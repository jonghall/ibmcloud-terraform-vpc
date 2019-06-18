#!/usr/bin/env python

# Terraform-Ansible dynamic inventory for IBM Cloud VPC Infrastructure
# Copyright (c) 2019
#
ti_version = '1.0'
# Based on dynamic inventory for IBM Cloud from steve_strutt@uk.ibm.com
# 05-16-2019 - 1.0 - Extended for use with the IBM VPC version 0.17.1 TF
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Can be used alongside static inventory files in the same directory 
#
#
# terraform_inv.ini file in the same directory as this script, points to the 
# location of the terraform.tfstate file to be inventoried.  Tags and will be
# created based on security group membership and zone.
#
# [TFSTATE]
# TFSTATE_FILE = /usr/share/terraform/ibm/Demoapp2x/terraform.tfstate
#
#
# [API]
# apikey = apikey-goes-here
# rias_endpoint = https://us-south.iaas.cloud.ibm.com
# resource_controller_endpoint = https://resource-controller.cloud.ibm.com
# version = ?version=2019-01-01&generation=1
#
# 
# Validate correct execution: 
#   With supplied test files - './terraform_inv.py -t ../tr_test_files/terraform.tfstate'
#   With ini file './terraform.py'
# Successful execution returns groups with lists of hosts and _meta/hostvars with a detailed
# host listing.
#
# Validate successful operation with ansible:
#   With - 'ansible-inventory -i inventory --list'
#
# Resources imported into Ansible
# ibm_is_instance
# Groups created for each availability zone, and security group.
# Security group groups extract the middle section between "-" of the security group name
# in the format: vpcname-tier-securitygroup

import json, configparser, os, requests, urllib.parse
from collections import defaultdict
from argparse import ArgumentParser


def parse_params():
    parser = ArgumentParser('IBM Cloud Terraform inventory')
    parser.add_argument('--list', action='store_true', default=True, help='List Terraform hosts')
    parser.add_argument('--tfstate', '-t', action='store', dest='tfstate', help='Terraform state file in current or specified directory (terraform.tfstate default)')
    parser.add_argument('--version', '-v', action='store_true', help='Show version')
    args = parser.parse_args()
    # read location of terrafrom state file from ini if it exists 
    if not args.tfstate:
        dirpath = os.getcwd()
        print ()
        config = configparser.ConfigParser()
        ini_file = 'terraform_inv.ini'
        try:
            # attempt to open ini file first. Only proceed if found
            # assume execution from the ansible playbook directory
            filepath = dirpath + "/inventory/" + ini_file
            open(filepath) 
            
        except FileNotFoundError:
            try:
                # If file is not found it may be because command is executed
                # in inventory directory
                filepath = dirpath + "/" + ini_file
                open(filepath) 
            
            except FileNotFoundError:
                raise Exception("Unable to find or open specified ini file")
            else:
                config.read(filepath)
        else: 
            config.read(filepath)

        config.read(filepath)
        tf_file = config['TFSTATE']['TFSTATE_FILE']
        tf_file = os.path.expanduser(tf_file)
        args.tfstate = tf_file

    return args


def get_tfstate(filename):
    return json.load(open(filename))

def parse_state(tf_source, prefix, sep='.'):
    for key, value in list(tf_source.items()):
        try:
            curprefix, rest = key.split(sep, 1)
        except ValueError:
            continue
        if curprefix != prefix or rest == '#':
            continue

        yield rest, value


def parse_attributes(tf_source, prefix, sep='.'):
    attributes = defaultdict(dict)
    for key, value in parse_state(tf_source, prefix, sep):
        index, key = key.split(sep, 1)
        attributes[index][key] = value

    return list(attributes.values())


def parse_dict(tf_source, prefix, sep='.'):
    return dict(parse_state(tf_source, prefix, sep))

def parse_list(tf_source, prefix, sep='.'):
    return [value for _, value in parse_state(tf_source, prefix, sep)]

class TerraformInventory:
    def __init__(self):
        self.args = parse_params()
        if self.args.version:
            print(ti_version)
        elif self.args.list:
            print(self.list_all())

    def list_all(self):
        tf_hosts = []
        vars = {}
        hosts_vars = {}
        attributes = {}
        groups = {}
        groups_json = {}
        inv_output = {}
        group_hosts = defaultdict(list)

        for name, attributes, groups in self.get_tf_instances():
            tf_hosts.append(name)
            hosts_vars[name] = attributes
            for group in list(groups):
                group_hosts[group].append(name)

        inv_output["All"] = {
            "hosts": tf_hosts,
            "vars": self.get_tf_output()
        }

        inv_output["_meta"] = {'hostvars': hosts_vars}

        for group in group_hosts:
            inv_output[group] = {'hosts': group_hosts[group]}

        return json.dumps(inv_output, indent=2)

    def get_tf_output(self):
        ################################################
        ## Get Terraform Output variables
        ################################################

        tfstate = get_tfstate(self.args.tfstate)
        vars = {}
        for module in tfstate['modules']:
            for key, value in module['outputs'].items():
                vars.update({key: value["value"]})
        return vars

    def get_tf_security_group_name(self, id):
        ################################################
        ## Get security groups
        ################################################

        tfstate = get_tfstate(self.args.tfstate)
        security_groups = {}
        for module in tfstate['modules']:
            for resource in module['resources'].values():
                if resource['type'] == 'ibm_is_security_group' :
                    tf_attrib = resource['primary']['attributes']
                    if tf_attrib["id"] == id:
                        return tf_attrib["name"]

    def get_tf_vpc(self, id):
        ################################################
        ## Get VPC name from ID
        ################################################

        tfstate = get_tfstate(self.args.tfstate)
        for module in tfstate['modules']:
            for resource in module['resources'].values():
                if resource['type'] == 'ibm_is_vpc':
                    tf_attrib = resource['primary']['attributes']
                    if tf_attrib["id"] == id:
                        return tf_attrib["name"]

    def get_tf_subnet_name(self, id):
        ################################################
        ## Get Subnet Name
        ################################################

        tfstate = get_tfstate(self.args.tfstate)
        for module in tfstate['modules']:
            for resource in module['resources'].values():
                if resource['type'] == 'ibm_is_subnet':
                    tf_attrib = resource['primary']['attributes']
                    if tf_attrib["id"] == id:
                        return tf_attrib["name"]


    def get_tf_instances(self):

        tfstate = get_tfstate(self.args.tfstate)

        for module in tfstate['modules']:
            for resource in module['resources'].values():
                if resource['type'] == 'ibm_is_instance':

                    tf_attrib = resource['primary']['attributes']
                    id = tf_attrib['id']

                    name = tf_attrib['name']

                    # Get Security Group ID, and derive name
                    security_group_id = 0
                    for key, value in tf_attrib.items():
                        if "primary_network_interface.0.security_groups." in key:
                            security_group_id = value

                    security_group = self.get_tf_security_group_name(security_group_id)

                    # Remove VPC prefix + "securitygroup" from name and change - to _ characters
                    tags = "group:" +security_group.split("-")[1].translate({ord(c): "_" for c in '-'})

                    attributes = {
                        'id': id,
                        'subnet': self.get_tf_subnet_name(tf_attrib["primary_network_interface.0.subnet"]),
                        'securitygroup': security_group,
                        'vpc': self.get_tf_vpc(tf_attrib["vpc"]),
                        'zone': tf_attrib['zone'],
                        'ram': tf_attrib['memory'],
                        'cpu': tf_attrib['cpu.0.cores'],
                        'profile': tf_attrib['profile'],
                        'ansible_host': tf_attrib['primary_network_interface.0.primary_ipv4_address'],
                        'ansible_ssh_user': 'root',
                        'provider': 'ibm',
                        'tags': tags
                    }

                    # create groups based on tags (security group)
                    value = attributes["tags"]
                    group = []
                    try:
                       curprefix, rest = value.split(":", 1)
                    except ValueError:
                       continue
                    if curprefix != "group" :
                       continue
                    group.append(rest)

                    # create group based on zone, remove any invalid group characters
                    group.append(tf_attrib['zone'].translate({ord(c): None for c in '-'}))


                    yield name, attributes, group



if __name__ == '__main__':


    TerraformInventory()

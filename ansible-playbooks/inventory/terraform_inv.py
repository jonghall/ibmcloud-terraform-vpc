#!/usr/bin/env python

# Terraform-Ansible dynamic inventory for IBM Cloud VPC Infrastructure
# Copyright (c) 2019
#
ti_version = '1.0'
# Based on dynamic inventory for IBM Cloud from steve_strutt@uk.ibm.com
# 05-16-2019 - 1.0 - Extended for use with the IBM VPC version 0.17 TF provider & expanded use of RIAS API
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
# This inventory script builds groups based on security group association
# of primary interface.


# terraform_inv.ini file in the same directory as this script, points to the 
# location of the terraform.tfstate file to be inventoried.  Additionally in the [API]
# section endpoint and apikey information should be supplied and are required
# to build security group based groups which are not stored in TF state file.
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


def parse_apiconfig():

    dirpath = os.getcwd()
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

    api = {}
    api["apikey"] = config["API"]["apikey"]
    api["iamtoken"] = getiamtoken(config["API"]["apikey"])
    api["rias_endpoint"] = config["API"]["rias_endpoint"]
    api["version"] = config["API"]["version"]

    return api

def getiamtoken(apikey):
    ################################################
    ## Lookup interface by ID
    ################################################

    headers = {"Content-Type": "application/x-www-form-urlencoded",
               "Accept": "application/json"}

    parms = {"grant_type": "urn:ibm:params:oauth:grant-type:apikey", "apikey": apikey}

    try:
        resp = requests.post("https://iam.cloud.ibm.com/identity/token?"+urllib.parse.urlencode(parms), headers=headers, timeout=30)
        resp.raise_for_status()
    except requests.exceptions.ConnectionError as errc:
        print("Error Connecting:", errc)
        quit()
    except requests.exceptions.Timeout as errt:
        print("Timeout Error:", errt)
        quit()
    except requests.exceptions.HTTPError as errb:
            print("Invalid token request.")
            print("template=%s" % parms)
            print("Error Data:  %s" % errb)
            print("Other Data:  %s" % resp.text)
            quit()


    iam = resp.json()

    iamtoken = {"Authorization": "Bearer " + iam["access_token"]}

    return iamtoken


def getinstance(api, instance_id):
    ################################################
    ## Lookup instance by ID
    ################################################

    try:
        resp = requests.get(api["rias_endpoint"] + '/v1/instances/' +instance_id + api["version"],
                            headers=api["iamtoken"], timeout=30)
        resp.raise_for_status()
    except requests.exceptions.ConnectionError as errc:
        print("Error Connecting:", errc)
        quit()
    except requests.exceptions.Timeout as errt:
        print("Timeout Error:", errt)
        quit()
    except requests.exceptions.HTTPError as errb:
        print("Unknown Error:", errb)
        quit()

    if resp.status_code == 200:
        instance = json.loads(resp.content)

    return instance


def getinterface(api, id, interface_id):
    ################################################
    ## Lookup interface by ID
    ################################################


    try:
        resp = requests.get(api["rias_endpoint"] + '/v1/instances/' + id + "/network_interfaces/" + interface_id + api["version"],
                            headers=api["iamtoken"], timeout=30)
        resp.raise_for_status()
    except requests.exceptions.ConnectionError as errc:
        print("Error Connecting:", errc)
        quit()
    except requests.exceptions.Timeout as errt:
        print("Timeout Error:", errt)
        quit()
    except requests.exceptions.HTTPError as errb:
        print("Unknown Error:", errb)
        quit()

    if resp.status_code == 200:
        interface = json.loads(resp.content)

    return interface

class TerraformInventory:
    def __init__(self):
        self.api = parse_apiconfig()
        self.args = parse_params()
        if self.args.version:
            print(ti_version)
        elif self.args.list:
            print(self.list_all())

    def list_all(self):
        #tf_hosts = []
        hosts_vars = {}
        attributes = {}
        groups = {}
        groups_json = {}
        inv_output = {}
        group_hosts = defaultdict(list)
        for name, attributes, groups in self.get_tf_instances():
            #tf_hosts.append(name)
            hosts_vars[name] = attributes
            for group in list(groups):
                #print(group)
                group_hosts[group].append(name)
                #print(group_hosts.items())

        for group in group_hosts:
            inv_output[group] = {'hosts': group_hosts[group]}
        inv_output["_meta"] = {'hostvars': hosts_vars} 
        return json.dumps(inv_output, indent=2)


    def get_tf_instances(self):

        tfstate = get_tfstate(self.args.tfstate)
        for module in tfstate['modules']:
            for resource in module['resources'].values():
                if resource['type'] == 'ibm_is_instance':

                    tf_attrib = resource['primary']['attributes']
                    id = tf_attrib['id']

                    instance = getinstance(self.api, id)

                    interface_id = instance["primary_network_interface"]["id"]

                    interface = getinterface(self.api, id, interface_id)

                    #print (json.dumps(instance,indent=4))
                    #print (json.dumps(interface, indent=4))

                    name = tf_attrib['name']
                    sgname = interface["security_groups"][0]["name"].split("-")[1]
                    tags = "group:" + sgname

                    attributes = {
                        'id': id,
                        'interface_id': interface_id,
                        'image': instance["image"]["name"],
                        'subnet': instance["primary_network_interface"]["subnet"]["name"],
                        'securitygroup': interface["security_groups"][0]["name"],
                        'vpc': instance["vpc"]["name"],
                        #'profile': instance["profile"]["name"],
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

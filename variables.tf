#---------------------------------------------------------
# MODIFY VARIABLES AS NEEDED
#---------------------------------------------------------
#---------------------------------------------------------

#---------------------------------------------------------
## DEFINE VPC
#---------------------------------------------------------
variable "vpc-name" {
    default = "terraform-test"
}

#---------------------------------------------------------
## DEFINE Zones
#---------------------------------------------------------
variable "zone1" {
    default = "us-south-1"
}

variable "zone2" {
    default = "us-south-2"
}


#---------------------------------------------------------
## DEFINE CIDR Blocks to be used in each zone
#---------------------------------------------------------
variable "address-prefix-1" {
    default = "172.21.0.0/18"
}

variable "address-prefix-2" {
    default = "172.21.64.0/18"
}

#---------------------------------------------------------
## DEFINE subnets for zone 1
#---------------------------------------------------------

variable "webtier-subnet-zone-1" {
    default = "172.21.0.0/24"
}

variable "apptier-subnet-zone-1" {
    default = "172.21.1.0/24"
}

variable "dbtier-subnet-zone-1" {
    default = "172.21.2.0/24"
}

#---------------------------------------------------------
## DEFINE subnets for zone 2
#---------------------------------------------------------
variable "webtier-subnet-zone-2" {
    default = "172.21.64.0/24"
}

variable "apptier-subnet-zone-2" {
    default = "172.21.65.0/24"
}

variable "dbtier-subnet-zone-2" {
    default = "172.21.66.0/24"
}


#---------------------------------------------------------
## DEFINE sshkey to be used for compute instances
#---------------------------------------------------------
variable "ssh_public_key" {
    default = "example_rsa.pub"
}

#---------------------------------------------------------
## DEFINE OS image to be used for compute instances
#---------------------------------------------------------
# CENTOS Image
variable "image" {
    default = "7eb4e35b-4257-56f8-d7da-326d85452591"
}

#---------------------------------------------------------
## DEFINE webtier compute instance profile & quantity
#---------------------------------------------------------
variable "profile-webserver" {
    default = "cc1-2x4"
}

variable "webserver-cloud-init" {
    default = "webserver-cloud-init.txt"
}

variable "webserver-name" {
    default = "webserver%02d"
}

variable "webserver-count" {
    default = 2
}



#---------------------------------------------------------
## DEFINE apptier compute instance profile & quantity
#---------------------------------------------------------
variable "profile-appserver" {
    default = "cc1-2x4"
}

variable "appserver-cloud-init" {
    default = "appserver-cloud-init.txt"
}

variable "appserver-name" {
    default = "appserver%02d"
}

variable "appserver-count" {
    default = 1
}

#---------------------------------------------------------
## DEFINE database tier compute instance profile & quantity
#---------------------------------------------------------
variable "profile-dbserver" {
    default = "cc1-2x4"
}

variable "dbserver-cloud-init" {
    default = "dbserver-cloud-init.txt"
}

variable "dbserver-name" {
    default = "dbserver%02d"
}

variable "dbserver-count" {
    default = 1
}

#---------------------------------------------------------
## DEFINE Load Balancer for webtier
#---------------------------------------------------------

variable "webtier-lb-connections" {
    default = 2000
}

variable "webtier-lb-algorithm" {
    default = "round_robin"
}

variable "webtier-lb-persistence" {
    default = "source_ip"
}

#---------------------------------------------------------
## DEFINE VPNaaS instance for connectivity to premise
#---------------------------------------------------------
variable "onprem_vpn_ip_address" {
    default = "0.0.0.0"
}

variable "onprem_cidr" {
    default = "172.16.0.0/24"
}

variable "vpn-preshared-key" {
    default = "vpnpassword"
}
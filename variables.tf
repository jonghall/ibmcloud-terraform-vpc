#---------------------------------------------------------
# MODIFY VARIABLES AS NEEDED
#---------------------------------------------------------
#---------------------------------------------------------

#---------------------------------------------------------
## DEFINE VPC
#---------------------------------------------------------
variable "vpc-name" {
  default = "terraform"
}

variable "resource_group" {
  default = "vpc_sandbox"
}

variable "cis_resource_group" {
  default = "default"
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
  default = "172.21.0.0/21"
}

variable "address-prefix-2" {
  default = "172.21.8.0/21"
}

#---------------------------------------------------------
## DEFINE subnets for zone 1
#---------------------------------------------------------

variable "webapptier-subnet-zone-1" {
  default = "172.21.0.0/24"
}

variable "dbtier-subnet-zone-1" {
  default = "172.21.1.0/24"
}

variable "vpn-subnet-zone-1" {
  default = "172.21.2.0/24"
}

#---------------------------------------------------------
## DEFINE subnets for zone 2
#---------------------------------------------------------
variable "webapptier-subnet-zone-2" {
  default = "172.21.8.0/24"
}

variable "dbtier-subnet-zone-2" {
  default = "172.21.9.0/24"
}

variable "vpn-subnet-zone-2" {
  default = "172.21.10.0/24"
}

#---------------------------------------------------------
## DEFINE DNS
#---------------------------------------------------------
variable "domain" {
  default = "hallusa.com"
}

variable "cis_instance_name" {
  default = "hallusa.com"
}

variable "dns_name" {
  default = "webappdemo."
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

#image = Ubuntu-16.04-amd64
variable "image" {
  default = "7eb4e35b-4257-56f8-d7da-326d85452591 "
}

#---------------------------------------------------------
## DEFINE webapptier compute instance profile & quantity
#---------------------------------------------------------
variable "profile-webappserver" {
  default = "cc1-2x4"
}

variable "webappserver-name" {
  default = "webapp%02d"
}

variable "webappserver-count" {
  default = 2
}

#---------------------------------------------------------
## DEFINE database tier compute instance profile & quantity
#---------------------------------------------------------
variable "profile-dbserver" {
  default = "cc1-2x4"
}

variable "dbserver-name" {
  default = "mysql%02d"
}

variable "dbserver-count" {
  default = 1
}

#---------------------------------------------------------
## DEFINE Load Balancer for webapptier
#---------------------------------------------------------

variable "webapptier-lb-connections" {
  default = 2000
}

variable "webapptier-lb-algorithm" {
  default = "round_robin"
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

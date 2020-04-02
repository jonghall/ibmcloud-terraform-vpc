#---------------------------------------------------------
# Get resource_group id
#---------------------------------------------------------

data "ibm_resource_group" "group" {
  name = "${var.resource_group}"
}

#---------------------------------------------------------
# Create new VPC
#---------------------------------------------------------

resource "ibm_is_vpc" "vpc1" {
  name                = "${var.vpc-name}"
  resource_group      = "${data.ibm_resource_group.group.id}"
  address_prefix_management = "manual"
}

#---------------------------------------------------------
# Create new address prefixes in VPC
#---------------------------------------------------------
resource "ibm_is_vpc_address_prefix" "prefix1" {
  name = "zone1-cidr-1"
  vpc  = "${ibm_is_vpc.vpc1.id}"
  zone = "${var.zone1}"
  cidr = "${var.address-prefix-1}"
}

resource "ibm_is_vpc_address_prefix" "prefix2" {
  name = "zone2-cidr-1"
  vpc  = "${ibm_is_vpc.vpc1.id}"
  zone = "${var.zone2}"
  cidr = "${var.address-prefix-2}"
}

#---------------------------------------------------------
# Get Public Gateway's for Zone 1 & Zone 2
#---------------------------------------------------------
resource "ibm_is_public_gateway" "pubgw-zone1" {
  name = "${var.vpc-name}-${var.zone1}-pubgw"
  vpc  = "${ibm_is_vpc.vpc1.id}"
  zone = "${var.zone1}"
}

resource "ibm_is_public_gateway" "pubgw-zone2" {
  name = "${var.vpc-name}-${var.zone2}-pubgw"
  vpc  = "${ibm_is_vpc.vpc1.id}"
  zone = "${var.zone2}"
}

#---------------------------------------------------------
## Create Webapp & Db Subnets in Zone1
#---------------------------------------------------------
resource "ibm_is_subnet" "webapptier-subnet-zone1" {
  name            = "${var.vpc-name}-${var.zone1}-webapptier"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${var.zone1}"
  ipv4_cidr_block = "${var.webapptier-subnet-zone-1}"
  network_acl     = "${ibm_is_network_acl.webapptier_acl.id}"
  public_gateway  = "${ibm_is_public_gateway.pubgw-zone1.id}"

  provisioner "local-exec" {
    command = "sleep 300"
    when    = "destroy"
  }
}

resource "ibm_is_subnet" "dbtier-subnet-zone1" {
  name            = "${var.vpc-name}-${var.zone1}-dbtier"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${var.zone1}"
  ipv4_cidr_block = "${var.dbtier-subnet-zone-1}"
  network_acl     = "${ibm_is_network_acl.dbtier_acl.id}"
  public_gateway  = "${ibm_is_public_gateway.pubgw-zone1.id}"

  provisioner "local-exec" {
    command = "sleep 300"
    when    = "destroy"
  }
}

#---------------------------------------------------------
## Create Webapp & Db Subnets in Zone2
#---------------------------------------------------------
resource "ibm_is_subnet" "webapptier-subnet-zone2" {
  name            = "${var.vpc-name}-${var.zone2}-webapptier"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${var.zone2}"
  ipv4_cidr_block = "${var.webapptier-subnet-zone-2}"
  network_acl     = "${ibm_is_network_acl.webapptier_acl.id}"
  public_gateway  = "${ibm_is_public_gateway.pubgw-zone2.id}"

  provisioner "local-exec" {
    command = "sleep 300"
    when    = "destroy"
  }
}

resource "ibm_is_subnet" "dbtier-subnet-zone2" {
  name            = "${var.vpc-name}-${var.zone2}-dbtier"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${var.zone2}"
  ipv4_cidr_block = "${var.dbtier-subnet-zone-2}"
  network_acl     = "${ibm_is_network_acl.dbtier_acl.id}"
  public_gateway  = "${ibm_is_public_gateway.pubgw-zone2.id}"

  provisioner "local-exec" {
    command = "sleep 300"
    when    = "destroy"
  }
}

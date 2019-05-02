data "ibm_resource_group" "group" {
  name = "${var.resource_group}"
}

resource "ibm_is_vpc" "vpc1" {
  name                = "${var.vpc-name}"
  resource_group      = "${data.ibm_resource_group.group.id}"
  default_network_acl = "${ibm_is_network_acl.default_acl.id}"
}

# Create new address prefixes in VPC
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

## Create Web, App, Db Subnets in Zone1
resource "ibm_is_subnet" "webtier-subnet-zone1" {
  name            = "${var.vpc-name}-${var.zone1}-webtier"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${var.zone1}"
  ipv4_cidr_block = "${var.webtier-subnet-zone-1}"
  network_acl     = "${ibm_is_network_acl.webtier_acl.id}"
  public_gateway  = "${ibm_is_public_gateway.pubgw-zone1.id}"

  provisioner "local-exec" {
    command = "sleep 300"
    when    = "destroy"
  }
}

resource "ibm_is_subnet" "apptier-subnet-zone1" {
  name            = "${var.vpc-name}-${var.zone1}-apptier"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${var.zone1}"
  ipv4_cidr_block = "${var.apptier-subnet-zone-1}"
  network_acl     = "${ibm_is_network_acl.apptier_acl.id}"
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

## Create Web, App, Db Subnets in Zone2
resource "ibm_is_subnet" "webtier-subnet-zone2" {
  name            = "${var.vpc-name}-${var.zone2}-webtier"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${var.zone2}"
  ipv4_cidr_block = "${var.webtier-subnet-zone-2}"
  network_acl     = "${ibm_is_network_acl.webtier_acl.id}"
  public_gateway  = "${ibm_is_public_gateway.pubgw-zone2.id}"

  provisioner "local-exec" {
    command = "sleep 300"
    when    = "destroy"
  }
}

resource "ibm_is_subnet" "apptier-subnet-zone2" {
  name            = "${var.vpc-name}-${var.zone2}-apptier"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${var.zone2}"
  ipv4_cidr_block = "${var.apptier-subnet-zone-2}"

  network_acl    = "${ibm_is_network_acl.apptier_acl.id}"
  public_gateway = "${ibm_is_public_gateway.pubgw-zone2.id}"

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

#---------------------------------------------------------
# Create Subnets for VPNaaS instances
#---------------------------------------------------------
resource "ibm_is_subnet" "vpn-subnet-zone-1" {
  name            = "${var.vpc-name}-${var.zone1}-vpn"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${var.zone1}"
  ipv4_cidr_block = "${var.vpn-subnet-zone-1}"
  network_acl     = "${ibm_is_network_acl.vpn_acl.id}"

  provisioner "local-exec" {
    command = "sleep 300"
    when    = "destroy"
  }
}

resource "ibm_is_subnet" "vpn-subnet-zone-2" {
  name            = "${var.vpc-name}-${var.zone2}-vpn"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${var.zone2}"
  ipv4_cidr_block = "${var.vpn-subnet-zone-2}"
  network_acl     = "${ibm_is_network_acl.vpn_acl.id}"

  provisioner "local-exec" {
    command = "sleep 300"
    when    = "destroy"
  }
}

#---------------------------------------------------------
# create VPNGateway for Zone 1
#---------------------------------------------------------
resource "ibm_is_vpn_gateway" "VPNGateway1" {
  name           = "${var.vpc-name}-${var.zone1}-vpn"
  resource_group = "${data.ibm_resource_group.group.id}"
  subnet         = "${ibm_is_subnet.vpn-subnet-zone-1.id}"
}

resource "ibm_is_vpn_gateway_connection" "VPNGatewayConnection1-zone1" {
  name          = "${var.vpc-name}-${var.zone1}-connection"
  vpn_gateway   = "${ibm_is_vpn_gateway.VPNGateway1.id}"
  peer_address  = "${var.onprem_vpn_ip_address}"
  preshared_key = "${var.vpn-preshared-key}"
  local_cidrs   = ["${var.address-prefix-1}"]
  peer_cidrs    = ["${var.onprem_cidr}"]
}

#---------------------------------------------------------
# Create BPNGateway for Zone2
#---------------------------------------------------------
resource "ibm_is_vpn_gateway" "VPNGateway2" {
  name           = "${var.vpc-name}-${var.zone2}-vpn"
  resource_group = "${data.ibm_resource_group.group.id}"
  subnet         = "${ibm_is_subnet.vpn-subnet-zone-2.id}"
}

resource "ibm_is_vpn_gateway_connection" "VPNGatewayConnection1-zone2" {
  name          = "${var.vpc-name}-${var.zone1}-connection"
  vpn_gateway   = "${ibm_is_vpn_gateway.VPNGateway2.id}"
  peer_address  = "${var.onprem_vpn_ip_address}"
  preshared_key = "${var.vpn-preshared-key}"
  local_cidrs   = ["${var.address-prefix-2}"]
  peer_cidrs    = ["${var.onprem_cidr}"]
}

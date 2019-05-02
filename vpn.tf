resource "ibm_is_vpn_gateway" "VPNGateway1" {
  name   = "${var.vpc-name}-${var.zone1}-vpn"
  subnet = "${ibm_is_subnet.webtier-subnet-zone1.id}"
}

resource "ibm_is_vpn_gateway_connection" "VPNGatewayConnection1-zone1" {
  name          = "${var.vpc-name}-${var.zone1}-connection"
  vpn_gateway   = "${ibm_is_vpn_gateway.VPNGateway1.id}"
  peer_address  = "${var.onprem_vpn_ip_address}"
  preshared_key = "${var.vpn-preshared-key}"
  local_cidrs   = ["${var.address-prefix-1}"]
  peer_cidrs    = ["${var.onprem_cidr}"]
}

resource "ibm_is_vpn_gateway" "VPNGateway2" {
  name   = "${var.vpc-name}-${var.zone2}-vpn"
  subnet = "${ibm_is_subnet.webtier-subnet-zone2.id}"
}

resource "ibm_is_vpn_gateway_connection" "VPNGatewayConnection1-zone2" {
  name          = "${var.vpc-name}-${var.zone1}-connection"
  vpn_gateway   = "${ibm_is_vpn_gateway.VPNGateway2.id}"
  peer_address  = "${var.onprem_vpn_ip_address}"
  preshared_key = "${var.vpn-preshared-key}"
  local_cidrs   = ["${var.address-prefix-2}"]
  peer_cidrs    = ["${var.onprem_cidr}"]
}
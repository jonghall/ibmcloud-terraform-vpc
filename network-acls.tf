resource "ibm_is_network_acl" "webapptier_acl" {
  name = "${var.vpc-name}-webapptier-acl"
  vpc = "${ibm_is_vpc.vpc1.id}"
  rules {
      name      = "${var.vpc-name}-webapptier-icmp-all"
      direction = "inbound"
      action    = "allow"
      source    = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      icmp = {
        type = "0"
        code = "0"
      }
    }
    rules {
      name        = "${var.vpc-name}-webapptier-udp-user-ports"
      direction   = "inbound"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      udp = {
        port_min = "1024"
        port_max = "65535"
      }
    }
    rules {
      name        = "${var.vpc-name}-webapptier-tcp-user-ports"
      direction   = "inbound"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      tcp = {
        port_min = "1024"
        port_max = "65535"
      }
    }
    rules {
      name        = "${var.vpc-name}-webapptier-from-vpn-network"
      direction   = "inbound"
      action      = "allow"
      source      = "${var.onprem_cidr}"
      destination = "${var.address-prefix-vpc}"
    }
    rules {
      name        = "${var.vpc-name}-webapptier-within-vpc"
      direction   = "inbound"
      action      = "allow"
      source      = "${var.address-prefix-vpc}"
      destination = "${var.address-prefix-vpc}"
    }
    rules {
      name        = "${var.vpc-name}-webapptier-web-http-traffic"
      direction   = "inbound"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "${var.address-prefix-vpc}"
      tcp = {
        port_min = "80"
        port_max = "80"
      }
    }
    rules {
      name        = "${var.vpc-name}-webapptier-allow-all-egress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "outbound"
    }
}

resource "ibm_is_network_acl" "dbtier_acl" {
  name = "${var.vpc-name}-dbtier-acl"
  vpc = "${ibm_is_vpc.vpc1.id}"
  rules {
      name      = "${var.vpc-name}-dbtier-icmp-all"
      direction = "inbound"
      action    = "allow"
      source    = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      icmp = {
        type = "0"
        code = "0"
      }
  }
  rules {
      name        = "${var.vpc-name}-dbtier-udp-user-ports"
      direction   = "inbound"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      udp = {
        port_min = "1024"
        port_max = "65535"
      }
  }
  rules {
      name        = "${var.vpc-name}-dbtier-tcp-user-ports"
      direction   = "inbound"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      tcp = {
        port_min = "1024"
        port_max = "65535"
      }
  }
  rules {
      name        = "${var.vpc-name}-dbtier-from-vpn-network"
      direction   = "inbound"
      action      = "allow"
      source      = "${var.onprem_cidr}"
      destination = "${var.address-prefix-vpc}"
  }
  rules {
      name        = "${var.vpc-name}-dbtier-within-vpc"
      direction   = "inbound"
      action      = "allow"
      source      = "${var.address-prefix-vpc}"
      destination = "${var.address-prefix-vpc}"
    }
    rules {
      name        = "${var.vpc-name}-dbtier-allow-all-egress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "outbound"
    }
}

resource "ibm_is_network_acl" "vpn_acl" {
  name = "${var.vpc-name}-vpn-acl"
  vpc = "${ibm_is_vpc.vpc1.id}"
  rules {
      name        = "${var.vpc-name}-vpn-all-ingress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "inbound"
  }
  rules {
      name        = "${var.vpc-name}-vpn-allow-all-egress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "outbound"
  }
}

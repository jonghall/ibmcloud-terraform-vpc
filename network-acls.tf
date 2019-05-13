resource "ibm_is_network_acl" "default_acl" {
  name = "${var.vpc-name}-default-acl"

  rules = [
    {
      name        = "${var.vpc-name}-default-deny-all-ingress"
      action      = "deny"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "ingress"
    },
    {
      name        = "${var.vpc-name}-default-deny-all-egress"
      action      = "deny"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "egress"
    },
  ]
}

resource "ibm_is_network_acl" "webapptier_acl" {
  name = "${var.vpc-name}-webapptier-acl"

  rules = [
    {
      name      = "${var.vpc-name}-webapptier-icmp-all"
      direction = "ingress"
      action    = "allow"
      source    = "0.0.0.0/0"

      icmp = {
        type = "0"
        code = "0"
      }

      destination = "0.0.0.0/0"
    },
    {
      name        = "${var.vpc-name}-webapptier-udp-user-ports"
      direction   = "ingress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"

      udp = {
        port_min = "1024"
        port_max = "65535"
      }
    },
    {
      name        = "${var.vpc-name}-webapptier-tcp-user-ports"
      direction   = "ingress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"

      tcp = {
        port_min = "1024"
        port_max = "65535"
      }
    },
    {
      name        = "${var.vpc-name}-webapptier-from-vpn-network"
      direction   = "ingress"
      action      = "allow"
      source      = "${var.onprem_cidr}"
      destination = "172.18.0.0/20"
    },
    {
      name        = "${var.vpc-name}-webapptier-within-vpc"
      direction   = "ingress"
      action      = "allow"
      source      = "172.18.0.0/20"
      destination = "172.18.0.0/20"
    },
    {
      name        = "${var.vpc-name}-webapptier-web-http-traffic"
      direction   = "ingress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "172.18.0.0/20"

      tcp = {
        port_min = "80"
        port_max = "80"
      }
    },
    {
      name        = "${var.vpc-name}-webapptier-allow-all-egress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "egress"
    },
  ]
}

resource "ibm_is_network_acl" "dbtier_acl" {
  name = "${var.vpc-name}-dbtier-acl"

  rules = [
    {
      name      = "${var.vpc-name}-dbtier-icmp-all"
      direction = "ingress"
      action    = "allow"
      source    = "0.0.0.0/0"

      icmp = {
        type = "0"
        code = "0"
      }

      destination = "0.0.0.0/0"
    },
    {
      name        = "${var.vpc-name}-dbtier-udp-user-ports"
      direction   = "ingress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"

      udp = {
        port_min = "1024"
        port_max = "65535"
      }
    },
    {
      name        = "${var.vpc-name}-dbtier-tcp-user-ports"
      direction   = "ingress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"

      tcp = {
        port_min = "1024"
        port_max = "65535"
      }
    },
    {
      name        = "${var.vpc-name}-dbtier-from-vpn-network"
      direction   = "ingress"
      action      = "allow"
      source      = "${var.onprem_cidr}"
      destination = "172.18.0.0/20"
    },
    {
      name        = "${var.vpc-name}-dbtier-within-vpc"
      direction   = "ingress"
      action      = "allow"
      source      = "172.18.0.0/20"
      destination = "172.18.0.0/20"
    },
    {
      name        = "${var.vpc-name}-dbtier-allow-all-egress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "egress"
    },
  ]
}

resource "ibm_is_network_acl" "vpn_acl" {
  name = "${var.vpc-name}-vpn-acl"

  rules = [
    {
      name        = "${var.vpc-name}-vpn-all-ingress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "ingress"
    },
    {
      name        = "${var.vpc-name}-vpn-allow-all-egress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "egress"
    },
  ]
}

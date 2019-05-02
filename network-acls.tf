
resource "ibm_is_network_acl" "default_acl" {
  name = "${var.vpc-name}-default-acl"
  rules = [
    {
      name = "deny-all-ingress"
      action = "deny"
      source = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction = "ingress"
    },
    {
      name = "deny-all-egress"
      action = "deny"
      source = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction = "egress"
    }]
}

resource "ibm_is_network_acl" "webtier_acl" {
  name = "${var.vpc-name}-webtier-acl"
  rules = [
    {
      name = "webtier-allow-all-ingress"
      action = "allow"
      source = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction = "ingress"
    },
    {
      name = "webtier-allow-all-egress"
      action = "allow"
      source = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction = "egress"
    }]
}

resource "ibm_is_network_acl" "apptier_acl" {
  name = "${var.vpc-name}-apptier-acl"
  rules = [
    {
      name = "apptier-allow-all-ingress"
      action = "allow"
      source = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction = "ingress"
    },
    {
      name = "apptier-allow-all-egress"
      action = "allow"
      source = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction = "egress"
    }]
}

resource "ibm_is_network_acl" "dbtier_acl" {
  name = "${var.vpc-name}-dbtier-acl"
  rules = [
    {
      name = "dbtier-allow-all-ingress"
      action = "allow"
      source = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction = "ingress"
    },
    {
      name = "dbtier-allow-all-egress"
      action = "allow"
      source = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction = "egress"
    }]
}


#---------------------------------------------------------
# Create Webapptier Security Group & Rules
#---------------------------------------------------------
resource "ibm_is_security_group" "webapptier-securitygroup" {
  name = "${var.vpc-name}-webapptier-securitygroup"
  vpc  = "${ibm_is_vpc.vpc1.id}"
}

resource "ibm_is_security_group_rule" "webapptier-securitygroup-rule1" {
  group      = "${ibm_is_security_group.webapptier-securitygroup.id}"
  direction  = "ingress"
  ip_version = "ipv4"
  remote     = "${var.webapptier-subnet-zone-1}"
}

resource "ibm_is_security_group_rule" "webapptier-securitygroup-rule2" {
  group      = "${ibm_is_security_group.webapptier-securitygroup.id}"
  direction  = "ingress"
  ip_version = "ipv4"
  remote     = "${var.webapptier-subnet-zone-2}"
}

resource "ibm_is_security_group_rule" "webapptier-securitygroup-rule3" {
  group      = "${ibm_is_security_group.webapptier-securitygroup.id}"
  direction  = "ingress"
  ip_version = "ipv4"
  remote     = "${var.onprem_cidr}"
}

resource "ibm_is_security_group_rule" "webapptier-securitygroup-rule4" {
  group      = "${ibm_is_security_group.webapptier-securitygroup.id}"
  direction  = "ingress"
  ip_version = "ipv4"
  remote     = "0.0.0.0/0"

  tcp = {
    port_min = 80
    port_max = 80
  }
}

resource "ibm_is_security_group_rule" "webapptier-securitygroup-rule5" {
  group     = "${ibm_is_security_group.webapptier-securitygroup.id}"
  direction = "ingress"
  remote    = "0.0.0.0/0"

  icmp = {
    code = 0
    type = 8
  }
}

#---------------------------------------------------------
# Add dbtier rules to security group
#---------------------------------------------------------

resource "ibm_is_security_group" "dbtier-securitygroup" {
  name = "${var.vpc-name}-dbtier-securitygroup"
  vpc  = "${ibm_is_vpc.vpc1.id}"
}

resource "ibm_is_security_group_rule" "dbtier-securitygroup-rule1" {
  group      = "${ibm_is_security_group.dbtier-securitygroup.id}"
  direction  = "ingress"
  ip_version = "ipv4"
  remote     = "${var.onprem_cidr}"
}

resource "ibm_is_security_group_rule" "dbtier-securitygroup-rule2" {
  group      = "${ibm_is_security_group.dbtier-securitygroup.id}"
  direction  = "ingress"
  ip_version = "ipv4"
  remote     = "${var.dbtier-subnet-zone-1}"
}

resource "ibm_is_security_group_rule" "dbtier-securitygroup-rule3" {
  group      = "${ibm_is_security_group.dbtier-securitygroup.id}"
  direction  = "ingress"
  ip_version = "ipv4"
  remote     = "${var.dbtier-subnet-zone-2}"
}

resource "ibm_is_security_group_rule" "dbtier-securitygroup-rule4" {
  group      = "${ibm_is_security_group.dbtier-securitygroup.id}"
  direction  = "ingress"
  ip_version = "ipv4"
  remote     = "${ibm_is_security_group.webapptier-securitygroup.id}"

  tcp = {
    port_min = "3306"
    port_max = "3306"
  }
}

resource "ibm_is_security_group_rule" "dbtier-securitygroup-rule5" {
  group     = "${ibm_is_security_group.dbtier-securitygroup.id}"
  direction = "ingress"
  remote    = "0.0.0.0/0"

  icmp = {
    code = 0
    type = 8
  }
}

resource "ibm_is_security_group_rule" "dbtier-securitygroup-rule6" {
  group      = "${ibm_is_security_group.dbtier-securitygroup.id}"
  direction  = "egress"
  ip_version = "ipv4"
  remote     = "0.0.0.0/0"
}

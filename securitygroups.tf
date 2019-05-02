
resource "ibm_is_security_group" "webtier-securitygroup" {
  name = "${var.vpc-name}-webtier-securitygroup"
  vpc = "${ibm_is_vpc.vpc1.id}"
}

resource "ibm_is_security_group" "apptier-securitygroup" {
  name = "${var.vpc-name}-apptier-securitygroup"
  vpc = "${ibm_is_vpc.vpc1.id}"
}

resource "ibm_is_security_group" "dbtier-securitygroup" {
  name = "${var.vpc-name}-dbtier-securitygroup"
  vpc = "${ibm_is_vpc.vpc1.id}"
}

# Add Webtier rules to security group
resource "ibm_is_security_group_rule" "webtier-securitygroup-rule1" {
  group     = "${ibm_is_security_group.webtier-securitygroup.id}"
  direction = "ingress"
  ip_version= "ipv4"
  remote    = "${var.webtier-subnet-zone-1}"
}


resource "ibm_is_security_group_rule" "webtier-securitygroup-rule2" {
  group     = "${ibm_is_security_group.webtier-securitygroup.id}"
  direction = "ingress"
  ip_version= "ipv4"
  remote    = "${var.webtier-subnet-zone-2}"
}

resource "ibm_is_security_group_rule" "webtier-securitygroup-rule3" {
  group     = "${ibm_is_security_group.webtier-securitygroup.id}"
  direction = "ingress"
  ip_version= "ipv4"
  remote    = "0.0.0.0/0"
  tcp = {
    port_min = 80
    port_max = 80
  }
}

resource "ibm_is_security_group_rule" "webtier-securitygroup-rule4" {
  group     = "${ibm_is_security_group.webtier-securitygroup.id}"
  direction = "ingress"
  remote    = "0.0.0.0/0"
  icmp = {
    code = 0
    type = 8
  }
}

resource "ibm_is_security_group_rule" "webtier-securitygroup-rule5" {
  group     = "${ibm_is_security_group.webtier-securitygroup.id}"
  direction = "egress"
  ip_version= "ipv4"
  remote    = "0.0.0.0/0"
}


# Add apptier rules to security group
resource "ibm_is_security_group_rule" "apptier-securitygroup-rule1" {
  group     = "${ibm_is_security_group.apptier-securitygroup.id}"
  direction = "ingress"
  ip_version= "ipv4"
  remote    = "${var.apptier-subnet-zone-1}"
}

resource "ibm_is_security_group_rule" "apptier-securitygroup-rule2" {
  group     = "${ibm_is_security_group.apptier-securitygroup.id}"
  direction = "ingress"
  ip_version= "ipv4"
  remote    = "${var.apptier-subnet-zone-2}"
}

resource "ibm_is_security_group_rule" "apptier-securitygroup-rule3" {
  group     = "${ibm_is_security_group.apptier-securitygroup.id}"
  direction = "ingress"
  remote    = "0.0.0.0/0"

  icmp = {
    code = 0
    type = 8
  }
}

resource "ibm_is_security_group_rule" "apptier-securitygroup-rule4" {
  group     = "${ibm_is_security_group.apptier-securitygroup.id}"
  direction = "egress"
  ip_version= "ipv4"
  remote    = "0.0.0.0/0"
}

# Add dbtier rules to security group
resource "ibm_is_security_group_rule" "dbtier-securitygroup-rule1" {
  group     = "${ibm_is_security_group.dbtier-securitygroup.id}"
  direction = "ingress"
  ip_version= "ipv4"
  remote    = "${var.dbtier-subnet-zone-1}"
}

resource "ibm_is_security_group_rule" "dbtier-securitygroup-rule2" {
  group     = "${ibm_is_security_group.dbtier-securitygroup.id}"
  direction = "ingress"
  ip_version= "ipv4"
  remote    = "${var.dbtier-subnet-zone-2}"
}

resource "ibm_is_security_group_rule" "dbtier-securitygroup-rule3" {
  group     = "${ibm_is_security_group.dbtier-securitygroup.id}"
  direction = "ingress"
  remote    = "0.0.0.0/0"

  icmp = {
    code = 0
    type = 8
  }
}

resource "ibm_is_security_group_rule" "dbtier-securitygroup-rule4" {
  group     = "${ibm_is_security_group.dbtier-securitygroup.id}"
  direction = "egress"
  ip_version= "ipv4"
  remote    = "0.0.0.0/0"
}
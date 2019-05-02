## Create sshkey from file
resource "ibm_is_ssh_key" "sshkey" {
  name       = "example"
  public_key = "${file(var.ssh_public_key)}"
}

## Create instances in each subnet in zone1
resource "ibm_is_instance" "webserver-zone1" {
  count   = "${var.webserver-count}"
  name    = "${format(var.webserver-name, count.index + 1)}-${var.zone1}"
  image   = "${var.image}"
  profile = "${var.profile-webserver}"

  primary_network_interface = {
    port_speed      = "1000"
    subnet          = "${ibm_is_subnet.webtier-subnet-zone1.id}"
    security_groups = ["${ibm_is_security_group.webtier-securitygroup.id}"]
  }

  vpc       = "${ibm_is_vpc.vpc1.id}"
  zone      = "${var.zone1}"
  keys      = ["${ibm_is_ssh_key.sshkey.id}"]
  user_data = "${data.template_cloudinit_config.cloud-init-webtier.rendered}"
}

resource "ibm_is_instance" "appserver-zone1" {
  count   = "${var.appserver-count}"
  name    = "${format(var.appserver-name, count.index + 1)}-${var.zone1}"
  image   = "${var.image}"
  profile = "${var.profile-appserver}"

  primary_network_interface = {
    port_speed      = "1000"
    subnet          = "${ibm_is_subnet.apptier-subnet-zone1.id}"
    security_groups = ["${ibm_is_security_group.apptier-securitygroup.id}"]
  }

  vpc       = "${ibm_is_vpc.vpc1.id}"
  zone      = "${var.zone1}"
  keys      = ["${ibm_is_ssh_key.sshkey.id}"]
  user_data = "${data.template_cloudinit_config.cloud-init-apptier.rendered}"
}

resource "ibm_is_instance" "dbserver-zone1" {
  count   = "${var.dbserver-count}"
  name    = "${format(var.dbserver-name, count.index + 1)}-${var.zone1}"
  image   = "${var.image}"
  profile = "${var.profile-dbserver}"

  primary_network_interface = {
    port_speed      = "1000"
    subnet          = "${ibm_is_subnet.dbtier-subnet-zone1.id}"
    security_groups = ["${ibm_is_security_group.dbtier-securitygroup.id}"]
  }

  vpc       = "${ibm_is_vpc.vpc1.id}"
  zone      = "${var.zone1}"
  keys      = ["${ibm_is_ssh_key.sshkey.id}"]
  user_data = "${data.template_cloudinit_config.cloud-init-dbtier.rendered}"
}

## Create instances in each subnet in zone2
resource "ibm_is_instance" "webserver-zone2" {
  count   = "${var.webserver-count}"
  name    = "${format(var.webserver-name, count.index + 1)}-${var.zone2}"
  image   = "${var.image}"
  profile = "${var.profile-webserver}"

  primary_network_interface = {
    port_speed      = "1000"
    subnet          = "${ibm_is_subnet.webtier-subnet-zone2.id}"
    security_groups = ["${ibm_is_security_group.webtier-securitygroup.id}"]
  }

  vpc       = "${ibm_is_vpc.vpc1.id}"
  zone      = "${var.zone2}"
  keys      = ["${ibm_is_ssh_key.sshkey.id}"]
  user_data = "${data.template_cloudinit_config.cloud-init-webtier.rendered}"
}

resource "ibm_is_instance" "appserver-zone2" {
  count   = "${var.appserver-count}"
  name    = "${format(var.appserver-name, count.index + 1)}-${var.zone2}"
  image   = "${var.image}"
  profile = "${var.profile-appserver}"

  primary_network_interface = {
    port_speed      = "1000"
    subnet          = "${ibm_is_subnet.apptier-subnet-zone2.id}"
    security_groups = ["${ibm_is_security_group.apptier-securitygroup.id}"]
  }

  vpc       = "${ibm_is_vpc.vpc1.id}"
  zone      = "${var.zone2}"
  keys      = ["${ibm_is_ssh_key.sshkey.id}"]
  user_data = "${data.template_cloudinit_config.cloud-init-apptier.rendered}"
}

resource "ibm_is_instance" "dbserver-zone2" {
  count   = "${var.dbserver-count}"
  name    = "${format(var.dbserver-name, count.index + 1)}-${var.zone2}"
  image   = "${var.image}"
  profile = "${var.profile-dbserver}"

  primary_network_interface = {
    port_speed      = "1000"
    subnet          = "${ibm_is_subnet.dbtier-subnet-zone2.id}"
    security_groups = ["${ibm_is_security_group.dbtier-securitygroup.id}"]
  }

  vpc       = "${ibm_is_vpc.vpc1.id}"
  zone      = "${var.zone2}"
  keys      = ["${ibm_is_ssh_key.sshkey.id}"]
  user_data = "${data.template_cloudinit_config.cloud-init-dbtier.rendered}"
}

# Assign floating IP's to all instances of Web Servers
#resource "ibm_is_floating_ip" "webserver-zone1-fip" {
#  count     = "${ibm_is_instance.webserver-zone1.count}"
#  name    = "${format(var.webserver-name, count.index + 1)}-${var.zone1}-fip"
#  target  = "${element(ibm_is_instance.webserver-zone1.*.primary_network_interface.0.id, count.index)}"
#}


#resource "ibm_is_floating_ip" "webserver-zone2-fip" {
#  count     = "${ibm_is_instance.webserver-zone2.count}"
#  name    = "${format(var.webserver-name, count.index + 1)}-${var.zone2}-fip"
#  target  = "${element(ibm_is_instance.webserver-zone2.*.primary_network_interface.0.id, count.index)}"
#}


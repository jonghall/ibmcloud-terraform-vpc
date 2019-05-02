resource "ibm_is_lb" "webtier-lb" {
  name    = "${var.vpc-name}-webtier-lb"
  subnets = ["${ibm_is_subnet.webtier-subnet-zone1.id}", "${ibm_is_subnet.webtier-subnet-zone2.id}"]
}

#resource "ibm_is_lb_listener" "webtier-lb-listener" {
#  lb = "${ibm_is_lb.webtier-lb.id}"
#  port = "80"
#  protocol = "http"
#  default_pool = "${ibm_is_lb_pool.webtier-lb-pool.id}"
#}

resource "ibm_is_lb_pool" "webtier-lb-pool" {
  lb                 = "${ibm_is_lb.webtier-lb.id}"
  name               = "${var.vpc-name}-webtier-lb-pool"
  protocol           = "http"
  algorithm          = "${var.webtier-lb-algorithm}"
  health_delay       = "5"
  health_retries     = "2"
  health_timeout     = "2"
  health_type        = "http"
  health_monitor_url = "/"
}

## Add webservers from zone 1 and zone 2 to pool
#resource "ibm_is_lb_pool_member" "webtier-lb-pool-member-zone1" {
#  count = "${ibm_is_instance.webserver-zone1.count}"
#  lb    = "${ibm_is_lb.webtier-lb.id}"
#  pool  = "${ibm_is_lb_pool.webtier-lb-pool.id}"
#  port  = "80"
#  target_address = "${element(ibm_is_instance.webserver-zone1.*.primary_network_interface.0.primary_ipv4_address,count.index)}"
#}


#resource "ibm_is_lb_pool_member" "webtier-lb-pool-member-zone2" {
#  count = "${ibm_is_instance.webserver-zone2.count}"
#  lb    = "${ibm_is_lb.webtier-lb.id}"
#  pool  = "${ibm_is_lb_pool.webtier-lb-pool.id}"
#  port  = "80"
#  target_address = "${element(ibm_is_instance.webserver-zone2.*.primary_network_interface.0.primary_ipv4_address,count.index)}"
#}


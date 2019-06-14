# IBM Cloud Resource Group the CIS instance will be created under
# Retrieve CIS resource Group and Cloud Internet Services (CIS) instance data
data "ibm_resource_group" "resource" {
  name = "${var.cis_resource_group}"
}

data "ibm_cis" "cis_instance" {
  name              = "${var.cis_instance_name}"
  resource_group_id = "${data.ibm_resource_group.resource.id}"
}

data "ibm_cis_domain" "cis_instance_domain" {
  domain = "${var.domain}"
  cis_id = "${data.ibm_cis.cis_instance.id}"
}

#setup healthcheck for nginx
resource "ibm_cis_healthcheck" "root" {
  cis_id         = "${data.ibm_cis.cis_instance.id}"
  description    = "Websiteroot"
  expected_body  = ""
  expected_codes = "200"
  path           = "/nginx_status"
}

# Create Pool (of one) with VPC LBaaS instances using URL
resource "ibm_cis_origin_pool" "vpc-lbaas" {
  cis_id        = "${data.ibm_cis.cis_instance.id}"
  name          = "${var.vpc-name}-webtier-lb"
  check_regions = ["NAF"]

  monitor = "${ibm_cis_healthcheck.root.id}"

  origins = {
    name    = "${var.vpc-name}-webtier-lbaas-1"
    address = "${ibm_is_lb.webapptier-lb.hostname}"
    enabled = true
  }

  description = "${var.vpc-name}-webtier-lb"
  enabled     = true
}

# GLB name - name advertised by DNS for the website: prefix + domain.  Enable DDOS proxy
resource "ibm_cis_global_load_balancer" "glb" {
  cis_id           = "${data.ibm_cis.cis_instance.id}"
  domain_id        = "${data.ibm_cis_domain.cis_instance_domain.id}"
  name             = "${var.dns_name}${var.domain}"
  fallback_pool_id = "${ibm_cis_origin_pool.vpc-lbaas.id}"
  default_pool_ids = ["${ibm_cis_origin_pool.vpc-lbaas.id}"]
  session_affinity = "cookie"
  description      = "Global Loadbalancer for webappdemo"
  proxied          = true
}

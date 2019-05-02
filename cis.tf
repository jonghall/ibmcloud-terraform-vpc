# IBM Cloud Resource Group the CIS instance will be created under
data "ibm_resource_group" "resource" {
  name = "${var.resource_group}"
}

data "ibm_cis" "cis_instance" {
  name              = "${var.cis_instance_name}"
  resource_group_id = "${data.ibm_resource_group.resource.id}"
}

data "ibm_cis_domain" "cis_instance_domain" {
  domain = "${var.domain}"
  cis_id = "${data.ibm_cis.cis_instance.id}"
}

resource "ibm_cis_healthcheck" "root" {
  cis_id         = "${data.ibm_cis.cis_instance.id}"
  description    = "Websiteroot"
  expected_body  = ""
  expected_codes = "200"
  path           = "/readme.html"
}

resource "ibm_cis_origin_pool" "vpc-lbaas" {
  cis_id        = "${data.ibm_cis.cis_instance.id}"
  name          = "${var.vpc-name}-webtier-lb"
  check_regions = ["NAF"]

  monitor = "${ibm_cis_healthcheck.root.id}"

  # Should be replaced with the URL, but currently not exposed in ibm_is_lb
  origins = [{
    name    = "${var.vpc-name}-webtier-lbaas-1"
    address = "${ibm_is_lb.webtier-lb.public_ips[0]}"
    enabled = true
  },
    {
      name    = "${var.vpc-name}-webtier-lbaas-2"
      address = "${ibm_is_lb.webtier-lb.public_ips[1]}"
      enabled = true
    },
  ]

  description = "${var.vpc-name}-webtier-lb"
  enabled     = true
}

# # GLB name - name advertised by DNS for the website: prefix + domain
resource "ibm_cis_global_load_balancer" "glb" {
  cis_id           = "${data.ibm_cis.cis_instance.id}"
  domain_id        = "${data.ibm_cis_domain.cis_instance_domain.id}"
  name             = "${var.dns_name}${var.domain}"
  fallback_pool_id = "${ibm_cis_origin_pool.vpc-lbaas.id}"
  default_pool_ids = ["${ibm_cis_origin_pool.vpc-lbaas.id}"]
  session_affinity = "cookie"
  description      = "GLB for webappdemo"
  proxied          = true
}

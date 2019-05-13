output "web_dns_name" {
  value = "http://${ibm_is_lb.webapptier-lb.hostname}"
}

output "app_name" {
  value = "http://${var.dns_name}${var.domain}"
}

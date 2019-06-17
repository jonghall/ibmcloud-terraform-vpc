output "app_name" {
  value = "http://${var.dns_name}${var.domain}"
}

output "Master_DB" {
  value = "${ibm_is_instance.dbserver-zone1.0.primary_network_interface.0.primary_ipv4_address}"
}

output "Slave_DB" {
  value = "${ibm_is_instance.dbserver-zone2.0.primary_network_interface.0.primary_ipv4_address}"
}

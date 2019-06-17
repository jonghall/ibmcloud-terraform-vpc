output "app_name" {
  value = "http://${var.dns_name}${var.domain}"
}

output "Zone1-VPN-Peer" {
  value = "${ibm_is_vpn_gateway.VPNGateway1.public_ip_address}"
}

output "Zone2-VPN-Peer" {
  value = "${ibm_is_vpn_gateway.VPNGateway2.public_ip_address}"
}

output "Master_DB" {
  value = "${ibm_is_instance.dbserver-zone1.0.primary_network_interface.0.primary_ipv4_address}"
}

output "Slave_DB" {
  value = "${ibm_is_instance.dbserver-zone2.0.primary_network_interface.0.primary_ipv4_address}"
}

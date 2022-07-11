output "mysql_fqdn" {
  value = azurerm_mysql_server.demo_mysql_server_instance.fqdn
}

output "demo_instance_ip" {
  description = "The actual ip address allocated for the resource."
  value       = azurerm_network_interface.demo_network_interface.private_ip_address
}

output "demo_instance_public_ip" {
  description = "The actual ip address allocated for the resource."
  value       = azurerm_public_ip.public_ip_demo.ip_address
}
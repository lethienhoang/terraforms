resource "azurerm_mysql_server" "demo_mysql_server_instance" {
  name                = "${var.prefix}-mysql-instance"
  location            = azurerm_resource_group.demo_resource_group.location
  resource_group_name = azurerm_resource_group.demo_resource_group.name

  sku_name = "GP_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  administrator_login          = "mysqladmin"
  administrator_login_password = "Pass@word1111"
  version                      = "5.7"
  ssl_enforcement_enabled      = true
}

resource "azurerm_mysql_database" "demo_db" {
  name                = "${var.prefix}-db"
  resource_group_name = azurerm_resource_group.demo_resource_group.name
  server_name         = azurerm_mysql_server.demo_mysql_server_instance.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_virtual_network_rule" "demo_mysql_db_subnet_vnet_rule" {
  name                = "${var.prefix}-mysql-db-vnet-rule"
  resource_group_name = azurerm_resource_group.demo_resource_group.name
  server_name         = azurerm_mysql_server.demo_mysql_server_instance.name
  subnet_id           = azurerm_subnet.database_demo_intance_subnet.id
}

resource "azurerm_mysql_virtual_network_rule" "demo_mysql_subnet_vnet_rule" {
  name                = "${var.prefix}-mysql-db-internal-vnet-rule"
  resource_group_name = azurerm_resource_group.demo_resource_group.name
  server_name         = azurerm_mysql_server.demo_mysql_server_instance.name
  subnet_id           = azurerm_subnet.database_demo_intance_subnet.id
}

resource "azurerm_mysql_firewall_rule" "demo_mysql_allo_demo_instance" {
  name                = "${var.prefix}-db-firewall"
  resource_group_name = azurerm_resource_group.demo_resource_group.name
  server_name         = azurerm_mysql_server.demo_mysql_server_instance.name
  start_ip_address    = azurerm_network_interface.demo_network_interface.private_ip_address
  end_ip_address      = azurerm_network_interface.demo_network_interface.private_ip_address
}

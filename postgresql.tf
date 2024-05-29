resource "azurerm_private_dns_zone" "default" {
  name                = "${var.config["postgresql_name"]}-pdz.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.default.name

  depends_on = [azurerm_subnet_network_security_group_association.default]
}

resource "azurerm_private_dns_zone_virtual_network_link" "default" {
  name                  = "${var.config["postgresql_name"]}-pdzvnetlink.com"
  private_dns_zone_name = azurerm_private_dns_zone.default.name
  virtual_network_id    = azurerm_virtual_network.default.id
  resource_group_name   = azurerm_resource_group.default.name
}

resource "azurerm_postgresql_flexible_server" "default" {
  name                   = "${var.config["postgresql_name"]}-server"
  resource_group_name    = azurerm_resource_group.default.name
  location               = azurerm_resource_group.default.location
  version                = "13"
  delegated_subnet_id    = azurerm_subnet.default.id
  private_dns_zone_id    = azurerm_private_dns_zone.default.id
  administrator_login    = "${var.config["user"]}"
  administrator_password = "${var.config["password"]}"
  zone                   = "1"
  storage_mb             = 32768
  sku_name               = "GP_Standard_D2s_v3"
  backup_retention_days  = 7

  depends_on = [azurerm_private_dns_zone_virtual_network_link.default]
}

resource "azurerm_postgresql_flexible_server_database" "default" {
  name      = "${var.config["postgresql_name"]}-db"
  server_id = azurerm_postgresql_flexible_server.default.id
  collation = "en_GB.utf8"
  charset   = "UTF8"
}
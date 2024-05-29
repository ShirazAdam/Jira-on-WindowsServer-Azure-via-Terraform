resource "azurerm_virtual_network" "default" {
  name                = "${var.config["vnet_name"]}"
  address_space       = ["${var.config["vnet_address_range"]}"]
  resource_group_name = "${azurerm_resource_group.res_group.name}"
  location            = "${azurerm_resource_group.res_group.location}"
}

resource "azurerm_network_security_group" "default" {
  name                = "${random_pet.name_prefix.id}-nsg"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet" "default" {
  name                 = "${var.config["subnet_name"]}-subnet"
  resource_group_name  = "${azurerm_resource_group.res_group.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefixes     = "${var.config["subnet_address_range"]}"
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "fs"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "default" {
  subnet_id                 = azurerm_subnet.default.id
  network_security_group_id = azurerm_network_security_group.default.id
}
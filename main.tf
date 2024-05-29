resource "azurerm_public_ip" "vm-pip" {
  name                         = "vm-pip"
  location                     = "${azurerm_resource_group.res_group.location}"
  resource_group_name          = "${azurerm_resource_group.res_group.name}"
  domain_name_label            = "crs-vm1-jira"
  allocation_method            = "static"
}

resource "azurerm_network_interface" "vm-nic" {
  name                = "vm-nic"
  resource_group_name = "${azurerm_resource_group.res_group.name}"
  location            = "${azurerm_resource_group.res_group.location}"

  ip_configuration {
    name = "jiraconf-ipconfig-01"
    private_ip_address_allocation = "static"
    subnet_id                     = "${azurerm_subnet.subnet1.id}"
    public_ip_address_id          = "${azurerm_public_ip.vm-pip.id}"
  }
}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "main" {
  name                  = "jiraconf-vm=01"
  admin_username        = "${var.config["vm_username"]}"
  admin_password        = "${var.config["vm_password"]}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "${var.config["vm_image_publisher"]}"
    offer     = "${var.config["vm_image_offer"]}"
    sku       = "${var.config["vm_image_sku"]}"
    version   = "${var.config["vm_image_version"]}"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_virtual_machine_extension" "AADLoginForWindows" {
  name                       = "AADLoginForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.main.id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}

resource "azurerm_managed_disk" "managed_disk" {
  count                = 1
  name                 = "jiraconf-datadisk-vm-01"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 500
}

resource "azurerm_virtual_machine_data_disk_attachment" "managed_disk_attach" {
  count              = 1
  managed_disk_id    = azurerm_managed_disk.managed_disk.*.id
  virtual_machine_id = azurerm_windows_virtual_machine.main.*.id
  lun                = 0
  caching            = "ReadWrite"
}

resource "null_resource" "remote-exec-vm-1" {
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = "${azurerm_public_ip.vm-pip.ip_address}"
      user     = "${var.config["vm_username"]}"
      password = "${var.config["vm_password"]}"
    }

    inline = [
      "powershell.exe .\\scripts\\installJira.ps1",
    ]
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = "${azurerm_public_ip.vm-pip.ip_address}"
      user     = "${var.config["vm_username"]}"
      password = "${var.config["vm_password"]}"
    }

    inline = [
      "powershell.exe .\\scripts\\configJiraDb.ps1 -Server \"${azurerm_postgresql_flexible_server.default.fully_qualified_domain_name}\" -Username \"${azurerm_postgresql_flexible_server.default.administrator_login}\" -Password \"${azurerm_postgresql_flexible_server.default.administrator_password}\"",
    ]
  }

  depends_on = ["azurerm_windows_virtual_machine.main", "azurerm_postgresql_flexible_server_database.default"]
}

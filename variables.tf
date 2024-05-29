variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "config" {
  type = "map"

  default = {
    # Resource Group settings
    resource_group = "rg-jiraconf-001"
    location       = "UK South"

    # Network Security Group settings
    security_group_name = "nsg-jiraconf-001"

    # Network settings
    vnet_name            = "vnet-jiraconf-001"
    vnet_address_range   = "10.0.0.0/24"
    subnet_name          = "subnet-jiraconf-001"
    subnet_address_range = "10.0.0.0/26"

    # Virtual Machine settings
    vm_name            = "jicvm001"
    vm_size            = "Standard_DS1_v2"
    vm_image_publisher = "MicrosoftWindowsServer"
    vm_image_offer     = "WindowsServer"
    vm_image_sku       = "2022-datacenter-azure-edition"
    vm_image_version   = "latest"
    vm_username        = "azureuser"
    vm_password        = "azurepassword123"
    
    # Azure DB for PostgreSQL
    postgresql_name = "jira-postgresql-01"
    db_name         = "jiradb"
    user            = "adminaccount"
    password        = "adminpassword123"
  }
}

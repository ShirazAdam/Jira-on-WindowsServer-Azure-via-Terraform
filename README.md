# Jira-on-WindowsServer-Azure-via-Terraform
Deploying Jira on Windows Server 2022 hosted on Azure through the use of Terraform and PowerShell

## Terraform Files

The following table describes the terraform files and their purpose.  

| File                | Description                                             | 
| ------------------- | ----------------                                        | 
| variables.tf        | Contains variables and config values used for deployment| 
| provider.tf         | Contains provider settings                              |
| rg.tf               | Contains resource group settings                        |
| nsg.tf              | Contains network security group                         |   
| network.tf          | Contains network settings                               |
| storage.tf          | Contains storage account settings                       |
| main.tf             | Jira virtual machine on Windows Server 2022             |
| postgresql.tf       | Azure DB for PostgreSQL                                 |
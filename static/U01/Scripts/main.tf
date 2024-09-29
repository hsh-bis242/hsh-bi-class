variable "groupnumber" {
  description = "This is your groups number"
  type        = number
  default     = 0
  validation {
    condition     = var.groupnumber > 0 && var.groupnumber <= 10
    error_message = "Please provide a valid group number"
  }
}

variable "sqlpassword" {
  description = "This is a variable of type string"
  type        = string
  default     = "ryDZo5*~71[Q-"
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  subscription_id = "1f75bacb-8d7d-4e96-87cb-f7e4216886e5"
}

// Resourcengruppe
resource "azurerm_resource_group" "rgBI" {
  name     = "rgBI"
  location = "West Europe"
}

// Storageaccount
resource "azurerm_storage_account" "bistorage" {
  name                     = format("bi%02d", var.groupnumber)
  resource_group_name      = azurerm_resource_group.rgBI.name
  location                 = azurerm_resource_group.rgBI.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = {
    "ms-resource-usage" = "azure-cloud-shell"
  }
}

// Storagecontainer
resource "azurerm_storage_container" "bistoragecontainer" {
  name                  = format("bi%02d", var.groupnumber)
  storage_account_name  = azurerm_storage_account.bistorage.name
  container_access_type = "private"
}

// SQL Server
resource "azurerm_mssql_server" "bisqlserver" {
  name                         = format("bi%02d", var.groupnumber)
  resource_group_name          = azurerm_resource_group.rgBI.name
  location                     = azurerm_resource_group.rgBI.location
  version                      = "12.0"
  administrator_login          = format("bi%02d", var.groupnumber)
  administrator_login_password = var.sqlpassword
}

// Adding Azure SQL firewall rule to allow access from Azure services
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name                = "AllowAzureServices"
  server_id           = azurerm_mssql_server.bisqlserver.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}
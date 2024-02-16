// terraform import azurerm_resource_group.rgBI /subscriptions/1f75bacb-8d7d-4e96-87cb-f7e4216886e5/resourceGroups/rgBI
// terraform import azurerm_storage_account.bixx /subscriptions/1f75bacb-8d7d-4e96-87cb-f7e4216886e5/resourceGroups/rgBI/providers/Microsoft.Storage/storageAccounts/bixx
// terraform import azurerm_data_factory.BIXX /subscriptions/1f75bacb-8d7d-4e96-87cb-f7e4216886e5/resourceGroups/rgBI/providers/Microsoft.DataFactory/factories/BIXX
// terraform import azurerm_mssql_server.bixx /subscriptions/1f75bacb-8d7d-4e96-87cb-f7e4216886e5/resourceGroups/rgBI/providers/Microsoft.Sql/servers/bixx
// terraform import azurerm_mssql_database.WillibaldXX /subscriptions/1f75bacb-8d7d-4e96-87cb-f7e4216886e5/resourceGroups/rgBI/providers/Microsoft.Sql/servers/bixx/databases/WillibaldXX
// terraform import azurerm_mssql_firewall_rule.allow_azure_services /subscriptions/1f75bacb-8d7d-4e96-87cb-f7e4216886e5/resourceGroups/rgBI/providers/Microsoft.Sql/servers/bixx/firewallRules/AllowAzureServices
// terraform import azurerm_storage_container.bixx https://bixx.blob.core.windows.net/bixx

provider "azurerm" {
  features {

  }
  skip_provider_registration = true
}

// Resourcengruppe
resource "azurerm_resource_group" "rgBI" {
  name     = "rgBI"
  location = "West Europe"
}

// Storageaccount
resource "azurerm_storage_account" "bixx" { // edit xx
  name                     = "bixx" // edit xx
  resource_group_name      = azurerm_resource_group.rgBI.name
  location                 = azurerm_resource_group.rgBI.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

// Storagecontainer
resource "azurerm_storage_container" "bixx" { // edit xx
  name                  = "bixx" // edit xx
  storage_account_name  = azurerm_storage_account.bixx.name // edit xx
  container_access_type = "private"
}

// SQL Server
resource "azurerm_mssql_server" "bixx" { // edit xx
  name                         = "bixx" // edit xx
  resource_group_name          = azurerm_resource_group.rgBI.name
  location                     = azurerm_resource_group.rgBI.location
  version                      = "12.0"
  administrator_login          = "bixx" // edit xx
  administrator_login_password = "ryDZo5*~71[Q-" // edit password
}

// Adding Azure SQL firewall rule to allow access from Azure services
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name                = "AllowAzureServices"
  server_id           = azurerm_mssql_server.bixx.id // edit xx
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
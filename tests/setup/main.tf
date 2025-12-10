resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "westeurope"
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "example-workspace"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

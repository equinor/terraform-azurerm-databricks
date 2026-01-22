output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

output "location" {
  value = azurerm_resource_group.example.location
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.example.id
}

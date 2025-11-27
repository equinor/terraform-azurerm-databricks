output "workspace_id" {
  description = "The ID of this Databricks workspace."
  value       = azurerm_databricks_workspace.this.id
}

output "workspace_name" {
  description = "The name of this Databricks workspace."
  value       = azurerm_databricks_workspace.this.name
}

output "workspace_url" {
  description = "The URL of this Databricks workspace."
  value       = azurerm_databricks_workspace.this.workspace_url
}

output "managed_identity_principal_id" {
  description = "The principal (object) ID of the managed identity that Azure Databricks automatically creates."
  value       = data.azurerm_user_assigned_identity.dbmanagedidentity.principal_id
}

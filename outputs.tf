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

  depends_on = [
    # The workspace URL is usually passed to a Databricks provider configuration.
    # Many Databricks resources require a metastore to be assigned to the workspace.
    # Wait for a metastore to be automatically assigned before outputting the workspace URL.
    time_sleep.metastore_assignment
  ]
}

output "managed_identity_principal_id" {
  description = "The principal (object) ID of the managed identity that Azure Databricks automatically creates."
  value       = data.azurerm_user_assigned_identity.dbmanagedidentity.principal_id
}

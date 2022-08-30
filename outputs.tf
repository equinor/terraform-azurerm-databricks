output "workspace_id" {
  description = "The ID of this Databricks workspace."
  value       = azurerm_databricks_workspace.this.id
}

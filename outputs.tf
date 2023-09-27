output "workspace_id" {
  description = "The ID of this Databricks workspace."
  value       = azurerm_databricks_workspace.this.id
}

output "workspace_name" {
  description = "The name of this Databricks workspace."
  value       = azurerm_databricks_workspace.this.name
}

output "workspace_url" {
  description = "The url of this Databricks workspace."
  value       = azurerm_databricks_workspace.this.workspace_url
}

output "compute_subnet_ids" {
  description = "The IDs of the compute subnets if set."
  value       = [for subnet in azurerm_subnet.this : subnet.id]
}

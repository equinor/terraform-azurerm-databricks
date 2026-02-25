output "group_display_names" {
  description = "A map of display names for the external groups that were assigned to the Databricks workspace."
  value       = { for k, v in data.databricks_group.this : k => v.display_name }
}

output "service_principal_application_ids" {
  description = "A map of application IDs for the external service principals that were assigned to the Databricks workspace."
  value       = { for k, v in data.databricks_service_principal.this : k => v.application_id }
}

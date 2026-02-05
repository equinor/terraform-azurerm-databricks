variable "workspace_url" {
  description = "The URL of the Databricks workspace to assign the identities to."
  type        = string
  nullable    = false
}

variable "external_groups" {
  description = "A map of external groups to assign to the Databricks workspace. To assign a user, group or service principal from Microsoft Entra ID, the external ID should match the Microsoft Entra object ID."
  type = map(object({
    external_id           = string
    admin_access          = optional(bool, false)
    workspace_access      = optional(bool, true)
    databricks_sql_access = optional(bool, true)
    allow_cluster_create  = optional(bool, false)
  }))
  nullable = false
  default  = {}
}

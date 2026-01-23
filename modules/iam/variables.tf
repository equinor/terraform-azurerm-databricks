variable "external_groups" {
  # TODO: add a description
  type = map(object({
    external_id           = string # Object ID from Entra ID
    admin_access          = optional(bool, false)
    workspace_access      = optional(bool, true)
    databricks_sql_access = optional(bool, true)
  }))
  nullable = false
  default  = {}
}

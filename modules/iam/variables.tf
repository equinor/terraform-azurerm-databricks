variable "external_groups" {
  # TODO: add a description
  type = map(object({
    external_id           = string # Object ID from Entra ID
    permissions           = optional(list(string), ["USER"])
    workspace_access      = optional(bool, true)
    databricks_sql_access = optional(bool, true)
  }))
  nullable = false
  default  = {}

  # TODO: validate that permissions contains "USER" and/or "ADMIN"
}

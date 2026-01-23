variable "external_groups" {
  # TODO: add a description
  type = map(object({
    external_id           = string # Object ID from Entra ID
    permissions           = list(string)
    workspace_access      = bool
    databricks_sql_access = bool
  }))
  nullable = false
  default  = {}

  # TODO: validate that permissions contains "USER" and/or "ADMIN"
}

variable "account_id" {
  # TODO: add description.
  type     = string
  nullable = false
}

variable "service_principals" {
  description = "A map of Databricks service principals to create in the Databricks workspace."
  type = map(object({
    display_name          = string
    workspace_access      = optional(bool, true)
    databricks_sql_access = optional(bool, true)
    allow_cluster_create  = optional(bool, false)
    permissions = list(object({
      user_name              = optional(string) # display name
      group_name             = optional(string) # display name
      service_principal_name = optional(string) # application ID
      permission_level       = string           # "CAN_MANAGE" or "CAN_USE"
    }))
  }))
  nullable = false
  default  = {}

  # TODO: validate that only one of user_name, group_name and service_principal_name is specified
}

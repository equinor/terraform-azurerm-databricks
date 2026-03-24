variable "account_id" {
  # TODO: add description.
  type     = string
  nullable = false
}

variable "service_principals" {
  description = "A map of service principals to create in the Databricks workspace. A permission object must specify a user (by display name), group (by display name) or service principal (by application ID), and a permission level (\"CAN_MANAGE\" or \"CAN_USE\")."
  type = map(object({
    display_name          = string
    workspace_access      = optional(bool, true)
    databricks_sql_access = optional(bool, true)
    allow_cluster_create  = optional(bool, false)
    permissions = optional(list(object({
      user_name              = optional(string)
      group_name             = optional(string)
      service_principal_name = optional(string)
      permission_level       = string
    })))
  }))
  nullable = false
  default = {
    "example" = {
      display_name = "example-sp"
      permissions = [
        {
          user_name        = "example-user"
          group_name       = "example-group"
          permission_level = "foo"
        }
      ]
    }
  }

  validation {
    condition = alltrue([
      for _, sp in var.service_principals :
      alltrue([
        for p in coalesce(sp.permissions, []) :
        length(compact([p.user_name, p.group_name, p.service_principal_name])) == 1
      ])
    ])
    error_message = "A permission object must specify exactly one of user_name, group_name, or service_principal_name."
  }

  validation {
    condition = alltrue([
      for _, sp in var.service_principals :
      alltrue([
        for p in coalesce(sp.permissions, []) :
        p.permission_level == "CAN_MANAGE" || p.permission_level == "CAN_USE"
      ])
    ])
    error_message = "A permission object must specify a permission level of \"CAN_MANAGE\" or \"CAN_USE\"."
  }
}

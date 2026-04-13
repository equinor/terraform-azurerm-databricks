variable "account_id" {
  description = "The ID of the Databricks account to manage service principal permissions for."
  type        = string
  nullable    = false
}

variable "service_principals" {
  description = "A map of service principals to create in the Databricks workspace. A permission object must specify a user (by display name), group (by display name) or service principal (by application ID), and a permission level (\"CAN_MANAGE\" or \"CAN_USE\")."
  type = map(object({
    display_name         = string
    allow_cluster_create = optional(bool, false)
    permissions = optional(list(object({
      user_name              = optional(string)
      group_name             = optional(string)
      service_principal_name = optional(string)
      permission_level       = string
    })), [])
  }))
  nullable = false
  default  = {}

  validation {
    condition = alltrue([
      for _, sp in var.service_principals : length(sp.permissions) > 0
    ])
    error_message = "At least one permission object must be specified."
  }

  validation {
    condition = alltrue([
      for _, sp in var.service_principals :
      alltrue([
        for p in sp.permissions :
        length(compact([p.user_name, p.group_name, p.service_principal_name])) == 1
      ])
    ])
    error_message = "A permission object must specify exactly one of user_name, group_name, or service_principal_name."
  }

  validation {
    condition = alltrue([
      for _, sp in var.service_principals :
      alltrue([
        for p in sp.permissions :
        p.permission_level == "CAN_MANAGE" || p.permission_level == "CAN_USE"
      ])
    ])
    error_message = "A permission object must specify a permission level of \"CAN_MANAGE\" or \"CAN_USE\"."
  }
}

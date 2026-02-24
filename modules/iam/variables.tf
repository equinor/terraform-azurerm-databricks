variable "workspace_url" {
  description = "The URL of the Databricks workspace to assign the identities to."
  type        = string
  nullable    = false
}

variable "external_groups" {
  description = "A map of external groups to assign to the Databricks workspace. To assign a group from Microsoft Entra ID, the external ID should match the Microsoft Entra group object ID."
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

variable "external_service_principals" {
  description = "A map of external service principals to assign to the Databricks workspace. To assign a service principal from Microsoft Entra ID, the external ID should match the Microsoft Entra service principal object ID."
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

variable "workspace_name" {
  description = "The name of this Databricks workspace."
  type        = string
  nullable    = false
}

variable "resource_group_name" {
  description = "The name of the resource group to create the resources in."
  type        = string
  nullable    = false
}

variable "location" {
  description = "The location to create the resources in."
  type        = string
  nullable    = false
}

variable "sku" {
  description = "The SKU of this Databricks workspace. Value must be \"standard\" or \"premium\"."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.sku)
    error_message = "SKU must be \"standard\" or \"premium\"."
  }
}

variable "managed_resource_group_name" {
  description = "The name of the resource group to create the managed Databricks resources in."
  type        = string
  default     = null
  nullable    = true
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to send diagnostics to. Required if value of sku is \"premium\"."
  type        = string
  default     = null
  nullable    = true
}

variable "diagnostic_setting_name" {
  description = "The name of this diagnostic setting."
  type        = string
  default     = "audit-logs"
  nullable    = false
}

# Enable all log categories that do not cost to export
# Ref: https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/resource-logs-categories#microsoftdatabricksworkspaces
variable "diagnostic_setting_enabled_log_categories" {
  description = "A list of log categories to be enabled for this diagnostic setting."
  type        = list(string)

  default = [
    "accounts",
    "clusters",
    "dbfs",
    "instancePools",
    "jobs",
    "notebook",
    "secrets",
    "sqlPermissions",
    "ssh",
    "workspace"
  ]

  nullable = false
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

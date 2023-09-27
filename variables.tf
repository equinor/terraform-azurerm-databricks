variable "workspace_name" {
  description = "The name of this Databricks workspace."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group to create the resources in."
  type        = string
}

variable "location" {
  description = "The location to create the resources in."
  type        = string
}

variable "sku" {
  description = "The SKU of this Databricks workspace."
  type        = string
  default     = "standard"
}

variable "managed_resource_group_name" {
  description = "The name of the resource group to create the managed Databricks resources in."
  type        = string
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to send diagnostics to."
  type        = string
  default     = null
}

variable "log_analytics_destination_type" {
  description = "The type of log analytics destination to use for this Log Analytics Workspace."
  type        = string
  default     = null
}

variable "diagnostic_setting_name" {
  description = "The name of this diagnostic setting."
  type        = string
  default     = "audit-logs"
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
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

variable "public_network_access_enabled" {
  description = "Should databricks workspace be reachable from the internet?"
  type        = bool
  default     = true
}

variable "secure_connectivity_settings" {
  description = "A collection of settings related to secure connectivty cluster"
  type = object({
    nat_gateway_name              = optional(string, "nat-gateway")
    public_ip_name                = optional(string, "nat-gw-public-ip")
    no_public_ip                  = optional(string, true)
    private_subnet_name           = optional(string, null)
    public_subnet_name            = optional(string, null)
    private_nsg_name              = optional(string, null)
    public_nsg_name               = optional(string, null)
    private_subnet_address_prefix = string
    public_subnet_address_prefix  = string
    virtual_network_id            = string
    vnet_address_prefix           = optional(string, "10.139")
    subnet_service_endpoints      = optional(list(string), [])
  })

  default = null
}

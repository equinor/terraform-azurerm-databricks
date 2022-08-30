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
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

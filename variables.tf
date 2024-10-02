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
  description = "The SKU of this Databricks workspace. Value must be \"standard\", \"premium\" or \"trial\"."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.sku)
    error_message = "SKU must be \"standard\" or \"premium\"."
  }
}

variable "log_analytics_workspace_id" {
  description = "The ID of a Log Analytics workspace to send diagnostics to. Required if value of sku is \"premium\"."
  type        = string
  default     = null
}

variable "default_storage_firewall_enabled" {
  description = "Should the firewall be enabled for the default Storage account?"
  type        = bool
  default     = false
}

variable "access_connector_id" {
  description = "The ID of the access connector to use if the firewall is enabled for the default Storage account. Required if value of default_storage_firewall_enabled is true."
  type        = string
  default     = null
}

variable "customer_managed_key_enabled" {
  description = "Should customer-managed key for encryption be enabled for this Databricks workspace? Only valid if value of sku is \"premium\"."
  type        = bool
  default     = false
}

variable "infrastructure_encryption_enabled" {
  description = "Should a secondary layer of encryption be enabled for the root file system? Only valid if value of sku is \"premium\"."
  type        = bool
  default     = false
}

variable "load_balancer_backend_address_pool_id" {
  description = "The ID of a load balancer backend address pool to be used for secure cluster connectivity (also known as \"No Public IP\" or NPIP)."
  type        = string
  default     = null
}

variable "managed_disk_cmk_key_vault_key_id" {
  description = "The ID of a Key Vault key to be used for encryption of managed disks using customer-managed key."
  type        = string
  default     = null
}

variable "managed_disk_cmk_key_vault_id" {
  description = "The ID of the Key Vault containing the key to be used for encryption of managed disks using customer-managed key. Only required if the Key Vault exists in a different subscription than this Databricks workspace."
  type        = string
  default     = null
}

variable "managed_disk_cmk_rotation_to_latest_version_enabled" {
  description = "Should automatic rotation to latest version of the customer-managed key used for encryption of managed disks be enabled?"
  type        = bool
  default     = null
}

variable "managed_services_cmk_key_vault_key_id" {
  description = "The ID of a Key Vault key to be used for encryption of managed services (e.g. notebooks and artifacts) using customer-managed key."
  type        = string
  default     = null
}

variable "managed_services_cmk_key_vault_id" {
  description = "The ID of the Key Vault containing the key to be used for encryption of managed services using customer-managed key. Only required if the Key Vault exists in a different subscription than this Databricks workspace."
  type        = string
  default     = null
}

variable "managed_resource_group_name" {
  description = "The name of the resource group to create the managed Databricks resources in."
  type        = string
  default     = null
  nullable    = true
}

variable "public_network_access_enabled" {
  description = "Should public network access be enabled for this Databricks workspace?"
  type        = bool
  default     = true
}

variable "network_security_group_rules_required" {
  description = "The network security group rules required for data plane (clusters) to control plane (Azure) communication. Value must be \"AllRules\", \"NoAzureDatabricksRules\" (internal) or \"NoAzureServiceRules\". Required if value of public_network_access_enabled is false."
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


#
# Custom Parameters
#
variable "machine_learning_workspace_id" {
  description = "The ID of a Machine Learning workspace to link with this Databricks workspace."
  type        = string
  default     = null
}

variable "nat_gateway_name" {
  description = "The name of the NAT gateway to be created for this Databricks workspace."
  type        = string
  default     = null
}

variable "public_ip_name" {
  description = "The name of the Public IP address to be created for this Databricks workspace."
  type        = string
  default     = null
}

variable "no_public_ip" {
  description = "Should Public IP be disabled for clusters?"
  type        = bool
  default     = false
}

variable "vnet_address_prefix" {
  description = "The address prefix to use for a managed Virtual Network to be created for this Databricks workspace."
  type        = string
  default     = null
}

variable "virtual_network_id" {
  description = "The ID of an existing Virtual Network to inject this Databricks workspace into."
  type        = string
  default     = null
}

variable "private_subnet_name" {
  description = "The name of the subnet to use as the private subnet. Subnet must be delegated to \"Microsoft.Databricks/workspaces\". Required if virtual_network_id is set."
  type        = string
  default     = null
}

variable "private_subnet_network_security_group_association_id" {
  description = "The ID of the subnet network security group association for the private subnet. Required if virtual_network_id is set."
  type        = string
  default     = null
}

variable "public_subnet_name" {
  description = "The name of the subnet to use as the public subnet. Subnet must be delegated to \"Microsoft.Databricks/workspaces\". Required if virtual_network_id is set."
  type        = string
  default     = null
}

variable "public_subnet_network_security_group_association_id" {
  description = "The ID of the subnet network security group association for the public subnet. Required if virtual_network_id is set."
  type        = string
  default     = null
}

variable "storage_account_name" {
  description = "The name of the Storage account to be created for this Databricks workspace."
  type        = string
  default     = null
}

variable "storage_account_sku_name" {
  description = "The SKU name of the Storage account to be crated for this Databricks workspace. Value must be \"Standard_LRS\", \"Standard_GRS\", \"Standard_RAGRS\", \"Standard_GZRS\", \"Standard_RAGZRS\", \"Standard_ZRS\", \"Premium_LRS\" or \"Premium_ZRS\"."
  type        = string
  default     = "Standard_GRS"
}

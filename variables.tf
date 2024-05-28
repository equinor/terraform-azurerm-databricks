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
  description = "The SKU of this Databricks workspace. Value must be \"standard\", \"premium\" or \"trial\"."
  type        = string
  default     = "standard"
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


#
# Custom Parameters
#
variable "machine_learning_workspace_id" {
  description = "The ID of a Azure Machine Learning workspace to link with Databricks workspace. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "nat_gateway_name" {
  description = "Name of the NAT Gateway. Defaults to 'nat-gateway'"
  type        = string
  default     = null
}

variable "public_ip_name" {
  description = "Name of the public IP for the NAT Gateway. Defaults to 'nat-gw-public-ip'"
  type        = string
  default     = null
}

variable "no_public_ip" {
  description = "Should public ip be disabled for clusters? Can only be set to true for VNet injected clusters."
  type        = bool
  default     = null
}

variable "private_subnet_network_security_group_association_id" {
  description = "Id of the Network Security Group subnet association for the private subnet"
  type        = string
  default     = null
}

variable "public_subnet_network_security_group_association_id" {
  description = "Id of the Network Security Group subnet association for the public subnet"
  type        = string
  default     = null
}

variable "private_subnet_id" {
  description = "Address prefix for the private subnet. Subnet must be in the same vnet as the public subnet. Subnet must be delegated to 'Microsoft.Databricks/workspaces'."
  type        = string
  default     = null
}

variable "public_subnet_id" {
  description = "Address prefix for the public subnet. Subnet must be in the same vnet as the private subnet. Subnet must be delegated to 'Microsoft.Databricks/workspaces'."
  type        = string
  default     = null
}

variable "storage_account_name" {
  description = "Default Databricks File Storage account name. Defaults to a randomized name(e.g. dbstoragel6mfeghoe5kxu). Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "storage_account_sku_name" {
  description = "Storage account SKU name. Possible values include Standard_LRS, Standard_GRS, Standard_RAGRS, Standard_GZRS, Standard_RAGZRS, Standard_ZRS, Premium_LRS or Premium_ZRS. Defaults to Standard_GRS. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "vnet_address_prefix" {
  description = "Address prefix for the virtual network"
  type        = string
  default     = null
}

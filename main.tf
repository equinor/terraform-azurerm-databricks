resource "azurerm_databricks_workspace" "this" {
  name                                                = var.workspace_name
  resource_group_name                                 = var.resource_group_name
  location                                            = var.location
  access_connector_id                                 = var.access_connector_id
  customer_managed_key_enabled                        = var.customer_managed_key_enabled
  default_storage_firewall_enabled                    = var.default_storage_firewall_enabled
  infrastructure_encryption_enabled                   = var.infrastructure_encryption_enabled
  load_balancer_backend_address_pool_id               = var.load_balancer_backend_address_pool_id
  sku                                                 = var.sku
  managed_disk_cmk_key_vault_id                       = var.managed_disk_cmk_key_vault_id
  managed_disk_cmk_key_vault_key_id                   = var.managed_disk_cmk_key_vault_key_id
  managed_disk_cmk_rotation_to_latest_version_enabled = var.managed_disk_cmk_rotation_to_latest_version_enabled
  managed_services_cmk_key_vault_id                   = var.managed_services_cmk_key_vault_id
  managed_services_cmk_key_vault_key_id               = var.managed_services_cmk_key_vault_key_id
  managed_resource_group_name                         = var.managed_resource_group_name
  network_security_group_rules_required               = var.network_security_group_rules_required
  public_network_access_enabled                       = var.public_network_access_enabled

  custom_parameters {
    machine_learning_workspace_id                        = var.machine_learning_workspace_id
    nat_gateway_name                                     = var.nat_gateway_name
    public_ip_name                                       = var.public_ip_name
    no_public_ip                                         = var.no_public_ip
    public_subnet_name                                   = var.private_subnet_id != null ? local.private_subnet_parsed.subnet_name : null
    public_subnet_network_security_group_association_id  = var.public_subnet_network_security_group_association_id
    private_subnet_name                                  = var.public_subnet_id != null ? local.public_subnet_parsed.subnet_name : null
    private_subnet_network_security_group_association_id = var.private_subnet_network_security_group_association_id
    storage_account_name                                 = var.storage_account_name
    storage_account_sku_name                             = var.storage_account_sku_name
    virtual_network_id                                   = var.private_subnet_id != null ? local.vnet_parsed.vnet_id : null
    vnet_address_prefix                                  = var.vnet_address_prefix
  }

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  # Premium SKU required for diagnostic settings
  # Ref: https://docs.microsoft.com/en-us/azure/databricks/administration-guide/account-settings/azure-diagnostic-logs#configure-diagnostic-log-delivery
  count = var.sku == "premium" ? 1 : 0

  name                       = var.diagnostic_setting_name
  target_resource_id         = azurerm_databricks_workspace.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # Ref: https://registry.terraform.io/providers/hashicorp/azurerm/3.65.0/docs/resources/monitor_diagnostic_setting#log_analytics_destination_type
  log_analytics_destination_type = null

  dynamic "enabled_log" {
    for_each = toset(var.diagnostic_setting_enabled_log_categories)

    content {
      category = enabled_log.value
    }
  }

  lifecycle {
    precondition {
      condition     = var.log_analytics_workspace_id != null
      error_message = "log_analytics_workspace_id must be set when sku is set to \"premium\"."
    }
  }
}

#
# Networking
#
locals {
  private_subnet_parsed = regex(".*/resourcegroups/(?P<resource_group>.*?)/providers/microsoft.network/virtualnetworks/(?P<vnet_name>.*?)/subnets/(?P<subnet_name>.*?)$", lower(var.private_subnet_id))
  public_subnet_parsed  = regex(".*/resourcegroups/(?P<resource_group>.*?)/providers/microsoft.network/virtualnetworks/(?P<vnet_name>.*?)/subnets/(?P<subnet_name>.*?)$", lower(var.public_subnet_id))
  vnet_parsed           = regex("(?P<vnet_id>.*?)/subnets/.*?$", var.public_subnet_id)
}

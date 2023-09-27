resource "azurerm_databricks_workspace" "this" {
  name                          = var.workspace_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = var.sku
  managed_resource_group_name   = var.managed_resource_group_name
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "custom_parameters" {
    for_each = var.secure_connectivity_settings != null ? [1] : []
    content {
      nat_gateway_name                                     = var.secure_connectivity_settings.nat_gateway_name
      public_ip_name                                       = var.secure_connectivity_settings.public_ip_name
      no_public_ip                                         = var.secure_connectivity_settings.no_public_ip
      public_subnet_name                                   = azurerm_subnet.this["public"].name
      public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.this["public"].id
      private_subnet_name                                  = azurerm_subnet.this["private"].name
      private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.this["private"].id
      virtual_network_id                                   = var.secure_connectivity_settings.virtual_network_id
      vnet_address_prefix                                  = var.secure_connectivity_settings.vnet_address_prefix
    }

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
  parsed_vnet = regex(".*/resourcegroups/(?P<resource_group>.*?)/providers/microsoft.network/virtualnetworks/(?P<name>.*?)$", lower(var.secure_connectivity_settings.virtual_network_id))
  subnets = var.secure_connectivity_settings != null ? {
    private = {
      address_prefix    = var.secure_connectivity_settings.private_subnet_address_prefix
      name              = var.secure_connectivity_settings.private_subnet_name != null ? var.secure_connectivity_settings.private_subnet_name : "snet-db-private"
      service_endpoints = var.secure_connectivity_settings.subnet_service_endpoints
    },
    public = {
      address_prefix    = var.secure_connectivity_settings.public_subnet_address_prefix
      name              = var.secure_connectivity_settings.public_subnet_name != null ? var.secure_connectivity_settings.public_subnet_name : "snet-db-public"
      service_endpoints = var.secure_connectivity_settings.subnet_service_endpoints
    }
  } : {}
  nsgs = var.secure_connectivity_settings != null ? {
    private = {
      name = var.secure_connectivity_settings.private_nsg_name != null ? var.secure_connectivity_settings.private_nsg_name : "nsg-db-private"
    },
    public = {
      name = var.secure_connectivity_settings.public_nsg_name != null ? var.secure_connectivity_settings.public_nsg_name : "snet-db-public"
    }
  } : {}
}

resource "azurerm_subnet" "this" {
  # Add subnets if virtual network id is set
  for_each             = local.subnets
  name                 = each.value.name
  resource_group_name  = local.parsed_vnet.resource_group
  virtual_network_name = local.parsed_vnet.name
  address_prefixes     = [each.value.address_prefix]
  service_endpoints    = each.value.service_endpoints

  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
    }
  }

  lifecycle {
    ignore_changes = [delegation]
  }
}

resource "azurerm_network_security_group" "this" {
  for_each            = local.nsgs
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "this" {
  depends_on                = [azurerm_network_security_group.this]
  for_each                  = local.nsgs
  subnet_id                 = azurerm_subnet.this["${each.key}"].id
  network_security_group_id = azurerm_network_security_group.this["${each.key}"].id
}

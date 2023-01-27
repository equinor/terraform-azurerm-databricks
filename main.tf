resource "azurerm_databricks_workspace" "this" {
  name                        = var.workspace_name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  sku                         = var.sku
  managed_resource_group_name = var.managed_resource_group_name

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  count = var.diagnostic_setting != null ? 1 : 0

  name                       = var.diagnostic_setting["name"]
  target_resource_id         = azurerm_databricks_workspace.this.id
  log_analytics_workspace_id = var.diagnostic_setting["log_analytics_workspace_id"]

  dynamic "enabled_log" {
    for_each = toset(var.diagnostic_setting["enabled_logs"])

    content {
      category = enabled_log.value

      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }
}

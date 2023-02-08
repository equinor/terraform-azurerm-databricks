resource "azurerm_databricks_workspace" "this" {
  name                        = var.workspace_name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  sku                         = var.sku
  managed_resource_group_name = var.managed_resource_group_name

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  # Premium SKU required for diagnostic settings
  # Ref: https://docs.microsoft.com/en-us/azure/databricks/administration-guide/account-settings/azure-diagnostic-logs#configure-diagnostic-log-delivery
  count = var.sku == "premium" ? 1 : 0

  name                       = "audit-logs"
  target_resource_id         = azurerm_databricks_workspace.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # Enable all log categories that do not cost to export
  # Ref: https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/resource-logs-categories#microsoftdatabricksworkspaces

  enabled_log {
    category = "accounts"
  }

  enabled_log {
    category = "clusters"
  }

  enabled_log {
    category = "dbfs"
  }

  enabled_log {
    category = "instancePools"
  }

  enabled_log {
    category = "jobs"
  }

  enabled_log {
    category = "notebook"
  }

  enabled_log {
    category = "secrets"
  }

  enabled_log {
    category = "sqlPermissions"
  }

  enabled_log {
    category = "ssh"
  }

  enabled_log {
    category = "workspace"
  }

  enabled_log {
    category = "RemoteHistoryService"
  }

  enabled_log {
    category = "databrickssql"
  }

  enabled_log {
    category = "deltaPipelines"
  }

  enabled_log {
    category = "featureStore"
  }

  enabled_log {
    category = "genie"
  }

  enabled_log {
    category = "globalInitScripts"
  }

  enabled_log {
    category = "iamRole"
  }

  enabled_log {
    category = "mlflowAcledArtifact"
  }

  enabled_log {
    category = "mlflowExperiment"
  }

  enabled_log {
    category = "modelRegistry"
  }

  enabled_log {
    category = "repos"
  }

  enabled_log {
    category = "sqlanalytics"
  }

  enabled_log {
    category = "unityCatalog"
  }

  enabled_log {
    category = "gitCredentials"
  }

  enabled_log {
    category = "webTerminal"
  }

  lifecycle {
    precondition {
      condition     = var.log_analytics_workspace_id != null
      error_message = "log_analytics_workspace_id must be set when sku is set to \"premium\"."
    }
  }
}

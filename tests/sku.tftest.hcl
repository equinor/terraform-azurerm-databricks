mock_provider "azurerm" {
  source = "./tests/azurerm"
}

run "setup" {
  module {
    source = "./tests/setup"
  }
}

variables {
  workspace_name             = "example-databricks"
  resource_group_name        = run.setup.resource_group_name
  location                   = run.setup.location
  log_analytics_workspace_id = run.setup.log_analytics_workspace_id
}

run "premium_sku" {
  variables {
    sku = "premium"
  }

  assert {
    condition     = azurerm_databricks_workspace.this.sku == "premium"
    error_message = "Databricks workspace SKU should be \"premium\""
  }
}

run "trial_sku" {
  variables {
    sku = "trial"
  }

  assert {
    condition     = azurerm_databricks_workspace.this.sku == "trial"
    error_message = "Databricks workspace SKU should be \"trial\""
  }
}

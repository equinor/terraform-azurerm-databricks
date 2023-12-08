provider "azurerm" {
  features {}
}

locals {
  tags = {
    Environment = "Test"
  }
}

resource "random_id" "this" {
  byte_length = 8
}

module "log_analytics" {
  source = "github.com/equinor/terraform-azurerm-log-analytics?ref=v2.1.1"

  workspace_name      = "log-${random_id.this.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = local.tags
}

module "databricks" {
  # source = "github.com/equinor/terraform-azurerm-databricks"
  source = "../.."

  workspace_name             = "dbw-${random_id.this.hex}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  sku                        = "premium"
  log_analytics_workspace_id = module.log_analytics.workspace_id

  tags = local.tags
}

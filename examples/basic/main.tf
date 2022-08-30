provider "azurerm" {
  features {}
}

resource "random_id" "this" {
  byte_length = 8
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${random_id.this.hex}"
  location = var.location
}

module "databricks" {
  # source = "github.com/equinor/terraform-azurerm-databricks//modules/workspace"
  source = "../../modules/workspace"

  workspace_name      = "dbw-${random_id.this.hex}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

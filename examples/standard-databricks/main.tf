provider "azurerm" {
  features {}
}

resource "random_id" "this" {
  byte_length = 8
}

module "databricks" {
  # source = "github.com/equinor/terraform-azurerm-databricks"
  source = "../.."

  workspace_name      = "dbw-${random_id.this.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location
}

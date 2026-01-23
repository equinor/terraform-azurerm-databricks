# Terraform module for Databricks IAM

## Usage

```terraform
module "databricks_iam" {
  source  = "equinor/databricks/azurerm//modules/iam
  version = "~> 4.2"
  
  workspace_url = data.azurerm_databricks_workspace.example.workspace_id
  external_groups = {
    "example" = {
      external_id           = "85e19454-004b-4d13-bb08-21978c58a927" # Object ID from Entra ID
      permissions           = ["USER"]
      workspace_access      = true
      databricks_sql_access = true
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_databricks_workspace" "example" {
  name                = "example-databricks"
  resource_group_name = "example-resources"
}

provider "databricks" {
  host = module.databricks.workspace_url
}
```

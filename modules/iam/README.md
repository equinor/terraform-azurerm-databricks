# Terraform module for Azure Databricks IAM

If [Entra ID automatic identity management](https://learn.microsoft.com/en-us/azure/databricks/admin/users-groups/automatic-identity-management) is enabled for your Azure Databricks account (enabled by default after August 1, 2025), users, groups and service principals in your Entra ID tenant will be automatically synced to your account.

Use this Terraform module to assign these account-level users, groups and service principals to an Azure Databricks workspace.

## Usage

Use a [workspace-level Databricks provider](https://registry.terraform.io/providers/databricks/databricks/latest/docs) to assign account-level users, groups or service principals to your Azure Databricks workspace:

```terraform
module "databricks_iam" {
  source  = "equinor/databricks/azurerm//modules/iam"
  version = "~> 4.2"
  
  external_groups = {
    "users" = {
      external_id = "85e19454-004b-4d13-bb08-21978c58a927" # Object ID from Entra ID
    }

    "admins" = {
      external_id  = "4ddc3f27-c0b1-491e-bdba-ce0f83c65a37" # Object ID from Entra ID
      admin_access = true
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

Users, groups and service principals that are synced from Entra ID are shown as **External** in the workspace UI.

## Notes

The [`databricks_group` resource](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group) uses the old [SCIM API](https://docs.databricks.com/api/azure/workspace/groups/create) to create groups, which will not work with automatic identity management.

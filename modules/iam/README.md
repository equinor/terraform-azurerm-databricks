# Terraform module for Azure Databricks IAM

> **NOTE**: This module directly calls the Databricks IAM V2 API, which is currently in beta. As such, this module should also be considered in beta. Breaking changes may occur without notice as the underlying API and provider evolve.

Terraform module which creates Azure Databricks Identity and Access Management (IAM) resources.

If [automatic identity management](https://learn.microsoft.com/en-us/azure/databricks/admin/users-groups/automatic-identity-management) is enabled for your Azure Databricks account (enabled by default after August 1, 2025), users, groups and service principals in your Entra ID tenant will be automatically synced to your account.

Use this Terraform module to assign Entra ID users, groups and service principals to your Azure Databricks workspace.

## Prerequisites

- [Automatic enablement of Unity Catalog](https://learn.microsoft.com/en-us/azure/databricks/data-governance/unity-catalog/get-started#enablement) (enabled by default after November 9, 2023)

## Usage

Use a [workspace-level Databricks provider](https://registry.terraform.io/providers/databricks/databricks/latest/docs) to assign Entra ID users, groups and service principals to your workspace:

```terraform
module "databricks_iam" {
  source  = "equinor/databricks/azurerm//modules/iam"
  version = "~> 4.2"

  workspace_url = data.azurerm_databricks_workspace.example.workspace_url
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

provider "databricks" {
  host = data.azurerm_databricks_workspace.example.workspace_url
}

data "azurerm_databricks_workspace" "example" {
  name                = "example-databricks"
  resource_group_name = "example-resources"
}

provider "azurerm" {
  features {}
}
```

Users, groups and service principals that are synced from Entra ID are shown as **External** in the workspace UI.

## Notes

The [`databricks_group` resource](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group) uses the old [SCIM API](https://learn.microsoft.com/en-us/azure/databricks/admin/users-groups/scim/) to create groups. Using this resource with a workspace-level Databricks provider will create [legacy workspace-local groups](https://learn.microsoft.com/en-us/azure/databricks/admin/users-groups/workspace-local-groups) that will not work with automatic identity management.

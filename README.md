# Terraform module for Azure Databricks

Terraform module which creates Azure Databricks resources.

## Features

- Premium tier Databricks workspace created by default (trial tier available, which gives 14 days of free access to premium DBUs).
- Audit logs sent to given Log Analytics workspace by default.

## Prerequisites

- Azure role `Contributor` at the resource group scope.
- Azure role `Log Analytics Contributor` at the Log Analytics workspace scope.

## Usage

```terraform
provider "azurerm" {
  features {}
}

module "databricks" {
  source  = "equinor/databricks/azurerm"
  version = "~> 4.1"

  workspace_name             = "example-databricks"
  resource_group_name        = azurerm_resource_group.example.name
  location                   = azurerm_resource_group.example.location
  log_analytics_workspace_id = module.log_analytics.workspace_id
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "westeurope"
}

module "log_analytics" {
  source  = "equinor/log-analytics/azurerm"
  version = "~> 2.3"

  workspace_name      = "example-workspace"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}
```

The user or service principal that creates the Databricks workspace will be automatically assigned the workspace admin role.

### Manage identities

If [Entra ID automatic identity management](https://learn.microsoft.com/en-us/azure/databricks/admin/users-groups/automatic-identity-management) is enabled for your Databricks account (enabled by default after August 1, 2025), users, groups and service principals in your Entra ID tenant will be automatically synced to your Databricks account.

Users are automatically added at the account-level on first login (ref: [Automatically provision users](https://learn.microsoft.com/en-us/azure/databricks/security/auth/jit)). Groups should be added at the account-level by an account admin (ref: [Manage groups](https://learn.microsoft.com/en-us/azure/databricks/admin/users-groups/manage-groups)).

Use a [workspace-level Databricks provider](https://registry.terraform.io/providers/databricks/databricks/latest/docs) to assign account-level users, groups or service principals to your Databricks workspace:

```terraform
provider "databricks" {
  host = module.databricks.workspace_url
}

resource "databricks_permission_assignment" "admins" {
  group_name  = "Databricks Admins" # Entra ID group display name
  permissions = ["ADMIN"]
}

resource "databricks_permission_assignment" "users" {
  group_name  = "Databricks Users" # Entra ID group display name
  permissions = ["USER"]
}

resource "databricks_entitlements" "users" {
  group_id              = databricks_permission_assignment.users.principal_id
  workspace_access      = true
  databricks_sql_access = true
}
```

Users, groups and service principals that are synced from Entra ID are shown as **External** in the workspace UI.

Alternative approaches:

- Use the [`databricks_group` resource](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group) with an account-level provider to add an Entra ID group to your account. Requires the account admin role.
- Use the `databricks_group` resource with a workspace-level provider to create a [legacy workspace-local group](https://learn.microsoft.com/en-us/azure/databricks/admin/users-groups/workspace-local-groups). The group will show in the workspace UI, but it won't work.

It's worth noting that a workspace admin can add an Entra ID group through the workspace setting, and that group will be synced to the account. This sync from the workspace to the account will not happen if the group is created through the API using a tool like the Terraform provider. The sync can take up to 40 minutes.

## Testing

1. Initialize working directory:

    ```console
    terraform init
    ```

1. Execute tests:

    ```console
    terraform test
    ```

    See [`terraform test` command documentation](https://developer.hashicorp.com/terraform/cli/commands/test) for options.

## Contributing

See [Contributing guidelines](https://github.com/equinor/terraform-baseline/blob/main/CONTRIBUTING.md).

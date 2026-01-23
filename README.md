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

Use a [workspace-level Databricks provider](https://registry.terraform.io/providers/databricks/databricks/latest/docs) to assign account-level users, groups or service principals to your Databricks workspace:

```terraform
provider "databricks" {
  host = module.databricks.workspace_url
}

resource "databricks_token" "pat" {}

# Use IAM V2 (Beta) API to resolve the account-level group with the given object ID from Entra ID.
# If the group does not exist in the Databricks account, it will be created.
# Ref: https://docs.databricks.com/api/azure/workspace/iamv2/resolvegroupproxy
data "http" "databricks_external_group" {
  url    = "https://${module.databricks.workspace_url}/api/2.0/identity/groups/resolveByExternalId"
  method = "POST"
  request_headers = {
    "Authorization" = "Bearer ${databricks_token.pat.token_value}"
    "Content-Type"  = "application/json"
  }
  request_body = jsonencode({
    "external_id" = "85e19454-004b-4d13-bb08-21978c58a927" # Entra ID object ID
  })
}

# Assign the account-level group to the Databricks workspace.
# This will create a corresponding workspace-level group.
resource "databricks_permission_assignment" "external_group" {
  principal_id = jsondecode(data.http.databricks_external_group.response_body).group.internal_id
  permissions = ["USER"]
}

# Retrieve information about the corresponding workspace-level group.
data "databricks_group" "external_group" {
  display_name = databricks_permission_assignment.external_group.display_name
}

# Set workspace and SQL access entitlements to the workspace-level group.
resource "databricks_entitlements" "external_group" {
  group_id              = data.databricks_group.external_group.id
  workspace_access      = true
  databricks_sql_access = true
}
```

Users, groups and service principals that are synced from Entra ID are shown as **External** in the workspace UI.

The [`databricks_group` resource](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group) uses the old SCIM API.

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

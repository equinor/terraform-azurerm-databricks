# Terraform module for Azure Databricks IAM

Terraform module which creates Azure Databricks Identity and Access Management (IAM) resources.

## Usage

```terraform
module "databricks_iam" {
  source  = "equinor/databricks/azurerm//modules/iam"
  version = "~> 4.3"

  account_id = "5509fd8d-c947-406a-ab92-eeaaa8e13faf"
  service_principals = {
    "job_runner" = {
      display_name         = "job-runner"
      allow_cluster_create = true
      permissions = [
        {
          group_name        = data.databricks_group.admins.display_name
          permissions_level = "CAN_MANAGE"
        },
        {
          group_name        = data.databricks_group.users.display_name
          permissions_level = "CAN_USE"
        }
      ]
    }
  }
}

data "databricks_group" "admins" {
  display_name = "Databricks Admins"
}

data "databricks_group" "users" {
  display_name = "Databricks Users"
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

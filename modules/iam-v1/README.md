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
          group_name        = module.databricks_iam_v2.external_group_names["admin"]
          permissions_level = "CAN_MANAGE"
        },
        {
          group_name        = module.databricks_iam_v2.external_group_names["developer"]
          permissions_level = "CAN_USE"
        }
      ]
    }
  }
}
```

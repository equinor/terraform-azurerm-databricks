terraform {
  # Terraform version 1.3.0 required to set optional attributes for object type constraints
  required_version = ">= 1.3.0"

  required_providers {
    databricks = {
      source = "databricks/databricks"
      # Databricks provider version 1.131.0 required to use the "databricks_workspace_iam_external_group_v2" and "databricks_workspace_iam_external_service_principal_v2" resources
      version = ">= 1.131.0"
    }
  }
}

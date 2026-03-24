terraform {
  # Terraform version 1.3.0 required to set optional attributes for object type constraints
  required_version = ">= 1.3.0"

  required_providers {
    databricks = {
      source = "databricks/databricks"
      # Databricks provider version 1.31.0 required to use the "databricks_current_config" data source
      version = ">= 1.31.0"
    }
  }
}

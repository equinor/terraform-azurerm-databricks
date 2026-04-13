terraform {
  # Terraform version 1.3.0 required to set optional attributes for object type constraints
  required_version = ">= 1.3.0"

  required_providers {
    databricks = {
      source = "databricks/databricks"
      # Databricks provider version 1.22.0 required to use the "databricks_access_control_rule_set" resource
      version = ">= 1.22.0"
    }
  }
}

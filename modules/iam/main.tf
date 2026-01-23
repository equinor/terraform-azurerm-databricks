resource "databricks_token" "pat" {
  comment = "Provision identity and access management (IAM) resources" # TODO: improve comment
}

data "databricks_current_config" "this" {}

# Use the IAM V2 (Beta) API to resolve the account-level group with the given object ID from Entra ID.
# If the group does not exist in the Databricks account, it will be created.
# Ref: https://docs.databricks.com/api/azure/workspace/iamv2/resolvegroupproxy
data "http" "databricks_external_group" {
  for_each = var.external_groups

  method = "POST"
  url    = "https://${data.databricks_current_config.this.host}/api/2.0/identity/groups/resolveByExternalId"
  request_headers = {
    "Authorization" = "Bearer ${databricks_token.pat.token_value}"
    "Content-Type"  = "application/json"
  }
  request_body = jsonencode({
    "external_id" = each.value.external_id
  })
}

# Assign the account-level group to the Databricks workspace.
# This will create a corresponding workspace-level group.
resource "databricks_permission_assignment" "external_group" {
  for_each = data.http.databricks_external_group

  principal_id = jsondecode(each.value.response_body).group.internal_id
  permissions  = var.external_groups[each.key].admin_access ? ["USER", "ADMIN"] : ["USER"]
}

# Retrieve information about the corresponding workspace-level group.
data "databricks_group" "external_group" {
  for_each = databricks_permission_assignment.external_group

  display_name = each.value.display_name
}

# Set workspace and SQL access entitlements to the workspace-level group.
resource "databricks_entitlements" "external_group" {
  for_each = data.databricks_group.external_group
  
  group_id              = each.value.id
  workspace_access      = var.external_groups[each.key].workspace_access
  databricks_sql_access = var.external_groups[each.key].databricks_sql_access
  allow_cluster_create  = var.external_groups[each.key].allow_cluster_create
}

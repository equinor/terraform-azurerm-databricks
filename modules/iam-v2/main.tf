resource "time_rotating" "token_expiration" {
  rotation_days = 30
}

resource "databricks_token" "this" {
  comment = "Provision identity and access management (IAM) resources using Terraform"

  lifetime_seconds = time_rotating.token_expiration.rotation_days * 86400 # There are 86 400 seconds per day

  lifecycle {
    replace_triggered_by = [
      # Replace when rotation period has passed and token has expired
      time_rotating.token_expiration.rfc3339
    ]
  }
}

data "external" "current_metastore_assignment" {
  program = [
    "bash", "${path.module}/current_metastore_assignment.sh",
    var.workspace_url,
    databricks_token.this.token_value
  ]
}

data "external" "resolve_group_proxy" {
  for_each = var.groups

  program = [
    "bash", "${path.module}/resolve_group_proxy.sh",
    var.workspace_url,
    databricks_token.this.token_value,
    each.value.external_id
  ]
}

# Assign the account-level groups to the Databricks workspace.
# This will create corresponding workspace-level groups.
resource "databricks_permission_assignment" "group" {
  for_each = data.external.resolve_group_proxy

  principal_id = each.value.result.internal_id
  permissions  = var.groups[each.key].admin_access ? ["ADMIN"] : ["USER"]

  depends_on = [
    # A metastore must be assigned to the Databricks workspace before permissions can be assigned to groups.
    data.external.current_metastore_assignment
  ]
}

# Retrieve information about the corresponding workspace-level groups.
data "databricks_group" "this" {
  for_each = databricks_permission_assignment.group

  display_name = each.value.display_name
}

# Set entitlements to the workspace-level groups.
resource "databricks_entitlements" "group" {
  for_each = data.databricks_group.this

  group_id              = each.value.id
  workspace_access      = var.groups[each.key].workspace_access
  databricks_sql_access = var.groups[each.key].databricks_sql_access
  allow_cluster_create  = var.groups[each.key].allow_cluster_create
}

data "external" "resolve_service_principal_proxy" {
  for_each = var.service_principals

  program = [
    "bash", "${path.module}/resolve_service_principal_proxy.sh",
    var.workspace_url,
    databricks_token.this.token_value,
    each.value.external_id
  ]
}

# Assign the account-level service principals to the Databricks workspace.
# This will create corresponding workspace-level service principals.
resource "databricks_permission_assignment" "service_principal" {
  for_each = data.external.resolve_service_principal_proxy

  principal_id = each.value.result.internal_id
  permissions  = var.service_principals[each.key].admin_access ? ["ADMIN"] : ["USER"]

  depends_on = [
    # A metastore must be assigned to the Databricks workspace before permissions can be assigned to service principals.
    data.external.current_metastore_assignment
  ]
}

# Retrieve information about the corresponding workspace-level service principals.
data "databricks_service_principal" "this" {
  for_each = databricks_permission_assignment.service_principal

  display_name = each.value.display_name
}

# Set entitlements to the workspace-level service principals.
resource "databricks_entitlements" "service_principal" {
  for_each = data.databricks_service_principal.this

  service_principal_id  = each.value.id
  workspace_access      = var.service_principals[each.key].workspace_access
  databricks_sql_access = var.service_principals[each.key].databricks_sql_access
  allow_cluster_create  = var.service_principals[each.key].allow_cluster_create
}

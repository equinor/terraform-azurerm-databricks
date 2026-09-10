data "databricks_workspace_iam_external_group_v2" "this" {
  for_each = var.groups

  nane = "external-groups/${each.value.external_id}"
}

# Assign the account-level groups to the Databricks workspace.
# This will create corresponding workspace-level groups.
resource "databricks_permission_assignment" "group" {
  for_each = data.databricks_workspace_iam_external_group_v2.this

  principal_id = each.value.internal_id
  permissions  = var.groups[each.key].admin_access ? ["ADMIN"] : ["USER"]
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

data "databricks_workspace_iam_external_service_principal_v2" "this" {
  for_each = var.service_principals

  name = "external-service-principals/${each.value.external_id}"
}

# Assign the account-level service principals to the Databricks workspace.
# This will create corresponding workspace-level service principals.
resource "databricks_permission_assignment" "service_principal" {
  for_each = data.databricks_workspace_iam_external_service_principal_v2.this

  principal_id = each.value.internal_id
  permissions  = var.service_principals[each.key].admin_access ? ["ADMIN"] : ["USER"]
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

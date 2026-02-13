data "databricks_current_user" "this" {}

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

# Use the IAM V2 (Beta) API to resolve the account-level groups with the given object IDs from Entra ID.
# If a group does not exist in the Databricks account, it will be created.
# Ref: https://docs.databricks.com/api/azure/workspace/iamv2/resolvegroupproxy
data "http" "external_group" {
  for_each = var.external_groups

  method = "POST"
  url    = "https://${data.databricks_current_user.this.workspace_url}/api/2.0/identity/groups/resolveByExternalId"
  request_headers = {
    "Authorization" = "Bearer ${databricks_token.this.token_value}"
    "Content-Type"  = "application/json"
  }
  request_body = jsonencode({
    "external_id" = each.value.external_id
  })

  retry {
    attempts     = 5
    min_delay_ms = 1000 # 1 second
    max_delay_ms = 5000 # 5 seconds
  }
}

resource "time_sleep" "metastore_assignment" {
  # Wait for a metastore to be automatically assigned to the Databricks workspace.
  create_duration = "15m"

  triggers = {
    # If the Databricks workspace URL changes, assume that it's a new workspace and wait for a metastore to be automatically assigned to it.
    workspace_url = data.databricks_current_user.this.workspace_url
  }
}

# Assign the account-level groups to the Databricks workspace.
# This will create corresponding workspace-level groups.
resource "databricks_permission_assignment" "external_group" {
  for_each = data.http.external_group

  principal_id = jsondecode(each.value.response_body).group.internal_id
  permissions  = var.external_groups[each.key].admin_access ? ["ADMIN"] : ["USER"]

  depends_on = [
    # A metastore must be assigned to the Databricks workspace before permissions can be assigned to groups.
    time_sleep.metastore_assignment
  ]
}

# Retrieve information about the corresponding workspace-level groups.
data "databricks_group" "external_group" {
  for_each = databricks_permission_assignment.external_group

  display_name = each.value.display_name
}

# Set entitlements to the workspace-level groups.
resource "databricks_entitlements" "external_group" {
  for_each = data.databricks_group.external_group

  group_id              = each.value.id
  workspace_access      = var.external_groups[each.key].workspace_access
  databricks_sql_access = var.external_groups[each.key].databricks_sql_access
  allow_cluster_create  = var.external_groups[each.key].allow_cluster_create
}

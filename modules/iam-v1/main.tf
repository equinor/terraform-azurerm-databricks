resource "databricks_service_principal" "this" {
  for_each = var.service_principals

  display_name          = each.value.display_name
  workspace_access      = each.value.workspace_access
  databricks_sql_access = each.value.databricks_sql_access
  allow_cluster_create  = each.value.allow_cluster_create
}

locals {
  # For each Databricks service principal, convert permission objects to access control rule objects
  access_control_rules = {
    for k, sp in var.service_principals : k => [for p in sp.permissions : {
      acl_user_id              = p.user_name != null ? "users/${p.user_name}" : null
      acl_group_id             = p.group_name != null ? "groups/${p.group_name}" : null
      acl_service_principal_id = p.service_principal_name != null ? "servicePrincipals/${p.service_principal_name}" : null
      role = {
        "CAN_MANAGE" = "roles/servicePrincipal.manager"
        "CAN_USE"    = "roles/servicePrincipal.user"
      }
    }]
  }
}

resource "databricks_access_control_rule_set" "service_principal" {
  for_each = databricks_service_principal.this

  name = "accounts/${var.account_id}/servicePrincipals/${each.value.application_id}/ruleSets/default"

  grant_rules {
    principals = [for r in local.access_control_rules[each.key] : coalesce(r.acl_user_id, r.acl_group_id, r.acl_service_principal_id) if r.role == "roles/servicePrincipal.manager"]
    role       = "roles/servicePrincipal.manager"
  }

  grant_rules {
    principals = [for r in local.access_control_rules[each.key] : coalesce(r.acl_user_id, r.acl_group_id, r.acl_service_principal_id) if r.role == "roles/servicePrincipal.user"]
    role       = "roles/servicePrincipal.user"
  }
}

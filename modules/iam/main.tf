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
    for key, sp in var.service_principals : key => [for permission in sp.permissions : {
      acl_user_id              = permission.user_name != null ? "users/${permission.user_name}" : null
      acl_group_id             = permission.group_name != null ? "groups/${permission.group_name}" : null
      acl_service_principal_id = permission.service_principal_name != null ? "servicePrincipals/${permission.service_principal_name}" : null
      role = {
        "CAN_MANAGE" = "roles/servicePrincipal.manager"
        "CAN_USE"    = "roles/servicePrincipal.user"
      }[permission.permission_level]
    }]
  }
}

resource "databricks_access_control_rule_set" "service_principal" {
  for_each = databricks_service_principal.this

  name = "accounts/${var.account_id}/servicePrincipals/${each.value.application_id}/ruleSets/default"

  grant_rules {
    principals = [for rule in local.access_control_rules[each.key] : coalesce(rule.acl_user_id, rule.acl_group_id, rule.acl_service_principal_id) if rule.role == "roles/servicePrincipal.manager"]
    role       = "roles/servicePrincipal.manager"
  }

  grant_rules {
    principals = [for rule in local.access_control_rules[each.key] : coalesce(rule.acl_user_id, rule.acl_group_id, rule.acl_service_principal_id) if rule.role == "roles/servicePrincipal.user"]
    role       = "roles/servicePrincipal.user"
  }
}

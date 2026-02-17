moved {
  from = time_rotating.this
  to   = time_rotating.token_expiration
}

moved {
  from = databricks_entitlements.external_group
  to   = databricks_entitlements.group
}

moved {
  from = databricks_permission_assignment.external_group
  to   = databricks_permission_assignment.group
}

moved {
  from = databricks_entitlements.external_service_principal
  to   = databricks_entitlements.service_principal
}

moved {
  from = databricks_permission_assignment.external_service_principal
  to   = databricks_permission_assignment.service_principal
}

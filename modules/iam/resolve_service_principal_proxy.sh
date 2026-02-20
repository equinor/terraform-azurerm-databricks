#! /bin/bash
#
# Use the IAM V2 (Beta) API to resolve an account-level service principal with
# the given object ID from Entra ID. If the service principal does not exist in
# the Databricks account, it will be created.
#
# Ref: https://docs.databricks.com/api/azure/workspace/iamv2/resolveserviceprincipalproxy
#
# Usage:
#   ./resolve_service_principal_proxy.sh <WORKSPACE_URL> <TOKEN> <EXTERNAL_ID>

set -e

WORKSPACE_URL="$1"
readonly WORKSPACE_URL

API_URL="https://${WORKSPACE_URL}/api/2.0/identity/servicePrincipals/resolveByExternalId"
readonly API_URL

TOKEN="$2"
readonly TOKEN

EXTERNAL_ID="$3"
readonly EXTERNAL_ID

# If the Entra ID service principal was just created, it can a while before it
# can be resolved in Databricks.
END_TIME_SECONDS=$((SECONDS + 1800)) # 30 minutes
readonly END_TIME_SECONDS

while [[ "$SECONDS" -lt "$END_TIME_SECONDS" ]]; do
  response=$(curl --silent --show-error \
    --request POST "$API_URL" \
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/json" \
    --data "{\"external_id\": \"$EXTERNAL_ID\"}"\
    --retry 5 --retry-delay 10)

  service_principal=$(echo "$response" | jq .service_principal)
  if [[ "$service_principal" != "null" ]]; then
    echo "$service_principal" | jq '{
      internal_id: (.internal_id | tostring),
      application_id: .application_id,
      display_name: .display_name,
      external_id: .external_id
    }' 
    exit 0
  fi

  sleep 10s
done

echo "Unhandled error: $response" >&2
exit 1

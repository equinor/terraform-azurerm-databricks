#! /bin/bash
#
# Use the IAM V2 (Beta) API to resolve an account-level service principal with the given object ID from Entra ID.
# If the service principal does not exist in the Databricks account, it will be created.
#
# Ref: https://docs.databricks.com/api/azure/workspace/iamv2/resolveserviceprincipalproxy
#
# Usage:
#   ./resolve_service_principal_by_external_id.sh <WORKSPACE_URL> <TOKEN> <EXTERNAL_ID>

set -e

WORKSPACE_URL="$1"
readonly WORKSPACE_URL

API_URL="https://${WORKSPACE_URL}/api/2.0/identity/servicePrincipals/resolveByExternalId"
readonly API_URL

TOKEN="$2"
readonly TOKEN

EXTERNAL_ID="$3"
readonly EXTERNAL_ID

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

# TODO: handle error
#
# Example error:
# "{\"error_code\":\"BAD_REQUEST\",\"message\":\"ServicePrincipal with external ID c488719c-e041-4e38-b0fc-0dc004772961 not found in IdP for account 3ef43c2c-eb9a-4237-baf4-59c0e1c4dcc4.\",\"details\":[{\"@type\":\"type.googleapis.com/google.rpc.RequestInfo\",\"request_id\":\"86e7a076-db20-41e1-9c41-f27d3b08df42\",\"serving_data\":\"\"}]}"

# error_code=$(echo "$response" | jq -r .error_code)
# if [[ "$error_code" != "null" ]]; then
#   echo "known error :)"
# else 
#   echo "unknown error :("
# fi

#! /bin/bash
#
# Use the IAM V2 (Beta) API to resolve an account-level service principal with
# the given object ID from Entra ID. If the service principal does not exist in
# the Databricks account, it will be created.
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

# If the Entra ID service principal was just created, it can take a few attempts
# before it can be resolved in Databricks.
RETRY_MAX_TIME_IN_SECONDS=1800 # 30 minutes
readonly RETRY_MAX_TIME_IN_SECONDS

RETRY_DELAY_IN_SECONDS=10
readonly RETRY_DELAY_IN_SECONDS

NUMBER_OF_RETRIES=$(( RETRY_MAX_TIME_IN_SECONDS / RETRY_DELAY_IN_SECONDS ))
readonly NUMBER_OF_RETRIES

for (( i=0; i<"$NUMBER_OF_RETRIES"; i++ )); do
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

  sleep "${RETRY_DELAY_IN_SECONDS}s"
done

echo "Unhandled error after $NUMBER_OF_RETRIES retries (${RETRY_MAX_TIME_IN_SECONDS}s): $response" >&2
exit 1

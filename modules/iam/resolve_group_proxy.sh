#! /bin/bash
#
# Use the IAM V2 (Beta) API to resolve an account-level group with the given
# object ID from Entra ID. If the group does not exist in the Databricks
# account, it will be created.
#
# Ref: https://docs.databricks.com/api/azure/workspace/iamv2/resolvegroupproxy
#
# Usage:
#   ./resolve_group_proxy.sh <WORKSPACE_URL> <TOKEN> <EXTERNAL_ID>

set -e

WORKSPACE_URL="$1"
readonly WORKSPACE_URL

API_URL="https://${WORKSPACE_URL}/api/2.0/identity/groups/resolveByExternalId"
readonly API_URL

TOKEN="$2"
readonly TOKEN

EXTERNAL_ID="$3"
readonly EXTERNAL_ID

# If the Entra ID group was just created, it can take a while before it can be
# resolved in Databricks.
END_TIME_SECONDS=$((SECONDS + 1800)) # 30 minutes
readonly END_TIME_SECONDS

while [[ "$SECONDS" -lt "$END_TIME_SECONDS" ]]; do
  response=$(curl --silent --show-error \
    --request POST "$API_URL" \
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/json" \
    --data "{\"external_id\": \"$EXTERNAL_ID\"}"\
    --retry 5 --retry-delay 10)

  group=$(echo "$response" | jq .group)
  if [[ "$group" != "null" ]]; then
    echo "$group" | jq '{
      internal_id: (.internal_id | tostring),
      group_name: .group_name,
      external_id: .external_id
    }' 
    exit 0
  fi

  sleep 10s
done

echo "Unhandled error: $response" >&2
exit 1

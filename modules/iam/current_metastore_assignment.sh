#! /bin/bash
#
# Use the Unity Catalog API to get the metastore assignment for the specified
# workspace.
#
# Ref: https://docs.databricks.com/api/azure/workspace/metastores/current
#
# Usage:
#   ./current_metastore_assignment.sh <WORKSPACE_URL> <TOKEN>

set -e

WORKSPACE_URL="$1"
readonly WORKSPACE_URL

API_URL="https://${WORKSPACE_URL}/api/2.1/unity-catalog/current-metastore-assignment"
readonly API_URL

TOKEN="$2"
readonly TOKEN

# If the workspace was just created, it can take a while before a metastore has
# been assigned to it.
RETRY_MAX_TIME_IN_SECONDS=1800 # 30 minutes
readonly RETRY_MAX_TIME_IN_SECONDS

RETRY_DELAY_IN_SECONDS=10
readonly RETRY_DELAY_IN_SECONDS

NUMBER_OF_RETRIES=$(( RETRY_MAX_TIME_IN_SECONDS / RETRY_DELAY_IN_SECONDS ))
readonly NUMBER_OF_RETRIES

for (( i=0; i<"$NUMBER_OF_RETRIES"; i++ )); do
  response=$(curl --silent --show-error \
    --request GET "$API_URL" \
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/json" \
    --retry 5 --retry-delay 10)

  metastore_id=$(echo "$response" | jq -r .metastore_id)
  if [[ "$metastore_id" != "null" ]]; then
    jq --null-input --arg metastore_id "$metastore_id" '{metastore_id: $metastore_id}'
    exit 0
  fi

  sleep "${RETRY_DELAY_IN_SECONDS}s"
done

echo "Unhandled error after $NUMBER_OF_RETRIES retries (${RETRY_MAX_TIME_IN_SECONDS}s): $response" >&2
exit 1

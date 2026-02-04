#!/bin/bash

# To identify the problematic records where the country name appears inconsistently as “Vietnam” and “Viet Nam,”
# we can use the Airtable API to filter only those records and return their Record IDs.

# Airtable supports filtering through the filterByFormula parameter.
# To capture both variations, we can query for records where the Country field equals either value.

# Details:
# filterByFormula is used to search for records where the Country field matches either “Vietnam” or “Viet Nam”.
# It can be done using the filter SEARCH("viet", LOWER({Country})) to retrieve all the data containing "viet" in any form. Avoiding case sensitivity
# and pulling all the data in one go.
# The OR() function ensures both variations are included in the result.
# fields[]=id limits the response so that only the Record ID is returned, as requested.
# The API Key value (keyTpI3Yfm2TvzRTV) is passed in the Authorization header to authenticate the request.
# This query will return only the IDs of records containing the inconsistent country naming, allowing them to be reviewed and corrected.

# The API key usage was deprecated, so keyTpI3Yfm2TvzRTV can't be used anymore.
# Response: {"error":{"type":"API_KEYS_ARE_DEPRECATED","message":"Airtable API keys are deprecated and can no longer be used. To continue using Airtable's API, migrate to personal access tokens or OAuth for integrations: https://support.airtable.com/docs/airtable-api-key-deprecation-notice."}}

# Record ID row is the same than record.id, so it's a waste of storage.

# Example API request using cURL:

source .env
API_TOKEN=${TOKEN}
BASE_ID="appVOdJZYRmYKfOHM"
TABLE="AppCampaigns"

OFFSET=""
TOTAL=0
PAGE=1

# Strings to filter
WORDS=("Vietnam" "Viet Nam")

FORMULA="OR("
for w in "${WORDS[@]}"; do
  FORMULA+="{Country}='${w}',"
done
FORMULA="${FORMULA%,})"
ENCODED_FILTER=$(printf "%s" "$FORMULA" | jq -sRr @uri)

mkdir -p pages

while true; do
  RESPONSE=$(curl -s "https://api.airtable.com/v0/${BASE_ID}/${TABLE}?filterByFormula=${ENCODED_FILTER}&offset=${OFFSET}" \
    -H "Authorization: Bearer ${API_TOKEN}")

  echo "$RESPONSE" > "pages/page_${PAGE}.json"

  COUNT=$(echo "$RESPONSE" | jq '.records | length')
  TOTAL=$((TOTAL + COUNT))

  OFFSET=$(echo "$RESPONSE" | jq -r '.offset // empty')

  [ -z "$OFFSET" ] && break

  PAGE=$((PAGE + 1))
done

jq -s '{records: map(.records[] | { id: .id, Country: .fields.Country }) }' pages/page_*.json > response.json
jq -r '.records[] | [.id, .Country] | @csv' response.json > response.csv


echo "Total retrieved rows: $TOTAL"
echo "Data saved to: $(pwd)/response.csv"

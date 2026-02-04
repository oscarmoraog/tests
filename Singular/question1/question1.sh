#!/bin/bash

# To retrieve all records from the AppCampaigns table, the Data Analytics platform must
# issue an authenticated GET request to the Airtable REST API using a Personal Access Token.

# Authentication is performed via a Bearer token included in the Authorization header.
# The Airtable API returns records in JSON format and paginates results automatically for large tables

# Details:
# - BASE_ID identifies the Airtable base.
# - TABLE specifies the table to be queried.
# - The Authorization: Bearer header is used for token-based authentication.
# - The response is returned in JSON format and contains up to 100 records per request. 
# - For tables exceeding this limit, Airtable includes an offset value in the response. (It can be confirmed in the resultant file page_7.json scripts/pages/page_7.json)
# - This value can be passed as a query parameter in subsequent requests to retrieve the next page of results.
# - The client must continue requesting pages until no offset value is returned.

# Below is an example cURL request that retrieves records from the table:

source .env
API_TOKEN=${TOKEN}
BASE_ID="appVOdJZYRmYKfOHM"
TABLE="AppCampaigns"

OFFSET=""
TOTAL=0
PAGE=1

mkdir -p pages

while true; do
  RESPONSE=$(curl -s "https://api.airtable.com/v0/${BASE_ID}/${TABLE}?offset=${OFFSET}" \
    -H "Authorization: Bearer ${API_TOKEN}")

  echo "$RESPONSE" > "pages/page_${PAGE}.json"

  COUNT=$(echo "$RESPONSE" | jq '.records | length')
  TOTAL=$((TOTAL + COUNT))

  OFFSET=$(echo "$RESPONSE" | jq -r '.offset // empty')

  [ -z "$OFFSET" ] && break

  PAGE=$((PAGE + 1))
done

jq -s '{records: map(.records[]) }' pages/page_*.json > response.json

echo "Total retrieved rows: $TOTAL"
echo "Data saved to: $(pwd)/response.json"

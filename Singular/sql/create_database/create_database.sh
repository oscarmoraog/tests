#!/bin/bash

source .env
API_TOKEN=${TOKEN}
BASE_ID="appVOdJZYRmYKfOHM"
TABLE="AppCampaigns"

DB_FILE="appcampaigns.db"
JSON_FILE="full.json"

if [ -z "$API_TOKEN" ]; then
  echo "ERROR: API token not set"
  exit 1
fi

mkdir -p pages

OFFSET=""
PAGE=1

echo "Downloading Airtable data..."

while true; do
  RESPONSE=$(curl -s "https://api.airtable.com/v0/${BASE_ID}/${TABLE}?offset=${OFFSET}" \
    -H "Authorization: Bearer ${API_TOKEN}")

  echo "$RESPONSE" > "pages/page_${PAGE}.json"

  OFFSET=$(echo "$RESPONSE" | jq -r '.offset // empty')

  [ -z "$OFFSET" ] && break

  PAGE=$((PAGE + 1))
done

echo "Merging pages..."

jq -s '{records: map(.records[]) }' pages/page_*.json > $JSON_FILE

if [ ! -s "$JSON_FILE" ]; then
  echo "ERROR: JSON file is empty"
  exit 1
fi

echo "Creating SQLite database..."

sqlite3 $DB_FILE <<EOF
DROP TABLE IF EXISTS AppCampaigns;

CREATE TABLE AppCampaigns (
  date TEXT,
  source TEXT,
  app TEXT,
  platform TEXT,
  country TEXT,
  campaign_name TEXT,
  impressions INTEGER,
  clicks INTEGER,
  installs INTEGER,
  cost REAL,
  record_id TEXT
);
EOF

echo "Importing data into SQLite..."

jq -c '.records[]' $JSON_FILE | while read -r row; do

  date=$(echo "$row" | jq -r '.fields["Date"] // ""')
  source=$(echo "$row" | jq -r '.fields["Source"] // ""')
  app=$(echo "$row" | jq -r '.fields["App"] // ""')
  platform=$(echo "$row" | jq -r '.fields["Platform"] // ""')
  country=$(echo "$row" | jq -r '.fields["Country"] // ""')
  campaign=$(echo "$row" | jq -r '.fields["Campaign Name"] // ""')
  impressions=$(echo "$row" | jq -r '.fields["Impressions"] // 0')
  clicks=$(echo "$row" | jq -r '.fields["Clicks"] // 0')
  installs=$(echo "$row" | jq -r '.fields["Installs"] // 0')
  cost=$(echo "$row" | jq -r '.fields["Cost"] // 0')
  id=$(echo "$row" | jq -r '.fields["Record ID"] // .id')

  sqlite3 "$DB_FILE" <<EOF
INSERT INTO AppCampaigns VALUES (
  '$date',
  '$source',
  '$app',
  '$platform',
  '$country',
  '$campaign',
  $impressions,
  $clicks,
  $installs,
  $cost,
  '$id'
);
EOF

done


echo "Done!"
echo "SQLite database created at: $DB_FILE"

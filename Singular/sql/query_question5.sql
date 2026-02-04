-- Run this command from the terminal in sql folder:
-- sqlite3 appcampaigns.db < query_question5.sql

SELECT *
FROM AppCampaigns
WHERE Country NOT IN (
  'United States',
  'Australia',
  'France',
  'United Kingdom',
  'Switzerland',
  'Germany',
  'Canada',
  'Italy',
  'United Arab Emirates',
  'New Zealand',
  'Thailand',
  'Norway',
  'Denmark',
  'Mexico',
  'Ireland',
  'South Africa',
  'Portugal',
  'Finland',
  'Sweden',
  'Philippines',
  'Singapore',
  'Vietnam',
  'Hong Kong',
  'Malaysia',
  'Spain',
  'Israel',
  'Belgium',
  'Japan',
  'Bulgaria',
  'Greece',
  'Viet Nam',
  'Ukraine',
  'Hungary',
  'South Korea',
  'India'
);

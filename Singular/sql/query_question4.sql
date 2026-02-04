-- Run this command from the terminal in sql folder:
-- sqlite3 appcampaigns.db < query_question4.sql

SELECT
  date,
  campaign_name,
  SUM(cost) AS total_cost
FROM AppCampaigns
GROUP BY date, campaign_name
HAVING SUM(cost) > 200;

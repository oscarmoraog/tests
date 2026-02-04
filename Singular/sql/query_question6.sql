-- Run this command from the terminal in sql folder:
-- sqlite3 appcampaigns.db < query_question6.sql

SELECT *
FROM AppCampaigns
WHERE Country IN ('Vietnam', 'Viet Nam');

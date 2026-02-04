Part 1 - Working with API’s:
Scenario
You work for TapCraze, a mobile game developer.
TapCraze advertises the mobile games they develop through various media sources.

You are responsible for the AppCampaigns Database and its integrations with other internal company tools. 

The AppCampaigns database stores Campaign Data pulled from the media sources TapCraze works with.

The AppCampaigns Database is critical to the data analysis operations of the company. 

Please see the diagram below showing a basic flow of data between a Data Analytics Platform TapCraze uses and the AppCampaigns Database.

To inspect the API Documentation

- Please go to this [link](https://airtable.com/appVOdJZYRmYKfOHM/api/docs#curl/introduction)
- Use email address partners-int@singular.net 
- The password is ----
- Personal Access Token: -------

To inspect the DB Table: 

- Please go to this link https://airtable.com/shrqEQ4LXqcMSuUm8
- The password is singular123

> Please do not make any changes to this account. It’s purely for query purposes only.

Question 1:
A colleague in the Data Analytics department asks you what is the correct API call the Data Analytics platform needs to make to receive all the data in the table. 

 
Using the API documentation described here, please write an API query that will pull all the data in the table. (Optional, copy and paste a cURL request with any helpful explanations for how to achieve the desired call). 
• Please use the Personal Access Token (see above).  

> Answer in file [question1/question1.sh](question1/question1.sh)

Question 2:
Your colleague mentions that there is an issue with the data for Vietnam. They claim they are seeing Vietnam and Viet Nam.

 Using the API documentation described here, please write an API query that will pull just the problem record ID.  (Optional, copy and paste a cURL request with any helpful explanations for how to achieve the desired call). 
• Please set the API Key value as keyTpI3Yfm2TvzRTV.

> Answer in file [question2/question2.sh](question2/question2.sh)

Question 3: 

 
Your colleagues in Data Analysis are looking at a new SaaS Analytics platform called “EasyData”. They are going to need to connect to the AppCampaigns DB to pull data into EasyData. 
• This will require a “mapping” between the AppCampaigns DB, and EasyData.
• EasyData has the following built-in Python Dictionary which automaps key-value pairs:
HEADER_DICTIONARY = {
Header.RECORD-DATE:
Header.CAMPAIGN-NAME:
Header.APP:
Header.PLATFORM:
Header.MEDIASOURCE
Header.COUNTRY:
Header.IMPRESSIONS:
Header.CLICKS:
Header.INSTALLS:
Header.SPEND:
('day'),
('cn', 'campaign'),
('app_name', 'App'),
('reported_type', 'Platform', 'os', 'device'),
('mediasource'),
('geo', 'country'),
('imps', 'views', 'imp'),
('click', 'clks'),
('downloads'),
('spend')
}
USE CASE:
• There is a dimension in EasyData called RECORD-DATE. 
• Any data returned to EasyData with the key 'day' will automatically have its value pulled under the RECORD-DATE dimension.
• Other keys can be added to the dictionary, i.e. ('day','XXX'), and would automap any values associated with the key 'XXX' to RECORD-DATE.

 
Based on what you know about the structure of the AppCampaigns DB, please rewrite the HEADER_DICTIONARY to fit the response from AppCampaigns DB API, (do not delete any existing values in the dictionary). 

Answer goes here
HEADER_DICTIONARY = {
Header.RECORD-DATE:
Header.CAMPAIGN-NAME:
Header.APP:
Header.PLATFORM:
Header.MEDIASOURCE
Header.COUNTRY:
Header.IMPRESSIONS:
Header.CLICKS:
Header.INSTALLS:
Header.SPEND:
('day'),
('cn', 'campaign'),
('app_name', 'App'),
('reported_type', 'Platform', 'os', 'device'),
('mediasource'),
('geo', 'country'),
('imps', 'views', 'imp'),
('click', 'clks'),
('downloads'),
('spend')
}

> Answer in file [question3/question3.md](question3/question3.md)

Part 2 - SQL

• You need to do some manual QA on this Table.
• You’ll be using SQL to query the data. 
Please write SQL queries for the following scenarios. 

Question 4: 
• You have a daily budget of $200 per campaign. 
• No campaigns should cost more than $200 per day. If there are any, this needs to be flagged.
Please write a query that would find all campaigns that have gone over $200 Cost for one day. 

```
SELECT
  date,
  campaign_name,
  SUM(cost) AS total_cost
FROM AppCampaigns
GROUP BY date, campaign_name
HAVING SUM(cost) > 200;
```

A real sqlite database has been created for testing purpose, only need to go to folder "sql" and run this command

```
sqlite3 appcampaigns.db < query_question4.sql
```

 
Question 5: 
• TapCraze is supposed to only run campaigns in the countries listed here.
Please write a query that would find any country outside of this list:

```
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
```

or running this command in sql folder from terminal.

```
sqlite3 appcampaigns.db < query_question5.sql
```

Question 6: 
• Following on from Question 2, you found the root cause of the issue, but the Data Analytics department decided they need a fallback solution which would identify both ‘Vietnam’ and ‘Viet Nam’ as ‘Vietnam’.
Please write a simple query that would pull data for both ‘Vietnam’ and ‘Viet Nam’

```
SELECT *
FROM AppCampaigns
WHERE Country IN ('Vietnam', 'Viet Nam');
```

or running this command in sql folder from terminal.

```
sqlite3 appcampaigns.db < query_question6.sql
```

 
Part 3 - Specification Writing

 
The purpose of this task is to test your ability to: 
• Read and understand the API documentation
• Understand the required process to retrieve data
• Execute sample requests to test the API.
• Create a development specification for an R&D team member to implement.
You don't need to understand anything about the Singular platform other than the specific documentation, and what is mentioned below. 

 
TapCraze is a Singular client. You have been asked to create a working specification that can be used to explain to the TapCraze R&D team how they can pull Singular data into your system.

 
• This is the API Key you’ll need to use: 24935bcd92fe2402c31cdec99d1eeb
• These are the data values that need to be pulled as part of your initial specification:
◦ "dimensions":"source,app,
◦ "metrics": "adn_impressions,adn_clicks,
◦ "start_date":"2017-08-24",
◦ "end_date": "2017-09-04",
◦ "time_breakdown": "all",
◦ "format": "csv" 
• This is the documentation you have been provided. 

 
Question 7:   
Please write a full specification that clearly explains to R&D how this data pull should be written.  

> Answer in [question7](question7/Answer.md) folder.

Part 4 - Troubleshooting/External Communication
Scenario
TapCraze’s works with a Fraud analytics service provider called fraud.ly 1. TapCraze sends a reporting request to their servers at these times: 1. 00:00 GMT 2. 06:00 GMT 3. 12:00 GMT 4. 18:00 GMT 2. Fraud.ly reports are generated immediately and returned in JSON format.  3. Since 1 November 2021, you are seeing 404 errors from time to time when querying this data.  4. No code relating to this integration has been deployed on TapCraze’s end since 23 June 2021. 5. You sent an email to fraud.ly’s support team asking them why is the API temporarily unavailable. They responded with the following message.
We believe this issue is related to API calls being sent incorrectly from your end.

Please fix your requests. This should resolve the issue.  6. This is a log showing all the API requests made to their servers along with the status code received from fraud.ly’s servers. You always expect to see status code 200’s. 

 
Question 8:  
Please write a response back to the Fraud.ly team.
Use the information provided in the log above, along with what you know about this case to defend why you believe the issue is on their end. 

 
Answer in [question8](question8/part4.md) folder

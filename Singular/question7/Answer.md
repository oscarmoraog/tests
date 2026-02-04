# Singular Data API Integration

1. Overview

This document describes the required process and technical details for retrieving marketing performance data from the Singular Reporting API and importing it into the TapCraze internal data platform.

The goal of this initial integration is to create an automated data pull that extracts a defined set of dimensions and metrics for a specific historical date range in CSV format.

2. Authentication

All API requests must include the following API Key provided for TapCraze:

API Key:

```
24935bcd92fe2402c31cdec99d1eeb
```

All API requests require an API key. To retrieve the key, log into your account and go to Developer Tools > API Keys. You can insert the key in the api_key parameter in your request, or provide the token under an Authorization HTTP header.

Docs [link](https://support.singular.net/hc/en-us/articles/360045245692-Reporting-API-Reference#Authentication)

3. Required Data Scope

For the initial implementation, the system must retrieve the following dataset:

```
Dimensions to Retrieve
source
app
Metrics to Retrieve
adn_impressions
adn_clicks
Date Range
Start Date: 2017-08-24
End Date: 2017-09-04
Additional Parameters
Time Breakdown: all
Output Format: csv
```

4. API Request Specification

The integration should generate an HTTP request to the Singular Reporting API using the parameters above.

Sample Request Structure:
A sample request using cURL would follow this structure:

```
curl "https://api.singular.net/api/v2.0/reporting?api_key=24935bcd92fe2402c31cdec99d1eeb&dimensions=source,app&metrics=adn_impressions,adn_clicks&start_date=2017-08-24&end_date=2017-09-04&time_breakdown=all&format=csv"
```

This request will return a CSV file containing aggregated performance data for the requested date range.

5. Data Retrieval Process

The R&D implementation should follow these steps:

- Construct an HTTP GET request to the Singular Reporting API endpoint.
- Include all required parameters:
- API Key
- Dimensions
- Metrics
- Date range
- Time breakdown
- Format
- Execute the request and download the CSV response. (Store the returned file in the internal data environment).
- Parse and load the CSV data into the TapCraze database or analytics system.

6. Automation Requirements

The integration should be designed to support future automation:

The process should allow dynamic modification of:

- Date ranges
- Dimensions
- Metrics
- The system should be capable of running on a scheduled basis (e.g., daily or weekly).
- Error handling should be implemented for:
- Invalid API responses
- Network failures
- Authentication issues

7. Validation and Testing

Before moving to production, the following should be verified:

- Successful API connectivity using the provided API key
- Correct retrieval of CSV data
- Data completeness for the specified date range
- Correct mapping of dimensions and metrics
- Proper import into internal systems

8. Future Enhancements

This initial specification supports a limited dataset. Future iterations may include:

- Additional dimensions (e.g., country, platform)
- Additional metrics (e.g., installs, revenue)
- Daily incremental data pulls
- Support for JSON format
- Pagination handling if required

Conclusion

This specification provides all necessary information for the TapCraze R&D team to implement a working connection to the Singular API and retrieve performance data in CSV format.

Once implemented, this process will serve as the foundation for broader analytics integrations with the Singular platform.

Singular team.

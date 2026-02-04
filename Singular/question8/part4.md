Hi Fraud.ly Support Team,

Thank you for your response.

We have carefully reviewed the logs you provided and performed a detailed analysis of all API requests made to your service. Based on this data, we would like to clarify why we believe the issue is not caused by incorrect requests from our side.

The log demonstrates the following:

Our requests are sent in a fully consistent and automated manner at the same four times every day:
00:00, 06:00, 12:00, and 18:00 GMT.

From 27 October 2021 through 31 October 2021, all requests returned status code 200, including the 06:00 request.
This confirms that:

- Our request format is valid
- The endpoint and parameters are correct
- Our integration was functioning properly
- Starting precisely on 1 November 2021, a new and highly consistent pattern appears:

Every single day from 1 November through 6 November, the request at 06:00 GMT returns a 404 error

The exact same request at 00:00, 12:00, and 18:00 GMT on those same days returns status 200

The URL structure, parameters, and API key are identical across all calls

For example, on 2021-11-06:

- 00:00 – 200
- 06:00 – 404
- 12:00 – 200
- 18:00 – 200

This exact behavior repeats on:

- 2021-11-05
- 2021-11-04
- 2021-11-03
- 2021-11-02
- 2021-11-01

The key point is:

✔ The same request format succeeds multiple times per day
✔ The same request format fails only at one specific time of day
✔ No code changes have been deployed on our end since 23 June 2021

If the problem were due to “incorrect requests,” we would expect to see 404 errors consistently for all time slots. Instead, we see a deterministic time-based failure occurring exclusively at 06:00 GMT starting exactly on 1 November.

This strongly suggests that:

- The resource is temporarily unavailable at that time
- Data for the 06:00 time window may not yet be generated
- There may be a scheduling, caching, or backend process issue on the Fraud.ly platform
- Or a recent internal change introduced after October 31 is affecting availability

Based on this evidence, we kindly request that you investigate your internal systems for any process that could affect report availability at 06:00 GMT.

We are happy to provide any additional logs or assist with further testing if required.

Thank you for your continued support, and we look forward to your findings.

Best regards,
TapCraze Technical Team

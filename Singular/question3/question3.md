The goal is to update the existing HEADER_DICTIONARY so that it correctly maps the fields returned from the AppCampaigns DB API into the dimensions used by the EasyData platform.

According to the requirements:

- The dictionary must be rewritten to reflect the actual structure of the AppCampaigns database.
- No existing values can be removed from the original dictionary.
- We must simply add the real field names from AppCampaigns so that EasyData can automatically recognize them.
- Fields from AppCampaigns DB

The AppCampaigns database contains the following columns:

```date
source
app
platform
country
campaign name
impressions
clicks
installs
cost
record ID
```

Each of these fields needs to be associated with the correct EasyData dimension.

Based on that structure, the revised mapping becomes:

```
HEADER_DICTIONARY = {
    Header.RECORD-DATE:
        ('day', 'date'),

    Header.CAMPAIGN-NAME:
        ('cn', 'campaign', 'campaign name'),

    Header.APP:
        ('app_name', 'App', 'app'),

    Header.PLATFORM:
        ('reported_type', 'Platform', 'os', 'device', 'platform'),

    Header.MEDIASOURCE:
        ('mediasource', 'source'),

    Header.COUNTRY:
        ('geo', 'country'),

    Header.IMPRESSIONS:
        ('imps', 'views', 'imp', 'impressions'),

    Header.CLICKS:
        ('click', 'clks', 'clicks'),

    Header.INSTALLS:
        ('downloads', 'installs'),

    Header.SPEND:
        ('spend', 'cost')
}
```

All original key-value mappings were preserved as required.

The actual field names returned by the AppCampaigns API were added to the corresponding tuples. This ensures that when EasyData receives data with keys such as date, clicks, or cost, it will automatically map them to:

RECORD-DATE
CLICKS
SPEND

The field record ID was intentionally not added to the dictionary because it is a technical identifier, not a metric or analytical dimension.

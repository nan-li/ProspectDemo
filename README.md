# ProspectDemo

To update the scores on the live activity, run this cURL command in your terminal, making sure to add your own App ID and API Key (replace anything with <> surrounding it with your own values) : 
```
curl --location --request POST 'https://onesignal.com/api/v1/apps/<APP ID>/live_activities/my_activity_id/notifications' \
--header 'Authorization: Basic <API KEY>' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data-raw '{
    "event": "update",
    "event_updates": {
        "homeScore": 6,
        "awayScore": 2

    },
    "contents": {
        "en": "English Message"
    },
    "headings": {
        "en": "English Message"
    },
    "name": "Score Tracker"
}'

```

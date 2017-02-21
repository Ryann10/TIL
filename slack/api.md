#How to

[Custom integrations](https://api.slack.com/custom-integrations)

[Detail Message](https://api.slack.com/docs/message-attachments)


postMessage
----------
<b>URI = </b> [https://slack.com/api/chat.postMessage](https://slack.com/api/chat.postMessage)

```bash
{
    "token": "SLACK_API_TOKEN",
    "response_type": "in_channel",
    "text": "Ticket #123456: http://domain.com/ticket/123456",
    "attachments": [
        {
            "title": "App hangs on reboot",
            "text": "If I restart my computer without quitting your app, it stops the reboot sequence.",
        }
    ]
}
```

![posted message](https://a.slack-edge.com/7f18/img/api/gs_internal_in_channel_msg.png)
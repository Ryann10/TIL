# Alerting on SLOs

## Alerting Considerations

SLI (Service Level Indicator) 및 에러 예산에서 경고를 생성하려면 이 두 요소를 특정 규칙에 결합하는 방법이 필요합니다. 목표는 중요한 이벤트 (오류 예산의 상당 부분을 소비하는 이벤트)에 대해 통지받는 것입니다.

경고 전략을 편가하기 위해 고려해야할 특성들

*Precision*

발견된 중요한 이벤트들의 비율. 모든 경고가 중요한 이벤트에 해당하면 정밀도는 100 %입니다. 알림은 트래픽이 적은 시간에 중요하지 않은 이벤트에 특히 민감하게 반응 할 수 있습니다.

*Recall*

발견된 중요한 이벤트의 비율. 모든 중요한 이벤트가 경고를 발생시키는 경우 재현율은 100 %입니다.

*Detection time*

다양한 조건에서 알림을 보내는 데 걸리는 시간. 탐지 시간이 길면 오류 예산에 부정적인 영향을 미칠 수 있습니다.

*Reset time*

문제가 해결 된 후 알림이 지속되는 기간. 재설정 시간이 길면 혼란이나 문제가 무시 될 수 있습니다.

## Ways to Alert on Significant Events

1. Target Error Rate >= SLO Threshold

가장 간단한 솔루션의 경우 작은 시간 창(window)(예: 10분) 선택하고 해당 창에 대한 에러율이 SLO를 초과하는지 경고 할 수 있습니다.

예를 들어 SLO가 30 일 동안 99.9 % 인 경우, 이전 10분 동안의 에러율이 0.1% 이상 일 경우 경고합니다.

```
alert: HighErrorRate
expr: job:slo_errors_per_request:ratio_rate10m{job="myjob"} >= 0.001
```

#### Table 5-1. Pros and cons of alerting when the immediate error rate is too high

- Pros

Detection time is good: 0.6 seconds for a total outage.
This alert fires on any event that threatens the SLO, exhibiting good recall.

- Cons

Precision is low: The alert fires on many events that do not threaten the SLO. A 0.1% error rate for 10 minutes would alert, while consuming only 0.02% of the monthly error budget.
Taking this example to an extreme, you could receive up to 144 alerts per day every day, not act upon any alerts, and still meet the SLO.

2. Increased Alert Window

We can build upon the preceding example by changing the size of the alert window to improve precision. By increasing the window size, you spend a higher budget amount before triggering an alert.
To keep the rate of alerts manageable, you decide to be notified only if an event consumes 5% of the 30-day error budget—a 36-hour window:

```
- alert: HighErrorRate
expr: job:slo_errors_per_request:ratio_rate36h{job="myjob"} > 0.001
```

Now, the detection time is:
(1 − SLO)/error ratio × alerting window size

Table 5-2 shows the benefits and disadvantages of alerting when the error rate is too high over a larger window of time.
Table 5-2. Pros and cons of alerting when the error rate is too high over a larger window of time

- Pros

Detection time is still good: 2 minutes and 10 seconds for a complete outage.

- Cons

Better precision than the previous example: by ensuring
that the error rate is sustained for longer, an alert will
likely represent a significant threat to the error budget.
Very poor reset time: In the case of 100% outage, an alert will fire
shortly after 2 minutes, and continue to fire for the next 36 hours.
Calculating rates over longer windows can be expensive in terms of
memory or I/O operations, due to the large number of data points.
Figure 5-2 shows that while the error rate over a 36-hour period has fallen to a negligible
level, the 36-hour average error rate remains above the threshold.

3. Incrementing Alert Duration

Most monitoring systems allow you to add a duration parameter to the alert criteria so the alert won’t fire unless the value remains above the threshold for some time. You may be tempted to use this parameter as a relatively inexpensive way to add longer windows:

```
- alert: HighErrorRate
expr: job:slo_errors_per_request:ratio_rate1m{job="myjob"} > 0.001
for: 1h
```

Table 5-3 shows the benefits and disadvantages of using a duration parameter for
alerts.
Table 5-3. Pros and cons of using a duration parameter for alerts

Pros
Alerts can be higher precision.
Requiring a sustained error rate before firing means that alerts are more likely to correspond to a significant event.

Cons
Poor recall and poor detection time: Because the duration does not scale with the severity of the incident, a 100% outage alerts after one hour, the same detection time as a 0.2% outage. The 100% outage would consume 140% of the 30-day budget in that hour.
If the metric even momentarily returns to a level within SLO, the duration timer resets. An SLI that fluctuates between missing SLO and passing SLO may never alert.

For the reasons listed in Table 5-3, we do not recommend using durations as part of your SLO-based alerting criteria.
> Duration clauses can occasionally be useful when you are filtering out ephemeral noise over very short durations. However, you still need to be aware of the cons listed in this section.

4: Alert on Burn Rate

To improve upon the previous solution, you want to create an alert with good detection time and high precision. To this end, you can introduce a burn rate to reduce the
size of the window while keeping the alert budget spend constant.

Burn rate is how fast, relative to the SLO, the service consumes the error budget.
Figure 5-4 shows the relationship between burn rates and error budgets.

The example service uses a burn rate of 1, which means that it’s consuming error budget at a rate that leaves you with exactly 0 budget at the end of the SLO’s time window (see Chapter 4 in our first book). With an SLO of 99.9% over a time window of 30 days, a constant 0.1% error rate uses exactly all of the error budget: a burn rate of 1.

Table 5-4 shows burn rates, their corresponding error rates, and the time it takes to exhaust the SLO budget.

Table 5-4. Burn rates and time to complete budget exhaustion

Burn rate | Error rate for a 99.9% SLO | Time to exhaustion
1         | 0.1%                       | 30 days
2         | 0.2%                       | 15 days
10        | 1%                         | 3 days
1,000     | 100%                       | 43 minutes

By keeping the alert window fixed at one hour and deciding that a 5% error budget spend is significant enough to notify someone, you can derive the burn rate to use for
the alert.

For burn rate–based alerts, the time taken for an alert to fire is:

(1 − SLO) / error ratio × alerting window size × burn rate

The error budget consumed by the time the alert fires is:

burn rate × alerting window size / period

Five percent of a 30-day error budget spend over one hour requires a burn rate of 36.
The alerting rule now becomes:

```
- alert: HighErrorRate
expr: job:slo_errors_per_request:ratio_rate1h{job="myjob"} > 36 * 0.001
```

Table 5-5 shows the benefits and limitations of alerting based on burn rate.

Table 5-5. Pros and cons of alerting based on burn rate

Pros

Good precision: This strategy chooses a significant portion of error
budget spend upon which to alert.
Shorter time window, which is cheaper to calculate.
Good detection time.
Better reset time: 58 minutes.

Cons

Low recall: A 35x burn rate never alerts, but consumes all of the 30-day error budget in 20.5 hours.
Reset time: 58 minutes is still too long.

5. Multiple Burn Rate Alerts

Your alerting logic can use multiple burn rates and time windows, and fire alerts when burn rates surpass a specified threshold. This option retains the benefits of alerting on burn rates and ensures that you don’t overlook lower (but still significant) error rates.

It’s also a good idea to set up ticket notifications for incidents that typically go unnoticed
but can exhaust your error budget if left unchecked—for example, a 10% budget
consumption in three days. This rate of errors catches significant events, but since the
rate of budget consumption provides adequate time to address the event, you don’t
need to page someone.

We recommend 2% budget consumption in one hour and 5% budget consumption in
six hours as reasonable starting numbers for paging, and 10% budget consumption in
three days as a good baseline for ticket alerts. The appropriate numbers depend on
the service and the baseline page load. For busier services, and depending on on-call
responsibilities over weekends and holidays, you may want ticket alerts for the sixhour
window.

Table 5-6 shows the corresponding burn rates and time windows for percentages of SLO budget consumed.
Table 5-6. Recommended time windows and burn rates for percentages of SLO budget consumedr

SLO budget consumption | Time window | Burn rate | Notification
2%                     | 1 hour      | 14.4      | Page
5%                     | 6 hours     | 6         | Page
10%                    | 3 days      | 1         | Ticket

## Low-Traffic Services and Error Budget Alerting

The multiwindow, multi-burn-rate approach just detailed works well when a sufficiently high rate of incoming requests provides a meaningful signal when an issue arises. However, these approaches can cause problems for systems that receive a low rate of requests. If a system has either a low number of users or natural low-traffic periods (such as nights and weekends), you may need to alter your approach.

It’s harder to automatically distinguish unimportant events in low-traffic services. For example, if a system receives 10 requests per hour, then a single failed request results in an hourly error rate of 10%. For a 99.9% SLO, this request constitutes a 1,000x burn rate and would page immediately, as it consumed 13.9% of the 30-day error budget. This scenario allows for only seven failed requests in 30 days. Single requests can fail for a large number of ephemeral and uninteresting reasons that aren’t necessarily cost-effective to solve in the same way as large systematic outages.

The best solution depends on the nature of the service: what is the impact of a single failed request? A high-availability target may be appropriate if failed requests are oneoff, high-value requests that aren’t retried. It may make sense from a business perspective to investigate every single failed request. However, in this case, the alerting system notifies you of an error too late.

We recommend a few key options to handle a low-traffic service:

• Generate artificial traffic to compensate for the lack of signal from real users.
• Combine smaller services into a larger service for monitoring purposes.
• Modify the product so that either:
  — It takes more requests to qualify a single incident as a failure.
  — The impact of a single failure is lower.

### Generating Artificial Traffic

A system can synthesize user activity to check for potential errors and high-latency requests. In the absence of real users, your monitoring system can detect synthetic errors and requests, so your on-call engineers can respond to issues before they impact too many actual users.

Artificial traffic provides more signals to work with, and allows you to reuse your existing monitoring logic and SLO values. You may even already have most of the necessary traffic-generating components, such as black-box probers and integration tests.

Generating artificial load does have some downsides. Most services that warrant SRE support are complex, and have a large system control surface. Ideally, the system should be designed and built for monitoring using artificial traffic. Even for a nontrivial service, you can synthesize only a small portion of the total number of user request types. For a stateful service, the greater number of states exacerbates this problem.

Additionally, if an issue affects real users but doesn’t affect artificial traffic, the successful artificial requests hide the real user signal, so you aren’t notified that users see errors.

### Combining Services

If multiple low-traffic services contribute to one overall function, combining their requests into a single higher-level group can detect significant events more precisely and with fewer false positives. For this approach to work, the services must be related in some way—you can combine microservices that form part of the same product, or multiple request types handled by the same binary.

A downside to combining services is that a complete failure of an individual service may not count as a significant event. You can increase the likelihood that a failure will affect the group as a whole by choosing services with a shared failure domain, such as a common backend database. You can still use longer-period alerts that eventually catch these 100% failures for individual services.

### Making Service and Infrastructure Changes

Alerting on significant events aims to provide sufficient notice to mitigate problems before they exhaust the entire error budget. If you can’t adjust the monitoring to be less sensitive to ephemeral events, and generating synthetic traffic is impractical, you might instead consider changing the service to reduce the user impact of a single failed request. For example, you might:

- Modify the client to retry, with exponential backoff and jitter.
- Set up fallback paths that capture the request for eventual execution, which can take place on the server or on the client.

These changes are useful for high-traffic systems, but even more so for low-traffic systems: they allow for more failed events in the error budget, more signal from monitoring, and more time to respond to an incident before it becomes significant.

### Lowering the SLO or Increasing the Window

You might also want to reconsider if the impact of a single failure on the error budget accurately reflects its impact on users. If a small number of errors causes you to lose error budget, do you really need to page an engineer to fix the issue immediately? If not, users would be equally happy with a lower SLO. With a lower SLO, an engineer is notified only of a larger sustained outage.

Once you have negotiated lowering the SLO with the service’s stakeholders (for example, lowering the SLO from 99.9% to 99%), implementing the change is very simple: if you already have systems in place for reporting, monitoring, and alerting based upon an SLO threshold, simply add the new SLO value to the relevant systems.

Lowering the SLO does have a downside: it involves a product decision. Changing the SLO affects other aspects of the system, such as expectations around system behavior and when to enact the error budget policy. These other requirements may be more important to the product than avoiding some number of low-signal alerts.

In a similar manner, increasing the time window used for the alerting logic ensures alerts that trigger pages are more significant and worthy of attention.

In practice, we use some combination of the following methods to alert for low-traffic services:

- Generating fake traffic, when doing so is possible and can achieve good coverage
- Modifying clients so that ephemeral failures are less likely to cause user harm
- Aggregating smaller services that share some failure mode
- Setting SLO thresholds commensurate with the actual impact of a failed request

### Extreme Availability Goals

Services with an extremely low or an extremely high availability goal may require special consideration. For example, consider a service that has a 90% availability target. Table 5-8 says to page when 2% of the error budget in a single hour is consumed. Because a 100% outage consumes only 1.4% of the budget in that hour, this alert could never fire. If your error budgets are set over long time periods, you may need to tune your alerting parameters.

For services with an extremely high availability goal, the time to exhaustion for a 100% outage is extremely small. A 100% outage for a service with a target monthly availability of 99.999% would exhaust its budget in 26 seconds—which is smaller than the metric collection interval of many monitoring services, let alone the end-to-end time to generate an alert and pass it through notification systems like email and SMS. Even if the alert goes straight to an automated resolution system, the issue may entirely consume the error budget before you can mitigate it.

Receiving notifications that you have only 26 seconds of budget left isn’t necessarily a bad strategy; it’s just not useful for defending the SLO. The only way to defend this level of reliability is to design the system so that the chance of a 100% outage is extremely low. That way, you can fix issues before consuming the budget. For example, if you initially roll out that change to only 1% of your users, and burn your error budget at the same rate of 1%, you now have 43 minutes before you exhaust your error budget. See Chapter 16 for tactics on designing such a system.

### Alerting at Scale

When you scale your service, make sure that your alerting strategy is likewise scalable. You might be tempted to specify custom alerting parameters for individual services.
If your service comprises 100 microservices (or equivalently, a single service
with 100 different request types), this scenario very quickly accumulates toil and cognitive
load that does not scale.
In this case, we strongly advise against specifying the alert window and burn rate
parameters independently for each service, because doing so quickly becomes overwhelming.
5 Once you decide on your alerting parameters, apply them to all your
services.
One technique for managing a large number of SLOs is to group request types into
buckets of approximately similar availability requirements. For example, for a service

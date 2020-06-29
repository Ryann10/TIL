# Eliminating Toil(삽질)

> 삽질이란 매우 힘들고 고된 일.

Google SREs spend much of their time optimizing—squeezing every bit of performance from a system through project work and developer collaboration. But the scope of optimization isn’t limited to compute resources: it’s also important that SREs optimize how they spend their time. Primarily, we want to avoid performing tasks classified as toil. For a comprehensive discussion of toil, see Chapter 5 in Site Reliability Engineering. For the purposes of this chapter, we’ll define toil as the repetitive, predictable, constant stream of tasks related to maintaining a service.

Toil is seemingly unavoidable for any team that manages a production service. System maintenance inevitably demands a certain amount of rollouts, upgrades, restarts, alert triaging, and so forth. These activities can quickly consume a team if left unchecked and unaccounted for. Google limits the time SRE teams spend on operational work (including both toil- and non-toil-intensive work) at 50% (for more context on why, see Chapter 5 in our first book). While this target may not be appropriate for your organization, there’s still an advantage to placing an upper bound on toil, as identifying and quantifying toil is the first step toward optimizing your team’s time.

## What Is Toil?

Toil tends to fall on a spectrum measured by the following characteristics, which are described in our first book. Here, we provide a concrete example for each toil characteristic:

*Manual*
When the tmp directory on a web server reaches 95% utilization, engineer Anne logs in to the server and scours the filesystem for extraneous log files to delete.

*Repetitive*
A full tmp directory is unlikely to be a one-time event, so the task of fixing it is repetitive.

*Automatable*
If your team has remediation documents with content like “login to X, execute this command, check the output, restart Y if you see…,” these instructions are essentially pseudocode to someone with software development skills! In the tmp
directory example, the solution has been partially automated. It would be even better to fully automate the problem detection and remediation by not requiring a human to run the script. Better still, submit a patch so that the software no longer breaks in this way.

*Nontactical/reactive*
When you receive too many alerts along the lines of “disk full” and “server down,” they distract engineers from higher-value engineering and potentially mask other, higher-severity alerts. As a result, the health of the service suffers.

*Lacks enduring value*
Completing a task often brings a satisfying sense of accomplishment, but this repetitive satisfaction isn’t a positive in the long run. For example, closing that alert-generated ticket ensured that the user queries continued to flow and HTTP requests continued to serve with status codes < 400, which is good. However, resolving the ticket today won’t prevent the issue in the future, so the payback has a short duration.

*Grows at least as fast as its source*
Many classes of operational work grow as fast as (or faster than) the size of the underlying infrastructure. For example, you can expect time spent performing hardware repairs to increase in lock-step fashion with the size of a server fleet. Physical repair work may unavoidably scale with the number of machines, but ancillary tasks (for example, making software/configuration changes) doesn’t necessarily have to.

## Measuring Toil

How do you know how much of your operational work is toil? And once you’ve decided
to take action to reduce toil, how do you know if your efforts were successful or
justified? Many SRE teams answer these questions with a combination of experience
and intuition. While such tactics might produce results, we can improve upon them.
Experience and intuition are not repeatable, objective, or transferable. Members of the
same team or organization often arrive at different conclusions regarding the magnitude
of engineering effort lost to toil, and therefore prioritize remediation efforts differently.
Furthermore, toil reduction efforts can span quarters or even years (as
demonstrated by some of the case studies in this chapter), during which time team
priorities and personnel can change. To maintain focus and justify cost over the long
term, you need an objective measure of progress. Usually, teams must choose a toilreduction
project from several candidates. An objective measure of toil allows your
team to evaluate the severity of the problems and prioritize them to achieve maximum
return on engineering investment.
Before beginning toil reduction projects, it’s important to analyze cost versus benefit
and to confirm that the time saved through eliminating toil will (at minimum) be
proportional to the time invested in first developing and then maintaining an automated
solution (Figure 6-1). Projects that look “unprofitable” from a simplistic comparison
of hours saved versus hours invested might still be well worth undertaking
because of the many indirect or intangible benefits of automation. Potential benefits
could include:
• Growth in engineering project work over time, some of which will further reduce
toil
• Increased team morale and decreased team attrition and burnout
• Less context switching for interrupts, which raises team productivity
• Increased process clarity and standardization
• Enhanced technical skills and career growth for team members
• Reduced training time
• Fewer outages attributable to human errors
• Improved security
• Shorter response times for user requests

So how do we recommend you measure toil?

1. Identify it. Chapter 5 of the first SRE book offers guidelines for identifying the toil in your operations. The people best positioned to identify toil depend upon your organization. Ideally, they will be stakeholders, including those who will perform the actual work.
2. Select an appropriate unit of measure that expresses the amount of human effort applied to this toil. Minutes and hours are a natural choice because they are objective and universally understood. Be sure to account for the cost of context switching. For efforts that are distributed or fragmented, a different wellunderstood bucket of human effort may be more appropriate. Some examples of units of measure include an applied patch, a completed ticket, a manual production change, a predictable email exchange, or a hardware operation. As long as the unit is objective, consistent, and well understood, it can serve as a measurement of toil.
3. Track these measurements continuously before, during, and after toil reduction efforts. Streamline the measurement process using tools or scripts so that collecting these measurements doesn’t create additional toil!

1. 식별하기. 삽질을 확인하기 가장 좋은 위치에 있는 사람들은 조직에 있습니다. 이상적으로는 그들과 실제 작업(구현)을 수행하는 사람들이 이해 관계자가 될 것입니다.
2. 이 삽질에 소비되는 인간 노력의 양을 나타내는 적절한 측정 단위를 선택해야 합니다.
3. 이러한 측정을 삽질을 줄이기 위한 노력을 하기 전, 도중 및 후 모두 추적해야 합니다.

## Toil Taxonomy

삽질은 "일반적인" 엔지니어링 업무와 비슷하게 보이고, 그렇기도 하다. 이러한 삽질을 이진법으로 나누어 구분할 것이 아니라, 스펙트럼으로 생각하는 것이 도움이 된다.

### Business Processes

제일 일반적인 삽질의 원인이다.

티켓 위주의 비즈니스 프로세스는 일반적으로 목표를 달성하기 때문에 티켓 기반 비즈니스는 약간 교활합니다.

### Production Interrupts

인터럽트는 시스템을 계속 실행하는 시간에 민감한 수위 작업의 일반적인 클래스입니다.

### Release Shepherding

많은 조직에서 배포 도구는 개발에서 제품 단계로 자동으로 전환됩니다. Even with automation, thorough code coverage, code reviews, and numerous forms of automated testing, this process doesn’t always go smoothly. Depending on the tooling and release cadence, release requests, rollbacks, emergency patches, and repetitive or manual configuration changes, releases may still generate toil.

### Migrations

### Cost Engineering and Capacity Planning

### Troubleshooting for Opaque Architectures

요즘 분산 마이크로서비스 아키텍처는 일반적이다. 조직은 복잡한 분산된 추적, 높은 정확도의 모니터링, 자세한 대시보드를 구축하는데 리소스가 부족 할 수 있다. 만약 이러한 도구들이 있다고 하더라도, 모든 시스템을 이용하여 일하고 있진 않을 것이다.

자체적으로 문제를 해결하는 것이 본질적으로 나쁘지는 않지만 새로운 장애 모드에 집중하는 것을 목표로 해야 한다.—not the same type of failure every week caused by brittle system architecture. With each new critical upstream dependency of availability P, availability decreases by 1 – P due to the combined chance of failure. A four 9s service that adds nine critical four 9s dependencies is now a three 9s service.

## Toil Management Strategies

### Identify and Measure Toil

### Engineer Toil Out of the System

### Reject the Toil

### Use SLOs to Reduce Toil

### Start with Human-Backed Interfaces

### Provide Self-Service Methods

### Get Support from Management and Colleagues

### Promote Toil Reduction as a Feature

### Increase Uniformity

### Assess Risk Within Automation

### Automate Toil Response

### Use Open Source and Third-Party Tools

Look for opportunities to use or extend third-party or open source libraries to reduce development costs, or at least to help you transition to partial automation.

### Use Feedback to Improve

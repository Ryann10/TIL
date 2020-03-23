# Implementing SLOs

Service level objectives (SLOs) specify a target level for the reliability of your service. Because SLOs are key to making data-driven decisions about reliability, they’re at the core of SRE practices. In many ways, this is the most important chapter in this book.
서비스 수준 목표 (SLO)는 서비스 신뢰성에 대한 목표 수준을 지정합니다. SLO는 신뢰성에 대한 데이터 주도 결정의 핵심이기 때문에 SRE 사례의 핵심입니다. 여러면에서이 책에서 가장 중요한 장이 됩니다.

Once you’re equipped with a few guidelines, setting up initial SLOs and a process for
refining them can be straightforward. Chapter 4 in our first book introduced the
topic of SLOs and SLIs (service level indicators), and gave some advice on how to use
them.
몇 가지 가이드 라인이 준비되면 초기 SLO를 설정하고이를 수정하는 프로세스를 간단하게 수행 할 수 있습니다. 첫 번째 책의 4 장에서는 SLO 및 SLI (서비스 수준 표시기)에 대한 주제를 소개하고이를 사용하는 방법에 대한 조언을 제공했습니다.

After discussing the motivation behind SLOs and error budgets, this chapter provides a step-by-step recipe to get you started thinking about SLOs, and also some advice about how to iterate from there. We’ll then cover how to use SLOs to make effective business decisions, and explore some advanced topics. Finally, we’ll give you some examples of SLOs for different types of services and some pointers on how to create more sophisticated SLOs in specific situations.
SLO 및 오류 예산에 대한 동기를 논의한 후, 이 장에서는 SLO에 대해 생각하기 시작하기 위한 단계별 레서피와 반복하는 방법에 대한 조언을 제공합니다. 그런 다음 SLO를 사용하여 효과적인 비즈니스 의사 결정을 내리고 고급 주제를 탐구하는 방법에 대해 설명합니다. 마지막으로, 다양한 유형의 서비스에 대한 SLO의 예와 특정 상황에서보다 정교한 SLO를 작성하는 방법에 대한 몇 가지 예를 제공합니다.

## Why SREs Need SLOs

Engineers are a scarce resource at even the largest organizations. Engineering time should be invested in the most important characteristics of the most important services. Striking the right balance between investing in functionality that will win new customers or retain current ones, versus investing in the reliability and scalability that will keep those customers happy, is difficult. At Google, we’ve learned that a well-thought-out and adopted SLO is key to making data-informed decisions about the opportunity cost of reliability work, and to determining how to appropriately prioritize that work.
엔지니어는 대규모 조직에서도 희소 자원입니다. 엔지니어링 시간은 가장 중요한 서비스의 가장 중요한 특성에 투자되어야 합니다. 새로운 고객을 확보하거나 현재 고객을 유지할 수있는 기능에 투자하는 것과 올바른 고객을 유지할 수있는 안정성 및 확장성에 투자하는 것 사이에서 올바른 균형을 유지하는 것은 어렵습니다. Google은 신뢰할 수있는 업무의 기회 비용에 대한 정보에 근거한 결정을 내리고 해당 작업의 우선 순위를 적절하게 결정하는 방법을 결정할 때 잘 고려되고 채택 된 SLO가 중요하다는 것을 알게되었습니다.

SREs’ core responsibilities aren’t merely to automate “all the things” and hold the pager. Their day-to-day tasks and projects are driven by SLOs: ensuring that SLOs are defended in the short term and that they can be maintained in the medium to long term. One could even claim that without SLOs, there is no need for SREs.
SRE의 핵심 책임은 단순히 "모든 것"을 자동화하고 무선 호출기를 들고있는 것이 아닙니다. 그들의 일상 업무 및 프로젝트는 SLO에 의해 주도됩니다. SLO가 단기적으로 방어되고 중장기 적으로 유지 될 수 있도록 보장합니다. 심지어 SLO가 없다면 SRE가 필요 없다고 주장 할 수도 있습니다.

SLOs are a tool to help determine what engineering work to prioritize. For example, consider the engineering tradeoffs for two reliability projects: automating rollbacks and moving to a replicated data store. By calculating the estimated impact on our error budget, we can determine which project is most beneficial to our users. See the section “Decision Making Using SLOs and Error Budgets” on page 37 for more detail on this, and “Managing Risk” in Site Reliability Engineering.
SLO는 우선 순위를 정하는 엔지니어링 작업을 결정하는 데 도움이되는 도구입니다. 예를 들어 롤백 자동화 및 복제 된 데이터 저장소로 이동하는 두 가지 안정성 프로젝트에 대한 엔지니어링 상충 관계를 고려해보십시오. 오류 예산에 대한 예상 영향을 계산하여 사용자에게 가장 도움이되는 프로젝트를 결정할 수 있습니다. 이에 대한 자세한 내용은 37 페이지의 "SLO 및 오류 예산을 사용하여 의사 결정"섹션을 참조하고 사이트 신뢰성 엔지니어링의 "위험 관리"를 참조하십시오.

## Getting Started

As a starting point for establishing a basic set of SLOs, let’s assume that your service is some form of code that has been compiled and released and is running on networked infrastructure that users access via the web. Your system’s maturity level might be one of the following:
기본적인 SLO 세트를 만들기위한 출발점으로, 귀하의 서비스는 컴파일되고 릴리스되어 사용자가 웹을 통해 액세스하는 네트워크 인프라에서 실행되는 코드 형태라고 가정 해 봅시다. 시스템의 완성도는 다음 중 하나 일 수 있습니다.

- A greenfield development, with nothing currently deployed
- A system in production with some monitoring to notify you when things go awry, but no formal objectives, no concept of an error budget, and an unspoken goal of 100% uptime
- A running deployment with an SLO below 100%, but without a common understanding about its importance or how to leverage it to make continuous improvement choices—in other words, an SLO without teeth
- 아무것도 배포되지 않은 그린 필드 상태
- 문제가 발생했을 때 사용자에게 알려주는 일부 모니터링 기능을 갖춘 시스템이지만 정식 목표는 없으며, 에러 예산 개념은 없고, 암묵적인 100% 업타임 목표를 가진 상태
- SLO가 100 % 미만인 실행중인 배포이지만 그 중요성이나, 지속적인 개선 선택을 위해 이를 활용하는 방법에 대해 공통적으로 이해하지 못한 상태. 다른 말로 이 없는 SLO

In order to adopt an error budget-based approach to Site Reliability Engineering, you need to reach a state where the following hold true:
사이트 신뢰성 엔지니어링에 대한 에러 예산 기반 접근 방식을 채택하려면 다음 사항이 충족되는 상태에 도달해야합니다.

- There are SLOs that all stakeholders in the organization have approved as being fit for the product.
- The people responsible for ensuring that the service meets its SLO have agreed that it is possible to meet this SLO under normal circumstances.
- The organization has committed to using the error budget for decision making and prioritizing. This commitment is formalized in an error budget policy.
- There is a process in place for refining the SLO.
- 조직의 모든 이해 관계자가 제품에 적합하다고 승인 한 SLO가 있습니다.
- 서비스가 SLO를 충족하는지 확인하는 책임이 있는 사람들은 정상적인 상황에서이 SLO를 충족시킬 수 있음에 동의했습니다.
- 조직은 의사 결정 및 우선 순위 결정에 오류 예산을 사용하기로 약속했습니다. 이 약속은 오류 예산 정책에서 공식화됩니다.
- SLO를 개선하기 위한 프로세스가 있습니다.

Otherwise, you won’t be able to adopt an error budget–based approach to reliability. SLO compliance will simply be another KPI (key performance indicator) or reporting metric, rather than a decision-making tool.
그렇지 않으면 안정성에 대한 오류 예산 기반 접근 방식을 채택 할 수 없습니다. SLO 준수는 의사 결정 도구가 아닌 다른 KPI (키 성능 지표) 또는 보고 메트릭이 될 뿐입니다.

### Reliability Targets and Error Budgets

The first step in formulating appropriate SLOs is to talk about what an SLO should be, and what it should cover.
적절한 SLO를 공식화하는 첫 번째 단계는 SLO가 무엇인지, 그리고 무엇을 다루어야 하는지에 대해 이야기하는 것입니다.

An SLO sets a target level of reliability for the service’s customers. Above this threshold, almost all users should be happy with your service (assuming they are otherwise happy with the utility of the service). Below this threshold, users are likely to start complaining or to stop using the service. Ultimately, user happiness is what matters—happy users use the service, generate revenue for your organization, place low demands on your customer support teams, and recommend the service to their friends. We keep our services reliable to keep our customers happy.
SLO는 서비스 고객을 위한 목표 수준의 신뢰성을 설정합니다. 이 임계 값을 초과하면 거의 모든 사용자가 서비스에 만족해야합니다 (서비스 이용에 만족한다고 가정) . 이 임계 값 미만이면 사용자가 서비스를 불평하거나 사용하지 않기 시작할 수 있습니다. 궁극적으로 사용자의 행복은 중요한 요소입니다. 행복한 사용자는 서비스를 사용하고 조직의 수익을 창출하며 고객 지원 팀에 대한 요구를 낮추고 친구들에게 서비스를 추천합니다. 우리는 고객의 행복을 위해 신뢰할 수있는 서비스를 제공합니다.

Customer happiness is a rather fuzzy concept; we can’t measure it precisely. Often we have very little visibility into it at all, so how do we begin? What do we use for our first SLO?
고객의 행복은 다소 애매한 개념이다; 우리는 정확히 측정할 수 없다. 고객의 행복에 있어서 우리는 매우 작은 시야를 가지고 있다, 따라서 우리는 어떻게 시작해야 할까? 첫 번째 SLO를 위해 어떤 것을 사용해야 할까?

Our experience has shown that 100% reliability is the wrong target:
우리의 경험에 의하면 100% 신뢰성이란 틀린 대상이다:

- If your SLO is aligned with customer satisfaction, 100% is not a reasonable goal. Even with redundant components, automated health checking, and fast failover, there is a nonzero probability that one or more components will fail simultaneously, resulting in less than 100% availability.
> SLO가 고객 만족도에 부합한다면 100 %는 합당한 목표는 아닙니다. 중복 구성 요소, 자동화 된 상태 확인 및 빠른 장애 조치 (failover)가 있더라도 하나 이상의 구성 요소가 동시에 실패하여 100 % 미만의 가용성을 초래할 확률은 0이 아닙니다.
- Even if you could achieve 100% reliability within your system, your customers would not experience 100% reliability. The chain of systems between you and your customers is often long and complex, and any of these components can fail. This also means that as you go from 99% to 99.9% to 99.99% reliability, each extra nine comes at an increased cost, but the marginal utility to your customers steadily approaches zero.
> 시스템 내에서 100 % 신뢰성을 달성 할 수 있다고 하더라도 고객은 100 % 안정성을 경험하지 못할 것입니다. 고객과 고객 사이의 시스템 체인은 길고 복잡하며 종종 이러한 구성 요소 중 하나라도 실패 할 수 있습니다. 이것은 99 %에서 99.9 %의 신뢰도에서 99.99 %의 신뢰도로 갈수록 각각의 추가 9는 증가 된 비용에 도달하지만 고객에 대한 한계 효용은 꾸준히 0에 접근한다는 것을 의미합니다.
- If you do manage to create an experience that is 100% reliable for your customers, and want to maintain that level of reliability, you can never update or improve your service. The number one source of outages is change: pushing new features, applying security patches, deploying new hardware, and scaling up to meet customer demand will impact that 100% target. Sooner or later, your service will stagnate and your customers will go elsewhere, which is not great for anyone’s bottom line.
> 고객에게 100 % 신뢰할 수있는 경험을 창출하고 해당 수준의 안정성을 유지하려는 경우 서비스를 업데이트하거나 개선 할 수 없습니다. 새로운 기능을 적용하고, 보안 패치를 적용하고, 새로운 하드웨어를 배치하고, 고객 요구를 충족시키기 위해 확장하는 것은 100 % 목표에 영향을 미칩니다. 조만간 서비스가 정체되고 고객이 다른 곳으로 이동하게됩니다. 이는 어느 누구의 수익에도 좋지 않다.
- An SLO of 100% means you only have time to be reactive. You literally cannot do anything other than react to < 100% availability, which is guaranteed to happen. Reliability of 100% is not an engineering culture SLO—it’s an operations team SLO.
> 100 %의 SLO는 사용자가 반응하는 시간 만 가질 수 있음을 의미합니다. 말 그대로, <100 % 가용성에 반응하는 것 이외의 일은 할 수 없으며, 이는 보장됩니다. 100 % 신뢰도는 엔지니어링 문화권 SLO가 아닙니다. 이것은 운영 팀의 SLO입니다.

Once you have an SLO target below 100%, it needs to be owned by someone in the organization who is empowered to make tradeoffs between feature velocity and reliability. In a small organization, this may be the CTO; in larger organizations, this is normally the product owner (or product manager).
100% 미만의 SLO 목표를 얻은 후에는 조직의 누군가가 기능 속도와 안정성 간의 균형을 유지하도록 권한을 부여 받아야합니다. 소규모 조직의 경우 CTO 일 수 있습니다. 대규모 조직에서는 일반적으로 제품 소유자 (또는 제품 관리자)입니다.

### What to Measure: Using SLIs

Once you agree that 100% is the wrong number, how do you determine the right number? And what are you measuring, anyway? Here, service level indicators come into play: an SLI is an indicator of the level of service that you are providing.
100%가 잘못된 숫자라는 데 동의하면 어떻게 올바른 숫자를 결정 할 수 있을까요? 그리고 당신은 어떤 것을 측정하고 있습니까? 여기서 서비스 수준 척도(SLI)가 작동합니다. SLI는 귀하가 제공하는 서비스 수준의 지표입니다.

While many numbers can function as an SLI, we generally recommend treating the SLI as the ratio of two numbers: the number of good events divided by the total number of events. For example:
많은 숫자들이 SLI로 동작할 수 있지만, 우리는 일반적으로 두 숫자의 비율을 SLI로 다루기를 추천한다: 성공한 이벤트의 수를 총 이벤트 수로 나눈 값. 예를 들어:

- Number of successful HTTP requests / total HTTP requests (success rate)
> 성공한 HTTP 요청 수 / 총 HTTP 요청 (성공률)
- Number of gRPC calls that completed successfully in < 100 ms / total gRPC requests
> 총 gRPC 요청 중 100ms 미만으로 성공적으로 완료된 gRPC 호출 수 / 총 gRPC 요청 수
- Number of search results that used the entire corpus / total number of search results, including those that degraded gracefully
> 전체 자료를 사용한 검색 결과의 수 / 정상적으로 성능이 저하 된 것을 포함하여 총 검색 결과 수
- Number of “stock check count” requests from product searches that used stock data fresher than 10 minutes / total number of stock check requests
> 10 분 이상 경과 된 재고 데이터를 사용한 제품 검색에서의 "재고 확인 요청"요청 수 / 총 재고 확인 요청 수
- Number of “good user minutes” according to some extended list of criteria for that metric / total number of user minutes
> 해당 메트릭에 대한 확장 된 기준 목록 / 총 사용자 분 수에 따라 "양호한 사용자 분"수

SLIs of this form have a couple of particularly useful properties. The SLI ranges from 0% to 100%, where 0% means nothing works, and 100% means nothing is broken. We have found this scale intuitive, and this style lends itself easily to the concept of an error budget: the SLO is a target percentage and the error budget is 100% minus the SLO. For example, if you have a 99.9% success ratio SLO, then a service that receives 3 million requests over a four-week period had a budget of 3,000 (0.1%)
이 양식의 SLI에는 특히 유용한 두 가지 속성이 있습니다. SLI의 범위는 0 %에서 100 %까지이며 0%는 아무것도 동작하지 못함을 의미하고, 100%는 아무 것도 고장나지 않았음을 의미합니다. 우리는 이 등급(sclae)을 직관적으로 발견했으며, 이 스타일은 에러 예산이라는 개념에 쉽게 적합합니다.
SLO는 목표 백분율이고 오류 예산은 SLO를 100% 뺀 값입니다. 예를 들어, SLO 성공률이 99.9%인 경우 4주 동안 3백만 건의 요청을 받는 서비스는 해당 기간 동안 3,000(0.1 %)의 오류 예산을가집니다. 하나의 중단으로 인해 1,500 개의 오류가 발생하면 해당 오류 비용은 오류 예산의 50%입니다.

In addition, making all of your SLIs follow a consistent style allows you to take better advantage of tooling: you can write alerting logic, SLO analysis tools, error budget calculation, and reports to expect the same inputs: numerator, denominator, and threshold. Simplification is a bonus here.
또한 모든 SLI를 일관된 스타일로 만들면 툴링의 장점을 활용할 수 있습니다. 경고 논리, SLO 분석 도구, 오류 예산 계산 및 보고서를 작성하여 동일한 입력 (분자, 분모 및 임계 값)을 기대할 수 있습니다. 단순화는 여기에 보너스입니다.

When attempting to formulate SLIs for the first time, you might find it useful to further divide SLIs into SLI specification and SLI implementation:
처음으로 SLI를 공식화하려고 시도 할 때 SLI를 SLI 사양(SLI specification) 및 SLI 구현(SLI Implementation)으로 더 나누는 것이 유용 할 수 있습니다:

#### SLI specification

The assessment of service outcome that you think matters to users, independent of how it is measured.
사용자가 중요하다고 생각하는 서비스 결과 평가 방법이며, 측정 방법과는 무관합니다.

For example: Ratio of home page requests that loaded in < 100 ms
예를 들어, <100ms 내에 로드 된 홈 페이지 요청 비율

#### SLI implementation

The SLI specification and a way to measure it.
SLI specification과 측정 방법

예를 들어,

- Ratio of home page requests that loaded in < 100 ms, as measured from the Latency column of the server log. This measurement will miss requests that fail to reach the backend.
- 서버 로그의 대기열에서 측정 된 <100ms 내에 로드 된 홈 페이지 요청 비율. 이 측정은 백엔드에 도달하지 못한 요청을 놓치게됩니다.
- Ratio of home page requests that loaded in < 100 ms, as measured by probers that execute JavaScript in a browser running in a virtual machine. This measurement will catch errors when requests cannot reach our network, but may miss issues that affect only a subset of users.
- 가상 컴퓨터에서 실행중인 브라우저에서 JavaScript를 실행하는 프로버가 측정 한 <100ms 내에 로드 된 홈 페이지 요청 비율입니다. 이 측정은 요청이 Google 네트워크에 도달 할 수 없을 때 오류를 잡아 내지 만 사용자의 하위 집합에만 영향을 미치는 문제를 놓칠 수 있습니다.
- Ratio of home page requests that loaded in < 100 ms, as measured by instrumentation in the JavaScript on the home page itself, and reported back to a dedicated telemetry recording service. This measurement will more accurately capture the user experience, although we now need to modify the code to capture this information and build the infrastructure to record it—a specification that has its own reliability requirements.
- 홈 페이지 자체의 자바 스크립트에서 계측으로 측정 한 <100ms 내에로드 된 홈 페이지 요청 비율이며 전용 원격 측정 기록 서비스에 다시보고됩니다. 이 측정은 코드를 수정하여 이 정보를 캡처하고 이를 기록하기위한 인프라를 구축해야합니다. 즉, 자체 안정성 요구 사항이있는 사양입니다.

As you can see, a single SLI specification might have multiple SLI implementations, each with its own set of pros and cons in terms of quality (how accurately they capture the experience of a customer), coverage (how well they capture the experience of all customers), and cost.
보시다시피, 하나의 SLI 사양에는 여러 SLI 구현이있을 수 있습니다. 퀄리티(how accurately they capture the experience of a customer), 커버리지(how well they capture the experience of all customers)와 비용에 있어서 각각의 장단점을 가지고 있다.

Your first attempt at an SLI and SLO doesn’t have to be correct; the most important goal is to get something in place and measured, and to set up a feedback loop so you can improve. (We dive deeper into this topic in “Continuous Improvement of SLO Targets” on page 34.)
SLI 및 SLO에서의 첫 시도는 정확할 필요가 없습니다. 가장 중요한 목표는 무언가를 얻고 측정하고 피드백 루프를 설정하여 개선 할 수 있도록 하는 것입니다. (34 페이지의 "SLO 대상의 지속적인 개선"에서이 주제에 대해 자세히 설명합니다).

In our first book, we advise against picking an SLO based upon current performance, because this can commit you to unnecessarily strict SLOs. While that advice is true, your current performance can be a good place to start if you don’t have any other information, and if you have a good process for iterating in place (which we’ll cover later). However, don’t let current performance limit you as you refine your SLO: your customers will also come to expect your service to perform at its SLO, so if your service returns successful requests 99.999% of the time in less than 10 ms, any significant regression from that baseline may make them unhappy.
첫 번째 책에서는 불필요하게 엄격한 SLO를 제공 할 수 있기 때문에 현재 성능을 기준으로 SLO를 선택하지 않는 것이 좋다고 조언했습니다. 이 조언이 사실이지만 다른 정보가 없거나 나중에 반복 할 수 있는 좋은 프로세스가 있다면 현재 성능을 기반으로 시작할 수 있습니다. 그러나 SLO를 조정할 때 현재 성능을 제한하지 마십시오. 고객도 서비스가 SLO에서 수행 될 것으로 기대할 수 있으므로 서비스가 10 밀리 초 미만의 시간 동안 99.999 %의 성공한 요청을 반환하면 그 기준선으로부터의 상당한 회귀는 그들을 불행하게 만들 수 있습니다.

To create your first set of SLOs, you need to decide upon a few key SLI specifications that matter to your service. Availability and latency SLOs are pretty common; freshness, durability, correctness, quality, and coverage SLOs also have heir place (we’ll talk more about those later).
첫 번째 SLO 세트를 만들려면 서비스에 중요한 몇 가지 주요 SLI 사양을 결정해야합니다. 가용성 및 대기 시간 SLO는 매우 일반적입니다. 신선도, 내구성, 정확성, 품질 및 적용 범위 SLO에도 관련성이 있습니다.

If you are having trouble figuring out what sort of SLIs to start with, it helps to start simple:
SLI의 종류를 알아내는 데 어려움이있는 경우 간단하게 시작하는 것이 좋습니다.

예를 들어,

- Choose one application for which you want to define SLOs. If your product comprises many applications, you can add those later.
- SLO를 정의하려는 응용 프로그램을 하나 선택하십시오. 제품이 많은 응용 프로그램으로 구성된 경우 나중에 추가 할 수 있습니다.
- Decide clearly who the “users” are in this situation. These are the people whose happiness you are optimizing.
- 이 상황에 "사용자"가 누구인지 명확히 결정하십시오. 이들은 당신이 행복을 최적화할 대상입니다.
- Consider the common ways your users interact with your system—common tasks and critical activities.
- 사용자가 시스템과 공통적으로 상호작용하는 일반적인 작업과 중요한 작업 방법들을 고려하십시오.
- Draw a high-level architecture diagram of your system; show the key components, the request flow, the data flow, and the critical dependencies. Group these components into categories listed in the following section (there may be some overlap and ambiguity; use your intuition and don’t let perfect be the enemy of the good).
- 시스템의 고수준 아키텍처 다이어그램 그리기. 주요 구성 요소, 요청 흐름, 데이터 흐름 및 중요한 종속성을 보여줍니다. 이 구성 요소를 다음 섹션에 나열된 범주로 그룹화하십시오 (일부 중복 및 모호함이있을 수 있습니다. 직감을 사용하고 완벽하게 할 필요는 없습니다).

You should think carefully about exactly what you select as your SLIs, but you also shouldn’t overcomplicate things. Especially if you’re just starting your SLI journey, pick an aspect of your system that’s relevant but easy to measure—you can always iterate and refine later.
SLI로 선택하는 것에 대해 신중하게 생각해야하지만, 너무 복잡해서는 안됩니다.
특히 SLI 여행을 방금 시작한 경우 관련성이 있지만 측정하기 쉬운 시스템 측면을 선택하십시오. 나중에 언제든지 반복하고 수정할 수 있습니다.

### Types of components

The easiest way to get started with setting SLIs is to abstract your system into a few common types of components. You can then use our list of suggested SLIs for each component to choose the ones most relevant to your service:
SLI를 설정하는 가장 쉬운 방법은 시스템을 몇 가지 일반적인 유형의 구성 요소로 추상화하는 것입니다. 그런 다음 각 구성 요소에 대한 권장 SLI 목록을 사용하여 서비스와 가장 관련이있는 SLI를 선택할 수 있습니다:

#### Request-driven

The user creates some type of event and expects a response. For example, this could be an HTTP service where the user interacts with a browser or an API for a mobile application.
사용자는 일정 유형의 이벤트를 생성하고 응답을 기대합니다. 예를 들어 사용자가 브라우저 나 모바일 애플리케이션 용 API와 상호 작용하는 HTTP 서비스 일 수 있습니다.

#### Pipeline

A system that takes records as input, mutates them, and places the output somewhere else. This might be a simple process that runs on a single instance in real time, or a multistage batch process that takes many hours. Examples include:
레코드를 입력으로 사용하고, 변경하고, 출력을 다른 곳에 배치하는 시스템입니다. 이는 단일 인스턴스에서 실시간으로 실행되는 간단한 프로세스이거나 여러 시간이 걸리는 다단계 배치 프로세스 일 수 있습니다. 예를 들어,

- A system that periodically reads data from a relational database and writes it
into a distributed hash table for optimized serving
- 관계형 데이터베이스에서 주기적으로 데이터를 읽고 최적화 된 검색을 위해 분산 해시 테이블에 씁니다.
- A video processing service that converts video from one format to another
- 한 형식에서 다른 형식으로 비디오를 변환하는 비디오 처리 서비스
- A system that reads in log files from many sources to generate reports
- 보고서를 생성하기 위해 여러 소스에서 로그 파일을 읽는 시스템
- A monitoring system that pulls metrics from remote servers and generates time series and alerts
- 원격 서버의 메트릭을 가져 와서 시계열 및 경고를 생성하는 모니터링 시스템

#### 스토리지

A system that accepts data (e.g., bytes, records, files, videos) and makes it available to be retrieved at a later date.
데이터 (예 : 바이트, 레코드, 파일, 비디오)를 받아들이고 나중에 검색 할 수 있도록 해주는 시스템입니다.

## A Worked Example

아래의 단순한 모바일 폰 게임 아키텍쳐를 고려해보자.

![2-1](https://lh3.googleusercontent.com/rrkV4P80fs79CERP-gUqSJE6ip8xZUtM-UL_3q684SD3yv5jYyaL84zTN9wAQQVz1VWpiw=s85)

사용자의 휴대 전화에서 실행되는 앱은 클라우드에서 실행되는 HTTP API와 상호 작용합니다. API는 영구 저장소 시스템에 상태 변경을 기록합니다. 파이프 라인은 이 데이터를 주기적으로 실행하여 오늘, 이번 주 및 모든 시간에 높은 점수를 제공하는 리그 테이블을 생성합니다. 이 데이터는 별도의 리그 테이블 데이터 저장소에 기록되며 결과는 모바일 앱 (게임 내 점수 용)과 웹 사이트를 통해 제공됩니다.
사용자는 API를 통해 높은 점수 웹 사이트에서 사용자 데이터 표에 사용되는 커스텀 아바타를 업로드 할 수 있습니다.

이 설정을 통해 사용자가 시스템과 상호 작용하는 방식과 사용자 경험의 다양한 측면을 측정 할 SLI의 종류를 생각할 수 있습니다.
이러한 SLI 중 일부는 겹칠 수 있습니다. 요청 기반 서비스가 정확성에 관한 SLI를 가지고 파이프 라인은 가용성, 내구성 SLI가 정확성 SLI의 변형으로 간주 될 수 있습니다. 고객에게 가장 중요한 기능을 나타내는 소수의 SLI 유형 (5 개 이하)을 선택하는 것이 좋습니다.

일반적인 사용자 경험과 그 긴 꼬리까지 모두 포착하기 위해 SLI 유형에 따라 여러 등급의 SLO를 사용하는 것이 좋습니다. 예를 들어, 90 %의 사용자 요청이 100ms 이내에 반환되지만 나머지 10 %는 10 초가 걸리는 경우 많은 사용자가 불만을 느낍니다. 대기 시간 SLO는 여러 임계 값을 설정하여이 사용자 베이스를 포착 할 수 있습니다: 요청의 90%는 100ms보다 빠르며 요청의 99 %는 400ms보다 빨라야 한다. 이 원칙은 사용자 불만을 측정하는 매개 변수가 있는 모든 SLI에 적용됩니다.

#### 다양한 유형의 구성 요소에 대한 잠재적 SLI들

- Request-driven
  - Availability
    - 성공적인 응답을 초래 한 요청의 비율
  - Latency
    - 어떤 임계값보다 빨랐던 요청의 비율
  - Quality
    - If the service degrades gracefully when overloaded or when backends are unavailable, you need to measure the proportion of responses that were served in an undegraded state. For example, if the User Data store is unavailable, the game is still playable but uses generic imagery.
    > 과부하가 발생했거나 백엔드를 사용할 수없는 경우 서비스가 정상적으로 성능이 저하 된 경우에는 성능이 저하되지 않은 상태로 제공 된 응답의 비율을 측정해야합니다. 예를 들어 사용자 데이터 저장소를 사용할 수없는 경우 게임은 계속 재생할 수 있지만 일반 이미지를 사용합니다.
- Pipeline
  - Freshness
    - 일정 시간보다 최근에 업데이트 된 데이터의 비율. 이상적으로이 측정 항목은 사용자가 데이터에 액세스 한 횟수를 계산하므로 사용자 환경을 가장 정확하게 반영합니다.
  - Correctness
    - 파이프 라인에 들어오는 정확한 비율로 나오는 레코드의 비율.
  - Coverage
    - 배치 프로세싱 작업에 있어서, 일부 목표량을 초과하여 처리 한 작업의 비율. 스트리밍 처리의 경우 일부 시간 창 내에서 성공적으로 처리 된 들어오는 레코드의 비율입니다.
- Storage
  - Durability
    - 성공적으로 읽을 수있는 쓰여진 기록의 비율. 내구성(durability) SLI에 특히 주의해야한다: 사용자가 원하는 데이터는 저장된 데이터의 일부일 수 있습니다. 예를 들어, 이전 10년 동안 10 억개의 레코드를 기록하고 있지만, 사용자는 (사용할 수 없는) 오늘부터 기록만을 원할수도 있다, 이 경우 그들은 거의 모든 데이터를 읽을 수 있음에도 불행이라 생각할 것이다.

## Moving from SLI specification to SLI Implmentation

Now that we know our SLI specifications, we need to start thinking about how to implement them.
이제 우리는 SLI 사양을 알고 있으므로 구현 방법에 대해 생각해 봐야합니다.

For your first SLIs, choose something that requires a minimum of engineering work. If your web server logs are already available, but setting up probes would take weeks and instrumenting your JavaScript would take months, use the logs.
첫 번째 SLI의 경우 최소한의 엔지니어링 작업이 필요한 사항을 선택하십시오. 웹 서버 로그를 이미 사용할 수 있지만 프로브를 설정하는 데 몇 주가 걸리고 자바 스크립트를 설치하는 데 몇 주가 걸리면 로그를 사용하십시오.

SLI를 측정 할 수있는 충분한 정보가 필요합니다. 가용성을 위해서는 성공 / 실패 상태가 필요합니다. 느린 요청의 경우 요청을 처리하는 데 필요한 시간이 필요합니다. 이 정보를 기록하려면 웹 서버를 다시 구성해야합니다. 클라우드 기반 서비스를 사용하는 경우이 정보 중 일부는 이미 모니터링 대시 보드에서 사용할 수 있습니다.
You need enough information to measure the SLI: for availability, you need the success/failure status; for slow requests, you need the time taken to serve the request. You may need to reconfigure your web server to record this information. If you’re using a cloud-based service, some of this information may already be available in a monitoring dashboard.

There are various options for SLI implementations for our example architecture, each with its own pros and cons. The following sections detail SLIs for the three types of components in our system.
예제 아키텍처에는 SLI 구현을위한 다양한 옵션이 있습니다. 각각의 장점과 단점이 있습니다. 다음 섹션에서는 시스템의 세 가지 유형의 구성 요소에 대한 SLI를 자세히 설명합니다.

### API and HTTP server availability and latency

모든 고려 된 SLI 구현에 대해 우리는 응답 성공을 HTTP 상태 코드를 기반으로합니다. 5XX 응답은 SLO에 대해 계산되지만 다른 모든 요청은 성공한 것으로 간주됩니다. 가용성 SLI는 성공적인 요청의 비율이며 지연 시간 SLI는 정의 된 임계 값보다 빠른 요청의 비율입니다.

SLI는 구체적이고 측정 가능해야합니다. 잠재적 후보자 목록을 요약하면 SLI가 다음 소스 중 하나 이상을 사용할 수 있습니다.

- Application server logs
- Load balancer monitoring
- Black-box monitoring
- Client-side instrumentation

이 예에서는 로드 밸런서 모니터링을 사용하는데, 메트릭을 이미 사용할 수 있고 응용 프로그램 서버의 로그에있는 SLI보다 사용자 경험에 가까운 SLI를 제공하기 때문입니다.

### Pipeline freshness, coverage, and correctness

우리의 파이프 라인이 리그 테이블을 업데이트 할 때, 데이터가 업데이트되었을 때의 타임 스탬프를 포함하는 워터 마크를 기록합니다.
SLI implementations 예:

- 리그 테이블에서 정기적으로 쿼리를 실행하여 총 레코드 수와 총 레코드 수를 계산합니다. 이렇게하면 얼마나 많은 사용자가 데이터를 보았는지에 관계없이 각 부실 레코드를 똑같이 중요하게 취급합니다.
- 리그 테이블의 모든 클라이언트가 새로운 데이터를 요청할 때 워터 마크를 확인하고 데이터가 요청되었음을 나타내는 메트릭 카운터를 증가시킵니다. 데이터가 미리 정의 된 임계 값보다 더 신선한 경우 다른 카운터를 증가시킵니다.

이 두 가지 옵션에서 우리의 예제는 클라이언트 측 구현을 사용합니다. SLI는 사용자 경험과 훨씬 밀접한 관련이 있으며 추가하기 쉽습니다.

커버리지 SLI를 계산하기 위해 우리 파이프 라인은 처리해야하는 레코드 수와 성공적으로 처리 된 레코드 수를 내 보냅니다. 이 측정 기준은 잘못 구성되어서 우리 파이프 라인에서 알지 못했던 기록을 놓칠 수 있습니다.

We have a couple potential approaches to measure correctness:
우리는 정확성을 측정하기위한 몇 가지 잠재적 접근법을 가지고 있습니다:

- 알려진 출력이있는 데이터를 시스템에 주입하고 출력이 예상과 일치하는 비율을 계산합니다.
- 파이프 라인 자체와는 다른 입력을 기반으로 올바른 출력을 계산하는 방법을 사용하십시오 (따라서 비용이 더 많이들 수 있으므로 파이프 라인에 적합하지 않을 수 있음). 입 / 출력 쌍을 샘플링하고 올바른 출력 레코드의 비율을 세는 데 사용하십시오. 이 방법론은 그러한 시스템을 만드는 것이 가능하고 실용적이라고 가정합니다.

Our example bases its correctness SLI on some manually curated data in the game state database, with known good outputs that are tested every time the pipeline runs. Our SLI is the proportion of correct entries for our test data. In order for this SLI to be representative of the actual user experience, we need to make sure that our manually curated data is representative of real-world data.
우리 예제의 정확성 SLI는 파이프라인이 실행될 때 마다 매번 테스트 된 수동으로 선택된 게임 상태 데이터베이스의 일부 데이터에 의한 측정을 기반으로 한다. 우리의 SLI는 테스트 데이터에 대한 올바른 항목의 비율입니다. 이 SLI가 실제 사용자 환경을 대표하려면 수동으로 큐레이터 된 데이터가 실제 데이터를 대표하는지 확인해야 합니다.

## Measuring the SLIs

그림 2-2는 우리의 화이트 박스 모니터링 시스템이 예제 애플리케이션의 다양한 구성 요소로부터 메트릭을 수집하는 방법을 보여줍니다.

모니터링 시스템의 메트릭을 사용하여 초기 SLO를 계산하는 예를 살펴 보겠습니다. 이 예에서는 가용성 및 대기 시간 측정 기준을 사용하지만 다른 모든 잠재적 SLO에도 동일한 원칙이 적용됩니다.

### Load balancer metrics

백엔드 ( "api"또는 "웹") 및 응답 코드 별 총 요청 수 :

  http_requests_total{host="api", status="500"}

총 레이턴시, 누적 히스토그램으로; 각 버킷은 그 시간보다 작거나 같은 요청 수를 계산합니다.

  http_request_duration_seconds{host="api", le="0.1"}
  http_request_duration_seconds{host="api", le="0.2"}
  http_request_duration_seconds{host="api", le="0.4"}

일반적으로 말하자면 느린 요청은 히스토그램으로 근사하는 것보다 세는 것이 좋습니다. 그러나 해당 정보를 사용할 수 없기 때문에 우리는 모니터링 시스템에서 제공하는 히스토그램을 사용합니다. 다른 접근법은 로드 밸런서의 구성 (예를 들어, 100ms 및 500ms의 임계치에 대한)의 다양한 슬로우 임계 값에 명시적인 슬로우 요청 카운트를 기초로 하는 것이다. 이 전략은 더 정확한 숫자를 제공하지만 더 많은 구성을 필요로하므로 임계 값을 소급하여 변경하는 것이 더 어렵습니다.

  http_request_duration_seconds{host="api", le="0.1"}
  http_request_duration_seconds{host="api", le="0.5"}

### Calculating the SLIs

위의 측정 항목을 사용하여 이전 7 일 동안의 현재 SLI를 계산할 수 있습니다.

#### Calculations for SLIs over the previous seven days지난 7 일 동안의 SLI 계산

- Avaliability
  - sum(rate(http_requests_total{host="api", status!~"5.."}[7d])) / sum(rate(http_requests_total{host="api"}[7d])
- Latency
  - histogram_quantile(0.9, rate(http_request_duration_seconds_bucket[7d]))
  - histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[7d]))

## Using the SLIs to Calculate Starter SLOs

We can round down these SLIs to manageable numbers (e.g., two significant figures of availability, or up to 50 ms of latency) to obtain our starting SLOs.
우리는 시작 SLO를 얻기 위해 관리 가능한 숫자 (예 : 2 개의 유효한 가용성 또는 최대 50 ms의 대기 시간)로이 SLI를 줄일 수 있습니다.

For example, over four weeks, the API metrics show:
예를 들어, 4주 동안 측정한 API 지표는 다음과 같습니다.

- Total requests: 3,663,253
- Total successful requests: 3,557,865 (97.123%)
- 90th percentile latency: 432 ms
- 99th percentile latency: 891 ms

We repeat this process for the other SLIs, and create a proposed SLO for the API, shown in Table 2-3.
표 2-3에 나와있는 것처럼 다른 SLI에 대해서도이 프로세스를 반복하고 API에 대한 제안 된 SLO를 만듭니다.

Table 2-3. Proposed SLOs for the API

- Availability
  - 97%
- Latency
  - 90% of requests < 450 ms
  - 99% of requests < 900 ms

Appendix A provides a full example of an SLO document. This document includes SLI implementations, which we omitted here for brevity. Based upon this proposed SLI, we can calculate our error budget over those four weeks, as shown in Table 2-4. 제안 된 SLI를 바탕으로 아래의 표와 같이 4 주 동안의 오류 예산을 계산할 수 있습니다.

Table 2-4. Error budget over four weeks

- 97% availability
  - failures: 109,897
- 90% of requests faster than 450 ms
  - failures: 366,325
- 99% of requests faster than 900 ms
  - failures: 36,632

## Choosing an Appropriate Time Window

SLOs can be defined over various time intervals, and can use either a rolling window or a calendar-aligned window (e.g., a month). There are several factors you need to account for when choosing the window.
SLO는 다양한 시간 간격에 걸쳐 정의 될 수 있으며, 롤링 윈도우 또는 캘린더 정렬 윈도우 (예 : 한 달)를 사용할 수 있습니다. 시간 간격을 선택할 때 고려해야 할 몇 가지 요소가 있습니다.

Rolling windows are more closely aligned with user experience: if you have a large outage on the final day of a month, your user doesn’t suddenly forget about it on the first day of the following month. We recommend defining this period as an integral number of weeks so it always contains the same number of weekends. For example, if you use a 30-day window, some periods might include four weekends while others include five weekends. If weekend traffic differs significantly from weekday traffic, your SLIs may vary for uninteresting reasons.
순차 이동 방식은 사용자 환경과 더욱 밀접하게 조화를 이루고 있습니다. 한 달의 마지막 날에 큰 정전이 발생하면 다음 달 1 일에 사용자가 갑자기 잊어 버리지 않습니다. 이 기간은 항상 주말 수가 같기 때문에이 기간을 정수로 정의하는 것이 좋습니다. 예를 들어 30 일짜리 창을 사용하는 경우 일부 주에는 4 개의 주말이 포함될 수 있으며 나머지는 5 개의 주말이 포함될 수 있습니다. 주말 교통량이 평일 교통량과 크게 다르다면 관심없는 이유로 SLI가 다를 수 있습니다.

Calendar windows are more closely aligned with business planning and project work. For example, you might evaluate your SLOs every quarter to determine where to focus the next quarter’s project headcount. Calendar windows also introduce some element of uncertainty: in the middle of the quarter, it is impossible to know how many requests you will receive for the rest of the quarter. Therefore, decisions made mid-quarter must speculate as to how much error budget you’ll spend in the remainder of the quarter.
캘린더 간격은 비즈니스 계획 및 프로젝트 작업과 더욱 밀접하게 연계되어 있습니다. 예를 들어, 매 분기마다 SLO를 평가하여 다음 분기 프로젝트의 인력을 집중시키는 위치를 결정할 수 있습니다. 캘린더 창에는 불확실성의 일부 요소가 있습니다. 분기 중반에는 나머지 분기 동안 얼마나 많은 요청을 받게 될지 알 수 없습니다. 따라서 분기 중반에 내린 결정은 나머지 분기 동안 지출 할 오류 예산의 양을 추측해야합니다.

Shorter time windows allow you to make decisions more quickly: if you missed your SLO for the previous week, then small course corrections—prioritizing relevant bugs, for example—can help avoid SLO violations in future weeks.
짧은 시간 창을 사용하면보다 신속하게 의사 결정을 내릴 수 있습니다. 이전 주 동안 SLO를 놓친 경우, 예를 들어 관련 버그의 우선 순위를 지정하는 작은 과정 수정은 향후 몇 주 동안 SLO 위반을 피할 수 있습니다.

Longer time periods are better for more strategic decisions: for example, if you could choose only one of three large projects, would you be better off moving to a highavailability distributed database, automating your rollout and rollback procedure, or deploying a duplicate stack in another zone? You need more than a week’s worth of data to evaluate large multiquarter projects; the amount of data required is roughly commensurate with the amount of engineering work being proposed to fix it.
더 긴 기간은 더 전략적인 결정을 위해 더 낫다.
예를 들어 대형 프로젝트 3 개 중 하나만 선택할 수있는 경우 고 가용성 분산 데이터베이스로 이동하거나 롤아웃 및 롤백 절차를 자동화하거나 다른 스택에 중복 스택을 배포하는 것이 좋습니다. 존? 대형 멀티 프로젝트를 평가하려면 1 주일 이상의 데이터가 필요합니다. 필요한 데이터의 양은이를 해결하기 위해 제안 된 엔지니어링 작업의 양과 대략 일치합니다.

우리는 좋은 범용 간격으로 4 주간의 롤링 윈도우를 발견했습니다. 우리는 작업 우선 순위를 매주 요약하고 프로젝트 계획을 위해 분기 별 요약 보고서를 작성하여 이 시간표를 보완합니다.

If the data source allows, you can then use this proposed SLO to calculate your actual SLO performance over that interval: if you set your initial SLO based on actual measurements, by design, you met your SLO. But we can also gather interesting information about the distribution. Were there any days during the past four weeks when our service did not meet its SLO? Do these days correlate with actual incidents? Was there (or should there have been) some action taken on those days in response to incidents?
데이터 소스가 허용하는 경우이 제안 된 SLO를 사용하여 해당 간격에 대한 실제 SLO 성능을 계산할 수 있습니다. 실제 측정을 기준으로 초기 SLO를 설정 한 경우 SLO에 도달 할 것입니다. 또한, 배포에 대한 흥미로운 정보를 수집 할 수도 있습니다. 지난 4 주 동안 서비스가 SLO를 충족하지 못한 날이 있었습니까? 이 기간은 실제 사고와 관련이 있는지와 사고에 대응하여 당시에 취한 조치가 있었는지 수집해 볼 수 있습니다.

If you do not have logs, metrics, or any other source of historical performance, you need to configure a data source. For example, as a low-fidelity solution for HTTP services, you can set up a remote monitoring service that performs some kind of periodic health check on the service (a ping or an HTTP GET) and reports back the number of successful requests. A number of online services can easily implement this solution.
로그, 지표 또는 기타 이전 성능 소스가 없는 경우 데이터 소스를 구성해야합니다. 예를 들어 HTTP 서비스의 충실도가 낮은 솔루션으로 서비스 (ping 또는 HTTP GET)에 대한 일종의 정기적 인 상태 검사를 수행하고 성공적인 요청 수를보고하는 원격 모니터링 서비스를 설정할 수 있습니다. 많은 온라인 서비스가이 솔루션을 쉽게 구현할 수 있습니다.

## Getting Stakeholder Agreement

In order for a proposed SLO to be useful and effective, you will need to get all stakeholders to agree to it:
SLO 제안이 유용하고 효과적이기 위해서는 모든 이해 관계자가 동의해야합니다.

- 제품 관리자는 이 임계 값이 사용자에게 충분하다는 것에 동의해야합니다.이 값 미만의 성능은 허용 할 수 없을 정도로 낮기 때문에 엔지니어링 시간을 수정해야 할 가치가 있습니다.
- 제품 개발자는 오류 예산이 모두 소진 된 경우 서비스가 다시 예산에 반영 될 때까지 사용자의 위험을 줄이기 위해 몇 가지 조치를 취해야한다는 점에 동의해야합니다.
- 이 SLO를 방어해야하는 생산 환경을 담당하는 팀은 힘든 노력, 과도한 노동력 및 소진 등으로 팀과 서비스의 장기간의 건강을 해치는 것이 아니라 방어가 가능하다는 데 동의해야 합니다.

일단이 모든 점들이 합의되면, 어려운 부분이 끝납니다. SLO 여행을 시작했으며 나머지 단계는이 출발점에서부터 반복됩니다.

SLO를 방어하려면 해당 위협이 적자가되기 전에 엔지니어가 오류 예산에 대한 적시의 통지를 수신 할 수 있도록 모니터링 및 경고를 설정해야합니다.

## Establishing an Error Budget Policy

Once you have an SLO, you can use the SLO to derive an error budget. In order to use this error budget, you need a policy outlining what to do when your service runs out of budget.
SLO가 있으면 SLO를 사용하여 오류 예산을 얻을 수 있습니다. 이 오류 예산을 사용하려면 서비스 예산이 소진되었을 때 수행 할 작업을 설명하는 정책이 필요합니다.

Getting the error budget policy approved by all key stakeholders—the product manager, the development team, and the SREs—is a good test for whether the SLOs are fit for purpose:
모든 주요 이해 관계자 (제품 관리자, 개발 팀 및 SRE)의 승인을받은 오류 예산 정책을 얻는 것이 SLO가 목적에 적합한 지 여부를 테스트하는 좋은 방법입니다.

- SRE가 SLO가 과도한 수고를 겪지 않고 방어 할 수 없다고 생각하면 일부 목표를 완화 할 수 있습니다.
- 개발 팀과 제품 관리자가 신뢰성을 고치기 위해 투입해야하는 자원의 증가로 인해 기능 릴리스 속도가 허용 수준 이하로 떨어지면 느린 목표를 주장 할 수 있습니다. SLO를 낮추면 SRE가 응답 할 수있는 상황도 줄어 듭니다. 제품 관리자는이 절충점을 이해해야합니다.
- 제품 예산 담당자가 오류 예산 정책에 따라 문제를 해결하라는 메시지를 표시하기 전에 제품 관리자가 상당 수의 사용자에게 SLO가 좋지 않은 경험을한다고 느끼면 SLO가 충분히 빡빡하지 않을 수 있습니다.

세 당사자 모두 오류 예산 정책을 시행하는 데 동의하지 않는 경우 모든 이해 관계자가 만족할 때까지 SLI 및 SLO를 반복해야합니다. 앞으로 나아갈 방법과 결정을 내리는 데 필요한 사항을 결정하십시오 : 더 많은 데이터, 더 많은 리소스 또는 SLI 또는 SLO의 변경?

오류 예산 집행에 관해 이야기 할 때 오류 예산이 소진되면 (또는 소진 될 때까지) 시스템 안정성을 복원하기 위해 무언가를 해야합니다.

오류 예산 집행 결정을 내리기 위해서는 서면 정책으로 시작해야합니다. 이 정책은 서비스가 일정 기간 동안 전체 오류 예산을 소비했을 때 취해야 할 특정 조치를 취해야하며 누가 해당 오류를 누가 가져갈 지 지정해야합니다. 일반적인 소유자 및 작업에는 다음이 포함될 수 있습니다.

- 개발 팀은 지난 4 주 간 안정성 문제와 관련된 버그를 최우선 적으로 처리합니다.
- 개발 팀은 시스템이 SLO 내에있을 때까지 신뢰성 문제에만 전념합니다. 이 책임은 외부 기능 요청 및 명령을 철회하기위한 높은 수준의 승인과 함께 제공됩니다.
- 더 많은 가동 중단의 위험을 줄이기 위해 생산 중단은 변경을 재개하기에 충분한 오류 예산이있을 때까지 시스템의 특정 변경을 중단시킵니다.

때로는 서비스가 전체 오류 예산을 소비하지만 일부 이해 관계자가 오류 예산 정책을 제정하는 것이 적절하다는 데 동의하지 않는 경우도 있습니다. 이 경우 오류 예산 정책 승인 단계로 돌아 가야합니다.

## Documenting the SLO and Error Budget Policy

An appropriately defined SLO should be documented in a prominent location where other teams and stakeholders can review it. This documentation should include the following information:
적절히 정의 된 SLO는 다른 팀과 이해 관계자가 검토 할 수있는 중요한 위치에 문서화되어야합니다. 이 문서에는 다음 정보가 포함되어야합니다.

- The authors of the SLO, the reviewers (who checked it for technical accuracy), and the approvers (who made the business decision about whether it is the right SLO).
- The date on which it was approved, and the date when it should next be reviewed.
- A brief description of the service to give the reader context.
- The details of the SLO: the objectives and the SLI implementations.
- The details of how the error budget is calculated and consumed.
- The rationale behind the numbers, and whether they were derived from experimental or observational data. Even if the SLOs are totally ad hoc, this fact should be documented so that future engineers reading the document don’t make bad decisions based upon ad hoc data.
- SLO 작성자, 검토자(기술 정확도를 확인) 및 승인자(비즈니스 상에서 올바른 SLO인지 여부를 결정)
- 승인 된 날짜 및 다음에 검토해야 할 날짜.
- 맥락을 제공하는 서비스에 대한 간략한 설명.
- SLO의 세부 사항 : 목표 및 SLI 구현.
- 에러 예산 계산 및 소비 방법에 대한 세부 정보.
- 숫자 뒤에 근거가 되는 이론적 근거와 실험 데이터 또는 관측 자료에서 파생되었는지 여부. SLO가 완전히 임시적 일지라도, 이 사실은 문서를 읽는 미래의 엔지니어가 특별 데이터를 기반으로 나쁜 결정을 내리지 않도록 문서화 되어야합니다.

How often you review an SLO document depends on the maturity of your SLO culture. When starting out, you should probably review the SLO frequently—perhaps every month. Once the appropriateness of the SLO becomes more established, you can likely reduce reviews to happen quarterly or even less frequently.
SLO 문서 검토 빈도는 SLO 문화의 성숙도에 따라 다릅니다. 시작하게 되면, SLO를 자주(아마도 매달) 검토해야 합니다. SLO의 적합성이 확립되면 분기 별 또는 그 이하의 빈도로 검토를 줄일 수 있습니다.

The error budget policy should also be documented, and should include the following information:
오류 예산 정책도 문서화되어야하며 다음 정보를 포함해야합니다.

- The policy authors, reviewers, and approvers
- The date on which it was approved, and the date when it should next be reviewed
- A brief description of the service to give the reader context
- The actions to be taken in response to budget exhaustion
- A clear escalation path to follow if there is disagreement on the calculation or whether the agreed-upon actions are appropriate in the circumstances
- Depending upon the audience’s level of error budget experience and expertise, it may be beneficial to include an overview of error budgets.
- 정책 작성자, 검토 자 및 승인자
- 승인 된 날짜 및 다음에 검토해야 할 날짜
- 독자 문맥을 제공하는 서비스에 대한 간략한 설명
- 예산 고갈에 대응하여 취해야 할 조치
- 계산에 의견 차이가 있거나 합의 된 조치가 상황에 적합한 지 여부에 따라 명확한 에스컬레이션 경로를 따라야합니다.

청중의 오류 예산 경험 및 전문성에 따라 오류 예산 개요를 포함하는 것이 유용 할 수 있습니다.

### Dashboards and Reports

게시 된 SLO 및 오류 예산 정책 문서 외에도 다른 팀과 통신하고 문제가있는 영역을 파악하기 위해 서비스의 SLO 준수에 대한 시간 스냅 숏을 제공하는 보고서 및 대시 보드를 갖는 것이 유용합니다.

그림 2-3의 보고서는 여러 서비스의 전반적인 준수를 보여줍니다. 전년도 분기 별 SLO를 모두 충족했는지 여부 (괄호 안의 숫자는 충족 된 목표의 수와 총 목표 수를 나타냄) 지난 분기와 지난 분기에 비해 SLI가 상향 또는 하향 조정 됐는지 여부.
Figure 2-3. SLO compliance report

It is also useful to have dashboards showing SLI trends. These dashboards indicate if you are consuming budget at a higher-than-usual rate, or if there are patterns or trends you need to be aware of.
SLI 추세를 보여주는 대시 보드를 갖는 것도 유용합니다. 이 대시 보드는 평소보다 높은 예산으로 예산을 사용하고 있는지 또는 알고 있어야하는 패턴이나 경향이 있는지 나타냅니다.

그림 2-4의 대시 보드는 해당 분기 중간에있는 단일 분기에 대한 오류 예산을 보여줍니다. 여기서 우리는 하나의 이벤트가 2 일 동안 오류 예산의 약 15 %를 소비했다는 것을 알 수 있습니다.
The dashboard in Figure 2-4 shows the error budget for a single quarter, midway through that quarter. Here we see that a single event consumed around 15% of the error budget over the course of two days.

Figure 2-4. Error budget dashboard

Error budgets can be useful for quantifying these events—for example, “this outage consumed 30% of my quarterly error budget,” or “these are the top three incidents this quarter, ordered by how much error budget they consumed.”
오류 예산은 이러한 이벤트를 정량화하는 데 유용 할 수 있습니다. 예를 들어 "이 중단은 분기 별 오류 예산의 30 %를 소비했습니다."또는 "이번 분기에 3 번 발생한 사고로, 얼마나 많은 오류 예산을 소비했는지 순서가 정해졌습니다."

## Continuous Improvement of SLO Targets

Every service can benefit from continuous improvement. This is one of the central service goals in ITIL, for example.
모든 서비스는 지속적인 개선의 혜택을 볼 수 있습니다. 이것은 예를 들어 ITIL의 핵심 서비스 목표 중 하나입니다.

Before you can improve your SLO targets, you need a source of information about user satisfaction with your service.

There are a huge range of options:

SLO 목표를 향상시키기 전에 서비스에 대한 사용자 만족도에 대한 정보 소스가 필요합니다.

엄청난 범위의 옵션이 있습니다.

- 수동으로 발견 된 정전, 공개 포럼에 게시 된 게시물, 지원 티켓 및 고객 서비스에 대한 전화를 셀 수 있습니다.
- 소셜 미디어에서 사용자 감정을 측정 할 수 있습니다.
- 사용자의 행복을 주기적으로 샘플링하기 위해 시스템에 코드를 추가 할 수 있습니다.
- 대면 사용자 설문 조사 및 샘플을 실시 할 수 있습니다.

가능성은 무한하며 최적의 방법은 서비스에 따라 다릅니다. 시작점에서 수집하고 반복하는 데 비용이 저렴한 측정으로 시작하는 것이 좋습니다. 가격 및 기능에 대한 고객과의 기존 논의에 신뢰성을 포함하도록 제품 관리자에게 요청하는 것이 좋습니다.

### Improving the Quality of Your SLO

Count your manually detected outages. If you have support tickets, count those too. Look at periods when you had a known outage or incident. Check that these periods correlate with steep drops in error budget. Likewise, look at times when your SLIs indicate an issue, or your service fell out of SLO. Do these time periods correlate with known outages or an increase in support tickets? If you are familiar with statistical analysis, Spearman’s rank correlation coefficient can be a useful way to quantify this relationship.
수동으로 감지 된 정전 수를 세십시오. 지원 티켓을 가지고 있다면 카운트하십시오. 알려진 정전이나 사건이 있었던시기를 살펴보십시오. 이 기간이 오류 예산의 가파른 하락과 관련이 있는지 확인하십시오. 마찬가지로, SLI가 문제를 나타내거나 서비스가 SLO에서 벗어 났을 때를보십시오. 이 기간은 알려진 중단 또는 지원 티켓 증가와 관련이 있습니까? 통계 분석에 익숙하다면 Spearman의 순위 상관 계수가이 관계를 계량화하는 유용한 방법이 될 수 있습니다.

그림 2-5는 하루에 발생한 지원 티켓 수와 해당 날짜의 오류 예산에서 측정 된 손실 그래프입니다. 모든 티켓이 안정성 문제와 관련이있는 것은 아니지만 티켓과 오류 예산 손실 간에는 상관 관계가 있습니다. 우리는 두 가지 이상 치를 보았습니다 : 하나는 5 장의 티켓으로, 우리는 오류 예산의 10 %를 잃었고, 하루는 40 장의 티켓으로 오류 예산을 잃지 않았습니다. 둘 다 더 면밀한 조사가 필요합니다.

Figure 2-5. Graph showing the number of support tickets per day versus the budget loss
on that day

SLI 또는 SLO에 중단 및 티켓 스파이크 중 일부가 포착되지 않거나 사용자 대면 문제에 매핑되지 않는 SLI 누락 및 SLO 누락이있는 경우 이는 SLO가 서비스 범위를 찾을 수 없다는 강력한 신호입니다. 이 상황은 완전히 정상적이며 예상되어야합니다. SLI와 SLO는 그들이 나타내는 서비스에 대한 현실이 변함에 따라 시간이 지남에 따라 변경되어야합니다. 시간이 지남에 따라 조사하고 수정하는 것을 두려워하지 마십시오!

There are several courses of action you can take if your SLO lacks coverage:
SLO가 범위가 부족한 경우 취할 수있는 조치는 다음과 같습니다.

#### Change your SLO

If your SLIs indicated a problem, but your SLOs didn’t prompt anyone to notice or respond, you may need to tighten your SLO.
SLI가 문제를 나타내지만 SLO가 누구에게 통보하거나 응답하도록 하지 않은 경우 SLO를 강화해야 할 수 있습니다.

- If the incident on that date was large enough that it needs to be addressed, look at the SLI values during the periods of interest. Calculate what SLO would have resulted in a notification on those dates. Apply that SLO to your historic SLIs, and see what other events this adjustment would have captured. It’s pointless to improve the recall of your system if you lower the precision such that the team must constantly respond to unimportant events.
- 해당 날짜의 사건이 충분히 처리되어야 하는 경우, 해당 기간 동안 SLI 값을 살펴보십시오. 해당 날짜에 SLO가 통지를 내리게 된 결과를 계산하십시오. SLO를 역사적인 SLI에 적용하고이 조정을 통해 얻은 다른 이벤트를 확인하십시오. 팀이 중요하지 않은 이벤트에 지속적으로 응답해야하는 정밀도를 낮추면 시스템 리콜을 향상시키는 것은 의미가 없습니다.
- Likewise, for false-positive days, consider relaxing the SLO. If changing the SLO in either direction results in too many false positives or false negatives, then you also need to improve the SLI implementation.
- 마찬가지로 false-positive일 경우 SLO 완화를 고려하십시오. 어느 방향 으로든 SLO를 변경했을 때 false-positive 또는 flase-negative 가 너무 많아 진다면 SLI 구현을 향상시켜야합니다.

####Change your SLI implementation

SLI 구현을 변경하는 두 가지 방법이 있습니다. 메트릭의 품질을 향상시키기 위해 측정을 사용자 가까이로 이동하거나보다 많은 사용자 상호 작용을 캡처 할 수 있도록 적용 범위를 향상시킵니다. For example:

- Instead of measuring success/latency at the server, measure it at the load balancer or on the client.
- Instead of measuring availability with a simple HTTP GET request, use a health-checking handler that exercises more functionality of the system, or a test that executes all of the client-side JavaScript.
- 서버에서 성공 / 대기 시간을 측정하는 대신로드 밸런서 또는 클라이언트에서 측정하십시오.
- 간단한 HTTP GET 요청으로 가용성을 측정하는 대신 시스템의 더 많은 기능을 수행하는 상태 확인 핸들러를 사용하거나 모든 클라이언트 측 JavaScript를 실행하는 테스트를 사용하십시오.

### Institute an aspirational SLO

Sometimes you determine that you need a tighter SLO to make your users happy, but improving your product to meet that SLO will take some time. If you implement the tighter SLO, you’ll be permanently out of SLO and subject to your error budget policy. In this situation, you can make the refined SLO an aspirational SLO—measured and tracked alongside your current SLO, but explicitly called out in your error budget policy as not requiring action. This way you can track your progress toward meeting the aspirational SLO, but you won’t be in a perpetual state of emergency.
때로는 사용자를 행복하게하기 위해 더 엄격한 SLO가 필요하다고 판단하지만 SLO를 충족시키기 위해 제품을 개선하는 데는 다소 시간이 걸릴 수 있습니다. 더 엄격한 SLO를 구현하면 영구적으로 SLO를 벗어나 에러 예산 정책을 따르게됩니다. 이러한 상황에선, 현재 SLO와 같이 측정되고 추적 할 수 있지만 오류 예산 정책에서 명시적으로 조치가 필요하지 않다고 언급 할 수 있는 aspirational SLO를 만들 수 있습니다. 이렇게 하면 영구적인 비상 사태에 있지 않으면서, aspirational SLO를 달성하는 과정을 추적 할 수 있습니다.

### Iterate

There are many different ways to iterate, and your review sessions will identify many potential improvements. Pick the option that’s most likely to give the highest return on investment. Especially during the first few iterations, err on the side of quicker and cheaper; doing so reduces the uncertainty in your metrics and helps you determine if you need more expensive metrics. Iterate as many times as you need to.
반복하는 방법은 여러가지가 있고, 검토 세션을 통해 많은 잠재적 개선 사항을 식별할 수 있습니다. 투자 수익률이 가장 높은 옵션을 선택해야 합니다. 특히 처음 몇 번의 반복 과정에서 더 빠르고 저렴하게 에러가 발생합니다. 이렇게하면 메트릭의 불확실성을 줄이고 더 비싼 메트릭이 필요한지 여부를 결정하는 데 도움이됩니다. 필요한만큼 반복하십시오.

## Decision Making Using SLOs and Error Budgets

SLO를 가지게 된다면, SLO를 이용하여 의사 결정을 내릴 수 있습니다.

The obvious decisions start from what to do when you’re not meeting your SLO—that is, when you’ve exhausted your error budget. As already discussed, the appropriate course of action when you exhaust your error budget should be covered by the error budget policy. Common policies include stopping feature launches until the service is once again within SLO or devoting some or all engineering time to working on reliability-related bugs.
분명한 결정은 SLO를 만나지 않을 때, 즉 오류 예산을 다 써 버렸을 때 무엇을해야하는지부터 시작합니다. 이미 논의한 바와 같이, 오류 예산을 소진 할 때 적절한 조치 방법은 오류 예산 정책의 적용을 받습니다. 일반적인 정책에는 서비스가 SLO 내에서 다시 한 번 돌아올 때까지 기능 시작을 중지하거나 신뢰성 관련 버그를 다루는 엔지니어링 시간의 일부 또는 전부를 기울이는 작업이 포함됩니다.

In extreme circumstances, a team can declare an emergency with high-level approval to deprioritize all external demands (requests from other teams, for example) until the service meets exit criteria—typically that the service is within SLO and that you’ve taken steps to decrease the chances of a subsequent SLO miss. These steps may include improving monitoring, improving testing, removing dangerous dependencies, or rearchitecting the system to remove known failure types.
극단적인 상황에서 팀은 서비스가 종료 기준을 충족 할 때까지 (예: 다른 팀의 요청) 모든 외부 요구 사항을 우선 순위에서 제외하도록 긴급 상황을 선언 할 수 있습니다. 일반적으로 서비스가 SLO 내에 있고 SLO 미스의 기회를 줄이기 위해 조치를 취한 경우를 말합니다. 이러한 단계에는 모니터링 개선, 테스트 개선, 위험한 종속성 제거 또는 알려진 재해 유형을 제거하기 위한 시스템 재구성이 포함될 수 있습니다.

You can determine the scale of the incident according to the proportion of the error budget it consumed, and use this data to identify the most critical incidents that merit closer investigation.
사고 규모를 사용 된 오류 예산의 비율에 따라 결정할 수 있으며 이 데이터를 사용하여보다 긴밀한 조사가 필요한 가장 중요한 사건을 식별 할 수 있습니다.

For example, imagine a release of a new API version causes 100% NullPointerExceptions until the system can be reverted four hours later. Inspecting the raw server logs indicates that the issue caused 14,066 errors. Using the numbers from our 97% SLO earlier, and our budget of 109,897 errors, this single event used 13% of our error budget.
예를 들어, 새 API 버전을 출시하면 100% NullPointerExceptions가 발생하여 4시간 후에 시스템을 되돌릴 수 있다고 가정합니다. 실제에 존재하는 로그를 검사하면 문제로 인해 14,066 개의 오류가 발생했음을 나타낸다고 했을 때, 이전 97 % SLO의 수치와 109,897 에러 예산 중에 이 단일 이벤트는 오류 예산의 13 %를 사용했습니다.

Or perhaps the server on which our singly homed state database is stored fails, and restoring from backups takes 20 hours. We estimate (based upon historical traffic over that period) that this outage caused us 72,000 errors, or 65% of our error budget.
또는 단독 홈 데이터베이스가 저장되는 서버가 실패하고 백업에서 복원하는 데 20 시간이 걸릴 수도 있습니다. 이 기간 동안의 실제 트래픽을 기준으로이 중단으로 인해 72,000 개의 오류 (오류 예산의 65 %)가 발생했다고 추정합니다.

Imagine that our example company had only one server failure in five years, but typically experiences two or three bad releases that require rollbacks per year. We can estimate that, on average, bad pushes cost twice as much error budget as database failures. The numbers prove that addressing the release problem provides much more benefit than investing resources in investigating the server failure.
예제 회사에서 5년 만에 하나의 서버 오류가 발생했다고 가정 해보십시오. 일반적으로 1년에 롤백해야하는 2 ~ 3 건의 불량 릴리스가 발생합니다. 평균적으로 나쁜 푸시는 데이터베이스 오류보다 두 배나 많은 오류 예산이 들게됩니다. 수치는 릴리스 문제를 해결하면 서버 오류를 조사하는 데 리소스를 투자하는 것보다 훨씬 많은 이점을 제공한다는 것을 입증합니다.

If the service is running flawlessly and needs little oversight, then it may be time to move the service to a less hands-on tier of support. You might continue to provide incident response management and high-level oversight, but you no longer need to be as closely involved with the product on a day-to-day basis. Therefore, you can focus your efforts on other systems that need more SRE support.
서비스가 완벽하게 작동하고 거의 감독이 필요하지 않은 경우 서비스를 실제보다 적은 지원 단계로 옮길 수 있습니다. 사고 대응 관리 및 높은 수준의 감독을 계속 제공 할 수 있지만 더 이상 일상적으로 제품에 긴밀하게 관여 할 필요가 없습니다. 따라서 더 많은 SRE 지원이 필요한 다른 시스템에 집중할 수 있습니다.

Table 2-5 provides suggested courses of action based on three key dimensions:
표 2-5는 세 가지 핵심 차원을 기반으로 제안 된 조치 과정을 제공합니다.

- Performance against SLO
- The amount of toil required to operate the service
- The level of customer satisfaction with the service
- SLO 대비 성능
- 서비스 운영에 필요한 수고액
- 서비스에 대한 고객 만족도

Table 2-5. SLO decision matrix
SLOs Toil Customer
satisfaction
Action
Met Low High Choose to (a) relax release and deployment processes and increase velocity, or (b) step back from the engagement and focus engineering time on services that need more reliability. (a) 릴리스 및 배포 프로세스를 완화하고 속도를 높이거나 (b) 더 많은 안정성이 필요한 서비스에 대한 참여 및 포커스 엔지니어링 시간을 줄이십시오.
Met Low Low Tighten SLO.
Met High High If alerting is generating false positives, reduce sensitivity. Otherwise, temporarily loosen the SLOs (or offload toil) and fix product and/or improve automated fault mitigation. 경고가 오 탐지를 생성하는 경우 감도를 줄이십시오. 그렇지 않으면 SLO를 일시적으로 풀고 (또는 부하를 줄이고) 제품을 수정하거나 자동 고장 완화를 개선하십시오.
Met High Low Tighten SLO.
Missed Low High Loosen SLO.
Missed Low Low Increase alerting sensitivity.
Missed High High Loosen SLO.
Missed High Low Offload toil and fix product and/or improve automated fault mitigation. 부하를 줄이고 제품을 수정하고 자동화 된 오류 완화 기능을 개선하십시오.

## Advanced Topics

Once you have a healthy and mature SLO and error budget culture, you can continue to improve and refine how you measure and discuss the reliability of your services.

### Modeling User Journeys

While all of the techniques discussed in this chapter will be beneficial to your organization,
ultimately SLOs should center on improving the customer experience. Therefore,
you should write SLOs in terms of user-centric actions.
You can use critical user journeys to help capture the experience of your customers. A
critical user journey is a sequence of tasks that is a core part of a given user’s experience
and an essential aspect of the service. For example, for an online shopping experience,
critical user journeys might include:
- Searching for a product
- Adding a product to a shopping cart
- Completing a purchase
These tasks will almost certainly not map well to your existing SLIs; each task
requires multiple complex steps that can fail at any point, and inferring the success
(or failure) of these actions from logs can be extremely difficult. (For example, how
do you determine if the user failed at the third step, or if they simply got distracted by
cat videos in another tab?) However, we need to identify what matters to the user
before we can start making sure that aspect of the service is reliable.
Once you identify user-centric events, you can solve the problem of measuring them.
You might measure them by joining distinct log events together, using advanced
JavaScript probing, using client-side instrumentation, or using some other process.
Once you can measure an event, it becomes just another SLI, which you can track
alongside your existing SLIs and SLOs. Critical user journeys can improve your recall
without affecting your precision.

### Grading Interaction Importance

Not all requests are considered equal. The HTTP request from a mobile app that
checks for account notifications (where notifications are generated by a daily pipeline)
is important to your user, but is not as important as a billing-related request by
your advertiser.
We need a way to distinguish certain classes of requests from others. You can use
bucketing to accomplish this—that is, adding more labels to your SLIs, and then
applying different SLOs to those different labels. Table 2-6 shows an example.
Table 2-6. Bucketing by tier
Customer tier Availability SLO
Premium 99.99%
Free 99.9%

You can split requests by expected responsiveness, as shown in Table 2-7.
Table 2-7. Bucketing by expected responsiveness
Responsiveness Latency SLO
Interactive (i.e., requests that block page load) 90% of requests complete in 100 ms
CSV download 90% of downloads start within 5 s
If you have the data available to apply your SLO to each customer independently, you
can track the number of customers who are in SLO at any given time. Note that this
number can be highly variable—customers who send a very low number of requests
will have either 100% availability (because they were lucky enough to experience no
failures) or very low availability (because the one failure they experienced was a significant
percentage of their requests). Individual customers can fail to meet their SLO
for uninteresting reasons, but in aggregate, tracking problems that affect a wide number
of customers’ SLO compliance can be a useful signal.

## Modeling Dependencies

Large systems have many components. A single system may have a presentation
layer, an application layer, a business logic layer, and a data persistence layer. Each of
these layers may consist of many services or microservices.
While your prime concern is implementing a user-centric SLO that covers the entire
stack, SLOs can also be a useful way to coordinate and implement reliability requirements
between different components in the stack.
For example, if a single component is a critical dependency9 for a particularly highvalue
interaction, its reliability guarantee should be at least as high as the reliability
guarantee of the dependent action. The team that runs that particular component
needs to own and manage its service’s SLO in the same way as the overarching product
SLO.
If a particular component has inherent reliability limitations, the SLO can communicate
that limitation. If the user journey that depends upon it needs a higher level of
availability than that component can reasonably provide, you need to engineer
around that condition. You can either use a different component or add sufficient
defenses (caching, offline store-and-forward processing, graceful degradation, etc.) to
handle failures in that component.
It can be tempting to try to math your way out of these problems. If you have a service
that offers 99.9% availability in a single zone, and you need 99.95% availability,
simply deploying the service in two zones should solve that requirement. The probability
that both services will experience an outage at the same time is so low that two
zones should provide 99.9999% availability. However, this reasoning assumes that
both services are wholly independent, which is almost never the case. The two instances
of your app will have common dependencies, common failure domains, shared
fate, and global control planes—all of which can cause an outage in both systems, no
matter how carefully it is designed and managed. Unless each of these dependencies
and failure patterns is carefully enumerated and accounted for, any such calculations
will be deceptive.
There are two schools of thought regarding how an error budget policy should
address a missed SLO when the failure is caused by a dependency that’s handled by
another team:
- Your team should not halt releases or devote more time to reliability, as your system
didn’t cause the issue.
- You should enact a change freeze in order to minimize the chances of future outages,
regardless of the cause of that outage.
The second approach will make your users happier. You have some flexibility in how
you apply this principle. Depending on the nature of the outage and dependency,
freezing changes may not be practical. Decide what is most appropriate for your service
and its dependencies, and record that decision for posterity in your documented
error budget. For an example of how this might work in practice, see the example
error budget policy in Appendix B.

### Experimenting with Relaxing Your SLOs
You may want to experiment with the reliability of your application and measure
which changes in reliability (e.g., adding latency into page load times) have a measurably
adverse impact on user behavior (e.g., percentage of users completing a purchase).
We recommend performing this sort of analysis only if you are confident that
you have error budget to burn. There are many subtle interactions between latency,
availability, customers, business domains, and competition (or lack thereof). To
make a choice to deliberately lower the perceived customer experience is a Rubicon
to be crossed extremely thoughtfully, if at all.
While this exercise might seem scary (nobody wants to lose sales!), the knowledge
you can gain by performing such experiments will allow you to improve your service
in ways that could lead to even better performance (and higher sales!) in the future.
This process may allow you to mathematically identify a relationship between a key
business metric (e.g., sales) and a measurable technical metric (e.g., latency). If it
does, you have gained a very valuable piece of data you can use to make important
engineering decisions for your service going forward.

This exercise should not be a one-time activity. As your service evolves, so will your
customers’ expectations. Make sure you regularly review the ongoing validity of the
relationship.
This sort of analysis is also risky because you can misinterpret the data you get. For
example, if you artificially slow your pages down by 50 ms and notice that no corresponding
loss in conversions occurs, you might conclude that your latency SLO is too
strict. However, your users might be unhappy, but simply lacking an alternative to
your service at the moment. As soon as a competitor comes along, your users will
leave. Be sure you are measuring the correct indicators, and take appropriate
precautions.

## Conclusion

이 책에서 다루는 모든 주제는 SLO에 다시 묶일 수 있습니다. 이제부터 이 장을 읽었으므로 부분적으로 형식화 된 SLO (사용자에게 분명하게 약속 한 내용)조차도 시스템 동작을보다 명확하게 논의 할 수있는 프레임 워크를 제공하고 서비스 실패시 실용적인 해결 방법을 찾아내는 데 도움이 되기를 바랍니다.

To summarize:

- SLO는 서비스의 신뢰성을 측정하는 도구입니다.
-오류 예산은 안정성을 다른 엔지니어링 작업과 균형을 유지하는 도구이며 어떤 프로젝트가 가장 큰 영향을 줄지 결정하는 좋은 방법입니다.
- You should start using SLOs and error budgets today. For an example SLO document and an example error budget policy, see AppendixesA and B.

# Simplicity

SRE에게, 단순함은 앤드-투-앤드 간 목표입니다.

## 복잡도 측정하기 (Measuring Complexity)

소프트웨어 시스템의 복잡도를 측정하는 것은 절대적인 관점에서 과학이라고 할 수는 없다. 일반적으로 소프트웨어 코드의 복잡도를 측정할 수 있는 방법은 여러가지가 있다.

하지만 시스템의 복잡도를 측정할 수 있는 형식적인 방법은 드물다.

예를 들어 이러한 방법들이 있을 수는 있다

*Training time*
새로운 팀 멤버가 전화 응대를 하는데까지 걸리는 시간은 얼마인가? 불충분하거나 누락 된 문서화는 개인마다 다른 복잡도를 가지게 하는 중요한 원인이 될 수 있습니다.

*Explanation time*
새로운 팀 구성원에게 포괄적인 서비스 수준을 설명하는 데 얼마나 걸리는가? (예. 화이트보드에 시스템 아키텍쳐 다이어그램을 그리고 각각의 컴포넌트들의 기능과 디펜던시들을 설명하는 것)

*Diversity of deployed configuration*
얼마나 많은 유니크한 설정들이 제품에 배포되어 있는가(바이러니, 바이너리 버전, 플래그, 환경(environments)들을 포함한)

*Age*
시스템은 얼마나 오래되었는가? [Hyrum의 법칙](http://www.hyrumslaw.com/)에 의하여, 시간이 지나는 동안 API 사용자는 구현의 모든 측면에 의존하기 때문에 깨지기 쉽고 예측할 수없는 행동을 하게 된다.
> 번역이 조금 이상..

While measuring complexity is occasionally worthwhile, it’s difficult. However, there
seems to be no serious opposition to the observations that:

- 일반적으로 살아있는 소프트웨어 시스템에서의 복잡도는 상응하는 노력이 없다면 증가합니다.
- 그 노력을 제공하는 것은 가치있는 일입니다.

## Simplicity Is End-to-End, and SREs Are Good for That

복잡도의 비용은 종종 그것을 야기한 개인, 팀 또는 역할에 영향을 미치지 않습니다 - 경제적인 용어로 복잡도는 외부성이라고도 한다.

리더 액션
- 엔지니어가 첫 전화대응을 가지 전에 시스템 다이어그램을 그려보도록 해라.
- SRE가 모든 중요한 디자인 문서들을 리뷰 할 수 있도록 보장하여, 새 디자인이 시스템 아키텍쳐에 얼마나 영향을 줄 수 있는지 파악할 수 있도록 해라.


## Regaining Simplicity

대부분의 단순화 작업은 시스템에서 요소를 제거하는 것으로 구성됩니다. 단순화하는 것은 즉시할 수 있는 것(리모트 시스템에서 받는 데이터 중 사용하지 않는 종속성을 제거)과 리디자인을 요구하는 것(시스템의 두 파트에서 동일한 리모트 데이터를 받아오는 것을 한번에 받아오고 계속해서 이용하는 방식으로의 변경)이 있습니다.

리더 액션
- 엔지니어들이 브레인스토밍을 통하여 시스템의 복잡도와 그것을 줄일 수 있는 방법에 대해 논의하는 시간을 가질 수 있게 하라

앞서 언급했듯이 시스템을 다이어그램화하는 것은 시스템을 이해하고 그 동작을 예측하는 데 방해가 되는 심층적인 설계 문제를 식별하는 데 도움이 될 수 있습니다. 예를 들어, 여러분의 시스템을 다이어그램화 할 때 아래의 내용들을 찾을 것입니다.

*Amplification*
호출이 오류를 반환하거나 시간이 초과되어 여러 수준에서 다시 시도되면 총 RPC 수가 증가합니다.

*Cyclic dependencies*
구성 요소가 자체적으로(간접적으로) 의존하는 경우 시스템 무결성이 심각하게 손상 될 수 있습니다. 특히 전체 시스템의 초기 가동이 불가능해질 수 있습니다.

### 케이스 연구3: Simplification of the Display Ads Spiderweb

- Established a single way to copy large data sets
- Established a single way to perform external data lookups
- Provided common templates for monitoring, provisioning, and configuration

### Case Study 4: Running Hundreds of Microservices on a Shared Platform

### Case Study 5: pDNS No Longer Depends on Itself

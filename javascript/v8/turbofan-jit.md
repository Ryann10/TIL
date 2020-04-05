# Digging into the TurboFan JIT

TurboFan은 최첨단 중간 표현IR을 멀티 레이어 변환 및 파이프라인 최적화를 통해 크랭크 샤프트CrankShaft JIT보다 더 나은 품질의 코드를 생성할 수 있음. CrankShaft 때는 하지 못한 우아한 코드 이동, 제어 흐름 최적화 및 정확한 수치 범위 분석이 가능 해짐.

## A layered architecture

컴파일러는 일반적으로 새로운 언어 기능 지원과 새로운 최적화 기법 추가, 새 컴퓨터 아키텍처 타입의 지원을 위해 시간이 지날 수록 복잡해짐.

이러한 요구를 달성하기 위해 Turbofan에서는 layered architecture 형태로 개발함.

소스 레벨 언어(JavaScrpt), VM 기능(V8) 및 아키텍처 복잡성(x86, ARM, MIPS)을 명확하게 구분하면 보다 깨끗하고 탄탄한 코드가 사용 가능해진다.

계층화는 로컬에서 컴파일러에서의 최적화, 기능, 효과적인 유닛 테스트를 작성하게끔 해준다.

## More sophisticated optimizations

TurboFan JIT는 CrankShaft보다 좀 더 공격적인 최적화를 수행

JavaScript는 최적화되지 않은 형태로 컴파일러 파이프라인으로 진입. 기계 코드가 생성 될 때까지 점차적으로 낮은형태로 변환 및 최적화됨. 설계 핵심은 보다 효과적인 재조정과 최적화를 가능하게 하는 좀 더 완화된 노드 바다sea-of-nodes 내부 표현IR이다.

![Example TurboFan graph](https://v8.dev/_img/turbofan-jit/example-graph.png)

그래프 기반의 IR은 최적화를 간단한 지역 축소로 표현하여 독립적으로 작성 및 테스트하기가 더 쉽다. 최적화 엔진은 지역 규칙을 체계적이고 철저한 방식으로 적용. 그래프 기반 표현에서 전환하려면 코드 순서를 자유롭게 변경하여 루프에서 자주 실행되지 않는 경로로 코드를 이동하는 혁신적인 스케줄링 알고리즘이 필요.

아키텍처 별 최적화는 최고 품질 코드를 위해 각 플랫폼의 기능을 활용.

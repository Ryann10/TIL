# 성능과 최적화

우수한 성능 목표를 달성하기 위한 방법

- 전체 소프트웨어 라이프사이클 성능 방법론
- 테스트
- 측정, 통계, 툴링
- 시스템 + 데이터 분석 스킬
- 하부 기술과 메커니즘

---

JVM 애플리케이션 성능 측정값은 정규 분포를 따르지 않는 경우가 많음
측정하는 행위 자체도 오버헤드 발생

성능은 다음과 같은 활동을 하면서 원하는 결과를 얻기 위한 일종의 실험과학. 아래 이터레이션을 계속해서 반복

- define goal
- measure as-is system
- define what todo
- improvement
- test
- decision

성능 지표

- throughput: 일정 시간 동안 완료한 작업 단위 수. e.g. 초당 처리 가능한 트랜잭션 수
- latency: 트랜잭션을 요청하고 결과를 받을때까지의 시간
- capacity: 동시 처리 가능한 트랜잭션 갯수
- utilization
- efficiency: throughput / utilization
- scability
- degradation

performance elbow: 부하가 증가하면서 예기치 않게 degradation/latency가 발생하는 그래프

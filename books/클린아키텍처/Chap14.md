# 컴포넌트 결합

컴포넌트 의존성 그래프에 순환cycle 이 있어서는 안 된다.

## ADP: 의존성 비순환 원칙

숙취 증후군the morning after syndrome: 누군가 당신보다 더 늦게까지 일하면서 당신이 의존하고 있던 무언가를 수정하면서, 다음 날 전혀 돌아가지 않는 현상

### 해결책

### 주 단위 빌드weekly build

중간 규모의 프로젝트에서 흔하게 사용

먼저 모든 개발자는 일주일의 첫 4일 동안은 서로를 신경쓰지 않는다. 모두 코드를 개인적으로 복사하여 작업하며, 전체적인 기준에서 작업을 어떻게 통합할지는 걱정하지 않는다. 그런 후 금요일이 되면 변경된 코드를 모두 통합하여 시스템을 빌드

장점: 5일 중 4일 동안 개발자를 고립된 세계에서 살 수 있게 보장

단점: 금요일에 통합과 관련된 막대한 업보를 치뤄야 한다.

프로젝트가 커지면서 통합은 금요일 하루 만에 끝마치는게 불가능해진다. 결국 토요일까지 넘어가고, 토요일에도 지연 현상이 반복되면 개발자는 적어도 목요일에는 시작해야 한다고 확신하게 된다. 그러면서 통합을 시작하는 날이 한 주의 중반을 향해 슬금슬금 움직이게 된다.

개발보다 통합에 드는 시간이 늘어나면서 팀의 효율성 저하된다. 개발자와 프로젝트 관리자는 불많이 쌓이고, 빌드를 격주로 해야 한다고 말하게 된다. 격주 빌드는 잠깐 동안은 만족스럽겠지만, 다시 규모가 성장하면서 통ㅎ바에 드는 시간은 계속해서 늘어 난다.

효율성을 유지하기 위해 빌드 일정을 계속 늘려야 하고, 빌드 주기가 늦어질수록 프로젝트가 감수할 위험은 커진다. 통합과 테스트를 수행하기가 점점 더 어려워지고, 팀은 빠른 피드백이 주는 장점을 잃는다.

### 순환 의존성 제거하기(의존성 비순환 원칙ADP)

개발 환경을 릴리즈 가능한 컴포넌트 단위로 분리하는 것이다.

컴포넌트는 개별 개발자 또는 단일 개발팀이 책임질 수 있는 작업 단위가 된다. 개발자가 해당 컴포넌트가 동작하도록 만든 후, 해당 컴포넌트를 릴리즈하여 다른 개발자가 사용할 수 있도록 만든다. 담당 개발자는 이 컴포넌트에 릴리즈 번호를 부여하고, 다른 팀에서 사용할 수 있는 디렉토리로 이동시킨다. 그 다음 개발자는 자신만의 공간에서 해당 컴포넌트를 지속적으로 수정한다. 나머지 개발자는 릴리즈된 버전을 사용한다.

컴포넌트가 새로 릴리즈 되어 사용하 ㄹ수 이쎅 되면, 다른 팀에서는 새 릴리즈를 당장 적용할지를 결정해야 한다. 적용하지 않기로 했다면 과거 버전의 릴리즈를 계속 사용한다. 새 릴리즈를 적요할 준비가 되었다는 판단이 들면 새 릴리즈를 사용하기 시작한다.

따라서 어떤 팀도 다른 팀에 좌우되지 않는다. 특정 컴포넌트가 변경되더라도 다른 팀에 즉각 영향을 주지는 않는다. 통합은 작고 점진적으로 이뤄진다.

컴포넌트를 조립하여 애플리케이션을 만드는 전형적인 구조 → 방향 그래프directed graph

컴포넌트 → 정점vertex

의존성 관계 → 방향이 있는 간선directed edge

특징

- 어느 컴포넌트에서 시작하더라도, 의존성 관계를 따라가면서 최초의 컴포넌트로 되돌아 갈 수 없다. → 순환이 없다. 비순환 방향 그래프Directed Acyclic Graph, DAG
- 시스템 전체를 릴리즈해야 할 때가 오면 릴리즈 절차는 상향식으로 진행된다. Entities 컴포넌트를 컴파일하고, 테스트하고, 릴리즈한다. 그러고나서 Database와 Interactors에 대해서도 동일한 과정을 거친다. 그 다음에는 Presenters, View, Controllers, Authorizer 순으로 진행된다. Main은 마지막에 처리한다. 이 같은 절차는 상당히 명료하며 쉽게 처리할 수 있다. 이처럼 구성요소 간 의존성을 파악하고 있으면 시스템을 빌드하는 방법을 알 수 있다.

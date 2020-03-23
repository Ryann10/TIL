![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/82806a77-0460-4126-99f9-66c4070f3881/Untitled.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/82806a77-0460-4126-99f9-66c4070f3881/Untitled.png)

[https://aarongorka.com/blog/gitlab-monorepo-pipelines/](https://aarongorka.com/blog/gitlab-monorepo-pipelines/)

### 의미

엣지Edges를 따라 이동할 때 동일한 노드로 되돌아 올 수 없는 그래프

Directed → 그래프의 Edges들은 반드시 한 방향으로 이동함을 의미. 미래의 엣지들은 이전 엣지들에게 의존적임을 의미

Acyclic → 그래프의 한 노드에서 엣지를 따라 이동을 시작했을 때 해당 노드로 되돌아 올 수 없음을 의미. cyclic이 원처럼 시작 지점으로 되돌아 올 수 있는 형태를 의미하는데 이와 반대

DAG는 베이지안 네트워크Bayesian networks의 조건부 의존성을 모델링하기 위한 확률적 그래픽 표현이다. 위상 정렬topologically ordered을 사용하여 표현.

### 예시

밥과 치킨을 이용해 요리 및 식사 과정을 그래프화 한다고 했을 때

- 밥을 먹기 전게는 반드시 음식을 준비 해야 한다 → 음식 준비와 관련된 노드들이 식사 노드로 향하도록 해야 한다.
- 음식을 준비하기 전에는 반드시 재료들을 사야 한다 → 반대로 재료를 사는 노드들은 음식을 준비하는 노드들로 이 향해야 한다.
- 만약 밥과 치킨을 사는 이벤트들이 서로 분리되어 독립적인 노드로 존재 한다고 하더라도, 두 노드들은 가게에서 쇼핑을 하는 노드로 방향이 향할 것이고 음식 준비 이벤트 노드로 모여지게 되는 것이다.

### 참고

[https://golden.com/wiki/Directed_acyclic_graph](https://golden.com/wiki/Directed_acyclic_graph)

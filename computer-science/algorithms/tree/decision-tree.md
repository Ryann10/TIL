# 의사결정트리Decision Tree

데이터를 분석 해 데이터들 간의 패턴을 예측 가능한 규칙들의 조합으로 나타내는 것

root node의 데이터 수 -> terminal node들의 데이터 수 합

classification과 regression 모두 가능

homogeneity가 증가, uncertainty가 최대한 감소하도록 하는 방향으로 학습 진행(information gain이라고도 함)

## 모델 학습

### recursive partitioning

입력 변수 영역을 두 파트로 분할

1회 분기위해 계산해야 하는 경우의수 -> (갯수 -1) * 변수

### pruning

너무 디테일하게 분할됐다면 다시 통합

#### 참고

- http://incredible.ai/machine-learning/2018/11/22/Decision-Tree/

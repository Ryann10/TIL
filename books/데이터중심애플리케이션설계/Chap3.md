# 저장소와 검색

키워드

- 트랜잭션 작업 부하에 맞춰 최적화된 저장소 엔진 vs 분석을 위해 최적화된 엔진: 트랜잭션 처리나 분석(93p)
- 분석에 최적화된 저장소 엔진들: 칼럼 지향 저장소(98p)

## 데이터베이스를 강력하게 만드는 데이터 구조

세상에서 제일 간단한 DB

```

#!/bin/bash

db_set() {
  echo "$1, $2" >> database
}

db_get() {
  grep "^$1," database | sed -e "s/^$1,//" | tail -n 1
}


```

로그(log): 많은 DB는 내부적으로 추가 전용 (append-only) 데이터 파일인 로그를 사용

db_set 함수는 매우 간단한 작업의 경우 꽤 좋은 성능을 보여줌
db_get 함수의 성능은 레코드가 많을 경우 좋지 않음. 키를 찾을 때마다 전체 DB 파일을 처음부터 끝까지 스캔해야하기 때문(O(n))

### 색인: 특정 키의 값을 효율적으로 찾기 위한 데이터 구조

모든 색인은 쓰기 속도를 떨어뜨린다. => 트레이드오프

#### 해시색인

키-값 데이터 색인 -> 해시 맵(or 해시 테이블)로 구현

단순히 파일에 추가하는 방식으로 데이터 저장소를 구성
- 색인 전략: 키를 데이터 파일의 바이트 오프셋에 매핑해 인메모리 해시 맵을 유지
- 바이트 오프셋은 값을 바로 찾을 수 있는 위치
- 파일에 새로운 키-값 쌍을 추가할 때마다 방금 기록한 데이터의 오프셋을 반영하기 위해 해시맵도 갱신

장점
- 각 키의 값이 자주 갱신되는 상황에 매우 적합
  - 키: 고양이 동영상의 URL, 값: 비디오가 재생된 횟수
  - 이런 유형의 작업부하에서는 쓰기가 아주 많지만 고유 키는 많지 않다. 즉, 키당 쓰기 수가 많지만 메모리에 모든 키를 보관할 수 있다.

단점
- 디스크 공간 문제
  - 해결방법
    - 특정 크기의 세그먼트로 로그 나누기
    - 특정 크기에 도달하면 새로운 세그먼트 파일에 이후 쓰기를 수행
    - 컴팩션: 로그에서 중복된 키를 버리고 각 키의 최신 갱신 값만 유지
      - 세그먼트를 더 작게 만듬(하나의 키는 세그먼트 내에서 대체로 여러 번 덮어쓰기 된 것을 가정함)
      - 세그먼트들을 병합할 시 새로운 파일로 만들어서 수행한다
      - 세그먼트 병합과 컴팩션은 백그라운드 스레드로 수행하여, 이전 세그먼트 파일들을 이용하여 일기와 쓰기 요청을 처리

실제 구현 시 고려 사항

- 파일 형식
  - CSV는 로그에 가장 적합한 형식이 아님. 바이트 단위의 문자열 길이를 부호화한 다음 원시 문자열(이스케이핑 할 필요 없이))을 부호화하는 바이너리 형식을 사용하는 편이 더 빠르고 간단하다
- 레코드 삭제
  - 키와 관련된 값을 삭제하려면 데이터 파일에 특수한 삭제 레코드를 추가
- 고장 복구
  - DB가 재시작되면 인메모리 해시 맵은 손실된다. 대안으로 스냅숏을 디스크에 저장해 복구 속도를 높인다.
- 부분적으로 레코드 쓰기
  - DB는 로그에 레코드를 추가하는 도중에도 죽을 수 있다. 파일은 체크섬을 포함하고 있어 로그의 손상된 부분을 탐지해 무시할 수 있어야 한다
- 동시성 제어
  - 쓰기를 엄격하게 순차적으로 로그에 추가할 때 ㅇ일반적인 구현 방법은 하나의 쓰기 스레드만 사용하는 것이다. 데이터 파일 세그먼트는 추가 전용이거나 불변이므로 다중 스레드로 동시에 읽기를 할 수 있다.

- 해시 테이블 색인 제한 사항
  - 키가 너무 많으면 문제가 발생
    - 디스크 상의 해시 맵에 좋은 성능을 기대하기는 어려움
    - 무작위 접근 I/O가 많이 필요하고 디스크가 가득 찼을 때 확장하는 비용이 비싸며 해시 충돌 해소를 위해 성가신 로직이 필요
    - 해시 테이블은 범위 질의에 효율적이지 않다 (kitty00000~kitty99999를 조회 시 해시 맵에서 모든 개별 키를 조회해야 한다)


#### SS테이블과 LSM트리

SS테이블: Sorted String Table

- 세그먼트 파일의 형식에 키로 정렬 하는 것
- 세그먼트 병합은 파일이 사용 가능한 메모리보다 크더라도 간단하고 효율적
  - 병합정렬(mergesort)와 유사
  - 입력 파일을 함께 읽고 각 파일의 첫 번째 키(이 때 각 파일은 미리 정렬된 상태)를 본다.
  - 가장 낮은 키를 출력 파일로 복사한 뒤 이 과정을 반복한다.
  - 이 과정에서 새로운 병합 세그먼트 파일이 생성(이미 키로 정렬된 상태)


#### 모든 것을 메모리에 보관

인메모리 DB의 성능 장점은 디스크에서 읽지 않아도 된다는 사실 때문은 아니다. 디스크 기반 저장소 엔진도 운영체제가 최근에 사용한 디스크 블록을 메모리에 캐시하기 때문에 충분한 메모리를 가진 경우에는 디스크에서 읽을 필요가 없다. ㄴ메모리 데이터 구조를 디스크에 기록하기 위한 형태로 부호화하는 오버헤드를 피할 수 있어 더 빠를 수도 있다.

Anti-caching: 메모리가 충분하지 않을 때 가장 최근에 사용하지 않은 데이터를 메모리에서 디스크로 내보내고 나중에 다시 접근할 때 메모리에 적재하는 방식으로 동작. 운영체제가 가상 메모리와 스왑 파일에서 수행하는 방식과 유사하지만 DB는 전체 메로리 페이지보다 개별 레코드 단위로 작업할 수 있기 떄문에 OS보다 더 효율적으로 메모리를 관리할 수 있다. 하지만 이 접근 방식은 여전히 전체 색인이 메모리에 있어야 한다.

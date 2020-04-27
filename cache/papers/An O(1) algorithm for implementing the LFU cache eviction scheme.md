# An O(1) algorithm for implementing the LFU cache eviction scheme 페이퍼 정리

사전 이해

- Eviction: 암시적인 제거
- Expiration: 명시적인 제거

가장 일반적으로 사용하는 Cache eviction 알고리즘은 LRU. 삽입, 접근, 제거 런타임 복잡도가 모두 O(1).
LFU 알고리즘은 O(logn) 복잡도를 가져 LRU가 대부분 사용되는데 해당 페이퍼에서는 O(1) 런타임 복잡도를 가지는 알고리즘을 제안.

## LFU가 다른 Cache eviction 알고리즘보다 우월한 이유

## LFU cache 구현에 필요한 dictionary operations

- 캐시 아이템 삽입Insert
- 캐시 아이템 검색Lookup 및 아이템 사용 횟수 카운트 업
- 최소 빈도 사용 캐시 아이템 제거Evict

## 현재 가장 잘 알려진 LFU 알고리즘과 런타임 복잡도에 대한 설명

가장 잘 알려진 LFU 캐시 런타임 복잡도

- 삽입: O(logn)
- 검색: O(logn)
- 제거: O(logn)

이러한 복잡도는 이항 힙binomial heap 구현 및 충돌 없는 표준 해시 테이블standard collision free hash table을 따른다.

LFU 캐싱 전략은 최소 힙min heap과 해시 맵을 이용하여 쉽고 효율적으로 구현할 수 있다.

사용 횟수를 기반으로 한 최소 힙과 엘리먼트 키를 인덱스로 하는 해시 테이블을 통해 구현.

충돌 없는 해시 테이블의 모든 오퍼레이션은 O(1) 복잡도를 가지므로, LFU 캐시 런타임은 최소 힙의 런타임 복잡도를 따르게 된다.

캐시에 엘리먼트(사용 횟수 1)가 삽입 될 때 최소 힙의 삽입 복잡도는 O(logn) 이므로, LFU 복잡도도 O(logn)를 따르게 된다.

검색의 경우 실제 엘리먼트의 키를 해싱하여 검색하게 된다. 동시에 사용 횟수가 1이 증가하게 되고, 최소 힙의 재조정 발생과 루트로부터 멀어지게 된다. 엘리먼트가 아래로 이동하는 오퍼레이션은 O(logn)를 따른다.

만약 엘리먼트가 제거를 위해 선택 되어 힙에서 삭제될 경우 힙의 막대한 재조정을 발생시킨다. 최소 사용한 엘리먼트가 최소 힙의 루트에 위치함으로, 아래 자식 노드가 루트로 대체되며 이러한 자식 노드들간의 올바른 위치 재조정 오퍼레이션 또한 O(logn) 복잡도를 따른다.

## 모든 연산이 O(1) 런타임 복잡도를 가지는 LFU 알고리즘

모든 연산이 O(1) 복잡도를 가지는 LFU 알고리즘은 연결 리스트 2개를 사용한다. 접근 빈도를 위한 리스트와 동일한 접근 빈도를 가지는 모든 엘리먼트를 위한 리스트로 사용한다.

TBA

### 관련 Leetcode 문제 및 풀이

- [문제](https://leetcode.com/problems/lfu-cache/)
- [풀이](https://github.com/Ryann10/TIL/blob/master/problem-solving/leetcode/hard/460.md)

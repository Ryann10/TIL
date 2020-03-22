# 함수형 프로그래밍

표현을 평가하는 방식으로 계산을 수행

함수는 부작용에서 자유롭기 때문에 스레드의 안정성과 관련해서 사고하는 것을 훨씬 단순하게 만드러줌으로써 동시성에 특별한 강점을 갖는다.

병렬성이 직접 구현되도록 만들어주는 첫 번째 모델

## 3.1 문제가 있으면 멈추기

값이 변하지 않는 불변 데이터는 잠금장치 없이도 여러 개의 스레드가 안정하게 접근 가능하다.

함수형 프로그래밍이 동시성이나 병렬성과 관련해서 매력을 갖는 이유가 여기에 있다. 함수형 프로그램은 가변인 상태가 존재 할 수 없으므로 가변일 때 공유될 경우 야기되는 문제에서 자유롭다.

## 3.2 1일 차: 가변 상태 없이 프로그래밍하기

### 3.2.1. 가변 상태의 위험

#### 숨겨진 가변 상태

다음은 가변 상태를 갖지 않기 때문에 스레드 안정성이 보장되는 클래스다.

```java
class DataParser {
  private final DateFormat format = new SimpleDateFormat("yyyy-MM-dd");

  public Data parse(String s) throws ParseException {
    return format.parse(s);
  }
}
```

코드에는 하나의 멤버 변수만 존재하고 final로 선언되어 변경 불가능해 보이지만 실제로 스레드 안정성을 제공해주지 않는다.

이유는 SimpleDateFormat이 내부 깊숙한 곳에 가변 상태를 가지고 있기 때문이다. [버그라고 부를 수도 있다](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4228335). 자바 같은 언어에서는 이런 식으로 가변 상태를 만드는 것이 너무 쉽다는 게 문제다. 코드가 그런 식으로 작성되면 그걸 알아채는 것이 사실상 불가능에 가깝다는 것은 더 큰 문제다. 그렇기 때문에 SimpleDateFormat의 API를 보는 것만으로는 그것이 스레드-안정성을 보장하는지 알 수 없다.

#### 가변 상태는 탈출왕

```java
public class Tournament {
  private List<Player> players = new LinkedList<Player>();

  public synchronized void addPlayer(Player p) {
    players.add(p);
  }

  public synchronized Iterator<Player> getPlayerIterator() {
    return players.iterator();
  }
}
```

이 코드도 스레드-안정성을 제공하지는 않는다. getPlayerIterator()에 의해 리턴된 순환자가 players의 내부에 저장된 가변 상태를 참조할 지 모르기 떄문이다. 순환자가 사용되는 동안 다른 스레드가 addPlayer()를 호출하면 우리는 ConcurrentModificationException 혹은 그보다 더 심한 예외를 만나게 될 것이다. 우리가 지키고 싶은 상태가 Tournament에서 제공하는 보호의 장막에서 탈출한 것이다.

### 3.2.3 첫 번째 함수 프로그램

일련의 수가 있다고 하고, 그들을 서로 더한 값을 계산해보자. 자바와 같은 명령형 언어에서라면 아마 다음과 같이 코드를 작성할 것이다.

```java
public int sum(int[] numbers) {
  int accumulator = 0;
  for (int n: numbers)
    accumulator += n;
  return accumulator;
}
```

accumulator의 상태가 변경되고 있기 때문에 이것은 함수적이지 않다. 루프다 돌 때마다 값이 달라진다.

```closure
(defn recursive-sum [numbers]
  (if (empty? numbers)
    0
    (+ (first numbers) (recursive-sum (rest numbers)))))
```

```closure
(defn reduce-sum [numbers]
  (reduce (fn [acc x] (+ acc x)) 0 numbers))
```

익명의 함수를 만들 필요조차 없이 아예 +를 인수로 전달하면 더 좋은 코드를 작성할 수 있다.

```closure
(defn sum [numbers]
  (reduce + numbers))
```

### 3.2.4 어렵지 않게 만들 수 있는 병렬성

sum 함수를 병렬적으로 만들기

```closure
(ns sum.core
  (:require [clojure.core.reducers :as r]))

(defn parallel=sum [numbers]
  (r/fold + numbers))
```

### 3.2.5 함수 방식으로 단어 세기

```closure
(defn word-frequencies [words]
  (reduce
   (fn [counts word] (assoc counts word (inc (get counts word 0))))))
```

reduce에 초깃값으로 빈 맵 {}을 전달하고 words에 담긴 각 단어에 대해서 해당 단어의 빈도에 1을 더할 수 있다. 하지만 클로저에 frequencies라는 표준 함수가 있으므로 이를 사용한다.

이제 정규표현을 이용해서 문자열을 여러 개의 단어로 나누는 것과 같이 어떤 열을 리턴하는 함수가 있다고 하자.

```closure
(defn get-words [text] (re-seq #"\w+" text))
```

다음으로 count-words-sequential이라는 페이지의 열이 주어지면 각 페이지에 담긴 단어들의 빈도를 담은 맵을 리턴하는 함수를 생성

```closure
(defn count-words-sequential [pages]
  (frequencies (mapcat get-words pages)))

### 3.2.6 게으른 것이 좋은 것이다

위키피디아 데이터는 40기가 바이트에 달한다. count-words가 모든 단어를 거대한 하나의 열에 담는다면 메모리가 부족할 것이다.

클로저의 동작은 기본적으로 lazy하기 때문에 lazy array에 담긴 원소들은 실제로 필요하게 될 때에 한해서 실제로 생성된다.

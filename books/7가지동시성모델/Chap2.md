# 스레드와 잠금장치

### 첫 번째 잠금장치

```java
package io.ryann10.app;

public class HelloWorld {
    public static void main(String[] args) throws InterruptedException {
        class Counter {
            private int count = 0;
            public void increment() { ++count; }
            public int getCount() { return count; }
        }

        final Counter counter = new Counter();

        class CountingThread extends Thread {
            public void run() {
                for (int i = 0; i < 10000; i++) {
                    counter.increment();
                }
            }
        }

        CountingThread t1 = new CountingThread();
        CountingThread t2 = new CountingThread();

        t1.start(); t2.start();
        t1.join(0); t2.join();
        System.out.println(counter.getCount());
    }
}
```

Result

```bash
> Task :compileJava
> Task :processResources NO-SOURCE
> Task :classes

> Task :HelloWorld.main()
11160
```

++count 코드를 읽었을 때 자바 컴파일러가 만드는 바이트코드

```bash
getfield #2 // count 값 읽기
iconst_1
iadd        // iconst_1 에 1 더하기
putfield #2 // 결과를 count에 저장
```

두 개의 스레드가 동시에 increment()를 실행한다고 생각하자. 스레드 1이 getfield #2를 수행하여 42라는 값을 읽는다. 그 상태에서 다음 단계로 넘어가기 전에 스레드 2도 getfield #2를 실행해서 42를 읽는다. 여기서 두 스레드가 모두 42에 1을 더한 결괏값 43을 count에 저장하게 된다. count가 두 번이 아니라 한 번만 증가된 것과 동일한 결과가 된다.

이런 상황에 대한 해법은 count에 대한 접근을 동기화synchronize하는 것이다. 그렇게 하는 방법의 하나는 자바 객체에 포함되어 있는 잠금장치intrinsic lock(mutex, monitor, critical section)을 이용하는 것이다.

```java
class Counter {
  private int count = 0;
  public synchronized void increment() { ++count; }
  public int getCount() { return count; }
}
```

이제 increment() 메소드가 호출되면 우선 Counter 객체가 가지고 있는 잠금장치를 요구한다. 메소드가 리턴할 때에는 자동으로 잠금장치도 해제된다. 따라서 한 번에 오직 하나의 스레드만 메소드를 실행할 수 있으며, 메소드에 동시에 접근하는 다른 스레드들은 잠금장치가 해제될 때까지 블로킹된다.

2.2.4 메모리 가시성

자바 메모리 모델은 한 스레드가 메모리에 가한 변화가 다른 메모리에 보이는 경우를 정의한다. 읽는 스레드와 쓰는 스레드가 동기화되지 않으면 그러한 가시성이 보장되지 않는다.

### 1일 차 에서 배운 내용

- 공유되는 변수에 대한 접근을 반드시 동기화한다.
- 쓰는 스레드와 읽는 스레드가 모두 동기화되어야 한다.
- 여러 개의 잠금장치를 미리 정해진 공통의 순서에 따라 요청한다.
- 잠금장치를 가진 상태에서 외부 메소드를 호출하지 않는다.
- 잠금장치는 최대한 짧게 보유한다.

### 1일 차 자율학습

- [윌리엄 푸의 자바 메모리 모델](http://www.cs.umd.edu/~pugh/java/memoryModel/index.html#reference)
- [JSR 133 FAQ](http://www.cs.umd.edu/~pugh/java/memoryModel/jsr-133-faq.html)
- 초기화 안전성과 관련해서 자바 메모리 모델이 보장해주는 내용은 무엇인가? 스레드 사이에서 객체를 안전하게 주고받기 위해서 잠금장치를 사용하는 것이 항상 필요한가?
- 중복확인 잠금장치double-checked locking 안티패턴이란 무엇인가? 그것이 안티패턴으로 불리는 이유는 무엇인가?

https://parkcheolu.tistory.com/14
# JVM 이야기

## 인터프리팅, 클래스로딩

JVM은 스택 기반의 interpreter machine. physical cpu hardware인 register는 없지만 일부 결과를 execution stack에 보관. 이 스택의 맨 위에 쌓인 값을 가져와 계산.

java HelloWorld -> OS는 VM process(java binary)를 구동 -> 자바 가상 환경이 구성, 스택 머신 초기화 -> HelloWorld class 파일 실행

클래스로딩 메커니즘

자바 프로세스 초기화 -> 클래스로더 작동 -> 부트스트랩 클래스가 런타임 코어 클래스를 로드
(자바9 부터는 런타임이 모듈화되고 클래스로딩 개념이 달라짐)

부트스트랩 클래스로더 임무: 다른 클래스로더가 나머지 시스템에 필요한 클래스를 로드할 수 있게 최소한의 필수 클래스

부트스트랩 클래스로더 -> 확장 클래스로더 로드 -> 애플리케이션 클래스로더(시스템 클래스로더) 생성 -> 지정된 클래스패스에 위치한 유저 클래스로더 로드'

---
ClassNotFoundException 예외 발생 과정

Java 프로그램 실행 중 처음 보는 새 클래스를 애플리케이션 클래스로드에게 룩업 요청 -> 클래스를 찾지 못한 클래스로더는 다시 부모 클래스로더에게 요청 -> 반복 -> 부트스트랩 클래스로더도 룩업하지 못하면 예외 발생

* 한 시스템에서 클래스는 패키지 명을 포함한 풀 클래스 명과 자신을 로드한 클래스로더, 두 가지 정보로 식별

## 바이트코드 실행

javac: 자바 소스 코드를 .class 파일의 바이트코드(IR) 형태로 변환. 최적화는 거의 하지 않음. VM 명세서에 정의된 구조를 가짐. JVM이 클래스를 로드할 때 해당 정의를 준수하고 있는 지 검사.

클래스 파일 해부도 일부

- 매직 넘버: 클래스 파일임을 나타내는 4바이트 16진수 + 클래스 파일을 컴파일 할 때 꼭 필요한 메이저/마이너 버전 숫자
- 상수 풀: 클래스명, 인터페이스명, 필드 명 등이 존재. JVm은 코드 실행 시 런타임 메모리 대신, 상수 풀 테이블을 찾아보고 필요한 값을 참조

`javac HelloWorld.java` -> `HelloWorld.class` -> `javap -c HelloWorld.class`

```java
public class HelloWorld {
    public static void main(String[] args) {
        for (int i = 0; i < 10; i++) {
            System.out.println("Hello World");
        }
    }
}
```

```bash
λ javap -c HelloWorld.class
Compiled from "HelloWorld.java"
public class HelloWorld {
  public HelloWorld();
    Code:
       0: aload_0
       1: invokespecial #1                  // Method java/lang/Object."<init>":()V
       4: return

  public static void main(java.lang.String[]);
    Code:
       0: iconst_0
       1: istore_1
       2: iload_1
       3: bipush        10
       5: if_icmpge     22
       8: getstatic     #2                  // Field java/lang/System.out:Ljava/io/PrintStream;
      11: ldc           #3                  // String Hello World
      13: invokevirtual #4                  // Method java/io/PrintStream.println:(Ljava/lang/String;)V
      16: iinc          1, 1
      19: goto          2
      22: return
}
```

javac가 클래스 파일에 기본 생성자를 자동으로 추가하기 때문에 메서드는 총 2개 생성

생성자 바이트코드 순서
0. 생성자에서 this 레퍼런스를 스택 상단에 올려놓는 aload_0 명령이 실행
1. invokespecial 명령이 호출 -> 슈퍼생성자들을 호출하고 객체를 생성 -> 특정 작업을 담당하는 인스턴스 메서드를 실행 -> Object 디폴트 생성자가 매치

메인 함수 바이트코드 순서
0. iconst_0 정수형 상수 0을 stack에 푸시
1. istore_1으로 상수값을 오프셋 1에 위치한 지역 변수(i)에 저장 (인스턴스 메소드에서 0번째 엔트리는 무조건 this)
2. iload_1 오프셋 1의 변수를 스택으로 다시 로드
3. bipush 10 상수 10을 푸시
4. if_icmpge 둘을 비교
5. 처음은 실패할테니 getstatic #2, ldc #3, invokevirtual #4를 통해 System.out의 정적 메서드를 해석하고 상수 풀에서 "Hello World"라는 스트링을 로드하여 인스턴스 메소드를 실행
6. iinc 1, 1 정수값 1 증가
7. goto 2 를 통해 2번 명령으로 다시 이동
8. if_icmpge 이 만족하면 22번 명령으로 넘어가 리턴


## 2.3 핫스팟 가상 머신

자바는 제로-오버헤드 추상화 철학에 동조하지 않는 언어
제로-오버헤드: 비용이 발생하지 않는 추상화 철학에 근거한 기계어에 가까운 구현.

## 2.4 JVM 메모리 관리

자바는 GC 프로세스를 이용해 힙 메모리를 자동 관리하는 방식으로 메모리 문제를 해결. jVM이 더 많은 메모리를 할당해야 할 때 불필요한 메모리를 회수하거나 재사용하는 nondeterministic 프로세스

GC가 실행디면 다른 애플리케이션은 모두 중단되고 하던 일은 멈춰야 함

## 2.5 스레딩, 자바메모리모델

자바 스레드 생성 및 실행 방법

```java
Thread t = new Thread(() -> {System.out.println("Hello World!");});
t.start();
```

자바 애플리케이션 스레드는 전용 OS 스레드와 1:1 대응
공유 스레드 풀을 이용해 전체 자바 애플리케이션 스레드를 실행하는 그린 스레드 방식은 복잡도만 가중시키지 성능은 X

90년대 후반 부터 자바의 멀티 스레드 기본 설계 원칙

- 자바 프로세스의 모든 스레드는 가비지가 수집되는 하나의 공용 힙 소유
- 한 스레드가 생성한객체는 그 객체를 참조하는 다른 스레드가 액세스 가능
- 기본적으로 객체는 mutable.

## 2.7 JVM 모니터링, 툴링

Instrumentation: 오류 진단이나 성능 개선을 위해 애플리케이션에 특정한 코드를 끼워 넣는 것

- Java Management Extensions(JMX)
- Java agent
- JVM Tool Interface(JVMTI)
- Serviceability Agent(SA)

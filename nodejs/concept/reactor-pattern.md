# Reactor 패턴

- I/O는 속도가 느림
- 전통적인 블로킹 I/O 프로그래밍에서는 I/O 요청에 해당하는 함수 호출은 작업이 완료 될 때까지 스레드 실행이 차단 됨

## 블로킹 I/O
일반적인 블로킹 스레드

```javascript
// 데이터를 사용할 수 있을 떄까지 스레드가 블록
data = socket.read();

// 데이터 사용 가능
print(data);
```

-웹 서버에서 동일한 스레드에서 여러 연결을 처리할 수 없는 문제를 해결하기 위해, 처리해야 하는 각가의 동시 연결에 대해 새로운 스레드 또는 프로세스를 시작하거나 풀에서 가져온 스레드를 재사용 하는 것. 스레드가 I/O 작업으로 차단되어도 분리된 스레드에서 처리되므로 다른 요청의 가용성에는 영향 X
- 하지만 스레드는 메모리 소비, 컨텍스트 전환 문제 등으로 인해 비효율적임

### 논 블로킹 I/O

- 시스템 호출을 데이터가 읽히거나 쓰여질떄까지 기다리지 않고 항상 즉시 반환하는 방법
  - 예) Unix의 fcntl(): fcntl 함수는 기존 file descriptor를 조작하여 운영 모드를 논 블로킹으로 변경하는데 사용. 일단 자원이 논 블로킹 모드에 있으면 자원에 읽을 준비가 된 데이터가 없을 경우, 모든 읽기 조작은 코드 EAGAIN을 반환하여 실패 노티

- 가장 기본적인 액세스 패턴은 데이터가 반환될 때까지 루프 내에서 리소스를 polling -> busy-waiting

```javascript
resources = [socketA, socketB, pipeA];

while(!resources.isEmpty()) {
  for (i = 0; i < resources.length; i++) {
    resource = resources[i];

    // 읽기 시도
    let data = resource.read();

    if (data === NO_DATA_AVAILABLE) {
      continue;
    }

    if (data === RESOURCE_CLOSED) {
      // 데이터 리소스가 닫혔기 때문에, 리소스 목록에서 제거
      resources.remove(i);
    } else {
      // 데이터가 도착해 이를 처리
      consumeData(data);
    }
  }
}
```

단점

- 루프를 대부분 사용할 수 없는 리소스를 반복하는데만 CPU를 사용. CPU 리소스 낭비 초래

### 이벤트 디멀티플렉싱

동기 이벤트 디멀티플렉서/이벤트 통지 인터페이스: Busy-waiting시 효율적인 논 블로킹 리소스 처리를 위한 기본적인 메커니즘

디멀티플렉서를 사용하는 수도 코드

```javascript
socketA, pipeB;
watchedList.add(socketA, FOR_READ;
watchedList.add(pipeB, FOR_READ);
while(events = demultiplexer.watch(watchedList)) {
  // 이벤트 루프
  foreach(event in events) {
    // 여기서 read는 블록되지 않으며 비어 있더라도 항상 데이터를 반환
    data = event.resource.read();

    if (data === RESOURCE_CLOSED) {
      // 리소스 목록에서 제거
      demultiplexer.unwatch(event.resource);
    } else {
      // 데이터 처리
      consumeData(data);
    }
  }
}
```

### Reactor 패턴

핵심 개념: 각 I/O 작업과 관련된 핸들러(Node.js에서는 callback 함수)를 갖는 것. 이 핸들러는 이벤트가 생성되어 이벤트 루프에 의해 처리되는 즉시 호출

1. 애플리케이션은 이벤트 디멀티플렉서로 요청을 전달함으로써 새로운 I/O작업을 생성. 처리가 완료될 때 호출될 핸들러를 지정. 이벤트 디멀티플렉서에 새 요청을 전달하는 것은 논 블로킹 호출이며, 즉시 애플리케이션에 제어를 반환
2. 일련의 I/O 작업들이 완료되면 이벤트 디멀티플렉서는 새 이벤트를 이벤트 큐에 추가
3. 이벤트 루프가 이벤트 큐의 항목들에 대해 이터레이션을 반복
4. 각 이벤트에 대해 관련된 핸들러가 호출
5. 애플리케이션 코드 일부인 핸들러는 실행이 완료되면 이벤트 루프에 제어를 반환. 핸들러 실행 중에 새로운 비동기 동작 요청이 발생하여 제어가 이벤트 루프로 돌아가기 전에 새로운 요청이 이벤트 디멀티플렉서에 삽입될 수도 있음
6. 이벤트 큐 내 모든 항목이 처리 되면, 루프는 이벤트 디멀티플렉서에서 다시 블록되고 처리 가능한 새로운 이벤트가 있을 때 이 과정을 트리거

> Node.js 애플리케이션은 이벤트 디멀티플렉서에 더 이상 보류 중인 작업이 없고 이벤트 큐에서 더 이상 처리할 이벤트가 없을 때 자동으로 종료

#### libuv

서로 다른 OS에서 발생하는 불일치 때문에 이벤트 디멀티플렉서는 높은 수준의 추상화가 필요

예) 각 I/O작업은 동일한 OS 내에서도 리소스 유형에 따라 매우 다르게 작동할 수 있음. Unix에서 일반 파일 시스템의 파일은 논 블로킹 작업을 지원하지 않으므로 논 블로킹 동작을 시뮬레이션 하려면 이벤트 루프 외부에 별도의 스레드를 사용해야 함

참고: https://nikhilm.github.io/uvbook/

### Node.js

Node.js 플랫폼 구조

- 바인딩: libuv와 기타 저수준의 기능등을 JavaScript에 래핑하고 사용 가능하게 함
- V8: JavaScript 엔진
- 코어 JavaScript API: 상위 수준의 Node.js를 구현하고 있는 라이브러리(a.k.a 노드 코어)

# The observer pattern

옵저버 패턴은 Node.js의 reactive 특성을 모델링하고 콜백을 완벽하게 보완하는 이상적인 해결책

## EventEmitter 클래스

전통적인 객체지향 프로그래밍에서 관찰자 패턴에는 인터페이스와 구현된 클래스들 그리고 계층 구조가 필요하지만 Node.js에서는 훨씬 간단

EventEmitter는 prototype이며 코어 모듈로부터 익스포트된다.

```javascript
const EventEmitter = require('events').EventEmitter;
const eeInstance = new EventEmitter();
```

### 오류 전파

EventEmitter는 이벤트가 비동기로 발생할 경우 이벤트 루프에서 손실될 수 있기 떄문에 콜백에서와 같이 예외가 발생해도 예외를 바로 throw 할 수 없다.

대신 error라는 특수한 이벤트를 발생시키고 Error 객체를 인자로 전달한다.

### 동기 및 비동기 이벤트

동기 이벤트와 비동기 이벤트의 주된 차이점은 리스너를 등록할 수 있는 방법에 있다.

이벤트가 비동기로 발생하면 EventEmitter가 초기화된 후에도 프로그램은 새로운 리스너를 등록할 수 있다. 이벤트가 이벤트 루프 다음 사이클이 될 때까지는 실행되지 않을 것이기 떄문

반대로 이벤트를 동기로 발생시키려면 EventEmitter 함수가 이벤트를 방출하기 전에 모든 리스너가 등록되어 있어야 한다.


```javascript
const EventEmitter = require('events').EventEmitter;

class SyncEmit extends EventEmitter {
  constructor() {
    super();
    this.emit('ready');
  }
}

const syncEmit = new SyncEmit();

syncEmit.on('ready', () => console.log('Object is ready to be used'));
```

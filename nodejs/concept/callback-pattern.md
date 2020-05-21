# 콜백 패턴

JavaScript는 함수가 일급 클래스 객체first class object로 변수에 수비게 할당하거나, 인수로 전달되거나, 다른 함수 호출에서 반환되거나 자료구조에 저장될 수 있음

클로저closure를 사용해 실제 함수가 작성된 환경을 참조할 수 있음. 콜백이 언제 어디서 호출되는 지 관계 없이 비동기 작업이 요청된 컨텍스트를 항상 유지할 수 있기 때문

## CPS, Continuation-Passing Style

함수형 프로그래밍에서 다른 함수에 인수로 함수가 전달되고 작업이 완료되면 결과로 호출되는 방식을 CPS라고 함

### 동기식 연속 전달 방식

```javascript

# 기본적인 동기 함수
function add(a, b) {
  return a + b;
}

# CPS 스타일
function add(a, b, callback) {
  return callback(a, b);
}

console.log('before');
add(1, 2, result => console.log('Result: ' + result));
console.log('after');
```

실행 시

```bash
before
result: 3
after
```

### 비동기식

```javascript
function additionAsync(a, b, callback) {
  setTimeout(() => callback(a + b), 100);
}

console.log('before');
additionAsync(1, 2, result => console.log('Result: ' + result));
console.log('after');
```

실행 시

```
before
after
Result: 3
```

#### 차이

동기 함수는 조작을 완료할 때까지 블록. 비동기 함수는 제어를 즉시 반환하고 결과는 이벤트 루프 다음 사이클에서 핸들러(콜백)로 전달

### Non-continuation-passing style Callback

콜백은 배열 내의 요소를 반복하는데 사용될 뿐 연산 결과를 전달하지 않음

```javascript
const result = [1, 5, 7].map(e => e - 1);
console.log(result); // [0, 4, 6]
```

### Sync vs Async

아래는 동기와 비동기가 모두 존재하는 불완전한 함수

```javascript
const fs = require('fs');

const cache = {};

function inconsistentRead(filename, callback) {
  if (cache[filename]) {
    // call synchronously
    callback(cache[filename]);
  } else {
    // call asynchronously
    fs.readFile(filename, 'utf8', (err, data) => {
      cache[filename] = data;
      callback(data);
    });
  }
}
```

완전히 동기화

```javascript
const fs = require('fs');

const cache = {};

function consistentReadSync(filename) {
  if (cache[filename]) {
    callback(cache[filename]);
  } else {
    cache[filename] = fs.readFileSync(filename, 'utf8');
    return cache[filename];
  }
}
```

비동기로

```javascript
function consistentReadAsync(filenmae, callback) {
  if (cache[filenmae]) {
    process.nextTick(() => callback(cache[filename]));
  } else {
    // 비동기 함수
    fs.readFile(filenmae, 'utf8', (err, data) => {
      cache[filename] = data;
      callback(data);
    })
  }
}
```

# 모듈 로더

## 모듈을 로드하고 private 범위로 감싸 평가하는 함수

```javascript
function loadModule(filename, module, require) {
  const wrappedSrc=`function(module, exports, require) {
    ${fs.readFileSync(filename, 'utf8')}
  })(module, module.exports, require);`;

  eval(wrappedSrc);
}
```

## require() 함수

```javascript
const requrie = (moduleName) => {
  console.log(`Require invoked for module: ${moduleName}`);

  // 모듈 전체 경로 알아내기
  const id = requrie.resolve(moduleName);

  // 캐시된 경우 즉시 리턴
  if (require.cache[id]) {
    return require.cache[id].exports;
  }

  /**
  * 모듈 메타데이터a
  * exports 빈 객체 리터럴을 통해 초기화된 exports 속성을 가지고 있는 module 객체 생성
  */
  const module = {
    exports: {},
    id: id
  };

  // 캐싱
  require.cache[id] = module;

  loadModule(id, module, require);

  // 불러온 모듈 코드에서 public API를 익스포트
  return module.exports;
};

require.cache = {};

require.resolve = (moduleName) => {
  /* moduleName에서 모듈 ID를 확인 */
}
```

## 예제 모듈

module.exports 변수에 할당되지 않은 한 모듈 내부의 모든 항목은 private. require()를 사용하여 모듈을 로드하면, 이 변수의 내용은 캐싱된 후 반환

```javascript
// 다른 종속성 로드
const dependency = require('./anotherModule');

// private 함수
function log() {
  console.log(`Well done ${dependency.username}`);
}

// 익스포트되어 외부에서 사용될 API
module.exports.run = () => {
  log();
};
```

### 동기적 require 함수

올바르지 않은 module.exports 할당

```javascript
setTimeout(() => {
  module.exports = function() {...};
}, 100);
```

이러한 접근 방식의 문제점은 require를 사용해 모듈을 로드한다고 해서 사용할 준비가 된다는 보장이 없다는 것

원래 Node.js는 비동기 버전의 require()를 사용 했지만 과도한 복잡성으로 인해 곧 제거됨

실제로는 초기화 시에만 사용되는 비동기 입출력이 장점보다 더 큰 복잡성을 가졌음

### Resolving algorithm

Node.js는 모듈이 로드되는 위치에 따라 다른 버전의 모듈을 로드할 수 있도록 하여 의존성 지옥dependency hell 문제를 우아하게 해결함

이 장점을 require 함수의 resolving 알고리즘에도 적용 됨

#### resolve() 함수

- 모듈 이름을 입력으로 사용하여 모듈 전체의 경로를 반환. 이 경로는 코드를 로드하고 모듈을 고유하게 식별하는데 사용
- Resolving 알고리즘 종류
  - 파일 모듈: moduleName이 '/'로 시작하면 이미 모듈에 대한 절대 경로라고 간주되어 그대로 반환. ./으로 시작하면 상대 견로로 간주하여 계산
  - 코어 모듈: moduleName이 '/' 또는 './'로 시작하지 않으면 알고리즘은 먼저 코어 Node.js 모듈 내에서 검색 시도
  - 패키지 모듈: moduleName과 일치하는 코어 모듈이 없는 경우, 요청 모듈의 경로에서 시작하여 디텍토리 구조를 탐색하여 올라가면서 node_modules 디렉토리를 찾고 그 안에서 일치하는 모듈을 찾음. 파일 시스템의 루트에 도달할 때까지 디텍토리 트리를 올라가면서 다음 node_modules 디렉토리를 탐색하여 계속 일치하는 모듈을 찾음

- 참고: https://nodejs.org/api/modules.html

### 모듈 캐시

require() 후속 호출은 단순히 캐시된 버전을 반환하기 떄문에 각 모듈은 처음 로드될 때만 로드되고 평가됨

캐싱 기능

- 모듈 의존성 내에서 순환을 가질 수 있음
- 일정한 패키지 내에서 동일한 모듈이 필요할 때는 어느 정도 동일한 인스턴스가 항상 반환된다는 것을 보장

모듈 캐시는 require.cache에 변수를 통해 외부에 노gf되므로 필요한 경우 모듈 캐시에 직접 액세스 할 수 있음

require.cache에서 관련 키를 삭제하여 캐시된 모듈을 무효화하는 것도 가능

## 모듈 정의 패턴

### named exports


```javascript
// logger.js 파일
exports.info = (message) => {
  console.log('info: ' + message);
};

exports.verbose = (message) => {
  console.log('verbose: ' + message);
};
```

CommonJs 명세에는 public 멤버들을 공개하는 exports 변수 만을 사용하도록 하고 있다

따라서 exports로 지정하는 것만이 CommonJS 명세와 호환되는 유일방 방법

### Exporting a function

Substack 패턴으로도 불리며 모듈에 대한 명확한 진입점을 제공하는 단일 기능을 제공하여 그것에 대한 이해와 사용할 단순화하는 것

```javascript
// logger.js 파일
module.exports = (message) => {
  console.log(`info: ${message}`);
};
```

이 패턴을 응용하여 다른 public API의 네임스페이스로 사용할 수 있다. 이렇게 하면 모듈에 단일 진입점의 명확성을 제공할 수 있다.

```javascript
module.exports.verbose = (message) => {
  console.log(`verbose: ${messgae}`);
};
```

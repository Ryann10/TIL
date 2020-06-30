# JavaScript engine fundamentals: Shapes and Inline Caches

<https://mathiasbynens.be/notes/shapes-ics>

# Dynamic Type vs Static Type

- 객체의 프로퍼티에 접근하는 속도 면에서 Static Type 언어에 비해 느림
- Static Type
    - 프로퍼티의 메모리 오프셋을 컴파일 시에 결정 할 수 있음
    - 프로퍼티를 선언할 때 오프셋 값을 어딘가 저장한 뒤, 프로퍼티의 값이 필요할 때 오프셋 값을 그대로 사용
    - 가변길이 배열과 같은 동적 데이터 타입은 예외
- Dynamic Type
    - 프로퍼티의 메모리 오프셋을 컴파일 할 때 결정할 수 없음
    - 동적 탐색(dynamic lookup)이 필요
    - JS와 같은 Dictionary 형태의 객체를 이용한다면, 객체의 프로퍼티를 읽어들일 때 비용이 발생하며 구현방식에 따라 비용이 달라짐

# 엔진

## 엔진 파이프라인

![https://mathiasbynens.be/_img/js-engines/js-engine-pipeline.svg](https://mathiasbynens.be/_img/js-engines/js-engine-pipeline.svg)

- 소스 코드 파싱 → AST
- interpreter가 바이트 코드를 생성
- profiling한 data를 이용하여 optimizing 컴파일러에 의해 코드 최적화

## 히든 클래스

- 히든 클래스를 이용하여 동적 탐색을 회피
    - 프로퍼티가 바뀔 때 각각 그 프로퍼티의 오프셋을 업데이트한 뒤 그 값을 가지고 있음
- 객체는 반드시 하나의 히든 클래스를 참조
- 각 프로퍼티에 대해 메모리 오프셋을 소유저
- 동적으로 새로운 프로퍼티가 만들어질 때, 혹은 기존 프로퍼티가 삭제되거나 기존 프로퍼티의 데이터 타입이 바뀔 때
    - 신규 히든 클래스가 생성
    - 신규 히든 클래스는 기존 프로퍼티에 대한 정보를 유지하면서 추가적으로 새 프로퍼티의 오프셋을 소유
- 프로퍼티에 대해 변경이 발생했을 때 참조해야 하는 히든 클래스에 대한 정보를 소유
- 객체에 프로퍼티가 새로 생성되면, 현재 참조하고 있는 히든 클래스의 전환 정보를 확인한 후, 현재 프로퍼티에 대한 변경이 전환 정보의 조건과 일치하면 객체의 참조 히든 클래스를 조건에 명시된 히든 클래스로 변경

생성과정

### **C0**

- 객체가 생성될 때는 반드시 히든 클래스가 생성

```jsx
var object = {};
```

### **C1**

- x 프로퍼티에 대한 오프셋을 가지는 히든 클래스 C1
- x를 추가하면 참조하는 히든 클래스가 C1으로 전환된다는 정보가 C0클래스에 추가

```jsx
var object = {};
obj.x = 5;
```

### **C2**

- object 객체에 대응하는 히든 클래스가 C1에서 C2로 변경
- C1 클래스에는 y를 추가하면 참조하는 히든 클래스가 C2로 변경된다는 정보가 추가됨

```jsx
var object = {};
obj.x = 5;
obj.y = 6;
```

![https://mathiasbynens.be/_img/js-engines/shape-chain-2.svg](https://mathiasbynens.be/_img/js-engines/shape-chain-2.svg)

- object.y 에 대한 접근이 발생한다면?
    - object 객체와 연결되어 있는 히든 클래스 찾기 => C2
    - C2 클래스에 적혀있는 y 프로퍼티의 오프셋을 이용해서 y의 값을 참조

## 전환 정보

```jsx
function Person(name) {  
	this.name = name;
}

var foo = new Person("yonehara");
var bar = new Person("suzuki");
console.log(bar.name);
```

### **var foo = new Persion("yonehara");**

- 히든 클래스 C0
    - 프로퍼티의 오프셋 값 없음
    - name을 추가하면 C1으로 전환된다는 정보가 있음
- 히든 클래스 C1
    - name의 오프셋 값

### **var bar = new Person("suzuki");**

- bar 객체는 다음에 name을 추가할 때 새로운 히든 클래스를 생성하지 않고 C1 클래스를 참조하여, 자기 자신과 C1 클래스를 연결

## 인라인 캐싱

- 히든 클래스를 사용하게 되면 객체가 많아졌을 때 메모리는 절약 가능
- 객체 → 히든 클래스 → 프로퍼티 테이블 → 프로퍼티 비교 → <오브젝트 + 오프셋> 위치로 접근이라는 단계를 거쳐야 함
- 접근하려는 프로퍼티의 오프셋 값을 캐싱
    - 동적인 언어라고해도 실제로는 바뀌지 않는데 더 많다
    - 성능 최적화는 루프에서

```jsx
function getX(o) {
    return o.x;
}
```

- 위의 코드는 JavaScriptCore에서 아래와 같은 바이트코드를 생성

![https://mathiasbynens.be/_img/js-engines/ic-1.svg](https://mathiasbynens.be/_img/js-engines/ic-1.svg)

- get_by_id instruction은 프로퍼티 x를 첫번째 argument인 arg1에서 불러와 loc0 에 저장
- 두번째 instruction에서 loc0 저장한 값을 리턴

    ![https://mathiasbynens.be/_img/js-engines/ic-3.svg](https://mathiasbynens.be/_img/js-engines/ic-3.svg)

- getX 함수를 처음 호출 시, get_by_id instruction은 프로퍼티 x 값이 0번째 오프셋에 위치 했다는 것을 확인
- 인라인 캐싱을 적용하여, get_by_id 는 객체의 shape 과 프로퍼티의 offset 을 기억

참고

- [https://engineering.linecorp.com/ko/blog/detail/232](https://engineering.linecorp.com/ko/blog/detail/232)
- [https://mathiasbynens.be/notes/shapes-ics](https://mathiasbynens.be/notes/shapes-ics)
- [http://meetup.toast.com/posts/78](http://meetup.toast.com/posts/78)

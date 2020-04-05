# Loop-Invariant Code Motion (LICM)

루프 내에서 항상 동일한 결과를 생성하는 코드를 Loop-Invariant code라고 함

이러한 코드는 루프 밖으로 이동시켜 컴파일러 최적화 하는 방법을 Loop-Invariant Code Motion

## Example

Before optimization,

```none
int i = 0;
while (i < n) {
    x = y + z;
    a[i] = 6 * i + x * x;
    ++i;
}
```

After

```none
int i = 0;
if (i < n) {
    x = y + z;
    int const t1 = x * x;
    do {
        a[i] = 6 * i + t1;
        ++i;
    } while (i < n);
}
```

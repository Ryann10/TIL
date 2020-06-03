# Time Complexity: Primality

`Medium`

```java
static String primality(int n) {
    if (n == 1 || (n != 2 && n % 2 == 0)) {
        return "Not prime";
    }

    for (int i = 3; i <= Math.sqrt(n); i += 2) {
        if (n % i == 0) {
            return "Not prime";
        }
    }

    return "Prime";
}
```

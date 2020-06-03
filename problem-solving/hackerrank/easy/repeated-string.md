# Repeated String

<https://www.hackerrank.com/challenges/repeated-string/problem>

```java
static long repeatedString(String s, long n) {
    int aInS = 0;
    int aInSInRemainder = 0;

    int remainderLength = (int)(n % s.length());

    for (int i = 0; i < s.length(); i++) {
        if (s.charAt(i) == 'a') {
            aInS++;

            if (i < remainderLength) {
                aInSInRemainder++;
            }
        }
    }

    return ((n / s.length()) * aInS) + aInSInRemainder;
    }
```

# Alternating Characters

`Easy`

<https://www.hackerrank.com/challenges/alternating-characters/problem>

```java
static int alternatingCharacters(String s) {
    int count = 0;
    char alphabet = s.charAt(0);

    for (int i = 1; i < s.length(); i++) {
        if (alphabet == s.charAt(i)) {
            count++;
        } else {
            alphabet = alphabet == 'A' ? 'B' : 'A';
        }
    }

    return count;
}
```

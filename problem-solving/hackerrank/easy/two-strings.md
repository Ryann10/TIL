# Two Strings

<https://www.hackerrank.com/challenges/two-strings/problem>

```java
static String twoStrings(String s1, String s2) {
    boolean[] alphabets = new boolean[26];
    for (char a : s1.toCharArray()) {
        alphabets[a - 'a'] = true;
    }

    for (char a : s2.toCharArray()) {
        if (alphabets[a - 'a']) {
            return "YES";
        }
    }

    return "NO";
}
```

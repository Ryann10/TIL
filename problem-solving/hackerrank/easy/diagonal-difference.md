# Diagonal Difference

<https://www.hackerrank.com/challenges/diagonal-difference/problem>

`5 mintues`

```java
public static int diagonalDifference(List<List<Integer>> arr) {
// Write your code here
  int diff = 0;

  for (int i = 0; i < arr.size(); i++) {
    List<Integer> inner = arr.get(i);

    diff += inner.get(i) - inner.get(inner.size() - 1 - i);
  }

  return Math.abs(diff);
}
```

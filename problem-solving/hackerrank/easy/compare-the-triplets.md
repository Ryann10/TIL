# Compare the Triplets

<https://www.hackerrank.com/challenges/compare-the-triplets/problem>

`5 mintues`

```java
static List<Integer> compareTriplets(List<Integer> a, List<Integer> b) {
  int aWins = 0;
  int bWins = 0;

  for (int i = 0; i < a.size(); i++) {
    if (a.get(i) > b.get(i)) {
      aWins++;
    } else if(a.get(i) < b.get(i)) {
      bWins++;
    }
  }

  return Arrays.asList(aWins, bWins);
}
```

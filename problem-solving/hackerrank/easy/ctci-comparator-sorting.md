# ctci-comparator-sorting

`Easy`

<https://www.hackerrank.com/challenges/ctci-comparator-sorting>

```java
public int compare(Player a, Player b) {
    int scoreDiff = a.score - b.score;

    if (scoreDiff == 0) {
        return a.name.compareTo(b.name);
    }

    return scoreDiff > 0 ? -1 : 1;
}
```

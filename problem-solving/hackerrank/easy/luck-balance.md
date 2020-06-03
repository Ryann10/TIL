# Luck balance

`Easy`

<https://www.hackerrank.com/challenges/luck-balance/problem>

```java
static int luckBalance(int k, int[][] contests) {
    int luck = 0;

    List<Integer> balances = new ArrayList();

    for (int[] contest : contests) {
        if (contest[1] == 1) {
            balances.add(contest[0]);
        } else {
            luck += contest[0];
        }
    }

    Collections.sort(balances);

    for (int i = 0; i < balances.size(); i++) {
        if (i < (balances.size() - k)) {
            luck -= balances.get(i);
        } else {
            luck += balances.get(i);
        }
    }

    return luck;
}
```

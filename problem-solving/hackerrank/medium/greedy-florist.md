# Greedy florist

`Medium`

<https://www.hackerrank.com/challenges/greedy-florist/problem>

```java
static int getMinimumCost(int k, int[] c) {
    int cost = 0;

    Arrays.sort(c);

    int iter = c.length / k + c.length % k == 0 ? 0 : 1;

    for (int i = 0; i < c.length % k; i++) {
        cost += (c.length / k + 1)  * c[i];
    }

    int totalPurchase = c.length / k;
    for (int i = c.length % k; i < c.length; i++) {
        cost += c[i] * (totalPurchase - ((i - c.length % k) / k));
    }

    return cost;
}
```

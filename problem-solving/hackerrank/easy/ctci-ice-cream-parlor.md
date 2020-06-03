# Hash Tables: Ice Cream Parlor

`Medium`

<https://www.hackerrank.com/challenges/ctci-ice-cream-parlor/problem>

```java
static void whatFlavors(int[] costs, int money) {
    HashMap<Integer, Integer> map = new HashMap();

    for (int i = 0; i < costs.length; i++) {
        if (map.containsKey(costs[i])) {
            System.out.println(map.get(costs[i]) + " " + (i + 1));
            break;
        }
        map.put(money - costs[i], i + 1);
    }
}
```

# Max Array Sum

`Medium`

<https://www.hackerrank.com/challenges/max-array-sum/problem>

```java
static int maxSubsetSum(int[] arr) {
    if (arr.length == 0) {
        return 0;
    } else if (arr.length == 1) {
        return arr[0];
    }

    int[] sums = new int[arr.length];

    sums[0] = arr[0];
    sums[1] = Math.max(arr[0], arr[1]);

    for (int i = 2; i < arr.length; i++) {
        sums[i] = Math.max(sums[i - 2] + arr[i], sums[i - 1]);
        sums[i] = Math.max(sums[i], arr[i]);
    }

    return sums[arr.length - 1];
}
```

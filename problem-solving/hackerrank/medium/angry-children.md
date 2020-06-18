# Max Min

<https://www.hackerrank.com/challenges/angry-children/problem>

```java
static int maxMin(int k, int[] arr) {
  Arrays.sort(arr);

  int min = Integer.MAX_VALUE;

  for (int i = 0; i < arr.length - k + 1; i++) {
    min = Math.min(arr[i + k - 1] - arr[i], min);
  }

  return min;
}
```

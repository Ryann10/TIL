# MaxCounters

`Respectable`

## Solution

### 1st trial

`9 minutes`

77% Score

- failed large_random2
- failed exreme_large

```java
import java.util.Arrays;

class Solution {
    public int[] solution(int N, int[] A) {
        int[] arr = new int[N];
        Arrays.fill(arr, 0);
        int max = 0;

        for (int X: A) {
            if (X > N) {
                Arrays.fill(arr, max);
            } else {
                arr[X - 1]++;

                max = Math.max(arr[X - 1], max);
            }
        }

        return arr;
    }
}
```

### 2nd trial

`7 minutes`

Time complexity: O(N + M)
Space complexity: O(N)

```java
import java.util.Arrays;

class Solution {
    public int[] solution(int N, int[] A) {
        int[] arr = new int[N];
        Arrays.fill(arr, 0);

        int maxCounter = 0;
        int curMax = 0;

        for (int X : A) {
            if (X <= N) {
                int max = Math.max(arr[X - 1], maxCounter) + 1;

                arr[X - 1] = max;

                curMax = Math.max(max, curMax);
            } else {
                maxCounter = curMax;
            }
        }

        for (int i = 0; i < arr.length; i++) {
            arr[i] = Math.max(maxCounter, arr[i]);
        }

        return arr;
    }
}
```

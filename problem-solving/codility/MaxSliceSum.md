# MaxSliceSum

`Painless`

> leetcode 53번과 동일한 문제

## Solution

`6 minutes`

Time complexity: O(N)
Space complexity: O(1)

```java
class Solution {
    public int solution(int[] A) {
        int max = A[0];
        int sum = A[0];

        for (int i = 1; i < A.length; i++) {
            sum = Math.max(A[i], A[i] + sum);
            max = Math.max(max, sum);
        }

        return max;
    }
}
```

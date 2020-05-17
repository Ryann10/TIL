# BinaryGap

`Painless`

## Solution

`12 minutes`

Score: 100%

Time complexity: O(n)
Space complexity: O(1)

```java
class Solution {
    public int solution(int N) {
        // write your code in Java SE 8

        int maxIndex = 0;

        while (Math.pow(2, maxIndex + 1) < N) {
            maxIndex++;
        }

        int cur = 0;
        int max = 0;

        for (int i = maxIndex; i >= 0; i--) {
            if (N - Math.pow(2, i) >= 0) {
                N -= Math.pow(2, i);
                max = Math.max(max, cur);
                cur = 0;
            } else {
                cur++;
            }
        }

        return max;
    }
}
```

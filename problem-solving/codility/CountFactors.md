# CountFactors

`Painless`

## Solution

`13 minutes`

Time complexity: O(sqrt(N))
Space complexity: O(1)

```java
class Solution {

    public int solution(int N) {
        int count = 0;

        for (int i = 1; i <= Math.sqrt(N); i++) {
            if (N % i == 0 && i * i != N) {
                count += 2;
            } else if (i * i == N) {
                count++;
            }
        }

        return count;
    }
}
```

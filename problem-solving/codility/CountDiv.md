# CountDiv

`Respectable`

## Solution

`10 minutes`

Time complexity: O(1)
Space complexity: O(1)

```java
class Solution {
    public int solution(int A, int B, int K) {
        int start = A % K == 0 ? A : (A + (K - A % K));

        int end = B % K == 0 ? B : (B - (B % K));

        return (end / K) - (start / K) + 1;
    }
}
```

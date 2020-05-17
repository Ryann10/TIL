# FrogJmp

`Painless`

## Solution

`5 minutes`

Time complexity: O(1)
Space complexity: O(1)

```java
class Solution {
    public int solution(int X, int Y, int D) {
        boolean needsOneMoreJump = (Y - X) % D != 0;

        return (Y - X) / D + (needsOneMoreJump ? 1 : 0);
    }
}
```

# Distinct

`Painless`

## Solution

`8 minutes`

Time complexity: O(N*log(N)) or O(N)
Space complexity: O(1)

```java
import java.util.Arrays;

class Solution {
    public int solution(int[] A) {
        // write your code in Java SE 8
        if (A.length == 0) {
            return 0;
        }

        Arrays.sort(A);

        int count = 1;
        int curNum = A[0];

        for (int num : A) {
            if (curNum != num) {
                curNum = num;
                count++;
            }
        }

        return count;
    }
}
```

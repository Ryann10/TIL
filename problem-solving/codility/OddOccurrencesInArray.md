# OddOccurrencesInArray

`Painless`

## Solution

`14 minutes`

Time complexity: O(N) or O(N*log(N))
Space complexity: O(1)

```java
import java.util.Arrays;

class Solution {
    public int solution(int[] A) {
        Arrays.sort(A);

        int num = 0;

        for (int a : A) {
            if (num == 0) {
                num = a;
            } else {
                if (num - a < 0) {
                    return num;
                }
                num -= a;
            }
        }

        return num;
    }
}
```

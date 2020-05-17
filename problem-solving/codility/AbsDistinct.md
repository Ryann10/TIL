# AbsDistinct

`Painless`

## Solution

`4 minutes`

Time complexity: O(N) or O(N*log(N))
Space complexity: O(N)

```java
import java.util.*;
import java.lang.Math;

class Solution {
    public int solution(int[] A) {
        HashSet<Integer> set = new HashSet();
        for (int num : A) {
            set.add(Math.abs(num));
        }

        return set.size();
    }
}
```

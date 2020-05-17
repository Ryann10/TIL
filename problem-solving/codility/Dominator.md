# Dominator

`Painless`

## Solution

`13 minutes`

Time complexity: O(N*log(N)) or O(N)
Space complexity: O(N)

```java
import java.util.HashMap;
import java.util.Iterator;

class Solution {
    public int solution(int[] A) {
        // write your code in Java SE 8

        HashMap<Integer, Integer> counter = new HashMap();
        HashMap<Integer, Integer> indexes = new HashMap();

        for (int i = 0; i < A.length; i++) {
            if (counter.containsKey(A[i])) {
                counter.put(A[i], counter.get(A[i]) + 1);
            } else {
                counter.put(A[i], 1);
                indexes.put(A[i], i);
            }
        }

        for(HashMap.Entry<Integer, Integer> entry : counter.entrySet()){
            if (entry.getValue() > A.length / 2) {
                return indexes.get(entry.getKey());
            }
        }

        return -1;
    }
}
```

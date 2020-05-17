# MaxNonoverlappingSegments

`Painless`

## Solution

`34 minutes`

Time complexity: O(n)
Space complexity: O(1)

```java
class Solution {
    public int solution(int[] A, int[] B) {
        int num = 0;

        int i = 0;

        while (i < A.length) {
            num++;
            int cur = B[i];

            do {
                i++;
            } while (i < A.length && A[i] <= cur);
        }

        return num;
    }
}
```

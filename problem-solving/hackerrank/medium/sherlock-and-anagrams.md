# Sherlock and anagrams

`Medium`

<https://www.hackerrank.com/challenges/sherlock-and-anagrams/problem>

```java
static int sherlockAndAnagrams(String s) {
    int count = 0;

    for (int i = 1; i < s.length(); i++) {
        Map<String, Integer> map = new HashMap();

        for (int j = 0; j <= s.length() - i; j++) {
            String sub = s.substring(j, j + i);

            char[] chars = sub.toCharArray();

            Arrays.sort(chars);
            String sorted = new String(chars);

            map.put(sorted, map.containsKey(sorted) ? map.get(sorted) + 1 : 1);
        }

        for (Map.Entry<String, Integer> entry : map.entrySet()) {
            if (entry.getValue() > 1) {
                count += entry.getValue() * (entry.getValue() - 1) / 2;
            }
        }
    }

    return count;
}
```

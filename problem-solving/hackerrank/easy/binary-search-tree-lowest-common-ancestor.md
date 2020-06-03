# binary-search-tree-lowest-common-ancestor

`Easy`

<https://www.hackerrank.com/challenges/binary-search-tree-lowest-common-ancestor/problem>

```java
public static Node lca(Node root, int v1, int v2) {
    int min = v1 > v2 ? v2 : v1;
    int max = min == v1 ? v2: v1;

    if (root.data > min && root.data < max) {
        return root;
    }

    if (root.data > max) {
        return lca(root.left, v1, v2);
    } else if (root.data < min) {
        return lca(root.right, v1, v2);
    }

    return root;
}
```

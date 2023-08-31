## [2236.判断根结点是否等于子结点之和 中文官方题解](https://leetcode.cn/problems/root-equals-sum-of-children/solutions/100000/pan-duan-gen-jie-dian-shi-fou-deng-yu-zi-zr6q)
#### 方法一：直接判断

计算两个子结点值之和，判断是否等于根结点值即可。

```Java [sol1-Java]
class Solution {
    public boolean checkTree(TreeNode root) {
        return root.val == root.left.val + root.right.val;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool CheckTree(TreeNode root) {
        return root.val == root.left.val + root.right.val;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool checkTree(TreeNode* root) {
        return root->val == root->left->val + root->right->val;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def checkTree(self, root: Optional[TreeNode]) -> bool:
        return root.val == root.left.val + root.right.val
```

```C [sol1-C]
bool checkTree(struct TreeNode* root) {
    return root->val == root->left->val + root->right->val;
}
```

```Go [sol1-Golang]
func checkTree(root *TreeNode) bool {
    return root.Val == root.Left.Val + root.Right.Val
}
```

```JavaScript [sol1-JavaScript]
var checkTree = function(root) {
    return root.val === root.left.val + root.right.val;
};
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。
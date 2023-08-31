## [965.单值二叉树 中文官方题解](https://leetcode.cn/problems/univalued-binary-tree/solutions/100000/dan-zhi-er-cha-shu-by-leetcode-solution-15bn)

#### 方法一：深度优先搜索

**思路与算法**

一棵树的所有节点都有相同的值，当且仅当对于树上的每一条边的两个端点，它们都有相同的值（这样根据传递性，所有节点都有相同的值）。

因此，我们可以对树进行一次深度优先搜索。当搜索到节点 $x$ 时，我们检查 $x$ 与 $x$ 的每一个子节点之间的边是否满足要求。例如对于左子节点而言，如果其存在并且值与 $x$ 相同，那么我们继续向下搜索该左子节点；如果值与 $x$ 不同，那么我们直接返回 $\text{False}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool isUnivalTree(TreeNode* root) {
        if (!root) {
            return true;
        }
        if (root->left) {
            if (root->val != root->left->val || !isUnivalTree(root->left)) {
                return false;
            }
        }
        if (root->right) {
            if (root->val != root->right->val || !isUnivalTree(root->right)) {
                return false;
            }
        }
        return true;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean isUnivalTree(TreeNode root) {
        if (root == null) {
            return true;
        }
        if (root.left != null) {
            if (root.val != root.left.val || !isUnivalTree(root.left)) {
                return false;
            }
        }
        if (root.right != null) {
            if (root.val != root.right.val || !isUnivalTree(root.right)) {
                return false;
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool IsUnivalTree(TreeNode root) {
        if (root == null) {
            return true;
        }
        if (root.left != null) {
            if (root.val != root.left.val || !IsUnivalTree(root.left)) {
                return false;
            }
        }
        if (root.right != null) {
            if (root.val != root.right.val || !IsUnivalTree(root.right)) {
                return false;
            }
        }
        return true;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def isUnivalTree(self, root: TreeNode) -> bool:
        if not root:
            return True
        
        if root.left:
            if root.val != root.left.val or not self.isUnivalTree(root.left):
                return False
        
        if root.right:
            if root.val != root.right.val or not self.isUnivalTree(root.right):
                return False
        
        return True
```

```C [sol1-C]
bool isUnivalTree(struct TreeNode* root){
    if (!root) {
        return true;
    }
    if (root->left) {
        if (root->val != root->left->val || !isUnivalTree(root->left)) {
            return false;
        }
    }
    if (root->right) {
        if (root->val != root->right->val || !isUnivalTree(root->right)) {
            return false;
        }
    }
    return true;
}
```

```JavaScript [sol1-JavaScript]
var isUnivalTree = function(root) {
    if (!root) {
        return true;
    }
    if (root.left) {
        if (root.val !== root.left.val || !isUnivalTree(root.left)) {
            return false;
        }
    }
    if (root.right) {
        if (root.val !== root.right.val || !isUnivalTree(root.right)) {
            return false;
        }
    }
    return true;
};
```

```go [sol1-Golang]
func isUnivalTree(root *TreeNode) bool {
    return root == nil || (root.Left == nil || root.Val == root.Left.Val && isUnivalTree(root.Left)) &&
                         (root.Right == nil || root.Val == root.Right.Val && isUnivalTree(root.Right))
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉树的节点个数。我们遍历二叉树的每个节点至多一次。

- 空间复杂度：$O(n)$，即为深度优先搜索中需要使用的栈空间。
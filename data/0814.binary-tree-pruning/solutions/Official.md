## [814.二叉树剪枝 中文官方题解](https://leetcode.cn/problems/binary-tree-pruning/solutions/100000/er-cha-shu-jian-zhi-by-leetcode-solution-k336)
#### 方法一：递归

**思路**

树相关的题目首先考虑用递归解决。首先确定边界条件，当输入为空时，即可返回空。然后对左子树和右子树分别递归进行 $\textit{pruneTree}$ 操作。递归完成后，当这三个条件：左子树为空，右子树为空，当前节点的值为 $0$，同时满足时，才表示以当前节点为根的原二叉树的所有节点都为 $0$，需要将这棵子树移除，返回空。有任一条件不满足时，当前节点不应该移除，返回当前节点。

**代码**

```Python [sol1-Python3]
class Solution:
    def pruneTree(self, root: Optional[TreeNode]) -> Optional[TreeNode]:
        if root is None:
            return None
        root.left = self.pruneTree(root.left)
        root.right = self.pruneTree(root.right)
        if root.left is None and root.right is None and root.val == 0:
            return None
        return root
```

```Java [sol1-Java]
class Solution {
    public TreeNode pruneTree(TreeNode root) {
        if (root == null) {
            return null;
        }
        root.left = pruneTree(root.left);
        root.right = pruneTree(root.right);
        if (root.left == null && root.right == null && root.val == 0) {
            return null;
        }
        return root;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public TreeNode PruneTree(TreeNode root) {
        if (root == null) {
            return null;
        }
        root.left = PruneTree(root.left);
        root.right = PruneTree(root.right);
        if (root.left == null && root.right == null && root.val == 0) {
            return null;
        }
        return root;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    TreeNode* pruneTree(TreeNode* root) {
        if (!root) {
            return nullptr;
        }
        root->left = pruneTree(root->left);
        root->right = pruneTree(root->right);
        if (!root->left && !root->right && !root->val) {
            return nullptr;
        }
        return root;
    }   
};
```

```C [sol1-C]
struct TreeNode* pruneTree(struct TreeNode* root){
    if (!root) {
        return NULL;
    }
    root->left = pruneTree(root->left);
    root->right = pruneTree(root->right);
    if (!root->left && !root->right && !root->val) {
        return NULL;
    }
    return root;
}
```

```go [sol1-Golang]
func pruneTree(root *TreeNode) *TreeNode {
    if root == nil {
        return nil
    }
    root.Left = pruneTree(root.Left)
    root.Right = pruneTree(root.Right)
    if root.Left == nil && root.Right == nil && root.Val == 0 {
        return nil
    }
    return root
}
```

```JavaScript [sol1-JavaScript]
var pruneTree = function(root) {
    if (!root) {
        return null;
    }
    root.left = pruneTree(root.left);
    root.right = pruneTree(root.right);
    if (!root.left && !root.right&& root.val === 0) {
        return null;
    }
    return root;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉树节点的个数。每个节点都需要遍历一次。

- 空间复杂度：$O(n)$，其中 $n$ 是二叉树节点的个数。递归的深度最多为 $O(n)$。
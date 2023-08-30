#### 方法一：递归

由于我们需要删除所有值为 `target` 的叶子节点，那么我们的操作顺序应当从二叉树的叶子节点开始，逐步向上直到二叉树的根为止。因此我们可以使用递归的方法遍历整颗二叉树，并在回溯时进行删除操作。这样对于二叉树中的每个节点，它的子节点一定先于它被操作。这其实也就是二叉树的后序遍历。

具体地，当我们回溯到某个节点 `u` 时，如果 `u` 的左右孩子均不存在（这里有两种情况，一是节点 `u` 的孩子本来就不存在，二是节点 `u` 的孩子变成了叶子节点并且值为 `target`，导致其被删除），并且值为 `target`，那么我们要删除节点 `u`，递归函数的返回值为空节点；如果节点 `u` 不需要被删除，那么递归函数的返回值为节点 `u` 本身。

```C++ [sol1-C++]
class Solution {
public:
    TreeNode* removeLeafNodes(TreeNode* root, int target) {
        if (!root) {
            return nullptr;
        }
        root->left = removeLeafNodes(root->left, target);
        root->right = removeLeafNodes(root->right, target);
        if (!root->left && !root->right && root->val == target) {
            return nullptr;
        }
        return root;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def removeLeafNodes(self, root: TreeNode, target: int) -> TreeNode:
        if not root:
            return None
        root.left = self.removeLeafNodes(root.left, target)
        root.right = self.removeLeafNodes(root.right, target)
        if not root.left and not root.right and root.val == target:
            return None
        return root
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是二叉树的节点个数。

- 空间复杂度：$O(H)$，其中 $H$ 是二叉树的高度。
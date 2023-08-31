## [669.修剪二叉搜索树 中文官方题解](https://leetcode.cn/problems/trim-a-binary-search-tree/solutions/100000/xiu-jian-er-cha-sou-suo-shu-by-leetcode-qe7q1)

#### 方法一：递归

对根结点 $\textit{root}$ 进行深度优先遍历。对于当前访问的结点，如果结点为空结点，直接返回空结点；如果结点的值小于 $\textit{low}$，那么说明该结点及它的左子树都不符合要求，我们返回对它的右结点进行修剪后的结果；如果结点的值大于 $\textit{high}$，那么说明该结点及它的右子树都不符合要求，我们返回对它的左子树进行修剪后的结果；如果结点的值位于区间 $[\textit{low}, \textit{high}]$，我们将结点的左结点设为对它的左子树修剪后的结果，右结点设为对它的右子树进行修剪后的结果。

```Python [sol1-Python3]
class Solution:
    def trimBST(self, root: Optional[TreeNode], low: int, high: int) -> Optional[TreeNode]:
        if root is None:
            return None
        if root.val < low:
            return self.trimBST(root.right, low, high)
        if root.val > high:
            return self.trimBST(root.left, low, high)
        root.left = self.trimBST(root.left, low, high)
        root.right = self.trimBST(root.right, low, high)
        return root
```

```C++ [sol1-C++]
class Solution {
public:
    TreeNode* trimBST(TreeNode* root, int low, int high) {
        if (root == nullptr) {
            return nullptr;
        }
        if (root->val < low) {
            return trimBST(root->right, low, high);
        } else if (root->val > high) {
            return trimBST(root->left, low, high);
        } else {
            root->left = trimBST(root->left, low, high);
            root->right = trimBST(root->right, low, high);
            return root;
        }
    }
};
```

```Java [sol1-Java]
class Solution {
    public TreeNode trimBST(TreeNode root, int low, int high) {
        if (root == null) {
            return null;
        }
        if (root.val < low) {
            return trimBST(root.right, low, high);
        } else if (root.val > high) {
            return trimBST(root.left, low, high);
        } else {
            root.left = trimBST(root.left, low, high);
            root.right = trimBST(root.right, low, high);
            return root;
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public TreeNode TrimBST(TreeNode root, int low, int high) {
        if (root == null) {
            return null;
        }
        if (root.val < low) {
            return TrimBST(root.right, low, high);
        } else if (root.val > high) {
            return TrimBST(root.left, low, high);
        } else {
            root.left = TrimBST(root.left, low, high);
            root.right = TrimBST(root.right, low, high);
            return root;
        }
    }
}
```

```C [sol1-C]
struct TreeNode* trimBST(struct TreeNode* root, int low, int high){
    if (root == NULL) {
        return NULL;
    }
    if (root->val < low) {
        return trimBST(root->right, low, high);
    } else if (root->val > high) {
        return trimBST(root->left, low, high);
    } else {
        root->left = trimBST(root->left, low, high);
        root->right = trimBST(root->right, low, high);
        return root;
    }
}
```

```JavaScript [sol1-JavaScript]
var trimBST = function(root, low, high) {
    if (!root) {
        return null;
    }
    if (root.val < low) {
        return trimBST(root.right, low, high);
    } else if (root.val > high) {
        return trimBST(root.left, low, high);
    } else {
        root.left = trimBST(root.left, low, high);
        root.right = trimBST(root.right, low, high);
        return root;
    }
};
```

```go [sol1-Golang]
func trimBST(root *TreeNode, low, high int) *TreeNode {
    if root == nil {
        return nil
    }
    if root.Val < low {
        return trimBST(root.Right, low, high)
    }
    if root.Val > high {
        return trimBST(root.Left, low, high)
    }
    root.Left = trimBST(root.Left, low, high)
    root.Right = trimBST(root.Right, low, high)
    return root
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 为二叉树的结点数目。

+ 空间复杂度：$O(n)$。递归栈最坏情况下需要 $O(n)$ 的空间。

#### 方法二：迭代

如果一个结点 $\textit{node}$ 符合要求，即它的值位于区间 $[\textit{low}, \textit{high}]$，那么它的左子树与右子树应该如何修剪？

我们先讨论左子树的修剪：

+ $node$ 的左结点为空结点：不需要修剪

+ $node$ 的左结点非空：

    + 如果它的左结点 $\textit{left}$ 的值小于 $\textit{low}$，那么 $\textit{left}$ 以及 $\textit{left}$ 的左子树都不符合要求，我们将 $\textit{node}$ 的左结点设为 $\textit{left}$ 的右结点，然后再重新对 $\textit{node}$ 的左子树进行修剪。
    
    + 如果它的左结点 $\textit{left}$ 的值大于等于 $\textit{low}$，又因为 $\textit{node}$ 的值已经符合要求，所以 $\textit{left}$ 的右子树一定符合要求。基于此，我们只需要对 $\textit{left}$ 的左子树进行修剪。我们令 $\textit{node}$ 等于 $\textit{left}$ ，然后再重新对 $\textit{node}$ 的左子树进行修剪。
    
以上过程可以迭代处理。对于右子树的修剪同理。

我们对根结点进行判断，如果根结点不符合要求，我们将根结点设为对应的左结点或右结点，直到根结点符合要求，然后将根结点作为符合要求的结点，依次修剪它的左子树与右子树。

```Python [sol2-Python3]
class Solution:
    def trimBST(self, root: Optional[TreeNode], low: int, high: int) -> Optional[TreeNode]:
        while root and (root.val < low or root.val > high):
            root = root.right if root.val < low else root.left
        if root is None:
            return None
        node = root
        while node.left:
            if node.left.val < low:
                node.left = node.left.right
            else:
                node = node.left
        node = root
        while node.right:
            if node.right.val > high:
                node.right = node.right.left
            else:
                node = node.right
        return root
```

```C++ [sol2-C++]
class Solution {
public:
    TreeNode* trimBST(TreeNode* root, int low, int high) {
        while (root && (root->val < low || root->val > high)) {
            if (root->val < low) {
                root = root->right;
            } else {
                root = root->left;
            }
        }
        if (root == nullptr) {
            return nullptr;
        }
        for (auto node = root; node->left; ) {
            if (node->left->val < low) {
                node->left = node->left->right;
            } else {
                node = node->left;
            }
        }
        for (auto node = root; node->right; ) {
            if (node->right->val > high) {
                node->right = node->right->left;
            } else {
                node = node->right;
            }
        }
        return root;
    }
};
```

```Java [sol2-Java]
class Solution {
    public TreeNode trimBST(TreeNode root, int low, int high) {
        while (root != null && (root.val < low || root.val > high)) {
            if (root.val < low) {
                root = root.right;
            } else {
                root = root.left;
            }
        }
        if (root == null) {
            return null;
        }
        for (TreeNode node = root; node.left != null; ) {
            if (node.left.val < low) {
                node.left = node.left.right;
            } else {
                node = node.left;
            }
        }
        for (TreeNode node = root; node.right != null; ) {
            if (node.right.val > high) {
                node.right = node.right.left;
            } else {
                node = node.right;
            }
        }
        return root;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public TreeNode TrimBST(TreeNode root, int low, int high) {
        while (root != null && (root.val < low || root.val > high)) {
            if (root.val < low) {
                root = root.right;
            } else {
                root = root.left;
            }
        }
        if (root == null) {
            return null;
        }
        for (TreeNode node = root; node.left != null; ) {
            if (node.left.val < low) {
                node.left = node.left.right;
            } else {
                node = node.left;
            }
        }
        for (TreeNode node = root; node.right != null; ) {
            if (node.right.val > high) {
                node.right = node.right.left;
            } else {
                node = node.right;
            }
        }
        return root;
    }
}
```

```C [sol2-C]
struct TreeNode* trimBST(struct TreeNode* root, int low, int high){
    while (root && (root->val < low || root->val > high)) {
        if (root->val < low) {
            root = root->right;
        } else {
            root = root->left;
        }
    }
    if (root == NULL) {
        return NULL;
    }
    for (struct TreeNode* node = root; node->left; ) {
        if (node->left->val < low) {
            node->left = node->left->right;
        } else {
            node = node->left;
        }
    }
    for (struct TreeNode* node = root; node->right; ) {
        if (node->right->val > high) {
            node->right = node->right->left;
        } else {
            node = node->right;
        }
    }
    return root;
}
```

```JavaScript [sol2-JavaScript]
var trimBST = function(root, low, high) {
    while (root && (root.val < low || root.val > high)) {
        if (root.val < low) {
            root = root.right;
        } else {
            root = root.left;
        }
    }
    if (!root) {
        return null;
    }
    for (let node = root; node.left; ) {
        if (node.left.val < low) {
            node.left = node.left.right;
        } else {
            node = node.left;
        }
    }
    for (let node = root; node.right; ) {
        if (node.right.val > high) {
            node.right = node.right.left;
        } else {
            node = node.right;
        }
    }
    return root;
};
```

```go [sol2-Golang]
func trimBST(root *TreeNode, low, high int) *TreeNode {
    for root != nil && (root.Val < low || root.Val > high) {
        if root.Val < low {
            root = root.Right
        } else {
            root = root.Left
        }
    }
    if root == nil {
        return nil
    }
    for node := root; node.Left != nil; {
        if node.Left.Val < low {
            node.Left = node.Left.Right
        } else {
            node = node.Left
        }
    }
    for node := root; node.Right != nil; {
        if node.Right.Val > high {
            node.Right = node.Right.Left
        } else {
            node = node.Right
        }
    }
    return root
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 为二叉树的结点数目。最多访问 $n$ 个结点。

+ 空间复杂度：$O(1)$。
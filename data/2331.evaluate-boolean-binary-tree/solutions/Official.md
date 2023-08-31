## [2331.计算布尔二叉树的值 中文官方题解](https://leetcode.cn/problems/evaluate-boolean-binary-tree/solutions/100000/ji-suan-bu-er-er-cha-shu-de-zhi-by-leetc-4g8f)
#### 方法一：递归

**思路与算法**
根据题目要求，如果当前节点为叶子节点，那么节点的值为它本身；否则节点的值为两个孩子的节点值的逻辑运算结果。我们可以使用递归，如果要计算出当前节点 $\textit{node}$ 的值，我们需要先计算出两个叶子节点组成的子树的值分别为 $\textit{lval}$ 与 $\textit{lval}$，然后再计算出当前节点组成的子树的值。计算过程如下：
+ 如果当前节点 $\textit{node}$ 为叶子节点，则直接返回当前节点的值。根据题中完整二叉树的定义，树中每个节点有 $0$ 个或者 $2$ 个孩子的二叉树，只需检测该节点是否有左孩子或者右孩子即可。
+ 如果当前节点 $\textit{node}$ 含有孩子节点，计算出其左右孩子节点的值为 $\textit{lval}$ 与 $\textit{rval}$。如果 $\textit{node}$ 节点的值为 $2$，则返回 $\textit{lval} ~|~ \textit{rval}$；如果 $\textit{node}$ 节点的值为 $3$，则返回 $\textit{lval} ~\&~ \textit{rval}$。

**代码**

```Python [sol1-Python3]
class Solution:
    def evaluateTree(self, root: Optional[TreeNode]) -> bool:
        if root.left is None:
            return root.val == 1
        if root.val == 2:
            return self.evaluateTree(root.left) or self.evaluateTree(root.right)
        return self.evaluateTree(root.left) and self.evaluateTree(root.right)
```

```C++ [sol1-C++]
class Solution {
public:
    bool evaluateTree(TreeNode* root) {
        if (root->left == nullptr) {
            return root->val;
        } 
        if (root->val == 2) {
            return evaluateTree(root->left) || evaluateTree(root->right);
        } else {
            return evaluateTree(root->left) && evaluateTree(root->right);
        }
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean evaluateTree(TreeNode root) {
        if (root.left == null) {
            return root.val == 1;
        } 
        if (root.val == 2) {
            return evaluateTree(root.left) || evaluateTree(root.right);
        } else {
            return evaluateTree(root.left) && evaluateTree(root.right);
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool EvaluateTree(TreeNode root) {
        if (root.left == null) {
            return root.val == 1;
        } 
        if (root.val == 2) {
            return EvaluateTree(root.left) || EvaluateTree(root.right);
        } else {
            return EvaluateTree(root.left) && EvaluateTree(root.right);
        }
    }
}
```

```C [sol1-C]
bool evaluateTree(struct TreeNode* root) {
    if (!root->left) {
        return root->val;
    } 
    if (root->val == 2) {
        return evaluateTree(root->left) || evaluateTree(root->right);
    } else {
        return evaluateTree(root->left) && evaluateTree(root->right);
    }
}
```

```JavaScript [sol1-JavaScript]
var evaluateTree = function(root) {
    if (!root.left) {
        return root.val === 1;
    } 
    if (root.val === 2) {
        return evaluateTree(root.left) || evaluateTree(root.right);
    } else {
        return evaluateTree(root.left) && evaluateTree(root.right);
    }
};
```

```go [sol1-Golang]
func evaluateTree(root *TreeNode) bool {
	if root.Left == nil {
		return root.Val == 1
	}
	if root.Val == 2 {
		return evaluateTree(root.Left) || evaluateTree(root.Right)
	}
	return evaluateTree(root.Left) && evaluateTree(root.Right)
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 表示树中节点的数目。对于每个节点我们只需遍历一次即可，因此时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 表示树中节点的数目。按照题目要求，含有 $n$ 个节点的完整二叉树的深度最多为 $\dfrac{n}{2}$，最少为 $O(\log n)$，因此递归的最大深度为 $\dfrac{n}{2}$，因此空间复杂度为 $O(n)$。
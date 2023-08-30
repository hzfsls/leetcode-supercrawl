#### 方法一：深度优先搜索

我们将二叉树看成一个有向图（从父结点指向子结点的边），定义同值有向路径为从某一结点出发，到达它的某一后代节点的路径，且经过的结点的值相同。最长同值路径长度必定为某一节点的左最长同值有向路径长度与右最长同值有向路径长度之和。

使用变量 $\textit{res}$ 保存最长同值路径长度。我们对根结点进行深度优先搜索，对于当前搜索的结点 $\textit{root}$，我们分别获取它左结点的最长同值有向路径长度 $\textit{left}$，右结点的最长同值有向路径长度 $\textit{right}$。如果结点 $\textit{root}$ 的左结点非空且结点 $\textit{root}$ 的值与它的左结点的值相等，那么结点 $\textit{root}$ 的左最长同值有向路径长度 $\textit{left}_1 = \textit{left} + 1$，否则 $\textit{left}_1 = 0$；如果结点 $\textit{root}$ 的右结点非空且结点 $\textit{root}$ 的值与它的右结点的值相等，那么结点 $\textit{root}$ 的右最长同值有向路径长度 $\textit{right}_1 = \textit{right} + 1$，否则 $\textit{right}_1 = 0$。令 $\textit{res} = \max (res, \textit{left}_1 + \textit{right}_1)$，并且返回结点 $\textit{root}$ 对应的最长同值有向路径长度 $\max (\textit{left}_1, \textit{right}_1)$。

```Python [sol1-Python3]
class Solution:
    def longestUnivaluePath(self, root: Optional[TreeNode]) -> int:
        ans = 0
        def dfs(node: Optional[TreeNode]) -> int:
            if node is None:
                return 0
            left = dfs(node.left)
            right = dfs(node.right)
            left1 = left + 1 if node.left and node.left.val == node.val else 0
            right1 = right + 1 if node.right and node.right.val == node.val else 0
            nonlocal ans
            ans = max(ans, left1 + right1)
            return max(left1, right1)
        dfs(root)
        return ans
```

```C++ [sol1-C++]
class Solution {
private:
    int res;

public:
    int longestUnivaluePath(TreeNode* root) {
        res = 0;
        dfs(root);
        return res;
    }

    int dfs(TreeNode *root) {
        if (root == nullptr) {
            return 0;
        }
        int left = dfs(root->left), right = dfs(root->right);
        int left1 = 0, right1 = 0;
        if (root->left && root->left->val == root->val) {
            left1 = left + 1;
        }
        if (root->right && root->right->val == root->val) {
            right1 = right + 1;
        }
        res = max(res, left1 + right1);
        return max(left1, right1);
    }
};
```

```Java [sol1-Java]
class Solution {
    int res;

    public int longestUnivaluePath(TreeNode root) {
        res = 0;
        dfs(root);
        return res;
    }

    public int dfs(TreeNode root) {
        if (root == null) {
            return 0;
        }
        int left = dfs(root.left), right = dfs(root.right);
        int left1 = 0, right1 = 0;
        if (root.left != null && root.left.val == root.val) {
            left1 = left + 1;
        }
        if (root.right != null && root.right.val == root.val) {
            right1 = right + 1;
        }
        res = Math.max(res, left1 + right1);
        return Math.max(left1, right1);
    }
}
```

```C# [sol1-C#]
public class Solution {
    int res;

    public int LongestUnivaluePath(TreeNode root) {
        res = 0;
        DFS(root);
        return res;
    }

    public int DFS(TreeNode root) {
        if (root == null) {
            return 0;
        }
        int left = DFS(root.left), right = DFS(root.right);
        int left1 = 0, right1 = 0;
        if (root.left != null && root.left.val == root.val) {
            left1 = left + 1;
        }
        if (root.right != null && root.right.val == root.val) {
            right1 = right + 1;
        }
        res = Math.Max(res, left1 + right1);
        return Math.Max(left1, right1);
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int dfs(struct TreeNode *root, int *res) {
    if (root == NULL) {
        return 0;
    }
    int left = dfs(root->left, res), right = dfs(root->right, res);
    int left1 = 0, right1 = 0;
    if (root->left && root->left->val == root->val) {
        left1 = left + 1;
    }
    if (root->right && root->right->val == root->val) {
        right1 = right + 1;
    }
    *res = MAX(*res, left1 + right1);
    return MAX(left1, right1);
}

int longestUnivaluePath(struct TreeNode* root){
    int res = 0;
    dfs(root, &res);
    return res;
}
```

```JavaScript [sol1-JavaScript]
var longestUnivaluePath = function(root) {
    let res = 0;
    const dfs = (root) => {
        if (!root) {
            return 0;
        }
        let left = dfs(root.left), right = dfs(root.right);
        let left1 = 0, right1 = 0;
        if (root.left && root.left.val === root.val) {
            left1 = left + 1;
        }
        if (root.right && root.right.val === root.val) {
            right1 = right + 1;
        }
        res = Math.max(res, left1 + right1);
        return Math.max(left1, right1);
    }
    dfs(root);
    return res;
};
```

```go [sol1-Golang]
func longestUnivaluePath(root *TreeNode) (ans int) {
    var dfs func(*TreeNode) int
    dfs = func(node *TreeNode) int {
        if node == nil {
            return 0
        }
        left := dfs(node.Left)
        right := dfs(node.Right)
        left1, right1 := 0, 0
        if node.Left != nil && node.Left.Val == node.Val {
            left1 = left + 1
        }
        if node.Right != nil && node.Right.Val == node.Val {
            right1 = right + 1
        }
        ans = max(ans, left1+right1)
        return max(left1, right1)
    }
    dfs(root)
    return ans
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 为树的结点数目。

+ 空间复杂度：$O(n)$。递归栈最坏情况下需要 $O(n)$ 的空间。
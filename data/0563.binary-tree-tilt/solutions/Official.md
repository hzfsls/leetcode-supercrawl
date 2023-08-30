#### 方法一：深度优先搜索

**思路和算法**

根据题意，我们需要累计二叉树中所有结点的左子树结点之和与右子树结点之和的差的绝对值。因此，我们可以使用深度优先搜索，在遍历每个结点时，累加其左子树结点之和与右子树结点之和的差的绝对值，并返回以其为根结点的树的结点之和。

具体地，我们实现算法如下：

* 从根结点开始遍历，设当前遍历的结点为 $\textit{node}$；
* 遍历 $\textit{node}$ 的左子结点，得到左子树结点之和 $\textit{sum\_left}$；遍历 $\textit{node}$ 的右子结点，得到右子树结点之和 $\textit{sum\_right}$；
* 将左子树结点之和与右子树结点之和的差的绝对值累加到结果变量 $\textit{ans}$；
* 返回以 $\textit{node}$ 作为根结点的树的结点之和 $\textit{sum\_left} + \textit{sum\_right} + \textit{node}.\textit{val}$。

**代码**

```Python [sol1-Python3]
class Solution:
    def __init__(self):
        self.ans = 0

    def findTilt(self, root: TreeNode) -> int:
        self.dfs(root)
        return self.ans

    def dfs(self, node):
        if not node:
            return 0
        sum_left = self.dfs(node.left)
        sum_right = self.dfs(node.right)
        self.ans += abs(sum_left - sum_right)
        return sum_left + sum_right + node.val
```

```Java [sol1-Java]
class Solution {
    int ans = 0;

    public int findTilt(TreeNode root) {
        dfs(root);
        return ans;
    }

    public int dfs(TreeNode node) {
        if (node == null) {
            return 0;
        }
        int sumLeft = dfs(node.left);
        int sumRight = dfs(node.right);
        ans += Math.abs(sumLeft - sumRight);
        return sumLeft + sumRight + node.val;
    }
}
```

```C# [sol1-C#]
public class Solution {
    int ans = 0;

    public int FindTilt(TreeNode root) {
        DFS(root);
        return ans;
    }

    public int DFS(TreeNode node) {
        if (node == null) {
            return 0;
        }
        int sumLeft = DFS(node.left);
        int sumRight = DFS(node.right);
        ans += Math.Abs(sumLeft - sumRight);
        return sumLeft + sumRight + node.val;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int ans = 0;

    int findTilt(TreeNode* root) {
        dfs(root);
        return ans;
    }

    int dfs(TreeNode* node) {
        if (node == nullptr) {
            return 0;
        }
        int sumLeft = dfs(node->left);
        int sumRight = dfs(node->right);
        ans += abs(sumLeft - sumRight);
        return sumLeft + sumRight + node->val;
    } 
};
```

```JavaScript [sol1-JavaScript]
var findTilt = function(root) {
    let ans = 0;

    const dfs = (node) => {
        if (!node) {
            return 0;
        }
        const sumLeft = dfs(node.left);
        const sumRight = dfs(node.right);
        ans += Math.abs(sumLeft - sumRight);
        return sumLeft + sumRight + node.val;
    }

    dfs(root);
    return ans;
};
```

```go [sol1-Golang]
func findTilt(root *TreeNode) (ans int) {
    var dfs func(*TreeNode) int
    dfs = func(node *TreeNode) int {
        if node == nil {
            return 0
        }
        sumLeft := dfs(node.Left)
        sumRight := dfs(node.Right)
        ans += abs(sumLeft - sumRight)
        return sumLeft + sumRight + node.Val
    }
    dfs(root)
    return
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为二叉树中结点总数。我们需要遍历每一个结点。

- 空间复杂度：$O(n)$。在最坏情况下， 当树为线性二叉树（即所有结点都只有左子结点或没有结点）时，树的高度为 $n - 1$，在递归时我们需要存储 $n$ 个结点。
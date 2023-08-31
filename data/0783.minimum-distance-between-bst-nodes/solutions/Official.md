## [783.二叉搜索树节点最小距离 中文官方题解](https://leetcode.cn/problems/minimum-distance-between-bst-nodes/solutions/100000/er-cha-sou-suo-shu-jie-dian-zui-xiao-ju-8u87w)
#### 方法一：中序遍历

**思路与算法**

考虑对升序数组 $a$ 求任意两个元素之差的最小值，答案一定为相邻两个元素之差的最小值，即
$$
\textit{ans}=\min_{i=0}^{n-2}\left\{a[i+1]-a[i]\right\}
$$
其中 $n$ 为数组 $a$ 的长度。其他任意间隔距离大于等于 $2$ 的下标对 $(i,j)$ 的元素之差一定大于下标对 $(i,i+1)$ 的元素之差，故不需要再被考虑。

回到本题，本题要求二叉搜索树任意两节点差的最小值，而我们知道二叉搜索树有个性质为**二叉搜索树中序遍历得到的值序列是递增有序的**，因此我们只要得到中序遍历后的值序列即能用上文提及的方法来解决。

朴素的方法是经过一次中序遍历将值保存在一个数组中再进行遍历求解，我们也可以在中序遍历的过程中用 $\textit{pre}$ 变量保存前驱节点的值，这样即能边遍历边更新答案，不再需要显式创建数组来保存，需要注意的是 $\textit{pre}$ 的初始值需要设置成任意负数标记开头，下文代码中设置为 $-1$。

二叉树的中序遍历有多种方式，包括递归、栈、Morris 遍历等，读者可选择自己最擅长的来实现。下文代码提供最普遍的递归方法来实现，其他遍历方法的介绍可以详细看「[94. 二叉树的中序遍历的官方题解](https://leetcode-cn.com/problems/binary-tree-inorder-traversal/solution/er-cha-shu-de-zhong-xu-bian-li-by-leetcode-solutio/)」，这里不再赘述。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    void dfs(TreeNode* root, int& pre, int& ans) {
        if (root == nullptr) {
            return;
        }
        dfs(root->left, pre, ans);
        if (pre == -1) {
            pre = root->val;
        } else {
            ans = min(ans, root->val - pre);
            pre = root->val;
        }
        dfs(root->right, pre, ans);
    }
    int minDiffInBST(TreeNode* root) {
        int ans = INT_MAX, pre = -1;
        dfs(root, pre, ans);
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    int pre;
    int ans;

    public int minDiffInBST(TreeNode root) {
        ans = Integer.MAX_VALUE;
        pre = -1;
        dfs(root);
        return ans;
    }

    public void dfs(TreeNode root) {
        if (root == null) {
            return;
        }
        dfs(root.left);
        if (pre == -1) {
            pre = root.val;
        } else {
            ans = Math.min(ans, root.val - pre);
            pre = root.val;
        }
        dfs(root.right);
    }
}
```

```JavaScript [sol1-JavaScript]
var minDiffInBST = function(root) {
    let ans = Number.MAX_SAFE_INTEGER, pre = -1;
    const dfs = (root) => {
        if (root === null) {
            return;
        }
        dfs(root.left);
        if (pre == -1) {
            pre = root.val;
        } else {
            ans = Math.min(ans, root.val - pre);
            pre = root.val;
        }
        dfs(root.right);
    }
    dfs(root);
    return ans;
};
```

```Golang [sol1-Golang]
func minDiffInBST(root *TreeNode) int {
    ans, pre := math.MaxInt64, -1
    var dfs func(*TreeNode)
    dfs = func(node *TreeNode) {
        if node == nil {
            return
        }
        dfs(node.Left)
        if pre != -1 && node.Val-pre < ans {
            ans = node.Val - pre
        }
        pre = node.Val
        dfs(node.Right)
    }
    dfs(root)
    return ans
}
```

```C [sol1-C]
void dfs(struct TreeNode* root, int* pre, int* ans) {
    if (root == NULL) {
        return;
    }
    dfs(root->left, pre, ans);
    if (*pre == -1) {
        *pre = root->val;
    } else {
        *ans = fmin(*ans, root->val - (*pre));
        *pre = root->val;
    }
    dfs(root->right, pre, ans);
}

int minDiffInBST(struct TreeNode* root) {
    int ans = INT_MAX, pre = -1;
    dfs(root, &pre, &ans);
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为二叉搜索树节点的个数。每个节点在中序遍历中都会被访问一次且只会被访问一次，因此总时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$。递归函数的空间复杂度取决于递归的栈深度，而栈深度在二叉搜索树为一条链的情况下会达到 $O(n)$ 级别。
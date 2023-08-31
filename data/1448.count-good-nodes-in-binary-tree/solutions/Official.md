## [1448.统计二叉树中好节点的数目 中文官方题解](https://leetcode.cn/problems/count-good-nodes-in-binary-tree/solutions/100000/tong-ji-er-cha-shu-zhong-hao-jie-dian-de-dqtl)

#### 方法一：深度优先遍历

**思路与算法**

在题目的定义中，从根到好节点所经过的节点中，没有任何节点的值大于好节点的值，等同于根节点到好节点的路径上所有节点（不包括好节点本身）的最大值小于等于好节点的值。

因此我们可以在深度优先遍历的过程中，记录从根节点到当前节点的路径上所有节点的最大值，若当前节点的值大于等于该最大值，则认为当前节点是好节点。

具体来说，定义递归函数求解以某个节点为根的子树中，好节点的个数。递归函数的参数为根节点以及路径上的最大值，若当前节点的值大于等于该最大值，则将答案加一，并更新路径最大值为当前节点的值。紧接着递归遍历左右子树时，将最大值以参数的形式传递下去。递归返回的结果需要累加到答案中。

最终，我们以根节点为入口，无穷小为路径最大值去调用递归函数，所得到的返回值即为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int dfs(TreeNode* root, int path_max) {
        if (root == nullptr) {
            return 0;
        }
        int res = 0;
        if (root->val >= path_max) {
            res++;
            path_max = root->val;
        }
        res += dfs(root->left, path_max) + dfs(root->right, path_max);
        return res;
    }

    int goodNodes(TreeNode* root) {
        return dfs(root, INT_MIN);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int goodNodes(TreeNode root) {
        return dfs(root, Integer.MIN_VALUE);
    }

    public int dfs(TreeNode root, int pathMax) {
        if (root == null) {
            return 0;
        }
        int res = 0;
        if (root.val >= pathMax) {
            res++;
            pathMax = root.val;
        }
        res += dfs(root.left, pathMax) + dfs(root.right, pathMax);
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int GoodNodes(TreeNode root) {
        return DFS(root, int.MinValue);
    }

    public int DFS(TreeNode root, int pathMax) {
        if (root == null) {
            return 0;
        }
        int res = 0;
        if (root.val >= pathMax) {
            res++;
            pathMax = root.val;
        }
        res += DFS(root.left, pathMax) + DFS(root.right, pathMax);
        return res;
    }
}
```

```C [sol1-C]
int dfs(struct TreeNode* root, int path_max) {
    if (root == NULL) {
        return 0;
    }
    int res = 0;
    if (root->val >= path_max) {
        res++;
        path_max = root->val;
    }
    res += dfs(root->left, path_max) + dfs(root->right, path_max);
    return res;
}

int goodNodes(struct TreeNode* root){
    return dfs(root, INT_MIN);
}
```

```Python [sol1-Python3]
class Solution:
    def goodNodes(self, root: TreeNode) -> int:
        def dfs(root, path_max):
            if root is None:
                return 0
            res = 0
            if root.val >= path_max:
                res += 1
                path_max = root.val
            res += dfs(root.left, path_max) + dfs(root.right, path_max)
            return res
        return dfs(root, -10**9)
```

```Go [sol1-Go]
func goodNodes(root *TreeNode) int {
    return dfs(root, math.MinInt)
}

func dfs(root *TreeNode, path_max int) int {
    if root == nil {
        return 0
    }
    res := 0
    if root.Val >= path_max {
        res++
        path_max = root.Val
    }
    res += dfs(root.Left, path_max) + dfs(root.Right, path_max)
    return res
}
```

```JavaScript [sol1-JavaScript]
var goodNodes = function(root) {
    const dfs = (root, path_max) => {
        if (root == null) {
            return 0;
        }
        let res = 0;
        if (root.val >= path_max) {
            res++;
            path_max = root.val;
        }
        res += dfs(root.left, path_max) + dfs(root.right, path_max);
        return res;
    }
    return dfs(root, -Infinity);
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为二叉树中的节点个数。在深度优先遍历的过程中，每个节点只会被遍历一次。

- 空间复杂度：$O(n)$。由于我们使用递归来实现深度优先遍历，因此空间复杂度的消耗主要在栈空间，取决于二叉树的高度，最坏情况下二叉树的高度为 $O(n)$。
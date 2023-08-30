#### 方法一：递归

**思路与算法**

题目给定的是一颗二叉树，并不保证是二叉搜索树。因此，我们需要去独立判断每个子树是否是一个二叉搜索树。以 $\textit{root}$ 为根的子树是一颗二叉搜索树当且仅当以下条件满足：

1. 左子树为空，或者左子树是一颗二叉搜索树并且左子树的最大值小于 $\textit{root.val}$；
2. 右子树为空，或者右子树是一颗二叉搜索树并且右子树的最小值大于 $\textit{root.val}$。

我们用一个结构体来描述一个子树的基本情况，它应当包含以下元素：

1. $\textit{isBST}$，表示该子树是否为二叉搜索树；
2. $\textit{minValue}$，表示该子树中的最小值；
3. $\textit{maxValue}$，表示该子树中的最大值；
4. $\textit{sumValue}$，表示该子树中所有节点的键值之和，用于求解答案。

在判断以 $\textit{root}$ 为根的子树是否是二叉搜索树时，首先递归判断它的左子树是否是二叉搜索树，然后递归判断它的右子树是否是二叉搜索树。用 $\textit{left}$ 和 $\textit{right}$ 分别表示左子树和右子树的基本信息。当且仅当以下条件都满足时，以 $\textit{root}$ 为根的子树是二叉搜索树：

1. $\textit{left.isBST}$ 为真；
2. $\textit{right.isBST}$ 为真；
3. $\textit{left.maxValue} \lt \textit{root.val}$；
4. $\textit{right.minValue} \gt \textit{root.val}$。

为了方便编写代码，对于空子树我们用 $-\infin$ 来表示最大值，用 $\infin$ 来表示最小值，并且将 $\textit{isBST}$ 设置为真，$\textit{sumValue}$ 设置为 $0$。这样在父节点判断时，不论是其左子树为空还是右子树为空，都不会影响到条件判断。

在确定以 $\textit{root}$ 为根的子树是二叉搜索树之后，设置其基本信息：
1. $\textit{isBST}$ 设置为真；
2. $\textit{minValue}$ 设置为 $\textit{left.minValue}$ 与 $\textit{root.val}$ 的最小值（因为当 $\textit{left}$ 为空子树时，$\textit{left.minValue} = \infin$）；
3. $\textit{maxValue}$ 设置为 $\textit{right.maxValue}$ 与 $\textit{root.val}$ 的最大值（原因同第 $2$ 条）；
4. $\textit{sumValue}$ 设置为 $\textit{left.sumValue}$ 与 $\textit{right.sumValue}$ 之和。

同时，用 $\textit{sumValue}$ 更新题目答案，取所有二叉搜索树中的最大值。

值得一提的是，本题需要把所有节点都遍历一次，因为每个子树都有成为二叉搜索树的可能。即便我们可以根据某个节点的左子树不是二叉搜索树就可以确定该子树不是二叉搜索树，我们也需要去遍历该结点的右子树。因为其右子树及其子树仍有成为二叉搜索树的可能。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    static constexpr int inf = 0x3f3f3f3f;
    int res;
    struct SubTree {
        bool isBST;
        int minValue;
        int maxValue;
        int sumValue;
        SubTree(bool isBST, int minValue, int maxValue, int sumValue) : isBST(isBST), minValue(minValue), maxValue(maxValue), sumValue(sumValue) {}
    };

    SubTree dfs(TreeNode* root) {
        if (root == nullptr) {
            return SubTree(true, inf, -inf, 0);
        }
        auto left = dfs(root->left);
        auto right = dfs(root->right);

        if (left.isBST && right.isBST &&
                root->val > left.maxValue && 
                root->val < right.minValue) {
            int sum = root->val + left.sumValue + right.sumValue;
            res = max(res, sum);
            return SubTree(true, min(left.minValue, root->val), 
                           max(root->val, right.maxValue), sum);
        } else {
            return SubTree(false, 0, 0, 0);
        }
    }

    int maxSumBST(TreeNode* root) {
        res = 0;
        dfs(root);
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    static final int INF = 0x3f3f3f3f;
    int res;

    class SubTree {
        boolean isBST;
        int minValue;
        int maxValue;
        int sumValue;

        SubTree(boolean isBST, int minValue, int maxValue, int sumValue) {
            this.isBST = isBST;
            this.minValue = minValue;
            this.maxValue = maxValue;
            this.sumValue = sumValue;
        }
    }

    public int maxSumBST(TreeNode root) {
        res = 0;
        dfs(root);
        return res;
    }

    public SubTree dfs(TreeNode root) {
        if (root == null) {
            return new SubTree(true, INF, -INF, 0);
        }
        SubTree left = dfs(root.left);
        SubTree right = dfs(root.right);

        if (left.isBST && right.isBST && root.val > left.maxValue && root.val < right.minValue) {
            int sum = root.val + left.sumValue + right.sumValue;
            res = Math.max(res, sum);
            return new SubTree(true, Math.min(left.minValue, root.val), Math.max(root.val, right.maxValue), sum);
        } else {
            return new SubTree(false, 0, 0, 0);
        }
    }
}
```

```Python [sol1-Python3]
class SubTree:
    def __init__(self, is_bst, min_value, max_value, sum_value):
        self.is_bst = is_bst
        self.min_value = min_value
        self.max_value = max_value
        self.sum_value = sum_value

class Solution:
    INF = 0x3f3f3f3f

    def maxSumBST(self, root: Optional[TreeNode]) -> int:
        self.res = 0
        self.dfs(root)
        return self.res

    def dfs(self, root):
        if root is None:
            return SubTree(True, self.INF, -self.INF, 0)

        left = self.dfs(root.left)
        right = self.dfs(root.right)

        if left.is_bst and right.is_bst and root.val > left.max_value and root.val < right.min_value:
            sum = root.val + left.sum_value + right.sum_value
            self.res = max(self.res, sum)
            return SubTree(True, min(left.min_value, root.val), max(root.val, right.max_value), sum)
        else:
            return SubTree(False, 0, 0, 0)
```

```Go [sol1-Go]
const INF = 0x3f3f3f3f
type SubTree struct {
    IsBST bool
    MinVal int
    MaxVal int
    SumVal int
}
var res int

func maxSumBST(root *TreeNode) int {
    res = 0
    dfs(root)
    return res
}

func max(a int, b int) int {
    if a > b {
        return a
    }
    return b
}

func min(a int, b int) int {
    if a < b {
        return a
    }
    return b
}

func dfs(root *TreeNode) *SubTree {
    if root == nil {
        return &SubTree{true, INF, -INF, 0}
    }
    left := dfs(root.Left)
    right := dfs(root.Right)

    if left.IsBST && right.IsBST && root.Val > left.MaxVal && root.Val < right.MinVal {
        sum := root.Val + left.SumVal + right.SumVal
        res = max(res, sum)
        return &SubTree{true, min(left.MinVal, root.Val), max(root.Val, right.MaxVal), sum}
    } else {
        return &SubTree{false, 0, 0, 0}
    }
}
```

```C# [sol1-C#]
public class Solution {
    const int INF = 0x3f3f3f3f;
    int res;

    public class SubTree {
        public bool isBST;
        public int minValue;
        public int maxValue;
        public int sumValue;

        public SubTree(bool isBST, int minValue, int maxValue, int sumValue) {
            this.isBST = isBST;
            this.minValue = minValue;
            this.maxValue = maxValue;
            this.sumValue = sumValue;
        }
    }

    public int MaxSumBST(TreeNode root) {
        res = 0;
        DFS(root);
        return res;
    }

    public SubTree DFS(TreeNode root) {
        if (root == null) {
            return new SubTree(true, INF, -INF, 0);
        }
        SubTree left = DFS(root.left);
        SubTree right = DFS(root.right);

        if (left.isBST && right.isBST && root.val > left.maxValue && root.val < right.minValue) {
            int sum = root.val + left.sumValue + right.sumValue;
            res = Math.Max(res, sum);
            return new SubTree(true, Math.Min(left.minValue, root.val), Math.Max(root.val, right.maxValue), sum);
        } else {
            return new SubTree(false, 0, 0, 0);
        }
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

const int INF = 0x3f3f3f3f;

typedef struct SubTree {
    bool isBST;
    int minValue;
    int maxValue;
    int sumValue;
} SubTree;

SubTree *createSubTree(bool isBST, int minValue,int maxValue, int sumValue) {
    SubTree *obj = (SubTree *)malloc(sizeof(SubTree));
    obj->isBST = isBST;
    obj->minValue = minValue;
    obj->maxValue = maxValue;
    obj->sumValue = sumValue;
    return obj;
}

SubTree* dfs(struct TreeNode* root, int *res) {
    if (root == NULL) {
        return createSubTree(true, INF, -INF, 0);
    }
    SubTree *left = dfs(root->left, res);
    SubTree *right = dfs(root->right, res);
    SubTree *ret = NULL;

    if (left->isBST && right->isBST &&
          root->val > left->maxValue &&
          root->val < right->minValue) {
        int sum = root->val + left->sumValue + right->sumValue;
        *res = MAX(*res, sum);
        ret = createSubTree(true, MIN(left->minValue, root->val), \
                            MAX(root->val, right->maxValue), sum);
    } else {
        ret = createSubTree(false, 0, 0, 0);
    }
    free(left);
    free(right);
    return ret;
}

int maxSumBST(struct TreeNode* root){
    int res = 0;
    SubTree *obj = dfs(root, &res);
    free(obj);
    return res;
}
```

```JavaScript [sol1-JavaScript]
const INF = 0x3f3f3f3f;
var maxSumBST = function(root) {
    const dfs = (root) => {
        if (!root) {
            return new SubTree(true, INF, -INF, 0);
        }
        let left = dfs(root.left);
        let right = dfs(root.right);

        if (left.isBST && right.isBST && root.val > left.maxValue && root.val < right.minValue) {
            const sum = root.val + left.sumValue + right.sumValue;
            res = Math.max(res, sum);
            return new SubTree(true, Math.min(left.minValue, root.val), Math.max(root.val, right.maxValue), sum);
        } else {
            return new SubTree(false, 0, 0, 0);
        }
    }
    let res = 0;
    dfs(root);
    return res;
};

class SubTree {
    constructor(isBST, minValue, maxValue, sumValue) {
        this.isBST = isBST;
        this.minValue = minValue;
        this.maxValue = maxValue;
        this.sumValue = sumValue;
    }
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是树中节点的个数。每个节点只需遍历一次，遍历一次的复杂度为 $O(1)$，因此总体复杂度为 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是树中节点的个数。在二叉树退化成链的情况下，递归所需要的栈空间为 $O(n)$。
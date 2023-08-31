## [1161.最大层内元素和 中文官方题解](https://leetcode.cn/problems/maximum-level-sum-of-a-binary-tree/solutions/100000/zui-da-ceng-nei-yuan-su-he-by-leetcode-s-2tm4)
#### 方法一：深度优先搜索

我们可以采用深度优先搜索来遍历这棵二叉树，递归的同时记录当前的层号。

相比哈希表，这里我们采用效率更高的动态数组来维护每一层的元素之和，如果当前层号达到了数组的长度，则将节点元素添加到数组末尾，否则更新对应层号的元素之和。

然后遍历数组，找到元素之和最大，且层号最小的元素。

```Python [sol1-Python3]
class Solution:
    def maxLevelSum(self, root: Optional[TreeNode]) -> int:
        sum = []
        def dfs(node: TreeNode, level: int) -> None:
            if level == len(sum):
                sum.append(node.val)
            else:
                sum[level] += node.val
            if node.left:
                dfs(node.left, level + 1)
            if node.right:
                dfs(node.right, level + 1)
        dfs(root, 0)
        return sum.index(max(sum)) + 1  # 层号从 1 开始
```

```C++ [sol1-C++]
class Solution {
    vector<int> sum;

    void dfs(TreeNode *node, int level) {
        if (level == sum.size()) {
            sum.push_back(node->val);
        } else {
            sum[level] += node->val;
        }
        if (node->left) {
            dfs(node->left, level + 1);
        }
        if (node->right) {
            dfs(node->right, level + 1);
        }
    }

public:
    int maxLevelSum(TreeNode *root) {
        dfs(root, 0);
        int ans = 0;
        for (int i = 0; i < sum.size(); ++i) {
            if (sum[i] > sum[ans]) {
                ans = i;
            }
        }
        return ans + 1; // 层号从 1 开始
    }
};
```

```Java [sol1-Java]
class Solution {
    private List<Integer> sum = new ArrayList<Integer>();

    public int maxLevelSum(TreeNode root) {
        dfs(root, 0);
        int ans = 0;
        for (int i = 0; i < sum.size(); ++i) {
            if (sum.get(i) > sum.get(ans)) {
                ans = i;
            }
        }
        return ans + 1; // 层号从 1 开始
    }

    private void dfs(TreeNode node, int level) {
        if (level == sum.size()) {
            sum.add(node.val);
        } else {
            sum.set(level, sum.get(level) + node.val);
        }
        if (node.left != null) {
            dfs(node.left, level + 1);
        }
        if (node.right != null) {
            dfs(node.right, level + 1);
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    private IList<int> sum = new List<int>();

    public int MaxLevelSum(TreeNode root) {
        DFS(root, 0);
        int ans = 0;
        for (int i = 0; i < sum.Count; ++i) {
            if (sum[i] > sum[ans]) {
                ans = i;
            }
        }
        return ans + 1; // 层号从 1 开始
    }

    private void DFS(TreeNode node, int level) {
        if (level == sum.Count) {
            sum.Add(node.val);
        } else {
            sum[level] += node.val;
        }
        if (node.left != null) {
            DFS(node.left, level + 1);
        }
        if (node.right != null) {
            DFS(node.right, level + 1);
        }
    }
}
```

```go [sol1-Golang]
func maxLevelSum(root *TreeNode) (ans int) {
    sum := []int{}
    var dfs func(*TreeNode, int)
    dfs = func(node *TreeNode, level int) {
        if level == len(sum) {
            sum = append(sum, node.Val)
        } else {
            sum[level] += node.Val
        }
        if node.Left != nil {
            dfs(node.Left, level+1)
        }
        if node.Right != nil {
            dfs(node.Right, level+1)
        }
    }
    dfs(root, 0)
    for i, s := range sum {
        if s > sum[ans] {
            ans = i
        }
    }
    return ans + 1 // 层号从 1 开始
}
```

```C [sol1-C]
#define MAX_NODE_SIZE 10000

void dfs(struct TreeNode *node, int level, int *sum, int *sumSize) {
    if (level == *sumSize) {
        sum[*sumSize] = node->val;
        (*sumSize)++;
    } else {
        sum[level] += node->val;
    }
    if (node->left) {
        dfs(node->left, level + 1, sum, sumSize);
    }
    if (node->right) {
        dfs(node->right, level + 1, sum, sumSize);
    }
}

int maxLevelSum(struct TreeNode* root) {
    int *sum = (int *)malloc(sizeof(int) * MAX_NODE_SIZE);
    int sumSize = 0;
    dfs(root, 0, sum, &sumSize);
    int ans = 0;
    for (int i = 0; i < sumSize; ++i) {
        if (sum[i] > sum[ans]) {
            ans = i;
        }
    }
    return ans + 1; // 层号从 1 开始
}
```

```JavaScript [sol1-JavaScript]
var maxLevelSum = function(root) {
    const sum = [];
    const dfs = (node, level) => {
        if (level === sum.length) {
            sum.push(node.val);
        } else {
            sum.splice(level, 1, sum[level] + node.val);
        }
        if (node.left) {
            dfs(node.left, level + 1);
        }
        if (node.right) {
            dfs(node.right, level + 1);
        }
    }
    dfs(root, 0);
    let ans = 0;
    for (let i = 0; i < sum.length; ++i) {
        if (sum[i] > sum[ans]) {
            ans = i;
        }
    }
    return ans + 1; // 层号从 1 开始
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉树的节点个数。

- 空间复杂度：$O(n)$。最坏情况下二叉树是一条链，需要 $O(n)$ 的数组空间以及 $O(n)$ 的递归栈空间。

#### 方法二：广度优先搜索

由于计算的是每层的元素之和，用广度优先搜索来遍历这棵树会更加自然。

对于广度优先搜索，我们可以用队列来实现。初始时，队列只包含根节点；然后不断出队，将子节点入队，直到队列为空。

如果直接套用方法一的思路，我们需要在队列中存储节点和节点的层号。另一种做法是一次遍历完一整层的节点，遍历的同时，累加该层的节点的元素之和，同时用这层的节点得到下一层的节点，这种做法不需要记录层号。

为了代码实现的方便，我们可以使用两个动态数组，第一个数组 $q$ 为当前层的节点，第二个数组 $\textit{nq}$ 为下一层的节点。遍历 $q$ 中节点的同时，把子节点加到 $\textit{nq}$ 中。遍历完当前层后，将 $q$ 置为 $\textit{nq}$。

```Python [sol2-Python3]
class Solution:
    def maxLevelSum(self, root: Optional[TreeNode]) -> int:
        ans, maxSum = 1, root.val
        level, q = 1, [root]
        while q:
            sum, nq = 0, []
            for node in q:
                sum += node.val
                if node.left:
                    nq.append(node.left)
                if node.right:
                    nq.append(node.right)
            if sum > maxSum:
                ans, maxSum = level, sum
            q = nq
            level += 1
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    int maxLevelSum(TreeNode *root) {
        int ans = 1, maxSum = root->val;
        vector<TreeNode*> q = {root};
        for (int level = 1; !q.empty(); ++level) {
            vector<TreeNode*> nq;
            int sum = 0;
            for (auto node : q) {
                sum += node->val;
                if (node->left) {
                    nq.emplace_back(node->left);
                }
                if (node->right) {
                    nq.emplace_back(node->right);
                }
            }
            if (sum > maxSum) {
                maxSum = sum;
                ans = level;
            }
            q = move(nq);
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maxLevelSum(TreeNode root) {
        int ans = 1, maxSum = root.val;
        List<TreeNode> q = new ArrayList<TreeNode>();
        q.add(root);
        for (int level = 1; !q.isEmpty(); ++level) {
            List<TreeNode> nq = new ArrayList<TreeNode>();
            int sum = 0;
            for (TreeNode node : q) {
                sum += node.val;
                if (node.left != null) {
                    nq.add(node.left);
                }
                if (node.right != null) {
                    nq.add(node.right);
                }
            }
            if (sum > maxSum) {
                maxSum = sum;
                ans = level;
            }
            q = nq;
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MaxLevelSum(TreeNode root) {
        int ans = 1, maxSum = root.val;
        IList<TreeNode> q = new List<TreeNode>();
        q.Add(root);
        for (int level = 1; q.Count > 0; ++level) {
            IList<TreeNode> nq = new List<TreeNode>();
            int sum = 0;
            foreach (TreeNode node in q) {
                sum += node.val;
                if (node.left != null) {
                    nq.Add(node.left);
                }
                if (node.right != null) {
                    nq.Add(node.right);
                }
            }
            if (sum > maxSum) {
                maxSum = sum;
                ans = level;
            }
            q = nq;
        }
        return ans;
    }
}
```

```go [sol2-Golang]
func maxLevelSum(root *TreeNode) int {
    ans, maxSum := 1, root.Val
    q := []*TreeNode{root}
    for level := 1; len(q) > 0; level++ {
        tmp := q
        q = nil
        sum := 0
        for _, node := range tmp {
            sum += node.Val
            if node.Left != nil {
                q = append(q, node.Left)
            }
            if node.Right != nil {
                q = append(q, node.Right)
            }
        }
        if sum > maxSum {
            ans, maxSum = level, sum
        }
    }
    return ans
}
```

```C [sol2-C]
#define MAX_NODE_SIZE 10000

int maxLevelSum(struct TreeNode* root){
    int ans = 1, maxSum = root->val;
    struct TreeNode **q = (struct TreeNode **)malloc(sizeof(struct TreeNode *) * MAX_NODE_SIZE);
    struct TreeNode **nq = (struct TreeNode **)malloc(sizeof(struct TreeNode *) * MAX_NODE_SIZE);
    int qSize = 0;
    q[qSize++] = root;
    for (int level = 1; qSize > 0; ++level) {
        int sum = 0, nqSize = 0;
        for (int i = 0; i < qSize; i++) {
            sum += q[i]->val;
            if (q[i]->left) {
                nq[nqSize++] = q[i]->left;
            }
            if (q[i]->right) {
                nq[nqSize++] = q[i]->right;
            }
        }
        if (sum > maxSum) {
            maxSum = sum;
            ans = level;
        }
        struct TreeNode *tmp = q;
        q = nq;
        nq = tmp;
        qSize = nqSize;
    }
    free(q);
    free(nq);
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var maxLevelSum = function(root) {
    let ans = 1, maxSum = root.val;
    let q = [];
    q.push(root);
    for (let level = 1; q.length > 0; ++level) {
        const nq = [];
        let sum = 0;
        for (const node of q) {
            sum += node.val;
            if (node.left) {
                nq.push(node.left);
            }
            if (node.right) {
                nq.push(node.right);
            }
        }
        if (sum > maxSum) {
            maxSum = sum;
            ans = level;
        }
        q = nq;
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉树的节点个数。

- 空间复杂度：$O(n)$。最坏情况下，数组中有 $O(n)$ 个节点。
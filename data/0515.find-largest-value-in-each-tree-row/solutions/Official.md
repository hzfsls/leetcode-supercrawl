## [515.在每个树行中找最大值 中文官方题解](https://leetcode.cn/problems/find-largest-value-in-each-tree-row/solutions/100000/zai-mei-ge-shu-xing-zhong-zhao-zui-da-zh-6xbs)
#### 方法一：深度优先搜索

**思路与算法**

我们用树的「先序遍历」来进行「深度优先搜索」处理，并用 $\textit{curHeight}$ 来标记遍历到的当前节点的高度。当遍历到 $\textit{curHeight}$ 高度的节点就判断是否更新该层节点的最大值。

**代码**

```Python [sol1-Python3]
class Solution:
    def largestValues(self, root: Optional[TreeNode]) -> List[int]:
        ans = []
        def dfs(node: TreeNode, curHeight: int) -> None:
            if node is None:
                return
            if curHeight == len(ans):
                ans.append(node.val)
            else:
                ans[curHeight] = max(ans[curHeight], node.val)
            dfs(node.left, curHeight + 1)
            dfs(node.right, curHeight + 1)
        dfs(root, 0)
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    void dfs(vector<int>& res, TreeNode* root, int curHeight) {
        if (curHeight == res.size()) {
            res.push_back(root->val);
        } else {
            res[curHeight] = max(res[curHeight], root->val);
        }
        if (root->left) {
            dfs(res, root->left, curHeight + 1);
        }
        if (root->right) {
            dfs(res, root->right, curHeight + 1);
        }
    }

    vector<int> largestValues(TreeNode* root) {
        if (!root) {
            return {};
        }
        vector<int> res;
        dfs(res, root, 0);
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> largestValues(TreeNode root) {
        if (root == null) {
            return new ArrayList<Integer>();
        }
        List<Integer> res = new ArrayList<Integer>();
        dfs(res, root, 0);
        return res;
    }

    public void dfs(List<Integer> res, TreeNode root, int curHeight) {
        if (curHeight == res.size()) {
            res.add(root.val);
        } else {
            res.set(curHeight, Math.max(res.get(curHeight), root.val));
        }
        if (root.left != null) {
            dfs(res, root.left, curHeight + 1);
        }
        if (root.right != null) {
            dfs(res, root.right, curHeight + 1);
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<int> LargestValues(TreeNode root) {
        if (root == null) {
            return new List<int>();
        }
        IList<int> res = new List<int>();
        DFS(res, root, 0);
        return res;
    }

    public void DFS(IList<int> res, TreeNode root, int curHeight) {
        if (curHeight == res.Count) {
            res.Add(root.val);
        } else {
            res[curHeight] = Math.Max(res[curHeight], root.val);
        }
        if (root.left != null) {
            DFS(res, root.left, curHeight + 1);
        }
        if (root.right != null) {
            DFS(res, root.right, curHeight + 1);
        }
    }
}
```

```C [sol1-C]
#define MAX_NODE_SIZE 10001
#define MAX(a, b) ((a) > (b) ? (a) : (b))

void dfs(int *res, int *pos, struct TreeNode* root, int curHeight) {
    if (curHeight == *pos) {
        res[(*pos)++] = root->val;
    } else {
        res[curHeight] = MAX(res[curHeight], root->val);
    }
    if (root->left) {
        dfs(res, pos, root->left, curHeight + 1);
    }
    if (root->right) {
        dfs(res, pos, root->right, curHeight + 1);
    }
} 

int* largestValues(struct TreeNode* root, int* returnSize) {
    if (!root) {
        *returnSize = 0;
        return NULL;
    }
    int *res = (int *)malloc(sizeof(int) * MAX_NODE_SIZE);
    *returnSize = 0;
    dfs(res, returnSize, root, 0);
    return res;
}
```

```JavaScript [sol1-JavaScript]
var largestValues = function(root) {
    if (!root) {
        return [];
    }
    const res = [];
    const dfs = (res, root, curHeight) => {
        if (curHeight === res.length) {
            res.push(root.val);
        } else {
            res.splice(curHeight, 1, Math.max(res[curHeight], root.val));
        }
        if (root.left) {
            dfs(res, root.left, curHeight + 1);
        }
        if (root.right) {
            dfs(res, root.right, curHeight + 1);
        }
    }
    dfs(res, root, 0);
    return res;
};
```

```go [sol1-Golang]
func largestValues(root *TreeNode) (ans []int) {
    var dfs func(*TreeNode, int)
    dfs = func(node *TreeNode, curHeight int) {
        if node == nil {
            return
        }
        if curHeight == len(ans) {
            ans = append(ans, node.Val)
        } else {
            ans[curHeight] = max(ans[curHeight], node.Val)
        }
        dfs(node.Left, curHeight+1)
        dfs(node.Right, curHeight+1)
    }
    dfs(root, 0)
    return
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为二叉树节点个数。二叉树的遍历中每个节点会被访问一次且只会被访问一次。

- 空间复杂度：$O(\textit{height})$。其中 $\textit{height}$ 表示二叉树的高度。递归函数需要栈空间，而栈空间取决于递归的深度，因此空间复杂度等价于二叉树的高度。

#### 方法二：广度优先搜索

**思路与算法**

我们也可以用「广度优先搜索」的方法来解决这道题目。「广度优先搜索」中的队列里存放的是「当前层的所有节点」。每次拓展下一层的时候，不同于「广度优先搜索」的每次只从队列里拿出一个节点，我们把当前队列中的全部节点拿出来进行拓展，这样能保证每次拓展完的时候队列里存放的是下一层的所有节点，即我们是一层一层地进行拓展，然后每一层我们用 $\textit{maxVal}$ 来标记该层节点的最大值。当该层全部节点都处理完后，$\textit{maxVal}$ 就是该层全部节点中的最大值。

**代码**

```Python [sol2-Python3]
class Solution:
    def largestValues(self, root: Optional[TreeNode]) -> List[int]:
        if root is None:
            return []
        ans = []
        q = [root]
        while q:
            maxVal = -inf
            tmp = q
            q = []
            for node in tmp:
                maxVal = max(maxVal, node.val)
                if node.left:
                    q.append(node.left)
                if node.right:
                    q.append(node.right)
            ans.append(maxVal)
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    vector<int> largestValues(TreeNode* root) {
        if (!root) {
            return {};
        }
        vector<int> res;
        queue<TreeNode*> q;
        q.push(root);
        while (!q.empty()) {
            int len = q.size();
            int maxVal = INT_MIN;
            while (len > 0) {
                len--;
                auto t = q.front();
                q.pop();
                maxVal = max(maxVal, t->val);
                if (t->left) {
                    q.push(t->left);
                }
                if (t->right) {
                    q.push(t->right);
                }
            }
            res.push_back(maxVal);
        }
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<Integer> largestValues(TreeNode root) {
        if (root == null) {
            return new ArrayList<Integer>();
        }
        List<Integer> res = new ArrayList<Integer>();
        Queue<TreeNode> queue = new ArrayDeque<TreeNode>();
        queue.offer(root);
        while (!queue.isEmpty()) {
            int len = queue.size();
            int maxVal = Integer.MIN_VALUE;
            while (len > 0) {
                len--;
                TreeNode t = queue.poll();
                maxVal = Math.max(maxVal, t.val);
                if (t.left != null) {
                    queue.offer(t.left);
                }
                if (t.right != null) {
                    queue.offer(t.right);
                }
            }
            res.add(maxVal);
        }
        return res;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public IList<int> LargestValues(TreeNode root) {
        if (root == null) {
            return new List<int>();
        }
        IList<int> res = new List<int>();
        Queue<TreeNode> queue = new Queue<TreeNode>();
        queue.Enqueue(root);
        while (queue.Count > 0) {
            int len = queue.Count;
            int maxVal = int.MinValue;
            while (len > 0) {
                len--;
                TreeNode t = queue.Dequeue();
                maxVal = Math.Max(maxVal, t.val);
                if (t.left != null) {
                    queue.Enqueue(t.left);
                }
                if (t.right != null) {
                    queue.Enqueue(t.right);
                }
            }
            res.Add(maxVal);
        }
        return res;
    }
}
```

```C [sol2-C]
#define MAX_NODE_SIZE 10001
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int* largestValues(struct TreeNode* root, int* returnSize) {
    if (!root) {
        *returnSize = 0;
        return NULL;
    }
    int *res = (int *)malloc(sizeof(int) * MAX_NODE_SIZE);
    int pos = 0;
    struct TreeNode **queue = (struct TreeNode *)malloc(sizeof(struct TreeNode *) * MAX_NODE_SIZE);
    int head = 0, tail = 0;
    queue[tail++] = root;
    while (head != tail) {
        int len = tail - head;
        int maxVal = INT_MIN;
        while (len > 0) {
            len--;
            struct TreeNode *node = queue[head++];
            maxVal = MAX(maxVal, node->val);
            if (node->left) {
                queue[tail++] = node->left;
            }
            if (node->right) {
                queue[tail++] = node->right;
            }
        }
        res[pos++] = maxVal;
    }
    *returnSize = pos;
    free(queue);
    return res;
}
```

```JavaScript [sol2-JavaScript]
var largestValues = function(root) {
    if (!root) {
        return [];
    }
    const res = [];
    const queue = [root];
    while (queue.length) {
        let len = queue.length;
        let maxVal = -Number.MAX_VALUE;
        while (len > 0) {
            len--;
            const t = queue.shift();
            maxVal = Math.max(maxVal, t.val);
            if (t.left) {
                queue.push(t.left);
            }
            if (t.right) {
                queue.push(t.right);
            }
        }
        res.push(maxVal);
    }
    return res;
};
```

```go [sol2-Golang]
func largestValues(root *TreeNode) (ans []int) {
    if root == nil {
        return
    }
    q := []*TreeNode{root}
    for len(q) > 0 {
        maxVal := math.MinInt32
        tmp := q
        q = nil
        for _, node := range tmp {
            maxVal = max(maxVal, node.Val)
            if node.Left != nil {
                q = append(q, node.Left)
            }
            if node.Right != nil {
                q = append(q, node.Right)
            }
        }
        ans = append(ans, maxVal)
    }
    return
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为二叉树节点个数，每一个节点仅会进出队列一次。

- 空间复杂度：$O(n)$，存储二叉树节点的空间开销。
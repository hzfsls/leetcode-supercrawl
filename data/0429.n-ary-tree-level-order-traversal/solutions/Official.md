## [429.N 叉树的层序遍历 中文官方题解](https://leetcode.cn/problems/n-ary-tree-level-order-traversal/solutions/100000/n-cha-shu-de-ceng-xu-bian-li-by-leetcode-lxdr)
#### 方法一：广度优先搜索

**思路与算法**

对于「层序遍历」的题目，我们一般使用广度优先搜索。在广度优先搜索的每一轮中，我们会遍历同一层的所有节点。

具体地，我们首先把根节点 $\textit{root}$ 放入队列中，随后在广度优先搜索的每一轮中，我们首先记录下当前队列中包含的节点个数（记为 $\textit{cnt}$），即表示上一层的节点个数。在这之后，我们从队列中依次取出节点，直到取出了上一层的全部 $\textit{cnt}$ 个节点为止。当取出节点 $\textit{cur}$ 时，我们将 $\textit{cur}$ 的值放入一个临时列表，再将 $\textit{cur}$ 的所有子节点全部放入队列中。

当这一轮遍历完成后，临时列表中就存放了当前层所有节点的值。这样一来，当整个广度优先搜索完成后，我们就可以得到层序遍历的结果。

**细节**

需要特殊判断树为空的情况。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> levelOrder(Node* root) {
        if (!root) {
            return {};
        }

        vector<vector<int>> ans;
        queue<Node*> q;
        q.push(root);

        while (!q.empty()) {
            int cnt = q.size();
            vector<int> level;
            for (int i = 0; i < cnt; ++i) {
                Node* cur = q.front();
                q.pop();
                level.push_back(cur->val);
                for (Node* child: cur->children) {
                    q.push(child);
                }
            }
            ans.push_back(move(level));
        }

        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<List<Integer>> levelOrder(Node root) {
        if (root == null) {
            return new ArrayList<List<Integer>>();
        }

        List<List<Integer>> ans = new ArrayList<List<Integer>>();
        Queue<Node> queue = new ArrayDeque<Node>();
        queue.offer(root);

        while (!queue.isEmpty()) {
            int cnt = queue.size();
            List<Integer> level = new ArrayList<Integer>();
            for (int i = 0; i < cnt; ++i) {
                Node cur = queue.poll();
                level.add(cur.val);
                for (Node child : cur.children) {
                    queue.offer(child);
                }
            }
            ans.add(level);
        }

        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<IList<int>> LevelOrder(Node root) {
        if (root == null) {
            return new List<IList<int>>();
        }

        IList<IList<int>> ans = new List<IList<int>>();
        Queue<Node> queue = new Queue<Node>();
        queue.Enqueue(root);

        while (queue.Count > 0) {
            int cnt = queue.Count;
            IList<int> level = new List<int>();
            for (int i = 0; i < cnt; ++i) {
                Node cur = queue.Dequeue();
                level.Add(cur.val);
                foreach (Node child in cur.children) {
                    queue.Enqueue(child);
                }
            }
            ans.Add(level);
        }

        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def levelOrder(self, root: 'Node') -> List[List[int]]:
        if not root:
            return []

        ans = list()
        q = deque([root])

        while q:
            cnt = len(q)
            level = list()
            for _ in range(cnt):
                cur = q.popleft()
                level.append(cur.val)
                for child in cur.children:
                    q.append(child)
            ans.append(level)

        return ans
```

```go [sol1-Golang]
func levelOrder(root *Node) (ans [][]int) {
    if root == nil {
        return
    }
    q := []*Node{root}
    for q != nil {
        level := []int{}
        tmp := q
        q = nil
        for _, node := range tmp {
            level = append(level, node.Val)
            q = append(q, node.Children...)
        }
        ans = append(ans, level)
    }
    return
}
```

```C [sol1-C]
#define MAX_LEVE_SIZE 1000
#define MAX_NODE_SIZE 10000

int** levelOrder(struct Node* root, int* returnSize, int** returnColumnSizes) {
    int ** ans = (int **)malloc(sizeof(int *) * MAX_LEVE_SIZE);
    *returnColumnSizes = (int *)malloc(sizeof(int) * MAX_LEVE_SIZE);
    if (!root) {
        *returnSize = 0;
        return ans;
    }
    struct Node ** queue = (struct Node **)malloc(sizeof(struct Node *) * MAX_NODE_SIZE);
    int head = 0, tail = 0;
    int level = 0;
    queue[tail++] = root;

    while (head != tail) {
        int cnt = tail - head;
        ans[level] = (int *)malloc(sizeof(int) * cnt);
        for (int i = 0; i < cnt; ++i) {
            struct Node * cur = queue[head++];
            ans[level][i] = cur->val;
            for (int j = 0; j < cur->numChildren; j++) {
                queue[tail++] = cur->children[j];
            }
        }
        (*returnColumnSizes)[level++] = cnt;
    }
    *returnSize = level;
    free(queue);
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var levelOrder = function(root) {
    if (!root) {
        return [];
    }

    const ans = [];
    const queue = [root];

    while (queue.length) {
        const cnt = queue.length;
        const level = [];
        for (let i = 0; i < cnt; ++i) {
            const cur = queue.shift();
            level.push(cur.val);
            for (const child of cur.children) {
                queue.push(child);
            }
        }
        ans.push(level);
    }

    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是树中包含的节点个数。在广度优先搜索的过程中，我们需要遍历每一个节点恰好一次。

- 空间复杂度：$O(n)$，即为队列需要使用的空间。在最坏的情况下，树只有两层，且最后一层有 $n-1$ 个节点，此时就需要 $O(n)$ 的空间。
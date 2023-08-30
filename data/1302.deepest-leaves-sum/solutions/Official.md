#### 方法一：深度优先搜索

由于层数最深的节点一定是叶节点，因此只要找到所有层数最深的节点并计算节点值之和即可。

可以使用深度优先搜索实现。从根节点开始遍历整个二叉树，遍历每个节点时需要记录该节点的层数，规定根节点在第 $0$ 层。遍历过程中维护最大层数与最深节点之和。

对于每个非空节点，执行如下操作。

1. 判断当前节点的层数与最大层数的关系：

   - 如果当前节点的层数大于最大层数，则之前遍历到的节点都不是层数最深的节点，因此用当前节点的层数更新最大层数，并将最深节点之和更新为当前节点值；

   - 如果当前节点的层数等于最大层数，则将当前节点值加到最深节点之和。

2. 对当前节点的左右子节点继续深度优先搜索。

遍历结束之后，即可得到层数最深叶子节点的和。

```Python [sol1-Python3]
class Solution:
    def deepestLeavesSum(self, root: Optional[TreeNode]) -> int:
        maxLevel, ans = -1, 0
        def dfs(node: Optional[TreeNode], level: int) -> None:
            if node is None:
                return
            nonlocal maxLevel, ans
            if level > maxLevel:
                maxLevel, ans = level, node.val
            elif level == maxLevel:
                ans += node.val
            dfs(node.left, level + 1)
            dfs(node.right, level + 1)
        dfs(root, 0)
        return ans
```

```Java [sol1-Java]
class Solution {
    int maxLevel = -1;
    int sum = 0;

    public int deepestLeavesSum(TreeNode root) {
        dfs(root, 0);
        return sum;
    }

    public void dfs(TreeNode node, int level) {
        if (node == null) {
            return;
        }
        if (level > maxLevel) {
            maxLevel = level;
            sum = node.val;
        } else if (level == maxLevel) {
            sum += node.val;
        }
        dfs(node.left, level + 1);
        dfs(node.right, level + 1);
    }
}
```

```C# [sol1-C#]
public class Solution {
    int maxLevel = -1;
    int sum = 0;

    public int DeepestLeavesSum(TreeNode root) {
        DFS(root, 0);
        return sum;
    }

    public void DFS(TreeNode node, int level) {
        if (node == null) {
            return;
        }
        if (level > maxLevel) {
            maxLevel = level;
            sum = node.val;
        } else if (level == maxLevel) {
            sum += node.val;
        }
        DFS(node.left, level + 1);
        DFS(node.right, level + 1);
    }
}
```

```C++ [sol1-C++]
class Solution {
private:
    int maxLevel = -1;
    int sum = 0;

public:
    int deepestLeavesSum(TreeNode* root) {
        dfs(root, 0);
        return sum;
    }

    void dfs(TreeNode* node, int level) {
        if (node == nullptr) {
            return;
        }
        if (level > maxLevel) {
            maxLevel = level;
            sum = node->val;
        } else if (level == maxLevel) {
            sum += node->val;
        }
        dfs(node->left, level + 1);
        dfs(node->right, level + 1);
    }
};
```

```C [sol1-C]
void dfs(struct TreeNode* node, int level, int* maxLevel, int* sum) {
    if (node == NULL) {
        return;
    }
    if (level > *maxLevel) {
        *maxLevel = level;
        *sum = node->val;
    } else if (level == *maxLevel) {
        *sum += node->val;
    }
    dfs(node->left, level + 1, maxLevel, sum);
    dfs(node->right, level + 1, maxLevel, sum);
}

int deepestLeavesSum(struct TreeNode* root){
    int maxLevel = -1;
    int sum = 0;
    dfs(root, 0, &maxLevel, &sum);
    return sum;
}
```

```JavaScript [sol1-JavaScript]
var deepestLeavesSum = function(root) {
    let maxLevel = -1;
    let sum = 0;
    const dfs = (node, level) => {
        if (!node) {
            return;
        }
        if (level > maxLevel) {
            maxLevel = level;
            sum = node.val;
        } else if (level === maxLevel) {
            sum += node.val;
        }
        dfs(node.left, level + 1);
        dfs(node.right, level + 1);
    }
    dfs(root, 0);
    return sum;
};
```

```go [sol1-Golang]
func deepestLeavesSum(root *TreeNode) (sum int) {
    maxLevel := -1
    var dfs func(*TreeNode, int)
    dfs = func(node *TreeNode, level int) {
        if node == nil {
            return
        }
        if level > maxLevel {
            maxLevel = level
            sum = node.Val
        } else if level == maxLevel {
            sum += node.Val
        }
        dfs(node.Left, level+1)
        dfs(node.Right, level+1)
    }
    dfs(root, 0)
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉树的节点数。深度优先搜索需要遍历每个节点一次。

- 空间复杂度：$O(n)$，其中 $n$ 是二叉树的节点数。空间复杂度主要取决于递归调用栈的深度，为二叉树的深度，最坏情况下二叉树的深度是 $O(n)$。

#### 方法二：广度优先搜索

计算最深节点之和也可以使用广度优先搜索实现。使用广度优先搜索时，对二叉树层序遍历，此时不需要维护最大层数，只需要确保每一轮遍历的节点是同一层的全部节点，则最后一轮遍历的节点是全部最深节点。

初始时，将根节点加入队列，此时队列中只有一个节点，是同一层的全部节点。每一轮遍历时，首先得到队列中的节点个数 $\textit{size}$，从队列中取出 $\textit{size}$ 个节点，则这 $\textit{size}$ 个节点是同一层的全部节点，记为第 $x$ 层。遍历时，第 $x$ 层的每个节点的子节点都在第 $x + 1$ 层，将子节点加入队列，则该轮遍历结束之后，第 $x$ 层的节点全部从队列中取出，第 $x + 1$ 层的节点全部加入队列，队列中的节点是同一层的全部节点。因此该方法可以确保每一轮遍历的节点是同一层的全部节点。

遍历过程中，分别计算每一层的节点之和，则遍历结束时的节点之和即为层数最深叶子节点的和。

```Python [sol2-Python3]
class Solution:
    def deepestLeavesSum(self, root: Optional[TreeNode]) -> int:
        q = deque([root])
        while q:
            ans = 0
            for _ in range(len(q)):
                node = q.popleft()
                ans += node.val
                if node.left:
                    q.append(node.left)
                if node.right:
                    q.append(node.right)
        return ans
```

```Java [sol2-Java]
class Solution {
    public int deepestLeavesSum(TreeNode root) {
        int sum = 0;
        Queue<TreeNode> queue = new ArrayDeque<TreeNode>();
        queue.offer(root);
        while (!queue.isEmpty()) {
            sum = 0;
            int size = queue.size();
            for (int i = 0; i < size; i++) {
                TreeNode node = queue.poll();
                sum += node.val;
                if (node.left != null) {
                    queue.offer(node.left);
                }
                if (node.right != null) {
                    queue.offer(node.right);
                }
            }
        }
        return sum;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int DeepestLeavesSum(TreeNode root) {
        int sum = 0;
        Queue<TreeNode> queue = new Queue<TreeNode>();
        queue.Enqueue(root);
        while (queue.Count > 0) {
            sum = 0;
            int size = queue.Count;
            for (int i = 0; i < size; i++) {
                TreeNode node = queue.Dequeue();
                sum += node.val;
                if (node.left != null) {
                    queue.Enqueue(node.left);
                }
                if (node.right != null) {
                    queue.Enqueue(node.right);
                }
            }
        }
        return sum;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int deepestLeavesSum(TreeNode* root) {
        int sum = 0;
        queue<TreeNode*> qu;
        qu.emplace(root);
        while (!qu.empty()) {
            sum = 0;
            int size = qu.size();
            for (int i = 0; i < size; i++) {
                TreeNode *node = qu.front();
                qu.pop();
                sum += node->val;
                if (node->left != nullptr) {
                    qu.emplace(node->left);
                }
                if (node->right != nullptr) {
                    qu.emplace(node->right);
                }
            }
        }
        return sum;
    }
};
```

```C [sol2-C]
#define MAX_NODE_SIZE 10001

int deepestLeavesSum(struct TreeNode* root){
    int sum = 0;
    struct TreeNode **queue = (struct TreeNode **)malloc(sizeof(struct TreeNode *) * MAX_NODE_SIZE);
    int head = 0, tail = 0;
    queue[tail++] = root;
    while (head != tail) {
        sum = 0;
        int size = tail - head;
        for (int i = 0; i < size; i++) {
            struct TreeNode *node = queue[head++];
            sum += node->val;
            if (node->left != NULL) {
                queue[tail++] = node->left;
            }
            if (node->right != NULL) {
                queue[tail++] = node->right;
            }
        }
    }
    free(queue);
    return sum;
}
```

```JavaScript [sol2-JavaScript]
var deepestLeavesSum = function(root) {
    let sum = 0;
    const queue = [];
    queue.push(root);
    while (queue.length) {
        sum = 0;
        const size = queue.length;
        for (let i = 0; i < size; i++) {
            const node = queue.shift();
            sum += node.val;
            if (node.left) {
                queue.push(node.left);
            }
            if (node.right) {
                queue.push(node.right);
            }
        }
    }
    return sum;
};
```

```go [sol2-Golang]
func deepestLeavesSum(root *TreeNode) (sum int) {
    q := []*TreeNode{root}
    for len(q) > 0 {
        sum = 0
        size := len(q)
        for i := 0; i < size; i++ {
            node := q[0]
            q = q[1:]
            sum += node.Val
            if node.Left != nil {
                q = append(q, node.Left)
            }
            if node.Right != nil {
                q = append(q, node.Right)
            }
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉树的节点数。广度优先搜索需要遍历每个节点一次。

- 空间复杂度：$O(n)$，其中 $n$ 是二叉树的节点数。空间复杂度主要取决于队列空间，队列中的节点个数不超过 $n$ 个。
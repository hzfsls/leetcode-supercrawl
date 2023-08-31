## [559.N 叉树的最大深度 中文官方题解](https://leetcode.cn/problems/maximum-depth-of-n-ary-tree/solutions/100000/n-cha-shu-de-zui-da-shen-du-by-leetcode-n7qtv)

#### 前言

「[104. 二叉树的最大深度](https://leetcode-cn.com/problems/maximum-depth-of-binary-tree)」要求计算二叉树的最大深度，这道题是第 104 题的推广，从二叉树推广到 $N$ 叉树。

建议读者先阅读「[104. 二叉树的最大深度的官方题解](https://leetcode-cn.com/problems/maximum-depth-of-binary-tree/solution/er-cha-shu-de-zui-da-shen-du-by-leetcode-solution)」，了解如何计算二叉树的最大深度，然后再阅读这篇题解。

#### 方法一：深度优先搜索

如果根节点有 $N$ 个子节点，则这 $N$ 个子节点对应 $N$ 个子树。记 $N$ 个子树的最大深度中的最大值为 $\textit{maxChildDepth}$，则该 $N$ 叉树的最大深度为 $\textit{maxChildDepth} + 1$。

每个子树的最大深度又可以以同样的方式进行计算。因此我们可以用「深度优先搜索」的方法计算 $N$ 叉树的最大深度。具体而言，在计算当前 $N$ 叉树的最大深度时，可以先递归计算出其每个子树的最大深度，然后在 $O(1)$ 的时间内计算出当前 $N$ 叉树的最大深度。递归在访问到空节点时退出。

```Java [sol1-Java]
class Solution {
    public int maxDepth(Node root) {
        if (root == null) {
            return 0;
        }
        int maxChildDepth = 0;
        List<Node> children = root.children;
        for (Node child : children) {
            int childDepth = maxDepth(child);
            maxChildDepth = Math.max(maxChildDepth, childDepth);
        }
        return maxChildDepth + 1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxDepth(Node root) {
        if (root == null) {
            return 0;
        }
        int maxChildDepth = 0;
        IList<Node> children = root.children;
        foreach (Node child in children) {
            int childDepth = MaxDepth(child);
            maxChildDepth = Math.Max(maxChildDepth, childDepth);
        }
        return maxChildDepth + 1;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int maxDepth(Node* root) {
        if (root == nullptr) {
            return 0;
        }
        int maxChildDepth = 0;
        vector<Node *> children = root->children;
        for (auto child : children) {
            int childDepth = maxDepth(child);
            maxChildDepth = max(maxChildDepth, childDepth);
        }
        return maxChildDepth + 1;
    }
};
```

```JavaScript [sol1-JavaScript]
var maxDepth = function(root) {
    if (!root) {
        return 0;
    }
    let maxChildDepth = 0;
    const children = root.children;
    for (const child of children) {
        const childDepth = maxDepth(child);
        maxChildDepth = Math.max(maxChildDepth, childDepth);
    }
    return maxChildDepth + 1;
};
```

```go [sol1-Golang]
func maxDepth(root *Node) int {
    if root == nil {
        return 0
    }
    maxChildDepth := 0
    for _, child := range root.Children {
        if childDepth := maxDepth(child); childDepth > maxChildDepth {
            maxChildDepth = childDepth
        }
    }
    return maxChildDepth + 1
}
```

```Python [sol1-Python3]
class Solution:
    def maxDepth(self, root: 'Node') -> int:
        return max((self.maxDepth(child) for child in root.children), default=0) + 1 if root else 0
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $N$ 叉树节点的个数。每个节点在递归中只被遍历一次。

- 空间复杂度：$O(\textit{height})$，其中 $\textit{height}$ 表示 $N$ 叉树的高度。递归函数需要栈空间，而栈空间取决于递归的深度，因此空间复杂度等价于 $N$ 叉树的高度。

#### 方法二：广度优先搜索

我们也可以用「广度优先搜索」的方法来解决这道题目，但我们需要对其进行一些修改，此时我们广度优先搜索的队列里存放的是「当前层的所有节点」。每次拓展下一层的时候，不同于广度优先搜索的每次只从队列里拿出一个节点，我们需要将队列里的所有节点都拿出来进行拓展，这样能保证每次拓展完的时候队列里存放的是当前层的所有节点，即我们是一层一层地进行拓展。最后我们用一个变量 $\textit{ans}$ 来维护拓展的次数，该 $N$ 叉树的最大深度即为 $\textit{ans}$。

```Java [sol2-Java]
class Solution {
    public int maxDepth(Node root) {
        if (root == null) {
            return 0;
        }
        Queue<Node> queue = new LinkedList<Node>();
        queue.offer(root);
        int ans = 0;
        while (!queue.isEmpty()) {
            int size = queue.size();
            while (size > 0) {
                Node node = queue.poll();
                List<Node> children = node.children;
                for (Node child : children) {
                    queue.offer(child);
                }
                size--;
            }
            ans++;
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MaxDepth(Node root) {
        if (root == null) {
            return 0;
        }
        Queue<Node> queue = new Queue<Node>();
        queue.Enqueue(root);
        int ans = 0;
        while (queue.Count > 0) {
            int size = queue.Count;
            while (size > 0) {
                Node node = queue.Dequeue();
                IList<Node> children = node.children;
                foreach (Node child in children) {
                    queue.Enqueue(child);
                }
                size--;
            }
            ans++;
        }
        return ans;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int maxDepth(Node* root) {
        if (root == nullptr) {
            return 0;
        }
        queue<Node *> qu;
        qu.push(root);
        int ans = 0;
        while (!qu.empty()) {
            int size = qu.size();
            while (size > 0) {
                Node * node = qu.front();
                qu.pop();
                vector<Node *> children = node->children;
                for (auto child : children) {
                    qu.push(child);
                }
                size--;
            }
            ans++;
        }
        return ans;
    }
};
```

```JavaScript [sol2-JavaScript]
var maxDepth = function(root) {
    if (!root) {
        return 0;
    }
    const queue = [];
    queue.push(root);
    let ans = 0;
    while (queue.length) {
        let size = queue.length;
        while (size > 0) {
            const node = queue.shift();
            const children = node.children;
            for (const child of children) {
                queue.push(child);
            }
            size--;
        }
        ans++;
    }
    return ans;
};
```

```go [sol2-Golang]
func maxDepth(root *Node) (ans int) {
    if root == nil {
        return
    }
    queue := []*Node{root}
    for len(queue) > 0 {
        q := queue
        queue = nil
        for _, node := range q {
            queue = append(queue, node.Children...)
        }
        ans++
    }
    return
}
```

```Python [sol2-Python3]
class Solution:
    def maxDepth(self, root: 'Node') -> int:
        if root is None:
            return 0
        ans = 0
        queue = [root]
        while queue:
            queue = [child for node in queue for child in node.children]
            ans += 1
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $N$ 叉树的节点个数。与方法一同样的分析，每个节点只会被访问一次。

- 空间复杂度：此方法空间的消耗取决于队列存储的元素数量，其在最坏情况下会达到 $O(n)$。
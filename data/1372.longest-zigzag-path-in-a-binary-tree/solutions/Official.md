## [1372.二叉树中的最长交错路径 中文官方题解](https://leetcode.cn/problems/longest-zigzag-path-in-a-binary-tree/solutions/100000/er-cha-shu-zhong-de-zui-chang-jiao-cuo-lu-jing-b-2)
#### 题目分析

题目要求我们找到树当中一条最长的左右交错的路径。

#### 方法一：动态规划

**思路**

记 $f(u)$ 为从根到节点 $u$ 的路径上以 $u$ 结尾并且 $u$ 是它父亲的左儿子的最长交错路径，$g(u)$ 为从根到节点 $u$ 的路径上以 $u$ 结尾并且 $u$ 是它父亲的右儿子的最长交错路径。记 $u$ 的父节点为 ${\rm father}(u)$，我们可以推得这样的转移方程：

$$\begin{aligned} & f[u] = g[{\rm father}(u)] + 1 &,& \, u \text{是左儿子} \\ & g[u] = f[{\rm father}(u)] + 1 &,& \, u \text{是右儿子}  \end{aligned}$$

很好理解，因为我们需要一条「交错」的路，如果 $u$ 是 ${\rm father}(u)$ 的左儿子，那么 ${\rm father}(u)$ 一定是 ${\rm father}({\rm father}(u))$ 的右儿子；反之，如果 $u$ 是 ${\rm father}(u)$ 的右儿子，那么 ${\rm father}(u)$ 一定是 ${\rm father}({\rm father}(u))$ 的左儿子。

实现的时候我们需要维护两个数组—— `f` 和 `g`，这里我们可以用从树的节点到整数的映射容器来实现，这样很方便从节点的指针映射到 $f$ 和 $g$ 的函数值。理论上我们可以用 DFS 或者 BFS 的任意一种框架来遍历这棵树，这里提供一个 BFS 的版本。我们用二元组 `(node, parent)` 作为状态，其中 `node` 表示当前待计算 `f` 和 `g` 的值的节点，`parent` 表示它的父亲。初始化的时候我们可以把每个点的 `f` 和 `g` 的值都置 0。在动态规划算法 BFS 过程中，先根据当前的点是左子树还是右子树更新 `f` 和 `g`，然后再拓展新状态入队。

最终我们可以遍历 `f` 和 `g`，找到最大的答案。

代码如下。


**代码**

```C++ [sol1]
class Solution {
public:
    unordered_map <TreeNode*, int> f, g;
    
    queue <pair <TreeNode *, TreeNode *>> q;
    
    void dp(TreeNode *o) {
        f[o] = g[o] = 0;
        q.push({o, nullptr});
        while (!q.empty()) {
            auto y = q.front(); q.pop();
            auto x = y.second, u = y.first;
            f[u] = g[u] = 0;
            if (x) {
                if (x->left == u) f[u] = g[x] + 1;
                if (x->right == u) g[u] = f[x] + 1;
            }
            if (u->left) q.push({u->left, u});
            if (u->right) q.push({u->right, u});
        }
    }
    
    int longestZigZag(TreeNode* root) {
        dp(root);
        int maxAns = 0;
        for (const auto &u: f) maxAns = max(maxAns, max(u.second, g[u.first]));
        return maxAns;
    }
};
```

```Java [sol1]
class Solution {
    Map<TreeNode, Integer> f = new HashMap<TreeNode, Integer>();
    Map<TreeNode, Integer> g = new HashMap<TreeNode, Integer>();
    Queue<TreeNode[]> q = new LinkedList<TreeNode[]>();

    public int longestZigZag(TreeNode root) {
        dp(root);
        int maxAns = 0;
        for (TreeNode u : f.keySet()) {
            maxAns = Math.max(maxAns, Math.max(f.get(u), g.get(u)));
        }
        return maxAns;
    }
    
    public void dp(TreeNode o) {
        f.put(o, 0);
        g.put(o, 0);
        q.offer(new TreeNode[]{o, null});
        while (!q.isEmpty()) {
            TreeNode[] y = q.poll();
            TreeNode u = y[0], x = y[1];
            f.put(u, 0);
            g.put(u, 0);
            if (x != null) {
                if (x.left == u) {
                    f.put(u, g.get(x) + 1);
                }
                if (x.right == u) {
                    g.put(u, f.get(x) + 1);
                }
            }
            if (u.left != null) {
                q.offer(new TreeNode[]{u.left, u});
            }
            if (u.right != null) {
                q.offer(new TreeNode[]{u.right, u});
            }
        }
    }
}
```

```Python [sol1]
class Solution:
    def longestZigZag(self, root: TreeNode) -> int:
        f, g = collections.defaultdict(int), collections.defaultdict(int)
        q = collections.deque([(root, None)])
        while len(q) > 0:
            node, parent = q.popleft()
            if parent:
                if parent.left == node:
                    f[node] = g[parent] + 1
                else:
                    g[node] = f[parent] + 1
            if node.left:
                q.append((node.left, node))
            if node.right:
                q.append((node.right, node))
        
        maxans = 0
        for _, val in f.items():
            maxans = max(maxans, val)
        for _, val in g.items():
            maxans = max(maxans, val)
        return maxans
```

**复杂度**

记 $n$ 为树上的节点总数。

- 时间复杂度：在 BFS 的过程中，每个点只被访问一次，所以这里的渐进时间复杂度为 $O(n)$。

- 空间复杂度：我们这里开了 `f` 和 `g` 两个大小为 $n$ 的数组和一个用来做 BFS 的队列。每个点最多进队两次（一次在初始化的过程中，一次在动态规划的过程中），所以队列最大的时候不会超过 $n$ 个元素。所以这里的渐进空间复杂度为 $O(n)$。

#### 方法二：深度优先搜索

**思路**

考虑以上的 DP 对于每个节点 $u$ 只使用到了父亲节点的信息，所以我们可以在 DFS 的时候作为参数传递下来，省掉两个数组的空间开销。

**思考：是否需要把 `f` 和 `g` 的值都传递下来？** 其实是不需要的，实际上我们只需要传递「当前」这个点应该走的方向（「向左」或者「向右」）`dir`，以及以这个点结尾的最长交错路径的长度 `len`。对于 `dir` 这个参数，这里 `0` 表示向左，`1` 表示向右。

在 DFS 的过程中，每次我们都把当前点的 `len` 参数和答案 `maxAns` 打擂台，这样可以比出一个最大的。然后我们根据 `dir` 分类讨论。如果当前点应该向左且可以向左，那么就让他向左走一步，新的 `len` 是当前的 `len` 加一。如果的的点应该向左但是却没有左子树呢？很无奈那就只能向右了，这个时候 `len` 的值应该「重置」。

**思考：「重置」为什么是把 `len` 变成 1 而不是 0？** 因为当前的点下传到它的子节点的时候已经走了一条长度为 1 的边。**那么为什么 `main` 函数中传入的 `len` 值是 0 而不是 1 呢？** 因为 `main` 函数中的 `root` 是没有父亲节点的，所以当前已经走过的路为 0。

以下是代码实现。

**代码**

```C++ [sol2]
class Solution {
public:
    int maxAns;

    /* 0 => left, 1 => right */
    void dfs(TreeNode* o, bool dir, int len) {
        maxAns = max(maxAns, len);
        if (!dir) {
            if (o->left) dfs(o->left, 1, len + 1);
            if (o->right) dfs(o->right, 0, 1);
        } else {
            if (o->right) dfs(o->right, 0, len + 1);
            if (o->left) dfs(o->left, 1, 1);
        }
    } 

    int longestZigZag(TreeNode* root) {
        if (!root) return 0;
        maxAns = 0;
        dfs(root, 0, 0);
        dfs(root, 1, 0);
        return maxAns;
    }
};
```

```Java [sol2]
class Solution {
    int maxAns;

    public int longestZigZag(TreeNode root) {
        if (root == null) {
            return 0;
        }
        maxAns = 0;
        dfs(root, false, 0);
        dfs(root, true, 0);
        return maxAns;
    }

    public void dfs(TreeNode o, boolean dir, int len) {
        maxAns = Math.max(maxAns, len);
        if (!dir) {
            if (o.left != null) {
                dfs(o.left, true, len + 1);
            }
            if (o.right != null) {
                dfs(o.right, false, 1);
            }
        } else {
            if (o.right != null) {
                dfs(o.right, false, len + 1);
            }
            if (o.left != null) {
                dfs(o.left, true, 1);
            }
        }
    }
}
```

```Python [sol2]
class Solution:
    def longestZigZag(self, root: TreeNode) -> int:
        maxans = 0

        def dfs(o, direction, length):
            if not o:
                return

            nonlocal maxans
            maxans = max(maxans, length)
            if direction == 0:
                dfs(o.left, 1, length + 1)
                dfs(o.right, 0, 1)
            else:
                dfs(o.right, 0, length + 1)
                dfs(o.left, 1, 1)
        
        dfs(root, 0, 0)
        dfs(root, 1, 0)
        return maxans
```

**复杂度分析**

- 时间复杂度：在 DFS 的过程中，这棵树中的所有节点都会被访问一次，所以如果节点总数是 $n$ 的话，那么渐进时间复杂度就是 $O(n)$。

- 空间复杂度：这里用到的辅助空间是 `maxAns` 变量，所以渐进空间复杂度是 $O(1)$。
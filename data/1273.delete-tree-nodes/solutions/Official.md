**方法一：深度优先搜索**

对于树中的每一个节点 `u`，我们通过深度优先搜索的方法，递归地搜索它的所有子节点 `v`，计算出以 `v` 为根的子树的节点数目和权值之和。在这之后，我们将子节点的值分别进行累加，就可以得到以 `u` 为根的子树的节点数目和权值之和。如果权值之和为零，那么以 `u` 为根的子树需要被删除，我们将其节点数目也置为零，作为结果返回到上一层。最终根节点 `0` 对应的节点数目即为答案。

由于题目中是用数组 `parent` 给出每个节点的父节点，表示树中的边。因此为了便于进行深度优先搜索，我们需要将这些边重新存入邻接表中。

```C++ [sol1]
class Solution {
public:
    void dfs(int u, const vector<vector<int>>& edges, vector<int>& value, vector<int>& node_cnt) {
        for (int v: edges[u]) {
            dfs(v, edges, value, node_cnt);
            value[u] += value[v];
            node_cnt[u] += node_cnt[v];
        }
        if (value[u] == 0) {
            node_cnt[u] = 0;
        }
    }
    
    int deleteTreeNodes(int nodes, vector<int>& parent, vector<int>& value) {
        vector<vector<int>> edges(nodes);
        for (int i = 0; i < nodes; ++i) {
            if (parent[i] != -1) {
                edges[parent[i]].push_back(i);
            }
        }
        vector<int> node_cnt(nodes, 1);
        dfs(0, edges, value, node_cnt);
        return node_cnt[0];
    }
};
```

```Python [sol1]
class Solution:
    def deleteTreeNodes(self, nodes: int, parent: List[int], value: List[int]) -> int:
        edges = {x: list() for x in range(nodes)}
        for x, p in enumerate(parent):
            if p != -1:
                edges[p].append(x)
        
        node_cnt = [1] * nodes
        
        def dfs(u):
            for v in edges[u]:
                dfs(v)
                value[u] += value[v]
                node_cnt[u] += node_cnt[v]
            if value[u] == 0:
                node_cnt[u] = 0

        dfs(0)
        return node_cnt[0]
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是树中的节点个数。

- 空间复杂度：$O(N)$。

**方法二：拓扑排序**

在方法一中，我们使用深度优先搜索的原因是：在计算某个节点 `u` 的一系列值之前，我们需要计算出其每个子节点 `v` 的一系列值。如果我们可以找出所有节点的一个排列，使得对于任意一个节点 `u`，它的子节点 `v` 在排列中都出现在 `u` 之前，那么我们就可以按照顺序依次遍历排列中的每个节点，计算出这一系列的值，而省去了深度优先搜索的步骤。

我们可以使用拓扑排序找出这样的一个排列。如果 `u` 是 `v` 的父节点，那么我们从 `v` 到 `u` 连接一条有向边。对这个图进行拓扑排序，我们就可以得到一个满足要求的排列。使用拓扑排序的另一个好处是省去了邻接表，我们可以直接通过数组 `parent` 构造拓扑排序对应的图，并且在得到排列后，我们计算出 `v` 的一系列值可以直接累加到 `u` 对应的值中，而不用遍历到 `u` 的时候再进行累加。

```C++ [sol2]
class Solution {
public:
    int deleteTreeNodes(int nodes, vector<int>& parent, vector<int>& value) {
        vector<int> in_deg(nodes);
        for (int i = 0; i < nodes; ++i) {
            if (parent[i] != -1) {
                ++in_deg[parent[i]];
            }
        }

        vector<int> node_cnt(nodes, 1);
        queue<int> q;
        for (int i = 0; i < nodes; ++i) {
            if (in_deg[i] == 0) {
                q.push(i);
            }
        }
        while (!q.empty()) {
            int v = q.front();
            q.pop();
            if (value[v] == 0) {
                node_cnt[v] = 0;
            }
            int u = parent[v];
            if (u != -1) {
                value[u] += value[v];
                node_cnt[u] += node_cnt[v];
                if (--in_deg[u] == 0) {
                    q.push(u);
                }
            }
        }
        
        return node_cnt[0];
    }
};
```

```Python [sol2]
class Solution:
    def deleteTreeNodes(self, nodes: int, parent: List[int], value: List[int]) -> int:
        in_deg = [0] * nodes
        for p in parent:
            if p != -1:
                in_deg[p] += 1
        
        node_cnt = [1] * nodes
        q = queue.Queue()
        for i in range(nodes):
            if in_deg[i] == 0:
                q.put_nowait(i)

        while not q.empty():
            v = q.get_nowait()
            if value[v] == 0:
                node_cnt[v] = 0
            u = parent[v]
            if u != -1:
                value[u] += value[v]
                node_cnt[u] += node_cnt[v]
                in_deg[u] -= 1
                if in_deg[u] == 0:
                    q.put_nowait(u)

        return node_cnt[0]
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是树中的节点个数。

- 空间复杂度：$O(N)$。

**方法三：基于数据特殊性的错误方法**

由于某些【未知的】原因，出题者在构造数据时，自行添加了额外的条件，使得数组 `parents` 中 `parents[i] < i` 恒成立，即每个节点的编号都大于其父节点的编号。因此我们可以直接断定 `N - 1, N - 2, ..., 1, 0`，即将节点的编号逆序得到的排列，就是方法二中的一个满足要求的排列。

这样以来，我们可以省去方法二中的拓扑排序，转而直接按照编号逆序地遍历所有节点并计算出一系列值。注意：这种方法是由于数据特性而得出的，它并不是一种正确的方法。

```C++ [sol3]
class Solution {
public:
    int deleteTreeNodes(int nodes, vector<int>& parent, vector<int>& value) {
        vector<int> node_cnt(nodes, 1);
        for (int i = nodes - 1; i >= 0; --i) {
            if (value[i] == 0) {
                node_cnt[i] = 0;
            }
            if (parent[i] != -1) {
                value[parent[i]] += value[i];
                node_cnt[parent[i]] += node_cnt[i];
            }
        }
        return node_cnt[0];
    }
};
```

```Python [sol3]
class Solution:
    def deleteTreeNodes(self, nodes: int, parent: List[int], value: List[int]) -> int:
        node_cnt = [1] * nodes
        for i in range(nodes - 1, -1, -1):
            if value[i] == 0:
                node_cnt[i] = 0
            if parent[i] != -1:
                value[parent[i]] += value[i]
                node_cnt[parent[i]] += node_cnt[i]
        return node_cnt[0]
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是树中的节点个数。

- 空间复杂度：$O(N)$。
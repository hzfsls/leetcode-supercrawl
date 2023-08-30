#### 前言

本题难度较大。读者需要首先掌握朴素的 [Dijkstra 算法](https://oi-wiki.org/graph/shortest-path/#dijkstra-%E7%AE%97%E6%B3%95)，时间复杂度为 $O(n^2)$，其中 $n$ 是图中的节点数量。如果使用优先队列进行优化，时间复杂度为 $O(m \log m)$，其中 $m$ 是图中的边的数量，而本题中 $m$ 的范围可以达到 $O(n^2)$ 的级别，因此使用朴素的版本，时间复杂度更低。

下面会介绍两种方法，第一种方法只需要使用不修改的朴素 Dijkstra 算法，但时间复杂度较高。第二种方法需要在 Dijkstra 算法的基础上进行修改，且有较高的思维难度，但时间复杂度较低。

为了叙述方便，下文用 $s, t, D$ 分别表示题目中的起点 $\textit{source}$，终点 $\textit{destiation}$ 和目标的最短距离 $\textit{target}$。

#### 方法一：二分查找 + 最短路

**提示 $1$**

给定任意一个图，如果节点 $s$ 到 $t$ 的最短路长度为 $d_{\min}(s, t)$，那么如果我们给图中的任意一条边的长度增加 $1$，那么新的最短路长度要么仍然为 $d_{\min}(s, t)$，要么为 $d_{\min}(s, t) + 1$。

**提示 $1$ 证明**

如果**所有**的 $s-t$ 最短路都经过了修改的边，那么最短路的长度会增加 $1$。否则，存在一条 $s-t$ 最短路没有任何改动，最短路的长度不变。

**思路与算法**

根据题目的描述，我们可以得到下面的结论：

- 当所有可以修改的边的长度为 $1$ 时，$s-t$ 最短路的长度达到最小值；

- 当所有可以修改的边的长度为 $2 \times 10^9$ 时，$s-t$ 的最短路长度达到最大值。

然而，把一条边的长度定为 $D$ 以上的值是没有意义的，因为：

- 如果我们希望这条边出现在最短路中，那么它的长度一定不可能大于 $D$；

- 如果我们不希望这条边出现在最短路中，那么将它的值定为 $D$，加上任意一条路径上的边，就会得到大于 $D$ 的路径长度，这样就是合理的。

因此，每一条可以修改的边的长度范围为 $[1, D]$。此时，我们就可以构造出下面 $k \times (D-1) + 1$ 种不同的边权情况，其中 $k$ 是可以修改的边的数量：

- $[1, 1, 1, \cdots, 1]$
- $[2, 1, 1, \cdots, 1]$
- $[3, 1, 1, \cdots, 1]$
- $\cdots$
- $[D, 1, 1, \cdots, 1]$
- $[D, 2, 1, \cdots, 1]$
- $[D, 3, 1, \cdots, 1]$
- $\cdots$
- $[D, D, D, \cdots, D]$

即每次将第一条可以修改的并且长度没有到达 $D$ 的边的长度增加 $1$。根据提示 $1$，相邻两种边权情况对应的最短路长度要么相同，要么增加 $1$。因此：

> 这 $k \times (D-1) + 1$ 种不同的边权情况，包含了最短路长度的最小值到最大值之间的**所有**可能的最短路值，并且上面构造的边权情况的序列，其最短路的长度是满足**单调性**的。

这样一来，我们就可以设计出如下的算法：

- 我们对边权情况为 $[1, 1, 1, \cdots, 1]$ 计算一次最短路。如果最短路的长度大于 $D$，那么无解；

- 我们对边权情况为 $[D, D, D, \cdots, D]$ 计算一次最短路。如果最短路的长度小于 $D$，那么无解；

- 此时，**答案一定存在**。我们可以在 $k \times (D-1) + 1$ 种不同的边权情况中进行二分查找。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> modifiedGraphEdges(int n, vector<vector<int>>& edges, int source, int destination, int target) {
        int k = 0;
        for (const auto& e: edges) {
            if (e[2] == -1) {
                ++k;
            }
        }

        if (dijkstra(source, destination, construct(n, edges, 0, target)) > target) {
            return {};
        }
        if (dijkstra(source, destination, construct(n, edges, static_cast<long long>(k) * (target - 1), target)) < target) {
            return {};
        }

        long long left = 0, right = static_cast<long long>(k) * (target - 1), ans = 0;
        while (left <= right) {
            long long mid = (left + right) / 2;
            if (dijkstra(source, destination, construct(n, edges, mid, target)) >= target) {
                ans = mid;
                right = mid - 1;
            }
            else {
                left = mid + 1;
            }
        }

        for (auto& e: edges) {
            if (e[2] == -1) {
                if (ans >= target - 1) {
                    e[2] = target;
                    ans -= (target - 1);
                }
                else {
                    e[2] = 1 + ans;
                    ans = 0;
                }
            }
        }

        return edges;
    }

    long long dijkstra(int source, int destination, const vector<vector<int>>& adj_matrix) {
        // 朴素的 dijkstra 算法
        // adj_matrix 是一个邻接矩阵
        int n = adj_matrix.size();
        vector<long long> dist(n, INT_MAX / 2);
        vector<int> used(n);
        dist[source] = 0;

        for (int round = 0; round < n - 1; ++round) {
            int u = -1;
            for (int i = 0; i < n; ++i) {
                if (!used[i] && (u == -1 || dist[i] < dist[u])) {
                    u = i;
                }
            }
            used[u] = true;
            for (int v = 0; v < n; ++v) {
                if (!used[v] && adj_matrix[u][v] != -1) {
                    dist[v] = min(dist[v], dist[u] + adj_matrix[u][v]);
                }
            }
        }

        return dist[destination];
    }

    vector<vector<int>> construct(int n, const vector<vector<int>>& edges, long long idx, int target) {
        // 需要构造出第 idx 种不同的边权情况，返回一个邻接矩阵
        vector<vector<int>> adj_matrix(n, vector<int>(n, -1));
        for (const auto& e: edges) {
            int u = e[0], v = e[1], w = e[2];
            if (w != -1) {
                adj_matrix[u][v] = adj_matrix[v][u] = w;
            }
            else {
                if (idx >= target - 1) {
                    adj_matrix[u][v] = adj_matrix[v][u] = target;
                    idx -= (target - 1);
                }
                else {
                    adj_matrix[u][v] = adj_matrix[v][u] = 1 + idx;
                    idx = 0;
                }
            }
        }
        return adj_matrix;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[][] modifiedGraphEdges(int n, int[][] edges, int source, int destination, int target) {
        int k = 0;
        for (int[] e : edges) {
            if (e[2] == -1) {
                ++k;
            }
        }

        if (dijkstra(source, destination, construct(n, edges, 0, target)) > target) {
            return new int[0][];
        }
        if (dijkstra(source, destination, construct(n, edges, (long) k * (target - 1), target)) < target) {
            return new int[0][];
        }

        long left = 0, right = (long) k * (target - 1), ans = 0;
        while (left <= right) {
            long mid = (left + right) / 2;
            if (dijkstra(source, destination, construct(n, edges, mid, target)) >= target) {
                ans = mid;
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }

        for (int[] e : edges) {
            if (e[2] == -1) {
                if (ans >= target - 1) {
                    e[2] = target;
                    ans -= target - 1;
                } else {
                    e[2] = (int) (1 + ans);
                    ans = 0;
                }
            }
        }

        return edges;
    }

    public long dijkstra(int source, int destination, int[][] adjMatrix) {
        // 朴素的 dijkstra 算法
        // adjMatrix 是一个邻接矩阵
        int n = adjMatrix.length;
        long[] dist = new long[n];
        Arrays.fill(dist, Integer.MAX_VALUE / 2);
        boolean[] used = new boolean[n];
        dist[source] = 0;

        for (int round = 0; round < n - 1; ++round) {
            int u = -1;
            for (int i = 0; i < n; ++i) {
                if (!used[i] && (u == -1 || dist[i] < dist[u])) {
                    u = i;
                }
            }
            used[u] = true;
            for (int v = 0; v < n; ++v) {
                if (!used[v] && adjMatrix[u][v] != -1) {
                    dist[v] = Math.min(dist[v], dist[u] + adjMatrix[u][v]);
                }
            }
        }

        return dist[destination];
    }

    public int[][] construct(int n, int[][] edges, long idx, int target) {
        // 需要构造出第 idx 种不同的边权情况，返回一个邻接矩阵
        int[][] adjMatrix = new int[n][n];
        for (int i = 0; i < n; ++i) {
            Arrays.fill(adjMatrix[i], -1);
        }
        for (int[] e : edges) {
            int u = e[0], v = e[1], w = e[2];
            if (w != -1) {
                adjMatrix[u][v] = adjMatrix[v][u] = w;
            } else {
                if (idx >= target - 1) {
                    adjMatrix[u][v] = adjMatrix[v][u] = target;
                    idx -= (target - 1);
                } else {
                    adjMatrix[u][v] = adjMatrix[v][u] = (int) (1 + idx);
                    idx = 0;
                }
            }
        }
        return adjMatrix;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[][] ModifiedGraphEdges(int n, int[][] edges, int source, int destination, int target) {
        int k = 0;
        foreach (int[] e in edges) {
            if (e[2] == -1) {
                ++k;
            }
        }

        if (Dijkstra(source, destination, Construct(n, edges, 0, target)) > target) {
            return new int[0][];
        }
        if (Dijkstra(source, destination, Construct(n, edges, (long) k * (target - 1), target)) < target) {
            return new int[0][];
        }

        long left = 0, right = (long) k * (target - 1), ans = 0;
        while (left <= right) {
            long mid = (left + right) / 2;
            if (Dijkstra(source, destination, Construct(n, edges, mid, target)) >= target) {
                ans = mid;
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }

        foreach (int[] e in edges) {
            if (e[2] == -1) {
                if (ans >= target - 1) {
                    e[2] = target;
                    ans -= target - 1;
                } else {
                    e[2] = (int) (1 + ans);
                    ans = 0;
                }
            }
        }

        return edges;
    }

    public long Dijkstra(int source, int destination, int[][] adjMatrix) {
        // 朴素的 dijkstra 算法
        // adjMatrix 是一个邻接矩阵
        int n = adjMatrix.Length;
        long[] dist = new long[n];
        Array.Fill(dist, int.MaxValue / 2);
        bool[] used = new bool[n];
        dist[source] = 0;

        for (int round = 0; round < n - 1; ++round) {
            int u = -1;
            for (int i = 0; i < n; ++i) {
                if (!used[i] && (u == -1 || dist[i] < dist[u])) {
                    u = i;
                }
            }
            used[u] = true;
            for (int v = 0; v < n; ++v) {
                if (!used[v] && adjMatrix[u][v] != -1) {
                    dist[v] = Math.Min(dist[v], dist[u] + adjMatrix[u][v]);
                }
            }
        }

        return dist[destination];
    }

    public int[][] Construct(int n, int[][] edges, long idx, int target) {
        // 需要构造出第 idx 种不同的边权情况，返回一个邻接矩阵
        int[][] adjMatrix = new int[n][];
        for (int i = 0; i < n; ++i) {
            adjMatrix[i] = new int[n];
            Array.Fill(adjMatrix[i], -1);
        }
        foreach (int[] e in edges) {
            int u = e[0], v = e[1], w = e[2];
            if (w != -1) {
                adjMatrix[u][v] = adjMatrix[v][u] = w;
            } else {
                if (idx >= target - 1) {
                    adjMatrix[u][v] = adjMatrix[v][u] = target;
                    idx -= (target - 1);
                } else {
                    adjMatrix[u][v] = adjMatrix[v][u] = (int) (1 + idx);
                    idx = 0;
                }
            }
        }
        return adjMatrix;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def modifiedGraphEdges(self, n: int, edges: List[List[int]], source: int, destination: int, target: int) -> List[List[int]]:
        def dijkstra(adj_matrix: List[List[int]]) -> int:
            # 朴素的 dijkstra 算法
            # adj_matrix 是一个邻接矩阵
            dist = [float("inf")] * n
            used = set()
            dist[source] = 0

            for round in range(n - 1):
                u = -1
                for i in range(n):
                    if i not in used and (u == -1 or dist[i] < dist[u]):
                        u = i
                used.add(u)
                for v in range(n):
                    if v not in used and adj_matrix[u][v] != -1:
                        dist[v] = min(dist[v], dist[u] + adj_matrix[u][v])
            
            return dist[destination]

        def construct(idx: int) -> List[List[int]]:
            # 需要构造出第 idx 种不同的边权情况，返回一个邻接矩阵
            adj_matrix = [[-1] * n for _ in range(n)]
            for u, v, w in edges:
                if w != -1:
                    adj_matrix[u][v] = adj_matrix[v][u] = w
                else:
                    if idx >= target - 1:
                        adj_matrix[u][v] = adj_matrix[v][u] = target
                        idx -= (target - 1)
                    else:
                        adj_matrix[u][v] = adj_matrix[v][u] = 1 + idx
                        idx = 0
            return adj_matrix
        
        k = sum(1 for e in edges if e[2] == -1)
        if dijkstra(construct(0)) > target:
            return []
        if dijkstra(construct(k * (target - 1))) < target:
            return []

        left, right, ans = 0, k * (target - 1), 0
        while left <= right:
            mid = (left + right) // 2
            if dijkstra(construct(mid)) >= target:
                ans = mid
                right = mid - 1
            else:
                left = mid + 1

        for i, e in enumerate(edges):
            if e[2] == -1:
                if ans >= target - 1:
                    edges[i][2] = target
                    ans -= (target - 1)
                else:
                    edges[i][2] = 1 + ans
                    ans = 0

        return edges
```

```Golang [sol1-Golang]
func modifiedGraphEdges(n int, edges [][]int, source int, destination int, target int) [][]int {
    k := 0
    for _, e := range edges {
        if e[2] == -1 {
            k++
        }
    }
    if dijkstra(source, destination, construct(n, edges, 0, target)) > int64(target) {
        return nil
    }
    if dijkstra(source, destination, construct(n, edges, int64(k) * int64(target - 1), target)) < int64(target) {
        return nil
    }

    left, right, ans := int64(0), int64(k) * int64(target - 1), int64(0)
    for left <= right {
        mid := int64(left + right) / 2
        if dijkstra(source, destination, construct(n, edges, mid, target)) >= int64(target) {
            ans, right = mid, mid - 1
        } else {
            left = mid + 1
        }
    }
    for _, e := range edges {
        if e[2] == -1 {
            if ans >= int64(target - 1) {
                e[2] = target
                ans -= int64(target - 1)
            } else {
                e[2] = int(1 + ans)
                ans = 0
            }
        }
    }
    return edges
}

func dijkstra(source, destination int, adjMatrix [][]int) int64 {
    // 朴素的 dijistra 算法
    // adjMatrix 是一个邻接矩阵
    n := len(adjMatrix)
    dist, used := make([]int64, n), make([]bool, n)
    for i := 0; i < n; i++ {
        dist[i] = 0x3f3f3f3f3f
    }
    dist[source] = 0
    for round := 0; round < n - 1; round++ {
        u := -1
        for i := 0; i < n; i++ {
            if !used[i] && (u == -1 || dist[i] < dist[u]) {
                u = i
            }
        }
        used[u] = true
        for v := 0; v < n; v++ {
            if !used[v] && adjMatrix[u][v] != -1 && dist[v] > dist[u] + int64(adjMatrix[u][v]) {
                dist[v] = dist[u] + int64(adjMatrix[u][v])
            }
        }
    }
    return dist[destination]
}

func construct(n int, edges [][]int, idx int64, target int) [][]int {
    // 需要构造出第 idx 种不同的边权情况，返回一个邻接矩阵
    adjMatrix := make([][]int, n)
    for i := 0; i < n; i++ {
        adjMatrix[i] = make([]int, n)
        for j := 0; j < n; j++ {
            adjMatrix[i][j] = -1
        }
    }
    for _, e := range edges {
        u, v, w := e[0], e[1], e[2]
        if w != -1 {
            adjMatrix[u][v], adjMatrix[v][u] = w, w
        } else {
            if idx >= int64(target - 1) {
                adjMatrix[u][v], adjMatrix[v][u] = target, target
                idx -= int64(target - 1)
            } else {
                adjMatrix[u][v], adjMatrix[v][u] = int(1 + idx), int(1 + idx)
                idx = 0
            }
        }
    }
    return adjMatrix
}
```

```C [sol1-C]
long long dijkstra(int source, int destination, int **adj_matrix, int n) {
    // 朴素的 dijkstra 算法
    // adj_matrix 是一个邻接矩阵
    long long dist[n];
    int used[n];
    memset(used, 0, sizeof(used));
    for (int i = 0; i < n; i++) {
        dist[i] = INT_MAX / 2;
    }
    dist[source] = 0;

    for (int round = 0; round < n - 1; ++round) {
        int u = -1;
        for (int i = 0; i < n; ++i) {
            if (!used[i] && (u == -1 || dist[i] < dist[u])) {
                u = i;
            }
        }
        used[u] = true;
        for (int v = 0; v < n; ++v) {
            if (!used[v] && adj_matrix[u][v] != -1) {
                dist[v] = fmin(dist[v], dist[u] + adj_matrix[u][v]);
            }
        }
    }

    return dist[destination];
}

int** construct(int** edges, int edgesSize, long long idx, int target, int **adj_matrix) {
    // 需要构造出第 idx 种不同的边权情况，返回一个邻接矩阵
    for (int i = 0; i < edgesSize; i++) {
        int u = edges[i][0], v = edges[i][1], w = edges[i][2];
        if (w != -1) {
            adj_matrix[u][v] = adj_matrix[v][u] = w;
        } else {
            if (idx >= target - 1) {
                adj_matrix[u][v] = adj_matrix[v][u] = target;
                idx -= (target - 1);
            } else {
                adj_matrix[u][v] = adj_matrix[v][u] = 1 + idx;
                idx = 0;
            }
        }
    }
    return adj_matrix;
}

int** modifiedGraphEdges(int n, int** edges, int edgesSize, int* edgesColSize, int source, int destination, int target, int* returnSize, int** returnColumnSizes) {
    int k = 0;
    for (int i = 0; i < edgesSize; i++) {
        if (edges[i][2] == -1) {
            ++k;
        }
    }

    int **adj_matrix = (int **)malloc(sizeof(int *) * n);
    for (int i = 0; i < n; i++) {
        adj_matrix[i] = (int *)malloc(sizeof(int) * n);
        memset(adj_matrix[i], 0xff, sizeof(int) * n);
    }
    if (dijkstra(source, destination, construct(edges, edgesSize, 0, target, adj_matrix), n) > target) {
        for (int i = 0; i < n; i++) {
            free(adj_matrix[i]);
        }
        free(adj_matrix);
        *returnSize = 0;
        return NULL;
    }
    if (dijkstra(source, destination, construct(edges, edgesSize, (long long) k * (target - 1), target, adj_matrix), n) < target) {
        for (int i = 0; i < n; i++) {
            free(adj_matrix[i]);
        }
        free(adj_matrix);
        *returnSize = 0;
        return NULL;
    }

    long long left = 0, right = (long long) k * (target - 1), ans = 0;
    while (left <= right) {
        long long mid = (left + right) / 2;
        if (dijkstra(source, destination, construct(edges, edgesSize, mid, target, adj_matrix), n) >= target) {
            ans = mid;
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }

    for (int i = 0; i < edgesSize; i++) {
        if (edges[i][2] == -1) {
            if (ans >= target - 1) {
                edges[i][2] = target;
                ans -= (target - 1);
            } else {
                edges[i][2] = 1 + ans;
                ans = 0;
            }
        }
    }
    *returnSize = edgesSize;
    *returnColumnSizes = edgesColSize;
    for (int i = 0; i < n; i++) {
        free(adj_matrix[i]);
    }
    free(adj_matrix);
    return edges;
}
```

```JavaScript [sol1-JavaScript]
var modifiedGraphEdges = function(n, edges, source, destination, target) {
    let k = 0;
    for (const e of edges) {
        if (e[2] === -1) {
            ++k;
        }
    }

    if (dijkstra(source, destination, construct(n, edges, 0, target)) > target) {
        return [];
    }
    if (dijkstra(source, destination, construct(n, edges, k * (target - 1), target)) < target) {
        return [];
    }

    let left = 0, right = k * (target - 1), ans = 0;
    while (left <= right) {
        const mid = Math.floor((left + right) / 2);
        if (dijkstra(source, destination, construct(n, edges, mid, target)) >= target) {
            ans = mid;
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }

    for (const e of edges) {
        if (e[2] === -1) {
            if (ans >= target - 1) {
                e[2] = target;
                ans -= target - 1;
            } else {
                e[2] = 1 + ans;
                ans = 0;
            }
        }
    }

    return edges;
}

const dijkstra = (source, destination, adjMatrix) => {
    // 朴素的 dijkstra 算法
    // adjMatrix 是一个邻接矩阵
    const n = adjMatrix.length;
    const dist = new Array(n).fill(Number.MAX_VALUE);
    const used = new Array(n).fill(false);
    dist[source] = 0;

    for (let round = 0; round < n - 1; ++round) {
        let u = -1;
        for (let i = 0; i < n; ++i) {
            if (!used[i] && (u === -1 || dist[i] < dist[u])) {
                u = i;
            }
        }
        used[u] = true;
        for (let v = 0; v < n; ++v) {
            if (!used[v] && adjMatrix[u][v] != -1) {
                dist[v] = Math.min(dist[v], dist[u] + adjMatrix[u][v]);
            }
        }
    }

    return dist[destination];
}

const construct = (n, edges, idx, target) => {
    // 需要构造出第 idx 种不同的边权情况，返回一个邻接矩阵
    const adjMatrix = new Array(n).fill(0).map(() => new Array(n).fill(-1));
    for (const e of edges) {
        let u = e[0], v = e[1], w = e[2];
        if (w !== -1) {
            adjMatrix[u][v] = adjMatrix[v][u] = w;
        } else {
            if (idx >= target - 1) {
                adjMatrix[u][v] = adjMatrix[v][u] = target;
                idx -= (target - 1);
            } else {
                adjMatrix[u][v] = adjMatrix[v][u] = (1 + idx);
                idx = 0;
            }
        }
    }
    return adjMatrix;
};
```

**复杂度分析**

- 时间复杂度：$O((n^2 + m)(\log m + \log \textit{target}))$，其中 $m$ 是图中边的数量。二分查找需要进行 $O(\log(k \times (\textit{target} - 1)))$ 次，在最坏情况下，所有的边都是可以修改的边，即 $O(\log m + \log \textit{target})$。每一次二分查找中需要 $O(n^2+m)$ 的时间构造邻接矩阵，以及 $O(n^2)$ 的时间使用朴素的 Dijkstra 算法计算最短路。

- 空间复杂度：$O(n^2)$，即为朴素的 Dijkstra 算法中邻接矩阵需要的空间。返回的答案可以直接在给定的数组 $\textit{edges}$ 上进行修改得到，省去 $O(m)$ 的空间。

#### 方法二：动态修改边权的 Dijkstra 算法

**思路与算法**

在方法一中，我们每次给一条可以修改的边长度增加 $1$。虽然使用了二分查找进行加速，但这样做效率仍然较低。如何进一步进行优化呢？我们可以产生一个简单的想法：

> 现在固定所有可以修改的边的长度为 $1$，再选择其中一条可以修改的边 $u-v$。$s-u$ 的最短路长度为 $d_{\min}(s, u)$，$v-t$ 的最短路长度为 $d_{\min}(v, t)$，那么将 $u-v$ 的长度修改为 $D - d_{\min}(s, u) - d_{\min}(v, t)$，这样 $s-u-v-t$ 就是一条长度恰好为 $D$ 的路径。

然而 $s-u-v-t$ 不一定是**最短**的路径，但我们可以不断重复这个步骤，直到最短路径的长度为 $D$ 为止。具体的步骤如下：

> 每次选择一条可以修改的边 $u-v$，并且这条边之前没有选择过。修改这条边的长度，使得 $s-u-v-t$ 这一条路径的长度恰好为 $D$，其中 $s-u$ 以及 $v-t$ 的路径是在「没有选择过的边的长度均为 $1$，选择过的边的长度均为修改后的长度」情况下的最短路径。

可以证明，如果存在满足题目要求的方案，那么上面的做法也一定能得到一种方案：

- 首先，每条边最多会被选择一次。因为在修改的过程中，$s-u$ 和 $v-t$ 的最短路径长度都是单调不降的（有其它长度为 $1$ 的边被修改成了长度大于 $1$），因此如果第二次选择 $u-v$ 这条边，会使得这条边的长度减少，这是没有任何意义的；

- 其次，如果当所有可以被选择的边都被选择过一次后，$s-t$ 的最短路径长度不为 $D$，那么：

    - 要么初始时（即所有可以修改的边的长度为 $1$ 时）最短路径的长度已经大于 $D$，此时不存在满足题目要求的方案；

    - 要么存在一条 $s-t$ 的长度小于 $D$ 的路径，这条路径上不可能有可以修改的边（否则可以修改对应的边使得长度等于 $D$），这就说明这条路径与所有可以修改的边无关，图中的最短路径本来就小于 $D$，此时也不存在满足题目要求的方案。

    因此，「$s-t$ 的最短路径长度不为 $D$」只会出现在不存在满足题目要求的方案时。这就说明在重复上述的步骤之后，$s-t$ 的最短路径长度一定为 $D$。

这样一来，我们就可以得到如下的算法：

- 我们每次选择一条可以修改的边 $u-v$，并且这条边之前没有选择过；

- 我们使用 Dijkstra 算法，求出 $s-u$ 以及 $u-v$ 的最短路 $d_{\min}(s, u)$ 和 $d_{\min}(v, t)$。如果 $d_{\min}(s, u) + d_{\min}(v, t) < D$，那么将 $u-v$ 的长度修改为 $D - d_{\min}(s, u) - d_{\min}(v, t)$。

- 当所有可以修改的边都被选择过后，如果 $s-t$ 的最短路长度为 $D$，说明存在一种满足要求的方案。

由于可以修改的边的数量最多为 $O(m)$，因此上述算法的时间复杂度为 $O(mn^2)$，需要继续进行优化。可以发现，该算法的瓶颈在于，当我们修改了 $u-v$ 的长度后，后续选择的边的两部分最短路的值 $d_{\min}(s, u)$ 和 $d_{\min}(v, t)$ 会发生变化，需要重新进行计算。

因此，我们可以考虑在进行 Dijkstra 算法的同时对边进行修改。在 Dijkstra 算法中，当我们遍历到节点 $u$ 时，再去修改所有以 $u$ 为端点的（且没有修改过的）边，此时就可以保证 $d_{\min}(s, u)$ 的值都是最新的。同时，当我们枚举 $u$ 的相邻节点 $v$ 时，$v$ 到 $t$ 的最短路长度 $d_{\min}(v, t)$ 要么与第一次 Dijkstra 算法中计算出的值相同，要么会变成一个非常大的值，使得 $d_{\min}(s, u) + d_{\min}(v, t)$ 已经至少为 $D$（证明见下一段）。这样就只需要一次 Dijkstra 算法即可，时间复杂度降低为 $O(n^2)$。

> 关于 $d_{\min}(v, t)$ 正确性的证明：如果此时的 $d_{\min}(v, t)$ 与第一次 Dijkstra 算法中计算出的值不同，那么说明 $v$ 到 $t$ 的任意一条原来的（即所有可以修改的边的长度均为 $1$）最短路中，都有一条边的长度修改为了大于 $1$ 的值。对于任意一条最短路：
> - 如果修改的边的某个端点为 $v$，记这条边为 $u'-v$，由于 $v$ 还没有遍历过，说明 $u'$ 已经遍历过，但 $u'$ 在 $v$ 到 $t$ 的最短路上，而最短路上不可能先经过离 $t$ 较近的点 $u'$，再经过离 $t$ 较远的点 $v$，这说明最终的最短路不可能从 $s$ 到 $u'$ 到 $v$ 再到 $t$，而是会跳过 $v$，因此这种情况并不会出现；
>
> - 否则，记最短路上的 $u'-v'$ 这条边被修改过，并且遍历过的节点是 $u'$。根据 Dijkstra 算法的性质，我们有 $d_{\min}(s, u') \leq d_{\min}(s, u)$；根据最短路的性质，我们有 $d_{\min}(v', t) < d_{\min}(v, t)$，那么 $u'-v'$ 这条边被修改成的值就为 $V = D - d_{\min}(s, u') - d_{\min}(v', t) > D - d_{\min}(s, u) - d_{\min}(v, t)$，$v$ 到 $t$ 的路径长度增加了至少 $V - 1 \geq D - d_{\min}(s, u) - d_{\min}(v, t)$，即路径长度至少为 $d'_{\min}(v, t) = d_{\min}(v, t) + V - 1 \geq D - d_{\min}(s, u)$。此时，$d_{\min}(s, u) + d'_{\min}(v, t) \geq D$。
>
> 因此，如果 $d_{\min}(v, t)$ 与第一次 Dijkstra 算法中计算出的值不同，$u-v$ 这条边本身就没有任何意义了。

最终的算法如下：

- 首先以 $t$ 为起始点进行一次 Dijkstra 算法，此时所有可以修改的边长度均为 $1$；

- 随后以 $s$ 为起始点进行一次 Dijkstra 算法。当遍历到节点 $u$ 时，修改所有以 $u$ 为端点的边 $u-v$：
    - 如果不是可以修改的边，或已经修改过，则不进行任何操作；

    - 如果 $s-u$ 的最短路长度（当前 Dijkstra 算法求出）加上 $v-t$ 的最短路长度（第一次 Dijkstra 算法求出）已经大于 $D$，则 $u-v$ 是一条没有用处的边，将它修改为任意值，例如 $D$；

    - 否则，将边的长度进行修改，值等于 $D$ 减去 $s-u$ 的最短路长度与 $v-t$ 的最短路长度之和，构造出一条长度为 $D$ 的路径。

    再通过这些边更新到 $v$ 的最短路长度；

- 两次 Dijkstra 算法完成后，如果 $s-t$ 的最短路长度为 $D$，则返回修改后的边，否则无解。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    vector<vector<int>> modifiedGraphEdges(int n, vector<vector<int>>& edges, int source, int destination, int target) {
        this->target = target;
        vector<vector<int>> adj_matrix(n, vector<int>(n, -1));
        // 邻接矩阵中存储边的下标
        for (int i = 0; i < edges.size(); ++i) {
            int u = edges[i][0], v = edges[i][1];
            adj_matrix[u][v] = adj_matrix[v][u] = i;
        }
        from_destination = dijkstra(0, destination, edges, adj_matrix);
        if (from_destination[source] > target) {
            return {};
        }
        vector<long long> from_source = dijkstra(1, source, edges, adj_matrix);
        if (from_source[destination] != target) {
            return {};
        }
        return edges;
    }

    vector<long long> dijkstra(int op, int source, vector<vector<int>>& edges, const vector<vector<int>>& adj_matrix) {
        // 朴素的 dijkstra 算法
        // adj_matrix 是一个邻接矩阵
        int n = adj_matrix.size();
        vector<long long> dist(n, INT_MAX / 2);
        vector<int> used(n);
        dist[source] = 0;

        for (int round = 0; round < n - 1; ++round) {
            int u = -1;
            for (int i = 0; i < n; ++i) {
                if (!used[i] && (u == -1 || dist[i] < dist[u])) {
                    u = i;
                }
            }
            used[u] = true;
            for (int v = 0; v < n; ++v) {
                if (!used[v] && adj_matrix[u][v] != -1) {
                    if (edges[adj_matrix[u][v]][2] != -1) {
                        dist[v] = min(dist[v], dist[u] + edges[adj_matrix[u][v]][2]);
                    }
                    else {
                        if (op == 0) {
                            dist[v] = min(dist[v], dist[u] + 1);
                        }
                        else {
                            int modify = target - dist[u] - from_destination[v];
                            if (modify > 0) {
                                dist[v] = min(dist[v], dist[u] + modify);
                                edges[adj_matrix[u][v]][2] = modify;
                            }
                            else {
                                edges[adj_matrix[u][v]][2] = target;
                            }
                        }
                    }
                    
                }
            }
        }

        return dist;
    }

private:
    vector<long long> from_destination;
    int target;
};
```

```Java [sol2-Java]
class Solution {
    long[] fromDestination;
    int target;

    public int[][] modifiedGraphEdges(int n, int[][] edges, int source, int destination, int target) {
        this.target = target;
        int[][] adjMatrix = new int[n][n];
        for (int i = 0; i < n; ++i) {
            Arrays.fill(adjMatrix[i], -1);
        }
        // 邻接矩阵中存储边的下标
        for (int i = 0; i < edges.length; ++i) {
            int u = edges[i][0], v = edges[i][1];
            adjMatrix[u][v] = adjMatrix[v][u] = i;
        }
        fromDestination = dijkstra(0, destination, edges, adjMatrix);
        if (fromDestination[source] > target) {
            return new int[0][];
        }
        long[] fromSource = dijkstra(1, source, edges, adjMatrix);
        if (fromSource[destination] != target) {
            return new int[0][];
        }
        return edges;
    }

    public long[] dijkstra(int op, int source, int[][] edges, int[][] adjMatrix) {
        // 朴素的 dijkstra 算法
        // adjMatrix 是一个邻接矩阵
        int n = adjMatrix.length;
        long[] dist = new long[n];
        Arrays.fill(dist, Integer.MAX_VALUE / 2);
        boolean[] used = new boolean[n];
        dist[source] = 0;

        for (int round = 0; round < n - 1; ++round) {
            int u = -1;
            for (int i = 0; i < n; ++i) {
                if (!used[i] && (u == -1 || dist[i] < dist[u])) {
                    u = i;
                }
            }
            used[u] = true;
            for (int v = 0; v < n; ++v) {
                if (!used[v] && adjMatrix[u][v] != -1) {
                    if (edges[adjMatrix[u][v]][2] != -1) {
                        dist[v] = Math.min(dist[v], dist[u] + edges[adjMatrix[u][v]][2]);
                    } else {
                        if (op == 0) {
                            dist[v] = Math.min(dist[v], dist[u] + 1);
                        } else {
                            int modify = (int) (target - dist[u] - fromDestination[v]);
                            if (modify > 0) {
                                dist[v] = Math.min(dist[v], dist[u] + modify);
                                edges[adjMatrix[u][v]][2] = modify;
                            } else {
                                edges[adjMatrix[u][v]][2] = target;
                            }
                        }
                    }
                }
            }
        }

        return dist;
    }
}
```

```C# [sol2-C#]
public class Solution {
    long[] fromDestination;
    int target;

    public int[][] ModifiedGraphEdges(int n, int[][] edges, int source, int destination, int target) {
        this.target = target;
        int[][] adjMatrix = new int[n][];
        for (int i = 0; i < n; ++i) {
            adjMatrix[i] = new int[n];
            Array.Fill(adjMatrix[i], -1);
        }
        // 邻接矩阵中存储边的下标
        for (int i = 0; i < edges.Length; ++i) {
            int u = edges[i][0], v = edges[i][1];
            adjMatrix[u][v] = adjMatrix[v][u] = i;
        }
        fromDestination = Dijkstra(0, destination, edges, adjMatrix);
        if (fromDestination[source] > target) {
            return new int[0][];
        }
        long[] fromSource = Dijkstra(1, source, edges, adjMatrix);
        if (fromSource[destination] != target) {
            return new int[0][];
        }
        return edges;
    }

    public long[] Dijkstra(int op, int source, int[][] edges, int[][] adjMatrix) {
        // 朴素的 dijkstra 算法
        // adjMatrix 是一个邻接矩阵
        int n = adjMatrix.Length;
        long[] dist = new long[n];
        Array.Fill(dist, int.MaxValue / 2);
        bool[] used = new bool[n];
        dist[source] = 0;

        for (int round = 0; round < n - 1; ++round) {
            int u = -1;
            for (int i = 0; i < n; ++i) {
                if (!used[i] && (u == -1 || dist[i] < dist[u])) {
                    u = i;
                }
            }
            used[u] = true;
            for (int v = 0; v < n; ++v) {
                if (!used[v] && adjMatrix[u][v] != -1) {
                    if (edges[adjMatrix[u][v]][2] != -1) {
                        dist[v] = Math.Min(dist[v], dist[u] + edges[adjMatrix[u][v]][2]);
                    } else {
                        if (op == 0) {
                            dist[v] = Math.Min(dist[v], dist[u] + 1);
                        } else {
                            int modify = (int) (target - dist[u] - fromDestination[v]);
                            if (modify > 0) {
                                dist[v] = Math.Min(dist[v], dist[u] + modify);
                                edges[adjMatrix[u][v]][2] = modify;
                            } else {
                                edges[adjMatrix[u][v]][2] = target;
                            }
                        }
                    }
                }
            }
        }

        return dist;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def modifiedGraphEdges(self, n: int, edges: List[List[int]], source: int, destination: int, target: int) -> List[List[int]]:
        def dijkstra(op: int, source: int, adj_matrix: List[List[int]]) -> List[int]:
            # 朴素的 dijkstra 算法
            # adj_matrix 是一个邻接矩阵
            dist = [float("inf")] * n
            used = set()
            dist[source] = 0

            for round in range(n - 1):
                u = -1
                for i in range(n):
                    if i not in used and (u == -1 or dist[i] < dist[u]):
                        u = i
                used.add(u)
                for v in range(n):
                    if v not in used and adj_matrix[u][v] != -1:
                        if edges[adj_matrix[u][v]][2] != -1:
                            dist[v] = min(dist[v], dist[u] + edges[adj_matrix[u][v]][2])
                        else:
                            if op == 0:
                                dist[v] = min(dist[v], dist[u] + 1)
                            else:
                                modify = target - dist[u] - from_destination[v]
                                if modify > 0:
                                    dist[v] = min(dist[v], dist[u] + modify)
                                    edges[adj_matrix[u][v]][2] = modify
                                else:
                                    edges[adj_matrix[u][v]][2] = target
            return dist

        adj_matrix = [[-1] * n for _ in range(n)]
        # 邻接矩阵中存储边的下标
        for i, (u, v, w) in enumerate(edges):
            adj_matrix[u][v] = adj_matrix[v][u] = i
        
        from_destination = dijkstra(0, destination, adj_matrix)
        if from_destination[source] > target:
            return []
        from_source = dijkstra(1, source, adj_matrix)
        if from_source[destination] != target:
            return []
        return edges
```

```Golang [sol2-Golang]
func modifiedGraphEdges(n int, edges [][]int, source int, destination int, target int) [][]int {
    adjMatrix := make([][]int, n)
    for i := 0; i < n; i++ {
        adjMatrix[i] = make([]int, n)
        for j := 0; j < n; j++ {
            adjMatrix[i][j] = -1
        }
    }
    // 邻接矩阵中存储边的下标
    for i, e := range edges {
        u, v := e[0], e[1]
        adjMatrix[u][v], adjMatrix[v][u] = i, i
    }
    fromDestination := dijkstra(0, destination, edges, adjMatrix, target, nil)
    if fromDestination[source] > int64(target) {
        return nil
    }
    fromSource := dijkstra(1, source, edges, adjMatrix, target, fromDestination)
    if fromSource[destination] != int64(target) {
        return nil
    }
    return edges
}

func dijkstra(op, source int, edges [][]int, adjMatrix [][]int, target int, fromDestination []int64) []int64 {
    // 朴素的 dijistra 算法
    // adjMatrix 是一个邻接矩阵
    n := len(adjMatrix)
    dist, used := make([]int64, n), make([]bool, n)
    for i := 0; i < n; i++ {
        dist[i] = 0x3f3f3f3f3f
    }
    dist[source] = 0
    for round := 0; round < n - 1; round++ {
        u := -1
        for i := 0; i < n; i++ {
            if !used[i] && (u == -1 || dist[i] < dist[u]) {
                u = i
            }
        }
        used[u] = true
        for v := 0; v < n; v++ {
            if !used[v] && adjMatrix[u][v] != -1 {
                i := adjMatrix[u][v]
                if edges[i][2] != -1 {
                    dist[v] = min(dist[v], dist[u] + int64(edges[i][2]))
                } else {
                    if op == 0 {
                        dist[v] = min(dist[v], dist[u] + 1)
                    } else {
                        modify := int64(target) - dist[u] - fromDestination[v]
                        if modify > 0 {
                            dist[v] = min(dist[v], dist[u] + modify)
                            edges[i][2] = int(modify)
                        } else {
                            edges[i][2] = target
                        }
                    }
                }
            }
        }
    }
    return dist
}

func min(a, b int64) int64 {
    if a > b {
        return b
    }
    return a
}
```

```JavaScript [sol2-JavaScript]
var modifiedGraphEdges = function(n, edges, source, destination, target) {
    this.target = target;
    const adjMatrix = new Array(n).fill(0).map(() => new Array(n).fill(-1));
    // 邻接矩阵中存储边的下标
    for (let i = 0; i < edges.length; ++i) {
        let u = edges[i][0], v = edges[i][1];
        adjMatrix[u][v] = adjMatrix[v][u] = i;
    }
    fromDestination = dijkstra(0, destination, edges, adjMatrix);
    if (fromDestination[source] > target) {
        return [];
    }
    const fromSource = dijkstra(1, source, edges, adjMatrix);
    if (fromSource[destination] !== target) {
        return [];
    }
    return edges;
}

const dijkstra = (op, source, edges, adjMatrix) => {
    // 朴素的 dijkstra 算法
    // adjMatrix 是一个邻接矩阵
    const n = adjMatrix.length;
    const dist = new Array(n).fill(Number.MAX_SAFE_INTEGER);
    const used = new Array(n).fill(false);
    dist[source] = 0;

    for (let round = 0; round < n - 1; ++round) {
        let u = -1;
        for (let i = 0; i < n; ++i) {
            if (!used[i] && (u === -1 || dist[i] < dist[u])) {
                u = i;
            }
        }
        used[u] = true;
        for (let v = 0; v < n; ++v) {
            if (!used[v] && adjMatrix[u][v] !== -1) {
                if (edges[adjMatrix[u][v]][2] !== -1) {
                    dist[v] = Math.min(dist[v], dist[u] + edges[adjMatrix[u][v]][2]);
                } else {
                    if (op == 0) {
                        dist[v] = Math.min(dist[v], dist[u] + 1);
                    } else {
                        const modify = (target - dist[u] - fromDestination[v]);
                        if (modify > 0) {
                            dist[v] = Math.min(dist[v], dist[u] + modify);
                            edges[adjMatrix[u][v]][2] = modify;
                        } else {
                            edges[adjMatrix[u][v]][2] = target;
                        }
                    }
                }
            }
        }
    }

    return dist;
};
```

```C [sol2-C]
long long* dijkstra(int op, int source, int target, int **edges, int edgesSize, int** adj_matrix, int n, long long *from_destination) {
    // 朴素的 dijkstra 算法
    // adj_matrix 是一个邻接矩阵
    int used[n];
    long long *dist = (long long *)malloc(sizeof(long long) * n);
    memset(used, 0, sizeof(used));
    for (int i = 0; i < n; i++) {
        dist[i] = INT_MAX / 2;
    }
    dist[source] = 0;

    for (int round = 0; round < n - 1; ++round) {
        int u = -1;
        for (int i = 0; i < n; ++i) {
            if (!used[i] && (u == -1 || dist[i] < dist[u])) {
                u = i;
            }
        }
        used[u] = true;
        for (int v = 0; v < n; ++v) {
            if (!used[v] && adj_matrix[u][v] != -1) {
                if (edges[adj_matrix[u][v]][2] != -1) {
                    dist[v] = fmin(dist[v], dist[u] + edges[adj_matrix[u][v]][2]);
                } else {
                    if (op == 0) {
                        dist[v] = fmin(dist[v], dist[u] + 1);
                    } else {
                        int modify = target - dist[u] - from_destination[v];
                        if (modify > 0) {
                            dist[v] = fmin(dist[v], dist[u] + modify);
                            edges[adj_matrix[u][v]][2] = modify;
                        } else {
                            edges[adj_matrix[u][v]][2] = target;
                        }
                    }
                }
                
            }
        }
    }
    return dist;
}

int** modifiedGraphEdges(int n, int** edges, int edgesSize, int* edgesColSize, int source, int destination, int target, int* returnSize, int** returnColumnSizes) {
    int **adj_matrix = (int **)malloc(sizeof(int *) * n);
    for (int i = 0; i < n; i++) {
        adj_matrix[i] = (int *)malloc(sizeof(int) * n);
        memset(adj_matrix[i], 0xff, sizeof(int) * n);
    }
    // 邻接矩阵中存储边的下标
    for (int i = 0; i < edgesSize; ++i) {
        int u = edges[i][0], v = edges[i][1];
        adj_matrix[u][v] = adj_matrix[v][u] = i;
    }

    long long from_destination[n];
    memset(from_destination, 0, sizeof(from_destination));
    long long *ret = dijkstra(0, destination, target, edges, edgesSize, adj_matrix, n, from_destination);
    memcpy(from_destination, ret, sizeof(long long) * n);
    free(ret);
    if (from_destination[source] > target) {
        for (int i = 0; i < n; i++) {
            free(adj_matrix[i]);
        }
        free(adj_matrix);
        *returnSize = 0;
        return NULL;
    }
    long long *from_source = dijkstra(1, source, target, edges, edgesSize, adj_matrix, n, from_destination);
    if (from_source[destination] != target) {
        for (int i = 0; i < n; i++) {
            free(adj_matrix[i]);
        }
        free(adj_matrix);
        free(from_source);
        *returnSize = 0;
        return NULL;
    }
    for (int i = 0; i < n; i++) {
        free(adj_matrix[i]);
    }
    free(adj_matrix);
    free(from_source);
    *returnSize = edgesSize;
    *returnColumnSizes = edgesColSize;
    return edges;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2 + m)$，其中 $m$ 是图中边的数量。我们需要 $O(n^2+m)$ 的时间构造邻接矩阵，以及两次 $O(n^2)$ 的时间使用朴素的 Dijkstra 算法计算最短路。

- 空间复杂度：$O(n^2)$，即为朴素的 Dijkstra 算法中邻接矩阵需要的空间。返回的答案可以直接在给定的数组 $\textit{edges}$ 上进行修改得到，省去 $O(m)$ 的空间。
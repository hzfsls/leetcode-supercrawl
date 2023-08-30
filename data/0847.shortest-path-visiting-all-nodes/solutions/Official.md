#### 方法一：状态压缩 + 广度优先搜索

**思路与算法**

由于题目需要我们求出「访问所有节点的**最短路径**的长度」，并且图中每一条边的长度均为 $1$，因此我们可以考虑使用广度优先搜索的方法求出最短路径。

在常规的广度优先搜索中，我们会在队列中存储节点的编号。对于本题而言，最短路径的前提是「访问了所有节点」，因此除了记录节点的编号以外，我们还需要记录每一个节点的经过情况。因此，我们使用三元组 $(u, \textit{mask}, \textit{dist})$ 表示队列中的每一个元素，其中：

- $u$ 表示当前位于的节点编号；

- $\textit{mask}$ 是一个长度为 $n$ 的二进制数，表示每一个节点是否经过。如果 $\textit{mask}$ 的第 $i$ 位是 $1$，则表示节点 $i$ 已经过，否则表示节点 $i$ 未经过；

- $\textit{dist}$ 表示到当前节点为止经过的路径长度。

这样一来，我们使用该三元组进行广度优先搜索，即可解决本题。初始时，我们将所有的 $(i, 2^i, 0)$ 放入队列，表示可以从任一节点开始。在搜索的过程中，如果当前三元组中的 $\textit{mask}$ 包含 $n$ 个 $1$（即 $\textit{mask} = 2^n - 1$），那么我们就可以返回 $\textit{dist}$ 作为答案。

**细节**

为了保证广度优先搜索时间复杂度的正确性，即同一个节点 $u$ 以及节点的经过情况 $\textit{mask}$ 只被搜索到一次，我们可以使用数组或者哈希表记录 $(u, \textit{mask})$ 是否已经被搜索过，防止无效的重复搜索。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int shortestPathLength(vector<vector<int>>& graph) {
        int n = graph.size();
        queue<tuple<int, int, int>> q;
        vector<vector<int>> seen(n, vector<int>(1 << n));
        for (int i = 0; i < n; ++i) {
            q.emplace(i, 1 << i, 0);
            seen[i][1 << i] = true;
        }

        int ans = 0;
        while (!q.empty()) {
            auto [u, mask, dist] = q.front();
            q.pop();
            if (mask == (1 << n) - 1) {
                ans = dist;
                break;
            }
            // 搜索相邻的节点
            for (int v: graph[u]) {
                // 将 mask 的第 v 位置为 1
                int mask_v = mask | (1 << v);
                if (!seen[v][mask_v]) {
                    q.emplace(v, mask_v, dist + 1);
                    seen[v][mask_v] = true;
                }
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int shortestPathLength(int[][] graph) {
        int n = graph.length;
        Queue<int[]> queue = new LinkedList<int[]>();
        boolean[][] seen = new boolean[n][1 << n];
        for (int i = 0; i < n; ++i) {
            queue.offer(new int[]{i, 1 << i, 0});
            seen[i][1 << i] = true;
        }

        int ans = 0;
        while (!queue.isEmpty()) {
            int[] tuple = queue.poll();
            int u = tuple[0], mask = tuple[1], dist = tuple[2];
            if (mask == (1 << n) - 1) {
                ans = dist;
                break;
            }
            // 搜索相邻的节点
            for (int v : graph[u]) {
                // 将 mask 的第 v 位置为 1
                int maskV = mask | (1 << v);
                if (!seen[v][maskV]) {
                    queue.offer(new int[]{v, maskV, dist + 1});
                    seen[v][maskV] = true;
                }
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int ShortestPathLength(int[][] graph) {
        int n = graph.Length;
        Queue<Tuple<int, int, int>> queue = new Queue<Tuple<int, int, int>>();
        bool[,] seen = new bool[n, 1 << n];
        for (int i = 0; i < n; ++i) {
            queue.Enqueue(new Tuple<int, int, int>(i, 1 << i, 0));
            seen[i, 1 << i] = true;
        }

        int ans = 0;
        while (queue.Count > 0) {
            Tuple<int, int, int> tuple = queue.Dequeue();
            int u = tuple.Item1, mask = tuple.Item2, dist = tuple.Item3;
            if (mask == (1 << n) - 1) {
                ans = dist;
                break;
            }
            // 搜索相邻的节点
            foreach (int v in graph[u]) {
                // 将 mask 的第 v 位置为 1
                int maskV = mask | (1 << v);
                if (!seen[v, maskV]) {
                    queue.Enqueue(new Tuple<int, int, int>(v, maskV, dist + 1));
                    seen[v, maskV] = true;
                }
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def shortestPathLength(self, graph: List[List[int]]) -> int:
        n = len(graph)
        q = deque((i, 1 << i, 0) for i in range(n))
        seen = {(i, 1 << i) for i in range(n)}
        ans = 0
        
        while q:
            u, mask, dist = q.popleft()
            if mask == (1 << n) - 1:
                ans = dist
                break
            # 搜索相邻的节点
            for v in graph[u]:
                # 将 mask 的第 v 位置为 1
                mask_v = mask | (1 << v)
                if (v, mask_v) not in seen:
                    q.append((v, mask_v, dist + 1))
                    seen.add((v, mask_v))
        
        return ans
```

```JavaScript [sol1-JavaScript]
var shortestPathLength = function(graph) {
    const n = graph.length;
    const queue = [];
    const seen = new Array(n).fill(0).map(() => new Array(1 << n).fill(false));
    for (let i = 0; i < n; ++i) {
        queue.push([i, 1 << i, 0]);
        seen[i][1 << i] = true;
    }

    let ans = 0;
    while (queue.length) {
        const tuple = queue.shift();
        const u = tuple[0], mask = tuple[1], dist = tuple[2];
        if (mask === (1 << n) - 1) {
            ans = dist;
            break;
        }
        // 搜索相邻的节点
        for (const v of graph[u]) {
            // 将 mask 的第 v 位置为 1
            const maskV = mask | (1 << v);
            if (!seen[v][maskV]) {
                queue.push([v, maskV, dist + 1]);
                seen[v][maskV] = true;
            }
        }
    }
    return ans;
};
```

```go [sol1-Golang]
func shortestPathLength(graph [][]int) int {
    n := len(graph)
    type tuple struct{ u, mask, dist int }
    q := []tuple{}
    seen := make([][]bool, n)
    for i := range seen {
        seen[i] = make([]bool, 1<<n)
        seen[i][1<<i] = true
        q = append(q, tuple{i, 1 << i, 0})
    }

    for {
        t := q[0]
        q = q[1:]
        if t.mask == 1<<n-1 {
            return t.dist
        }
        // 搜索相邻的节点
        for _, v := range graph[t.u] {
            maskV := t.mask | 1<<v
            if !seen[v][maskV] {
                q = append(q, tuple{v, maskV, t.dist + 1})
                seen[v][maskV] = true
            }
        }
    }
}
```

```C [sol1-C]
struct Node {
    int id, mask, dist;
};

int shortestPathLength(int** graph, int graphSize, int* graphColSize){
    int n = graphSize;
    struct Node q[n * (1 << n)];
    int left = 0, right = 0;
    int seen[n][1 << n];
    memset(seen, 0, sizeof(seen));
    for (int i = 0; i < n; ++i) {
        q[right++] = (struct Node){i, 1 << i, 0};
        seen[i][1 << i] = true;
    }

    int ans = 0;
    while (left < right) {
        int u = q[left].id;
        int mask = q[left].mask;
        int dist = q[left++].dist;
        if (mask == (1 << n) - 1) {
            ans = dist;
            break;
        }
        // 搜索相邻的节点
        for (int i = 0; i < graphColSize[u]; i++) {
            int v = graph[u][i];
            // 将 mask 的第 v 位置为 1
            int mask_v = mask | (1 << v);
            if (!seen[v][mask_v]) {
                q[right++] = (struct Node){v, mask_v, dist + 1};
                seen[v][mask_v] = true;
            }
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2 \cdot 2^n)$。常规的广度优先搜索的时间复杂度为 $O(n + m)$，其中 $n$ 和 $m$ 分别表示图的节点数和边数。本题中引入了 $\textit{mask}$ 这一维度，其取值范围为 $[0, 2^n)$，因此可以看成是进行了 $2^n$ 次常规的广度优先搜索。由于 $m$ 的范围没有显式给出，在最坏情况下为完全图，有 $m = O(n^2)$，因此总时间复杂度为 $O(n^2 \cdot 2^n)$。

- 空间复杂度：$O(n \cdot 2^n)$，即为队列需要使用的空间。

#### 方法二：预处理点对间最短路 + 状态压缩动态规划

**思路与算法**

由于题目中给定的图是连通图，那么我们可以计算出任意两个节点之间 $u, v$ 间的最短距离，记为 $d(u, v)$。这样一来，我们就可以使用动态规划的方法计算出最短路径。

对于任意一条经过所有节点的路径，它的某一个子序列（可以不连续）一定是 $0, 1, \cdots, n - 1$ 的一个排列。我们称这个子序列上的节点为「关键节点」。在动态规划的过程中，我们也是通过枚举「关键节点」进行状态转移的。

我们用 $f[u][\textit{mask}]$ 表示从任一节点开始到节点 $u$ 为止，并且经过的「关键节点」对应的二进制表示为 $\textit{mask}$ 时的最短路径长度。由于 $u$ 是最后一个「关键节点」，那么在进行状态转移时，我们可以枚举上一个「关键节点」$v$，即：

$$
f[u][\textit{mask}] = \min_{v \in \textit{mask}, v \neq u} \big\{ f[v][\textit{mask}\backslash u] + d(v, u) \big\}
$$

其中 $\textit{mask} \backslash u$ 表示将 $\textit{mask}$ 的第 $u$ 位从 $1$ 变为 $0$ 后的二进制表示。也就是说，「关键节点」$v$ 在 $\textit{mask}$ 中的对应位置必须为 $1$，将 $f[v][\textit{mask} \backslash u]$ 加上从 $v$ 走到 $u$ 的最短路径长度为 $d(v, u)$，取最小值即为 $f[u][\textit{mask}]$。

最终的答案即为：

$$
\min_u f[u][2^n - 1]
$$

**细节**

当 $\textit{mask}$ 中只包含一个 $1$ 时，我们无法枚举满足要求的上一个「关键节点」$v$。这里的处理方式与方法一中的类似：若 $\textit{mask}$ 中只包含一个 $1$，说明我们位于开始的节点，还未经过任何路径，因此状态转移方程直接写为：

$$
f[u][\textit{mask}] = 0
$$

此外，在状态转移方程中，我们需要多次求出 $d(v, u)$，因此我们可以考虑在动态规划前将所有的 $d(v, u)$ 预处理出来。这里有两种可以使用的方法，时间复杂度均为 $O(n^3)$：

- 我们可以使用 $\texttt{Floyd}$ 算法求出所有点对之间的最短路径长度；

- 我们可以进行 $n$ 次广度优先搜索，第 $i$ 次从节点 $i$ 出发，也可以得到所有点对之间的最短路径长度。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int shortestPathLength(vector<vector<int>>& graph) {
        int n = graph.size();
        vector<vector<int>> d(n, vector<int>(n, n + 1));
        for (int i = 0; i < n; ++i) {
            for (int j: graph[i]) {
                d[i][j] = 1;
            }
        }
        // 使用 floyd 算法预处理出所有点对之间的最短路径长度
        for (int k = 0; k < n; ++k) {
            for (int i = 0; i < n; ++i) {
                for (int j = 0; j < n; ++j) {
                    d[i][j] = min(d[i][j], d[i][k] + d[k][j]);
                }
            }
        }

        vector<vector<int>> f(n, vector<int>(1 << n, INT_MAX / 2));
        for (int mask = 1; mask < (1 << n); ++mask) {
            // 如果 mask 只包含一个 1，即 mask 是 2 的幂
            if ((mask & (mask - 1)) == 0) {
                int u = __builtin_ctz(mask);
                f[u][mask] = 0;
            }
            else {
                for (int u = 0; u < n; ++u) {
                    if (mask & (1 << u)) {
                        for (int v = 0; v < n; ++v) {
                            if ((mask & (1 << v)) && u != v) {
                                f[u][mask] = min(f[u][mask], f[v][mask ^ (1 << u)] + d[v][u]);
                            }
                        }
                    }
                }
            }
        }

        int ans = INT_MAX;
        for (int u = 0; u < n; ++u) {
            ans = min(ans, f[u][(1 << n) - 1]);
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int shortestPathLength(int[][] graph) {
        int n = graph.length;
        int[][] d = new int[n][n];
        for (int i = 0; i < n; ++i) {
            Arrays.fill(d[i], n + 1);
        }
        for (int i = 0; i < n; ++i) {
            for (int j : graph[i]) {
                d[i][j] = 1;
            }
        }
        // 使用 floyd 算法预处理出所有点对之间的最短路径长度
        for (int k = 0; k < n; ++k) {
            for (int i = 0; i < n; ++i) {
                for (int j = 0; j < n; ++j) {
                    d[i][j] = Math.min(d[i][j], d[i][k] + d[k][j]);
                }
            }
        }

        int[][] f = new int[n][1 << n];
        for (int i = 0; i < n; ++i) {
            Arrays.fill(f[i], Integer.MAX_VALUE / 2);
        }
        for (int mask = 1; mask < (1 << n); ++mask) {
            // 如果 mask 只包含一个 1，即 mask 是 2 的幂
            if ((mask & (mask - 1)) == 0) {
                int u = Integer.bitCount((mask & (-mask)) - 1);
                f[u][mask] = 0;
            } else {
                for (int u = 0; u < n; ++u) {
                    if ((mask & (1 << u)) != 0) {
                        for (int v = 0; v < n; ++v) {
                            if ((mask & (1 << v)) != 0 && u != v) {
                                f[u][mask] = Math.min(f[u][mask], f[v][mask ^ (1 << u)] + d[v][u]);
                            }
                        }
                    }
                }
            }
        }

        int ans = Integer.MAX_VALUE;
        for (int u = 0; u < n; ++u) {
            ans = Math.min(ans, f[u][(1 << n) - 1]);
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int ShortestPathLength(int[][] graph) {
        int n = graph.Length;
        int[,] d = new int[n, n];
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                d[i, j] = n + 1;
            }
        }
        for (int i = 0; i < n; ++i) {
            foreach (int j in graph[i]) {
                d[i, j] = 1;
            }
        }
        // 使用 floyd 算法预处理出所有点对之间的最短路径长度
        for (int k = 0; k < n; ++k) {
            for (int i = 0; i < n; ++i) {
                for (int j = 0; j < n; ++j) {
                    d[i, j] = Math.Min(d[i, j], d[i, k] + d[k, j]);
                }
            }
        }

        int[,] f = new int[n, 1 << n];
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < 1 << n; ++j) {
                f[i, j] = int.MaxValue / 2;
            }
        }
        for (int mask = 1; mask < (1 << n); ++mask) {
            // 如果 mask 只包含一个 1，即 mask 是 2 的幂
            if ((mask & (mask - 1)) == 0) {
                int u = BitCount((mask & (-mask)) - 1);
                f[u, mask] = 0;
            } else {
                for (int u = 0; u < n; ++u) {
                    if ((mask & (1 << u)) != 0) {
                        for (int v = 0; v < n; ++v) {
                            if ((mask & (1 << v)) != 0 && u != v) {
                                f[u, mask] = Math.Min(f[u, mask], f[v, mask ^ (1 << u)] + d[v, u]);
                            }
                        }
                    }
                }
            }
        }

        int ans = int.MaxValue;
        for (int u = 0; u < n; ++u) {
            ans = Math.Min(ans, f[u, (1 << n) - 1]);
        }
        return ans;
    }

    public static int BitCount(int i) {
        i = i - ((i >> 1) & 0x55555555);
        i = (i & 0x33333333) + ((i >> 2) & 0x33333333);
        i = (i + (i >> 4)) & 0x0f0f0f0f;
        i = i + (i >> 8);
        i = i + (i >> 16);
        return i & 0x3f;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def shortestPathLength(self, graph: List[List[int]]) -> int:
        n = len(graph)
        d = [[n + 1] * n for _ in range(n)]
        for i in range(n):
            for j in graph[i]:
                d[i][j] = 1
        
        # 使用 floyd 算法预处理出所有点对之间的最短路径长度
        for k in range(n):
            for i in range(n):
                for j in range(n):
                    d[i][j] = min(d[i][j], d[i][k] + d[k][j])

        f = [[float("inf")] * (1 << n) for _ in range(n)]
        for mask in range(1, 1 << n):
            # 如果 mask 只包含一个 1，即 mask 是 2 的幂
            if (mask & (mask - 1)) == 0:
                u = bin(mask).count("0") - 1
                f[u][mask] = 0
            else:
                for u in range(n):
                    if mask & (1 << u):
                        for v in range(n):
                            if (mask & (1 << v)) and u != v:
                                f[u][mask] = min(f[u][mask], f[v][mask ^ (1 << u)] + d[v][u])

        ans = min(f[u][(1 << n) - 1] for u in range(n))
        return ans
```

```JavaScript [sol2-JavaScript]
var shortestPathLength = function(graph) {
    const n = graph.length;
    const d = new Array(n).fill(0).map(() => new Array(n).fill(n + 1));
    for (let i = 0; i < n; ++i) {
        for (const j of graph[i]) {
            d[i][j] = 1;
        }
    }
    // 使用 floyd 算法预处理出所有点对之间的最短路径长度
    for (let k = 0; k < n; ++k) {
        for (let i = 0; i < n; ++i) {
            for (let j = 0; j < n; ++j) {
                d[i][j] = Math.min(d[i][j], d[i][k] + d[k][j]);
            }
        }
    }

    const f = new Array(n).fill(0).map(() => new Array(1 << n).fill(Number.MAX_SAFE_INTEGER));
    for (let mask = 1; mask < (1 << n); ++mask) {
        // 如果 mask 只包含一个 1，即 mask 是 2 的幂
        if ((mask & (mask - 1)) === 0) {
            const tmp = (mask & (-mask)) - 1;
            const u = tmp.toString(2).split('0').join('').length;
            f[u][mask] = 0;
        } else {
            for (let u = 0; u < n; ++u) {
                if ((mask & (1 << u)) !== 0) {
                    for (let v = 0; v < n; ++v) {
                        if ((mask & (1 << v)) !== 0 && u !== v) {
                            f[u][mask] = Math.min(f[u][mask], f[v][mask ^ (1 << u)] + d[v][u]);
                        }
                    }
                }
            }
        }
    }

    let ans = Number.MAX_SAFE_INTEGER;
    for (let u = 0; u < n; ++u) {
        ans = Math.min(ans, f[u][(1 << n) - 1]);
    }
    return ans;
};
```

```go [sol2-Golang]
func shortestPathLength(graph [][]int) int {
    n := len(graph)
    d := make([][]int, n)
    for i := range d {
        d[i] = make([]int, n)
        for j := range d[i] {
            d[i][j] = n + 1
        }
    }
    for v, nodes := range graph {
        for _, u := range nodes {
            d[v][u] = 1
        }
    }

    // 使用 floyd 算法预处理出所有点对之间的最短路径长度
    for k := range d {
        for i := range d {
            for j := range d {
                d[i][j] = min(d[i][j], d[i][k]+d[k][j])
            }
        }
    }

    f := make([][]int, n)
    for i := range f {
        f[i] = make([]int, 1<<n)
        for j := range f[i] {
            f[i][j] = math.MaxInt64 / 2
        }
    }
    for mask := 1; mask < 1<<n; mask++ {
        // 如果 mask 只包含一个 1，即 mask 是 2 的幂
        if mask&(mask-1) == 0 {
            i := bits.TrailingZeros(uint(mask))
            f[i][1<<i] = 0
            continue
        }
        for u := 0; u < n; u++ {
            if mask>>u&1 > 0 {
                for v := 0; v < n; v++ {
                    if v != u && mask>>v&1 > 0 {
                        f[u][mask] = min(f[u][mask], f[v][mask^(1<<u)]+d[v][u])
                    }
                }
            }
        }
    }
    ans := math.MaxInt64
    for u := 0; u < n; u++ {
        ans = min(ans, f[u][1<<n-1])
    }
    return ans
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```C [sol2-C]
struct Node {
    int id, mask, dist;
};

int shortestPathLength(int** graph, int graphSize, int* graphColSize){
    int n = graphSize;
    int d[n][n];
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            d[i][j] = n + 1;
        }
        for (int j = 0; j < graphColSize[i]; j++) {
            d[i][graph[i][j]] = 1;
        }
    }
    // 使用 floyd 算法预处理出所有点对之间的最短路径长度
    for (int k = 0; k < n; ++k) {
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                d[i][j] = fmin(d[i][j], d[i][k] + d[k][j]);
            }
        }
    }

    int f[n][1 << n];
    memset(f, 0x3f, sizeof(f));
    for (int mask = 1; mask < (1 << n); ++mask) {
        // 如果 mask 只包含一个 1，即 mask 是 2 的幂
        if ((mask & (mask - 1)) == 0) {
            int u = __builtin_ctz(mask);
            f[u][mask] = 0;
        }
        else {
            for (int u = 0; u < n; ++u) {
                if (mask & (1 << u)) {
                    for (int v = 0; v < n; ++v) {
                        if ((mask & (1 << v)) && u != v) {
                            f[u][mask] = fmin(f[u][mask], f[v][mask ^ (1 << u)] + d[v][u]);
                        }
                    }
                }
            }
        }
    }

    int ans = INT_MAX;
    for (int u = 0; u < n; ++u) {
        ans = fmin(ans, f[u][(1 << n) - 1]);
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2 \cdot 2^n)$。状态的总数为 $O(n \cdot 2^n)$，对于每一个状态，我们需要 $O(n)$ 的时间枚举 $v$ 进行状态转移，因此总时间复杂度 $O(n^2 \cdot 2^n)$。

    预处理所有 $d(u, v)$ 的时间复杂度为 $O(n^3)$，但其在渐近意义下小于 $O(n^2 \cdot 2^n)$，因此可以忽略。

- 空间复杂度：$O(n \cdot 2^n)$，即为存储所有状态需要使用的空间。
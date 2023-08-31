## [1761.一个图中连通三元组的最小度数 中文官方题解](https://leetcode.cn/problems/minimum-degree-of-a-connected-trio-in-a-graph/solutions/100000/yi-ge-tu-zhong-lian-tong-san-yuan-zu-de-wuv8o)
#### 方法一：枚举每一个三元组

**思路与算法**

我们可以直接枚举每一个三元组，并计算其度数。

为了方便对三元组进行枚举，我们可以使用一个邻接矩阵 $g$ 存储所有的边，其中 $g(i, j) = 1$ 表示节点 $i$ 和 $j$ 之间有一条边。这样一来，我们只需要使用一个三重循环，如果 $g(i, j), g(i, k), g(j, k)$ 均为 $1$，那么 $(i, j, k)$ 就是一个连通的三元组。

为了快速计算连通三元组的度数，我们可以预处理出每一个节点的度数，记为数组 $\textit{degree}$。此时，对于一个连通三元组 $(i, j, k)$，它的度数即为：

$$
\textit{degree}(i) + \textit{degree}(j) + \textit{degree}(k) - 6
$$

减去的 $6$ 代表了 $(i, j, k)$ 之间的 $3$ 条边，每条边被计算了 $2$ 次。

**优化**

上述方法会将每个三元组枚举 $3! = 6$ 次。为了减少常数，在进行枚举时，我们可以只枚举 $i < j < k$ 的情况，这样每个三元组只会被枚举 $1$ 次。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minTrioDegree(int n, vector<vector<int>>& edges) {
        vector<vector<int>> g(n, vector<int>(n));
        vector<int> degree(n);

        for (auto&& edge: edges) {
            int x = edge[0] - 1, y = edge[1] - 1;
            g[x][y] = g[y][x] = 1;
            ++degree[x];
            ++degree[y];
        }

        int ans = INT_MAX;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                if (g[i][j] == 1) {
                    for (int k = j + 1; k < n; ++k) {
                        if (g[i][k] == 1 && g[j][k] == 1) {
                            ans = min(ans, degree[i] + degree[j] + degree[k] - 6);
                        }
                    }
                }
            }
        }

        return ans == INT_MAX ? -1 : ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minTrioDegree(int n, int[][] edges) {
        int[][] g = new int[n][n];
        int[] degree = new int[n];

        for (int[] edge : edges) {
            int x = edge[0] - 1, y = edge[1] - 1;
            g[x][y] = g[y][x] = 1;
            ++degree[x];
            ++degree[y];
        }

        int ans = Integer.MAX_VALUE;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                if (g[i][j] == 1) {
                    for (int k = j + 1; k < n; ++k) {
                        if (g[i][k] == 1 && g[j][k] == 1) {
                            ans = Math.min(ans, degree[i] + degree[j] + degree[k] - 6);
                        }
                    }
                }
            }
        }

        return ans == Integer.MAX_VALUE ? -1 : ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinTrioDegree(int n, int[][] edges) {
        int[][] g = new int[n][];
        for (int i = 0; i < n; ++i) {
            g[i] = new int[n];
        }
        int[] degree = new int[n];

        foreach (int[] edge in edges) {
            int x = edge[0] - 1, y = edge[1] - 1;
            g[x][y] = g[y][x] = 1;
            ++degree[x];
            ++degree[y];
        }

        int ans = int.MaxValue;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                if (g[i][j] == 1) {
                    for (int k = j + 1; k < n; ++k) {
                        if (g[i][k] == 1 && g[j][k] == 1) {
                            ans = Math.Min(ans, degree[i] + degree[j] + degree[k] - 6);
                        }
                    }
                }
            }
        }

        return ans == int.MaxValue ? -1 : ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minTrioDegree(self, n: int, edges: List[List[int]]) -> int:
        g = [[0] * n for _ in range(n)]
        degree = [0] * n
        
        for x, y in edges:
            x, y = x - 1, y - 1
            g[x][y] = g[y][x] = 1
            degree[x] += 1
            degree[y] += 1
        
        ans = inf
        for i in range(n):
            for j in range(i + 1, n):
                if g[i][j] == 1:
                    for k in range(j + 1, n):
                        if g[i][k] == g[j][k] == 1:
                            ans = min(ans, degree[i] + degree[j] + degree[k] - 6)
        
        return -1 if ans == inf else ans
```

```Go [sol1-Go]
func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}

func minTrioDegree(n int, edges [][]int) int {
    g := make([][]int, n)
    degree := make([]int, n)
    for i := 0; i < n; i++ {
        g[i] = make([]int, n)
    }
    for _, edge := range edges {
        x, y := edge[0] - 1, edge[1] - 1
        g[x][y], g[y][x] = 1, 1
        degree[x]++
        degree[y]++
    }
    ans := 0x3f3f3f3f
    for i := 0; i < n; i++ {
        for j := i + 1; j < n; j++ {
            if g[i][j] != 1 {
                continue
            }
            for k := j + 1; k < n; k++ {
                if g[i][k] == 1 && g[j][k] == 1 {
                    ans = min(ans, degree[i] + degree[j] + degree[k] - 6)
                }
            }
        }
    }
    if ans == 0x3f3f3f3f {
        return -1
    }
    return ans
}
```

```C [sol1-C]
int minTrioDegree(int n, int** edges, int edgesSize, int* edgesColSize) {
    int g[n][n], degree[n];
    memset(g, 0, sizeof(g));
    memset(degree, 0, sizeof(degree));

    for (int i = 0; i < edgesSize; i++) {
        int x = edges[i][0] - 1, y = edges[i][1] - 1;
        g[x][y] = g[y][x] = 1;
        ++degree[x];
        ++degree[y];
    }

    int ans = INT_MAX;
    for (int i = 0; i < n; ++i) {
        for (int j = i + 1; j < n; ++j) {
            if (g[i][j] == 1) {
                for (int k = j + 1; k < n; ++k) {
                    if (g[i][k] == 1 && g[j][k] == 1) {
                        ans = fmin(ans, degree[i] + degree[j] + degree[k] - 6);
                    }
                }
            }
        }
    }
    return ans == INT_MAX ? -1 : ans;
}
```

```JavaScript [sol1-JavaScript]
var minTrioDegree = function(n, edges) {
    const degree = Array(n).fill(0);
    const g = Array(n).fill(0).map(() => new Array(n).fill(0));

    for (const [x, y] of edges) {
        g[x - 1][y - 1] = g[y - 1][x - 1] = 1;
        degree[x - 1]++;
        degree[y - 1]++;
    }

    let ans = Infinity;
    for (let i = 0; i < n; ++i) {
        for (let j = i + 1; j < n; ++j) {
            if (g[i][j] == 1) {
                for (let k = j + 1; k < n; ++k) {
                    if (g[i][k] == 1 && g[j][k] == 1) {
                        ans = Math.min(ans, degree[i] + degree[j] + degree[k] - 6);
                    }
                }
            }
        }
    }
    return ans == Infinity ? -1 : ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n^3)$。

- 空间复杂度：$O(n^2)$，即为邻接矩阵需要使用的空间。

#### 方法二：另一种枚举每一个三元组的方法

**思路与算法**

我们考虑将图中的每条边指定一个方向。对于图中的两个节点 $i, j$，它们之间有一条无向边：

- 如果 $\textit{degree}(i) < \textit{degree}(j)$，那么边的方向由 $i$ 指向 $j$；

- 如果 $\textit{degree}(i) > \textit{degree}(j)$，那么边的方向由 $j$ 指向 $i$；

- 如果 $\textit{degree}(i) = \textit{degree}(j)$，那么边的方向由编号较小的节点指向编号较大的节点。

这种定向方法可以保证得到的有向图中，任意一个节点的出度都不会超过 $\sqrt{2m}$，其中 $m$ 为图中的边数，证明如下：

> 使用反证法，假设节点 $i$ 的**出度**大于 $\sqrt{2m}$，那么节点 $i$ 在原始无向图中的**度数**大于 $\sqrt{2m}$，说明其指向的节点在原始无向图中的**度数**也大于 $\sqrt{2m}$，即原始无向图中有超过 $\sqrt{2m}$ 个节点的**度数**大于 $\sqrt{2m}$，即总度数大于 $2m$。而总度数应该恰好为 $2m$。

因此我们就可以在有向图上枚举连通三元组了：

- 枚举 $i$ 以及 $i$ 指向的节点 $j$。由于图中有 $m$ 条边，这一部分的时间复杂度为 $O(m)$；

- 枚举 $j$ 指向的节点 $k$，由于 $j$ 的出度不超过 $\sqrt{2m}$，这一部分的时间复杂度为 $O(\sqrt{m})$；

- 判断 $k$ 在原始无向图中是否与 $i$ 之间有一条无向边，可以使用哈希表，这一部分的时间复杂度为 $O(1)$。

因此该方法的时间复杂度为 $O(m \sqrt{m})$。在本题中，$m$ 在最坏情况下可以达到 $O(n^2)$，与方法一的时间复杂度一致。但如果给出形如 $m = n = O(10^5)$ 的图，那么只有方法二可以在规定时间内通过。

这样做一定能保证枚举到每一个连通三元组，证明如下：

> 对于任意连通三元组 $(i, j, k)$，不妨设定向后有 $i \to j$，那么如果 $j \to k$，那么按照顺序枚举 $i, j, k$ 即可；如果 $k \to j$，那么根据 $i$ 与 $k$ 之间的定向，按照顺序枚举 $i, k, j$ 或者 $k, i, j$ 即可。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int minTrioDegree(int n, vector<vector<int>>& edges) {
        // 原图
        vector<unordered_set<int>> g(n);
        // 定向后的图
        vector<vector<int>> h(n);
        vector<int> degree(n);

        for (auto&& edge: edges) {
            int x = edge[0] - 1, y = edge[1] - 1;
            g[x].insert(y);
            g[y].insert(x);
            ++degree[x];
            ++degree[y];
        }
        for (auto&& edge: edges) {
            int x = edge[0] - 1, y = edge[1] - 1;
            if (degree[x] < degree[y] || (degree[x] == degree[y] && x < y)) {
                h[x].push_back(y);
            }
            else {
                h[y].push_back(x);
            }
        }

        int ans = INT_MAX;
        for (int i = 0; i < n; ++i) {
            for (int j: h[i]) {
                for (int k: h[j]) {
                    if (g[i].count(k)) {
                        ans = min(ans, degree[i] + degree[j] + degree[k] - 6);
                    }
                }
            }
        }

        return ans == INT_MAX ? -1 : ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int minTrioDegree(int n, int[][] edges) {
        // 原图
        Set<Integer>[] g = new Set[n];
        for (int i = 0; i < n; ++i) {
            g[i] = new HashSet<Integer>();
        }
        // 定向后的图
        List<Integer>[] h = new List[n];
        for (int i = 0; i < n; ++i) {
            h[i] = new ArrayList<Integer>();
        }
        int[] degree = new int[n];

        for (int[] edge : edges) {
            int x = edge[0] - 1, y = edge[1] - 1;
            g[x].add(y);
            g[y].add(x);
            ++degree[x];
            ++degree[y];
        }
        for (int[] edge : edges) {
            int x = edge[0] - 1, y = edge[1] - 1;
            if (degree[x] < degree[y] || (degree[x] == degree[y] && x < y)) {
                h[x].add(y);
            } else {
                h[y].add(x);
            }
        }

        int ans = Integer.MAX_VALUE;
        for (int i = 0; i < n; ++i) {
            for (int j : h[i]) {
                for (int k : h[j]) {
                    if (g[i].contains(k)) {
                        ans = Math.min(ans, degree[i] + degree[j] + degree[k] - 6);
                    }
                }
            }
        }

        return ans == Integer.MAX_VALUE ? -1 : ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MinTrioDegree(int n, int[][] edges) {
        // 原图
        ISet<int>[] g = new ISet<int>[n];
        for (int i = 0; i < n; ++i) {
            g[i] = new HashSet<int>();
        }
        // 定向后的图
        IList<int>[] h = new IList<int>[n];
        for (int i = 0; i < n; ++i) {
            h[i] = new List<int>();
        }
        int[] degree = new int[n];

        foreach (int[] edge in edges) {
            int x = edge[0] - 1, y = edge[1] - 1;
            g[x].Add(y);
            g[y].Add(x);
            ++degree[x];
            ++degree[y];
        }
        foreach (int[] edge in edges) {
            int x = edge[0] - 1, y = edge[1] - 1;
            if (degree[x] < degree[y] || (degree[x] == degree[y] && x < y)) {
                h[x].Add(y);
            } else {
                h[y].Add(x);
            }
        }

        int ans = int.MaxValue;
        for (int i = 0; i < n; ++i) {
            foreach (int j in h[i]) {
                foreach (int k in h[j]) {
                    if (g[i].Contains(k)) {
                        ans = Math.Min(ans, degree[i] + degree[j] + degree[k] - 6);
                    }
                }
            }
        }

        return ans == int.MaxValue ? -1 : ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def minTrioDegree(self, n: int, edges: List[List[int]]) -> int:
        # 原图
        g = defaultdict(set)
        # 定向后的图
        h = defaultdict(list)
        degree = [0] * n

        for x, y in edges:
            x, y = x - 1, y - 1
            g[x].add(y)
            g[y].add(x)
            degree[x] += 1
            degree[y] += 1
        
        for x, y in edges:
            x, y = x - 1, y - 1
            if degree[x] < degree[y] or (degree[x] == degree[y] and x < y):
                h[x].append(y)
            else:
                h[y].append(x)
        
        ans = inf
        for i in range(n):
            for j in h[i]:
                for k in h[j]:
                    if k in g[i]:
                        ans = min(ans, degree[i] + degree[j] + degree[k] - 6)

        return -1 if ans == inf else ans
```

```Go [sol2-Go]
func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}

func minTrioDegree(n int, edges [][]int) int {
    g := make([]map[int]struct{}, n)
    h := make([][]int, n)
    degree := make([]int, n)
    for i := 0; i < n; i++ {
        g[i] = make(map[int]struct{})
    }

    for _, edge := range edges {
        x, y := edge[0] - 1, edge[1] - 1
        g[x][y], g[y][x] = struct{}{}, struct{}{}
        degree[x]++
        degree[y]++
    }
    for _, edge := range edges {
        x, y := edge[0] - 1, edge[1] - 1
        if degree[x] < degree[y] || (degree[x] == degree[y] && x < y) {
            h[x] = append(h[x], y)
        } else {
            h[y] = append(h[y], x)
        }
    }

    ans := 0x3f3f3f3f
    for i := 0; i < n; i++ {
        for _, j := range h[i] {
            for _, k := range h[j] {
                if _, ok := g[i][k]; ok {
                    ans = min(ans, degree[i] + degree[j] + degree[k] - 6)
                }
            }
        }
    }
    if ans == 0x3f3f3f3f {
        return -1
    }
    return ans
}
```

```C [sol2-C]
typedef struct {
    int key;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);
    }
}

int minTrioDegree(int n, int** edges, int edgesSize, int* edgesColSize) {
    // 原图
    HashItem *g[n];
    // 定向后的图
    HashItem *h[n];
    int degree[n];
    for (int i = 0; i < n; i++) {
        h[i] = NULL;
        g[i] = NULL;
    }
    memset(degree, 0, sizeof(degree));

    for (int i = 0; i < edgesSize; i++) {
        int x = edges[i][0] - 1, y = edges[i][1] - 1;
        hashAddItem(&g[x], y);
        hashAddItem(&g[y], x);
        ++degree[x];
        ++degree[y];
    }
    for (int i = 0; i < edgesSize; i++) {
        int x = edges[i][0] - 1, y = edges[i][1] - 1;
        if (degree[x] < degree[y] || (degree[x] == degree[y] && x < y)) {
            hashAddItem(&h[x], y);
        } else {
            hashAddItem(&h[y], x);
        }
    }

    int ans = INT_MAX;
    for (int i = 0; i < n; ++i) {
        for (HashItem *pEntry1 = h[i]; pEntry1; pEntry1 = pEntry1->hh.next) {
            int j = pEntry1->key;
            for (HashItem *pEntry2 = h[j]; pEntry2; pEntry2 = pEntry2->hh.next) {
                int k = pEntry2->key;
                if (hashFindItem(&g[i], k)) {
                    ans = fmin(ans, degree[i] + degree[j] + degree[k] - 6);
                }
            }
        }
    }
    for (int i = 0; i < n; i++) {
        hashFree(&h[i]);
        hashFree(&g[i]);
    }
    return ans == INT_MAX ? -1 : ans;
}
```

```JavaScript [sol2-JavaScript]
var minTrioDegree = function(n, edges) {
    // 原图
    const g = Array(n).fill(0).map(() => new Set());
    // 定向后的图
    const h = Array(n).fill(0).map(() => new Array());
    const degree = Array(n).fill(0);

    for (const [x, y] of edges) {
        g[x - 1].add(y - 1);
        g[y - 1].add(x - 1);
        degree[x - 1]++;
        degree[y - 1]++;
    }
    for (const [x, y] of edges) {
        if (degree[x - 1] < degree[y - 1] || (degree[x - 1] == degree[y - 1] && x < y)) {
            h[x - 1].push(y - 1);
        } else {
            h[y - 1].push(x - 1);
        }
    }

    let ans = Infinity;
    for (let i = 0; i < n; ++i) {
        for (const j of h[i]) {
            for (const k of h[j]) {
                if (g[i].has(k)) {
                    ans = Math.min(ans, degree[i] + degree[j] + degree[k] - 6);
                }
            }
        }
    }

    return ans == Infinity ? -1 : ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n + m \sqrt{m})$，其中 $m$ 是数组 $\textit{edges}$ 的长度。

- 空间复杂度：$O(m)$，即为使用邻接表需要使用的空间。
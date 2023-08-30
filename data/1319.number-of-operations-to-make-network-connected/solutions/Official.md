#### 前言

我们首先考虑在什么情况下，不可能将所有计算机进行连接。

当计算机的数量为 $n$ 时，我们至少需要 $n-1$ 根线才能将它们进行连接。如果线的数量少于 $n-1$，那么我们无论如何都无法将这 $n$ 台计算机进行连接。因此如果数组 $\textit{connections}$ 的长度小于 $n-1$，我们可以直接返回 $-1$ 作为答案，否则我们一定可以找到一种操作方式。

那么如何计算最少的操作次数呢？我们将这 $n$ 台计算机看成 $n$ 个节点，每一条线看成一条无向边。假设这个无向图中有 $k$ 个「连通分量」，连通分量的定义为：

> 设集合 $V$ 为无向图中节点的一个子集，集合 $E$ 为无向图中所有两个端点都在 $V$ 中的边。设图 $S=(V, E)$，那么 $S$ 就称为无向图的一个「诱导子图」（或者叫「导出子图」）。「连通分量」是极大的「诱导子图」，这里的「极大」表现在：
> - $V$ 中的任意两个节点仅通过 $E$ 就可以相互到达；
>
> - 不存在一个不属于 $V$ 的节点 $x$，使得 $x$ 与 $V$ 中的某个节点直接相连。
>
> 我们可以通过节点集合 $V$ 唯一地描述一个连通分量：例如在题目给出的样例 $1$ 中，有两个连通分量 $\{0, 1, 2\}$ 和 $\{3\}$；样例 $2$ 中，有三个连通分量 $\{0, 1, 2, 3\}$，$\{4\}$ 和 $\{5\}$。

如果我们的操作是「添加一根线」而不是「移动一根线」，那么显然只需要添加 $k-1$ 根线就可以将所有计算机进行连接了：例如将编号为 $0$ 的连通分量中的任意一台计算机分别与编号为 $1, 2, \cdots, k-1$ 的连通分量中的任意一台计算机相连。由于「移动一根线」的操作一定不会优于「添加一根线」，那么我们至少需要移动 $k-1$ 根线，才有可能将所有计算机连接。

那么我们是否可以找到一种移动 $k-1$ 根线的操作方法呢？我们可以发现，$m$ 台电脑只需要 $m-1$ 根线就可以将它们进行连接。如果一个节点数为 $m$ 的连通分量中的边数超过 $m - 1$，就一定可以找到一条多余的边，且移除这条边之后，连通性保持不变。此时，我们就可以用这条边来连接两个连通分量，使得图中连通分量的个数减少 $1$。

> 在题目给出的样例 $2$ 中，连通分量 $\{0, 1, 2, 3\}$ 中有 $5$ 条边，大于 $m-1=3$。因此一定可以找到一条多余的边。具体地，该连通分量中的任意一条边被移除后，连通性都保持不变。
>
> **注意**：并不是在所有的情况下，连通分量中的任意一条边都是可以被移除的，我们只需要保证必定能够找到「一条」多余的边。

因此我们可以设计一个迭代的过程：每次在图中找出一条多余的边，将其断开，并连接图中的两个连通分量。将这个过程重复 $k-1$ 次，最终就可以使得整个图连通。

我们如何保证一定能找出「一条」多余的边呢？我们需要证明的是，在**任意时刻**，如果图中有 $k'$ 个连通分量且 $k'>1$，即整个图还没有完全连通，那么一定存在一个连通分量，使得其有一条多余的边：即它的节点数为 $m_i$，边数为 $e_i$，并且有 $e_i > m_i - 1$。

我们可以使用反证法来证明上面的结论。假设所有的连通分量都满足 $e_i \leq m_i - 1$，那么：

$$
\begin{cases}
e_1 \leq m_1 - 1 \\
e_2 \leq m_2 - 1 \\
\cdots \\
e_{k'} \leq m_{k'} - 1
\end{cases}
$$

将这 $k'$ 个不等式相加可以得到：

$$
e_1 + \cdots + e_{k'} \leq m_1 + \cdots + m_{k'} - k' = n - k'
$$

左侧的 $e_1 + \cdots + e_{k'}$ 即为图中的边数，右侧的 $m_1 + ... + m_{k'} = n$ 即为图中的节点数。由于图中至少有 $n-1$ 条边，那么有：

$$
e_1 + \cdots + e_{k'} \geq n - 1
$$

与

$$
e_1 + \cdots + e_{k'} \leq n - k'
$$

产生了矛盾！因此一定存在一个连通分量，它有一条多余的边。

统计图中连通分量数的方法有很多，本篇题解中我们给出深度优先搜索和并查集两种方法。

#### 方法一：深度优先搜索

**思路与算法**

我们可以使用深度优先搜索来得到图中的连通分量数。

具体地，初始时所有节点的状态均为「待搜索」。我们每次选择一个「待搜索」的节点，从该节点开始进行深度优先搜索，并将所有搜索到的节点的状态更改为「已搜索」，这样我们就找到了一个连通分量。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    vector<vector<int>> edges;
    vector<int> used;

public:
    void dfs(int u) {
        used[u] = true;
        for (int v: edges[u]) {
            if (!used[v]) {
                dfs(v);
            }
        }
    }
    
    int makeConnected(int n, vector<vector<int>>& connections) {
        if (connections.size() < n - 1) {
            return -1;
        }

        edges.resize(n);
        for (const auto& conn: connections) {
            edges[conn[0]].push_back(conn[1]);
            edges[conn[1]].push_back(conn[0]);
        }
        
        used.resize(n);
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            if (!used[i]) {
                dfs(i);
                ++ans;
            }
        }
        
        return ans - 1;
    }
};
```

```Java [sol1-Java]
class Solution {
    List<Integer>[] edges;
    boolean[] used;

    public int makeConnected(int n, int[][] connections) {
        if (connections.length < n - 1) {
            return -1;
        }

        edges = new List[n];
        for (int i = 0; i < n; ++i) {
            edges[i] = new ArrayList<Integer>();
        }
        for (int[] conn : connections) {
            edges[conn[0]].add(conn[1]);
            edges[conn[1]].add(conn[0]);
        }
        
        used = new boolean[n];
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            if (!used[i]) {
                dfs(i);
                ++ans;
            }
        }
        
        return ans - 1;
    }

    public void dfs(int u) {
        used[u] = true;
        for (int v : edges[u]) {
            if (!used[v]) {
                dfs(v);
            }
        }
    }
}
```

```Python [sol1-Python3]
class Solution:
    def makeConnected(self, n: int, connections: List[List[int]]) -> int:
        if len(connections) < n - 1:
            return -1
        
        edges = collections.defaultdict(list)
        for x, y in connections:
            edges[x].append(y)
            edges[y].append(x)
        
        seen = set()

        def dfs(u: int):
            seen.add(u)
            for v in edges[u]:
                if v not in seen:
                    dfs(v)
        
        ans = 0
        for i in range(n):
            if i not in seen:
                dfs(i)
                ans += 1
        
        return ans - 1
```

```JavaScript [sol1-JavaScript]
var makeConnected = function(n, connections) {
    if (connections.length < n - 1) {
        return -1;
    }

    const edges = new Map();
    for (const [x, y] of connections) {
        edges.get(x) ? edges.get(x).push(y) : edges.set(x, [y]);
        edges.get(y) ? edges.get(y).push(x) : edges.set(y, [x]);
    }

    const used = new Array(n).fill(0);

    let ans = 0;
    for (let i = 0; i < n; i++) {
        if (!used[i]) {
            dfs(i, used, edges);
            ans++;
        }
    }
    return ans - 1;
};

const dfs = (u, used, edges) => {
    used[u] = 1;
    if (edges.get(u)) {
        for (const v of edges.get(u)) {
            if (!used[v]) {
                dfs(v, used, edges);
            }
        }
    }
}
```

```go [sol1-Golang]
func makeConnected(n int, connections [][]int) (ans int) {
    if len(connections) < n-1 {
        return -1
    }

    graph := make([][]int, n)
    for _, c := range connections {
        v, w := c[0], c[1]
        graph[v] = append(graph[v], w)
        graph[w] = append(graph[w], v)
    }

    vis := make([]bool, n)
    var dfs func(int)
    dfs = func(from int) {
        vis[from] = true
        for _, to := range graph[from] {
            if !vis[to] {
                dfs(to)
            }
        }
    }
    for i, v := range vis {
        if !v {
            ans++
            dfs(i)
        }
    }
    return ans - 1
}
```

```C [sol1-C]
void dfs(int** edges, int* edgesColSize, int* used, int u) {
    used[u] = true;
    for (int i = 0; i < edgesColSize[u]; i++) {
        int v = edges[u][i];
        if (!used[v]) {
            dfs(edges, edgesColSize, used, v);
        }
    }
}

int makeConnected(int n, int** connections, int connectionsSize, int* connectionsColSize) {
    if (connectionsSize < n - 1) {
        return -1;
    }

    int* edges[n];
    int edgesColSize[n];
    memset(edgesColSize, 0, sizeof(edgesColSize));
    for (int i = 0; i < connectionsSize; i++) {
        edgesColSize[connections[i][0]]++;
        edgesColSize[connections[i][1]]++;
    }
    for (int i = 0; i < n; i++) {
        edges[i] = malloc(sizeof(int) * edgesColSize[i]);
        edgesColSize[i] = 0;
    }

    for (int i = 0; i < connectionsSize; i++) {
        int x = connections[i][0], y = connections[i][1];
        edges[x][edgesColSize[x]++] = y;
        edges[y][edgesColSize[y]++] = x;
    }

    int used[n];
    memset(used, 0, sizeof(used));
    int ans = 0;
    for (int i = 0; i < n; ++i) {
        if (!used[i]) {
            dfs(edges, edgesColSize, used, i);
            ++ans;
        }
    }

    return ans - 1;
}
```

**复杂度分析**

- 时间复杂度：$O(n+m)$，其中 $m$ 是数组 $\textit{connections}$ 的长度。

- 空间复杂度：$O(n+m)$，其中 $O(m)$ 为存储所有边需要的空间，$O(n)$ 为深度优先搜索中使用的栈空间。

#### 方法二：并查集

我们可以使用并查集来得到图中的连通分量数。

并查集本身就是用来维护连通性的数据结构。如果其包含 $n$ 个节点，那么初始时连通分量数为 $n$，每成功进行一次合并操作，连通分量数就会减少 $1$。

```C++ [sol2-C++]
// 并查集模板
class UnionFind {
public:
    vector<int> parent;
    vector<int> size;
    int n;
    // 当前连通分量数目
    int setCount;
    
public:
    UnionFind(int _n): n(_n), setCount(_n), parent(_n), size(_n, 1) {
        iota(parent.begin(), parent.end(), 0);
    }
    
    int findset(int x) {
        return parent[x] == x ? x : parent[x] = findset(parent[x]);
    }
    
    bool unite(int x, int y) {
        x = findset(x);
        y = findset(y);
        if (x == y) {
            return false;
        }
        if (size[x] < size[y]) {
            swap(x, y);
        }
        parent[y] = x;
        size[x] += size[y];
        --setCount;
        return true;
    }
    
    bool connected(int x, int y) {
        x = findset(x);
        y = findset(y);
        return x == y;
    }
};

class Solution {
public:
    int makeConnected(int n, vector<vector<int>>& connections) {
        if (connections.size() < n - 1) {
            return -1;
        }

        UnionFind uf(n);
        for (const auto& conn: connections) {
            uf.unite(conn[0], conn[1]);
        }

        return uf.setCount - 1;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int makeConnected(int n, int[][] connections) {
        if (connections.length < n - 1) {
            return -1;
        }

        UnionFind uf = new UnionFind(n);
        for (int[] conn : connections) {
            uf.unite(conn[0], conn[1]);
        }

        return uf.setCount - 1;
    }
}

// 并查集模板
class UnionFind {
    int[] parent;
    int[] size;
    int n;
    // 当前连通分量数目
    int setCount;

    public UnionFind(int n) {
        this.n = n;
        this.setCount = n;
        this.parent = new int[n];
        this.size = new int[n];
        Arrays.fill(size, 1);
        for (int i = 0; i < n; ++i) {
            parent[i] = i;
        }
    }
    
    public int findset(int x) {
        return parent[x] == x ? x : (parent[x] = findset(parent[x]));
    }
    
    public boolean unite(int x, int y) {
        x = findset(x);
        y = findset(y);
        if (x == y) {
            return false;
        }
        if (size[x] < size[y]) {
            int temp = x;
            x = y;
            y = temp;
        }
        parent[y] = x;
        size[x] += size[y];
        --setCount;
        return true;
    }
    
    public boolean connected(int x, int y) {
        x = findset(x);
        y = findset(y);
        return x == y;
    }
}
```

```Python [sol2-Python3]
# 并查集模板
class UnionFind:
    def __init__(self, n: int):
        self.parent = list(range(n))
        self.size = [1] * n
        self.n = n
        # 当前连通分量数目
        self.setCount = n
    
    def findset(self, x: int) -> int:
        if self.parent[x] == x:
            return x
        self.parent[x] = self.findset(self.parent[x])
        return self.parent[x]
    
    def unite(self, x: int, y: int) -> bool:
        x, y = self.findset(x), self.findset(y)
        if x == y:
            return False
        if self.size[x] < self.size[y]:
            x, y = y, x
        self.parent[y] = x
        self.size[x] += self.size[y]
        self.setCount -= 1
        return True
    
    def connected(self, x: int, y: int) -> bool:
        x, y = self.findset(x), self.findset(y)
        return x == y

class Solution:
    def makeConnected(self, n: int, connections: List[List[int]]) -> int:
        if len(connections) < n - 1:
            return -1
        
        uf = UnionFind(n)
        for x, y in connections:
            uf.unite(x, y)
        
        return uf.setCount - 1
```

```JavaScript [sol2-JavaScript]
var makeConnected = function(n, connections) {
    if (connections.length < n - 1) {
        return -1;
    }

    const uf = new UnionFind(n);
    for (const conn of connections) {
        uf.unite(conn[0], conn[1]);
    }

    return uf.setCount - 1;
};

// 并查集模板
class UnionFind {
    constructor (n) {
        this.parent = new Array(n).fill(0).map((element, index) => index);
        this.size = new Array(n).fill(1);
        // 当前连通分量数目
        this.setCount = n;
    }

    findset (x) {
        if (this.parent[x] === x) {
            return x;
        }
        this.parent[x] = this.findset(this.parent[x]);
        return this.parent[x];
    }

    unite (a, b) {
        let x = this.findset(a), y = this.findset(b);
        if (x === y) {
            return false;
        }
        if (this.size[x] < this.size[y]) {
            [x, y] = [y, x];
        }
        this.parent[y] = x;
        this.size[x] += this.size[y];
        this.setCount -= 1;
        return true;
    }

    connected (a, b) {
        const x = this.findset(a), y = this.findset(b);
        return x === y;
    }
}
```

```go [sol2-Golang]
type unionFind struct {
    parent, size []int
    setCount     int // 当前连通分量数目
}

func newUnionFind(n int) *unionFind {
    parent := make([]int, n)
    size := make([]int, n)
    for i := range parent {
        parent[i] = i
        size[i] = 1
    }
    return &unionFind{parent, size, n}
}

func (uf *unionFind) find(x int) int {
    if uf.parent[x] != x {
        uf.parent[x] = uf.find(uf.parent[x])
    }
    return uf.parent[x]
}

func (uf *unionFind) union(x, y int) {
    fx, fy := uf.find(x), uf.find(y)
    if fx == fy {
        return
    }
    if uf.size[fx] < uf.size[fy] {
        fx, fy = fy, fx
    }
    uf.size[fx] += uf.size[fy]
    uf.parent[fy] = fx
    uf.setCount--
}

func makeConnected(n int, connections [][]int) int {
    if len(connections) < n-1 {
        return -1
    }

    uf := newUnionFind(n)
    for _, c := range connections {
        uf.union(c[0], c[1])
    }

    return uf.setCount - 1
}
```

```C [sol2-C]
void swap(int* a, int* b) {
    int tmp = *a;
    *a = *b, *b = tmp;
}

struct DisjointSetUnion {
    int *f, *size;
    int n, setCount;
};

void initDSU(struct DisjointSetUnion* obj, int n) {
    obj->f = malloc(sizeof(int) * n);
    obj->size = malloc(sizeof(int) * n);
    obj->n = n;
    obj->setCount = n;
    for (int i = 0; i < n; i++) {
        obj->f[i] = i;
        obj->size[i] = 1;
    }
}

int find(struct DisjointSetUnion* obj, int x) {
    return obj->f[x] == x ? x : (obj->f[x] = find(obj, obj->f[x]));
}

int unionSet(struct DisjointSetUnion* obj, int x, int y) {
    int fx = find(obj, x), fy = find(obj, y);
    if (fx == fy) {
        return false;
    }
    if (obj->size[fx] < obj->size[fy]) {
        swap(&fx, &fy);
    }
    obj->size[fx] += obj->size[fy];
    obj->f[fy] = fx;
    obj->setCount--;
    return true;
}

int makeConnected(int n, int** connections, int connectionsSize, int* connectionsColSize) {
    if (connectionsSize < n - 1) {
        return -1;
    }

    struct DisjointSetUnion* uf = malloc(sizeof(struct DisjointSetUnion));
    initDSU(uf, n);
    for (int i = 0; i < connectionsSize; i++) {
        unionSet(uf, connections[i][0], connections[i][1]);
    }

    return uf->setCount - 1;
}
```

**复杂度分析**

- 时间复杂度：$O(m \cdot \alpha(n))$，其中 $m$ 是数组 $\textit{connections}$ 的长度，$\alpha$ 是阿克曼函数的反函数。

- 空间复杂度：$O(n)$，即为并查集需要使用的空间。
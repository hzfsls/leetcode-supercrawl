## [1631.最小体力消耗路径 中文官方题解](https://leetcode.cn/problems/path-with-minimum-effort/solutions/100000/zui-xiao-ti-li-xiao-hao-lu-jing-by-leetc-3q2j)
#### 前言

我们可以将本题抽象成如下的一个图论模型：

- 我们将地图中的每一个格子看成图中的一个节点；

- 我么将两个相邻（左右相邻或者上下相邻）的两个格子对应的节点之间连接一条无向边，边的权值为这两个格子的高度差的绝对值；

- 我们需要找到一条从左上角到右下角的**最短**路径，其中一条路径的长度定义为其经过的所有边权的**最大值**。

由于地图是二维的，我们需要给每个格子对应的节点赋予一个唯一的节点编号。如果地图的行数为 $m$，列数为 $n$，那么位置为 $(i, j)$ 的格子对应的编号为 $i \times n + j$，这样 $,mn$ 个格子的编号一一对应着 $[0, mn)$ 范围内的所有整数。当然，如果读者使用的语言支持对二元组进行哈希计算、作为下标访问等，则不需要这一步操作。

本篇题解中会介绍三种不同的解决方法。

#### 方法一：二分查找

**思路与算法**

我们可以将这个问题转化成一个「判定性」问题，即：

> 是否存在一条从左上角到右下角的路径，其经过的所有边权的最大值不超过 $x$？

这个判定性问题解决起来并不复杂，我们只要从左上角开始进行深度优先搜索或者广度优先搜索，在搜索的过程中只允许经过边权不超过 $x$ 的边，搜索结束后判断是否能到达右下角即可。

随着 $x$ 的增大，原先可以经过的边仍然会被保留，因此如果当 $x=x_0$ 时，我们可以从左上角到达右下角，那么当 $x > x_0$ 时同样也可以可行的。因此我们可以使用二分查找的方法，找出满足要求的最小的那个 $x$ 值，记为 $x_\textit{ans}$，那么：

- 当 $x < x_\textit{ans}$，我们无法从左上角到达右下角；

- 当 $x \geq x_\textit{ans}$，我们可以从左上角到达右下角。

由于格子的高度范围为 $[1, 10^6]$，因此我们可以 $[0, 10^6-1]$ 的范围内对 $x$ 进行二分查找。在每一步查找的过程中，我们使用进行深度优先搜索或者广度优先搜索判断是否可以从左上角到达右下角，并根据判定结果更新二分查找的左边界或右边界即可。

**代码**

下面的代码中使用的是广度优先搜索。

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    
public:
    int minimumEffortPath(vector<vector<int>>& heights) {
        int m = heights.size();
        int n = heights[0].size();
        int left = 0, right = 999999, ans = 0;
        while (left <= right) {
            int mid = (left + right) / 2;
            queue<pair<int, int>> q;
            q.emplace(0, 0);
            vector<int> seen(m * n);
            seen[0] = 1;
            while (!q.empty()) {
                auto [x, y] = q.front();
                q.pop();
                for (int i = 0; i < 4; ++i) {
                    int nx = x + dirs[i][0];
                    int ny = y + dirs[i][1];
                    if (nx >= 0 && nx < m && ny >= 0 && ny < n && !seen[nx * n + ny] && abs(heights[x][y] - heights[nx][ny]) <= mid) {
                        q.emplace(nx, ny);
                        seen[nx * n + ny] = 1;
                    }
                }
            }
            if (seen[m * n - 1]) {
                ans = mid;
                right = mid - 1;
            }
            else {
                left = mid + 1;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    int[][] dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

    public int minimumEffortPath(int[][] heights) {
        int m = heights.length;
        int n = heights[0].length;
        int left = 0, right = 999999, ans = 0;
        while (left <= right) {
            int mid = (left + right) / 2;
            Queue<int[]> queue = new LinkedList<int[]>();
            queue.offer(new int[]{0, 0});
            boolean[] seen = new boolean[m * n];
            seen[0] = true;
            while (!queue.isEmpty()) {
                int[] cell = queue.poll();
                int x = cell[0], y = cell[1];
                for (int i = 0; i < 4; ++i) {
                    int nx = x + dirs[i][0];
                    int ny = y + dirs[i][1];
                    if (nx >= 0 && nx < m && ny >= 0 && ny < n && !seen[nx * n + ny] && Math.abs(heights[x][y] - heights[nx][ny]) <= mid) {
                        queue.offer(new int[]{nx, ny});
                        seen[nx * n + ny] = true;
                    }
                }
            }
            if (seen[m * n - 1]) {
                ans = mid;
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minimumEffortPath(self, heights: List[List[int]]) -> int:
        m, n = len(heights), len(heights[0])
        left, right, ans = 0, 10**6 - 1, 0

        while left <= right:
            mid = (left + right) // 2
            q = collections.deque([(0, 0)])
            seen = {(0, 0)}
            
            while q:
                x, y = q.popleft()
                for nx, ny in [(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]:
                    if 0 <= nx < m and 0 <= ny < n and (nx, ny) not in seen and abs(heights[x][y] - heights[nx][ny]) <= mid:
                        q.append((nx, ny))
                        seen.add((nx, ny))
            
            if (m - 1, n - 1) in seen:
                ans = mid
                right = mid - 1
            else:
                left = mid + 1
        
        return ans
```

```JavaScript [sol1-JavaScript]
var minimumEffortPath = function(heights) {
    const dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]];

    const m = heights.length, n = heights[0].length;
    let left = 0, right = 999999, ans = 0;
    while (left <= right) {
        const mid = Math.floor((left + right) / 2);
        const queue = [[0, 0]];
        const seen = new Array(m * n).fill(0);
        seen[0] = 1;
        while (queue.length) {
            const [x, y] = queue.shift();
            for (let i = 0; i < 4; i++) {
                const nx = x + dirs[i][0];
                const ny = y + dirs[i][1];
                if (nx >= 0 && nx < m && ny >= 0 && ny < n && !seen[nx * n + ny] && Math.abs(heights[x][y] - heights[nx][ny]) <= mid) {
                    queue.push([nx, ny]);
                    seen[nx * n + ny] = 1;
                }
            }
        }
        if (seen[m * n - 1]) {
            ans = mid;
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return ans;
};
```

```go [sol1-Golang]
type pair struct{ x, y int }
var dirs = []pair{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func minimumEffortPath(heights [][]int) int {
    n, m := len(heights), len(heights[0])
    return sort.Search(1e6, func(maxHeightDiff int) bool {
        vis := make([][]bool, n)
        for i := range vis {
            vis[i] = make([]bool, m)
        }
        vis[0][0] = true
        queue := []pair{{}}
        for len(queue) > 0 {
            p := queue[0]
            queue = queue[1:]
            if p.x == n-1 && p.y == m-1 {
                return true
            }
            for _, d := range dirs {
                x, y := p.x+d.x, p.y+d.y
                if 0 <= x && x < n && 0 <= y && y < m && !vis[x][y] && abs(heights[x][y]-heights[p.x][p.y]) <= maxHeightDiff {
                    vis[x][y] = true
                    queue = append(queue, pair{x, y})
                }
            }
        }
        return false
    })
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

```C [sol1-C]
int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

int minimumEffortPath(int** heights, int heightsSize, int* heightsColSize) {
    int m = heightsSize;
    int n = heightsColSize[0];
    int left = 0, right = 999999, ans = 0;
    while (left <= right) {
        int mid = (left + right) / 2;
        int q[n * m][2];
        int qleft = 0, qright = 0;
        q[qright][0] = 0, q[qright++][1] = 0;
        int seen[m * n];
        memset(seen, 0, sizeof(seen));
        seen[0] = 1;
        while (qleft < qright) {
            int x = q[qleft][0], y = q[qleft++][1];
            for (int i = 0; i < 4; ++i) {
                int nx = x + dirs[i][0];
                int ny = y + dirs[i][1];
                if (nx >= 0 && nx < m && ny >= 0 && ny < n && !seen[nx * n + ny] && abs(heights[x][y] - heights[nx][ny]) <= mid) {
                    q[qright][0] = nx, q[qright++][1] = ny;
                    seen[nx * n + ny] = 1;
                }
            }
        }
        if (seen[m * n - 1]) {
            ans = mid;
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(mn \log C)$，其中 $m$ 和 $n$ 分别是地图的行数和列数，$C$ 是格子的最大高度，在本题中 $C$ 不超过 $10^6$。我们需要进行 $O(\log C)$ 次二分查找，每一步查找的过程中需要使用广度优先搜索，在 $O(mn)$ 的时间判断是否可以从左上角到达右下角，因此总时间复杂度为 $O(mn \log C)$。

- 空间复杂度：$O(mn)$，即为广度优先搜索中使用的队列需要的空间。

#### 方法二：并查集

**思路与算法**

我们将这 $mn$ 个节点放入并查集中，实时维护它们的连通性。

由于我们需要找到从左上角到右下角的最短路径，因此我们可以将图中的所有边按照权值从小到大进行排序，并依次加入并查集中。当我们加入一条权值为 $x$ 的边之后，如果左上角和右下角从非连通状态变为连通状态，那么 $x$ 即为答案。

**代码**

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
    int minimumEffortPath(vector<vector<int>>& heights) {
        int m = heights.size();
        int n = heights[0].size();
        vector<tuple<int, int, int>> edges;
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                int id = i * n + j;
                if (i > 0) {
                    edges.emplace_back(id - n, id, abs(heights[i][j] - heights[i - 1][j]));
                }
                if (j > 0) {
                    edges.emplace_back(id - 1, id, abs(heights[i][j] - heights[i][j - 1]));
                }
            }
        }
        sort(edges.begin(), edges.end(), [](const auto& e1, const auto& e2) {
            auto&& [x1, y1, v1] = e1;
            auto&& [x2, y2, v2] = e2;
            return v1 < v2;
        });

        UnionFind uf(m * n);
        int ans = 0;
        for (const auto [x, y, v]: edges) {
            uf.unite(x, y);
            if (uf.connected(0, m * n - 1)) {
                ans = v;
                break;
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int minimumEffortPath(int[][] heights) {
        int m = heights.length;
        int n = heights[0].length;
        List<int[]> edges = new ArrayList<int[]>();
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                int id = i * n + j;
                if (i > 0) {
                    edges.add(new int[]{id - n, id, Math.abs(heights[i][j] - heights[i - 1][j])});
                }
                if (j > 0) {
                    edges.add(new int[]{id - 1, id, Math.abs(heights[i][j] - heights[i][j - 1])});
                }
            }
        }
        Collections.sort(edges, new Comparator<int[]>() {
            public int compare(int[] edge1, int[] edge2) {
                return edge1[2] - edge2[2];
            }
        });

        UnionFind uf = new UnionFind(m * n);
        int ans = 0;
        for (int[] edge : edges) {
            int x = edge[0], y = edge[1], v = edge[2];
            uf.unite(x, y);
            if (uf.connected(0, m * n - 1)) {
                ans = v;
                break;
            }
        }
        return ans;
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
    def minimumEffortPath(self, heights: List[List[int]]) -> int:
        m, n = len(heights), len(heights[0])
        edges = list()
        for i in range(m):
            for j in range(n):
                iden = i * n + j
                if i > 0:
                    edges.append((iden - n, iden, abs(heights[i][j] - heights[i - 1][j])))
                if j > 0:
                    edges.append((iden - 1, iden, abs(heights[i][j] - heights[i][j - 1])))
        
        edges.sort(key=lambda e: e[2])

        uf = UnionFind(m * n)
        ans = 0
        for x, y, v in edges:
            uf.unite(x, y)
            if uf.connected(0, m * n - 1):
                ans = v
                break
        
        return ans
```

```JavaScript [sol2-JavaScript]
var minimumEffortPath = function(heights) {
    const m = heights.length;
    const n = heights[0].length;
    const edges = [];
    for (let i = 0; i < m; ++i) {
        for (let j = 0; j < n; ++j) {
            const id = i * n + j;
            if (i > 0) {
                edges.push([id - n, id, Math.abs(heights[i][j] - heights[i - 1][j])]);
            }
            if (j > 0) {
                edges.push([id - 1, id, Math.abs(heights[i][j] - heights[i][j - 1])]);
            }
        }
    }
    edges.sort((a, b) => a[2] - b[2]);

    const uf = new UnionFind(m * n);
    let ans = 0;
    for (const edge of edges) {
        const x = edge[0], y = edge[1], v = edge[2];
        uf.unite(x, y);
        if (uf.connected(0, m * n - 1)) {
            ans = v;
            break;
        }
    }
    return ans;
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
}

func newUnionFind(n int) *unionFind {
    parent := make([]int, n)
    size := make([]int, n)
    for i := range parent {
        parent[i] = i
        size[i] = 1
    }
    return &unionFind{parent, size}
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
}

func (uf *unionFind) inSameSet(x, y int) bool {
    return uf.find(x) == uf.find(y)
}

type edge struct {
    v, w, diff int
}

func minimumEffortPath(heights [][]int) int {
    n, m := len(heights), len(heights[0])
    edges := []edge{}
    for i, row := range heights {
        for j, h := range row {
            id := i*m + j
            if i > 0 {
                edges = append(edges, edge{id - m, id, abs(h - heights[i-1][j])})
            }
            if j > 0 {
                edges = append(edges, edge{id - 1, id, abs(h - heights[i][j-1])})
            }
        }
    }
    sort.Slice(edges, func(i, j int) bool { return edges[i].diff < edges[j].diff })

    uf := newUnionFind(n * m)
    for _, e := range edges {
        uf.union(e.v, e.w)
        if uf.inSameSet(0, n*m-1) {
            return e.diff
        }
    }
    return 0
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
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

int connected(struct DisjointSetUnion* obj, int x, int y) {
    return find(obj, x) == find(obj, y);
}

struct Tuple {
    int x, y, z
};

int cmp(const struct Tuple* a, const struct Tuple* b) {
    return a->z - b->z;
}

int minimumEffortPath(int** heights, int heightsSize, int* heightsColSize) {
    int m = heightsSize;
    int n = heightsColSize[0];
    struct Tuple edges[n * m * 2];
    int edgesSize = 0;
    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < n; ++j) {
            int id = i * n + j;
            if (i > 0) {
                edges[edgesSize].x = id - n;
                edges[edgesSize].y = id;
                edges[edgesSize++].z = fabs(heights[i][j] - heights[i - 1][j]);
            }
            if (j > 0) {
                edges[edgesSize].x = id - 1;
                edges[edgesSize].y = id;
                edges[edgesSize++].z = fabs(heights[i][j] - heights[i][j - 1]);
            }
        }
    }
    qsort(edges, edgesSize, sizeof(struct Tuple), cmp);

    struct DisjointSetUnion* uf = malloc(sizeof(struct DisjointSetUnion));
    initDSU(uf, m * n);
    int ans = 0;
    for (int i = 0; i < edgesSize; i++) {
        unionSet(uf, edges[i].x, edges[i].y);
        if (connected(uf, 0, m * n - 1)) {
            ans = edges[i].z;
            break;
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(mn \log(mn))$，其中 $m$ 和 $n$ 分别是地图的行数和列数。图中的边数为 $O(mn)$，因此排序的时间复杂度为 $O(mn \log (mn))$。并查集的时间复杂度为 $O(mn \cdot \alpha(mn))$，其中 $\alpha$ 为阿克曼函数的反函数。由于后者在渐进意义下小于前者，因此总时间复杂度为 $O(mn \log(mn))$。

- 空间复杂度：$O(mn)$，即为存储所有边以及并查集需要的空间。

#### 方法三：最短路

**思路与算法**

「最短路径」使得我们很容易想到求解最短路径的 $\texttt{Dijkstra}$ 算法，然而本题中对于「最短路径」的定义不是其经过的所有边权的和，而是其经过的所有边权的**最大值**，那么我们还可以用 $\texttt{Dijkstra}$ 算法进行求解吗？

答案是可以的。$\texttt{Dijkstra}$ 算法本质上是一种启发式搜索算法，它是 $\texttt{A*}$ 算法在启发函数 $h \equiv 0$ 时的特殊情况。读者可以参考 [A* search algorithm](https://en.wikipedia.org/wiki/A*_search_algorithm)，[Consistent heuristic](https://en.wikipedia.org/wiki/Consistent_heuristic)，[Admissible heuristic](https://en.wikipedia.org/wiki/Admissible_heuristic) 深入了解 $\texttt{Dijkstra}$ 算法的本质。

下面给出 $\texttt{Dijkstra}$ 算法的可行性证明，需要读者对 $\texttt{A*}$ 算法以及其可行性条件有一定的掌握。

**证明**

定义加法运算 $a \oplus b = \max (a,b)$，显然 $\oplus$ 满足交换律和结合律。那么如果一条路径上的边权分别为 $e_0, e_1, \cdots, e_k$，那么 $e_0 \oplus e_1 \oplus \cdots \oplus e_k$ 即为这条路径的长度。

在 $\texttt{Dijkstra}$ 算法中 $h \equiv 0$，对于图中任意的无向边 $x \leftrightarrow y$，由于 $e_{x, y} \geq 0$，那么 $h(x)=0\leq e_{x,y} \oplus h(y)$ 恒成立，其中 $e_{x, y}$ 表示边权。因此启发函数 $h$ 和加法运算 $\oplus$ 满足三角不等式，是 consistent heuristic 的，可以使用 $\texttt{Dijkstra}$ 算法求出最短路径。

**代码**

```C++ [sol3-C++]
class Solution {
private:
    static constexpr int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    
public:
    int minimumEffortPath(vector<vector<int>>& heights) {
        int m = heights.size();
        int n = heights[0].size();
        
        auto tupleCmp = [](const auto& e1, const auto& e2) {
            auto&& [x1, y1, d1] = e1;
            auto&& [x2, y2, d2] = e2;
            return d1 > d2;
        };
        priority_queue<tuple<int, int, int>, vector<tuple<int, int, int>>, decltype(tupleCmp)> q(tupleCmp);
        q.emplace(0, 0, 0);

        vector<int> dist(m * n, INT_MAX);
        dist[0] = 0;
        vector<int> seen(m * n);

        while (!q.empty()) {
            auto [x, y, d] = q.top();
            q.pop();
            int id = x * n + y;
            if (seen[id]) {
                continue;
            }
            if (x == m - 1 && y == n - 1) {
                break;
            }
            seen[id] = 1;
            for (int i = 0; i < 4; ++i) {
                int nx = x + dirs[i][0];
                int ny = y + dirs[i][1];
                if (nx >= 0 && nx < m && ny >= 0 && ny < n && max(d, abs(heights[x][y] - heights[nx][ny])) < dist[nx * n + ny]) {
                    dist[nx * n + ny] = max(d, abs(heights[x][y] - heights[nx][ny]));
                    q.emplace(nx, ny, dist[nx * n + ny]);
                }
            }
        }
        
        return dist[m * n - 1];
    }
};
```

```Java [sol3-Java]
class Solution {
    int[][] dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

    public int minimumEffortPath(int[][] heights) {
        int m = heights.length;
        int n = heights[0].length;
        PriorityQueue<int[]> pq = new PriorityQueue<int[]>(new Comparator<int[]>() {
            public int compare(int[] edge1, int[] edge2) {
                return edge1[2] - edge2[2];
            }
        });
        pq.offer(new int[]{0, 0, 0});

        int[] dist = new int[m * n];
        Arrays.fill(dist, Integer.MAX_VALUE);
        dist[0] = 0;
        boolean[] seen = new boolean[m * n];

        while (!pq.isEmpty()) {
            int[] edge = pq.poll();
            int x = edge[0], y = edge[1], d = edge[2];
            int id = x * n + y;
            if (seen[id]) {
                continue;
            }
            if (x == m - 1 && y == n - 1) {
                break;
            }
            seen[id] = true;
            for (int i = 0; i < 4; ++i) {
                int nx = x + dirs[i][0];
                int ny = y + dirs[i][1];
                if (nx >= 0 && nx < m && ny >= 0 && ny < n && Math.max(d, Math.abs(heights[x][y] - heights[nx][ny])) < dist[nx * n + ny]) {
                    dist[nx * n + ny] = Math.max(d, Math.abs(heights[x][y] - heights[nx][ny]));
                    pq.offer(new int[]{nx, ny, dist[nx * n + ny]});
                }
            }
        }
        
        return dist[m * n - 1];
    }
}
```

```Python [sol3-Python3]
class Solution:
    def minimumEffortPath(self, heights: List[List[int]]) -> int:
        m, n = len(heights), len(heights[0])
        q = [(0, 0, 0)]
        dist = [0] + [float("inf")] * (m * n - 1)
        seen = set()

        while q:
            d, x, y = heapq.heappop(q)
            iden = x * n + y
            if iden in seen:
                continue
            if (x, y) == (m - 1, n - 1):
                break
            
            seen.add(iden)
            for nx, ny in [(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]:
                if 0 <= nx < m and 0 <= ny < n and max(d, abs(heights[x][y] - heights[nx][ny])) <= dist[nx * n + ny]:
                    dist[nx * n + ny] = max(d, abs(heights[x][y] - heights[nx][ny]))
                    heapq.heappush(q, (dist[nx * n + ny], nx, ny))
        
        return dist[m * n - 1]
```

```go [sol3-Golang]
type point struct{ x, y, maxDiff int }
type hp []point
func (h hp) Len() int              { return len(h) }
func (h hp) Less(i, j int) bool    { return h[i].maxDiff < h[j].maxDiff }
func (h hp) Swap(i, j int)         { h[i], h[j] = h[j], h[i] }
func (h *hp) Push(v interface{})   { *h = append(*h, v.(point)) }
func (h *hp) Pop() (v interface{}) { a := *h; *h, v = a[:len(a)-1], a[len(a)-1]; return }

type pair struct{ x, y int }
var dir4 = []pair{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func minimumEffortPath(heights [][]int) int {
    n, m := len(heights), len(heights[0])
    maxDiff := make([][]int, n)
    for i := range maxDiff {
        maxDiff[i] = make([]int, m)
        for j := range maxDiff[i] {
            maxDiff[i][j] = math.MaxInt64
        }
    }
    maxDiff[0][0] = 0
    h := &hp{{}}
    for {
        p := heap.Pop(h).(point)
        if p.x == n-1 && p.y == m-1 {
            return p.maxDiff
        }
        if maxDiff[p.x][p.y] < p.maxDiff {
            continue
        }
        for _, d := range dir4 {
            if x, y := p.x+d.x, p.y+d.y; 0 <= x && x < n && 0 <= y && y < m {
                if diff := max(p.maxDiff, abs(heights[x][y]-heights[p.x][p.y])); diff < maxDiff[x][y] {
                    maxDiff[x][y] = diff
                    heap.Push(h, point{x, y, diff})
                }
            }
        }
    }
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

**复杂度分析**

- 时间复杂度：$O(mn \log(mn))$，其中 $m$ 和 $n$ 分别是地图的行数和列数。对于节点数为 $n_0$，边数为 $m_0$ 的图，使用优先队列优化的 $\texttt{Dijkstra}$ 算法的时间复杂度为 $O(m_0 \log m_0)$。由于图中的边数为 $O(mn)$，带入即可得到时间复杂度 $O(mn \log(mn))$。

- 空间复杂度：$O(mn)$，即为 $\texttt{Dijkstra}$ 算法需要使用的空间。
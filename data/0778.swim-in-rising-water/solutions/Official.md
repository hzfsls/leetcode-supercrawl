#### 方法一：堆（优先队列）

根据题意，假设在时间 $t$ 时能够到达方格 $(i,j)$，那么对于一个与之相邻的方格 $(i',j')$：
- 如果 $\textit{grid}[i'][j'] \le \textit{grid}[i][j]$，说明 $(i',j')$ 处的高度更低，故在时间 $t$ 也能够到达 $(i',j')$；
- 否则，若 $\textit{grid}[i'][j'] > \textit{grid}[i][j]$，则需要至少等到 $\textit{grid}[i'][j']$ 时刻才能够到达 $(i',j')$。

因此，我们从原点出发，每一步试图多访问一个方格，并记录访问到该方格的最短时间。当进行下一步时，考虑从已访问方格能到达的所有方格，并选择其中高度最低的那个方格进行下一次访问。这一迭代的步骤类似于利用 $\text{Dijkstra}$ 算法求解最短路径的过程。

为了维护从已访问方格能到达的所有方格，并能从中取出最小值，我们使用堆（优先队列）来维护这些信息。

```C++ [sol1-C++]
// 优先队列中的数据结构。其中 (i,j) 代表坐标，val 代表水位。
struct Entry {
    int i;
    int j;
    int val;
    bool operator<(const Entry& other) const {
        return this->val > other.val;
    }
    Entry(int ii, int jj, int val): i(ii), j(jj), val(val) {}
};

class Solution {
public:
    int swimInWater(vector<vector<int>>& grid) {
        int n = grid.size();
        priority_queue<Entry, vector<Entry>, function<bool(const Entry& x, const Entry& other)>> pq(&Entry::operator<);
        vector<vector<int>> visited(n, vector<int>(n, 0));

        pq.push(Entry(0, 0, grid[0][0]));
        int ret = 0;
        vector<pair<int, int>> directions{{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
        while (!pq.empty()) {
            Entry x = pq.top();
            pq.pop();
            if (visited[x.i][x.j] == 1) {
                continue;
            }
            
            visited[x.i][x.j] = 1;
            ret = max(ret, grid[x.i][x.j]);
            if (x.i == n - 1 && x.j == n - 1) {
                break;
            }

            for (const auto [di, dj]: directions) {
                int ni = x.i + di, nj = x.j + dj;
                if (ni >= 0 && ni < n && nj >= 0 && nj < n) {
                    if (visited[ni][nj] == 0) {
                        pq.push(Entry(ni, nj, grid[ni][nj]));
                    }
                }
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int swimInWater(int[][] grid) {
        int n = grid.length;
        PriorityQueue<Entry> pq = new PriorityQueue<Entry>(new Comparator<Entry>() {
            public int compare(Entry entry1, Entry entry2) {
                return entry1.val - entry2.val;
            }
        });
        boolean[][] visited = new boolean[n][n];

        pq.offer(new Entry(0, 0, grid[0][0]));
        int ret = 0;
        int[][] directions = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
        while (!pq.isEmpty()) {
            Entry x = pq.poll();
            if (visited[x.i][x.j]) {
                continue;
            }
            
            visited[x.i][x.j] = true;
            ret = Math.max(ret, grid[x.i][x.j]);
            if (x.i == n - 1 && x.j == n - 1) {
                break;
            }

            for (int[] direction : directions) {
                int ni = x.i + direction[0], nj = x.j + direction[1];
                if (ni >= 0 && ni < n && nj >= 0 && nj < n) {
                    if (!visited[ni][nj]) {
                        pq.offer(new Entry(ni, nj, grid[ni][nj]));
                    }
                }
            }
        }
        return ret;
    }
}

// 优先队列中的数据结构。其中 (i,j) 代表坐标，val 代表水位。
class Entry {
    int i;
    int j;
    int val;

    public Entry(int i, int j, int val) {
        this.i = i;
        this.j = j;
        this.val = val;
    }
};
```

```go [sol1-Golang]
type entry struct{ i, j, val int }
type hp []entry

func (h hp) Len() int            { return len(h) }
func (h hp) Less(i, j int) bool  { return h[i].val < h[j].val }
func (h hp) Swap(i, j int)       { h[i], h[j] = h[j], h[i] }
func (h *hp) Push(v interface{}) { *h = append(*h, v.(entry)) }
func (h *hp) Pop() interface{}   { a := *h; v := a[len(a)-1]; *h = a[:len(a)-1]; return v }

type pair struct{ x, y int }
var dirs = []pair{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func swimInWater(grid [][]int) (ans int) {
    n := len(grid)
    vis := make([][]bool, n)
    for i := range vis {
        vis[i] = make([]bool, n)
    }
    vis[0][0] = true
    h := &hp{{0, 0, grid[0][0]}}
    for {
        e := heap.Pop(h).(entry)
        ans = max(ans, e.val)
        if e.i == n-1 && e.j == n-1 {
            return
        }
        for _, d := range dirs {
            if x, y := e.i+d.x, e.j+d.y; 0 <= x && x < n && 0 <= y && y < n && !vis[x][y] {
                vis[x][y] = true
                heap.Push(h, entry{x, y, grid[x][y]})
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
```

**复杂度分析**

- 时间复杂度：$O(n^2\log n)$，其中 $n$ 为网格的边长。每个方格至多会被加入优先队列 $4$ 次，故循环执行次数为 $O(4n^2)=O(n^2)$，同时每次循环要从至多 $O(n^2)$ 的位置中取最小值，故单次循环的代价为 $O(\log n^2)=O(2\log n)=O(\log n)$。

- 空间复杂度：$O(n^2)$。

#### 方法二：二分查找

考虑这样一个问题：给定一个整数 $\textit{threshold}$，是否存在一个路径，使得能在 $\textit{threshold}$ 时间内从起点到达终点？

这一问题的解法是很直观的：我们执行广度优先搜索，并只去访问那些高度不超过 $\textit{threshold}$ 的方格。最终，如果能访问到终点，说明存在这样一种路径。

如果能在 $\textit{threshold}$ 时间内从起点到达终点，则一定也能在 $\textit{threshold}+1$ 的时间内从起点到达终点。因此，我们可以通过二分查找的方式，寻找最小可能的 $\textit{threshold}$。

```C++ [sol2-C++]
class Solution {
public:
    bool check(vector<vector<int>>& grid, int threshold) {
        if (grid[0][0] > threshold) {
            return false;
        }
        int n = grid.size();
        vector<vector<int>> visited(n, vector<int>(n, 0));
        visited[0][0] = 1;
        queue<pair<int, int>> q;
        q.push(make_pair(0, 0));

        vector<pair<int, int>> directions{{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
        while (!q.empty()) {
            auto [i, j] = q.front();
            q.pop();

            for (const auto [di, dj]: directions) {
                int ni = i + di, nj = j + dj;
                if (ni >= 0 && ni < n && nj >= 0 && nj < n) {
                    if (visited[ni][nj] == 0 && grid[ni][nj] <= threshold) {
                        q.push(make_pair(ni, nj));
                        visited[ni][nj] = 1;
                    }
                }
            }
        }
        return visited[n - 1][n - 1] == 1;
    }

    int swimInWater(vector<vector<int>>& grid) {
        int n = grid.size();
        int left = 0, right = n * n - 1;
        while (left < right) {
            int mid = (left + right) / 2;
            if (check(grid, mid)) {
                right = mid;
            } else {
                left = mid + 1;
            }
        } 
        return left;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int swimInWater(int[][] grid) {
        int n = grid.length;
        int left = 0, right = n * n - 1;
        while (left < right) {
            int mid = (left + right) / 2;
            if (check(grid, mid)) {
                right = mid;
            } else {
                left = mid + 1;
            }
        } 
        return left;
    }

    public boolean check(int[][] grid, int threshold) {
        if (grid[0][0] > threshold) {
            return false;
        }
        int n = grid.length;
        boolean[][] visited = new boolean[n][n];
        visited[0][0] = true;
        Queue<int[]> queue = new LinkedList<int[]>();
        queue.offer(new int[]{0, 0});

        int[][] directions = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
        while (!queue.isEmpty()) {
            int[] square = queue.poll();
            int i = square[0], j = square[1];

            for (int[] direction : directions) {
                int ni = i + direction[0], nj = j + direction[1];
                if (ni >= 0 && ni < n && nj >= 0 && nj < n) {
                    if (!visited[ni][nj] && grid[ni][nj] <= threshold) {
                        queue.offer(new int[]{ni, nj});
                        visited[ni][nj] = true;
                    }
                }
            }
        }
        return visited[n - 1][n - 1];
    }
}
```

```go [sol2-Golang]
type pair struct{ x, y int }
var dirs = []pair{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func swimInWater(grid [][]int) (ans int) {
    n := len(grid)
    return sort.Search(n*n-1, func(threshold int) bool {
        if threshold < grid[0][0] {
            return false
        }
        vis := make([][]bool, n)
        for i := range vis {
            vis[i] = make([]bool, n)
        }
        vis[0][0] = true
        queue := []pair{{}}
        for len(queue) > 0 {
            p := queue[0]
            queue = queue[1:]
            for _, d := range dirs {
                if x, y := p.x+d.x, p.y+d.y; 0 <= x && x < n && 0 <= y && y < n && !vis[x][y] && grid[x][y] <= threshold {
                    vis[x][y] = true
                    queue = append(queue, pair{x, y})
                }
            }
        }
        return vis[n-1][n-1]
    })
}
```

```C [sol2-C]
int directions[4][2] = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};

bool check(int** grid, int gridSize, int threshold) {
    if (grid[0][0] > threshold) {
        return false;
    }
    int visited[gridSize][gridSize];
    memset(visited, 0, sizeof(visited));
    visited[0][0] = 1;
    int q[gridSize * gridSize][2];
    int left = 0, right = 0;
    q[right][0] = 0, q[right++][1] = 0;

    while (left < right) {
        int i = q[left][0], j = q[left++][1];

        for (int k = 0; k < 4; k++) {
            int ni = i + directions[k][0], nj = j + directions[k][1];
            if (ni >= 0 && ni < gridSize && nj >= 0 && nj < gridSize) {
                if (visited[ni][nj] == 0 && grid[ni][nj] <= threshold) {
                    q[right][0] = ni, q[right++][1] = nj;
                    visited[ni][nj] = 1;
                }
            }
        }
    }
    return visited[gridSize - 1][gridSize - 1] == 1;
}

int swimInWater(int** grid, int gridSize, int* gridColSize) {
    int left = 0, right = gridSize * gridSize - 1;
    while (left < right) {
        int mid = (left + right) >> 1;
        if (check(grid, gridSize, mid)) {
            right = mid;
        } else {
            left = mid + 1;
        }
    }
    return left;
}
```

```JavaScript [sol2-JavaScript]
var swimInWater = function(grid) {
    const n = grid.length;
    let left = 0, right = n * n - 1;
    while (left < right) {
        const mid = Math.floor((left + right) / 2);
        if (check(grid, mid)) {
            right = mid;
        } else {
            left = mid + 1;
        }
    }
    return left;
}

const check = (grid, threshold) => {
    if (grid[0][0] > threshold) {
        return false;
    }
    const n = grid.length;
    const visited = new Array(n).fill(0).map(() => new Array(n).fill(false));
    visited[0][0] = true;
    const queue = [[0, 0]];

    const directions = [[0, 1], [0, -1], [1, 0], [-1, 0]];
    while (queue.length) {
        const square = queue.shift();
        const i = square[0], j = square[1];

        for (const direction of directions) {
            const ni = i + direction[0], nj = j + direction[1];
            if (ni >= 0 && ni < n && nj >= 0 && nj < n) {
                if (!visited[ni][nj] && grid[ni][nj] <= threshold) {
                    queue.push([ni, nj]);
                    visited[ni][nj] = true;
                }
            }
        }
    }
    return visited[n - 1][n - 1];
}
```

**复杂度分析**

- 时间复杂度：$O(n^2\log n)$。对于任何一个给定的 $\textit{threshold}$ 而言，需要 $O(n^2)$ 的时间内执行广度优先搜索。同时，二分查找的上下边界分别为 $n^2-1$ 和 $0$，故二分查找的次数为 $O(\log n^2)=O(2\log n)=O(\log n)$。

- 空间复杂度：$O(n^2)$。

#### 方法三：并查集

依然考虑同样的问题：给定一个整数 $\textit{threshold}$，是否存在一个路径，使得能在 $\textit{threshold}$ 时间内从起点到达终点？

我们将每个方格看做图中的顶点。由于任意时刻都不能到达高度高于 $\textit{threshold}$ 的方格，因此对于两个相邻的方格而言，当且仅当它们的高度都不超过 $\textit{threshold}$ 时，才在这两个顶点之间连接一条边。因此，能否从起点到达终点，就等价于对应的顶点在图中是否连通。

为了判断是否连通，可以使用并查集来维护节点之间的连通关系。

我们当然也能通过二分查找的方式来找到最小可能的 $\textit{threshold}$。但是如果使用二分查找，每次判断 $\textit{threshold}$ 是否符合条件时，都要耗费大量的时间重新构建并查集，导致复杂度还不如前一种做法。

如果我们是从小到大依次考虑 $\textit{threshold}$，那么每次考虑一个新值时，只需要在上一个阶段的图中，添加几条新边而已，而无需重新构建整张图。

具体而言，我们维护每个高度值对应的方块位置，当考虑 $\textit{threshold}$ 时，我们首先找出对应的方块位置，然后对于每个与之相邻的方块，如果相邻的方块的高度值不超过 $\textit{threshold}$，就在两个方块之间连接一条边。当所有相邻方块都被考虑完毕时，再判断起点和终点是否连通。

```C++ [sol3-C++]
class Solution {
public:
    int find(vector<int>& f, int x) {
        if (f[x] == x) {
            return x;
        }
        int fa = find(f, f[x]);
        f[x] = fa;
        return fa;
    }

    void merge(vector<int>& f, int x, int y) {
        int fx = find(f, x), fy = find(f, y);
        f[fx] = fy;
    }

    int swimInWater(vector<vector<int>>& grid) {
        int n = grid.size();
        vector<int> f(n * n);
        for (int i = 0; i < n * n; i++) {
            f[i] = i;
        }

        vector<pair<int, int>> idx(n * n); // 存储每个平台高度对应的位置
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                idx[grid[i][j]] = make_pair(i, j);
            }
        }

        vector<pair<int, int>> directions{{0,1},{0,-1},{1,0},{-1,0}};
        for (int threshold = 0; threshold < n * n; threshold++) {
            auto [i, j] = idx[threshold];
            for (const auto [di, dj]: directions) {
                int ni = i + di, nj = j + dj;
                if (ni >= 0 && ni < n && nj >= 0 && nj < n && grid[ni][nj] <= threshold) {
                    merge(f, i * n + j, ni * n + nj);
                }
            }
            if (find(f, 0) == find(f, n * n - 1)) {
                return threshold;
            }
        }
        return -1; // cannot happen
    }
};
```

```Java [sol3-Java]
class Solution {
    public int swimInWater(int[][] grid) {
        int n = grid.length;
        int[] f = new int[n * n];
        for (int i = 0; i < n * n; i++) {
            f[i] = i;
        }

        int[][] idx = new int[n * n][2]; // 存储每个平台高度对应的位置
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                idx[grid[i][j]][0] = i;
                idx[grid[i][j]][1] = j;
            }
        }

        int[][] directions = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
        for (int threshold = 0; threshold < n * n; threshold++) {
            int i = idx[threshold][0], j = idx[threshold][1];
            for (int[] direction : directions) {
                int ni = i + direction[0], nj = j + direction[1];
                if (ni >= 0 && ni < n && nj >= 0 && nj < n && grid[ni][nj] <= threshold) {
                    merge(f, i * n + j, ni * n + nj);
                }
            }
            if (find(f, 0) == find(f, n * n - 1)) {
                return threshold;
            }
        }
        return -1; // cannot happen
    }

    public int find(int[] f, int x) {
        if (f[x] == x) {
            return x;
        }
        int fa = find(f, f[x]);
        f[x] = fa;
        return fa;
    }

    public void merge(int[] f, int x, int y) {
        int fx = find(f, x), fy = find(f, y);
        f[fx] = fy;
    }
}
```

```go [sol3-Golang]
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

type pair struct{ x, y int }
var dirs = []pair{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func swimInWater(grid [][]int) (ans int) {
    n := len(grid)
    pos := make([]pair, n*n)
    for i, row := range grid {
        for j, h := range row {
            pos[h] = pair{i, j} // 存储每个平台高度对应的位置
        }
    }

    uf := newUnionFind(n * n)
    for threshold := 0; ; threshold++ {
        p := pos[threshold]
        for _, d := range dirs {
            if x, y := p.x+d.x, p.y+d.y; 0 <= x && x < n && 0 <= y && y < n && grid[x][y] <= threshold {
                uf.union(x*n+y, p.x*n+p.y)
            }
        }
        if uf.inSameSet(0, n*n-1) {
            return threshold
        }
    }
}
```

```C [sol3-C]
int directions[4][2] = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};

int find(int* f, int x) {
    if (f[x] == x) {
        return x;
    }
    int fa = find(f, f[x]);
    f[x] = fa;
    return fa;
}

void merge(int* f, int x, int y) {
    int fx = find(f, x), fy = find(f, y);
    f[fx] = fy;
}

int swimInWater(int** grid, int gridSize, int* gridColSize) {
    int f[gridSize * gridSize];
    for (int i = 0; i < gridSize * gridSize; i++) {
        f[i] = i;
    }

    int idx[gridSize * gridSize][2];  // 存储每个平台高度对应的位置
    for (int i = 0; i < gridSize; i++) {
        for (int j = 0; j < gridSize; j++) {
            idx[grid[i][j]][0] = i;
            idx[grid[i][j]][1] = j;
        }
    }

    for (int threshold = 0; threshold < gridSize * gridSize; threshold++) {
        int i = idx[threshold][0], j = idx[threshold][1];
        for (int k = 0; k < 4; k++) {
            int ni = i + directions[k][0], nj = j + directions[k][1];
            if (ni >= 0 && ni < gridSize && nj >= 0 && nj < gridSize && grid[ni][nj] <= threshold) {
                merge(f, i * gridSize + j, ni * gridSize + nj);
            }
        }
        if (find(f, 0) == find(f, gridSize * gridSize - 1)) {
            return threshold;
        }
    }
    return -1;  // cannot happen
}
```

```JavaScript [sol3-JavaScript]
var swimInWater = function(grid) {
    const n = grid.length;
    const f = new Array(n * n).fill(0)
                              .map((element, index) => index);

    const idx = new Array(n * n).fill(0)
                                .map(() => new Array(2).fill(0));
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < n; j++) {
            idx[grid[i][j]][0] = i;
            idx[grid[i][j]][1] = j;
        }
    }

    const directions = [[0, 1], [0, -1], [1, 0], [-1, 0]];
    for (let threshold = 0; threshold < n * n; threshold++) {
        const i = idx[threshold][0], j = idx[threshold][1];
        for (const direction of directions) {
            const ni = i + direction[0], nj = j + direction[1];
            if (ni >= 0 && ni < n && nj >= 0 && nj < n && grid[ni][nj] <= threshold) {
                merge(f, i * n + j, ni * n + nj);
            }
        }
        if (find(f, 0) === find(f, n * n - 1)) {
            return threshold;
        }
    }
    return -1;
};

const find = (f, x) => {
    if (f[x] === x) {
        return x;
    }
    const fa = find(f, f[x]);
    f[x] = fa;
    return fa;
}

const merge = (f, x, y) => {
    const fx = find(f, x), fy = find(f, y);
    f[fx] = fy;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2\log n)$。外层循环至多执行 $O(n^2)$ 次，每次循环至多添加 $4$ 条边，而添加每条边的代价为 $O(\log n^2)=O(2\log n)=O(\log n)$，判断起点和终点是否连通的代价为 $O(\log n^2)=O(2\log n)=O(\log n)$。

- 空间复杂度：$O(n^2)$。
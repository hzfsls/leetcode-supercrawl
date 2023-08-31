## [803.打砖块 中文官方题解](https://leetcode.cn/problems/bricks-falling-when-hit/solutions/100000/da-zhuan-kuai-by-leetcode-solution-szrq)
#### 方法一：逆序思维 + 并查集

**思路**

我们可以将问题抽象成一张图。每个网格上的砖块为图中的一个节点；如果某个砖块的 $4$ 个相邻位置中的一个位置有另外的砖块，就在相应的两个节点之间添加一条边，以维护砖块之间的相邻关系。

根据题意，所有与网格顶部直接相邻的砖块都不会掉落。因此，可以抽象出一个特殊的节点 $X$：任何与网格顶部直接相邻的砖块对应的节点，都与 $X$ 有一条直接相邻的边。

当消除一个砖块时，相当于从图中直接移除掉对应的节点，以及所有与它相邻的边。如果在移除节点之后，某一节点 $p$ 不再与 $X$ 连通，则说明对应的砖块「掉落」。于是，任意时刻留在网格中的砖块数量，就等于图中与 $X$ 连通的节点数量。

第一眼看上去，读者不难想到利用并查集来维护节点的连通关系。然而，此问题的难点在于，并查集只能支持对两个连通分支的合并，而无法将一个连通分支拆成两个。

我们不妨**从后向前**考虑这一过程。初始时，图中具有多个独立的连通分支；每次操作会在网格中添加一个砖块，于是在图中添加一个新的节点以及对应的边。注意到这一操作可能会使得更多的节点与 $X$ 相连，这些多出来的节点数量，就为**从前向后**考虑问题时，该操作掉落的砖块数量。

**算法细节**

设矩阵为 $h$ 行 $w$ 列，则可以每个网格中的位置 $(i,j)$ 映射成整数 $i\cdot w + j$，并为特殊节点 $X$ 映射到整数 $h\cdot w$。

我们首先正序遍历 $\textit{hits}$ 数组，得到 $\textit{grid}$ 经一系列操作后得到的状态 $\textit{status}$，在 $\textit{status}$ 中将每个被消除的位置（即 $\textit{hits}$ 的每个元素代表的位置）的值设为 $0$，并根据 $\textit{status}$ 的砖块情况构建初始并查集。

随后，我们逆序遍历 $\textit{hits}$ 数组中的每一项：

- 如果该位置在 $\textit{grid}$ 数组的取值为 $0$，说明此次操作根本没有消除砖块，因此一定只消除了 $0$ 个砖块。

- 否则，此次操作添加了一个新砖块。于是，我们首先统计与 $X$ 相邻的节点数量 $\textit{prev}$；随后，在将新节点与新边添加到并查集后，统计此时与 $X$ 相邻的节点数量 $\textit{size}$。这就说明，该次操作消除的砖块数量为 $\max\{0, \textit{size}-\textit{prev}-1\}$（注意新添加的砖块本身不计入答案中）。最后，我们要更新网格的状态 $\textit{status}$。

上面的操作要求我们在并查集中实时维护与 $X$ 相邻的节点数目，因此在并查集的代码中，除了父亲数组 $f$ 外，还需要额外维护节点数量数组 $\textit{sz}$，其中数组 $\textit{sz}[i]$ 的取值**只有当 $i$ 为某个连通分支的祖先时才有效**，并代表着以 $i$ 为祖先的连通分支的节点数量。

每次在将两个**不同分支**的节点加入到并查集中时，需要同时更新 $\textit{sz}$ 中对应元素的取值。具体而言，在合并两个节点 $x,y$ 时，我们首先找出它们的祖先 $f_x,f_y$；随后，如果要令 $f[f_x]=f_y$，则也要同步更新 $\textit{sz}[f_y] += \textit{sz}[f_x]$。

最后，注意到题目描述中约定「所有 $(x_i, y_i)$ 互不相同」。稍加思考就会发现，如果去除这条约定，那么在逆序遍历时遇到 $\textit{hits}$ 数组中的某一项时，即使 $\textit{grid}$ 数组中对应位置的元素为 $1$，我们也无法添加新的节点和新的边，因为该位置可能会在此后（即正序考虑时的「此前」）才应当被添加到图中。

通过对这一问题的思考，读者应当能够对逆序思路有更加深刻的理解。

**代码**

```C++ [sol1-C++]
class UnionFind {
private:
    vector<int> f, sz;
public:
    UnionFind(int n): f(n), sz(n) {
        for (int i = 0; i < n; i++) {
            f[i] = i;
            sz[i] = 1;
        }
    }

    int find(int x) {
        if (f[x] == x) {
            return x;
        }
        int newf = find(f[x]);
        f[x] = newf;
        return f[x];
    }

    void merge(int x, int y) {
        int fx = find(x), fy = find(y);
        if (fx == fy) {
            return;
        }
        f[fx] = fy;
        sz[fy] += sz[fx];
    }

    int size(int x) {
        return sz[find(x)];
    }
};

class Solution {
public:
    vector<int> hitBricks(vector<vector<int>>& grid, vector<vector<int>>& hits) {
        int h = grid.size(), w = grid[0].size();
        
        UnionFind uf(h * w + 1);
        vector<vector<int>> status = grid;
        for (int i = 0; i < hits.size(); i++) {
            status[hits[i][0]][hits[i][1]] = 0;
        }
        for (int i = 0; i < h; i++) {
            for (int j = 0; j < w; j++) {
                if (status[i][j] == 1) {
                    if (i == 0) {
                        uf.merge(h * w, i * w + j);
                    }
                    if (i > 0 && status[i - 1][j] == 1) {
                        uf.merge(i * w + j, (i - 1) * w + j);
                    }
                    if (j > 0 && status[i][j - 1] == 1) {
                        uf.merge(i * w + j, i * w + j - 1);
                    }
                }
            }
        }
        const vector<pair<int, int>> directions{{0, 1},{1, 0},{0, -1},{-1, 0}};
        vector<int> ret(hits.size(), 0);
        for (int i = hits.size() - 1; i >= 0; i--) {
            int r = hits[i][0], c = hits[i][1];
            if (grid[r][c] == 0) {
                continue;
            }
            int prev = uf.size(h * w);

            if (r == 0) {
                uf.merge(c, h * w);
            }
            for (const auto [dr, dc]: directions) {
                int nr = r + dr, nc = c + dc;
                
                if (nr >= 0 && nr < h && nc >= 0 && nc < w) {
                    if (status[nr][nc] == 1) {
                        uf.merge(r * w + c, nr * w + nc);
                    }
                }
            }
            int size = uf.size(h * w);
            ret[i] = max(0, size - prev - 1);
            status[r][c] = 1;
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] hitBricks(int[][] grid, int[][] hits) {
        int h = grid.length, w = grid[0].length;
        
        UnionFind uf = new UnionFind(h * w + 1);
        int[][] status = new int[h][w];
        for (int i = 0; i < h; i++) {
            for (int j = 0; j < w; j++) {
                status[i][j] = grid[i][j];
            }
        }
        for (int i = 0; i < hits.length; i++) {
            status[hits[i][0]][hits[i][1]] = 0;
        }
        for (int i = 0; i < h; i++) {
            for (int j = 0; j < w; j++) {
                if (status[i][j] == 1) {
                    if (i == 0) {
                        uf.merge(h * w, i * w + j);
                    }
                    if (i > 0 && status[i - 1][j] == 1) {
                        uf.merge(i * w + j, (i - 1) * w + j);
                    }
                    if (j > 0 && status[i][j - 1] == 1) {
                        uf.merge(i * w + j, i * w + j - 1);
                    }
                }
            }
        }
        int[][] directions = {{0, 1},{1, 0},{0, -1},{-1, 0}};
        int[] ret = new int[hits.length];
        for (int i = hits.length - 1; i >= 0; i--) {
            int r = hits[i][0], c = hits[i][1];
            if (grid[r][c] == 0) {
                continue;
            }
            int prev = uf.size(h * w);

            if (r == 0) {
                uf.merge(c, h * w);
            }
            for (int[] direction : directions) {
                int dr = direction[0], dc = direction[1];
                int nr = r + dr, nc = c + dc;
                
                if (nr >= 0 && nr < h && nc >= 0 && nc < w) {
                    if (status[nr][nc] == 1) {
                        uf.merge(r * w + c, nr * w + nc);
                    }
                }
            }
            int size = uf.size(h * w);
            ret[i] = Math.max(0, size - prev - 1);
            status[r][c] = 1;
        }
        return ret;
    }
}

class UnionFind {
    int[] f;
    int[] sz;

    public UnionFind(int n) {
        f = new int[n];
        sz = new int[n];
        for (int i = 0; i < n; i++) {
            f[i] = i;
            sz[i] = 1;
        }
    }

    public int find(int x) {
        if (f[x] == x) {
            return x;
        }
        int newf = find(f[x]);
        f[x] = newf;
        return f[x];
    }

    public void merge(int x, int y) {
        int fx = find(x), fy = find(y);
        if (fx == fy) {
            return;
        }
        f[fx] = fy;
        sz[fy] += sz[fx];
    }

    public int size(int x) {
        return sz[find(x)];
    }
}
```

```go [sol1-Golang]
func hitBricks(grid [][]int, hits [][]int) []int {
    h, w := len(grid), len(grid[0])
    fa := make([]int, h*w+1)
    size := make([]int, h*w+1)
    for i := range fa {
        fa[i] = i
        size[i] = 1
    }
    var find func(int) int
    find = func(x int) int {
        if fa[x] != x {
            fa[x] = find(fa[x])
        }
        return fa[x]
    }
    union := func(from, to int) {
        from, to = find(from), find(to)
        if from != to {
            size[to] += size[from]
            fa[from] = to
        }
    }

    status := make([][]int, h)
    for i, row := range grid {
        status[i] = append([]int(nil), row...)
    }
    // 遍历 hits 得到最终状态
    for _, p := range hits {
        status[p[0]][p[1]] = 0
    }

    // 根据最终状态建立并查集
    root := h * w
    for i, row := range status {
        for j, v := range row {
            if v == 0 {
                continue
            }
            if i == 0 {
                union(i*w+j, root)
            }
            if i > 0 && status[i-1][j] == 1 {
                union(i*w+j, (i-1)*w+j)
            }
            if j > 0 && status[i][j-1] == 1 {
                union(i*w+j, i*w+j-1)
            }
        }
    }

    type pair struct{ x, y int }
    directions := []pair{{-1, 0}, {1, 0}, {0, -1}, {0, 1}} // 上下左右

    ans := make([]int, len(hits))
    for i := len(hits) - 1; i >= 0; i-- {
        p := hits[i]
        r, c := p[0], p[1]
        if grid[r][c] == 0 {
            continue
        }

        preSize := size[find(root)]
        if r == 0 {
            union(c, root)
        }
        for _, d := range directions {
            if newR, newC := r+d.x, c+d.y; 0 <= newR && newR < h && 0 <= newC && newC < w && status[newR][newC] == 1 {
                union(r*w+c, newR*w+newC)
            }
        }
        curSize := size[find(root)]
        if cnt := curSize - preSize - 1; cnt > 0 {
            ans[i] = cnt
        }
        status[r][c] = 1
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var hitBricks = function(grid, hits) {
    const h = grid.length; w = grid[0].length;

    const uf = new UnionFind(h * w + 1);
    const status = JSON.parse(JSON.stringify(grid));;
    for (let i = 0; i < hits.length; i++) {
        status[hits[i][0]][hits[i][1]] = 0;
    }
    for (let i = 0; i < h; i++) {
        for (let j = 0; j < w; j++) {
            if (status[i][j] === 1) {
                if (i === 0) {
                    uf.merge(h * w, i * w + j);
                }
                if (i > 0 && status[i - 1][j] === 1) {
                    uf.merge(i * w + j, (i - 1) * w + j);
                }
                if (j > 0 && status[i][j - 1] === 1) {
                    uf.merge(i * w + j, i * w + j - 1);
                }
            }
        }
    }

    const directions = [[0, 1], [1, 0], [0, -1], [-1, 0]];
    const ret = new Array(hits.length).fill(0);
    for (let i = hits.length - 1; i >= 0; i--) {
        const r = hits[i][0], c = hits[i][1];
        if (grid[r][c] === 0) {
            console.log(1)
            continue;
        }
        const prev = uf.size(h * w);
         
        if (r === 0) {
            console.log(2)
            uf.merge(c, h * w);
        }
        for (const [dr, dc] of directions) {
            const nr = r + dr, nc = c + dc;

            if (nr >= 0 && nr < h && nc >= 0 && nc < w) {
                if (status[nr][nc] === 1) {
                    console.log(3)
                    uf.merge(r * w + c, nr * w + nc);
                }
            }
        }
        const size = uf.size(h * w);
        ret[i] = Math.max(0, size - prev - 1);
        status[r][c] = 1;
    }
    return ret;
};

class UnionFind {
    constructor (n) {
        this.f = new Array(n).fill(0).map((element, index) => index);
        this.sz = new Array(n).fill(1);
    }

    find (x) {
        if (this.f[x] === x) {
            return x;
        }
        const newf = this.find(this.f[x]);
        this.f[x] = newf;
        return this.f[x];
    }

    merge (x, y) {
        const fx = this.find(x), fy = this.find(y);
        if (fx === fy) {
            return;
        }
        this.f[fx] = fy;
        this.sz[fy] += this.sz[fx];
    }

    size (x) {
        return this.sz[this.find(x)];
    }
}
```

```C [sol1-C]
int find(int* f, int x) {
    if (f[x] == x) {
        return x;
    }
    int newf = find(f, f[x]);
    f[x] = newf;
    return f[x];
}

void merge(int* f, int* sz, int x, int y) {
    int fx = find(f, x), fy = find(f, y);
    if (fx == fy) {
        return;
    }
    f[fx] = fy;
    sz[fy] += sz[fx];
}

int size(int* f, int* sz, int x) {
    return sz[find(f, x)];
}

int* hitBricks(int** grid, int gridSize, int* gridColSize, int** hits, int hitsSize, int* hitsColSize, int* returnSize) {
    int h = gridSize, w = gridColSize[0];

    int f[h * w + 1], sz[h * w + 1];
    for (int i = 0; i <= h * w; i++) {
        f[i] = i;
        sz[i] = 1;
    }
    int status[h][w];
    for (int i = 0; i < h; i++) {
        for (int j = 0; j < w; j++) {
            status[i][j] = grid[i][j];
        }
    }
    for (int i = 0; i < hitsSize; i++) {
        status[hits[i][0]][hits[i][1]] = 0;
    }
    for (int i = 0; i < h; i++) {
        for (int j = 0; j < w; j++) {
            if (status[i][j] == 1) {
                if (i == 0) {
                    merge(f, sz, h * w, i * w + j);
                }
                if (i > 0 && status[i - 1][j] == 1) {
                    merge(f, sz, i * w + j, (i - 1) * w + j);
                }
                if (j > 0 && status[i][j - 1] == 1) {
                    merge(f, sz, i * w + j, i * w + j - 1);
                }
            }
        }
    }
    int directions[4][2] = {{0, 1}, {1, 0}, {0, -1}, {-1, 0}};
    int* ret = malloc(sizeof(int) * hitsSize);
    memset(ret, 0, sizeof(int) * hitsSize);
    *returnSize = hitsSize;
    memset(ret, 0, hitsSize);
    for (int i = hitsSize - 1; i >= 0; i--) {
        int r = hits[i][0], c = hits[i][1];
        if (grid[r][c] == 0) {
            continue;
        }
        int prev = size(f, sz, h * w);

        if (r == 0) {
            merge(f, sz, c, h * w);
        }
        for (int i = 0; i < 4; i++) {
            int nr = r + directions[i][0], nc = c + directions[i][1];

            if (nr >= 0 && nr < h && nc >= 0 && nc < w) {
                if (status[nr][nc] == 1) {
                    merge(f, sz, r * w + c, nr * w + nc);
                }
            }
        }
        ret[i] = fmax(0, size(f, sz, h * w) - prev - 1);
        status[r][c] = 1;
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n\cdot hw \cdot \log(hw))$，其中 $n$ 为消除砖块的次数（即数组 $\textit{hits}$ 的长度），$h$ 和 $w$ 分别为矩阵的行数和列数。图中共有 $hw+1$ 个节点，故并查集的单次操作的时间复杂度为 $O(hw \cdot \log(hw))$。

- 空间复杂度：$O(hw)$。
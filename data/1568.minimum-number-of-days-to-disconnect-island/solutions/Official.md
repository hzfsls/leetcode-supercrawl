## [1568.使陆地分离的最少天数 中文官方题解](https://leetcode.cn/problems/minimum-number-of-days-to-disconnect-island/solutions/100000/shi-lu-di-fen-chi-de-zui-shao-tian-shu-by-leetcode)

#### 方法一：分类讨论

**思路与算法**

仔细思考我们会发现最终的答案不可能超过 $2$。因为对于 $n\times m$ 的岛屿（$n,m \ge 2$），我们总是可以将某个角落相邻的**两个**陆地单元变成水单元，从而使这个角落的陆地单元与原岛屿分离。而对于 $1\times n$ 类型的岛屿，我们也可以选择一个中间的陆地单元变成水单元使得陆地分离。因此最终的答案只可能是 $0,1,2$。

那么我们只要依次检查 $0$ 或 $1$ 的答案是否存在即可。$0$ 的情况对应于一开始的二维网格已经是陆地分离的状态，而对于$1$ 的情况，我们只要枚举每一个存在的陆地单元，将其修改为水单元，再去看是否为陆地分离的状态即可。如果都不能变为陆地分离的状态，那么答案即为 $2$。

那么最后要解决的即为「如何判断二维网格是否为陆地分离的状态」。根据其定义，我们可以知道只要统计全部为 $1$ 的四连通块数量是否大于 $1$ 即可，统计连通块数量可以通过深度优先搜索来处理，这里不再赘述。

**代码**

```C++ [sol1-C++]
class Solution {
    int dx[4] = {0, 1, 0, -1};
    int dy[4] = {1, 0, -1, 0};
public:
    void dfs(int x, int y, vector<vector<int>>& grid, int n, int m) {
        grid[x][y] = 2;
        for (int i = 0; i < 4; ++i) {
            int tx = dx[i] + x;
            int ty = dy[i] + y;
            if (tx < 0 || tx >= n || ty < 0 || ty >= m || grid[tx][ty] != 1) {
                continue;
            }
            dfs(tx, ty, grid, n, m);
        }
    }
    int count(vector<vector<int>>& grid, int n, int m) {
        int cnt = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                if (grid[i][j] == 1) {
                    cnt++;
                    dfs(i, j, grid, n, m);
                }
            }
        }
        // 还原
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                if (grid[i][j] == 2) {
                    grid[i][j] = 1;
                }
            }
        }
        return cnt;
    }
    int minDays(vector<vector<int>>& grid) {
        int n = grid.size(), m = grid[0].size();
        // 岛屿数量不为 1，陆地已经分离
        if (count(grid, n, m) != 1) {
            return 0;
        }
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                if (grid[i][j]) {
                    grid[i][j] = 0;
                    if (count(grid, n, m) != 1) {
                        // 更改一个陆地单元为水单元后陆地分离
                        return 1;
                    }
                    grid[i][j] = 1;
                }
            }
        }
        return 2;
    }
};
```

```Java [sol1-Java]
class Solution {
    int[] dx = {0, 1, 0, -1};
    int[] dy = {1, 0, -1, 0};

    public int minDays(int[][] grid) {
        int n = grid.length, m = grid[0].length;
        // 岛屿数量不为 1，陆地已经分离
        if (count(grid, n, m) != 1) {
            return 0;
        }
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                if (grid[i][j] != 0) {
                    grid[i][j] = 0;
                    if (count(grid, n, m) != 1) {
                        // 更改一个陆地单元为水单元后陆地分离
                        return 1;
                    }
                    grid[i][j] = 1;
                }
            }
        }
        return 2;
    }

    public int count(int[][] grid, int n, int m) {
        int cnt = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                if (grid[i][j] == 1) {
                    cnt++;
                    dfs(i, j, grid, n, m);
                }
            }
        }
        // 还原
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                if (grid[i][j] == 2) {
                    grid[i][j] = 1;
                }
            }
        }
        return cnt;
    }

    public void dfs(int x, int y, int[][] grid, int n, int m) {
        grid[x][y] = 2;
        for (int i = 0; i < 4; ++i) {
            int tx = dx[i] + x;
            int ty = dy[i] + y;
            if (tx < 0 || tx >= n || ty < 0 || ty >= m || grid[tx][ty] != 1) {
                continue;
            }
            dfs(tx, ty, grid, n, m);
        }
    }
}
```

```JavaScript [sol1-JavaScript]
const dx = [0, 1, 0, -1];
const dy = [1, 0, -1 ,0];

const dfs = (x, y, grid, n, m) => {
    grid[x][y] = 2;
    for (let i = 0; i < 4; ++i) {
        const tx = dx[i] + x;
        const ty = dy[i] + y;
        if (tx < 0 || tx >= n || ty < 0 || ty >= m || grid[tx][ty] != 1) {
            continue;
        }
        dfs(tx, ty, grid, n, m);
    }
}

const count = (grid, n, m) => {
    let cnt = 0;
    for (let i = 0; i < n; ++i) {
        for (let j = 0; j < m; ++j) {
            if (grid[i][j] == 1) {
                cnt++;
                dfs(i, j, grid, n, m);
            }
        }
    }
    // 还原
    for (let i = 0; i < n; ++i) {
        for (let j = 0; j < m; ++j) {
            if (grid[i][j] == 2) {
                grid[i][j] = 1;
            }
        }
    }
    return cnt;
}
var minDays = function(grid) {
    const n = grid.length, m = grid[0].length;
    // 岛屿数量不为 1，陆地已经分离
    if (count(grid, n, m) != 1) {
        return 0;
    }
    for (let i = 0; i < n; ++i) {
        for (let j = 0; j < m; ++j) {
            if (grid[i][j]) {
                grid[i][j] = 0;
                if (count(grid, n, m) != 1) {
                    // 更改一个陆地单元为水单元后陆地分离
                    return 1;
                }
                grid[i][j] = 1;
            }
        }
    }
    return 2;
};
```

```Python [sol1-Python3]
class Solution:
    def minDays(self, grid: List[List[int]]) -> int:
        def dfs(x: int, y: int):
            grid[x][y] = 2
            for tx, ty in [(x, y + 1), (x + 1, y), (x, y - 1), (x - 1, y)]:
                if 0 <= tx < n and 0 <= ty < m and grid[tx][ty] == 1:
                    dfs(tx, ty)
        
        def count():
            cnt = 0
            for i in range(n):
                for j in range(m):
                    if grid[i][j] == 1:
                        cnt += 1
                        dfs(i, j)
            # 还原
            for i in range(n):
                for j in range(m):
                    if grid[i][j] == 2:
                        grid[i][j] = 1
            return cnt
        
        n, m = len(grid), len(grid[0])
        
        # 岛屿数量不为 1，陆地已经分离
        if count() != 1:
            return 0
        
        for i in range(n):
            for j in range(m):
                if grid[i][j]:
                    grid[i][j] = 0
                    if count() != 1:
                        # 更改一个陆地单元为水单元后陆地分离
                        return 1
                    grid[i][j] = 1
        
        return 2
```

**复杂度分析**

- 时间复杂度：$O(n^2m^2)$，其中 $n$ 为网格高度，$m$ 为网格宽度。时间复杂度瓶颈在于枚举更改一个陆地单元为水单元，统计当前有多少岛屿，这里每次枚举需要 $O(nm)$ 的时间复杂度，统计当前有多少岛屿需要 $O(nm)$ 的时间复杂度，因此总时间复杂度为 $O(n^2m^2)$。

- 空间复杂度：$O(nm)$。在深度优先搜索统计有多少岛屿的时候，递归的栈空间最深可达到 $O(nm)$，即整个二维网格全都是陆地单元的情况，因此空间复杂度为 $O(nm)$。

#### 结语

如果我们将每一块陆地看成无向图中的一个节点，每一组相邻的陆地之间连接一条无向边，那么得到的图 $G$：

- 如果图 $G$ 中没有节点，那么答案为 $0$；

- 如果连通分量个数大于 $1$，那么说明陆地已经分离，答案为 $0$；

- 如果连通分量个数为 $1$：

    - 如果图 $G$ 中仅有一个节点，那么答案为 $1$；

    - 如果图 $G$ 中存在[割点](https://baike.baidu.com/item/%E5%89%B2%E7%82%B9)，那么将割点对应的陆地变成水，就可以使得陆地分离，答案为 $1$；

    - 如果图 $G$ 中不存在割点，那么答案为 $2$。

求解无向图的割点可以用 Tarjan 算法，但由于其明显超出了面试难度，在笔试中也几乎不可能出现，因此本题解中不给出该算法本身的讲解，仅给出参考代码。读者如果对 Tarjan 算法感兴趣，可以查阅资料自行学习。

下面代码的时间复杂度和空间复杂度均为 $O(mn)$，即为 Tarjan 算法求解包含不超过 $mn$ 个节点以及 $4mn$ 条边的无向图的割点的时间复杂度。

```C++ [sol2-C++]
class TarjanSCC {
private:
    const vector<vector<int>>& edges;
    vector<int> low, dfn, fa;
    int timestamp = -1;
    int n;
    
private:
    // Tarjan 算法求解割点模板
    void getCuttingVertex(int u, int parent, vector<int>& ans) {
        low[u] = dfn[u] = ++timestamp;
        fa[u] = parent;
        int child = 0;
        bool iscv = false;
        for (int v: edges[u]) {
            if (dfn[v] == -1) {
                ++child;
                getCuttingVertex(v, u, ans);
                low[u] = min(low[u], low[v]);
                if (!iscv && parent != -1 && low[v] >= dfn[u]) {
                    ans.push_back(u);
                    iscv = true;
                }
            }
            else if (v != fa[u]) {
                low[u] = min(low[u], dfn[v]);
            }
        }
        if (!iscv && parent == -1 && child >= 2) {
            ans.push_back(u);
        }
    }

public:
    TarjanSCC(const vector<vector<int>>& _edges): edges(_edges), n(_edges.size()) {}

    int check() {
        low.assign(n, -1);
        dfn.assign(n, -1);
        fa.assign(n, -1);
        timestamp = -1;
        
        // cutting vertices 存储割点
        vector<int> cvs;
        // connected components count 存储连通分量个数
        int cccnt = 0;
        for (int i = 0; i < n; ++i) {
            if (dfn[i] == -1) {
                ++cccnt;
                getCuttingVertex(i, -1, cvs);
            }
        }
        // 如果连通分量个数大于 1，答案为 0
        if (cccnt > 1) {
            return 0;
        }
        // 如果存在割点，答案为 1
        if (!cvs.empty()) {
            return 1;
        }
        return 2;
    }
};

class Solution {
private:
    static constexpr int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

public:
    int minDays(vector<vector<int>>& grid) {
        int m = grid.size();
        int n = grid[0].size();
        
        // 节点重标号
        int landCount = 0;
        unordered_map<int, int> relabel;
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (grid[i][j] == 1) {
                    relabel[i * n + j] = landCount;
                    ++landCount;
                }
            }
        }
        if (!landCount) {
            return 0;
        }
        if (landCount == 1) {
            return 1;
        }

        // 添加图中的边
        vector<vector<int>> edges(landCount);
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (grid[i][j] == 1) {
                    for (int d = 0; d < 4; ++d) {
                        int ni = i + dirs[d][0];
                        int nj = j + dirs[d][1];
                        if (ni >= 0 && ni < m && nj >= 0 && nj < n && grid[ni][nj] == 1) {
                            edges[relabel[i * n + j]].push_back(relabel[ni * n + nj]);
                        }
                    }
                }
            }
        }

        auto scc = TarjanSCC(edges);
        return scc.check();
    }
};
```
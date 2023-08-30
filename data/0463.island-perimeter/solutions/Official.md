#### 方法一：迭代

**思路与算法**

对于一个陆地格子的每条边，它被算作岛屿的周长当且仅当这条边为网格的边界或者相邻的另一个格子为水域。 因此，我们可以遍历每个陆地格子，看其四个方向是否为边界或者水域，如果是，将这条边的贡献（即 $1$）加入答案 $\textit{ans}$ 中即可。

**代码**

```C++ [sol1-C++]
class Solution {
    constexpr static int dx[4] = {0, 1, 0, -1};
    constexpr static int dy[4] = {1, 0, -1, 0};
public:
    int islandPerimeter(vector<vector<int>> &grid) {
        int n = grid.size(), m = grid[0].size();
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                if (grid[i][j]) {
                    int cnt = 0;
                    for (int k = 0; k < 4; ++k) {
                        int tx = i + dx[k];
                        int ty = j + dy[k];
                        if (tx < 0 || tx >= n || ty < 0 || ty >= m || !grid[tx][ty]) {
                            cnt += 1;
                        }
                    }
                    ans += cnt;
                }
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    static int[] dx = {0, 1, 0, -1};
    static int[] dy = {1, 0, -1, 0};

    public int islandPerimeter(int[][] grid) {
        int n = grid.length, m = grid[0].length;
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                if (grid[i][j] == 1) {
                    int cnt = 0;
                    for (int k = 0; k < 4; ++k) {
                        int tx = i + dx[k];
                        int ty = j + dy[k];
                        if (tx < 0 || tx >= n || ty < 0 || ty >= m || grid[tx][ty] == 0) {
                            cnt += 1;
                        }
                    }
                    ans += cnt;
                }
            }
        }
        return ans;
    }
}
```

```JavaScript [sol1-JavaScript]
var islandPerimeter = function (grid) {
    const dx = [0, 1, 0, -1];
    const dy = [1, 0, -1, 0];
    const n = grid.length, m = grid[0].length;
    let ans = 0;
    for (let i = 0; i < n; ++i) {
        for (let j = 0; j < m; ++j) {
            if (grid[i][j]) {
                let cnt = 0;
                for (let k = 0; k < 4; ++k) {
                    let tx = i + dx[k];
                    let ty = j + dy[k];
                    if (tx < 0 || tx >= n || ty < 0 || ty >= m || !grid[tx][ty]) {
                        cnt += 1;
                    }
                }
                ans += cnt;
            }
        }
    }
    return ans;
};
```

```Golang [sol1-Golang]
type pair struct{ x, y int }
var dir4 = []pair{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func islandPerimeter(grid [][]int) (ans int) {
    n, m := len(grid), len(grid[0])
    for i, row := range grid {
        for j, v := range row {
            if v == 1 {
                for _, d := range dir4 {
                    if x, y := i+d.x, j+d.y; x < 0 || x >= n || y < 0 || y >= m || grid[x][y] == 0 {
                        ans++
                    }
                }
            }
        }
    }
    return
}
```

```C [sol1-C]
const int dx[4] = {0, 1, 0, -1};
const int dy[4] = {1, 0, -1, 0};

int islandPerimeter(int** grid, int gridSize, int* gridColSize) {
    int n = gridSize, m = gridColSize[0];
    int ans = 0;
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < m; ++j) {
            if (grid[i][j]) {
                int cnt = 0;
                for (int k = 0; k < 4; ++k) {
                    int tx = i + dx[k];
                    int ty = j + dy[k];
                    if (tx < 0 || tx >= n || ty < 0 || ty >= m || !grid[tx][ty]) {
                        cnt += 1;
                    }
                }
                ans += cnt;
            }
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(nm)$，其中 $n$ 为网格的高度，$m$ 为网格的宽度。我们需要遍历每个格子，每个格子要看其周围 $4$ 个格子是否为岛屿，因此总时间复杂度为 $O(4nm)=O(nm)$。

-  空间复杂度：$O(1)$。只需要常数空间存放若干变量。

#### 方法二：深度优先搜索

**思路与算法**

我们也可以将方法一改成深度优先搜索遍历的方式，此时遍历的方式可扩展至统计多个岛屿各自的周长。需要注意的是为了防止陆地格子在深度优先搜索中被重复遍历导致死循环，我们需要将遍历过的陆地格子标记为已经遍历过，下面的代码中我们设定值为 $2$ 的格子为已经遍历过的陆地格子。

**代码**

```C++ [sol2-C++]
class Solution {
    constexpr static int dx[4] = {0, 1, 0, -1};
    constexpr static int dy[4] = {1, 0, -1, 0};
public:
    int dfs(int x, int y, vector<vector<int>> &grid, int n, int m) {
        if (x < 0 || x >= n || y < 0 || y >= m || grid[x][y] == 0) {
            return 1;
        }
        if (grid[x][y] == 2) {
            return 0;
        }
        grid[x][y] = 2;
        int res = 0;
        for (int i = 0; i < 4; ++i) {
            int tx = x + dx[i];
            int ty = y + dy[i];
            res += dfs(tx, ty, grid, n, m);
        }
        return res;
    }
    int islandPerimeter(vector<vector<int>> &grid) {
        int n = grid.size(), m = grid[0].size();
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                if (grid[i][j] == 1) {
                    ans += dfs(i, j, grid, n, m);
                }
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    static int[] dx = {0, 1, 0, -1};
    static int[] dy = {1, 0, -1, 0};

    public int islandPerimeter(int[][] grid) {
        int n = grid.length, m = grid[0].length;
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                if (grid[i][j] == 1) {
                    ans += dfs(i, j, grid, n, m);
                }
            }
        }
        return ans;
    }

    public int dfs(int x, int y, int[][] grid, int n, int m) {
        if (x < 0 || x >= n || y < 0 || y >= m || grid[x][y] == 0) {
            return 1;
        }
        if (grid[x][y] == 2) {
            return 0;
        }
        grid[x][y] = 2;
        int res = 0;
        for (int i = 0; i < 4; ++i) {
            int tx = x + dx[i];
            int ty = y + dy[i];
            res += dfs(tx, ty, grid, n, m);
        }
        return res;
    }
}
```

```JavaScript [sol2-JavaScript]
var islandPerimeter = function (grid) {
    const dx = [0, 1, 0, -1];
    const dy = [1, 0, -1, 0];
    const n = grid.length, m = grid[0].length;

    const dfs = (x, y) => {
        if (x < 0 || x >= n || y < 0 || y >= m || grid[x][y] === 0) {
            return 1;
        }
        if (grid[x][y] === 2) {
            return 0;
        }
        grid[x][y] = 2;
        let res = 0;
        for (let i = 0; i < 4; ++i) {
            const tx = x + dx[i];
            const ty = y + dy[i];
            res += dfs(tx, ty);
        }
        return res;
    }

    let ans = 0;
    for (let i = 0; i < n; ++i) {
        for (let j = 0; j < m; ++j) {
            if (grid[i][j] === 1) {
                ans += dfs(i, j);
            }
        }
    }
    return ans;
};
```

```Golang [sol2-Golang]
type pair struct{ x, y int }
var dir4 = []pair{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func islandPerimeter(grid [][]int) (ans int) {
    n, m := len(grid), len(grid[0])
    var dfs func(x, y int)
    dfs = func(x, y int) {
        if x < 0 || x >= n || y < 0 || y >= m || grid[x][y] == 0 {
            ans++
            return
        }
        if grid[x][y] == 2 {
            return
        }
        grid[x][y] = 2
        for _, d := range dir4 {
            dfs(x+d.x, y+d.y)
        }
    }
    for i, row := range grid {
        for j, v := range row {
            if v == 1 {
                dfs(i, j)
            }
        }
    }
    return
}
```

```C [sol2-C]
const int dx[4] = {0, 1, 0, -1};
const int dy[4] = {1, 0, -1, 0};

int dfs(int x, int y, int** grid, int n, int m) {
    if (x < 0 || x >= n || y < 0 || y >= m || grid[x][y] == 0) {
        return 1;
    }
    if (grid[x][y] == 2) {
        return 0;
    }
    grid[x][y] = 2;
    int res = 0;
    for (int i = 0; i < 4; ++i) {
        int tx = x + dx[i];
        int ty = y + dy[i];
        res += dfs(tx, ty, grid, n, m);
    }
    return res;
}

int islandPerimeter(int** grid, int gridSize, int* gridColSize) {
    int n = gridSize, m = gridColSize[0];
    int ans = 0;
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < m; ++j) {
            if (grid[i][j] == 1) {
                ans += dfs(i, j, grid, n, m);
            }
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(nm)$，其中 $n$ 为网格的高度，$m$ 为网格的宽度。每个格子至多会被遍历一次，因此总时间复杂度为 $O(nm)$。

- 空间复杂度：$O(nm)$。深度优先搜索复杂度取决于递归的栈空间，而栈空间最坏情况下会达到 $O(nm)$。
## [1219.黄金矿工 中文官方题解](https://leetcode.cn/problems/path-with-maximum-gold/solutions/100000/huang-jin-kuang-gong-by-leetcode-solutio-f9gg)

#### 方法一：回溯算法

**思路与算法**

我们首先在 $m \times n$ 个网格内枚举起点。只要格子内的数大于 $0$，它就可以作为起点进行开采。

记枚举的起点为 $(i, j)$，我们就可以从 $(i, j)$ 开始进行递归 + 回溯，枚举所有可行的开采路径。我们用递归函数 $\textit{dfs}(x, y, \textit{gold})$ 进行枚举，其中 $(x, y)$ 表示当前所在的位置，$\textit{gold}$ 表示在开采位置 $(x, y)$ 之前，已经拥有的黄金数量。根据题目的要求，我们需要进行如下的步骤：

- 我们需要将 $\textit{gold}$ 更新为 $\textit{gold} + \textit{grid}[x][y]$，表示对位置 $(x, y)$ 进行开采。由于我们的目标是最大化收益，因此我们还要维护一个最大的收益值 $\textit{ans}$，并在这一步使用 $\textit{gold}$ 更新 $\textit{ans}$；

- 我们需要枚举矿工下一步的方向。由于矿工每次可以从当前位置向上下左右四个方向走，因此我们需要依次枚举每一个方向。如果往某一个方向不会走出网格，并且走到的位置的值不为 $0$，我们就可以进行递归搜索；

- 在搜索完所有方向后，我们进行回溯。

需要注意的是，题目规定了「每个单元格只能被开采一次」，因此当我们到达位置 $(x, y)$ 时，我们可以将 $\textit{grid}[x][y]$ 暂时置为 $0$；在进行回溯之前，再将 $\textit{grid}[x][y]$ 的值恢复。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

public:
    int getMaximumGold(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();
        int ans = 0;

        function<void(int, int, int)> dfs = [&](int x, int y, int gold) {
            gold += grid[x][y];
            ans = max(ans, gold);

            int rec = grid[x][y];
            grid[x][y] = 0;

            for (int d = 0; d < 4; ++d) {
                int nx = x + dirs[d][0];
                int ny = y + dirs[d][1];
                if (nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] > 0) {
                    dfs(nx, ny, gold);
                }
            }

            grid[x][y] = rec;
        };

        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (grid[i][j] != 0) {
                    dfs(i, j, 0);
                }
            }
        }

        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    static int[][] dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    int[][] grid;
    int m, n;
    int ans = 0;

    public int getMaximumGold(int[][] grid) {
        this.grid = grid;
        this.m = grid.length;
        this.n = grid[0].length;
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (grid[i][j] != 0) {
                    dfs(i, j, 0);
                }
            }
        }
        return ans;
    }

    public void dfs(int x, int y, int gold) {
        gold += grid[x][y];
        ans = Math.max(ans, gold);

        int rec = grid[x][y];
        grid[x][y] = 0;

        for (int d = 0; d < 4; ++d) {
            int nx = x + dirs[d][0];
            int ny = y + dirs[d][1];
            if (nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] > 0) {
                dfs(nx, ny, gold);
            }
        }

        grid[x][y] = rec;
    }
}
```

```C# [sol1-C#]
public class Solution {
    static int[][] dirs = {new int[]{-1, 0}, new int[]{1, 0}, new int[]{0, -1}, new int[]{0, 1}};
    int[][] grid;
    int m, n;
    int ans = 0;

    public int GetMaximumGold(int[][] grid) {
        this.grid = grid;
        this.m = grid.Length;
        this.n = grid[0].Length;
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (grid[i][j] != 0) {
                    DFS(i, j, 0);
                }
            }
        }
        return ans;
    }

    public void DFS(int x, int y, int gold) {
        gold += grid[x][y];
        ans = Math.Max(ans, gold);

        int rec = grid[x][y];
        grid[x][y] = 0;

        for (int d = 0; d < 4; ++d) {
            int nx = x + dirs[d][0];
            int ny = y + dirs[d][1];
            if (nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] > 0) {
                DFS(nx, ny, gold);
            }
        }

        grid[x][y] = rec;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def getMaximumGold(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        ans = 0

        def dfs(x: int, y: int, gold: int) -> None:
            gold += grid[x][y]
            nonlocal ans
            ans = max(ans, gold)

            rec = grid[x][y]
            grid[x][y] = 0

            for nx, ny in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
                if 0 <= nx < m and 0 <= ny < n and grid[nx][ny] > 0:
                    dfs(nx, ny, gold)

            grid[x][y] = rec

        for i in range(m):
            for j in range(n):
                if grid[i][j] != 0:
                    dfs(i, j, 0)

        return ans
```

```JavaScript [sol1-JavaScript]
var getMaximumGold = function(grid) {
    this.grid = grid;
    this.m = grid.length;
    this.n = grid[0].length;
    this.dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]];
    this.ans = 0;

    const dfs = (x, y, gold, dirs) => {
        gold += grid[x][y];
        this.ans = Math.max(ans, gold);

        const rec = grid[x][y];
        grid[x][y] = 0;

        for (let d = 0; d < 4; ++d) {
            const nx = x + this.dirs[d][0];
            const ny = y + this.dirs[d][1];
            if (nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] > 0) {
                dfs(nx, ny, gold);
            }
        }

        grid[x][y] = rec;
    }
    for (let i = 0; i < m; ++i) {
        for (let j = 0; j < n; ++j) {
            if (grid[i][j] !== 0) {
                dfs(i, j, 0);
            }
        }
    }
    return ans;
};
```

```go [sol1-Golang]
var dirs = []struct{ x, y int }{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func getMaximumGold(grid [][]int) (ans int) {
    var dfs func(x, y, gold int)
    dfs = func(x, y, gold int) {
        gold += grid[x][y]
        if gold > ans {
            ans = gold
        }

        rec := grid[x][y]
        grid[x][y] = 0
        for _, d := range dirs {
            nx, ny := x+d.x, y+d.y
            if 0 <= nx && nx < len(grid) && 0 <= ny && ny < len(grid[nx]) && grid[nx][ny] > 0 {
                dfs(nx, ny, gold)
            }
        }
        grid[x][y] = rec
    }

    for i, row := range grid {
        for j, gold := range row {
            if gold > 0 {
                dfs(i, j, 0)
            }
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(mn + \min(mn, T) \cdot 3^{\min(mn, T)})$，其中 $T = 25$ 表示最多包含黄金的单元格数量。枚举起点需要 $O(mn)$ 的时间，可以成为起点的位置必须有黄金，那么可能的起点有 $\min(mn, T)$ 个。对于每一个起点，第一步最多有 $4$ 个可行的方向，后面的每一步最多有 $3$ 个可行的方向，因此可以粗略估计出一次搜索需要的时间为 $O(4 \times 3^{\min(mn, T) - 2}) = O(3^{\min(mn, T)})$。

- 空间复杂度：$O(\min(mn, T))$，即为递归需要的栈空间。
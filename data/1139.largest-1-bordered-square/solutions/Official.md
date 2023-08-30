#### 方法一：动态规划

**思路与算法**

我们假设以 $(x,y)$ 为右下方顶点的最大的正方形边长为 $l$，此时正方形的四个顶点分别为 $(x - l + 1, y - l + 1), (x, y - l + 1), (x - l + 1, y), (x, y)$，此时需要保证正方形的四条边上的数字均为 $1$。我们设 $\textit{left}[x][y]$ 表示以 $(x,y)$ 为起点左侧连续 $1$ 的最大数目，$\textit{right}[x][y]$ 表示以 $(x,y)$ 为起点右侧连续 $1$ 的最大数目，$\textit{up}[x][y]$ 表示从 $(x,y)$ 为起点上方连续 $1$ 的最大数目，$\textit{down}[x][y]$ 表示以 $(x,y)$ 为起点下方连续 $1$ 的最大数目。此时正方形的四条边中以四个顶点为起点的连续 $1$ 的数目分别为：上侧边中以 $(x-l+1,y-l+1)$ 为起点连续 $1$ 数目为 $\textit{right}[x-l+1][y-l+1]$，左侧边中以 $(x-l+1,y-l+1)$ 为起点连续 $1$ 的数目为 $\textit{down}[x-l+1][y-l+1]$，右侧边中以 $(x,y)$ 为起点连续 $1$ 的数目为 $\textit{up}[x][y]$，下侧边中以 $(x,y)$ 为起点连续 $1$ 的数目为 $\textit{left}[x][y]$。

如果连续 $1$ 的数目大于等于 $l$，则构成一条「合法」的边，如果正方形的四条边均「合法」，此时一定可以构成边界全为 $1$ 且边长为 $l$ 的正方形。

$$
\left\{
\begin{aligned}
& \textit{right}[x-l+1][y-l+1] \ge l \\
& \textit{down}[x-l+1][y-l+1] \ge l \\
& \textit{up}[x][y] \ge l \\
& \textit{left}[x][y] \ge l \\
\end{aligned}
\right.
$$

我们只需要求出以 $(x,y)$ 为起点四个方向上连续 $1$ 的数目，枚举边长 $l$ 即可求出以 $(x,y)$ 为右下顶点构成的边界为 $1$ 的最大正方形，此时我们可以求出矩阵中边界为 $1$ 的最大正方形。

本题即转换为求矩阵中任意位置 $(x,y)$ 为起点上下左右四个方向连续 $1$ 的最大数目，此时可以利用动态规划：

+ 如果当前 $\textit{grid}[x][x] = 0$，此时四个方向的连续 $1$ 的长度均为 $0$；

+ 如果当前 $\textit{grid}[x][x] = 1$，此时四个方向的连续 $1$ 的最大数目分别等于四个方向上前一个位置的最大数目加 $1$，计算公式如下：

$$
\left\{
\begin{aligned}
& \textit{right}[x][y] = \textit{right}[x][y + 1] + 1\\
& \textit{down}[x][y] = \textit{down}[x + 1][y] + 1\\
& \textit{up}[x][y] =  \textit{up}[x-1][y] + 1\\
& \textit{left}[x][y] =  \textit{left}[x][y - 1] + 1\\
\end{aligned}
\right.
$$

在实际计算过程中我们可以进行优化，不必全部计算出四个方向上的最大连续 $1$ 的数目，可以进行如下优化：

+ 只需要求出每个位置 $(x,y)$ 为起点左侧连续 $1$ 的最大数目 $\textit{left}[x][y]$ 与上方连续 $1$ 的最大数目 $\textit{up}[x][y]$ 即可。假设当前正方形的边长为 $l$，此时只需检测 $\textit{up}[x][y],\textit{left}[x][y],\textit{left}[x-l+1][y],\textit{up}[x][y-l+1]$ 是否均满足大于等于 $l$ 即可检测正方形的合法性。
  
+ 枚举正方形的边长时可以从大到小进行枚举，我们已经知道以 $(x,y)$ 为起点左侧连续 $1$ 的最大数目 $\textit{left}[x][y]$ 与上方连续 $1$ 的最大数目 $\textit{up}[x][y]$，此时能够成正方形的边长的最大值一定不会超过二者中的最小值 $\min(\textit{left}[x][y],\textit{up}[x][y])$，从大到小枚举直到可以构成「合法」的正方形即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def largest1BorderedSquare(self, grid):
        m, n = len(grid), len(grid[0])
        left = [[0] * (n + 1) for _ in range(m + 1)]
        up = [[0] * (n + 1) for _ in range(m + 1)]
        maxBorder = 0
        for i in range(1, m + 1):
            for j in range(1, n + 1):
                if grid[i - 1][j - 1]:
                    left[i][j] = left[i][j - 1] + 1
                    up[i][j] = up[i - 1][j] + 1
                    border = min(left[i][j], up[i][j])
                    while left[i - border + 1][j] < border or up[i][j - border + 1] < border:
                        border -= 1
                    maxBorder = max(maxBorder, border)
        return maxBorder ** 2
```

```C++ [sol1-C++]
class Solution {
public:
    int largest1BorderedSquare(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();
        vector<vector<int>> left(m + 1, vector<int>(n + 1));
        vector<vector<int>> up(m + 1, vector<int>(n + 1));
        int maxBorder = 0;
        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (grid[i - 1][j - 1] == 1) {
                    left[i][j] = left[i][j - 1] + 1;
                    up[i][j] = up[i - 1][j] + 1;
                    int border = min(left[i][j], up[i][j]);
                    while (left[i - border + 1][j] < border || up[i][j - border + 1] < border) {
                        border--;
                    }
                    maxBorder = max(maxBorder, border);
                }
            }
        }
        return maxBorder * maxBorder;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int largest1BorderedSquare(int[][] grid) {
        int m = grid.length, n = grid[0].length;
        int[][] left = new int[m + 1][n + 1];
        int[][] up = new int[m + 1][n + 1];
        int maxBorder = 0;
        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (grid[i - 1][j - 1] == 1) {
                    left[i][j] = left[i][j - 1] + 1;
                    up[i][j] = up[i - 1][j] + 1;
                    int border = Math.min(left[i][j], up[i][j]);
                    while (left[i - border + 1][j] < border || up[i][j - border + 1] < border) {
                        border--;
                    }
                    maxBorder = Math.max(maxBorder, border);
                }
            }
        }
        return maxBorder * maxBorder;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int Largest1BorderedSquare(int[][] grid) {
        int m = grid.Length, n = grid[0].Length;
        int[][] left = new int[m + 1][];
        int[][] up = new int[m + 1][];
        for (int i = 0; i <= m; i++) {
            left[i] = new int[n + 1];
            up[i] = new int[n + 1];
        }
        int maxBorder = 0;
        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (grid[i - 1][j - 1] == 1) {
                    left[i][j] = left[i][j - 1] + 1;
                    up[i][j] = up[i - 1][j] + 1;
                    int border = Math.Min(left[i][j], up[i][j]);
                    while (left[i - border + 1][j] < border || up[i][j - border + 1] < border) {
                        border--;
                    }
                    maxBorder = Math.Max(maxBorder, border);
                }
            }
        }
        return maxBorder * maxBorder;
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int largest1BorderedSquare(int** grid, int gridSize, int* gridColSize) {
    int m = gridSize, n = gridColSize[0];
    int left[m + 1][n + 1], up[m + 1][n + 1];
    memset(left, 0, sizeof(left));
    memset(up, 0, sizeof(up));
    int maxBorder = 0;
    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (grid[i - 1][j - 1] == 1) {
                left[i][j] = left[i][j - 1] + 1;
                up[i][j] = up[i - 1][j] + 1;
                int border = MIN(left[i][j], up[i][j]);
                while (left[i - border + 1][j] < border || up[i][j - border + 1] < border) {
                    border--;
                }
                maxBorder = MAX(maxBorder, border);
            }
        }
    }
    return maxBorder * maxBorder;
}
```

```JavaScript [sol1-JavaScript]
var largest1BorderedSquare = function(grid) {
    const m = grid.length, n = grid[0].length;
    const left = new Array(m + 1).fill(0).map(() => new Array(n + 1).fill(0));
    const up = new Array(m + 1).fill(0).map(() => new Array(n + 1).fill(0));
    let maxBorder = 0;
    for (let i = 1; i <= m; i++) {
        for (let j = 1; j <= n; j++) {
            if (grid[i - 1][j - 1] === 1) {
                left[i][j] = left[i][j - 1] + 1;
                up[i][j] = up[i - 1][j] + 1;
                let border = Math.min(left[i][j], up[i][j]);
                while (left[i - border + 1][j] < border || up[i][j - border + 1] < border) {
                    border--;
                }
                maxBorder = Math.max(maxBorder, border);
            }
        }
    }
    return maxBorder * maxBorder;
};
```

```go [sol1-Golang]
func largest1BorderedSquare(grid [][]int) int {
    m, n := len(grid), len(grid[0])
    left := make([][]int, m+1)
    up := make([][]int, m+1)
    for i := range left {
        left[i] = make([]int, n+1)
        up[i] = make([]int, n+1)
    }
    maxBorder := 0
    for i := 1; i <= m; i++ {
        for j := 1; j <= n; j++ {
            if grid[i-1][j-1] == 1 {
                left[i][j] = left[i][j-1] + 1
                up[i][j] = up[i-1][j] + 1
                border := min(left[i][j], up[i][j])
                for left[i-border+1][j] < border || up[i][j-border+1] < border {
                    border--
                }
                maxBorder = max(maxBorder, border)
            }
        }
    }
    return maxBorder * maxBorder
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(m \times n \times \min(m,n))$，其中 $m$ 表示矩阵的行数，$n$ 表示矩阵的列数。

- 空间复杂度：$O(m \times n)$，其中 $m$ 表示矩阵的行数，$n$ 表示矩阵的列数。需要保存矩阵中每个位置的最长连续 $1$ 的数目，需要的空间为 $O(m \times n)$。
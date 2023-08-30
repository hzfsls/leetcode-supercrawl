#### 方法一：动态规划

由于从 $(N-1,N-1)$ 返回 $(0,0)$ 的这条路径，可以等价地看成从 $(0,0)$ 到 $(N-1,N-1)$ 的路径，因此问题可以等价转换成，有两个人从 $(0,0)$ 出发，向下或向右走到 $(N-1,N-1)$ 时，摘到的樱桃个数之和的最大值。

由于题目限制同一个格子只能摘取一次，我们需要找到一种方案来判断两人是否到达了同一个格子。

不妨假设两人同时出发，且速度相同。无论这两人怎么走，在时间相同的情况下，他们向右走的步数加上向下走的步数之和是一个定值（设为 $k$）。设两人的坐标为 $(x_1,y_1)$ 和 $(x_2,y_2)$，则 $x_1+y_1 = x_2+y_2 = k$。那么当 $x_1=x_2$ 时，必然有 $y_1=y_2$，即两个人到达了同一个格子。

定义 $f[k][x_1][x_2]$ 表示两个人（设为 A 和 B）分别从 $(x_1,k-x_1)$ 和 $(x_2,k-x_2)$ 同时出发，到达 $(N-1,N-1)$ 摘到的樱桃个数之和的最大值。

如果 $(x_1,k-x_1)$ 或 $(x_2,k-x_2)$ 是荆棘，则 $f[k][x_1][x_2]=-\infty$，表示不合法的情况。

枚举 A 和 B 上一步的走法，来计算 $f[k][x_1][x_2]$。有四种情况：

- 都往右：从 $f[k-1][x_1][x_2]$ 转移过来；
- A 往下，B 往右：从 $f[k-1][x_1-1][x_2]$ 转移过来；
- A 往右，B 往下：从 $f[k-1][x_1][x_2-1]$ 转移过来；
- 都往下：从 $f[k-1][x_1-1][x_2-1]$ 转移过来；

取这四种情况的最大值，加上 $\textit{grid}[x_1][k-x_1]$ 和 $\textit{grid}[x_2][k-x_2]$ 的值，就得到了 $f[k][x_1][x_2]$，如果 $x_1=x_2$，则只需加上 $\textit{grid}[x_1][k-x_1]$。

最后答案为 $\max(f[2n-2][n-1][n-1],0)$，取 $\max$ 是因为路径可能被荆棘挡住，无法从 $(0,0)$ 到达 $(N-1,N-1)$。

代码实现时，我们可以将 A 和 B 走出的路径的上轮廓看成是 A 走出的路径，下轮廓看成是 B 走出的路径，即视作 A 始终不会走到 B 的下方，则有 $x_1\le x_2$，在代码实现时保证这一点，可以减少循环次数。

```Python [sol1-Python3]
class Solution:
    def cherryPickup(self, grid: List[List[int]]) -> int:
        n = len(grid)
        f = [[[-inf] * n for _ in range(n)] for _ in range(n * 2 - 1)]
        f[0][0][0] = grid[0][0]
        for k in range(1, n * 2 - 1):
            for x1 in range(max(k - n + 1, 0), min(k + 1, n)):
                y1 = k - x1
                if grid[x1][y1] == -1:
                    continue
                for x2 in range(x1, min(k + 1, n)):
                    y2 = k - x2
                    if grid[x2][y2] == -1:
                        continue
                    res = f[k - 1][x1][x2]  # 都往右
                    if x1:
                        res = max(res, f[k - 1][x1 - 1][x2])  # 往下，往右
                    if x2:
                        res = max(res, f[k - 1][x1][x2 - 1])  # 往右，往下
                    if x1 and x2:
                        res = max(res, f[k - 1][x1 - 1][x2 - 1])  # 都往下
                    res += grid[x1][y1]
                    if x2 != x1:  # 避免重复摘同一个樱桃
                        res += grid[x2][y2]
                    f[k][x1][x2] = res
        return max(f[-1][-1][-1], 0)
```

```C++ [sol1-C++]
class Solution {
public:
    int cherryPickup(vector<vector<int>> &grid) {
        int n = grid.size();
        vector<vector<vector<int>>> f(n * 2 - 1, vector<vector<int>>(n, vector<int>(n, INT_MIN)));
        f[0][0][0] = grid[0][0];
        for (int k = 1; k < n * 2 - 1; ++k) {
            for (int x1 = max(k - n + 1, 0); x1 <= min(k, n - 1); ++x1) {
                int y1 = k - x1;
                if (grid[x1][y1] == -1) {
                    continue;
                }
                for (int x2 = x1; x2 <= min(k, n - 1); ++x2) {
                    int y2 = k - x2;
                    if (grid[x2][y2] == -1) {
                        continue;
                    }
                    int res = f[k - 1][x1][x2]; // 都往右
                    if (x1) {
                        res = max(res, f[k - 1][x1 - 1][x2]); // 往下，往右
                    }
                    if (x2) {
                        res = max(res, f[k - 1][x1][x2 - 1]); // 往右，往下
                    }
                    if (x1 && x2) {
                        res = max(res, f[k - 1][x1 - 1][x2 - 1]); // 都往下
                    }
                    res += grid[x1][y1];
                    if (x2 != x1) { // 避免重复摘同一个樱桃
                        res += grid[x2][y2];
                    }
                    f[k][x1][x2] = res;
                }
            }
        }
        return max(f.back().back().back(), 0);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int cherryPickup(int[][] grid) {
        int n = grid.length;
        int[][][] f = new int[n * 2 - 1][n][n];
        for (int i = 0; i < n * 2 - 1; ++i) {
            for (int j = 0; j < n; ++j) {
                Arrays.fill(f[i][j], Integer.MIN_VALUE);
            }
        }
        f[0][0][0] = grid[0][0];
        for (int k = 1; k < n * 2 - 1; ++k) {
            for (int x1 = Math.max(k - n + 1, 0); x1 <= Math.min(k, n - 1); ++x1) {
                int y1 = k - x1;
                if (grid[x1][y1] == -1) {
                    continue;
                }
                for (int x2 = x1; x2 <= Math.min(k, n - 1); ++x2) {
                    int y2 = k - x2;
                    if (grid[x2][y2] == -1) {
                        continue;
                    }
                    int res = f[k - 1][x1][x2]; // 都往右
                    if (x1 > 0) {
                        res = Math.max(res, f[k - 1][x1 - 1][x2]); // 往下，往右
                    }
                    if (x2 > 0) {
                        res = Math.max(res, f[k - 1][x1][x2 - 1]); // 往右，往下
                    }
                    if (x1 > 0 && x2 > 0) {
                        res = Math.max(res, f[k - 1][x1 - 1][x2 - 1]); // 都往下
                    }
                    res += grid[x1][y1];
                    if (x2 != x1) { // 避免重复摘同一个樱桃
                        res += grid[x2][y2];
                    }
                    f[k][x1][x2] = res;
                }
            }
        }
        return Math.max(f[n * 2 - 2][n - 1][n - 1], 0);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CherryPickup(int[][] grid) {
        int n = grid.Length;
        int[,,] f = new int[n * 2 - 1, n, n];
        for (int i = 0; i < n * 2 - 1; ++i) {
            for (int j = 0; j < n; ++j) {
                for (int k = 0; k < n; ++k) {
                    f[i, j, k] = int.MinValue;
                }
            }
        }
        f[0, 0, 0] = grid[0][0];
        for (int k = 1; k < n * 2 - 1; ++k) {
            for (int x1 = Math.Max(k - n + 1, 0); x1 <= Math.Min(k, n - 1); ++x1) {
                int y1 = k - x1;
                if (grid[x1][y1] == -1) {
                    continue;
                }
                for (int x2 = x1; x2 <= Math.Min(k, n - 1); ++x2) {
                    int y2 = k - x2;
                    if (grid[x2][y2] == -1) {
                        continue;
                    }
                    int res = f[k - 1, x1, x2]; // 都往右
                    if (x1 > 0) {
                        res = Math.Max(res, f[k - 1, x1 - 1, x2]); // 往下，往右
                    }
                    if (x2 > 0) {
                        res = Math.Max(res, f[k - 1, x1, x2 - 1]); // 往右，往下
                    }
                    if (x1 > 0 && x2 > 0) {
                        res = Math.Max(res, f[k - 1, x1 - 1, x2 - 1]); // 都往下
                    }
                    res += grid[x1][y1];
                    if (x2 != x1) { // 避免重复摘同一个樱桃
                        res += grid[x2][y2];
                    }
                    f[k, x1, x2] = res;
                }
            }
        }
        return Math.Max(f[n * 2 - 2, n - 1, n - 1], 0);
    }
}
```

```go [sol1-Golang]
func cherryPickup(grid [][]int) int {
    n := len(grid)
    f := make([][][]int, n*2-1)
    for i := range f {
        f[i] = make([][]int, n)
        for j := range f[i] {
            f[i][j] = make([]int, n)
            for k := range f[i][j] {
                f[i][j][k] = math.MinInt32
            }
        }
    }
    f[0][0][0] = grid[0][0]
    for k := 1; k < n*2-1; k++ {
        for x1 := max(k-n+1, 0); x1 <= min(k, n-1); x1++ {
            y1 := k - x1
            if grid[x1][y1] == -1 {
                continue
            }
            for x2 := x1; x2 <= min(k, n-1); x2++ {
                y2 := k - x2
                if grid[x2][y2] == -1 {
                    continue
                }
                res := f[k-1][x1][x2] // 都往右
                if x1 > 0 {
                    res = max(res, f[k-1][x1-1][x2]) // 往下，往右
                }
                if x2 > 0 {
                    res = max(res, f[k-1][x1][x2-1]) // 往右，往下
                }
                if x1 > 0 && x2 > 0 {
                    res = max(res, f[k-1][x1-1][x2-1]) // 都往下
                }
                res += grid[x1][y1]
                if x2 != x1 { // 避免重复摘同一个樱桃
                    res += grid[x2][y2]
                }
                f[k][x1][x2] = res
            }
        }
    }
    return max(f[n*2-2][n-1][n-1], 0)
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int cherryPickup(int** grid, int gridSize, int* gridColSize){
    int n = gridSize;
    int ***f = (int ***)malloc(sizeof(int **) * (n * 2 - 1));
    for (int i = 0; i < n * 2 - 1; ++i) {
        f[i] = (int **)malloc(sizeof(int *) * n);
        for (int j = 0; j < n; ++j) {
            f[i][j] = (int *)malloc(sizeof(int) * n);
            for (int k = 0; k < n; ++k) {
                f[i][j][k] = INT_MIN;
            }
        }
    }
    f[0][0][0] = grid[0][0];
    for (int k = 1; k < n * 2 - 1; ++k) {
        for (int x1 = MAX(k - n + 1, 0); x1 <= MIN(k, n - 1); ++x1) {
            int y1 = k - x1;
            if (grid[x1][y1] == -1) {
                continue;
            }
            for (int x2 = x1; x2 <= MIN(k, n - 1); ++x2) {
                int y2 = k - x2;
                if (grid[x2][y2] == -1) {
                    continue;
                }
                int res = f[k - 1][x1][x2]; // 都往右
                if (x1) {
                    res = MAX(res, f[k - 1][x1 - 1][x2]); // 往下，往右
                }
                if (x2) {
                    res = MAX(res, f[k - 1][x1][x2 - 1]); // 往右，往下
                }
                if (x1 && x2) {
                    res = MAX(res, f[k - 1][x1 - 1][x2 - 1]); // 都往下
                }
                res += grid[x1][y1];
                if (x2 != x1) { // 避免重复摘同一个樱桃
                    res += grid[x2][y2];
                }
                f[k][x1][x2] = res;
            }
        }
    }
    int ret = MAX(f[n * 2 - 2][n - 1][n - 1], 0);
    for (int i = 0; i < n * 2 - 1; ++i) {
        for (int j = 0; j < n; ++j) {
            free(f[i][j]);
        }
        free(f[i]);
    }
    free(f);
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var cherryPickup = function(grid) {
    const n = grid.length;
    const f = new Array(n * 2 - 1).fill(0).map(() => new Array(n).fill(0).map(() => new Array(n).fill(-Number.MAX_VALUE)));
    f[0][0][0] = grid[0][0];
    for (let k = 1; k < n * 2 - 1; ++k) {
        for (let x1 = Math.max(k - n + 1, 0); x1 <= Math.min(k, n - 1); ++x1) {
            const y1 = k - x1;
            if (grid[x1][y1] === -1) {
                continue;
            }
            for (let x2 = x1; x2 <= Math.min(k, n - 1); ++x2) {
                let y2 = k - x2;
                if (grid[x2][y2] === -1) {
                    continue;
                }
                let res = f[k - 1][x1][x2]; // 都往右
                if (x1 > 0) {
                    res = Math.max(res, f[k - 1][x1 - 1][x2]); // 往下，往右
                }
                if (x2 > 0) {
                    res = Math.max(res, f[k - 1][x1][x2 - 1]); // 往右，往下
                }
                if (x1 > 0 && x2 > 0) {
                    res = Math.max(res, f[k - 1][x1 - 1][x2 - 1]); // 都往下
                }
                res += grid[x1][y1];
                if (x2 !== x1) { // 避免重复摘同一个樱桃
                    res += grid[x2][y2];
                }
                f[k][x1][x2] = res;
            }
        }
    }
    return Math.max(f[n * 2 - 2][n - 1][n - 1], 0);
};
```

由于 $f[k][][]$ 都是从 $f[k-1][][]$ 转移过来的，我们可以通过倒序循环 $x_1$ 和 $x_2$，来优化掉第一个维度。

为什么要倒序循环呢？在去掉第一个维度后，若正序循环 $x_1$ 和 $x_2$，在计算 $f[x_1][x_2]$ 时，转移来源 $f[x'_1][x'_2]$ 的值已经被覆盖（因为 $x'_1\le x_1$ 以及 $x'_2\le x_2$），这意味着 $f[x'_1][x'_2]$ 实际对应的是 $f[k][x'_1][x'_2]$。

若倒序循环，则可消除该错误，这种方式保证计算 $f[x_1][x_2]$ 时，转移来源 $f[x'_1][x'_2]$ 的值尚未被覆盖，实际对应的是 $f[k-1][x'_1][x'_2]$，从而保证转移方程与去掉维度前一致。

```Python [sol2-Python3]
class Solution:
    def cherryPickup(self, grid: List[List[int]]) -> int:
        n = len(grid)
        f = [[-inf] * n for _ in range(n)]
        f[0][0] = grid[0][0]
        for k in range(1, n * 2 - 1):
            for x1 in range(min(k, n - 1), max(k - n, -1), -1):
                for x2 in range(min(k, n - 1), x1 - 1, -1):
                    y1, y2 = k - x1, k - x2
                    if grid[x1][y1] == -1 or grid[x2][y2] == -1:
                        f[x1][x2] = -inf
                        continue
                    res = f[x1][x2]  # 都往右
                    if x1:
                        res = max(res, f[x1 - 1][x2])  # 往下，往右
                    if x2:
                        res = max(res, f[x1][x2 - 1])  # 往右，往下
                    if x1 and x2:
                        res = max(res, f[x1 - 1][x2 - 1])  # 都往下
                    res += grid[x1][y1]
                    if x2 != x1:  # 避免重复摘同一个樱桃
                        res += grid[x2][y2]
                    f[x1][x2] = res
        return max(f[-1][-1], 0)
```

```C++ [sol2-C++]
class Solution {
public:
    int cherryPickup(vector<vector<int>> &grid) {
        int n = grid.size();
        vector<vector<int>> f(n, vector<int>(n, INT_MIN));
        f[0][0] = grid[0][0];
        for (int k = 1; k < n * 2 - 1; ++k) {
            for (int x1 = min(k, n - 1); x1 >= max(k - n + 1, 0); --x1) {
                for (int x2 = min(k, n - 1); x2 >= x1; --x2) {
                    int y1 = k - x1, y2 = k - x2;
                    if (grid[x1][y1] == -1 || grid[x2][y2] == -1) {
                        f[x1][x2] = INT_MIN;
                        continue;
                    }
                    int res = f[x1][x2]; // 都往右
                    if (x1) {
                        res = max(res, f[x1 - 1][x2]); // 往下，往右
                    }
                    if (x2) {
                        res = max(res, f[x1][x2 - 1]); // 往右，往下
                    }
                    if (x1 && x2) {
                        res = max(res, f[x1 - 1][x2 - 1]); // 都往下
                    }
                    res += grid[x1][y1];
                    if (x2 != x1) { // 避免重复摘同一个樱桃
                        res += grid[x2][y2];
                    }
                    f[x1][x2] = res;
                }
            }
        }
        return max(f.back().back(), 0);
    }
};
```

```Java [sol2-Java]
class Solution {
    public int cherryPickup(int[][] grid) {
        int n = grid.length;
        int[][] f = new int[n][n];
        for (int i = 0; i < n; ++i) {
            Arrays.fill(f[i], Integer.MIN_VALUE);
        }
        f[0][0] = grid[0][0];
        for (int k = 1; k < n * 2 - 1; ++k) {
            for (int x1 = Math.min(k, n - 1); x1 >= Math.max(k - n + 1, 0); --x1) {
                for (int x2 = Math.min(k, n - 1); x2 >= x1; --x2) {
                    int y1 = k - x1, y2 = k - x2;
                    if (grid[x1][y1] == -1 || grid[x2][y2] == -1) {
                        f[x1][x2] = Integer.MIN_VALUE;
                        continue;
                    }
                    int res = f[x1][x2]; // 都往右
                    if (x1 > 0) {
                        res = Math.max(res, f[x1 - 1][x2]); // 往下，往右
                    }
                    if (x2 > 0) {
                        res = Math.max(res, f[x1][x2 - 1]); // 往右，往下
                    }
                    if (x1 > 0 && x2 > 0) {
                        res = Math.max(res, f[x1 - 1][x2 - 1]); // 都往下
                    }
                    res += grid[x1][y1];
                    if (x2 != x1) { // 避免重复摘同一个樱桃
                        res += grid[x2][y2];
                    }
                    f[x1][x2] = res;
                }
            }
        }
        return Math.max(f[n - 1][n - 1], 0);
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int CherryPickup(int[][] grid) {
        int n = grid.Length;
        int[,] f = new int[n, n];
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                f[i, j] = int.MinValue;
            }
        }
        f[0, 0] = grid[0][0];
        for (int k = 1; k < n * 2 - 1; ++k) {
            for (int x1 = Math.Min(k, n - 1); x1 >= Math.Max(k - n + 1, 0); --x1) {
                for (int x2 = Math.Min(k, n - 1); x2 >= x1; --x2) {
                    int y1 = k - x1, y2 = k - x2;
                    if (grid[x1][y1] == -1 || grid[x2][y2] == -1) {
                        f[x1, x2] = int.MinValue;
                        continue;
                    }
                    int res = f[x1, x2]; // 都往右
                    if (x1 > 0) {
                        res = Math.Max(res, f[x1 - 1, x2]); // 往下，往右
                    }
                    if (x2 > 0) {
                        res = Math.Max(res, f[x1, x2 - 1]); // 往右，往下
                    }
                    if (x1 > 0 && x2 > 0) {
                        res = Math.Max(res, f[x1 - 1, x2 - 1]); // 都往下
                    }
                    res += grid[x1][y1];
                    if (x2 != x1) { // 避免重复摘同一个樱桃
                        res += grid[x2][y2];
                    }
                    f[x1, x2] = res;
                }
            }
        }
        return Math.Max(f[n - 1, n - 1], 0);
    }
}
```

```go [sol2-Golang]
func cherryPickup(grid [][]int) int {
    n := len(grid)
    f := make([][]int, n)
    for i := range f {
        f[i] = make([]int, n)
        for j := range f[i] {
            f[i][j] = math.MinInt32
        }
    }
    f[0][0] = grid[0][0]
    for k := 1; k < n*2-1; ++k {
        for x1 := min(k, n-1); x1 >= max(k-n+1, 0); x1-- {
            for x2 := min(k, n-1); x2 >= x1; x2-- {
                y1, y2 := k-x1, k-x2
                if grid[x1][y1] == -1 || grid[x2][y2] == -1 {
                    f[x1][x2] = math.MinInt32
                    continue
                }
                res := f[x1][x2] // 都往右
                if x1 > 0 {
                    res = max(res, f[x1-1][x2]) // 往下，往右
                }
                if x2 > 0 {
                    res = max(res, f[x1][x2-1]) // 往右，往下
                }
                if x1 > 0 && x2 > 0 {
                    res = max(res, f[x1-1][x2-1]) // 都往下
                }
                res += grid[x1][y1]
                if x2 != x1 { // 避免重复摘同一个樱桃
                    res += grid[x2][y2]
                }
                f[x1][x2] = res
            }
        }
    }
    return max(f[n-1][n-1], 0)
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

```C [sol2-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int cherryPickup(int** grid, int gridSize, int* gridColSize){
    int n = gridSize;
    int **f = (int **)malloc(sizeof(int *) * n);
    for (int i = 0; i < n; ++i) {
        f[i] = (int *)malloc(sizeof(int) * n);
        for (int j = 0; j < n; ++j) {
            f[i][j] = INT_MIN;
        }
    }
    f[0][0] = grid[0][0];
    for (int k = 1; k < n * 2 - 1; ++k) {
        for (int x1 = MIN(k, n - 1); x1 >= MAX(k - n + 1, 0); --x1) {
            for (int x2 = MIN(k, n - 1); x2 >= x1; --x2) {
                int y1 = k - x1, y2 = k - x2;
                if (grid[x1][y1] == -1 || grid[x2][y2] == -1) {
                    f[x1][x2] = INT_MIN;
                    continue;
                }
                int res = f[x1][x2]; // 都往右
                if (x1) {
                    res = MAX(res, f[x1 - 1][x2]); // 往下，往右
                }
                if (x2) {
                    res = MAX(res, f[x1][x2 - 1]); // 往右，往下
                }
                if (x1 && x2) {
                    res = MAX(res, f[x1 - 1][x2 - 1]); // 都往下
                }
                res += grid[x1][y1];
                if (x2 != x1) { // 避免重复摘同一个樱桃
                    res += grid[x2][y2];
                }
                f[x1][x2] = res;
            }
        }
    }
    int ret = MAX(f[n - 1][n - 1], 0);
    for (int i = 0; i < n; ++i) {
        free(f[i]);
    }
    free(f);
    return ret;
}
```

```JavaScript [sol2-JavaScript]
var cherryPickup = function(grid) {
    const n = grid.length;
    const f = new Array(n).fill(0).map(() => new Array(n).fill(-Number.MAX_VALUE));
    f[0][0] = grid[0][0];
    for (let k = 1; k < n * 2 - 1; ++k) {
        for (let x1 = Math.min(k, n - 1); x1 >= Math.max(k - n + 1, 0); --x1) {
            for (let x2 = Math.min(k, n - 1); x2 >= x1; --x2) {
                const y1 = k - x1, y2 = k - x2;
                if (grid[x1][y1] === -1 || grid[x2][y2] === -1) {
                    f[x1][x2] = -Number.MAX_VALUE;
                    continue;
                }
                let res = f[x1][x2]; // 都往右
                if (x1 > 0) {
                    res = Math.max(res, f[x1 - 1][x2]); // 往下，往右
                }
                if (x2 > 0) {
                    res = Math.max(res, f[x1][x2 - 1]); // 往右，往下
                }
                if (x1 > 0 && x2 > 0) {
                    res = Math.max(res, f[x1 - 1][x2 - 1]); //都往下
                }
                res += grid[x1][y1];
                if (x2 !== x1) { // 避免重复摘同一个樱桃
                    res += grid[x2][y2];
                }
                f[x1][x2] = res;
            }
        }
    }
    return Math.max(f[n - 1][n - 1], 0);
};
```

**复杂度分析**

- 时间复杂度：$O(N^3)$，其中 $N$ 是矩阵 $\textit{grid}$ 的长宽。

- 空间复杂度：$O(N^2)$。
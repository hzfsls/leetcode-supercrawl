## [1289.下降路径最小和  II 中文官方题解](https://leetcode.cn/problems/minimum-falling-path-sum-ii/solutions/100000/xia-jiang-lu-jing-zui-xiao-he-ii-by-leetcode-solut)
#### 方法一：动态规划

**思路与算法**

我们可以使用动态规划来解决这个问题。

令状态 $f[i][j]$ 表示从数组 $\textit{grid}$ 的前 $i$ 行中的每一行选择一个数字，并且第 $i$ 行选择的数字为 $grid[i][j]$ 时，可以得到的路径和最小值。$f[i][j]$ 可以从第 $i - 1$ 行除了 $f[i - 1][j]$ 之外的任意状态转移而来，因此有如下状态转移方程：

$$
f[i][j] = \begin{cases}
\textit{grid}[0][j] & \text{if} \quad i = 0  \\
\min(f[i-1][k]) + \textit{grid}[i][j] & \text{if} \quad i \ne 0, j \ne k
\end{cases}
$$

最终，我们取第 $n - 1$ 行中的最小值，即最小的 $\min(f[n][j])$ 作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minFallingPathSum(vector<vector<int>>& grid) {
        int n = grid.size();
        vector<vector<int>> d(n, vector<int>(n, INT_MAX));
        for (int i = 0; i < n; i++) {
            d[0][i] = grid[0][i];
        }
        for (int i = 1; i < n; i++) {
            for (int j = 0; j < n; j++) {
                for (int k = 0; k < n; k++) {
                    if (j == k) {
                        continue;
                    }
                    d[i][j] = min(d[i][j], d[i - 1][k] + grid[i][j]);
                }
            }
        }
        int res = INT_MAX;
        for (int j = 0; j < n; j++) {
            res = min(res, d[n - 1][j]);
        }
        return res;
    }
};
```

```C [sol1-C]
const int INF = 0x3f3f3f3f;

int minFallingPathSum(int** grid, int gridSize, int* gridColSize){
    int n = gridSize;
    int d[n][n];
    memset(d, 0x3f, sizeof(d));
    for (int i = 0; i < n; i++) {
        d[0][i] = grid[0][i];
    }
    for (int i = 1; i < n; i++) {
        for (int j = 0; j < n; j++) {
            for (int k = 0; k < n; k++) {
                if (j == k) {
                    continue;
                }
                d[i][j] = fmin(d[i][j], d[i - 1][k] + grid[i][j]);
            }
        }
    }
    int res = INT_MAX;
    for (int j = 0; j < n; j++) {
        res = fmin(res, d[n - 1][j]);
    }
    return res;
}
```

```Java [sol1-Java]
class Solution {
    public int minFallingPathSum(int[][] grid) {
        int n = grid.length;
        int[][] d = new int[n][n];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                d[i][j] = Integer.MAX_VALUE;
            }
        }
        for (int i = 0; i < n; i++) {
            d[0][i] = grid[0][i];
        }
        for (int i = 1; i < n; i++) {
            for (int j = 0; j < n; j++) {
                for (int k = 0; k < n; k++) {
                    if (j == k) {
                        continue;
                    }
                    d[i][j] = Math.min(d[i][j], d[i - 1][k] + grid[i][j]);
                }
            }
        }
        int res = Integer.MAX_VALUE;
        for (int j = 0; j < n; j++) {
            res = Math.min(res, d[n - 1][j]);
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinFallingPathSum(int[][] grid) {
        int n = grid.Length;
        int[][] d = new int[n][];
        for (int i = 0; i < n; i++) {
            d[i] = new int[n];
            for (int j = 0; j < n; j++) {
                d[i][j] = int.MaxValue;
            }
        }
        for (int i = 0; i < n; i++) {
            d[0][i] = grid[0][i];
        }
        for (int i = 1; i < n; i++) {
            for (int j = 0; j < n; j++) {
                for (int k = 0; k < n; k++) {
                    if (j == k) {
                        continue;
                    }
                    d[i][j] = Math.Min(d[i][j], d[i - 1][k] + grid[i][j]);
                }
            }
        }
        int res = int.MaxValue;
        for (int j = 0; j < n; j++) {
            res = Math.Min(res, d[n - 1][j]);
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minFallingPathSum(self, grid: List[List[int]]) -> int:
        n = len(grid)
        d = [[10**9 for _ in range(n)] for _ in range(n)]
        for i in range(n):
            d[0][i] = grid[0][i]
        for i in range(n):
            for j in range(n):
                for k in range(n):
                    if j == k:
                        continue
                    d[i][j] = min(d[i][j], d[i - 1][k] + grid[i][j])
        return min(d[n - 1])
```

```Go [sol1-Go]
func minFallingPathSum(grid [][]int) int {
    n := len(grid)
    d := make([][]int, n)
    for i := 0; i < n; i++ {
        d[i] = make([]int, n)
        for j := 0; j < n; j++ {
            d[i][j] = math.MaxInt
        }
    }
    for i := 0; i < n; i++ {
        d[0][i] = grid[0][i]
    }
    for i := 1; i < n; i++ {
        for j := 0; j < n; j++ {
            for k := 0; k < n; k++ {
                if j == k {
                    continue
                }
                d[i][j] = min(d[i][j], d[i - 1][k] + grid[i][j])
            }
        }
    }
    res := math.MaxInt
    for i := 0; i < n; i++ {
        res = min(res, d[n - 1][i])
    }
    return res
}

func min(a int, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var minFallingPathSum = function(grid) {
    const n = grid.length;
    const d = new Array(n).fill(0).map(() => new Array(n).fill(Infinity));
    for (let i = 0; i < n; i++) {
        d[0][i] = grid[0][i];
    }
    for (let i = 1; i < n; i++) {
        for (let j = 0; j < n; j++) {
            for (let k = 0; k < n; k++) {
                if (j == k) {
                    continue;
                }
                d[i][j] = Math.min(d[i][j], d[i - 1][k] + grid[i][j]);
            }
        }
    }
    return Math.min(...d[n - 1]);
};
```

**复杂度分析**

- 时间复杂度：$O(n^3)$，其中 $n$ 是 $\textit{grid}$ 的行数和列数。我们使用三重循环来求解答案，每一层循环的复杂度为 $O(n)$，第 $0$ 层单独求解和最终答案遍历的时间复杂度均为 $O(n)$，因此总的时间复杂度为 $O(n^3)$。

- 空间复杂度：$O(n^2)$。我们使用二维数组 $d[i][j]$ 来存储过程中的答案，实际上可以使用滚动数组优化至 $O(n)$。

#### 方法二：转移过程优化

**思路与算法**

不难发现，求解第 $i$ 行中所有的 $f[i][j]$ 时，有很多状态在转移时所依赖的 $\min(f[i-1][k])$ 是相同的。我们令 $\textit{first\_min\_sum}$ 为第 $i - 1$ 行状态中的最小值，$\textit{first\_min\_index}$ 为最小值对应的下标，$\textit{second\_min\_sum}$ 为状态次小值。那么有如下转移方程：

$$
f[i][j] = \begin{cases}
\textit{grid}[0][j] & \text{if} \quad i = 0 \\
\textit{first\_min\_sum} + grid[i][j] & \text{if} \quad i \ne 0, j \ne \textit{first\_min\_index} \\
\textit{second\_min\_sum} + grid[i][j] & \text{if} \quad i \ne 0, j =\textit{first\_min\_index} \\
\end{cases}
$$

对于 $i=0$ 的情况，我们不做变动。对于 $i\ne 0$ 情况，判断当前遍历到的下标 $j$ 是否与上一行状态中的最小值下标 $\textit{first\_min\_index}$ 相同，若相同，取次小值 $\textit{second\_min\_sum}$ 转移，若不同，取 $\textit{first\_min\_sum}$ 转移。

因此，我们只需维护第 $i - 1$ 行相关的三个变量（最小值，最小值下标和次小值）就可以在 $O(1)$ 时间内求解 $f[i][j]$。在求解 $f[i][j]$ 的过程中，我们也只需记录第 $i$ 行相关的变量即可，不用把所有的 $f[i][j]$ 都保存下来。这样做可以将空间复杂度优化到 $O(1)$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int minFallingPathSum(vector<vector<int>>& grid) {
        int n = grid.size();
        int first_min_sum = 0;
        int second_min_sum = 0;
        int first_min_index = -1;
        
        for (int i = 0; i < n; i++) {
            int cur_first_min_sum = INT_MAX;
            int cur_second_min_sum = INT_MAX;
            int cur_first_min_index = -1;
            
            for (int j = 0; j < n; j++) {
                int cur_sum = (j != first_min_index ? first_min_sum : second_min_sum) + grid[i][j];
                if (cur_sum < cur_first_min_sum) {
                    cur_second_min_sum = cur_first_min_sum;
                    cur_first_min_sum = cur_sum;
                    cur_first_min_index = j;
                } else if (cur_sum < cur_second_min_sum) {
                    cur_second_min_sum = cur_sum;
                }
            }
            first_min_sum = cur_first_min_sum;
            second_min_sum = cur_second_min_sum;
            first_min_index = cur_first_min_index;
        }
        return first_min_sum;
    }
};
```

```C [sol2-C]
int minFallingPathSum(int** grid, int gridSize, int* gridColSize) {
    int first_min_sum = 0;
    int second_min_sum = 0;
    int first_min_index = -1;
    
    for (int i = 0; i < gridSize; i++) {
        int cur_first_min_sum = INT_MAX;
        int cur_second_min_sum = INT_MAX;
        int cur_first_min_index = -1;
        for (int j = 0; j < gridSize; j++) {
            int cur_sum = (j != first_min_index ? first_min_sum : second_min_sum) + grid[i][j];
            if (cur_sum < cur_first_min_sum) {
                cur_second_min_sum = cur_first_min_sum;
                cur_first_min_sum = cur_sum;
                cur_first_min_index = j;
            } else if (cur_sum < cur_second_min_sum) {
                cur_second_min_sum = cur_sum;
            }
        }
        first_min_sum = cur_first_min_sum;
        second_min_sum = cur_second_min_sum;
        first_min_index = cur_first_min_index;
    }
    return first_min_sum;
}
```

```Java [sol2-Java]
class Solution {
    public int minFallingPathSum(int[][] grid) {
        int n = grid.length;
        int first_min_sum = 0;
        int second_min_sum = 0;
        int first_min_index = -1;
        
        for (int i = 0; i < n; i++) {
            int cur_first_min_sum = Integer.MAX_VALUE;
            int cur_second_min_sum = Integer.MAX_VALUE;
            int cur_first_min_index = -1;
            
            for (int j = 0; j < n; j++) {
                int cur_sum = (j != first_min_index ? first_min_sum : second_min_sum) + grid[i][j];
                if (cur_sum < cur_first_min_sum) {
                    cur_second_min_sum = cur_first_min_sum;
                    cur_first_min_sum = cur_sum;
                    cur_first_min_index = j;
                } else if (cur_sum < cur_second_min_sum) {
                    cur_second_min_sum = cur_sum;
                }
            }
            first_min_sum = cur_first_min_sum;
            second_min_sum = cur_second_min_sum;
            first_min_index = cur_first_min_index;
        }
        return first_min_sum;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def minFallingPathSum(self, grid: List[List[int]]) -> int:
        first_min_sum, second_min_sum = 0, 0
        first_min_index = -1
        for i in range(len(grid)):
            cur_first_min_sum, cur_second_min_sum = 10**9, 10**9
            cur_first_min_index = -1
            for j in range(len(grid)):
                cur_sum = grid[i][j]
                if j != first_min_index:
                    cur_sum += first_min_sum
                else:
                    cur_sum += second_min_sum
                if cur_sum < cur_first_min_sum:
                    cur_second_min_sum, cur_first_min_sum = cur_first_min_sum, cur_sum
                    cur_first_min_index = j
                elif cur_sum < cur_second_min_sum:
                    cur_second_min_sum = cur_sum
            first_min_sum, second_min_sum = cur_first_min_sum, cur_second_min_sum
            first_min_index = cur_first_min_index
        return first_min_sum
```

```Go [sol2-Go]
func minFallingPathSum(grid [][]int) int {
    n := len(grid)
    first_min_sum, second_min_sum := 0, 0
    first_min_index := -1
    
    for i := 0; i < n; i++ {
        cur_first_min_sum, cur_second_min_sum := math.MaxInt, math.MaxInt
        cur_first_min_index := -1
        
        for j := 0; j < n; j++ {
            cur_sum := grid[i][j]
            if j != first_min_index {
                cur_sum += first_min_sum
            } else {
                cur_sum += second_min_sum
            }
            if cur_sum < cur_first_min_sum {
                cur_second_min_sum, cur_first_min_sum = cur_first_min_sum, cur_sum
                cur_first_min_index = j
            } else if cur_sum < cur_second_min_sum {
                cur_second_min_sum = cur_sum
            }
        }
        first_min_sum, second_min_sum = cur_first_min_sum, cur_second_min_sum
        first_min_index = cur_first_min_index
    }
    return first_min_sum;
}
```

```JavaScript [sol2-JavaScript]
var minFallingPathSum = function(grid) {
    const n = grid.length;
    let first_min_sum = 0, second_min_sum = 0;
    let first_min_index = -1;
    
    for (let i = 0; i < n; i++) {
        let cur_first_min_sum = Infinity, cur_second_min_sum = Infinity;
        let cur_first_min_index = -1;
        
        for (let j = 0; j < n; j++) {
            let cur_sum = grid[i][j];
            if (j != first_min_index) {
                cur_sum += first_min_sum;
            } else {
                cur_sum += second_min_sum;
            }
            if (cur_sum < cur_first_min_sum) {
                cur_second_min_sum = cur_first_min_sum;
                cur_first_min_sum = cur_sum;
                cur_first_min_index = j
            } else if (cur_sum < cur_second_min_sum) {
                cur_second_min_sum = cur_sum;
            }
        }
        first_min_sum = cur_first_min_sum;
        second_min_sum = cur_second_min_sum;
        first_min_index = cur_first_min_index;
    }
    return first_min_sum;
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是 $\textit{grid}$ 的行数和列数。

- 空间复杂度：$O(1)$。过程中我们只使用了常数个变量。
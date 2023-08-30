#### 方法一：遍历

**思路与算法**

设 $\textit{grid}$ 的大小为 $n \times n$，那么我们申请一个大小为 $(n - 2) \times (n - 2)$ 的矩阵 $\textit{res}$ 用来存放答案。我们遍历 $\textit{grid}$ 中每个 $3 \times 3$ 子矩阵的左上角，然后统计当前子矩阵的最大值放入 $\textit{res}$ 中。

具体做法是，我们顺序遍历 $i~(0 \le i \lt n - 2)$，再顺序遍历 $j~(0 \le j \lt n - 2)$，接着遍历求解 $\{\textit{grid}(x, y)~|~i \le x \lt i + 3, j \le y \lt j + 3\}$ 的最大值放入 $\textit{res}[i][j]$ 中。

**代码**

```Python [sol1-Python3]
class Solution:
    def largestLocal(self, grid: List[List[int]]) -> List[List[int]]:
        n = len(grid)
        ans = [[0] * (n - 2) for _ in range(n - 2)]
        for i in range(n - 2):
            for j in range(n - 2):
                ans[i][j] = max(grid[x][y] for x in range(i, i + 3) for y in range(j, j + 3))
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> largestLocal(vector<vector<int>>& grid) {
        int n = grid.size();
        vector<vector<int>> res(n - 2, vector<int>(n - 2, 0));
        for (int i = 0; i < n - 2; i++) {
            for (int j = 0; j < n - 2; j++) {
                for (int x = i; x < i + 3; x++) {
                    for (int y = j; y < j + 3; y++) {
                        res[i][j] = max(res[i][j], grid[x][y]);
                    }
                }
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[][] largestLocal(int[][] grid) {
        int n = grid.length;
        int[][] res = new int[n - 2][n - 2];
        for (int i = 0; i < n - 2; i++) {
            for (int j = 0; j < n - 2; j++) {
                for (int x = i; x < i + 3; x++) {
                    for (int y = j; y < j + 3; y++) {
                        res[i][j] = Math.max(res[i][j], grid[x][y]);
                    }
                }
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[][] LargestLocal(int[][] grid) {
        int n = grid.Length;
        int[][] res = new int[n - 2][];
        for (int i = 0; i < n - 2; i++) {
            res[i] = new int[n - 2];
            for (int j = 0; j < n - 2; j++) {
                for (int x = i; x < i + 3; x++) {
                    for (int y = j; y < j + 3; y++) {
                        res[i][j] = Math.Max(res[i][j], grid[x][y]);
                    }
                }
            }
        }
        return res;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int** largestLocal(int** grid, int gridSize, int* gridColSize, int* returnSize, int** returnColumnSizes) {
    int **res = (int **)malloc(sizeof(int *) * (gridSize - 2));
    for (int i = 0; i < gridSize - 2; i++) {
        res[i] = (int *)calloc(gridSize - 2, sizeof(int));
    }
    for (int i = 0; i < gridSize - 2; i++) {
        for (int j = 0; j < gridSize - 2; j++) {
            for (int x = i; x < i + 3; x++) {
                for (int y = j; y < j + 3; y++) {
                    res[i][j] = MAX(res[i][j], grid[x][y]);
                }
            }
        }
    }
    *returnSize = gridSize - 2;
    *returnColumnSizes = (int *)calloc(gridSize - 2, sizeof(int));
    for (int i = 0; i < gridSize - 2; i++) {
        (*returnColumnSizes)[i] = gridSize - 2;
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var largestLocal = function(grid) {
    const n = grid.length;
    const res = new Array(n - 2).fill(0).map(() => new Array(n - 2).fill(0));
    for (let i = 0; i < n - 2; i++) {
        for (let j = 0; j < n - 2; j++) {
            for (let x = i; x < i + 3; x++) {
                for (let y = j; y < j + 3; y++) {
                    res[i][j] = Math.max(res[i][j], grid[x][y]);
                }
            }
        }
    }
    return res;
};
```

```go [sol1-Golang]
func largestLocal(grid [][]int) [][]int {
    n := len(grid)
    ans := make([][]int, n-2)
    for i := 1; i < n-1; i++ {
        row := make([]int, n-2)
        for j := 1; j < n-1; j++ {
            mx := grid[i][j]
            for r := i - 1; r <= i+1; r++ {
                for c := j - 1; c <= j+1; c++ {
                    if grid[r][c] > mx {
                        mx = grid[r][c]
                    }
                }
            }
            row[j-1] = mx
        }
        ans[i-1] = row
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是矩阵 $\textit{grid}$ 的行数和列数。

- 空间复杂度：$O(1)$。这里不考虑返回值的空间。
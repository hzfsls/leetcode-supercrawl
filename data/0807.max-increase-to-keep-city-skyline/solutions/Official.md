#### 方法一：贪心

从左侧和右侧看，城市天际线等于矩阵 $\textit{grid}$ 的每一行的建筑物高度最大值；从顶部和底部看，城市天际线等于矩阵 $\textit{grid}$ 的每一列的建筑物高度最大值。只要不改变每一行和每一列的建筑物高度最大值，就能保持城市天际线，因此可以使用贪心的思想计算建筑物高度可以增加的最大总和。

由于矩阵 $\textit{grid}$ 的行数和列数都是 $n$，因此创建两个长度为 $n$ 的数组 $\textit{rowMax}$ 和 $\textit{colMax}$ 分别记录矩阵 $\textit{grid}$ 的每一行的最大值和每一列的最大值。遍历矩阵 $\textit{grid}$ 填入两个数组之后，再次遍历矩阵，计算每个建筑物高度可以增加的最大值。

当 $0 \le i, j < n$ 时，对于第 $i$ 行第 $j$ 列的建筑物，其所在行的建筑物高度最大值是 $\textit{rowMax}[i]$，其所在列的建筑物高度最大值是 $\textit{colMax}[j]$。为了保持城市天际线，该建筑物增加后的高度不能超过其所在行和所在列的建筑物高度最大值，即该建筑物增加后的最大高度是 $\min(\textit{rowMax}[i], \textit{colMax}[j])$。由于该建筑物的原始高度是 $\textit{grid}[i][j]$，因此该建筑物高度可以增加的最大值是 $\min(\textit{rowMax}[i], \textit{colMax}[j]) - \textit{grid}[i][j]$。

对于矩阵 $\textit{grid}$ 中的每个元素计算可以增加的最大值，即可得到建筑物高度可以增加的最大总和。

```Java [sol1-Java]
class Solution {
    public int maxIncreaseKeepingSkyline(int[][] grid) {
        int n = grid.length;
        int[] rowMax = new int[n];
        int[] colMax = new int[n];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                rowMax[i] = Math.max(rowMax[i], grid[i][j]);
                colMax[j] = Math.max(colMax[j], grid[i][j]);
            }
        }
        int ans = 0;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                ans += Math.min(rowMax[i], colMax[j]) - grid[i][j];
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxIncreaseKeepingSkyline(int[][] grid) {
        int n = grid.Length;
        int[] rowMax = new int[n];
        int[] colMax = new int[n];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                rowMax[i] = Math.Max(rowMax[i], grid[i][j]);
                colMax[j] = Math.Max(colMax[j], grid[i][j]);
            }
        }
        int ans = 0;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                ans += Math.Min(rowMax[i], colMax[j]) - grid[i][j];
            }
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int maxIncreaseKeepingSkyline(vector<vector<int>>& grid) {
        int n = grid.size();
        vector<int> rowMax(n);
        vector<int> colMax(n);
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                rowMax[i] = max(rowMax[i], grid[i][j]);
                colMax[j] = max(colMax[j], grid[i][j]);
            }
        }
        int ans = 0;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                ans += min(rowMax[i], colMax[j]) - grid[i][j];
            }
        }
        return ans;
    }
};
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int maxIncreaseKeepingSkyline(int** grid, int gridSize, int* gridColSize){
    int * rowMax = (int *)malloc(sizeof(int) * gridSize);
    int * colMax = (int *)malloc(sizeof(int) * gridSize);
    memset(rowMax, 0, sizeof(int) * gridSize);
    memset(colMax, 0, sizeof(int) * gridSize);
    for (int i = 0; i < gridSize; ++i) {
        for (int j = 0; j < gridSize; ++j) {
            rowMax[i] = MAX(rowMax[i], grid[i][j]);
            colMax[j] = MAX(colMax[j], grid[i][j]);
        }
    }
    int ans = 0;
    for (int i = 0; i < gridSize; ++i) {
        for (int j = 0; j < gridSize; ++j) {
            ans += MIN(rowMax[i], colMax[j]) - grid[i][j];
        }
    } 
    free(rowMax);
    free(colMax);
    return ans;
}
```

```go [sol1-Golang]
func maxIncreaseKeepingSkyline(grid [][]int) (ans int) {
    n := len(grid)
    rowMax := make([]int, n)
    colMax := make([]int, n)
    for i, row := range grid {
        for j, h := range row {
            rowMax[i] = max(rowMax[i], h)
            colMax[j] = max(colMax[j], h)
        }
    }
    for i, row := range grid {
        for j, h := range row {
            ans += min(rowMax[i], colMax[j]) - h
        }
    }
    return
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

```Python [sol1-Python3]
class Solution:
    def maxIncreaseKeepingSkyline(self, grid: List[List[int]]) -> int:
        rowMax = list(map(max, grid))
        colMax = list(map(max, zip(*grid)))
        return sum(min(rowMax[i], colMax[j]) - h for i, row in enumerate(grid) for j, h in enumerate(row))
```

```JavaScript [sol1-JavaScript]
var maxIncreaseKeepingSkyline = function(grid) {
    const n = grid.length;
    const rowMax = new Array(n).fill(0);
    const colMax = new Array(n).fill(0);
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < n; j++) {
            rowMax[i] = Math.max(rowMax[i], grid[i][j]);
            colMax[j] = Math.max(colMax[j], grid[i][j]);
        }
    }
    let ans = 0;
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < n; j++) {
            ans += Math.min(rowMax[i], colMax[j]) - grid[i][j];
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是矩阵 $\textit{grid}$ 的行数和列数。需要遍历矩阵 $\textit{grid}$ 两次，第一次遍历计算每一行的最大值和每一列的最大值，第二次遍历计算建筑物高度可以增加的最大总和。

- 空间复杂度：$O(n)$，其中 $n$ 是矩阵 $\textit{grid}$ 的行数和列数。需要创建两个长度为 $n$ 的数组分别记录矩阵 $\textit{grid}$ 的每一行的最大值和每一列的最大值。
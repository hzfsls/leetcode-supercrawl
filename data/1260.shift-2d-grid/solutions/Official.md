## [1260.二维网格迁移 中文官方题解](https://leetcode.cn/problems/shift-2d-grid/solutions/100000/er-wei-wang-ge-qian-yi-by-leetcode-solut-ploz)
#### 方法一：一维展开

设 $m$ 和 $n$ 分别为网格的行列数，我们将网格 $\textit{grid}$ 想象成由多个一维数组 $\big \{\textit{grid}[i]; 0 \le i \lt n \big \}$ 按顺序拼接而成的一维数组，那么元素 $\textit{grid}[i][j]$ 在该一维数组的下标为 $\textit{index} = i \times n + j$。

每次迁移操作都相当于将该一维数组向右循环移动一次，那么 $k$ 次迁移操作之后，元素 $\textit{grid}[i][j]$ 在该一维数组的下标变为 $\textit{index}_1 = (\textit{index} + k) \bmod (m \times n)$，在网格的位置变为 $\textit{grid}[\Big \lfloor \dfrac{\textit{index}_1}{n} \Big \rfloor][\textit{index}_1 \bmod n]$。

```Python [sol1-Python3]
class Solution:
    def shiftGrid(self, grid: List[List[int]], k: int) -> List[List[int]]:
        m, n = len(grid), len(grid[0])
        ans = [[0] * n for _ in range(m)]
        for i, row in enumerate(grid):
            for j, v in enumerate(row):
                index1 = (i * n + j + k) % (m * n)
                ans[index1 // n][index1 % n] = v
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> shiftGrid(vector<vector<int>>& grid, int k) {
        int m = grid.size(), n = grid[0].size();
        vector<vector<int>> ret(m, vector<int>(n));
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                int index1 = (i * n + j + k) % (m * n);
                ret[index1 / n][index1 % n] = grid[i][j];
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<List<Integer>> shiftGrid(int[][] grid, int k) {
        int m = grid.length, n = grid[0].length;
        List<List<Integer>> ret = new ArrayList<List<Integer>>();
        for (int i = 0; i < m; i++) {
            List<Integer> row = new ArrayList<Integer>();
            for (int j = 0; j < n; j++) {
                row.add(0);
            }
            ret.add(row);
        }
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                int index1 = (i * n + j + k) % (m * n);
                ret.get(index1 / n).set(index1 % n, grid[i][j]);
            }
        }
        return ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<IList<int>> ShiftGrid(int[][] grid, int k) {
        int m = grid.Length, n = grid[0].Length;
        IList<IList<int>> ret = new List<IList<int>>();
        for (int i = 0; i < m; i++) {
            IList<int> row = new List<int>();
            for (int j = 0; j < n; j++) {
                row.Add(0);
            }
            ret.Add(row);
        }
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                int index1 = (i * n + j + k) % (m * n);
                ret[index1 / n][index1 % n] = grid[i][j];
            }
        }
        return ret;
    }
}
```

```C [sol1-C]
int** shiftGrid(int** grid, int gridSize, int* gridColSize, int k, int* returnSize, int** returnColumnSizes){
    int m = gridSize, n = gridColSize[0];
    int **ret = (int **)malloc(sizeof(int *) * m);
    *returnColumnSizes = (int *)malloc(sizeof(int) * m);
    for (int i = 0; i < m; i++) {
        ret[i] = (int *)malloc(sizeof(int) * n);
        (*returnColumnSizes)[i] = n;
    }
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            int index1 = (i * n + j + k) % (m * n);
            ret[index1 / n][index1 % n] = grid[i][j];
        }
    }
    *returnSize = m;
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var shiftGrid = function(grid, k) {
    const m = grid.length, n = grid[0].length;
    const ret = [];
    for (let i = 0; i < m; i++) {
        const row = [];
        for (let j = 0; j < n; j++) {
            row.push(0);
        }
        ret.push(row);
    }
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            const index1 = (i * n + j + k) % (m * n);
            ret[Math.floor(index1 / n)].splice(index1 % n, 1, grid[i][j]);
        }
    }
    return ret;
};
```

```go [sol1-Golang]
func shiftGrid(grid [][]int, k int) [][]int {
    m, n := len(grid), len(grid[0])
    ans := make([][]int, m)
    for i := range ans {
        ans[i] = make([]int, n)
    }
    for i, row := range grid {
        for j, v := range row {
            index1 := (i*n + j + k) % (m * n)
            ans[index1/n][index1%n] = v
        }
    }
    return ans
}
```

**复杂度分析**

+ 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别为网格的行列数。

+ 空间复杂度：$O(1)$。返回值不计入空间复杂度。
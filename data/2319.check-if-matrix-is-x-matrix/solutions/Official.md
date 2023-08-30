#### 方法一：数学

**思路与算法**

首先题目给出 $\text{X}$ 矩阵的定义，一个正方形矩阵如果同时满足以下两个条件则该矩阵为 $\text{X}$ 矩阵。

- 矩阵对角线上的所有元素都不是 $0$。
- 矩阵中的所有其他元素都是 $0$。

现在给出一个大小为 $n \times n$ 的二维整数数组 $\textit{grid}$，现在我们需要判断 $\textit{grid}$ 是否是一个 $\text{X}$ 矩阵。对于矩阵 $\textit{grid}$ 中的某一个位置 $(i, j)$，$0 \le i, j < n$，如果满足 $i = j$ 或者 $i + j + 1= n$，则说明该点在矩阵 $\textit{grid}$ 的对角线上，否则不在矩阵对角线上。那么我们遍历矩阵中的每一个位置来判断是否满足 $X$ 的定义即可——若在对角线上则需要满足 $\textit{grid}[i][j] \ne 0$，否则需要满足 $\textit{grid}[i][j] = 0$。如果每一个位置都满足要求则返回 $\text{true}$，否则返回 $\text{false}$。

**代码**

```Python [sol1-Python3]
class Solution:
    def checkXMatrix(self, grid: List[List[int]]) -> bool:
        n = len(grid)
        for i, row in enumerate(grid):
            for j, x in enumerate(row):
                if i == j or (i + j) == (n - 1):
                    if x == 0:
                        return False
                elif x:
                    return False
        return True
```

```C++ [sol1-C++]
class Solution {
public:
    bool checkXMatrix(vector<vector<int>>& grid) {
        int n = grid.size();
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                if (i == j || (i + j) == (n - 1)) {
                    if (grid[i][j] == 0) {
                        return false;
                    }
                } else if (grid[i][j]) {
                    return false;
                }
            }
        }
        return true;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean checkXMatrix(int[][] grid) {
        int n = grid.length;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                if (i == j || (i + j) == (n - 1)) {
                    if (grid[i][j] == 0) {
                        return false;
                    }
                } else if (grid[i][j] != 0) {
                    return false;
                }
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool CheckXMatrix(int[][] grid) {
        int n = grid.Length;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                if (i == j || (i + j) == (n - 1)) {
                    if (grid[i][j] == 0) {
                        return false;
                    }
                } else if (grid[i][j] != 0) {
                    return false;
                }
            }
        }
        return true;
    }
}
```

```C [sol1-C]
bool checkXMatrix(int** grid, int gridSize, int* gridColSize) {
    for (int i = 0; i < gridSize; ++i) {
        for (int j = 0; j < gridSize; ++j) {
            if (i == j || (i + j) == (gridSize - 1)) {
                if (grid[i][j] == 0) {
                    return false;
                }
            } else if (grid[i][j]) {
                return false;
            }
        }
    }
    return true;
}
```

```JavaScript [sol1-JavaScript]
var checkXMatrix = function(grid) {
    const n = grid.length;
    for (let i = 0; i < n; ++i) {
        for (let j = 0; j < n; ++j) {
            if (i === j || (i + j) === (n - 1)) {
                if (grid[i][j] === 0) {
                    return false;
                }
            } else if (grid[i][j] !== 0) {
                return false;
            }
        }
    }
    return true;
};
```

```go [sol1-Golang]
func checkXMatrix(grid [][]int) bool {
    for i, row := range grid {
        for j, x := range row {
            if i == j || i+j == len(grid)-1 {
                if x == 0 {
                    return false
                }
            } else if x != 0 {
                return false
            }
        }
    }
    return true
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 为正方形矩阵 $\textit{grid}$ 的行列数。
- 空间复杂度：$O(1)$。仅使用常量空间。
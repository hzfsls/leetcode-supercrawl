## [867.转置矩阵 中文官方题解](https://leetcode.cn/problems/transpose-matrix/solutions/100000/zhuan-zhi-ju-zhen-by-leetcode-solution-85s2)

#### 方法一：模拟

如果矩阵 $\textit{matrix}$ 为 $m$ 行 $n$ 列，则转置后的矩阵 $\textit{matrix}^\text{T}$ 为 $n$ 行 $m$ 列，且对任意 $0 \le i<m$ 和 $0 \le j<n$，都有 $\textit{matrix}^\text{T}[j][i]=\textit{matrix}[i][j]$。

创建一个 $n$ 行 $m$ 列的新矩阵，根据转置的规则对新矩阵中的每个元素赋值，则新矩阵为转置后的矩阵。

```Java [sol1-Java]
class Solution {
    public int[][] transpose(int[][] matrix) {
        int m = matrix.length, n = matrix[0].length;
        int[][] transposed = new int[n][m];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                transposed[j][i] = matrix[i][j];
            }
        }
        return transposed;
    }
}
```

```JavaScript [sol1-JavaScript]
var transpose = function(matrix) {
    const m = matrix.length, n = matrix[0].length;
    const transposed = new Array(n).fill(0).map(() => new Array(m).fill(0));
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            transposed[j][i] = matrix[i][j];
        }
    }
    return transposed;
};
```

```go [sol1-Golang]
func transpose(matrix [][]int) [][]int {
    n, m := len(matrix), len(matrix[0])
    t := make([][]int, m)
    for i := range t {
        t[i] = make([]int, n)
        for j := range t[i] {
            t[i][j] = -1
        }
    }
    for i, row := range matrix {
        for j, v := range row {
            t[j][i] = v
        }
    }
    return t
}
```

```Python [sol1-Python3]
class Solution:
    def transpose(self, matrix: List[List[int]]) -> List[List[int]]:
        m, n = len(matrix), len(matrix[0])
        transposed = [[0] * m for _ in range(n)]
        for i in range(m):
            for j in range(n):
                transposed[j][i] = matrix[i][j]
        return transposed
```

```Python [sol1-Python3_oneline]
class Solution:
    def transpose(self, matrix: List[List[int]]) -> List[List[int]]:
        return list(list(row) for row in zip(*matrix))
```

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> transpose(vector<vector<int>>& matrix) {
        int m = matrix.size(), n = matrix[0].size();
        vector<vector<int>> transposed(n, vector<int>(m));
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                transposed[j][i] = matrix[i][j];
            }
        }
        return transposed;
    }
};
```

```C [sol1-C]
int** transpose(int** matrix, int matrixSize, int* matrixColSize, int* returnSize, int** returnColumnSizes) {
    int m = matrixSize, n = matrixColSize[0];
    int** transposed = malloc(sizeof(int*) * n);
    *returnSize = n;
    *returnColumnSizes = malloc(sizeof(int) * n);
    for (int i = 0; i < n; i++) {
        transposed[i] = malloc(sizeof(int) * m);
        (*returnColumnSizes)[i] = m;
    }
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            transposed[j][i] = matrix[i][j];
        }
    }
    return transposed;
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是矩阵 $\textit{matrix}$ 的行数和列数。需要遍历整个矩阵，并对转置后的矩阵进行赋值操作。

- 空间复杂度：$O(1)$。除了返回值以外，额外使用的空间为常数。
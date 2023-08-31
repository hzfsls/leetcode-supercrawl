## [1605.给定行和列的和求可行矩阵 中文官方题解](https://leetcode.cn/problems/find-valid-matrix-given-row-and-column-sums/solutions/100000/gei-ding-xing-he-lie-de-he-qiu-ke-xing-j-u8dj)
#### 方法一：贪心

**思路与算法**

给你两个长度为 $n$ 和 $m$ 的非负整数数组 $\textit{rowSum}$ 和 $\textit{colSum}$ ，其中 $\textit{rowSum}[i]$ 是二维矩阵中第 $i$ 行元素的和，$\textit{colSum}[j]$ 是第 $j$ 列元素的和。现在我们需要返回任意一个大小为 $n \times m$ 并且满足 $\textit{rowSum}$ 和 $\textit{colSum}$ 要求的二维非负整数矩阵 $\textit{matrix}$。

对于 $\textit{matrix}$ 的每一个位置 $\textit{matrix}[i][j]$，$0 \le i < n$ 且 $0 \le j < m$，我们将 $\textit{matrix}[i][j]$ 设为 $\min\{\textit{rowSum}[i], \textit{colSum}[j]\}$，然后将 $\textit{rowSum}[i], \textit{colSum}[j]$ 同时减去 $\textit{matrix}[i][j]$ 即可。当遍历完全部位置后，$\textit{matrix}$ 即为一个满足要求的答案矩阵。

上述的构造方法的正确性说明如下：

首先我们可以容易得到对于某一个位置 $\textit{matrix}[i][j]$ 处理完后，$\textit{rowSum}[i]$，$\textit{colSum}[j]$ 一定不会小于 $0$。然后我们从第一行开始往最后一行构造，因为初始时 $\sum_{i = 0}^n \textit{rowSum}[i] = \sum_{j = 0}^m \textit{colSum}[j]$，所以对于第一行显然有 $\textit{rowSum}[0] \le \sum_{j = 0}^{m} \textit{colSum}[j]$，所以通过上述操作一定可以使得 $\textit{rowSum}[0] = 0$，同时满足 $\textit{colSum}[j] \ge 0$ 对于 $0 \le j < m$ 恒成立。然后我们对剩下的 $n - 1$ 行和 $m$ 列做同样的处理。当处理完成后，$\textit{matrix}$ 为一个符合要求的答案矩阵。

在实现的过程中，当遍历过程中 $\textit{rowSum}[i] = 0$，$0 \le i < n$ 时，因为每一个元素为非负整数，所以该行中剩下的元素只能全部为 $0$，同理对于 $\textit{colSum}[j] = 0$，$0 \le j < m$ 时，该列中剩下的元素也只能全部为 $0$。所以我们可以初始化 $\textit{matrix}$ 为全零矩阵，在遍历的过程中一旦存在上述情况，则可以直接跳过该行或者列。

**代码**

```Python [sol1-Python3]
class Solution:
    def restoreMatrix(self, rowSum: List[int], colSum: List[int]) -> List[List[int]]:
        n, m = len(rowSum), len(colSum)
        matrix = [[0] * m for _ in range(n)]
        i = j = 0
        while i < n and j < m:
            v = min(rowSum[i], colSum[j])
            matrix[i][j] = v
            rowSum[i] -= v
            colSum[j] -= v
            if rowSum[i] == 0:
                i += 1
            if colSum[j] == 0:
                j += 1
        return matrix
```

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> restoreMatrix(vector<int>& rowSum, vector<int>& colSum) {
        int n = rowSum.size(), m = colSum.size();
        vector<vector<int>> matrix(n, vector<int>(m, 0));
        int i = 0, j = 0;
        while (i < n && j < m) {
            int v = min(rowSum[i], colSum[j]);
            matrix[i][j] = v;
            rowSum[i] -= v;
            colSum[j] -= v;
            if (rowSum[i] == 0) {
                ++i;
            }
            if (colSum[j] == 0) {
                ++j;
            }
        }
        return matrix;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[][] restoreMatrix(int[] rowSum, int[] colSum) {
        int n = rowSum.length, m = colSum.length;
        int[][] matrix = new int[n][m];
        int i = 0, j = 0;
        while (i < n && j < m) {
            int v = Math.min(rowSum[i], colSum[j]);
            matrix[i][j] = v;
            rowSum[i] -= v;
            colSum[j] -= v;
            if (rowSum[i] == 0) {
                ++i;
            }
            if (colSum[j] == 0) {
                ++j;
            }
        }
        return matrix;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[][] RestoreMatrix(int[] rowSum, int[] colSum) {
        int n = rowSum.Length, m = colSum.Length;
        int[][] matrix = new int[n][];
        for (int row = 0; row < n; ++row) {
            matrix[row] = new int[m];
        }
        int i = 0, j = 0;
        while (i < n && j < m) {
            int v = Math.Min(rowSum[i], colSum[j]);
            matrix[i][j] = v;
            rowSum[i] -= v;
            colSum[j] -= v;
            if (rowSum[i] == 0) {
                ++i;
            }
            if (colSum[j] == 0) {
                ++j;
            }
        }
        return matrix;
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int** restoreMatrix(int* rowSum, int rowSumSize, int* colSum, int colSumSize, int* returnSize, int** returnColumnSizes) {
    int n = rowSumSize, m = colSumSize;
    int **matrix = (int **)malloc(sizeof(int *) * n);
    for (int i = 0; i < n; i++) {
        matrix[i] = (int *)malloc(sizeof(int) * m);
        memset(matrix[i], 0, sizeof(int) * m);
    }
    int i = 0, j = 0;
    while (i < n && j < m) {
        int v = MIN(rowSum[i], colSum[j]);
        matrix[i][j] = v;
        rowSum[i] -= v;
        colSum[j] -= v;
        if (rowSum[i] == 0) {
            ++i;
        }
        if (colSum[j] == 0) {
            ++j;
        }
    }
    *returnSize = n;
    *returnColumnSizes = (int *)malloc(sizeof(int) * n);
    for (int i = 0; i < n; i++) {
        (*returnColumnSizes)[i] = m;
    }
    return matrix;
}
```

```JavaScript [sol1-JavaScript]
var restoreMatrix = function(rowSum, colSum) {
    const n = rowSum.length, m = colSum.length;
    const matrix = new Array(n).fill(0).map(() => new Array(m).fill(0));
    let i = 0, j = 0;
    while (i < n && j < m) {
        const v = Math.min(rowSum[i], colSum[j]);
        matrix[i][j] = v;
        rowSum[i] -= v;
        colSum[j] -= v;
        if (rowSum[i] === 0) {
            ++i;
        }
        if (colSum[j] === 0) {
            ++j;
        }
    }
    return matrix;
};
```

```go [sol1-Golang]
func restoreMatrix(rowSum []int, colSum []int) [][]int {
    n, m := len(rowSum), len(colSum)
    matrix := make([][]int, n)
    for i := range matrix {
        matrix[i] = make([]int, m)
    }
    i, j := 0, 0
    for i < n && j < m {
        v := min(rowSum[i], colSum[j])
        matrix[i][j] = v
        rowSum[i] -= v
        colSum[j] -= v
        if rowSum[i] == 0 {
            i++
        }
        if colSum[j] == 0 {
            j++
        }
    }
    return matrix
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n \times m)$，其中 $n$ 和 $m$ 分别为数组 $\textit{rowSum}$ 和 $\textit{colSum}$ 的长度，主要为构造 $\textit{matrix}$ 结果矩阵的时间开销，填充 $\textit{matrix}$ 的时间复杂度为 $O(n + m)$。
- 空间复杂度：$O(1)$，仅使用常量空间。注意返回的结果数组不计入空间开销。
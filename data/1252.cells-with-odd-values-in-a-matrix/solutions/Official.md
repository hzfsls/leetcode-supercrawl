## [1252.奇数值单元格的数目 中文官方题解](https://leetcode.cn/problems/cells-with-odd-values-in-a-matrix/solutions/100000/qi-shu-zhi-dan-yuan-ge-de-shu-mu-by-leet-oa4o)

#### 方法一：直接模拟

直接使用使用一个 $n \times m$ 的矩阵来存放操作的结果，对于 $\textit{indices}$ 中的每一对 $[r_i, c_i]$，将矩阵第 $r_i$ 行的所有数增加 $1$，第 $c_i$ 列的所有数增加 $1$。在所有操作模拟完毕后，我们遍历矩阵，得到奇数的数目。

```Python [sol1-Python3]
class Solution:
    def oddCells(self, m: int, n: int, indices: List[List[int]]) -> int:
        matrix = [[0] * n for _ in range(m)]
        for x, y in indices:
            for j in range(n):
                matrix[x][j] += 1
            for row in matrix:
                row[y] += 1
        return sum(x % 2 for row in matrix for x in row)
```

```C++ [sol1-C++]
class Solution {
public:
    int oddCells(int m, int n, vector<vector<int>>& indices) {
        int res = 0;
        vector<vector<int>> matrix(m, vector<int>(n));
        for (auto &index : indices) {
            for (int i = 0; i < n; i++) {
                matrix[index[0]][i]++;
            }
            for (int i = 0; i < m; i++) {
                matrix[i][index[1]]++;
            }
        }
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (matrix[i][j] & 1) {
                    res++;
                }
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int oddCells(int m, int n, int[][] indices) {
        int res = 0;
        int[][] matrix = new int[m][n];
        for (int[] index : indices) {
            for (int i = 0; i < n; i++) {
                matrix[index[0]][i]++;
            }
            for (int i = 0; i < m; i++) {
                matrix[i][index[1]]++;
            }
        }
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if ((matrix[i][j] & 1) != 0) {
                    res++;
                }
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int OddCells(int m, int n, int[][] indices) {
        int res = 0;
        int[,] matrix = new int[m, n];
        foreach (int[] index in indices) {
            for (int i = 0; i < n; i++) {
                matrix[index[0], i]++;
            }
            for (int i = 0; i < m; i++) {
                matrix[i, index[1]]++;
            }
        }
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if ((matrix[i, j] & 1) != 0) {
                    res++;
                }
            }
        }
        return res;
    }
}
```

```C [sol1-C]
int oddCells(int m, int n, int** indices, int indicesSize, int* indicesColSize) {
    int res = 0;
    int **matrix = (int **)malloc(sizeof(int *) * m);
    for (int i = 0; i < m; i++) {
        matrix[i] = (int *)malloc(sizeof(int) * n);
        memset(matrix[i], 0, sizeof(int) * n);
    }
    for (int i = 0; i < indicesSize; i++) {
        for (int j = 0; j < n; j++) {
            matrix[indices[i][0]][j]++;
        }
        for (int j = 0; j < m; j++) {
            matrix[j][indices[i][1]]++;
        }
    }
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (matrix[i][j] & 1) {
                res++;
            }
        }
        free(matrix[i]);
    }
    free(matrix);
    return res;
}
```

```JavaScript [sol1-JavaScript]
var oddCells = function(m, n, indices) {
    let res = 0;
    const matrix = new Array(m).fill(0).map(() => new Array(n).fill(0));
    for (const index of indices) {
        for (let i = 0; i < n; i++) {
            matrix[index[0]][i]++;
        }
        for (let i = 0; i < m; i++) {
            matrix[i][index[1]]++;
        }
    }
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if ((matrix[i][j] & 1) !== 0) {
                res++;
            }
        }
    }
    return res;
};
```

```go [sol1-Golang]
func oddCells(m, n int, indices [][]int) (ans int) {
    matrix := make([][]int, m)
    for i := range matrix {
        matrix[i] = make([]int, n)
    }
    for _, p := range indices {
        for j := range matrix[p[0]] {
            matrix[p[0]][j]++
        }
        for _, row := range matrix {
            row[p[1]]++
        }
    }
    for _, row := range matrix {
        for _, v := range row {
            ans += v % 2
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(q \times (m + n) + m \times n)$, 其中 $q$ 表示数组 $\textit{indices}$ 的长度，$m, n$ 为矩阵的行数与列数。遍历数组时，每次都需要更新矩阵中一行加一列，需要的时间为 $O(q \times (m + n))$，最后还需要遍历矩阵，需要的时间为 $O(m \times n)$，总的时间复杂度为 $O(q \times (m + n) + m \times n)$。

- 空间复杂度：$O(m \times n)$，其中 $m, n$ 为矩阵的行数与列数。需要存储矩阵的所有元素。

#### 方法二：模拟空间优化

由于每次操作只会将一行和一列的数增加 $1$，因此我们可以使用一个行数组 $\textit{rows}$ 和列数组 $\textit{cols}$ 分别记录每一行和每一列被增加的次数。对于 $\textit{indices}$ 中的每一对 $[r_i, c_i]$，我们将 $\textit{rows}[r_i]$ 和 $\textit{cols}[c_i]$ 的值分别增加 $1$。
在所有操作完成后，我们可以计算出位置 $(x, y)$ 位置的计数即为 $\textit{rows}[x] + \textit{cols}[y]$。遍历矩阵，即可得到所有奇数的数目。

```Python [sol2-Python3]
class Solution:
    def oddCells(self, m: int, n: int, indices: List[List[int]]) -> int:
        rows = [0] * m
        cols = [0] * n
        for x, y in indices:
            rows[x] += 1
            cols[y] += 1
        return sum((row + col) % 2 for row in rows for col in cols)
```

```C++ [sol2-C++]
class Solution {
public:
    int oddCells(int m, int n, vector<vector<int>>& indices) {
        vector<int> rows(m), cols(n);
        for (auto & index : indices) {
            rows[index[0]]++;
            cols[index[1]]++;
        }
        int res = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if ((rows[i] + cols[j]) & 1) {
                    res++;
                }
            }
        }
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int oddCells(int m, int n, int[][] indices) {
        int[] rows = new int[m];
        int[] cols = new int[n];
        for (int[] index : indices) {
            rows[index[0]]++;
            cols[index[1]]++;
        }
        int res = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (((rows[i] + cols[j]) & 1) != 0) {
                    res++;
                }
            }
        }
        return res;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int OddCells(int m, int n, int[][] indices) {
        int[] rows = new int[m];
        int[] cols = new int[n];
        foreach (int[] index in indices) {
            rows[index[0]]++;
            cols[index[1]]++;
        }
        int res = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (((rows[i] + cols[j]) & 1) != 0) {
                    res++;
                }
            }
        }
        return res;
    }
}
```

```C [sol2-C]
int oddCells(int m, int n, int** indices, int indicesSize, int* indicesColSize) {
    int res = 0;
    int *rows = (int *)malloc(sizeof(int) * m);
    int *cols = (int *)malloc(sizeof(int) * n);
    memset(rows, 0, sizeof(int) * m);
    memset(cols, 0, sizeof(int) * n);
    for (int i = 0; i < indicesSize; i++) {
        rows[indices[i][0]]++;
        cols[indices[i][1]]++;
    }
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if ((rows[i] + cols[j]) & 1) {
                res++;
            }
        }
    }
    free(rows);
    free(cols);
    return res;
}
```

```JavaScript [sol2-JavaScript]
var oddCells = function(m, n, indices) {
    const rows = new Array(m).fill(0);
    const cols = new Array(n).fill(0);
    for (const index of indices) {
        rows[index[0]]++;
        cols[index[1]]++;
    }
    let res = 0;
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (((rows[i] + cols[j]) & 1) !== 0) {
                res++;
            }
        }
    }
    return res;
};
```

```go [sol2-Golang]
func oddCells(m, n int, indices [][]int) (ans int) {
    rows := make([]int, m)
    cols := make([]int, n)
    for _, p := range indices {
        rows[p[0]]++
        cols[p[1]]++
    }
    for _, row := range rows {
        for _, col := range cols {
            ans += (row + col) % 2
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(q + m \times n)$, 其中 $q$ 表示数组 $\textit{indices}$ 的长度，$m, n$ 为矩阵的行数与列数。遍历数组时需要的时间为 $O(q)$，最后还需要遍历矩阵，需要的时间为 $O(m \times n)$，因此总的时间复杂度为 $O(q + m \times n)$。

- 空间复杂度：$O(m + n)$，其中 $m, n$ 为矩阵的行数与列数。需要存储矩阵的行数统计与列数统计。

#### 方法三：计数优化

继续对方法二进行优化，矩阵中位于 $(x, y)$ 位置的数为奇数，当且仅当 $\textit{rows}[x]$ 和 $\textit{cols}[y]$ 中恰好有一个为奇数，一个为偶数。设 $\textit{rows}$ 有 $\textit{odd}_x$ 个奇数，$\textit{cols}$ 有 $\textit{odd}_y$ 个奇数，因此对于 $\textit{rows}[x]$ 为偶数，那么在第 $x$ 行有 $\textit{odd}_y$ 个位置的数为奇数；对于 $\textit{rows}[x]$ 为奇数，那么在第 $x$ 行有 $n - \textit{odd}_y$ 个位置的数为偶数。综上我们可以得到奇数的数目为 $\textit{odd}_x \times (n - \textit{odd}_y) + (m - \textit{odd}_x) \times \textit{odd}_y$。

```Python [sol3-Python3]
class Solution:
    def oddCells(self, m: int, n: int, indices: List[List[int]]) -> int:
        rows = [0] * m
        cols = [0] * n
        for x, y in indices:
            rows[x] += 1
            cols[y] += 1
        oddx = sum(row % 2 for row in rows)
        oddy = sum(col % 2 for col in cols)
        return oddx * (n - oddy) + (m - oddx) * oddy
```

```C++ [sol3-C++]
class Solution {
public:
    int oddCells(int m, int n, vector<vector<int>>& indices) {
        vector<int> rows(m), cols(n);
        for (auto & index : indices) {
            rows[index[0]]++;
            cols[index[1]]++;
        }
        int oddx = 0, oddy = 0;
        for (int i = 0; i < m; i++) {
            if (rows[i] & 1) {
                oddx++;
            }
        }
        for (int i = 0; i < n; i++) {
            if (cols[i] & 1) {
                oddy++;
            }
        }
        return oddx * (n - oddy) + (m - oddx) * oddy;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int oddCells(int m, int n, int[][] indices) {
        int[] rows = new int[m];
        int[] cols = new int[n];
        for (int[] index : indices) {
            rows[index[0]]++;
            cols[index[1]]++;
        }
        int oddx = 0, oddy = 0;
        for (int i = 0; i < m; i++) {
            if ((rows[i] & 1) != 0) {
                oddx++;
            }
        }
        for (int i = 0; i < n; i++) {
            if ((cols[i] & 1) != 0) {
                oddy++;
            }
        }
        return oddx * (n - oddy) + (m - oddx) * oddy;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int OddCells(int m, int n, int[][] indices) {
        int[] rows = new int[m];
        int[] cols = new int[n];
        foreach (int[] index in indices) {
            rows[index[0]]++;
            cols[index[1]]++;
        }
        int oddx = 0, oddy = 0;
        for (int i = 0; i < m; i++) {
            if ((rows[i] & 1) != 0) {
                oddx++;
            }
        }
        for (int i = 0; i < n; i++) {
            if ((cols[i] & 1) != 0) {
                oddy++;
            }
        }
        return oddx * (n - oddy) + (m - oddx) * oddy;
    }
}
```

```C [sol3-C]
int oddCells(int m, int n, int** indices, int indicesSize, int* indicesColSize) {
    int res = 0;
    int *rows = (int *)malloc(sizeof(int) * m);
    int *cols = (int *)malloc(sizeof(int) * n);
    memset(rows, 0, sizeof(int) * m);
    memset(cols, 0, sizeof(int) * n);
    for (int i = 0; i < indicesSize; i++) {
        rows[indices[i][0]]++;
        cols[indices[i][1]]++;
    }
    int oddx = 0, oddy = 0;
    for (int i = 0; i < m; i++) {
        if (rows[i] & 1) {
            oddx++;
        }
    }
    for (int i = 0; i < n; i++) {
        if (cols[i] & 1) {
            oddy++;
        }
    }
    return oddx * (n - oddy) + (m - oddx) * oddy;
}
```

```JavaScript [sol3-JavaScript]
var oddCells = function(m, n, indices) {
    const rows = new Array(m).fill(0);
    const cols = new Array(n).fill(0);
    for (const index of indices) {
        rows[index[0]]++;
        cols[index[1]]++;
    }
    let oddx = 0, oddy = 0;
    for (let i = 0; i < m; i++) {
        if ((rows[i] & 1) !== 0) {
            oddx++;
        }
    }
    for (let i = 0; i < n; i++) {
        if ((cols[i] & 1) !== 0) {
            oddy++;
        }
    }
    return oddx * (n - oddy) + (m - oddx) * oddy;
};
```

```go [sol3-Golang]
func oddCells(m, n int, indices [][]int) int {
    rows := make([]int, m)
    cols := make([]int, n)
    for _, p := range indices {
        rows[p[0]]++
        cols[p[1]]++
    }
    oddx := 0
    for _, row := range rows {
        oddx += row % 2
    }
    oddy := 0
    for _, col := range cols {
        oddy += col % 2
    }
    return oddx*(n-oddy) + (m-oddx)*oddy
}
```

**复杂度分析**

- 时间复杂度：$O(q + m + n)$, 其中 $q$ 表示数组 $\textit{indices}$ 的长度，$m, n$ 为矩阵的行数与列数。

- 空间复杂度：$O(m + n)$，其中 $m, n$ 为矩阵的行数与列数。需要存储矩阵的行数统计与列数统计。
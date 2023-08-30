#### 方法一：模拟

**思路与算法**

题目给定了一个大小为 $m \times n$ 的矩阵 $\textit{mat}$，并满足矩阵中的任意元素为 $1$ 或者 $0$。现在给出**特殊位置**的定义：如果 $\textit{mat}[i][j] = 1, i \in [0,m),j \in [0, n)$，并且第 $i$ 行和第 $j$ 列的其他元素均为 $0$，则位置 $(i,j)$ 为**特殊位置**。那么我们枚举每一个位置，然后按照特殊位置的定义来判断该位置是否满足要求，又因为矩阵中的每一个元素只能为 $1$ 或者 $0$，所以我们可以预处理出每一行和列的和来快速的得到每一行和列中的 $1$ 的个数。

**代码**

```Python [sol1-Python3]
class Solution:
    def numSpecial(self, mat: List[List[int]]) -> int:
        rows_sum = [sum(row) for row in mat]
        cols_sum = [sum(col) for col in zip(*mat)]
        res = 0
        for i, row in enumerate(mat):
            for j, x in enumerate(row):
                if x == 1 and rows_sum[i] == 1 and cols_sum[j] == 1:
                    res += 1
        return res
```

```Java [sol1-Java]
class Solution {
    public int numSpecial(int[][] mat) {
        int m = mat.length, n = mat[0].length;
        int[] rowsSum = new int[m];
        int[] colsSum = new int[n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                rowsSum[i] += mat[i][j];
                colsSum[j] += mat[i][j];
            }
        }
        int res = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (mat[i][j] == 1 && rowsSum[i] == 1 && colsSum[j] == 1) {
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
    public int NumSpecial(int[][] mat) {
        int m = mat.Length, n = mat[0].Length;
        int[] rowsSum = new int[m];
        int[] colsSum = new int[n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                rowsSum[i] += mat[i][j];
                colsSum[j] += mat[i][j];
            }
        }
        int res = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (mat[i][j] == 1 && rowsSum[i] == 1 && colsSum[j] == 1) {
                    res++;
                }
            }
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int numSpecial(vector<vector<int>>& mat) {
        int m = mat.size(), n = mat[0].size();
        vector<int> rowsSum(m);
        vector<int> colsSum(n);
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                rowsSum[i] += mat[i][j];
                colsSum[j] += mat[i][j];
            }
        }
        int res = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (mat[i][j] == 1 && rowsSum[i] == 1 && colsSum[j] == 1) {
                    res++;
                }
            }
        }
        return res;
    }
};
```

```C [sol1-C]
int numSpecial(int** mat, int matSize, int* matColSize) {
    int m = matSize, n = matColSize[0];
    int *rowsSum = (int *)malloc(sizeof(int) * m);
    int *colsSum = (int *)malloc(sizeof(int) * n);
    memset(rowsSum, 0, sizeof(int) * m);
    memset(colsSum, 0, sizeof(int) * n);
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            rowsSum[i] += mat[i][j];
            colsSum[j] += mat[i][j];
        }
    }
    int res = 0;
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (mat[i][j] == 1 && rowsSum[i] == 1 && colsSum[j] == 1) {
                res++;
            }
        }
    }
    free(rowsSum);
    free(colsSum);
    return res;
}
```

```JavaScript [sol1-JavaScript]
var numSpecial = function(mat) {
    const m = mat.length, n = mat[0].length;
    const rowsSum = new Array(m).fill(0);
    const colsSum = new Array(n).fill(0);
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            rowsSum[i] += mat[i][j];
            colsSum[j] += mat[i][j];
        }
    }
    let res = 0;
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (mat[i][j] === 1 && rowsSum[i] === 1 && colsSum[j] === 1) {
                res++;
            }
        }
    }
    return res;
};
```

```go [sol1-Golang]
func numSpecial(mat [][]int) (ans int) {
    rowsSum := make([]int, len(mat))
    colsSum := make([]int, len(mat[0]))
    for i, row := range mat {
        for j, x := range row {
            rowsSum[i] += x
            colsSum[j] += x
        }
    }
    for i, row := range mat {
        for j, x := range row {
            if x == 1 && rowsSum[i] == 1 && colsSum[j] == 1 {
                ans++
            }
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(m \times n)$，其中 $m$ 为矩阵 $\textit{mat}$ 的行数，$n$ 为矩阵 $\textit{mat}$ 的列数。
- 空间复杂度：$O(m + n)$，主要为预处理每一行和列的空间开销。

#### 方法二：列的标记值

在方法一的基础上，我们可以看到对于 $(i,j)$，它为特殊位置的条件为 $\textit{mat}[i][j]=1$ 且该行和该列中 $1$ 的数量都为 $1$。据此，定义第 $j$ 列的**标记值**为：该列所有 $1$ 所在行中的 $1$ 的数量之和。下面证明，$(i,j)$ 为特殊位置的充要条件是，第 $j$ 列的标记值恰好为 $1$：

+ 如果 $(i,j)$ 为特殊位置，则说明第 $j$ 列只有一个 $1$，这一个 $1$ 所在的第 $i$ 行也只有它这一个 $1$，那么按照标记值的定义可得，第 $j$ 列的标记值为 $1$。
+ 如果第 $j$ 列的标记值为 $1$，那么说明该列只能有一个 $1$。反证：如果有 $x$ 个 $1$（$x > 1$），则第 $j$ 列的标记值一定 $\ge x$。既然只能有一个 $1$，设其在第 $i$ 行，那么标记值也是第 $i$ 行中的 $1$ 的数量，即：第 $i$ 行也有且仅有这个 $1$。所以 $(i,j)$ 为特殊位置。

那么整个矩阵的特殊位置的数量就是最后标记值为 $1$ 的列的数量。

进一步地，我们可以用原始矩阵的第一行来作为我们标记列的额外空间，从而使空间复杂度降至 $O(1)$。

```Python [sol2-Python3]
class Solution:
    def numSpecial(self, mat: List[List[int]]) -> int:
        for i, row in enumerate(mat):
            cnt1 = sum(row) - (i == 0)
            if cnt1:
                for j, x in enumerate(row):
                    if x == 1:
                        mat[0][j] += cnt1
        return sum(x == 1 for x in mat[0])
```

```Java [sol2-Java]
class Solution {
    public int numSpecial(int[][] mat) {
        int m = mat.length, n = mat[0].length;
        for (int i = 0; i < m; i++) {
            int cnt1 = 0;
            for (int j = 0; j < n; j++) {
                if (mat[i][j] == 1) {
                    cnt1++;
                }
            }
            if (i == 0) {
                cnt1--;
            }
            if (cnt1 > 0) {
                for (int j = 0; j < n; j++) {
                    if (mat[i][j] == 1) {
                        mat[0][j] += cnt1;
                    }
                }
            }
        }
        int sum = 0;
        for (int num : mat[0]) {
            if (num == 1) {
                sum++;
            }
        }
        return sum;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int NumSpecial(int[][] mat) {
        int m = mat.Length, n = mat[0].Length;
        for (int i = 0; i < m; i++) {
            int cnt1 = 0;
            for (int j = 0; j < n; j++) {
                if (mat[i][j] == 1) {
                    cnt1++;
                }
            }
            if (i == 0) {
                cnt1--;
            }
            if (cnt1 > 0) {
                for (int j = 0; j < n; j++) {
                    if (mat[i][j] == 1) {
                        mat[0][j] += cnt1;
                    }
                }
            }
        }
        int sum = 0;
        foreach (int num in mat[0]) {
            if (num == 1) {
                sum++;
            }
        }
        return sum;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int numSpecial(vector<vector<int>>& mat) {
        int m = mat.size(), n = mat[0].size();
        for (int i = 0; i < m; i++) {
            int cnt1 = 0;
            for (int j = 0; j < n; j++) {
                if (mat[i][j] == 1) {
                    cnt1++;
                }
            }
            if (i == 0) {
                cnt1--;
            }
            if (cnt1 > 0) {
                for (int j = 0; j < n; j++) {
                    if (mat[i][j] == 1) {
                        mat[0][j] += cnt1;
                    }
                }
            }
        }
        int sum = 0;
        for (int i = 0; i < n; i++) {
            if (mat[0][i] == 1) {
                sum++;
            }
        }
        return sum;
    }
};
```

```C [sol2-C]
int numSpecial(int** mat, int matSize, int* matColSize) {
    int m = matSize, n = matColSize[0];
    for (int i = 0; i < m; i++) {
        int cnt1 = 0;
        for (int j = 0; j < n; j++) {
            if (mat[i][j] == 1) {
                cnt1++;
            }
        }
        if (i == 0) {
            cnt1--;
        }
        if (cnt1 > 0) {
            for (int j = 0; j < n; j++) {
                if (mat[i][j] == 1) {
                    mat[0][j] += cnt1;
                }
            }
        }
    }
    int sum = 0;
    for (int i = 0; i < n; i++) {
        if (mat[0][i] == 1) {
            sum++;
        }
    }
    return sum;
}
```

```JavaScript [sol2-JavaScript]
var numSpecial = function(mat) {
    const m = mat.length, n = mat[0].length;
    for (let i = 0; i < m; i++) {
        let cnt1 = 0;
        for (let j = 0; j < n; j++) {
            if (mat[i][j] === 1) {
                cnt1++;
            }
        }
        if (i === 0) {
            cnt1--;
        }
        if (cnt1 > 0) {
            for (let j = 0; j < n; j++) {
                if (mat[i][j] === 1) {
                    mat[0][j] += cnt1;
                }
            }
        }
    }
    let sum = 0;
    for (const num of mat[0]) {
        if (num === 1) {
            sum++;
        }
    }
    return sum;
};
```

```go [sol2-Golang]
func numSpecial(mat [][]int) (ans int) {
    for i, row := range mat {
        cnt1 := 0
        for _, x := range row {
            cnt1 += x
        }
        if i == 0 {
            cnt1--
        }
        if cnt1 > 0 {
            for j, x := range row {
                if x == 1 {
                    mat[0][j] += cnt1
                }
            }
        }
    }
    for _, x := range mat[0] {
        if x == 1 {
            ans++
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(m \times n)$，其中 $m$ 为矩阵 $\textit{mat}$ 的行数，$n$ 为矩阵 $\textit{mat}$ 的列数。
- 空间复杂度：$O(1)$，由于用了原始矩阵的空间来作为我们的辅助空间，所以我们仅使用常量空间。
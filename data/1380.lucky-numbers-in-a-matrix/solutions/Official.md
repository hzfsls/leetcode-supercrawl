#### 方法一：模拟

**思路与算法**

遍历矩阵 $\textit{matrix}$，判断 $\textit{matrix}[i][j]$ 是否是它所在行的最小值和所在列的最大值，如果是，则加入返回结果。

**代码**

```Python [sol1-Python3]
class Solution:
    def luckyNumbers(self, matrix: List[List[int]]) -> List[int]:
        ans = []
        for row in matrix:
            for j, x in enumerate(row):
                if max(r[j] for r in matrix) <= x <= min(row):
                    ans.append(x)
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> luckyNumbers (vector<vector<int>>& matrix) {
        int m = matrix.size(), n = matrix[0].size();
        vector<int> ret;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                bool isMin = true, isMax = true;
                for (int k = 0; k < n; k++) {
                    if (matrix[i][k] < matrix[i][j]) {
                        isMin = false;
                        break;
                    }
                }
                if (!isMin) {
                    continue;
                }
                for (int k = 0; k < m; k++) {
                    if (matrix[k][j] > matrix[i][j]) {
                        isMax = false;
                        break;
                    }
                }
                if (isMax) {
                    ret.push_back(matrix[i][j]);
                }
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> luckyNumbers (int[][] matrix) {
        int m = matrix.length, n = matrix[0].length;
        List<Integer> ret = new ArrayList<Integer>();
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                boolean isMin = true, isMax = true;
                for (int k = 0; k < n; k++) {
                    if (matrix[i][k] < matrix[i][j]) {
                        isMin = false;
                        break;
                    }
                }
                if (!isMin) {
                    continue;
                }
                for (int k = 0; k < m; k++) {
                    if (matrix[k][j] > matrix[i][j]) {
                        isMax = false;
                        break;
                    }
                }
                if (isMax) {
                    ret.add(matrix[i][j]);
                }
            }
        }
        return ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<int> LuckyNumbers (int[][] matrix) {
        int m = matrix.Length, n = matrix[0].Length;
        IList<int> ret = new List<int>();
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                bool isMin = true, isMax = true;
                for (int k = 0; k < n; k++) {
                    if (matrix[i][k] < matrix[i][j]) {
                        isMin = false;
                        break;
                    }
                }
                if (!isMin) {
                    continue;
                }
                for (int k = 0; k < m; k++) {
                    if (matrix[k][j] > matrix[i][j]) {
                        isMax = false;
                        break;
                    }
                }
                if (isMax) {
                    ret.Add(matrix[i][j]);
                }
            }
        }
        return ret;
    }
}
```

```C [sol1-C]
int *luckyNumbers (int **matrix, int matrixSize, int *matrixColSize, int *returnSize){
    int *ret = (int *)malloc(sizeof(int) * matrixSize * matrixColSize[0]);
    int retSize = 0;
    for (int i = 0; i < matrixSize; i++) {
        for (int j = 0; j < matrixColSize[0]; j++) {
            bool isMin = true, isMax = true;
            for (int k = 0; k < matrixColSize[0]; k++) {
                if (matrix[i][k] < matrix[i][j]) {
                    isMin = false;
                    break;
                }
            }
            if (!isMin) {
                continue;
            }
            for (int k = 0; k < matrixSize; k++) {
                if (matrix[k][j] > matrix[i][j]) {
                    isMax = false;
                    break;
                }
            }
            if (isMax) {
                ret[retSize++] = matrix[i][j];
            }
        }
    *returnSize = retSize;
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var luckyNumbers  = function(matrix) {
    const m = matrix.length, n = matrix[0].length;
    const ret = [];
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            let isMin = true, isMax = true;
            for (let k = 0; k < n; k++) {
                if (matrix[i][k] < matrix[i][j]) {
                    isMin = false;
                    break;
                }
            }
            if (!isMin) {
                continue;
            }
            for (let k = 0; k < m; k++) {
                if (matrix[k][j] > matrix[i][j]) {
                    isMax = false;
                    break;
                }
            }
            if (isMax) {
                ret.push(matrix[i][j]);
            }
        }
    }
    return ret;
};
```

```go [sol1-Golang]
func luckyNumbers(matrix [][]int) (ans []int) {
    for _, row := range matrix {
    next:
        for j, x := range row {
            for _, y := range row {
                if y < x {
                    continue next
                }
            }
            for _, r := range matrix {
                if r[j] > x {
                    continue next
                }
            }
            ans = append(ans, x)
        }
    }
    return
}
```

**复杂度分析**

+ 时间复杂度：$O(mn \times (m + n))$，其中 $m$ 和 $n$ 分别是矩阵 $\textit{matrix}$ 的行数和列数。遍历矩阵 $\textit{matrix}$ 需要 $O(mn)$，查找行最小值需要 $O(n)$，查找列最大值需要 $O(m)$。

+ 空间复杂度：$O(1)$。返回值不计算空间复杂度。

#### 方法二：预处理 + 模拟

**思路与算法**

预处理出每行的最小值数组 $\textit{minRow}$ 和每列的最大值数组 $\textit{maxCol}$，其中 $\textit{minRow}[i]$ 表示第 $i$ 行的最小值，$\textit{maxCol}[j]$ 表示第 $j$ 列的最大值。遍历矩阵 $\textit{matrix}$，如果 $\textit{matrix}[i][j]$ 同时满足 $\textit{matrix}[i][j]=\textit{minRow}[i]$ 和 $\textit{matrix}[i][j] = \textit{maxCol}[j]$，那么 $\textit{matrix}[i][j]$ 是矩阵中的幸运数，加入返回结果。

**代码**

```Python [sol2-Python3]
class Solution:
    def luckyNumbers(self, matrix: List[List[int]]) -> List[int]:
        minRow = [min(row) for row in matrix]
        maxCol = [max(col) for col in zip(*matrix)]
        ans = []
        for i, row in enumerate(matrix):
            for j, x in enumerate(row):
                if x == minRow[i] == maxCol[j]:
                    ans.append(x)
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    vector<int> luckyNumbers (vector<vector<int>>& matrix) {
        int m = matrix.size(), n = matrix[0].size();
        vector<int> minRow(m, INT_MAX), maxCol(n);
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                minRow[i] = min(minRow[i], matrix[i][j]);
                maxCol[j] = max(maxCol[j], matrix[i][j]);
            }
        }
        vector<int> ret;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (matrix[i][j] == minRow[i] && matrix[i][j] == maxCol[j]) {
                    ret.push_back(matrix[i][j]);
                }
            }
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<Integer> luckyNumbers (int[][] matrix) {
        int m = matrix.length, n = matrix[0].length;
        int[] minRow = new int[m];
        Arrays.fill(minRow, Integer.MAX_VALUE);
        int[] maxCol = new int[n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                minRow[i] = Math.min(minRow[i], matrix[i][j]);
                maxCol[j] = Math.max(maxCol[j], matrix[i][j]);
            }
        }
        List<Integer> ret = new ArrayList<Integer>();
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (matrix[i][j] == minRow[i] && matrix[i][j] == maxCol[j]) {
                    ret.add(matrix[i][j]);
                }
            }
        }
        return ret;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public IList<int> LuckyNumbers (int[][] matrix) {
        int m = matrix.Length, n = matrix[0].Length;
        int[] minRow = new int[m];
        Array.Fill(minRow, int.MaxValue);
        int[] maxCol = new int[n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                minRow[i] = Math.Min(minRow[i], matrix[i][j]);
                maxCol[j] = Math.Max(maxCol[j], matrix[i][j]);
            }
        }
        IList<int> ret = new List<int>();
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (matrix[i][j] == minRow[i] && matrix[i][j] == maxCol[j]) {
                    ret.Add(matrix[i][j]);
                }
            }
        }
        return ret;
    }
}
```

```C [sol2-C]
static inline int max(int n1, int n2) {
    return n1 > n2 ? n1 : n2;
}

static inline int min(int n1, int n2) {
    return n1 < n2 ? n1 : n2;
}

int *luckyNumbers (int **matrix, int matrixSize, int *matrixColSize, int *returnSize){
    int *ret = (int *)malloc(sizeof(int) * matrixSize * matrixColSize[0]);
    int retSize = 0;
    int *minRow = (int *)malloc(sizeof(int) * matrixSize), *maxCol = (int *)malloc(sizeof(int) * matrixColSize[0]);
    memset(minRow, 0x3f, sizeof(int) * matrixSize);
    memset(maxCol, 0, sizeof(int) * matrixColSize[0]);
    for (int i = 0; i < matrixSize; i++) {
        for (int j = 0; j < matrixColSize[0]; j++) {
            minRow[i] = min(minRow[i], matrix[i][j]);
            maxCol[j] = max(maxCol[j], matrix[i][j]);
        }
    }
    for (int i = 0; i < matrixSize; i++) {
        for (int j = 0; j < matrixColSize[0]; j++) {
            if (matrix[i][j] == minRow[i] && matrix[i][j] == maxCol[j]) {
                ret[retSize++] = matrix[i][j];
            }
        }
    }
    free(minRow);
    free(maxCol);
    *returnSize = retSize;
    return ret;
}
```

```JavaScript [sol2-JavaScript]
var luckyNumbers  = function(matrix) {
    const m = matrix.length, n = matrix[0].length;
    const minRow = new Array(m).fill(Number.MAX_SAFE_INTEGER);
    const maxCol = new Array(n).fill(0);
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            minRow[i] = Math.min(minRow[i], matrix[i][j]);
            maxCol[j] = Math.max(maxCol[j], matrix[i][j]);
        }
    }
    const ret = [];
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (matrix[i][j] === minRow[i] && matrix[i][j] === maxCol[j]) {
                ret.push(matrix[i][j]);
            }
        }
    }
    return ret;
};
```

```go [sol2-Golang]
func luckyNumbers(matrix [][]int) (ans []int) {
    minRow := make([]int, len(matrix))
    maxCol := make([]int, len(matrix[0]))
    for i, row := range matrix {
        minRow[i] = row[0]
        for j, x := range row {
            minRow[i] = min(minRow[i], x)
            maxCol[j] = max(maxCol[j], x)
        }
    }
    for i, row := range matrix {
        for j, x := range row {
            if x == minRow[i] && x == maxCol[j] {
                ans = append(ans, x)
            }
        }
    }
    return
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

**复杂度分析**

+ 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是矩阵 $\textit{matrix}$ 的行数和列数。预处理 $\textit{minRow}$ 和 $\textit{maxCol}$ 需要 $O(mn)$，查找幸运数需要 $O(mn)$。

+ 空间复杂度：$O(m + n)$。保存 $\textit{minRow}$ 和 $\textit{maxCol}$ 需要 $O(m + n)$ 的额外空间，返回值不计入空间复杂度。

#### 方法三：幸运数的性质

**思路与算法**

因为矩阵中的数字互不相同，我们可以推导出幸运数的一些性质：

+ 如果 $\textit{matrix}[i][j]$ 是幸运数，即 $\textit{matrix}[i][j]=\textit{minRow}[i]$ 且 $\textit{matrix}[i][j] = \textit{maxCol}[j]$，那么 $\textit{minRow}[i]$ 是 $\textit{minRow}$ 的最大值（记作 $\textit{rowMax}$），$\textit{maxCol}[j]$ 是 $\textit{maxCol}$ 的最小值（记作 $\textit{colMin}$）。

   > 证明：如果 $\textit{minRow}[i]$ 不是 $\textit{minRow}$ 的最大值，那么假设最大值 $\textit{rowMax} = \textit{minRow}[k] = \textit{matrix}[k][l]$，其中 $k \ne i$。于是 $\textit{matrix}[i][j] = \textit{minRow}[i] \lt \textit{rowMax} = \textit{minRow}[k] = \textit{matrix}[k][l] \lt \textit{matrix}[k][j]$，所以 $\textit{matrix}[i][j] \ne \textit{maxCol}[j]$，矛盾。因此 $\textit{minRow}[i]$ 是 $\textit{minRow}$ 的最大值。同理我们也可以证明 $\textit{maxCol}[j]$ 是 $\textit{maxCol}$ 的最小值。

+ 幸运数不超过一个。

   > 证明：如果存在两个幸运数 $a$ 和 $b$，那么 $a = b = \textit{rowMax}$，与矩阵中的数字互不相同矛盾。

如果存在幸运数，那么幸运数一定等于 $\textit{rowMax}$。因此我们可以先求出 $\textit{minRow}$ 的最大值 $\textit{rowMax}$，并记录 $\textit{rowMax}$ 所在的列 $k$，然后判断 $\textit{rowMax}$ 是不是第 $k$ 列的最大值，如果是，则返回 $\textit{rowMax}$。

**代码**

```Python [sol3-Python3]
class Solution:
    def luckyNumbers(self, matrix: List[List[int]]) -> List[int]:
        rowMax, k = 0, 0
        for row in matrix:
            minRow = min(row)
            if minRow > rowMax:
                rowMax, k = minRow, row.index(minRow)
        return [rowMax] if all(row[k] <= rowMax for row in matrix) else []
```

```C++ [sol3-C++]
class Solution {
public:
    vector<int> luckyNumbers (vector<vector<int>>& matrix) {
        int m = matrix.size();
        int rowMax = 0, k;
        for (int i = 0; i < m; i++) {
            int c = min_element(matrix[i].begin(), matrix[i].end()) - matrix[i].begin();
            if (rowMax < matrix[i][c]) {
                rowMax = matrix[i][c];
                k = c;
            }
        }
        for (int i = 0; i < m; i++) {
            if (rowMax < matrix[i][k]) {
                return {};
            }
        }
        return {rowMax};
    }
};
```

```Java [sol3-Java]
class Solution {
    public List<Integer> luckyNumbers (int[][] matrix) {
        List<Integer> ret = new ArrayList<Integer>();
        int m = matrix.length, n = matrix[0].length;
        int rowMax = 0, k = 0;
        for (int i = 0; i < m; i++) {
            int curMin = matrix[i][0];
            int c = 0;
            for (int j = 1; j < n; j++) {
                if (curMin > matrix[i][j]) {
                    curMin = matrix[i][j];
                    c = j;
                }
            }
            if (rowMax < curMin) {
                rowMax = curMin;
                k = c;
            }
        }
        for (int i = 0; i < m; i++) {
            if (rowMax < matrix[i][k]) {
                return ret;
            }
        }
        ret.add(rowMax);
        return ret;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public IList<int> LuckyNumbers (int[][] matrix) {
        IList<int> ret = new List<int>();
        int m = matrix.Length, n = matrix[0].Length;
        int rowMax = 0, k = 0;
        for (int i = 0; i < m; i++) {
            int curMin = matrix[i][0];
            int c = 0;
            for (int j = 1; j < n; j++) {
                if (curMin > matrix[i][j]) {
                    curMin = matrix[i][j];
                    c = j;
                }
            }
            if (rowMax < curMin) {
                rowMax = curMin;
                k = c;
            }
        }
        for (int i = 0; i < m; i++) {
            if (rowMax < matrix[i][k]) {
                return ret;
            }
        }
        ret.Add(rowMax);
        return ret;
    }
}
```

```C [sol3-C]
int *luckyNumbers (int **matrix, int matrixSize, int *matrixColSize, int *returnSize){
    int m = matrixSize, n = matrixColSize[0];
    int rowMax = 0, k;
    for (int i = 0; i < m; i++) {
        int index = 0;
        for (int j = 1; j < n; j++) {
            if (matrix[i][index] > matrix[i][j]) {
                index = j;
            }
        }
        if (rowMax < matrix[i][index]) {
            rowMax = matrix[i][index];
            k = index;
        }
    }

    for (int i = 0; i < m; i++) {
        if (rowMax < matrix[i][k]) {
            *returnSize = 0;
            return NULL;
        }
    }

    int *ret = (int *)malloc(sizeof(int));
    *ret = rowMax;
    *returnSize = 1;
    return ret;
}
```

```go [sol3-Golang]
func luckyNumbers(matrix [][]int) []int {
    rowMax, k := 0, 0
    for _, row := range matrix {
        c := 0
        for j, v := range row {
            if v < row[c] {
                c = j
            }
        }
        if row[c] > rowMax {
            rowMax = row[c]
            k = c
        }
    }
    for _, row := range matrix {
        if row[k] > rowMax {
            return nil
        }
    }
    return []int{rowMax}
}
```

```JavaScript [sol3-JavaScript]
var luckyNumbers  = function(matrix) {
    const ret = [];
    const m = matrix.length, n = matrix[0].length;
    let rowMax = 0, k = 0;
    for (let i = 0; i < m; i++) {
        let curMin = matrix[i][0];
        let c = 0;
        for (let j = 1; j < n; j++) {
            if (curMin > matrix[i][j]) {
                curMin = matrix[i][j];
                c = j;
            }
        }
        if (rowMax < curMin) {
            rowMax = curMin;
            k = c;
        }
    }
    for (let i = 0; i < m; i++) {
        if (rowMax < matrix[i][k]) {
            return ret;
        }
    }
    ret.push(rowMax);
    return ret;
};
```

**复杂度分析**

+ 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是矩阵 $\textit{matrix}$ 的行数和列数。获取 $\textit{rowMax}$ 需要 $O(mn)$，判断 $\textit{rowMax}$ 是否是列最大值需要 $O(m)$。

+ 空间复杂度：$O(1)$。
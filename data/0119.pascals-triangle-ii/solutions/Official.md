## [119.杨辉三角 II 中文官方题解](https://leetcode.cn/problems/pascals-triangle-ii/solutions/100000/yang-hui-san-jiao-ii-by-leetcode-solutio-shuk)
#### 方法一：递推

杨辉三角，是二项式系数在三角形中的一种几何排列。它是中国古代数学的杰出研究成果之一，它把二项式系数图形化，把组合数内在的一些代数性质直观地从图形中体现出来，是一种离散型的数与形的结合。

杨辉三角具有以下性质：

1. 每行数字左右对称，由 $1$ 开始逐渐变大再变小，并最终回到 $1$。

2. 第 $n$ 行（从 $0$ 开始编号）的数字有 $n+1$ 项，前 $n$ 行共有 $\frac{n(n+1)}{2}$ 个数。

3. 第 $n$ 行的第 $m$ 个数（从 $0$ 开始编号）可表示为可以被表示为组合数 $\mathcal{C}(n,m)$，记作 $\mathcal{C}_n^m$ 或 $\binom{n}{m}$，即为从 $n$ 个不同元素中取 $m$ 个元素的组合数。我们可以用公式来表示它：$\mathcal{C}_n^m=\dfrac{n!}{m!(n-m)!}$

4. 每个数字等于上一行的左右两个数字之和，可用此性质写出整个杨辉三角。即第 $n$ 行的第 $i$ 个数等于第 $n-1$ 行的第 $i-1$ 个数和第 $i$ 个数之和。这也是组合数的性质之一，即 $\mathcal{C}_n^i=\mathcal{C}_{n-1}^i+\mathcal{C}_{n-1}^{i-1}$。

5. $(a+b)^n$ 的展开式（二项式展开）中的各项系数依次对应杨辉三角的第 $n$ 行中的每一项。

依据性质 $4$，我们可以一行一行地计算杨辉三角。每当我们计算出第 $i$ 行的值，我们就可以在线性时间复杂度内计算出第 $i+1$ 行的值。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> getRow(int rowIndex) {
        vector<vector<int>> C(rowIndex + 1);
        for (int i = 0; i <= rowIndex; ++i) {
            C[i].resize(i + 1);
            C[i][0] = C[i][i] = 1;
            for (int j = 1; j < i; ++j) {
                C[i][j] = C[i - 1][j - 1] + C[i - 1][j];
            }
        }
        return C[rowIndex];
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> getRow(int rowIndex) {
        List<List<Integer>> C = new ArrayList<List<Integer>>();
        for (int i = 0; i <= rowIndex; ++i) {
            List<Integer> row = new ArrayList<Integer>();
            for (int j = 0; j <= i; ++j) {
                if (j == 0 || j == i) {
                    row.add(1);
                } else {
                    row.add(C.get(i - 1).get(j - 1) + C.get(i - 1).get(j));
                }
            }
            C.add(row);
        }
        return C.get(rowIndex);
    }
}
```

```go [sol1-Golang]
func getRow(rowIndex int) []int {
    C := make([][]int, rowIndex+1)
    for i := range C {
        C[i] = make([]int, i+1)
        C[i][0], C[i][i] = 1, 1
        for j := 1; j < i; j++ {
            C[i][j] = C[i-1][j-1] + C[i-1][j]
        }
    }
    return C[rowIndex]
}
```

```JavaScript [sol1-JavaScript]
var getRow = function(rowIndex) {
    const C = new Array(rowIndex + 1).fill(0);
    for (let i = 0; i <= rowIndex; ++i) {
        C[i] = new Array(i + 1).fill(0);
        C[i][0] = C[i][i] = 1;
        for (let j = 1; j < i; j++) {
            C[i][j] = C[i - 1][j - 1] + C[i - 1][j];
        }
    }
    return C[rowIndex];
};
```

```C [sol1-C]
int* getRow(int rowIndex, int* returnSize) {
    *returnSize = rowIndex + 1;
    int* C[rowIndex + 1];
    for (int i = 0; i <= rowIndex; ++i) {
        C[i] = malloc(sizeof(int) * (i + 1));
        C[i][0] = C[i][i] = 1;
        for (int j = 1; j < i; ++j) {
            C[i][j] = C[i - 1][j - 1] + C[i - 1][j];
        }
    }
    return C[rowIndex];
}
```

**优化**

注意到对第 $i+1$ 行的计算仅用到了第 $i$ 行的数据，因此可以使用**滚动数组**的思想优化空间复杂度。

```C++ [sol2-C++]
class Solution {
public:
    vector<int> getRow(int rowIndex) {
        vector<int> pre, cur;
        for (int i = 0; i <= rowIndex; ++i) {
            cur.resize(i + 1);
            cur[0] = cur[i] = 1;
            for (int j = 1; j < i; ++j) {
                cur[j] = pre[j - 1] + pre[j];
            }
            pre = cur;
        }
        return pre;
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<Integer> getRow(int rowIndex) {
        List<Integer> pre = new ArrayList<Integer>();
        for (int i = 0; i <= rowIndex; ++i) {
            List<Integer> cur = new ArrayList<Integer>();
            for (int j = 0; j <= i; ++j) {
                if (j == 0 || j == i) {
                    cur.add(1);
                } else {
                    cur.add(pre.get(j - 1) + pre.get(j));
                }
            }
            pre = cur;
        }
        return pre;
    }
}
```

```go [sol2-Golang]
func getRow(rowIndex int) []int {
    var pre, cur []int
    for i := 0; i <= rowIndex; i++ {
        cur = make([]int, i+1)
        cur[0], cur[i] = 1, 1
        for j := 1; j < i; j++ {
            cur[j] = pre[j-1] + pre[j]
        }
        pre = cur
    }
    return pre
}
```

```JavaScript [sol2-JavaScript]
var getRow = function(rowIndex) {
    let pre = [], cur = [];
    for (let i = 0; i <= rowIndex; ++i) {
        cur = new Array(i + 1).fill(0);
        cur[0] = cur[i] =1;
        for (let j = 1; j < i; ++j) {
            cur[j] = pre[j - 1] + pre[j];
        }
        pre = cur;
    }
    return pre;
};
```

```C [sol2-C]
int* getRow(int rowIndex, int* returnSize) {
    *returnSize = rowIndex + 1;
    int* pre = malloc(sizeof(int) * (*returnSize));
    memset(pre, 0, sizeof(int) * (*returnSize));
    int* cur = malloc(sizeof(int) * (*returnSize));
    memset(cur, 0, sizeof(int) * (*returnSize));
    for (int i = 0; i <= rowIndex; ++i) {
        cur[0] = cur[i] = 1;
        for (int j = 1; j < i; ++j) {
            cur[j] = pre[j - 1] + pre[j];
        }
        int* tmp = pre;
        pre = cur;
        cur = tmp;
    }
    return pre;
}
```

**进一步优化**

能否只用一个数组呢？

递推式 $\mathcal{C}_n^i=\mathcal{C}_{n-1}^i+\mathcal{C}_{n-1}^{i-1}$ 表明，当前行第 $i$ 项的计算只与上一行第 $i-1$ 项及第 $i$ 项有关。因此我们可以倒着计算当前行，这样计算到第 $i$ 项时，第 $i-1$ 项仍然是上一行的值。

```C++ [sol3-C++]
class Solution {
public:
    vector<int> getRow(int rowIndex) {
        vector<int> row(rowIndex + 1);
        row[0] = 1;
        for (int i = 1; i <= rowIndex; ++i) {
            for (int j = i; j > 0; --j) {
                row[j] += row[j - 1];
            }
        }
        return row;
    }
};
```

```Java [sol3-Java]
class Solution {
    public List<Integer> getRow(int rowIndex) {
        List<Integer> row = new ArrayList<Integer>();
        row.add(1);
        for (int i = 1; i <= rowIndex; ++i) {
            row.add(0);
            for (int j = i; j > 0; --j) {
                row.set(j, row.get(j) + row.get(j - 1));
            }
        }
        return row;
    }
}
```

```go [sol3-Golang]
func getRow(rowIndex int) []int {
    row := make([]int, rowIndex+1)
    row[0] = 1
    for i := 1; i <= rowIndex; i++ {
        for j := i; j > 0; j-- {
            row[j] += row[j-1]
        }
    }
    return row
}
```

```JavaScript [sol3-JavaScript]
var getRow = function(rowIndex) {
    const row = new Array(rowIndex + 1).fill(0);
    row[0] = 1;
    for (let i = 1; i <= rowIndex; ++i) {
        for (let j = i; j > 0; --j) {
            row[j] += row[j - 1];
        }
    }
    return row;
};
```

```C [sol3-C]
int* getRow(int rowIndex, int* returnSize) {
    *returnSize = rowIndex + 1;
    int* row = malloc(sizeof(int) * (*returnSize));
    memset(row, 0, sizeof(int) * (*returnSize));
    row[0] = 1;
    for (int i = 1; i <= rowIndex; ++i) {
        for (int j = i; j > 0; --j) {
            row[j] += row[j - 1];
        }
    }
    return row;
}
```

**复杂度分析**

- 时间复杂度：$O(\textit{rowIndex}^2)$。

- 空间复杂度：$O(1)$。不考虑返回值的空间占用。

#### 方法二：线性递推

由组合数公式 $\mathcal{C}_n^m=\dfrac{n!}{m!(n-m)!}$，可以得到同一行的相邻组合数的关系

$$\mathcal{C}_n^m= \mathcal{C}_n^{m-1} \times \dfrac{n-m+1}{m}$$

由于 $\mathcal{C}_n^0=1$，利用上述公式我们可以在线性时间计算出第 $n$ 行的所有组合数。

**代码**

```C++ [sol4-C++]
class Solution {
public:
    vector<int> getRow(int rowIndex) {
        vector<int> row(rowIndex + 1);
        row[0] = 1;
        for (int i = 1; i <= rowIndex; ++i) {
            row[i] = 1LL * row[i - 1] * (rowIndex - i + 1) / i;
        }
        return row;
    }
};
```

```Java [sol4-Java]
class Solution {
    public List<Integer> getRow(int rowIndex) {
        List<Integer> row = new ArrayList<Integer>();
        row.add(1);
        for (int i = 1; i <= rowIndex; ++i) {
            row.add((int) ((long) row.get(i - 1) * (rowIndex - i + 1) / i));
        }
        return row;
    }
}
```

```go [sol4-Golang]
func getRow(rowIndex int) []int {
    row := make([]int, rowIndex+1)
    row[0] = 1
    for i := 1; i <= rowIndex; i++ {
        row[i] = row[i-1] * (rowIndex - i + 1) / i
    }
    return row
}
```

```JavaScript [sol4-JavaScript]
var getRow = function(rowIndex) {
    const row = new Array(rowIndex + 1).fill(0);
    row[0] = 1;
    for (let i = 1; i <= rowIndex; ++i) {
        row[i] = row[i - 1] * (rowIndex - i + 1) / i;
    }
    return row;
};
```

```C [sol4-C]
int* getRow(int rowIndex, int* returnSize) {
    *returnSize = rowIndex + 1;
    int* row = malloc(sizeof(int) * (*returnSize));
    row[0] = 1;
    for (int i = 1; i <= rowIndex; ++i) {
        row[i] = 1LL * row[i - 1] * (rowIndex - i + 1) / i;
    }
    return row;
}
```

**复杂度分析**

- 时间复杂度：$O(\textit{rowIndex})$。

- 空间复杂度：$O(1)$。不考虑返回值的空间占用。
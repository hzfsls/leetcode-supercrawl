## [1572.矩阵对角线元素的和 中文官方题解](https://leetcode.cn/problems/matrix-diagonal-sum/solutions/100000/ju-zhen-dui-jiao-xian-yuan-su-de-he-by-leetcode-so)

#### 方法一：遍历矩阵

**思路与算法**

我们知道矩阵中某个位置 $(i,j)$ 处于对角线上，则一定满足下列条件之一：
+ $i = j$；
+ $i + j = n - 1$；

根据上述结论，我们可以遍历整个矩阵，如果当前坐标 $(i, j)$ 满足 $i = j$ 或者 $i + j = n - 1$ 则表示该位置一定在对角线上，则把当前的数字加入到答案之中。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int diagonalSum(vector<vector<int>>& mat) {
        int n = mat.size(), sum = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                if (i == j || i + j == n - 1) {
                    sum += mat[i][j];
                }
            }
        }
        return sum;
    }
};
```

```C [sol1-C]
int diagonalSum(int** mat, int matSize, int* matColSize) {
    int n = matSize, sum = 0;
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            if (i == j || i + j == n - 1) {
                sum += mat[i][j];
            }
        }
    }
    return sum;
}
```

```Java [sol1-Java]
class Solution {
    public int diagonalSum(int[][] mat) {
        int n = mat.length, sum = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                if (i == j || i + j == n - 1) {
                    sum += mat[i][j];
                }
            }
        }
        return sum;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int DiagonalSum(int[][] mat) {
        int n = mat.Length, sum = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                if (i == j || i + j == n - 1) {
                    sum += mat[i][j];
                }
            }
        }
        return sum;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def diagonalSum(self, mat: List[List[int]]) -> int:
        n = len(mat)
        return sum(mat[i][j] for i in range(n) for j in range(n) \
                    if i == j or i + j == n - 1)
```

```JavaScript [sol1-JavaScript]
var diagonalSum = function(mat) {
    const n = mat.length;
    let sum = 0;
    for (let i = 0; i < n; ++i) {
        for (let j = 0; j < n; ++j) {
            if (i == j || i + j == n - 1) {
                sum += mat[i][j];
            }
        }
    }
    return sum;
};
```

```Go [sol1-Go]
func diagonalSum(mat [][]int) int {
    n := len(mat)
    sum := 0
    for i := 0; i < n; i += 1 {
        for j := 0; j < n; j += 1 {
            if i == j || i + j == n - 1 {
                sum += mat[i][j]
            }
        }
    }
    return sum
}

```


**复杂度分析**

+ 时间复杂度：$O(n^2)$，其中 $n$ 是矩阵 $\textit{mat}$ 的行数。
+ 空间复杂度：$O(1)$。

#### 方法二：枚举对角线元素

**思路与算法**

逐行遍历，记当前的行号为 $i$，则当前行中处于对角线的元素为： 坐标 $(i, i)$ 和坐标 $(i, n - i - 1)$，因此我们把 $(i, i)$ 与 $(i, n - i - 1)$ 处的数字加入到答案中。
如果 $n$ 是奇数的话，则主对角线与副对角线存在交点 $(\lfloor \dfrac{n}{2} \rfloor,\lfloor \dfrac{n}{2} \rfloor)$，该点会被计算两次。所以当 $n$ 为奇数的时候，需要减掉交点处的值。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int diagonalSum(vector<vector<int>>& mat) {
        int n = mat.size(), sum = 0, mid = n / 2;
        for (int i = 0; i < n; ++i) {
            sum += mat[i][i] + mat[i][n - 1 - i];
        }
        return sum - mat[mid][mid] * (n & 1);
    }
};
```

```C [sol2-C]
int diagonalSum(int** mat, int matSize, int* matColSize) {
    int n = matSize, sum = 0, mid = n / 2;
    for (int i = 0; i < n; ++i) {
        sum += mat[i][i] + mat[i][n - 1 - i];
    }
    return sum - mat[mid][mid] * (n & 1);
}
```

```Java [sol2-Java]
class Solution {
    public int diagonalSum(int[][] mat) {
        int n = mat.length, sum = 0, mid = n / 2;
        for (int i = 0; i < n; ++i) {
            sum += mat[i][i] + mat[i][n - 1 - i];
        }
        return sum - mat[mid][mid] * (n & 1);
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int DiagonalSum(int[][] mat) {
        int n = mat.Length, sum = 0, mid = n / 2;
        for (int i = 0; i < n; ++i) {
            sum += mat[i][i] + mat[i][n - 1 - i];
        }
        return sum - mat[mid][mid] * (n & 1);
    }
}
```

```Python [sol2-Python3]
class Solution:
    def diagonalSum(self, mat: List[List[int]]) -> int:
        n = len(mat)
        total = 0
        mid = n // 2
        for i in range(n):
            total += mat[i][i] + mat[i][n - 1 - i]
        return total - mat[mid][mid] * (n & 1)
```

```JavaScript [sol2-JavaScript]
var diagonalSum = function(mat) {
    const n = mat.length, mid = Math.floor(n / 2);
    let sum = 0;
    for (let i = 0; i < n; ++i) {
        sum += mat[i][i] + mat[i][n - 1 - i];
    }
    return sum - mat[mid][mid] * (n & 1);
};
```

```Go [sol2-Go]
func diagonalSum(mat [][]int) int {
    n := len(mat)
    sum := 0
    mid := n / 2
    for i := 0; i < n; i += 1 {
        sum += mat[i][i] + mat[i][n - 1 - i]
    }
    if n & 1 == 1 {
        sum -= mat[mid][mid]
    }
    return sum
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是矩阵 $\textit{mat}$ 的行数。
+ 空间复杂度：$O(1)$。
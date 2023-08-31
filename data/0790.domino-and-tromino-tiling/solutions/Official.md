## [790.多米诺和托米诺平铺 中文官方题解](https://leetcode.cn/problems/domino-and-tromino-tiling/solutions/100000/duo-mi-nuo-he-tuo-mi-nuo-ping-pu-by-leet-7n0j)
#### 方法一：动态规划

考虑这么一种平铺的方式：在第 $i$ 列前面的正方形都被瓷砖覆盖，在第 $i$ 列后面的正方形都没有被瓷砖覆盖（$i$ 从 $1$ 开始计数）。那么第 $i$ 列的正方形有四种被覆盖的情况：

+ 一个正方形都没有被覆盖，记为状态 $0$；

+ 只有上方的正方形被覆盖，记为状态 $1$；

+ 只有下方的正方形被覆盖，记为状态 $2$；

+ 上下两个正方形都被覆盖，记为状态 $3$。

使用 $\textit{dp}[i][s]$ 表示平铺到第 $i$ 列时，各个状态 $s$ 对应的平铺方法数量。考虑第 $i-1$ 列和第 $i$ 列正方形，它们之间的状态转移如下图（红色条表示新铺的瓷砖）：

![fig1](https://assets.leetcode-cn.com/solution-static/790/1.png)

初始时 $\textit{dp}[0][0] = 0, \textit{dp}[0][1] = 0, \textit{dp}[0][2] = 0, \textit{dp}[0][3] = 1$，对应的状态转移方程（$i \gt 0$）为：

$$
\begin{aligned}
    \textit{dp}[i][0] &= \textit{dp}[i-1][3] \\
    \textit{dp}[i][1] &= \textit{dp}[i-1][0] + \textit{dp}[i-1][2] \\
    \textit{dp}[i][2] &= \textit{dp}[i-1][0] + \textit{dp}[i-1][1] \\
    \textit{dp}[i][3] &= \textit{dp}[i-1][0] + \textit{dp}[i-1][1] + \textit{dp}[i-1][2] + \textit{dp}[i-1][3] \\
\end{aligned}
$$

最后平铺到第 $n$ 列时，上下两个正方形都被覆盖的状态 $\textit{dp}[n][3]$ 对应的平铺方法数量就是总平铺方法数量。

```Python [sol1-Python3]
class Solution:
    def numTilings(self, n: int) -> int:
        MOD = 10 ** 9 + 7
        dp = [[0] * 4 for _ in range(n + 1)]
        dp[0][3] = 1
        for i in range(1, n + 1):
            dp[i][0] = dp[i - 1][3]
            dp[i][1] = (dp[i - 1][0] + dp[i - 1][2]) % MOD
            dp[i][2] = (dp[i - 1][0] + dp[i - 1][1]) % MOD
            dp[i][3] = (((dp[i - 1][0] + dp[i - 1][1]) % MOD + dp[i - 1][2]) % MOD + dp[i - 1][3]) % MOD
        return dp[n][3]
```

```C++ [sol1-C++]
const long long mod = 1e9 + 7;
class Solution {
public:
    int numTilings(int n) {
        vector<vector<long long>> dp(n + 1, vector<long long>(4));
        dp[0][3] = 1;
        for (int i = 1; i <= n; i++) {
            dp[i][0] = dp[i - 1][3];
            dp[i][1] = (dp[i - 1][0] + dp[i - 1][2]) % mod;
            dp[i][2] = (dp[i - 1][0] + dp[i - 1][1]) % mod;
            dp[i][3] = (dp[i - 1][0] + dp[i - 1][1] + dp[i - 1][2] + dp[i - 1][3]) % mod;
        }
        return dp[n][3];
    }
};
```

```Java [sol1-Java]
class Solution {
    static final int MOD = 1000000007;

    public int numTilings(int n) {
        int[][] dp = new int[n + 1][4];
        dp[0][3] = 1;
        for (int i = 1; i <= n; i++) {
            dp[i][0] = dp[i - 1][3];
            dp[i][1] = (dp[i - 1][0] + dp[i - 1][2]) % MOD;
            dp[i][2] = (dp[i - 1][0] + dp[i - 1][1]) % MOD;
            dp[i][3] = (((dp[i - 1][0] + dp[i - 1][1]) % MOD + dp[i - 1][2]) % MOD + dp[i - 1][3]) % MOD;
        }
        return dp[n][3];
    }
}
```

```C# [sol1-C#]
public class Solution {
    const int MOD = 1000000007;

    public int NumTilings(int n) {
        int[][] dp = new int[n + 1][];
        for (int i = 0; i <= n; i++) {
            dp[i] = new int[4];
        }
        dp[0][3] = 1;
        for (int i = 1; i <= n; i++) {
            dp[i][0] = dp[i - 1][3];
            dp[i][1] = (dp[i - 1][0] + dp[i - 1][2]) % MOD;
            dp[i][2] = (dp[i - 1][0] + dp[i - 1][1]) % MOD;
            dp[i][3] = (((dp[i - 1][0] + dp[i - 1][1]) % MOD + dp[i - 1][2]) % MOD + dp[i - 1][3]) % MOD;
        }
        return dp[n][3];
    }
}
```

```JavaScript [sol1-JavaScript]
var numTilings = function(n) {
    const mod = 1e9 + 7;
    const dp = new Array(n + 1).fill(0).map(() => new Array(4).fill(0));
    dp[0][3] = 1;
    for (let i = 1; i <= n; i++) {
        dp[i][0] = dp[i - 1][3];
        dp[i][1] = (dp[i - 1][0] + dp[i - 1][2]) % mod;
        dp[i][2] = (dp[i - 1][0] + dp[i - 1][1]) % mod;
        dp[i][3] = (dp[i - 1][0] + dp[i - 1][1] + dp[i - 1][2] + dp[i - 1][3]) % mod;
    }
    return dp[n][3];
};
```

```C [sol1-C]
const long long mod = 1e9 + 7;

int numTilings(int n) {
    long long dp[n + 1][4];
    memset(dp, 0, sizeof(dp));
    dp[0][3] = 1;
    for (int i = 1; i <= n; i++) {
        dp[i][0] = dp[i - 1][3];
        dp[i][1] = (dp[i - 1][0] + dp[i - 1][2]) % mod;
        dp[i][2] = (dp[i - 1][0] + dp[i - 1][1]) % mod;
        dp[i][3] = (dp[i - 1][0] + dp[i - 1][1] + dp[i - 1][2] + dp[i - 1][3]) % mod;
    }
    return dp[n][3];
}
```

```go [sol1-Golang]
func numTilings(n int) int {
    const mod int = 1e9 + 7
    dp := make([][4]int, n+1)
    dp[0][3] = 1
    for i := 1; i <= n; i++ {
        dp[i][0] = dp[i-1][3]
        dp[i][1] = (dp[i-1][0] + dp[i-1][2]) % mod
        dp[i][2] = (dp[i-1][0] + dp[i-1][1]) % mod
        dp[i][3] = (((dp[i-1][0]+dp[i-1][1])%mod+dp[i-1][2])%mod + dp[i-1][3]) % mod
    }
    return dp[n][3]
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是总列数。

+ 空间复杂度：$O(n)$。保存 $\textit{dp}$ 数组需要 $O(n)$ 的空间。

#### 方法二：矩阵快速幂

关于矩阵快速幂的讲解可以参考官方题解「[70. 爬楼梯](https://leetcode.cn/problems/climbing-stairs/solutions/286022/pa-lou-ti-by-leetcode-solution/)」的方法二，本文不再作详细说明。由方法一可知，平铺到某一列时的所有覆盖状态可以用一个列向量 $x$ 来表示，那么初始时 $x = [0 \ 0 \ 0 \ 1]^T$。一次状态转移等价于在左边乘上矩阵：

$$
A = 
\begin{bmatrix}
    0&0&0&1 \\
    1&0&1&0 \\
    1&1&0&0 \\
    1&1&1&1 \\
\end{bmatrix}
$$

那么 $n$ 次状态转移后，所有覆盖状态对应的列向量为 $A^n x$，其中 $A^n$ 可以使用矩阵快速幂来计算。根据 $x$ 的值，可以知道最终所有的覆盖状态对应的列向量为 $A^n$ 的第 $3$ 列，返回该列向量的第 $3$ 个元素即可。

```Python [sol2-Python3]
class Solution:
    def numTilings(self, n: int) -> int:
        MOD = 10 ** 9 + 7

        def multiply(a: List[List[int]], b: List[List[int]]) -> List[List[int]]:
            rows, columns, temp = len(a), len(b[0]), len(b)
            c = [[0] * columns for _ in range(rows)]
            for i in range(rows):
                for j in range(columns):
                    for k in range(temp):
                        c[i][j] = (c[i][j] + a[i][k] * b[k][j]) % MOD
            return c

        def matrixPow(mat: List[List[int]], n: int) -> List[List[int]]:
            ret = [
                [1, 0, 0, 0],
                [0, 1, 0, 0],
                [0, 0, 1, 0],
                [0, 0, 0, 1],
            ]
            while n:
                if n & 1:
                    ret = multiply(ret, mat)
                n >>= 1
                mat = multiply(mat, mat)
            return ret

        mat = [
            [0, 0, 0, 1],
            [1, 0, 1, 0],
            [1, 1, 0, 0],
            [1, 1, 1, 1],
        ]
        res = matrixPow(mat, n)
        return res[3][3]
```

```C++ [sol2-C++]
const long long mod = 1e9 + 7;
class Solution {
public:
    vector<vector<long long>> mulMatrix(const vector<vector<long long>> &m1, const vector<vector<long long>> &m2) {
        int n1 = m1.size(), n2 = m2.size(), n3 = m2[0].size();
        vector<vector<long long>> res(n1, vector<long long>(n3));
        for (int i = 0; i < n1; i++) {
            for (int k = 0; k < n3; k++) {
                for (int j = 0; j < n2; j++) {
                    res[i][k] = (res[i][k] + m1[i][j] * m2[j][k]) % mod;
                }
            }
        }
        return res;
    }

    int numTilings(int n) {
        vector<vector<long long>> mat = {
            {0, 0, 0, 1},
            {1, 0, 1, 0},
            {1, 1, 0, 0},
            {1, 1, 1, 1}
        };
        vector<vector<long long>> matn = {
            {1, 0, 0, 0},
            {0, 1, 0, 0},
            {0, 0, 1, 0},
            {0, 0, 0, 1}
        };
        while (n) {
            if (n & 1) {
                matn = mulMatrix(matn, mat);
            }
            mat = mulMatrix(mat, mat);
            n >>= 1;
        }
        return matn[3][3];
    }
};
```

```Java [sol2-Java]
class Solution {
    static final int MOD = 1000000007;

    public int numTilings(int n) {
        int[][] mat = {
            {0, 0, 0, 1},
            {1, 0, 1, 0},
            {1, 1, 0, 0},
            {1, 1, 1, 1}
        };
        int[][] matn = {
            {1, 0, 0, 0},
            {0, 1, 0, 0},
            {0, 0, 1, 0},
            {0, 0, 0, 1}
        };
        while (n > 0) {
            if ((n & 1) != 0) {
                matn = mulMatrix(matn, mat);
            }
            mat = mulMatrix(mat, mat);
            n >>= 1;
        }
        return matn[3][3];
    }

    public int[][] mulMatrix(int[][] m1, int[][] m2) {
        int n1 = m1.length, n2 = m2.length, n3 = m2[0].length;
        int[][] res = new int[n1][n3];
        for (int i = 0; i < n1; i++) {
            for (int k = 0; k < n3; k++) {
                for (int j = 0; j < n2; j++) {
                    res[i][k] = (int) ((res[i][k] + (long) m1[i][j] * m2[j][k]) % MOD);
                }
            }
        }
        return res;
    }
}
```

```C# [sol2-C#]
public class Solution {
    const int MOD = 1000000007;

    public int NumTilings(int n) {
        int[][] mat = {
            new int[]{0, 0, 0, 1},
            new int[]{1, 0, 1, 0},
            new int[]{1, 1, 0, 0},
            new int[]{1, 1, 1, 1}
        };
        int[][] matn = {
            new int[]{1, 0, 0, 0},
            new int[]{0, 1, 0, 0},
            new int[]{0, 0, 1, 0},
            new int[]{0, 0, 0, 1}
        };
        while (n > 0) {
            if ((n & 1) != 0) {
                matn = MulMatrix(matn, mat);
            }
            mat = MulMatrix(mat, mat);
            n >>= 1;
        }
        return matn[3][3];
    }

    public int[][] MulMatrix(int[][] m1, int[][] m2) {
        int n1 = m1.Length, n2 = m2.Length, n3 = m2[0].Length;
        int[][] res = new int[n1][];
        for (int i = 0; i < n1; i++) {
            res[i] = new int[n3];
            for (int k = 0; k < n3; k++) {
                for (int j = 0; j < n2; j++) {
                    res[i][k] = (int) ((res[i][k] + (long) m1[i][j] * m2[j][k]) % MOD);
                }
            }
        }
        return res;
    }
}
```

```C [sol2-C]
const long long mod = 1e9 + 7;

struct Matrix {
    long long mat[4][4];
};

struct Matrix mulMatrix(const struct Matrix *m1, const struct Matrix *m2) {
    struct Matrix res;
    memset(&res, 0, sizeof(res));
    for (int i = 0; i < 4; i++) {
        for (int k = 0; k < 4; k++) {
            for (int j = 0; j < 4; j++) {
                res.mat[i][k] = (res.mat[i][k] + m1->mat[i][j] * m2->mat[j][k]) % mod;
            }
        }
    }
    return res;
}

int numTilings(int n) {
    long long mat1[4][4] = {
        {0, 0, 0, 1},
        {1, 0, 1, 0},
        {1, 1, 0, 0},
        {1, 1, 1, 1}
    };
    long long mat2[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {0, 0, 0, 1}
    };
    struct Matrix mat, matn;
    memcpy(mat.mat, mat1, sizeof(mat1));
    memcpy(matn.mat, mat2, sizeof(mat2));
    while (n) {
        if (n & 1) {
            matn = mulMatrix(&matn, &mat);
        }
        mat = mulMatrix(&mat, &mat);
        n >>= 1;
    }
    return matn.mat[3][3];
}
```

```go [sol2-Golang]
const mod int = 1e9 + 7

type matrix [4][4]int

func (a matrix) mul(b matrix) matrix {
    c := matrix{}
    for i, row := range a {
        for j := range b[0] {
            for k, v := range row {
                c[i][j] = (c[i][j] + v*b[k][j]) % mod
            }
        }
    }
    return c
}

func (a matrix) pow(n int) matrix {
    res := matrix{}
    for i := range res {
        res[i][i] = 1
    }
    for ; n > 0; n >>= 1 {
        if n&1 > 0 {
            res = res.mul(a)
        }
        a = a.mul(a)
    }
    return res
}

func numTilings(n int) int {
    m := matrix{
        {0, 0, 0, 1},
        {1, 0, 1, 0},
        {1, 1, 0, 0},
        {1, 1, 1, 1},
    }
    return m.pow(n)[3][3]
}
```

**复杂度分析**

+ 时间复杂度：$O(\log n)$，其中 $n$ 是总列数。矩阵快速幂的时间复杂度为 $O(\log n)$。

+ 空间复杂度：$O(1)$。
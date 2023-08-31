## [1220.统计元音字母序列的数目 中文官方题解](https://leetcode.cn/problems/count-vowels-permutation/solutions/100000/tong-ji-yuan-yin-zi-mu-xu-lie-de-shu-mu-jxo09)
#### 方法一：动态规划

**思路**

题目中给定的字符的下一个字符的规则如下：
+ 字符串中的每个字符都应当是小写元音字母 $（\texttt{`a'}, \texttt{`e'}, \texttt{`i'}, \texttt{`o'}, \texttt{`u'}）$；
+ 每个元音 $\texttt{`a'}$ 后面都只能跟着 $\texttt{`e'}$；
+ 每个元音 $\texttt{`e'}$ 后面只能跟着 $\texttt{`a'}$ 或者是 $\texttt{`i'}$；
+ 每个元音 $\texttt{`i'}$ 后面不能再跟着另一个 $\texttt{`i'}$；
+ 每个元音 $\texttt{`o'}$ 后面只能跟着 $\texttt{`i'}$ 或者是 $\texttt{`u'}$；
+ 每个元音 $\texttt{`u'}$ 后面只能跟着 $\texttt{`a'}$；

以上等价于每个字符的前一个字符的规则如下：
+ 元音字母 $\texttt{`a'}$ 前面只能跟着 $\texttt{`e'}, \texttt{`i'}, \texttt{`u'}$；
+ 元音字母 $\texttt{`e'}$ 前面只能跟着 $\texttt{`a'}, \texttt{`i'}$；
+ 每个元音 $\texttt{`i'}$ 前面只能跟着 $\texttt{`e'}, \texttt{`o'}$；
+ 每个元音 $\texttt{`o'}$ 前面只能跟着 $\texttt{`i'}$；
+ 每个元音 $\texttt{`u'}$ 后面只能跟着 $\texttt{`o'}, \texttt{`i'}$；

我们设 $\textit{dp}[i][j]$ 代表当前长度为 $i$ 且以字符 $j$ 为结尾的字符串的数目，其中在此 $j = {0,1,2,3,4}$ 分别代表元音字母 ${\texttt{`a'}, \texttt{`e'}, \texttt{`i'}, \texttt{`o'}, \texttt{`u'}}$，通过以上的字符规则，我们可以得到动态规划递推公式如下：

$$
\left\{
  \begin{array}{lr}
\textit{dp}[i][0] = \textit{dp}[i-1][1] + \textit{dp}[i-1][2] + \textit{dp}[i-1][4] \\
\textit{dp}[i][1] = \textit{dp}[i-1][0] + \textit{dp}[i-1][2] \\
\textit{dp}[i][2] = \textit{dp}[i-1][1] + \textit{dp}[i-1][3]  \\
\textit{dp}[i][3] = \textit{dp}[i-1][2] \\
\textit{dp}[i][4] = \textit{dp}[i-1][2] + \textit{dp}[i-1][3]
  \end{array}
\right.
$$

按照题目规则最终可以形成长度为 $n$ 的字符串的数目为：$\sum_{i=0}^4\textit{dp}[n][i]$

+ 实际计算过程中只需要保留前一个状态即可推导出后一个状态，计算长度为 $i$ 的状态只需要长度为 $i-1$ 的中间变量即可，$i-1$ 之前的状态全部都可以丢弃掉。计算过程中，答案需要取模 $1\text{e}9+7$。

**代码**

```Java [sol1-Java]
class Solution {
    public int countVowelPermutation(int n) {
        long mod = 1000000007;
        long[] dp = new long[5];
        long[] ndp = new long[5];
        for (int i = 0; i < 5; ++i) {
            dp[i] = 1;
        }
        for (int i = 2; i <= n; ++i) {
            /* a前面可以为e,u,i */
            ndp[0] = (dp[1] + dp[2] + dp[4]) % mod;
            /* e前面可以为a,i */
            ndp[1] = (dp[0] + dp[2]) % mod;
            /* i前面可以为e,o */
            ndp[2] = (dp[1] + dp[3]) % mod;
            /* o前面可以为i */
            ndp[3] = dp[2];
            /* u前面可以为i,o */
            ndp[4] = (dp[2] + dp[3]) % mod;
            System.arraycopy(ndp, 0, dp, 0, 5);
        }
        long ans = 0;
        for (int i = 0; i < 5; ++i) {
            ans = (ans + dp[i]) % mod;
        }
        return (int)ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int countVowelPermutation(int n) {
        long long mod = 1e9 + 7;
        vector<long long> dp(5, 1);
        vector<long long> ndp(5);
        for (int i = 2; i <= n; ++i) {
            /* a前面可以为e,u,i */
            ndp[0] = (dp[1] + dp[2] + dp[4]) % mod;
            /* e前面可以为a,i */
            ndp[1] = (dp[0] + dp[2]) % mod;
            /* i前面可以为e,o */
            ndp[2] = (dp[1] + dp[3]) % mod;
            /* o前面可以为i */
            ndp[3] = dp[2];
            /* u前面可以为i,o */
            ndp[4] = (dp[2] + dp[3]) % mod;
            dp = ndp;
        }
        return accumulate(dp.begin(), dp.end(), 0LL) % mod;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public int CountVowelPermutation(int n) {
        long mod = 1000000007;
        long[] dp = new long[5];
        long[] ndp = new long[5];
        for (int i = 0; i < 5; ++i) {
            dp[i] = 1;
        }
        for (int i = 2; i <= n; ++i) {
            /* a前面可以为e,u,i */
            ndp[0] = (dp[1] + dp[2] + dp[4]) % mod;
            /* e前面可以为a,i */
            ndp[1] = (dp[0] + dp[2]) % mod;
            /* i前面可以为e,o */
            ndp[2] = (dp[1] + dp[3]) % mod;
            /* o前面可以为i */
            ndp[3] = dp[2];
            /* u前面可以为i,o */
            ndp[4] = (dp[2] + dp[3]) % mod;
            Array.Copy(ndp, 0, dp, 0, 5);
        }
        long ans = 0;
        for (int i = 0; i < 5; ++i) {
            ans = (ans + dp[i]) % mod;
        }
        return (int)ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def countVowelPermutation(self, n: int) -> int:
        dp = (1, 1, 1, 1, 1)
        for _ in range(n - 1):
            dp = ((dp[1] + dp[2] + dp[4]) % 1000000007, (dp[0] + dp[2]) % 1000000007, (dp[1] + dp[3]) % 1000000007, dp[2], (dp[2] + dp[3]) % 1000000007)
        return sum(dp) % 1000000007
```

```C [sol1-C]
typedef long long LL;

int countVowelPermutation(int n){
    long long mod = 1e9 + 7;
    long long ans = 0;
    LL * dp = (LL *)malloc(sizeof(LL) * 5);
    LL * ndp = (LL *)malloc(sizeof(LL) * 5);
    
    for (int i = 0; i < 5; ++i) {
        dp[i] = 1;
    }
    for (int i = 2; i <= n; ++i) {
        /* a前面可以为e,u,i */
        ndp[0] = (dp[1] + dp[2] + dp[4]) % mod;
        /* e前面可以为a,i */
        ndp[1] = (dp[0] + dp[2]) % mod;
        /* i前面可以为e,o */
        ndp[2] = (dp[1] + dp[3]) % mod;
        /* o前面可以为i */
        ndp[3] = dp[2];
        /* u前面可以为i,o */
        ndp[4] = (dp[2] + dp[3]) % mod;
        memcpy(dp, ndp, sizeof(LL) * 5);
    }
    for (int i = 0; i < 5; ++i) {
        ans = (ans + dp[i]) % mod;
    }
    free(dp);
    free(ndp);
    return ans;
}
```

```go [sol1-Golang]
func countVowelPermutation(n int) (ans int) {
    const mod int = 1e9 + 7
    dp := [5]int{1, 1, 1, 1, 1}
    for i := 1; i < n; i++ {
        dp = [5]int{
            (dp[1] + dp[2] + dp[4]) % mod, // a 前面可以为 e,u,i
            (dp[0] + dp[2]) % mod,         // e 前面可以为 a,i
            (dp[1] + dp[3]) % mod,         // i 前面可以为 e,o
            dp[2],                         // o 前面可以为 i
            (dp[2] + dp[3]) % mod,         // u 前面可以为 i,o
        }
    }
    for _, v := range dp {
        ans = (ans + v) % mod
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var countVowelPermutation = function(n) {
    const mod = 1000000007;
    const dp = new Array(5).fill(0);
    const ndp = new Array(5).fill(0);
    for (let i = 0; i < 5; ++i) {
        dp[i] = 1;
    }
    for (let i = 2; i <= n; ++i) {
        /* a前面可以为e,u,i */
        ndp[0] = (dp[1] + dp[2] + dp[4]) % mod;
        /* e前面可以为a,i */
        ndp[1] = (dp[0] + dp[2]) % mod;
        /* i前面可以为e,o */
        ndp[2] = (dp[1] + dp[3]) % mod;
        /* o前面可以为i */
        ndp[3] = dp[2];
        /* u前面可以为i,o */
        ndp[4] = (dp[2] + dp[3]) % mod;
        dp.splice(0, 5, ...ndp);
    }
    let ans = 0;
    for (let i = 0; i < 5; ++i) {
        ans = (ans + dp[i]) % mod;
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(C \times n)$，其中 $n$ 是给定，$C$ 表示元音字母的数量，在本题中 $C = 5$。

- 空间复杂度：$O(C)$，我们只需要常数个空间存储不同组的数目。

#### 方法二：矩阵快速幂

**思路**

已经知道上述的递推公式，可以转将其转化为矩阵乘法，设 $f(n)$ 表示长度为 $n$ 的字符串且以不同元音字母为结尾的组合数矩阵，构造矩阵的递推关系如下：
$$
f(n) = 
\begin{bmatrix}
0 & 1 & 1 & 0 & 1\\
1 & 0 & 1 & 0 & 0\\
0 & 1 & 0 & 1 & 0\\
0 & 0 & 1 & 0 & 0\\
0 & 0 & 1 & 1 & 0\\
\end{bmatrix} 
\times f(n-1)
$$
因此我们可以推出:
$$
f(n) = 
\begin{bmatrix}
0 & 1 & 1 & 0 & 1\\
1 & 0 & 1 & 0 & 0\\
0 & 1 & 0 & 1 & 0\\
0 & 0 & 1 & 0 & 0\\
0 & 0 & 1 & 1 & 0\\
\end{bmatrix}^{n-1}
\times f(1)
$$
令：
$$
f(1) = 
\begin{bmatrix}
1 \\
1 \\
1 \\
1 \\
1 \\
\end{bmatrix} 
$$
$$
M = 
\begin{bmatrix}
0 & 1 & 1 & 0 & 1\\
1 & 0 & 1 & 0 & 0\\
0 & 1 & 0 & 1 & 0\\
0 & 0 & 1 & 0 & 0\\
0 & 0 & 1 & 1 & 0\\
\end{bmatrix}
$$
因此只要我们能快速计算矩阵 $M$ 的 $n$ 次幂，就可以得到 $f(n)$ 的值。如果直接求取 $M^n$ ，时间复杂度是 $O(n)$，可以定义矩阵乘法，然后用快速幂算法来加速 $M^n$ 的求取。计算过程中，答案需要取模 $1\text{e}9+7$。

**代码**

```Java [sol2-Java]
class Solution {
    public int countVowelPermutation(int n) {
        long mod = 1_000_000_007;
        long[][] factor =
        {
            {0, 1, 0, 0, 0}, 
            {1, 0, 1, 0, 0}, 
            {1, 1, 0, 1, 1}, 
            {0, 0, 1, 0, 1}, 
            {1, 0, 0, 0, 0}
        };

        long[][] res = fastPow(factor, n - 1, mod);
        long ans = 0;
        for (int i = 0; i < 5; ++i) {
            for (int j = 0; j < 5; ++j) {
                ans = (ans + res[i][j]) % mod;
            }
        }
        return (int)ans;
    }

    public long[][] fastPow(long[][] matrix, int n, long mod) {
        int m = matrix.length;
        long[][] res = new long[m][m];
        long[][] curr = matrix;

        for (int i = 0; i < m; ++i) {
            res[i][i] = 1;
        }
        for (int i = n; i != 0; i >>= 1) {
            if ((i % 2) == 1) {
                res = multiply(curr, res, mod);
            }
            curr = multiply(curr, curr, mod);
        }
        return res;
    }

    public long[][] multiply(long[][] matrixA, long[][] matrixB, long mod) {
        int m = matrixA.length;
        int n = matrixB[0].length;
        long[][] res = new long[m][n];

        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                res[i][j] = 0;
                for (int k = 0; k < matrixA[i].length; ++k) {
                    res[i][j] = (res[i][j] + matrixA[i][k] * matrixB[k][j]) % mod;
                }
            }
        }
        return res;
    }
}
```

```C++ [sol2-C++]
using LL = long long;
using Mat = vector<vector<LL>>;

class Solution {
public:     
    Mat multiply(const Mat & matrixA, const Mat & matrixB, LL mod) {
        int m = matrixA.size();
        int n = matrixB[0].size();
        Mat res(m, vector<LL>(n, 0));
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                for (int k = 0; k < matrixA[i].size(); ++k) {
                    res[i][j] = (res[i][j] + matrixA[i][k] * matrixB[k][j]) % mod;
                }
            }
        }
        return res;
    }
     
    Mat fastPow(const Mat & matrix, LL n, LL mod) {
        int m = matrix.size();
        Mat res(m, vector<LL>(m, 0));
        Mat curr = matrix;

        for (int i = 0; i < m; ++i) {
            res[i][i] = 1;
        }
        for (int i = n; i != 0; i >>= 1) {
            if (i & 1) {
                res = multiply(curr, res, mod);
            }
            curr = multiply(curr, curr, mod);
        }
        return res;
    }

    int countVowelPermutation(int n) {
        LL mod = 1e9 + 7;
        Mat factor =
        {
            {0, 1, 0, 0, 0}, 
            {1, 0, 1, 0, 0}, 
            {1, 1, 0, 1, 1}, 
            {0, 0, 1, 0, 1}, 
            {1, 0, 0, 0, 0}
        };
        Mat res = fastPow(factor, n - 1, mod);
        long long ans = 0;
        for (int i = 0; i < 5; ++i) {
            ans = (ans + accumulate(res[i].begin(), res[i].end(), 0LL)) % mod;
        }
        return  ans;
    }
};
```

```C# [sol2-C#]
public class Solution {
    public int CountVowelPermutation(int n) {
        long mod = 1_000_000_007;
        long[][] factor =
        {
            new long[]{0, 1, 0, 0, 0}, 
            new long[]{1, 0, 1, 0, 0}, 
            new long[]{1, 1, 0, 1, 1}, 
            new long[]{0, 0, 1, 0, 1}, 
            new long[]{1, 0, 0, 0, 0}
        };

        long[][] res = FastPow(factor, n - 1, mod);
        long ans = 0;
        for (int i = 0; i < 5; ++i) {
            for (int j = 0; j < 5; ++j) {
                ans = (ans + res[i][j]) % mod;
            }
        }
        return (int)ans;
    }

    public long[][] FastPow(long[][] matrix, int n, long mod) {
        int m = matrix.Length;
        long[][] res = new long[m][];
        for (int i = 0; i < m; ++i) {
            res[i] = new long[m];
        }
        long[][] curr = matrix;

        for(int i = 0; i < m; ++i) {
            res[i][i] = 1;
        }
        for (int i = n; i != 0; i >>= 1) {
            if ((i % 2) == 1) {
                res = Multiply(curr, res, mod);
            }
            curr = Multiply(curr, curr, mod);
        }
        return res;
    }

    public long[][] Multiply(long[][] matrixA, long[][] matrixB, long mod) {
        int m = matrixA.Length;
        int n = matrixB[0].Length;
        long[][] res = new long[m][];
        for (int i = 0; i < m; ++i) {
            res[i] = new long[n];
        }

        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                res[i][j] = 0;
                for (int k = 0; k < matrixA[i].Length; ++k) {
                    res[i][j] = (res[i][j] + matrixA[i][k] * matrixB[k][j]) % mod;
                }
            }
        }
        return res;
    }
}
```

```Python [sol2-Python3]
import numpy as np
class Solution:
    def countVowelPermutation(self, n: int) -> int:
        factor = np.mat([(0, 1, 0, 0, 0), (1, 0, 1, 0, 0), (1, 1, 0, 1, 1), (0, 0, 1, 0, 1), (1, 0, 0, 0, 0)], np.dtype('O'))
        res = np.mat([(1, 1, 1, 1, 1)], np.dtype('O'))
        n -= 1
        while n > 0:
            if n % 2 == 1:
                res = res * factor % 1000000007
            factor = factor * factor % 1000000007
            n = n // 2
        return res.sum() % 1000000007
```

```C [sol2-C]
typedef long long LL;
typedef LL * Mat;

#define IDX(x, y, col) ((x) * (col) + (y))

Mat multiply(const Mat matrixA, int matrixARowSize, int matrixAColSize, const Mat matrixB, int matrixBRowSize, int matrixBColSize, LL mod) {
    Mat res = (LL *)malloc(sizeof(LL) * matrixARowSize * matrixBColSize);
    memset(res, 0, sizeof(LL) * matrixARowSize * matrixBColSize);
    for (int i = 0; i < matrixARowSize; ++i) {
        for (int j = 0; j < matrixBColSize; ++j) {
            for (int k = 0; k < matrixAColSize; ++k) {
                res[IDX(i, j, matrixAColSize)] = (res[IDX(i, j, matrixAColSize)] + \
                                                  matrixA[IDX(i, k, matrixAColSize)] * \
                                                  matrixB[IDX(k, j, matrixBColSize)]) % mod;
            }
        }
    }
    return res;
}

Mat fastPow(const Mat matrix, int matrixRowSize, LL n, LL mod) {
    Mat res = (LL *)malloc(sizeof(LL) * matrixRowSize * matrixRowSize);
    Mat curr = (LL *)malloc(sizeof(LL) * matrixRowSize * matrixRowSize);
    memset(res, 0, sizeof(LL) * matrixRowSize * matrixRowSize);
    memcpy(curr, matrix, sizeof(LL) * matrixRowSize * matrixRowSize);

    for (int i = 0; i < matrixRowSize; ++i) {
        res[IDX(i, i, matrixRowSize)] = 1;
    }
    for (int i = n; i != 0; i >>= 1) {
        if (i & 1) {
            Mat nextRes = multiply(curr, matrixRowSize, matrixRowSize, res, matrixRowSize, matrixRowSize, mod);
            free(res);
            res = nextRes;
        }
        Mat nextCurr = multiply(curr, matrixRowSize, matrixRowSize, curr, matrixRowSize, matrixRowSize, mod);
        free(curr);
        curr = nextCurr;
    }
    free(curr);
    return res;
}

int countVowelPermutation(int n){
    LL mod = 1e9 + 7;
    LL factor[25] = { \
                      0, 1, 0, 0, 0, \
                      1, 0, 1, 0, 0, \
                      1, 1, 0, 1, 1, \
                      0, 0, 1, 0, 1, \
                      1, 0, 0, 0, 0  \
                    };
    Mat res = fastPow(factor, 5, n - 1, mod);
    LL ans = 0;
    for (int i = 0; i < 25; ++i) {
        ans = (ans + res[i]) % mod;
    }
    free(res);
    return ans;
}
```

```go [sol2-Golang]
const mod int = 1e9 + 7

type matrix [5][5]int

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

func countVowelPermutation(n int) (ans int) {
    m := matrix{
        {0, 1, 0, 0, 0},
        {1, 0, 1, 0, 0},
        {1, 1, 0, 1, 1},
        {0, 0, 1, 0, 1},
        {1, 0, 0, 0, 0},
    }
    res := m.pow(n - 1)
    for _, row := range res {
        for _, v := range row {
            ans = (ans + v) % mod
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(C^3 \log n)$，其中 $n$ 是给定的参数，$C$ 表示元音字母的数量，在本题中 $C = 5$，每次矩阵相乘的时间复杂度为 $O(C^3)$，最多需要 $\log n$ 次矩阵相乘。

- 空间复杂度：$O(C^2)$，需要保空间来存储矩阵乘法的结果。
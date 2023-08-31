## [808.分汤 中文官方题解](https://leetcode.cn/problems/soup-servings/solutions/100000/fen-tang-by-leetcode-solution-0yxs)

#### 方法一：动态规划

**思路与算法**

首先，由于四种分配操作都是 $25$ 的倍数，因此我们可以将 $n$ 除以 $25$（如果有余数，则补 $1$），并将四种分配操作变为 $(4, 0),(3, 1),(2, 2),(1, 3)$，且每种操作的概率均为 $0.25$。

当 $n$ 较小时，我们可以用动态规划来解决这个问题。设 $\textit{dp}(i, j)$ 表示汤 $A$ 和汤 $B$ 分别剩下 $i$ 和 $j$ 份时所求的概率值，即汤 $A$ 先分配完的概率 $\text{+}$ 汤 $A$ 和汤 $B$ 同时分配完的概率除以 $2$。

状态转移方程为：

$$
\textit{dp}(i, j) = \frac{1}{4} \times (\textit{dp}(i - 4, j) + \textit{dp}(i - 3, j - 1) + \textit{dp}(i - 2, j - 2) + \textit{dp}(i - 1, j - 3))
$$

我们仔细考虑一下边界条件：

+ 当满足 $i > 0,j = 0$，此时无法再分配，而汤 $A$ 还未分配完成，汤 $A$ 永远无法完成分配，此时 $\textit{dp}(i, j) = 0$；

+ 当满足 $i = 0,j = 0$，此时汤 $A$ 和汤 $B$ 同时分配完的概率为 $1.0$，汤 $A$ 先分配完的概率为 $0$，因此 $\textit{dp}(i, j) = 1.0 \times 0.5 = 0.5$；

+ 当满足 $i = 0,j > 0$，此时无法再分配，汤 $A$ 先分配完的概率为 $1.0$，汤 $B$ 永远无法完成分配，因此 $\textit{dp}(i, j) = 1.0$；

因此综上，我们可以得到边界条件如下：

$$
\textit{dp}(i,j) =
\begin{cases}
0, & i > 0, j = 0 \\
0.5, & i = 0, j = 0 \\
1, & i = 0, j > 0 \\
\end{cases}
$$

我们可以看到这个动态规划的时间复杂度是 $O(n^2)$，即使将 $n$ 除以 $25$ 之后，仍然没法在短时间内得到答案，因此我们需要尝试一些别的思路。
我们可以发现，每次分配操作有 $(4, 0),(3, 1),(2, 2),(1, 3)$ 四种，那么在一次分配中，汤 $A$ 平均会被分配的份数期望为 $E(A) = (4 + 3 + 2 + 1) \times 0.25 = 2.5$ ，汤 $B$ 平均会被分配的份数期望为 $E(B) = (0 + 1 + 2 + 3) \times 0.25 = 1.5$。因此在 $n$ 非常大的时候，汤 $A$ 会有很大的概率比 $B$ 先分配完，汤 $A$ 被先取完的概率应该非常接近 $1$。事实上，当我们进行实际计算时发现，当 $n \ge 4475$ 时，所求概率已经大于 $0.99999$ 了（可以通过上面的动态规划方法求出），它和 $1$ 的误差（无论是绝对误差还是相对误差）都小于 $10^{-5}$。实际我们在进行测算时发现：

$$
n = 4475, \quad p \approx 0.999990211307  \\
n = 4476, \quad p \approx 0.999990468596 
$$

因此在 $n \ge 179 \times 25$ 时，我们只需要输出 $1$ 作为答案即可。在其它的情况下，我们使用动态规划计算出答案。

**代码**

```Python [sol1-Python3]
class Solution:
    def soupServings(self, n: int) -> float:
        n = (n + 24) // 25
        if n >= 179:
            return 1.0
        dp = [[0.0] * (n + 1) for _ in range(n + 1)]
        dp[0] = [0.5] + [1.0] * n
        for i in range(1, n + 1):
            for j in range(1, n + 1):
                dp[i][j] = (dp[max(0, i - 4)][j] + dp[max(0, i - 3)][max(0, j - 1)] +
                            dp[max(0, i - 2)][max(0, j - 2)] + dp[max(0, i - 1)][max(0, j - 3)]) / 4
        return dp[n][n]
```

```C++ [sol1-C++]
class Solution {
public:
    double soupServings(int n) {
        n = ceil((double) n / 25);
        if (n >= 179) {
            return 1.0;
        }
        vector<vector<double>> dp(n + 1, vector<double>(n + 1));
        dp[0][0] = 0.5;
        for (int i = 1; i <= n; i++) {
            dp[0][i] = 1.0;
        }
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= n; j++) {
                dp[i][j] = (dp[max(0, i - 4)][j] + dp[max(0, i - 3)][max(0, j - 1)] +
                           dp[max(0, i - 2)][max(0, j - 2)] + dp[max(0, i - 1)][max(0, j - 3)]) / 4.0;
            }
        }
        return dp[n][n];
    }
};
```

```Java [sol1-Java]
class Solution {
    public double soupServings(int n) {
        n = (int) Math.ceil((double) n / 25);
        if (n >= 179) {
            return 1.0;
        }
        double[][] dp = new double[n + 1][n + 1];
        dp[0][0] = 0.5;
        for (int i = 1; i <= n; i++) {
            dp[0][i] = 1.0;
        }
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= n; j++) {
                dp[i][j] = (dp[Math.max(0, i - 4)][j] + dp[Math.max(0, i - 3)][Math.max(0, j - 1)] + dp[Math.max(0, i - 2)][Math.max(0, j - 2)] + dp[Math.max(0, i - 1)][Math.max(0, j - 3)]) / 4.0;
            }
        }
        return dp[n][n];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public double SoupServings(int n) {
        n = (int) Math.Ceiling((double) n / 25);
        if (n >= 179) {
            return 1.0;
        }
        double[][] dp = new double[n + 1][];
        for (int i = 0; i <= n; i++) {
            dp[i] = new double[n + 1];
        }
        dp[0][0] = 0.5;
        for (int i = 1; i <= n; i++) {
            dp[0][i] = 1.0;
        }
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= n; j++) {
                dp[i][j] = (dp[Math.Max(0, i - 4)][j] + dp[Math.Max(0, i - 3)][Math.Max(0, j - 1)] + dp[Math.Max(0, i - 2)][Math.Max(0, j - 2)] + dp[Math.Max(0, i - 1)][Math.Max(0, j - 3)]) / 4.0;
            }
        }
        return dp[n][n];
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

double soupServings(int n) {
     n = n = ceil((double) n / 25);
    if (n >= 179) {
        return 1.0;
    }
    double dp[n + 1][n + 1];
    dp[0][0] = 0.5;
    for (int i = 1; i <= n; i++) {
        dp[0][i] = 1.0;
        dp[i][0] = 0.0;
    }
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= n; j++) {
            dp[i][j] = (dp[MAX(0, i - 4)][j] + dp[MAX(0, i - 3)][MAX(0, j - 1)] + \
                        dp[MAX(0, i - 2)][MAX(0, j - 2)] + dp[MAX(0, i - 1)][MAX(0, j - 3)]) / 4.0;
        }
    }
    return dp[n][n];
}
```

```JavaScript [sol1-JavaScript]
var soupServings = function(n) {
    n = Math.ceil(n / 25);
    if (n >= 179) {
        return 1.0;
    }
    const dp = new Array(n + 1).fill(0).map(() => new Array(n + 1).fill(0));
    dp[0][0] = 0.5;
    for (let i = 1; i <= n; i++) {
        dp[0][i] = 1.0;
    }
    for (let i = 1; i <= n; i++) {
        for (let j = 1; j <= n; j++) {
            dp[i][j] = (dp[Math.max(0, i - 4)][j] + dp[Math.max(0, i - 3)][Math.max(0, j - 1)] + dp[Math.max(0, i - 2)][Math.max(0, j - 2)] + dp[Math.max(0, i - 1)][Math.max(0, j - 3)]) / 4.0;
        }
    }
    return dp[n][n];
};
```

```go [sol1-Golang]
func soupServings(n int) float64 {
    n = (n + 24) / 25
    if n >= 179 {
        return 1
    }
    dp := make([][]float64, n+1)
    for i := range dp {
        dp[i] = make([]float64, n+1)
    }
    dp[0][0] = 0.5
    for i := 1; i <= n; i++ {
        dp[0][i] = 1
    }
    for i := 1; i <= n; i++ {
        for j := 1; j <= n; j++ {
            dp[i][j] = (dp[max(0, i-4)][j] + dp[max(0, i-3)][max(0, j-1)] +
                dp[max(0, i-2)][max(0, j-2)] + dp[max(0, i-1)][max(0, j-3)]) / 4
        }
    }
    return dp[n][n]
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```
   
**复杂度分析**

- 时间复杂度：$O(C^2)$。因为存在常数 $C$，在这里我们可以取 $C = 192$，使得当 $n > C$ 时，所求的概率和 $1$ 的误差在 $10^{-5}$ 以内，我们可以直接返回，需要的时间为 $O(1)$；当 $n \le C$ 时，我们需要的时间复杂度为 $O(n^2)$，因此总的时间复杂度为 $O(C^2)$。

- 空间复杂度：$O(C^2)$。因为存在常数 $C$，在这里我们可以取 $C = 192$，使得当 $n > C$ 时，所求的概率和 $1$ 的误差在 $10^{-5}$ 以内，我们可以直接返回，需要的空间为 $O(1)$；当 $n \le C$ 时，我们需要的空间为 $O(n^2)$，因此总的空间复杂度为 $O(C^2)$。

#### 方法二：记忆化搜索

**思路与算法**

同样动态规划的解题思路我们还可以采用自顶向下的记忆化搜索的方法来实现，与自底向上的动态规划相比记忆化搜索会减少许多无效状态的计算。

**代码**

```Python [sol2-Python3]
class Solution:
    def soupServings(self, n: int) -> float:
        n = (n + 24) // 25
        if n >= 179:
            return 1.0
        @cache
        def dfs(a: int, b: int) -> float:
            if a <= 0 and b <= 0:
                return 0.5
            if a <= 0:
                return 1.0
            if b <= 0:
                return 0.0
            return (dfs(a - 4, b) + dfs(a - 3, b - 1) +
                    dfs(a - 2, b - 2) + dfs(a - 1, b - 3)) / 4
        return dfs(n, n)
```

```C++ [sol2-C++]
class Solution {
public:
    double soupServings(int n) {
        n = ceil((double) n / 25);
        if (n >= 179) {
            return 1.0;
        }
        memo = vector<vector<double>>(n + 1, vector<double>(n + 1));
        return dfs(n, n);
    }

    double dfs(int a, int b) {
        if (a <= 0 && b <= 0) {
            return 0.5;
        } else if (a <= 0) {
            return 1;
        } else if (b <= 0) {
            return 0;
        }
        if (memo[a][b] > 0) {
            return memo[a][b];
        }
        memo[a][b] = 0.25 * (dfs(a - 4, b) + dfs(a - 3, b - 1) + 
                             dfs(a - 2, b - 2) + dfs(a - 1, b - 3));
        return memo[a][b];
    }
private:
    vector<vector<double>> memo;
};
```

```Java [sol2-Java]
class Solution {
    private double[][] memo;

    public double soupServings(int n) {
        n = (int) Math.ceil((double) n / 25);
        if (n >= 179) {
            return 1.0;
        }
        memo = new double[n + 1][n + 1];
        return dfs(n, n);
    }

    public double dfs(int a, int b) {
        if (a <= 0 && b <= 0) {
            return 0.5;
        } else if (a <= 0) {
            return 1;
        } else if (b <= 0) {
            return 0;
        }
        if (memo[a][b] == 0) {
            memo[a][b] = 0.25 * (dfs(a - 4, b) + dfs(a - 3, b - 1) + dfs(a - 2, b - 2) + dfs(a - 1, b - 3));
        }
        return memo[a][b];
    }
}
```

```C# [sol2-C#]
public class Solution {
    private double[][] memo;

    public double SoupServings(int n) {
        n = (int) Math.Ceiling((double) n / 25);
        if (n >= 179) {
            return 1.0;
        }
        memo = new double[n + 1][];
        for (int i = 0; i <= n; i++) {
            memo[i] = new double[n + 1];
        }
        return DFS(n, n);
    }

    public double DFS(int a, int b) {
        if (a <= 0 && b <= 0) {
            return 0.5;
        } else if (a <= 0) {
            return 1;
        } else if (b <= 0) {
            return 0;
        }
        if (memo[a][b] == 0) {
            memo[a][b] = 0.25 * (DFS(a - 4, b) + DFS(a - 3, b - 1) + DFS(a - 2, b - 2) + DFS(a - 1, b - 3));
        }
        return memo[a][b];
    }
}
```

```C [sol2-C]
double dfs(int a, int b, double **memo) {
    if (a <= 0 && b <= 0) {
        return 0.5;
    } else if (a <= 0) {
        return 1;
    } else if (b <= 0) {
        return 0;
    }
    if (memo[a][b] > 0) {
        return memo[a][b];
    }
    memo[a][b] = 0.25 * (dfs(a - 4, b, memo) + dfs(a - 3, b - 1, memo) + \
                         dfs(a - 2, b - 2, memo) + dfs(a - 1, b - 3, memo));
    return memo[a][b];
}

double soupServings(int n){
    n = ceil((double) n / 25);
    if (n >= 179) {
        return 1.0;
    }
    double **memo = (double **)malloc(sizeof(double *) * (n + 1));
    for (int i = 0; i <= n; i++) {
        memo[i] = (double *)malloc(sizeof(double) * (n + 1));
        memset(memo[i], 0, sizeof(double) * (n + 1));
    }
    double ret = dfs(n, n, memo);
    for (int i = 0; i <= n; i++) {
        free(memo[i]);
    }
    free(memo);
    return ret;
}
```

```JavaScript [sol2-JavaScript]
var soupServings = function(n) {
    n = Math.ceil(n / 25);
    if (n >= 179) {
        return 1.0;
    }
    const memo = new Array(n + 1).fill(0).map(() => new Array(n + 1).fill(0));
    const dfs = (a, b) => {
        if (a <= 0 && b <= 0) {
            return 0.5;
        } else if (a <= 0) {
            return 1;
        } else if (b <= 0) {
            return 0;
        }
        if (memo[a][b] === 0) {
            memo[a][b] = 0.25 * (dfs(a - 4, b) + dfs(a - 3, b - 1) + dfs(a - 2, b - 2) + dfs(a - 1, b - 3));
        }
        return memo[a][b];
    };
    return dfs(n, n);
}
```

```go [sol2-Golang]
func soupServings(n int) float64 {
    n = (n + 24) / 25
    if n >= 179 {
        return 1
    }
    dp := make([][]float64, n+1)
    for i := range dp {
        dp[i] = make([]float64, n+1)
    }
    var dfs func(int, int) float64
    dfs = func(a, b int) float64 {
        if a <= 0 && b <= 0 {
            return 0.5
        }
        if a <= 0 {
            return 1
        }
        if b <= 0 {
            return 0
        }
        dv := &dp[a][b]
        if *dv > 0 {
            return *dv
        }
        res := (dfs(a-4, b) + dfs(a-3, b-1) +
            dfs(a-2, b-2) + dfs(a-1, b-3)) / 4
        *dv = res
        return res
    }
    return dfs(n, n)
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```
   
**复杂度分析**

- 时间复杂度：$O(C^2)$。因为存在常数 $C$，在这里我们可以取 $C = 192$，使得当 $n > C$ 时，所求的概率和 $1$ 的误差在 $10^{-5}$ 以内，我们可以直接返回，需要的时间为 $O(1)$；当 $n \le C$ 时，我们需要的时间复杂度为 $O(n^2)$，因此总的时间复杂度为 $O(C^2)$。

- 空间复杂度：$O(C^2)$。因为存在常数 $C$，在这里我们可以取 $C = 192$，使得当 $n > C$ 时，所求的概率和 $1$ 的误差在 $10^{-5}$ 以内，我们可以直接返回，需要的空间为 $O(1)$；当 $n \le C$ 时，我们需要的空间为 $O(n^2)$，因此总的空间复杂度为 $O(C^2)$。
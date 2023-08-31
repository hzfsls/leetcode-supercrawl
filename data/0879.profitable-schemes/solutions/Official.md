## [879.盈利计划 中文官方题解](https://leetcode.cn/problems/profitable-schemes/solutions/100000/ying-li-ji-hua-by-leetcode-solution-3t8o)

#### 方法一：动态规划

本题与经典背包问题非常相似。两者不同点在于经典背包问题只有一种容量限制，而本题却有两种限制：集团员工人数上限 $n$，以及工作产生的利润下限 $\textit{minProfit}$。

通过经典背包问题的练习，我们已知经典背包问题可以使用二维动态规划求解：两个维度分别代表物品和容量的限制标准。对于本题上述的两种限制，我们可以想到使用三维动态规划求解。本题解法的三个维度分别为：当前**可选择**的工作，**已选择**的小组员工人数，以及**目前状态的工作获利下限**。

根据上述分析，我们可以定义一个三维数组 $\textit{dp}$ 作为动态规划的状态，其中 $\textit{dp}[i][j][k]$ 表示在前 $i$ 个工作中选择了 $j$ 个员工，并且满足工作利润至少为 $k$ 的情况下的盈利计划的总数目。假设 $\textit{group}$ 数组长度为 $\textit{len}$，那么不考虑取模运算的情况下，最终答案为：

$$
\sum_{i=0}^{n}\textit{dp}[\textit{len}][i][\textit{minProfit}]
$$

所以我们可以新建一个三维数组 $\textit{dp}[\textit{len} + 1][n + 1][\textit{minProfit} + 1]$，初始化 $\textit{dp}[0][0][0] = 1$。接下来分析状态转移方程，对于每个工作 $i$，我们根据当前工作人数上限 $j$，有**能够开展当前工作**和**无法开展当前工作**两种情况：

- 如果无法开展当前工作 $i$，那么显然：

    $$
    \textit{dp}[i][j][k] = \textit{dp}[i - 1][j][k]
    $$

- 如果能够开展当前工作 $i$，设当前小组人数为 $\textit{group}[i]$，工作获利为 $\textit{profit}[i]$，那么不考虑取模运算的情况下，则有：

    $$
    \textit{dp}[i][j][k] = \textit{dp}[i - 1][j][k] + \textit{dp}[i - 1][j - \textit{group}[i]][\max(0, k - \textit{profit}[i])]
    $$

由于我们定义的第三维是**工作利润至少为 $k$** 而不是 **工作利润恰好为 $k$**，因此上述状态转移方程中右侧的第三维是 $\max(0, k - \textit{profit}[i])$ 而不是 $k - \textit{profit}[i]$。读者可以思考这一步的妙处所在。

根据上述思路，参考代码如下：

```Java [sol11-Java]
class Solution {
    public int profitableSchemes(int n, int minProfit, int[] group, int[] profit) {
        int len = group.length, MOD = (int)1e9 + 7;
        int[][][] dp = new int[len + 1][n + 1][minProfit + 1];
        dp[0][0][0] = 1;
        for (int i = 1; i <= len; i++) {
            int members = group[i - 1], earn = profit[i - 1];
            for (int j = 0; j <= n; j++) {
                for (int k = 0; k <= minProfit; k++) {
                    if (j < members) {
                        dp[i][j][k] = dp[i - 1][j][k];
                    } else {
                        dp[i][j][k] = (dp[i - 1][j][k] + dp[i - 1][j - members][Math.max(0, k - earn)]) % MOD;
                    }
                }
            }
        }
        int sum = 0;
        for (int j = 0; j <= n; j++) {
            sum = (sum + dp[len][j][minProfit]) % MOD;
        }
        return sum;
    }
}
```

```C# [sol11-C#]
public class Solution {
    public int ProfitableSchemes(int n, int minProfit, int[] group, int[] profit) {
        int len = group.Length, MOD = (int)1e9 + 7;
        int[,,] dp = new int[len + 1, n + 1, minProfit + 1];
        dp[0, 0, 0] = 1;
        for (int i = 1; i <= len; i++) {
            int members = group[i - 1], earn = profit[i - 1];
            for (int j = 0; j <= n; j++) {
                for (int k = 0; k <= minProfit; k++) {
                    if (j < members) {
                        dp[i, j, k] = dp[i - 1, j, k];
                    } else {
                        dp[i, j, k] = (dp[i - 1, j, k] + dp[i - 1, j - members, Math.Max(0, k - earn)]) % MOD;
                    }
                }
            }
        }
        int sum = 0;
        for (int j = 0; j <= n; j++) {
            sum = (sum + dp[len, j, minProfit]) % MOD;
        }
        return sum;
    }
}
```

```JavaScript [sol11-JavaScript]
var profitableSchemes = function(n, minProfit, group, profit) {
    const len = group.length, MOD = 1e9 + 7;
    const dp = new Array(len + 1).fill(0).map(() => new Array(n + 1).fill(0).map(() => new Array(minProfit + 1).fill(0)));
    dp[0][0][0] = 1;
    for (let i = 1; i <= len; i++) {
        const members = group[i - 1], earn = profit[i - 1];
        for (let j = 0; j <= n; j++) {
            for (let k = 0; k <= minProfit; k++) {
                if (j < members) {
                    dp[i][j][k] = dp[i - 1][j][k];
                } else {
                    dp[i][j][k] = (dp[i - 1][j][k] + dp[i - 1][j - members][Math.max(0, k - earn)]) % MOD;
                }
            }
        }
    }
    let sum = 0;
    for (let j = 0; j <= n; j++) {
        sum = (sum + dp[len][j][minProfit]) % MOD;
    }
    return sum;
};
```

```Python [sol11-Python3]
class Solution:
    def profitableSchemes(self, n: int, minProfit: int, group: List[int], profit: List[int]) -> int:
        MOD = 10**9 + 7
        
        length = len(group)
        dp = [[[0] * (minProfit + 1) for _ in range(n + 1)] for _ in range(length + 1)]
        dp[0][0][0] = 1
        for i in range(1, length + 1):
            members, earn = group[i - 1], profit[i - 1]
            for j in range(n + 1):
                for k in range(minProfit + 1):
                    if j < members:
                        dp[i][j][k] = dp[i - 1][j][k]
                    else:
                        dp[i][j][k] = (dp[i - 1][j][k] + dp[i - 1][j - members][max(0, k - earn)]) % MOD
        
        total = sum(dp[length][j][minProfit] for j in range(n + 1))
        return total % MOD
```

```C++ [sol11-C++]
class Solution {
public:
    int profitableSchemes(int n, int minProfit, vector<int>& group, vector<int>& profit) {
        int len = group.size(), MOD = (int)1e9 + 7;
        vector<vector<vector<int>>> dp(len + 1, vector<vector<int>>(n + 1, vector<int>(minProfit + 1)));
        dp[0][0][0] = 1;
        for (int i = 1; i <= len; i++) {
            int members = group[i - 1], earn = profit[i - 1];
            for (int j = 0; j <= n; j++) {
                for (int k = 0; k <= minProfit; k++) {
                    if (j < members) {
                        dp[i][j][k] = dp[i - 1][j][k];
                    } else {
                        dp[i][j][k] = (dp[i - 1][j][k] + dp[i - 1][j - members][max(0, k - earn)]) % MOD;
                    }
                }
            }
        }
        int sum = 0;
        for (int j = 0; j <= n; j++) {
            sum = (sum + dp[len][j][minProfit]) % MOD;
        }
        return sum;
    }
};
```

```C [sol11-C]
int profitableSchemes(int n, int minProfit, int* group, int groupSize, int* profit, int profitSize) {
    int len = groupSize, MOD = (int)1e9 + 7;
    int dp[len + 1][n + 1][minProfit + 1];
    memset(dp, 0, sizeof(dp));
    dp[0][0][0] = 1;
    for (int i = 1; i <= len; i++) {
        int members = group[i - 1], earn = profit[i - 1];
        for (int j = 0; j <= n; j++) {
            for (int k = 0; k <= minProfit; k++) {
                if (j < members) {
                    dp[i][j][k] = dp[i - 1][j][k];
                } else {
                    dp[i][j][k] = (dp[i - 1][j][k] + dp[i - 1][j - members][(int)fmax(0, k - earn)]) % MOD;
                }
            }
        }
    }
    int sum = 0;
    for (int j = 0; j <= n; j++) {
        sum = (sum + dp[len][j][minProfit]) % MOD;
    }
    return sum;
}
```

```go [sol11-Golang]
func profitableSchemes(n, minProfit int, group, profit []int) (sum int) {
    const mod int = 1e9 + 7
    ng := len(group)
    dp := make([][][]int, ng+1)
    for i := range dp {
        dp[i] = make([][]int, n+1)
        for j := range dp[i] {
            dp[i][j] = make([]int, minProfit+1)
        }
    }
    dp[0][0][0] = 1
    for i, members := range group {
        earn := profit[i]
        for j := 0; j <= n; j++ {
            for k := 0; k <= minProfit; k++ {
                if j < members {
                    dp[i+1][j][k] = dp[i][j][k]
                } else {
                    dp[i+1][j][k] = (dp[i][j][k] + dp[i][j-members][max(0, k-earn)]) % mod
                }
            }
        }
    }
    for _, d := range dp[ng] {
        sum = (sum + d[minProfit]) % mod
    }
    return
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

可以发现 $\textit{dp}[i][j][k]$ 仅与 $\textit{dp}[i - 1][..][..]$ 有关，所以本题可以用二维动态规划解决。当采用二维动态规划解法时，对于最小工作利润为 $0$ 的情况，无论当前在工作的员工有多少人，我们总能提供一种方案，所以初始化 $\textit{dp}[i][0] = 1$。此外，降维之后 $\textit{dp}$ 数组的遍历顺序应为**逆序**，与背包问题降维解法类似，因为这样才能保证求状态 $\textit{dp}[j][k]$ 时, 用到的 $\textit{dp}[j - \textit{members}][\max(0, k - \textit{earn})]$ **是上一时刻的值**，而正序遍历则会改写该值。参考代码如下：

```Java [sol12-Java]
class Solution {
    public int profitableSchemes(int n, int minProfit, int[] group, int[] profit) {
        int[][] dp = new int[n + 1][minProfit + 1];
        for (int i = 0; i <= n; i++) {
            dp[i][0] = 1;
        }
        int len = group.length, MOD = (int)1e9 + 7;
        for (int i = 1; i <= len; i++) {
            int members = group[i - 1], earn = profit[i - 1];
            for (int j = n; j >= members; j--) {
                for (int k = minProfit; k >= 0; k--) {
                    dp[j][k] = (dp[j][k] + dp[j - members][Math.max(0, k - earn)]) % MOD;
                }
            }
        }
        return dp[n][minProfit];
    }
}
```

```C# [sol12-C#]
public class Solution {
    public int ProfitableSchemes(int n, int minProfit, int[] group, int[] profit) {
        int[,] dp = new int[n + 1, minProfit + 1];
        for (int i = 0; i <= n; i++) {
            dp[i, 0] = 1;
        }
        int len = group.Length, MOD = (int)1e9 + 7;
        for (int i = 1; i <= len; i++) {
            int members = group[i - 1], earn = profit[i - 1];
            for (int j = n; j >= members; j--) {
                for (int k = minProfit; k >= 0; k--) {
                    dp[j, k] = (dp[j, k] + dp[j - members, Math.Max(0, k - earn)]) % MOD;
                }
            }
        }
        return dp[n, minProfit];
    }
}
```

```Python [sol12-Python3]
class Solution:
    def profitableSchemes(self, n: int, minProfit: int, group: List[int], profit: List[int]) -> int:
        MOD = 10**9 + 7
        dp = [[0] * (minProfit + 1) for _ in range(n + 1)]
        for i in range(0, n + 1):
            dp[i][0] = 1
        for earn, members in zip(profit, group):
            for j in range(n, members - 1, -1):
                for k in range(minProfit, -1, -1):
                    dp[j][k] = (dp[j][k] + dp[j - members][max(0, k - earn)]) % MOD;
        return dp[n][minProfit]
```

```JavaScript [sol12-JavaScript]
var profitableSchemes = function(n, minProfit, group, profit) {
    const dp = new Array(n + 1).fill(0).map(() => new Array(minProfit + 1).fill(0));
    for (let i = 0; i <= n; i++) {
        dp[i][0] = 1;
    }
    const len = group.length, MOD = 1e9 + 7;
    for (let i = 1; i <= len; i++) {
        const members = group[i - 1], earn = profit[i - 1];
        for (let j = n; j >= members; j--) {
            for (let k = minProfit; k >= 0; k--) {
                dp[j][k] = (dp[j][k] + dp[j - members][Math.max(0, k - earn)]) % MOD;
            }
        }
    }
    return dp[n][minProfit];
};
```

```C++ [sol12-C++]
class Solution {
public:
    int profitableSchemes(int n, int minProfit, vector<int>& group, vector<int>& profit) {
        vector<vector<int>> dp(n + 1, vector<int>(minProfit + 1));
        for (int i = 0; i <= n; i++) {
            dp[i][0] = 1;
        }
        int len = group.size(), MOD = (int)1e9 + 7;
        for (int i = 1; i <= len; i++) {
            int members = group[i - 1], earn = profit[i - 1];
            for (int j = n; j >= members; j--) {
                for (int k = minProfit; k >= 0; k--) {
                    dp[j][k] = (dp[j][k] + dp[j - members][max(0, k - earn)]) % MOD;
                }
            }
        }
        return dp[n][minProfit];
    }
};
```

```C [sol12-C]
int profitableSchemes(int n, int minProfit, int* group, int groupSize, int* profit, int profitSize) {
    int dp[n + 1][minProfit + 1];
    memset(dp, 0, sizeof(dp));
    for (int i = 0; i <= n; i++) {
        dp[i][0] = 1;
    }
    int len = groupSize, MOD = (int)1e9 + 7;
    for (int i = 1; i <= len; i++) {
        int members = group[i - 1], earn = profit[i - 1];
        for (int j = n; j >= members; j--) {
            for (int k = minProfit; k >= 0; k--) {
                dp[j][k] = (dp[j][k] + dp[j - members][(int)fmax(0, k - earn)]) % MOD;
            }
        }
    }
    return dp[n][minProfit];
}
```

```go [sol12-Golang]
func profitableSchemes(n, minProfit int, group, profit []int) (sum int) {
    const mod int = 1e9 + 7
    dp := make([][]int, n+1)
    for i := range dp {
        dp[i] = make([]int, minProfit+1)
        dp[i][0] = 1
    }
    for i, members := range group {
        earn := profit[i]
        for j := n; j >= members; j-- {
            for k := minProfit; k >= 0; k-- {
                dp[j][k] = (dp[j][k] + dp[j-members][max(0, k-earn)]) % mod
            }
        }
    }
    return dp[n][minProfit]
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

**复杂度分析**

- 时间复杂度：$O(\textit{len} \times n \times \textit{minProfit})$，其中 $\textit{len}$ 为数组 $\textit{group}$ 的长度。
    动态规划需要计算的状态总数是 $O(\textit{len} \times n \times \textit{minProfit})$，每个状态的值需要 $O(1)$ 的时间计算。

- 空间复杂度：$O(n \times \textit{minProfit})$。
    使用空间优化的实现，需要创建 $n + 1$ 行，$\textit{minProfit} + 1$ 列的二维数组 $\textit{dp}$。
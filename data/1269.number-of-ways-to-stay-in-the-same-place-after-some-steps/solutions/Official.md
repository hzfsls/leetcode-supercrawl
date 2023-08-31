## [1269.停在原地的方案数 中文官方题解](https://leetcode.cn/problems/number-of-ways-to-stay-in-the-same-place-after-some-steps/solutions/100000/ting-zai-yuan-di-de-fang-an-shu-by-leetcode-soluti)
#### 方法一：动态规划

对于计算方案数的题目，常用的方法是动态规划。对于这道题，需要计算在 $\textit{steps}$ 步操作之后，指针位于下标 $0$ 的方案数。

用 $\textit{dp}[i][j]$ 表示在 $i$ 步操作之后，指针位于下标 $j$ 的方案数。其中，$i$ 的取值范围是 $0 \le i \le \textit{steps}$，$j$ 的取值范围是 $0 \le j \le \textit{arrLen}-1$。

由于一共执行 $\textit{steps}$ 步操作，因此指针所在下标一定不会超过 $\textit{steps}$，可以将 $j$ 的取值范围进一步缩小到 $0 \le j \le \min(\textit{arrLen}-1, \textit{steps})$。

当没有进行任何操作时，指针一定位于下标 $0$，因此动态规划的边界条件是 $\textit{dp}[0][0]=1$，当 $1 \le j \le \min(\textit{arrLen}-1, \textit{steps})$ 时有 $\textit{dp}[0][j]=0$。

每一步操作中，指针可以向左或向右移动 $1$ 步，或者停在原地。因此，当 $1 \le i \le \textit{steps}$ 时，状态 $\textit{dp}[i][j]$ 可以从 $\textit{dp}[i-1][j-1]$、$\textit{dp}[i-1][j]$ 和 $\textit{dp}[i-1][j+1]$ 这三个状态转移得到。状态转移方程如下：

$$
\textit{dp}[i][j] = \textit{dp}[i-1][j-1]+\textit{dp}[i-1][j]+\textit{dp}[i-1][j+1]
$$

由于指针不能移动到数组范围外，因此对于上述状态转移方程，需要注意下标边界情况。当 $j=0$ 时，$\textit{dp}[i-1][j-1]=0$；当 $j=\min(\textit{arrLen}-1, \textit{steps})$ 时，$\textit{dp}[i-1][j+1]=0$。具体实现时，需要对下标进行判断，避免下标越界。

计算过程中需要对每个状态的值计算模 $10^9+7$ 后的结果。最终得到 $\textit{dp}[\textit{steps}][0]$ 的值即为答案。

```Java [sol11-Java]
class Solution {
    public int numWays(int steps, int arrLen) {
        final int MODULO = 1000000007;
        int maxColumn = Math.min(arrLen - 1, steps);
        int[][] dp = new int[steps + 1][maxColumn + 1];
        dp[0][0] = 1;
        for (int i = 1; i <= steps; i++) {
            for (int j = 0; j <= maxColumn; j++) {
                dp[i][j] = dp[i - 1][j];
                if (j - 1 >= 0) {
                    dp[i][j] = (dp[i][j] + dp[i - 1][j - 1]) % MODULO;
                }
                if (j + 1 <= maxColumn) {
                    dp[i][j] = (dp[i][j] + dp[i - 1][j + 1]) % MODULO;
                }
            }
        }
        return dp[steps][0];
    }
}
```

```C# [sol11-C#]
public class Solution {
    public int NumWays(int steps, int arrLen) {
        const int MODULO = 1000000007;
        int maxColumn = Math.Min(arrLen - 1, steps);
        int[,] dp = new int[steps + 1, maxColumn + 1];
        dp[0, 0] = 1;
        for (int i = 1; i <= steps; i++) {
            for (int j = 0; j <= maxColumn; j++) {
                dp[i, j] = dp[i - 1, j];
                if (j - 1 >= 0) {
                    dp[i, j] = (dp[i, j] + dp[i - 1, j - 1]) % MODULO;
                }
                if (j + 1 <= maxColumn) {
                    dp[i, j] = (dp[i, j] + dp[i - 1, j + 1]) % MODULO;
                }
            }
        }
        return dp[steps, 0];
    }
}
```

```go [sol11-Golang]
func numWays(steps, arrLen int) int {
    const mod = 1e9 + 7
    maxColumn := min(arrLen-1, steps)
    dp := make([][]int, steps+1)
    for i := range dp {
        dp[i] = make([]int, maxColumn+1)
    }
    dp[0][0] = 1
    for i := 1; i <= steps; i++ {
        for j := 0; j <= maxColumn; j++ {
            dp[i][j] = dp[i-1][j]
            if j-1 >= 0 {
                dp[i][j] = (dp[i][j] + dp[i-1][j-1]) % mod
            }
            if j+1 <= maxColumn {
                dp[i][j] = (dp[i][j] + dp[i-1][j+1]) % mod
            }
        }
    }
    return dp[steps][0]
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```C++ [sol11-C++]
class Solution {
public:
    const int MODULO = 1000000007;

    int numWays(int steps, int arrLen) {
        int maxColumn = min(arrLen - 1, steps);
        vector<vector<int>> dp(steps + 1, vector<int>(maxColumn + 1));
        dp[0][0] = 1;
        for (int i = 1; i <= steps; i++) {
            for (int j = 0; j <= maxColumn; j++) {
                dp[i][j] = dp[i - 1][j];
                if (j - 1 >= 0) {
                    dp[i][j] = (dp[i][j] + dp[i - 1][j - 1]) % MODULO;
                }
                if (j + 1 <= maxColumn) {
                    dp[i][j] = (dp[i][j] + dp[i - 1][j + 1]) % MODULO;
                }
            }
        }
        return dp[steps][0];
    }
};
```

```C [sol11-C]
const int MODULO = 1000000007;

int numWays(int steps, int arrLen) {
    int maxColumn = fmin(arrLen - 1, steps);
    int dp[steps + 1][maxColumn + 1];
    memset(dp, 0, sizeof(dp));
    dp[0][0] = 1;
    for (int i = 1; i <= steps; i++) {
        for (int j = 0; j <= maxColumn; j++) {
            dp[i][j] = dp[i - 1][j];
            if (j - 1 >= 0) {
                dp[i][j] = (dp[i][j] + dp[i - 1][j - 1]) % MODULO;
            }
            if (j + 1 <= maxColumn) {
                dp[i][j] = (dp[i][j] + dp[i - 1][j + 1]) % MODULO;
            }
        }
    }
    return dp[steps][0];
}
```

```Python [sol11-Python3]
class Solution:
    def numWays(self, steps: int, arrLen: int) -> int:
        mod = 10**9 + 7
        maxColumn = min(arrLen - 1, steps)

        dp = [[0] * (maxColumn + 1) for _ in range(steps + 1)]
        dp[0][0] = 1

        for i in range(1, steps + 1):
            for j in range(0, maxColumn + 1):
                dp[i][j] = dp[i - 1][j]
                if j - 1 >= 0:
                    dp[i][j] = (dp[i][j] + dp[i - 1][j - 1]) % mod
                if j + 1 <= maxColumn:
                    dp[i][j] = (dp[i][j] + dp[i - 1][j + 1]) % mod
        
        return dp[steps][0]
```

```JavaScript [sol11-JavaScript]
var numWays = function(steps, arrLen) {
    const MODULO = 1000000007;
    let maxColumn = Math.min(arrLen - 1, steps);
    const dp = new Array(steps + 1).fill(0).map(() => new Array(maxColumn + 1).fill(0));
    dp[0][0] = 1;
    for (let i = 1; i <= steps; i++) {
        for (let j = 0; j <= maxColumn; j++) {
            dp[i][j] = dp[i - 1][j];
            if (j - 1 >= 0) {
                dp[i][j] = (dp[i][j] + dp[i - 1][j - 1]) % MODULO;
            }
            if (j + 1 <= maxColumn) {
                dp[i][j] = (dp[i][j] + dp[i - 1][j + 1]) % MODULO;
            }
        }
    }
    return dp[steps][0];
};
```

上述实现的时间复杂度是 $O(\textit{steps} \times \min(\textit{arrLen}, \textit{steps}))$，空间复杂度是 $O(\textit{steps} \times \min(\textit{arrLen}, \textit{steps}))$。

注意到 $\textit{dp}$ 的每一行只和上一行有关，因此可以将空间复杂度降低到 $O(\min(\textit{arrLen}, \textit{steps}))$。

```Java [sol12-Java]
class Solution {
    public int numWays(int steps, int arrLen) {
        final int MODULO = 1000000007;
        int maxColumn = Math.min(arrLen - 1, steps);
        int[] dp = new int[maxColumn + 1];
        dp[0] = 1;
        for (int i = 1; i <= steps; i++) {
            int[] dpNext = new int[maxColumn + 1];
            for (int j = 0; j <= maxColumn; j++) {
                dpNext[j] = dp[j];
                if (j - 1 >= 0) {
                    dpNext[j] = (dpNext[j] + dp[j - 1]) % MODULO;
                }
                if (j + 1 <= maxColumn) {
                    dpNext[j] = (dpNext[j] + dp[j + 1]) % MODULO;
                }
            }
            dp = dpNext;
        }
        return dp[0];
    }
}
```

```C# [sol12-C#]
public class Solution {
    public int NumWays(int steps, int arrLen) {
        const int MODULO = 1000000007;
        int maxColumn = Math.Min(arrLen - 1, steps);
        int[] dp = new int[maxColumn + 1];
        dp[0] = 1;
        for (int i = 1; i <= steps; i++) {
            int[] dpNext = new int[maxColumn + 1];
            for (int j = 0; j <= maxColumn; j++) {
                dpNext[j] = dp[j];
                if (j - 1 >= 0) {
                    dpNext[j] = (dpNext[j] + dp[j - 1]) % MODULO;
                }
                if (j + 1 <= maxColumn) {
                    dpNext[j] = (dpNext[j] + dp[j + 1]) % MODULO;
                }
            }
            dp = dpNext;
        }
        return dp[0];
    }
}
```

```go [sol12-Golang]
func numWays(steps, arrLen int) int {
    const mod = 1e9 + 7
    maxColumn := min(arrLen-1, steps)
    dp := make([]int, maxColumn+1)
    dp[0] = 1
    for i := 1; i <= steps; i++ {
        dpNext := make([]int, maxColumn+1)
        for j := 0; j <= maxColumn; j++ {
            dpNext[j] = dp[j]
            if j-1 >= 0 {
                dpNext[j] = (dpNext[j] + dp[j-1]) % mod
            }
            if j+1 <= maxColumn {
                dpNext[j] = (dpNext[j] + dp[j+1]) % mod
            }
        }
        dp = dpNext
    }
    return dp[0]
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```C++ [sol12-C++]
class Solution {
public:
    const int MODULO = 1000000007;

    int numWays(int steps, int arrLen) {
        int maxColumn = min(arrLen - 1, steps);
        vector<int> dp(maxColumn + 1);
        dp[0] = 1;
        for (int i = 1; i <= steps; i++) {
            vector<int> dpNext(maxColumn + 1);
            for (int j = 0; j <= maxColumn; j++) {
                dpNext[j] = dp[j];
                if (j - 1 >= 0) {
                    dpNext[j] = (dpNext[j] + dp[j - 1]) % MODULO;
                }
                if (j + 1 <= maxColumn) {
                    dpNext[j] = (dpNext[j] + dp[j + 1]) % MODULO;
                }
            }
            dp = dpNext;
        }
        return dp[0];
    }
};
```

```C [sol12-C]
const int MODULO = 1000000007;

int numWays(int steps, int arrLen) {
    int maxColumn = fmin(arrLen - 1, steps);
    int dp[maxColumn + 1];
    memset(dp, 0, sizeof(dp));
    dp[0] = 1;
    for (int i = 1; i <= steps; i++) {
        int dpNext[maxColumn + 1];
        for (int j = 0; j <= maxColumn; j++) {
            dpNext[j] = dp[j];
            if (j - 1 >= 0) {
                dpNext[j] = (dpNext[j] + dp[j - 1]) % MODULO;
            }
            if (j + 1 <= maxColumn) {
                dpNext[j] = (dpNext[j] + dp[j + 1]) % MODULO;
            }
        }
        memcpy(dp, dpNext, sizeof(dp));
    }
    return dp[0];
}
```

```Python [sol12-Python3]
class Solution:
    def numWays(self, steps: int, arrLen: int) -> int:
        mod = 10**9 + 7
        maxColumn = min(arrLen - 1, steps)

        dp = [0] * (maxColumn + 1)
        dp[0] = 1

        for i in range(1, steps + 1):
            dpNext = [0] * (maxColumn + 1)
            for j in range(0, maxColumn + 1):
                dpNext[j] = dp[j]
                if j - 1 >= 0:
                    dpNext[j] = (dpNext[j] + dp[j - 1]) % mod
                if j + 1 <= maxColumn:
                    dpNext[j] = (dpNext[j] + dp[j + 1]) % mod
            dp = dpNext
        
        return dp[0]
```

```JavaScript [sol12-JavaScript]
var numWays = function(steps, arrLen) {
    const MODULO = 1000000007;
    let maxColumn = Math.min(arrLen - 1, steps);
    let dp = new Array(maxColumn + 1).fill(0);
    dp[0] = 1;
    for (let i = 1; i <= steps; i++) {
        const dpNext = new Array(maxColumn + 1).fill(0);
        for (let j = 0; j <= maxColumn; j++) {
            dpNext[j] = dp[j];
            if (j - 1 >= 0) {
                dpNext[j] = (dpNext[j] + dp[j - 1]) % MODULO;
            }
            if (j + 1 <= maxColumn) {
                dpNext[j] = (dpNext[j] + dp[j + 1]) % MODULO;
            }
        }
        dp = dpNext;
    }
    return dp[0];
};
```

**复杂度分析**

- 时间复杂度：$O(\textit{steps} \times \min(\textit{arrLen}, \textit{steps}))$。动态规划需要计算每个状态的值。

- 空间复杂度：$O(\min(\textit{arrLen}, \textit{steps}))$。使用空间优化的做法，可以将空间复杂度降低到 $O(\min(\textit{arrLen}, \textit{steps}))$。
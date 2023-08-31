## [1049.最后一块石头的重量 II 中文官方题解](https://leetcode.cn/problems/last-stone-weight-ii/solutions/100000/zui-hou-yi-kuai-shi-tou-de-zhong-liang-i-95p9)
#### 前言：合法性证明

为了便于讨论，若最终没有石头剩下，则视作最终剩下了一块重量为 $0$ 的石头。

用归纳法可以证明，无论按照何种顺序粉碎石头，最后一块石头的重量总是可以表示成

$$
\sum_{i=0}^{n-1} k_i \times \textit{stones}_i,\ \ k_i\in\{-1,1\}
$$

但不是所有 $k_i$ 的取值都是合法的。例如有四块石头，其重量分别为 $a$，$b$，$c$，$d$，且满足 $a\le b\le c\le d$。由于石头的重量不可能增加，无论怎么操作，我们是不可能得到大小为 $d+c+b-a$ 的石头的，该重量已经超过了 $c$ 以及 $d$。

那么，上述和式的最小非负值所对应的这组 $\{k_i\}$ 是合法的吗？

我们将这组 $\{k_i\}$ 对应的石头划分成两堆，$k_i=1$ 的石头分至一堆，$k_i=-1$ 的石头分至另一堆。由于这是最小非负值所对应的 $\{k_i\}$，**这两堆石头重量之差的绝对值也是所有划分当中最小的**。

记这两堆石头重量之差的绝对值为 $\textit{diff}$。若能找到一种粉碎方案，使得最后一块石头的重量也为 $\textit{diff}$，那就能说明这组 $\{k_i\}$ 是合法的。

我们不断地粉碎石头。每次粉碎时，记重量最大的石头所处的堆为 $A$（若两堆最大重量相同则任选一堆），另一堆为 $B$。从 $A$ 中取出重量最大的石头，$B$ 中任取一石头，若没有完全粉碎，则将新石头重新放入 $A$。这一操作从每堆石头中减去了同样的重量，从而保证重量之差的绝对值在粉碎前后是不变的。

若出现一堆没有石头，而另一堆不止一块石头的情况，记有石头的那一堆为 $A$，另一堆为 $B$。要继续粉碎，则需要从 $A$ 中取出一块石头移入 $B$，然后按规则粉碎。但移入操作让重量之差的绝对值变得更小，与事实（上文加粗文字）矛盾，所以不会出现这种情况。

因此，按照上述流程操作，最后一块石头的重量为 $\textit{diff}$，所以这组 $\{k_i\}$ 对应着一个合法的粉碎结果。

#### 方法一：动态规划

记石头的总重量为 $\textit{sum}$，$k_i=-1$ 的石头的重量之和为 $\textit{neg}$，则其余 $k_i=1$ 的石头的重量之和为 $\textit{sum}-\textit{neg}$。则有

$$
\sum_{i=0}^{n-1} k_i\cdot\textit{stones}_i = (\textit{sum}-\textit{neg})-\textit{neg} = \textit{sum}-2\cdot\textit{neg}
$$

要使最后一块石头的重量尽可能地小，$\textit{neg}$ 需要在不超过 $\lfloor \textit{sum}/2 \rfloor$ 的前提下尽可能地大。因此本问题可以看作是背包容量为 $\lfloor \textit{sum}/2 \rfloor$，物品重量和价值均为 $\textit{stones}_i$ 的 0-1 背包问题。

对于该问题，定义二维布尔数组 $\textit{dp}$，其中 $\textit{dp}[i+1][j]$ 表示前 $i$ 个石头能否凑出重量 $j$。特别地，$\textit{dp}[0][]$ 为不选任何石头的状态，因此除了 $\textit{dp}[0][0]$ 为真，其余 $\textit{dp}[0][j]$ 全为假。

对于第 $i$ 个石头，考虑凑出重量 $j$：

- 若 $j<\textit{stones}[i]$，则不能选第 $i$ 个石头，此时有 $\textit{dp}[i+1][j]=\textit{dp}[i][j]$；
- 若 $j\ge \textit{stones}[i]$，存在选或不选两种决策，不选时有 $\textit{dp}[i+1][j]=\textit{dp}[i][j]$，选时需要考虑能否凑出重量 $j-\textit{stones}[i]$，即 $\textit{dp}[i+1][j]=\textit{dp}[i][j-\textit{stones}[i]]$。若二者均为假则 $\textit{dp}[i+1][j]$ 为假，否则 $\textit{dp}[i+1][j]$ 为真。

因此状态转移方程如下：

$$
\textit{dp}[i+1][j]=
\begin{cases}
\textit{dp}[i][j],& j<\textit{stones}[i] \\
\textit{dp}[i][j] \lor \textit{dp}[i][j-\textit{stones}[i]], & j\ge \textit{stones}[i]
\end{cases}
$$

其中 $\lor$ 表示逻辑或运算。求出 $\textit{dp}[n][]$ 后，所有为真的 $\textit{dp}[n][j]$ 中，最大的 $j$ 即为 $\textit{neg}$ 能取到的最大值。代入 $\textit{sum}-2\cdot\textit{neg}$ 中即得到最后一块石头的最小重量。

```C++ [sol1-C++]
class Solution {
public:
    int lastStoneWeightII(vector<int> &stones) {
        int sum = accumulate(stones.begin(), stones.end(), 0);
        int n = stones.size(), m = sum / 2;
        vector<vector<int>> dp(n + 1, vector<int>(m + 1));
        dp[0][0] = true;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j <= m; ++j) {
                if (j < stones[i]) {
                    dp[i + 1][j] = dp[i][j];
                } else {
                    dp[i + 1][j] = dp[i][j] || dp[i][j - stones[i]];
                }
            }
        }
        for (int j = m;; --j) {
            if (dp[n][j]) {
                return sum - 2 * j;
            }
        }
    }
};
```

```Java [sol1-Java]
class Solution {
    public int lastStoneWeightII(int[] stones) {
        int sum = 0;
        for (int weight : stones) {
            sum += weight;
        }
        int n = stones.length, m = sum / 2;
        boolean[][] dp = new boolean[n + 1][m + 1];
        dp[0][0] = true;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j <= m; ++j) {
                if (j < stones[i]) {
                    dp[i + 1][j] = dp[i][j];
                } else {
                    dp[i + 1][j] = dp[i][j] || dp[i][j - stones[i]];
                }
            }
        }
        for (int j = m;; --j) {
            if (dp[n][j]) {
                return sum - 2 * j;
            }
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int LastStoneWeightII(int[] stones) {
        int sum = 0;
        foreach (int weight in stones) {
            sum += weight;
        }
        int n = stones.Length, m = sum / 2;
        bool[,] dp = new bool[n + 1, m + 1];
        dp[0, 0] = true;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j <= m; ++j) {
                if (j < stones[i]) {
                    dp[i + 1, j] = dp[i, j];
                } else {
                    dp[i + 1, j] = dp[i, j] || dp[i, j - stones[i]];
                }
            }
        }
        for (int j = m;; --j) {
            if (dp[n, j]) {
                return sum - 2 * j;
            }
        }
    }
}
```

```go [sol1-Golang]
func lastStoneWeightII(stones []int) int {
    sum := 0
    for _, v := range stones {
        sum += v
    }
    n, m := len(stones), sum/2
    dp := make([][]bool, n+1)
    for i := range dp {
        dp[i] = make([]bool, m+1)
    }
    dp[0][0] = true
    for i, weight := range stones {
        for j := 0; j <= m; j++ {
            if j < weight {
                dp[i+1][j] = dp[i][j]
            } else {
                dp[i+1][j] = dp[i][j] || dp[i][j-weight]
            }
        }
    }
    for j := m; ; j-- {
        if dp[n][j] {
            return sum - 2*j
        }
    }
}
```

```JavaScript [sol1-JavaScript]
var lastStoneWeightII = function(stones) {
    let sum = 0;
    for (const weight of stones) {
        sum += weight;
    }
    const n = stones.length, m = Math.floor(sum / 2);
    const dp = new Array(n + 1).fill(0).map(() => new Array(m + 1).fill(false));
    dp[0][0] = true;
    for (let i = 0; i < n; ++i) {
        for (let j = 0; j <= m; ++j) {
            if (j < stones[i]) {
                dp[i + 1][j] = dp[i][j];
            } else {
                dp[i + 1][j] = dp[i][j] || dp[i][j - stones[i]];
            }
        }
    }
    for (let j = m;; --j) {
        if (dp[n][j]) {
            return sum - 2 * j;
        }
    }
};
```

```Python [sol1-Python3]
class Solution:
    def lastStoneWeightII(self, stones: List[int]) -> int:
        total = sum(stones)
        n, m = len(stones), total // 2
        dp = [[False] * (m + 1) for _ in range(n + 1)]
        dp[0][0] = True

        for i in range(n):
            for j in range(m + 1):
                if j < stones[i]:
                    dp[i + 1][j] = dp[i][j]
                else:
                    dp[i + 1][j] = dp[i][j] or dp[i][j - stones[i]]
        
        ans = None
        for j in range(m, -1, -1):
            if dp[n][j]:
                ans = total - 2 * j
                break
        
        return ans
```

```C [sol1-C]
int lastStoneWeightII(int* stones, int stonesSize) {
    int sum = 0;
    for (int i = 0; i < stonesSize; i++) {
        sum += stones[i];
    }
    int n = stonesSize, m = sum / 2;
    int dp[n + 1][m + 1];
    memset(dp, 0, sizeof(dp));
    dp[0][0] = true;
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j <= m; ++j) {
            if (j < stones[i]) {
                dp[i + 1][j] = dp[i][j];
            } else {
                dp[i + 1][j] = dp[i][j] || dp[i][j - stones[i]];
            }
        }
    }
    for (int j = m;; --j) {
        if (dp[n][j]) {
            return sum - 2 * j;
        }
    }
}
```

由于 $\textit{dp}[i+1][]$ 的每个元素值的计算只和 $\textit{dp}[i][]$ 的元素值有关，因此可以使用滚动数组的方式，去掉 $\textit{dp}$ 的第一个维度。

对于转移方程 

$$
\textit{dp}[i+1][j]=\textit{dp}[i][j] \lor \textit{dp}[i][j-\textit{stones}[i]]
$$

在去掉第一个维度后，若仍采用正序遍历，在计算 $\textit{dp}[j]$ 时，$\textit{dp}[j-\textit{stones}[i]]$ 的值已经被覆盖，这意味着 $\textit{dp}[j-\textit{stones}[i]]$ 实际对应的是 $\textit{dp}[i+1][j-\textit{stones}[i]]$，即我们计算的是一个错误的转移方程

$$
\textit{dp}[i+1][j]=\textit{dp}[i][j] \lor \textit{dp}[i+1][j-\textit{stones}[i]]
$$

若采用倒序遍历，则可消除该错误，这种方式保证计算 $\textit{dp}[j]$ 时，$\textit{dp}[j-\textit{stones}[i]]$ 的值实际对应的是 $\textit{dp}[i][j-\textit{stones}[i]]$，从而保证转移方程与去掉维度前一致。

```C++ [sol2-C++]
class Solution {
public:
    int lastStoneWeightII(vector<int> &stones) {
        int sum = accumulate(stones.begin(), stones.end(), 0);
        int m = sum / 2;
        vector<int> dp(m + 1);
        dp[0] = true;
        for (int weight : stones) {
            for (int j = m; j >= weight; --j) {
                dp[j] = dp[j] || dp[j - weight];
            }
        }
        for (int j = m;; --j) {
            if (dp[j]) {
                return sum - 2 * j;
            }
        }
    }
};
```

```Java [sol2-Java]
class Solution {
    public int lastStoneWeightII(int[] stones) {
        int sum = 0;
        for (int weight : stones) {
            sum += weight;
        }
        int m = sum / 2;
        boolean[] dp = new boolean[m + 1];
        dp[0] = true;
        for (int weight : stones) {
            for (int j = m; j >= weight; --j) {
                dp[j] = dp[j] || dp[j - weight];
            }
        }
        for (int j = m;; --j) {
            if (dp[j]) {
                return sum - 2 * j;
            }
        }
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int LastStoneWeightII(int[] stones) {
        int sum = 0;
        foreach (int weight in stones) {
            sum += weight;
        }
        int m = sum / 2;
        bool[] dp = new bool[m + 1];
        dp[0] = true;
        foreach (int weight in stones) {
            for (int j = m; j >= weight; --j) {
                dp[j] = dp[j] || dp[j - weight];
            }
        }
        for (int j = m;; --j) {
            if (dp[j]) {
                return sum - 2 * j;
            }
        }
    }
}
```

```go [sol2-Golang]
func lastStoneWeightII(stones []int) int {
    sum := 0
    for _, v := range stones {
        sum += v
    }
    m := sum / 2
    dp := make([]bool, m+1)
    dp[0] = true
    for _, weight := range stones {
        for j := m; j >= weight; j-- {
            dp[j] = dp[j] || dp[j-weight]
        }
    }
    for j := m; ; j-- {
        if dp[j] {
            return sum - 2*j
        }
    }
}
```

```JavaScript [sol2-JavaScript]
var lastStoneWeightII = function(stones) {
    let sum = 0;
    for (const weight of stones) {
        sum += weight;
    }
    const m = Math.floor(sum / 2);
    const dp = new Array(m + 1).fill(false);
    dp[0] = true;
    for (const weight of stones) {
        for (let j = m; j >= weight; --j) {
            dp[j] = dp[j] || dp[j - weight];
        }
    }
    for (let j = m;; --j) {
        if (dp[j]) {
            return sum - 2 * j;
        }
    }
};
```

```Python [sol2-Python3]
class Solution:
    def lastStoneWeightII(self, stones: List[int]) -> int:
        total = sum(stones)
        n, m = len(stones), total // 2
        dp = [False] * (m + 1)
        dp[0] = True

        for weight in stones:
            for j in range(m, weight - 1, -1):
                dp[j] |= dp[j - weight]
        
        ans = None
        for j in range(m, -1, -1):
            if dp[j]:
                ans = total - 2 * j
                break
        
        return ans
```

```C [sol2-C]
int lastStoneWeightII(int* stones, int stonesSize) {
    int sum = 0;
    for (int i = 0; i < stonesSize; i++) {
        sum += stones[i];
    }
    int m = sum / 2;
    int dp[m + 1];
    memset(dp, 0, sizeof(dp));
    dp[0] = true;
    for (int i = 0; i < stonesSize; ++i) {
        for (int j = m; j >= stones[i]; --j) {
            dp[j] = dp[j] || dp[j - stones[i]];
        }
    }
    for (int j = m;; --j) {
        if (dp[j]) {
            return sum - 2 * j;
        }
    }
}
```

**复杂度分析**

- 时间复杂度：$O(n\cdot \textit{sum})$。其中 $n$ 是数组 $\textit{stones}$ 的长度，$\textit{sum}$ 为 $\textit{stones}$ 所有元素之和。

- 空间复杂度：$O(\textit{sum})$。
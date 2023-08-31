## [188.买卖股票的最佳时机 IV 中文官方题解](https://leetcode.cn/problems/best-time-to-buy-and-sell-stock-iv/solutions/100000/mai-mai-gu-piao-de-zui-jia-shi-ji-iv-by-8xtkp)
#### 方法一：动态规划

**思路与算法**

与其余的股票问题类似，我们使用一系列变量存储「买入」的状态，再用一系列变量存储「卖出」的状态，通过动态规划的方法即可解决本题。

我们用 $\textit{buy}[i][j]$ 表示对于数组 $\textit{prices}[0..i]$ 中的价格而言，进行恰好 $j$ 笔交易，并且当前手上持有一支股票，这种情况下的最大利润；用 $\textit{sell}[i][j]$ 表示恰好进行 $j$ 笔交易，并且当前手上不持有股票，这种情况下的最大利润。

那么我们可以对状态转移方程进行推导。对于 $\textit{buy}[i][j]$，我们考虑当前手上持有的股票是否是在第 $i$ 天买入的。如果是第 $i$ 天买入的，那么在第 $i-1$ 天时，我们手上不持有股票，对应状态 $\textit{sell}[i-1][j]$，并且需要扣除 $\textit{prices}[i]$ 的买入花费；如果不是第 $i$ 天买入的，那么在第 $i-1$ 天时，我们手上持有股票，对应状态 $\textit{buy}[i-1][j]$。那么我们可以得到状态转移方程：

$$
\textit{buy}[i][j] = \max \big\{ \textit{buy}[i-1][j], \textit{sell}[i-1][j] - \textit{price}[i] \big\}
$$

同理对于 $\textit{sell}[i][j]$，如果是第 $i$ 天卖出的，那么在第 $i-1$ 天时，我们手上持有股票，对应状态 $\textit{buy}[i-1][j-1]$，并且需要增加 $\textit{prices}[i]$ 的卖出收益；如果不是第 $i$ 天卖出的，那么在第 $i-1$ 天时，我们手上不持有股票，对应状态 $\textit{sell}[i-1][j]$。那么我们可以得到状态转移方程：

$$
\textit{sell}[i][j] = \max \big\{ \textit{sell}[i-1][j], \textit{buy}[i-1][j-1] + \textit{price}[i] \big\}
$$

由于在所有的 $n$ 天结束后，手上不持有股票对应的最大利润一定是严格由于手上持有股票对应的最大利润的，然而完成的交易数并不是越多越好（例如数组 $\textit{prices}$ 单调递减，我们不进行任何交易才是最优的），因此最终的答案即为 $\textit{sell}[n-1][0..k]$ 中的最大值。

**细节**

在上述的状态转移方程中，确定边界条件是非常重要的步骤。我们可以考虑将所有的 $\textit{buy}[0][0..k]$ 以及 $\textit{sell}[0][0..k]$ 设置为边界。

对于 $\textit{buy}[0][0..k]$，由于只有 $\textit{prices}[0]$ 唯一的股价，因此我们不可能进行过任何交易，那么我们可以将所有的 $\textit{buy}[0][1..k]$ 设置为一个非常小的值，表示不合法的状态。而对于 $\textit{buy}[0][0]$，它的值为 $-\textit{prices}[0]$，即「我们在第 $0$ 天以 $\textit{prices}[0]$ 的价格买入股票」是唯一满足手上持有股票的方法。

对于 $\textit{sell}[0][0..k]$，同理我们可以将所有的 $\textit{sell}[0][1..k]$ 设置为一个非常小的值，表示不合法的状态。而对于 $\textit{sell}[0][0]$，它的值为 $0$，即「我们在第 $0$ 天不做任何事」是唯一满足手上不持有股票的方法。

在设置完边界之后，我们就可以使用二重循环，在 $i\in [1,n), j \in [0, k]$ 的范围内进行状态转移。需要注意的是，$\textit{sell}[i][j]$ 的状态转移方程中包含 $\textit{buy}[i-1][j-1]$，在 $j=0$ 时其表示不合法的状态，因此在 $j=0$ 时，我们无需对 $\textit{sell}[i][j]$ 进行转移，让其保持值为 $0$ 即可。

最后需要注意的是，本题中 $k$ 的最大值可以达到 $10^9$，然而这是毫无意义的，因为 $n$ 天最多只能进行 $\lfloor \frac{n}{2} \rfloor$ 笔交易，其中 $\lfloor x \rfloor$ 表示对 $x$ 向下取整。因此我们可以将 $k$ 对 $\lfloor \frac{n}{2} \rfloor$ 取较小值之后再进行动态规划。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maxProfit(int k, vector<int>& prices) {
        if (prices.empty()) {
            return 0;
        }

        int n = prices.size();
        k = min(k, n / 2);
        vector<vector<int>> buy(n, vector<int>(k + 1));
        vector<vector<int>> sell(n, vector<int>(k + 1));

        buy[0][0] = -prices[0];
        sell[0][0] = 0;
        for (int i = 1; i <= k; ++i) {
            buy[0][i] = sell[0][i] = INT_MIN / 2;
        }

        for (int i = 1; i < n; ++i) {
            buy[i][0] = max(buy[i - 1][0], sell[i - 1][0] - prices[i]);
            for (int j = 1; j <= k; ++j) {
                buy[i][j] = max(buy[i - 1][j], sell[i - 1][j] - prices[i]);
                sell[i][j] = max(sell[i - 1][j], buy[i - 1][j - 1] + prices[i]);   
            }
        }

        return *max_element(sell[n - 1].begin(), sell[n - 1].end());
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxProfit(int k, int[] prices) {
        if (prices.length == 0) {
            return 0;
        }

        int n = prices.length;
        k = Math.min(k, n / 2);
        int[][] buy = new int[n][k + 1];
        int[][] sell = new int[n][k + 1];

        buy[0][0] = -prices[0];
        sell[0][0] = 0;
        for (int i = 1; i <= k; ++i) {
            buy[0][i] = sell[0][i] = Integer.MIN_VALUE / 2;
        }

        for (int i = 1; i < n; ++i) {
            buy[i][0] = Math.max(buy[i - 1][0], sell[i - 1][0] - prices[i]);
            for (int j = 1; j <= k; ++j) {
                buy[i][j] = Math.max(buy[i - 1][j], sell[i - 1][j] - prices[i]);
                sell[i][j] = Math.max(sell[i - 1][j], buy[i - 1][j - 1] + prices[i]);   
            }
        }

        return Arrays.stream(sell[n - 1]).max().getAsInt();
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maxProfit(self, k: int, prices: List[int]) -> int:
        if not prices:
            return 0

        n = len(prices)
        k = min(k, n // 2)
        buy = [[0] * (k + 1) for _ in range(n)]
        sell = [[0] * (k + 1) for _ in range(n)]

        buy[0][0], sell[0][0] = -prices[0], 0
        for i in range(1, k + 1):
            buy[0][i] = sell[0][i] = float("-inf")

        for i in range(1, n):
            buy[i][0] = max(buy[i - 1][0], sell[i - 1][0] - prices[i])
            for j in range(1, k + 1):
                buy[i][j] = max(buy[i - 1][j], sell[i - 1][j] - prices[i])
                sell[i][j] = max(sell[i - 1][j], buy[i - 1][j - 1] + prices[i]);  

        return max(sell[n - 1])
```

```go [sol1-Golang]
func maxProfit(k int, prices []int) int {
    n := len(prices)
    if n == 0 {
        return 0
    }

    k = min(k, n/2)
    buy := make([][]int, n)
    sell := make([][]int, n)
    for i := range buy {
        buy[i] = make([]int, k+1)
        sell[i] = make([]int, k+1)
    }
    buy[0][0] = -prices[0]
    for i := 1; i <= k; i++ {
        buy[0][i] = math.MinInt64 / 2
        sell[0][i] = math.MinInt64 / 2
    }

    for i := 1; i < n; i++ {
        buy[i][0] = max(buy[i-1][0], sell[i-1][0]-prices[i])
        for j := 1; j <= k; j++ {
            buy[i][j] = max(buy[i-1][j], sell[i-1][j]-prices[i])
            sell[i][j] = max(sell[i-1][j], buy[i-1][j-1]+prices[i])
        }
    }
    return max(sell[n-1]...)
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}

func max(a ...int) int {
    res := a[0]
    for _, v := range a[1:] {
        if v > res {
            res = v
        }
    }
    return res
}
```

```C [sol1-C]
int maxProfit(int k, int* prices, int pricesSize) {
    int n = pricesSize;
    if (n == 0) {
        return 0;
    }

    k = fmin(k, n / 2);
    int buy[n][k + 1], sell[n][k + 1];
    memset(buy, 0, sizeof(buy));
    memset(sell, 0, sizeof(sell));

    buy[0][0] = -prices[0];
    sell[0][0] = 0;
    for (int i = 1; i <= k; ++i) {
        buy[0][i] = sell[0][i] = INT_MIN / 2;
    }

    for (int i = 1; i < n; ++i) {
        buy[i][0] = fmax(buy[i - 1][0], sell[i - 1][0] - prices[i]);
        for (int j = 1; j <= k; ++j) {
            buy[i][j] = fmax(buy[i - 1][j], sell[i - 1][j] - prices[i]);
            sell[i][j] = fmax(sell[i - 1][j], buy[i - 1][j - 1] + prices[i]);
        }
    }
    int ret = 0;
    for (int i = 0; i <= k; i++) {
        ret = fmax(ret, sell[n - 1][i]);
    }

    return ret;
}
```

```JavaScript [sol1-JavaScript]
var maxProfit = function(k, prices) {
    if (!prices.length) {
        return 0;
    }

    const n = prices.length;
    k = Math.min(k, Math.floor(n / 2));
    const buy = new Array(n).fill(0).map(() => new Array(k + 1).fill(0));
    const sell = new Array(n).fill(0).map(() => new Array(k + 1).fill(0));

    buy[0][0] = -prices[0];
    sell[0][0] = 0;
    for (let i = 1; i <= k; ++i) {
        buy[0][i] = sell[0][i] = -Number.MAX_VALUE;
    }

    for (let i = 1; i < n; ++i) {
        buy[i][0] = Math.max(buy[i - 1][0], sell[i - 1][0] - prices[i]);
        for (let j = 1; j <= k; ++j) {
            buy[i][j] = Math.max(buy[i - 1][j], sell[i - 1][j] - prices[i]);
            sell[i][j] = Math.max(sell[i - 1][j], buy[i - 1][j - 1] + prices[i]);   
        }
    }

    return Math.max(...sell[n - 1]);
};
```

注意到在状态转移方程中，$\textit{buy}[i][j]$ 和 $\textit{sell}[i][j]$ 都从 $\textit{buy}[i-1][..]$ 以及 $\textit{sell}[i-1][..]$ 转移而来，因此我们可以使用一维数组而不是二维数组进行状态转移，即：

$$
\begin{cases}
b[j] \leftarrow \max \big\{ b[j], s[j] - \textit{price}[i] \big\} \\ \\
s[j] \leftarrow \max \big\{ s[j], b[j-1] + \textit{price}[i] \big\}
\end{cases}
$$

这样的状态转移方程会因为状态的覆盖而变得不同。例如如果我们先计算 $\textit{b}$ 而后计算 $s$，那么在计算到 $s[j]$ 时，其状态转移方程中包含的 $b[j-1]$ 这一项的值已经被覆盖了，即本来应当是从二维表示中的 $\textit{buy}[i-1][j-1]$ 转移而来，而现在却变成了 $\textit{buy}[i][j-1]$。

但其仍然是正确的。我们考虑 $\textit{buy}[i][j-1]$ 的状态转移方程：

$$
b[j-1] \leftarrow \textit{buy}[i][j-1] = \max \big\{ \textit{buy}[i-1][j-1], \textit{sell}[i-1][j-1] - \textit{price}[i] \big\}
$$

那么 $s[j]$ 的状态转移方程实际上为：

$$
s[j] \leftarrow \max \big\{ s[j], \textit{buy}[i-1][j-1] + \textit{prices}[i], \textit{sell}[i-1][j-1] \big\}
$$

为什么 $s[j]$ 的状态转移方程中会出现 $\textit{sell}[i-1][j-1]$ 这一项？实际上，我们是把「在第 $i$ 天以 $\textit{prices}[i]$ 的价格买入，并在同一天以 $\textit{prices}[i]$ 的价格卖出」看成了一笔交易，这样对应的收益即为：

$$
\textit{sell}[i-1][j-1] - \textit{prices}[i] + \textit{prices}[i]
$$

也就是 $\textit{sell}[i-1][j-1]$ 本身。这种在同一天之内进行一笔交易的情况，收益为零，它**并不会带来额外的收益**，因此对最终的答案并不会产生影响，状态转移方程在本质上仍然是正确的。

```C++ [sol2-C++]
class Solution {
public:
    int maxProfit(int k, vector<int>& prices) {
        if (prices.empty()) {
            return 0;
        }

        int n = prices.size();
        k = min(k, n / 2);
        vector<int> buy(k + 1);
        vector<int> sell(k + 1);

        buy[0] = -prices[0];
        sell[0] = 0;
        for (int i = 1; i <= k; ++i) {
            buy[i] = sell[i] = INT_MIN / 2;
        }

        for (int i = 1; i < n; ++i) {
            buy[0] = max(buy[0], sell[0] - prices[i]);
            for (int j = 1; j <= k; ++j) {
                buy[j] = max(buy[j], sell[j] - prices[i]);
                sell[j] = max(sell[j], buy[j - 1] + prices[i]);   
            }
        }

        return *max_element(sell.begin(), sell.end());
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maxProfit(int k, int[] prices) {
        if (prices.length == 0) {
            return 0;
        }

        int n = prices.length;
        k = Math.min(k, n / 2);
        int[] buy = new int[k + 1];
        int[] sell = new int[k + 1];

        buy[0] = -prices[0];
        sell[0] = 0;
        for (int i = 1; i <= k; ++i) {
            buy[i] = sell[i] = Integer.MIN_VALUE / 2;
        }

        for (int i = 1; i < n; ++i) {
            buy[0] = Math.max(buy[0], sell[0] - prices[i]);
            for (int j = 1; j <= k; ++j) {
                buy[j] = Math.max(buy[j], sell[j] - prices[i]);
                sell[j] = Math.max(sell[j], buy[j - 1] + prices[i]);   
            }
        }

        return Arrays.stream(sell).max().getAsInt();
    }
}
```

```Python [sol2-Python3]
class Solution:
    def maxProfit(self, k: int, prices: List[int]) -> int:
        if not prices:
            return 0

        n = len(prices)
        k = min(k, n // 2)
        buy = [0] * (k + 1)
        sell = [0] * (k + 1)

        buy[0], sell[0] = -prices[0], 0
        for i in range(1, k + 1):
            buy[i] = sell[i] = float("-inf")

        for i in range(1, n):
            buy[0] = max(buy[0], sell[0] - prices[i])
            for j in range(1, k + 1):
                buy[j] = max(buy[j], sell[j] - prices[i])
                sell[j] = max(sell[j], buy[j - 1] + prices[i]); 

        return max(sell)
```

```go [sol2-Golang]
func maxProfit(k int, prices []int) int {
    n := len(prices)
    if n == 0 {
        return 0
    }

    k = min(k, n/2)
    buy := make([]int, k+1)
    sell := make([]int, k+1)
    buy[0] = -prices[0]
    for i := 1; i <= k; i++ {
        buy[i] = math.MinInt64 / 2
        sell[i] = math.MinInt64 / 2
    }

    for i := 1; i < n; i++ {
        buy[0] = max(buy[0], sell[0]-prices[i])
        for j := 1; j <= k; j++ {
            buy[j] = max(buy[j], sell[j]-prices[i])
            sell[j] = max(sell[j], buy[j-1]+prices[i])
        }
    }
    return max(sell...)
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}

func max(a ...int) int {
    res := a[0]
    for _, v := range a[1:] {
        if v > res {
            res = v
        }
    }
    return res
}
```

```JavaScript [sol2-JavaScript]
var maxProfit = function(k, prices) {
    if (!prices.length) {
        return 0;
    }

    const n = prices.length;
    k = Math.min(k, Math.floor(n / 2));
    const buy = new Array(k + 1).fill(0);
    const sell = new Array(k + 1).fill(0);

    [buy[0], sell[0]] = [-prices[0], 0]
    for (let i = 1; i < k + 1; ++i) {
        buy[i] = sell[i] = -Number.MAX_VALUE;
    }

    for (let i = 1; i < n; ++i) {
        buy[0] = Math.max(buy[0], sell[0] - prices[i]);
        for (let j = 1; j < k + 1; ++j) {
            buy[j] = Math.max(buy[j], sell[j] - prices[i]);
            sell[j] = Math.max(sell[j], buy[j - 1] + prices[i]); 
        }
    }

    return Math.max(...sell)
};
```

```C [sol2-C]
int maxProfit(int k, int* prices, int pricesSize) {
    int n = pricesSize;
    if (n == 0) {
        return 0;
    }

    k = fmin(k, n / 2);
    int buy[k + 1], sell[k + 1];
    memset(buy, 0, sizeof(buy));
    memset(sell, 0, sizeof(sell));

    buy[0] = -prices[0];
    sell[0] = 0;
    for (int i = 1; i <= k; ++i) {
        buy[i] = sell[i] = INT_MIN / 2;
    }

    for (int i = 1; i < n; ++i) {
        buy[0] = fmax(buy[0], sell[0] - prices[i]);
        for (int j = 1; j <= k; ++j) {
            buy[j] = fmax(buy[j], sell[j] - prices[i]);
            sell[j] = fmax(sell[j], buy[j - 1] + prices[i]);
        }
    }
    int ret = 0;
    for (int i = 0; i <= k; i++) {
        ret = fmax(ret, sell[i]);
    }

    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n\min(n, k))$，其中 $n$ 是数组 $\textit{prices}$ 的大小，即我们使用二重循环进行动态规划需要的时间。

- 空间复杂度：$O(n\min(n, k))$ 或 $O(\min(n, k))$，取决于我们使用二维数组还是一维数组进行动态规划。
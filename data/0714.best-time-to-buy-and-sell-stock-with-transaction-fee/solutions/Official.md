#### 前言

本题和 [122. 买卖股票的最佳时机 II](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-ii/) 是非常类似的题，唯一的区别就在于本题有「手续费」而第 122 题没有。

#### 方法一：动态规划

**思路与算法**

考虑到「不能同时参与多笔交易」，因此每天交易结束后只可能存在手里有一支股票或者没有股票的状态。

定义状态 $\textit{dp}[i][0]$ 表示第 $i$ 天交易完后手里没有股票的最大利润，$\textit{dp}[i][1]$ 表示第 $i$ 天交易完后手里持有一支股票的最大利润（$i$ 从 $0$ 开始）。

考虑 $\textit{dp}[i][0]$ 的转移方程，如果这一天交易完后手里没有股票，那么可能的转移状态为前一天已经没有股票，即 $\textit{dp}[i-1][0]$，或者前一天结束的时候手里持有一支股票，即 $\textit{dp}[i-1][1]$，这时候我们要将其卖出，并获得 $\textit{prices}[i]$ 的收益，但需要支付 $\textit{fee}$ 的手续费。因此为了收益最大化，我们列出如下的转移方程：

$$
\textit{dp}[i][0]=\max\{\textit{dp}[i-1][0],\textit{dp}[i-1][1]+\textit{prices}[i]-\textit{fee}\}
$$

再来按照同样的方式考虑 $\textit{dp}[i][1]$ 按状态转移，那么可能的转移状态为前一天已经持有一支股票，即 $\textit{dp}[i-1][1]$，或者前一天结束时还没有股票，即 $\textit{dp}[i-1][0]$，这时候我们要将其买入，并减少 $\textit{prices}[i]$ 的收益。可以列出如下的转移方程：

$$
\textit{dp}[i][1]=\max\{\textit{dp}[i-1][1],\textit{dp}[i-1][0]-\textit{prices}[i]\}
$$

对于初始状态，根据状态定义我们可以知道第 $0$ 天交易结束的时候有 $\textit{dp}[0][0]=0$ 以及 $\textit{dp}[0][1]=-\textit{prices}[0]$。

因此，我们只要从前往后依次计算状态即可。由于全部交易结束后，持有股票的收益一定低于不持有股票的收益，因此这时候 $\textit{dp}[n-1][0]$ 的收益必然是大于 $\textit{dp}[n-1][1]$ 的，最后的答案即为 $\textit{dp}[n-1][0]$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maxProfit(vector<int>& prices, int fee) {
        int n = prices.size();
        vector<vector<int>> dp(n, vector<int>(2));
        dp[0][0] = 0, dp[0][1] = -prices[0];
        for (int i = 1; i < n; ++i) {
            dp[i][0] = max(dp[i - 1][0], dp[i - 1][1] + prices[i] - fee);
            dp[i][1] = max(dp[i - 1][1], dp[i - 1][0] - prices[i]);
        }
        return dp[n - 1][0];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxProfit(int[] prices, int fee) {
        int n = prices.length;
        int[][] dp = new int[n][2];
        dp[0][0] = 0;
        dp[0][1] = -prices[0];
        for (int i = 1; i < n; ++i) {
            dp[i][0] = Math.max(dp[i - 1][0], dp[i - 1][1] + prices[i] - fee);
            dp[i][1] = Math.max(dp[i - 1][1], dp[i - 1][0] - prices[i]);
        }
        return dp[n - 1][0];
    }
}
```

```JavaScript [sol1-JavaScript]
var maxProfit = function(prices, fee) {
    const n = prices.length;
    const dp = new Array(n).fill(0).map(v => new Array(2).fill(0));
    dp[0][0] = 0, dp[0][1] = -prices[0];
    for (let i = 1; i < n; ++i) {
        dp[i][0] = Math.max(dp[i - 1][0], dp[i - 1][1] + prices[i] - fee);
        dp[i][1] = Math.max(dp[i - 1][1], dp[i - 1][0] - prices[i]);
    }
    return dp[n - 1][0];
};
```

```Python [sol1-Python3]
class Solution:
    def maxProfit(self, prices: List[int], fee: int) -> int:
        n = len(prices)
        dp = [[0, -prices[0]]] + [[0, 0] for _ in range(n - 1)]
        for i in range(1, n):
            dp[i][0] = max(dp[i - 1][0], dp[i - 1][1] + prices[i] - fee)
            dp[i][1] = max(dp[i - 1][1], dp[i - 1][0] - prices[i])
        return dp[n - 1][0]
```

```Go [sol1-Golang]
func maxProfit(prices []int, fee int) int {
    n := len(prices)
    dp := make([][2]int, n)
    dp[0][1] = -prices[0]
    for i := 1; i < n; i++ {
        dp[i][0] = max(dp[i-1][0], dp[i-1][1]+prices[i]-fee)
        dp[i][1] = max(dp[i-1][1], dp[i-1][0]-prices[i])
    }
    return dp[n-1][0]
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol1-C]
int maxProfit(int* prices, int pricesSize, int fee){
    int dp[pricesSize][2];
    dp[0][0] = 0, dp[0][1] = -prices[0];
    for (int i = 1; i < pricesSize; ++i) {
        dp[i][0] = fmax(dp[i - 1][0], dp[i - 1][1] + prices[i] - fee);
        dp[i][1] = fmax(dp[i - 1][1], dp[i - 1][0] - prices[i]);
    }
    return dp[pricesSize - 1][0];
}
```

注意到在状态转移方程中，$\textit{dp}[i][0]$ 和 $\textit{dp}[i][1]$ 只会从 $\textit{dp}[i-1][0]$ 和 $\textit{dp}[i-1][1]$ 转移而来，因此我们不必使用数组存储所有的状态，而是使用两个变量 $\textit{sell}$ 以及 $\textit{buy}$ 分别表示 $\textit{dp}[..][0]$ 和 $\textit{dp}[..][1]$ 直接进行状态转移即可。

```C++ [sol2-C++]
class Solution {
public:
    int maxProfit(vector<int>& prices, int fee) {
        int n = prices.size();
        int sell = 0, buy = -prices[0];
        for (int i = 1; i < n; ++i) {
            tie(sell, buy) = pair(max(sell, buy + prices[i] - fee), max(buy, sell - prices[i]));
        }
        return sell;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maxProfit(int[] prices, int fee) {
        int n = prices.length;
        int sell = 0, buy = -prices[0];
        for (int i = 1; i < n; ++i) {
            sell = Math.max(sell, buy + prices[i] - fee);
            buy = Math.max(buy, sell - prices[i]);
        }
        return sell;
    }
}
```

```JavaScript [sol2-JavaScript]
var maxProfit = function(prices, fee) {
    const n = prices.length;
    let [sell, buy] = [0, -prices[0]];
    for (let i = 1; i < n; i++) {
        [sell, buy] = [Math.max(sell, buy + prices[i] - fee), Math.max(buy, sell - prices[i])]
    }
    return sell;
};
```

```Python [sol2-Python3]
class Solution:
    def maxProfit(self, prices: List[int], fee: int) -> int:
        n = len(prices)
        sell, buy = 0, -prices[0]
        for i in range(1, n):
            sell, buy = max(sell, buy + prices[i] - fee), max(buy, sell - prices[i])
        return sell
```

```Go [sol2-Golang]
func maxProfit(prices []int, fee int) int {
    n := len(prices)
    sell, buy := 0, -prices[0]
    for i := 1; i < n; i++ {
        sell = max(sell, buy+prices[i]-fee)
        buy = max(buy, sell-prices[i])
    }
    return sell
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol2-C]
int maxProfit(int* prices, int pricesSize, int fee) {
    int sell = 0, buy = -prices[0];
    for (int i = 1; i < pricesSize; ++i) {
        sell = fmax(sell, buy + prices[i] - fee);
        buy = fmax(buy, sell - prices[i]);
    }
    return sell;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组的长度。一共有 $2n$ 个状态，每次状态转移的时间复杂度为 $O(1)$，因此时间复杂度为 $O(2n)=O(n)$。

- 空间复杂度：$O(n)$ 或 $O(1)$，取决于是否使用数组存储所有的状态。

#### 方法二：贪心算法

**思路与算法**

方法一中，我们将手续费放在卖出时进行计算。如果我们换一个角度考虑，将手续费放在买入时进行计算，那么就可以得到一种基于贪心的方法。

我们用 $\textit{buy}$ 表示**在最大化收益的前提下，如果我们手上拥有一支股票，那么它的最低买入价格是多少**。在初始时，$\textit{buy}$ 的值为 $\textit{prices}[0]$ 加上手续费 $\textit{fee}$。那么当我们遍历到第 $i~(i>0)$ 天时：

- 如果当前的股票价格 $\textit{prices}[i]$ 加上手续费 $\textit{fee}$ 小于 $\textit{buy}$，那么与其使用 $\textit{buy}$ 的价格购买股票，我们不如以 $\textit{prices}[i] + \textit{fee}$ 的价格购买股票，因此我们将 $\textit{buy}$ 更新为 $\textit{prices}[i] + \textit{fee}$；

- 如果当前的股票价格 $\textit{prices}[i]$ 大于 $\textit{buy}$，那么我们直接卖出股票并且获得 $\textit{prices}[i] - \textit{buy}$ 的收益。但实际上，我们此时卖出股票可能并不是全局最优的（例如下一天股票价格继续上升），因此我们可以提供一个反悔操作，看成**当前手上拥有一支买入价格为 $\textit{prices}[i]$ 的股票**，将 $\textit{buy}$ 更新为 $\textit{prices}[i]$。这样一来，如果下一天股票价格继续上升，我们会获得 $\textit{prices}[i+1] - \textit{prices}[i]$ 的收益，加上这一天 $\textit{prices}[i] - \textit{buy}$ 的收益，**恰好就等于在这一天不进行任何操作，而在下一天卖出股票的收益**；

- 对于其余的情况，$\textit{prices}[i]$ 落在区间 $[\textit{buy}-\textit{fee}, \textit{buy}]$ 内，它的价格没有低到我们放弃手上的股票去选择它，也没有高到我们可以通过卖出获得收益，因此我们不进行任何操作。

上面的贪心思想可以浓缩成一句话，即**当我们卖出一支股票时，我们就立即获得了以相同价格并且免除手续费买入一支股票的权利**。在遍历完整个数组 $\textit{prices}$ 之后之后，我们就得到了最大的总收益。

**代码**

```C++ [sol3-C++]
class Solution {
public:
    int maxProfit(vector<int>& prices, int fee) {
        int n = prices.size();
        int buy = prices[0] + fee;
        int profit = 0;
        for (int i = 1; i < n; ++i) {
            if (prices[i] + fee < buy) {
                buy = prices[i] + fee;
            }
            else if (prices[i] > buy) {
                profit += prices[i] - buy;
                buy = prices[i];
            }
        }
        return profit;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int maxProfit(int[] prices, int fee) {
        int n = prices.length;
        int buy = prices[0] + fee;
        int profit = 0;
        for (int i = 1; i < n; ++i) {
            if (prices[i] + fee < buy) {
                buy = prices[i] + fee;
            } else if (prices[i] > buy) {
                profit += prices[i] - buy;
                buy = prices[i];
            }
        }
        return profit;
    }
}
```

```JavaScript [sol3-JavaScript]
var maxProfit = function(prices, fee) {
    const n = prices.length;
    let buy = prices[0] + fee;
    let profit = 0;
    for (let i = 1; i < n; i++) {
        if (prices[i] + fee < buy) {
            buy = prices[i] + fee;
        } else if (prices[i] > buy) {
            profit += prices[i] - buy;
            buy = prices[i];
        }
    }
    return profit;
};
```

```Python [sol3-Python3]
class Solution:
    def maxProfit(self, prices: List[int], fee: int) -> int:
        n = len(prices)
        buy = prices[0] + fee
        profit = 0
        for i in range(1, n):
            if prices[i] + fee < buy:
                buy = prices[i] + fee
            elif prices[i] > buy:
                profit += prices[i] - buy
                buy = prices[i]
        return profit
```

```Go [sol3-Golang]
func maxProfit(prices []int, fee int) int {
    n := len(prices)
    buy := prices[0] + fee;
    profit := 0;
    for i := 1; i < n; i++ {
        if prices[i]+fee < buy {
            buy = prices[i]+fee
        } else if prices[i] > buy {
            profit += prices[i]-buy
            buy = prices[i]
        }
    }
    return profit
}
```

```C [sol3-C]
int maxProfit(int* prices, int pricesSize, int fee) {
    int buy = prices[0] + fee;
    int profit = 0;
    for (int i = 1; i < pricesSize; ++i) {
        if (prices[i] + fee < buy) {
            buy = prices[i] + fee;
        } else if (prices[i] > buy) {
            profit += prices[i] - buy;
            buy = prices[i];
        }
    }
    return profit;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组的长度。

- 空间复杂度：$O(1)$。
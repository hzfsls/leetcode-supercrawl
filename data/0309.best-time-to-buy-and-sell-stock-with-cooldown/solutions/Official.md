## [309.买卖股票的最佳时机含冷冻期 中文官方题解](https://leetcode.cn/problems/best-time-to-buy-and-sell-stock-with-cooldown/solutions/100000/zui-jia-mai-mai-gu-piao-shi-ji-han-leng-dong-qi-4)

#### 前言

对于力扣平台上的股票类型的题目：

- [121. 买卖股票的最佳时机](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock/)

- [122. 买卖股票的最佳时机 II](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-ii/)

- [123. 买卖股票的最佳时机 III](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-iii/)

- [188. 买卖股票的最佳时机 IV](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-iv/)

- （本题）[309. 最佳买卖股票时机含冷冻期](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-with-cooldown/)

- [714. 买卖股票的最佳时机含手续费](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-with-transaction-fee/)

- [剑指 Offer 63. 股票的最大利润](https://leetcode-cn.com/problems/gu-piao-de-zui-da-li-run-lcof/)

一种常用的方法是将「买入」和「卖出」分开进行考虑：「买入」为负收益，而「卖出」为正收益。在初入股市时，你只有「买入」的权利，只能获得负收益。而当你「买入」之后，你就有了「卖出」的权利，可以获得正收益。显然，我们需要尽可能地降低负收益而提高正收益，因此我们的目标总是将收益值最大化。因此，我们可以使用动态规划的方法，维护在股市中每一天结束后可以获得的「累计最大收益」，并以此进行状态转移，得到最终的答案。

#### 方法一：动态规划

**思路与算法**

我们用 $f[i]$ 表示**第 $i$ 天结束之后**的「累计最大收益」。根据题目描述，由于我们最多只能同时买入（持有）一支股票，并且卖出股票后有冷冻期的限制，因此我们会有三种不同的状态：

- 我们目前持有一支股票，对应的「累计最大收益」记为 $f[i][0]$；

- 我们目前不持有任何股票，并且处于冷冻期中，对应的「累计最大收益」记为 $f[i][1]$；

- 我们目前不持有任何股票，并且不处于冷冻期中，对应的「累计最大收益」记为 $f[i][2]$。

> **这里的「处于冷冻期」指的是在第 $i$ 天结束之后的状态。也就是说：如果第 $i$ 天结束之后处于冷冻期，那么第 $i+1$ 天无法买入股票。**

如何进行状态转移呢？在第 $i$ 天时，我们可以在不违反规则的前提下进行「买入」或者「卖出」操作，此时第 $i$ 天的状态会从第 $i-1$ 天的状态转移而来；我们也可以不进行任何操作，此时第 $i$ 天的状态就等同于第 $i-1$ 天的状态。那么我们分别对这三种状态进行分析：

- 对于 $f[i][0]$，我们目前持有的这一支股票可以是在第 $i-1$ 天就已经持有的，对应的状态为 $f[i-1][0]$；或者是第 $i$ 天买入的，那么第 $i-1$ 天就不能持有股票并且不处于冷冻期中，对应的状态为 $f[i-1][2]$ 加上买入股票的负收益 ${\it prices}[i]$。因此状态转移方程为：

    $$
    f[i][0] = \max(f[i-1][0], f[i-1][2] - {\it prices}[i])
    $$

- 对于 $f[i][1]$，我们在第 $i$ 天结束之后处于冷冻期的原因是在当天卖出了股票，那么说明在第 $i-1$ 天时我们必须持有一支股票，对应的状态为 $f[i-1][0]$ 加上卖出股票的正收益 ${\it prices}[i]$。因此状态转移方程为：

    $$
    f[i][1] = f[i-1][0] + {\it prices}[i]
    $$

- 对于 $f[i][2]$，我们在第 $i$ 天结束之后不持有任何股票并且不处于冷冻期，说明当天没有进行任何操作，即第 $i-1$ 天时不持有任何股票：如果处于冷冻期，对应的状态为 $f[i-1][1]$；如果不处于冷冻期，对应的状态为 $f[i-1][2]$。因此状态转移方程为：

    $$
    f[i][2] = \max(f[i-1][1], f[i-1][2])
    $$

这样我们就得到了所有的状态转移方程。如果一共有 $n$ 天，那么最终的答案即为：

$$
\max(f[n-1][0], f[n-1][1], f[n-1][2])
$$

注意到如果在最后一天（第 $n-1$ 天）结束之后，手上仍然持有股票，那么显然是没有任何意义的。因此更加精确地，最终的答案实际上是 $f[n-1][1]$ 和 $f[n-1][2]$ 中的较大值，即：

$$
\max(f[n-1][1], f[n-1][2])
$$

**细节**

我们可以将第 $0$ 天的情况作为动态规划中的边界条件：

$$
\begin{cases}
f[0][0] &= -{\it prices}[0] \\
f[0][1] &= 0 \\
f[0][2] &= 0
\end{cases}
$$

在第 $0$ 天时，如果持有股票，那么只能是在第 $0$ 天买入的，对应负收益 $-{\it prices}[0]$；如果不持有股票，那么收益为零。注意到第 $0$ 天实际上是不存在处于冷冻期的情况的，但我们仍然可以将对应的状态 $f[0][1]$ 置为零，这其中的原因留给读者进行思考。

这样我们就可以从第 $1$ 天开始，根据上面的状态转移方程进行进行动态规划，直到计算出第 $n-1$ 天的结果。

```C++ [sol1-C++]
class Solution {
public:
    int maxProfit(vector<int>& prices) {
        if (prices.empty()) {
            return 0;
        }

        int n = prices.size();
        // f[i][0]: 手上持有股票的最大收益
        // f[i][1]: 手上不持有股票，并且处于冷冻期中的累计最大收益
        // f[i][2]: 手上不持有股票，并且不在冷冻期中的累计最大收益
        vector<vector<int>> f(n, vector<int>(3));
        f[0][0] = -prices[0];
        for (int i = 1; i < n; ++i) {
            f[i][0] = max(f[i - 1][0], f[i - 1][2] - prices[i]);
            f[i][1] = f[i - 1][0] + prices[i];
            f[i][2] = max(f[i - 1][1], f[i - 1][2]);
        }
        return max(f[n - 1][1], f[n - 1][2]);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxProfit(int[] prices) {
        if (prices.length == 0) {
            return 0;
        }

        int n = prices.length;
        // f[i][0]: 手上持有股票的最大收益
        // f[i][1]: 手上不持有股票，并且处于冷冻期中的累计最大收益
        // f[i][2]: 手上不持有股票，并且不在冷冻期中的累计最大收益
        int[][] f = new int[n][3];
        f[0][0] = -prices[0];
        for (int i = 1; i < n; ++i) {
            f[i][0] = Math.max(f[i - 1][0], f[i - 1][2] - prices[i]);
            f[i][1] = f[i - 1][0] + prices[i];
            f[i][2] = Math.max(f[i - 1][1], f[i - 1][2]);
        }
        return Math.max(f[n - 1][1], f[n - 1][2]);
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        if not prices:
            return 0
        
        n = len(prices)
        # f[i][0]: 手上持有股票的最大收益
        # f[i][1]: 手上不持有股票，并且处于冷冻期中的累计最大收益
        # f[i][2]: 手上不持有股票，并且不在冷冻期中的累计最大收益
        f = [[-prices[0], 0, 0]] + [[0] * 3 for _ in range(n - 1)]
        for i in range(1, n):
            f[i][0] = max(f[i - 1][0], f[i - 1][2] - prices[i])
            f[i][1] = f[i - 1][0] + prices[i]
            f[i][2] = max(f[i - 1][1], f[i - 1][2])
        
        return max(f[n - 1][1], f[n - 1][2])
```

```C [sol1-C]
int maxProfit(int* prices, int pricesSize) {
    if (pricesSize == 0) {
        return 0;
    }

    // f[i][0]: 手上持有股票的最大收益
    // f[i][1]: 手上不持有股票，并且处于冷冻期中的累计最大收益
    // f[i][2]: 手上不持有股票，并且不在冷冻期中的累计最大收益
    int f[pricesSize][3];
    f[0][0] = -prices[0];
    f[0][1] = f[0][2] = 0;
    for (int i = 1; i < pricesSize; ++i) {
        f[i][0] = fmax(f[i - 1][0], f[i - 1][2] - prices[i]);
        f[i][1] = f[i - 1][0] + prices[i];
        f[i][2] = fmax(f[i - 1][1], f[i - 1][2]);
    }
    return fmax(f[pricesSize - 1][1], f[pricesSize - 1][2]);
}
```

```golang [sol1-Golang]
func maxProfit(prices []int) int {
    if len(prices) == 0 {
        return 0
    }
    n := len(prices)
    // f[i][0]: 手上持有股票的最大收益
    // f[i][1]: 手上不持有股票，并且处于冷冻期中的累计最大收益
    // f[i][2]: 手上不持有股票，并且不在冷冻期中的累计最大收益
    f := make([][3]int, n)
    f[0][0] = -prices[0]
    for i := 1; i < n; i++ {
        f[i][0] = max(f[i-1][0], f[i-1][2] - prices[i])
        f[i][1] = f[i-1][0] + prices[i]
        f[i][2] = max(f[i-1][1], f[i-1][2]) 
    }
    return max(f[n-1][1], f[n-1][2])
}

func max(x, y int) int {
    if x > y {
        return x
    }
    return y
}
```

**空间优化**

注意到上面的状态转移方程中，$f[i][..]$ 只与 $f[i-1][..]$ 有关，而与 $f[i-2][..]$ 及之前的所有状态都无关，因此我们不必存储这些无关的状态。也就是说，我们只需要将 $f[i-1][0]$，$f[i-1][1]$，$f[i-1][2]$ 存放在三个变量中，通过它们计算出 $f[i][0]$，$f[i][1]$，$f[i][2]$ 并存回对应的变量，以便于第 $i+1$ 天的状态转移即可。 

```C++ [sol2-C++]
class Solution {
public:
    int maxProfit(vector<int>& prices) {
        if (prices.empty()) {
            return 0;
        }

        int n = prices.size();
        int f0 = -prices[0];
        int f1 = 0;
        int f2 = 0;
        for (int i = 1; i < n; ++i) {
            int newf0 = max(f0, f2 - prices[i]);
            int newf1 = f0 + prices[i];
            int newf2 = max(f1, f2);
            f0 = newf0;
            f1 = newf1;
            f2 = newf2;
        }

        return max(f1, f2);
    }
};
```

```C++ [sol2-C++11]
class Solution {
public:
    int maxProfit(vector<int>& prices) {
        if (prices.empty()) {
            return 0;
        }

        int n = prices.size();
        int f0 = -prices[0];
        int f1 = 0;
        int f2 = 0;
        for (int i = 1; i < n; ++i) {
            tie(f0, f1, f2) = make_tuple(max(f0, f2 - prices[i]), f0 + prices[i], max(f1, f2));
        }

        return max(f1, f2);
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maxProfit(int[] prices) {
        if (prices.length == 0) {
            return 0;
        }

        int n = prices.length;
        int f0 = -prices[0];
        int f1 = 0;
        int f2 = 0;
        for (int i = 1; i < n; ++i) {
            int newf0 = Math.max(f0, f2 - prices[i]);
            int newf1 = f0 + prices[i];
            int newf2 = Math.max(f1, f2);
            f0 = newf0;
            f1 = newf1;
            f2 = newf2;
        }

        return Math.max(f1, f2);
    }
}
```

```Python [sol2-Python3]
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        if not prices:
            return 0
        
        n = len(prices)
        f0, f1, f2 = -prices[0], 0, 0
        for i in range(1, n):
            newf0 = max(f0, f2 - prices[i])
            newf1 = f0 + prices[i]
            newf2 = max(f1, f2)
            f0, f1, f2 = newf0, newf1, newf2
        
        return max(f1, f2)
```

```C [sol2-C]
int maxProfit(int* prices, int pricesSize) {
    if (pricesSize == 0) {
        return 0;
    }

    int f0 = -prices[0];
    int f1 = 0;
    int f2 = 0;
    for (int i = 1; i < pricesSize; ++i) {
        int newf0 = fmax(f0, f2 - prices[i]);
        int newf1 = f0 + prices[i];
        int newf2 = fmax(f1, f2);
        f0 = newf0;
        f1 = newf1;
        f2 = newf2;
    }

    return fmax(f1, f2);
}
```

```golang [sol2-Golang]
func maxProfit(prices []int) int {
    if len(prices) == 0 {
        return 0
    }
    n := len(prices)
    f0, f1, f2 := -prices[0], 0, 0
    for i := 1; i < n; i++ {
        newf0 := max(f0, f2 - prices[i])
        newf1 := f0 + prices[i]
        newf2 := max(f1, f2)
        f0, f1, f2 = newf0, newf1, newf2
    }
    return max(f1, f2)
}

func max(x, y int) int {
    if x > y {
        return x
    }
    return y
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 ${\it prices}$ 的长度。

- 空间复杂度：$O(n)$。我们需要 $3n$ 的空间存储动态规划中的所有状态，对应的空间复杂度为 $O(n)$。如果使用空间优化，空间复杂度可以优化至 $O(1)$。
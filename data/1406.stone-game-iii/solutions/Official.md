## [1406.石子游戏 III 中文官方题解](https://leetcode.cn/problems/stone-game-iii/solutions/100000/shi-zi-you-xi-iii-by-leetcode-solution)

#### 方法一：动态规划

对于这种两个玩家、分先后手、博弈类型的题目，我们一般可以使用动态规划来解决。

由于玩家只能拿走前面的石子，因此我们考虑使用状态 $f[i]$ 表示还剩下第 $i, i+1, \cdots, n-1$ 堆石子时，**当前玩家**（也就是当前准备拿石子的那一名玩家）的某一个状态。这个「某一个状态」具体是什么状态，我们暂且不表，这里带着大家一步一步来分析这个状态。

根据题目描述，当前玩家有三种策略可以选择，即取走前 $1$、$2$ 或 $3$ 堆石子，那么留给 **下一位玩家（也就是下一个准备拿石子的那一名玩家）** 的状态为 $f[i+1]$、$f[i+2]$ 或 $f[i+3]$。设想一下，假如你是当前玩家，你希望 $f[i]$ 表示什么，才可以帮助你选择自己的 **最优策略** 呢？

一个聪明的读者会说：**我希望 $f[i]$ 表示还剩下第 $i, i+1, \cdots, n-1$ 堆石子时，当前玩家最多能从剩下的石子中拿到的石子数目（这个「剩下」的意义是，如果 $i, i+1,\cdots n-1$ 堆石子的总数是 $t$，Alice 拿走了 $x$，Bob 就拿走了 $t - x$，也就是我们只讨论 $i, i+1,\cdots n-1$ 堆石子，而不讨论对 $0, 1, \cdots, i - 1$ 堆石子 Alice 和 Bob 作出了怎样的决策）**。这样以来：

- 如果当前玩家选择了一堆石子，那么留给下一位玩家的状态为 $f[i+1]$，表示他可以最多拿到 $f[i+1]$ 数量的石子。

    - 咦？我们之前的定义中，$f[i+1]$ 是表示当前玩家最多能拿到的石子数目，为什么这里变成了下一位玩家呢？仔细想想，「当前玩家」和「下一位玩家」的概念其实是相对的。在「当前玩家」拿完石子后，「下一位玩家」就成了此时的「当前玩家」）。

    由于下一位玩家可以拿 $f[i+1]$ 数量的石子，如果我们用 $\textit{sum}(l, r)$ 表示第 $l, l+1, \cdots, r$ 堆石子的的数量之和，那么当前玩家就可以拿到 $\textit{sum}(i+1,n-1)-f[i+1]$ 数量的石子。加上当前玩家选择了一堆石子，它一共可以拿到 $\textit{sum}(i,i)+\textit{sum}(i+1,n-1)-f[i+1]$ 数量的石子。可以发现，它可以化简为 $\textit{sum}(i,n-1)-f[i+1]$；

- 同理，如果当前玩家选择了两堆石子，那么留给下一位玩家的状态为 $f[i+2]$，当前玩家一共可以拿到 $\textit{sum}(i,n-1)-f[i+2]$ 数量的石子；

- 同理，如果当前玩家选择了三堆石子，那么留给下一位玩家的状态为 $f[i+3]$，当前玩家一共可以拿到 $\textit{sum}(i,n-1)-f[i+3]$ 数量的石子。

这样以来，当前玩家只要选择上面三种情况中能拿到最多数量的石子的方案，就是他的最优策略。

因此，我们就可以用动态规划来解决这个问题了。我们首先处理出表示石子数量的数组 $\textit{values}$ 的后缀和，方便我们快速地求出 $\textit{sum}(l,r)$。随后，我们就可以倒序地进行动态规划（因为在计算 $f[i]$ 的值的时候，需要已经求出 $f[i+1]$，$f[i+2]$ 和 $f[i+3]$ 的值），状态转移方程为：

$$
\begin{aligned}
f[i] &= \max( \textit{sum}(i,n-1) - f[j]) \\
&= \textit{sum}(i,n-1) - \min(f[j]) \quad , j \in [i+1,i+3]
\end{aligned}
$$

最后的 $f[0]$ 就表示 Alice 最多可以获得的石子数量。我们根据 $f[0]$ 与 $\textit{sum}(0,n-1)$ 的关系，就可以得到最终的获胜者。

```C++ [sol1-C++]
class Solution {
public:
    string stoneGameIII(vector<int>& stoneValue) {
        int n = stoneValue.size();
        
        vector<int> suffix_sum(n);
        suffix_sum[n - 1] = stoneValue[n - 1];
        for (int i = n - 2; i >= 0; --i) {
            suffix_sum[i] = suffix_sum[i + 1] + stoneValue[i];
        }

        vector<int> f(n + 1);
        // 边界情况，当没有石子时，分数为 0
        // 为了代码的可读性，显式声明
        f[n] = 0;
        for (int i = n - 1; i >= 0; --i) {
            int bestj = f[i + 1];
            for (int j = i + 2; j <= i + 3 && j <= n; ++j) {
                bestj = min(bestj, f[j]);
            }
            f[i] = suffix_sum[i] - bestj;
        }
        
        int total = accumulate(stoneValue.begin(), stoneValue.end(), 0);
        if (f[0] * 2 == total) {
            return "Tie";
        }
        else {
            return f[0] * 2 > total ? "Alice" : "Bob";
        }
    }
};
```

```C++ [sol1-C++17]
class Solution {
public:
    string stoneGameIII(vector<int>& stoneValue) {
        int n = stoneValue.size();
        
        vector<int> suffix_sum(n);
        suffix_sum[n - 1] = stoneValue[n - 1];
        for (int i = n - 2; i >= 0; --i) {
            suffix_sum[i] = suffix_sum[i + 1] + stoneValue[i];
        }

        vector<int> f(n + 1);
        // 边界情况，当没有石子时，分数为 0
        // 为了代码的可读性，显式声明
        f[n] = 0;
        for (int i = n - 1; i >= 0; --i) {
            int bestj = f[i + 1];
            for (int j = i + 2; j <= i + 3 && j <= n; ++j) {
                bestj = min(bestj, f[j]);
            }
            f[i] = suffix_sum[i] - bestj;
        }
        
        if (int total = accumulate(stoneValue.begin(), stoneValue.end(), 0); f[0] * 2 == total) {
            return "Tie";
        }
        else {
            return f[0] * 2 > total ? "Alice" : "Bob";
        }
    }
};
```

```Python [sol1-Python3]
class Solution:
    def stoneGameIII(self, stoneValue: List[int]) -> str:
        n = len(stoneValue)

        suffix_sum = [0] * (n - 1) + [stoneValue[-1]]
        for i in range(n - 2, -1, -1):
            suffix_sum[i] = suffix_sum[i + 1] + stoneValue[i]
        
        # 边界情况，当没有石子时，分数为 0
        # 为了代码的可读性，显式声明
        f = [0] * n + [0]
        for i in range(n - 1, -1, -1):
            f[i] = suffix_sum[i] - min(f[i+1:i+4])
        
        total = sum(stoneValue)
        if f[0] * 2 == total:
            return "Tie"
        else:
            return "Alice" if f[0] * 2 > total else "Bob"
```

```Java [sol1-Java]
class Solution {
    public String stoneGameIII(int[] stoneValue) {
        int n = stoneValue.length;
        int[] suffixSum = new int[n];
        suffixSum[n - 1] = stoneValue[n - 1];
        for (int i = n - 2; i >= 0; --i) {
            suffixSum[i] = suffixSum[i + 1] + stoneValue[i];
        }
        int[] f = new int[n + 1];
        // 边界情况，当没有石子时，分数为 0
        // 为了代码的可读性，显式声明
        f[n] = 0;
        for (int i = n - 1; i >= 0; --i) {
            int bestj = f[i + 1];
            for (int j = i + 2; j <= i + 3 && j <= n; ++j) {
                bestj = Math.min(bestj, f[j]);
            }
            f[i] = suffixSum[i] - bestj;
        }
        int total = 0;
        for (int value : stoneValue) {
            total += value;
        }
        if (f[0] * 2 == total) {
            return "Tie";
        } else {
            return f[0] * 2 > total ? "Alice" : "Bob";
        }
    }
}
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是数组 $\textit{values}$ 的长度。

- 空间复杂度：$O(N)$。

#### 方法二：另一种状态的设计思路

一个更聪明的读者会说：**我希望 $f[i]$ 表示还剩下第 $i, i+1, \cdots, n-1$ 堆石子时，当前玩家比下一位玩家最多能多拿到的石子数目（注意此时依旧是在剩下的石子中定义的）**。这样以来：

- 如果当前玩家选择了一堆石子，那么留给下一位玩家的状态为 $f[i+1]$，表示下一位玩家最多最多可以比当前玩家多拿到 $f[i+1]$ 数量的石子。那么当前玩家可以比下一位玩家多拿到 $\textit{value}[i] - f[i+1]$ 数量的石子；

- 同理，如果当前玩家选择了两堆石子，那么留给下一位玩家的状态为 $f[i+2]$，当前玩家可以比下一位玩家多拿到 $\textit{value}[i] + \textit{value}[i+1] - f[i+2]$ 数量的石子；

- 同理，如果当前玩家选择了三堆石子，那么留给下一位玩家的状态为 $f[i+3]$，当前玩家可以比下一位玩家多拿到 $\textit{value}[i] + \textit{value}[i+1] + \textit{value}[i+2] - f[i+3]$ 数量的石子；

这样以来，当前玩家只要选择上面三种情况中能比下一位玩家多拿到最多数量的石子的方案，就是他的最优策略。

因此，我们就可以写出使用另一种动态规划的状态转移方程：

$$
\begin{aligned}
f[i] &= \max( \textit{sum}(i,j-1) - f[j]) \quad , j \in [i+1,i+3]
\end{aligned}
$$

最后的 $f[0]$ 就表示 Alice 最多可以比 Bob 多获得的石子数量。我们根据 $f[0]$ 与 $0$ 的关系，就可以得到最终的获胜者。

**注解**

方法二的状态转移方程与方法一实际上是等价的，因为 **A 希望尽可能多地拿到石子** 和 **A 希望进行多地比 B 拿到的石子多** 这两者是等价的。

```C++ [sol2-C++]
class Solution {
public:
    string stoneGameIII(vector<int>& stoneValue) {
        int n = stoneValue.size();
        
        vector<int> f(n + 1, INT_MIN);
        // 边界情况，当没有石子时，分数为 0
        f[n] = 0;
        for (int i = n - 1; i >= 0; --i) {
            int pre = 0;
            for (int j = i + 1; j <= i + 3 && j <= n; ++j) {
                pre += stoneValue[j - 1];
                f[i] = max(f[i], pre - f[j]);
            }
        }
        
        if (f[0] == 0) {
            return "Tie";
        }
        else {
            return f[0] > 0 ? "Alice" : "Bob";
        }
    }
};
```

```Python [sol2-Python3]
class Solution:
    def stoneGameIII(self, stoneValue: List[int]) -> str:
        n = len(stoneValue)

        # 边界情况，当没有石子时，分数为 0
        f = [-10**9] * n + [0]
        for i in range(n - 1, -1, -1):
            pre = 0
            for j in range(i + 1, min(i + 3, n) + 1):
                pre += stoneValue[j - 1]
                f[i] = max(f[i], pre - f[j])
        
        if f[0] == 0:
            return "Tie"
        else:
            return "Alice" if f[0] > 0 else "Bob"
```

```Java [sol2-Java]
class Solution {
    public String stoneGameIII(int[] stoneValue) {
        int n = stoneValue.length;
        int[] f = new int[n + 1];
        Arrays.fill(f, Integer.MIN_VALUE);
        // 边界情况，当没有石子时，分数为 0
        f[n] = 0;
        for (int i = n - 1; i >= 0; --i) {
            int pre = 0;
            for (int j = i + 1; j <= i + 3 && j <= n; ++j) {
                pre += stoneValue[j - 1];
                f[i] = Math.max(f[i], pre - f[j]);
            }
        }
        if (f[0] == 0) {
            return "Tie";
        } else {
            return f[0] > 0 ? "Alice" : "Bob";
        }
    }
}
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是数组 $\textit{values}$ 的长度。

- 空间复杂度：$O(N)$。
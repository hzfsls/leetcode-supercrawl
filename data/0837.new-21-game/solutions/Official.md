## [837.新 21 点 中文官方题解](https://leetcode.cn/problems/new-21-game/solutions/100000/xin-21dian-by-leetcode-solution)
### 📺视频题解  
![837. 新21点 4.mp4](8e029a47-ffea-47d0-a750-7c0c208ac6cb)

### 📖文字题解

#### 方法一：动态规划

爱丽丝获胜的概率只和下一轮开始前的得分有关，因此根据得分计算概率。

令 $\textit{dp}[x]$ 表示从得分为 $x$ 的情况开始游戏并且获胜的概率，目标是求 $\textit{dp}[0]$ 的值。

根据规则，当分数达到或超过 $k$ 时游戏结束，游戏结束时，如果分数不超过 $n$ 则获胜，如果分数超过 $n$ 则失败。因此当 $k \le x \le \min(n, k+\textit{maxPts}-1)$ 时有 $\textit{dp}[x]=1$，当 $x>\min(n, k+\textit{maxPts}-1)$ 时有 $\textit{dp}[x]=0$。

> 为什么分界线是 $\min(n, k+\textit{maxPts}-1)$？首先，只有在分数不超过 $n$ 时才算获胜；其次，可以达到的最大分数为 $k+\textit{maxPts}-1$，即在最后一次抽取数字之前的分数为 $k-1$，并且抽到了 $\textit{maxPts}$。

当 $0 \le x < k$ 时，如何计算 $\textit{dp}[x]$ 的值？注意到每次在范围 $[1, \textit{maxPts}]$ 内随机抽取一个整数，且每个整数被抽取到的概率相等，因此可以得到如下状态转移方程：

$$
\textit{dp}[x]=\frac{\sum_{i=1}^\textit{maxPts} \textit{dp}[x+i]}{\textit{maxPts}}
$$

根据状态转移方程，可以实现如下简单的动态规划：

```Java [sol1-Java]
class Solution {
    public double new21Game(int n, int k, int maxPts) {
        if (k == 0) {
            return 1.0;
        }
        double[] dp = new double[k + maxPts];
        for (int i = k; i <= n && i < k + maxPts; i++) {
            dp[i] = 1.0;
        }
        for (int i = k - 1; i >= 0; i--) {
            for (int j = 1; j <= maxPts; j++) {
                dp[i] += dp[i + j] / maxPts;
            }
        }
        return dp[0];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public double New21Game(int n, int k, int maxPts) {
        if (k == 0) {
            return 1.0;
        }
        double[] dp = new double[k + maxPts];
        for (int i = k; i <= n && i < k + maxPts; i++) {
            dp[i] = 1.0;
        }
        for (int i = k - 1; i >= 0; i--) {
            for (int j = 1; j <= maxPts; j++) {
                dp[i] += dp[i + j] / maxPts;
            }
        }
        return dp[0];
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    double new21Game(int n, int k, int maxPts) {
        if (k == 0) {
            return 1.0;
        }
        vector<double> dp(k + maxPts);
        for (int i = k; i <= n && i < k + maxPts; i++) {
            dp[i] = 1.0;
        }
        for (int i = k - 1; i >= 0; i--) {
            for (int j = 1; j <= maxPts; j++) {
                dp[i] += dp[i + j] / maxPts;
            }
        }
        return dp[0];
    }
};
```

```Python [sol1-Python3]
class Solution:
    def new21Game(self, n: int, k: int, maxPts: int) -> float:
        if k == 0:
            return 1.0
        dp = [0.0] * (k + maxPts)
        for i in range(k, min(n, k + maxPts - 1) + 1):
            dp[i] = 1.0
        for i in range(k - 1, -1, -1):
            for j in range(1, maxPts + 1):
                dp[i] += dp[i + j] / maxPts
        return dp[0]
```

```golang [sol1-Golang]
func new21Game(n int, k int, maxPts int) float64 {
    if k == 0 {
        return 1.0
    }
    dp := make([]float64, k + maxPts)
    for i := k; i <= n && i < k + maxPts; i++ {
        dp[i] = 1.0
    }
    for i := k - 1; i >= 0; i-- {
        for j := 1; j <= maxPts; j++ {
            dp[i] += dp[i + j] / float64(maxPts)
        }
    }
    return dp[0]
}
```

上述解法的时间复杂度是 $O(n+k \times \textit{maxPts})$，会超出时间限制，因此需要优化。

考虑对 $\textit{dp}$ 的相邻项计算差分，有如下结果：

$$
\textit{dp}[x] - \textit{dp}[x+1]=\frac{\textit{dp}[x+1] - \textit{dp}[x+\textit{maxPts}+1]}{\textit{maxPts}}
$$

其中 $0 \le x<k-1$。

因此可以得到新的状态转移方程：

$$
\textit{dp}[x]=\textit{dp}[x+1]-\frac{\textit{dp}[x+\textit{maxPts}+1]-\textit{dp}[x+1]}{\textit{maxPts}}
$$

其中 $0 \le x<k-1$。

注意到上述状态转移方程中 $x$ 的取值范围，当 $x=k-1$ 时不适用。因此对于 $\textit{dp}[k-1]$ 的值，需要通过

$$
\textit{dp}[k-1]=\frac{\sum_{i=0}^{\textit{maxPts}-1} \textit{dp}[k+i]}{\textit{maxPts}}
$$

计算得到。注意到只有当 $k \le x \le \min(n, k+\textit{maxPts}-1)$ 时才有 $\textit{dp}[x]=1$，因此

$$
\textit{dp}[k-1]=\frac{\min(n, k+\textit{maxPts}-1) - k + 1}{\textit{maxPts}} = \frac{\min(n-k+1,\textit{maxPts})}{\textit{maxPts}}
$$

可在 $O(1)$ 时间内计算得到 $\textit{dp}[k-1]$ 的值。

对于 $\textit{dp}[k-2]$ 到 $\textit{dp}[0]$ 的值，则可通过新的状态转移方程得到。

```Java [sol2-Java]
class Solution {
    public double new21Game(int n, int k, int maxPts) {
        if (k == 0) {
            return 1.0;
        }
        double[] dp = new double[k + maxPts];
        for (int i = k; i <= n && i < k + maxPts; i++) {
            dp[i] = 1.0;
        }
        dp[k - 1] = 1.0 * Math.min(n - k + 1, maxPts) / maxPts;
        for (int i = k - 2; i >= 0; i--) {
            dp[i] = dp[i + 1] - (dp[i + maxPts + 1] - dp[i + 1]) / maxPts;
        }
        return dp[0];
    }
}
```

```C# [sol2-C#]
public class Solution {
    public double New21Game(int n, int k, int maxPts) {
        if (k == 0) {
            return 1.0;
        }
        double[] dp = new double[k + maxPts];
        for (int i = k; i <= n && i < k + maxPts; i++) {
            dp[i] = 1.0;
        }
        dp[k - 1] = 1.0 * Math.Min(n - k + 1, maxPts) / maxPts;
        for (int i = k - 2; i >= 0; i--) {
            dp[i] = dp[i + 1] - (dp[i + maxPts + 1] - dp[i + 1]) / maxPts;
        }
        return dp[0];
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    double new21Game(int n, int k, int maxPts) {
        if (k == 0) {
            return 1.0;
        }
        vector<double> dp(k + maxPts);
        for (int i = k; i <= n && i < k + maxPts; i++) {
            dp[i] = 1.0;
        }
        dp[k - 1] = 1.0 * min(n - k + 1, maxPts) / maxPts;
        for (int i = k - 2; i >= 0; i--) {
            dp[i] = dp[i + 1] - (dp[i + maxPts + 1] - dp[i + 1]) / maxPts;
        }
        return dp[0];
    }
};
```

```Python [sol2-Python3]
class Solution:
    def new21Game(self, n: int, k: int, maxPts: int) -> float:
        if k == 0:
            return 1.0
        dp = [0.0] * (k + maxPts)
        for i in range(k, min(n, k + maxPts - 1) + 1):
            dp[i] = 1.0
        dp[k - 1] = float(min(n - k + 1, maxPts)) / maxPts
        for i in range(k - 2, -1, -1):
            dp[i] = dp[i + 1] - (dp[i + maxPts + 1] - dp[i + 1]) / maxPts
        return dp[0]
```

```golang [sol2-Golang]
func new21Game(n int, k int, maxPts int) float64 {
    if k == 0 {
        return 1.0
    }
    dp := make([]float64, k + maxPts)
    for i := k; i <= n && i < k + maxPts; i++ {
        dp[i] = 1.0
    }

    dp[k - 1] = 1.0 * float64(min(n - k + 1, maxPts)) / float64(maxPts)
    for i := k - 2; i >= 0; i-- {
        dp[i] = dp[i + 1] - (dp[i + maxPts + 1] - dp[i + 1]) / float64(maxPts) 
    }
    return dp[0]
}

func min(x, y int) int {
    if x < y {
        return x
    }
    return y
}
```

**复杂度分析**

* 时间复杂度：$O(\min(n, k+\textit{maxPts}))$。即需要计算的 $\textit{dp}$ 值的数量 $\min(n, k+\textit{maxPts}-1)$。

* 空间复杂度：$O(k+\textit{maxPts})$。创建了一个长度为 $k+\textit{maxPts}$ 的数组 $\textit{dp}$。
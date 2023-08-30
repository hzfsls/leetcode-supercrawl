#### 方法一：动态规划

对于正整数 $n$，当 $n \ge 2$ 时，可以拆分成至少两个正整数的和。令 $x$ 是拆分出的第一个正整数，则剩下的部分是 $n-x$，$n-x$ 可以不继续拆分，或者继续拆分成至少两个正整数的和。由于每个正整数对应的最大乘积取决于比它小的正整数对应的最大乘积，因此可以使用动态规划求解。

创建数组 $\textit{dp}$，其中 $\textit{dp}[i]$ 表示将正整数 $i$ 拆分成至少两个正整数的和之后，这些正整数的最大乘积。特别地，$0$ 不是正整数，$1$ 是最小的正整数，$0$ 和 $1$ 都不能拆分，因此 $\textit{dp}[0]=\textit{dp}[1]=0$。

当 $i \ge 2$ 时，假设对正整数 $i$ 拆分出的第一个正整数是 $j$（$1 \le j < i$），则有以下两种方案：

- 将 $i$ 拆分成 $j$ 和 $i-j$ 的和，且 $i-j$ 不再拆分成多个正整数，此时的乘积是 $j \times (i-j)$；

- 将 $i$ 拆分成 $j$ 和 $i-j$ 的和，且 $i-j$ 继续拆分成多个正整数，此时的乘积是 $j \times \textit{dp}[i-j]$。

因此，当 $j$ 固定时，有 $\textit{dp}[i]=\max(j \times (i-j), j \times \textit{dp}[i-j])$。由于 $j$ 的取值范围是 $1$ 到 $i-1$，需要遍历所有的 $j$ 得到 $\textit{dp}[i]$ 的最大值，因此可以得到状态转移方程如下：

$$
\textit{dp}[i]=\mathop{\max}\limits_{1 \le j < i}\{\max(j \times (i-j), j \times \textit{dp}[i-j])\}
$$

最终得到 $\textit{dp}[n]$ 的值即为将正整数 $n$ 拆分成至少两个正整数的和之后，这些正整数的最大乘积。

```Java [sol1-Java]
class Solution {
    public int integerBreak(int n) {
        int[] dp = new int[n + 1];
        for (int i = 2; i <= n; i++) {
            int curMax = 0;
            for (int j = 1; j < i; j++) {
                curMax = Math.max(curMax, Math.max(j * (i - j), j * dp[i - j]));
            }
            dp[i] = curMax;
        }
        return dp[n];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int IntegerBreak(int n) {
        int[] dp = new int[n + 1];
        for (int i = 2; i <= n; i++) {
            int curMax = 0;
            for (int j = 1; j < i; j++) {
                curMax = Math.Max(curMax, Math.Max(j * (i - j), j * dp[i - j]));
            }
            dp[i] = curMax;
        }
        return dp[n];
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int integerBreak(int n) {
        vector <int> dp(n + 1);
        for (int i = 2; i <= n; i++) {
            int curMax = 0;
            for (int j = 1; j < i; j++) {
                curMax = max(curMax, max(j * (i - j), j * dp[i - j]));
            }
            dp[i] = curMax;
        }
        return dp[n];
    }
};
```

```Python [sol1-Python3]
class Solution:
    def integerBreak(self, n: int) -> int:
        dp = [0] * (n + 1)
        for i in range(2, n + 1):
            for j in range(i):
                dp[i] = max(dp[i], j * (i - j), j * dp[i - j])
        return dp[n]
```

```go [sol1-Golang]
func integerBreak(n int) int {
    dp := make([]int, n + 1)
    for i := 2; i <= n; i++ {
        curMax := 0
        for j := 1; j < i; j++ {
            curMax = max(curMax, max(j * (i - j), j * dp[i - j]))
        }
        dp[i] = curMax
    }
    return dp[n]
}

func max(x, y int) int {
    if x > y {
        return x
    }
    return y
}
```

```C [sol1-C]
int integerBreak(int n) {
    int dp[n + 1];
    memset(dp, 0, sizeof(dp));
    for (int i = 2; i <= n; i++) {
        int curMax = 0;
        for (int j = 1; j < i; j++) {
            curMax = fmax(curMax, fmax(j * (i - j), j * dp[i - j]));
        }
        dp[i] = curMax;
    }
    return dp[n];
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是给定的正整数。对于从 $2$ 到 $n$ 的每一个整数都要计算对应的 $\textit{dp}$ 值，计算一个整数对应的 $\textit{dp}$ 值需要 $O(n)$ 的时间复杂度，因此总时间复杂度是 $O(n^2)$。

- 空间复杂度：$O(n)$，其中 $n$ 是给定的正整数。创建一个数组 $\textit{dp}$，其长度为 $n+1$。

#### 方法二：优化的动态规划

方法一中定义的状态转移方程如下：

$$
\textit{dp}[i]=\mathop{\max}\limits_{1 \le j < i}\{\max(j \times (i-j), j \times \textit{dp}[i-j])\}
$$

使用上述状态转移方程，计算 $\textit{dp}[i]$ 时，$j$ 的值遍历了从 $1$ 到 $i-1$ 的所有值，因此总时间复杂度是 $O(n^2)$。是否可以降低时间复杂度？

上述状态转移方程包含两项，当 $j$ 固定时，$\textit{dp}[i]$ 的值由 $j \times (i-j)$ 和 $j \times \textit{dp}[i-j]$ 中的较大值决定，因此需要对两项分别考虑。

首先考虑 $j \times \textit{dp}[i-j]$ 这一项。

注意到 $\textit{dp}$ 的定义，$\textit{dp}[i]$ 表示将正整数 $i$ 拆分成至少两个正整数的和之后，这些正整数的最大乘积，因此对于任意 $1 \le j < i$，有 $\textit{dp}[i] \ge j \times \textit{dp}[i-j]$。

当 $j$ 是奇数时，有 $j=\dfrac{j-1}{2}+\dfrac{j+1}{2}$，因此 $\textit{dp}[i] \geq \dfrac{j-1}{2} \times \textit{dp}[i - \dfrac{j-1}{2}] \ge \dfrac{j-1}{2} \times \dfrac{j+1}{2} \times \textit{dp}[i-j]$。

当 $j$ 是偶数时，有 $j=\dfrac{j}{2}+\dfrac{j}{2}$，因此 $\textit{dp}[i] \ge \dfrac{j}{2} \times \textit{dp}[i - \dfrac{j}{2}] \ge \dfrac{j}{2} \times \dfrac{j}{2} \times \textit{dp}[i-j]$。

如果 $j \ge 4$ 且 $j$ 是奇数，则 $\dfrac{j-1}{2} \times \dfrac{j+1}{2}>j$ 恒成立。如果 $j \ge 4$ 且 $j$ 是偶数，则 $\dfrac{j}{2} \times \dfrac{j}{2} \ge j$ 恒成立，当且仅当 $j=4$ 时等号成立。

由此可知，如果 $j \ge 4$，则 $\textit{dp}[j] \ge j$，当且仅当 $j=4$ 时等号成立，即当 $j \ge 4$ 时一定能将 $j$ 拆成至少两个正整数的和，这些正整数的乘积大于或等于 $j$。

同时也可以得到，如果 $j \ge 4$，则 $\textit{dp}[i] \ge j \times \textit{dp}[i-j]$，只有当 $j=4$ 时等号可能成立。又由于

$$
\textit{dp}[i] \ge 2 \times \textit{dp}[i-2] \ge 2 \times (2 \times \textit{dp}[i-4]) = 4 \times \textit{dp}[i-4]
$$

因此取 $j=2$ 计算得到的 $\textit{dp}[i]$ 一定不会小于取 $j=4$ 计算得到的 $\textit{dp}[i]$。根据上述分析，$j \ge 4$ 的情况都是不需要考虑的。

那么 $j=1$ 是否需要考虑？答案是不需要。如果取 $j=1$，则有 $\textit{dp}[i] \ge 1 \times \textit{dp}[i-1]=\textit{dp}[i-1]$。当 $i \ge 3$ 时，$\textit{dp}[i-1]$ 是将正整数 $i-1$ 拆分成至少两个正整数的和之后，这些正整数的最大乘积，在拆分成的正整数中，任选一个数字加 $1$，则拆分成的正整数的和变成 $i$，且乘积一定大于 $\textit{dp}[i-1]$，因此必有 $\textit{dp}[i]>\textit{dp}[i-1]$，即当 $j=1$ 时不可能得到最大的 $\textit{dp}[i]$ 的值。

根据上述分析可知，计算 $\textit{dp}[i]$ 的值只需要考虑 $j=2$ 和 $j=3$ 的情况，不需要遍历从 $1$ 到 $i-1$ 的所有值。

其次考虑 $j \times (i-j)$ 这一项。

根据上述推导可知，如果 $j \ge 4$，则 $\textit{dp}[j] \ge j$，当且仅当 $j=4$ 时等号成立。因此在 $i-j \ge 4$ 的情况下，有 $\textit{dp}[i-j] \ge i-j$，$\textit{dp}[i] \ge j \times \textit{dp}[i-j] \ge j \times (i-j)$，此时计算 $\textit{dp}[i]$ 的值不需要考虑 $j \times (i-j)$ 的值。

如果 $i-j<4$，在计算 $\textit{dp}[i]$ 的值的时候就需要考虑 $j \times (i-j)$ 的值。在考虑 $j \times \textit{dp}[i-j]$ 时，根据上述分析，只需要考虑 $j=2$ 和 $j=3$ 的情况。在考虑 $j \times (i-j)$ 时，需要考虑 $j$ 的哪些值？

如果 $j=1$，则 $1 \times (i-1)=i-1$，当 $i=2$ 或 $i=3$ 时有 $\textit{dp}[i]=i-1$，当 $i \ge 4$ 时有 $\textit{dp}[i] \ge i>i-1$，显然当 $i \ge 4$ 时取 $j=1$ 不可能得到最大乘积，因此 $j=1$ 时是不需要考虑的。

如果 $j \ge 4$，$\textit{dp}[i]$ 是否可能等于 $j \times (i-j)$？当 $i$ 固定时，要使得 $j \times (i-j)$ 的值最大，$j$ 的值应该取 $j=i/2$，这里的 $/$ 表示整数除法。当 $j \ge 4$ 时，若要满足 $j=i/2$，则 $i \ge 8$，此时 $i-j \ge 4$，利用上述结论，$\textit{dp}[i-j] \ge i-j$，因此 $j \times \textit{dp}[i-j] \ge j \times (i-j)$。由此可见，当 $j \ge 4$ 时，计算 $\textit{dp}[i]$ 只需要考虑 $j \times \textit{dp}[i-j]$，不需要考虑 $j \times (i-j)$。

又由于在使用 $j \times \textit{dp}[i-j]$ 计算 $\textit{dp}[i]$ 时，$j=2$ 和 $j=3$ 的情况一定优于 $j \ge 4$ 的情况，因此无论是考虑 $j \times \textit{dp}[i-j]$ 还是考虑 $j \times (i-j)$，都只需要考虑 $j=2$ 和 $j=3$ 的情况。

由此可以对方法一的动态规划进行优化。

边界情况是 $n=2$，此时唯一的拆分方案是 $2=1+1$，最大乘积是 $1 \times 1=1$。

当 $i \ge 3$ 时，状态转移方程如下：

$$
\textit{dp}[i]=\max(2 \times (i-2), 2 \times \textit{dp}[i-2], 3 \times (i-3), 3 \times \textit{dp}[i-3])
$$

```Java [sol2-Java]
class Solution {
    public int integerBreak(int n) {
        if (n <= 3) {
            return n - 1;
        }
        int[] dp = new int[n + 1];
        dp[2] = 1;
        for (int i = 3; i <= n; i++) {
            dp[i] = Math.max(Math.max(2 * (i - 2), 2 * dp[i - 2]), Math.max(3 * (i - 3), 3 * dp[i - 3]));
        }
        return dp[n];
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int IntegerBreak(int n) {
        if (n <= 3) {
            return n - 1;
        }
        int[] dp = new int[n + 1];
        dp[2] = 1;
        for (int i = 3; i <= n; i++) {
            dp[i] = Math.Max(Math.Max(2 * (i - 2), 2 * dp[i - 2]), Math.Max(3 * (i - 3), 3 * dp[i - 3]));
        }
        return dp[n];
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int integerBreak(int n) {
        if (n <= 3) {
            return n - 1;
        }
        vector <int> dp(n + 1);
        dp[2] = 1;
        for (int i = 3; i <= n; i++) {
            dp[i] = max(max(2 * (i - 2), 2 * dp[i - 2]), max(3 * (i - 3), 3 * dp[i - 3]));
        }
        return dp[n];
    }
};
```

```Python [sol2-Python3]
class Solution:
    def integerBreak(self, n: int) -> int:
        if n <= 3:
            return n - 1
        
        dp = [0] * (n + 1)
        dp[2] = 1
        for i in range(3, n + 1):
            dp[i] = max(2 * (i - 2), 2 * dp[i - 2], 3 * (i - 3), 3 * dp[i - 3])
        
        return dp[n]
```

```go [sol2-Golang]
func integerBreak(n int) int {
    if n <= 3 {
        return n - 1
    }
    dp := make([]int, n + 1)
    dp[2] = 1
    for i := 3; i <= n; i++ {
        dp[i] = max(max(2 * (i - 2), 2 * dp[i - 2]), max(3 * (i - 3), 3 * dp[i - 3]))
    }
    return dp[n]
}

func max(x, y int) int {
    if x > y {
        return x
    }
    return y
}
```

```C [sol2-C]
int integerBreak(int n) {
    if (n <= 3) {
        return n - 1;
    }
    int dp[n + 1];
    memset(dp, 0, sizeof(dp));
    dp[2] = 1;
    for (int i = 3; i <= n; i++) {
        dp[i] = fmax(fmax(2 * (i - 2), 2 * dp[i - 2]), fmax(3 * (i - 3), 3 * dp[i - 3]));
    }
    return dp[n];
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是给定的正整数。和方法一相比，计算每个整数对应的 $\textit{dp}$ 的值的时间复杂度降到 $O(1)$，因此总时间复杂度降到 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是给定的正整数。创建一个数组 $\textit{dp}$，其长度为 $n+1$。

#### 方法三：数学

方法二中利用了数学知识降低时间复杂度。正整数 $4$ 可以拆分成 $2+2$，乘积不变（$4=2 \times 2$）。对于大于 $4$ 的正整数，总是存在一种拆分的方案，使得拆分成的两个正整数的乘积大于拆分前的正整数（例如，$5=2+3$，$2 \times 3=6>5$）。那么，能否利用数学知识在方法二的基础上进一步降低时间复杂度，找到最优的拆分方案呢？

下面给出两种直接得出最优拆分方案的证明方法。

**函数极值证明法**

显然，如果将给定的正整数拆分成尽可能多的某个特定的正整数，则这些正整数的乘积最大。

定义函数 $f(x)$ 表示将给定的正整数 $n$ 拆分成尽可能多的正数 $x$ 的情况下的最大乘积，则可以将 $n$ 分成 $\dfrac{n}{x}$ 项，此时 $f(x)=x^{\frac{n}{x}}$，目标是求 $f(x)$ 的最大值，即

$$
\mathop{\max}\limits_{x}(f(x))
$$

可以将 $f(x)$ 写成如下形式：

$$
f(x)=x^{\frac{n}{x}}=e^{\frac{n \ln x}{x}}
$$

令 $g(t)=e^t$，$h(x)=\dfrac{\ln x}{x}$，则有 $f(x)=g(n \cdot h(x))$。由于 $g(t)$ 是单调递增的，$n>0$，因此 $h(x)$ 与 $f(x)$ 的单调性相同。

计算 $h(x)$ 的驻点，即 $h'(x)=\dfrac{1- \ln x}{x^2}=0$ 的点，得到驻点为 $x=e$。

由于当 $0<x<e$ 时 $h'(x)>0$，当 $x>e$ 时 $h'(x)<0$，因此 $x=e$ 是 $h(x)$ 的极大值点，也是 $f(x)$ 的极大值点。由于函数 $f(x)$ 的定义域连续，因此极大值点唯一，也是最大值点。

因此，当 $x=e$ 时，$f(x)$ 取到最大值，$\max f(x)=f(e)=e^{\frac{n}{e}}$。

由于 $e$ 不是整数，因此使用与 $e$ 最接近的整数作为 $x$ 的值，$x$ 可以是 $2$ 或 $3$，此时需要比较 $f(2)$ 与 $f(3)$ 的大小，可以通过计算 $\dfrac{f(3)}{f(2)}$ 进行比较。

$$
\dfrac{f(3)}{f(2)}=\dfrac{e^{n \cdot h(3)}}{e^{n \cdot h(2)}}=e^{n \cdot h(3)-n \cdot h(2)}=e^{n \cdot (\frac{\ln 3}{3} - \frac{\ln 2}{2})}=e^{\frac{n}{6} \cdot (2 \ln 3 - 3 \ln 2)}=e^{\frac{n}{6} \cdot (\ln 9 - \ln 8)}
$$

由于 $\ln 9 > \ln 8$，因此 $\dfrac{f(3)}{f(2)}>1$，即 $f(3)>f(2)$。当 $x=3$ 时，可以得到最大乘积。因此，应该将给定的正整数拆分成尽可能多的 $3$。

根据 $n$ 除以 $3$ 的余数进行分类讨论：

- 如果余数为 $0$，即 $n=3m(m \ge 2)$，则将 $n$ 拆分成 $m$ 个 $3$；

- 如果余数为 $1$，即 $n=3m+1(m \ge 1)$，由于 $2 \times 2 > 3 \times 1$，因此将 $n$ 拆分成 $m-1$ 个 $3$ 和 $2$ 个 $2$；

- 如果余数为 $2$，即 $n=3m+2(m \ge 1)$，则将 $n$ 拆分成 $m$ 个 $3$ 和 $1$ 个 $2$。

上述拆分的适用条件是 $n \ge 4$。如果 $n \le 3$，则上述拆分不适用，需要单独处理。

- 如果 $n=2$，则唯一的拆分方案是 $2=1+1$，最大乘积是 $1 \times 1=1$；

- 如果 $n=3$，则拆分方案有 $3=1+2=1+1+1$，最大乘积对应方案 $3=1+2$，最大乘积是 $1 \times 2=2$。

这两种情形可以合并为：当 $n \le 3$ 时，最大乘积是 $n-1$。

**归纳证明法**

- 第一步：证明最优的拆分方案中不会出现大于 $4$ 的整数。

    > 假设出现了大于 $4$ 的整数 $x$，由于 $2(x-2) > x$ 在 $x > 4$ 时恒成立，将 $x$ 拆分成 $2$ 和 $x-2$ 可以增大乘积。因此最优的拆分方案中不会出现大于 $4$ 的整数。

- 第二步：证明最优的拆分方案中可以不出现整数 $4$。

    > 如果出现了整数 $4$，我们可以用 $2 \times 2$ 代替之，乘积不变。

此时，我们可以知道，最优的拆分方案中只会出现 $1$，$2$ 和 $3$。

- 第三步：证明当 $n \geq 5$ 时，最优的拆分方案中不会出现整数 $1$。

    > 当 $n \geq 5$ 时，如果出现了整数 $1$，那么拆分中剩余的数的和为 $n-1 \geq 4$，对应这至少两个整数。我们将其中任意一个整数 $x$ 加上 $1$，乘积就会增大。因此最优的拆分方案中不会出现整数 $1$。

此时，我们可以知道，当 $n \geq 5$ 时，最优的拆分方案中只会出现 $2$ 和 $3$。

- 第四步：证明当 $n \geq 5$ 时，最优的拆分方案中 $2$ 的个数不会超过 $3$ 个。

    > 如果出现了超过 $3$ 个 $2$，那么将它们转换成 $2$ 个 $3$，可以增大乘积，即 $3 \times 3 > 2 \times 2 \times 2$。

此时，$n \geq 5$ 的最优拆分方案就唯一了。这是因为当最优的拆分方案中 $2$ 的个数分别为 $0$，$1$，$2$ 个时，就对应着 $n$ 除以 $3$ 的余数分别为 $0$，$2$，$1$ 的情况。因此我们可以得到和「函数极值证明法」相同的分类讨论结果。

当 $n = 4$ 时，$4 = 2 \times 2$ 的最优拆分方案也可以放入分类讨论结果；当 $2 \leq n \leq 3$ 时，只有唯一的拆分方案 $1 \times (n - 1)$。

```Java [sol3-Java]
class Solution {
    public int integerBreak(int n) {
        if (n <= 3) {
            return n - 1;
        }
        int quotient = n / 3;
        int remainder = n % 3;
        if (remainder == 0) {
            return (int) Math.pow(3, quotient);
        } else if (remainder == 1) {
            return (int) Math.pow(3, quotient - 1) * 4;
        } else {
            return (int) Math.pow(3, quotient) * 2;
        }
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int IntegerBreak(int n) {
        if (n <= 3) {
            return n - 1;
        }
        int quotient = n / 3;
        int remainder = n % 3;
        if (remainder == 0) {
            return (int) Math.Pow(3, quotient);
        } else if (remainder == 1) {
            return (int) Math.Pow(3, quotient - 1) * 4;
        } else {
            return (int) Math.Pow(3, quotient) * 2;
        }
    }
}
```

```C++ [sol3-C++]
class Solution {
public:
    int integerBreak(int n) {
        if (n <= 3) {
            return n - 1;
        }
        int quotient = n / 3;
        int remainder = n % 3;
        if (remainder == 0) {
            return (int)pow(3, quotient);
        } else if (remainder == 1) {
            return (int)pow(3, quotient - 1) * 4;
        } else {
            return (int)pow(3, quotient) * 2;
        }
    }
};
```

```Python [sol3-Python3]
class Solution:
    def integerBreak(self, n: int) -> int:
        if n <= 3:
            return n - 1
        
        quotient, remainder = n // 3, n % 3
        if remainder == 0:
            return 3 ** quotient
        elif remainder == 1:
            return 3 ** (quotient - 1) * 4
        else:
            return 3 ** quotient * 2
```

```go [sol3-Golang]
func integerBreak(n int) int {
    if n <= 3 {
        return n - 1
    }
    quotient := n / 3
    remainder := n % 3
    if remainder == 0 {
        return int(math.Pow(3, float64(quotient)))
    } else if remainder == 1 {
        return int(math.Pow(3, float64(quotient - 1))) * 4
    }
    return int(math.Pow(3, float64(quotient))) * 2
}
```

```C [sol3-C]
int integerBreak(int n) {
    if (n <= 3) {
        return n - 1;
    }
    int quotient = n / 3;
    int remainder = n % 3;
    if (remainder == 0) {
        return (int)pow(3, quotient);
    } else if (remainder == 1) {
        return (int)pow(3, quotient - 1) * 4;
    } else {
        return (int)pow(3, quotient) * 2;
    }
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。涉及到的操作包括计算商和余数，以及幂次运算，时间复杂度都是常数。

- 空间复杂度：$O(1)$。只需要使用常数复杂度的额外空间。
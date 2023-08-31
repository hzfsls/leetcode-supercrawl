## [926.将字符串翻转到单调递增 中文官方题解](https://leetcode.cn/problems/flip-string-to-monotone-increasing/solutions/100000/jiang-zi-fu-chuan-fan-zhuan-dao-dan-diao-stjd)

#### 方法一：动态规划

单调递增的字符串满足以下性质：

- 首个字符是 $0$ 或 $1$；

- 其余的每个字符，字符 $0$ 前面的相邻字符一定是 $0$，字符 $1$ 前面的相邻字符可以是 $0$ 或 $1$。

当 $i > 0$ 时，如果字符串 $s$ 的长度为 $i$ 的前缀即 $s[0 .. i - 1]$ 单调递增，且 $s[i]$ 和 $s[i - 1]$ 也满足上述单调递增的顺序，则长度为 $i + 1$ 的前缀 $s[0 .. i]$ 也单调递增。因此可以使用动态规划计算使字符串 $s$ 单调递增的最小翻转次数。

由于字符串 $s$ 的每个位置的字符可以是 $0$ 或 $1$，因此对于每个位置需要分别计算该位置的字符是 $0$ 和该位置的字符是 $1$ 的情况下的最小翻转次数。

假设字符串 $s$ 的长度是 $n$，对于 $0 \le i < n$，用 $\textit{dp}[i][0]$ 和 $\textit{dp}[i][1]$ 分别表示下标 $i$ 处的字符为 $0$ 和 $1$ 的情况下使得 $s[0 .. i]$ 单调递增的最小翻转次数。

当 $i = 0$ 时，对应长度为 $1$ 的前缀，一定满足单调递增，因此 $\textit{dp}[0][0]$ 和 $\textit{dp}[0][1]$ 的值取决于字符 $s[i]$。具体而言，$\textit{dp}[0][0] = \mathbb{I}(s[0] = \text{`1'})$，$\textit{dp}[0][1] = \mathbb{I}(s[0] = \text{`0'})$，其中 $\mathbb{I}$ 为示性函数，当事件成立时示性函数值为 $1$，当事件不成立时示性函数值为 $0$。

当 $1 \le i < n$ 时，考虑下标 $i$ 处的字符。如果下标 $i$ 处的字符是 $0$，则只有当下标 $i - 1$ 处的字符是 $0$ 时才符合单调递增；如果下标 $i$ 处的字符是 $1$，则下标 $i - 1$ 处的字符是 $0$ 或 $1$ 都符合单调递增，此时为了将翻转次数最小化，应分别考虑下标 $i - 1$ 处的字符是 $0$ 和 $1$ 的情况下需要的翻转次数，取两者的最小值。

在计算 $\textit{dp}[i][0]$ 和 $\textit{dp}[i][1]$ 时，还需要根据 $s[i]$ 的值决定下标 $i$ 处的字符是否需要翻转，因此可以得到如下状态转移方程，其中 $\mathbb{I}$ 为示性函数：

$$
\begin{aligned}
\textit{dp}[i][0] &= \textit{dp}[i - 1][0] + \mathbb{I}(s[i] = \text{`1'}) \\
\textit{dp}[i][1] &= \min(\textit{dp}[i - 1][0], \textit{dp}[i - 1][1]) + \mathbb{I}(s[i] = \text{`0'})
\end{aligned}
$$

遍历字符串 $s$ 计算每个下标处的状态值，遍历结束之后，$\textit{dp}[n - 1][0]$ 和 $\textit{dp}[n - 1][1]$ 中的最小值即为使字符串 $s$ 单调递增的最小翻转次数。

实现方面有以下两点可以优化。

1. 可以将边界情况定义为 $\textit{dp}[-1][0] = \textit{dp}[-1][1] = 0$，则可以从下标 $0$ 开始使用状态转移方程计算状态值。

2. 由于 $\textit{dp}[i]$ 的值只和 $\textit{dp}[i - 1]$ 有关，因此在计算状态值的过程中只需要维护前一个下标处的状态值，将空间复杂度降低到 $O(1)$。

```Python [sol1-Python3]
class Solution:
    def minFlipsMonoIncr(self, s: str) -> int:
        dp0 = dp1 = 0
        for c in s:
            dp0New, dp1New = dp0, min(dp0, dp1)
            if c == '1':
                dp0New += 1
            else:
                dp1New += 1
            dp0, dp1 = dp0New, dp1New
        return min(dp0, dp1)
```

```Java [sol1-Java]
class Solution {
    public int minFlipsMonoIncr(String s) {
        int n = s.length();
        int dp0 = 0, dp1 = 0;
        for (int i = 0; i < n; i++) {
            char c = s.charAt(i);
            int dp0New = dp0, dp1New = Math.min(dp0, dp1);
            if (c == '1') {
                dp0New++;
            } else {
                dp1New++;
            }
            dp0 = dp0New;
            dp1 = dp1New;
        }
        return Math.min(dp0, dp1);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinFlipsMonoIncr(string s) {
        int n = s.Length;
        int dp0 = 0, dp1 = 0;
        for (int i = 0; i < n; i++) {
            char c = s[i];
            int dp0New = dp0, dp1New = Math.Min(dp0, dp1);
            if (c == '1') {
                dp0New++;
            } else {
                dp1New++;
            }
            dp0 = dp0New;
            dp1 = dp1New;
        }
        return Math.Min(dp0, dp1);
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minFlipsMonoIncr(string &s) {
        int dp0 = 0, dp1 = 0;
        for (char c: s) {
            int dp0New = dp0, dp1New = min(dp0, dp1);
            if (c == '1') {
                dp0New++;
            } else {
                dp1New++;
            }
            dp0 = dp0New;
            dp1 = dp1New;
        }
        return min(dp0, dp1);
    }
};
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int minFlipsMonoIncr(char * s){
    int n = strlen(s);
    int dp0 = 0, dp1 = 0;
    for (int i = 0; i < n; i++) {
        char c = s[i];
        int dp0New = dp0, dp1New = MIN(dp0, dp1);
        if (c == '1') {
            dp0New++;
        } else {
            dp1New++;
        }
        dp0 = dp0New;
        dp1 = dp1New;
    }
    return MIN(dp0, dp1);
}
```

```go [sol1-Golang]
func minFlipsMonoIncr(s string) int {
    dp0, dp1 := 0, 0
    for _, c := range s {
        dp0New, dp1New := dp0, min(dp0, dp1)
        if c == '1' {
            dp0New++
        } else {
            dp1New++
        }
        dp0, dp1 = dp0New, dp1New
    }
    return min(dp0, dp1)
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var minFlipsMonoIncr = function(s) {
    const n = s.length;
    let dp0 = 0, dp1 = 0;
    for (let i = 0; i < n; i++) {
        const c = s[i];
        let dp0New = dp0, dp1New = Math.min(dp0, dp1);
        if (c === '1') {
            dp0New++;
        } else {
            dp1New++;
        }
        dp0 = dp0New;
        dp1 = dp1New;
    }
    return Math.min(dp0, dp1);
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。需要遍历字符串一次，对于每个字符计算最小翻转次数的时间都是 $O(1)$。

- 空间复杂度：$O(1)$。使用空间优化的方法，空间复杂度是 $O(1)$。
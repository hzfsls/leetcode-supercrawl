## [712.两个字符串的最小ASCII删除和 中文官方题解](https://leetcode.cn/problems/minimum-ascii-delete-sum-for-two-strings/solutions/100000/liang-ge-zi-fu-chuan-de-zui-xiao-asciish-xllf)
#### 方法一：动态规划

假设字符串 $s_1$ 和 $s_2$ 的长度分别为 $m$ 和 $n$，创建 $m+1$ 行 $n+1$ 列的二维数组 $\textit{dp}$，其中 $\textit{dp}[i][j]$ 表示使 $s_1[0:i]$ 和 $s_2[0:j]$ 相同的最小 $\text{ASCII}$ 删除和。

> 上述表示中，$s_1[0:i]$ 表示 $s_1$ 的长度为 $i$ 的前缀，$s_2[0:j]$ 表示 $s_2$ 的长度为 $j$ 的前缀。

动态规划的边界情况如下：

- 当 $i=j=0$ 时，$s_1[0:i]$ 和 $s_2[0:j]$ 都为空，两个空字符串相同，不需要删除任何字符，因此有 $\textit{dp}[0][0]=0$；

- 当 $i=0$ 且 $j>0$ 时，$s_1[0:i]$ 为空且 $s_2[0:j]$ 不为空，空字符串和任何字符串要变成相同，只有将另一个字符串的字符全部删除，因此对任意 $1 \le j \le n$，有 $\textit{dp}[0][j]=\textit{dp}[0][j-1]+s_2[j-1]$；

- 当 $j=0$ 且 $i>0$ 时，$s_2[0:j]$ 为空且 $s_1[0:i]$ 不为空，同理可得，对任意 $1 \le i \le m$，有 $\textit{dp}[i][0]=\textit{dp}[i-1][0]+s_1[i-1]$。

当 $i>0$ 且 $j>0$ 时，考虑 $\textit{dp}[i][j]$ 的计算：

- 当 $s_1[i-1]=s_2[j-1]$ 时，将这两个相同的字符称为公共字符，考虑使 $s_1[0:i-1]$ 和 $s_2[0:j-1]$ 相同的最小 $\text{ASCII}$ 删除和，增加一个公共字符之后，最小 $\text{ASCII}$ 删除和不变，因此 $\textit{dp}[i][j]=\textit{dp}[i-1][j-1]$。

- 当 $s_1[i-1] \ne s_2[j-1]$ 时，考虑以下两项：

   - 使 $s_1[0:i-1]$ 和 $s_2[0:j]$ 相同的最小 $\text{ASCII}$ 删除和，加上删除 $s_1[i-1]$ 的 $\text{ASCII}$ 值；

   - 使 $s_1[0:i]$ 和 $s_2[0:j-1]$ 相同的最小 $\text{ASCII}$ 删除和，加上删除 $s_2[j-1]$ 的 $\text{ASCII}$ 值。

   要得到使 $s_1[0:i]$ 和 $s_2[0:j]$ 相同的最小 $\text{ASCII}$ 删除和，应取两项中较小的一项，因此 $\textit{dp}[i][j]=\min(\textit{dp}[i-1][j]+s_1[i-1],\textit{dp}[i][j-1]+s_2[j-1])$。

由此可以得到如下状态转移方程：

$$
\textit{dp}[i][j] = \begin{cases}
\textit{dp}[i-1][j-1], & s_1[i-1]=s_2[j-1] \\
\min(\textit{dp}[i-1][j]+s_1[i-1],\textit{dp}[i][j-1]+s_2[j-1]), & s_1[i-1] \ne s_2[j-1]
\end{cases}
$$

最终计算得到 $\textit{dp}[m][n]$ 即为使 $s_1$ 和 $s_2$ 相同的最小 $\text{ASCII}$ 删除和。

实现方面，需要将 $s_1[i-1]$ 和 $s_2[j-1]$ 转换成相应的 $\text{ASCII}$ 值。

```Java [sol1-Java]
class Solution {
    public int minimumDeleteSum(String s1, String s2) {
        int m = s1.length(), n = s2.length();
        int[][] dp = new int[m + 1][n + 1];
        for (int i = 1; i <= m; i++) {
            dp[i][0] = dp[i - 1][0] + s1.codePointAt(i - 1);
        }
        for (int j = 1; j <= n; j++) {
            dp[0][j] = dp[0][j - 1] + s2.codePointAt(j - 1);
        }
        for (int i = 1; i <= m; i++) {
            int code1 = s1.codePointAt(i - 1);
            for (int j = 1; j <= n; j++) {
                int code2 = s2.codePointAt(j - 1);
                if (code1 == code2) {
                    dp[i][j] = dp[i - 1][j - 1];
                } else {
                    dp[i][j] = Math.min(dp[i - 1][j] + code1, dp[i][j - 1] + code2);
                }
            }
        }
        return dp[m][n];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinimumDeleteSum(string s1, string s2) {
        int m = s1.Length, n = s2.Length;
        int[,] dp = new int[m + 1, n + 1];
        for (int i = 1; i <= m; i++) {
            dp[i, 0] = dp[i - 1, 0] + s1[i - 1];
        }
        for (int j = 1; j <= n; j++) {
            dp[0, j] = dp[0, j - 1] + s2[j - 1];
        }
        for (int i = 1; i <= m; i++) {
            int code1 = s1[i - 1];
            for (int j = 1; j <= n; j++) {
                int code2 = s2[j - 1];
                if (code1 == code2) {
                    dp[i, j] = dp[i - 1, j - 1];
                } else {
                    dp[i, j] = Math.Min(dp[i - 1, j] + code1, dp[i, j - 1] + code2);
                }
            }
        }
        return dp[m, n];
    }
}
```

```JavaScript [sol1-JavaScript]
var minimumDeleteSum = function(s1, s2) {
    const m = s1.length, n = s2.length;
    const dp = new Array(m + 1).fill(0).map(() => new Array(n + 1).fill(0));
    for (let i = 1; i <= m; i++) {
        dp[i][0] = dp[i - 1][0] + s1[i - 1].charCodeAt();
    }
    for (let j = 1; j <= n; j++) {
        dp[0][j] = dp[0][j - 1] + s2[j - 1].charCodeAt();
    }
    for (let i = 1; i <= m; i++) {
        const code1 = s1[i - 1].charCodeAt();
        for (let j = 1; j <= n; j++) {
            const code2 = s2[j - 1].charCodeAt();
            if (code1 === code2) {
                dp[i][j] = dp[i - 1][j - 1];
            } else {
                dp[i][j] = Math.min(dp[i - 1][j] + code1, dp[i][j - 1] + code2);
            }
        }
    }
    return dp[m][n];
};
```

```Python [sol1-Python3]
class Solution:
    def minimumDeleteSum(self, s1: str, s2: str) -> int:
        m, n = len(s1), len(s2)
        dp = [[0] * (n + 1) for _ in range(m + 1)]
        for i in range(1, m + 1):
            dp[i][0] = dp[i - 1][0] + ord(s1[i - 1])
        for j in range(1, n + 1):
            dp[0][j] = dp[0][j - 1] + ord(s2[j - 1])

        for i in range(1, m + 1):
            for j in range(1, n + 1):
                if s1[i - 1] == s2[j - 1]:
                    dp[i][j] = dp[i - 1][j - 1]
                else:
                    dp[i][j] = min(dp[i - 1][j] + ord(s1[i - 1]), dp[i][j - 1] + ord(s2[j - 1]))
        
        return dp[m][n]
```

```C++ [sol1-C++]
class Solution {
public:
    int minimumDeleteSum(string s1, string s2) {
        int m = s1.size();
        int n = s2.size();
        vector<vector<int>> dp(m + 1, vector<int>(n + 1));

        for (int i = 1; i <= m; ++i) {
            dp[i][0] = dp[i - 1][0] + s1[i - 1];
        }
        for (int j = 1; j <= n; ++j) {
            dp[0][j] = dp[0][j - 1] + s2[j - 1];
        }
        for (int i = 1; i <= m; i++) {
            char c1 = s1[i - 1];
            for (int j = 1; j <= n; j++) {
                char c2 = s2[j - 1];
                if (c1 == c2) {
                    dp[i][j] = dp[i - 1][j - 1];
                } else {
                    dp[i][j] = min(dp[i - 1][j] + s1[i - 1], dp[i][j - 1] + s2[j - 1]);
                }
            }
        }

        return dp[m][n];
    }
};
```

```go [sol1-Golang]
func minimumDeleteSum(s1 string, s2 string) int {
    m, n := len(s1), len(s2)
    dp := make([][]int, m+1)
    for i := range dp {
        dp[i] = make([]int, n+1)
        if i > 0 {
            dp[i][0] = dp[i-1][0] + int(s1[i-1])
        }
    }
    for j := range dp[0] {
        if j > 0 {
            dp[0][j] = dp[0][j-1] + int(s2[j-1])
        }
    }
    for i, c1 := range s1 {
        for j, c2 := range s2 {
            if c1 == c2 {
                dp[i+1][j+1] = dp[i][j]
            } else {
                dp[i+1][j+1] = min(dp[i][j+1] + int(c1), dp[i+1][j] + int(c2))
            }
        }
    }
    return dp[m][n]
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是字符串 $s_1$ 和 $s_2$ 的长度。二维数组 $\textit{dp}$ 有 $m+1$ 行和 $n+1$ 列，需要对 $\textit{dp}$ 中的每个元素进行计算。

- 空间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是字符串 $s_1$ 和 $s_2$ 的长度。创建了 $m+1$ 行 $n+1$ 列的二维数组 $\textit{dp}$。
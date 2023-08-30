#### 方法一：动态规划

最长公共子序列问题是典型的二维动态规划问题。

假设字符串 $\textit{text}_1$ 和 $\textit{text}_2$ 的长度分别为 $m$ 和 $n$，创建 $m+1$ 行 $n+1$ 列的二维数组 $\textit{dp}$，其中 $\textit{dp}[i][j]$ 表示 $\textit{text}_1[0:i]$ 和 $\textit{text}_2[0:j]$ 的最长公共子序列的长度。

> 上述表示中，$\textit{text}_1[0:i]$ 表示 $\textit{text}_1$ 的长度为 $i$ 的前缀，$\textit{text}_2[0:j]$ 表示 $\textit{text}_2$ 的长度为 $j$ 的前缀。

考虑动态规划的边界情况：

- 当 $i=0$ 时，$\textit{text}_1[0:i]$ 为空，空字符串和任何字符串的最长公共子序列的长度都是 $0$，因此对任意 $0 \le j \le n$，有 $\textit{dp}[0][j]=0$；

- 当 $j=0$ 时，$\textit{text}_2[0:j]$ 为空，同理可得，对任意 $0 \le i \le m$，有 $\textit{dp}[i][0]=0$。

因此动态规划的边界情况是：当 $i=0$ 或 $j=0$ 时，$\textit{dp}[i][j]=0$。

当 $i>0$ 且 $j>0$ 时，考虑 $\textit{dp}[i][j]$ 的计算：

- 当 $\textit{text}_1[i-1]=\textit{text}_2[j-1]$ 时，将这两个相同的字符称为公共字符，考虑 $\textit{text}_1[0:i-1]$ 和 $\textit{text}_2[0:j-1]$ 的最长公共子序列，再增加一个字符（即公共字符）即可得到 $\textit{text}_1[0:i]$ 和 $\textit{text}_2[0:j]$ 的最长公共子序列，因此 $\textit{dp}[i][j]=\textit{dp}[i-1][j-1]+1$。

- 当 $\textit{text}_1[i-1] \ne \textit{text}_2[j-1]$ 时，考虑以下两项：

   - $\textit{text}_1[0:i-1]$ 和 $\textit{text}_2[0:j]$ 的最长公共子序列；

   - $\textit{text}_1[0:i]$ 和 $\textit{text}_2[0:j-1]$ 的最长公共子序列。

   要得到 $\textit{text}_1[0:i]$ 和 $\textit{text}_2[0:j]$ 的最长公共子序列，应取两项中的长度较大的一项，因此 $\textit{dp}[i][j]=\max(\textit{dp}[i-1][j],\textit{dp}[i][j-1])$。

由此可以得到如下状态转移方程：

$$
\textit{dp}[i][j] = \begin{cases}
\textit{dp}[i-1][j-1]+1, & \textit{text}_1[i-1]=\textit{text}_2[j-1] \\
\max(\textit{dp}[i-1][j],\textit{dp}[i][j-1]), & \textit{text}_1[i-1] \ne \textit{text}_2[j-1]
\end{cases}
$$

最终计算得到 $\textit{dp}[m][n]$ 即为 $\textit{text}_1$ 和 $\textit{text}_2$ 的最长公共子序列的长度。

![image.png](https://pic.leetcode-cn.com/1617411822-KhEKGw-image.png){:width="85%"}


```Java [sol1-Java]
class Solution {
    public int longestCommonSubsequence(String text1, String text2) {
        int m = text1.length(), n = text2.length();
        int[][] dp = new int[m + 1][n + 1];
        for (int i = 1; i <= m; i++) {
            char c1 = text1.charAt(i - 1);
            for (int j = 1; j <= n; j++) {
                char c2 = text2.charAt(j - 1);
                if (c1 == c2) {
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                } else {
                    dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }
        return dp[m][n];
    }
}
```

```JavaScript [sol1-JavaScript]
var longestCommonSubsequence = function(text1, text2) {
    const m = text1.length, n = text2.length;
    const dp = new Array(m + 1).fill(0).map(() => new Array(n + 1).fill(0));
    for (let i = 1; i <= m; i++) {
        const c1 = text1[i - 1];
        for (let j = 1; j <= n; j++) {
            const c2 = text2[j - 1];
            if (c1 === c2) {
                dp[i][j] = dp[i - 1][j - 1] + 1;
            } else {
                dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
            }
        }
    }
    return dp[m][n];
};
```

```go [sol1-Golang]
func longestCommonSubsequence(text1, text2 string) int {
    m, n := len(text1), len(text2)
    dp := make([][]int, m+1)
    for i := range dp {
        dp[i] = make([]int, n+1)
    }
    for i, c1 := range text1 {
        for j, c2 := range text2 {
            if c1 == c2 {
                dp[i+1][j+1] = dp[i][j] + 1
            } else {
                dp[i+1][j+1] = max(dp[i][j+1], dp[i+1][j])
            }
        }
    }
    return dp[m][n]
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```Python [sol1-Python3]
class Solution:
    def longestCommonSubsequence(self, text1: str, text2: str) -> int:
        m, n = len(text1), len(text2)
        dp = [[0] * (n + 1) for _ in range(m + 1)]
        
        for i in range(1, m + 1):
            for j in range(1, n + 1):
                if text1[i - 1] == text2[j - 1]:
                    dp[i][j] = dp[i - 1][j - 1] + 1
                else:
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
        
        return dp[m][n]
```

```C++ [sol1-C++]
class Solution {
public:
    int longestCommonSubsequence(string text1, string text2) {
        int m = text1.length(), n = text2.length();
        vector<vector<int>> dp(m + 1, vector<int>(n + 1));
        for (int i = 1; i <= m; i++) {
            char c1 = text1.at(i - 1);
            for (int j = 1; j <= n; j++) {
                char c2 = text2.at(j - 1);
                if (c1 == c2) {
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                } else {
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }
        return dp[m][n];
    }
};
```

```C [sol1-C]
int longestCommonSubsequence(char* text1, char* text2) {
    int m = strlen(text1), n = strlen(text2);
    int dp[m + 1][n + 1];
    memset(dp, 0, sizeof(dp));
    for (int i = 1; i <= m; i++) {
        char c1 = text1[i - 1];
        for (int j = 1; j <= n; j++) {
            char c2 = text2[j - 1];
            if (c1 == c2) {
                dp[i][j] = dp[i - 1][j - 1] + 1;
            } else {
                dp[i][j] = fmax(dp[i - 1][j], dp[i][j - 1]);
            }
        }
    }
    return dp[m][n];
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是字符串 $\textit{text}_1$ 和 $\textit{text}_2$ 的长度。二维数组 $\textit{dp}$ 有 $m+1$ 行和 $n+1$ 列，需要对 $\textit{dp}$ 中的每个元素进行计算。

- 空间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是字符串 $\textit{text}_1$ 和 $\textit{text}_2$ 的长度。创建了 $m+1$ 行 $n+1$ 列的二维数组 $\textit{dp}$。
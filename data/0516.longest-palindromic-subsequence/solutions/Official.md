#### 方法一：动态规划

对于一个子序列而言，如果它是回文子序列，并且长度大于 $2$，那么将它首尾的两个字符去除之后，它仍然是个回文子序列。因此可以用动态规划的方法计算给定字符串的最长回文子序列。

用 $\textit{dp}[i][j]$ 表示字符串 $s$ 的下标范围 $[i, j]$ 内的最长回文子序列的长度。假设字符串 $s$ 的长度为 $n$，则只有当 $0 \le i \le j < n$ 时，才会有 $\textit{dp}[i][j] > 0$，否则 $\textit{dp}[i][j] = 0$。

由于任何长度为 $1$ 的子序列都是回文子序列，因此动态规划的边界情况是，对任意 $0 \le i < n$，都有 $\textit{dp}[i][i] = 1$。

当 $i < j$ 时，计算 $\textit{dp}[i][j]$ 需要分别考虑 $s[i]$ 和 $s[j]$ 相等和不相等的情况：

- 如果 $s[i] = s[j]$，则首先得到 $s$ 的下标范围 $[i+1, j-1]$ 内的最长回文子序列，然后在该子序列的首尾分别添加 $s[i]$ 和 $s[j]$，即可得到 $s$ 的下标范围 $[i, j]$ 内的最长回文子序列，因此 $\textit{dp}[i][j] = \textit{dp}[i+1][j-1] + 2$；

- 如果 $s[i] \ne s[j]$，则 $s[i]$ 和 $s[j]$ 不可能同时作为同一个回文子序列的首尾，因此 $\textit{dp}[i][j] = \max(\textit{dp}[i+1][j], \textit{dp}[i][j-1])$。

由于状态转移方程都是从长度较短的子序列向长度较长的子序列转移，因此需要注意动态规划的循环顺序。

最终得到 $\textit{dp}[0][n-1]$ 即为字符串 $s$ 的最长回文子序列的长度。

```Java [sol1-Java]
class Solution {
    public int longestPalindromeSubseq(String s) {
        int n = s.length();
        int[][] dp = new int[n][n];
        for (int i = n - 1; i >= 0; i--) {
            dp[i][i] = 1;
            char c1 = s.charAt(i);
            for (int j = i + 1; j < n; j++) {
                char c2 = s.charAt(j);
                if (c1 == c2) {
                    dp[i][j] = dp[i + 1][j - 1] + 2;
                } else {
                    dp[i][j] = Math.max(dp[i + 1][j], dp[i][j - 1]);
                }
            }
        }
        return dp[0][n - 1];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int LongestPalindromeSubseq(string s) {
        int n = s.Length;
        int[,] dp = new int[n, n];
        for (int i = n - 1; i >= 0; i--) {
            dp[i, i] = 1;
            char c1 = s[i];
            for (int j = i + 1; j < n; j++) {
                char c2 = s[j];
                if (c1 == c2) {
                    dp[i, j] = dp[i + 1, j - 1] + 2;
                } else {
                    dp[i, j] = Math.Max(dp[i + 1, j], dp[i, j - 1]);
                }
            }
        }
        return dp[0, n - 1];
    }
}
```

```JavaScript [sol1-JavaScript]
var longestPalindromeSubseq = function(s) {
    const n = s.length;
    const dp = new Array(n).fill(0).map(() => new Array(n).fill(0));
    for (let i = n - 1; i >= 0; i--) {
        dp[i][i] = 1;
        const c1 = s[i];
        for (let j = i + 1; j < n; j++) {
            const c2 = s[j];
            if (c1 === c2) {
                dp[i][j] = dp[i + 1][j - 1] + 2;
            } else {
                dp[i][j] = Math.max(dp[i + 1][j], dp[i][j - 1]);
            }
        }
    }
    return dp[0][n - 1];
};
```

```Python [sol1-Python3]
class Solution:
    def longestPalindromeSubseq(self, s: str) -> int:
        n = len(s)
        dp = [[0] * n for _ in range(n)]
        for i in range(n - 1, -1, -1):
            dp[i][i] = 1
            for j in range(i + 1, n):
                if s[i] == s[j]:
                    dp[i][j] = dp[i + 1][j - 1] + 2
                else:
                    dp[i][j] = max(dp[i + 1][j], dp[i][j - 1])
        return dp[0][n - 1]
```

```go [sol1-Golang]
func longestPalindromeSubseq(s string) int {
    n := len(s)
    dp := make([][]int, n)
    for i := range dp {
        dp[i] = make([]int, n)
    }
    for i := n - 1; i >= 0; i-- {
        dp[i][i] = 1
        for j := i + 1; j < n; j++ {
            if s[i] == s[j] {
                dp[i][j] = dp[i+1][j-1] + 2
            } else {
                dp[i][j] = max(dp[i+1][j], dp[i][j-1])
            }
        }
    }
    return dp[0][n-1]
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C++ [sol1-C++]
class Solution {
public:
    int longestPalindromeSubseq(string s) {
        int n = s.length();
        vector<vector<int>> dp(n, vector<int>(n));
        for (int i = n - 1; i >= 0; i--) {
            dp[i][i] = 1;
            char c1 = s[i];
            for (int j = i + 1; j < n; j++) {
                char c2 = s[j];
                if (c1 == c2) {
                    dp[i][j] = dp[i + 1][j - 1] + 2;
                } else {
                    dp[i][j] = max(dp[i + 1][j], dp[i][j - 1]);
                }
            }
        }
        return dp[0][n - 1];
    }
};
```

```C [sol1-C]
int longestPalindromeSubseq(char* s) {
    int n = strlen(s);
    int dp[n][n];
    memset(dp, 0, sizeof(dp));
    for (int i = n - 1; i >= 0; i--) {
        dp[i][i] = 1;
        char c1 = s[i];
        for (int j = i + 1; j < n; j++) {
            char c2 = s[j];
            if (c1 == c2) {
                dp[i][j] = dp[i + 1][j - 1] + 2;
            } else {
                dp[i][j] = fmax(dp[i + 1][j], dp[i][j - 1]);
            }
        }
    }
    return dp[0][n - 1];
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是字符串 $s$ 的长度。动态规划需要计算的状态数是 $O(n^2)$。

- 空间复杂度：$O(n^2)$，其中 $n$ 是字符串 $s$ 的长度。需要创建二维数组 $\textit{dp}$，空间是 $O(n^2)$。
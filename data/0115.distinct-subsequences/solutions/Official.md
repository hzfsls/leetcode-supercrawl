## [115.不同的子序列 中文官方题解](https://leetcode.cn/problems/distinct-subsequences/solutions/100000/bu-tong-de-zi-xu-lie-by-leetcode-solutio-urw3)

#### 方法一：动态规划

假设字符串 $s$ 和 $t$ 的长度分别为 $m$ 和 $n$。如果 $t$ 是 $s$ 的子序列，则 $s$ 的长度一定大于或等于 $t$ 的长度，即只有当 $m \ge n$ 时，$t$ 才可能是 $s$ 的子序列。如果 $m<n$，则 $t$ 一定不是 $s$ 的子序列，因此直接返回 $0$。

当 $m \ge n$ 时，可以通过动态规划的方法计算在 $s$ 的子序列中 $t$ 出现的个数。

创建二维数组 $\textit{dp}$，其中 $\textit{dp}[i][j]$ 表示在 $s[i:]$ 的子序列中 $t[j:]$ 出现的个数。

> 上述表示中，$s[i:]$ 表示 $s$ 从下标 $i$ 到末尾的子字符串，$t[j:]$ 表示 $t$ 从下标 $j$ 到末尾的子字符串。

考虑动态规划的边界情况：

- 当 $j=n$ 时，$t[j:]$ 为空字符串，由于空字符串是任何字符串的子序列，因此对任意 $0 \le i \le m$，有 $\textit{dp}[i][n]=1$；

- 当 $i=m$ 且 $j<n$ 时，$s[i:]$ 为空字符串，$t[j:]$ 为非空字符串，由于非空字符串不是空字符串的子序列，因此对任意 $0 \le j<n$，有 $\textit{dp}[m][j]=0$。

当 $i<m$ 且 $j<n$ 时，考虑 $\textit{dp}[i][j]$ 的计算：

- 当 $s[i]=t[j]$ 时，$\textit{dp}[i][j]$ 由两部分组成：

   - 如果 $s[i]$ 和 $t[j]$ 匹配，则考虑 $t[j+1:]$ 作为 $s[i+1:]$ 的子序列，子序列数为 $\textit{dp}[i+1][j+1]$；

   - 如果 $s[i]$ 不和 $t[j]$ 匹配，则考虑 $t[j:]$ 作为 $s[i+1:]$ 的子序列，子序列数为 $\textit{dp}[i+1][j]$。

   因此当 $s[i]=t[j]$ 时，有 $\textit{dp}[i][j]=\textit{dp}[i+1][j+1]+\textit{dp}[i+1][j]$。

- 当 $s[i] \ne t[j]$ 时，$s[i]$ 不能和 $t[j]$ 匹配，因此只考虑 $t[j:]$ 作为 $s[i+1:]$ 的子序列，子序列数为 $\textit{dp}[i+1][j]$。

   因此当 $s[i] \ne t[j]$ 时，有 $\textit{dp}[i][j]=\textit{dp}[i+1][j]$。

由此可以得到如下状态转移方程：

$$
\textit{dp}[i][j] = \begin{cases}
\textit{dp}[i+1][j+1]+\textit{dp}[i+1][j], & s[i]=t[j]\\
\textit{dp}[i+1][j], & s[i] \ne t[j]
\end{cases}
$$

最终计算得到 $\textit{dp}[0][0]$ 即为在 $s$ 的子序列中 $t$ 出现的个数。

<![ppt1](https://assets.leetcode-cn.com/solution-static/115/1.png),![ppt2](https://assets.leetcode-cn.com/solution-static/115/2.png),![ppt3](https://assets.leetcode-cn.com/solution-static/115/3.png),![ppt4](https://assets.leetcode-cn.com/solution-static/115/4.png),![ppt5](https://assets.leetcode-cn.com/solution-static/115/5.png),![ppt6](https://assets.leetcode-cn.com/solution-static/115/6.png),![ppt7](https://assets.leetcode-cn.com/solution-static/115/7.png),![ppt8](https://assets.leetcode-cn.com/solution-static/115/8.png),![ppt9](https://assets.leetcode-cn.com/solution-static/115/9.png),![ppt10](https://assets.leetcode-cn.com/solution-static/115/10.png),![ppt11](https://assets.leetcode-cn.com/solution-static/115/11.png),![ppt12](https://assets.leetcode-cn.com/solution-static/115/12.png),![ppt13](https://assets.leetcode-cn.com/solution-static/115/13.png),![ppt14](https://assets.leetcode-cn.com/solution-static/115/14.png),![ppt15](https://assets.leetcode-cn.com/solution-static/115/15.png),![ppt16](https://assets.leetcode-cn.com/solution-static/115/16.png),![ppt17](https://assets.leetcode-cn.com/solution-static/115/17.png),![ppt18](https://assets.leetcode-cn.com/solution-static/115/18.png),![ppt19](https://assets.leetcode-cn.com/solution-static/115/19.png),![ppt20](https://assets.leetcode-cn.com/solution-static/115/20.png),![ppt21](https://assets.leetcode-cn.com/solution-static/115/21.png),![ppt22](https://assets.leetcode-cn.com/solution-static/115/22.png),![ppt23](https://assets.leetcode-cn.com/solution-static/115/23.png),![ppt24](https://assets.leetcode-cn.com/solution-static/115/24.png)>

```Java [sol1-Java]
class Solution {
    public int numDistinct(String s, String t) {
        int m = s.length(), n = t.length();
        if (m < n) {
            return 0;
        }
        int[][] dp = new int[m + 1][n + 1];
        for (int i = 0; i <= m; i++) {
            dp[i][n] = 1;
        }
        for (int i = m - 1; i >= 0; i--) {
            char sChar = s.charAt(i);
            for (int j = n - 1; j >= 0; j--) {
                char tChar = t.charAt(j);
                if (sChar == tChar) {
                    dp[i][j] = dp[i + 1][j + 1] + dp[i + 1][j];
                } else {
                    dp[i][j] = dp[i + 1][j];
                }
            }
        }
        return dp[0][0];
    }
}
```

```JavaScript [sol1-JavaScript]
var numDistinct = function(s, t) {
    const m = s.length, n = t.length;
    if (m < n) {
        return 0;
    }
    const dp = new Array(m + 1).fill(0).map(() => new Array(n + 1).fill(0));
    for (let i = 0; i <= m; i++) {
        dp[i][n] = 1;
    }
    for (let i = m - 1; i >= 0; i--) {
        for (let j = n - 1; j >= 0; j--) {
            if (s[i] == t[j]) {
                dp[i][j] = dp[i + 1][j + 1] + dp[i + 1][j];
            } else {
                dp[i][j] = dp[i + 1][j];
            }
        }
    }
    return dp[0][0];
};
```

```go [sol1-Golang]
func numDistinct(s, t string) int {
    m, n := len(s), len(t)
    if m < n {
        return 0
    }
    dp := make([][]int, m+1)
    for i := range dp {
        dp[i] = make([]int, n+1)
        dp[i][n] = 1
    }
    for i := m - 1; i >= 0; i-- {
        for j := n - 1; j >= 0; j-- {
            if s[i] == t[j] {
                dp[i][j] = dp[i+1][j+1] + dp[i+1][j]
            } else {
                dp[i][j] = dp[i+1][j]
            }
        }
    }
    return dp[0][0]
}
```

```Python [sol1-Python3]
class Solution:
    def numDistinct(self, s: str, t: str) -> int:
        m, n = len(s), len(t)
        if m < n:
            return 0
        
        dp = [[0] * (n + 1) for _ in range(m + 1)]
        for i in range(m + 1):
            dp[i][n] = 1
        
        for i in range(m - 1, -1, -1):
            for j in range(n - 1, -1, -1):
                if s[i] == t[j]:
                    dp[i][j] = dp[i + 1][j + 1] + dp[i + 1][j]
                else:
                    dp[i][j] = dp[i + 1][j]
        
        return dp[0][0]
```

```C++ [sol1-C++]
class Solution {
public:
    int numDistinct(string s, string t) {
        int m = s.length(), n = t.length();
        if (m < n) {
            return 0;
        }
        vector<vector<unsigned long long>> dp(m + 1, vector<unsigned long long>(n + 1));
        for (int i = 0; i <= m; i++) {
            dp[i][n] = 1;
        }
        for (int i = m - 1; i >= 0; i--) {
            char sChar = s.at(i);
            for (int j = n - 1; j >= 0; j--) {
                char tChar = t.at(j);
                if (sChar == tChar) {
                    dp[i][j] = dp[i + 1][j + 1] + dp[i + 1][j];
                } else {
                    dp[i][j] = dp[i + 1][j];
                }
            }
        }
        return dp[0][0];
    }
};
```

```C [sol1-C]
int numDistinct(char* s, char* t) {
    int m = strlen(s), n = strlen(t);
    if (m < n) {
        return 0;
    }
    unsigned long long dp[m + 1][n + 1];
    memset(dp, 0, sizeof(dp));
    for (int i = 0; i <= m; i++) {
        dp[i][n] = 1;
    }
    for (int i = m - 1; i >= 0; i--) {
        char sChar = s[i];
        for (int j = n - 1; j >= 0; j--) {
            char tChar = t[j];
            if (sChar == tChar) {
                dp[i][j] = dp[i + 1][j + 1] + dp[i + 1][j];
            } else {
                dp[i][j] = dp[i + 1][j];
            }
        }
    }
    return dp[0][0];
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是字符串 $s$ 和 $t$ 的长度。二维数组 $\textit{dp}$ 有 $m+1$ 行和 $n+1$ 列，需要对 $\textit{dp}$ 中的每个元素进行计算。

- 空间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是字符串 $s$ 和 $t$ 的长度。创建了 $m+1$ 行 $n+1$ 列的二维数组 $\textit{dp}$。
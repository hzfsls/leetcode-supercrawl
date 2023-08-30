#### 方法一：最长公共子序列

给定两个字符串 $\textit{word}_1$ 和 $\textit{word}_2$，分别删除若干字符之后使得两个字符串相同，则剩下的字符为两个字符串的公共子序列。为了使删除操作的次数最少，剩下的字符应尽可能多。当剩下的字符为两个字符串的**最长公共子序列**时，删除操作的次数最少。因此，可以计算两个字符串的最长公共子序列的长度，然后分别计算两个字符串的长度和最长公共子序列的长度之差，即为两个字符串分别需要删除的字符数，两个字符串各自需要删除的字符数之和即为最少的删除操作的总次数。

关于最长公共子序列，请读者参考「[1143. 最长公共子序列](https://leetcode-cn.com/problems/longest-common-subsequence)」。计算最长公共子序列的长度的方法见「[1143. 最长公共子序列的官方题解](https://leetcode-cn.com/problems/longest-common-subsequence/solution/zui-chang-gong-gong-zi-xu-lie-by-leetcod-y7u0/)」，这里不再具体阐述。

假设字符串 $\textit{word}_1$ 和 $\textit{word}_2$ 的长度分别为 $m$ 和 $n$，计算字符串 $\textit{word}_1$ 和 $\textit{word}_2$ 的最长公共子序列的长度，记为 $\textit{lcs}$，则最少删除操作次数为 $m - \textit{lcs} + n - \textit{lcs}$。

```Java [sol1-Java]
class Solution {
    public int minDistance(String word1, String word2) {
        int m = word1.length(), n = word2.length();
        int[][] dp = new int[m + 1][n + 1];
        for (int i = 1; i <= m; i++) {
            char c1 = word1.charAt(i - 1);
            for (int j = 1; j <= n; j++) {
                char c2 = word2.charAt(j - 1);
                if (c1 == c2) {
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                } else {
                    dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }
        int lcs = dp[m][n];
        return m - lcs + n - lcs;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinDistance(string word1, string word2) {
        int m = word1.Length, n = word2.Length;
        int[,] dp = new int[m + 1, n + 1];
        for (int i = 1; i <= m; i++) {
            char c1 = word1[i - 1];
            for (int j = 1; j <= n; j++) {
                char c2 = word2[j - 1];
                if (c1 == c2) {
                    dp[i, j] = dp[i - 1, j - 1] + 1;
                } else {
                    dp[i, j] = Math.Max(dp[i - 1, j], dp[i, j - 1]);
                }
            }
        }
        int lcs = dp[m, n];
        return m - lcs + n - lcs;
    }
}
```

```JavaScript [sol1-JavaScript]
var minDistance = function(word1, word2) {
    const m = word1.length, n = word2.length;
    const dp = new Array(m + 1).fill(0).map(() => new Array(n + 1).fill(0));
    for (let i = 1; i <= m; i++) {
        const c1 = word1[i - 1];
        for (let j = 1; j <= n; j++) {
            const c2 = word2[j - 1];
            if (c1 === c2) {
                dp[i][j] = dp[i - 1][j - 1] + 1;
            } else {
                dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
            }
        }
    }
    const lcs = dp[m][n];
    return m - lcs + n - lcs;
};
```

```Python [sol1-Python3]
class Solution:
    def minDistance(self, word1: str, word2: str) -> int:
        m, n = len(word1), len(word2)
        dp = [[0] * (n + 1) for _ in range(m + 1)]
        for i in range(1, m + 1):
            for j in range(1, n + 1):
                if word1[i - 1] == word2[j - 1]:
                    dp[i][j] = dp[i - 1][j - 1] + 1
                else:
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
        
        lcs = dp[m][n]
        return m - lcs + n - lcs
```

```C++ [sol1-C++]
class Solution {
public:
    int minDistance(string word1, string word2) {
        int m = word1.size();
        int n = word2.size();
        vector<vector<int>> dp(m + 1, vector<int>(n + 1));

        for (int i = 1; i <= m; i++) {
            char c1 = word1[i - 1];
            for (int j = 1; j <= n; j++) {
                char c2 = word2[j - 1];
                if (c1 == c2) {
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                } else {
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }

        int lcs = dp[m][n];
        return m - lcs + n - lcs;
    }
};
```

```go [sol1-Golang]
func minDistance(word1, word2 string) int {
    m, n := len(word1), len(word2)
    dp := make([][]int, m+1)
    for i := range dp {
        dp[i] = make([]int, n+1)
    }
    for i, c1 := range word1 {
        for j, c2 := range word2 {
            if c1 == c2 {
                dp[i+1][j+1] = dp[i][j] + 1
            } else {
                dp[i+1][j+1] = max(dp[i][j+1], dp[i+1][j])
            }
        }
    }
    lcs := dp[m][n]
    return m + n - lcs*2
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是字符串 $\textit{word}_1$ 和 $\textit{word}_2$ 的长度。二维数组 $\textit{dp}$ 有 $m+1$ 行和 $n+1$ 列，需要对 $\textit{dp}$ 中的每个元素进行计算。

- 空间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是字符串 $\textit{word}_1$ 和 $\textit{word}_2$ 的长度。创建了 $m+1$ 行 $n+1$ 列的二维数组 $\textit{dp}$。

#### 方法二：动态规划

也可以直接使用动态规划计算最少删除操作次数，不需要计算最长公共子序列的长度。

假设字符串 $\textit{word}_1$ 和 $\textit{word}_2$ 的长度分别为 $m$ 和 $n$，创建 $m+1$ 行 $n+1$ 列的二维数组 $\textit{dp}$，其中 $\textit{dp}[i][j]$ 表示使 $\textit{word}_1[0:i]$ 和 $\textit{word}_2[0:j]$ 相同的最少删除操作次数。

> 上述表示中，$\textit{word}_1[0:i]$ 表示 $\textit{word}_1$ 的长度为 $i$ 的前缀，$\textit{word}_2[0:j]$ 表示 $\textit{word}_2$ 的长度为 $j$ 的前缀。

动态规划的边界情况如下：

- 当 $i=0$ 时，$\textit{word}_1[0:i]$ 为空，空字符串和任何字符串要变成相同，只有将另一个字符串的字符全部删除，因此对任意 $0 \le j \le n$，有 $\textit{dp}[0][j]=j$；

- 当 $j=0$ 时，$\textit{word}_2[0:j]$ 为空，同理可得，对任意 $0 \le i \le m$，有 $\textit{dp}[i][0]=i$。

当 $i>0$ 且 $j>0$ 时，考虑 $\textit{dp}[i][j]$ 的计算：

- 当 $\textit{word}_1[i-1]=\textit{word}_2[j-1]$ 时，将这两个相同的字符称为公共字符，考虑使 $\textit{word}_1[0:i-1]$ 和 $\textit{word}_2[0:j-1]$ 相同的最少删除操作次数，增加一个公共字符之后，最少删除操作次数不变，因此 $\textit{dp}[i][j]=\textit{dp}[i-1][j-1]$。

- 当 $\textit{word}_1[i-1] \ne \textit{word}_2[j-1]$ 时，考虑以下两项：

   - 使 $\textit{word}_1[0:i-1]$ 和 $\textit{word}_2[0:j]$ 相同的最少删除操作次数，加上删除 $\textit{word}_1[i-1]$ 的 $1$ 次操作；

   - 使 $\textit{word}_1[0:i]$ 和 $\textit{word}_2[0:j-1]$ 相同的最少删除操作次数，加上删除 $\textit{word}_2[j-1]$ 的 $1$ 次操作。

   要得到使 $\textit{word}_1[0:i]$ 和 $\textit{word}_2[0:j]$ 相同的最少删除操作次数，应取两项中较小的一项，因此 $\textit{dp}[i][j]=\min(\textit{dp}[i-1][j]+1,\textit{dp}[i][j-1]+1)=\min(\textit{dp}[i-1][j],\textit{dp}[i][j-1])+1$。

由此可以得到如下状态转移方程：

$$
\textit{dp}[i][j] = \begin{cases}
\textit{dp}[i-1][j-1], & \textit{word}_1[i-1]=\textit{word}_2[j-1] \\
\min(\textit{dp}[i-1][j],\textit{dp}[i][j-1])+1, & \textit{word}_1[i-1] \ne \textit{word}_2[j-1]
\end{cases}
$$

最终计算得到 $\textit{dp}[m][n]$ 即为使 $\textit{word}_1$ 和 $\textit{word}_2$ 相同的最少删除操作次数。

```Java [sol2-Java]
class Solution {
    public int minDistance(String word1, String word2) {
        int m = word1.length(), n = word2.length();
        int[][] dp = new int[m + 1][n + 1];
        for (int i = 1; i <= m; i++) {
            dp[i][0] = i;
        }
        for (int j = 1; j <= n; j++) {
            dp[0][j] = j;
        }
        for (int i = 1; i <= m; i++) {
            char c1 = word1.charAt(i - 1);
            for (int j = 1; j <= n; j++) {
                char c2 = word2.charAt(j - 1);
                if (c1 == c2) {
                    dp[i][j] = dp[i - 1][j - 1];
                } else {
                    dp[i][j] = Math.min(dp[i - 1][j], dp[i][j - 1]) + 1;
                }
            }
        }
        return dp[m][n];
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MinDistance(string word1, string word2) {
        int m = word1.Length, n = word2.Length;
        int[,] dp = new int[m + 1, n + 1];
        for (int i = 1; i <= m; i++) {
            dp[i, 0] = i;
        }
        for (int j = 1; j <= n; j++) {
            dp[0, j] = j;
        }
        for (int i = 1; i <= m; i++) {
            char c1 = word1[i - 1];
            for (int j = 1; j <= n; j++) {
                char c2 = word2[j - 1];
                if (c1 == c2) {
                    dp[i, j] = dp[i - 1, j - 1];
                } else {
                    dp[i, j] = Math.Min(dp[i - 1, j], dp[i, j - 1]) + 1;
                }
            }
        }
        return dp[m, n];
    }
}
```

```JavaScript [sol2-JavaScript]
var minDistance = function(word1, word2) {
    const m = word1.length, n = word2.length;
    const dp = new Array(m + 1).fill(0).map(() => new Array(n + 1).fill(0));
    for (let i = 1; i <= m; i++) {
        dp[i][0] = i;
    }
    for (let j = 1; j <= n; j++) {
        dp[0][j] = j;
    }
    for (let i = 1; i <= m; i++) {
        const c1 = word1[i - 1];
        for (let j = 1; j <= n; j++) {
            const c2 = word2[j - 1];
            if (c1 === c2) {
                dp[i][j] = dp[i - 1][j - 1];
            } else {
                dp[i][j] = Math.min(dp[i - 1][j], dp[i][j - 1]) + 1;
            }
        }
    }
    return dp[m][n];
};
```

```Python [sol2-Python3]
class Solution:
    def minDistance(self, word1: str, word2: str) -> int:
        m, n = len(word1), len(word2)
        dp = [[0] * (n + 1) for _ in range(m + 1)]
        for i in range(1, m + 1):
            dp[i][0] = i
        for j in range(1, n + 1):
            dp[0][j] = j

        for i in range(1, m + 1):
            for j in range(1, n + 1):
                if word1[i - 1] == word2[j - 1]:
                    dp[i][j] = dp[i - 1][j - 1]
                else:
                    dp[i][j] = min(dp[i - 1][j], dp[i][j - 1]) + 1
        
        return dp[m][n]
```

```C++ [sol2-C++]
class Solution {
public:
    int minDistance(string word1, string word2) {
        int m = word1.size();
        int n = word2.size();
        vector<vector<int>> dp(m + 1, vector<int>(n + 1));

        for (int i = 1; i <= m; ++i) {
            dp[i][0] = i;
        }
        for (int j = 1; j <= n; ++j) {
            dp[0][j] = j;
        }
        for (int i = 1; i <= m; i++) {
            char c1 = word1[i - 1];
            for (int j = 1; j <= n; j++) {
                char c2 = word2[j - 1];
                if (c1 == c2) {
                    dp[i][j] = dp[i - 1][j - 1];
                } else {
                    dp[i][j] = min(dp[i - 1][j], dp[i][j - 1]) + 1;
                }
            }
        }

        return dp[m][n];
    }
};
```

```go [sol2-Golang]
func minDistance(word1, word2 string) int {
    m, n := len(word1), len(word2)
    dp := make([][]int, m+1)
    for i := range dp {
        dp[i] = make([]int, n+1)
        dp[i][0] = i
    }
    for j := range dp[0] {
        dp[0][j] = j
    }
    for i, c1 := range word1 {
        for j, c2 := range word2 {
            if c1 == c2 {
                dp[i+1][j+1] = dp[i][j]
            } else {
                dp[i+1][j+1] = min(dp[i][j+1], dp[i+1][j]) + 1
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

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是字符串 $\textit{word}_1$ 和 $\textit{word}_2$ 的长度。二维数组 $\textit{dp}$ 有 $m+1$ 行和 $n+1$ 列，需要对 $\textit{dp}$ 中的每个元素进行计算。

- 空间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是字符串 $\textit{word}_1$ 和 $\textit{word}_2$ 的长度。创建了 $m+1$ 行 $n+1$ 列的二维数组 $\textit{dp}$。
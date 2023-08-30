#### 方法一：动态规划

这道题和经典的背包问题非常相似，但是和经典的背包问题只有一种容量不同，这道题有两种容量，即选取的字符串子集中的 $0$ 和 $1$ 的数量上限。

经典的背包问题可以使用二维动态规划求解，两个维度分别是物品和容量。这道题有两种容量，因此需要使用三维动态规划求解，三个维度分别是字符串、$0$ 的容量和 $1$ 的容量。

定义三维数组 $\textit{dp}$，其中 $\textit{dp}[i][j][k]$ 表示在前 $i$ 个字符串中，使用 $j$ 个 $0$ 和 $k$ 个 $1$ 的情况下最多可以得到的字符串数量。假设数组 $\textit{str}$ 的长度为 $l$，则最终答案为 $\textit{dp}[l][m][n]$。

当没有任何字符串可以使用时，可以得到的字符串数量只能是 $0$，因此动态规划的边界条件是：当 $i=0$ 时，对任意 $0 \le j \le m$ 和 $0 \le k \le n$，都有 $\textit{dp}[i][j][k]=0$。

当 $1 \le i \le l$ 时，对于 $\textit{strs}$ 中的第 $i$ 个字符串（计数从 $1$ 开始），首先遍历该字符串得到其中的 $0$ 和 $1$ 的数量，分别记为 $\textit{zeros}$ 和 $\textit{ones}$，然后对于 $0 \le j \le m$ 和 $0 \le k \le n$，计算 $\textit{dp}[i][j][k]$ 的值。

当 $0$ 和 $1$ 的容量分别是 $j$ 和 $k$ 时，考虑以下两种情况：

- 如果 $j < \textit{zeros}$ 或 $k < \textit{ones}$，则不能选第 $i$ 个字符串，此时有 $\textit{dp}[i][j][k] = \textit{dp}[i - 1][j][k]$；

- 如果 $j \ge \textit{zeros}$ 且 $k \ge \textit{ones}$，则如果不选第 $i$ 个字符串，有 $\textit{dp}[i][j][k] = \textit{dp}[i - 1][j][k]$，如果选第 $i$ 个字符串，有 $\textit{dp}[i][j][k] = \textit{dp}[i - 1][j - \textit{zeros}][k - \textit{ones}] + 1$，$\textit{dp}[i][j][k]$ 的值应取上面两项中的最大值。

因此状态转移方程如下：

$$
\textit{dp}[i][j][k]=\begin{cases}
\textit{dp}[i - 1][j][k], & j<\textit{zeros} ~~ | ~~ k<\textit{ones} \\
\max(\textit{dp}[i - 1][j][k], \textit{dp}[i - 1][j - \textit{zeros}][k - \textit{ones}] + 1), & j \ge \textit{zeros} ~ \& ~ k \ge \textit{ones}
\end{cases}
$$

最终得到 $\textit{dp}[l][m][n]$ 的值即为答案。

由此可以得到空间复杂度为 $O(lmn)$ 的实现。

```Java [sol1-Java]
class Solution {
    public int findMaxForm(String[] strs, int m, int n) {
        int length = strs.length;
        int[][][] dp = new int[length + 1][m + 1][n + 1];
        for (int i = 1; i <= length; i++) {
            int[] zerosOnes = getZerosOnes(strs[i - 1]);
            int zeros = zerosOnes[0], ones = zerosOnes[1];
            for (int j = 0; j <= m; j++) {
                for (int k = 0; k <= n; k++) {
                    dp[i][j][k] = dp[i - 1][j][k];
                    if (j >= zeros && k >= ones) {
                        dp[i][j][k] = Math.max(dp[i][j][k], dp[i - 1][j - zeros][k - ones] + 1);
                    }
                }
            }
        }
        return dp[length][m][n];
    }

    public int[] getZerosOnes(String str) {
        int[] zerosOnes = new int[2];
        int length = str.length();
        for (int i = 0; i < length; i++) {
            zerosOnes[str.charAt(i) - '0']++;
        }
        return zerosOnes;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindMaxForm(string[] strs, int m, int n) {
        int length = strs.Length;
        int[,,] dp = new int[length + 1, m + 1, n + 1];
        for (int i = 1; i <= length; i++) {
            int[] zerosOnes = GetZerosOnes(strs[i - 1]);
            int zeros = zerosOnes[0], ones = zerosOnes[1];
            for (int j = 0; j <= m; j++) {
                for (int k = 0; k <= n; k++) {
                    dp[i, j, k] = dp[i - 1, j, k];
                    if (j >= zeros && k >= ones) {
                        dp[i, j, k] = Math.Max(dp[i, j, k], dp[i - 1, j - zeros, k - ones] + 1);
                    }
                }
            }
        }
        return dp[length, m, n];
    }

    public int[] GetZerosOnes(string str) {
        int[] zerosOnes = new int[2];
        int length = str.Length;
        for (int i = 0; i < length; i++) {
            zerosOnes[str[i] - '0']++;
        }
        return zerosOnes;
    }
}
```

```JavaScript [sol1-JavaScript]
var findMaxForm = function(strs, m, n) {
    const length = strs.length;
    const dp = new Array(length + 1).fill(0).map(() => new Array(m + 1).fill(0).map(() => new Array(n + 1).fill(0)));
    for (let i = 1; i <= length; i++) {
        const zerosOnes = getZerosOnes(strs[i - 1]);
        let zeros = zerosOnes[0], ones = zerosOnes[1];
        for (let j = 0; j <= m; j++) {
            for (let k = 0; k <= n; k++) {
                dp[i][j][k] = dp[i - 1][j][k];
                if (j >= zeros && k >= ones) {
                    dp[i][j][k] = Math.max(dp[i][j][k], dp[i - 1][j - zeros][k - ones] + 1);
                }
            }
        }
    }
    return dp[length][m][n];
};

const getZerosOnes = (str) => {
    const zerosOnes = new Array(2).fill(0);
    const length = str.length;
    for (let i = 0; i < length; i++) {
        zerosOnes[str[i].charCodeAt() - '0'.charCodeAt()]++;
    }
    return zerosOnes;

}
```

```go [sol1-Golang]
func findMaxForm(strs []string, m, n int) int {
    length := len(strs)
    dp := make([][][]int, length+1)
    for i := range dp {
        dp[i] = make([][]int, m+1)
        for j := range dp[i] {
            dp[i][j] = make([]int, n+1)
        }
    }
    for i, s := range strs {
        zeros := strings.Count(s, "0")
        ones := len(s) - zeros
        for j := 0; j <= m; j++ {
            for k := 0; k <= n; k++ {
                dp[i+1][j][k] = dp[i][j][k]
                if j >= zeros && k >= ones {
                    dp[i+1][j][k] = max(dp[i+1][j][k], dp[i][j-zeros][k-ones]+1)
                }
            }
        }
    }
    return dp[length][m][n]
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
    vector<int> getZerosOnes(string& str) {
        vector<int> zerosOnes(2);
        int length = str.length();
        for (int i = 0; i < length; i++) {
            zerosOnes[str[i] - '0']++;
        }
        return zerosOnes;
    }

    int findMaxForm(vector<string>& strs, int m, int n) {
        int length = strs.size();
        vector<vector<vector<int>>> dp(length + 1, vector<vector<int>>(m + 1, vector<int>(n + 1)));
        for (int i = 1; i <= length; i++) {
            vector<int>&& zerosOnes = getZerosOnes(strs[i - 1]);
            int zeros = zerosOnes[0], ones = zerosOnes[1];
            for (int j = 0; j <= m; j++) {
                for (int k = 0; k <= n; k++) {
                    dp[i][j][k] = dp[i - 1][j][k];
                    if (j >= zeros && k >= ones) {
                        dp[i][j][k] = max(dp[i][j][k], dp[i - 1][j - zeros][k - ones] + 1);
                    }
                }
            }
        }
        return dp[length][m][n];
    }
};
```

```C [sol1-C]
void getZerosOnes(int* zerosOnes, char* str) {
    int length = strlen(str);
    for (int i = 0; i < length; i++) {
        zerosOnes[str[i] - '0']++;
    }
}

int findMaxForm(char** strs, int strsSize, int m, int n) {
    int length = strsSize;
    int dp[length + 1][m + 1][n + 1];
    memset(dp, 0, sizeof(dp));
    for (int i = 1; i <= length; i++) {
        int zerosOnes[2];
        memset(zerosOnes, 0, sizeof(zerosOnes));
        getZerosOnes(zerosOnes, strs[i - 1]);
        int zeros = zerosOnes[0], ones = zerosOnes[1];
        for (int j = 0; j <= m; j++) {
            for (int k = 0; k <= n; k++) {
                dp[i][j][k] = dp[i - 1][j][k];
                if (j >= zeros && k >= ones) {
                    dp[i][j][k] = fmax(dp[i][j][k], dp[i - 1][j - zeros][k - ones] + 1);
                }
            }
        }
    }
    return dp[length][m][n];
}
```

由于 $\textit{dp}[i][][]$ 的每个元素值的计算只和 $\textit{dp}[i-1][][]$ 的元素值有关，因此可以使用滚动数组的方式，去掉 $\textit{dp}$ 的第一个维度，将空间复杂度优化到 $O(mn)$。

实现时，内层循环需采用倒序遍历的方式，这种方式保证转移来的是 $\textit{dp}[i-1][][]$ 中的元素值。

```Java [sol2-Java]
class Solution {
    public int findMaxForm(String[] strs, int m, int n) {
        int[][] dp = new int[m + 1][n + 1];
        int length = strs.length;
        for (int i = 0; i < length; i++) {
            int[] zerosOnes = getZerosOnes(strs[i]);
            int zeros = zerosOnes[0], ones = zerosOnes[1];
            for (int j = m; j >= zeros; j--) {
                for (int k = n; k >= ones; k--) {
                    dp[j][k] = Math.max(dp[j][k], dp[j - zeros][k - ones] + 1);
                }
            }
        }
        return dp[m][n];
    }

    public int[] getZerosOnes(String str) {
        int[] zerosOnes = new int[2];
        int length = str.length();
        for (int i = 0; i < length; i++) {
            zerosOnes[str.charAt(i) - '0']++;
        }
        return zerosOnes;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int FindMaxForm(string[] strs, int m, int n) {
        int[,] dp = new int[m + 1, n + 1];
        int length = strs.Length;
        for (int i = 0; i < length; i++) {
            int[] zerosOnes = GetZerosOnes(strs[i]);
            int zeros = zerosOnes[0], ones = zerosOnes[1];
            for (int j = m; j >= zeros; j--) {
                for (int k = n; k >= ones; k--) {
                    dp[j, k] = Math.Max(dp[j, k], dp[j - zeros, k - ones] + 1);
                }
            }
        }
        return dp[m, n];
    }

    public int[] GetZerosOnes(string str) {
        int[] zerosOnes = new int[2];
        int length = str.Length;
        for (int i = 0; i < length; i++) {
            zerosOnes[str[i] - '0']++;
        }
        return zerosOnes;
    }
}
```

```JavaScript [sol2-JavaScript]
var findMaxForm = function(strs, m, n) {
    const dp = new Array(m + 1).fill(0).map(() => new Array(n + 1).fill(0));
    const length = strs.length;
    for (let i = 0; i < length; i++) {
        const zerosOnes = getZerosOnes(strs[i]);
        const zeros = zerosOnes[0], ones = zerosOnes[1];
        for (let j = m; j >= zeros; j--) {
            for (let k = n; k >= ones; k--) {
                dp[j][k] = Math.max(dp[j][k], dp[j - zeros][k - ones] + 1);
            }
        }
    }
    return dp[m][n];
};

const getZerosOnes = (str) => {
    const zerosOnes = new Array(2).fill(0);
    const length = str.length;
    for (let i = 0; i < length; i++) {
        zerosOnes[str[i].charCodeAt() - '0'.charCodeAt()]++;
    }
    return zerosOnes;
}
```

```go [sol2-Golang]
func findMaxForm(strs []string, m, n int) int {
    dp := make([][]int, m+1)
    for i := range dp {
        dp[i] = make([]int, n+1)
    }
    for _, s := range strs {
        zeros := strings.Count(s, "0")
        ones := len(s) - zeros
        for j := m; j >= zeros; j-- {
            for k := n; k >= ones; k-- {
                dp[j][k] = max(dp[j][k], dp[j-zeros][k-ones]+1)
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

```C++ [sol2-C++]
class Solution {
public:
    vector<int> getZerosOnes(string& str) {
        vector<int> zerosOnes(2);
        int length = str.length();
        for (int i = 0; i < length; i++) {
            zerosOnes[str[i] - '0']++;
        }
        return zerosOnes;
    }

    int findMaxForm(vector<string>& strs, int m, int n) {
        int length = strs.size();
        vector<vector<int>> dp(m + 1, vector<int>(n + 1));
        for (int i = 0; i < length; i++) {
            vector<int>&& zerosOnes = getZerosOnes(strs[i]);
            int zeros = zerosOnes[0], ones = zerosOnes[1];
            for (int j = m; j >= zeros; j--) {
                for (int k = n; k >= ones; k--) {
                    dp[j][k] = max(dp[j][k], dp[j - zeros][k - ones] + 1);
                }
            }
        }
        return dp[m][n];
    }
};
```

```C [sol2-C]
void getZerosOnes(int* zerosOnes, char* str) {
    int length = strlen(str);
    for (int i = 0; i < length; i++) {
        zerosOnes[str[i] - '0']++;
    }
}

int findMaxForm(char** strs, int strsSize, int m, int n) {
    int length = strsSize;
    int dp[m + 1][n + 1];
    memset(dp, 0, sizeof(dp));
    for (int i = 0; i < length; i++) {
        int zerosOnes[2];
        memset(zerosOnes, 0, sizeof(zerosOnes));
        getZerosOnes(zerosOnes, strs[i]);
        int zeros = zerosOnes[0], ones = zerosOnes[1];
        for (int j = m; j >= zeros; j--) {
            for (int k = n; k >= ones; k--) {
                dp[j][k] = fmax(dp[j][k], dp[j - zeros][k - ones] + 1);
            }
        }
    }
    return dp[m][n];
}
```

**复杂度分析**

- 时间复杂度：$O(lmn + L)$，其中 $l$ 是数组 $\textit{strs}$ 的长度，$m$ 和 $n$ 分别是 $0$ 和 $1$ 的容量，$L$ 是数组 $\textit{strs}$ 中的所有字符串的长度之和。
   动态规划需要计算的状态总数是 $O(lmn)$，每个状态的值需要 $O(1)$ 的时间计算。
   对于数组 $\textit{strs}$ 中的每个字符串，都要遍历字符串得到其中的 $0$ 和 $1$ 的数量，因此需要 $O(L)$ 的时间遍历所有的字符串。
   总时间复杂度是 $O(lmn + L)$。

- 空间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是 $0$ 和 $1$ 的容量。使用空间优化的实现，需要创建 $m+1$ 行 $n+1$ 列的二维数组 $\textit{dp}$。
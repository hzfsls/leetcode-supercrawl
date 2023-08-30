#### 方法一：动态规划（使用三维数组）

**思路与算法**

显然每一个「回文序列」都满足开头和结尾的字符相同。那么我们设给定字符串为 $s$，长度为 $n$，状态 $\textit{dp}(x,i,j)$ 表示在字符串区间 $s[i:j]$ 中以字符 $x$ 为开头和结尾的不同「回文序列」总数，其中 $s[i:j]$ 表示字符串 $s$ 从下标 $i$ 到下标 $j$ 的子串（包含下标 $i$ 和下标 $j$）。那么最终我们需要求的答案就转化为了 $(\sum_{i=0}^C\textit{dp}(x_i,0,n-1)) \bmod 1000000007$，其中 $x_i \in S$，$S$ 为题目给定的的字符集合，$C$ 为该字符集合的大小。

我们思考如何求解各个状态：

1. 当 $s[i]=x$ 且 $s[j]=x$ 时，那么对于 $s[i+1:j-1]$ 中的任意一个「回文序列」在头尾加上字符 $x$ 都会生成一个新的以字符 $x$ 为开头结尾的「回文序列」，并加上 $xx$ 和 $x$ 两个单独的「回文序列」。下式中，由于 $x_k$ 不同的「回文序列」一定互不相同，因此可以直接累加，无需考虑去重。
   $$\textit{dp}(x,i,j) = 2 + \sum_{k=0}^C{\textit{dp}(x_k,i + 1,j - 1)}$$
2. 当 $s[i]=x$ 且 $s[j] \neq x$ 时，那么 $\textit{dp}(x,i,j)$ 等价于 $\textit{dp}(x,i,j-1)$。
   $$\textit{dp}(x,i,j) = \textit{dp}(x,i,j-1)$$
3. 当 $s[i] \neq x$ 且 $s[j]=x$ 时，那么 $\textit{dp}(x,i,j)$ 等价于 $\textit{dp}(x,i+1,j)$。
   $$\textit{dp}(x,i,j) = \textit{dp}(x,i+1,j)$$
4. 当 $s[i] \neq x$ 且 $s[j] \neq x$ 时，那么 $\textit{dp}(x,i,j)$ 等价于 $\textit{dp}(x,i+1,j-1)$。
   $$\textit{dp}(x,i,j) = \textit{dp}(x,i+1,j-1)$$

上文的讨论是建立在字符串长度大于 $\text{1}$ 的前提上的，我们还需要考虑动态规划的边界条件，即字符串长度为 $\text{1}$ 或者不存在的情况。对于长度为 $\text{1}$ 的字符串，它显然只有本身这一个「回文序列」。对于字符串不存在的情况，那么肯定不存在任何「回文序列」子串。因此我们就可以写出动态规划的边界条件：

$$
\textit{dp}(c,i,j) = \begin{cases}
1, & i = j \And s[i] = c \\
0, & i = j \And s[i] \ne c \\
0, & i > j \\
\end{cases}
$$

可以看到每一个区间上的求解都与其小区间的求解有关，所以我们可以采用「自底向上」的编码方式来实现求解过程。最终返回 $(\sum_{i=0}^C\textit{dp}(x_i,0,n-1)) \bmod 1000000007$ 即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def countPalindromicSubsequences(self, s: str) -> int:
        MOD = 10 ** 9 + 7
        n = len(s)
        dp = [[[0] * n for _ in range(n)] for _ in range(4)]
        for i, c in enumerate(s):
            dp[ord(c) - ord('a')][i][i] = 1

        for sz in range(2, n + 1):
            for j in range(sz - 1, n):
                i = j - sz + 1
                for k, c in enumerate("abcd"):
                    if s[i] == c and s[j] == c:
                        dp[k][i][j] = (2 + sum(d[i + 1][j - 1] for d in dp)) % MOD
                    elif s[i] == c:
                        dp[k][i][j] = dp[k][i][j - 1]
                    elif s[j] == c:
                        dp[k][i][j] = dp[k][i + 1][j]
                    else:
                        dp[k][i][j] = dp[k][i + 1][j - 1]
        return sum(d[0][n - 1] for d in dp) % MOD
```

```C++ [sol1-C++]
class Solution {
public:
    const int MOD = 1e9 + 7;

    int countPalindromicSubsequences(string &s) {
        int n = s.size();
        vector<vector<vector<int>>> dp(4, vector<vector<int>>(n, vector<int>(n, 0)));
        for (int i = 0; i < n; i++) {
            dp[s[i] - 'a'][i][i] = 1;
        }

        for (int len = 2; len <= n; len++) {
            for (int i = 0, j = len - 1; j < n; i++, j++) {
                for (char c = 'a', k = 0; c <= 'd'; c++, k++) {
                    if (s[i] == c && s[j] == c) {
                        dp[k][i][j] = (2LL + dp[0][i + 1][j - 1] + dp[1][i + 1][j - 1] + dp[2][i + 1][j - 1] + dp[3][i + 1][j - 1]) % MOD;
                    } else if (s[i] == c) {
                        dp[k][i][j] = dp[k][i][j - 1];
                    } else if (s[j] == c) {
                        dp[k][i][j] = dp[k][i + 1][j];
                    } else {
                        dp[k][i][j] = dp[k][i + 1][j - 1];
                    }
                }
            }
        }

        int res = 0;
        for (int i = 0; i < 4; i++) {
            res = (res + dp[i][0][n - 1]) % MOD;
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int countPalindromicSubsequences(String s) {
        final int MOD = 1000000007;
        int n = s.length();
        int[][][] dp = new int[4][n][n];
        for (int i = 0; i < n; i++) {
            dp[s.charAt(i) - 'a'][i][i] = 1;
        }

        for (int len = 2; len <= n; len++) {
            for (int i = 0; i + len <= n; i++) {
                int j = i + len - 1;
                for (char c = 'a'; c <= 'd'; c++) {
                    int k = c - 'a';
                    if (s.charAt(i) == c && s.charAt(j) == c) {
                        dp[k][i][j] = (2 + (dp[0][i + 1][j - 1] + dp[1][i + 1][j - 1]) % MOD + (dp[2][i + 1][j - 1] + dp[3][i + 1][j - 1]) % MOD) % MOD;
                    } else if (s.charAt(i) == c) {
                        dp[k][i][j] = dp[k][i][j - 1];
                    } else if (s.charAt(j) == c) {
                        dp[k][i][j] = dp[k][i + 1][j];
                    } else {
                        dp[k][i][j] = dp[k][i + 1][j - 1];
                    }
                }
            }
        }

        int res = 0;
        for (int i = 0; i < 4; i++) {
            res = (res + dp[i][0][n - 1]) % MOD;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountPalindromicSubsequences(string s) {
        const int MOD = 1000000007;
        int n = s.Length;
        int[,,] dp = new int[4, n, n];
        for (int i = 0; i < n; i++) {
            dp[s[i] - 'a', i, i] = 1;
        }

        for (int len = 2; len <= n; len++) {
            for (int i = 0; i + len <= n; i++) {
                int j = i + len - 1;
                for (char c = 'a'; c <= 'd'; c++) {
                    int k = c - 'a';
                    if (s[i] == c && s[j] == c) {
                        dp[k, i, j] = (2 + (dp[0, i + 1, j - 1] + dp[1, i + 1, j - 1]) % MOD + (dp[2, i + 1, j - 1] + dp[3, i + 1, j - 1]) % MOD) % MOD;
                    } else if (s[i] == c) {
                        dp[k, i, j] = dp[k, i, j - 1];
                    } else if (s[j] == c) {
                        dp[k, i, j] = dp[k, i + 1, j];
                    } else {
                        dp[k, i, j] = dp[k, i + 1, j - 1];
                    }
                }
            }
        }

        int res = 0;
        for (int i = 0; i < 4; i++) {
            res = (res + dp[i, 0, n - 1]) % MOD;
        }
        return res;
    }
}
```

```C [sol1-C]
#define MOD 1000000007

int countPalindromicSubsequences(char * s){
    int n = strlen(s);
    int **dp[4];
    for (int i = 0; i < 4; i++) {
        dp[i] = (int **)malloc(sizeof(int *) * n);
        for (int j = 0; j < n; j++) {
            dp[i][j] = (int *)malloc(sizeof(int) * n);
            memset(dp[i][j], 0, sizeof(int) * n);
        }
    }
    for (int i = 0; i < n; i++) {
        dp[s[i] - 'a'][i][i] = 1;
    }

    for (int len = 2; len <= n; len++) {
        for (int i = 0; i + len <= n; i++) {
            int j = i + len - 1;
            for (char c = 'a', k = 0; c <= 'd'; c++, k++) {
                if (s[i] == c && s[j] == c) {
                    dp[k][i][j] = (2LL + dp[0][i + 1][j - 1] + dp[1][i + 1][j - 1] + dp[2][i + 1][j - 1] + dp[3][i + 1][j - 1]) % MOD;
                } else if (s[i] == c) {
                    dp[k][i][j] = dp[k][i][j - 1];
                } else if (s[j] == c) {
                    dp[k][i][j] = dp[k][i + 1][j];
                } else {
                    dp[k][i][j] = dp[k][i + 1][j - 1];
                }
            }
        }
    }

    int res = 0;
    for (int i = 0; i < 4; i++) {
        res = (res + dp[i][0][n - 1]) % MOD;
        for (int j = 0; j < n; ++j) {
            free(dp[i][j]);
        }
        free(dp[i]);
    }
    return res;
}
```

```go [sol1-Golang]
func countPalindromicSubsequences(s string) (ans int) {
    const mod int = 1e9 + 7
    n := len(s)
    dp := [4][][]int{}
    for i := range dp {
        dp[i] = make([][]int, n)
        for j := range dp[i] {
            dp[i][j] = make([]int, n)
        }
    }
    for i, c := range s {
        dp[c-'a'][i][i] = 1
    }

    for sz := 2; sz <= n; sz++ {
        for i, j := 0, sz-1; j < n; i++ {
            for k, c := 0, byte('a'); k < 4; k++ {
                if s[i] == c && s[j] == c {
                    dp[k][i][j] = (2 + dp[0][i+1][j-1] + dp[1][i+1][j-1] + dp[2][i+1][j-1] + dp[3][i+1][j-1]) % mod
                } else if s[i] == c {
                    dp[k][i][j] = dp[k][i][j-1]
                } else if s[j] == c {
                    dp[k][i][j] = dp[k][i+1][j]
                } else {
                    dp[k][i][j] = dp[k][i+1][j-1]
                }
                c++
            }
            j++
        }
    }

    for _, d := range dp {
        ans += d[0][n-1]
    }
    return ans % mod
}
```

```JavaScript [sol1-JavaScript]
var countPalindromicSubsequences = function(s) {
    const MOD = 1000000007;
    const n = s.length;
    const dp = new Array(4).fill(0).map(() => new Array(n).fill(0).map(() => new Array(n).fill(0)));
    for (let i = 0; i < n; i++) {
        dp[s[i].charCodeAt() - 'a'.charCodeAt()][i][i] = 1;
    }

    for (let len = 2; len <= n; len++) {
        for (let i = 0; i + len <= n; i++) {
            let j = i + len - 1;
            for (const c of ['a', 'b', 'c', 'd']) {
                const k = c.charCodeAt() - 'a'.charCodeAt();
                if (s[i] === c && s[j] === c) {
                    dp[k][i][j] = (2 + (dp[0][i + 1][j - 1] + dp[1][i + 1][j - 1]) % MOD + (dp[2][i + 1][j - 1] + dp[3][i + 1][j - 1]) % MOD) % MOD;
                } else if (s[i] === c) {
                    dp[k][i][j] = dp[k][i][j - 1];
                } else if (s[j] === c) {
                    dp[k][i][j] = dp[k][i + 1][j];
                } else {
                    dp[k][i][j] = dp[k][i + 1][j - 1];
                }
            }
        }
    }

    let res = 0;
    for (let i = 0; i < 4; i++) {
        res = (res + dp[i][0][n - 1]) % MOD;
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(C^2 \times n^2)$，其中 $n$ 为字符串 $s$ 的长度，$C$ 为字符串 $s$ 中的字符集大小，在本题中 $C = 4$。时间复杂度主要取决于需要求解的状态数 $C \times n^2$。在最坏的情况下，当整个字符串只有一个字符的情况下，每一个状态的求解需要 $O(C)$ 的时间开销，所以总的时间复杂度为 $O(C^2 \times n^2)$。

- 空间复杂度：$O(C \times n^2)$，其中 $n$ 为字符串 $s$ 的长度，$C$ 为字符串 $s$ 中的字符集大小，在本题中 $C = 4$。空间复杂度主要取决于动态规划模型中状态的总数。

#### 方法二：动态规划（使用二维数组）

**思路与算法**

在方法一中我们是以在某一个区间上，以某一个字符作为开头结尾的「回文序列」个数来作为状态来进行求解。而可以看到每一个状态的求解其实都只和开头和结尾都相同的区间有关。比如计算 $\textit{dp}(x,i,j)$，当 $s[i] \ne x$ 或者 $s[j] \ne x$ 时，$i$ 会向右移动到第一个满足 $s[i] = x$ 的位置，$j$ 会向左移动到第一个满足 $s[j] = x$ 的位置。

所以我们重新定义 $\textit{dp}(i,j)$ 来表示字符串区间 $s[i:j]$ 中的不同的回文序列个数。我们思考此时如何求解各个状态：

1. 当 $s[i] = s[j] = x$ 时，那么对于 $s[i+1:j-1]$ 中的任意一个「回文序列」在头尾加上字符 $x$ 都会生成一个新的以字符 $x$ 为开头结尾的「回文序列」，并加上 $xx$ 和 $x$ 两个单独的「回文序列」。那么新生成的「回文序列」个数就是 $2 + \textit{dp}(i+1,j-1)$，此时总的「回文序列」个数就是 $2 + \textit{dp}(i+1,j-1) \times 2$，然后我们分析总的「回文序列」中是否有重复的「回文序列」。
   首先我们思考什么情况才会产生重复的「回文序列」：当 $s[i:j]$ 中存在区间 $s[\textit{low}:\textit{high}]$ 使得 $s[\textit{low}] = s[\textit{high}]$ 且 $s[\textit{low}] = s[i]$ 时，对于 $s[\textit{low}+1:\textit{high}-1]$ 区间中的任意「回文序列」在求解 $\textit{dp}(\textit{low},\textit{high})$ 时都会与 $s[\textit{low}]$ 和 $s[\textit{high}]$ 生成新的回文序列，而这些「回文序列」就是此时总的「回文序列」中重复的「回文序列」。所以我们只要找到最大的区间 $s[\textit{low}:\textit{high}]$，然后减去 $\textit{dp}(low+1,high-1)$ 即可。不过需要注意当最大区间大小为 $1$ 时，此时重复的只有 $x$ 那么只需要减去 $1$ 即可。

   $$
   \textit{dp}(i,j) = \begin{cases}
   2 + \textit{dp}(i+1,j-1) \times 2, & low > high \\
   1 + \textit{dp}(i+1,j-1) \times 2, & low = high \\
   \textit{dp}(i+1,j-1) \times 2 - \textit{dp}(low+1,high-1), & low < high \\
   \end{cases}
   $$

   为了快速求得 $\textit{low}$ 和 $\textit{high}$，我们可以设 $\textit{next}(i,x)$ 表示从 $s[i]$ 开始往后下一个字符 $x$ 所在的位置，如果不存在则为 $n$，设 $\textit{pre}(i,x)$ 表示从 $s[i]$ 开始往前下一个字符 $x$ 所在的位置，如果不存在则为 $-1$。那么我们可以在 $O(C \times n)$ 的时间复杂度预处理得到 $\textit{next}$ 和 $\textit{pre}$ 数组。这样每次就可以在 $O(1)$ 的时间开销内得到对应的 $\textit{low}$ 和 $\textit{high}$。

2. 当 $s[i] \ne s[j]$ 时，根据**容斥原理**可得区间 $s[i:j]$ 内的「回文序列」的个数是区间 $s[i+1:j]$ 内的「回文序列」的个数加上区间 $s[i:j-1]$ 内的「回文序列」的个数然后减去公共区间 $s[i+1:j-1]$ 内的「回文序列」的个数:
   $$\textit{dp}(i,j) = \textit{dp}(i,j-1) + \textit{dp}(i+1,j) - \textit{dp}(i+1,j-1)$$

上文的讨论是建立在字符串长度大于 $\text{1}$ 的前提上的，我们还需要考虑动态规划的边界条件，即字符串长度为 $\text{1}$ 或者不存在的情况。对于长度为 $\text{1}$ 的字符串，它显然只有本身这一个「回文序列」。对于字符串不存在的情况，那么肯定不存在任何「回文序列」字串。因此我们就可以写出动态规划的边界条件：

$$
\textit{dp}(i,j) = \begin{cases}
1, & i = j\\
0, & i > j\\
\end{cases}
$$

可以看到每一个区间上的求解都与其小区间的求解有关，所以我们可以采用「自底向上」的编码方式来实现求解过程。最终返回 $\textit{dp}(0,n-1) \bmod 1000000007$ 即可。

**代码**

```Python [sol2-Python3]
class Solution:
    def countPalindromicSubsequences(self, s: str) -> int:
        MOD = 10 ** 9 + 7
        n = len(s)
        dp = [[0] * n for _ in range(n)]
        next = [[0] * 4 for _ in range(n)]
        pre = [[0] * 4 for _ in range(n)]

        for i in range(n):
            dp[i][i] = 1

        pos = [-1] * 4

        for i in range(n):
            for c in range(4):
                pre[i][c] = pos[c]
            pos[ord(s[i]) - ord('a')] = i

        pos[0] = pos[1] = pos[2] = pos[3] = n

        for i in range(n - 1, -1, -1):
            for c in range(4):
                next[i][c] = pos[c]
            pos[ord(s[i]) - ord('a')] = i

        for sz in range(2, n + 1):
            for j in range(sz - 1, n):
                i = j - sz + 1
                if s[i] == s[j]:
                    low, high = next[i][ord(s[i]) - ord('a')], pre[j][ord(s[i]) - ord('a')]
                    if low > high:
                        dp[i][j] = (2 + dp[i + 1][j - 1] * 2) % MOD
                    elif low == high:
                        dp[i][j] = (1 + dp[i + 1][j - 1] * 2) % MOD
                    else:
                        dp[i][j] = (dp[i + 1][j - 1] * 2 - dp[low + 1][high - 1]) % MOD
                else:
                    dp[i][j] = (dp[i + 1][j] + dp[i][j - 1] - dp[i + 1][j - 1]) % MOD
        return dp[0][n - 1]
```

```C++ [sol2-C++]
class Solution {
public:
    const int MOD = 1e9 + 7;

    int countPalindromicSubsequences(string s) {
        int n = s.size();
        vector<vector<int>> dp(n, vector<int>(n));
        vector<vector<int>> next(n, vector<int>(4));
        vector<vector<int>> pre(n, vector<int>(4));

        for (int i = 0; i < n; i++) {
            dp[i][i] = 1;
        }

        vector<int> pos(4, -1);

        for (int i = 0; i < n; i++) {
            for (int c = 0; c < 4; c++) {
                pre[i][c] = pos[c];
            }
            pos[s[i] - 'a'] = i;
        }

        pos[0] = pos[1] = pos[2] = pos[3] = n;

        for (int i = n - 1; i >= 0; i--) {
            for (int c = 0; c < 4; c++) {
                next[i][c] = pos[c];
            }
            pos[s[i] - 'a'] = i;
        }

        for (int len = 2; len <= n; len++) {
            for (int i = 0; i + len <= n; i++) {
                int j = i + len - 1;
                if (s[i] == s[j]) {
                    int low = next[i][s[i] - 'a'];
                    int high = pre[j][s[i] - 'a'];
                    if (low > high) {
                        dp[i][j] = (2 + dp[i + 1][j - 1] * 2) % MOD;
                    } else if (low == high) {
                        dp[i][j] = (1 + dp[i + 1][j - 1] * 2) % MOD;
                    } else {
                        dp[i][j] = (0LL + dp[i + 1][j - 1] * 2 - dp[low + 1][high - 1] + MOD) % MOD;
                    }
                } else {
                    dp[i][j] = (0LL + dp[i + 1][j] + dp[i][j - 1] - dp[i + 1][j - 1] + MOD) % MOD;
                }
            }
        }

        return dp[0][n - 1];
    }
};
```

```Java [sol2-Java]
class Solution {
    public int countPalindromicSubsequences(String s) {
        final int MOD = 1000000007;
        int n = s.length();
        int[][] dp = new int[n][n];
        int[][] next = new int[n][4];
        int[][] pre = new int[n][4];

        for (int i = 0; i < n; i++) {
            dp[i][i] = 1;
        }

        int[] pos = new int[4];
        Arrays.fill(pos, -1);

        for (int i = 0; i < n; i++) {
            for (int c = 0; c < 4; c++) {
                pre[i][c] = pos[c];
            }
            pos[s.charAt(i) - 'a'] = i;
        }

        pos[0] = pos[1] = pos[2] = pos[3] = n;

        for (int i = n - 1; i >= 0; i--) {
            for (int c = 0; c < 4; c++) {
                next[i][c] = pos[c];
            }
            pos[s.charAt(i) - 'a'] = i;
        }

        for (int len = 2; len <= n; len++) {
            for (int i = 0; i + len <= n; i++) {
                int j = i + len - 1;
                if (s.charAt(i) == s.charAt(j)) {
                    int low = next[i][s.charAt(i) - 'a'];
                    int high = pre[j][s.charAt(i) - 'a'];
                    if (low > high) {
                        dp[i][j] = (2 + dp[i + 1][j - 1] * 2) % MOD;
                    } else if (low == high) {
                        dp[i][j] = (1 + dp[i + 1][j - 1] * 2) % MOD;
                    } else {
                        dp[i][j] = (dp[i + 1][j - 1] * 2 % MOD - dp[low + 1][high - 1] + MOD) % MOD;
                    }
                } else {
                    dp[i][j] = ((dp[i + 1][j] + dp[i][j - 1]) % MOD - dp[i + 1][j - 1] + MOD) % MOD;
                }
            }
        }

        return dp[0][n - 1];
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int CountPalindromicSubsequences(string s) {
        const int MOD = 1000000007;
        int n = s.Length;
        int[,] dp = new int[n, n];
        int[,] next = new int[n, 4];
        int[,] pre = new int[n, 4];

        for (int i = 0; i < n; i++) {
            dp[i, i] = 1;
        }

        int[] pos = new int[4];
        Array.Fill(pos, -1);

        for (int i = 0; i < n; i++) {
            for (int c = 0; c < 4; c++) {
                pre[i, c] = pos[c];
            }
            pos[s[i] - 'a'] = i;
        }

        pos[0] = pos[1] = pos[2] = pos[3] = n;

        for (int i = n - 1; i >= 0; i--) {
            for (int c = 0; c < 4; c++) {
                next[i, c] = pos[c];
            }
            pos[s[i] - 'a'] = i;
        }

        for (int len = 2; len <= n; len++) {
            for (int i = 0; i + len <= n; i++) {
                int j = i + len - 1;
                if (s[i] == s[j]) {
                    int low = next[i, s[i] - 'a'];
                    int high = pre[j, s[i] - 'a'];
                    if (low > high) {
                        dp[i, j] = (2 + dp[i + 1, j - 1] * 2) % MOD;
                    } else if (low == high) {
                        dp[i, j] = (1 + dp[i + 1, j - 1] * 2) % MOD;
                    } else {
                        dp[i, j] = (dp[i + 1, j - 1] * 2 % MOD - dp[low + 1, high - 1] + MOD) % MOD;
                    }
                } else {
                    dp[i, j] = ((dp[i + 1, j] + dp[i, j - 1]) % MOD - dp[i + 1, j - 1] + MOD) % MOD;
                }
            }
        }

        return dp[0, n - 1];
    }
}
```

```C [sol2-C]
#define MOD 1000000007

int countPalindromicSubsequences(char * s){
    int n = strlen(s);
    int **dp = NULL;
    dp = (int **)malloc(sizeof(int *) * n);
    int **next = NULL;
    next = (int **)malloc(sizeof(int *) * n);
    int **pre = NULL;
    pre = (int **)malloc(sizeof(int *) * n);
    for (int i = 0; i < n; i++) {
        dp[i] = (int *)malloc(sizeof(int) * n);
        memset(dp[i], 0, sizeof(int) * n);
        dp[i][i] = 1;
        next[i] = (int *)malloc(sizeof(int) * 4);
        pre[i] = (int *)malloc(sizeof(int) * 4);
    }

    int pos[4];
    pos[0] = pos[1] = pos[2] = pos[3] = -1;

    for (int i = 0; i < n; i++) {
        for (int c = 0; c < 4; c++) {
            pre[i][c] = pos[c];
        }
        pos[s[i] - 'a'] = i;
    }

    pos[0] = pos[1] = pos[2] = pos[3] = n;

    for (int i = n - 1; i >= 0; i--) {
        for (int c = 0; c < 4; c++) {
            next[i][c] = pos[c];
        }
        pos[s[i] - 'a'] = i;
    }

    for (int len = 2; len <= n; len++) {
        for (int i = 0; i + len <= n; i++) {
            int j = i + len - 1;
            if (s[i] == s[j]) {
                int low = next[i][s[i] - 'a'];
                int high = pre[j][s[i] - 'a'];
                if (low > high) {
                    dp[i][j] = (2 + dp[i + 1][j - 1] * 2) % MOD;
                } else if (low == high) {
                    dp[i][j] = (1 + dp[i + 1][j - 1] * 2) % MOD;
                } else {
                    dp[i][j] = (0LL + dp[i + 1][j - 1] * 2 - dp[low + 1][high - 1] + MOD) % MOD;
                }
            } else {
                dp[i][j] = (0LL + dp[i + 1][j] + dp[i][j - 1] - dp[i + 1][j - 1] + MOD) % MOD;
            }
        }
    }

    int res = dp[0][n - 1];
    for (int i = 0; i < n; i++) {
        free(dp[i]);
    }
    free(dp);
    return res;
}
```

```go [sol2-Golang]
func countPalindromicSubsequences(s string) (ans int) {
    const mod int = 1e9 + 7
    n := len(s)
    dp := make([][]int, n)
    next := make([][]int, n)
    pre := make([][]int, n)
    for i := range dp {
        dp[i] = make([]int, n)
        dp[i][i] = 1
        next[i] = make([]int, 4)
        pre[i] = make([]int, 4)
    }

    pos := make([]int, 4)
    for i := 0; i < 4; i++ {
        pos[i] = -1
    }

    for i := 0; i < n; i++ {
        for c := 0; c < 4; c++ {
            pre[i][c] = pos[c]
        }
        pos[s[i]-'a'] = i
    }

    for i := 0; i < 4; i++ {
        pos[i] = n
    }

    for i := n-1; i >= 0; i-- {
        for c := 0; c < 4; c++ {
            next[i][c] = pos[c]
        }
        pos[s[i]-'a'] = i
    }

    for sz := 2; sz <= n; sz++ {
        for i, j := 0, sz-1; j < n; i++ {
            if s[i] == s[j] {
                low, high := next[i][s[i]-'a'], pre[j][s[i]-'a']
                if low > high {
                    dp[i][j] = (2 + dp[i+1][j-1]*2) % mod
                } else if low == high {
                    dp[i][j] = (1 + dp[i+1][j-1]*2) % mod
                } else {
                    dp[i][j] = (dp[i+1][j-1]*2 - dp[low+1][high-1] + mod) % mod
                }
            } else {
                dp[i][j] = (dp[i+1][j] + dp[i][j-1] - dp[i+1][j-1] + mod) % mod
            }
            j++
        }
    }

    return dp[0][n-1]
}
```

```JavaScript [sol2-JavaScript]
var countPalindromicSubsequences = function(s) {
    const MOD = 1000000007;
    const n = s.length;
    const dp = new Array(n).fill(0).map(() => new Array(n).fill(0));
    const next = new Array(n).fill(0).map(() => new Array(4).fill(0));
    const pre = new Array(n).fill(0).map(() => new Array(4).fill(0));

    for (let i = 0; i < n; i++) {
        dp[i][i] = 1;
    }

    const pos = new Array(n);
    pos[0] = pos[1] = pos[2] = pos[3] = -1;

    for (let i = 0; i < n; i++) {
        for (let c = 0; c < 4; c++) {
            pre[i][c] = pos[c];
        }
        pos[s[i].charCodeAt() - 'a'.charCodeAt()] = i;
    }

    pos[0] = pos[1] = pos[2] = pos[3] = n;

    for (let i = n - 1; i >= 0; i--) {
        for (let c = 0; c < 4; c++) {
            next[i][c] = pos[c];
        }
        pos[s[i].charCodeAt() - 'a'.charCodeAt()] = i;
    }

    for (let len = 2; len <= n; len++) {
        for (let i = 0; i + len <= n; i++) {
            let j = i + len - 1;
            if (s[i] === s[j]) {
                let low = next[i][s[i].charCodeAt() - 'a'.charCodeAt()];
                let high = pre[j][s[i].charCodeAt() - 'a'.charCodeAt()];
                if (low > high) {
                    dp[i][j] = (2 + dp[i + 1][j - 1] * 2) % MOD;
                } else if (low === high) {
                    dp[i][j] = (1 + dp[i + 1][j - 1] * 2) % MOD;
                } else {
                    dp[i][j] = (dp[i + 1][j - 1] * 2 % MOD - dp[low + 1][high - 1] + MOD) % MOD;
                }
            } else {
                dp[i][j] = ((dp[i + 1][j] + dp[i][j - 1]) % MOD - dp[i + 1][j - 1] + MOD) % MOD;
            }
        }
    }

    return dp[0][n - 1];
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 为字符串 $s$ 的长度。在预处理 $\textit{next}$ 和 $\textit{pre}$ 数组时的开销为 $O(C \times n)$，每次求 $\textit{low}$ 和 $\textit{high}$ 的开销为 $O(1)$，所以总的时间复杂度主要取决于需要求解的状态数 $n^2$。

- 空间复杂度：$O(n^2)$，其中 $n$ 为字符串 $s$ 的长度。空间复杂度主要取决于动态规划模型中状态的总数。
## [132.分割回文串 II 中文官方题解](https://leetcode.cn/problems/palindrome-partitioning-ii/solutions/100000/fen-ge-hui-wen-chuan-ii-by-leetcode-solu-norx)
#### 方法一：动态规划

**思路与算法**

设 $f[i]$ 表示字符串的前缀 $s[0..i]$ 的**最少**分割次数。要想得出 $f[i]$ 的值，我们可以考虑枚举 $s[0..i]$ 分割出的最后一个回文串，这样我们就可以写出状态转移方程：

$$
f[i] = \min_{0 \leq j < i} \{ f[j] \} + 1, \quad 其中 ~ s[j+1..i] ~是一个回文串
$$

即我们枚举最后一个回文串的起始位置 $j+1$，保证 $s[j+1..i]$ 是一个回文串，那么 $f[i]$ 就可以从 $f[j]$ 转移而来，附加 $1$ 次额外的分割次数。

注意到上面的状态转移方程中，我们还少考虑了一种情况，即 $s[0..i]$ 本身就是一个回文串。此时其不需要进行任何分割，即：

$$
f[i] = 0
$$

那么我们如何知道 $s[j+1..i]$ 或者 $s[0..i]$ 是否为回文串呢？我们可以使用与「[131. 分割回文串的官方题解](https://leetcode-cn.com/problems/palindrome-partitioning/solution/fen-ge-hui-wen-chuan-by-leetcode-solutio-6jkv/)」中相同的预处理方法，将字符串 $s$ 的每个子串是否为回文串预先计算出来，即：

> 设 $g(i, j)$ 表示 $s[i..j]$ 是否为回文串，那么有状态转移方程：
>
>   $$
>   g(i, j) = \begin{cases}
>   \texttt{True}, & \quad i \geq j \\
>   g(i+1,j-1) \wedge (s[i]=s[j]), & \quad \text{otherwise}
>   \end{cases}
>   $$
>
>   其中 $\wedge$ 表示逻辑与运算，即 $s[i..j]$ 为回文串，当且仅当其为空串（$i>j$），其长度为 $1$（$i=j$），或者首尾字符相同且 $s[i+1..j-1]$ 为回文串。

这样一来，我们只需要 $O(1)$ 的时间就可以判断任意 $s[i..j]$ 是否为回文串了。通过动态规划计算出所有的 $f$ 值之后，最终的答案即为 $f[n-1]$，其中 $n$ 是字符串 $s$ 的长度。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minCut(string s) {
        int n = s.size();
        vector<vector<int>> g(n, vector<int>(n, true));

        for (int i = n - 1; i >= 0; --i) {
            for (int j = i + 1; j < n; ++j) {
                g[i][j] = (s[i] == s[j]) && g[i + 1][j - 1];
            }
        }

        vector<int> f(n, INT_MAX);
        for (int i = 0; i < n; ++i) {
            if (g[0][i]) {
                f[i] = 0;
            }
            else {
                for (int j = 0; j < i; ++j) {
                    if (g[j + 1][i]) {
                        f[i] = min(f[i], f[j] + 1);
                    }
                }
            }
        }

        return f[n - 1];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minCut(String s) {
        int n = s.length();
        boolean[][] g = new boolean[n][n];
        for (int i = 0; i < n; ++i) {
            Arrays.fill(g[i], true);
        }

        for (int i = n - 1; i >= 0; --i) {
            for (int j = i + 1; j < n; ++j) {
                g[i][j] = s.charAt(i) == s.charAt(j) && g[i + 1][j - 1];
            }
        }

        int[] f = new int[n];
        Arrays.fill(f, Integer.MAX_VALUE);
        for (int i = 0; i < n; ++i) {
            if (g[0][i]) {
                f[i] = 0;
            } else {
                for (int j = 0; j < i; ++j) {
                    if (g[j + 1][i]) {
                        f[i] = Math.min(f[i], f[j] + 1);
                    }
                }
            }
        }

        return f[n - 1];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minCut(self, s: str) -> int:
        n = len(s)
        g = [[True] * n for _ in range(n)]

        for i in range(n - 1, -1, -1):
            for j in range(i + 1, n):
                g[i][j] = (s[i] == s[j]) and g[i + 1][j - 1]

        f = [float("inf")] * n
        for i in range(n):
            if g[0][i]:
                f[i] = 0
            else:
                for j in range(i):
                    if g[j + 1][i]:
                        f[i] = min(f[i], f[j] + 1)
        
        return f[n - 1]
```

```JavaScript [sol1-JavaScript]
var minCut = function(s) {
    const n = s.length;
    const g = new Array(n).fill(0).map(() => new Array(n).fill(true));

    for (let i = n - 1; i >= 0; --i) {
        for (let j = i + 1; j < n; ++j) {
            g[i][j] = s[i] == s[j] && g[i + 1][j - 1];
        }
    }

    const f = new Array(n).fill(Number.MAX_SAFE_INTEGER);
    for (let i = 0; i < n; ++i) {
        if (g[0][i]) {
            f[i] = 0;
        } else {
            for (let j = 0; j < i; ++j) {
                if (g[j + 1][i]) {
                    f[i] = Math.min(f[i], f[j] + 1);
                }
            }
        }
    }

    return f[n - 1];
};
```

```go [sol1-Golang]
func minCut(s string) int {
    n := len(s)
    g := make([][]bool, n)
    for i := range g {
        g[i] = make([]bool, n)
        for j := range g[i] {
            g[i][j] = true
        }
    }
    for i := n - 1; i >= 0; i-- {
        for j := i + 1; j < n; j++ {
            g[i][j] = s[i] == s[j] && g[i+1][j-1]
        }
    }

    f := make([]int, n)
    for i := range f {
        if g[0][i] {
            continue
        }
        f[i] = math.MaxInt64
        for j := 0; j < i; j++ {
            if g[j+1][i] && f[j]+1 < f[i] {
                f[i] = f[j] + 1
            }
        }
    }
    return f[n-1]
}
```

```C [sol1-C]
int minCut(char* s) {
    int n = strlen(s);
    bool g[n][n];
    memset(g, 1, sizeof(g));

    for (int i = n - 1; i >= 0; --i) {
        for (int j = i + 1; j < n; ++j) {
            g[i][j] = (s[i] == s[j]) && g[i + 1][j - 1];
        }
    }

    int f[n];
    for (int i = 0; i < n; ++i) {
        f[i] = INT_MAX;
    }
    for (int i = 0; i < n; ++i) {
        if (g[0][i]) {
            f[i] = 0;
        } else {
            for (int j = 0; j < i; ++j) {
                if (g[j + 1][i]) {
                    f[i] = fmin(f[i], f[j] + 1);
                }
            }
        }
    }

    return f[n - 1];
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是字符串 $s$ 的长度。预处理计算 $g$ 和动态规划计算 $f$ 的时间复杂度均为 $O(n^2)$。

- 空间复杂度：$O(n^2)$，数组 $g$ 需要使用 $O(n^2)$ 的空间，数组 $f$ 需要使用 $O(n)$ 的空间。
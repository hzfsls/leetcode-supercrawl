## [1092.最短公共超序列 中文官方题解](https://leetcode.cn/problems/shortest-common-supersequence/solutions/100000/zui-duan-gong-gong-chao-xu-lie-by-leetco-c1tu)
#### 方法一：动态规划

**思路与算法**

首先题目给出两个字符串 $\textit{str}_1$ 和 $\textit{str}_2$，我们需要返回任意一个满足同时以 $\textit{str}_1$ 和 $\textit{str}_2$ 作为子序列的最短字符串。我们设 $\textit{str}_1$ 的长度为 $n$，$\textit{str}_2$ 的长度为 $m$，$\textit{dp}[i][j]$ 表示同时以字符串 $\textit{str}_1[i:n]$ 和 $\textit{str}_2[j:m]$ 作为子序列的最短字符串长度，其中 $\textit{str}_1[i:j]$，$\textit{str}_2[i:j]$ 表示字符串 $\textit{str}_1$，$\textit{str}_2$ 从下标 $i$ 到下标 $j$ 的子串（包含下标 $i$ 且不包含下标 $j$）。现在我们来思考如何求解各个状态：

1. 当 $\textit{str}_1[i] = \textit{str}_2[j]$ 时，以 $\textit{str}_1[i:n]$ 和 $\textit{str}_2[j:m]$ 作为子序列的最短字符串的开头字符为 $\textit{str}_1[i]$ 一定是最优的：

$$\textit{dp}[i][j] = \textit{dp}[i + 1][j + 1] + 1$$

2. 否则当 $\textit{str}_1[i] \ne \textit{str}_2[j]$ 时，以 $\textit{str}_1[i:n]$ 和 $\textit{str}_2[j:m]$ 作为子序列的最短字符串的开头字符只能为 $\textit{str}_1[i]$ 或者 $\textit{str}_2[j]$：

$$\textit{dp}[i][j] = \min\{\textit{dp}[i + 1][j], \textit{dp}[i][j + 1]\} + 1$$

上文讨论的是建立在 $i < n$ 和 $j < m$ 的前提上的，我们还需要考虑动态规划的边界条件，当 $i = n$ 或 $j = m$ 时，此时其中一个字符串为空串，同时满足以两字符串作为子序列的最短字符串长度为另一个字符串的长度。因此我们就可以写出动态规划的边界条件：

$$
\textit{dp}[i][j] = \begin{cases}
m - j, & i = n \And j < m \\
n - i, & j = m \And i < n \\
0, & i = n \And j = m \\
\end{cases}
$$

可以看到每一个区间上的求解都与其子区间的求解有关，所以我们可以采用「自底向上」的编码方式来实现求解过程。求解完毕后，此时 $\textit{dp}[0][0]$ 即为此时题目中满足同时以 $\textit{str}_1$ 和 $\textit{str}_2$ 作为子序列的最短字符串长度，然后我们可以通过双指针和通过动态规划状态来从前往后构造出具体方案。我们用指针 $t_1 = 0$ 来指向 $\textit{str}_1$ 的头部，用 $t_2 = 0$ 来指向 $\textit{str}_2$ 的头部，并根据 $\textit{dp}[i][j]$ 来从前往后构造出具体字符串方案：

1. 若 $t_1$ 到达 $\textit{str}_1$ 尾部（$t_1 = n$）或者 $t_2$ 到达 $\textit{str}_2$ 尾部（$t_2 = m$），将对应的剩下的字符加到结果字符串后面。
2. 否则：
   - 若 $\textit{str}_1[t_1] = \textit{str}_2[t_2]$，则此时结果字符串最后添加 $\textit{str}_1[t_1]$ 为最优条件，然后 $t_1$ 和 $t_2$ 指针分别往后移动一单位。
   - 否则若当 
    $$\textit{dp}[t_1 + 1][t_2] = \textit{dp}[t_1][t_2] - 1 \tag{1}$$
    向结果字符串中添加 $\textit{str}_1[t_1]$，然后 $t_1$ 指针往后移动一单位。若当
    $$\textit{dp}[t_1][t_2 + 1] = \textit{dp}[t_1][t_2] - 1 \tag{2}$$
    则向结果字符串中添加 $\textit{str}_2[t_2]$，然后 $t_2$ 指针往后移动一单位。由于我们只需要返回任一符合条件的结果字符串，所以若条件 $(1)(2)$ 都满足我们只需要取其中一种情况即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string shortestCommonSupersequence(string str1, string str2) {
        int n = str1.size(), m = str2.size();
        vector<vector<int>> dp(n + 1, vector<int>(m + 1));
        for (int i = 0; i < n; ++i) {
            dp[i][m] = n - i;
        }
        for (int i = 0; i < m; ++i) {
            dp[n][i] = m - i;
        }
        for (int i = n - 1; i >= 0; --i) {
            for (int j = m - 1; j >= 0; --j) {
                if (str1[i] == str2[j]) {
                    dp[i][j] = dp[i + 1][j + 1] + 1;
                } else {
                    dp[i][j] = min(dp[i + 1][j], dp[i][j + 1]) + 1;
                }
            }
        }
        string res;
        int t1 = 0, t2 = 0;
        while (t1 < n && t2 < m) {
            if (str1[t1] == str2[t2]) {
                res += str1[t1];
                ++t1;
                ++t2;
            } else if (dp[t1 + 1][t2] == dp[t1][t2] - 1) {
                res += str1[t1];
                ++t1;
            } else if (dp[t1][t2 + 1] == dp[t1][t2] - 1) {
                res += str2[t2];
                ++t2;
            }
        }
        if (t1 < n) {
            res += str1.substr(t1);
        }
        else if (t2 < m) {
            res += str2.substr(t2);
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String shortestCommonSupersequence(String str1, String str2) {
        int n = str1.length(), m = str2.length();
        int[][] dp = new int[n + 1][m + 1];
        for (int i = 0; i < n; ++i) {
            dp[i][m] = n - i;
        }
        for (int i = 0; i < m; ++i) {
            dp[n][i] = m - i;
        }
        for (int i = n - 1; i >= 0; --i) {
            for (int j = m - 1; j >= 0; --j) {
                if (str1.charAt(i) == str2.charAt(j)) {
                    dp[i][j] = dp[i + 1][j + 1] + 1;
                } else {
                    dp[i][j] = Math.min(dp[i + 1][j], dp[i][j + 1]) + 1;
                }
            }
        }
        StringBuilder res = new StringBuilder();
        int t1 = 0, t2 = 0;
        while (t1 < n && t2 < m) {
            if (str1.charAt(t1) == str2.charAt(t2)) {
                res.append(str1.charAt(t1));
                ++t1;
                ++t2;
            } else if (dp[t1 + 1][t2] == dp[t1][t2] - 1) {
                res.append(str1.charAt(t1));
                ++t1;
            } else if (dp[t1][t2 + 1] == dp[t1][t2] - 1) {
                res.append(str2.charAt(t2));
                ++t2;
            }
        }
        if (t1 < n) {
            res.append(str1.substring(t1));
        } else if (t2 < m) {
            res.append(str2.substring(t2));
        }
        return res.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string ShortestCommonSupersequence(string str1, string str2) {
        int n = str1.Length, m = str2.Length;
        int[][] dp = new int[n + 1][];
        for (int i = 0; i <= n; ++i) {
            dp[i] = new int[m + 1];
        }
        for (int i = 0; i < n; ++i) {
            dp[i][m] = n - i;
        }
        for (int i = 0; i < m; ++i) {
            dp[n][i] = m - i;
        }
        for (int i = n - 1; i >= 0; --i) {
            for (int j = m - 1; j >= 0; --j) {
                if (str1[i] == str2[j]) {
                    dp[i][j] = dp[i + 1][j + 1] + 1;
                } else {
                    dp[i][j] = Math.Min(dp[i + 1][j], dp[i][j + 1]) + 1;
                }
            }
        }
        StringBuilder res = new StringBuilder();
        int t1 = 0, t2 = 0;
        while (t1 < n && t2 < m) {
            if (str1[t1] == str2[t2]) {
                res.Append(str1[t1]);
                ++t1;
                ++t2;
            } else if (dp[t1 + 1][t2] == dp[t1][t2] - 1) {
                res.Append(str1[t1]);
                ++t1;
            } else if (dp[t1][t2 + 1] == dp[t1][t2] - 1) {
                res.Append(str2[t2]);
                ++t2;
            }
        }
        if (t1 < n) {
            res.Append(str1.Substring(t1));
        } else if (t2 < m) {
            res.Append(str2.Substring(t2));
        }
        return res.ToString();
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

char * shortestCommonSupersequence(char * str1, char * str2) {
    int n = strlen(str1), m = strlen(str2);
    int dp[n + 1][m + 1];
    memset(dp, 0, sizeof(dp));
    for (int i = 0; i < n; ++i) {
        dp[i][m] = n - i;
    }
    for (int i = 0; i < m; ++i) {
        dp[n][i] = m - i;
    }
    for (int i = n - 1; i >= 0; --i) {
        for (int j = m - 1; j >= 0; --j) {
            if (str1[i] == str2[j]) {
                dp[i][j] = dp[i + 1][j + 1] + 1;
            } else {
                dp[i][j] = MIN(dp[i + 1][j], dp[i][j + 1]) + 1;
            }
        }
    }
    char *res = (char *)malloc(sizeof(char) * (m + n + 1));
    int t1 = 0, t2 = 0;
    int pos = 0;
    while (t1 < n && t2 < m) {
        if (str1[t1] == str2[t2]) {
            res[pos++] = str1[t1];
            ++t1;
            ++t2;
        } else if (dp[t1 + 1][t2] == dp[t1][t2] - 1) {
            res[pos++] = str1[t1];
            ++t1;
        } else if (dp[t1][t2 + 1] == dp[t1][t2] - 1) {
            res[pos++] = str2[t2];
            ++t2;
        }
    }
    if (t1 < n) {
        sprintf(res + pos, "%s", str1 + t1);
    } else if (t2 < m) {
        sprintf(res + pos, "%s", str2 + t2);
    } else {
        res[pos] = '\0';
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var shortestCommonSupersequence = function(str1, str2) {
    const n = str1.length, m = str2.length;
    const dp = new Array(n + 1).fill(0).map(() => new Array(m + 1).fill(0));
    for (let i = 0; i < n; ++i) {
        dp[i][m] = n - i;
    }
    for (let i = 0; i < m; ++i) {
        dp[n][i] = m - i;
    }
    for (let i = n - 1; i >= 0; --i) {
        for (let j = m - 1; j >= 0; --j) {
            if (str1[i] == str2[j]) {
                dp[i][j] = dp[i + 1][j + 1] + 1;
            } else {
                dp[i][j] = Math.min(dp[i + 1][j], dp[i][j + 1]) + 1;
            }
        }
    }
    let res = '';
    let t1 = 0, t2 = 0;
    while (t1 < n && t2 < m) {
        if (str1[t1] === str2[t2]) {
            res += str1[t1];
            ++t1;
            ++t2;
        } else if (dp[t1 + 1][t2] === dp[t1][t2] - 1) {
            res += str1[t1];
            ++t1;
        } else if (dp[t1][t2 + 1] === dp[t1][t2] - 1) {
            res += str2[t2];
            ++t2;
        }
    }
    if (t1 < n) {
        res += str1.slice(t1);
    } else if (t2 < m) {
        res += str2.slice(t2);
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n \times m)$。其中预处理动态规划求解的复杂度为 $O(n \times m)$，构造具体字符串方案的复杂度为 $O(n + m)$，其中 $n$ 为字符串 $\textit{str}_1$ 的长度，$m$ 为字符串 $\textit{str}_2$ 的长度。
- 空间复杂度：$O(n \times m)$，其中 $n$ 为字符串 $\textit{str}_1$ 的长度，$m$ 为字符串 $\textit{str}_2$ 的长度。空间复杂度主要取决于动态规划模型中状态的总数。
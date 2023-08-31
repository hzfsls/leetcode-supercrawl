## [1335.工作计划的最低难度 中文官方题解](https://leetcode.cn/problems/minimum-difficulty-of-a-job-schedule/solutions/100000/gong-zuo-ji-hua-de-zui-di-nan-du-by-leet-dule)

#### 方法一：动态规划

**思路与算法**

题目给出了 $n$ 份工作，其中第 $i$ 份（工作下标从 $0$ 开始计算）工作的工作强度为 $\textit{jobDifficulty}[i]$，$0 \le i < n$。现在我们需要将 $n$ 份工作分配到 $d$ 天完成，其中每一天至少需要完成一份工作，并且在完成第 $i$ 份工作时，必须完成全部第 $j$ 份工作，$0 \le j < i$。每一天的工作难度为当天应该完成工作的最大难度，现在需要求整个工作计划的最小难度。

首先当工作份数小于 $d$ 时，因为每天至少需要完成一份工作，所以此时无法制定工作计划，直接返回 $-1$。否则我们设 $\textit{dp}[i][j]$ 表示前 $i + 1$ 天完成前 $j$ 项工作的最小难度，有：

$$\textit{dp}[i][j] = \min_{k=i-1,i,\dots,j - 1}\{\textit{dp}[i-1][k] + f(k + 1, j)\}$$

其中 $k$ 为前 $i$ 天完成的工作份数，$f(i,j)$ 表示第 $i$ 份工作到第 $j$ 份工作的最大工作强度，即：

$$f(i, j) = \max_{t = i, i + 1, \dots, j}\{\textit{jobDifficulty}[t]\}$$

以上的讨论建立在 $i > 0$ 的基础上，边界条件当 $i = 0$ 时，有：

$$\textit{dp}[i][j] = f(0, j)$$

最后我们返回 $\textit{dp}[d - 1][n - 1]$ 即可。在实现的过程中可以发现 $\textit{dp}[i]$ 的求解只与上一层状态 $\textit{dp}[i-1]$ 有关，因此我们可以通过「滚动数组」来实现编码过程中的空间优化。

**代码**

未空间优化版

```C++ [sol11-C++]
class Solution {
public:
    int minDifficulty(vector<int>& jobDifficulty, int d) {
        int n = jobDifficulty.size();
        if (n < d) {
            return -1;
        }
        vector<vector<int>> dp(d + 1, vector<int>(n, 0x3f3f3f3f));
        int ma = 0;
        for (int i = 0; i < n; ++i) {
            ma = max(ma, jobDifficulty[i]);
            dp[0][i] = ma;
        }
        for (int i = 1; i < d; ++i) {
            for (int j = i; j < n; ++j) {
                ma = 0;
                for (int k = j; k >= i; --k) {
                    ma = max(ma, jobDifficulty[k]);
                    dp[i][j] = min(dp[i][j], ma + dp[i - 1][k - 1]);
                }
            }
        }
        return dp[d - 1][n - 1];
    }
};
```

```Java [sol11-Java]
class Solution {
    public int minDifficulty(int[] jobDifficulty, int d) {
        int n = jobDifficulty.length;
        if (n < d) {
            return -1;
        }
        int[][] dp = new int[d + 1][n];
        for (int i = 0; i <= d; ++i) {
            Arrays.fill(dp[i], 0x3f3f3f3f);
        }
        int ma = 0;
        for (int i = 0; i < n; ++i) {
            ma = Math.max(ma, jobDifficulty[i]);
            dp[0][i] = ma;
        }
        for (int i = 1; i < d; ++i) {
            for (int j = i; j < n; ++j) {
                ma = 0;
                for (int k = j; k >= i; --k) {
                    ma = Math.max(ma, jobDifficulty[k]);
                    dp[i][j] = Math.min(dp[i][j], ma + dp[i - 1][k - 1]);
                }
            }
        }
        return dp[d - 1][n - 1];
    }
}
```

```C# [sol11-C#]
public class Solution {
    public int MinDifficulty(int[] jobDifficulty, int d) {
        int n = jobDifficulty.Length;
        if (n < d) {
            return -1;
        }
        int[][] dp = new int[d + 1][];
        for (int i = 0; i <= d; ++i) {
            dp[i] = new int[n];
            Array.Fill(dp[i], 0x3f3f3f3f);
        }
        int ma = 0;
        for (int i = 0; i < n; ++i) {
            ma = Math.Max(ma, jobDifficulty[i]);
            dp[0][i] = ma;
        }
        for (int i = 1; i < d; ++i) {
            for (int j = i; j < n; ++j) {
                ma = 0;
                for (int k = j; k >= i; --k) {
                    ma = Math.Max(ma, jobDifficulty[k]);
                    dp[i][j] = Math.Min(dp[i][j], ma + dp[i - 1][k - 1]);
                }
            }
        }
        return dp[d - 1][n - 1];
    }
}
```

```C [sol11-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int minDifficulty(int* jobDifficulty, int jobDifficultySize, int d) {
    int n = jobDifficultySize;
    if (n < d) {
        return -1;
    }
    int dp[n + 1][n];
    memset(dp, 0x3f, sizeof(dp));
    int ma = 0;
    for (int i = 0; i < n; ++i) {
        ma = MAX(ma, jobDifficulty[i]);
        dp[0][i] = ma;
    }
    for (int i = 1; i < d; ++i) {
        for (int j = i; j < n; ++j) {
            ma = 0;
            for (int k = j; k >= i; --k) {
                ma = MAX(ma, jobDifficulty[k]);
                dp[i][j] = MIN(dp[i][j], ma + dp[i - 1][k - 1]);
            }
        }
    }
    return dp[d - 1][n - 1];
}
```

```JavaScript [sol11-JavaScript]
var minDifficulty = function(jobDifficulty, d) {
    const n = jobDifficulty.length;
    if (n < d) {
        return -1;
    }
    const dp = new Array(d + 1).fill(0).map(() => new Array(n).fill(0x3f3f3f3f));
    let ma = 0;
    for (let i = 0; i < n; ++i) {
        ma = Math.max(ma, jobDifficulty[i]);
        dp[0][i] = ma;
    }
    for (let i = 1; i < d; ++i) {
        for (let j = i; j < n; ++j) {
            ma = 0;
            for (let k = j; k >= i; --k) {
                ma = Math.max(ma, jobDifficulty[k]);
                dp[i][j] = Math.min(dp[i][j], ma + dp[i - 1][k - 1]);
            }
        }
    }
    return dp[d - 1][n - 1];
};
```

通过「滚动数组」空间优化版

```C++ [sol12-C++]
class Solution {
public:
    int minDifficulty(vector<int>& jobDifficulty, int d) {
        int n = jobDifficulty.size();
        if (n < d) {
            return -1;
        }
        vector<int> dp(n);
        for (int i = 0, j = 0; i < n; ++i) {
            j = max(j, jobDifficulty[i]);
            dp[i] = j;
        }
        for (int i = 1; i < d; ++i) {
            vector<int> ndp(n, 0x3f3f3f3f);
            for (int j = i; j < n; ++j) {
                int ma = 0;
                for (int k = j; k >= i; --k) {
                    ma = max(ma, jobDifficulty[k]);
                    ndp[j] = min(ndp[j], ma + dp[k - 1]);
                }
            }
            swap(ndp, dp);
        }
        return dp[n - 1];
    }
};
```

```Java [sol12-Java]
class Solution {
    public int minDifficulty(int[] jobDifficulty, int d) {
        int n = jobDifficulty.length;
        if (n < d) {
            return -1;
        }
        int[] dp = new int[n];
        for (int i = 0, j = 0; i < n; ++i) {
            j = Math.max(j, jobDifficulty[i]);
            dp[i] = j;
        }
        for (int i = 1; i < d; ++i) {
            int[] ndp = new int[n];
            Arrays.fill(ndp, 0x3f3f3f3f);
            for (int j = i; j < n; ++j) {
                int ma = 0;
                for (int k = j; k >= i; --k) {
                    ma = Math.max(ma, jobDifficulty[k]);
                    ndp[j] = Math.min(ndp[j], ma + dp[k - 1]);
                }
            }
            dp = ndp;
        }
        return dp[n - 1];
    }
}
```

```C# [sol12-C#]
public class Solution {
    public int MinDifficulty(int[] jobDifficulty, int d) {
        int n = jobDifficulty.Length;
        if (n < d) {
            return -1;
        }
        int[] dp = new int[n];
        for (int i = 0, j = 0; i < n; ++i) {
            j = Math.Max(j, jobDifficulty[i]);
            dp[i] = j;
        }
        for (int i = 1; i < d; ++i) {
            int[] ndp = new int[n];
            Array.Fill(ndp, 0x3f3f3f3f);
            for (int j = i; j < n; ++j) {
                int ma = 0;
                for (int k = j; k >= i; --k) {
                    ma = Math.Max(ma, jobDifficulty[k]);
                    ndp[j] = Math.Min(ndp[j], ma + dp[k - 1]);
                }
            }
            dp = ndp;
        }
        return dp[n - 1];
    }
}
```

```C [sol12-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int minDifficulty(int* jobDifficulty, int jobDifficultySize, int d) {
    int n = jobDifficultySize;
    if (n < d) {
        return -1;
    }
    int dp[n];
    for (int i = 0, j = 0; i < n; ++i) {
        j = MAX(j, jobDifficulty[i]);
        dp[i] = j;
    }
    for (int i = 1; i < d; ++i) {
        int ndp[n];
        memset(ndp, 0x3f, sizeof(ndp));
        for (int j = i; j < n; ++j) {
            int ma = 0;
            for (int k = j; k >= i; --k) {
                ma = MAX(ma, jobDifficulty[k]);
                ndp[j] = MIN(ndp[j], ma + dp[k - 1]);
            }
        }
        memcpy(dp, ndp, sizeof(dp));
    }
    return dp[n - 1];
}
```

```JavaScript [sol12-JavaScript]
var minDifficulty = function(jobDifficulty, d) {
    const n = jobDifficulty.length;
    if (n < d) {
        return -1;
    }
    let dp = new Array(n).fill(0);
    for (let i = 0, j = 0; i < n; ++i) {
        j = Math.max(j, jobDifficulty[i]);
        dp[i] = j;
    }
    for (let i = 1; i < d; ++i) {
        const ndp = new Array(n).fill(0x3f3f3f3f);
        for (let j = i; j < n; ++j) {
            let ma = 0;
            for (let k = j; k >= i; --k) {
                ma = Math.max(ma, jobDifficulty[k]);
                ndp[j] = Math.min(ndp[j], ma + dp[k - 1]);
            }
        }
        dp = ndp;
    }
    return dp[n - 1];
};
```

**复杂度分析**

- 时间复杂度：$O(n^2 \times d)$，其中 $n$ 为数组 $\textit{jobDifficulty}$ 的长度，$d$ 为需要分配工作的天数。其中共有 $n \times d$ 个状态，每一个状态的求解时间开销为 $O(n)$。
- 空间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{jobDifficulty}$ 的长度。在通过「滚动数组」优化后的空间复杂度为 $O(n)$。

#### 方法二：单调栈

**思路与算法**

现在对于前 $j$ 份工作，找到小于 $j$ 的最大下标 $p$，使得 $\textit{jobDifficulty}[p] > \textit{jobDifficulty}[j]$。那么在「方法一」中，对于 $\textit{dp}[i][j]$ 的求解可以分解为：

- 当 $k \ge p$ 时，有 $f(k+1, j) = \textit{jobDifficulty}[j]$，得：

$$

\begin{aligned}
	\textit{dp}[i][j] =& \min_{k=p,p+1,\dots,j - 1}\{\textit{dp}[i-1][k] + \textit{jobDifficulty}[j]\} \\
    =& \min_{k=p,p+1,\dots,j - 1}\{\textit{dp}[i-1][k]\} + \textit{jobDifficulty}[j]
\end{aligned}

$$

- 当 $k < p$ 时，有 $f(k+1, j) = f(k+1, p)$，得：

$$

\begin{aligned}
	\textit{dp}[i][j] =& \min_{k=i-1,i,\dots,p - 1}\{\textit{dp}[i-1][k] + f(k + 1, p)\} \\
    =& \textit{dp}[i][p]
\end{aligned}

$$

在求解 $\textit{dp}[i][j]$，$i \le j < n$ 时，对于 $p$ 的求解，类似于 [739. 每日温度](https://leetcode.cn/problems/daily-temperatures/)，我们可以通过「单调栈」来进行求解，这样对于 $j$ 求解 $p$ 的均摊时间复杂度为 $O(1)$。我们维护一个存储二元组 $(\textit{idx}_i, \textit{val}_i)$ 的单调栈，从栈底到栈顶的二元组对应的 $idx_i$ 依次递减，其中 $idx_i$ 为对应的工作下标，$\textit{val}_i$ 表示相应区间的最小值，具体来说，如果现在正在求解状态 $\textit{dp}[i][j]$，$i > 0$，且「单调栈」中所存的下标为 $\textit{idx}_1,\textit{idx}_2,\dots,\textit{idx}_m$，则 $\textit{val}_1$ 表示区间 $\textit{dp}[i-1][0]$ 到 $\textit{dp}[i-1][\textit{idx}_1 - 1]$ 的最小值，$\textit{val}_2$ 表示区间 $\textit{dp}[i-1][\textit{idx}_1]$ 到 $\textit{dp}[i-1][\textit{idx}_2 - 1]$ 的最小值，以此类推。这样在维护「单调栈」的过程中，就可以在得到对应 $p$ 的同时，得到：

$$\min_{k = p,p+1,\dots,j-1}dp[k][j - 1]$$

以上的分析在 $i > 0$ 的基础上，同样与「方法一」相同，当 $i = 0$ 时为边界情况，有：

$$\textit{dp}[i][j] = f(0, j)$$

最后我们返回 $\textit{dp}[d - 1][n - 1]$ 即可。在实现的过程中同样可以发现 $\textit{dp}[i]$ 的求解只与上一层状态 $\textit{dp}[i-1]$ 有关，因此我们可以通过「滚动数组」来实现编码过程中的空间优化。

**代码**

未空间优化版

```C++ [sol21-C++]
class Solution {
public:
    int minDifficulty(vector<int>& jobDifficulty, int d) {
        int n = jobDifficulty.size();
        if (n < d) {
            return -1;
        }
        vector<vector<int>> dp(d, vector<int>(n));
        for (int j = 0, ma = 0; j < n; ++j) {
            ma = max(ma, jobDifficulty[j]);
            dp[0][j] = ma;
        }
        for (int i = 1; i < d; ++i) {
            stack<pair<int, int>> st;
            for (int j = i; j < n; ++j) {
                int mi = dp[i - 1][j - 1];
                while (!st.empty() && jobDifficulty[st.top().first] < jobDifficulty[j]) {
                    mi = min(mi, st.top().second);
                    st.pop();
                }
                if (st.empty()) {
                    dp[i][j] = mi + jobDifficulty[j];
                } else {
                    dp[i][j] = min(dp[i][st.top().first], mi + jobDifficulty[j]);
                }
                st.emplace(j, mi);
            }
        }
        return dp[d - 1][n - 1];
    }
};
```

```Java [sol21-Java]
class Solution {
    public int minDifficulty(int[] jobDifficulty, int d) {
        int n = jobDifficulty.length;
        if (n < d) {
            return -1;
        }
        int[][] dp = new int[d][n];
        for (int j = 0, ma = 0; j < n; ++j) {
            ma = Math.max(ma, jobDifficulty[j]);
            dp[0][j] = ma;
        }
        for (int i = 1; i < d; ++i) {
            Deque<int[]> stack = new ArrayDeque<int[]>();
            for (int j = i; j < n; ++j) {
                int mi = dp[i - 1][j - 1];
                while (!stack.isEmpty() && jobDifficulty[stack.peek()[0]] < jobDifficulty[j]) {
                    mi = Math.min(mi, stack.pop()[1]);
                }
                if (stack.isEmpty()) {
                    dp[i][j] = mi + jobDifficulty[j];
                } else {
                    dp[i][j] = Math.min(dp[i][stack.peek()[0]], mi + jobDifficulty[j]);
                }
                stack.push(new int[]{j, mi});
            }
        }
        return dp[d - 1][n - 1];
    }
}
```

```C# [sol21-C#]
public class Solution {
    public int MinDifficulty(int[] jobDifficulty, int d) {
        int n = jobDifficulty.Length;
        if (n < d) {
            return -1;
        }
        int[][] dp = new int[d][];
        for (int i = 0; i < d; ++i) {
            dp[i] = new int[n];
        }
        for (int j = 0, ma = 0; j < n; ++j) {
            ma = Math.Max(ma, jobDifficulty[j]);
            dp[0][j] = ma;
        }
        for (int i = 1; i < d; ++i) {
            Stack<Tuple<int, int>> stack = new Stack<Tuple<int, int>>();
            for (int j = i; j < n; ++j) {
                int mi = dp[i - 1][j - 1];
                while (stack.Count > 0 && jobDifficulty[stack.Peek().Item1] < jobDifficulty[j]) {
                    mi = Math.Min(mi, stack.Pop().Item2);
                }
                if (stack.Count == 0) {
                    dp[i][j] = mi + jobDifficulty[j];
                } else {
                    dp[i][j] = Math.Min(dp[i][stack.Peek().Item1], mi + jobDifficulty[j]);
                }
                stack.Push(new Tuple<int, int>(j, mi));
            }
        }
        return dp[d - 1][n - 1];
    }
}
```

```C [sol21-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int minDifficulty(int* jobDifficulty, int jobDifficultySize, int d) {
    int n = jobDifficultySize;
    if (n < d) {
        return -1;
    }
    int dp[d][n];
    memset(dp, 0, sizeof(dp));
    for (int j = 0, ma = 0; j < n; ++j) {
        ma = MAX(ma, jobDifficulty[j]);
        dp[0][j] = ma;
    }
    for (int i = 1; i < d; ++i) {
        int stack[n][2];
        int top = 0;
        for (int j = i; j < n; ++j) {
            int mi = dp[i - 1][j - 1];
            while (top > 0 && jobDifficulty[stack[top - 1][0]] < jobDifficulty[j]) {
                mi = MIN(mi, stack[top - 1][1]);
                top--;
            }
            if (top == 0) {
                dp[i][j] = mi + jobDifficulty[j];
            } else {
                dp[i][j] = MIN(dp[i][stack[top - 1][0]], mi + jobDifficulty[j]);
            }
            stack[top][0] = j;
            stack[top][1] = mi;
            top++;
        }
    }
    return dp[d - 1][n - 1];
}
```

```JavaScript [sol21-JavaScript]
var minDifficulty = function(jobDifficulty, d) {
    const n = jobDifficulty.length;
    if (n < d) {
        return -1;
    }
    const dp = new Array(d).fill(0).map(() => new Array(n).fill(0));
    for (let j = 0, ma = 0; j < n; ++j) {
        ma = Math.max(ma, jobDifficulty[j]);
        dp[0][j] = ma;
    }
    for (let i = 1; i < d; ++i) {
        const stack = [];
        for (let j = i; j < n; ++j) {
            let mi = dp[i - 1][j - 1];
            while (stack.length && jobDifficulty[stack[stack.length - 1][0]] < jobDifficulty[j]) {
                mi = Math.min(mi, stack.pop()[1]);
            }
            if (stack.length === 0) {
                dp[i][j] = mi + jobDifficulty[j];
            } else {
                dp[i][j] = Math.min(dp[i][stack[stack.length - 1][0]], mi + jobDifficulty[j]);
            }
            stack.push([j, mi]);
        }
    }
    return dp[d - 1][n - 1];
};
```

通过「滚动数组」空间优化版

```C++ [sol22-C++]
class Solution {
public:
    int minDifficulty(vector<int>& jobDifficulty, int d) {
        int n = jobDifficulty.size();
        if (n < d) {
            return -1;
        }
        vector<int> dp(n);
        for (int j = 0, ma = 0; j < n; ++j) {
            ma = max(ma, jobDifficulty[j]);
            dp[j] = ma;
        }
        for (int i = 1; i < d; ++i) {
            stack<pair<int, int>> st;
            vector<int> ndp(n);
            for (int j = i; j < n; ++j) {
                int mi = dp[j - 1];
                while (!st.empty() && jobDifficulty[st.top().first] < jobDifficulty[j]) {
                    mi = min(mi, st.top().second);
                    st.pop();
                }
                if (st.empty()) {
                    ndp[j] = mi + jobDifficulty[j];
                } else {
                    ndp[j] = min(ndp[st.top().first], mi + jobDifficulty[j]);
                }
                st.emplace(j, mi);
            }
            swap(dp, ndp);
        }
        return dp[n - 1];
    }
};
```

```Java [sol22-Java]
class Solution {
    public int minDifficulty(int[] jobDifficulty, int d) {
        int n = jobDifficulty.length;
        if (n < d) {
            return -1;
        }
        int[] dp = new int[n];
        for (int j = 0, ma = 0; j < n; ++j) {
            ma = Math.max(ma, jobDifficulty[j]);
            dp[j] = ma;
        }
        for (int i = 1; i < d; ++i) {
            Deque<int[]> stack = new ArrayDeque<int[]>();
            int[] ndp = new int[n];
            for (int j = i; j < n; ++j) {
                int mi = dp[j - 1];
                while (!stack.isEmpty() && jobDifficulty[stack.peek()[0]] < jobDifficulty[j]) {
                    mi = Math.min(mi, stack.pop()[1]);
                }
                if (stack.isEmpty()) {
                    ndp[j] = mi + jobDifficulty[j];
                } else {
                    ndp[j] = Math.min(ndp[stack.peek()[0]], mi + jobDifficulty[j]);
                }
                stack.push(new int[]{j, mi});
            }
            dp = ndp;
        }
        return dp[n - 1];
    }
}
```

```C# [sol22-C#]
public class Solution {
    public int MinDifficulty(int[] jobDifficulty, int d) {
        int n = jobDifficulty.Length;
        if (n < d) {
            return -1;
        }
        int[] dp = new int[n];
        for (int j = 0, ma = 0; j < n; ++j) {
            ma = Math.Max(ma, jobDifficulty[j]);
            dp[j] = ma;
        }
        for (int i = 1; i < d; ++i) {
            Stack<Tuple<int, int>> stack = new Stack<Tuple<int, int>>();
            int[] ndp = new int[n];
            for (int j = i; j < n; ++j) {
                int mi = dp[j - 1];
                while (stack.Count > 0 && jobDifficulty[stack.Peek().Item1] < jobDifficulty[j]) {
                    mi = Math.Min(mi, stack.Pop().Item2);
                }
                if (stack.Count == 0) {
                    ndp[j] = mi + jobDifficulty[j];
                } else {
                    ndp[j] = Math.Min(ndp[stack.Peek().Item1], mi + jobDifficulty[j]);
                }
                stack.Push(new Tuple<int, int>(j, mi));
            }
            dp = ndp;
        }
        return dp[n - 1];
    }
}
```

```C [sol22-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int minDifficulty(int* jobDifficulty, int jobDifficultySize, int d) {
    int n = jobDifficultySize;
    if (n < d) {
        return -1;
    }
    int dp[n];
    for (int j = 0, ma = 0; j < n; ++j) {
        ma = MAX(ma, jobDifficulty[j]);
        dp[j] = ma;
    }
    for (int i = 1; i < d; ++i) {
        int stack[n][2];
        int top = 0;
        int ndp[n];
        memset(ndp, 0, sizeof(ndp));
        for (int j = i; j < n; ++j) {
            int mi = dp[j - 1];
            while (top > 0 && jobDifficulty[stack[top - 1][0]] < jobDifficulty[j]) {
                mi = MIN(mi, stack[top - 1][1]);
                top--;
            }
            if (top == 0) {
                ndp[j] = mi + jobDifficulty[j];
            } else {
                ndp[j] = MIN(ndp[stack[top - 1][0]], mi + jobDifficulty[j]);
            }
            stack[top][0] = j;
            stack[top][1] = mi;
            top++;
        }
        memcpy(dp, ndp, sizeof(dp));
    }
    return dp[n - 1];
}
```

```JavaScript [sol22-JavaScript]
var minDifficulty = function(jobDifficulty, d) {
    const n = jobDifficulty.length;
    if (n < d) {
        return -1;
    }
    let dp = new Array(n).fill(0);
    for (let j = 0, ma = 0; j < n; ++j) {
        ma = Math.max(ma, jobDifficulty[j]);
        dp[j] = ma;
    }
    for (let i = 1; i < d; ++i) {
        const stack = [];
        const ndp = new Array(n).fill(0);
        for (let j = i; j < n; ++j) {
            let mi = dp[j - 1];
            while (stack.length && jobDifficulty[stack[stack.length - 1][0]] < jobDifficulty[j]) {
                mi = Math.min(mi, stack.pop()[1]);
            }
            if (stack.length === 0) {
                ndp[j] = mi + jobDifficulty[j];
            } else {
                ndp[j] = Math.min(ndp[stack[stack.length - 1][0]], mi + jobDifficulty[j]);
            }
            stack.push([j, mi]);
        }
        dp = ndp;
    }
    return dp[n - 1];
};
```

**复杂度分析**

- 时间复杂度：$O(n \times d)$，其中 $n$ 为数组 $\textit{jobDifficulty}$ 的长度，$d$ 为需要分配工作的天数。其中共有 $n \times d$ 个状态，每一个状态的求解时间开销均摊为 $O(1)$。
- 空间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{jobDifficulty}$ 的长度。在通过「滚动数组」优化后的空间复杂度为 $O(n)$。
## [1494.并行课程 II 中文官方题解](https://leetcode.cn/problems/parallel-courses-ii/solutions/100000/bing-xing-ke-cheng-ii-by-leetcode-soluti-l0mo)

#### 前言

本题解涉及到「二进制」中的「子集枚举」，具体表示为对给定的一个整数 $x$，不重复地枚举 $x$ 的「二进制」表示的非空子集 $y$，其中 $y$ 满足 $y \And x = y$。以下为以 `C++` 实现枚举 $x$ 的非空子集的代码，其正确性证明详细可以见 [OI_WIKI-二进制集合操作-子集遍历部分](https://oi-wiki.org/math/binary-set/)。

```C++
// 降序遍历 x 的非空子集
for (int sub = x; sub; sub = (sub - 1) & x) {
    // sub 是 x 的一个非空子集
}
```

对于一个有「二进制」表示中有 $k$ 个 $1$ 的正整数 $x$，其非空子集有 $2^k - 1$ 个。所以对于 $x$ 枚举子集的时间复杂度为 $O(2^k)$。

#### 方法一：动态规划 + 状态压缩

**思路与算法** 

题目给出 $n$ 门课程数目，编号从 $1$ 到 $n$，和数组 $\textit{relations}$，其中 $\textit{relations}[i] = [x_i, y_i]$ 表示课程 $y_i$ 的先修课程为 $x_i$，即：在学习课程 $y_i$ 之前课程 $x_i$ 必须要完成。现在在一个学期中我们最多可以同时上 $k$ 门课，前提是这些课的先修课程在之前的学期中已全部完成学习。现在我们需要返回上完全部 $n$ 门课程最少需要多少个学期。

由于题目限定 $n$ 最多 $15$，所以我们可以通过「二进制」和「状态压缩」来表示一个课程集合。我们用一个整数 $S$ 来表示当前还需要学习的课程集合：从 $S$ 「二进制」表示的低位到高位，第 $i$ 位为 $1$ 则表示课程 $i$ 还需要进行学习，否则表示课程 $i$ 已经完成学习。现在我们尝试用「状态压缩动态规划」来解决本题，设 $\textit{dp}[i]$ 和 $\textit{need}[i]$ 分别表示现在我们需要完成学习的课程集合为 $i$ 所需要的最少学期数和完成学习课程集合为 $i$ 时的先修课程集合，并初始化每一个状态 $i$ 的 $\textit{dp}[i] = \text{INF}$，$\textit{need}[i] = 0$，其中 $\text{INF}$ 为我们人为设定的最大值表示该课程集合无法完成学习。

现在我们考虑如何实现状态转移。首先为了方便状态表示，我们重新对课程进行编号，从 $0$ 开始编号，即原来编号为 $x$ 的课程现在为 $x - 1$。然后从给定数组 $\textit{relations}$ 中每一个 $\textit{relations}[i] = [x_i, y_i]$ 更新 $\textit{need}[2^{y_i}] = 2^{x_i}$，注意现在的 $x_i$ 和 $y_i$ 为重新编号后的课程编号。特别地当课程集合为空时，有 $\textit{need}[0] = 0$ 和 $\textit{dp}[0] = 0$。那么现在我们可以写出状态转移方程：

$$
\begin{aligned}
\textit{need}[i] &= \textit{need}[i \oplus \textit{sub}] ｜ \textit{need}[\textit{sub}] \\
\textit{dp}[i] &= \min_{\textit{sub} \text{ is valid}}{dp[i \oplus \textit{sub}]} + 1
\end{aligned}
$$

这两个状态方程什么意思呢？

- 对于 $\textit{need}[i]$ 我们找到状态 $i$ 的一个任意子集 $\textit{sub}$，课程集合 $i$ 的先修课程为集合 $\textit{sub}$ 和集合 $i$ 中去掉 $\textit{sub}$ 后所需的先修课程集合的并集。这里 $\oplus$ 表示「异或」运算，$i \oplus \textit{sub}$ 表示将 $\textit{sub}$ 从 $i$ 移除的操作。为了计算方便，我们可以令 $\textit{sub}$ 为 $i$ 的「二进制」的最低位，可以用 $i \And (-i)$ 来表示，$i \oplus \textit{sub} = i \And (i - 1)$：

$$\textit{need}[i] = \textit{need}[i \And (i - 1)] ｜ \textit{need}[i \And (-i)]$$


- 对于 $\textit{dp}[i]$ 我们对 $i$ 进行「子集枚举」。其中枚举的子集 $\textit{sub}$ 表示现在我们在当前课程集合 $i$ 的情况下，在该学期尝试学习课程集合 $\textit{sub}$。那么在所有满足条件的 $\textit{sub}$ 中选取剩下课程所需要学习学期最少的情况，就可以得到此时学完课程 $i$ 所需要的最少学期数。当 $\textit{sub}$ 满足以下几个条件时，我们可以对 $\textit{sub}$ 进行学习：

    - $\textit{sub}$ 的大小不能超过每学期最多可以上的课程数 $k$，即 $\textit{popcount}(\textit{sub}) \le k$，其中 $\textit{popcount}(x)$ 表示整数 $x$ 「二进制」表示中 $1$ 的个数。
    - 剩下的课程集合 $i \oplus \textit{sub}$ 为可以在有限的学期内完成学习，即：$\textit{dp}[i \oplus \textit{sub}] \neq \text{INF}$。
    - 剩下的课程集合 $i \oplus \textit{sub}$ 中不存在 $\textit{sub}$ 的先修课程，即：$\textit{need}[\textit{sub}] \And (i \oplus \textit{sub}) = \textit{need}[\textit{sub}]$。

    若不存在满足条件的 $\textit{sub}$，则 $\textit{dp}[i] = \text{INF}$ 不变。

然后我们从小到大来计算每一个状态 $i$ 的 $\textit{need}[i]$ 和 $\textit{dp}[i]$，最后返回 $\textit{dp}[2^n-1]$ 即为学完全部课程所需要的最少学期数。

在实现的过程中，我们可以做以下的优化：

- 当 $i \mid \textit{need}[i] \neq i$ 时，说明无论如何枚举子集 $\textit{sub}$，始终有课程不能完成学习，此时 $\textit{dp}[i]$ 仍为 $\text{INF}$ 不变，直接跳过该状态。
- 对于枚举的子集 $\textit{sub}$ 为 $\textit{i} \oplus \textit{need}[i]$ 的子集。因为如果要完成课程状态 $i$ 的学习，$\textit{need}[i]$ 一定不能在最后完成。
- 当 $\textit{i} \oplus \textit{need}[i]$ 的课程集合大小小于等于 $k$ 时，我们可以全部进行学习，不必再进行子集枚举。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minNumberOfSemesters(int n, vector<vector<int>>& relations, int k) {
        vector<int> dp(1 << n, INT_MAX);
        vector<int> need(1 << n, 0);
        for (auto& edge : relations) {
            need[(1 << (edge[1] - 1))] |= 1 << (edge[0] - 1);
        }
        dp[0] = 0;
        for (int i = 1; i < (1 << n); ++i) {
            need[i] = need[i & (i - 1)] | need[i & (-i)];
            if ((need[i] | i) != i) { // i 中有任意一门课程的前置课程没有完成学习
                continue;
            }
            int valid = i ^ need[i]; // 当前学期可以进行学习的课程集合
            if (__builtin_popcount(valid) <= k) { // 如果个数小于 k，则可以全部学习，不再枚举子集
                dp[i] = min(dp[i], dp[i ^ valid] + 1);
            } else { // 否则枚举当前学期需要进行学习的课程集合
                for (int sub = valid; sub; sub = (sub - 1) & valid) {
                    if (__builtin_popcount(sub) <= k) {
                        dp[i] = min(dp[i], dp[i ^ sub] + 1);
                    }
                }
            }
        }
        return dp[(1 << n) - 1];
    }
};
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

const int INF = 0x3f3f3f3f;

int minNumberOfSemesters(int n, int** relations, int relationsSize, int* relationsColSize, int k) {
    int dp[1 << n];
    int need[1 << n];
    memset(dp, 0x3f, sizeof(dp));
    memset(need, 0, sizeof(need));
    for (int i = 0; i < relationsSize; i++) {
        int x = relations[i][0], y = relations[i][1];
        need[(1 << (y - 1))] |= 1 << (x - 1);
    }
    dp[0] = 0;
    for (int i = 1; i < (1 << n); ++i) {
        need[i] = need[i & (i - 1)] | need[i & (-i)];
        if ((need[i] | i) != i) { // i 中有任意一门课程的前置课程没有完成学习
            continue;
        }
        int valid = i ^ need[i]; // 当前学期可以进行学习的课程集合
        if (__builtin_popcount(valid) <= k) { // 如果个数小于 k，则可以全部学习，不再枚举子集
            dp[i] = MIN(dp[i], dp[i ^ valid] + 1);
        } else { // 否则枚举当前学期需要进行学习的课程集合
            for (int sub = valid; sub; sub = (sub - 1) & valid) {
                if (__builtin_popcount(sub) <= k) {
                    dp[i] = MIN(dp[i], dp[i ^ sub] + 1);
                }
            }
        }
    }
    return dp[(1 << n) - 1];
}
```

```Python [sol1-Python3]
class Solution:
    def minNumberOfSemesters(self, n: int, relations: List[List[int]], k: int) -> int:
        dp = [inf] * (1 << n)
        need = [0] * (1 << n)
        for edge in relations:
            need[(1 << (edge[1] - 1))] |= 1 << (edge[0] - 1)
        dp[0] = 0
        for i in range(1, (1 << n)):
            need[i] = need[i & (i - 1)] | need[i & (-i)]
            if (need[i] | i) != i: # i 中有任意一门课程的前置课程没有完成学习
                continue
            sub = valid = i ^ need[i] # 当前学期可以进行学习的课程集合
            if sub.bit_count() <= k: # 如果个数小于 k，则可以全部学习，不再枚举子集
                dp[i] = min(dp[i], dp[i ^ sub] + 1)
            else: # 枚举子集
                while sub:
                    if sub.bit_count() <= k:
                        dp[i] = min(dp[i], dp[i ^ sub] + 1)
                    sub = (sub - 1) & valid
        return dp[-1]
```

```Java [sol1-Java]
class Solution {
    public int minNumberOfSemesters(int n, int[][] relations, int k) {
        int[] dp = new int[1 << n];
        Arrays.fill(dp, Integer.MAX_VALUE);
        int[] need = new int[1 << n];
        for (int[] edge : relations) {
            need[(1 << (edge[1] - 1))] |= 1 << (edge[0] - 1);
        }
        dp[0] = 0;
        for (int i = 1; i < (1 << n); ++i) {
            need[i] = need[i & (i - 1)] | need[i & (-i)];
            if ((need[i] | i) != i) { // i 中有任意一门课程的前置课程没有完成学习
                continue;
            }
            int valid = i ^ need[i]; // 当前学期可以进行学习的课程集合
            if (Integer.bitCount(valid) <= k) { // 如果个数小于 k，则可以全部学习，不再枚举子集
                dp[i] = Math.min(dp[i], dp[i ^ valid] + 1);
            } else { // 否则枚举当前学期需要进行学习的课程集合
                for (int sub = valid; sub > 0; sub = (sub - 1) & valid) {
                    if (Integer.bitCount(sub) <= k) {
                        dp[i] = Math.min(dp[i], dp[i ^ sub] + 1);
                    }
                }
            }
        }
        return dp[(1 << n) - 1];
    }
}
```

```Go [sol1-Go]
func minNumberOfSemesters(n int, relations [][]int, k int) int {
    dp := make([]int, 1 << n)
    for i := range dp {
        dp[i] = math.MaxInt32
    }
    need := make([]int, 1<<n)
    for _, edge := range relations {
        need[1 << (edge[1] - 1)] |= 1 << (edge[0] - 1)
    }
    dp[0] = 0
    for i := 1; i < (1 << n); i++ {
        need[i] = need[i & (i - 1)] | need[i & -i]
        if (need[i] | i) != i { // i 中有任意一门课程的前置课程没有完成学习
                continue;
        }
        valid := i ^ need[i]; // 当前学期可以进行学习的课程集合
        if bits.OnesCount(uint(valid)) <= k { // 如果个数小于 k，则可以全部学习，不再枚举子集
            dp[i] = min(dp[i], dp[i ^ valid] + 1)
        } else {
            for sub := valid; sub > 0; sub = (sub - 1) & valid {
                if bits.OnesCount(uint(sub)) <= k {
                    dp[i] = min(dp[i], dp[i ^ sub] + 1)
                }
            }
        }
    }
    return dp[(1 << n) - 1]
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var minNumberOfSemesters = function(n, relations, k) {
    const dp = new Array(1 << n).fill(Infinity);
    const need = new Array(1 << n).fill(0);
    for (const edge of relations) {
        need[(1 << (edge[1] - 1))] |= 1 << (edge[0] - 1);
    }
    dp[0] = 0;
    for (let i = 1; i < (1 << n); ++i) {
        need[i] = need[i & (i - 1)] | need[i & (-i)];
        if ((need[i] | i) !== i) {
            continue;
        }
        const valid = i ^ need[i];
        if (bitCount(valid) <= k) {
            dp[i] = Math.min(dp[i], dp[i ^ valid] + 1);
        } else {
            for (let sub = valid; sub; sub = (sub - 1) & valid) {
                if (bitCount(sub) <= k) {
                    dp[i] = Math.min(dp[i], dp[i ^ sub] + 1);
                }
            }
        }
    }
    return dp[(1 << n) - 1];
}

function bitCount(n) {
    let count = 0;
    while (n) {
        count++;
        n &= n - 1;
    }
    return count;
}
```

**复杂度分析**

- 时间复杂度：$O(3^n)$，其中 $n$ 为课程的数量，动态规划中共有 $O(2^n)$ 种状态，将每一个状态看作一个集合，大小为 $k$ 的集合有 $C_n^k$ 个，其中 $C_n^k$ 表示从 $n$ 个数中选取 $k$ 个数的组合数，并且每一个转移的个数为 $2^k$，根据「二项式定理」可以得到 
  
    $$
    \sum_{k = 0}^n{C_n^k2^k} = \sum_{k = 0}^n{C_n^k2^k1^{n - k}} = (2 + 1) ^ n = 3^n
    $$

    因此总的时间复杂度为 $O(3^n)$。
- 空间复杂度：$O(2^n)$，其中 $n$ 为课程的数量。我们需要保存动态规划中的每一个状态。
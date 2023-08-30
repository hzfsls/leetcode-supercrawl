#### 前言

本题难度较大，题解中包含较多变量以及公式，希望读者认真阅读。

为了叙述方便，我们称给定的字符串 $s$ 为「原串」，压缩后的字符串 $t$ 为「压缩串」。我们的目标是从 $s$ 中删除至多 $k$ 个字符，使得其对应的 $t$ 的长度最小。

#### 方法一：动态规划

**思路与算法**

压缩串 $t$ 由字母和数字间隔组成：

$$
t = c_1d_1c_2d_2 \cdots c_md_m
$$

其中 $c_x$ 表示字母，$d_x$ 表示数字，$(c_x, d_x)$ 即代表着原串 $s$ 中连续出现了 $d_x$ 次字母 $c_x$。当出现次数为 $1$ 时，我们会省略 $d_x$。我们可以根据 $t$ 的形式进行动态规划。在状态转移的过程中，每一次我们只处理 $t$ 中的一个 $(c_x, d_x)$ 二元组。

我们用 $f[i][j]$ 表示对于原串 $s$ 的前 $i$ 个字符，通过删除其中的 $j$ 个字符，剩余的 $i-j$ 个字符可以得到的最小的压缩串的长度。为了方便对边界条件进行处理，这里的 $i$ 和 $j$ 都从 $1$ 开始编号。$i$ 的最大值为 $|s|$（原串 $s$ 的长度），$j$ 的最大值为 $k$。

> 注意这里的状态表示中，我们并不关心到底删除了哪 $j$ 个字符。

如何进行状态转移呢？我们可以考虑第 $i$ 个字符是否被删除：

- 如果第 $i$ 个字符被删除，那么前 $i-1$ 个字符中就有 $j-1$ 个字符被删除，状态转移方程为：

    $$
    f[i][j] = f[i-1][j-1]
    $$

- 如果第 $i$ 个字符没有被删除，那么我们考虑以该字符 $s[i]$ 为结尾的一个 $(c_x, d_x)$ 二元组，其中 $c_x = s[i]$。我们需要在 $[1, i)$ 的范围内再选择若干个（包括零个）与 $s[i]$ 相同的字符，一起进行压缩。在选择的范围内与 $s[i]$ 不相同的字符，则会全部被删除。形式化地说，我们选择了位置

    $$
    p_1 < p_2 < \cdots < p_{d_x-1} < i
    $$

    其中

    $$
    s[p_1] = s[p_2] = \cdots = s[p_{d_x-1}] = s[i] = c_x
    $$

    那么我们选择的范围即为 $[p_1, i]$，在其中选择了 $d_x$ 个字符 $c_x$，剩余的 $i-p_1+1-d_x$ 个字符（无论是否为 $c_x$）都必须被删除。那么前 $p_1-1$ 个字符中就有 $j-(i-p_1+1-d_x)$ 个字符被删除，状态转移方程为：

    $$
    f[i][j] = \min_{\mathcal{X}_d} \{ f[p_1-1][j-(i-p_1+1-d_x)] + \text{cost}(d_x) \}
    $$

    其中 $\mathcal{X}_d$ 表示包含了所有选择 $p_1, \cdots, p_{d_x-1}$ 的方案集合，$\text{cost}(d_x)$ 表示压缩 $d_x$ 个字符得到的长度：

    $$
    \text{cost}(d_x) = \begin{cases}
    1, & d_x=1 \\
    2, & 2 \leq d_x \leq 9 \\
    3, & 10 \leq d_x \leq 99 \\
    4, & d_x=100
    \end{cases}
    $$

    这个状态转移方程的时间复杂度非常高，因为 $\mathcal{X}_d$ 是一个非常大的集合，我们需要枚举每一种方案是不现实的。事实上，如果 $p_1, \cdots, p_{d_x-1}, i$ 是原串 $s$ 中**连续的**出现字符 $c_x$ 的位置，那么方案数就没有那么多了。我们只需要枚举 $d_x$，就可以从 $i$ 开始向左依次地选取出现字符 $c_x$ 的位置，当选取了 $d_x-1$ 次后，就对应着**唯一的** $p_1, \cdots, p_{d_x-1}, i$。

    **那么这样只考虑选择连续的 $c_x$ 的做法是否是正确的呢**？例如当 $s[1 .. i] = \text{aabca}$ 时，我们要选择 $2$ 个 $\text{a}$，其中 $1$ 个 $\text{a}$ 是 $s[i]$，我们如何保证只考虑选择连续的 $\text{a}$，即选择 $\text{a\underline{a}bc\underline{a}}$，而不考虑 $\text{\underline{a}abc\underline{a}}$ 这种情况呢？

    > 可以发现，在 $\text{\underline{a}abc\underline{a}}$ 这种情况中，我们保留了 $2$ 个 $\text{a}$ 而删除了 $3$ 个字符。由于删除任意一个字符的代价都是一样的，因此我们**不如从左到右连续地保留 $2$ 个出现的 $\text{a}$，而删除剩余的 $3$ 个字符**，即 $\text{\underline{aa}bca}$，这两种情况是等价的。而后者会在 $s[1 .. i'] = \text{aa}$ 时就会被考虑到，所以我们可以不用考虑前者。
    > 
    > 更直观地说，如果我们选择的 $d_x$ 个 $c_x$ 不是连续的，那么我们可以在对应的选择范围内**从左到右连续地**重新选择 $d_x$ 个 $c_x$，二者是等价的，而后者由于连续性，会在之前的状态转移中被考虑到。

    因此，我们可以对状态转移方程进行优化，只考虑选择连续的 $c_x$：

    $$
    f[i][j] = \min_{s[i_0]=s[i]} \{ f[i_0-1][j- \text{diff}(i_0, i)] + \text{cost}(\text{same}(i_0, i)) \}
    $$

    其中 $\text{diff}(i_0, i)$ 表示 $s[i_0 .. i]$ 中与 $s[i]$ 不同的字符数目，$\text{same}(i_0, i)$ 表示 $s[i_0 .. i]$ 中与 $s[i]$ 相同的字符数目，有：

    $$
    \text{diff}(i_0, i) + \text{same}(i_0, i) = i-i_0+1
    $$

    也就是说，我们枚举满足 $s[i_0] = s[i] = c_x$ 的 $i_0$，选择所有在 $[i_0, i]$ 范围内的 $c_x$，删除剩余的字符（此时剩余的字符均不会是 $c_x$）。

动态规划的边界条件为 $f[0][0] = 0$，表示空串对应的压缩串的长度为零。由于需要求的是 $f[i][j]$ 的最小值，因此我们可以将它们的值初始化为一个很大的正整数。

最终的答案即为 $f[n][0 .. k]$ 中的最小值，即我们可以 $s$ 中删除最多 $k$ 个字符。由于删除一个字符永远不会劣于保留该字符，因此实际上最终的答案就是 $f[n][k]$，即我们恰好删除 $k$ 个字符。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int getLengthOfOptimalCompression(string s, int k) {
        auto calc = [](int x) {
            if (x == 1) {
                return 1;
            }
            if (x < 10) {
                return 2;
            }
            if (x < 100) {
                return 3;
            }
            return 4;
        };
        
        int n = s.size();
        vector<vector<int>> f(n + 1, vector<int>(k + 1, INT_MAX >> 1));
        f[0][0] = 0;
        for (int i = 1; i <= n; ++i) {
            for (int j = 0; j <= k && j <= i; ++j) {
                if (j > 0) {
                    f[i][j] = f[i - 1][j - 1];
                }
                int same = 0, diff = 0;
                for (int i0 = i; i0 >= 1 && diff <= j; --i0) {
                    if (s[i0 - 1] == s[i - 1]) {
                        ++same;
                        f[i][j] = min(f[i][j], f[i0 - 1][j - diff] + calc(same));
                    } else {
                        ++diff;
                    }
                }
            }
        }
        
        return f[n][k];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int getLengthOfOptimalCompression(String s, int k) {
        int n = s.length();
        int[][] f = new int[n + 1][k + 1];
        for (int i = 0; i <= n; i++) {
            Arrays.fill(f[i], Integer.MAX_VALUE >> 1);
        }
        f[0][0] = 0;
        for (int i = 1; i <= n; ++i) {
            for (int j = 0; j <= k && j <= i; ++j) {
                if (j > 0) {
                    f[i][j] = f[i - 1][j - 1];
                }
                int same = 0, diff = 0;
                for (int i0 = i; i0 >= 1 && diff <= j; --i0) {
                    if (s.charAt(i0 - 1) == s.charAt(i - 1)) {
                        ++same;
                        f[i][j] = Math.min(f[i][j], f[i0 - 1][j - diff] + calc(same));
                    } else {
                        ++diff;
                    }
                }
            }
        }
        
        return f[n][k];
    }

    public int calc(int x) {
        if (x == 1) {
            return 1;
        }
        if (x < 10) {
            return 2;
        }
        if (x < 100) {
            return 3;
        }
        return 4;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def getLengthOfOptimalCompression(self, s: str, k: int) -> int:
        calc = lambda x: 1 if x == 1 else (2 if x < 10 else (3 if x < 100 else 4))

        n = len(s)
        f = [[10**9] * (k + 1) for _ in range(n + 1)]
        f[0][0] = 0
        
        for i in range(1, n + 1):
            for j in range(min(k, i) + 1):
                if j > 0:
                    f[i][j] = f[i - 1][j - 1]
                same = diff = 0
                for i0 in range(i, 0, -1):
                    if s[i0 - 1] == s[i - 1]:
                        same += 1
                        f[i][j] = min(f[i][j], f[i0 - 1][j - diff] + calc(same))
                    else:
                        diff += 1
                        if diff > j:
                            break
        return f[n][k]
```

```C [sol1-C]
int calc(int x) {
    if (x == 1) {
        return 1;
    }
    if (x < 10) {
        return 2;
    }
    if (x < 100) {
        return 3;
    }
    return 4;
}

int getLengthOfOptimalCompression(char* s, int k) {
    int n = strlen(s);
    int f[n + 1][k + 1];
    memset(f, 0x3f, sizeof(f));
    f[0][0] = 0;
    for (int i = 1; i <= n; ++i) {
        for (int j = 0; j <= k && j <= i; ++j) {
            if (j > 0) {
                f[i][j] = f[i - 1][j - 1];
            }
            int same = 0, diff = 0;
            for (int i0 = i; i0 >= 1 && diff <= j; --i0) {
                if (s[i0 - 1] == s[i - 1]) {
                    ++same;
                    f[i][j] = fmin(f[i][j], f[i0 - 1][j - diff] + calc(same));
                } else {
                    ++diff;
                }
            }
        }
    }

    return f[n][k];
}
```

**复杂度分析**

- 时间复杂度：$O(|s|^2k)$，其中 $|s|$ 是原串 $s$ 的长度。动态规划中状态的数目为 $O(|s|k)$，每一个状态需要 $O(|s|)$ 的时间进行转移，相乘即可得到总时间复杂度。

- 空间复杂度：$O(|s|k)$，即为动态规划中状态的数目。
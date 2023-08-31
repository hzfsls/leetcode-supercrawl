## [2272.最大波动的子字符串 中文官方题解](https://leetcode.cn/problems/substring-with-largest-variance/solutions/100000/zui-da-bo-dong-de-zi-zi-fu-chuan-by-leet-xsnp)

#### 方法一：枚举最多和最少的字符 + 最大子段和动态规划

**思路与算法**

如果我们枚举给定字符串 $s$ 的所有子串并计算波动值，那么至少需要 $O(n^2)$ 的时间，其中 $n$ 是字符串 $s$ 的长度。这是因为 $s$ 的子串有 $O(n^2)$ 个，然而本题 $n \leq 10^4$，会超出时间限制。

因此我们可以考虑枚举「出现次数最多的字符」以及「出现次数最少的字符」。如果出现次数最多的字符为 $c_0$，最少的字符为 $c_1$，并且我们可以将字符串 $s$ 映射成一个数组：

- 如果某个字符为 $c_0$，那么映射为 $+1$;

- 如果某个字符为 $c_1$，那么映射为 $-1$；

- 对于其余情况，映射为 $0$。

那么任意一个子串对应的子数组的和，就是「$c_0$ 出现的次数减去 $c_1$ 出现的次数」。我们只要求出映射数组的「最大子段和」（就是和最大的子数组的和），就可以知道在以 $c_0$ 为出现次数最多的字符、$c_1$ 为出现次数最少的字符时，最大的波动值。

对于某个子串，如果 $c_0$ 并非真正出现次数最多的字符，或者 $c_1$ 并非出现次数最少的字符，我们在计算答案时也不会产生影响。例如 $c_0'$ 是真正出现次数最多的字符，我们计算出的最大波动值为「$c_0$ 出现的次数减去 $c_1$ 出现的次数」，而真正的答案「$c_0'$ 出现的次数减去 $c_1$ 出现的次数」只会更大，并且会在枚举 $(c_0', c_1)$ 时计算出来。

**动态规划**

当给定一个只包含 $+1, 0, -1$ 的数组，如何计算最大子段和呢？需要注意的是，满足要求的子数组必须至少包含一个 $+1$ 和一个 $-1$，否则我们会将例如只包含 $c_0$ 而不包含 $c_1$ 的子串计入答案。由于不包含 $+1$ 的子数组一定不是答案（此时子数组的和为负数，而答案一定是非负整数），因此在进行动态规划时，我们只需要一个额外的状态，即「包含 $-1$ 的子数组」。

我们用 $f[i]$ 表示以 $i$ 结尾的子数组的最大和，$g[i]$ 表示以 $i$ 结尾的并且一定包含 $-1$ 的子数组的最大和。初始时 $f[-1] = 0$ 以及 $g[-1] = -\infty$，因为 $f$ 的定义可以允许一个空的子数组，而 $g$ 不可以（因为一定要包含 $-1$）。记 $d_i$ 表示 $s[i]$ 映射的数值，当 $d_i=0$ 时，状态转移方程为：

$$
\begin{cases}
f[i]=f[i-1] \\
g[i]=g[i-1]
\end{cases}
$$

当 $d_i=1$ 时，状态转移方程为：

$$
\begin{cases}
f[i]=\max\{f[i-1], 0\}+1 \\
g[i]=g[i-1]+1
\end{cases}
$$

当 $d_i=-1$ 时，状态转移方程为：

$$
\begin{cases}
f[i]=\max\{f[i-1], 0\}-1 \\
g[i]=\max\{f[i-1], g[i-1], 0\}-1
\end{cases}
$$

最终的答案为数组 $g$ 中的最大值。

**优化**

上述算法的时间复杂度为 $O(n|\Sigma|^2)$，其中 $\Sigma$ 表示字符集。但注意到当 $d_i=0$ 时，我们实际上没有进行任何计算，因此我们可以对动态规划的时间进行优化。

我们使用哈希映射递增地存储每一个字符出现的位置。当枚举到 $(c_0, c_1)$ 时，我们使用类似「合并两个有序列表」的方法进行动态规划，这样就可以完成所有 $d_i = \pm 1$ 的计算，并且跳过了 $d_i=0$ 的位置。具体实现可以参考下面的代码。

由于每种字符会被枚举到 $2|\Sigma|-1$ 次，而所有字符的出现次数总和为 $n$，因此优化后的算法的时间复杂度为 $O((2|\Sigma|-1)n) - O(n|\Sigma|)$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int largestVariance(string s) {
        unordered_map<char, vector<int>> pos;
        for (int i = 0; i < s.size(); ++i) {
            pos[s[i]].push_back(i);
        }

        int ans = 0;
        for (auto&& [c0, pos0]: pos) {
            for (auto&& [c1, pos1]: pos) {
                if (c0 != c1) {
                    int i = 0, j = 0;
                    int f = 0, g = INT_MIN;
                    while (i < pos0.size() || j < pos1.size()) {
                        if (j == pos1.size() || (i < pos0.size() && pos0[i] < pos1[j])) {
                            tie(f, g) = tuple{max(f, 0) + 1, g + 1};
                            ++i;
                        }
                        else {
                            tie(f, g) = tuple{max(f, 0) - 1, max({f, g, 0}) - 1};
                            ++j;
                        }
                        ans = max(ans, g);
                    }
                }
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def largestVariance(self, s: str) -> int:
        pos = defaultdict(list)
        for i, ch in enumerate(s):
            pos[ch].append(i)

        ans = 0
        for c0, pos0 in pos.items():
            for c1, pos1 in pos.items():
                if c0 != c1:
                    i = j = 0
                    f, g = 0, float("-inf")
                    while i < len(pos0) or j < len(pos1):
                        if j == len(pos1) or (i < len(pos0) and pos0[i] < pos1[j]):
                            f, g = max(f, 0) + 1, g + 1
                            i += 1
                        else:
                            f, g = max(f, 0) - 1, max(f, g, 0) - 1
                            j += 1
                        ans = max(ans, g)
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n|\Sigma|)$，其中 $n$ 是字符串 $s$ 的长度，$\Sigma$ 是字符集，在本题中 $|\Sigma|=26$。

- 空间复杂度：$O(n)$，即为哈希映射需要使用的空间。
#### 前言

本题思维难度较大，需要一些动态规划的预处理和优化技巧，并且细节很多。

#### 方法一：动态规划

**思路与算法**

我们用 $f[i][j]$ 表示对于字符串 $\textit{num}$ 的第 $0, 1, \cdots, j$ 个字符进行划分，并且最后一个数使用了第 $i, i+1, \cdots j$ 个字符的方案数。为了叙述方便，我们用 $\textit{num}(i, j)$ 表示该数。

那么如何进行状态转移呢？我们可以基于如下的一个事实：

> 对于数 $a$ 和 $b$，如果 $a$ 的位数严格大于 $b$ 的位数，那么 $a$ 一定严格大于 $b$。

由于 $f[i][j]$ 中的最后一个数的位数为 $j-i+1$，那么上一个数的位数小于等于 $j-i$ 即可进行转移。上一个数的结尾在位置 $i - 1$，那么其开始下标需要大于等于：

$$
(i - 1) - (j - i) + 1 = 2i - j
$$

对应的状态即为：

$$
f[2i - j][i - 1], f[2i - j + 1, i - 1], \cdots, f[i - 1][i - 1]
$$

此外，我们还需要比较 $\textit{num}(2i - j - 1, i - 1)$ 和 $\textit{num}(i, j)$ 的值的大小关系，此时这两个数的位数都是 $j-i+1$。如果前者小于等于后者，那么 $f[i][j]$ 还可以从 $f[2i-j-1][i-1]$ 转移而来。因此，状态转移方程为：

$$
f[i][j] = \left\{
\begin{aligned}
& \sum_{k=2i-j}^{i-1} f[k][i-1], & \textit{num}(2i-j-1,i-1) > \textit{num}(i, j) \\
& \sum_{k=2i-j-1}^{i-1} f[k][i-1], & \textit{num}(2i-j-1,i-1) \leq \textit{num}(i, j)
\end{aligned}
\right.
$$

需要注意的是：为了防止状态转移方程显得过于复杂，我们在状态转移方程中：

- 没有考虑 $2i-j$ 和 $2i-j-1$ 是否超出边界。但在实际的代码编写中，需要保证求和式中 $k$ 的最小值不能小于 $0$；

- 没有考虑 $\textit{num}(i, j)$ 是否包含前导零。如果 $\textit{num}[i] = 0$，那么 $f[i][j] = 0$。特别地，如果 $\textit{num}[0] = 0$，那么不会有任何满足要求的划分方案，直接返回 $0$ 作为答案，无需进行动态规划。

动态规划的边界条件为 $f[0][..] = 1$，其余的状态的初始值均为 $0$。最终的答案即为所有 $f[..][n - 1]$ 的和，其中 $n$ 是字符串 $\textit{num}$ 的长度。

**前缀和优化**

即使我们不考虑如何快速地比较 $\textit{num}(2i-j-1,i-1)$ 和 $\textit{num}(i, j)$ 的大小关系，上述动态规划的时间复杂度也为 $O(n^3)$：即我们需要 $O(n^2)$ 的时间枚举 $i$ 和 $j$，还需要 $O(n)$ 的时间枚举 $k$ 计算对应项的和。

然而我们可以发现，这些和是「连续」的，因此我们可以使用前缀和进行优化。设 $\textit{pre}[i][j]$ 表示：

$$
\textit{pre}[i][j] = \sum_{k=0}^{i} f[i][j]
$$

那么状态转移方程可以改写为：

$$
f[i][j] = \left\{
\begin{aligned}
& \textit{pre}[i-1][i-1] - \textit{pre}[2i-j-1][i-1], & \textit{num}(2i-j-1,i-1) > \textit{num}(i, j) \\
& \textit{pre}[i-1][i-1] - \textit{pre}[2i-j-2][i-1], & \textit{num}(2i-j-1,i-1) \leq \textit{num}(i, j)
\end{aligned}
\right.
$$

只要在计算 $f$ 的过程中维护 $\textit{pre}$，就可以将动态规划的时间复杂度优化至 $O(n^2)$。

此外，我们也可以无需显式地使用前缀和数组：如果我们按照先枚举 $i$ 再枚举 $j$ 的顺序计算 $f[i][j]$，那么有：

$$
f[i][j] = \sum_{k=2i-j}^{i-1} f[k][i-1]
$$

这里我们不考虑 $\textit{num}(2i-j-1,i-1)$ 和 $\textit{num}(i, j)$ 的大小关系，即使前者小于等于后者，多出的 $f[2i-j-1][i-1]$ 这一项也可以 $O(1)$ 的时间累加进 $f[i][j]$，无需刻意前缀和进行优化。

当 $j \to j+1$ 时：

$$
f[i][j+1] = \sum_{k=2i-j-1}^{i-1} f[k][i-1]
$$

可以发现，$f[i][j+1]$ 只比 $f[i][j]$ 多出了 $f[2i-j-1][i-1]$ 这一项，因此在求得 $f[i][j]$ 的前提下，我们需要 $O(1)$ 的时间即可得到 $f[i][j+1]$。

**快速比较两个数的大小关系**

此时，我们只剩最后一步，也就是快速比较 $\textit{num}(2i-j-1,i-1)$ 和 $\textit{num}(i, j)$ 的大小关系了。这一步可以使用预处理巧妙地解决。

记 $\textit{lcp}[i][j]$ 表示在字符串 $\textit{nums}$ 中，以 $i$ 开始的后缀与以 $j$ 开始的后缀的「最长公共前缀」的长度。直观上看，它表示：

- $\textit{num}(i, i + \textit{lcp}[i][j] - 1) = \textit{num}(j, j + \textit{lcp}[i][j] - 1)$；

- $\textit{num}[i + \textit{lcp}[i][j]] \neq \textit{num}[j + \textit{lcp}[i][j]]$ 或者其中某一下标超出边界。

$\textit{lcp}[i][j]$ 可以很方便地使用动态规划求出，即：

$$
\textit{lcp}[i][j] = \begin{cases}
\textit{lcp}[i+1][j+1] + 1, & \quad \textit{num}[i] = \textit{num}[j] \\
0, & \quad \textit{num}[i] \neq \textit{num}[j]
\end{cases}
$$

当我们求出了 $\textit{lcp}$ 后，就可以方便地比较 $\textit{num}$ 中两个子串的大小关系了。对于 $\textit{num}(2i-j-1,i-1)$ 和 $\textit{num}(i, j)$：

- 如果 $\textit{lcp}[2i-j-1][i] \geq j-i+1$，那么 $\textit{num}(2i-j-1,i-1)$ 一定等于 $\textit{num}(i, j)$；

- 如果 $\textit{lcp}[2i-j-1][i] < j-i+1$，那么 $\textit{num}(2i-j-1,i-1)$ 和 $\textit{num}(i, j)$ 的大小关系，等同于 $\textit{num}[2i-j-1+\textit{lcp}[2i-j-1][i]]$ 与 $\textit{num}[i+\textit{lcp}[2i-j-1][i]]$ 的大小关系。

这样做的原因在于，两个长度相等的数的「数值」大小关系是等同于它们「字典序」的大小关系的。因此我们找出这两个数的最长公共前缀，再比较最长公共前缀的下一个字符的大小关系即可。

至此，我们就将动态规划的时间复杂度完全优化至 $O(n^2)$，也就可以通过本题了。

**注解**

$\textit{lcp}$ 来源于 $\text{\textbf{L}ongest \textbf{C}ommon \textbf{P}refix}$，即最长公共前缀。如果读者研究过算法竞赛，学习过「后缀数组」，那么上述的 $\textit{lcp}$ 是可以通过后缀数组 + $\text{ST}$ 表在 $O(n \log n)$ 的时间内预处理得到的。但这已经远远超出了面试和笔试的难度，因此这里不再深入解释。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int mod = 1000000007;

public:
    int numberOfCombinations(string num) {
        if (num[0] == '0') {
            return 0;
        }

        int n = num.size();

        // 预处理 lcp
        vector<vector<int>> lcp(n, vector<int>(n));
        for (int i = n - 1; i >= 0; --i) {
            lcp[i][n - 1] = (num[i] == num[n - 1]);
            for (int j = i + 1; j < n - 1; ++j) {
                lcp[i][j] = (num[i] == num[j] ? lcp[i + 1][j + 1] + 1 : 0);
            }
        }

        // 辅助函数，计算 x = (x + y) % mod
        auto update = [&](int& x, int y) {
            x += y;
            if (x >= mod) {
                x -= mod;
            }
        };

        // 动态规划
        vector<vector<int>> f(n, vector<int>(n));
        // 边界 f[0][..] = 1
        for (int i = 0; i < n; ++i) {
            f[0][i] = 1;
        }
        for (int i = 1; i < n; ++i) {
            // 有前导零，无需转移
            if (num[i] == '0') {
                continue;
            }
            // 前缀和
            int presum = 0;
            for (int j = i; j < n; ++j) {
                int length = j - i + 1;
                f[i][j] = presum;
                if (i - length >= 0) {
                    // 使用 lcp 比较 num(2i-j-1,i-1) 与 num(i,j) 的大小关系
                    if (lcp[i - length][i] >= length || num[i - length + lcp[i - length][i]] < num[i + lcp[i - length][i]]) {
                        update(f[i][j], f[i - length][i - 1]);
                    }
                    // 更新前缀和
                    update(presum, f[i - length][i - 1]);
                }
            }
        }

        // 最终答案即为所有 f[..][n-1] 的和
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            update(ans, f[i][n - 1]);
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def numberOfCombinations(self, num: str) -> int:
        mod = 10**9 + 7

        if num[0] == "0":
            return 0

        n = len(num)

        # 预处理 lcp
        lcp = [[0] * n for _ in range(n)]
        for i in range(n - 1, -1, -1):
            lcp[i][n - 1] = int(num[i] == num[n - 1])
            for j in range(i + 1, n - 1):
                lcp[i][j] = (lcp[i + 1][j + 1] + 1 if num[i] == num[j] else 0)

        # 动态规划
        f = [[0] * n for _ in range(n)]
        # 边界 f[0][..] = 1
        for i in range(n):
            f[0][i] = 1
        
        for i in range(1, n):
            # 有前导零，无需转移
            if num[i] == "0":
                continue
            
            # 前缀和
            presum = 0
            for j in range(i, n):
                length = j - i + 1
                f[i][j] = presum % mod
                if i - length >= 0:
                    # 使用 lcp 比较 num(2i-j-1,i-1) 与 num(i,j) 的大小关系
                    if lcp[i - length][i] >= length or num[i - length + lcp[i - length][i]] < num[i + lcp[i - length][i]]:
                        f[i][j] = (f[i][j] + f[i - length][i - 1]) % mod
                    # 更新前缀和
                    presum += f[i - length][i - 1]

        # 最终答案即为所有 f[..][n-1] 的和
        ans = sum(f[i][n - 1] for i in range(n)) % mod
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是字符串 $\textit{num}$ 的长度。

- 空间复杂度：$O(n^2)$，即为数组 $f$ 和 $\textit{lcp}$ 需要使用的空间。
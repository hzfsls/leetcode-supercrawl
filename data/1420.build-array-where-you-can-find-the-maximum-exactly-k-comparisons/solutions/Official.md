## [1420.生成数组 中文官方题解](https://leetcode.cn/problems/build-array-where-you-can-find-the-maximum-exactly-k-comparisons/solutions/100000/sheng-cheng-shu-zu-by-leetcode-solution-yswf)
#### 方法一：动态规划

**说明**

为了叙述方便，我们用关键词「搜索代价」代替 `search_cost`。

**分析**

我们可以使用动态规划解决这个问题。

我们用 $f[i][s][j]$ 表示长度为 $i$，搜索代价为 $s$，最大值为 $j$ 的数组的数量。在设计状态转移方程时，我们考虑枚举数组中的最后一个数（第 $i$ 个数），也就是说，$f[i][s][j]$ 会从 $f[i-1][..][..]$ 转移而来。我们可以这样思考：

- 如果第 $i$ 个数没有改变搜索代价，那么说明它不严格大于数组中的前 $i-1$ 个数。也就是说，$f[i][s][j]$ 会从 $f[i-1][s][j]$ 转移而来，即数组中的前 $i-1$ 个数的最大值已经是 $j$ 了，第 $i$ 个数没有改变最大值。在这种情况下，第 $i$ 个数可以在 $[1,j]$ 的范围中任意选择，即：

    $$
    f[i][s][j] = f[i-1][s][j] * j
    $$

- 如果第 $i$ 个数改变了搜索代价，那么说明前 $i-1$ 个数的最大值严格小于 $j$，并且第 $i$ 个数恰好等于 $j$。此时，$f[i][s][j]$ 会从所有的 $f[i-1][s-1][j']$ 转移而来，其中 $j' < j$，即：

    $$
    f[i][s][j] = \sum_{j'=1}^{j-1} f[i-1][s-1][j]
    $$

将上面的两种情况相加，就可以得到状态转移方程：

$$
f[i][s][j] = f[i-1][s][j] * j + \sum_{j'=1}^{j-1} f[i-1][s-1][j]
$$

最终的答案即为所有 $f[n][k][..]$ 的和。

```C++ [sol1-C++]
class Solution {
private:
    int f[51][51][101];
    static constexpr int mod = 1000000007;

public:
    int numOfArrays(int n, int m, int k) {
        // 不存在搜索代价为 0 的数组
        if (!k) {
            return 0;
        }
        
        memset(f, 0, sizeof(f));
        // 边界条件，所有长度为 1 的数组的搜索代价都为 1
        for (int j = 1; j <= m; ++j) {
            f[1][1][j] = 1;
        }
        for (int i = 2; i <= n; ++i) {
            // 搜索代价不会超过数组长度
            for (int s = 1; s <= k && s <= i; ++s) {
                for (int j = 1; j <= m; ++j) {
                    f[i][s][j] = (long long)f[i - 1][s][j] * j % mod;
                    for (int j0 = 1; j0 < j; ++j0) {
                        f[i][s][j] += f[i - 1][s - 1][j0];
                        f[i][s][j] %= mod;
                    }
                }
            }
        }

        // 最终的答案是所有 f[n][k][..] 的和
        // 即数组长度为 n，搜索代价为 k，最大值任意
        int ans = 0;
        for (int j = 1; j <= m; ++j) {
            ans += f[n][k][j];
            ans %= mod;
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def numOfArrays(self, n: int, m: int, k: int) -> int:
        # 不存在搜索代价为 0 的数组
        if k == 0:
            return 0

        f = [[[0] * (m + 1) for _ in range(k + 1)] for __ in range(n + 1)]
        mod = 10**9 + 7
        # 边界条件，所有长度为 1 的数组的搜索代价都为 1
        for j in range(1, m + 1):
            f[1][1][j] = 1
        for i in range(2, n + 1):
            # 搜索代价不会超过数组长度
            for s in range(1, min(k, i) + 1):
                for j in range(1, m + 1):
                    f[i][s][j] = f[i - 1][s][j] * j
                    for j0 in range(1, j):
                        f[i][s][j] += f[i - 1][s - 1][j0]
                    f[i][s][j] %= mod
        
        # 最终的答案是所有 f[n][k][..] 的和
        # 即数组长度为 n，搜索代价为 k，最大值任意
        ans = sum(f[n][k][j] for j in range(1, m + 1)) % mod
        return ans
```

```Java [sol1-Java]
class Solution {
    int[][][] f = new int[51][51][101];
    final int MOD = 1000000007;

    public int numOfArrays(int n, int m, int k) {
        // 不存在搜索代价为 0 的数组
        if (k == 0) {
            return 0;
        }
        
        // 边界条件，所有长度为 1 的数组的搜索代价都为 1
        for (int j = 1; j <= m; j++) {
            f[1][1][j] = 1;
        }
        for (int i = 2; i <= n; ++i) {
            // 搜索代价不会超过数组长度
            for (int s = 1; s <= k && s <= i; ++s) {
                for (int j = 1; j <= m; ++j) {
                    f[i][s][j] = (int) ((long) f[i - 1][s][j] * j % MOD);
                    for (int j0 = 1; j0 < j; ++j0) {
                        f[i][s][j] += f[i - 1][s - 1][j0];
                        f[i][s][j] %= MOD;
                    }
                }
            }
        }

        // 最终的答案是所有 f[n][k][..] 的和
        // 即数组长度为 n，搜索代价为 k，最大值任意
        int ans = 0;
        for (int j = 1; j <= m; ++j) {
            ans += f[n][k][j];
            ans %= MOD;
        }
        return ans;
    }
}
```

**复杂度分析**

- 时间复杂度：$O(NM^2K)$。在进行动态规划时，我们需要使用三重循环遍历所有的 $f[i][s][j]$，循环的次数分别为 $O(N)$，$O(K)$ 和 $O(M)$。在进行状态的转移时，我们还需要额外 $O(j) = O(M)$ 的时间计算 $f[i][s][j]$ 的值。

- 空间复杂度：$O(NMK)$，即为数组 $f$ 需要的空间。

#### 方法二：前缀和优化

我们重新写下方法一中的状态转移方程：

$$
f[i][s][j] = f[i-1][s][j] * j + \sum_{j'=1}^{j-1} f[i-1][s-1][j]
$$

从上面的状态转移方程中，我们可以看出：方法一的时间复杂度瓶颈在于右侧的求和操作，对于每一个 $f[i][s][j]$ 需要使用 $O(j)$ 的时间计算这个和。

然而这个求和操作是一个 **前缀和**，也就是说：

$$
\begin{aligned}
& f[i][s][j] &= \ldots + \sum_{j'=1}^{j-1} f[i-1][s-1][j] \\
& f[i][s][j+1] &= \ldots + \sum_{j'=1}^{j} f[i-1][s-1][j] \\
\end{aligned}
$$

$f[i][s][j+1]$ 的求和部分只比 $f[i][s][j]$ 多出一个 $f[i-1][s-1][j]$，因此我们不需要每次使用 $O(j)$ 的时间计算，而是使用一个变量存储这个前缀和，每次使用 $O(1)$ 的时间将其累加 $f[i-1][s-1][j]$ 进行更新即可。

```C++ [sol2-C++]
class Solution {
private:
    int f[51][51][101];
    static constexpr int mod = 1000000007;

public:
    int numOfArrays(int n, int m, int k) {
        // 不存在搜索代价为 0 的数组
        if (!k) {
            return 0;
        }
        
        memset(f, 0, sizeof(f));
        // 边界条件，所有长度为 1 的数组的搜索代价都为 1
        for (int j = 1; j <= m; ++j) {
            f[1][1][j] = 1;
        }
        for (int i = 2; i <= n; ++i) {
            // 搜索代价不会超过数组长度
            for (int s = 1; s <= k && s <= i; ++s) {
                // 前缀和
                int presum_j = 0;
                for (int j = 1; j <= m; ++j) {
                    f[i][s][j] = (long long)f[i - 1][s][j] * j % mod;
                    f[i][s][j] = (f[i][s][j] + presum_j) % mod;
                    presum_j = (presum_j + f[i - 1][s - 1][j]) % mod;
                }
            }
        }

        // 最终的答案是所有 f[n][k][..] 的和
        // 即数组长度为 n，搜索代价为 k，最大值任意
        int ans = 0;
        for (int j = 1; j <= m; ++j) {
            ans += f[n][k][j];
            ans %= mod;
        }
        return ans;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def numOfArrays(self, n: int, m: int, k: int) -> int:
        # 不存在搜索代价为 0 的数组
        if k == 0:
            return 0

        f = [[[0] * (m + 1) for _ in range(k + 1)] for __ in range(n + 1)]
        mod = 10**9 + 7
        # 边界条件，所有长度为 1 的数组的搜索代价都为 1
        for j in range(1, m + 1):
            f[1][1][j] = 1
        for i in range(2, n + 1):
            # 搜索代价不会超过数组长度
            for s in range(1, min(k, i) + 1):
                # 前缀和
                presum_j = 0
                for j in range(1, m + 1):
                    f[i][s][j] = (f[i - 1][s][j] * j + presum_j) % mod
                    presum_j += f[i - 1][s - 1][j]
        
        # 最终的答案是所有 f[n][k][..] 的和
        # 即数组长度为 n，搜索代价为 k，最大值任意
        ans = sum(f[n][k][j] for j in range(1, m + 1)) % mod
        return ans
```

```Java [sol2-Java]
class Solution {
    int[][][] f = new int[51][51][101];
    final int MOD = 1000000007;

    public int numOfArrays(int n, int m, int k) {
        // 不存在搜索代价为 0 的数组
        if (k == 0) {
            return 0;
        }
        
        // 边界条件，所有长度为 1 的数组的搜索代价都为 1
        for (int j = 1; j <= m; ++j) {
            f[1][1][j] = 1;
        }
        for (int i = 2; i <= n; ++i) {
            // 搜索代价不会超过数组长度
            for (int s = 1; s <= k && s <= i; ++s) {
                // 前缀和
                int presum_j = 0;
                for (int j = 1; j <= m; ++j) {
                    f[i][s][j] = (int) ((long)f[i - 1][s][j] * j % MOD);
                    f[i][s][j] = (f[i][s][j] + presum_j) % MOD;
                    presum_j = (presum_j + f[i - 1][s - 1][j]) % MOD;
                }
            }
        }

        // 最终的答案是所有 f[n][k][..] 的和
        // 即数组长度为 n，搜索代价为 k，最大值任意
        int ans = 0;
        for (int j = 1; j <= m; ++j) {
            ans += f[n][k][j];
            ans %= MOD;
        }
        return ans;
    }
}
```

**复杂度分析**

- 时间复杂度：$O(NMK)$。在进行动态规划时，我们需要使用三重循环遍历所有的 $f[i][s][j]$，循环的次数分别为 $O(N)$，$O(K)$ 和 $O(M)$。在进行状态的转移时，我们使用前缀和进行优化，只需要 $O(1)$ 的时间计算 $f[i][s][j]$ 的值。

- 空间复杂度：$O(NMK)$，即为数组 $f$ 需要的空间。
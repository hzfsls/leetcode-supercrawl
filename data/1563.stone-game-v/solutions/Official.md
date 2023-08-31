## [1563.石子游戏 V 中文官方题解](https://leetcode.cn/problems/stone-game-v/solutions/100000/shi-zi-you-xi-v-by-leetcode-solution)

#### 方法一：动态规划

**思路与算法**

我们用 $f[l][r]$ 表示当 Alice 面对数组 $\textit{stoneValue}$ 中从位置 $l$ 到 $r$ 这一段连续的石子时，她能获得的最大分数。

由于 Alice 需要选择将这一段石子分成两部分，因此我们可以枚举分隔位置 $i$，左侧部分的石子从位置 $l$ 到 $i$，右侧部分的石子从位置 $i+1$ 到 $r$。记 $\textit{sum}(l, r)$ 表示位置 $l$ 到 $r$ 的石子的分数之和，根据题目要求：

- 如果 $\textit{sum}(l, i) < \textit{sum}(i+1, r)$，那么 Bob 会丢弃右侧部分，状态转移方程为：

    $$
    f[l][r] = f[l][i] + \textit{sum}(l, i)
    $$

- 如果 $\textit{sum}(l, i) > \textit{sum}(i+1, r)$，那么 Bob 会丢弃左侧部分，状态转移方程为：

    $$
    f[l][r] = f[i+1][r] + \textit{sum}(i+1, r)
    $$

- 如果 $\textit{sum}(l, i) = \textit{sum}(i+1, r)$，那么 Bob 会让 Alice 选择丢弃的部分，状态转移方程为：

    $$
    f[l][r] = \max\{ f[l][i], f[i+1][r] \} + \textit{sum}(l, i)
    $$

我们可以预先计算出 $\textit{sum}(l, r)$ 的值，可以使用前缀和或直接遍历计算的方法。在枚举 $i$ 时，我们可以同时计算出 $\textit{sum}(l, i)$ 的值，这样 $\textit{sum}(i+1, r)$ 的值就可以通过

$$
\textit{sum}(i+1, r) = \textit{sum}(l, r) - \textit{sum}(l, i)
$$

在 $O(1)$ 的时间得出。

当只剩下一颗石子时，Alice 的得分为 $0$，对应的边界条件为：

$$
f[l][l] = 0
$$

最终的答案即为 $f[0][n-1]$，其中 $n$ 是数组 $\textit{stoneValue}$ 的长度。

**注意**：如果使用三重循环枚举 $l$，$r$，$i$ 进行状态转移，那么 `C++` 语言的代码可能会超出时间限制。因此下面给出的代码使用了自顶向下的记忆化搜索方法来完成动态规划。这样可以跳过一部分无需计算的状态，并在合理的时间内通过本题。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    vector<vector<int>> f;

public:
    int dfs(const vector<int>& stoneValue, int left, int right) {
        if (left == right) {
            return 0;
        }
        if (f[left][right]) {
            return f[left][right];
        }

        int sum = accumulate(stoneValue.begin() + left, stoneValue.begin() + right + 1, 0);
        int suml = 0;
        for (int i = left; i < right; ++i) {
            suml += stoneValue[i];
            int sumr = sum - suml;
            if (suml < sumr) {
                f[left][right] = max(f[left][right], dfs(stoneValue, left, i) + suml);
            } else if (suml > sumr) {
                f[left][right] = max(f[left][right], dfs(stoneValue, i + 1, right) + sumr);
            } else {
                f[left][right] = max(f[left][right], max(dfs(stoneValue, left, i), dfs(stoneValue, i + 1, right)) + suml);
            }
        }
        return f[left][right];
    }

    int stoneGameV(vector<int>& stoneValue) {
        int n = stoneValue.size();
        f.assign(n, vector<int>(n));
        return dfs(stoneValue, 0, n - 1);
    }
};
```

```Java [sol1-Java]
class Solution {
    int[][] f;

    public int stoneGameV(int[] stoneValue) {
        int n = stoneValue.length;
        f = new int[n][n];
        return dfs(stoneValue, 0, n - 1);
    }

    public int dfs(int[] stoneValue, int left, int right) {
        if (left == right) {
            return 0;
        }
        if (f[left][right] != 0) {
            return f[left][right];
        }

        int sum = 0;
        for (int i = left; i <= right; ++i) {
            sum += stoneValue[i];
        }
        int suml = 0;
        for (int i = left; i < right; ++i) {
            suml += stoneValue[i];
            int sumr = sum - suml;
            if (suml < sumr) {
                f[left][right] = Math.max(f[left][right], dfs(stoneValue, left, i) + suml);
            } else if (suml > sumr) {
                f[left][right] = Math.max(f[left][right], dfs(stoneValue, i + 1, right) + sumr);
            } else {
                f[left][right] = Math.max(f[left][right], Math.max(dfs(stoneValue, left, i), dfs(stoneValue, i + 1, right)) + suml);
            }
        }
        return f[left][right];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def stoneGameV(self, stoneValue: List[int]) -> int:
        @lru_cache(None)
        def dfs(left: int, right: int) -> int:
            if left == right:
                return 0
            
            total = sum(stoneValue[left:right+1])
            suml = ans = 0
            for i in range(left, right):
                suml += stoneValue[i]
                sumr = total - suml
                if suml < sumr:
                    ans = max(ans, dfs(left, i) + suml)
                elif suml > sumr:
                    ans = max(ans, dfs(i + 1, right) + sumr)
                else:
                    ans = max(ans, max(dfs(left, i), dfs(i + 1, right)) + suml)
            return ans
        
        n = len(stoneValue)
        return dfs(0, n - 1)
```

**复杂度分析**

- 时间复杂度：$O(n^3)$，其中 $n$ 是数组 $\textit{stoneValue}$ 的长度。

- 空间复杂度：$O(n^2)$，为存储所有状态需要的空间。

#### 方法二：动态规划优化

**说明**

本方法为进阶方法，但无需高级的优化技巧，感兴趣的读者可以尝试学习。

**思路与算法**

考虑某次状态转移中的 $l$，$r$，$i$，如果 $\textit{sum}(l, i) < \textit{sum}(i+1, r)$，那么有状态转移方程：

$$
f[l][r] = f[l][i] + \textit{sum}(l, i)
$$

而对于 $r+1$ 而言，$\textit{sum}(l, i) < \textit{sum}(i+1, r+1)$ 一定也成立，那么有状态转移方程：

$$
f[l][r+1] = f[l][i] + \textit{sum}(l, i)
$$

可以发现这两个状态转移方程的右侧相同，$f[l][i] + \textit{sum}(l, i)$ 被重复计算，这也是方法一的瓶颈所在。因此，我们可以考虑维护两个辅助数组 $\textit{maxl}$ 和 $\textit{maxr}$：

$$
\left \{ \begin{aligned}
\textit{maxl}[l][r] &= \max_{i=l}^r \big\{ f[l][i] + \textit{sum}(l, i) \big\} \\ \\
\textit{maxr}[l][r] &= \max_{i=l}^r \big\{ f[i][r] + \textit{sum}(i, r) \big\}
\end{aligned} \right.
$$

这样一来，对于任意的 $l$，$r$，存在 $i_0 \in [l-1, r)$ 满足：

$$
\left \{ \begin{aligned}
& \textit{sum}(l, i_0) \leq \textit{sum}(i_0+1, r) \\
& \textit{sum}(l, i_0+1) > \textit{sum}(i_0+2, r)
\end{aligned} \right.
$$

> 其中 $\textit{sum}(x, y)$ 在 $x > y$ 时的值为 $0$。

那么当 $i \leq i_0$ 时，对应的状态转移方程合并在一起即为：

$$
f[l][r] = \textit{maxl}[l][i_0]
$$

当 $i > i_0$ 时，对应的状态转移方程合并在一起即为：

$$
f[l][r] = \textit{maxr}[i_0+2][r]
$$

特别地，如果 $\textit{sum}(l, i_0) = \textit{sum}(i_0+1, r)$，还可以有额外的转移：

$$
f[l][r] = \textit{maxr}[i_0+1][r]
$$

因此，**如果我们知道数组 $\textit{maxl}$，数组 $\textit{maxr}$ 以及 $i_0$**，那么就可以在 $O(1)$ 的时间计算出 $f[l][r]$，完成状态转移。那么我们如何计算出这些需要的信息呢？

**细节**

观察数组 $\textit{maxl}$ 和 $\textit{maxr}$ 的表示，它提示我们可以使用递推的方法，在枚举 $l$，$r$ 并计算 $f[l][r]$ 的同时，计算出 $\textit{maxl}[l][r]$ 和 $\textit{maxr}[l][r]$：

$$
\left \{ \begin{aligned}
\textit{maxl}[l][r] &= \max \{ \textit{maxl}[l][r-1], f[l][r] + \textit{sum}(l, r) \} \\
\textit{maxr}[l][r] &= \max \{ \textit{maxr}[l+1][r], f[l][r] + \textit{sum}(i, r) \}
\end{aligned} \right.
$$

边界条件为：

$$
\textit{maxl}[l][l] = \textit{maxr}[l][l] = \textit{stoneValue}[l]
$$

而对于 $i_0$，记 $i_{l,r}$ 表示在枚举 $l$，$r$ 时 $i_0$ 的值，由于数组 $\textit{stoneValue}$ 中所有的数都是正整数，那么有

$$
i_{l,r} \leq i_{l,r+1}
$$

即固定 $l$，$i_{l,r}$ 是单调递增的。因此我们可以递减地枚举 $l$ 并且（在固定 $l$ 时）递增地枚举 $r$，同时维护 $i_{l,r}$：

- $i_{l,r}$ 的初始值为 $i_{l,l} = l-1$；

- 当我们已知 $i_{l,r}$ 时，要求出 $i_{l,r+1}$，我们只需不断地增加 $i_{l,r}$，直到 $\textit{sum}(l, i_{l,r}) \leq \textit{sum}(i_{l,r}+1, r+1)$ 不满足为止。此时 $i_{l,r+1}$ 的值就为 $i_{l,r} - 1$。

这样一来，计算 $\textit{maxl}[l][r]$ 和 $\textit{maxr}[l][r]$ 的时间为 $O(1)$，计算 $i_0$ 的时间为均摊 $O(1)$，我们就可以在 $O(1)$ 的时间计算出 $f[l][r]$ 了。

**代码**

```C++ [sol2-C++]
class Solution {
private:
    vector<vector<int>> f;
    vector<vector<int>> maxl, maxr;

public:
    int stoneGameV(vector<int>& stoneValue) {
        int n = stoneValue.size();
        f.assign(n, vector<int>(n));
        maxl.assign(n, vector<int>(n));
        maxr.assign(n, vector<int>(n));
        for (int left = n - 1; left >= 0; --left) {
            maxl[left][left] = maxr[left][left] = stoneValue[left];
            int sum = stoneValue[left], suml = 0;
            for (int right = left + 1, i = left - 1; right < n; ++right) {
                sum += stoneValue[right];
                while (i + 1 < right && (suml + stoneValue[i + 1]) * 2 <= sum) {
                    suml += stoneValue[i + 1];
                    ++i;
                }
                if (left <= i) {
                    f[left][right] = max(f[left][right], maxl[left][i]);
                }
                if (i + 1 < right) {
                    f[left][right] = max(f[left][right], maxr[i + 2][right]);
                }
                if (suml * 2 == sum) {
                    f[left][right] = max(f[left][right], maxr[i + 1][right]);
                }
                maxl[left][right] = max(maxl[left][right - 1], sum + f[left][right]);
                maxr[left][right] = max(maxr[left + 1][right], sum + f[left][right]);
            }
        }
        return f[0][n - 1];
    }
};
```

```Java [sol2-Java]
class Solution {
    int[][] f;
    int[][] maxl;
    int[][] maxr;

    public int stoneGameV(int[] stoneValue) {
        int n = stoneValue.length;
        f = new int[n][n];
        maxl = new int[n][n];
        maxr = new int[n][n];
        for (int left = n - 1; left >= 0; --left) {
            maxl[left][left] = maxr[left][left] = stoneValue[left];
            int sum = stoneValue[left], suml = 0;
            for (int right = left + 1, i = left - 1; right < n; ++right) {
                sum += stoneValue[right];
                while (i + 1 < right && (suml + stoneValue[i + 1]) * 2 <= sum) {
                    suml += stoneValue[i + 1];
                    ++i;
                }
                if (left <= i) {
                    f[left][right] = Math.max(f[left][right], maxl[left][i]);
                }
                if (i + 1 < right) {
                    f[left][right] = Math.max(f[left][right], maxr[i + 2][right]);
                }
                if (suml * 2 == sum) {
                    f[left][right] = Math.max(f[left][right], maxr[i + 1][right]);
                }
                maxl[left][right] = Math.max(maxl[left][right - 1], sum + f[left][right]);
                maxr[left][right] = Math.max(maxr[left + 1][right], sum + f[left][right]);
            }
        }
        return f[0][n - 1];
    }
}
```

```Python [sol2-Python3]
class Solution:
    def stoneGameV(self, stoneValue: List[int]) -> int:
        n = len(stoneValue)
        f = [[0] * n for _ in range(n)]
        maxl = [[0] * n for _ in range(n)]
        maxr = [[0] * n for _ in range(n)]

        for left in range(n - 1, -1, -1):
            maxl[left][left] = maxr[left][left] = stoneValue[left]
            total = stoneValue[left]
            suml = 0
            i = left - 1
            for right in range(left + 1, n):
                total += stoneValue[right]
                while i + 1 < right and (suml + stoneValue[i + 1]) * 2 <= total:
                    suml += stoneValue[i + 1]
                    i += 1
                if left <= i:
                    f[left][right] = max(f[left][right], maxl[left][i])
                if i + 1 < right:
                    f[left][right] = max(f[left][right], maxr[i + 2][right])
                if suml * 2 == total:
                    f[left][right] = max(f[left][right], maxr[i + 1][right])
                maxl[left][right] = max(maxl[left][right - 1], total + f[left][right])
                maxr[left][right] = max(maxr[left + 1][right], total + f[left][right])
        
        return f[0][n - 1]
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是数组 $\textit{stoneValue}$ 的长度。

- 空间复杂度：$O(n^2)$，为存储所有状态以及辅助数组需要的空间。
#### 方法一：动态规划 + 预处理

**思路与算法**

题目描述等价于：

> 给定数组 $\textit{nums}$ 以及整数 $k$，需要把数组完整地分成 $k+1$ 段连续的子数组，每一段的权值是「这一段的最大值**乘以**这一段的长度**再减去**这一段的元素和」。需要最小化总权值。

我们可以使用动态规划解决本题。

记 $f[i][j]$ 表示将 $\textit{nums}[0..i]$ 分成 $j$ 段的最小总权值。在进行状态转移时，我们可以枚举最后的一段，那么就有状态转移方程：

$$
f[i][j] = \min_{0 \leq i_0 \leq i} \{ f[i_0-1][j-1] + g[i_0][i] \}
$$

其中 $g[i_0][i]$ 表示「$\textit{nums}[i_0..i]$ 这一段的最大值**乘以**这一段的长度**再减去**这一段的元素和」。在进行动态规划之前，我们可以使用二重循环预处理出所有的 $g$ 值。

最终的答案即为 $f[n-1][k+1]$。

**细节**

在状态转移时我们需要枚举 $i_0$，而当 $i_0 = 0$ 时，$f[-1][j-1]$ 并不是一个合法的状态。

我们可以考虑 $f[-1][..]$ 表示的意义：对于一段空的数组，我们希望将它分成若干段。由于每一段至少都要有一个元素，那么「空的数组」只能够分成 $0$ 段，即 $f[-1][0] = 0$；而不能分成任意正整数段，即其余的 $f[-1][..] = \infty$（因为我们需要求出的是最小总权值，因此将不合法的状态标记为极大值）。

然而本题有一个很好的性质，即当 $k_1 < k_2$ 时，分成 $k_1$ 段的最小总权值一定不会小于分成 $k_2$ 段的最小总权值，因此将所有的 $f[-1][..]$ 都置为 $0$ 也是不会影响最终答案的。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minSpaceWastedKResizing(vector<int>& nums, int k) {
        int n = nums.size();

        // 预处理数组 g
        vector<vector<int>> g(n, vector<int>(n));
        for (int i = 0; i < n; ++i) {
            // 记录子数组的最大值
            int best = INT_MIN;
            // 记录子数组的和
            int total = 0;
            for (int j = i; j < n; ++j) {
                best = max(best, nums[j]);
                total += nums[j];
                g[i][j] = best * (j - i + 1) - total;
            }
        }
        
        vector<vector<int>> f(n, vector<int>(k + 2, INT_MAX / 2));
        for (int i = 0; i < n; ++i) {
            for (int j = 1; j <= k + 1; ++j) {
                for (int i0 = 0; i0 <= i; ++i0) {
                    f[i][j] = min(f[i][j], (i0 == 0 ? 0 : f[i0 - 1][j - 1]) + g[i0][i]);
                }
            }
        }

        return f[n - 1][k + 1];
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minSpaceWastedKResizing(self, nums: List[int], k: int) -> int:
        n = len(nums)
        
        # 预处理数组 g
        g = [[0] * n for _ in range(n)]
        for i in range(n):
            # 记录子数组的最大值
            best = float("-inf")
            # 记录子数组的和
            total = 0
            for j in range(i, n):
                best = max(best, nums[j])
                total += nums[j]
                g[i][j] = best * (j - i + 1) - total
        
        f = [[float("inf")] * (k + 2) for _ in range(n)]
        for i in range(n):
            for j in range(1, k + 2):
                for i0 in range(i + 1):
                    f[i][j] = min(f[i][j], (0 if i0 == 0 else f[i0 - 1][j - 1]) + g[i0][i])

        return f[n - 1][k + 1]
```

**复杂度分析**

- 时间复杂度：$O(n^2k)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。状态的数量为 $O(nk)$，每个状态需要 $O(n)$ 的时间枚举 $i_0$ 进行转移。

- 空间复杂度：$O(n(n+k))$。我们需要 $O(n^2)$ 的空间存储数组 $g$，$O(nk)$ 的空间存储所有的状态。
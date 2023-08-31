## [1937.扣分后的最大得分 中文官方题解](https://leetcode.cn/problems/maximum-number-of-points-with-cost/solutions/100000/kou-fen-hou-de-zui-da-de-fen-by-leetcode-60zl)

#### 方法一：动态规划

**思路与算法**

记 $f[i][j]$ 表示当我们在第 $0, 1, \cdots, i$ 行均选择了一个格子，并且第 $i$ 行选择的格子为 $(i, j)$ 时的最大分数。在进行状态转移时，我们可以枚举第 $i-1$ 行选择的格子 $j'$，这样就可以得到状态转移方程：

$$
f[i][j] = \max \big\{ f[i-1][j'] - |j - j'| \big\} + \textit{points}[i][j]
$$

最终的答案即为 $f[m-1][0..n-1]$ 中的最大值。

然而上述动态规划的时间复杂度为 $O(mn^2)$，因为总计有 $mn$ 个状态，而对于每个状态我们需要 $O(n)$ 的时间枚举 $j'$ 进行转移，这样很容易超出时间限制，因此我们需要进行优化。

**优化**

优化的重点在于状态转移方程中的 $|j-j'|$ 这一项。

当 $j' \leq j$ 时，$|j - j'| = j - j'$，状态转移方程变为：

$$
\begin{aligned}
f[i][j] &= \max \big\{ f[i-1][j'] - j + j' \big\} + \textit{points}[i][j] \\
&= \max \big\{ f[i-1][j'] + j' \big\} + \textit{points}[i][j] - j
\end{aligned}
$$

这样一来，我们只需要在满足 $j' \leq j$ 的前提下，找出最大的 $f[i-1][j'] + j'$ 进行转移即可。我们只需要在 $[0, n-1]$ 的范围内**正序**地遍历一遍 $j$，即可在 $O(n)$ 的时间完成这一部分的状态转移。

同理，当 $j' > j$ 时，$|j - j'| = j' - j$，状态转移方程变为：

$$
\begin{aligned}
f[i][j] &= \max \big\{ f[i-1][j'] - j' + j \big\} + \textit{points}[i][j] \\
&= \max \big\{ f[i-1][j'] - j' \big\} + \textit{points}[i][j] + j
\end{aligned}
$$

这样一来，我们只需要在满足 $j' > j$ 的前提下，找出最大的 $f[i-1][j'] - j'$ 进行转移即可。我们只需要在 $[0, n-1]$ 的范围内**倒序**地遍历一遍 $j$，即可在 $O(n)$ 的时间完成这一部分的状态转移。

在进行了两次 $O(n)$ 的遍历后，我们就得到了所有 $f[i][0..n-1]$ 的值，动态规划的总时间复杂度就优化为 $O(mn)$。

**细节**

当 $i=0$ 时，$f[i-1][..]$ 均为不合法状态，我们需要直接计算出它们的值，即 $f[0][j] = \textit{points}[0][j]$。

同时我们可以发现，在状态转移方程中 $f[i][..]$ 只会从 $f[i-1][..]$ 转移而来，因此我们可以使用两个一维数组代替二维数组 $f$ 进行状态转移。此时，我们可以无需特殊考虑 $i=0$ 时所有 $f[i][..]$ 的值。假设我们用来转移的两个数组为 $t_1$ 和 $t_2$，当 $i=0$ 时，我们使用 $t_1$ 对 $t_2$ 进行转移。由于 $t_1$ 的所有元素均为初始化的 $0$ 值，那么 $t_2[j]$ 一定是从同下标的 $t_1[j]$ 转移而来的（此时 $|j-j'|$ 的值最小），因此可以得到正确的 $t_2[j] = \textit{points}[0][j]$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    long long maxPoints(vector<vector<int>>& points) {
        int m = points.size();
        int n = points[0].size();
        vector<long long> f(n);
        for (int i = 0; i < m; ++i) {
            vector<long long> g(n);
            long long best = LLONG_MIN;
            // 正序遍历
            for (int j = 0; j < n; ++j) {
                best = max(best, f[j] + j);
                g[j] = max(g[j], best + points[i][j] - j);
            }
            best = LLONG_MIN;
            // 倒序遍历
            for (int j = n - 1; j >= 0; --j) {
                best = max(best, f[j] - j);
                g[j] = max(g[j], best + points[i][j] + j);
            }
            f = move(g);
        }
        return *max_element(f.begin(), f.end());
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maxPoints(self, points: List[List[int]]) -> int:
        m, n = len(points), len(points[0])
        f = [0] * n
        for i in range(m):
            g = [0] * n
            best = float("-inf")
            # 正序遍历
            for j in range(n):
                best = max(best, f[j] + j)
                g[j] = max(g[j], best + points[i][j] - j)
            
            best = float("-inf")
            # 倒序遍历
            for j in range(n - 1, -1, -1):
                best = max(best, f[j] - j)
                g[j] = max(g[j], best + points[i][j] + j)
            
            f = g
        
        return max(f)
```

**复杂度分析**

- 时间复杂度：$O(mn)$。

- 空间复杂度：$O(n)$。
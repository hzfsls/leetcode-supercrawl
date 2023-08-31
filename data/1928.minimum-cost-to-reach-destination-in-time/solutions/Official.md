## [1928.规定时间内到达终点的最小花费 中文官方题解](https://leetcode.cn/problems/minimum-cost-to-reach-destination-in-time/solutions/100000/gui-ding-shi-jian-nei-dao-da-zhong-dian-n3ews)

#### 方法一：动态规划

**思路与算法**

我们用 $f[t][i]$ 表示**使用恰好** $t$ 分钟到达城市 $i$ 需要的**最少**通行费总和。

在状态转移时，我们考虑最后一次通行是从城市 $j$ 到达城市 $i$ 的，那么有状态转移方程：

$$
f[t][i] = \min_{(j, i) \in E} \big\{ f[t-\textit{cost}(j, i)][j] + \textit{passingFees}[i] \big\}
$$

其中 $(j, i) \in E$ 表示城市 $j$ 与 $i$ 存在一条道路，$\textit{cost}(j, i)$ 表示这条道路的耗费时间。

最终的答案即为 $f[1][n-1], f[2][n-1], \cdots, f[\textit{maxTime}][n-1]$ 中的最小值。

**细节**

初始状态为 $f[0][0] = \textit{passingFees}[0]$，即我们一开始位于 $0$ 号城市，需要交 $\textit{passingFees}[0]$ 的通行费。

由于我们的状态转移方程中的目标的最小值，因此对于其它的状态，我们可以在一开始赋予它们一个极大值 $\infty$。如果最终的答案为 $\infty$，说明无法在 $\textit{maxTime}$ 及以内完成旅行，返回 $-1$。

此外，本题中的道路是以数组 $\textit{edges}$ 的形式给定的，在动态规划的过程中，如果我们使用两重循环枚举 $t$ 和 $i$，就不能利用 $\textit{edges}$，而需要使用额外的数据结构存储以 $i$ 为端点的所有道路。一种合理的解决方法是，我们使用一重循环枚举 $t$，另一重循环枚举 $\textit{edges}$ 中的每一条边 $(i, j, \textit{cost})$，通过这条边更新 $f[t][i]$ 以及 $f[t][j]$ 的值。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    // 极大值
    static constexpr int INFTY = INT_MAX / 2;

public:
    int minCost(int maxTime, vector<vector<int>>& edges, vector<int>& passingFees) {
        int n = passingFees.size();
        vector<vector<int>> f(maxTime + 1, vector<int>(n, INFTY));
        f[0][0] = passingFees[0];
        for (int t = 1; t <= maxTime; ++t) {
            for (const auto& edge: edges) {
                int i = edge[0], j = edge[1], cost = edge[2];
                if (cost <= t) {
                    f[t][i] = min(f[t][i], f[t - cost][j] + passingFees[i]);
                    f[t][j] = min(f[t][j], f[t - cost][i] + passingFees[j]);
                }
            }
        }

        int ans = INFTY;
        for (int t = 1; t <= maxTime; ++t) {
            ans = min(ans, f[t][n - 1]);
        }
        return ans == INFTY ? -1 : ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minCost(self, maxTime: int, edges: List[List[int]], passingFees: List[int]) -> int:
        n = len(passingFees)
        f = [[float("inf")] * n for _ in range(maxTime + 1)]
        f[0][0] = passingFees[0]
        for t in range(1, maxTime + 1):
            for i, j, cost in edges:
                if cost <= t:
                    f[t][i] = min(f[t][i], f[t - cost][j] + passingFees[i])
                    f[t][j] = min(f[t][j], f[t - cost][i] + passingFees[j])

        ans = min(f[t][n - 1] for t in range(1, maxTime + 1))
        return -1 if ans == float("inf") else ans
```

**复杂度分析**

- 时间复杂度：$O((n+m) \cdot \textit{maxTimes})$，其中 $m$ 是数组 $\textit{edges}$ 的长度。

    - 我们需要 $O(n \cdot \textit{maxTimes})$ 的时间初始化数组 $f$；

    - 动态规划需要的时间为 $O(m \cdot \textit{maxTimes})$。

- 空间复杂度：$O(n \cdot \textit{maxTimes})$。
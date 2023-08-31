## [2088.统计农场中肥沃金字塔的数目 中文官方题解](https://leetcode.cn/problems/count-fertile-pyramids-in-a-land/solutions/100000/tong-ji-nong-chang-zhong-fei-wo-jin-zi-t-paok)
#### 方法一：动态规划

**思路与算法**

我们首先考虑所有的「金字塔」。

如果我们能够计算出以每一个位置 $(i, j)$ 为顶端的**最大**的金字塔的高度：

> 这里我们对于高度的定义如下：
> - 如果 $(i, j)$ 本身不是肥沃的，那么最大的金字塔的高度为 $-1$；
> - 如果 $(i, j)$ 本身是肥沃的，但是它无法作为任何金字塔的顶端，那么最大的金字塔的高度为 $0$；
> - 如果 $(i, j)$ 本身是肥沃的，并且以它为顶端的最大金字塔有 $x$ 行，那么最大的金字塔的高度为 $x-1$。

记为 $f[i, j]$，那么只要 $(i, j)$ 本身是肥沃的，那么以 $(i, j)$ 为顶端的金字塔的高度就可以为 $1, 2, \cdots, f[i, j]$，即一共有 $f[i, j]$ 个金字塔。此时，所有 $f[i, j]$ 的和即为金字塔的总数。

要想求出 $f[i, j]$，我们可以考虑形成金字塔的**充要条件**。要想形成一个以 $(i, j)$ 为顶端并且高度为 $x$ 的金字塔，当且仅当：

- $f[i, j]$ 本身是肥沃的；

- 存在以 $(i+1, j-1)$ 为顶端，高度为 $x-1$ 的金字塔；

- 存在以 $(i+1, j)$ 为顶端，高度为 $x-1$ 的金字塔；

- 存在以 $(i+1, j+1)$ 为顶端，高度为 $x-1$ 的金字塔；

![fig1](https://assets.leetcode-cn.com/solution-static/5925/5925.png)

上图可视化地描述了这四个条件。这说明 $x$ 的最大值取决于 $(i, j)$ 下方左中右三个位置为顶端的金字塔高度的**最小值**，因此：

- 如果 $(i, j)$ 本身不是肥沃的，那么 $f[i, j] = -1$；

- 如果 $(i, j)$ 本身是肥沃的，那么有：

    $$
    f[i, j] = \min \big\{ f[i+1, j-1], f[i+1, j], f[i+1, j+1] \big\} + 1
    $$

这里规定所有超出边界的 $f[i, j]$ 的值均为 $-1$。

而在考虑「倒金字塔」时，由于它只是把金字塔倒过来，因此我们只需要把上面的状态转移方程中的 $i+1$ 全部改成 $i-1$ 即可：

$$
f[i, j] = \min \big\{ f[i-1, j-1], f[i-1, j], f[i-1, j+1] \big\} + 1
$$

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countPyramids(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();
        vector<vector<int>> f(m, vector<int>(n));
        int ans = 0;
        // 金字塔
        for (int i = m - 1; i >= 0; --i) {
            for (int j = 0; j < n; ++j) {
                if (grid[i][j] == 0) {
                    f[i][j] = -1;
                }
                else if (i == m - 1 || j == 0 || j == n - 1) {
                    f[i][j] = 0;
                }
                else {
                    f[i][j] = min({f[i + 1][j - 1], f[i + 1][j], f[i + 1][j + 1]}) + 1;
                    ans += f[i][j];
                }
            }
        }
        // 倒金字塔
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (grid[i][j] == 0) {
                    f[i][j] = -1;
                }
                else if (i == 0 || j == 0 || j == n - 1) {
                    f[i][j] = 0;
                }
                else {
                    f[i][j] = min({f[i - 1][j - 1], f[i - 1][j], f[i - 1][j + 1]}) + 1;
                    ans += f[i][j];
                }
            }
        }
        
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def countPyramids(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        f = [[0] * n for _ in range(m)]
        ans = 0

        # 金字塔
        for i in range(m - 1, -1, -1):
            for j in range(n):
                if grid[i][j] == 0:
                    f[i][j] = -1
                elif i == m - 1 or j == 0 or j == n - 1:
                    f[i][j] = 0
                else:
                    f[i][j] = min(f[i + 1][j - 1], f[i + 1][j], f[i + 1][j + 1]) + 1
                    ans += f[i][j]
        
        # 倒金字塔
        for i in range(m):
            for j in range(n):
                if grid[i][j] == 0:
                    f[i][j] = -1
                elif i == 0 or j == 0 or j == n - 1:
                    f[i][j] = 0
                else:
                    f[i][j] = min(f[i - 1][j - 1], f[i - 1][j], f[i - 1][j + 1]) + 1
                    ans += f[i][j]
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(mn)$。

- 空间复杂度：$O(mn)$，即为存储所有状态需要的空间。注意到在两种状态转移方程中，$f[i, j]$ 只会从 $f[i-1, ..]$ 或者 $f[i+1, ..]$ 转移而来，因此可以使用两个长度为 $n$ 的一维数组交替地进行状态转移，空间复杂度可以降低为 $O(n)$。
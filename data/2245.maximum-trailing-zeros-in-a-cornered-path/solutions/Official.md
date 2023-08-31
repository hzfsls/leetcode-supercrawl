## [2245.转角路径的乘积中最多能有几个尾随零 中文官方题解](https://leetcode.cn/problems/maximum-trailing-zeros-in-a-cornered-path/solutions/100000/zhuan-jiao-lu-jing-de-cheng-ji-zhong-zui-ibdk)

#### 方法一：维护各个方向的前缀和

**提示 $1$**

一定存在至少一个**两端位于数组边界**的路径，它的乘积的尾随零数量最多。

**提示 $1$ 解释**

我们可以用反证法证明。假设存在一条至少有一端不位于数组边界的路径，它的乘积尾随零数量大于任何两端位于数组边界的路径。

那么我们将该路径的**两个端点延长至数组边界**，此时乘积尾随零数量不可能减少，这就产生了矛盾。

**提示 $2$**

对于长宽不为 $1$ 的数组 $\textit{grid}$，一定存在至少一个**带有一个转角**的路径，它的乘积的尾随零数量最多。

**提示 $2$ 解释**

我们可以用反证法证明。假设存在一条不带转角的路径，它的乘积尾随零数量大于任何两端带有一个转角的路径。

那么我们将该路径的一个端点**沿着任意一个互相垂直的方向延伸**，此时乘积尾随零数量不可能减少，这就产生了矛盾。

**提示 $3$**

一条路径中乘积尾随零的数量等于该乘积质因数分解中因子 $2$ 的数目与因子 $5$ 的数目的**较小值**。

**思路与算法**

根据 **提示 $1$** 与 **提示 $2$**，对于任意一个确定的转角点，对应的乘积尾随零数量最大的路径一定是该点**沿着某一水平方向以及某一竖直方向延伸至数组边界的四条路径之一**。因此，我们可以遍历 $\textit{grid}$ 中的所有单元格，并维护每个单元格作为转角点，对应路径乘积尾随零最大数量的最大值。

如果我们对于每一个单元格，都暴力计算每条可能路径的对应值，那么我们遍历每个单元格都需要 $O(m + n)$ 的时间复杂度，总时间复杂度 $O(mn(m + n))$ 显然不符合题目要求。因此我们需要对算法的时间复杂度进行优化。

我们可以将每一条路径拆成 $3$ 个**互不相交的**部分，即转角点，水平方向延伸部分，竖直方向延伸部分。同时，根据 **提示 $3$**，我们用 $8$ 个二维数组 ${(l|r|u|d)}_{(2|5)}$ 表示每个点对应方向（左右上下）延伸部分乘积中 $2$ 或 $5$ 的因子个数。同时，我们用 $c_2(i, j)$ 与 $c_5(i, j)$ 表示 $(i, j)$ 坐标数值中 $2$ 或 $5$ 的因子个数。因此以 $(i, j)$ 转角点，对应的最大乘积尾随零数量一定是下列四个数值中的**最大值**：

$$
\min(u_2[i][j] + l_2[i][j] + c_2(i, j),\ u_5[i][j] + l_5[i][j] + c_5(i, j)) \\
\min(u_2[i][j] + r_2[i][j] + c_2(i, j),\ u_5[i][j] + r_5[i][j] + c_5(i, j)) \\
\min(d_2[i][j] + l_2[i][j] + c_2(i, j),\ d_5[i][j] + l_5[i][j] + c_5(i, j)) \\
\min(d_2[i][j] + r_2[i][j] + c_2(i, j),\ d_5[i][j] + r_5[i][j] + c_5(i, j)) \\
$$

而对于这 $8$ 个二维数组，以数组 $u_2$ 为例，我们有：

$$
u_2[i][j] = u_2[i-1][j] + c_2(i - 1, j).
$$

因此我们可以通过按照对应方向遍历数组，并以类似计算**前缀和**的方式，**预处理**更新这 $8$ 个二维数组。这样，我们可以将预处理与遍历的时间复杂度都优化至 $O(mn)$。

综上，我们首先通过计算前缀和的方式按照不同方向遍历数组预处理出上文的 $8$ 个二维数组，随后枚举转角点，计算对应路径乘积尾随零的最大数量，并维护这些数量的最大值。最终，我们返回该最大值作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maxTrailingZeros(vector<vector<int>>& grid) {
        int m = grid.size();
        int n = grid[0].size();
        // 计算一个整数质因数分解中 2 的数量
        auto cnt2 = [](int num) -> int {
            int res = 0;
            while (num % 2 == 0) {
                ++res;
                num /= 2;
            }
            return res;
        };
        
        // 计算一个整数质因数分解中 5 的数量
        auto cnt5 = [](int num) -> int {
            int res = 0;
            while (num % 5 == 0) {
                ++res;
                num /= 5;
            }
            return res;
        };
        
        // 每个方向延伸部分乘积中因子 2/5 的数量
        vector<vector<int>> l2(m, vector<int>(n));
        vector<vector<int>> l5(m, vector<int>(n));
        vector<vector<int>> r2(m, vector<int>(n));
        vector<vector<int>> r5(m, vector<int>(n));
        vector<vector<int>> u2(m, vector<int>(n));
        vector<vector<int>> u5(m, vector<int>(n));
        vector<vector<int>> d2(m, vector<int>(n));
        vector<vector<int>> d5(m, vector<int>(n));
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (i) {
                    u2[i][j] = u2[i-1][j] + cnt2(grid[i-1][j]);
                    u5[i][j] = u5[i-1][j] + cnt5(grid[i-1][j]);
                }
                if (j) {
                    l2[i][j] = l2[i][j-1] + cnt2(grid[i][j-1]);
                    l5[i][j] = l5[i][j-1] + cnt5(grid[i][j-1]);
                }
            }
        }
        for (int i = m - 1; i >= 0; --i) {
            for (int j = n - 1; j >= 0; --j) {
                if (i != m - 1) {
                    d2[i][j] = d2[i+1][j] + cnt2(grid[i+1][j]);
                    d5[i][j] = d5[i+1][j] + cnt5(grid[i+1][j]);
                }
                if (j != n - 1) {
                    r2[i][j] = r2[i][j+1] + cnt2(grid[i][j+1]);
                    r5[i][j] = r5[i][j+1] + cnt5(grid[i][j+1]);
                }
            }
        }
        int res = 0;   // 所有转角路径中乘积尾随零的最大值
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                // 枚举转角点
                int c2 = cnt2(grid[i][j]);
                int c5 = cnt5(grid[i][j]);
                res = max(res, min(u2[i][j] + l2[i][j] + c2, u5[i][j] + l5[i][j] + c5));
                res = max(res, min(u2[i][j] + r2[i][j] + c2, u5[i][j] + r5[i][j] + c5));
                res = max(res, min(d2[i][j] + l2[i][j] + c2, d5[i][j] + l5[i][j] + c5));
                res = max(res, min(d2[i][j] + r2[i][j] + c2, d5[i][j] + r5[i][j] + c5));
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def maxTrailingZeros(self, grid: List[List[int]]) -> int:
        m = len(grid)
        n = len(grid[0])
        # 计算一个整数质因数分解中 2 的数量
        def cnt2(num: int) -> int:
            res = 0
            while num % 2 == 0:
                res += 1
                num //= 2
            return res
        
        # 计算一个整数质因数分解中 5 的数量
        def cnt5(num: int) -> int:
            res = 0
            while num % 5 == 0:
                res += 1
                num //= 5
            return res
        
        # 每个方向延伸部分乘积中因子 2/5 的数量
        l2 = [[0] * n for _ in range(m)]
        l5 = [[0] * n for _ in range(m)]
        r2 = [[0] * n for _ in range(m)]
        r5 = [[0] * n for _ in range(m)]
        u2 = [[0] * n for _ in range(m)]
        u5 = [[0] * n for _ in range(m)]
        d2 = [[0] * n for _ in range(m)]
        d5 = [[0] * n for _ in range(m)]
        for i in range(m):
            for j in range(n):
                if i:
                    u2[i][j] = u2[i-1][j] + cnt2(grid[i-1][j])
                    u5[i][j] = u5[i-1][j] + cnt5(grid[i-1][j])
                if j:
                    l2[i][j] = l2[i][j-1] + cnt2(grid[i][j-1])
                    l5[i][j] = l5[i][j-1] + cnt5(grid[i][j-1])
        for i in range(m - 1, -1, -1):
            for j in range(n - 1, - 1, -1):
                if i != m - 1:
                    d2[i][j] = d2[i+1][j] + cnt2(grid[i+1][j])
                    d5[i][j] = d5[i+1][j] + cnt5(grid[i+1][j])
                if j != n - 1:
                    r2[i][j] = r2[i][j+1] + cnt2(grid[i][j+1])
                    r5[i][j] = r5[i][j+1] + cnt5(grid[i][j+1])
        res = 0   # 所有转角路径中乘积尾随零的最大值
        for i in range(m):
            for j in range(n):
                # 枚举转角点
                c2 = cnt2(grid[i][j])
                c5 = cnt5(grid[i][j])
                res = max(res, min(u2[i][j] + l2[i][j] + c2, u5[i][j] + l5[i][j] + c5))
                res = max(res, min(u2[i][j] + r2[i][j] + c2, u5[i][j] + r5[i][j] + c5))
                res = max(res, min(d2[i][j] + l2[i][j] + c2, d5[i][j] + l5[i][j] + c5))
                res = max(res, min(d2[i][j] + r2[i][j] + c2, d5[i][j] + r5[i][j] + c5))
        return res
```


**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m, n$ 分别为二维数组 $\textit{grid}$ 的长与宽。即为计算各方向前后缀和以及遍历转角对应点的时间复杂度。

- 空间复杂度：$O(mn)$，即为前缀和辅助数组的空间开销。
#### 方法一：枚举所有的菱形

**提示 $1$**

一个菱形的自由度是多少（即如果我们至少需要多少个变量，才能**唯一**表示一个菱形）？

**提示 $1$ 解释**

一个菱形的自由度是 $3$，例如：

> $2$ 个变量表示菱形上顶点的坐标，$1$ 个变量表示菱形在水平或者竖直方向上的宽度。

**提示 $2$**

![fig1](https://assets.leetcode-cn.com/solution-static/5757/5757.png)

**提示 $3$**

要想快速计算提示 $2$ 中的每一部分，我们可以使用前缀和。

- 记 $\textit{sum}_1[x][y]$ 表示从位置 $(x-1, y-1)$ 开始往**左上方**走，走到边界为止的所有格子的元素和。

- 记 $\textit{sum}_2[x][y]$ 表示从位置 $(x-1, y-1)$ 开始往**右上方**走，走到边界为止的所有格子的元素和。

**思路与算法**

我们首先可以使用二重循环预处理出所有的 $\textit{sum}_1[i][j]$ 以及 $\textit{sum}_2[i][j]$。具体地，有递推式：

$$
\textit{sum}_1[i][j] = \textit{sum}_1[i-1][j-1] + \textit{grid}[i-1][j-1]
$$

以及：

$$
\textit{sum}_2[i][j] = \textit{sum}_2[i-1][j+1] + \textit{grid}[i-1][j-1]
$$

其中 $i$ 和 $j$ 的范围分别为 $[1, m]$ 以及 $[1, n]$。

接下来，我们使用三重循环分别枚举菱形上顶点的位置以及其在水平方向上的宽度，就可以计算出菱形四个顶点的位置，上下左右顶点的位置依次记为 $(u_x, u_y)$，$(d_x, d_y)$，$(l_x, l_y)$ 以及 $(r_x, r_y)$。这样一来，我们就可以使用前缀和在 $O(1)$ 的时间计算该菱形的菱形和，即提示 $2$ 中的五个部分的和分别为：

$$
\begin{cases}
\textit{sum}_2[l_x + 1][l_y + 1] - \textit{sum}_2[u_x][u_y + 2] \\
\textit{sum}_1[r_x + 1][r_y + 1] - \textit{sum}_1[u_x][u_y] \\
\textit{sum}_1[d_x + 1][d_y + 1] - \textit{sum}_1[l_x][l_y] \\
\textit{sum}_2[d_x + 1][d_y + 1] - \textit{sum}_2[r_x][r_y + 2] \\
\textit{grid}[u_x][u_y] + \textit{grid}[d_x][d_y] + \textit{grid}[l_x][l_y] + \textit{grid}[r_x][r_y]
\end{cases}
$$

除此之外，我们可以设计一个简单的数据结构，它使得我们在得到了菱形和后，可以实时维护最大的 $3$ 个互不相同的菱形和，具体的实现可以参考下面的代码。

**细节**

需要注意单独的一个格子也是菱形。

**代码**

```C++ [sol1-C++]
struct Answer {
    array<int, 3> ans{};
    
    void put(int x) {
        if (x > ans[0]) {
            tie(ans[0], ans[1], ans[2]) = tuple{x, ans[0], ans[1]};
        }
        else if (x != ans[0] && x > ans[1]) {
            tie(ans[1], ans[2]) = tuple{x, ans[1]};
        }
        else if (x != ans[0] && x != ans[1] && x > ans[2]) {
            ans[2] = x;
        }
    }
    
    vector<int> get() const {
        vector<int> ret;
        for (int num: ans) {
            if (num) {
                ret.push_back(num);
            }
        }
        return ret;
    }
};

class Solution {
public:
    vector<int> getBiggestThree(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();
        vector<vector<int>> sum1(m + 1, vector<int>(n + 2));
        vector<vector<int>> sum2(m + 1, vector<int>(n + 2));
        for (int i = 1; i <= m; ++i) {
            for (int j = 1; j <= n; ++j) {
                sum1[i][j] = sum1[i - 1][j - 1] + grid[i - 1][j - 1];
                sum2[i][j] = sum2[i - 1][j + 1] + grid[i - 1][j - 1];
            }
        }
        Answer ans;
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                // 单独的一个格子也是菱形
                ans.put(grid[i][j]);
                for (int k = i + 2; k < m; k += 2) {
                    int ux = i, uy = j;
                    int dx = k, dy = j;
                    int lx = (i + k) / 2, ly = j - (k - i) / 2;
                    int rx = (i + k) / 2, ry = j + (k - i) / 2;
                    if (ly < 0 || ry >= n) {
                        break;
                    }
                    ans.put(
                        (sum2[lx + 1][ly + 1] - sum2[ux][uy + 2]) +
                        (sum1[rx + 1][ry + 1] - sum1[ux][uy]) +
                        (sum1[dx + 1][dy + 1] - sum1[lx][ly]) +
                        (sum2[dx + 1][dy + 1] - sum2[rx][ry + 2]) -
                        (grid[ux][uy] + grid[dx][dy] + grid[lx][ly] + grid[rx][ry])
                    );
                }
            }
        }
        return ans.get();
    }
};
```

```Python [sol1-Python3]
class Answer:
    def __init__(self):
        self.ans = [0, 0, 0]
    
    def put(self, x: int):
        _ans = self.ans

        if x > _ans[0]:
            _ans[0], _ans[1], _ans[2] = x, _ans[0], _ans[1]
        elif x != _ans[0] and x > _ans[1]:
            _ans[1], _ans[2] = x, _ans[1]
        elif x != _ans[0] and x != _ans[1] and x > _ans[2]:
            _ans[2] = x
    
    def get(self) -> List[int]:
        _ans = self.ans

        return [num for num in _ans if num != 0]


class Solution:
    def getBiggestThree(self, grid: List[List[int]]) -> List[int]:
        m, n = len(grid), len(grid[0])
        sum1 = [[0] * (n + 2) for _ in range(m + 1)]
        sum2 = [[0] * (n + 2) for _ in range(m + 1)]

        for i in range(1, m + 1):
            for j in range(1, n + 1):
                sum1[i][j] = sum1[i - 1][j - 1] + grid[i - 1][j - 1]
                sum2[i][j] = sum2[i - 1][j + 1] + grid[i - 1][j - 1]
        
        ans = Answer()
        for i in range(m):
            for j in range(n):
                # 单独的一个格子也是菱形
                ans.put(grid[i][j])
                for k in range(i + 2, m, 2):
                    ux, uy = i, j
                    dx, dy = k, j
                    lx, ly = (i + k) // 2, j - (k - i) // 2
                    rx, ry = (i + k) // 2, j + (k - i) // 2
                    
                    if ly < 0 or ry >= n:
                        break
                    
                    ans.put(
                        (sum2[lx + 1][ly + 1] - sum2[ux][uy + 2]) +
                        (sum1[rx + 1][ry + 1] - sum1[ux][uy]) +
                        (sum1[dx + 1][dy + 1] - sum1[lx][ly]) +
                        (sum2[dx + 1][dy + 1] - sum2[rx][ry + 2]) -
                        (grid[ux][uy] + grid[dx][dy] + grid[lx][ly] + grid[rx][ry])
                    )
        
        return ans.get()
```

**复杂度分析**

- 时间复杂度：$O(mn \min(m, n))$。预处理前缀和的时间复杂度为 $O(mn)$，枚举菱形并计算菱形和的时间复杂度为 $O(mn \min(m, n))$，因此总时间复杂度为 $O(mn \min(m, n))$。

- 空间复杂度：$O(mn)$，记为前缀和数组需要使用的空间。
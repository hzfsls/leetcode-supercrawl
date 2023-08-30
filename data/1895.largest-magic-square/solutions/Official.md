#### 方法一：枚举正方形 + 前缀和优化

**思路与算法**

我们只需要按照从大到小的顺序枚举正方形的边长 $\textit{edge}$，再枚举给定的矩阵 $\textit{grid}$ 中所有边长为 $\textit{edge}$ 的正方形，并依次判断它们是否满足幻方的要求即可。

这样做的时间复杂度是多少呢？我们记 $l = \min(m, n)$，那么 $\textit{edge}$ 的范围为 $[1, l]$，边长为 $\textit{edge}$ 的正方形有 $(m-\textit{edge}+1)(n-\textit{edge}+1)=O(mn)$ 个，对于每个正方形，我们需要计算其每一行、列和对角线的和，一共有 $\textit{edge}$ 行 $\textit{edge}$ 列以及 $2$ 条对角线，那么计算这些和的总时间复杂度为 $((2 \cdot \textit{edge}+2) \cdot \textit{edge})=O(l^2)$。将所有项相乘，总时间复杂度即为 $O(l^3 mn)$。

我们无法 $100\%$ 保证 $O(l^3 mn)$ 的算法可以在规定时间内通过所有的测试数据：虽然它的时间复杂度看起来很大，但是常数实际上很小，如果代码写得比较优秀，还是有通过的机会的。

但做一些不复杂的优化也是很有必要的。一个可行的优化点是：我们可以预处理出矩阵 $\textit{grid}$ 每一行以及每一列的前缀和，这样对于计算和的部分：

- 每一行只需要 $O(1)$ 的时间即可求和，所有的 $\textit{edge}$ 行的总时间复杂度为 $O(l)$；

- 每一列只需要 $O(1)$ 的时间即可求和，所有的 $\textit{edge}$ 列的总时间复杂度为 $O(l)$；

- 我们没有预处理对角线的前缀和，这是因为对角线只有 $2$ 条，即使我们直接计算求和，时间复杂度也为 $O(2 \cdot l) = O(l)$。

因此，求和部分的总时间复杂度从 $O(l^2)$ 降低为 $O(l)$，总时间复杂度降低为 $O(l^2 mn)$，对于本题 $m, n \leq 50$ 的范围，该时间复杂度是合理的。

前缀和的具体实现过程可以参考下面的代码。

**优化**

我们只需要在 $[2, l]$ 的范围内从大到小遍历 $\textit{edge}$ 即可，这是因为边长为 $1$ 的正方形一定是一个幻方。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int largestMagicSquare(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();
        // 每一行的前缀和
        vector<vector<int>> rowsum(m, vector<int>(n));
        for (int i = 0; i < m; ++i) {
            rowsum[i][0] = grid[i][0];
            for (int j = 1; j < n; ++j) {
                rowsum[i][j] = rowsum[i][j - 1] + grid[i][j];
            }
        }
        // 每一列的前缀和
        vector<vector<int>> colsum(m, vector<int>(n));
        for (int j = 0; j < n; ++j) {
            colsum[0][j] = grid[0][j];
            for (int i = 1; i < m; ++i) {
                colsum[i][j] = colsum[i - 1][j] + grid[i][j];
            }
        }

        // 从大到小枚举边长 edge
        for (int edge = min(m, n); edge >= 2; --edge) {
            // 枚举正方形的左上角位置 (i,j)
            for (int i = 0; i + edge <= m; ++i) {
                for (int j = 0; j + edge <= n; ++j) {
                    // 计算每一行、列、对角线的值应该是多少（以第一行为样本）
                    int stdsum = rowsum[i][j + edge - 1] - (j ? rowsum[i][j - 1] : 0);
                    bool check = true;
                    // 枚举每一行并用前缀和直接求和
                    // 由于我们已经拿第一行作为样本了，这里可以跳过第一行
                    for (int ii = i + 1; ii < i + edge; ++ii) {
                        if (rowsum[ii][j + edge - 1] - (j ? rowsum[ii][j - 1] : 0) != stdsum) {
                            check = false;
                            break;
                        }
                    }
                    if (!check) {
                        continue;
                    }
                    // 枚举每一列并用前缀和直接求和
                    for (int jj = j; jj < j + edge; ++jj) {
                        if (colsum[i + edge - 1][jj] - (i ? colsum[i - 1][jj] : 0) != stdsum) {
                            check = false;
                            break;
                        }
                    }
                    if (!check) {
                        continue;
                    }
                    // d1 和 d2 分别表示两条对角线的和
                    // 这里 d 表示 diagonal
                    int d1 = 0, d2 = 0;
                    // 不使用前缀和，直接遍历求和
                    for (int k = 0; k < edge; ++k) {
                        d1 += grid[i + k][j + k];
                        d2 += grid[i + k][j + edge - 1 - k];
                    }
                    if (d1 == stdsum && d2 == stdsum) {
                        return edge;
                    }
                }
            }
        }

        return 1;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def largestMagicSquare(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        
        # 每一行的前缀和
        rowsum = [[0] * n for _ in range(m)]
        for i in range(m):
            rowsum[i][0] = grid[i][0]
            for j in range(1, n):
                rowsum[i][j] = rowsum[i][j - 1] + grid[i][j]
        
        # 每一列的前缀和
        colsum = [[0] * n for _ in range(m)]
        for j in range(n):
            colsum[0][j] = grid[0][j]
            for i in range(1, m):
                colsum[i][j] = colsum[i - 1][j] + grid[i][j]

        # 从大到小枚举边长 edge
        for edge in range(min(m, n), 1, -1):
            # 枚举正方形的左上角位置 (i,j)
            for i in range(m - edge + 1):
                for j in range(n - edge + 1):
                    # 计算每一行、列、对角线的值应该是多少（以第一行为样本）
                    stdsum = rowsum[i][j + edge - 1] - (0 if j == 0 else rowsum[i][j - 1])
                    check = True
                    # 枚举每一行并用前缀和直接求和
                    # 由于我们已经拿第一行作为样本了，这里可以跳过第一行
                    for ii in range(i + 1, i + edge):
                        if rowsum[ii][j + edge - 1] - (0 if j == 0 else rowsum[ii][j - 1]) != stdsum:
                            check = False
                            break
                    if not check:
                        continue
                    
                    # 枚举每一列并用前缀和直接求和
                    for jj in range(j, j + edge):
                        if colsum[i + edge - 1][jj] - (0 if i == 0 else colsum[i - 1][jj]) != stdsum:
                            check = False
                            break
                    if not check:
                        continue
                    
                    # d1 和 d2 分别表示两条对角线的和
                    # 这里 d 表示 diagonal
                    d1 = d2 = 0
                    # 不使用前缀和，直接遍历求和
                    for k in range(edge):
                        d1 += grid[i + k][j + k]
                        d2 += grid[i + k][j + edge - 1 - k]
                    if d1 == stdsum and d2 == stdsum:
                        return edge

        return 1
```

**复杂度分析**

- 时间复杂度：$O(mn\min(m, n)^2)$。

- 空间复杂度：$O(mn)$，即为存储前缀和需要的空间。
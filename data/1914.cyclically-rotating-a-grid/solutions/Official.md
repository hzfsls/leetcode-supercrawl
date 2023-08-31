## [1914.循环轮转矩阵 中文官方题解](https://leetcode.cn/problems/cyclically-rotating-a-grid/solutions/100000/xun-huan-lun-zhuan-ju-zhen-by-leetcode-s-n9o9)
#### 方法一：枚举每一层

**思路与算法**

对于一个 $m \times n$ 的矩阵 $\textit{grid}$，它的层数为 $\min(m / 2, n / 2)$。我们可以从外向内枚举矩阵的每一层模拟循环轮转操作。

为了方便模拟，我们从左上角起按照逆时针方向遍历每一层的元素。在本文中，我们将遍历过程分为四个部分，每个部分按顺序遍历每条边除了最后一个元素以外的所有元素。

我们将这些元素的行坐标、列坐标与数值保存在对应的数组 $r, c, \textit{val}$ 中，并计算元素总数，即数组的长度 $\textit{total}$。此时，如果对该层元素进行 $\textit{total}$ 次循环轮转操作，那么该层元素不会改变。因此，实际的循环轮转操作数量即为 $\textit{kk} = k \% \textit{total}$。

那么，这一层中遍历到的第 $i$ 个位置在轮转操作后存放的值对应 $\textit{val}$ 数组中下标为 $(i - \textit{kk} + \textit{total}) \% \textit{total}$ 的值。此处在取模时加上 $\textit{total}$ 是为了避免出现负数。

我们遍历行列坐标数组，并在 $\textit{grid}$ 中更新每个坐标对应的轮转操作后的取值。当枚举并更新完所有层后，$\textit{grid}$ 即为轮转操作后的矩阵。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> rotateGrid(vector<vector<int>>& grid, int k) {
        int m = grid.size();
        int n = grid[0].size();
        int nlayer = min(m / 2, n / 2);   // 层数
        // 从左上角起逆时针枚举每一层
        for (int layer = 0; layer < nlayer; ++layer){
            vector<int> r, c, val;   // 每个元素的行下标，列下标与数值
            for (int i = layer; i < m - layer - 1; ++i){   // 左
                r.push_back(i);
                c.push_back(layer);
                val.push_back(grid[i][layer]);
            }
            for (int j = layer; j < n - layer - 1; ++j){   // 下
                r.push_back(m - layer - 1);
                c.push_back(j);
                val.push_back(grid[m-layer-1][j]);
            }
            for (int i = m - layer - 1; i > layer; --i){   // 右
                r.push_back(i);
                c.push_back(n - layer - 1);
                val.push_back(grid[i][n-layer-1]);
            }
            for (int j = n - layer - 1; j > layer; --j){   // 上
                r.push_back(layer);
                c.push_back(j);
                val.push_back(grid[layer][j]);
            }
            int total = val.size();   // 每一层的元素总数
            int kk = k % total;   // 等效轮转次数
            // 找到每个下标对应的轮转后的取值
            for (int i = 0; i < total; ++i){
                int idx = (i + total - kk) % total;   // 轮转后取值对应的下标
                grid[r[i]][c[i]] = val[idx];
            }
        }
        return grid;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def rotateGrid(self, grid: List[List[int]], k: int) -> List[List[int]]:
        m, n = len(grid), len(grid[0])
        nlayer = min(m // 2, n // 2)   # 层数
        # 从左上角起逆时针枚举每一层
        for layer in range(nlayer):
            r = []   # 每个元素的行下标
            c = []   # 每个元素的列下标
            val = []   # 每个元素的数值
            for i in range(layer, m - layer - 1):   # 左 
                r.append(i)
                c.append(layer)
                val.append(grid[i][layer])
            for j in range(layer, n - layer - 1):   # 下
                r.append(m - layer - 1)
                c.append(j)
                val.append(grid[m-layer-1][j])
            for i in range(m - layer - 1, layer, -1):   # 右
                r.append(i)
                c.append(n - layer - 1)
                val.append(grid[i][n-layer-1])
            for j in range(n - layer - 1, layer, -1):   # 上
                r.append(layer)
                c.append(j)
                val.append(grid[layer][j])
            total = len(val)   # 每一层的元素总数
            kk = k % total   # 等效轮转次数
            # 找到每个下标对应的轮转后的取值
            for i in range(total):
                idx = (i + total - kk) % total   # 轮转后取值对应的下标
                grid[r[i]][c[i]] = val[idx]
        return grid
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别为 $\textit{grid}$ 的行数和列数。即为遍历 $\textit{grid}$ 并进行旋转的时间复杂度。

- 空间复杂度：$O(m + n)$，即为存储每一层行列与数值的辅助数组大小。事实上，我们可以利用原地旋转将空间复杂度优化至 $O(1)$，但这样写出的代码并不直观，因此本题解中不给出空间复杂度最优的写法。
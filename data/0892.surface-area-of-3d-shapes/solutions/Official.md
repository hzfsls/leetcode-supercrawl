## [892.三维形体的表面积 中文官方题解](https://leetcode.cn/problems/surface-area-of-3d-shapes/solutions/100000/san-wei-xing-ti-de-biao-mian-ji-by-leetcode-soluti)

#### 方法一：分步累加

**思路**

我们单独计算每一个 `v = grid[i][j]` 所贡献的表面积，再将所有的 `v` 值相加就能得到最终形体的表面积：

- 对于顶面和底面的表面积，如果 `v > 0`，那么顶面和底面各贡献了 `1` 的表面积，总计 `2` 的表面积；

- 对于四个侧面的表面积，只有在相邻位置的高度小于 `v` 时，对应的那个侧面才会贡献表面积，且贡献的数量为 `v - nv`，其中 `nv` 是相邻位置的高度。我们可以将其写成 `max(v - nv, 0)`。

举一个例子，对于网格

```
1 5
6 7
```

而言，位置 `grid[0][1]` 的高度为 `5`：

- 因为 `5 > 0`，所以贡献了 `2` 的顶面和底面表面积；

- 该位置的上方和右侧没有单元格，可以看成高度为 `0`，所以分别贡献了 `max(5 - 0, 0) = 5` 的表面积；

- 该位置的左侧高度为 `1`，所以贡献了 `max(5 - 1, 0) = 4` 的表面积；

- 该位置的下方高度为 `7`，所以贡献了 `max(5 - 7, 0) = 0` 的表面积。

因此 `grid[0][1]` 贡献的表面积总和为 `2 + 5 + 5 + 4 + 0 = 16`。

**算法**

对于每个 `v = grid[r][c] > 0`，计算 `ans += 2`，对于 `grid[r][c]` 四个方向的每个相邻值 `nv` 还要加上 `max(v - nv, 0)`。

```Java [sol1-Java]
class Solution {
    public int surfaceArea(int[][] grid) {
        int[] dr = new int[]{0, 1, 0, -1};
        int[] dc = new int[]{1, 0, -1, 0};

        int N = grid.length;
        int ans = 0;

        for (int r = 0; r < N; ++r) {
            for (int c = 0; c < N; ++c) {
                if (grid[r][c] > 0) {
                    ans += 2;
                    for (int k = 0; k < 4; ++k) {
                        int nr = r + dr[k];
                        int nc = c + dc[k];
                        int nv = 0;
                        if (0 <= nr && nr < N && 0 <= nc && nc < N) {
                            nv = grid[nr][nc];
                        }

                        ans += Math.max(grid[r][c] - nv, 0);
                    }
                }
            }
        }

        return ans;
    }
}
```
```Python [sol1-Python3]
class Solution:
    def surfaceArea(self, grid: List[List[int]]) -> int:
        N = len(grid)

        ans = 0
        for r in range(N):
            for c in range(N):
                if grid[r][c]:
                    ans += 2
                    for nr, nc in ((r - 1, c), (r + 1, c), (r, c - 1), (r, c + 1)):
                        if 0 <= nr < N and 0 <= nc < N:
                            nval = grid[nr][nc]
                        else:
                            nval = 0

                        ans += max(grid[r][c] - nval, 0)

        return ans
```
```C++ [sol1-C++]
class Solution {
public:
    int surfaceArea(vector<vector<int>>& grid) {
        int dr[]{0, 1, 0, -1};
        int dc[]{1, 0, -1, 0};

        int N = grid.size();
        int ans = 0;

        for (int r = 0; r < N; ++r) {
            for (int c = 0; c < N; ++c) {
                if (grid[r][c] > 0) {
                    ans += 2;
                    for (int k = 0; k < 4; ++k) {
                        int nr = r + dr[k];
                        int nc = c + dc[k];
                        int nv = 0;
                        if (0 <= nr && nr < N && 0 <= nc && nc < N) {
                            nv = grid[nr][nc];
                        }

                        ans += max(grid[r][c] - nv, 0);
                    }
                }
            }
        }

        return ans;
    }
};
```
```JavaScript [sol1-JavaScript]
var surfaceArea = function(grid) {
    const dr = [0, 1, 0, -1];
    const dc = [1, 0, -1, 0];

    const N = grid.length;
    let ans = 0;

    for (let r = 0; r < N; ++r) {
        for (let c = 0; c < N; ++c) {
            if (grid[r][c] > 0) {
                ans += 2;
                for (let k = 0; k < 4; ++k) {
                    const nr = r + dr[k];
                    const nc = c + dc[k];
                    let nv = 0;
                    if (0 <= nr && nr < N && 0 <= nc && nc < N) {
                        nv = grid[nr][nc];
                    }

                    ans += Math.max(grid[r][c] - nv, 0);
                }
            }
        }
    }
    
    return ans;
};
```

**复杂度分析**

* 时间复杂度：$O(N^2)$，其中 $N$ 是 `grid` 中的行和列的数目。

* 空间复杂度：$O(1)$。
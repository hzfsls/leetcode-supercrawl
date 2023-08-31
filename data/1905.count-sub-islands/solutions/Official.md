## [1905.统计子岛屿 中文官方题解](https://leetcode.cn/problems/count-sub-islands/solutions/100000/tong-ji-zi-dao-yu-by-leetcode-solution-x32x)

#### 方法一：广度优先搜索

**思路与算法**

我们可以使用广度优先搜索（也可以使用深度优先搜索）找出所有的岛屿，具体可以参考[「200. 岛屿数量」的官方题解](https://leetcode-cn.com/problems/number-of-islands/solution/dao-yu-shu-liang-by-leetcode/)。

在 $\textit{grid}_2$ 中搜索某一个岛屿的过程中，我们需要判断岛屿包含的每一个格子是否都在 $\textit{grid}_1$ 中出现了。如果全部出现，那么将答案增加 $1$。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr array<array<int, 2>, 4> dirs = {{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}};
public:
    int countSubIslands(vector<vector<int>>& grid1, vector<vector<int>>& grid2) {
        int m = grid1.size(), n = grid1[0].size();

        auto bfs = [&](int sx, int sy) {
            queue<pair<int,int>> q;
            q.emplace(sx, sy);
            grid2[sx][sy] = 0;
            // 判断岛屿包含的每一个格子是否都在 grid1 中出现了
            bool check = grid1[sx][sy];
            while (!q.empty()) {
                auto [x, y] = q.front();
                q.pop();
                for (int d = 0; d < 4; ++d) {
                    int nx = x + dirs[d][0];
                    int ny = y + dirs[d][1];
                    if (nx >= 0 && nx < m && ny >= 0 && ny < n && grid2[nx][ny] == 1) {
                        q.emplace(nx, ny);
                        grid2[nx][ny] = 0;
                        if (grid1[nx][ny] != 1) {
                            check = false;
                        }
                    }
                }
            }
            return check;
        };

        int ans = 0;
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (grid2[i][j] == 1) {
                    ans += bfs(i, j);
                }
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def countSubIslands(self, grid1: List[List[int]], grid2: List[List[int]]) -> int:
        m, n = len(grid1), len(grid1[0])

        def bfs(sx: int, sy: int) -> int:
            q = deque([(sx, sy)])
            grid2[sx][sy] = 0
            # 判断岛屿包含的每一个格子是否都在 grid1 中出现了
            check = (grid1[sx][sy] == 1)
            while q:
                x, y = q.popleft()
                for nx, ny in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
                    if 0 <= nx < m and 0 <= ny < n and grid2[nx][ny] == 1:
                        q.append((nx, ny))
                        grid2[nx][ny] = 0
                        if grid1[nx][ny] != 1:
                            check = False
            
            return int(check)

        ans = 0
        for i in range(m):
            for j in range(n):
                if grid2[i][j] == 1:
                    ans += bfs(i, j)
        return ans
```

**复杂度分析**

- 时间复杂度：$O(mn)$。

- 空间复杂度：$O(mn)$，即为广度优先搜索中队列需要使用的空间。
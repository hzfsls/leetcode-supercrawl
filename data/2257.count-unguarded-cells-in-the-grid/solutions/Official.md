## [2257.统计网格图中没有被保卫的格子数 中文官方题解](https://leetcode.cn/problems/count-unguarded-cells-in-the-grid/solutions/100000/tong-ji-wang-ge-tu-zhong-mei-you-bei-bao-ba6m)
#### 方法一：广度优先搜索 + 存储每个格子的状态

**思路与算法**

为了方便操作，我们可以用二维数组 $\textit{grid}$ 来表示网格图的状态。其中，警卫对应的状态值为 $-1$，墙对应的状态值为 $-2$，未被保卫的格子对应的状态值为 $0$，被保卫格子对应的状态值为正整数。二维数组的初始值均为 $0$，随后我们遍历 $\textit{guards}$ 和 $\textit{walls}$ 数组对应更新网格图。

在恢复了网格图后，我们可以使用广度优先搜索维护每个格子的状态。由于视线是向特定方向的，因此在广度优先搜索的过程中，除了要维护格子的横纵坐标，还要维护当前的**视线方向**。我们用 $(i, j, k)$ 来表示广度优先搜索的状态，其中 $(i, j)$ 代表当前点的横纵坐标，$k$ 为 $[0, 3]$ 闭区间内的整数，分别代表右、上、左、下的视线方向。同样地，为了防止每个非警卫或墙的点被重复或遗漏，我们用 $4$ 个二进制位组成的正整数来表示该格子的状态，其中**从低到高的**第 $k$ 位为 $1$ 代表有指向第 $k$ 个方向的视线经过该点，反之则代表没有。

我们用队列 $q$ 来进行广度优先搜索。首先，对于每个警卫点 $(i, j)$，由于警卫可以看到四个方向，因此我们需要将 $k$ 为 $[0, 3]$ 闭区间内对应的**四种状态** $(i, j, k)$ 全部加进队列。

当遍历到 $(x, y, k)$ 时，我们首先计算沿着该视线方向的**下一个**坐标 $(n_x, n_y)$，如果该坐标不合法或为墙或警卫，则我们直接跳过该坐标；对于余下的情况，我们需要检查该坐标对应状态 $\textit{grid}[i][j]$ 中从低到高的第 $k$ 位的数值。此时有两种情况：

- 第 $k$ 位为 $1$，则说明该坐标及视线方向对应的状态 $(n_x, n_y, k)$ 已被遍历过，我们直接跳过即可；

- 第 $k$ 位为 $0$，则说明该坐标及视线方向对应的状态 $(n_x, n_y, k)$ 未被遍历过，我们需要将该位置为 $1$，并将该状态加入队列 $q$ 的尾部。

最终，当广度优先搜索完成时，一个格子未被保卫**当且仅当** $\textit{grid}$ 中的对应状态值为 $0$。我们只需要遍历 $\textit{grid}$，维护数值为 $0$ 的格子数量，并返回即可。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countUnguarded(int m, int n, vector<vector<int>>& guards, vector<vector<int>>& walls) {
        vector<vector<int>> grid(m, vector<int> (n));   // 网格状态数组
        queue<tuple<int, int, int>> q;   // 广度优先搜索队列
        // 每个方向的单位向量
        vector<int> dx = {1, 0, -1, 0};
        vector<int> dy = {0, 1, 0, -1};
        for (const auto& guard: guards) {
            grid[guard[0]][guard[1]] = -1;
            for (int k = 0; k < 4; ++k) {
                // 将四个方向视线对应的状态均添加进搜索队列中
                q.emplace(guard[0], guard[1], k);
            }
        }
        for (const auto& wall: walls) {
            grid[wall[0]][wall[1]] = -2;
        }
        while (!q.empty()) {
            auto [x, y, k] = q.front();
            q.pop();
            int nx = x + dx[k];
            int ny = y + dy[k];
            if (nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] >= 0) {
                // 沿着视线方向的下一个坐标合法，且不为警卫或墙
                if ((grid[nx][ny] & (1 << k)) == 0) {
                    // 对应状态未遍历过
                    grid[nx][ny] |= (1 << k);
                    q.emplace(nx, ny, k);
                }
            }
        }
        int res = 0;   // 未被保护格子数目
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (grid[i][j] == 0) {
                    ++res;
                }
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def countUnguarded(self, m: int, n: int, guards: List[List[int]], walls: List[List[int]]) -> int:
        grid = [[0] * n for  _ in range(m)]   # 网格状态数组
        q = deque([])   # 广度优先搜索队列
        # 每个方向的单位向量
        dx = [1, 0, -1, 0]
        dy = [0, 1, 0, -1]
        for i, j in guards:
            grid[i][j] = -1
            for k in range(4):
                # 将四个方向视线对应的状态均添加进搜索队列中
                q.append((i, j, k))
        for i, j in walls:
            grid[i][j] = -2
        while q:
            x, y, k = q.popleft()
            nx, ny = x + dx[k], y + dy[k]
            if 0 <= nx < m and 0 <= ny < n and grid[nx][ny] >= 0:
                # 沿着视线方向的下一个坐标合法，且不为警卫或墙
                if grid[nx][ny] & (1 << k) == 0:
                    # 对应状态未遍历过
                    grid[nx][ny] |= (1 << k)
                    q.append((nx, ny, k))
        res = 0   # 未被保护格子数目
        for i in range(m):
            for j in range(n):
                if grid[i][j] == 0:
                    res += 1
        return res
```


**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别为网格图的行数与列数。即为广度优先搜索的时间复杂度。

- 空间复杂度：$O(mn)$，即为网格图数组的空间开销。
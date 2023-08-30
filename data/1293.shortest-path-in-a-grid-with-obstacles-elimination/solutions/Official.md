### 方法一：广度优先搜索

对于二维网格中的最短路问题，我们一般可以使用广度优先搜索 + 队列的方法解决。

本题中，玩家在移动时可以消除障碍物，这会导致网格的结构发生变化，看起来我们需要在广度优先搜索时额外存储网格的变化。但实际上，由于玩家在最短路中显然不会经过同一位置超过一次，因此最多消除 `k` 个障碍物等价于最多经过 `k` 个障碍物。

这样我们就可以使用三元组 `(x, y, rest)` 表示一个搜索状态，其中 `(x, y)` 表示玩家的位置，`rest` 表示玩家还可以经过 `rest` 个障碍物，它的值必须为非负整数。对于当前的状态 `(x, y, rest)`，它可以向最多四个新状态进行搜索，即将玩家 `(x, y)` 向四个方向移动一格。假设移动的方向为 `(dx, dy)`，那么玩家的新位置为 `(mx + dx, my + dy)`。如果该位置为障碍物，那么新的状态为 `(mx + dx, my + dy, rest - 1)`，否则新的状态为 `(mx + dx, my + dy, rest)`。我们从初始状态 `(0, 0, k)` 开始搜索，当我们第一次到达状态 `(m - 1, n - 1, k')`，其中 `k'` 是任意非负整数时，就得到了从左上角 `(0, 0)` 到右下角 `(m - 1, n - 1)` 且最多经过 `k` 个障碍物的最短路径。

此外，我们还可以对搜索空间进行优化。注意到题目中 `k` 的上限为 `m * n`，但考虑一条从 `(0, 0)` 向下走到 `(m - 1, 0)` 再向右走到 `(m - 1, n - 1)` 的路径，它经过了 `m + n - 1` 个位置，其中起点 `(0, 0)` 和终点 `(m - 1, n - 1)` 没有障碍物，那么这条路径上最多只会有 `m + n - 3` 个障碍物。因此我们可以将 `k` 的值设置为 `m + n - 3` 与其本身的较小值 `min(k, m + n - 3)`，将广度优先搜索的时间复杂度从 $O(MNK)$ 降低至 $O(MN * \min(M + N, K))$。

```C++ [sol1-C++]
struct Nagato {
    int x, y;
    int rest;
    Nagato(int _x, int _y, int _r): x(_x), y(_y), rest(_r) {}
};

class Solution {
private:
    static constexpr int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

public:
    int shortestPath(vector<vector<int>>& grid, int k) {
        int m = grid.size(), n = grid[0].size();
        if (m == 1 && n == 1) {
            return 0;
        }

        k = min(k, m + n - 3);
        bool visited[m][n][k + 1];
        memset(visited, false, sizeof(visited));
        queue<Nagato> q;
        q.emplace(0, 0, k);
        visited[0][0][k] = true;

        for (int step = 1; q.size() > 0; ++step) {
            int cnt = q.size();
            for (int _ = 0; _ < cnt; ++_) {
                Nagato cur = q.front();
                q.pop();
                for (int i = 0; i < 4; ++i) {
                    int nx = cur.x + dirs[i][0];
                    int ny = cur.y + dirs[i][1];
                    if (nx >= 0 && nx < m && ny >= 0 && ny < n) {
                        if (grid[nx][ny] == 0 && !visited[nx][ny][cur.rest]) {
                            if (nx == m - 1 && ny == n - 1) {
                                return step;
                            }
                            q.emplace(nx, ny, cur.rest);
                            visited[nx][ny][cur.rest] = true;
                        }
                        else if (grid[nx][ny] == 1 && cur.rest > 0 && !visited[nx][ny][cur.rest - 1]) {
                            q.emplace(nx, ny, cur.rest - 1);
                            visited[nx][ny][cur.rest - 1] = true;
                        }
                    }
                }
            }
        }
        return -1;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def shortestPath(self, grid: List[List[int]], k: int) -> int:
        m, n = len(grid), len(grid[0])
        if m == 1 and n == 1:
            return 0
        
        k = min(k, m + n - 3)
        visited = set([(0, 0, k)])
        q = collections.deque([(0, 0, k)])

        step = 0
        while len(q) > 0:
            step += 1
            cnt = len(q)
            for _ in range(cnt):
                x, y, rest = q.popleft()
                for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
                    nx, ny = x + dx, y + dy
                    if 0 <= nx < m and 0 <= ny < n:
                        if grid[nx][ny] == 0 and (nx, ny, rest) not in visited:
                            if nx == m - 1 and ny == n - 1:
                                return step
                            q.append((nx, ny, rest))
                            visited.add((nx, ny, rest))
                        elif grid[nx][ny] == 1 and rest > 0 and (nx, ny, rest - 1) not in visited:
                            q.append((nx, ny, rest - 1))
                            visited.add((nx, ny, rest - 1))
        return -1
```

**复杂度分析**

- 时间复杂度：$O(MN * \min(M + N, K))$。

- 空间复杂度：$O(MN * \min(M + N, K))$。
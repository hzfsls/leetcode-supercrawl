#### 方法一：广度优先搜索

**思路与算法**

我们可以使用广度优先搜索来寻找迷宫中距离入口最近的出口。

在广度优先搜索的过程中，我们在队列中保存 $(c_x, c_y, d)$ 三元组，其中 $(c_x, c_y)$ 为当前的行列坐标， $d$ 为当前坐标相对入口的距离。

当我们遍历至 $(c_x, c_y)$ 时，我们枚举它上下左右的相邻坐标 $(n_x, n_y)$。此时可能有三种情况：

- $(n_x, n_y)$ 不合法或对应的坐标为墙，此时无需进行任何操作；

- $(n_x, n_y)$ 为迷宫的出口（在迷宫边界且不为墙），此时应返回 $d + 1$，即该出口相对入口的距离作为答案。

- $(n_x, n_y)$ 为空格子且不为出口，此时应将新坐标对应的三元组 $(n_x, n_y, d + 1)$ 加入队列。

最终，如果不存在到达出口的路径，我们返回 $-1$ 作为答案。

为了避免重复遍历，我们可以将所有遍历过的坐标对应迷宫矩阵的值改为墙所对应的字符 $\texttt{`+'}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int nearestExit(vector<vector<char>>& maze, vector<int>& entrance) {
        int m = maze.size();
        int n = maze[0].size();
        // 上下左右四个相邻坐标对应的行列变化量
        vector<int> dx = {1, 0, -1, 0};
        vector<int> dy = {0, 1, 0, -1};
        queue<tuple<int, int, int>> q;
        // 入口加入队列并修改为墙
        q.emplace(entrance[0], entrance[1], 0);
        maze[entrance[0]][entrance[1]] = '+';
        while (!q.empty()){
            auto [cx, cy, d] = q.front();
            q.pop();
            // 遍历四个方向相邻坐标
            for (int k = 0; k < 4; ++k){
                int nx = cx + dx[k];
                int ny = cy + dy[k];
                // 新坐标合法且不为墙
                if (nx >= 0 && nx < m && ny >= 0 && ny < n && maze[nx][ny] == '.'){
                    if (nx == 0 || nx == m - 1 || ny == 0 || ny == n - 1){
                        // 新坐标为出口，返回距离作为答案
                        return d + 1;
                    }
                    // 新坐标为空格子且不为出口，修改为墙并加入队列
                    maze[nx][ny] = '+';
                    q.emplace(nx, ny, d + 1);
                }
            }
        }
        // 不存在到出口的路径，返回 -1
        return -1;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def nearestExit(self, maze: List[List[str]], entrance: List[int]) -> int:
        m, n = len(maze), len(maze[0])
        # 上下左右四个相邻坐标对应的行列变化量
        dx = [1, 0, -1, 0]
        dy = [0, 1, 0, -1]
        # 入口加入队列并修改为墙
        q = deque([(entrance[0], entrance[1], 0)])
        maze[entrance[0]][entrance[1]] = '+'
        while q:
            cx, cy, d = q.popleft()
            # 遍历四个方向相邻坐标
            for k in range(4):
                nx = cx + dx[k]
                ny = cy + dy[k]
                if 0 <= nx < m and 0 <= ny < n and maze[nx][ny] == '.':
                    # 新坐标合法且不为墙
                    if nx == 0 or nx == m - 1 or ny == 0 or ny == n - 1:
                        # 新坐标为出口，返回距离作为答案
                        return d + 1
                    # 新坐标为空格子且不为出口，修改为墙并加入队列
                    maze[nx][ny] = '+'
                    q.append((nx, ny, d + 1))
        # 不存在到出口的路径，返回 -1
        return -1
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m, n$ 分别为迷宫矩阵的行数与列数。即为广度优先搜索的时间复杂度。

- 空间复杂度：$O(mn)$，即为广度优先搜索中队列需要使用的空间。
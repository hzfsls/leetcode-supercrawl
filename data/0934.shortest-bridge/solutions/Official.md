#### 方法一：广度优先搜索

题目中求最少的翻转 $0$ 的数目等价于求矩阵中两个岛的最短距离，因此我们可以广度优先搜索来找到矩阵中两个块的最短距离。首先找到其中一座岛，然后将其不断向外延伸一圈，直到到达了另一座岛，延伸的圈数即为最短距离。广度优先搜索时，我们可以将已经遍历过的位置标记为 $-1$，实际计算过程如下：
+ 我们通过遍历找到数组 $\textit{grid}$ 中的 $1$ 后进行广度优先搜索，此时可以得到第一座岛的位置集合，记为 $\textit{island}$，并将其位置全部标记为 $-1$。
+ 随后我们从 $\textit{island}$ 中的所有位置开始进行广度优先搜索，当它们到达了任意的 $1$ 时，即表示搜索到了第二个岛，搜索的层数就是答案。

```Python [sol1-Python3]
class Solution:
    def shortestBridge(self, grid: List[List[int]]) -> int:
        n = len(grid)
        for i, row in enumerate(grid):
            for j, v in enumerate(row):
                if v != 1:
                    continue
                island = []
                grid[i][j] = -1
                q = deque([(i, j)])
                while q:
                    x, y = q.popleft()
                    island.append((x, y))
                    for nx, ny in (x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1):
                        if 0 <= nx < n and 0 <= ny < n and grid[nx][ny] == 1:
                            grid[nx][ny] = -1
                            q.append((nx, ny))

                step = 0
                q = island
                while True:
                    tmp = q
                    q = []
                    for x, y in tmp:
                        for nx, ny in (x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1):
                            if 0 <= nx < n and 0 <= ny < n:
                                if grid[nx][ny] == 1:
                                    return step
                                if grid[nx][ny] == 0:
                                    grid[nx][ny] = -1
                                    q.append((nx, ny))
                    step += 1
```

```C++ [sol1-C++]
class Solution {
public:
    int shortestBridge(vector<vector<int>>& grid) {
        int n = grid.size();
        vector<vector<int>> dirs = {{-1, 0}, {1, 0}, {0, 1}, {0, -1}};
        vector<pair<int, int>> island;
        queue<pair<int, int>> qu;

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 1) {
                    qu.emplace(i, j);
                    grid[i][j] = -1;
                    while (!qu.empty()) {
                        auto [x, y] = qu.front();
                        qu.pop();
                        island.emplace_back(x, y);
                        for (int k = 0; k < 4; k++) {
                            int nx = x + dirs[k][0];
                            int ny = y + dirs[k][1];
                            if (nx >= 0 && ny >= 0 && nx < n && ny < n && grid[nx][ny] == 1) {
                                qu.emplace(nx, ny);
                                grid[nx][ny] = -1;
                            }
                        }
                    }
                    for (auto &&[x, y] : island) {
                        qu.emplace(x, y);
                    }
                    int step = 0;
                    while (!qu.empty()) {
                        int sz = qu.size();
                        for (int i = 0; i < sz; i++) {
                            auto [x, y] = qu.front();
                            qu.pop();
                            for (int k = 0; k < 4; k++) {
                                int nx = x + dirs[k][0];
                                int ny = y + dirs[k][1];
                                if (nx >= 0 && ny >= 0 && nx < n && ny < n) {
                                    if (grid[nx][ny] == 0) {
                                        qu.emplace(nx, ny);
                                        grid[nx][ny] = -1;
                                    } else if (grid[nx][ny] == 1) {
                                        return step;
                                    }
                                }
                            }
                        }
                        step++;
                    }
                }
            }
        }
        return 0;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int shortestBridge(int[][] grid) {
        int n = grid.length;
        int[][] dirs = {{-1, 0}, {1, 0}, {0, 1}, {0, -1}};
        List<int[]> island = new ArrayList<int[]>();
        Queue<int[]> queue = new ArrayDeque<int[]>();

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 1) {
                    queue.offer(new int[]{i, j});
                    grid[i][j] = -1;
                    while (!queue.isEmpty()) {
                        int[] cell = queue.poll();
                        int x = cell[0], y = cell[1];
                        island.add(cell);
                        for (int k = 0; k < 4; k++) {
                            int nx = x + dirs[k][0];
                            int ny = y + dirs[k][1];
                            if (nx >= 0 && ny >= 0 && nx < n && ny < n && grid[nx][ny] == 1) {
                                queue.offer(new int[]{nx, ny});
                                grid[nx][ny] = -1;
                            }
                        }
                    }
                    for (int[] cell : island) {
                        queue.offer(cell);
                    }
                    int step = 0;
                    while (!queue.isEmpty()) {
                        int sz = queue.size();
                        for (int k = 0; k < sz; k++) {
                            int[] cell = queue.poll();
                            int x = cell[0], y = cell[1];
                            for (int d = 0; d < 4; d++) {
                                int nx = x + dirs[d][0];
                                int ny = y + dirs[d][1];
                                if (nx >= 0 && ny >= 0 && nx < n && ny < n) {
                                    if (grid[nx][ny] == 0) {
                                        queue.offer(new int[]{nx, ny});
                                        grid[nx][ny] = -1;
                                    } else if (grid[nx][ny] == 1) {
                                        return step;
                                    }
                                }
                            }
                        }
                        step++;
                    }
                }
            }
        }
        return 0;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int ShortestBridge(int[][] grid) {
        int n = grid.Length;
        int[][] dirs = {new int[]{-1, 0}, new int[]{1, 0}, new int[]{0, 1}, new int[]{0, -1}};
        IList<Tuple<int, int>> island = new List<Tuple<int, int>>();
        Queue<Tuple<int, int>> queue = new Queue<Tuple<int, int>>();

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 1) {
                    queue.Enqueue(new Tuple<int, int>(i, j));
                    grid[i][j] = -1;
                    while (queue.Count > 0) {
                        Tuple<int, int> cell = queue.Dequeue();
                        int x = cell.Item1, y = cell.Item2;
                        island.Add(cell);
                        for (int k = 0; k < 4; k++) {
                            int nx = x + dirs[k][0];
                            int ny = y + dirs[k][1];
                            if (nx >= 0 && ny >= 0 && nx < n && ny < n && grid[nx][ny] == 1) {
                                queue.Enqueue(new Tuple<int, int>(nx, ny));
                                grid[nx][ny] = -1;
                            }
                        }
                    }
                    foreach (Tuple<int, int> cell in island) {
                        queue.Enqueue(cell);
                    }
                    int step = 0;
                    while (queue.Count > 0) {
                        int sz = queue.Count;
                        for (int k = 0; k < sz; k++) {
                            Tuple<int, int> cell = queue.Dequeue();
                            int x = cell.Item1, y = cell.Item2;
                            for (int d = 0; d < 4; d++) {
                                int nx = x + dirs[d][0];
                                int ny = y + dirs[d][1];
                                if (nx >= 0 && ny >= 0 && nx < n && ny < n) {
                                    if (grid[nx][ny] == 0) {
                                        queue.Enqueue(new Tuple<int, int>(nx, ny));
                                        grid[nx][ny] = -1;
                                    } else if (grid[nx][ny] == 1) {
                                        return step;
                                    }
                                }
                            }
                        }
                        step++;
                    }
                }
            }
        }
        return 0;
    }
}
```

```C [sol1-C]
int shortestBridge(int** grid, int gridSize, int* gridColSize) {
    int n = gridSize;
    int dirs[4][2] = {{-1, 0}, {1, 0}, {0, 1}, {0, -1}};
    int *island = (int *)malloc(sizeof(int) * n * n); 
    int *queue = (int *)malloc(sizeof(int) * n * n);
    int head = 0, tail = 0;

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] == 1) {
                queue[tail++] = i * n + j;
                grid[i][j] = -1;
                int islandSize = 0;
                while (head != tail) {
                    int x = queue[head] / n;
                    int y = queue[head] % n;
                    island[islandSize++] = queue[head];
                    head++;
                    for (int k = 0; k < 4; k++) {
                        int nx = x + dirs[k][0];
                        int ny = y + dirs[k][1];
                        if (nx >= 0 && ny >= 0 && nx < n && ny < n && grid[nx][ny] == 1) {
                            queue[tail++] = nx * n + ny;
                            grid[nx][ny] = -1;
                        }
                    }
                }
                head = tail = 0;
                for (int i = 0; i < islandSize; i++) {
                    queue[tail++] = island[i];
                }
                int step = 0;
                while (head != tail) {
                    int sz = tail - head;
                    for (int i = 0; i < sz; i++) {
                        int x = queue[head] / n;
                        int y = queue[head] % n;
                        head++;
                        for (int k = 0; k < 4; k++) {
                            int nx = x + dirs[k][0];
                            int ny = y + dirs[k][1];
                            if (nx >= 0 && ny >= 0 && nx < n && ny < n) {
                                if (grid[nx][ny] == 0) {
                                    queue[tail++] = nx * n + ny;
                                    grid[nx][ny] = -1;
                                } else if (grid[nx][ny] == 1) {
                                    free(queue);
                                    free(island);
                                    return step;
                                }
                            }
                        }
                    }
                    step++;
                }
            }
        }
    }
    return 0;
}
```

```JavaScript [sol1-JavaScript]
var shortestBridge = function(grid) {
    const n = grid.length;
    const dirs = [[-1, 0], [1, 0], [0, 1], [0, -1]];
    const island = [];
    const queue = [];

    for (let i = 0; i < n; i++) {
        for (let j = 0; j < n; j++) {
            if (grid[i][j] === 1) {
                queue.push([i, j]);
                grid[i][j] = -1;
                while (queue.length !== 0) {
                    const cell = queue.shift();
                    let x = cell[0], y = cell[1];
                    island.push(cell);
                    for (let k = 0; k < 4; k++) {
                        let nx = x + dirs[k][0];
                        let ny = y + dirs[k][1];
                        if (nx >= 0 && ny >= 0 && nx < n && ny < n && grid[nx][ny] == 1) {
                            queue.push([nx, ny]);
                            grid[nx][ny] = -1;
                        }
                    }
                }
                for (const cell of island) {
                    queue.push(cell);
                }
                let step = 0;
                while (queue.length !== 0) {
                    const sz = queue.length;
                    for (let k = 0; k < sz; k++) {
                        const cell = queue.shift();
                        let x = cell[0], y = cell[1];
                        for (let d = 0; d < 4; d++) {
                            let nx = x + dirs[d][0];
                            let ny = y + dirs[d][1];
                            if (nx >= 0 && ny >= 0 && nx < n && ny < n) {
                                if (grid[nx][ny] === 0) {
                                    queue.push([nx, ny]);
                                    grid[nx][ny] = -1;
                                } else if (grid[nx][ny] === 1) {
                                    return step;
                                }
                            }
                        }
                    }
                    step++;
                }
            }
        }
    }
    return 0;
};
```

```go [sol1-Golang]
func shortestBridge(grid [][]int) (step int) {
    type pair struct{ x, y int }
    dirs := []pair{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    n := len(grid)
    for i, row := range grid {
        for j, v := range row {
            if v != 1 {
                continue
            }
            island := []pair{}
            grid[i][j] = -1
            q := []pair{{i, j}}
            for len(q) > 0 {
                p := q[0]
                q = q[1:]
                island = append(island, p)
                for _, d := range dirs {
                    x, y := p.x+d.x, p.y+d.y
                    if 0 <= x && x < n && 0 <= y && y < n && grid[x][y] == 1 {
                        grid[x][y] = -1
                        q = append(q, pair{x, y})
                    }
                }
            }

            q = island
            for {
                tmp := q
                q = nil
                for _, p := range tmp {
                    for _, d := range dirs {
                        x, y := p.x+d.x, p.y+d.y
                        if 0 <= x && x < n && 0 <= y && y < n {
                            if grid[x][y] == 1 {
                                return
                            }
                            if grid[x][y] == 0 {
                                grid[x][y] = -1
                                q = append(q, pair{x, y})
                            }
                        }
                    }
                }
                step++
            }
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 表示 $\textit{grid}$ 的行数，$\textit{grid}$ 的行数与列数相等。我们只需遍历一遍矩阵即可完成访问两个不同的岛。

- 空间复杂度：$O(n^2)$。其中 $n$ 表示 $\textit{grid}$ 的行数，$\textit{grid}$ 的行数与列数相等。$\textit{grid}$ 中的岛含有的元素最多为 $n^2$ 个，广度优先搜索时队列中最多有 $n^2$ 个元素，因此空间复杂度为 $O(n^2)$。

#### 方法二：深度优先搜索 + 广度优先搜索

解法思路与方法一类似，我们可以利用深度优先搜索求出其中的一座岛，然后利用广度优先搜索来找到两座岛的最短距离。深度度优先搜索时，我们可以将已经遍历过的位置标记为 $-1$，实际计算过程如下：
+ 我们通过遍历找到数组 $\textit{grid}$ 中的 $1$ 后进行深度优先搜索，此时可以得到第一座岛的位置集合，记为 $\textit{island}$，并将其位置全部标记为 $-1$。
+ 随后我们从 $\textit{island}$ 中的所有位置开始进行广度优先搜索，当它们到达了任意的 $1$ 时，即表示搜索到了第二个岛，搜索的层数就是答案。

```Python [sol2-Python3]
class Solution:
    def shortestBridge(self, grid: List[List[int]]) -> int:
        n = len(grid)
        for i, row in enumerate(grid):
            for j, v in enumerate(row):
                if v != 1:
                    continue
                q = []
                def dfs(x: int, y: int) -> None:
                    grid[x][y] = -1
                    q.append((x, y))
                    for nx, ny in (x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1):
                        if 0 <= nx < n and 0 <= ny < n and grid[nx][ny] == 1:
                            dfs(nx, ny)
                dfs(i, j)

                step = 0
                while True:
                    tmp = q
                    q = []
                    for x, y in tmp:
                        for nx, ny in (x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1):
                            if 0 <= nx < n and 0 <= ny < n:
                                if grid[nx][ny] == 1:
                                    return step
                                if grid[nx][ny] == 0:
                                    grid[nx][ny] = -1
                                    q.append((nx, ny))
                    step += 1
```

```C++ [sol2-C++]
class Solution {
public:
    void dfs(int x, int y, vector<vector<int>>& grid, queue<pair<int, int>> &qu) {
        if (x < 0 || y < 0 || x >= grid.size() || y >= grid[0].size() || grid[x][y] != 1) {
            return;
        }
        qu.emplace(x, y);
        grid[x][y] = -1;
        dfs(x - 1, y, grid, qu);
        dfs(x + 1, y, grid, qu);
        dfs(x, y - 1, grid, qu);
        dfs(x, y + 1, grid, qu);
    }

    int shortestBridge(vector<vector<int>>& grid) {
        int n = grid.size();
        vector<vector<int>> dirs = {{-1, 0}, {1, 0}, {0, 1}, {0, -1}};

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 1) {
                    queue<pair<int, int>> qu;
                    dfs(i, j, grid, qu);
                    int step = 0;
                    while (!qu.empty()) {
                        int sz = qu.size();
                        for (int i = 0; i < sz; i++) {
                            auto [x, y] = qu.front();
                            qu.pop();
                            for (int k = 0; k < 4; k++) {
                                int nx = x + dirs[k][0];
                                int ny = y + dirs[k][1];
                                if (nx >= 0 && ny >= 0 && nx < n && ny < n) {
                                    if (grid[nx][ny] == 0) {
                                        qu.emplace(nx, ny);
                                        grid[nx][ny] = -1;
                                    } else if (grid[nx][ny] == 1) {
                                        return step;
                                    }
                                }
                            }
                        }
                        step++;
                    }
                }
            }
        }
        return 0;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int shortestBridge(int[][] grid) {
        int n = grid.length;
        int[][] dirs = {{-1, 0}, {1, 0}, {0, 1}, {0, -1}};

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 1) {
                    Queue<int[]> queue = new ArrayDeque<int[]>();
                    dfs(i, j, grid, queue);
                    int step = 0;
                    while (!queue.isEmpty()) {
                        int sz = queue.size();
                        for (int k = 0; k < sz; k++) {
                            int[] cell = queue.poll();
                            int x = cell[0], y = cell[1];
                            for (int d = 0; d < 4; d++) {
                                int nx = x + dirs[d][0];
                                int ny = y + dirs[d][1];
                                if (nx >= 0 && ny >= 0 && nx < n && ny < n) {
                                    if (grid[nx][ny] == 0) {
                                        queue.offer(new int[]{nx, ny});
                                        grid[nx][ny] = -1;
                                    } else if (grid[nx][ny] == 1) {
                                        return step;
                                    }
                                }
                            }
                        }
                        step++;
                    }
                }
            }
        }
        return 0;
    }

    public void dfs(int x, int y, int[][] grid, Queue<int[]> queue) {
        if (x < 0 || y < 0 || x >= grid.length || y >= grid[0].length || grid[x][y] != 1) {
            return;
        }
        queue.offer(new int[]{x, y});
        grid[x][y] = -1;
        dfs(x - 1, y, grid, queue);
        dfs(x + 1, y, grid, queue);
        dfs(x, y - 1, grid, queue);
        dfs(x, y + 1, grid, queue);
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int ShortestBridge(int[][] grid) {
        int n = grid.Length;
        int[][] dirs = {new int[]{-1, 0}, new int[]{1, 0}, new int[]{0, 1}, new int[]{0, -1}};

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 1) {
                    Queue<Tuple<int, int>> queue = new Queue<Tuple<int, int>>();
                    DFS(i, j, grid, queue);
                    int step = 0;
                    while (queue.Count > 0) {
                        int sz = queue.Count;
                        for (int k = 0; k < sz; k++) {
                            Tuple<int, int> cell = queue.Dequeue();
                            int x = cell.Item1, y = cell.Item2;
                            for (int d = 0; d < 4; d++) {
                                int nx = x + dirs[d][0];
                                int ny = y + dirs[d][1];
                                if (nx >= 0 && ny >= 0 && nx < n && ny < n) {
                                    if (grid[nx][ny] == 0) {
                                        queue.Enqueue(new Tuple<int, int>(nx, ny));
                                        grid[nx][ny] = -1;
                                    } else if (grid[nx][ny] == 1) {
                                        return step;
                                    }
                                }
                            }
                        }
                        step++;
                    }
                }
            }
        }
        return 0;
    }

    public void DFS(int x, int y, int[][] grid, Queue<Tuple<int, int>> queue) {
        if (x < 0 || y < 0 || x >= grid.Length || y >= grid[0].Length || grid[x][y] != 1) {
            return;
        }
        queue.Enqueue(new Tuple<int, int>(x, y));
        grid[x][y] = -1;
        DFS(x - 1, y, grid, queue);
        DFS(x + 1, y, grid, queue);
        DFS(x, y - 1, grid, queue);
        DFS(x, y + 1, grid, queue);
    }
}
```

```C [sol2-C]
void dfs(int x, int y, int** grid, int n, int *queue, int *tail) {
    if (x < 0 || y < 0 || x >= n || y >= n || grid[x][y] != 1) {
        return;
    }
    queue[(*tail)++] = x * n + y;
    grid[x][y] = -1;
    dfs(x - 1, y, grid, n, queue, tail);
    dfs(x + 1, y, grid, n, queue, tail);
    dfs(x, y - 1, grid, n, queue, tail);
    dfs(x, y + 1, grid, n, queue, tail);
}

int shortestBridge(int** grid, int gridSize, int* gridColSize) {
    int n = gridSize;
    int dirs[4][2] = {{-1, 0}, {1, 0}, {0, 1}, {0, -1}};
   
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] == 1) {
                int *queue = (int *)malloc(sizeof(int) * n * n);
                int head = 0, tail = 0;
                dfs(i, j, grid, n, queue, &tail);
                int step = 0;
                while (head != tail) {
                    int sz = tail - head;
                    for (int i = 0; i < sz; i++) {
                        int x = queue[head] / n;
                        int y = queue[head] % n;
                        head++;
                        for (int k = 0; k < 4; k++) {
                            int nx = x + dirs[k][0];
                            int ny = y + dirs[k][1];
                            if (nx >= 0 && ny >= 0 && nx < n && ny < n) {
                                if (grid[nx][ny] == 0) {
                                    queue[tail++] = nx * n + ny;
                                    grid[nx][ny] = -1;
                                } else if (grid[nx][ny] == 1) {
                                    free(queue);
                                    return step;
                                }
                            }
                        }
                    }
                    step++;
                }
            }
        }
    }
    return 0;
}
```

```JavaScript [sol2-JavaScript]
var shortestBridge = function(grid) {
    const n = grid.length;
    const dirs = [[-1, 0], [1, 0], [0, 1], [0, -1]];

    for (let i = 0; i < n; i++) {
        for (let j = 0; j < n; j++) {
            if (grid[i][j] === 1) {
                const queue = [];
                dfs(i, j, grid, queue);
                let step = 0;
                while (queue.length !== 0) {
                    const sz = queue.length;
                    for (let k = 0; k < sz; k++) {
                        const cell = queue.shift();
                        let x = cell[0], y = cell[1];
                        for (let d = 0; d < 4; d++) {
                            let nx = x + dirs[d][0];
                            let ny = y + dirs[d][1];
                            if (nx >= 0 && ny >= 0 && nx < n && ny < n) {
                                if (grid[nx][ny] === 0) {
                                    queue.push([nx, ny]);
                                    grid[nx][ny] = -1;
                                } else if (grid[nx][ny] === 1) {
                                    return step;
                                }
                            }
                        }
                    }
                    step++;
                }
            }
        }
    }
    return 0;
}

const dfs = (x, y, grid, queue) => {
    if (x < 0 || y < 0 || x >= grid.length || y >= grid[0].length || grid[x][y] !== 1) {
        return;
    }
    queue.push([x, y]);
    grid[x][y] = -1;
    dfs(x - 1, y, grid, queue);
    dfs(x + 1, y, grid, queue);
    dfs(x, y - 1, grid, queue);
    dfs(x, y + 1, grid, queue);
};
```

```go [sol2-Golang]
func shortestBridge(grid [][]int) (step int) {
    type pair struct{ x, y int }
    dirs := []pair{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    n := len(grid)
    for i, row := range grid {
        for j, v := range row {
            if v != 1 {
                continue
            }
            q := []pair{}
            var dfs func(int, int)
            dfs = func(i, j int) {
                grid[i][j] = -1
                q = append(q, pair{i, j})
                for _, d := range dirs {
                    x, y := i+d.x, j+d.y
                    if 0 <= x && x < n && 0 <= y && y < n && grid[x][y] == 1 {
                        dfs(x, y)
                    }
                }
            }
            dfs(i, j)

            for {
                tmp := q
                q = nil
                for _, p := range tmp {
                    for _, d := range dirs {
                        x, y := p.x+d.x, p.y+d.y
                        if 0 <= x && x < n && 0 <= y && y < n {
                            if grid[x][y] == 1 {
                                return
                            }
                            if grid[x][y] == 0 {
                                grid[x][y] = -1
                                q = append(q, pair{x, y})
                            }
                        }
                    }
                }
                step++
            }
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 表示 $\textit{grid}$ 的行数，$\textit{grid}$ 的行数与列数相等。我们只需遍历一遍矩阵即可完成访问两个不同的岛。

- 空间复杂度：$O(n^2)$。其中 $n$ 表示 $\textit{grid}$ 的行数，$\textit{grid}$ 的行数与列数相等。$\textit{grid}$ 中每个岛含有的元素最多为 $n^2$ 个，广度优先搜索时队列中最多有 $n^2$ 个元素，因此空间复杂度为 $O(n^2)$。
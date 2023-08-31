## [1020.飞地的数量 中文官方题解](https://leetcode.cn/problems/number-of-enclaves/solutions/100000/fei-di-de-shu-liang-by-leetcode-solution-nzs3)

#### 方法一：深度优先搜索

根据飞地的定义，如果从一个陆地单元格出发无法移动到网格边界，则这个陆地单元格是飞地。因此可以将所有陆地单元格分成两类：第一类陆地单元格和网格边界相连，这些陆地单元格不是飞地；第二类陆地单元格不和网格边界相连，这些陆地单元格是飞地。

我们可以从网格边界上的每个陆地单元格开始深度优先搜索，遍历完边界之后，所有和网格边界相连的陆地单元格就都被访问过了。然后遍历整个网格，如果网格中的一个陆地单元格没有被访问过，则该陆地单元格不和网格的边界相连，是飞地。

代码实现时，由于网格边界上的单元格一定不是飞地，因此遍历网格统计飞地的数量时只需要遍历不在网格边界上的单元格。

```Java [sol1-Java]
class Solution {
    public static int[][] dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    private int m, n;
    private boolean[][] visited;

    public int numEnclaves(int[][] grid) {
        m = grid.length;
        n = grid[0].length;
        visited = new boolean[m][n];
        for (int i = 0; i < m; i++) {
            dfs(grid, i, 0);
            dfs(grid, i, n - 1);
        }
        for (int j = 1; j < n - 1; j++) {
            dfs(grid, 0, j);
            dfs(grid, m - 1, j);
        }
        int enclaves = 0;
        for (int i = 1; i < m - 1; i++) {
            for (int j = 1; j < n - 1; j++) {
                if (grid[i][j] == 1 && !visited[i][j]) {
                    enclaves++;
                }
            }
        }
        return enclaves;
    }

    public void dfs(int[][] grid, int row, int col) {
        if (row < 0 || row >= m || col < 0 || col >= n || grid[row][col] == 0 || visited[row][col]) {
            return;
        }
        visited[row][col] = true;
        for (int[] dir : dirs) {
            dfs(grid, row + dir[0], col + dir[1]);
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public static int[][] dirs = {new int[]{-1, 0}, new int[]{1, 0}, new int[]{0, -1}, new int[]{0, 1}};
    private int m, n;
    private bool[][] visited;

    public int NumEnclaves(int[][] grid) {
        m = grid.Length;
        n = grid[0].Length;
        visited = new bool[m][];
        for (int i = 0; i < m; i++) {
            visited[i] = new bool[n];
        }
        for (int i = 0; i < m; i++) {
            DFS(grid, i, 0);
            DFS(grid, i, n - 1);
        }
        for (int j = 1; j < n - 1; j++) {
            DFS(grid, 0, j);
            DFS(grid, m - 1, j);
        }
        int enclaves = 0;
        for (int i = 1; i < m - 1; i++) {
            for (int j = 1; j < n - 1; j++) {
                if (grid[i][j] == 1 && !visited[i][j]) {
                    enclaves++;
                }
            }
        }
        return enclaves;
    }

    public void DFS(int[][] grid, int row, int col) {
        if (row < 0 || row >= m || col < 0 || col >= n || grid[row][col] == 0 || visited[row][col]) {
            return;
        }
        visited[row][col] = true;
        foreach (int[] dir in dirs) {
            DFS(grid, row + dir[0], col + dir[1]);
        }
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

    int numEnclaves(vector<vector<int>>& grid) {
        this->m = grid.size();
        this->n = grid[0].size();
        this->visited = vector<vector<bool>>(m, vector<bool>(n, false));
        for (int i = 0; i < m; i++) {
            dfs(grid, i, 0);
            dfs(grid, i, n - 1);
        }
        for (int j = 1; j < n - 1; j++) {
            dfs(grid, 0, j);
            dfs(grid, m - 1, j);
        }
        int enclaves = 0;
        for (int i = 1; i < m - 1; i++) {
            for (int j = 1; j < n - 1; j++) {
                if (grid[i][j] == 1 && !visited[i][j]) {
                    enclaves++;
                }
            }
        }
        return enclaves;
    }

    void dfs(const vector<vector<int>> & grid, int row, int col) {
        if (row < 0 || row >= m || col < 0 || col >= n || grid[row][col] == 0 || visited[row][col]) {
            return;
        }
        visited[row][col] = true;
        for (auto & dir : dirs) {
            dfs(grid, row + dir[0], col + dir[1]);
        }
    }
private:
    int m, n;
    vector<vector<bool>> visited;
};
```

```C [sol1-C]
int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

void dfs(const int** grid, int m, int n, uint8_t** visited, int row, int col) {
    if (row < 0 || row >= m || col < 0 || col >= n || grid[row][col] == 0 || visited[row][col]) {
        return;
    }
    visited[row][col] = 1;
    for (int i = 0; i < 4 ; i++) {
        dfs(grid, m, n, visited, row + dirs[i][0], col + dirs[i][1]);
    }
}

int numEnclaves(int** grid, int gridSize, int* gridColSize) {
    int m = gridSize, n = gridColSize[0];
    uint8_t ** visited = (uint8_t **)malloc(sizeof(uint8_t *) * m);
    for (int i = 0; i < m; i++) {
        visited[i] = (uint8_t *)malloc(sizeof(uint8_t) * n);
        memset(visited[i], 0, sizeof(uint8_t) * n);
    }
    for (int i = 0; i < m; i++) {
        dfs(grid, m, n, visited, i, 0);
        dfs(grid, m, n, visited, i, n - 1);
    }
    for (int j = 1; j < n - 1; j++) {
        dfs(grid, m, n, visited, 0, j);
        dfs(grid, m, n, visited, m - 1, j);
    }
    int enclaves = 0;
    for (int i = 1; i < m - 1; i++) {
        for (int j = 1; j < n - 1; j++) {
            if (grid[i][j] == 1 && !visited[i][j]) {
                enclaves++;
            }
        }
    }
    for (int i = 0; i < m; i++) {
        free(visited[i]);
    }
    free(visited);
    return enclaves;
}
```

```Python [sol1-Python3]
class Solution:
    def numEnclaves(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        vis = [[False] * n for _ in range(m)]

        def dfs(r: int, c: int) -> None:
            if r < 0 or r >= m or c < 0 or c >= n or grid[r][c] == 0 or vis[r][c]:
                return
            vis[r][c] = True
            for x, y in ((r - 1, c), (r + 1, c), (r, c - 1), (r, c + 1)):
                dfs(x, y)

        for i in range(m):
            dfs(i, 0)
            dfs(i, n - 1)
        for j in range(1, n - 1):
            dfs(0, j)
            dfs(m - 1, j)
        return sum(grid[i][j] and not vis[i][j] for i in range(1, m - 1) for j in range(1, n - 1))
```

```go [sol1-Golang]
var dirs = []struct{ x, y int }{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func numEnclaves(grid [][]int) (ans int) {
    m, n := len(grid), len(grid[0])
    vis := make([][]bool, m)
    for i := range vis {
        vis[i] = make([]bool, n)
    }
    var dfs func(int, int)
    dfs = func(r, c int) {
        if r < 0 || r >= m || c < 0 || c >= n || grid[r][c] == 0 || vis[r][c] {
            return
        }
        vis[r][c] = true
        for _, d := range dirs {
            dfs(r+d.x, c+d.y)
        }
    }
    for i := range grid {
        dfs(i, 0)
        dfs(i, n-1)
    }
    for j := 1; j < n-1; j++ {
        dfs(0, j)
        dfs(m-1, j)
    }
    for i := 1; i < m-1; i++ {
        for j := 1; j < n-1; j++ {
            if grid[i][j] == 1 && !vis[i][j] {
                ans++
            }
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var numEnclaves = function(grid) {
    const dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]];
    const m = grid.length;
    const n = grid[0].length;
    const visited = new Array(m).fill(0).map(() => new Array(n).fill(false));

    const dfs = (grid, row, col) => {
        if (row < 0 || row >= m || col < 0 || col >= n || grid[row][col] == 0 || visited[row][col]) {
            return;
        }
        visited[row][col] = true;
        for (const dir of dirs) {
            dfs(grid, row + dir[0], col + dir[1]);
        }
    };

    for (let i = 0; i < m; i++) {
        dfs(grid, i, 0);
        dfs(grid, i, n - 1);
    }
    for (let j = 1; j < n - 1; j++) {
        dfs(grid, 0, j);
        dfs(grid, m - 1, j);
    }
    let enclaves = 0;
    for (let i = 1; i < m - 1; i++) {
        for (let j = 1; j < n - 1; j++) {
            if (grid[i][j] === 1 && !visited[i][j]) {
                enclaves++;
            }
        }
    }
    return enclaves;
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是网格 $\textit{grid}$ 的行数和列数。深度优先搜索最多访问每个单元格一次，需要 $O(mn)$ 的时间，遍历网格统计飞地的数量也需要 $O(mn)$ 的时间。

- 空间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是网格 $\textit{grid}$ 的行数和列数。空间复杂度主要取决于 $\textit{visited}$ 数组和递归调用栈空间，空间复杂度是 $O(mn)$。

#### 方法二：广度优先搜索

也可以通过广度优先搜索判断每个陆地单元格是否和网格边界相连。

首先从网格边界上的每个陆地单元格开始广度优先搜索，访问所有和网格边界相连的陆地单元格，然后遍历整个网格，统计飞地的数量。

```Java [sol2-Java]
class Solution {
    public static int[][] dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

    public int numEnclaves(int[][] grid) {
        int m = grid.length, n = grid[0].length;
        boolean[][] visited = new boolean[m][n];
        Queue<int[]> queue = new ArrayDeque<int[]>();
        for (int i = 0; i < m; i++) {
            if (grid[i][0] == 1) {
                visited[i][0] = true;
                queue.offer(new int[]{i, 0});
            }
            if (grid[i][n - 1] == 1) {
                visited[i][n - 1] = true;
                queue.offer(new int[]{i, n - 1});
            }
        }
        for (int j = 1; j < n - 1; j++) {
            if (grid[0][j] == 1) {
                visited[0][j] = true;
                queue.offer(new int[]{0, j});
            }
            if (grid[m - 1][j] == 1) {
                visited[m - 1][j] = true;
                queue.offer(new int[]{m - 1, j});
            }
        }
        while (!queue.isEmpty()) {
            int[] cell = queue.poll();
            int currRow = cell[0], currCol = cell[1];
            for (int[] dir : dirs) {
                int nextRow = currRow + dir[0], nextCol = currCol + dir[1];
                if (nextRow >= 0 && nextRow < m && nextCol >= 0 && nextCol < n && grid[nextRow][nextCol] == 1 && !visited[nextRow][nextCol]) {
                    visited[nextRow][nextCol] = true;
                    queue.offer(new int[]{nextRow, nextCol});
                }
            }
        }
        int enclaves = 0;
        for (int i = 1; i < m - 1; i++) {
            for (int j = 1; j < n - 1; j++) {
                if (grid[i][j] == 1 && !visited[i][j]) {
                    enclaves++;
                }
            }
        }
        return enclaves;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public static int[][] dirs = {new int[]{-1, 0}, new int[]{1, 0}, new int[]{0, -1}, new int[]{0, 1}};

    public int NumEnclaves(int[][] grid) {
        int m = grid.Length, n = grid[0].Length;
        bool[][] visited = new bool[m][];
        for (int i = 0; i < m; i++) {
            visited[i] = new bool[n];
        }
        Queue<Tuple<int, int>> queue = new Queue<Tuple<int, int>>();
        for (int i = 0; i < m; i++) {
            if (grid[i][0] == 1) {
                visited[i][0] = true;
                queue.Enqueue(new Tuple<int, int>(i, 0));
            }
            if (grid[i][n - 1] == 1) {
                visited[i][n - 1] = true;
                queue.Enqueue(new Tuple<int, int>(i, n - 1));
            }
        }
        for (int j = 1; j < n - 1; j++) {
            if (grid[0][j] == 1) {
                visited[0][j] = true;
                queue.Enqueue(new Tuple<int, int>(0, j));
            }
            if (grid[m - 1][j] == 1) {
                visited[m - 1][j] = true;
                queue.Enqueue(new Tuple<int, int>(m - 1, j));
            }
        }
        while (queue.Count > 0) {
            Tuple<int, int> cell = queue.Dequeue();
            int currRow = cell.Item1, currCol = cell.Item2;
            foreach (int[] dir in dirs) {
                int nextRow = currRow + dir[0], nextCol = currCol + dir[1];
                if (nextRow >= 0 && nextRow < m && nextCol >= 0 && nextCol < n && grid[nextRow][nextCol] == 1 && !visited[nextRow][nextCol]) {
                    visited[nextRow][nextCol] = true;
                    queue.Enqueue(new Tuple<int, int>(nextRow, nextCol));
                }
            }
        }
        int enclaves = 0;
        for (int i = 1; i < m - 1; i++) {
            for (int j = 1; j < n - 1; j++) {
                if (grid[i][j] == 1 && !visited[i][j]) {
                    enclaves++;
                }
            }
        }
        return enclaves;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    vector<vector<int>> dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

    int numEnclaves(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();
        vector<vector<bool>> visited = vector<vector<bool>>(m, vector<bool>(n, false));
        queue<pair<int,int>> qu;
        for (int i = 0; i < m; i++) {
            if (grid[i][0] == 1) {
                visited[i][0] = true;
                qu.emplace(i, 0);
            }
            if (grid[i][n - 1] == 1) {
                visited[i][n - 1] = true;
                qu.emplace(i, n - 1);
            }
        }
        for (int j = 1; j < n - 1; j++) {
            if (grid[0][j] == 1) {
                visited[0][j] = true;
                qu.emplace(0, j);
            }
            if (grid[m - 1][j] == 1) {
                visited[m - 1][j] = true;
                qu.emplace(m - 1, j);
            }
        }
        while (!qu.empty()) {
            auto [currRow, currCol] = qu.front();
            qu.pop();
            for (auto & dir : dirs) {
                int nextRow = currRow + dir[0], nextCol = currCol + dir[1];
                if (nextRow >= 0 && nextRow < m && nextCol >= 0 && nextCol < n && grid[nextRow][nextCol] == 1 && !visited[nextRow][nextCol]) {
                    visited[nextRow][nextCol] = true;
                    qu.emplace(nextRow, nextCol);
                }
            }
        }
        int enclaves = 0;
        for (int i = 1; i < m - 1; i++) {
            for (int j = 1; j < n - 1; j++) {
                if (grid[i][j] == 1 && !visited[i][j]) {
                    enclaves++;
                }
            }
        }
        return enclaves;
    }
};
```

```C [sol2-C]
typedef struct {
    int x;
    int y;
} Pair;

int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

int numEnclaves(int** grid, int gridSize, int* gridColSize){
    int m = gridSize, n = gridColSize[0];
    bool ** visited = (bool **)malloc(sizeof(bool *) * m);
    for (int i = 0; i < m; i++) {
        visited[i] = (bool *)malloc(sizeof(bool) * n);
        memset(visited[i], 0, sizeof(bool) * n);
    }
    Pair * queue = (Pair *)malloc(sizeof(Pair) * m * n);
    int head = 0;
    int tail = 0;
    for (int i = 0; i < m; i++) {
        if (grid[i][0] == 1) {
            visited[i][0] = true;
            queue[tail].x = i;
            queue[tail].y = 0;
            tail++;
        }
        if (grid[i][n - 1] == 1) {
            visited[i][n - 1] = true;
            queue[tail].x = i;
            queue[tail].y = n - 1;
            tail++;
        }
    }
    for (int j = 1; j < n - 1; j++) {
        if (grid[0][j] == 1) {
            visited[0][j] = true;
            queue[tail].x = 0;
            queue[tail].y = j;
            tail++;
        }
        if (grid[m - 1][j] == 1) {
            visited[m - 1][j] = true;
            queue[tail].x = m - 1;
            queue[tail].y = j;
            tail++;
        }
    }
    while (head != tail) {
        int currRow = queue[head].x;
        int currCol = queue[head].y;
        head++;
        for (int i = 0; i < 4; i++) {
            int nextRow = currRow + dirs[i][0], nextCol = currCol + dirs[i][1];
            if (nextRow >= 0 && nextRow < m && nextCol >= 0 && nextCol < n && grid[nextRow][nextCol] == 1 && !visited[nextRow][nextCol]) {
                visited[nextRow][nextCol] = true;
                queue[tail].x = nextRow;
                queue[tail].y = nextCol;
                tail++;
            }
        }
    }
    int enclaves = 0;
    for (int i = 1; i < m - 1; i++) {
        for (int j = 1; j < n - 1; j++) {
            if (grid[i][j] == 1 && !visited[i][j]) {
                enclaves++;
            }
        }
    }
    for (int i = 0; i < m; i++) {
        free(visited[i]);
    }
    free(visited);
    free(queue);
    return enclaves;
}
```

```Python [sol2-Python3]
class Solution:
    def numEnclaves(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        vis = [[False] * n for _ in range(m)]
        q = deque()
        for i, row in enumerate(grid):
            if row[0]:
                vis[i][0] = True
                q.append((i, 0))
            if row[n - 1]:
                vis[i][n - 1] = True
                q.append((i, n - 1))
        for j in range(1, n - 1):
            if grid[0][j]:
                vis[0][j] = True
                q.append((0, j))
            if grid[m - 1][j]:
                vis[m - 1][j] = True
                q.append((m - 1, j))
        while q:
            r, c = q.popleft()
            for x, y in ((r - 1, c), (r + 1, c), (r, c - 1), (r, c + 1)):
                if 0 <= x < m and 0 <= y < n and grid[x][y] and not vis[x][y]:
                    vis[x][y] = True
                    q.append((x, y))
        return sum(grid[i][j] and not vis[i][j] for i in range(1, m - 1) for j in range(1, n - 1))
```

```go [sol2-Golang]
type pair struct{ x, y int }
var dirs = []pair{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func numEnclaves(grid [][]int) (ans int) {
    m, n := len(grid), len(grid[0])
    vis := make([][]bool, m)
    for i := range vis {
        vis[i] = make([]bool, n)
    }
    q := []pair{}
    for i, row := range grid {
        if row[0] == 1 {
            vis[i][0] = true
            q = append(q, pair{i, 0})
        }
        if row[n-1] == 1 {
            vis[i][n-1] = true
            q = append(q, pair{i, n - 1})
        }
    }
    for j := 1; j < n-1; j++ {
        if grid[0][j] == 1 {
            vis[0][j] = true
            q = append(q, pair{0, j})
        }
        if grid[m-1][j] == 1 {
            vis[m-1][j] = true
            q = append(q, pair{m - 1, j})
        }
    }
    for len(q) > 0 {
        p := q[0]
        q = q[1:]
        for _, d := range dirs {
            if x, y := p.x+d.x, p.y+d.y; 0 <= x && x < m && 0 <= y && y < n && grid[x][y] == 1 && !vis[x][y] {
                vis[x][y] = true
                q = append(q, pair{x, y})
            }
        }
    }
    for i := 1; i < m-1; i++ {
        for j := 1; j < n-1; j++ {
            if grid[i][j] == 1 && !vis[i][j] {
                ans++
            }
        }
    }
    return
}
```

```JavaScript [sol2-JavaScript]
var numEnclaves = function(grid) {
    const dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]];
    const m = grid.length, n = grid[0].length;
    const visited = new Array(m).fill(0).map(() => new Array(n).fill(false));
    const queue = [];
    for (let i = 0; i < m; i++) {
        if (grid[i][0] === 1) {
            visited[i][0] = true;
            queue.push([i, 0]);
        }
        if (grid[i][n - 1] === 1) {
            visited[i][n - 1] = true;
            queue.push([i, n - 1]);
        }
    }
    for (let j = 1; j < n - 1; j++) {
        if (grid[0][j] === 1) {
            visited[0][j] = true;
            queue.push([0, j]);
        }
        if (grid[m - 1][j] === 1) {
            visited[m - 1][j] = true;
            queue.push([m - 1, j]);
        }
    }
    while (queue.length) {
        const cell = queue.shift();
        const currRow = cell[0], currCol = cell[1];
        for (const dir of dirs) {
            const nextRow = currRow + dir[0], nextCol = currCol + dir[1];
            if (nextRow >= 0 && nextRow < m && nextCol >= 0 && nextCol < n && grid[nextRow][nextCol] == 1 && !visited[nextRow][nextCol]) {
                visited[nextRow][nextCol] = true;
                queue.push([nextRow, nextCol]);
            }
        }
    }
    let enclaves = 0;
    for (let i = 1; i < m - 1; i++) {
        for (let j = 1; j < n - 1; j++) {
            if (grid[i][j] === 1 && !visited[i][j]) {
                enclaves++;
            }
        }
    }
    return enclaves;
};
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是网格 $\textit{grid}$ 的行数和列数。广度优先搜索最多访问每个单元格一次，需要 $O(mn)$ 的时间，遍历网格统计飞地的数量也需要 $O(mn)$ 的时间。

- 空间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是网格 $\textit{grid}$ 的行数和列数。空间复杂度主要取决于 $\textit{visited}$ 数组和队列空间，空间复杂度是 $O(mn)$。

#### 方法三：并查集

除了深度优先搜索和广度优先搜索的方法以外，也可以使用并查集判断每个陆地单元格是否和网格边界相连。

并查集的核心思想是计算网格中的每个陆地单元格所在的连通分量。对于网格边界上的每个陆地单元格，其所在的连通分量中的所有陆地单元格都不是飞地。如果一个陆地单元格所在的连通分量不同于任何一个网格边界上的陆地单元格所在的连通分量，则该陆地单元格是飞地。

并查集的做法是，遍历整个网格，对于网格中的每个陆地单元格，将其与所有相邻的陆地单元格做合并操作。由于需要判断每个陆地单元格所在的连通分量是否和网格边界相连，因此并查集还需要记录每个单元格是否和网格边界相连的信息，在合并操作时更新该信息。

在遍历网格完成并查集的合并操作之后，再次遍历整个网格，通过并查集中的信息判断每个陆地单元格是否和网格边界相连，统计飞地的数量。

```Java [sol3-Java]
class Solution {
    public int numEnclaves(int[][] grid) {
        int m = grid.length, n = grid[0].length;
        UnionFind uf = new UnionFind(grid);
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 1) {
                    int index = i * n + j;
                    if (j + 1 < n && grid[i][j + 1] == 1) {
                        uf.union(index, index + 1);
                    }
                    if (i + 1 < m && grid[i + 1][j] == 1) {
                        uf.union(index, index + n);
                    }
                }
            }
        }
        int enclaves = 0;
        for (int i = 1; i < m - 1; i++) {
            for (int j = 1; j < n - 1; j++) {
                if (grid[i][j] == 1 && !uf.isOnEdge(i * n + j)) {
                    enclaves++;
                }
            }
        }
        return enclaves;
    }
}

class UnionFind {
    private int[] parent;
    private boolean[] onEdge;
    private int[] rank;

    public UnionFind(int[][] grid) {
        int m = grid.length, n = grid[0].length;
        parent = new int[m * n];
        onEdge = new boolean[m * n];
        rank = new int[m * n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 1) {
                    int index = i * n + j;
                    parent[index] = index;
                    if (i == 0 || i == m - 1 || j == 0 || j == n - 1) {
                        onEdge[index] = true;
                    }
                }
            }
        }
    }

    public int find(int i) {
        if (parent[i] != i) {
            parent[i] = find(parent[i]);
        }
        return parent[i];
    }

    public void union(int x, int y) {
        int rootx = find(x);
        int rooty = find(y);
        if (rootx != rooty) {
            if (rank[rootx] > rank[rooty]) {
                parent[rooty] = rootx;
                onEdge[rootx] |= onEdge[rooty];
            } else if (rank[rootx] < rank[rooty]) {
                parent[rootx] = rooty;
                onEdge[rooty] |= onEdge[rootx];
            } else {
                parent[rooty] = rootx;
                onEdge[rootx] |= onEdge[rooty];
                rank[rootx]++;
            }
        }
    }

    public boolean isOnEdge(int i) {
        return onEdge[find(i)];
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int NumEnclaves(int[][] grid) {
        int m = grid.Length, n = grid[0].Length;
        UnionFind uf = new UnionFind(grid);
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 1) {
                    int index = i * n + j;
                    if (j + 1 < n && grid[i][j + 1] == 1) {
                        uf.Union(index, index + 1);
                    }
                    if (i + 1 < m && grid[i + 1][j] == 1) {
                        uf.Union(index, index + n);
                    }
                }
            }
        }
        int enclaves = 0;
        for (int i = 1; i < m - 1; i++) {
            for (int j = 1; j < n - 1; j++) {
                if (grid[i][j] == 1 && !uf.IsOnEdge(i * n + j)) {
                    enclaves++;
                }
            }
        }
        return enclaves;
    }
}

class UnionFind {
    private int[] parent;
    private bool[] onEdge;
    private int[] rank;

    public UnionFind(int[][] grid) {
        int m = grid.Length, n = grid[0].Length;
        parent = new int[m * n];
        onEdge = new bool[m * n];
        rank = new int[m * n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 1) {
                    int index = i * n + j;
                    parent[index] = index;
                    if (i == 0 || i == m - 1 || j == 0 || j == n - 1) {
                        onEdge[index] = true;
                    }
                }
            }
        }
    }

    public int Find(int i) {
        if (parent[i] != i) {
            parent[i] = Find(parent[i]);
        }
        return parent[i];
    }

    public void Union(int x, int y) {
        int rootx = Find(x);
        int rooty = Find(y);
        if (rootx != rooty) {
            if (rank[rootx] > rank[rooty]) {
                parent[rooty] = rootx;
                onEdge[rootx] |= onEdge[rooty];
            } else if (rank[rootx] < rank[rooty]) {
                parent[rootx] = rooty;
                onEdge[rooty] |= onEdge[rootx];
            } else {
                parent[rooty] = rootx;
                onEdge[rootx] |= onEdge[rooty];
                rank[rootx]++;
            }
        }
    }

    public bool IsOnEdge(int i) {
        return onEdge[Find(i)];
    }
}
```

```C++ [sol3-C++]
class UnionFind {
public:
    UnionFind(const vector<vector<int>> & grid) {
        int m = grid.size(), n = grid[0].size();
        this->parent = vector<int>(m * n);
        this->onEdge = vector<bool>(m * n, false);
        this->rank = vector<int>(m * n);
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 1) {
                    int index = i * n + j;
                    parent[index] = index;
                    if (i == 0 || i == m - 1 || j == 0 || j == n - 1) {
                        onEdge[index] = true;
                    }
                }
            }
        }
    }

    int find(int i) {
        if (parent[i] != i) {
            parent[i] = find(parent[i]);
        }
        return parent[i];
    }

    void uni(int x, int y) {
        int rootx = find(x);
        int rooty = find(y);
        if (rootx != rooty) {
            if (rank[rootx] > rank[rooty]) {
                parent[rooty] = rootx;
                onEdge[rootx] = onEdge[rootx] | onEdge[rooty];
            } else if (rank[rootx] < rank[rooty]) {
                parent[rootx] = rooty;
                onEdge[rooty] = onEdge[rooty] | onEdge[rootx];
            } else {
                parent[rooty] = rootx;
                onEdge[rootx] = onEdge[rootx] | onEdge[rooty];
                rank[rootx]++;
            }
        }
    }

    bool isOnEdge(int i) {
        return onEdge[find(i)];
    }
private:
    vector<int> parent;
    vector<bool> onEdge;
    vector<int> rank;    
};

class Solution {
public:
    int numEnclaves(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();
        UnionFind uf(grid);
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (grid[i][j] == 1) {
                    int index = i * n + j;
                    if (j + 1 < n && grid[i][j + 1] == 1) {
                        uf.uni(index, index + 1);
                    }
                    if (i + 1 < m && grid[i + 1][j] == 1) {
                        uf.uni(index, index + n);
                    }
                }
            }
        }
        int enclaves = 0;
        for (int i = 1; i < m - 1; i++) {
            for (int j = 1; j < n - 1; j++) {
                if (grid[i][j] == 1 && !uf.isOnEdge(i * n + j)) {
                    enclaves++;
                }
            }
        }
        return enclaves;
    }
};
```

```C [sol3-C]
typedef struct {
    int * parent;
    bool * onEdge;
    int * rank;  
} UnionFind;

void initUnionFind(UnionFind * uf, const int** grid, int gridSize, int* gridColSize) {
    int m = gridSize, n = gridColSize[0];
    assert(NULL != uf);
    uf->parent = (int *)malloc(sizeof(int) * m * n);
    uf->onEdge = (bool *)malloc(sizeof(bool) * m * n);
    uf->rank = (int *)malloc(sizeof(int) * m * n);
    memset(uf->parent, 0, sizeof(int) * m * n);
    memset(uf->onEdge, 0, sizeof(bool) * m * n);
    memset(uf->rank, 0, sizeof(int) * m * n);
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] == 1) {
                int index = i * n + j;
                uf->parent[index] = index;
                if (i == 0 || i == m - 1 || j == 0 || j == n - 1) {
                    uf->onEdge[index] = true;
                }
            }
        }
    }
}

void freeUnionFind(UnionFind * uf) {
    free(uf->parent);
    free(uf->onEdge);
    free(uf->rank);
}

int find(UnionFind * uf, int i) {
    if (uf->parent[i] != i) {
        uf->parent[i] = find(uf, uf->parent[i]);
    }
    return uf->parent[i];
}

void uni(UnionFind * uf, int x, int y) {
    int rootx = find(uf, x);
    int rooty = find(uf, y);
    if (rootx != rooty) {
        if (uf->rank[rootx] > uf->rank[rooty]) {
            uf->parent[rooty] = rootx;
            uf->onEdge[rootx] = uf->onEdge[rootx] | uf->onEdge[rooty];
        } else if (uf->rank[rootx] < uf->rank[rooty]) {
            uf->parent[rootx] = rooty;
            uf->onEdge[rooty] = uf->onEdge[rooty] | uf->onEdge[rootx];
        } else {
            uf->parent[rooty] = rootx;
            uf->onEdge[rootx] = uf->onEdge[rootx] | uf->onEdge[rooty];
            uf->rank[rootx]++;
        }
    }
}

bool isOnEdge(UnionFind * uf, int i) {
    return uf->onEdge[find(uf, i)];
}

int numEnclaves(int** grid, int gridSize, int* gridColSize){
    int m = gridSize, n = gridColSize[0];
    UnionFind * uf = (UnionFind *)malloc(sizeof(UnionFind));
    initUnionFind(uf, grid, gridSize, gridColSize);
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] == 1) {
                int index = i * n + j;
                if (j + 1 < n && grid[i][j + 1] == 1) {
                    uni(uf, index, index + 1);
                }
                if (i + 1 < m && grid[i + 1][j] == 1) {
                    uni(uf, index, index + n);
                }
            }
        }
    }
    int enclaves = 0;
    for (int i = 1; i < m - 1; i++) {
        for (int j = 1; j < n - 1; j++) {
            if (grid[i][j] == 1 && !isOnEdge(uf, i * n + j)) {
                enclaves++;
            }
        }
    }
    freeUnionFind(uf);
    free(uf);
    return enclaves;
}
```

```Python [sol3-Python3]
class UnionFind:
    def __init__(self, grid: List[List[int]]):
        m, n = len(grid), len(grid[0])
        self.parent = [0] * (m * n)
        self.rank = [0] * (m * n)
        self.onEdge = [False] * (m * n)
        for i, row in enumerate(grid):
            for j, v in enumerate(row):
                if v:
                    idx = i * n + j
                    self.parent[idx] = idx
                    if i == 0 or i == m - 1 or j == 0 or j == n - 1:
                        self.onEdge[idx] = True

    def find(self, x: int) -> int:
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def merge(self, x: int, y: int) -> None:
        x, y = self.find(x), self.find(y)
        if x == y:
            return
        if self.rank[x] > self.rank[y]:
            self.parent[y] = x
            self.onEdge[x] |= self.onEdge[y]
        elif self.rank[x] < self.rank[y]:
            self.parent[x] = y
            self.onEdge[y] |= self.onEdge[x]
        else:
            self.parent[y] = x
            self.onEdge[x] |= self.onEdge[y]
            self.rank[x] += 1

class Solution:
    def numEnclaves(self, grid: List[List[int]]) -> int:
        uf = UnionFind(grid)
        m, n = len(grid), len(grid[0])
        for i, row in enumerate(grid):
            for j, v in enumerate(row):
                if v:
                    idx = i * n + j
                    if j + 1 < n and grid[i][j + 1]:
                        uf.merge(idx, idx + 1)
                    if i + 1 < m and grid[i + 1][j]:
                        uf.merge(idx, idx + n)
        return sum(grid[i][j] and not uf.onEdge[uf.find(i * n + j)] for i in range(1, m - 1) for j in range(1, n - 1))
```

```go [sol3-Golang]
type unionFind struct {
    parent []int
    rank   []int
    onEdge []bool
}

func newUnionFind(grid [][]int) unionFind {
    m, n := len(grid), len(grid[0])
    parent := make([]int, m*n)
    rank := make([]int, m*n)
    onEdge := make([]bool, m*n)
    for i, row := range grid {
        for j, v := range row {
            if v == 1 {
                idx := i*n + j
                parent[idx] = idx
                if i == 0 || i == m-1 || j == 0 || j == n-1 {
                    onEdge[idx] = true
                }
            }
        }
    }
    return unionFind{parent, rank, onEdge}
}

func (uf unionFind) find(x int) int {
    if uf.parent[x] != x {
        uf.parent[x] = uf.find(uf.parent[x])
    }
    return uf.parent[x]
}

func (uf unionFind) merge(x, y int) {
    x, y = uf.find(x), uf.find(y)
    if x == y {
        return
    }
    if uf.rank[x] > uf.rank[y] {
        uf.parent[y] = x
        uf.onEdge[x] = uf.onEdge[x] || uf.onEdge[y]
    } else if uf.rank[x] < uf.rank[y] {
        uf.parent[x] = y
        uf.onEdge[y] = uf.onEdge[y] || uf.onEdge[x]
    } else {
        uf.parent[y] = x
        uf.onEdge[x] = uf.onEdge[x] || uf.onEdge[y]
        uf.rank[x]++
    }
}

func numEnclaves(grid [][]int) (ans int) {
    uf := newUnionFind(grid)
    m, n := len(grid), len(grid[0])
    for i, row := range grid {
        for j, v := range row {
            if v == 1 {
                idx := i*n + j
                if j+1 < n && grid[i][j+1] == 1 {
                    uf.merge(idx, idx+1)
                }
                if i+1 < m && grid[i+1][j] == 1 {
                    uf.merge(idx, idx+n)
                }
            }
        }
    }
    for i := 1; i < m-1; i++ {
        for j := 1; j < n-1; j++ {
            if grid[i][j] == 1 && !uf.onEdge[uf.find(i*n+j)] {
                ans++
            }
        }
    }
    return
}
```

```JavaScript [sol3-JavaScript]
var numEnclaves = function(grid) {
    const m = grid.length, n = grid[0].length;
    const uf = new UnionFind(grid);
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (grid[i][j] === 1) {
                const index = i * n + j;
                if (j + 1 < n && grid[i][j + 1] === 1) {
                    uf.union(index, index + 1);
                }
                if (i + 1 < m && grid[i + 1][j] === 1) {
                    uf.union(index, index + n);
                }
            }
        }
    }
    let enclaves = 0;
    for (let i = 1; i < m - 1; i++) {
        for (let j = 1; j < n - 1; j++) {
            if (grid[i][j] === 1 && !uf.isOnEdge(i * n + j)) {
                enclaves++;
            }
        }
    }
    return enclaves;
}

class UnionFind {
    constructor(grid) {
        const m = grid.length, n = grid[0].length;
        this.parent = new Array(m * n).fill(0);
        this.onEdge = new Array(m * n).fill(false);
        this.rank = new Array(m * n).fill(0);
        for (let i = 0; i < m; i++) {
            for (let j = 0; j < n; j++) {
                if (grid[i][j] === 1) {
                    const index = i * n + j;
                    this.parent[index] = index;
                    if (i === 0 || i === m - 1 || j === 0 || j === n - 1) {
                        this.onEdge[index] = true;
                    }
                }
            }
        }
    }

    find(i) {
        if (this.parent[i] !== i) {
            this.parent[i] = this.find(this.parent[i]);
        }
        return this.parent[i];
    }

    union(x, y) {
        const rootx = this.find(x);
        const rooty = this.find(y);
        if (rootx !== rooty) {
            if (this.rank[rootx] > this.rank[rooty]) {
                this.parent[rooty] = rootx;
                this.onEdge[rootx] |= this.onEdge[rooty];
            } else if (this.rank[rootx] < this.rank[rooty]) {
                this.parent[rootx] = rooty;
                this.onEdge[rooty] |= this.onEdge[rootx];
            } else {
                this.parent[rooty] = rootx;
                this.onEdge[rootx] |= this.onEdge[rooty];
                this.rank[rootx]++;
            }
        }
    }

    isOnEdge(i) {
        return this.onEdge[this.find(i)];
    }
}
```

**复杂度分析**

- 时间复杂度：$O(mn \times \alpha(mn))$，其中 $m$ 和 $n$ 分别是网格 $\textit{grid}$ 的行数和列数，$\alpha$ 是反阿克曼函数。这里的并查集使用了路径压缩和按秩合并，单次操作的时间复杂度是 $O(\alpha(mn))$，因此整个网格的并查集操作的时间复杂度是 $O(mn \times \alpha(mn))$，并查集操作之后需要 $O(mn \times \alpha(mn))$ 的时间再次遍历网格统计飞地的数量，因此总时间复杂度是 $O(mn \times \alpha(mn))$。

- 空间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是网格 $\textit{grid}$ 的行数和列数。并查集需要 $O(mn)$ 的空间。
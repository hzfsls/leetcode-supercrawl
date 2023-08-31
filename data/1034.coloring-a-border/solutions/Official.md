## [1034.边界着色 中文官方题解](https://leetcode.cn/problems/coloring-a-border/solutions/100000/bian-kuang-zhao-se-by-leetcode-solution-0h5l)

#### 前言

此题与搜索的经典题「[200. 岛屿数量](https://leetcode-cn.com/problems/number-of-islands/)」较为类似，常规的思路是可以使用深度优先搜索或者广度优先搜索来寻找出位置 $(\textit{row},\textit{col})$ 的所在的连通分量，额外要做的是搜索的时候需要判断当前的点是否属于边界。如果属于边界，需要把该点加入到一个用来存所有边界点的数组中。当搜索完毕后，再将所有边界点的进行着色。

#### 方法一：深度优先搜索

**思路及解法**

我们用递归来实现深度优先搜索遍历连通分量，用一个大小和 $\textit{grid}$ 相同的矩阵 $\textit{visited}$ 来记录当前节点是否被访问过，并把边界点存入数组$\textit{borders}$ 中。

**代码**

```Python [sol1-Python3]
class Solution:
    def colorBorder(self, grid: List[List[int]], row: int, col: int, color: int) -> List[List[int]]:
        m, n = len(grid), len(grid[0])
        visited = [[False] * n for _ in range(m)]
        borders = []
        originalColor = grid[row][col]
        visited[row][col] = True
        self.dfs(grid, row, col, visited, borders, originalColor)
        for x, y in borders:
            grid[x][y] = color
        return grid

    def dfs(self, grid, x, y, visited, borders, originalColor):  
        isBorder = False        
        m, n = len(grid), len(grid[0])
        direc = ((-1, 0), (1, 0), (0, -1), (0, 1))
        for dx, dy in direc:
            nx, ny = x + dx, y + dy
            if not (0 <= nx < m and 0 <= ny < n and grid[nx][ny] == originalColor):
                isBorder = True
            elif not visited[nx][ny]:
                visited[nx][ny] = True
                self.dfs(grid, nx, ny, visited, borders, originalColor)
        if isBorder:
            borders.append((x, y))
```

```Java [sol1-Java]
class Solution {
    public int[][] colorBorder(int[][] grid, int row, int col, int color) {
        int m = grid.length, n = grid[0].length;
        boolean[][] visited = new boolean[m][n];
        List<int[]> borders = new ArrayList<>();
        int originalColor = grid[row][col];
        visited[row][col] = true;
        dfs(grid, row, col, visited, borders, originalColor);
        for (int i = 0; i < borders.size(); i++) {
            int x = borders.get(i)[0], y = borders.get(i)[1];
            grid[x][y] = color;
        }
        return grid;
    }

    private void dfs(int[][] grid, int x, int y, boolean[][] visited, List<int[]> borders, int originalColor) {
        int m = grid.length, n = grid[0].length;
        boolean isBorder = false;
        int[][] direc = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
        for (int i = 0; i < 4; i++) {
            int nx = direc[i][0] + x, ny = direc[i][1] + y;
            if (!(nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] == originalColor)) {
                isBorder = true;
            } else if (!visited[nx][ny]){
                visited[nx][ny] = true;
                dfs(grid, nx, ny, visited, borders, originalColor);
            }                
        }
        if (isBorder) {
            borders.add(new int[]{x, y});
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[][] ColorBorder(int[][] grid, int row, int col, int color) {
        int m = grid.Length, n = grid[0].Length;
        bool[,] visited = new bool[m, n];
        IList<int[]> borders = new List<int[]>();
        int originalColor = grid[row][col];
        visited[row, col] = true;
        DFS(grid, row, col, visited, borders, originalColor);
        for (int i = 0; i < borders.Count; i++) {
            int x = borders[i][0], y = borders[i][1];
            grid[x][y] = color;
        }
        return grid;
    }

    private void DFS(int[][] grid, int x, int y, bool[,] visited, IList<int[]> borders, int originalColor) {
        int m = grid.Length, n = grid[0].Length;
        bool isBorder = false;
        int[][] direc = {new int[]{0, 1}, new int[]{0, -1}, new int[]{1, 0}, new int[]{-1, 0}};
        for (int i = 0; i < 4; i++) {
            int nx = direc[i][0] + x, ny = direc[i][1] + y;
            if (!(nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] == originalColor)) {
                isBorder = true;
            } else if (!visited[nx, ny]){
                visited[nx, ny] = true;
                DFS(grid, nx, ny, visited, borders, originalColor);
            }                
        }
        if (isBorder) {
            borders.Add(new int[]{x, y});
        }
    }
}
```

```C++ [sol1-C++]
typedef pair<int, int> pii;

class Solution {
public:
    vector<vector<int>> colorBorder(vector<vector<int>>& grid, int row, int col, int color) {
        int m = grid.size(), n = grid[0].size();
        vector<vector<bool>> visited(m, vector<bool>(n, false));
        vector<pii> borders;
        int originalColor = grid[row][col];
        visited[row][col] = true;
        dfs(grid, row, col, visited, borders, originalColor);
        for (auto & [x, y] : borders) {
            grid[x][y] = color;
        }
        return grid;
    }

    void dfs(vector<vector<int>>& grid, int x, int y, vector<vector<bool>> & visited, vector<pii> & borders, int originalColor) {
        int m = grid.size(), n = grid[0].size();
        bool isBorder = false;
        int direc[4][2] = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
        for (int i = 0; i < 4; i++) {
            int nx = direc[i][0] + x, ny = direc[i][1] + y;
            if (!(nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] == originalColor)) {
                isBorder = true;
            } else if (!visited[nx][ny]) {
                visited[nx][ny] = true;
                dfs(grid, nx, ny, visited, borders, originalColor);
            }                
        }
        if (isBorder) {
            borders.emplace_back(x, y);
        }
    }
};
```

```go [sol1-Golang]
var dirs = []struct{ x, y int }{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func colorBorder(grid [][]int, row, col, color int) [][]int {
    m, n := len(grid), len(grid[0])
    type point struct{ x, y int }
    borders := []point{}
    originalColor := grid[row][col]
    vis := make([][]bool, m)
    for i := range vis {
        vis[i] = make([]bool, n)
    }

    var dfs func(int, int)
    dfs = func(x, y int) {
        vis[x][y] = true
        isBorder := false
        for _, dir := range dirs {
            nx, ny := x+dir.x, y+dir.y
            if !(0 <= nx && nx < m && 0 <= ny && ny < n && grid[nx][ny] == originalColor) {
                isBorder = true
            } else if !vis[nx][ny] {
                vis[nx][ny] = true
                dfs(nx, ny)
            }
        }
        if isBorder {
            borders = append(borders, point{x, y})
        }
    }
    dfs(row, col)

    for _, p := range borders {
        grid[p.x][p.y] = color
    }
    return grid
}
```

```JavaScript [sol1-JavaScript]
var colorBorder = function(grid, row, col, color) {
    const m = grid.length, n = grid[0].length;
    const visited = new Array(m).fill(0).map(() => new Array(n).fill(0));
    const borders = [];
    const originalColor = grid[row][col];
    visited[row][col] = true;
    dfs(grid, row, col, visited, borders, originalColor);
    for (let i = 0; i < borders.length; i++) {
        const x = borders[i][0], y = borders[i][1];
        grid[x][y] = color;
    }
    return grid;
};

const dfs = (grid, x, y, visited, borders, originalColor) => {
    const m = grid.length, n = grid[0].length;
    let isBorder = false;
    const direc = [[0, 1], [0, -1], [1, 0], [-1, 0]];
    for (let i = 0; i < 4; i++) {
        const nx = direc[i][0] + x, ny = direc[i][1] + y;
        if (!(nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] === originalColor)) {
            isBorder = true;
        } else if (!visited[nx][ny]){
            visited[nx][ny] = true;
            dfs(grid, nx, ny, visited, borders, originalColor);
        }                
    }
    if (isBorder) {
        borders.push([x, y]);
    }
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是 $\textit{grid}$ 的行数和列数。在最坏情况下，我们需要访问到 $\textit{grid}$ 中的每个点。

- 空间复杂度：$O(mn)$。我们用一个与 $\textit{grid}$ 相同大小的矩阵来存储每个点是否被遍历过，而其他的空间消耗，比如递归和用来存储所有边界点的数组，均不超过 $O(mn)$。

#### 方法二：广度优先搜索

**思路及解法**

我们用一个队列来实现广度优先搜索遍历连通分量，并用一个大小和 $\textit{grid}$ 相同的矩阵 $\textit{visited}$ 来记录当前节点是否被访问过，并把边界点存入数组$\textit{borders}$ 中。

**代码**

```Python [sol2-Python3]
class Solution:
    def colorBorder(self, grid: List[List[int]], row: int, col: int, color: int) -> List[List[int]]:
        originalColor = grid[row][col]
        m, n = len(grid), len(grid[0])
        visited = [[False] * n for _ in range(m)]
        borders = []
        direc = ((-1, 0), (1, 0), (0, -1), (0, 1))
        q = deque([(row, col)])
        visited[row][col] = True
        while q:
            x, y = q.popleft()
            isBorder = False
            for dx, dy in direc:
                nx, ny = x + dx, y + dy
                if not (0 <= nx < m and 0 <= ny < n and grid[nx][ny] == originalColor):
                    isBorder = True
                elif not visited[nx][ny]:
                    visited[nx][ny] = True
                    q.append((nx, ny))
            if isBorder:
                borders.append((x, y))
        for x, y in borders:
            grid[x][y] = color
        return grid
```

```Java [sol2-Java]
class Solution {
    public int[][] colorBorder(int[][] grid, int row, int col, int color) {
        int m = grid.length, n = grid[0].length;
        boolean[][] visited = new boolean[m][n];
        List<int[]> borders = new ArrayList<>();
        int originalColor = grid[row][col];
        int[][] direc = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
        Deque<int[]> q = new ArrayDeque<>();
        q.offer(new int[]{row, col});
        visited[row][col] = true;
        while (!q.isEmpty()) {
            int[] node = q.poll();
            int x = node[0], y = node[1];

            boolean isBorder = false;
            for (int i = 0; i < 4; i++) {
                int nx = direc[i][0] + x, ny = direc[i][1] + y;
                if (!(nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] == originalColor)) {
                    isBorder = true;
                } else if (!visited[nx][ny]) {
                    visited[nx][ny] = true;
                    q.offer(new int[]{nx, ny});
                }         
            }
            if (isBorder) {
                borders.add(new int[]{x, y});
            }
        }
        for (int i = 0; i < borders.size(); i++) {
            int x = borders.get(i)[0], y = borders.get(i)[1];
            grid[x][y] = color;
        }
        return grid;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int[][] ColorBorder(int[][] grid, int row, int col, int color) {
        int m = grid.Length, n = grid[0].Length;
        bool[,] visited = new bool[m, n];
        IList<int[]> borders = new List<int[]>();
        int originalColor = grid[row][col];
        int[][] direc = {new int[]{0, 1}, new int[]{0, -1}, new int[]{1, 0}, new int[]{-1, 0}};
        Queue<int[]> q = new Queue<int[]>();
        visited[row, col] = true;
        q.Enqueue(new int[]{row, col});
        while (q.Count > 0) {
            int[] node = q.Dequeue();
            int x = node[0], y = node[1];
            bool isBorder = false;
            for (int i = 0; i < 4; i++) {
                int nx = direc[i][0] + x, ny = direc[i][1] + y;
                if (!(nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] == originalColor)) {
                    isBorder = true;
                } else if (!visited[nx, ny]) {
                    visited[nx, ny] = true;
                    q.Enqueue(new int[]{nx, ny});
                }         
            }
            if (isBorder) {
                borders.Add(new int[]{x, y});
            }
        }
        for (int i = 0; i < borders.Count; i++) {
            int x = borders[i][0], y = borders[i][1];
            grid[x][y] = color;
        }
        return grid;
    }
}
```

```C++ [sol2-C++]
typedef pair<int,int> pii;

class Solution {
public:
    vector<vector<int>> colorBorder(vector<vector<int>>& grid, int row, int col, int color) {
        int m = grid.size(), n = grid[0].size();
        vector<vector<bool>> visited(m, vector<bool>(n, false));
        vector<pii> borders;
        int originalColor = grid[row][col];
        int direc[4][2] = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
        queue<pii> q;
        q.emplace(row, col);
        visited[row][col] = true;
        while (!q.empty()) {
            pii & node = q.front();
            q.pop();
            int x = node.first, y = node.second;

            bool isBorder = false;
            for (int i = 0; i < 4; i++) {
                int nx = direc[i][0] + x, ny = direc[i][1] + y;
                if (!(nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] == originalColor)) {
                    isBorder = true;
                } else if (!visited[nx][ny]) {
                    visited[nx][ny] = true;
                    q.emplace(nx, ny);
                }         
            }
            if (isBorder) {
                borders.emplace_back(x, y);
            }
        }
        for (auto & [x, y] : borders) {
            grid[x][y] = color;
        }
        return grid;
    }
};
```

```go [sol2-Golang]
var dirs = []struct{ x, y int }{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func colorBorder(grid [][]int, row, col, color int) [][]int {
    m, n := len(grid), len(grid[0])
    type point struct{ x, y int }
    borders := []point{}
    originalColor := grid[row][col]
    vis := make([][]bool, m)
    for i := range vis {
        vis[i] = make([]bool, n)
    }

    q := []point{{row, col}}
    vis[row][col] = true
    for len(q) > 0 {
        p := q[0]
        q = q[1:]
        x, y := p.x, p.y
        isBorder := false
        for _, dir := range dirs {
            nx, ny := x+dir.x, y+dir.y
            if !(0 <= nx && nx < m && 0 <= ny && ny < n && grid[nx][ny] == originalColor) {
                isBorder = true
            } else if !vis[nx][ny] {
                vis[nx][ny] = true
                q = append(q, point{nx, ny})
            }
        }
        if isBorder {
            borders = append(borders, point{x, y})
        }
    }

    for _, p := range borders {
        grid[p.x][p.y] = color
    }
    return grid
}
```

```JavaScript [sol2-JavaScript]
var colorBorder = function(grid, row, col, color) {
    const m = grid.length, n = grid[0].length;
    const visited = new Array(m).fill(0).map(() => new Array(n).fill(0));
    const borders = [];
    const originalColor = grid[row][col];
    const direc = [[0, 1], [0, -1], [1, 0], [-1, 0]];
    const q = [];
    q.push([row, col]);
    visited[row][col] = true;
    while (q.length) {
        const node = q.pop();
        const x = node[0], y = node[1];

        let isBorder = false;
        for (let i = 0; i < 4; i++) {
            const nx = direc[i][0] + x, ny = direc[i][1] + y;
            if (!(nx >= 0 && nx < m && ny >= 0 && ny < n && grid[nx][ny] === originalColor)) {
                isBorder = true;
            } else if (!visited[nx][ny]) {
                visited[nx][ny] = true;
                q.push([nx, ny]);
            }         
        }
        if (isBorder) {
            borders.push([x, y]);
        }
    }
    for (let i = 0; i < borders.length; i++) {
        const x = borders[i][0], y = borders[i][1];
        grid[x][y] = color;
    }
    return grid;
};
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是 $\textit{grid}$ 的行数和列数。在最坏情况下，我们需要访问到 $\textit{grid}$ 中的每个点。

- 空间复杂度：$O(mn)$。我们用一个与 $\textit{grid}$ 相同大小的矩阵来存储每个点是否被遍历过，而其他的空间消耗，比如广度优先搜索用到的队列和用来存储所有边界点的数组，均不超过 $O(mn)$。
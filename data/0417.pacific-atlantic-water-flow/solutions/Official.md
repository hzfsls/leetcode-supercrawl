#### 方法一：深度优先搜索

雨水的流动方向是从高到低，每个单元格上的雨水只能流到高度小于等于当前单元格的相邻单元格。从一个单元格开始，通过搜索的方法模拟雨水的流动，则可以判断雨水是否可以从该单元格流向海洋。

如果直接以每个单元格作为起点模拟雨水的流动，则会重复遍历每个单元格，导致时间复杂度过高。为了降低时间复杂度，可以从矩阵的边界开始反向搜索寻找雨水流向边界的单元格，反向搜索时，每次只能移动到高度相同或更大的单元格。

由于矩阵的左边界和上边界是太平洋，矩阵的右边界和下边界是大西洋，因此从矩阵的左边界和上边界开始反向搜索即可找到雨水流向太平洋的单元格，从矩阵的右边界和下边界开始反向搜索即可找到雨水流向大西洋的单元格。

可以使用深度优先搜索实现反向搜索，搜索过程中需要记录每个单元格是否可以从太平洋反向到达以及是否可以从大西洋反向到达。反向搜索结束之后，遍历每个网格，如果一个网格既可以从太平洋反向到达也可以从大西洋反向到达，则该网格满足太平洋和大西洋都可以到达，将该网格添加到答案中。

```Python [sol1-Python3]
class Solution:
    def pacificAtlantic(self, heights: List[List[int]]) -> List[List[int]]:
        m, n = len(heights), len(heights[0])

        def search(starts: List[Tuple[int, int]]) -> Set[Tuple[int, int]]:
            visited = set()
            def dfs(x: int, y: int):
                if (x, y) in visited:
                    return
                visited.add((x, y))
                for nx, ny in ((x, y + 1), (x, y - 1), (x - 1, y), (x + 1, y)):
                    if 0 <= nx < m and 0 <= ny < n and heights[nx][ny] >= heights[x][y]:
                        dfs(nx, ny)
            for x, y in starts:
                dfs(x, y)
            return visited

        pacific = [(0, i) for i in range(n)] + [(i, 0) for i in range(1, m)]
        atlantic = [(m - 1, i) for i in range(n)] + [(i, n - 1) for i in range(m - 1)]
        return list(map(list, search(pacific) & search(atlantic)))
```

```Java [sol1-Java]
class Solution {
    static int[][] dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    int[][] heights;
    int m, n;

    public List<List<Integer>> pacificAtlantic(int[][] heights) {
        this.heights = heights;
        this.m = heights.length;
        this.n = heights[0].length;
        boolean[][] pacific = new boolean[m][n];
        boolean[][] atlantic = new boolean[m][n];
        for (int i = 0; i < m; i++) {
            dfs(i, 0, pacific);
        }
        for (int j = 1; j < n; j++) {
            dfs(0, j, pacific);
        }
        for (int i = 0; i < m; i++) {
            dfs(i, n - 1, atlantic);
        }
        for (int j = 0; j < n - 1; j++) {
            dfs(m - 1, j, atlantic);
        }
        List<List<Integer>> result = new ArrayList<List<Integer>>();
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (pacific[i][j] && atlantic[i][j]) {
                    List<Integer> cell = new ArrayList<Integer>();
                    cell.add(i);
                    cell.add(j);
                    result.add(cell);
                }
            }
        }
        return result;
    }

    public void dfs(int row, int col, boolean[][] ocean) {
        if (ocean[row][col]) {
            return;
        }
        ocean[row][col] = true;
        for (int[] dir : dirs) {
            int newRow = row + dir[0], newCol = col + dir[1];
            if (newRow >= 0 && newRow < m && newCol >= 0 && newCol < n && heights[newRow][newCol] >= heights[row][col]) {
                dfs(newRow, newCol, ocean);
            }
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    static int[][] dirs = {new int[]{-1, 0}, new int[]{1, 0}, new int[]{0, -1}, new int[]{0, 1}};
    int[][] heights;
    int m, n;

    public IList<IList<int>> PacificAtlantic(int[][] heights) {
        this.heights = heights;
        this.m = heights.Length;
        this.n = heights[0].Length;
        bool[][] pacific = new bool[m][];
        bool[][] atlantic = new bool[m][];
        for (int i = 0; i < m; i++) {
            pacific[i] = new bool[n];
            atlantic[i] = new bool[n];
        }
        for (int i = 0; i < m; i++) {
            DFS(i, 0, pacific);
        }
        for (int j = 1; j < n; j++) {
            DFS(0, j, pacific);
        }
        for (int i = 0; i < m; i++) {
            DFS(i, n - 1, atlantic);
        }
        for (int j = 0; j < n - 1; j++) {
            DFS(m - 1, j, atlantic);
        }
        IList<IList<int>> result = new List<IList<int>>();
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (pacific[i][j] && atlantic[i][j]) {
                    IList<int> cell = new List<int>();
                    cell.Add(i);
                    cell.Add(j);
                    result.Add(cell);
                }
            }
        }
        return result;
    }

    public void DFS(int row, int col, bool[][] ocean) {
        if (ocean[row][col]) {
            return;
        }
        ocean[row][col] = true;
        foreach (int[] dir in dirs) {
            int newRow = row + dir[0], newCol = col + dir[1];
            if (newRow >= 0 && newRow < m && newCol >= 0 && newCol < n && heights[newRow][newCol] >= heights[row][col]) {
                DFS(newRow, newCol, ocean);
            }
        }
    }
}
```

```C++ [sol1-C++]
static const int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

class Solution {
public:
    vector<vector<int>> heights;

    void dfs(int row, int col, vector<vector<bool>> & ocean) {
        int m = ocean.size();
        int n = ocean[0].size();
        if (ocean[row][col]) {
            return;
        }
        ocean[row][col] = true;
        for (int i = 0; i < 4; i++) {
            int newRow = row + dirs[i][0], newCol = col + dirs[i][1];
            if (newRow >= 0 && newRow < m && newCol >= 0 && newCol < n && heights[newRow][newCol] >= heights[row][col]) {
                dfs(newRow, newCol, ocean);
            }
        }
    }

    vector<vector<int>> pacificAtlantic(vector<vector<int>>& heights) {
        this->heights = heights;
        int m = heights.size();
        int n = heights[0].size();
        vector<vector<bool>> pacific(m, vector<bool>(n, false));
        vector<vector<bool>> atlantic(m, vector<bool>(n, false));

        for (int i = 0; i < m; i++) {
            dfs(i, 0, pacific);
        }
        for (int j = 1; j < n; j++) {
            dfs(0, j, pacific);
        }
        for (int i = 0; i < m; i++) {
            dfs(i, n - 1, atlantic);
        }
        for (int j = 0; j < n - 1; j++) {
            dfs(m - 1, j, atlantic);
        }
        vector<vector<int>> result;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (pacific[i][j] && atlantic[i][j]) {
                    vector<int> cell;
                    cell.emplace_back(i);
                    cell.emplace_back(j);
                    result.emplace_back(cell);
                }
            }
        }
        return result;
    }
};
```

```C [sol1-C]
static const int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

void dfs(int row, int col, bool ** ocean, const int ** heights, int m, int n) {
    if (ocean[row][col]) {
        return;
    }
    ocean[row][col] = true;
    for (int i = 0; i < 4; i++) {
        int newRow = row + dirs[i][0], newCol = col + dirs[i][1];
        if (newRow >= 0 && newRow < m && newCol >= 0 && newCol < n && heights[newRow][newCol] >= heights[row][col]) {
            dfs(newRow, newCol, ocean, heights, m, n);
        }
    }
}

int** pacificAtlantic(int** heights, int heightsSize, int* heightsColSize, int* returnSize, int** returnColumnSizes){
        int m = heightsSize;
        int n = heightsColSize[0];
        bool ** pacific = (bool **)malloc(sizeof(bool *) * m);
        bool ** atlantic = (bool **)malloc(sizeof(bool *) * m);
        for (int i = 0; i < m; i++) {
            pacific[i] = (bool *)malloc(sizeof(bool) * n);
            atlantic[i] = (bool *)malloc(sizeof(bool) * n);
            memset(pacific[i], 0, sizeof(bool) * n);
            memset(atlantic[i], 0, sizeof(bool) * n);
        }

        for (int i = 0; i < m; i++) {
            dfs(i, 0, pacific, heights, m, n);
        }
        for (int j = 1; j < n; j++) {
            dfs(0, j, pacific, heights, m, n);
        }
        for (int i = 0; i < m; i++) {
            dfs(i, n - 1, atlantic, heights, m, n);
        }
        for (int j = 0; j < n - 1; j++) {
            dfs(m - 1, j, atlantic, heights, m, n);
        }
        int ** result = (int **)malloc(sizeof(int *) * m * n);
        *returnColumnSizes = (int *)malloc(sizeof(int) * m * n);
        int pos = 0;
        for (int i = 0; i < m * n; i++) {
            result[i] = (int *)malloc(sizeof(int) * 2);
            (*returnColumnSizes)[i] = 2;
        }
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (pacific[i][j] && atlantic[i][j]) {
                    result[pos][0] = i;
                    result[pos][1] = j;
                    pos++;
                }
            }
            free(pacific[i]);
            free(atlantic[i]);
        }
        free(pacific);
        free(atlantic);
        *returnSize = pos;
        return result;
}
```

```JavaScript [sol1-JavaScript]
const dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]];
var pacificAtlantic = function(heights) {
    m = heights.length;
    n = heights[0].length;
    const pacific = new Array(m).fill(0).map(() => new Array(n).fill(0));
    const atlantic = new Array(m).fill(0).map(() => new Array(n).fill(0));

    const dfs = (row, col, ocean) => {
        if (ocean[row][col]) {
            return;
        }
        ocean[row][col] = true;
        for (const dir of dirs) {
            const newRow = row + dir[0], newCol = col + dir[1];
            if (newRow >= 0 && newRow < m && newCol >= 0 && newCol < n && heights[newRow][newCol] >= heights[row][col]) {
                dfs(newRow, newCol, ocean);
            }
        }
    };

    for (let i = 0; i < m; i++) {
        dfs(i, 0, pacific);
    }
    for (let j = 1; j < n; j++) {
        dfs(0, j, pacific);
    }
    for (let i = 0; i < m; i++) {
        dfs(i, n - 1, atlantic);
    }
    for (let j = 0; j < n - 1; j++) {
        dfs(m - 1, j, atlantic);
    }
    const result = [];
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (pacific[i][j] && atlantic[i][j]) {
                const cell = [];
                cell.push(i);
                cell.push(j);
                result.push(cell);
            }
        }
    }
    return result;
}
```

```go [sol1-Golang]
var dirs = []struct{ x, y int }{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func pacificAtlantic(heights [][]int) (ans [][]int) {
    m, n := len(heights), len(heights[0])
    pacific := make([][]bool, m)
    atlantic := make([][]bool, m)
    for i := range pacific {
        pacific[i] = make([]bool, n)
        atlantic[i] = make([]bool, n)
    }

    var dfs func(int, int, [][]bool)
    dfs = func(x, y int, ocean [][]bool) {
        if ocean[x][y] {
            return
        }
        ocean[x][y] = true
        for _, d := range dirs {
            if nx, ny := x+d.x, y+d.y; 0 <= nx && nx < m && 0 <= ny && ny < n && heights[nx][ny] >= heights[x][y] {
                dfs(nx, ny, ocean)
            }
        }
    }
    for i := 0; i < m; i++ {
        dfs(i, 0, pacific)
    }
    for j := 1; j < n; j++ {
        dfs(0, j, pacific)
    }
    for i := 0; i < m; i++ {
        dfs(i, n-1, atlantic)
    }
    for j := 0; j < n-1; j++ {
        dfs(m-1, j, atlantic)
    }

    for i, row := range pacific {
        for j, ok := range row {
            if ok && atlantic[i][j] {
                ans = append(ans, []int{i, j})
            }
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是矩阵 $\textit{heights}$ 的行数和列数。深度优先搜索最多遍历每个单元格两次，寻找太平洋和大西洋都可以到达的单元格需要遍历整个矩阵，因此时间复杂度是 $O(mn)$。

- 空间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是矩阵 $\textit{heights}$ 的行数和列数。深度优先搜索的递归调用层数是 $O(mn)$，记录每个单元格是否可以到达太平洋和大西洋需要 $O(mn)$ 的空间，因此空间复杂度是 $O(mn)$。

#### 方法二：广度优先搜索

反向搜索也可以使用广度优先搜索实现。搜索过程中同样需要记录每个单元格是否可以从太平洋反向到达以及是否可以从大西洋反向到达。反向搜索结束之后，遍历每个网格，如果一个网格既可以从太平洋反向到达也可以从大西洋反向到达，则该网格满足太平洋和大西洋都可以到达，将该网格添加到答案中。

```Python [sol2-Python3]
class Solution:
    def pacificAtlantic(self, heights: List[List[int]]) -> List[List[int]]:
        m, n = len(heights), len(heights[0])

        def bfs(starts: List[Tuple[int, int]]) -> Set[Tuple[int, int]]:
            q = deque(starts)
            visited = set(starts)
            while q:
                x, y = q.popleft()
                for nx, ny in ((x, y + 1), (x, y - 1), (x - 1, y), (x + 1, y)):
                    if 0 <= nx < m and 0 <= ny < n and heights[nx][ny] >= heights[x][y] and (nx, ny) not in visited:
                        q.append((nx, ny))
                        visited.add((nx, ny))
            return visited

        pacific = [(0, i) for i in range(n)] + [(i, 0) for i in range(1, m)]
        atlantic = [(m - 1, i) for i in range(n)] + [(i, n - 1) for i in range(m - 1)]
        return list(map(list, bfs(pacific) & bfs(atlantic)))
```

```Java [sol2-Java]
class Solution {
    static int[][] dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    int[][] heights;
    int m, n;

    public List<List<Integer>> pacificAtlantic(int[][] heights) {
        this.heights = heights;
        this.m = heights.length;
        this.n = heights[0].length;
        boolean[][] pacific = new boolean[m][n];
        boolean[][] atlantic = new boolean[m][n];
        for (int i = 0; i < m; i++) {
            bfs(i, 0, pacific);
        }
        for (int j = 1; j < n; j++) {
            bfs(0, j, pacific);
        }
        for (int i = 0; i < m; i++) {
            bfs(i, n - 1, atlantic);
        }
        for (int j = 0; j < n - 1; j++) {
            bfs(m - 1, j, atlantic);
        }
        List<List<Integer>> result = new ArrayList<List<Integer>>();
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (pacific[i][j] && atlantic[i][j]) {
                    List<Integer> cell = new ArrayList<Integer>();
                    cell.add(i);
                    cell.add(j);
                    result.add(cell);
                }
            }
        }
        return result;
    }

    public void bfs(int row, int col, boolean[][] ocean) {
        if (ocean[row][col]) {
            return;
        }
        ocean[row][col] = true;
        Queue<int[]> queue = new ArrayDeque<int[]>();
        queue.offer(new int[]{row, col});
        while (!queue.isEmpty()) {
            int[] cell = queue.poll();
            for (int[] dir : dirs) {
                int newRow = cell[0] + dir[0], newCol = cell[1] + dir[1];
                if (newRow >= 0 && newRow < m && newCol >= 0 && newCol < n && heights[newRow][newCol] >= heights[cell[0]][cell[1]] && !ocean[newRow][newCol]) {
                    ocean[newRow][newCol] = true;
                    queue.offer(new int[]{newRow, newCol});
                }
            }
        }
    }
}
```

```C# [sol2-C#]
public class Solution {
    static int[][] dirs = {new int[]{-1, 0}, new int[]{1, 0}, new int[]{0, -1}, new int[]{0, 1}};
    int[][] heights;
    int m, n;

    public IList<IList<int>> PacificAtlantic(int[][] heights) {
        this.heights = heights;
        this.m = heights.Length;
        this.n = heights[0].Length;
        bool[][] pacific = new bool[m][];
        bool[][] atlantic = new bool[m][];
        for (int i = 0; i < m; i++) {
            pacific[i] = new bool[n];
            atlantic[i] = new bool[n];
        }
        for (int i = 0; i < m; i++) {
            BFS(i, 0, pacific);
        }
        for (int j = 1; j < n; j++) {
            BFS(0, j, pacific);
        }
        for (int i = 0; i < m; i++) {
            BFS(i, n - 1, atlantic);
        }
        for (int j = 0; j < n - 1; j++) {
            BFS(m - 1, j, atlantic);
        }
        IList<IList<int>> result = new List<IList<int>>();
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (pacific[i][j] && atlantic[i][j]) {
                    IList<int> cell = new List<int>();
                    cell.Add(i);
                    cell.Add(j);
                    result.Add(cell);
                }
            }
        }
        return result;
    }

    public void BFS(int row, int col, bool[][] ocean) {
        if (ocean[row][col]) {
            return;
        }
        ocean[row][col] = true;
        Queue<Tuple<int, int>> queue = new Queue<Tuple<int, int>>();
        queue.Enqueue(new Tuple<int, int>(row, col));
        while (queue.Count > 0) {
            Tuple<int, int> cell = queue.Dequeue();
            foreach (int[] dir in dirs) {
                int newRow = cell.Item1 + dir[0], newCol = cell.Item2 + dir[1];
                if (newRow >= 0 && newRow < m && newCol >= 0 && newCol < n && heights[newRow][newCol] >= heights[cell.Item1][cell.Item2] && !ocean[newRow][newCol]) {
                    ocean[newRow][newCol] = true;
                    queue.Enqueue(new Tuple<int, int>(newRow, newCol));
                }
            }
        }
    }
}
```

```C++ [sol2-C++]
static const int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

class Solution {
public:
    vector<vector<int>> heights;

    void bfs(int row, int col, vector<vector<bool>> & ocean) {
        if (ocean[row][col]) {
            return;
        }
        int m = heights.size();
        int n = heights[0].size();
        ocean[row][col] = true;
        queue<pair<int, int>> qu;
        qu.emplace(row, col);
        while (!qu.empty()) {
            auto [row, col] = qu.front();
            qu.pop();
            for (int i = 0; i < 4; i++) {
                int newRow = row + dirs[i][0], newCol = col + dirs[i][1];
                if (newRow >= 0 && newRow < m && newCol >= 0 && newCol < n && heights[newRow][newCol] >= heights[row][col] && !ocean[newRow][newCol]) {
                    ocean[newRow][newCol] = true;
                    qu.emplace(newRow, newCol);
                }
            }
        }
    }

    vector<vector<int>> pacificAtlantic(vector<vector<int>>& heights) {
        this->heights = heights;
        int m = heights.size();
        int n = heights[0].size();
        vector<vector<bool>> pacific(m, vector<bool>(n, false));
        vector<vector<bool>> atlantic(m, vector<bool>(n, false));

        for (int i = 0; i < m; i++) {
            bfs(i, 0, pacific);
        }
        for (int j = 1; j < n; j++) {
            bfs(0, j, pacific);
        }
        for (int i = 0; i < m; i++) {
            bfs(i, n - 1, atlantic);
        }
        for (int j = 0; j < n - 1; j++) {
            bfs(m - 1, j, atlantic);
        }
        vector<vector<int>> result;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (pacific[i][j] && atlantic[i][j]) {
                    vector<int> cell;
                    cell.emplace_back(i);
                    cell.emplace_back(j);
                    result.emplace_back(cell);
                }
            }
        }
        return result;
    }
};
```

```C [sol2-C]
static const int dirs[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

void bfs(int row, int col, bool ** ocean, const int ** heights, int m, int n) {
    if (ocean[row][col]) {
        return;
    }
    ocean[row][col] = true;
    int * queue = (int *)malloc(sizeof(int) * m * n);
    int head = 0;
    int tail = 0;
    queue[tail++] = row * n + col;
    while (head != tail) {
        int row = queue[head] / n;
        int col = queue[head] % n;
        head++;
        for (int i = 0; i < 4; i++) {
            int newRow = row + dirs[i][0], newCol = col + dirs[i][1];
            if (newRow >= 0 && newRow < m && newCol >= 0 && newCol < n && heights[newRow][newCol] >= heights[row][col] && !ocean[newRow][newCol]) {
                ocean[newRow][newCol] = true;
                queue[tail++] = newRow * n + newCol;
            }
        }
    }
    free(queue);
}

int** pacificAtlantic(int** heights, int heightsSize, int* heightsColSize, int* returnSize, int** returnColumnSizes){
        int m = heightsSize;
        int n = heightsColSize[0];
        bool ** pacific = (bool **)malloc(sizeof(bool *) * m);
        bool ** atlantic = (bool **)malloc(sizeof(bool *) * m);
        for (int i = 0; i < m; i++) {
            pacific[i] = (bool *)malloc(sizeof(bool) * n);
            atlantic[i] = (bool *)malloc(sizeof(bool) * n);
            memset(pacific[i], 0, sizeof(bool) * n);
            memset(atlantic[i], 0, sizeof(bool) * n);
        }

        for (int i = 0; i < m; i++) {
            bfs(i, 0, pacific, heights, m, n);
        }
        for (int j = 1; j < n; j++) {
            bfs(0, j, pacific, heights, m, n);
        }
        for (int i = 0; i < m; i++) {
            bfs(i, n - 1, atlantic, heights, m, n);
        }
        for (int j = 0; j < n - 1; j++) {
            bfs(m - 1, j, atlantic, heights, m, n);
        }
        int ** result = (int **)malloc(sizeof(int *) * m * n);
        *returnColumnSizes = (int *)malloc(sizeof(int) * m * n);
        int pos = 0;
        for (int i = 0; i < m * n; i++) {
            result[i] = (int *)malloc(sizeof(int) * 2);
            (*returnColumnSizes)[i] = 2;
        }
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (pacific[i][j] && atlantic[i][j]) {
                    result[pos][0] = i;
                    result[pos][1] = j;
                    pos++;
                }
            }
            free(pacific[i]);
            free(atlantic[i]);
        }
        free(pacific);
        free(atlantic);
        *returnSize = pos;
        return result;
}
```

```JavaScript [sol2-JavaScript]
const dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]];
var pacificAtlantic = function(heights) {
    m = heights.length;
    n = heights[0].length;
    const pacific = new Array(m).fill(0).map(() => new Array(n).fill(0));
    const atlantic = new Array(m).fill(0).map(() => new Array(n).fill(0));

    const bfs = (row, col, ocean) => {
        if (ocean[row][col]) {
            return;
        }
        ocean[row][col] = true;
        const queue = [];
        queue.push([row, col]);
        while (queue.length) {
            const cell = queue.shift();
            for (const dir of dirs) {
                const newRow = cell[0] + dir[0], newCol = cell[1] + dir[1];
                if (newRow >= 0 && newRow < m && newCol >= 0 && newCol < n && heights[newRow][newCol] >= heights[cell[0]][cell[1]] && !ocean[newRow][newCol]) {
                    ocean[newRow][newCol] = true;
                    queue.push([newRow, newCol]);
                }
            }
        }
    };

    for (let i = 0; i < m; i++) {
        bfs(i, 0, pacific);
    }
    for (let j = 1; j < n; j++) {
        bfs(0, j, pacific);
    }
    for (let i = 0; i < m; i++) {
        bfs(i, n - 1, atlantic);
    }
    for (let j = 0; j < n - 1; j++) {
        bfs(m - 1, j, atlantic);
    }
    const result = [];
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (pacific[i][j] && atlantic[i][j]) {
                const cell = [];
                cell.push(i);
                cell.push(j);
                result.push(cell);
            }
        }
    }
    return result;
}
```

```go [sol2-Golang]
type pair struct{ x, y int }
var dirs = []pair{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func pacificAtlantic(heights [][]int) (ans [][]int) {
    m, n := len(heights), len(heights[0])
    pacific := make([][]bool, m)
    atlantic := make([][]bool, m)
    for i := range pacific {
        pacific[i] = make([]bool, n)
        atlantic[i] = make([]bool, n)
    }

    bfs := func(x, y int, ocean [][]bool) {
        if ocean[x][y] {
            return
        }
        ocean[x][y] = true
        q := []pair{{x, y}}
        for len(q) > 0 {
            p := q[0]
            q = q[1:]
            for _, d := range dirs {
                if x, y := p.x+d.x, p.y+d.y; 0 <= x && x < m && 0 <= y && y < n && !ocean[x][y] && heights[x][y] >= heights[p.x][p.y] {
                    ocean[x][y] = true
                    q = append(q, pair{x, y})
                }
            }
        }
    }
    for i := 0; i < m; i++ {
        bfs(i, 0, pacific)
    }
    for j := 1; j < n; j++ {
        bfs(0, j, pacific)
    }
    for i := 0; i < m; i++ {
        bfs(i, n-1, atlantic)
    }
    for j := 0; j < n-1; j++ {
        bfs(m-1, j, atlantic)
    }

    for i, row := range pacific {
        for j, ok := range row {
            if ok && atlantic[i][j] {
                ans = append(ans, []int{i, j})
            }
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是矩阵 $\textit{heights}$ 的行数和列数。广度优先搜索最多遍历每个单元格两次，寻找太平洋和大西洋都可以到达的单元格需要遍历整个矩阵，因此时间复杂度是 $O(mn)$。

- 空间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是矩阵 $\textit{heights}$ 的行数和列数。广度优先搜索的队列空间是 $O(mn)$，记录每个单元格是否可以到达太平洋和大西洋需要 $O(mn)$ 的空间，因此空间复杂度是 $O(mn)$。
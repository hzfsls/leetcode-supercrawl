## [529.扫雷游戏 中文官方题解](https://leetcode.cn/problems/minesweeper/solutions/100000/sao-lei-you-xi-by-leetcode-solution)
#### 方法一：深度优先搜索 + 模拟

**思路与算法**

由于题目要求你根据规则来展示执行一次点击操作后游戏面板的变化，所以我们只要明确该扫雷游戏的规则，并用代码模拟出来即可。

那我们着眼于题目的规则，会发现总共分两种情况：
1. 当前点击的是「未挖出的地雷」，我们将其值改为 $\text{X}$ 即可。
2. 当前点击的是「未挖出的空方块」，我们需要统计它周围相邻的方块里地雷的数量 $\textit{cnt}$（即 $\text{M}$ 的数量）。如果 $\textit{cnt}$ 为零，即执行规则 $2$，此时需要将其改为 $\text{B}$，且**递归地处理**周围的八个**未挖出**的方块，递归终止条件即为规则 $4$，没有更多方块可被揭露的时候。否则执行规则 $3$，将其修改为数字即可。

整体看来，一次点击过程会从一个位置出发，逐渐向外圈扩散，所以这引导我们利用「搜索」的方式来实现。这里以深度优先搜索为例：我们定义递归函数 `dfs(x, y)` 表示当前在 $(x,y)$ 点，执行扫雷规则的情况，我们只要按照上面理出来的情况来进行模拟即可，在 $\textit{cnt}$ 为零的时候，对当前点相邻的未挖出的方块调用递归函数，否则将其改为数字，结束递归。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int dir_x[8] = {0, 1, 0, -1, 1, 1, -1, -1};
    int dir_y[8] = {1, 0, -1, 0, 1, -1, 1, -1};

    void dfs(vector<vector<char>>& board, int x, int y) {
        int cnt = 0;
        for (int i = 0; i < 8; ++i) {
            int tx = x + dir_x[i];
            int ty = y + dir_y[i];
            if (tx < 0 || tx >= board.size() || ty < 0 || ty >= board[0].size()) {
                continue;
            }
            // 不用判断 M，因为如果有 M 的话游戏已经结束了
            cnt += board[tx][ty] == 'M';
        }
        if (cnt > 0) {
            // 规则 3
            board[x][y] = cnt + '0';
        } else {
            // 规则 2
            board[x][y] = 'B';
            for (int i = 0; i < 8; ++i) {
                int tx = x + dir_x[i];
                int ty = y + dir_y[i];
                // 这里不需要在存在 B 的时候继续扩展，因为 B 之前被点击的时候已经被扩展过了
                if (tx < 0 || tx >= board.size() || ty < 0 || ty >= board[0].size() || board[tx][ty] != 'E') {
                    continue;
                }
                dfs(board, tx, ty);
            }
        }
    }

    vector<vector<char>> updateBoard(vector<vector<char>>& board, vector<int>& click) {
        int x = click[0], y = click[1];
        if (board[x][y] == 'M') {
            // 规则 1
            board[x][y] = 'X';
        } else {
            dfs(board, x, y);
        }
        return board;
    }
};
```

```Java [sol1-Java]
class Solution {
    int[] dirX = {0, 1, 0, -1, 1, 1, -1, -1};
    int[] dirY = {1, 0, -1, 0, 1, -1, 1, -1};

    public char[][] updateBoard(char[][] board, int[] click) {
        int x = click[0], y = click[1];
        if (board[x][y] == 'M') {
            // 规则 1
            board[x][y] = 'X';
        } else{
            dfs(board, x, y);
        }
        return board;
    }

    public void dfs(char[][] board, int x, int y) {
        int cnt = 0;
        for (int i = 0; i < 8; ++i) {
            int tx = x + dirX[i];
            int ty = y + dirY[i];
            if (tx < 0 || tx >= board.length || ty < 0 || ty >= board[0].length) {
                continue;
            }
            // 不用判断 M，因为如果有 M 的话游戏已经结束了
            if (board[tx][ty] == 'M') {
                ++cnt;
            }
        }
        if (cnt > 0) {
            // 规则 3
            board[x][y] = (char) (cnt + '0');
        } else {
            // 规则 2
            board[x][y] = 'B';
            for (int i = 0; i < 8; ++i) {
                int tx = x + dirX[i];
                int ty = y + dirY[i];
                // 这里不需要在存在 B 的时候继续扩展，因为 B 之前被点击的时候已经被扩展过了
                if (tx < 0 || tx >= board.length || ty < 0 || ty >= board[0].length || board[tx][ty] != 'E') {
                    continue;
                }
                dfs(board, tx, ty);
            }
        }
    }
}
```

```C [sol1-C]
const int dir_x[8] = {0, 1, 0, -1, 1, 1, -1, -1};
const int dir_y[8] = {1, 0, -1, 0, 1, -1, 1, -1};

int n, m;

void dfs(char** board, int x, int y) {
    int cnt = 0;
    for (int i = 0; i < 8; ++i) {
        int tx = x + dir_x[i];
        int ty = y + dir_y[i];
        if (tx < 0 || tx >= n || ty < 0 || ty >= m) {
            continue;
        }
        // 不用判断 M，因为如果有 M 的话游戏已经结束了
        cnt += board[tx][ty] == 'M';
    }
    if (cnt > 0) {
        // 规则 3
        board[x][y] = cnt + '0';
    } else {
        // 规则 2
        board[x][y] = 'B';
        for (int i = 0; i < 8; ++i) {
            int tx = x + dir_x[i];
            int ty = y + dir_y[i];
            // 这里不需要在存在 B 的时候继续扩展，因为 B 之前被点击的时候已经被扩展过了
            if (tx < 0 || tx >= n || ty < 0 || ty >= m || board[tx][ty] != 'E') {
                continue;
            }
            dfs(board, tx, ty);
        }
    }
}

char** updateBoard(char** board, int boardSize, int* boardColSize, int* click, int clickSize, int* returnSize, int** returnColumnSizes) {
    n = boardSize, m = boardColSize[0];
    int x = click[0], y = click[1];
    if (board[x][y] == 'M') {
        // 规则 1
        board[x][y] = 'X';
    } else {
        dfs(board, x, y);
    }
    *returnSize = n;
    **returnColumnSizes = malloc(sizeof(int*) * n);
    for (int i = 0; i < n; i++) {
        (*returnColumnSizes)[i] = m;
    }
    return board;
}
```

```golang [sol1-Golang]
var dirX = []int{0, 1, 0, -1, 1, 1, -1, -1}
var dirY = []int{1, 0, -1, 0, 1, -1, 1, -1}

func updateBoard(board [][]byte, click []int) [][]byte {
    x, y := click[0], click[1]
    if board[x][y] == 'M' {
        board[x][y] = 'X'
    } else {
        dfs(board, x, y)
    }
    return board
}

func dfs(board [][]byte, x, y int) {
    cnt := 0
    for i := 0; i < 8; i++ {
        tx, ty := x + dirX[i], y + dirY[i]
        if tx < 0 || tx >= len(board) || ty < 0 || ty >= len(board[0]) {
            continue
        }
        // 不用判断 M，因为如果有 M 的话游戏已经结束了
        if board[tx][ty] == 'M' {
            cnt++
        }
    }
    if cnt > 0 {
        board[x][y] = byte(cnt + '0')
    } else {
        board[x][y] = 'B'
        for i := 0; i < 8; i++ {
            tx, ty := x + dirX[i], y + dirY[i]
            // 这里不需要在存在 B 的时候继续扩展，因为 B 之前被点击的时候已经被扩展过了
            if tx < 0 || tx >= len(board) || ty < 0 || ty >= len(board[0]) || board[tx][ty] != 'E' {
                continue
            }
            dfs(board, tx, ty)
        }
    }
}
```

**复杂度分析**

- 时间复杂度：$O(nm)$，其中 $n$ 和 $m$ 分别代表面板的宽和高。最坏情况下会遍历整个面板。
- 空间复杂度：$O(nm)$。空间复杂度取决于递归的栈深度，而递归栈深度在最坏情况下有可能遍历整个面板而达到 $O(nm)$。

#### 方法二：广度优先搜索 + 模拟

**思路与算法**

同样地，我们也可以将深度优先搜索改为广度优先搜索来模拟，我们只要在 $\textit{cnt}$ 为零的时候，将当前点相邻的未挖出的方块加入广度优先搜索的队列里即可，其他情况不加入队列，这里不再赘述。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int dir_x[8] = {0, 1, 0, -1, 1, 1, -1, -1};
    int dir_y[8] = {1, 0, -1, 0, 1, -1, 1, -1};

    void bfs(vector<vector<char>>& board, int sx, int sy) {
        queue<pair<int, int>> Q;
        vector<vector<int>> vis(board.size(), vector<int>(board[0].size(), 0));
        Q.push({sx, sy});
        vis[sx][sy] = true;
        while (!Q.empty()) {
            auto pos = Q.front();
            Q.pop();
            int cnt = 0, x = pos.first, y = pos.second;
            for (int i = 0; i < 8; ++i) {
                int tx = x + dir_x[i];
                int ty = y + dir_y[i];
                if (tx < 0 || tx >= board.size() || ty < 0 || ty >= board[0].size()) {
                    continue;
                }
                // 不用判断 M，因为如果有 M 的话游戏已经结束了
                cnt += board[tx][ty] == 'M';
            }
            if (cnt > 0) {
                // 规则 3
                board[x][y] = cnt + '0';
            } else {
                // 规则 2
                board[x][y] = 'B';
                for (int i = 0; i < 8; ++i) {
                    int tx = x + dir_x[i];
                    int ty = y + dir_y[i];
                    // 这里不需要在存在 B 的时候继续扩展，因为 B 之前被点击的时候已经被扩展过了
                    if (tx < 0 || tx >= board.size() || ty < 0 || ty >= board[0].size() || board[tx][ty] != 'E' || vis[tx][ty]) {
                        continue;
                    }
                    Q.push(make_pair(tx, ty));
                    vis[tx][ty] = true;
                }
            }
        }
    }

    vector<vector<char>> updateBoard(vector<vector<char>>& board, vector<int>& click) {
        int x = click[0], y = click[1];
        if (board[x][y] == 'M') {
            // 规则 1
            board[x][y] = 'X';
        } else {
            bfs(board, x, y);
        }
        return board;
    }
};
```

```Java [sol2-Java]
class Solution {
    int[] dirX = {0, 1, 0, -1, 1, 1, -1, -1};
    int[] dirY = {1, 0, -1, 0, 1, -1, 1, -1};

    public char[][] updateBoard(char[][] board, int[] click) {
        int x = click[0], y = click[1];
        if (board[x][y] == 'M') {
            // 规则 1
            board[x][y] = 'X';
        } else{
            bfs(board, x, y);
        }
        return board;
    }

    public void bfs(char[][] board, int sx, int sy) {
        Queue<int[]> queue = new LinkedList<int[]>();
        boolean[][] vis = new boolean[board.length][board[0].length];
        queue.offer(new int[]{sx, sy});
        vis[sx][sy] = true;
        while (!queue.isEmpty()) {
            int[] pos = queue.poll();
            int cnt = 0, x = pos[0], y = pos[1];
            for (int i = 0; i < 8; ++i) {
                int tx = x + dirX[i];
                int ty = y + dirY[i];
                if (tx < 0 || tx >= board.length || ty < 0 || ty >= board[0].length) {
                    continue;
                }
                // 不用判断 M，因为如果有 M 的话游戏已经结束了
                if (board[tx][ty] == 'M') {
                    ++cnt;
                }
            }
            if (cnt > 0) {
                // 规则 3
                board[x][y] = (char) (cnt + '0');
            } else {
                // 规则 2
                board[x][y] = 'B';
                for (int i = 0; i < 8; ++i) {
                    int tx = x + dirX[i];
                    int ty = y + dirY[i];
                    // 这里不需要在存在 B 的时候继续扩展，因为 B 之前被点击的时候已经被扩展过了
                    if (tx < 0 || tx >= board.length || ty < 0 || ty >= board[0].length || board[tx][ty] != 'E' || vis[tx][ty]) {
                        continue;
                    }
                    queue.offer(new int[]{tx, ty});
                    vis[tx][ty] = true;
                }
            }
        }
    }
}
```

```C [sol2-C]
const int dir_x[8] = {0, 1, 0, -1, 1, 1, -1, -1};
const int dir_y[8] = {1, 0, -1, 0, 1, -1, 1, -1};

int n, m;

typedef struct {
    int x, y;
} pair;

void bfs(char** board, int sx, int sy) {
    bool vis[n][m];
    memset(vis, 0, sizeof(vis));
    pair Q[n * m];
    int l = 0, r = 1;
    Q[0].x = sx, Q[0].y = sy;
    vis[sx][sy] = true;
    while (l < r) {
        pair pos = Q[l++];
        int cnt = 0, x = pos.x, y = pos.y;
        for (int i = 0; i < 8; ++i) {
            int tx = x + dir_x[i];
            int ty = y + dir_y[i];
            if (tx < 0 || tx >= n || ty < 0 || ty >= m) {
                continue;
            }
            // 不用判断 M，因为如果有 M 的话游戏已经结束了
            cnt += board[tx][ty] == 'M';
        }
        if (cnt > 0) {
            // 规则 3
            board[x][y] = cnt + '0';
        } else {
            // 规则 2
            board[x][y] = 'B';
            for (int i = 0; i < 8; ++i) {
                int tx = x + dir_x[i];
                int ty = y + dir_y[i];
                // 这里不需要在存在 B 的时候继续扩展，因为 B 之前被点击的时候已经被扩展过了
                if (tx < 0 || tx >= n || ty < 0 || ty >= m || board[tx][ty] != 'E' || vis[tx][ty]) {
                    continue;
                }
                Q[r].x = tx, Q[r++].y = ty;
                vis[tx][ty] = true;
            }
        }
    }
}

char** updateBoard(char** board, int boardSize, int* boardColSize, int* click, int clickSize, int* returnSize, int** returnColumnSizes) {
    n = boardSize, m = boardColSize[0];
    int x = click[0], y = click[1];
    if (board[x][y] == 'M') {
        // 规则 1
        board[x][y] = 'X';
    } else {
        bfs(board, x, y);
    }
    *returnSize = n;
    **returnColumnSizes = malloc(sizeof(int*) * n);
    for (int i = 0; i < n; i++) {
        (*returnColumnSizes)[i] = m;
    }
    return board;
}
```

```golang [sol2-Golang]
var dirX = []int{0, 1, 0, -1, 1, 1, -1, -1}
var dirY = []int{1, 0, -1, 0, 1, -1, 1, -1}

func updateBoard(board [][]byte, click []int) [][]byte {
    x, y := click[0], click[1]
    if board[x][y] == 'M' {
        board[x][y] = 'X'
    } else {
        bfs(board, x, y)
    }
    return board
}

func bfs(board [][]byte, sx, sy int) {
    queue := [][]int{}
    vis := make([][]bool, len(board))
    for i := 0; i < len(vis); i++ {
        vis[i] = make([]bool, len(board[0]))
    }
    queue = append(queue, []int{sx, sy})
    vis[sx][sy] = true
    for i := 0; i < len(queue); i++ {
        cnt, x, y := 0, queue[i][0], queue[i][1]
        for i := 0; i < 8; i++ {
        tx, ty := x + dirX[i], y + dirY[i]
            if tx < 0 || tx >= len(board) || ty < 0 || ty >= len(board[0]) {
                continue
            }
            // 不用判断 M，因为如果有 M 的话游戏已经结束了
            if board[tx][ty] == 'M' {
                cnt++
            }
        }
        if cnt > 0 {
            board[x][y] = byte(cnt + '0')
        } else {
            board[x][y] = 'B'
            for i := 0; i < 8; i++ {
                tx, ty := x + dirX[i], y + dirY[i]
                // 这里不需要在存在 B 的时候继续扩展，因为 B 之前被点击的时候已经被扩展过了
                if tx < 0 || tx >= len(board) || ty < 0 || ty >= len(board[0]) || board[tx][ty] != 'E' || vis[tx][ty] {
                    continue
                }
                queue = append(queue, []int{tx, ty})
                vis[tx][ty] = true
            }
        }
    }
}
```

**复杂度分析**

- 时间复杂度：$O(nm)$，其中 $n$ 和 $m$ 分别代表面板的宽和高。最坏情况下会遍历整个面板。
- 空间复杂度：$O(nm)$。我们需要 $O(nm)$ 的标记数组来标记当前位置是否已经被加入队列防止重复计算。
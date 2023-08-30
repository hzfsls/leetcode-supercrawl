#### 写在前面

本题给定的矩阵中有三种元素：

* 字母 `X`；
* 被字母 `X` 包围的字母 `O`；
* 没有被字母 `X` 包围的字母 `O`。

本题要求将所有被字母 `X` 包围的字母 `O`都变为字母 `X` ，但很难判断哪些 `O` 是被包围的，哪些 `O` 不是被包围的。

注意到题目解释中提到：**任何边界上的 `O` 都不会被填充为 `X`。** 我们可以想到，所有的不被包围的 `O` 都直接或间接与边界上的 `O` 相连。我们可以利用这个性质判断 `O` 是否在边界上，具体地说：

* 对于每一个边界上的 `O`，我们以它为起点，标记所有与它直接或间接相连的字母 `O`；
* 最后我们遍历这个矩阵，对于每一个字母：
  * 如果该字母被标记过，则该字母为没有被字母 `X` 包围的字母 `O`，我们将其还原为字母 `O`；
  * 如果该字母没有被标记过，则该字母为被字母 `X` 包围的字母 `O`，我们将其修改为字母 `X`。

#### 方法一：深度优先搜索

**思路及解法**

我们可以使用深度优先搜索实现标记操作。在下面的代码中，我们把标记过的字母 `O` 修改为字母 `A`。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int n, m;

    void dfs(vector<vector<char>>& board, int x, int y) {
        if (x < 0 || x >= n || y < 0 || y >= m || board[x][y] != 'O') {
            return;
        }
        board[x][y] = 'A';
        dfs(board, x + 1, y);
        dfs(board, x - 1, y);
        dfs(board, x, y + 1);
        dfs(board, x, y - 1);
    }

    void solve(vector<vector<char>>& board) {
        n = board.size();
        if (n == 0) {
            return;
        }
        m = board[0].size();
        for (int i = 0; i < n; i++) {
            dfs(board, i, 0);
            dfs(board, i, m - 1);
        }
        for (int i = 1; i < m - 1; i++) {
            dfs(board, 0, i);
            dfs(board, n - 1, i);
        }
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (board[i][j] == 'A') {
                    board[i][j] = 'O';
                } else if (board[i][j] == 'O') {
                    board[i][j] = 'X';
                }
            }
        }
    }
};
```

```Java [sol1-Java]
class Solution {
    int n, m;

    public void solve(char[][] board) {
        n = board.length;
        if (n == 0) {
            return;
        }
        m = board[0].length;
        for (int i = 0; i < n; i++) {
            dfs(board, i, 0);
            dfs(board, i, m - 1);
        }
        for (int i = 1; i < m - 1; i++) {
            dfs(board, 0, i);
            dfs(board, n - 1, i);
        }
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (board[i][j] == 'A') {
                    board[i][j] = 'O';
                } else if (board[i][j] == 'O') {
                    board[i][j] = 'X';
                }
            }
        }
    }

    public void dfs(char[][] board, int x, int y) {
        if (x < 0 || x >= n || y < 0 || y >= m || board[x][y] != 'O') {
            return;
        }
        board[x][y] = 'A';
        dfs(board, x + 1, y);
        dfs(board, x - 1, y);
        dfs(board, x, y + 1);
        dfs(board, x, y - 1);
    }
}
```

```Python [sol1-Python3]
class Solution:
    def solve(self, board: List[List[str]]) -> None:
        if not board:
            return
        
        n, m = len(board), len(board[0])

        def dfs(x, y):
            if not 0 <= x < n or not 0 <= y < m or board[x][y] != 'O':
                return
            
            board[x][y] = "A"
            dfs(x + 1, y)
            dfs(x - 1, y)
            dfs(x, y + 1)
            dfs(x, y - 1)
        
        for i in range(n):
            dfs(i, 0)
            dfs(i, m - 1)
        
        for i in range(m - 1):
            dfs(0, i)
            dfs(n - 1, i)
        
        for i in range(n):
            for j in range(m):
                if board[i][j] == "A":
                    board[i][j] = "O"
                elif board[i][j] == "O":
                    board[i][j] = "X"
```

```golang [sol1-Golang]
var n, m int

func solve(board [][]byte)  {
    if len(board) == 0 || len(board[0]) == 0 {
        return
    }
    n, m = len(board), len(board[0])
    for i := 0; i < n; i++ {
        dfs(board, i, 0)
        dfs(board, i, m - 1)
    }
    for i := 1; i < m - 1; i++ {
        dfs(board, 0, i)
        dfs(board, n - 1, i)
    }
    for i := 0; i < n; i++ {
        for j := 0; j < m; j++ {
            if board[i][j] == 'A' {
                board[i][j] = 'O'
            } else if board[i][j] == 'O' {
                board[i][j] = 'X'
            }
        }
    }
}

func dfs(board [][]byte, x, y int) {
    if x < 0 || x >= n || y < 0 || y >= m || board[x][y] != 'O' {
        return
    }
    board[x][y] = 'A'
    dfs(board, x + 1, y)
    dfs(board, x - 1, y)
    dfs(board, x, y + 1)
    dfs(board, x, y - 1)
}
```

**复杂度分析**

- 时间复杂度：$O(n \times m)$，其中 $n$ 和 $m$ 分别为矩阵的行数和列数。深度优先搜索过程中，每一个点至多只会被标记一次。

- 空间复杂度：$O(n \times m)$，其中 $n$ 和 $m$ 分别为矩阵的行数和列数。主要为深度优先搜索的栈的开销。

#### 方法二：广度优先搜索

**思路及解法**

我们可以使用广度优先搜索实现标记操作。在下面的代码中，我们把标记过的字母 `O` 修改为字母 `A`。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    const int dx[4] = {1, -1, 0, 0};
    const int dy[4] = {0, 0, 1, -1};

    void solve(vector<vector<char>>& board) {
        int n = board.size();
        if (n == 0) {
            return;
        }
        int m = board[0].size();
        queue<pair<int, int>> que;
        for (int i = 0; i < n; i++) {
            if (board[i][0] == 'O') {
                que.emplace(i, 0);
                board[i][0] = 'A';
            }
            if (board[i][m - 1] == 'O') {
                que.emplace(i, m - 1);
                board[i][m - 1] = 'A';
            }
        }
        for (int i = 1; i < m - 1; i++) {
            if (board[0][i] == 'O') {
                que.emplace(0, i);
                board[0][i] = 'A';
            }
            if (board[n - 1][i] == 'O') {
                que.emplace(n - 1, i);
                board[n - 1][i] = 'A';
            }
        }
        while (!que.empty()) {
            int x = que.front().first, y = que.front().second;
            que.pop();
            for (int i = 0; i < 4; i++) {
                int mx = x + dx[i], my = y + dy[i];
                if (mx < 0 || my < 0 || mx >= n || my >= m || board[mx][my] != 'O') {
                    continue;
                }
                que.emplace(mx, my);
                board[mx][my] = 'A';
            }
        }
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (board[i][j] == 'A') {
                    board[i][j] = 'O';
                } else if (board[i][j] == 'O') {
                    board[i][j] = 'X';
                }
            }
        }
    }
};

```

```Java [sol2-Java]
class Solution {
    int[] dx = {1, -1, 0, 0};
    int[] dy = {0, 0, 1, -1};

    public void solve(char[][] board) {
        int n = board.length;
        if (n == 0) {
            return;
        }
        int m = board[0].length;
        Queue<int[]> queue = new LinkedList<int[]>();
        for (int i = 0; i < n; i++) {
            if (board[i][0] == 'O') {
                queue.offer(new int[]{i, 0});
                board[i][0] = 'A';
            }
            if (board[i][m - 1] == 'O') {
                queue.offer(new int[]{i, m - 1});
                board[i][m - 1] = 'A';
            }
        }
        for (int i = 1; i < m - 1; i++) {
            if (board[0][i] == 'O') {
                queue.offer(new int[]{0, i});
                board[0][i] = 'A';
            }
            if (board[n - 1][i] == 'O') {
                queue.offer(new int[]{n - 1, i});
                board[n - 1][i] = 'A';
            }
        }
        while (!queue.isEmpty()) {
            int[] cell = queue.poll();
            int x = cell[0], y = cell[1];
            for (int i = 0; i < 4; i++) {
                int mx = x + dx[i], my = y + dy[i];
                if (mx < 0 || my < 0 || mx >= n || my >= m || board[mx][my] != 'O') {
                    continue;
                }
                queue.offer(new int[]{mx, my});
                board[mx][my] = 'A';
            }
        }
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (board[i][j] == 'A') {
                    board[i][j] = 'O';
                } else if (board[i][j] == 'O') {
                    board[i][j] = 'X';
                }
            }
        }
    }
}
```

```Python [sol2-Python3]
class Solution:
    def solve(self, board: List[List[str]]) -> None:
        if not board:
            return
        
        n, m = len(board), len(board[0])
        que = collections.deque()
        for i in range(n):
            if board[i][0] == "O":
                que.append((i, 0))
                board[i][0] = "A"
            if board[i][m - 1] == "O":
                que.append((i, m - 1))
                board[i][m - 1] = "A"
        for i in range(m - 1):
            if board[0][i] == "O":
                que.append((0, i))
                board[0][i] = "A"
            if board[n - 1][i] == "O":
                que.append((n - 1, i))
                board[n - 1][i] = "A"
        
        while que:
            x, y = que.popleft()
            for mx, my in [(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]:
                if 0 <= mx < n and 0 <= my < m and board[mx][my] == "O":
                    que.append((mx, my))
                    board[mx][my] = "A"
        
        for i in range(n):
            for j in range(m):
                if board[i][j] == "A":
                    board[i][j] = "O"
                elif board[i][j] == "O":
                    board[i][j] = "X"
```

```C [sol2-C]
const int dx[4] = {1, -1, 0, 0};
const int dy[4] = {0, 0, 1, -1};

void solve(char** board, int boardSize, int* boardColSize) {
    int n = boardSize;
    if (n == 0) {
        return;
    }
    int m = boardColSize[0];

    int** que = (int**)malloc(sizeof(int*) * n * m);
    for (int i = 0; i < n * m; i++) {
        que[i] = (int*)malloc(sizeof(int) * 2);
    }
    int l = 0, r = 0;
    for (int i = 0; i < n; i++) {
        if (board[i][0] == 'O') {
            board[i][0] = 'A';
            que[r][0] = i, que[r++][1] = 0;
        }
        if (board[i][m - 1] == 'O') {
            board[i][m - 1] = 'A';
            que[r][0] = i, que[r++][1] = m - 1;
        }
    }
    for (int i = 1; i < m - 1; i++) {
        if (board[0][i] == 'O') {
            board[0][i] = 'A';
            que[r][0] = 0, que[r++][1] = i;
        }
        if (board[n - 1][i] == 'O') {
            board[n - 1][i] = 'A';
            que[r][0] = n - 1, que[r++][1] = i;
        }
    }
    while (l < r) {
        int x = que[l][0], y = que[l][1];
        l++;
        for (int i = 0; i < 4; i++) {
            int mx = x + dx[i], my = y + dy[i];
            if (mx < 0 || my < 0 || mx >= n || my >= m || board[mx][my] != 'O') {
                continue;
            }
            board[mx][my] = 'A';
            que[r][0] = mx, que[r++][1] = my;
        }
    }
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            if (board[i][j] == 'A') {
                board[i][j] = 'O';
            } else if (board[i][j] == 'O') {
                board[i][j] = 'X';
            }
        }
    }
    for (int i = 0; i < n * m; i++) {
        free(que[i]);
    }
    free(que);
}
```

```golang [sol2-Golang]
var (
    dx = [4]int{1, -1, 0, 0}
    dy = [4]int{0, 0, 1, -1}
)
func solve(board [][]byte)  {
    if len(board) == 0 || len(board[0]) == 0 {
        return
    }
    n, m := len(board), len(board[0])
    queue := [][]int{}
    for i := 0; i < n; i++ {
        if board[i][0] == 'O' {
            queue = append(queue, []int{i, 0})
            board[i][0] = 'A'
        }
        if board[i][m-1] == 'O' {
            queue = append(queue, []int{i, m - 1})
            board[i][m - 1] = 'A'
        }
    }
    for i := 1; i < m - 1; i++ {
        if board[0][i] == 'O' {
            queue = append(queue, []int{0, i})
            board[0][i] = 'A'
        }
        if board[n-1][i] == 'O' {
            queue = append(queue, []int{n - 1, i})
            board[n - 1][i] = 'A'
        }
    }
    for len(queue) > 0 {
        cell := queue[0]
        queue = queue[1:]
        x, y := cell[0], cell[1]
        for i := 0; i < 4; i++ {
            mx, my := x + dx[i], y + dy[i]
            if mx < 0 || my < 0 || mx >= n || my >= m || board[mx][my] != 'O' {
                continue
            }
            queue = append(queue, []int{mx, my})
            board[mx][my] = 'A'
        }
    }
    for i := 0; i < n; i++ {
        for j := 0; j < m; j++ {
            if board[i][j] == 'A' {
                board[i][j] = 'O'
            } else if board[i][j] == 'O' {
                board[i][j] = 'X'
            }
        }
    }
}
```

**复杂度分析**

- 时间复杂度：$O(n \times m)$，其中 $n$ 和 $m$ 分别为矩阵的行数和列数。广度优先搜索过程中，每一个点至多只会被标记一次。

- 空间复杂度：$O(n \times m)$，其中 $n$ 和 $m$ 分别为矩阵的行数和列数。主要为广度优先搜索的队列的开销。
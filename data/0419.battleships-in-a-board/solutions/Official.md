#### 方法一：遍历扫描

题目要求找到矩阵中战舰的数量，战舰用 $\texttt{'X'}$ 表示，空位用 $\texttt{'.'}$，而矩阵中的战舰的满足以下两个条件：

- 战舰只能水平或者垂直放置。战舰只能由子矩阵 $1 \times N$（$1$ 行，$N$ 列）组成，或者子矩阵 $N \times 1$（$N$ 行, $1$ 列）组成，其中 $N$ 可以是任意大小。
- 两艘战舰之间至少有一个水平或垂直的空位分隔，没有相邻的战舰。

我们遍历矩阵中的每个位置 $(i,j)$ 且满足 $\textit{board}[i][j] = \texttt{'X'}$，并将以 $(i,j)$ 为起点的战舰的所有位置均设置为空位，从而我们即可统计出所有可能的战舰。

**代码**

```Java [sol1-Java]
class Solution {
    public int countBattleships(char[][] board) {
        int row = board.length;
        int col = board[0].length;
        int ans = 0;
        for (int i = 0; i < row; ++i) {
            for (int j = 0; j < col; ++j) {
                if (board[i][j] == 'X') {
                    board[i][j] = '.';
                    for (int k = j + 1; k < col && board[i][k] == 'X'; ++k) {
                        board[i][k] = '.';
                    }                    
                    for (int k = i + 1; k < row && board[k][j] == 'X'; ++k) {
                        board[k][j] = '.';
                    }
                    ans++;
                }
            }
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int countBattleships(vector<vector<char>>& board) {
        int row = board.size();
        int col = board[0].size();
        int ans = 0;
        for (int i = 0; i < row; ++i) {
            for (int j = 0; j < col; ++j) {
                if (board[i][j] == 'X') {
                    board[i][j] = '.';
                    for (int k = j + 1; k < col && board[i][k] == 'X'; ++k) {
                        board[i][k] = '.';
                    }                    
                    for (int k = i + 1; k < row && board[k][j] == 'X'; ++k) {
                        board[k][j] = '.';
                    }
                    ans++;
                }
            }
        }
        return ans;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public int CountBattleships(char[][] board) {
        int row = board.Length;
        int col = board[0].Length;
        int ans = 0;
        for (int i = 0; i < row; ++i) {
            for (int j = 0; j < col; ++j) {
                if (board[i][j] == 'X') {
                    board[i][j] = '.';
                    for (int k = j + 1; k < col && board[i][k] == 'X'; ++k) {
                        board[i][k] = '.';
                    }                    
                    for (int k = i + 1; k < row && board[k][j] == 'X'; ++k) {
                        board[k][j] = '.';
                    }
                    ans++;
                }
            }
        }
        return ans;
    }
}
```

```C [sol1-C]
int countBattleships(char** board, int boardSize, int* boardColSize){
    int row = boardSize;
    int col = boardColSize[0];
    int ans = 0;
    for (int i = 0; i < row; ++i) {
        for (int j = 0; j < col; ++j) {
            if (board[i][j] == 'X') {
                board[i][j] = '.';
                for (int k = j + 1; k < col && board[i][k] == 'X'; ++k) {
                    board[i][k] = '.';
                }                    
                for (int k = i + 1; k < row && board[k][j] == 'X'; ++k) {
                    board[k][j] = '.';
                }
                ans++;
            }
        }
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var countBattleships = function(board) {
    const row = board.length;
    const col = board[0].length;
    let ans = 0;
    for (let i = 0; i < row; ++i) {
        for (let j = 0; j < col; ++j) {
            if (board[i][j] === 'X') {
                board[i][j] = '.';
                for (let k = j + 1; k < col && board[i][k] === 'X'; ++k) {
                    board[i][k] = '.';
                }                    
                for (let k = i + 1; k < row && board[k][j] === 'X'; ++k) {
                    board[k][j] = '.';
                }
                ans++;
            }
        }
    }
    return ans;
};
```

```go [sol1-Golang]
func countBattleships(board [][]byte) (ans int) {
    m, n := len(board), len(board[0])
    for i, row := range board {
        for j, ch := range row {
            if ch == 'X' {
                row[j] = '.'
                for k := j + 1; k < n && row[k] == 'X'; k++ {
                    row[k] = '.'
                }
                for k := i + 1; k < m && board[k][j] == 'X'; k++ {
                    board[k][j] = '.'
                }
                ans++
            }
        }
    }
    return
}
```

```Python [sol1-Python3]
class Solution:
    def countBattleships(self, board: List[List[str]]) -> int:
        ans = 0
        m, n = len(board), len(board[0])
        for i, row in enumerate(board):
            for j, ch in enumerate(row):
                if ch == 'X':
                    row[j] = '.'
                    for k in range(j + 1, n):
                        if row[k] != 'X':
                            break
                        row[k] = '.'
                    for k in range(i + 1, m):
                        if board[k][j] != 'X':
                            break
                        board[k][j] = '.'
                    ans += 1
        return ans
```

**复杂度分析**

- 时间复杂度：$O(m \times n \times \max(m,n))$，其中 $m$ 是矩阵的行数，$n$ 是矩阵的列数，我们对于矩阵的每个位置都会遍历一遍以该位置所在的行和列。

- 空间复杂度：$O(1)$。

#### 方法二：枚举起点

题目进阶要求一次扫描算法，只使用 $O(1)$ 额外空间，并且不修改甲板的值。因为题目中给定的两艘战舰之间至少有一个水平或垂直的空位分隔，任意两个战舰之间是不相邻的，因此我们可以通过枚举每个战舰的左上顶点即可统计战舰的个数。假设矩阵的行数为 $\textit{row}$，矩阵的列数 $\textit{col}$，矩阵中的位置 $(i, j)$ 为战舰的左上顶点，需满足以下条件：

- 满足当前位置所在的值 $\textit{board}[i][j] = \texttt{'X'}$；
- 满足当前位置的左则为空位，即$\textit{board}[i][j-1] = \texttt{'.'}$；
- 满足当前位置的上方为空位，即$\textit{board}[i-1][j] = \texttt{'.'}$；

我们统计出所有战舰的左上顶点的个数即为所有战舰的个数。

**代码**

```Java [sol2-Java]
class Solution {
    public int countBattleships(char[][] board) {
        int row = board.length;
        int col = board[0].length;
        int ans = 0;
        for (int i = 0; i < row; ++i) {
            for (int j = 0; j < col; ++j) {
                if (board[i][j] == 'X') {
                    if (i > 0 && board[i - 1][j] == 'X') {
                        continue;
                    }
                    if (j > 0 && board[i][j - 1] == 'X') {
                        continue;
                    }
                    ans++;
                }
            }
        }
        return ans;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int countBattleships(vector<vector<char>>& board) {
        int row = board.size();
        int col = board[0].size();
        int ans = 0;
        for (int i = 0; i < row; ++i) {
            for (int j = 0; j < col; ++j) { 
                if (board[i][j] == 'X') {
                    if (i > 0 && board[i - 1][j] == 'X') {
                        continue;
                    }
                    if (j > 0 && board[i][j - 1] == 'X') {
                        continue;
                    }
                    ans++;
                }
            }
        }
        return ans;
    }
};
```

```C# [sol2-C#]
public class Solution {
    public int CountBattleships(char[][] board) {
        int row = board.Length;
        int col = board[0].Length;
        int ans = 0;
        for (int i = 0; i < row; ++i) {
            for (int j = 0; j < col; ++j) {
                if (board[i][j] == 'X') {
                    if (i > 0 && board[i - 1][j] == 'X') {
                        continue;
                    }
                    if (j > 0 && board[i][j - 1] == 'X') {
                        continue;
                    }
                    ans++;
                }
            }
        }
        return ans;
    }
}
```

```C [sol2-C]
int countBattleships(char** board, int boardSize, int* boardColSize){
    int row = boardSize;
    int col = boardColSize[0];
    int ans = 0;
    for (int i = 0; i < row; ++i) {
        for (int j = 0; j < col; ++j) {
            if (board[i][j] == 'X') {
                if (i > 0 && board[i - 1][j] == 'X') {
                    continue;
                }
                if (j > 0 && board[i][j - 1] == 'X') {
                    continue;
                }
                ans++;
            }
        }
    }
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var countBattleships = function(board) {
    const row = board.length;
    const col = board[0].length;
    let ans = 0;
    for (let i = 0; i < row; ++i) {
        for (let j = 0; j < col; ++j) {
            if (board[i][j] === 'X') {
                if (i > 0 && board[i - 1][j] === 'X') {
                    continue;
                }
                if (j > 0 && board[i][j - 1] === 'X') {
                    continue;
                }
                ans++;
            }
        }
    }
    return ans;
};
```

```go [sol2-Golang]
func countBattleships(board [][]byte) (ans int) {
    for i, row := range board {
        for j, ch := range row {
            if ch == 'X' && !(i > 0 && board[i-1][j] == 'X' || j > 0 && board[i][j-1] == 'X') {
                ans++
            }
        }
    }
    return
}
```

```Python [sol2-Python3]
class Solution:
    def countBattleships(self, board: List[List[str]]) -> int:
        return sum(ch == 'X' and not (i > 0 and board[i - 1][j] == 'X' or j > 0 and board[i][j - 1] == 'X')
                   for i, row in enumerate(board) for j, ch in enumerate(row))
```

**复杂度分析**

- 时间复杂度：$O(m \times n)$，其中 $m$ 是矩阵的行数，$n$ 是矩阵的列数，我们只需要遍历一遍矩阵中每个位置即可。

- 空间复杂度：$O(1)$。
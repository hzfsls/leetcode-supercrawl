## [794.有效的井字游戏 中文官方题解](https://leetcode.cn/problems/valid-tic-tac-toe-state/solutions/100000/you-xiao-de-jing-zi-you-xi-by-leetcode-s-c1j3)
#### 方法一：分类讨论

**思路**

题目要求判断当前游戏板是否生效，我们思考游戏板生效的规则：
- 玩家轮流将字符放入空位 $\texttt{" "}$ 中。第一个玩家总是放字符 $\texttt{"X"}$，且第二个玩家总是放字符 $\texttt{"O"}$。因为第一个玩家总是先手，这就要求游戏板中字符 $\texttt{"X"}$ 的数量一定是大于等于字符 $\texttt{"O"}$ 的数量。
- $\texttt{"X"}$ 和 $\texttt{"O"}$ 只允许放置在空位中，不允许对已放有字符的位置进行填充。
- 当有 $3$ 个相同（且非空）的字符填充任何行、列或对角线时，游戏结束。当所有位置非空时，也算为游戏结束。如果游戏结束，玩家不允许再放置字符，不可能能出现二者同时获胜的情况，因此游戏板上不可能同时出现 $3$ 个 $\texttt{"X"}$ 在一行和 $3$ 个 $\texttt{"O"}$ 在另一行。
- 获胜的玩家一定是在自己放棋后赢得比赛，赢得比赛后，立马停止放置字符。
  - 如果第一个玩家获胜，由于第一个玩家是先手，则次数游戏板中 $\texttt{"X"}$ 的数量比 $\texttt{"O"}$ 的数量多 $1$。
  - 如果第二个玩家获胜，则 $\texttt{"X"}$ 的数量与 $\texttt{"O"}$ 的数量相同。

以上条件包含了游戏板生效的全部情况，可以通过反证法验证上面分类条件的正确性。在合法的游戏板，只能有 $3$ 种结果合法，要么没有任何玩家赢，要么玩家一赢，要么玩家二赢。我们可以通过检查两种棋的数量关系即可验证是否有效，同时我们要检测是否存在两个玩家同时赢这种非法情况。

算法实现细节如下:
- 首先统计游戏板上 $\texttt{"X"}$ 和 $\texttt{"O"}$ 的数量并记录在 $\textit{xCount}$ 和 $\textit{oCount}$ 中，如果不满足 $\textit{xCount} \ge \textit{oCount}$，则此时为非法，直接返回 $\texttt{false}$。
- 然后我们检查是否有玩家是否获胜，我们检查在棋盘的 $3$ 行，$3$ 列和 $2$ 条对角线上是否有该玩家的连续 $3$ 枚棋子。我们首先检测玩家一是否获胜，如果玩家一获胜,则检查 $\textit{xCount}$ 是否等于 $\textit{oCount} + 1$；我们继续检测玩家二是否获胜，如果玩家二获胜，则检查 $\textit{xCount}$ 是否等于 $\textit{oCount}$。
- 对于特殊情况如果两个玩家都获胜，是否可以检测出该非法情况？如果同时满足两个玩家都获胜，则 $\texttt{"X"}$ 和 $\texttt{"O"}$ 数量的合法的组合可能为 $(3,3),(4,3),(4,4),(5,4)$，对于 $(3,3),(4,4)$ 不满足玩家一获胜的检测条件，对于 $(4,3),(5,4)$ 满足玩家一获胜的检测条件但不满足玩家二的获胜条件。

**代码**

```Java [sol1-Java]
class Solution {
    public boolean validTicTacToe(String[] board) {
        int xCount = 0, oCount = 0;
        for (String row : board) {
            for (char c : row.toCharArray()) {
                xCount = (c == 'X') ? (xCount + 1) : xCount;
                oCount = (c == 'O') ? (oCount + 1) : oCount;
            }
        }
        return !((oCount != xCount && oCount != xCount - 1) ||
               (oCount != xCount - 1 && win(board, 'X')) ||
               (oCount != xCount && win(board, 'O')));
    }

    public boolean win(String[] board, char p) {
        for (int i = 0; i < 3; ++i) {
            if ((p == board[0].charAt(i) && p == board[1].charAt(i) && p == board[2].charAt(i)) ||
               (p == board[i].charAt(0) && p == board[i].charAt(1) && p == board[i].charAt(2))) {
                return true;
            }
        }
        return ((p == board[0].charAt(0) && p == board[1].charAt(1) && p == board[2].charAt(2)) ||
                (p == board[0].charAt(2) && p == board[1].charAt(1) && p == board[2].charAt(0)));
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool validTicTacToe(vector<string>& board) {
        int xCount = 0, oCount = 0;
        for (string & row : board) {
            for (char c : row) {
                xCount = (c == 'X') ? (xCount + 1) : xCount;
                oCount = (c == 'O') ? (oCount + 1) : oCount;
            }
        }
        return !((oCount != xCount && oCount != xCount - 1) ||
               (oCount != xCount - 1 && win(board, 'X')) ||
               (oCount != xCount && win(board, 'O')));
    }

    bool win(vector<string>& board, char p) {
        for (int i = 0; i < 3; ++i) {
            if ((p == board[0][i] && p == board[1][i] && p == board[2][i]) ||
               (p == board[i][0] && p == board[i][1] && p == board[i][2])) {
                return true;
            }
        }
        return ((p == board[0][0] && p == board[1][1] && p == board[2][2]) ||
                (p == board[0][2] && p == board[1][1] && p == board[2][0]));
    }
};
```

```C# [sol1-C#]
public class Solution {
    public bool ValidTicTacToe(string[] board) {
        int xCount = 0, oCount = 0;
        foreach (string row in board) {
            foreach (char c in row) {
                xCount = (c == 'X') ? (xCount + 1) : xCount;
                oCount = (c == 'O') ? (oCount + 1) : oCount;
            }
        }
        return !((oCount != xCount && oCount != xCount - 1) ||
               (oCount != xCount - 1 && win(board, 'X')) ||
               (oCount != xCount && win(board, 'O')));
    }

    public bool win(string[] board, char p) {
        for (int i = 0; i < 3; ++i) {
            if ((p == board[0][i] && p == board[1][i] && p == board[2][i]) ||
               (p == board[i][0] && p == board[i][1] && p == board[i][2])) {
                return true;
            }
        }
        return ((p == board[0][0] && p == board[1][1] && p == board[2][2]) ||
                (p == board[0][2] && p == board[1][1] && p == board[2][0]));
    }
}
```

```Python [sol1-Python3]
class Solution:
    def win(self, board: List[str], p: str) -> bool:
        return any(board[i][0] == p and board[i][1] == p and board[i][2] == p or
                   board[0][i] == p and board[1][i] == p and board[2][i] == p for i in range(3)) or \
                   board[0][0] == p and board[1][1] == p and board[2][2] == p or \
                   board[0][2] == p and board[1][1] == p and board[2][0] == p

    def validTicTacToe(self, board: List[str]) -> bool:
        oCount = sum(row.count('O') for row in board)
        xCount = sum(row.count('X') for row in board)
        return not (oCount != xCount and oCount != xCount - 1 or
                    oCount != xCount and self.win(board, 'O') or
                    oCount != xCount - 1 and self.win(board, 'X'))
```

```go [sol1-Golang]
func win(board []string, p byte) bool {
    for i := 0; i < 3; i++ {
        if board[i][0] == p && board[i][1] == p && board[i][2] == p ||
            board[0][i] == p && board[1][i] == p && board[2][i] == p {
            return true
        }
    }
    return board[0][0] == p && board[1][1] == p && board[2][2] == p ||
        board[0][2] == p && board[1][1] == p && board[2][0] == p
}

func validTicTacToe(board []string) bool {
    oCount, xCount := 0, 0
    for _, row := range board {
        oCount += strings.Count(row, "O")
        xCount += strings.Count(row, "X")
    }
    return !(oCount != xCount && oCount != xCount-1 ||
        oCount != xCount && win(board, 'O') ||
        oCount != xCount-1 && win(board, 'X'))
}
```

```JavaScript [sol1-JavaScript]
var validTicTacToe = function(board) {
    let xCount = 0, oCount = 0;
    for (const row of board) {
        for (const c of row) {
            xCount = (c === 'X') ? (xCount + 1) : xCount;
            oCount = (c === 'O') ? (oCount + 1) : oCount;
        }
    }
    return !((oCount != xCount && oCount != xCount - 1) ||
               (oCount != xCount - 1 && win(board, 'X')) ||
               (oCount != xCount && win(board, 'O')));
};

const win = (board, p) => {
    for (let i = 0; i < 3; ++i) {
        if ((p == board[0][i] && p == board[1][i] && p == board[2][i]) ||
            (p == board[i][0] && p == board[i][1] && p == board[i][2])) {
            return true;
        }
    }
    return ((p == board[0][0] && p == board[1][1] && p == board[2][2]) ||
            (p == board[0][2] && p == board[1][1] && p == board[2][0]));
}
```

```C [sol1-C]
bool win(const char ** board, char p) {
    for (int i = 0; i < 3; ++i) {
        if ((p == board[0][i] && p == board[1][i] && p == board[2][i]) ||
            (p == board[i][0] && p == board[i][1] && p == board[i][2])) {
            return true;
        }
    }
    return ((p == board[0][0] && p == board[1][1] && p == board[2][2]) ||
            (p == board[0][2] && p == board[1][1] && p == board[2][0]));
}

bool validTicTacToe(char ** board, int boardSize){
    int xCount = 0, oCount = 0;
    for (int i = 0; i < boardSize; ++i) {
        for (int j = 0; j < 3; ++j) {
            xCount = (board[i][j] == 'X') ? (xCount + 1) : xCount;
            oCount = (board[i][j] == 'O') ? (oCount + 1) : oCount;
        }
    }
    return !((oCount != xCount && oCount != xCount - 1) ||
            (oCount != xCount - 1 && win(board, 'X')) ||
            (oCount != xCount && win(board, 'O')));
}
```

**复杂度分析**

- 时间复杂度：$O(C)$，由于此题给定的棋盘大小为常数 $C = 9$，因此时间复杂度为常数。

- 空间复杂度：$O(1)$。
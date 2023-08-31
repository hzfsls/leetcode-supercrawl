## [37.解数独 中文官方题解](https://leetcode.cn/problems/sudoku-solver/solutions/100000/jie-shu-du-by-leetcode-solution)
#### 前言

我们可以考虑按照「行优先」的顺序依次枚举每一个空白格中填的数字，通过递归 + 回溯的方法枚举所有可能的填法。当递归到最后一个空白格后，如果仍然没有冲突，说明我们找到了答案；在递归的过程中，如果当前的空白格不能填下任何一个数字，那么就进行回溯。

由于每个数字在同一行、同一列、同一个九宫格中只会出现一次，因此我们可以使用 $\textit{line}[i]$，$\textit{column}[j]$，$\textit{block}[x][y]$ 分别表示第 $i$ 行，第 $j$ 列，第 $(x, y)$ 个九宫格中填写数字的情况。在下面给出的三种方法中，我们将会介绍两种不同的表示填写数字情况的方法。

> 九宫格的范围为 $0 \leq x \leq 2$ 以及 $0 \leq y \leq 2$。
> 具体地，第 $i$ 行第 $j$ 列的格子位于第 $(\lfloor i/3 \rfloor, \lfloor j/3 \rfloor)$ 个九宫格中，其中 $\lfloor u \rfloor$ 表示对 $u$ 向下取整。

由于这些方法均以递归 + 回溯为基础，算法运行的时间（以及时间复杂度）很大程度取决于给定的输入数据，而我们很难找到一个非常精确的渐进紧界。因此这里只给出一个较为宽松的渐进复杂度上界 $O(9^{9 \times 9})$，即最多有 $9 \times 9$ 个空白格，每个格子可以填 $[1, 9]$ 中的任意整数。

#### 方法一：回溯

**思路**

最容易想到的方法是用一个数组记录每个数字是否出现。由于我们可以填写的数字范围为 $[1, 9]$，而数组的下标从 $0$ 开始，因此在存储时，我们使用一个长度为 $9$ 的布尔类型的数组，其中 $i$ 个元素的值为 $\text{True}$，当且仅当数字 $i+1$ 出现过。例如我们用 $\textit{line}[2][3] = \text{True}$ 表示数字 $4$ 在第 $2$ 行已经出现过，那么当我们在遍历到第 $2$ 行的空白格时，就不能填入数字 $4$。

**算法**

我们首先对整个数独数组进行遍历，当我们遍历到第 $i$ 行第 $j$ 列的位置：

- 如果该位置是一个空白格，那么我们将其加入一个用来存储空白格位置的列表中，方便后续的递归操作；

- 如果该位置是一个数字 $x$，那么我们需要将 $\textit{line}[i][x-1]$，$\textit{column}[j][x-1]$ 以及 $\textit{block}[\lfloor i/3 \rfloor][\lfloor j/3 \rfloor][x-1]$ 均置为 $\text{True}$。

当我们结束了遍历过程之后，就可以开始递归枚举。当递归到第 $i$ 行第 $j$ 列的位置时，我们枚举填入的数字 $x$。根据题目的要求，数字 $x$ 不能和当前行、列、九宫格中已经填入的数字相同，因此 $\textit{line}[i][x-1]$，$\textit{column}[j][x-1]$ 以及 $\textit{block}[\lfloor i/3 \rfloor][\lfloor j/3 \rfloor][x-1]$ 必须均为 $\text{False}$。

当我们填入了数字 $x$ 之后，我们要将上述的三个值都置为 $\text{True}$，并且继续对下一个空白格位置进行递归。在回溯到当前递归层时，我们还要将上述的三个值重新置为 $\text{False}$。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    bool line[9][9];
    bool column[9][9];
    bool block[3][3][9];
    bool valid;
    vector<pair<int, int>> spaces;

public:
    void dfs(vector<vector<char>>& board, int pos) {
        if (pos == spaces.size()) {
            valid = true;
            return;
        }

        auto [i, j] = spaces[pos];
        for (int digit = 0; digit < 9 && !valid; ++digit) {
            if (!line[i][digit] && !column[j][digit] && !block[i / 3][j / 3][digit]) {
                line[i][digit] = column[j][digit] = block[i / 3][j / 3][digit] = true;
                board[i][j] = digit + '0' + 1;
                dfs(board, pos + 1);
                line[i][digit] = column[j][digit] = block[i / 3][j / 3][digit] = false;
            }
        }
    }

    void solveSudoku(vector<vector<char>>& board) {
        memset(line, false, sizeof(line));
        memset(column, false, sizeof(column));
        memset(block, false, sizeof(block));
        valid = false;

        for (int i = 0; i < 9; ++i) {
            for (int j = 0; j < 9; ++j) {
                if (board[i][j] == '.') {
                    spaces.emplace_back(i, j);
                }
                else {
                    int digit = board[i][j] - '0' - 1;
                    line[i][digit] = column[j][digit] = block[i / 3][j / 3][digit] = true;
                }
            }
        }

        dfs(board, 0);
    }
};
```

```Java [sol1-Java]
class Solution {
    private boolean[][] line = new boolean[9][9];
    private boolean[][] column = new boolean[9][9];
    private boolean[][][] block = new boolean[3][3][9];
    private boolean valid = false;
    private List<int[]> spaces = new ArrayList<int[]>();

    public void solveSudoku(char[][] board) {
        for (int i = 0; i < 9; ++i) {
            for (int j = 0; j < 9; ++j) {
                if (board[i][j] == '.') {
                    spaces.add(new int[]{i, j});
                } else {
                    int digit = board[i][j] - '0' - 1;
                    line[i][digit] = column[j][digit] = block[i / 3][j / 3][digit] = true;
                }
            }
        }

        dfs(board, 0);
    }

    public void dfs(char[][] board, int pos) {
        if (pos == spaces.size()) {
            valid = true;
            return;
        }

        int[] space = spaces.get(pos);
        int i = space[0], j = space[1];
        for (int digit = 0; digit < 9 && !valid; ++digit) {
            if (!line[i][digit] && !column[j][digit] && !block[i / 3][j / 3][digit]) {
                line[i][digit] = column[j][digit] = block[i / 3][j / 3][digit] = true;
                board[i][j] = (char) (digit + '0' + 1);
                dfs(board, pos + 1);
                line[i][digit] = column[j][digit] = block[i / 3][j / 3][digit] = false;
            }
        }
    }
}
```

```Python [sol1-Python3]
class Solution:
    def solveSudoku(self, board: List[List[str]]) -> None:
        def dfs(pos: int):
            nonlocal valid
            if pos == len(spaces):
                valid = True
                return
            
            i, j = spaces[pos]
            for digit in range(9):
                if line[i][digit] == column[j][digit] == block[i // 3][j // 3][digit] == False:
                    line[i][digit] = column[j][digit] = block[i // 3][j // 3][digit] = True
                    board[i][j] = str(digit + 1)
                    dfs(pos + 1)
                    line[i][digit] = column[j][digit] = block[i // 3][j // 3][digit] = False
                if valid:
                    return
            
        line = [[False] * 9 for _ in range(9)]
        column = [[False] * 9 for _ in range(9)]
        block = [[[False] * 9 for _a in range(3)] for _b in range(3)]
        valid = False
        spaces = list()

        for i in range(9):
            for j in range(9):
                if board[i][j] == ".":
                    spaces.append((i, j))
                else:
                    digit = int(board[i][j]) - 1
                    line[i][digit] = column[j][digit] = block[i // 3][j // 3][digit] = True

        dfs(0)
```

```Golang [sol1-Golang]
func solveSudoku(board [][]byte) {
    var line, column [9][9]bool
    var block [3][3][9]bool
    var spaces [][2]int

    for i, row := range board {
        for j, b := range row {
            if b == '.' {
                spaces = append(spaces, [2]int{i, j})
            } else {
                digit := b - '1'
                line[i][digit] = true
                column[j][digit] = true
                block[i/3][j/3][digit] = true
            }
        }
    }

    var dfs func(int) bool
    dfs = func(pos int) bool {
        if pos == len(spaces) {
            return true
        }
        i, j := spaces[pos][0], spaces[pos][1]
        for digit := byte(0); digit < 9; digit++ {
            if !line[i][digit] && !column[j][digit] && !block[i/3][j/3][digit] {
                line[i][digit] = true
                column[j][digit] = true
                block[i/3][j/3][digit] = true
                board[i][j] = digit + '1'
                if dfs(pos + 1) {
                    return true
                }
                line[i][digit] = false
                column[j][digit] = false
                block[i/3][j/3][digit] = false
            }
        }
        return false
    }
    dfs(0)
}
```

```C [sol1-C]
bool line[9][9];
bool column[9][9];
bool block[3][3][9];
bool valid;
int* spaces[81];
int spacesSize;

void dfs(char** board, int pos) {
    if (pos == spacesSize) {
        valid = true;
        return;
    }

    int i = spaces[pos][0], j = spaces[pos][1];
    for (int digit = 0; digit < 9 && !valid; ++digit) {
        if (!line[i][digit] && !column[j][digit] && !block[i / 3][j / 3][digit]) {
            line[i][digit] = column[j][digit] = block[i / 3][j / 3][digit] = true;
            board[i][j] = digit + '0' + 1;
            dfs(board, pos + 1);
            line[i][digit] = column[j][digit] = block[i / 3][j / 3][digit] = false;
        }
    }
}

void solveSudoku(char** board, int boardSize, int* boardColSize) {
    memset(line, false, sizeof(line));
    memset(column, false, sizeof(column));
    memset(block, false, sizeof(block));
    valid = false;
    spacesSize = 0;

    for (int i = 0; i < 9; ++i) {
        for (int j = 0; j < 9; ++j) {
            if (board[i][j] == '.') {
                spaces[spacesSize] = malloc(sizeof(int) * 2);
                spaces[spacesSize][0] = i;
                spaces[spacesSize++][1] = j;
            } else {
                int digit = board[i][j] - '0' - 1;
                line[i][digit] = column[j][digit] = block[i / 3][j / 3][digit] = true;
            }
        }
    }

    dfs(board, 0);
}
```

#### 方法二：位运算优化

**思路与算法**

在方法一中，我们使用了长度为 $9$ 的数组表示每个数字是否出现过。我们同样也可以借助位运算，仅使用一个整数表示每个数字是否出现过。

具体地，数 $b$ 的二进制表示的第 $i$ 位（从低到高，最低位为第 $0$ 位）为 $1$，当且仅当数字 $i+1$ 已经出现过。例如当 $b$ 的二进制表示为 $(011000100)_2$ 时，就表示数字 $3$，$7$，$8$ 已经出现过。

位运算有一些基础的使用技巧。下面列举了所有在代码中使用到的技巧：

- 对于第 $i$ 行第 $j$ 列的位置，$\textit{line}[i] ~|~ \textit{column}[j] ~|~ \textit{block}[\lfloor i/3 \rfloor][\lfloor j/3 \rfloor]$ 中第 $k$ 位为 $1$，表示该位置不能填入数字 $k+1$（因为已经出现过），其中 $|$ 表示按位或运算。如果我们对这个值进行 $\sim$ 按位取反运算，那么第 $k$ 位为 $1$ 就表示该位置可以填入数字 $k+1$，我们就可以通过寻找 $1$ 来进行枚举。由于在进行按位取反运算后，这个数的高位也全部变成了 $1$，而这是我们不应当枚举到的，因此我们需要将这个数和 $(111111111)_2 = (\text{1FF})_{16}$ 进行按位与运算 $\&$，将所有无关的位置为 $0$；

- 我们可以使用按位异或运算 $\wedge$，将第 $i$ 位从 $0$ 变为 $1$，或从 $1$ 变为 $0$。具体地，与数 $1 << i$ 进行按位异或运算即可，其中 $<<$ 表示左移运算；

- 我们可以用 $b ~\&~ (-b)$ 得到 $b$ 二进制表示中最低位的 $1$，这是因为 $(-b)$ 在计算机中以补码的形式存储，它等于 $\sim b + 1$。$b$ 如果和 $\sim b$ 进行按位与运算，那么会得到 $0$，但是当 $\sim b$ 增加 $1$ 之后，最低位的连续的 $1$ 都变为 $0$，而最低位的 $0$ 变为 $1$，对应到 $b$ 中即为最低位的 $1$，因此当 $b$ 和 $\sim b + 1$ 进行按位与运算时，只有最低位的 $1$ 会被保留；

- 当我们得到这个最低位的 $1$ 时，我们可以通过一些语言自带的函数得到这个最低位的 $1$ 究竟是第几位（即 $i$ 值），具体可以参考下面的代码；

- 我们可以用 $b$ 和最低位的 $1$ 进行按位异或运算，就可以将其从 $b$ 中去除，这样就可以枚举下一个 $1$。同样地，我们也可以用 $b$ 和 $b-1$ 进行按位与运算达到相同的效果，读者可以自行尝试推导。

实际上，方法二中整体的递归 + 回溯的框架与方法一是一致的。不同的仅仅是我们将一个数组「压缩」成了一个数而已。

**代码**

```C++ [sol2-C++]
class Solution {
private:
    int line[9];
    int column[9];
    int block[3][3];
    bool valid;
    vector<pair<int, int>> spaces;

public:
    void flip(int i, int j, int digit) {
        line[i] ^= (1 << digit);
        column[j] ^= (1 << digit);
        block[i / 3][j / 3] ^= (1 << digit);
    }

    void dfs(vector<vector<char>>& board, int pos) {
        if (pos == spaces.size()) {
            valid = true;
            return;
        }

        auto [i, j] = spaces[pos];
        int mask = ~(line[i] | column[j] | block[i / 3][j / 3]) & 0x1ff;
        for (; mask && !valid; mask &= (mask - 1)) {
            int digitMask = mask & (-mask);
            int digit = __builtin_ctz(digitMask);
            flip(i, j, digit);
            board[i][j] = digit + '0' + 1;
            dfs(board, pos + 1);
            flip(i, j, digit);
        }
    }

    void solveSudoku(vector<vector<char>>& board) {
        memset(line, 0, sizeof(line));
        memset(column, 0, sizeof(column));
        memset(block, 0, sizeof(block));
        valid = false;

        for (int i = 0; i < 9; ++i) {
            for (int j = 0; j < 9; ++j) {
                if (board[i][j] == '.') {
                    spaces.emplace_back(i, j);
                }
                else {
                    int digit = board[i][j] - '0' - 1;
                    flip(i, j, digit);
                }
            }
        }

        dfs(board, 0);
    }
};
```

```Java [sol2-Java]
class Solution {
    private int[] line = new int[9];
    private int[] column = new int[9];
    private int[][] block = new int[3][3];
    private boolean valid = false;
    private List<int[]> spaces = new ArrayList<int[]>();

    public void solveSudoku(char[][] board) {
        for (int i = 0; i < 9; ++i) {
            for (int j = 0; j < 9; ++j) {
                if (board[i][j] == '.') {
                    spaces.add(new int[]{i, j});
                } else {
                    int digit = board[i][j] - '0' - 1;
                    flip(i, j, digit);
                }
            }
        }

        dfs(board, 0);
    }

    public void dfs(char[][] board, int pos) {
        if (pos == spaces.size()) {
            valid = true;
            return;
        }

        int[] space = spaces.get(pos);
        int i = space[0], j = space[1];
        int mask = ~(line[i] | column[j] | block[i / 3][j / 3]) & 0x1ff;
        for (; mask != 0 && !valid; mask &= (mask - 1)) {
            int digitMask = mask & (-mask);
            int digit = Integer.bitCount(digitMask - 1);
            flip(i, j, digit);
            board[i][j] = (char) (digit + '0' + 1);
            dfs(board, pos + 1);
            flip(i, j, digit);
        }
    }

    public void flip(int i, int j, int digit) {
        line[i] ^= (1 << digit);
        column[j] ^= (1 << digit);
        block[i / 3][j / 3] ^= (1 << digit);
    }
}
```

```Python [sol2-Python3]
class Solution:
    def solveSudoku(self, board: List[List[str]]) -> None:
        def flip(i: int, j: int, digit: int):
            line[i] ^= (1 << digit)
            column[j] ^= (1 << digit)
            block[i // 3][j // 3] ^= (1 << digit)

        def dfs(pos: int):
            nonlocal valid
            if pos == len(spaces):
                valid = True
                return
            
            i, j = spaces[pos]
            mask = ~(line[i] | column[j] | block[i // 3][j // 3]) & 0x1ff
            while mask:
                digitMask = mask & (-mask)
                digit = bin(digitMask).count("0") - 1
                flip(i, j, digit)
                board[i][j] = str(digit + 1)
                dfs(pos + 1)
                flip(i, j, digit)
                mask &= (mask - 1)
                if valid:
                    return
            
        line = [0] * 9
        column = [0] * 9
        block = [[0] * 3 for _ in range(3)]
        valid = False
        spaces = list()

        for i in range(9):
            for j in range(9):
                if board[i][j] == ".":
                    spaces.append((i, j))
                else:
                    digit = int(board[i][j]) - 1
                    flip(i, j, digit)

        dfs(0)
```

```Golang [sol2-Golang]
func solveSudoku(board [][]byte) {
    var line, column [9]int
    var block [3][3]int
    var spaces [][2]int

    flip := func(i, j int, digit byte) {
        line[i] ^= 1 << digit
        column[j] ^= 1 << digit
        block[i/3][j/3] ^= 1 << digit
    }

    for i, row := range board {
        for j, b := range row {
            if b == '.' {
                spaces = append(spaces, [2]int{i, j})
            } else {
                digit := b - '1'
                flip(i, j, digit)
            }
        }
    }

    var dfs func(int) bool
    dfs = func(pos int) bool {
        if pos == len(spaces) {
            return true
        }
        i, j := spaces[pos][0], spaces[pos][1]
        mask := 0x1ff &^ uint(line[i]|column[j]|block[i/3][j/3]) // 0x1ff 即二进制的 9 个 1
        for ; mask > 0; mask &= mask - 1 { // 最右侧的 1 置为 0
            digit := byte(bits.TrailingZeros(mask))
            flip(i, j, digit)
            board[i][j] = digit + '1'
            if dfs(pos + 1) {
                return true
            }
            flip(i, j, digit)
        }
        return false
    }
    dfs(0)
}
```

```C [sol2-C]
int line[9];
int column[9];
int block[3][3];
bool valid;
int* spaces[81];
int spacesSize;

void flip(int i, int j, int digit) {
    line[i] ^= (1 << digit);
    column[j] ^= (1 << digit);
    block[i / 3][j / 3] ^= (1 << digit);
}

void dfs(char** board, int pos) {
    if (pos == spacesSize) {
        valid = true;
        return;
    }

    int i = spaces[pos][0], j = spaces[pos][1];
    int mask = ~(line[i] | column[j] | block[i / 3][j / 3]) & 0x1ff;
    for (; mask && !valid; mask &= (mask - 1)) {
        int digitMask = mask & (-mask);
        int digit = __builtin_ctz(digitMask);
        flip(i, j, digit);
        board[i][j] = digit + '0' + 1;
        dfs(board, pos + 1);
        flip(i, j, digit);
    }
}

void solveSudoku(char** board, int boardSize, int* boardColSize) {
    memset(line, 0, sizeof(line));
    memset(column, 0, sizeof(column));
    memset(block, 0, sizeof(block));
    valid = false;
    spacesSize = 0;

    for (int i = 0; i < 9; ++i) {
        for (int j = 0; j < 9; ++j) {
            if (board[i][j] == '.') {
                spaces[spacesSize] = malloc(sizeof(int) * 2);
                spaces[spacesSize][0] = i;
                spaces[spacesSize++][1] = j;
            } else {
                int digit = board[i][j] - '0' - 1;
                flip(i, j, digit);
            }
        }
    }

    dfs(board, 0);
}
```

#### 方法三：枚举优化

**思路与算法**

我们可以顺着方法二的思路继续优化下去：

- 如果一个空白格只有唯一的数可以填入，也就是其对应的 $b$ 值和 $b-1$ 进行按位与运算后得到 $0$（即 $b$ 中只有一个二进制位为 $1$）。此时，我们就可以确定这个空白格填入的数，而不用等到递归时再去处理它。

这样一来，我们可以不断地对整个数独进行遍历，将可以唯一确定的空白格全部填入对应的数。随后我们再使用与方法二相同的方法对剩余无法唯一确定的空白格进行递归 + 回溯。

**代码**

```C++ [sol3-C++]
class Solution {
private:
    int line[9];
    int column[9];
    int block[3][3];
    bool valid;
    vector<pair<int, int>> spaces;

public:
    void flip(int i, int j, int digit) {
        line[i] ^= (1 << digit);
        column[j] ^= (1 << digit);
        block[i / 3][j / 3] ^= (1 << digit);
    }

    void dfs(vector<vector<char>>& board, int pos) {
        if (pos == spaces.size()) {
            valid = true;
            return;
        }

        auto [i, j] = spaces[pos];
        int mask = ~(line[i] | column[j] | block[i / 3][j / 3]) & 0x1ff;
        for (; mask && !valid; mask &= (mask - 1)) {
            int digitMask = mask & (-mask);
            int digit = __builtin_ctz(digitMask);
            flip(i, j, digit);
            board[i][j] = digit + '0' + 1;
            dfs(board, pos + 1);
            flip(i, j, digit);
        }
    }

    void solveSudoku(vector<vector<char>>& board) {
        memset(line, 0, sizeof(line));
        memset(column, 0, sizeof(column));
        memset(block, 0, sizeof(block));
        valid = false;

        for (int i = 0; i < 9; ++i) {
            for (int j = 0; j < 9; ++j) {
                if (board[i][j] != '.') {
                    int digit = board[i][j] - '0' - 1;
                    flip(i, j, digit);
                }
            }
        }

        while (true) {
            int modified = false;
            for (int i = 0; i < 9; ++i) {
                for (int j = 0; j < 9; ++j) {
                    if (board[i][j] == '.') {
                        int mask = ~(line[i] | column[j] | block[i / 3][j / 3]) & 0x1ff;
                        if (!(mask & (mask - 1))) {
                            int digit = __builtin_ctz(mask);
                            flip(i, j, digit);
                            board[i][j] = digit + '0' + 1;
                            modified = true;
                        }
                    }
                }
            }
            if (!modified) {
                break;
            }
        }

        for (int i = 0; i < 9; ++i) {
            for (int j = 0; j < 9; ++j) {
                if (board[i][j] == '.') {
                    spaces.emplace_back(i, j);
                }
            }
        }

        dfs(board, 0);
    }
};
```

```Java [sol3-Java]
class Solution {
    private int[] line = new int[9];
    private int[] column = new int[9];
    private int[][] block = new int[3][3];
    private boolean valid = false;
    private List<int[]> spaces = new ArrayList<int[]>();

    public void solveSudoku(char[][] board) {
        for (int i = 0; i < 9; ++i) {
            for (int j = 0; j < 9; ++j) {
                if (board[i][j] != '.') {
                    int digit = board[i][j] - '0' - 1;
                    flip(i, j, digit);
                }
            }
        }

        while (true) {
            boolean modified = false;
            for (int i = 0; i < 9; ++i) {
                for (int j = 0; j < 9; ++j) {
                    if (board[i][j] == '.') {
                        int mask = ~(line[i] | column[j] | block[i / 3][j / 3]) & 0x1ff;
                        if ((mask & (mask - 1)) == 0) {
                            int digit = Integer.bitCount(mask - 1);
                            flip(i, j, digit);
                            board[i][j] = (char) (digit + '0' + 1);
                            modified = true;
                        }
                    }
                }
            }
            if (!modified) {
                break;
            }
        }

        for (int i = 0; i < 9; ++i) {
            for (int j = 0; j < 9; ++j) {
                if (board[i][j] == '.') {
                    spaces.add(new int[]{i, j});
                }
            }
        }

        dfs(board, 0);
    }

    public void dfs(char[][] board, int pos) {
        if (pos == spaces.size()) {
            valid = true;
            return;
        }

        int[] space = spaces.get(pos);
        int i = space[0], j = space[1];
        int mask = ~(line[i] | column[j] | block[i / 3][j / 3]) & 0x1ff;
        for (; mask != 0 && !valid; mask &= (mask - 1)) {
            int digitMask = mask & (-mask);
            int digit = Integer.bitCount(digitMask - 1);
            flip(i, j, digit);
            board[i][j] = (char) (digit + '0' + 1);
            dfs(board, pos + 1);
            flip(i, j, digit);
        }
    }

    public void flip(int i, int j, int digit) {
        line[i] ^= (1 << digit);
        column[j] ^= (1 << digit);
        block[i / 3][j / 3] ^= (1 << digit);
    }
}
```

```Python [sol3-Python3]
class Solution:
    def solveSudoku(self, board: List[List[str]]) -> None:
        def flip(i: int, j: int, digit: int):
            line[i] ^= (1 << digit)
            column[j] ^= (1 << digit)
            block[i // 3][j // 3] ^= (1 << digit)

        def dfs(pos: int):
            nonlocal valid
            if pos == len(spaces):
                valid = True
                return
            
            i, j = spaces[pos]
            mask = ~(line[i] | column[j] | block[i // 3][j // 3]) & 0x1ff
            while mask:
                digitMask = mask & (-mask)
                digit = bin(digitMask).count("0") - 1
                flip(i, j, digit)
                board[i][j] = str(digit + 1)
                dfs(pos + 1)
                flip(i, j, digit)
                mask &= (mask - 1)
                if valid:
                    return
            
        line = [0] * 9
        column = [0] * 9
        block = [[0] * 3 for _ in range(3)]
        valid = False
        spaces = list()

        for i in range(9):
            for j in range(9):
                if board[i][j] != ".":
                    digit = int(board[i][j]) - 1
                    flip(i, j, digit)
        
        while True:
            modified = False
            for i in range(9):
                for j in range(9):
                    if board[i][j] == ".":
                        mask = ~(line[i] | column[j] | block[i // 3][j // 3]) & 0x1ff
                        if not (mask & (mask - 1)):
                            digit = bin(mask).count("0") - 1
                            flip(i, j, digit)
                            board[i][j] = str(digit + 1)
                            modified = True
            if not modified:
                break
        
        for i in range(9):
            for j in range(9):
                if board[i][j] == ".":
                    spaces.append((i, j))

        dfs(0)
```

```Golang [sol3-Golang]
func solveSudoku(board [][]byte) {
    var line, column [9]int
    var block [3][3]int
    var spaces [][2]int

    flip := func(i, j int, digit byte) {
        line[i] ^= 1 << digit
        column[j] ^= 1 << digit
        block[i/3][j/3] ^= 1 << digit
    }

    for i, row := range board {
        for j, b := range row {
            if b != '.' {
                digit := b - '1'
                flip(i, j, digit)
            }
        }
    }

    for {
        modified := false
        for i, row := range board {
            for j, b := range row {
                if b != '.' {
                    continue
                }
                mask := 0x1ff &^ uint(line[i]|column[j]|block[i/3][j/3])
                if mask&(mask-1) == 0 { // mask 的二进制表示仅有一个 1
                    digit := byte(bits.TrailingZeros(mask))
                    flip(i, j, digit)
                    board[i][j] = digit + '1'
                    modified = true
                }
            }
        }
        if !modified {
            break
        }
    }

    for i, row := range board {
        for j, b := range row {
            if b == '.' {
                spaces = append(spaces, [2]int{i, j})
            }
        }
    }

    var dfs func(int) bool
    dfs = func(pos int) bool {
        if pos == len(spaces) {
            return true
        }
        i, j := spaces[pos][0], spaces[pos][1]
        mask := 0x1ff &^ uint(line[i]|column[j]|block[i/3][j/3]) // 0x1ff 即二进制的 9 个 1
        for ; mask > 0; mask &= mask - 1 { // 最右侧的 1 置为 0
            digit := byte(bits.TrailingZeros(mask))
            flip(i, j, digit)
            board[i][j] = digit + '1'
            if dfs(pos + 1) {
                return true
            }
            flip(i, j, digit)
        }
        return false
    }
    dfs(0)
}
```

```C [sol3-C]
int line[9];
int column[9];
int block[3][3];
bool valid;
int* spaces[81];
int spacesSize;

void flip(int i, int j, int digit) {
    line[i] ^= (1 << digit);
    column[j] ^= (1 << digit);
    block[i / 3][j / 3] ^= (1 << digit);
}

void dfs(char** board, int pos) {
    if (pos == spacesSize) {
        valid = true;
        return;
    }

    int i = spaces[pos][0], j = spaces[pos][1];
    int mask = ~(line[i] | column[j] | block[i / 3][j / 3]) & 0x1ff;
    for (; mask && !valid; mask &= (mask - 1)) {
        int digitMask = mask & (-mask);
        int digit = __builtin_ctz(digitMask);
        flip(i, j, digit);
        board[i][j] = digit + '0' + 1;
        dfs(board, pos + 1);
        flip(i, j, digit);
    }
}

void solveSudoku(char** board, int boardSize, int* boardColSize) {
    memset(line, 0, sizeof(line));
    memset(column, 0, sizeof(column));
    memset(block, 0, sizeof(block));
    valid = false;
    spacesSize = 0;

    for (int i = 0; i < 9; ++i) {
        for (int j = 0; j < 9; ++j) {
            if (board[i][j] != '.') {
                int digit = board[i][j] - '0' - 1;
                flip(i, j, digit);
            }
        }
    }

    while (true) {
        int modified = false;
        for (int i = 0; i < 9; ++i) {
            for (int j = 0; j < 9; ++j) {
                if (board[i][j] == '.') {
                    int mask = ~(line[i] | column[j] | block[i / 3][j / 3]) & 0x1ff;
                    if (!(mask & (mask - 1))) {
                        int digit = __builtin_ctz(mask);
                        flip(i, j, digit);
                        board[i][j] = digit + '0' + 1;
                        modified = true;
                    }
                }
            }
        }
        if (!modified) {
            break;
        }
    }

    for (int i = 0; i < 9; ++i) {
        for (int j = 0; j < 9; ++j) {
            if (board[i][j] == '.') {
                spaces[spacesSize] = malloc(sizeof(int) * 2);
                spaces[spacesSize][0] = i;
                spaces[spacesSize++][1] = j;
            }
        }
    }

    dfs(board, 0);
}
```
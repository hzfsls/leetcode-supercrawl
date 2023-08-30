#### 前言

「$N$ 皇后问题」研究的是如何将 $N$ 个皇后放置在 $N \times N$ 的棋盘上，并且使皇后彼此之间不能相互攻击。

皇后的走法是：可以横直斜走，格数不限。因此要求皇后彼此之间不能相互攻击，等价于要求任何两个皇后都不能在同一行、同一列以及同一条斜线上。

直观的做法是暴力枚举将 $N$ 个皇后放置在 $N \times N$ 的棋盘上的所有可能的情况，并对每一种情况判断是否满足皇后彼此之间不相互攻击。暴力枚举的时间复杂度是非常高的，因此必须利用限制条件加以优化。

显然，每个皇后必须位于不同行和不同列，因此将 $N$ 个皇后放置在 $N \times N$ 的棋盘上，一定是每一行有且仅有一个皇后，每一列有且仅有一个皇后，且任何两个皇后都不能在同一条斜线上。基于上述发现，可以通过回溯的方式寻找可能的解。

回溯的具体做法是：使用一个数组记录每行放置的皇后的列下标，依次在每一行放置一个皇后。每次新放置的皇后都不能和已经放置的皇后之间有攻击：即新放置的皇后不能和任何一个已经放置的皇后在同一列以及同一条斜线上，并更新数组中的当前行的皇后列下标。当 $N$ 个皇后都放置完毕，则找到一个可能的解。当找到一个可能的解之后，将数组转换成表示棋盘状态的列表，并将该棋盘状态的列表加入返回列表。

由于每个皇后必须位于不同列，因此已经放置的皇后所在的列不能放置别的皇后。第一个皇后有 $N$ 列可以选择，第二个皇后最多有 $N-1$ 列可以选择，第三个皇后最多有 $N-2$ 列可以选择（如果考虑到不能在同一条斜线上，可能的选择数量更少），因此所有可能的情况不会超过 $N!$ 种，遍历这些情况的时间复杂度是 $O(N!)$。

为了降低总时间复杂度，每次放置皇后时需要快速判断每个位置是否可以放置皇后，显然，最理想的情况是在 $O(1)$ 的时间内判断该位置所在的列和两条斜线上是否已经有皇后。

以下两种方法分别使用集合和位运算对皇后的放置位置进行判断，都可以在 $O(1)$ 的时间内判断一个位置是否可以放置皇后，算法的总时间复杂度都是 $O(N!)$。

#### 方法一：基于集合的回溯

为了判断一个位置所在的列和两条斜线上是否已经有皇后，使用三个集合 $\textit{columns}$、$\textit{diagonals}_1$ 和 $\textit{diagonals}_2$ 分别记录每一列以及两个方向的每条斜线上是否有皇后。

列的表示法很直观，一共有 $N$ 列，每一列的下标范围从 $0$ 到 $N-1$，使用列的下标即可明确表示每一列。

如何表示两个方向的斜线呢？对于每个方向的斜线，需要找到斜线上的每个位置的行下标与列下标之间的关系。

方向一的斜线为从左上到右下方向，同一条斜线上的每个位置满足**行下标与列下标之差相等**，例如 $(0,0)$ 和 $(3,3)$ 在同一条方向一的斜线上。因此使用行下标与列下标之差即可明确表示每一条方向一的斜线。

![fig1](https://assets.leetcode-cn.com/solution-static/51/1.png)

方向二的斜线为从右上到左下方向，同一条斜线上的每个位置满足**行下标与列下标之和相等**，例如 $(3,0)$ 和 $(1,2)$ 在同一条方向二的斜线上。因此使用行下标与列下标之和即可明确表示每一条方向二的斜线。

![fig2](https://assets.leetcode-cn.com/solution-static/51/2.png)

每次放置皇后时，对于每个位置判断其是否在三个集合中，如果三个集合都不包含当前位置，则当前位置是可以放置皇后的位置。

```Java [sol1-Java]
class Solution {
    public List<List<String>> solveNQueens(int n) {
        List<List<String>> solutions = new ArrayList<List<String>>();
        int[] queens = new int[n];
        Arrays.fill(queens, -1);
        Set<Integer> columns = new HashSet<Integer>();
        Set<Integer> diagonals1 = new HashSet<Integer>();
        Set<Integer> diagonals2 = new HashSet<Integer>();
        backtrack(solutions, queens, n, 0, columns, diagonals1, diagonals2);
        return solutions;
    }

    public void backtrack(List<List<String>> solutions, int[] queens, int n, int row, Set<Integer> columns, Set<Integer> diagonals1, Set<Integer> diagonals2) {
        if (row == n) {
            List<String> board = generateBoard(queens, n);
            solutions.add(board);
        } else {
            for (int i = 0; i < n; i++) {
                if (columns.contains(i)) {
                    continue;
                }
                int diagonal1 = row - i;
                if (diagonals1.contains(diagonal1)) {
                    continue;
                }
                int diagonal2 = row + i;
                if (diagonals2.contains(diagonal2)) {
                    continue;
                }
                queens[row] = i;
                columns.add(i);
                diagonals1.add(diagonal1);
                diagonals2.add(diagonal2);
                backtrack(solutions, queens, n, row + 1, columns, diagonals1, diagonals2);
                queens[row] = -1;
                columns.remove(i);
                diagonals1.remove(diagonal1);
                diagonals2.remove(diagonal2);
            }
        }
    }

    public List<String> generateBoard(int[] queens, int n) {
        List<String> board = new ArrayList<String>();
        for (int i = 0; i < n; i++) {
            char[] row = new char[n];
            Arrays.fill(row, '.');
            row[queens[i]] = 'Q';
            board.add(new String(row));
        }
        return board;
    }
}
```

```cpp [sol1-C++]
class Solution {
public:
    vector<vector<string>> solveNQueens(int n) {
        auto solutions = vector<vector<string>>();
        auto queens = vector<int>(n, -1);
        auto columns = unordered_set<int>();
        auto diagonals1 = unordered_set<int>();
        auto diagonals2 = unordered_set<int>();
        backtrack(solutions, queens, n, 0, columns, diagonals1, diagonals2);
        return solutions;
    }

    void backtrack(vector<vector<string>> &solutions, vector<int> &queens, int n, int row, unordered_set<int> &columns, unordered_set<int> &diagonals1, unordered_set<int> &diagonals2) {
        if (row == n) {
            vector<string> board = generateBoard(queens, n);
            solutions.push_back(board);
        } else {
            for (int i = 0; i < n; i++) {
                if (columns.find(i) != columns.end()) {
                    continue;
                }
                int diagonal1 = row - i;
                if (diagonals1.find(diagonal1) != diagonals1.end()) {
                    continue;
                }
                int diagonal2 = row + i;
                if (diagonals2.find(diagonal2) != diagonals2.end()) {
                    continue;
                }
                queens[row] = i;
                columns.insert(i);
                diagonals1.insert(diagonal1);
                diagonals2.insert(diagonal2);
                backtrack(solutions, queens, n, row + 1, columns, diagonals1, diagonals2);
                queens[row] = -1;
                columns.erase(i);
                diagonals1.erase(diagonal1);
                diagonals2.erase(diagonal2);
            }
        }
    }

    vector<string> generateBoard(vector<int> &queens, int n) {
        auto board = vector<string>();
        for (int i = 0; i < n; i++) {
            string row = string(n, '.');
            row[queens[i]] = 'Q';
            board.push_back(row);
        }
        return board;
    }
};
```

```golang [sol1-Golang]
var solutions [][]string

func solveNQueens(n int) [][]string {
    solutions = [][]string{}
    queens := make([]int, n)
    for i := 0; i < n; i++ {
        queens[i] = -1
    }
    columns := map[int]bool{}
    diagonals1, diagonals2 := map[int]bool{}, map[int]bool{}
    backtrack(queens, n, 0, columns, diagonals1, diagonals2)
    return solutions
}

func backtrack(queens []int, n, row int, columns, diagonals1, diagonals2 map[int]bool) {
    if row == n {
        board := generateBoard(queens, n)
        solutions = append(solutions, board)
        return
    }
    for i := 0; i < n; i++ {
        if columns[i] {
            continue
        }
        diagonal1 := row - i
        if diagonals1[diagonal1] {
            continue
        }
        diagonal2 := row + i
        if diagonals2[diagonal2] {
            continue
        }
        queens[row] = i
        columns[i] = true
        diagonals1[diagonal1], diagonals2[diagonal2] = true, true
        backtrack(queens, n, row + 1, columns, diagonals1, diagonals2)
        queens[row] = -1
        delete(columns, i)
        delete(diagonals1, diagonal1)
        delete(diagonals2, diagonal2)
    }
}

func generateBoard(queens []int, n int) []string {
    board := []string{}
    for i := 0; i < n; i++ {
        row := make([]byte, n)
        for j := 0; j < n; j++ {
            row[j] = '.'
        }
        row[queens[i]] = 'Q'
        board = append(board, string(row))
    }
    return board
}
```

```Python [sol1-Python3]
class Solution:
    def solveNQueens(self, n: int) -> List[List[str]]:
        def generateBoard():
            board = list()
            for i in range(n):
                row[queens[i]] = "Q"
                board.append("".join(row))
                row[queens[i]] = "."
            return board

        def backtrack(row: int):
            if row == n:
                board = generateBoard()
                solutions.append(board)
            else:
                for i in range(n):
                    if i in columns or row - i in diagonal1 or row + i in diagonal2:
                        continue
                    queens[row] = i
                    columns.add(i)
                    diagonal1.add(row - i)
                    diagonal2.add(row + i)
                    backtrack(row + 1)
                    columns.remove(i)
                    diagonal1.remove(row - i)
                    diagonal2.remove(row + i)
                    
        solutions = list()
        queens = [-1] * n
        columns = set()
        diagonal1 = set()
        diagonal2 = set()
        row = ["."] * n
        backtrack(0)
        return solutions
```

```C [sol1-C]
int solutionsSize;

char** generateBoard(int* queens, int n) {
    char** board = (char**)malloc(sizeof(char*) * n);
    for (int i = 0; i < n; i++) {
        board[i] = (char*)malloc(sizeof(char) * (n + 1));
        for (int j = 0; j < n; j++) board[i][j] = '.';
        board[i][queens[i]] = 'Q', board[i][n] = 0;
    }
    return board;
}

void backtrack(char*** solutions, int* queens, int n, int row, int* columns, int* diagonals1, int* diagonals2) {
    if (row == n) {
        char** board = generateBoard(queens, n);
        solutions[solutionsSize++] = board;
    } else {
        for (int i = 0; i < n; i++) {
            if (columns[i]) {
                continue;
            }
            int diagonal1 = row - i + n - 1;
            if (diagonals1[diagonal1]) {
                continue;
            }
            int diagonal2 = row + i;
            if (diagonals2[diagonal2]) {
                continue;
            }
            queens[row] = i;
            columns[i] = true;
            diagonals1[diagonal1] = true;
            diagonals2[diagonal2] = true;
            backtrack(solutions, queens, n, row + 1, columns, diagonals1, diagonals2);
            queens[row] = -1;
            columns[i] = false;
            diagonals1[diagonal1] = false;
            diagonals2[diagonal2] = false;
        }
    }
}

char*** solveNQueens(int n, int* returnSize, int** returnColumnSizes) {
    char*** solutions = malloc(sizeof(char**) * 501);
    solutionsSize = 0;
    int queens[n];
    int columns[n];
    int diagonals1[n + n];
    int diagonals2[n + n];
    memset(queens, -1, sizeof(queens));
    memset(columns, 0, sizeof(columns));
    memset(diagonals1, 0, sizeof(diagonals1));
    memset(diagonals2, 0, sizeof(diagonals2));
    backtrack(solutions, queens, n, 0, columns, diagonals1, diagonals2);
    *returnSize = solutionsSize;
    *returnColumnSizes = malloc(sizeof(int*) * solutionsSize);
    for (int i = 0; i < solutionsSize; i++) {
        (*returnColumnSizes)[i] = n;
    }
    return solutions;
}
```

**复杂度分析**

- 时间复杂度：$O(N!)$，其中 $N$ 是皇后数量。

- 空间复杂度：$O(N)$，其中 $N$ 是皇后数量。空间复杂度主要取决于递归调用层数、记录每行放置的皇后的列下标的数组以及三个集合，递归调用层数不会超过 $N$，数组的长度为 $N$，每个集合的元素个数都不会超过 $N$。

#### 方法二：基于位运算的回溯

方法一使用三个集合记录分别记录每一列以及两个方向的每条斜线上是否有皇后，每个集合最多包含 $N$ 个元素，因此集合的空间复杂度是 $O(N)$。如果利用位运算记录皇后的信息，就可以将记录皇后信息的空间复杂度从 $O(N)$ 降到 $O(1)$。

具体做法是，使用三个整数 $\textit{columns}$、$\textit{diagonals}_1$ 和 $\textit{diagonals}_2$ 分别记录每一列以及两个方向的每条斜线上是否有皇后，每个整数有 $N$ 个二进制位。棋盘的每一列对应每个整数的二进制表示中的一个数位，其中棋盘的最左列对应每个整数的最低二进制位，最右列对应每个整数的最高二进制位。

那么如何根据每次放置的皇后更新三个整数的值呢？在说具体的计算方法之前，首先说一个例子。

棋盘的边长和皇后的数量 $N=8$。如果棋盘的前两行分别在第 $2$ 列和第 $4$ 列放置了皇后（下标从 $0$ 开始），则棋盘的前两行如下图所示。

![fig3](https://assets.leetcode-cn.com/solution-static/51/3.png){:width="65%"}

如果要在下一行放置皇后，哪些位置不能放置呢？我们用 $0$ 代表可以放置皇后的位置，$1$ 代表不能放置皇后的位置。

新放置的皇后不能和任何一个已经放置的皇后在同一列，因此不能放置在第 $2$ 列和第 $4$ 列，对应 $\textit{columns}=00010100_{(2)}$。

新放置的皇后不能和任何一个已经放置的皇后在同一条方向一（从左上到右下方向）的斜线上，因此不能放置在第 $4$ 列和第 $5$ 列，对应 $\textit{diagonals}_1=00110000_{(2)}$。其中，第 $4$ 列为其前两行的第 $2$ 列的皇后往右下移动两步的位置，第 $5$ 列为其前一行的第 $4$ 列的皇后往右下移动一步的位置。

新放置的皇后不能和任何一个已经放置的皇后在同一条方向二（从右上到左下方向）的斜线上，因此不能放置在第 $0$ 列和第 $3$ 列，对应 $\textit{diagonals}_2=00001001_{(2)}$。其中，第 $0$ 列为其前两行的第 $2$ 列的皇后往左下移动两步的位置，第 $3$ 列为其前一行的第 $4$ 列的皇后往左下移动一步的位置。

![fig4](https://assets.leetcode-cn.com/solution-static/51/4.png){:width="92%"}

由此可以得到三个整数的计算方法：

- 初始时，三个整数的值都等于 $0$，表示没有放置任何皇后；

- 在当前行放置皇后，如果皇后放置在第 $i$ 列，则将三个整数的第 $i$ 个二进制位（指从低到高的第 $i$ 个二进制位）的值设为 $1$；

- 进入下一行时，$\textit{columns}$ 的值保持不变，$\textit{diagonals}_1$ 左移一位，$\textit{diagonals}_2$ 右移一位，由于棋盘的最左列对应每个整数的最低二进制位，即每个整数的最右二进制位，因此对整数的移位操作方向和对棋盘的移位操作方向相反（对棋盘的移位操作方向是 $\textit{diagonals}_1$ 右移一位，$\textit{diagonals}_2$ 左移一位）。

<![ppt1](https://assets.leetcode-cn.com/solution-static/51/2_1.png),![ppt2](https://assets.leetcode-cn.com/solution-static/51/2_2.png),![ppt3](https://assets.leetcode-cn.com/solution-static/51/2_3.png),![ppt4](https://assets.leetcode-cn.com/solution-static/51/2_4.png),![ppt5](https://assets.leetcode-cn.com/solution-static/51/2_5.png),![ppt6](https://assets.leetcode-cn.com/solution-static/51/2_6.png)>

每次放置皇后时，三个整数的按位或运算的结果即为不能放置皇后的位置，其余位置即为可以放置皇后的位置。可以通过 $(2^n-1)~\&~(\sim(\textit{columns} | \textit{diagonals}_1 | \textit{diagonals}_2))$ 得到可以放置皇后的位置（该结果的值为 $1$ 的位置表示可以放置皇后的位置），然后遍历这些位置，尝试放置皇后并得到可能的解。

遍历可以放置皇后的位置时，可以利用以下两个按位与运算的性质：

- $x~\&~(-x)$ 可以获得 $x$ 的二进制表示中的最低位的 $1$ 的位置；

- $x~\&~(x-1)$ 可以将 $x$ 的二进制表示中的最低位的 $1$ 置成 $0$。

具体做法是，每次获得可以放置皇后的位置中的最低位，并将该位的值置成 $0$，尝试在该位置放置皇后。这样即可遍历每个可以放置皇后的位置。

```Java [sol2-Java]
class Solution {
    public List<List<String>> solveNQueens(int n) {
        int[] queens = new int[n];
        Arrays.fill(queens, -1);
        List<List<String>> solutions = new ArrayList<List<String>>();
        solve(solutions, queens, n, 0, 0, 0, 0);
        return solutions;
    }

    public void solve(List<List<String>> solutions, int[] queens, int n, int row, int columns, int diagonals1, int diagonals2) {
        if (row == n) {
            List<String> board = generateBoard(queens, n);
            solutions.add(board);
        } else {
            int availablePositions = ((1 << n) - 1) & (~(columns | diagonals1 | diagonals2));
            while (availablePositions != 0) {
                int position = availablePositions & (-availablePositions);
                availablePositions = availablePositions & (availablePositions - 1);
                int column = Integer.bitCount(position - 1);
                queens[row] = column;
                solve(solutions, queens, n, row + 1, columns | position, (diagonals1 | position) << 1, (diagonals2 | position) >> 1);
                queens[row] = -1;
            }
        }
    }

    public List<String> generateBoard(int[] queens, int n) {
        List<String> board = new ArrayList<String>();
        for (int i = 0; i < n; i++) {
            char[] row = new char[n];
            Arrays.fill(row, '.');
            row[queens[i]] = 'Q';
            board.add(new String(row));
        }
        return board;
    }
}
```

```cpp [sol2-C++]
class Solution {
public:
    vector<vector<string>> solveNQueens(int n) {
        auto solutions = vector<vector<string>>();
        auto queens = vector<int>(n, -1);
        solve(solutions, queens, n, 0, 0, 0, 0);
        return solutions;
    }

    void solve(vector<vector<string>> &solutions, vector<int> &queens, int n, int row, int columns, int diagonals1, int diagonals2) {
        if (row == n) {
            auto board = generateBoard(queens, n);
            solutions.push_back(board);
        } else {
            int availablePositions = ((1 << n) - 1) & (~(columns | diagonals1 | diagonals2));
            while (availablePositions != 0) {
                int position = availablePositions & (-availablePositions);
                availablePositions = availablePositions & (availablePositions - 1);
                int column = __builtin_ctz(position);
                queens[row] = column;
                solve(solutions, queens, n, row + 1, columns | position, (diagonals1 | position) >> 1, (diagonals2 | position) << 1);
                queens[row] = -1;
            }
        }
    }

    vector<string> generateBoard(vector<int> &queens, int n) {
        auto board = vector<string>();
        for (int i = 0; i < n; i++) {
            string row = string(n, '.');
            row[queens[i]] = 'Q';
            board.push_back(row);
        }
        return board;
    }
};
```

```golang [sol2-Golang]
var solutions [][]string

func solveNQueens(n int) [][]string {
    solutions = [][]string{}
    queens := make([]int, n)
    for i := 0; i < n; i++ {
        queens[i] = -1
    }
    solve(queens, n, 0, 0, 0, 0)
    return solutions
}

func solve(queens []int, n, row, columns, diagonals1, diagonals2 int) {
    if row == n {
        board := generateBoard(queens, n)
        solutions = append(solutions, board)
        return
    }
    availablePositions := ((1 << n) - 1) & (^(columns | diagonals1 | diagonals2))
    for availablePositions != 0 {
        position := availablePositions & (-availablePositions)
        availablePositions = availablePositions & (availablePositions - 1)
        column := bits.OnesCount(uint(position - 1))
        queens[row] = column
        solve(queens, n, row + 1, columns | position, (diagonals1 | position) >> 1, (diagonals2 | position) << 1)
        queens[row] = -1
    }
}

func generateBoard(queens []int, n int) []string {
    board := []string{}
    for i := 0; i < n; i++ {
        row := make([]byte, n)
        for j := 0; j < n; j++ {
            row[j] = '.'
        }
        row[queens[i]] = 'Q'
        board = append(board, string(row))
    }
    return board
}
```

```Python [sol2-Python3]
class Solution:
    def solveNQueens(self, n: int) -> List[List[str]]:
        def generateBoard():
            board = list()
            for i in range(n):
                row[queens[i]] = "Q"
                board.append("".join(row))
                row[queens[i]] = "."
            return board

        def solve(row: int, columns: int, diagonals1: int, diagonals2: int):
            if row == n:
                board = generateBoard()
                solutions.append(board)
            else:
                availablePositions = ((1 << n) - 1) & (~(columns | diagonals1 | diagonals2))
                while availablePositions:
                    position = availablePositions & (-availablePositions)
                    availablePositions = availablePositions & (availablePositions - 1)
                    column = bin(position - 1).count("1")
                    queens[row] = column
                    solve(row + 1, columns | position, (diagonals1 | position) << 1, (diagonals2 | position) >> 1)

        solutions = list()
        queens = [-1] * n
        row = ["."] * n
        solve(0, 0, 0, 0)
        return solutions
```

```C [sol2-C]
int solutionsSize;

char** generateBoard(int* queens, int n) {
    char** board = (char**)malloc(sizeof(char*) * n);
    for (int i = 0; i < n; i++) {
        board[i] = (char*)malloc(sizeof(char) * (n + 1));
        for (int j = 0; j < n; j++) board[i][j] = '.';
        board[i][queens[i]] = 'Q', board[i][n] = 0;
    }
    return board;
}

void solve(char*** solutions, int* queens, int n, int row, int columns, int diagonals1, int diagonals2) {
    if (row == n) {
        char** board = generateBoard(queens, n);
        solutions[solutionsSize++] = board;
    } else {
        int availablePositions = ((1 << n) - 1) & (~(columns | diagonals1 | diagonals2));
        while (availablePositions != 0) {
            int position = availablePositions & (-availablePositions);
            availablePositions = availablePositions & (availablePositions - 1);
            int column = __builtin_ctz(position);
            queens[row] = column;
            solve(solutions, queens, n, row + 1, columns | position, (diagonals1 | position) >> 1, (diagonals2 | position) << 1);
            queens[row] = -1;
        }
    }
}

char*** solveNQueens(int n, int* returnSize, int** returnColumnSizes) {
    char*** solutions = malloc(sizeof(char**) * 501);
    solutionsSize = 0;
    int queens[n];
    memset(queens, -1, sizeof(queens));
    solve(solutions, queens, n, 0, 0, 0, 0);
    *returnSize = solutionsSize;
    *returnColumnSizes = malloc(sizeof(int*) * solutionsSize);
    for (int i = 0; i < solutionsSize; i++) {
        (*returnColumnSizes)[i] = n;
    }
    return solutions;
}
```

**复杂度分析**

- 时间复杂度：$O(N!)$，其中 $N$ 是皇后数量。

- 空间复杂度：$O(N)$，其中 $N$ 是皇后数量。由于使用位运算表示，因此存储皇后信息的空间复杂度是 $O(1)$，空间复杂度主要取决于递归调用层数和记录每行放置的皇后的列下标的数组，递归调用层数不会超过 $N$，数组的长度为 $N$。

#### 小结

回顾这道题，拿到这道题的时候，其实我们很容易看出需要使用枚举的方法来求解这个问题，当我们不知道用什么办法来枚举是最优的时候，可以从下面三个方向考虑：

+ 子集枚举：可以把问题转化成「从 $n^2$ 个格子中选一个子集，使得子集中恰好有 $n$ 个格子，且任意选出两个都不在同行、同列或者同对角线」，这里枚举的规模是 $2^{n^2}$；
+ 组合枚举：可以把问题转化成「从 $n^2$ 个格子中选择 $n$ 个，且任意选出两个都不在同行、同列或者同对角线」，这里的枚举规模是 ${n^2} \choose {n}$；
+ 排列枚举：因为这里每行只能放置一个皇后，而所有行中皇后的列号正好构成一个 $1$ 到 $n$ 的排列，所以我们可以把问题转化为一个排列枚举，规模是 $n!$。

带入一些 $n$ 进这三种方法验证，就可以知道哪种方法的枚举规模是最小的，这里我们发现第三种方法的枚举规模最小。这道题给出的两个方法其实和排列枚举的本质是类似的。
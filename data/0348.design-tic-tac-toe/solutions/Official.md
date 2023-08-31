## [348.设计井字棋 中文官方题解](https://leetcode.cn/problems/design-tic-tac-toe/solutions/100000/she-ji-jing-zi-qi-by-leetcode-solution-65eb)
[TOC]

## 解决方案

---

 #### 前言

 井字棋是我们大多数人在童年时都玩过的经典游戏。游戏规则相当简单。有 2 位玩家轮流在  `n * n`  的棋盘上标记位置。第一个在水平，垂直，或对角线上标记了 `n` 个位置的玩家赢得比赛。
 解决这个问题的暴力方法是遍历整个 `n * n` 的棋盘检查当前玩家是否在任何一行，列，对角线或反对角线上做了标记。
 这种方法是穷尽的，每一步都需要 $O(n^2)$ 的时间。那么我们来看看其他更高效的解决方案。

---

 #### 方法 1：暴力优化

 **概述**
 最简单直观的方法是在每一步检查当前玩家是否赢了。每个玩家通过在棋盘上的一个格子做标记来进行移动。给定的格子位于行 `row` 和列 `col`上。玩家能赢的四种方式如下：

- 玩家已经标记了整行 `row`。
- 玩家已经标记了整列 `col`。
- 玩家已经标记了从棋盘左上角开始，到右下角结束的对角线。
- 玩家已经标记了从棋盘右上角开始，到左下角结束的反对角线。

 下图展示了 4 种获胜条件。

 ![image.png](https://pic.leetcode.cn/1691727829-QeyCXf-image.png){:width=400}

 > 我们如何判断哪些格子位于对角线或反对角线上？

主对角线上的每一个格子都有一个独特的属性，行索引和列索引相等。同样，反对角线上的每一个格子，列索引的值等于 `n - row - 1`。

![image.png](https://pic.leetcode.cn/1691727833-cLXsbj-image.png){:width=400}

 每一步我们将检查上述条件是否成立。如果是，我们就宣布当前玩家为胜利者，结束游戏。

 **算法**

 1. 对于给定的 `n`, 先初始化一个二维数组 `board`，大小为 `n*n`，所有元素的值设为 `0`。
 2. 每一步，将 `board` 上 `row` 行 `col` 列的格子标记为当前玩家的 id `player`。
 3. 现在，我们检查以下条件以确定当前玩家是否赢了。

    - 检查给定 `row` 的所有格子是否已被当前玩家标记。要做到这一点，我们必须在索引 `0` 到 `n - 1` 的所有列上进行遍历，保持 `row` 索引恒定。
    - 检查给定 `col` 上的所有位置是否已被当前玩家标记。我们必须在索引从 `0` 到 `n - 1` 的所有行上进行遍历，保持 `col` 索引恒定。
    - 检查主对角线是否已被当前玩家完全标记。
    从上述叙述中，我们知道主对角线上的每一个格子，`row` 和 `col` 的索引是相等的。因此，对角线上的每一个格子可以由 `board[row][row]` 表示。
    - 检查反对角线是否已被当前玩家完全标记。
    从上述叙述中，我们知道反对角线上的每一个格子，`col` 的值等于 `n - row - 1`。因此，反对角线上的每一个格子可以由 `board[row][n - row - 1]`表示。

 4. 如果当前玩家赢得了比赛，就返回 `player`。否则返回 `0`，表示没有人赢得比赛。

 **实现**

 ```C++ [slu1]
 
class TicTacToe {
public:
    vector<vector<int>> board;
    int n;

    TicTacToe(int n) {
        board.assign(n, vector<int>(n, 0));
        this->n = n;
    }

    int move(int row, int col, int player) {
        board[row][col] = player;
        if (checkCol(col, player) ||
            checkRow(row, player) ||
            (row == col && checkDiagonal(player)) ||
            (row == n - col - 1 && checkAntiDiagonal(player))) {
            return player;
        }
        // 没有人赢
        return 0;
    }

    bool checkDiagonal(int player) {
        for (int row = 0; row < n; row++) {
            if (board[row][row] != player) return false;
        }
        return true;
    }

    bool checkAntiDiagonal(int player) {
        for (int row = 0; row < n; row++) {
            if (board[row][n - row - 1] != player) return false;
        }
        return true;
    }

    bool checkCol(int col, int player) {
        for (int row = 0; row < n; row++) {
            if (board[row][col] != player) return false;
        }
        return true;
    }

    bool checkRow(int row, int player) {
        for (int col = 0; col < n; col++) {
            if (board[row][col] != player) return false;
        }
        return true;
    }
};
 ```

 ```Java [slu1]
 class TicTacToe {

    private int[][] board;
    private int n;

    public TicTacToe(int n) {
        board = new int[n][n];
        this.n = n;
    }

    public int move(int row, int col, int player) {
        board[row][col] = player;
        // 检查玩家是否赢得游戏
        if ((checkRow(row, player)) ||
            (checkColumn(col, player)) ||
            (row == col && checkDiagonal(player)) ||
            (col == n - row - 1 && checkAntiDiagonal(player))) {
            return player;
        }
        // 没有人赢
        return 0;
    }

    private boolean checkDiagonal(int player) {
        for (int row = 0; row < n; row++) {
            if (board[row][row] != player) {
                return false;
            }
        }
        return true;
    }

    private boolean checkAntiDiagonal(int player) {
        for (int row = 0; row < n; row++) {
            if (board[row][n - row - 1] != player) {
                return false;
            }
        }
        return true;
    }

    private boolean checkColumn(int col, int player) {
        for (int row = 0; row < n; row++) {
            if (board[row][col] != player) {
                return false;
            }
        }
        return true;
    }

    private boolean checkRow(int row, int player) {
        for (int col = 0; col < n; col++) {
            if (board[row][col] != player) {
                return false;
            }
        }
        return true;
    }
}
 ```

 **复杂度分析**
 *时间复杂度*：$O(n)$，因为每一步我们都会遍历 `n` 个格子 4 次，检查每一列，每一行，每个对角线和每个反对角线。这给我们的时间复杂度是 $O(4* n)$，等同于 $O(n)$。
 *空间复杂度*：$O(n^2)$，因为我们使用了大小为 `n* n` 的二维数组 `board`。

---

 #### 方法 2：优化解决方案

 **概述**
 我们的目标是找出玩家是否通过标记整行，整列，对角线或反对角线的格子来赢得比赛。我们能在常数时间内找到这一点，而不需要在每一步中遍历每一个水平，垂直和对角线吗？是的。我们来发现怎么做。
 我们把这个问题分为两部分，

  - 首先，我们要在每一步中确定玩家是否已经标记了每一行或每一列中所有的格子。换言之，我们可以说，如果棋盘有 `n` 行和 `n` 列，玩家必须已经标记了某一行或某一列 `n` 次。
    
> 从给定的条件中我们知道，每一步的移动都是有效的并且会在一个空白的格子上进行。因此我们可以确定，如果玩家已经标记了任何一行 `n` 次，他们必须每次都在不同的列上进行标记。
    
  - 其次，我们在每一步中要确定玩家是否已经标记了所有主对角线或反对角线的格子。不论棋盘的大小，主对角线和反对角线只能有一个。
    同样，对角线和反对角线上都有 `n` 个格子。因此，要想通过对角线或反对角线赢得比赛，玩家必须在对角线或反对角线上标记 `n` 次。
 让我们来理解怎样实施这个方法。

 **算法**
 从上述叙述中我们知道，我们需要使用一个数据结构来计算玩家标记了特定的行，列或对角线多少次。

 - 实施第一部分，对于每个玩家，我们将创建一个大小为 `n` 的数组 `rows`，其中 `rows[i]` 储存玩家在第 $i^{th}$行标记了多少次。同样的，对于每个玩家，我们还会创建一个大小为 `n` 的数组 `cols`。
    胜利条件：如果 `rows[i]` 或 `cols[j]` 等于 `n`，则在标记了第 $i^{th}$ 行和第 $j^{th}$ 列的格子之后，玩家就赢了比赛。
    设 `player1Rows` 和 `player1Cols` 是玩家1的`rows`和`cols`数组。同样的，设 `player2Rows` 和 `player2Cols`是玩家2的`rows`和`cols`数组。以下图解说明了对`move(0, 0, 1)` 和 `move(0, 2, 2)` 的处理过程。

 ![image.png](https://pic.leetcode.cn/1691727837-UkdhFp-image.png){:width=600}

 - 实施第二部分，我们可以用类似的想法。因为只有一个对角线和一个反对角线，对于每个玩家，我们只需要两个整数变量 `diagonal` 和 `antiDiagonal`。这些变量会储存对角线和反对角线上格子被标记了多少次。
    胜利条件：玩家标记了对角线上的一个格子后，我们检查该玩家的变量 `diagonal` 的值是否等于 `n`。同样地，玩家标记了反对角线上的一个格子后，我们检查该玩家的 `antiDiagonal` 的值是否等于 `n`。
    设 `player1Diagonal` 和 `player1AntiDiagonal` 分别是玩家1的 `diagonal` 和 `antiDiagonal` 变量。同样的，设 `player2Diagonal` 和 `player2AntiDiagonal` 分别是玩家2的 `diagonal` 和 `antiDiagonal` 变量。以下图解说明了对 `move(1, 1, 1)` 和 `move(2, 0, 2)` 的处理过程。

 ![image.png](https://pic.leetcode.cn/1691727841-Mkflwx-image.png){:width=600}

 > 我们能否进一步优化这个算法？

 答案是肯定的。因为只有两个玩家，当我们实施第一部分时，我们可以使用同一份数据结构来储存两个玩家标记行和列的值。
 实现的一种方式是 _增加_ 计数（count）当玩家 1 标记一个格子，和 _减少_ 计数（count）当玩家 2 标记一个格子。这样我们就可以说，如果 `rows[i]` 的值等于 `n`，玩家 1 已在第 $i^{th}$ 行标记 `n` 次。同样， 如果 `rows[i]` 的值等于 `-n`，那么玩家 2 已在第 $i^{th}$ 行标记 `n` 次。
 相同的逻辑也适用于列和对角线。
 以下动画说明了这个想法。

 <![image.png](https://pic.leetcode.cn/1691734031-iTNvHU-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691734034-KWgezi-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691734036-cPPPkW-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691734039-BgpnpY-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691734041-ucCiyc-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691734044-YLBncN-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691734047-FtsVAw-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691734049-DMfXYc-image.png){:width=400}>

 算法可以如下实现：

 1. 对于一个给定的 `n`，初始化大小为 `n` 的数组 `rows` 和 `cols`，每个元素的值设为 `0`。
 2. 每次移动，我们必须增加/减少 row，column，diagonal，和 anti-diagonal 根据当前玩家是谁和那一个格子被标记。
    如果当前玩家是玩家 1，我们 _递增_ 值，如果是玩家 2，我们 _递减_ 值。

    > 注意：如果我们应用简单的数字规则，我们可以递增或递减这些值不论玩家是谁。

    我们可以使用另一个变量 `currentPlayer`，对于玩家 1 值为 `1`，对于玩家 2 值为 `-1`， 并把 `currentPlayer` 的值加到当前的 row，column，diagonal 和 anti-diagonal 上。
 3. 最后一步，我们检查当前玩家是否赢了比赛。如果任何行，列，对角线或反对角线等于 `n` （对于玩家1） 或 `-n` （对于玩家 2），那么当前玩家就赢了比赛。
    同样的，我们可以检查绝对值，而不必拥有单独的条件来检查现在轮到谁。

**实现**
 ```C++ [slu2]
 class TicTacToe {
public:
    vector<int> rows;
    vector<int> cols;
    int diagonal;
    int antiDiagonal;

    TicTacToe(int n) {
        rows.assign(n, 0);
        cols.assign(n, 0);
        diagonal = 0;
        antiDiagonal = 0;
    }

    int move(int row, int col, int player) {
        int currentPlayer = (player == 1) ? 1 : -1;
        // 更新 rows 和 cols 数组中的当前用户
        rows[row] += currentPlayer;
        cols[col] += currentPlayer;
        // 更新 diagonal
        if (row == col) {
            diagonal += currentPlayer;
        }
        // 更新 anti Diagonal
        if (col == (cols.size() - row - 1)) {
            antiDiagonal += currentPlayer;
        }
        int n = rows.size();
        // 检查玩家是否赢得游戏
        if (abs(rows[row]) == n ||
            abs(cols[col]) == n ||
            abs(diagonal) == n ||
            abs(antiDiagonal) == n) {
            return player;
        }
        // 没有人赢
        return 0;
    }
};
 ```

 ```Java [slu2]
 public class TicTacToe {
    int[] rows;
    int[] cols;
    int diagonal;
    int antiDiagonal;

    public TicTacToe(int n) {
        rows = new int[n];
        cols = new int[n];
    }

    public int move(int row, int col, int player) {
        int currentPlayer = (player == 1) ? 1 : -1;
        // 更新 rows 和 cols 数组中的当前用户
        rows[row] += currentPlayer;
        cols[col] += currentPlayer;
        // 更新 diagonal
        if (row == col) {
            diagonal += currentPlayer;
        }
        // 更新 antiDiagonal
        if (col == (cols.length - row - 1)) {
            antiDiagonal += currentPlayer;
        }
        int n = rows.length;
        // 检查玩家是否赢得游戏
        if (Math.abs(rows[row]) == n ||
                Math.abs(cols[col]) == n ||
                Math.abs(diagonal) == n ||
                Math.abs(antiDiagonal) == n) {
            return player;
        }
        // 没有人赢
        return 0;
    }
}
 ```

 **复杂度分析**
 设 $n$ 为字符串 $s$ 的长度。 

 * 时间复杂度：$O(1)$，因为每次移动，我们都会在常数时间内标记一个特定的行，列，对角线，和反对角线。
 * 空间复杂度： $O(n)$，因为我们使用大小为 `n` 的数组 `rows` 和 `cols`。该变量 `diagonal` 和 `antiDiagonal` 同样使用了常数的额外空间。
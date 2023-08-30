#### 方法一：一次遍历

有效的数独满足以下三个条件：

- 同一个数字在每一行只能出现一次；

- 同一个数字在每一列只能出现一次；

- 同一个数字在每一个小九宫格只能出现一次。

可以使用哈希表记录每一行、每一列和每一个小九宫格中，每个数字出现的次数。只需要遍历数独一次，在遍历的过程中更新哈希表中的计数，并判断是否满足有效的数独的条件即可。

对于数独的第 $i$ 行第 $j$ 列的单元格，其中 $0 \le i, j < 9$，该单元格所在的行下标和列下标分别为 $i$ 和 $j$，该单元格所在的小九宫格的行数和列数分别为 $\Big\lfloor \dfrac{i}{3} \Big\rfloor$ 和 $\Big\lfloor \dfrac{j}{3} \Big\rfloor$，其中 $0 \le \Big\lfloor \dfrac{i}{3} \Big\rfloor, \Big\lfloor \dfrac{j}{3} \Big\rfloor < 3$。

由于数独中的数字范围是 $1$ 到 $9$，因此可以使用数组代替哈希表进行计数。

具体做法是，创建二维数组 $\textit{rows}$ 和 $\textit{columns}$ 分别记录数独的每一行和每一列中的每个数字的出现次数，创建三维数组 $\textit{subboxes}$ 记录数独的每一个小九宫格中的每个数字的出现次数，其中 $\textit{rows}[i][\textit{index}]$、$\textit{columns}[j][\textit{index}]$ 和 $\textit{subboxes}\Big[\Big\lfloor \dfrac{i}{3} \Big\rfloor\Big]\Big[\Big\lfloor \dfrac{j}{3} \Big\rfloor\Big]\Big[\textit{index}\Big]$ 分别表示数独的第 $i$ 行第 $j$ 列的单元格所在的行、列和小九宫格中，数字 $\textit{index} + 1$ 出现的次数，其中 $0 \le \textit{index} < 9$，对应的数字 $\textit{index} + 1$ 满足 $1 \le \textit{index} + 1 \le 9$。

如果 $\textit{board}[i][j]$ 填入了数字 $n$，则将 $\textit{rows}[i][n - 1]$、$\textit{columns}[j][n - 1]$ 和 $\textit{subboxes}\Big[\Big\lfloor \dfrac{i}{3} \Big\rfloor\Big]\Big[\Big\lfloor \dfrac{j}{3} \Big\rfloor\Big]\Big[n - 1\Big]$ 各加 $1$。如果更新后的计数大于 $1$，则不符合有效的数独的条件，返回 $\text{false}$。

如果遍历结束之后没有出现计数大于 $1$ 的情况，则符合有效的数独的条件，返回 $\text{true}$。

```Java [sol1-Java]
class Solution {
    public boolean isValidSudoku(char[][] board) {
        int[][] rows = new int[9][9];
        int[][] columns = new int[9][9];
        int[][][] subboxes = new int[3][3][9];
        for (int i = 0; i < 9; i++) {
            for (int j = 0; j < 9; j++) {
                char c = board[i][j];
                if (c != '.') {
                    int index = c - '0' - 1;
                    rows[i][index]++;
                    columns[j][index]++;
                    subboxes[i / 3][j / 3][index]++;
                    if (rows[i][index] > 1 || columns[j][index] > 1 || subboxes[i / 3][j / 3][index] > 1) {
                        return false;
                    }
                }
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool IsValidSudoku(char[][] board) {
        int[,] rows = new int[9, 9];
        int[,] columns = new int[9, 9];
        int[,,] subboxes = new int[3, 3, 9];
        for (int i = 0; i < 9; i++) {
            for (int j = 0; j < 9; j++) {
                char c = board[i][j];
                if (c != '.') {
                    int index = c - '0' - 1;
                    rows[i, index]++;
                    columns[j, index]++;
                    subboxes[i / 3, j / 3, index]++;
                    if (rows[i, index] > 1 || columns[j, index] > 1 || subboxes[i / 3, j / 3, index] > 1) {
                        return false;
                    }
                }
            }
        }
        return true;
    }
}
```

```JavaScript [sol1-JavaScript]
var isValidSudoku = function(board) {
    const rows = new Array(9).fill(0).map(() => new Array(9).fill(0));
    const columns = new Array(9).fill(0).map(() => new Array(9).fill(0));
    const subboxes = new Array(3).fill(0).map(() => new Array(3).fill(0).map(() => new Array(9).fill(0)));
    for (let i = 0; i < 9; i++) {
        for (let j = 0; j < 9; j++) {
            const c = board[i][j];
            if (c !== '.') {
                const index = c.charCodeAt() - '0'.charCodeAt() - 1;
                rows[i][index]++;
                columns[j][index]++;
                subboxes[Math.floor(i / 3)][Math.floor(j / 3)][index]++;
                if (rows[i][index] > 1 || columns[j][index] > 1 || subboxes[Math.floor(i / 3)][Math.floor(j / 3)][index] > 1) {
                    return false;
                }
            }
        }
    }
    return true;
};
```

```C++ [sol1-C++]
class Solution {
public:
    bool isValidSudoku(vector<vector<char>>& board) {
        int rows[9][9];
        int columns[9][9];
        int subboxes[3][3][9];
        
        memset(rows,0,sizeof(rows));
        memset(columns,0,sizeof(columns));
        memset(subboxes,0,sizeof(subboxes));
        for (int i = 0; i < 9; i++) {
            for (int j = 0; j < 9; j++) {
                char c = board[i][j];
                if (c != '.') {
                    int index = c - '0' - 1;
                    rows[i][index]++;
                    columns[j][index]++;
                    subboxes[i / 3][j / 3][index]++;
                    if (rows[i][index] > 1 || columns[j][index] > 1 || subboxes[i / 3][j / 3][index] > 1) {
                        return false;
                    }
                }
            }
        }
        return true;
    }
};
```

```go [sol1-Golang]
func isValidSudoku(board [][]byte) bool {
    var rows, columns [9][9]int
    var subboxes [3][3][9]int
    for i, row := range board {
        for j, c := range row {
            if c == '.' {
                continue
            }
            index := c - '1'
            rows[i][index]++
            columns[j][index]++
            subboxes[i/3][j/3][index]++
            if rows[i][index] > 1 || columns[j][index] > 1 || subboxes[i/3][j/3][index] > 1 {
                return false
            }
        }
    }
    return true
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。数独共有 $81$ 个单元格，只需要对每个单元格遍历一次即可。

- 空间复杂度：$O(1)$。由于数独的大小固定，因此哈希表的空间也是固定的。
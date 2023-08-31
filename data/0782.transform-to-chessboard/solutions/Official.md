## [782.变为棋盘 中文官方题解](https://leetcode.cn/problems/transform-to-chessboard/solutions/100000/bian-wei-qi-pan-by-leetcode-solution-39dd)
#### 方法一：分维度计算

首先需要思考的是对矩阵做一次交换之后，矩阵的变换状态。比如我们以交换列为代表，在对任意两列进行交换之后，可以看到列交换是不会改变任意相邻两行之间的元素异同对应关系，比如相邻两行的两个元素 $\textit{board}[i][j],\textit{board}[i+1][j]$ 原本就相同，任意列交换之后这个两个元素对应的关系保持不变，如果这两个元素本来就不同，经过列交换之后也仍然不同，因此可以推出矩阵一定只能包含有两种不同的行，要么与第一行的元素相同，要么每一行的元素刚好与第一行的元素「相反」。如果矩阵可以转换为合法的「棋盘」，假设第 $1$ 行的元素为 $[0,1,1,1,0]$，则其他行的元素要么为 $[0,1,1,1,0]$，要么为 $[1,0,0,0,1]$。最终的棋盘一定只有两种不同的行，要么以 $0$ 开始的 $[0,1,0,1,\cdots]$，要么以 $1$ 开始的 $[1,0,1,0,\cdots]$，因此我们可以推出棋盘也一定可以通过列变换将所有的行变为只有以上两种状态的行，否则无法得到最终合法的「棋盘」。同时我们可以观察到，先换行再换列跟先换列再换行结果是一样的，因为我们可以先将所有的行调整到正确的位置，再将所有的列调整到正确的位置。行与列之间的变换实际是相互独立的，二者互不影响，列变换不会影响相邻两行的异同关系，行变换不会不会影响相邻两列的异同关系。

由于最终只有两种不同的行，要达成最终的「棋盘」实际上等价于将矩阵的行表示成 $0,1$ 相互交替的状态，如果一个行无法变为 $0,1$ 交替的状态，则我们认为矩阵不存在可行的变换。假设矩阵的某行用 $[0,1]$ 表示之后得到数组为 $[0, 1, 1, 1, 0, 0]$，那么只需求出这个数组变成 $[0, 1, 0, 1, 0, 1]$ 或者 $[1, 0, 1, 0, 1, 0]$ 的最少交换次数即可。同理，对于矩阵的列也是如此，这就将二维问题变成了两个一维问题。我们实际只需要分别将矩阵的第一行变为最终状态和第一列变为最终状态，最终的矩阵一定为合法「棋盘」。

+ 首先我们需要检测矩阵的合法性，即该矩阵是否可以变为合法的「棋盘」。我们依次检测矩阵的每一行是否可以变为 $0,1$ 交替，即变为 $[0,1,0,1,\cdots],[1,0,1,0,\cdots]$ 两种可能的行；然后依次检测矩阵的每一列是否可以变为 $0,1$ 交替，即变为 $[0,1,0,1,\cdots],[1,0,1,0,\cdots]$ 两种可能的列。设行的数目为 $n$，检测矩阵的行与列时需要进行如下检测：
  + 检测每一行和每一列的状态是否合法：由于列变换不改变相邻两行元素的对应关系，因此我们可以知道矩阵的行要么与第 $1$ 行相同，要么与第 $1$ 行「相反」。设第一行的状态为 $\textit{rowMask}$，与之相反对应的状态为 $\textit{reverseRowMask}$，我们检测每一行是否属于这两个合法的状态 $\textit{rowMask},\textit{reverseRowMask}$，如果不合法直接返回，对于列也采用同样的检测方法。由于题目中的行与列的值均为 $0$ 或者 $1$，且行数和列数最大为 $30$，我们利用压缩位图来表示每一行或者每一列的状态，可以用一个 $32$ 位整数来表示每一行，其中整数每位上的数字对应着每列上的数字。

  + 检测每一行和每一列中含有的数字是否合法：检测每一行或者每一列若要变为 $0,1$ 交替的状态，如果 $n$ 为偶数，则每一行中 $1$ 的数目与 $0$ 的数目相等；如果 $n$ 为奇数，则每一行中 $1$ 的数目与 $0$ 的数目相差的绝对值一定为 $1$。此时我们只需要检测第一行中含有的数字 $0,1$ 的个数是否合法，对于列我们也采用同样的检测方法。由于我们用一个 $32$ 位整数来表示每一行或者每一列，我们只需要要快速计算出整数的二进制位上含有的 $1$ 的数目即可。
  
  + 检测不同状态的行数和列数是否合法：我们设矩阵中与第一行相同的行的数量为 $\textit{count}$。根据我们之前的推论可知，需要满足两种不同的行交替分情况讨论：如果 $n$ 为偶数，由于必须要满足两种不同的行交替，每种行的数目只能占到总行数的一半，此时一定有 $\textit{count} \times 2 = n$；如果 $n$ 为奇数，由于必须要满足两种不同的行交替，则另一种行的数量只能为 $n - \textit{count}$，由于必须满足交替不同，则二者之间的差值的绝对值一定为 $1$，因此此时一定满足 $|2 \times \textit{count} - n| = 1$，满足以上条件才是合法的行数。我们采用同样的方法对矩阵的列数进行检测。

+ 其次我们求出将矩阵变为棋盘的最少交换次数。分为两种情况讨论:
  + 如果 $n$ 为偶数，则此时最终的合法棋盘有两种可能，即第一行的元素的第一个元素 $\textit{board}[0][0] = 0$ 或者 $\textit{board}[0][0] = 1$。我们可以选择将第 $1$ 行变为以 $0$ 开头，此时只需将偶数位上的 $0$ 全部替换为 $1$ 即可；也可以选择将第 $1$ 行变为以 $1$ 开头，此时只需将奇数位上的 $0$ 全部替换为 $1$ 即可。我们可以用位图来快速计算出偶数位或者奇数位上 $1$ 的个数，可以与特定的数进行布尔代数运算即可快速消除奇数位或者偶数位上的 $1$。
 
  + 如果 $n$ 为奇数，则此时最终的合法棋盘只有一种可能，如果第一行中 $0$ 的数目大于 $1$ 的数目，此时第一行只能变为以 $0$ 为开头交替的序列，此时我们只需要将偶数位上的 $0$ 全部变为 $1$；如果第一行中 $0$ 的数目小于 $1$ 的数目，此时第一行只能交换变为以 $1$ 为开头交替的序列，此时我们只需要将奇数位上的 $0$ 全部变为 $1$。可以用位图来快速计算出偶数位或者奇数位上 $1$ 的个数，可以与特定的数进行布尔代数运算即可快速消除奇数位或者偶数位上的 $1$。
 
  + 由于我们采用 $32$ 位整数表示每一行或者每一列，在快速计算偶数位或者上的 $1$ 的数目时可以采用位运算掩码。比如 $32$ 位整数 $x$，我们只保留 $x$ 偶数位上的 $1$，此时我们需要去掉奇数位上的 $1$，此时只需将 $x$ 与掩码：
    
    > $\texttt{(1010~1010~1010~1010~1010~1010~1010~1010)}_\texttt{2}=\texttt{0xAAAAAAAA}$
    
    相与即可；我们只保留 $x$ 奇数位上的 $1$，此时我们需要去掉偶数位上的 $1$，此时只需将 $x$ 与掩码：

    > $\texttt{(0101~0101~0101~0101~0101~0101~0101~0101)}_\texttt{2}=\texttt{0x55555555}$

    相与即可。
    
```Python [sol1-Python3]
class Solution:
    def movesToChessboard(self, board: List[List[int]]) -> int:
        n = len(board)
        # 棋盘的第一行与第一列
        rowMask = colMask = 0
        for i in range(n):
            rowMask |= board[0][i] << i
            colMask |= board[i][0] << i
        reverseRowMask = ((1 << n) - 1) ^ rowMask
        reverseColMask = ((1 << n) - 1) ^ colMask
        rowCnt = colCnt = 0
        for i in range(n):
            currRowMask = currColMask = 0
            for j in range(n):
                currRowMask |= board[i][j] << j
                currColMask |= board[j][i] << j
            # 检测每一行和每一列的状态是否合法
            if currRowMask != rowMask and currRowMask != reverseRowMask or \
               currColMask != colMask and currColMask != reverseColMask:
                return -1
            rowCnt += currRowMask == rowMask  # 记录与第一行相同的行数
            colCnt += currColMask == colMask  # 记录与第一列相同的列数

        def getMoves(mask: int, count: int) -> int:
            ones = mask.bit_count()
            if n & 1:
                # 如果 n 为奇数，则每一行中 1 与 0 的数目相差为 1，且满足相邻行交替
                if abs(n - 2 * ones) != 1 or abs(n - 2 * count) != 1:
                    return -1
                if ones == n // 2:
                    # 偶数位变为 1 的最小交换次数
                    return n // 2 - (mask & 0xAAAAAAAA).bit_count()
                else:
                    # 奇数位变为 1 的最小交换次数
                    return (n + 1) // 2 - (mask & 0x55555555).bit_count()
            else:
                # 如果 n 为偶数，则每一行中 1 与 0 的数目相等，且满足相邻行交替
                if ones != n // 2 or count != n // 2:
                    return -1
                # 偶数位变为 1 的最小交换次数
                count0 = n // 2 - (mask & 0xAAAAAAAA).bit_count()
                # 奇数位变为 1 的最小交换次数
                count1 = n // 2 - (mask & 0x55555555).bit_count()
                return min(count0, count1)

        rowMoves = getMoves(rowMask, rowCnt)
        colMoves = getMoves(colMask, colCnt)
        return -1 if rowMoves == -1 or colMoves == -1 else rowMoves + colMoves
```

```C++ [sol1-C++]
class Solution {
public:
    int getMoves(int mask, int count, int n) {
        int ones = __builtin_popcount(mask);
        if (n & 1) {
            /* 如果 n 为奇数，则每一行中 1 与 0 的数目相差为 1，且满足相邻行交替 */
            if (abs(n - 2 * ones) != 1 || abs(n - 2 * count) != 1 ) {
                return -1;
            }
            if (ones == (n >> 1)) {
                /* 偶数位变为 1 的最小交换次数 */
                return n / 2 - __builtin_popcount(mask & 0xAAAAAAAA);
            } else {
                /* 奇数位变为 1 的最小交换次数 */
                return (n + 1) / 2 - __builtin_popcount(mask & 0x55555555);
            }
        } else { 
            /* 如果 n 为偶数，则每一行中 1 与 0 的数目相等，且满足相邻行交替 */
            if (ones != (n >> 1) || count != (n >> 1)) {
                return -1;
            }
            /* 偶数位变为 1 的最小交换次数 */
            int count0 = n / 2 - __builtin_popcount(mask & 0xAAAAAAAA);
            /* 奇数位变为 1 的最小交换次数 */
            int count1 = n / 2 - __builtin_popcount(mask & 0x55555555);  
            return min(count0, count1);
        }
    }

    int movesToChessboard(vector<vector<int>>& board) {
        int n = board.size();
        int rowMask = 0, colMask = 0;        

        /* 检查棋盘的第一行与第一列 */
        for (int i = 0; i < n; i++) {
            rowMask |= (board[0][i] << i);
            colMask |= (board[i][0] << i);
        }
        int reverseRowMask = ((1 << n) - 1) ^ rowMask;
        int reverseColMask = ((1 << n) - 1) ^ colMask;
        int rowCnt = 0, colCnt = 0;
        for (int i = 0; i < n; i++) {
            int currRowMask = 0;
            int currColMask = 0;
            for (int j = 0; j < n; j++) {
                currRowMask |= (board[i][j] << j);
                currColMask |= (board[j][i] << j);
            }
            /* 检测每一行的状态是否合法 */
            if (currRowMask != rowMask && currRowMask != reverseRowMask) {
                return -1;
            } else if (currRowMask == rowMask) {
                /* 记录与第一行相同的行数 */
                rowCnt++;
            }
            /* 检测每一列的状态是否合法 */
            if (currColMask != colMask && currColMask != reverseColMask) {
                return -1;
            } else if (currColMask == colMask) {
                /* 记录与第一列相同的列数 */
                colCnt++;
            }
        }
        int rowMoves = getMoves(rowMask, rowCnt, n);
        int colMoves = getMoves(colMask, colCnt, n);
        return (rowMoves == -1 || colMoves == -1) ? -1 : (rowMoves + colMoves); 
    }
};
```

```Java [sol1-Java]
class Solution {
    public int movesToChessboard(int[][] board) {
        int n = board.length;
        int rowMask = 0, colMask = 0;        

        /* 检查棋盘的第一行与第一列 */
        for (int i = 0; i < n; i++) {
            rowMask |= (board[0][i] << i);
            colMask |= (board[i][0] << i);
        }
        int reverseRowMask = ((1 << n) - 1) ^ rowMask;
        int reverseColMask = ((1 << n) - 1) ^ colMask;
        int rowCnt = 0, colCnt = 0;
        for (int i = 0; i < n; i++) {
            int currRowMask = 0;
            int currColMask = 0;
            for (int j = 0; j < n; j++) {
                currRowMask |= (board[i][j] << j);
                currColMask |= (board[j][i] << j);
            }
            /* 检测每一行的状态是否合法 */
            if (currRowMask != rowMask && currRowMask != reverseRowMask) {
                return -1;
            } else if (currRowMask == rowMask) {
                /* 记录与第一行相同的行数 */
                rowCnt++;
            }
            /* 检测每一列的状态是否合法 */
            if (currColMask != colMask && currColMask != reverseColMask) {
                return -1;
            } else if (currColMask == colMask) {
                /* 记录与第一列相同的列数 */
                colCnt++;
            }
        }
        int rowMoves = getMoves(rowMask, rowCnt, n);
        int colMoves = getMoves(colMask, colCnt, n);
        return (rowMoves == -1 || colMoves == -1) ? -1 : (rowMoves + colMoves); 
    }

    public int getMoves(int mask, int count, int n) {
        int ones = Integer.bitCount(mask);
        if ((n & 1) == 1) {
            /* 如果 n 为奇数，则每一行中 1 与 0 的数目相差为 1，且满足相邻行交替 */
            if (Math.abs(n - 2 * ones) != 1 || Math.abs(n - 2 * count) != 1 ) {
                return -1;
            }
            if (ones == (n >> 1)) {
                /* 以 0 为开头的最小交换次数 */
                return n / 2 - Integer.bitCount(mask & 0xAAAAAAAA);
            } else {
                return (n + 1) / 2 - Integer.bitCount(mask & 0x55555555);
            }
        } else { 
            /* 如果 n 为偶数，则每一行中 1 与 0 的数目相等，且满足相邻行交替 */
            if (ones != (n >> 1) || count != (n >> 1)) {
                return -1;
            }
            /* 找到行的最小交换次数 */
            int count0 = n / 2 - Integer.bitCount(mask & 0xAAAAAAAA);
            int count1 = n / 2 - Integer.bitCount(mask & 0x55555555);  
            return Math.min(count0, count1);
        }
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

static int countBit(int x) {
    int ans = 0;
    while (x != 0) {
        x &= (x - 1);
        ans++;
    }
    return ans;
}

static int getMoves(int mask, int count, int n) {
    int ones = countBit(mask);
    if (n & 1) {
        /* 如果 n 为奇数，则每一行中 1 与 0 的数目相差为 1，且满足相邻行交替 */
        if (abs(n - 2 * ones) != 1 || abs(n - 2 * count) != 1 ) {
            return -1;
        }
        if (ones == (n >> 1)) {
            /* 偶数位变为 1 的最小交换次数 */
            return n / 2 - countBit(mask & 0xAAAAAAAA);
        } else {
            /* 奇数位变为 1 的最小交换次数 */
            return (n + 1) / 2 - countBit(mask & 0x55555555);
        }
    } else { 
        /* 如果 n 为偶数，则每一行中 1 与 0 的数目相等，且满足相邻行交替 */
        if (ones != (n >> 1) || count != (n >> 1)) {
            return -1;
        }
        /* 偶数位变为 1 的最小交换次数 */
        int count0 = n / 2 - countBit(mask & 0xAAAAAAAA);
        /* 奇数位变为 1 的最小交换次数 */
        int count1 = n / 2 - countBit(mask & 0x55555555);  
        return MIN(count0, count1);
    }
}

int movesToChessboard(int** board, int boardSize, int* boardColSize){
    int rowMask = 0, colMask = 0;        

    /* 检查棋盘的第一行与第一列 */
    for (int i = 0; i < boardSize; i++) {
        rowMask |= (board[0][i] << i);
        colMask |= (board[i][0] << i);
    }
    int reverseRowMask = ((1 << boardSize) - 1) ^ rowMask;
    int reverseColMask = ((1 << boardSize) - 1) ^ colMask;
    int rowCnt = 0, colCnt = 0;
    for (int i = 0; i < boardSize; i++) {
        int currRowMask = 0;
        int currColMask = 0;
        for (int j = 0; j < boardSize; j++) {
            currRowMask |= (board[i][j] << j);
            currColMask |= (board[j][i] << j);
        }
        /* 检测每一行的状态是否合法 */
        if (currRowMask != rowMask && currRowMask != reverseRowMask) {
            return -1;
        } else if (currRowMask == rowMask) {
            /* 记录与第一行相同的行数 */
            rowCnt++;
        }
        /* 检测每一列的状态是否合法 */
        if (currColMask != colMask && currColMask != reverseColMask) {
            return -1;
        } else if (currColMask == colMask) {
            /* 记录与第一列相同的列数 */
            colCnt++;
        }
    }
    int rowMoves = getMoves(rowMask, rowCnt, boardSize);
    int colMoves = getMoves(colMask, colCnt, boardSize);
    return (rowMoves == -1 || colMoves == -1) ? -1 : (rowMoves + colMoves); 
}
```

```JavaScript [sol1-JavaScript]
var movesToChessboard = function(board) {
    const n = board.length;
    let rowMask = 0, colMask = 0;        

    /* 检查棋盘的第一行与第一列 */
    for (let i = 0; i < n; i++) {
        rowMask |= (board[0][i] << i);
        colMask |= (board[i][0] << i);
    }
    const reverseRowMask = ((1 << n) - 1) ^ rowMask;
    const reverseColMask = ((1 << n) - 1) ^ colMask;
    let rowCnt = 0, colCnt = 0;
    for (let i = 0; i < n; i++) {
        let currRowMask = 0;
        let currColMask = 0;
        for (let j = 0; j < n; j++) {
            currRowMask |= (board[i][j] << j);
            currColMask |= (board[j][i] << j);
        }
        /* 检测每一行的状态是否合法 */
        if (currRowMask !== rowMask && currRowMask !== reverseRowMask) {
            return -1;
        } else if (currRowMask === rowMask) {
            /* 记录与第一行相同的行数 */
            rowCnt++;
        }
        /* 检测每一列的状态是否合法 */
        if (currColMask !== colMask && currColMask !== reverseColMask) {
            return -1;
        } else if (currColMask === colMask) {
            /* 记录与第一列相同的列数 */
            colCnt++;
        }
    }
    const rowMoves = getMoves(rowMask, rowCnt, n);
    const colMoves = getMoves(colMask, colCnt, n);
    return (rowMoves == -1 || colMoves == -1) ? -1 : (rowMoves + colMoves); 
};

const getMoves = (mask, count, n) => {
    const ones = bitCount(mask);
    if ((n & 1) === 1) {
        /* 如果 n 为奇数，则每一行中 1 与 0 的数目相差为 1，且满足相邻行交替 */
        if (Math.abs(n - 2 * ones) !== 1 || Math.abs(n - 2 * count) !== 1 ) {
            return -1;
        }
        if (ones === (n >> 1)) {
            /* 以 0 为开头的最小交换次数 */
            return Math.floor(n / 2) - bitCount(mask & 0xAAAAAAAA);
        } else {
            return Math.floor((n + 1) / 2) - bitCount(mask & 0x55555555);
        }
    } else { 
        /* 如果 n 为偶数，则每一行中 1 与 0 的数目相等，且满足相邻行交替 */
        if (ones !== (n >> 1) || count !== (n >> 1)) {
            return -1;
        }
        /* 找到行的最小交换次数 */
        const count0 = Math.floor(n / 2) - bitCount(mask & 0xAAAAAAAA);
        const count1 = Math.floor(n / 2) - bitCount(mask & 0x55555555);  
        return Math.min(count0, count1);
    }
}

const bitCount = (num) => {
    return num.toString(2).split('0').join('').length
}
```

```go [sol1-Golang]
func getMoves(mask uint, count, n int) int {
    ones := bits.OnesCount(mask)
    if n&1 > 0 {
        // 如果 n 为奇数，则每一行中 1 与 0 的数目相差为 1，且满足相邻行交替
        if abs(n-2*ones) != 1 || abs(n-2*count) != 1 {
            return -1
        }
        if ones == n>>1 {
            // 偶数位变为 1 的最小交换次数
            return n/2 - bits.OnesCount(mask&0xAAAAAAAA)
        } else {
            // 奇数位变为 1 的最小交换次数
            return (n+1)/2 - bits.OnesCount(mask&0x55555555)
        }
    } else {
        // 如果 n 为偶数，则每一行中 1 与 0 的数目相等，且满足相邻行交替
        if ones != n>>1 || count != n>>1 {
            return -1
        }
        // 偶数位变为 1 的最小交换次数
        count0 := n/2 - bits.OnesCount(mask&0xAAAAAAAA)
        // 奇数位变为 1 的最小交换次数
        count1 := n/2 - bits.OnesCount(mask&0x55555555)
        return min(count0, count1)
    }
}

func movesToChessboard(board [][]int) int {
    n := len(board)
    // 棋盘的第一行与第一列
    rowMask, colMask := 0, 0
    for i := 0; i < n; i++ {
        rowMask |= board[0][i] << i
        colMask |= board[i][0] << i
    }
    reverseRowMask := 1<<n - 1 ^ rowMask
    reverseColMask := 1<<n - 1 ^ colMask
    rowCnt, colCnt := 0, 0
    for i := 0; i < n; i++ {
        currRowMask, currColMask := 0, 0
        for j := 0; j < n; j++ {
            currRowMask |= board[i][j] << j
            currColMask |= board[j][i] << j
        }
        if currRowMask != rowMask && currRowMask != reverseRowMask || // 检测每一行的状态是否合法
            currColMask != colMask && currColMask != reverseColMask { // 检测每一列的状态是否合法
            return -1
        }
        if currRowMask == rowMask {
            rowCnt++ // 记录与第一行相同的行数
        }
        if currColMask == colMask {
            colCnt++ // 记录与第一列相同的列数
        }
    }
    rowMoves := getMoves(uint(rowMask), rowCnt, n)
    colMoves := getMoves(uint(colMask), colCnt, n)
    if rowMoves == -1 || colMoves == -1 {
        return -1
    }
    return rowMoves + colMoves
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 为矩阵的行数。我们只需要遍历矩阵一遍即可。

- 空间复杂度：$O(1)$。
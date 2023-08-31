## [999.可以被一步捕获的棋子数 中文官方题解](https://leetcode.cn/problems/available-captures-for-rook/solutions/100000/che-de-ke-yong-bu-huo-liang-by-leetcode-solution)
#### 方法一：模拟

**思路和算法**

根据题意模拟即可：

1. 遍历棋盘确定白色车的下标，用 $(st,ed)$ 表示。

2. 模拟车移动的规则，朝四个基本方向移动，直到碰到卒或者白色象或者碰到棋盘边缘时停止，用 $\textit{cnt}$ 记录捕获到的卒的数量。

那么如何模拟车移动的规则呢？我们可以建立方向数组表示在这个方向上移动一步的增量，比如向北移动一步的时候，白色车的 `x` 轴坐标减 `1`，而 `y` 轴坐标不会变化，所以我们可以用 `(-1, 0)` 表示白色车向北移动一步的增量，其它三个方向同理。建立了方向数组，则白色车在某个方向移动 $\textit{step}$ 步的坐标增量就可以直接计算得到，比如向北移动 $\textit{step}$ 步的坐标增量即为 `(-step, 0)`。

![fig1](https://assets.leetcode-cn.com/solution-static/999_fig1.gif)

方向数组也可以根据相应的题意自行扩展，比如模拟象棋中马跳的坐标增量。

```C++ [sol1-C++]
class Solution {
public:
    int numRookCaptures(vector<vector<char>>& board) {
        int cnt = 0, st = 0, ed = 0;
        int dx[4] = {0, 1, 0, -1};
        int dy[4] = {1, 0, -1, 0};
        for (int i = 0; i < 8; ++i) {
            for (int j = 0; j < 8; ++j) {
                if (board[i][j] == 'R') {
                    st = i;
                    ed = j;
                    break;
                }
            }
        }
        for (int i = 0; i < 4; ++i) {
            for (int step = 0;; ++step) {
                int tx = st + step * dx[i];
                int ty = ed + step * dy[i];
                if (tx < 0 || tx >= 8 || ty < 0 || ty >= 8 || board[tx][ty] == 'B') {
                    break;
                }
                if (board[tx][ty] == 'p') {
                    cnt++;
                    break;
                }
            }
        }
        return cnt;
    }
};
```
```Java [sol1-Java]
class Solution {
    public int numRookCaptures(char[][] board) {
        int cnt = 0, st = 0, ed = 0;
        int[] dx = {0, 1, 0, -1};
        int[] dy = {1, 0, -1, 0};
        for (int i = 0; i < 8; ++i) {
            for (int j = 0; j < 8; ++j) {
                if (board[i][j] == 'R') {
                    st = i;
                    ed = j;
                    break;
                }
            }
        }
        for (int i = 0; i < 4; ++i) {
            for (int step = 0;; ++step) {
                int tx = st + step * dx[i];
                int ty = ed + step * dy[i];
                if (tx < 0 || tx >= 8 || ty < 0 || ty >= 8 || board[tx][ty] == 'B') {
                    break;
                }
                if (board[tx][ty] == 'p') {
                    cnt++;
                    break;
                }
            }
        }
        return cnt;
    }
}
```
```Javascript [sol1-Javascript]
var numRookCaptures = function(board) {
    let cnt = 0, st = 0, ed = 0;
    const dx = [0, 1, 0, -1];
    const dy = [1, 0, -1, 0];

    for (let i = 0; i < 8; ++i) {
        for (let j = 0; j < 8; ++j) {
            if (board[i][j] == 'R') {
                st = i;
                ed = j;
                break;
            }
        }
    }
    for (let i = 0; i < 4; ++i) {
        for (let step = 0;; ++step) {
            const tx = st + step * dx[i];
            const ty = ed + step * dy[i];
            if (tx < 0 || tx >= 8 || ty < 0 || ty >= 8 || board[tx][ty] == 'B') {
                break;
            }
            if (board[tx][ty] == 'p') {
                cnt++;
                break;
            }
        }
    }
    return cnt;
};
```
```Python [sol1-Python3]
class Solution:
    def numRookCaptures(self, board: List[List[str]]) -> int:
        cnt, st, ed = 0, 0, 0
        dx, dy = [0, 1, 0, -1], [1, 0, -1, 0]
        for i in range(8):
            for j in range(8):
                if board[i][j] == "R":
                    st, ed = i, j
        for i in range(4):
            step = 0
            while True:
                tx = st + step * dx[i]
                ty = ed + step * dy[i]
                if tx < 0 or tx >= 8 or ty < 0 or ty >= 8 or board[tx][ty] == "B":
                    break
                if board[tx][ty] == "p":
                    cnt += 1
                    break
                step += 1
        return cnt
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是棋盘的边长。找白色车在棋盘中的位置需要 $O(n^2)$ 的时间复杂度，模拟车在四个方向上捕获颜色相反的卒需要 $O(n)$ 的时间复杂度，所以一共需要 $O(n^2+n) = O(n^2)$ 的时间复杂度。 

- 空间复杂度：$O(1)$，只需要常数空间存放若干变量。
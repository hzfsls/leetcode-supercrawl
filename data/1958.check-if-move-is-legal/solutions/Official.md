## [1958.检查操作是否合法 中文官方题解](https://leetcode.cn/problems/check-if-move-is-legal/solutions/100000/jian-cha-cao-zuo-shi-fou-he-fa-by-leetco-gqwz)
#### 方法一：枚举每个方向验证

**思路与算法**

由题意可知，当前操作合法当且仅当从该点开始的 $8$ 个方向（上下左右与对角线）中，至少有一个方向存在一个以该点为起点的好线段。

那么，我们可以枚举这 $8$ 个方向，并对于每个方向验证是否存在以该点为起点的好线段。如果该点与对应方向**下一个相同颜色**的格点之间的所有格点（至少一个）均为另一种颜色，那么它们构成一个好线段。

我们用数对 $(\textit{dx}, \textit{dy})$ 来表示每个方向下一个格点相对于当前格点的行列下标变化量，并用函数 $\textit{check}(\textit{dx}, \textit{dy})$ 来判断该方向是否存在以操作位置为起点的好线段。如果我们寻找到了符合要求的好线段，则返回 $\texttt{true}$；反之亦然。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool checkMove(vector<vector<char>>& board, int rMove, int cMove, char color) {
        // 判断每个方向是否存在以操作位置为起点的好线段
        auto check = [&](int dx, int dy) -> bool{
            int x = rMove + dx;
            int y = cMove + dy;
            int step = 1;   // 当前遍历到的节点序号
            while (x >= 0 && x < 8 && y >= 0 && y < 8){
                if (step == 1){
                    // 第一个点必须为相反颜色
                    if (board[x][y] == '.' || board[x][y] == color){
                        return false;
                    }
                }
                else{
                    // 好线段中不应存在空格子
                    if (board[x][y] == '.'){
                        return false;
                    }
                    // 遍历到好线段的终点，返回 true
                    if (board[x][y] == color){
                        return true;
                    }
                }
                ++step;
                x += dx;
                y += dy;
            }
            // 不存在符合要求的好线段
            return false;
        };
        
        // 从 x 轴正方向开始逆时针枚举 8 个方向
        vector<int> dx = {1, 1, 0, -1, -1, -1, 0, 1};   // 行改变量
        vector<int> dy = {0, 1, 1, 1, 0, -1, -1, -1};   // 列改变量
        for (int k = 0; k < 8; ++k){
            if (check(dx[k], dy[k])){
                return true;
            }
        }
        return false;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def checkMove(self, board: List[List[str]], rMove: int, cMove: int, color: str) -> bool:
        # 判断每个方向是否存在以操作位置为起点的好线段
        def check(dx: int, dy: int) -> bool:
            x, y = rMove + dx, cMove + dy
            step = 1   # 当前遍历到的节点序号
            while 0 <= x < 8 and 0 <= y < 8:
                if step == 1:
                    # 第一个点必须为相反颜色
                    if board[x][y] == "." or board[x][y] == color:
                        return False
                else:
                    # 好线段中不应存在空格子
                    if board[x][y] == ".":
                        return False
                    # 遍历到好线段的终点，返回 true
                    if board[x][y] == color:
                        return True
                step += 1
                x += dx
                y += dy
            # 不存在符合要求的好线段
            return False
        
        # 从 x 轴正方向开始逆时针枚举 8 个方向
        dx = [1, 1, 0, -1, -1, -1, 0, 1]   # 行改变量
        dy = [0, 1, 1, 1, 0, -1, -1, -1]   # 列改变量
        for k in range(8):
            if check(dx[k], dy[k]):
                return True
        return False
```


**复杂度分析**

- 时间复杂度：$O(\max(r, c))$，其中 $r, c$ 为 $\textit{board}$ 的行数与列数。验证每个方向的时间复杂度为 $O(\max(r, c))$，我们最多需要验证 $8$ 个方向。

- 空间复杂度：$O(1)$。
### 方法一：模拟

我们可以模拟数组 `move` 中的每一步落子。我们使用两个集合 `A` 和 `B` 存放每位玩家当前已经落子的位置，并用集合 `wins` 存放棋子排成一条直线的所有情况（排成一行或一列各有 `3` 种，排成对角线有 `2` 种，总计 `8` 种）。当某位玩家落子时，我们枚举 `wins` 中的每一种情况，并判断该玩家是否将棋子落在了这些位置。如果满足了其中一种情况，则该玩家获胜。

如果直到落子完毕仍然没有玩家获胜，那么根据数组 `move` 的长度返回平局 `Draw` 或游戏未结束 `Pending`。

```C++ [sol1]
class Solution {
public:
    bool checkwin(unordered_set<int>& S, vector<vector<int>>& wins) {
        for (auto win: wins) {
            bool flag = true;
            for (auto pos: win) {
                if (!S.count(pos)) {
                    flag = false;
                    break;
                }
            }
            if (flag) {
                return true;
            }
        }
        return false;
    }

    string tictactoe(vector<vector<int>>& moves) {
        vector<vector<int>> wins = {
            {0, 1, 2},
            {3, 4, 5},
            {6, 7, 8},
            {0, 3, 6},
            {1, 4, 7},
            {2, 5, 8},
            {0, 4, 8},
            {2, 4, 6}
        };

        unordered_set<int> A, B;
        for (int i = 0; i < moves.size(); ++i) {
            int pos = moves[i][0] * 3 + moves[i][1];
            if (i % 2 == 0) {
                A.insert(pos);
                if (checkwin(A, wins)) {
                    return "A";
                }
            }
            else {
                B.insert(pos);
                if (checkwin(B, wins)) {
                    return "B";
                }
            }
        }

        return (moves.size() == 9 ? "Draw" : "Pending");
    }
};
```

```Python [sol1]
class Solution:
    def tictactoe(self, moves: List[List[int]]) -> str:
        wins = [
            [(0, 0), (0, 1), (0, 2)],
            [(1, 0), (1, 1), (1, 2)],
            [(2, 0), (2, 1), (2, 2)],
            [(0, 0), (1, 0), (2, 0)],
            [(0, 1), (1, 1), (2, 1)],
            [(0, 2), (1, 2), (2, 2)],
            [(0, 0), (1, 1), (2, 2)],
            [(0, 2), (1, 1), (2, 0)],
        ]

        def checkwin(S):
            for win in wins:
                flag = True
                for pos in win:
                    if pos not in S:
                        flag = False
                        break
                if flag:
                    return True
            return False

        A, B = set(), set()
        for i, (x, y) in enumerate(moves):
            if i % 2 == 0:
                A.add((x, y))
                if checkwin(A):
                    return "A"
            else:
                B.add((x, y))
                if checkwin(B):
                    return "B"
        
        return "Draw" if len(moves) == 9 else "Pending"
```

**复杂度分析**

- 时间复杂度：$O(N^4)$，其中 $N$ 是棋盘的边长，在本题中 $N = 3$。集合 `wins` 中存放的排成一条直线的所有情况的数量为 $O(2N+2)=O(N)$，对于每一步落子我们需要遍历所有的情况，而每一种情况有 $N$ 个位置，因此时间复杂度为 $O(N^2)$。在最坏情况下，落子的数量为 $O(N^2)$，因此总时间复杂度为 $O(N^4)$。

- 空间复杂度：$O(N^2)$。集合 `wins` 占用的空间为 $O(N^2)$，而集合 `A` 和 `B` 在最坏情况下占用的空间也为 $O(N^2)$。
#### 方法一：动态规划

根据题意，我们从右下角 `"S"` 出发后，只能向上、左或左上移动，那么我们不会重复经过数组 `board` 中的位置，因此我们可以使用动态规划的方法来解决这个问题。

我们用 `dp[i][j]` 表示数组 `board` 中位置 `(i, j)` 的若干状态。由于题目要求得到从右下角到左上角的得分最大值以及最大得分方案数，因此 `dp[i][j]` 中需要存储两个状态：一个表示从右下角到位置 `(i, j)` 的得分最大值，另一个表示从右下角到位置 `(i, j)` 的最大得分方案数。如果从右下角无法到达位置 `(i, j)`（有两种情况，一是位置 `(i, j)` 是一个障碍，二是由于障碍的存在，位置 `(i, j)` 无法到达），那么 `dp[i][j]` 中的第一个状态为 `-1`。

由于我们的起始位置为右下角，因此在进行动态规划时，我们需要先转移位置 `(i, j)` 较大的状态，即外层的两重循环分别为：

```
for i = n - 1 to 1
    for j = n - 1 to 1
        // some codes...
```

那么如何写出状态转移方程呢？显然，`dp[i][j]` 可以从 `dp[i + 1][j]`、`dp[i][j + 1]` 和 `dp[i + 1][j + 1]` 这三个状态转移而来。由于 `dp[i][j]` 中存储了两个状态，直接通过 `dp[i][j] = max(...)` 的形式进行转移并不方便，因此我们可以使用一个 `update()` 函数，依次将 `dp[i + 1][j]`、`dp[i][j + 1]` 和 `dp[i + 1][j + 1]` 这三个状态作为函数的参数，更新 `dp[i][j]` 的值。

设在 `update()` 函数中的状态为 `dp[x][y]`，即我们使用状态 `dp[x][y]` 对 `dp[i][j]` 进行转移，那么会有如下三种情况：

- 若 `dp[x][y]` 中第一个状态为 `-1`，说明位置 `(x, y)` 无法到达，那么就无法对 `dp[i][j]` 进行转移；

- 若 `dp[x][y]` 和 `dp[i][j]` 的第一个状态值相等，说明 `dp[x][y]` 和之前某个参数的得分最大值相同，它们都可以作为最大得分更新 `dp[i][j]`，因此我们将 `dp[i][j]` 的第二个状态加上 `dp[x][y]` 的第二个状态的值，合并最大得分方案数；

- 若 `dp[x][y]` 和 `dp[i][j]` 的第一个状态值不等，且前者大于后者，说明 `dp[x][y]` 相较于之前的所有参数，其得分最大值更优，因此我们将 `dp[i][j]` 直接更新为 `dp[x][y]`，替换之前的得分最大值以及最大得分方案数；

在转移结束之后，如果 `dp[i][j]` 的第一个状态不为 `-1`，说明位置 `(i, j)` 可以从右下角到达，那么我们将 `dp[i][j]` 的第一个状态值加上位置 `(i, j)` 的得分，就得到了位置 `(i, j)` 的得分最大值以及最大得分方案数。

```C++ [sol1-C++]
using PII = pair<int, int>;

class Solution {
private:
    static constexpr int mod = (int)1e9 + 7;

public:
    void update(vector<vector<PII>>& dp, int n, int x, int y, int u, int v) {
        if (u >= n || v >= n || dp[u][v].first == -1) {
            return;
        }
        if (dp[u][v].first > dp[x][y].first) {
            dp[x][y] = dp[u][v];
        }
        else if (dp[u][v].first == dp[x][y].first) {
            dp[x][y].second += dp[u][v].second;
            if (dp[x][y].second >= mod) {
                dp[x][y].second -= mod;
            }
        }
    }

    vector<int> pathsWithMaxScore(vector<string>& board) {
        int n = board.size();
        vector<vector<PII>> dp(n, vector<PII>(n, {-1, 0}));
        dp[n - 1][n - 1] = {0, 1};
        for (int i = n - 1; i >= 0; --i) {
            for (int j = n - 1; j >= 0; --j) {
                if (!(i == n - 1 && j == n - 1) && board[i][j] != 'X') {
                    update(dp, n, i, j, i + 1, j);
                    update(dp, n, i, j, i, j + 1);
                    update(dp, n, i, j, i + 1, j + 1);
                    if (dp[i][j].first != -1) {
                        dp[i][j].first += (board[i][j] == 'E' ? 0 : board[i][j] - '0');
                    }
                }
            }
        }
        return dp[0][0].first == -1 ? vector<int>{0, 0} : vector<int>{dp[0][0].first, dp[0][0].second};
    }
};
```

```Python [sol1-Python3]
class Solution:
    def pathsWithMaxScore(self, board: List[str]) -> List[int]:
        n = len(board)
        dp = [[[-1, 0]] * n for _ in range(n)]
        dp[n - 1][n - 1] = [0, 1]

        def update(x, y, u, v):
            if u >= n or v >= n or dp[u][v][0] == -1:
                return
            if dp[u][v][0] > dp[x][y][0]:
                dp[x][y] = dp[u][v][:]
            elif dp[u][v][0] == dp[x][y][0]:
                dp[x][y][1] += dp[u][v][1]

        for i in range(n - 1, -1, -1):
            for j in range(n - 1, -1, -1):
                if not (i == n - 1 and j == n - 1) and board[i][j] != "X":
                    update(i, j, i + 1, j)
                    update(i, j, i, j + 1)
                    update(i, j, i + 1, j + 1)
                    if dp[i][j][0] != -1:
                        dp[i][j][0] += (0 if board[i][j] == "E" else ord(board[i][j]) - 48)
        return [dp[0][0][0], dp[0][0][1] % (10**9 + 7)] if dp[0][0][0] != -1 else [0, 0]
```

**复杂度分析**

- 时间复杂度：$O(N^2)$，其中 $N$ 是数组 `board` 的边长。

- 空间复杂度：$O(N^2)$。
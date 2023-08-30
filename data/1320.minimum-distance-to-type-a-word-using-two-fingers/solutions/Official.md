#### 方法一：动态规划

我们用 `dp[i][l][r]` 表示在输入了字符串 `word` 的第 `i` 个字母后，左手的位置为 `l`，右手的位置为 `r`，达到该状态的最小移动距离。这里的位置为指向的字母编号，例如 `A` 对应 `0`，`B` 对应 `1`，以此类推，而非字母在键盘上的位置。这样做的好处是将字母的位置映射成一个整数而非二维的坐标，使得我们更加方便地进行状态转移。

那么如何进行状态转移呢？我们首先需要看出一个非常重要的性质：对于状态 `dp[i][l][r]`，要么 `word[i] == l`，要么 `word[i] == r`，即在输入了第 `i` 个字母后，左手和右手中至少有一个在 `word[i]` 的位置。我们可以根据这两种情况，分别进行状态转移：

- 当 `word[i] == l` 时，左手在 `word[i]` 的位置。我们需要考虑在输入字符串 `word` 的第 `i - 1` 个字母时，是左手还是右手在 `word[i - 1]` 的位置：

  - 如果左手在 `word[i - 1]` 的位置，那么在输入第 `i` 个字母时，左手从 `word[i - 1]` 移动至 `word[i]`，状态转移方程为：

    ```
    dp[i][l = word[i]][r] = dp[i - 1][l0 = word[i - 1]][r] + dist(word[i - 1], word[i])
    ```

  - 如果右手在 `word[i - 1]` 的位置，那么由于第 `i` 个字母使用了左手，右手就没有移动，即 `word[i - 1] == r`。同时，在输入 `word[i1]` 之前的左手位置也无关紧要，可以为任意的 `l0`，状态转移方程为：

    ```
    dp[i][l = word[i]][r = word[i - 1]] = dp[i - 1][l0][r = word[i - 1]] + dist(l0, word[i])
    ```

- 当 `word[i] == r` 时，右手在 `word[i]` 的位置。我们需要考虑在输入字符串 `word` 的第 `i - 1` 个字母时，是右手还是左手在 `word[i - 1]` 的位置：

  - 如果右手在 `word[i - 1]` 的位置，那么在输入第 `i` 个字母时，右手从 `word[i - 1]` 移动至 `word[i]`，状态转移方程为：

    ```
    dp[i][l][r = word[i]] = dp[i - 1][l][r0 = word[i - 1]] + dist(word[i - 1], word[i])
    ```

  - 如果左手在 `word[i - 1]` 的位置，那么由于第 `i` 个字母使用了右手，左手就没有移动，即 `word[i - 1] == l`。同时，在输入 `word[i]` 之前的右手位置也无关紧要，可以为任意的 `r0`，状态转移方程为：

    ```
    dp[i][l = word[i - 1]][r = word[i]] = dp[i - 1][l = word[i - 1]][r0] + dist(r0, word[i])
    ```

对于每一个状态 `dp[i][l][r]`，我们取它所有转移中的最小值，即为输入了字符串 `word` 的第 `i` 个字母后，左手的位置为 `l`，右手的位置为 `r`，达到该状态的最小移动距离。

在这个动态规划中，我们还需要考虑不合法的状态以及边界状态。对于某一个不合法的状态，如果用它来进行状态转移，可能会使得 `dp[i][l][r]` 取到一个更小且不合法的值。因此，我们一般会给所有不合法的状态赋予一个非常大的值（例如 `C++` 中的整数最大值 `INT_MAX`），这样即使用它来进行状态转移，也会因为本身值非常大的缘故，对最优解没有任何影响。在考虑边界状态时，由于题目中规定两根手指的起始位置是零代价的，因此对于字符串中的第 `0` 个字母 `word[0]`，输入它的最小移动距离为 `0`。此时要么左手的位置为 `word[0]`，要么右手的位置为 `word[0]`，因此我们可以将所有的 `dp[0][l = word[0]][r]` 以及 `dp[0][l][r = word[0]]` 作为边界状态，它们的值为 `0`。

```C++ [sol1-C++]
class Solution {
public:
    int getDistance(int p, int q) {
        int x1 = p / 6, y1 = p % 6;
        int x2 = q / 6, y2 = q % 6;
        return abs(x1 - x2) + abs(y1 - y2);
    }

    int minimumDistance(string word) {
        int n = word.size();
        int dp[n][26][26];
        fill(dp[0][0], dp[0][0] + n * 26 * 26, INT_MAX >> 1);
        for (int i = 0; i < 26; ++i) {
            dp[0][i][word[0] - 'A'] = dp[0][word[0] - 'A'][i] = 0;
        }
        
        for (int i = 1; i < n; ++i) {
            int cur = word[i] - 'A';
            int prev = word[i - 1] - 'A';
            int d = getDistance(prev, cur);
            for (int j = 0; j < 26; ++j) {
                dp[i][cur][j] = min(dp[i][cur][j], dp[i - 1][prev][j] + d);
                dp[i][j][cur] = min(dp[i][j][cur], dp[i - 1][j][prev] + d);
                if (prev == j) {
                    for (int k = 0; k < 26; ++k) {
                        int d0 = getDistance(k, cur);
                        dp[i][cur][j] = min(dp[i][cur][j], dp[i - 1][k][j] + d0);
                        dp[i][j][cur] = min(dp[i][j][cur], dp[i - 1][j][k] + d0);
                    }
                }
            }
        }

        int ans = *min_element(dp[n - 1][0], dp[n - 1][0] + 26 * 26);
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minimumDistance(self, word: str) -> int:
        n = len(word)
        BIG = 2**30
        dp = [[[BIG] * 26 for x in range(26)] for y in range(n)]
        for i in range(26):
            dp[0][i][ord(word[0]) - 65] = 0
            dp[0][ord(word[0]) - 65][i] = 0
    
        def getDistance(p, q):
            x1, y1 = p // 6, p % 6
            x2, y2 = q // 6, q % 6
            return abs(x1 - x2) + abs(y1 - y2)

        for i in range(1, n):
            cur, prev = ord(word[i]) - 65, ord(word[i - 1]) - 65
            d = getDistance(prev, cur)
            for j in range(26):
                dp[i][cur][j] = min(dp[i][cur][j], dp[i - 1][prev][j] + d)
                dp[i][j][cur] = min(dp[i][j][cur], dp[i - 1][j][prev] + d)
                if prev == j:
                    for k in range(26):
                        d0 = getDistance(k, cur)
                        dp[i][cur][j] = min(dp[i][cur][j], dp[i - 1][k][j] + d0)
                        dp[i][j][cur] = min(dp[i][j][cur], dp[i - 1][j][k] + d0)
        
        ans = min(min(dp[n - 1][x]) for x in range(26))
        return ans
```

**复杂度分析**

- 时间复杂度：$O(|\Sigma|N)$，其中 $N$ 是字符串 `word` 的长度，$|\Sigma|$ 是可能出现的字母数量，在本题中 $|\Sigma| = 26$。对于状态 `dp[i][l][r]`，枚举 `i` 需要的时间复杂度为 $O(N)$，在此之后，如果 `word[i] == l`，根据上面的状态转移方程：

  - 如果左手在 `word[i - 1]` 的位置，那么单次状态转移的时间复杂度为 $O(1)$，需要对所有的 `r` 都进行转移，总时间复杂度为 $O(|\Sigma|)$；

  - 如果右手在 `word[i - 1]` 的位置，那么 `r == word[i - 1]`。虽然我们要枚举 `l0`，但是合法的 `r` 只有一个，因此总时间复杂度也为 $O(|\Sigma|)$。

  如果 `word[i] == r`，分析的过程相同，在此不再赘述。这样总时间复杂度即为 $O(|\Sigma|N)$。


- 空间复杂度：$O(|\Sigma|^2 N)$。

#### 方法二：动态规划 + 空间优化

在方法一中，我们提到了一条重要的性质：对于状态 `dp[i][l][r]`，要么 `word[i] == l`，要么 `word[i] == r`，即在输入了第 `i` 个字母后，左手和右手中至少有一个在 `word[i]` 的位置。那么对于每一个 `i`，我们其实只需要存储 $2|\Sigma|$ 而不是 $|\Sigma|^2$ 个状态。例如我们可以用 `dp[i][op][rest]` 表示状态，其中 `op` 的值只能为 `0` 或 `1`，`op == 0` 表示左手在 `word[i]` 的位置，`op == 1` 表示右手在 `word[i]` 的位置，而 `rest` 表示不在 `word[i]` 位置的另一只手的位置。这样我们在状态转移方程几乎不变的前提下，减少了动态规划需要的空间。

那么我们是否还可以继续进行优化呢？我们可以发现，在方法一中，状态转移方程具有高度对称性，那么我们可以断定，`dp[i][op = 0][rest]` 和 `dp[i][op = 1][rest]` 的值一定是相等的。这是因为 `dp[i][op = 0][rest]` 表示左手在 `word[i]` 的位置且右手在 `rest` 的位置，如果我们将左右手互换，那么我们同样可以使用 `dp[i][op = 0][rest]` 的移动距离使得右手在 `word[i]` 的位置且左手在 `rest` 的位置，而这恰好就是 `dp[i][op = 1][rest]`。

因此我们可以直接使用 `dp[i][rest]` 进行状态转移，其表示一只手在 `word[i]` 的位置，另一只手在 `rest` 的位置的最小移动距离。我们并不需要关心具体哪只手在 `word[i]` 的位置，因为两只手是完全对称的。这样以来，我们将三维的动态规划优化至了二维，大大减少了空间的使用。

```C++ [sol2-C++]
class Solution {
public:
    int getDistance(int p, int q) {
        int x1 = p / 6, y1 = p % 6;
        int x2 = q / 6, y2 = q % 6;
        return abs(x1 - x2) + abs(y1 - y2);
    }

    int minimumDistance(string word) {
        int n = word.size();
        int dp[n][26];
        fill(dp[0], dp[0] + n * 26, INT_MAX >> 1);
        fill(dp[0], dp[0] + 26, 0);
        
        for (int i = 1; i < n; ++i) {
            int cur = word[i] - 'A';
            int prev = word[i - 1] - 'A';
            int d = getDistance(prev, cur);
            for (int j = 0; j < 26; ++j) {
                dp[i][j] = min(dp[i][j], dp[i - 1][j] + d);
                if (prev == j) {
                    for (int k = 0; k < 26; ++k) {
                        int d0 = getDistance(k, cur);
                        dp[i][j] = min(dp[i][j], dp[i - 1][k] + d0);
                    }
                }
            }
        }

        int ans = *min_element(dp[n - 1], dp[n - 1] + 26);
        return ans;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def minimumDistance(self, word: str) -> int:
        n = len(word)
        BIG = 2**30
        dp = [[0] * 26] + [[BIG] * 26 for _ in range(n - 1)]
        
        def getDistance(p, q):
            x1, y1 = p // 6, p % 6
            x2, y2 = q // 6, q % 6
            return abs(x1 - x2) + abs(y1 - y2)

        for i in range(1, n):
            cur, prev = ord(word[i]) - 65, ord(word[i - 1]) - 65
            d = getDistance(prev, cur)
            for j in range(26):
                dp[i][j] = min(dp[i][j], dp[i - 1][j] + d)
                if prev == j:
                    for k in range(26):
                        d0 = getDistance(k, cur)
                        dp[i][j] = min(dp[i][j], dp[i - 1][k] + d0)

        ans = min(dp[n - 1])
        return ans
```

**复杂度分析**

- 时间复杂度：$O(|\Sigma|N)$。

- 空间复杂度：$O(|\Sigma|N)$。
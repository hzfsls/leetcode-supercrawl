#### 方法一：暴力
直接遍历所有的横，竖，对角线，反对角线线段，记录经过的最长的 1 线段。但是如果直接把横，竖，对角线，反对角线的遍历各写一遍，代码会非常冗长，难以排错。所以让我们先来研究一下这几种遍历之间有什么共性。
分析可知，要遍历任意一条线段，我们只需要给出这条线段的起点，以及遍历方向，然后让线段从起点开始，一直向遍历方向走到矩阵的边界为起点即可。无论是横，竖，对角线，还是反对角线的遍历，都遵从上述的逻辑，只是起点与方向有所不同。
接着，我们来列举一下需要考虑的起点和方向：
  * 对于横向的线段，遍历方向是向右，可能的起点是矩阵的左边界为起点的所有点。
  * 对于纵向的线段，遍历方向是向下，可能的起点是矩阵的上边界为起点的所有点。
  * 对于对角线方向的线段，遍历方向是向下向右，可能的起点是矩阵的上边界为起点的所有点，以及左边界的所有点。
  * 对于反对角线方向的线段，遍历方向是向下向左，可能的起点是矩阵的上边界为起点的所有点，以及右边界的所有点。
那我们只需要遍历这些可能的起点，并指定方向进行同样逻辑的计数即可。
```python []
class Solution:
    def overflow(self, i, j):
        return i < 0 or j < 0 or i >= len(self.m) or j >= len(self.m[0])
    
    def count(self, i, j, direction_i, direction_j):
        ans = 0
        cur = 0
        while not self.overflow(i, j):
            if self.m[i][j]:
                cur += 1
                ans = max(ans, cur)
            else:
                cur = 0
            i += direction_i
            j += direction_j
        return ans

    def longestLine(self, M: List[List[int]]) -> int:
        if not M:
            return 0
        self.m = M
        ans = 0
        for i in range(len(M)):
            # 左边界为起点，向右
            ans = max(ans, self.count(i, 0, 0, 1))
            # 左边界为起点，向右下
            ans = max(ans, self.count(i, 0, 1, 1))
            # 右边界为起点，向左下
            ans = max(ans, self.count(i, len(M[0]) - 1, 1, -1))
        for j in range(len(M[0])):
            # 上边界为起点，向下
            ans = max(ans, self.count(0, j, 1, 0))
            # 上边界为起点，向右下
            ans = max(ans, self.count(0, j, 1, 1))
            # 上边界为起点，向左下
            ans = max(ans, self.count(0, j, 1, -1))
        return ans
```
```C++ []
class Solution {
    int overflow(vector<vector<int>>& M, int i, int j) {
        return i < 0 || j < 0 || i >= M.size() or j >= M[0].size();
    }
    int count(vector<vector<int>>& M, int i, int j, int direction_i, int direction_j) {
        int ans = 0, cur = 0;
        while (!overflow(M, i, j)) {
            if (M[i][j]) {
                ++cur;
                ans = max(ans, cur);
            } else {
                cur = 0;
            }
            i += direction_i;
            j += direction_j;
        }
        return ans;
    }
public:
    int longestLine(vector<vector<int>>& M) {
        if (M.size() == 0)
            return 0;
        int ans = 0;
        for (int i = 0; i != M.size(); ++i) {
            // 左边界为起点，向右
            ans = max(ans, count(M, i, 0, 0, 1));
            // 左边界为起点，向右下
            ans = max(ans, count(M, i, 0, 1, 1));
            // 右边界为起点，向左下
            ans = max(ans, count(M, i, M[0].size() - 1, 1, -1));
        }
        for (int j = 0; j != M[0].size(); ++j) {
            // 上边界为起点，向下
            ans = max(ans, count(M, 0, j, 1, 0));
            // 上边界为起点，向右下
            ans = max(ans, count(M, 0, j, 1, 1));
            // 上边界为起点，向左下
            ans = max(ans, count(M, 0, j, 1, -1));
        }
        return ans;
    }
};
```

```Java []
class Solution {
    public boolean overflow(int[][] M, int i, int j) {
        return i < 0 || j < 0 || i >= M.length || j >= M[0].length;
    }

    public int count(int[][] M, int i, int j, int direction_i, int direction_j) {
        int ans = 0, cur = 0;
        while (!overflow(M, i, j)) {
            if (M[i][j] == 1) {
                ++cur;
                ans = Math.max(ans, cur);
            } else {
                cur = 0;
            }
            i += direction_i;
            j += direction_j;
        }
        return ans;
    }

    public int longestLine(int[][] M) {
        if (M.length == 0)
            return 0;
        int ans = 0;
        for (int i = 0; i != M.length; ++i) {
            // 左边界为起点，向右
            ans = Math.max(ans, count(M, i, 0, 0, 1));
            // 左边界为起点，向右下
            ans = Math.max(ans, count(M, i, 0, 1, 1));
            // 右边界为起点，向左下
            ans = Math.max(ans, count(M, i, M[0].length - 1, 1, -1));
        }
        for (int j = 0; j != M[0].length; ++j) {
            // 上边界为起点，向下
            ans = Math.max(ans, count(M, 0, j, 1, 0));
            // 上边界为起点，向右下
            ans = Math.max(ans, count(M, 0, j, 1, 1));
            // 上边界为起点，向左下
            ans = Math.max(ans, count(M, 0, j, 1, -1));
        }
        return ans;
    }
}
```

**复杂度分析**
  * 时间复杂度：$O(mn)$，$m$ 为矩阵行数，$n$ 为矩阵列数。
  分析复杂度时只需要考虑程序到底遍历过多少个数字。显然每次 `count` 函数内部遍历的数字是不重叠的，而 `count` 函数被运行了六次，因此程序对每个数字最多只会经过 6 次。6 为常数，所以时间复杂度为数字的个数 $O(mn)$。
  * 空间复杂度：$O(1)$
  遍历过程只需要创建常数个指针，不需要另外的空间。

#### 方法二：二维动态规划
设 `dp[i][j]` 代表以矩阵第 `i` 行，第 `j` 列结尾的连续 1 线段的长度。那么我们需要记录四个 dp 矩阵：横，竖，对角线，以及反对角线分别需要一个 dp 矩阵来记录。
  * 横向 dp 矩阵仅需要考虑其左边的连续 1 线段，即 `dp[i][j - 1]`。
  * 纵向 dp 矩阵仅需要考虑其上边的连续 1 线段，即 `dp[i - 1][j]`。
  * 对角线方向 dp 矩阵仅需要考虑其左上的连续 1 线段，即 `dp[i - 1][j - 1]`。
  * 反对角线方向 dp 矩阵仅需要考虑其右上的连续 1 线段，即 `dp[i - 1][j + 1]`。

```python []
class Solution:
    def longestLine(self, M: List[List[int]]) -> int:
        ans = 0
        horizontal, vertical, diagonal, antidiagonal = [], [], [], []
        for i, l in enumerate(M):
            horizontal.append([])
            vertical.append([])
            diagonal.append([])
            antidiagonal.append([])
            for j, n in enumerate(l):
                if n == 0:
                    horizontal[i].append(0)
                    vertical[i].append(0)
                    diagonal[i].append(0)
                    antidiagonal[i].append(0)
                else:
                    horizontal[i].append(horizontal[i][j - 1] + 1 if j > 0 else 1)
                    vertical[i].append(vertical[i - 1][j] + 1 if i > 0 else 1)
                    diagonal[i].append(diagonal[i - 1][j - 1] + 1 if i > 0 and j > 0 else 1)
                    antidiagonal[i].append(antidiagonal[i - 1][j + 1] + 1 if i > 0 and j < len(M[0]) - 1 else 1)
                    ans = max(ans, horizontal[i][j])
                    ans = max(ans, vertical[i][j])
                    ans = max(ans, diagonal[i][j])
                    ans = max(ans, antidiagonal[i][j])
        return ans
```
```C++ []
class Solution {
public:
    int longestLine(vector<vector<int>>& M) {
        if (M.empty())
            return 0;
        int ans = 0;
        int horizontal[M.size()][M[0].size()] = {0};
        int vertical[M.size()][M[0].size()] = {0};
        int diagonal[M.size()][M[0].size()] = {0};
        int antidiagonal[M.size()][M[0].size()] = {0};
        for (int i = 0; i != M.size(); ++i) {
            for (int j = 0; j != M[0].size(); ++j) {
                if (M[i][j] == 0) {
                    horizontal[i][j] = 0;
                    vertical[i][j] = 0;
                    diagonal[i][j] = 0;
                    antidiagonal[i][j] = 0;
                } else {
                    horizontal[i][j] = j > 0 ? horizontal[i][j - 1] + 1 : 1;
                    vertical[i][j] = i > 0 ? vertical[i - 1][j] + 1 : 1;
                    diagonal[i][j] = i > 0 && j > 0 ? diagonal[i - 1][j - 1] + 1 : 1;
                    antidiagonal[i][j] = i > 0 && j < M[0].size() - 1 ? antidiagonal[i - 1][j + 1] + 1 : 1;
                    ans = max(ans, horizontal[i][j]);
                    ans = max(ans, vertical[i][j]);
                    ans = max(ans, diagonal[i][j]);
                    ans = max(ans, antidiagonal[i][j]);
                }
            }
        }
        return ans;
    }
};
```

```Java []
class Solution {
    public int longestLine(int[][] M) {
        if (M == null || M.length == 0 || M[0].length == 0)
            return 0;
        int ans = 0;
        int[][] horizontal = new int[M.length][M[0].length];
        int[][] vertical = new int[M.length][M[0].length];
        int[][] diagonal = new int[M.length][M[0].length];
        int[][] antidiagonal = new int[M.length][M[0].length];
        for (int i = 0; i != M.length; ++i) {
            for (int j = 0; j != M[0].length; ++j) {
                if (M[i][j] == 0) {
                    horizontal[i][j] = 0;
                    vertical[i][j] = 0;
                    diagonal[i][j] = 0;
                    antidiagonal[i][j] = 0;
                } else {
                    horizontal[i][j] = j > 0 ? horizontal[i][j - 1] + 1 : 1;
                    vertical[i][j] = i > 0 ? vertical[i - 1][j] + 1 : 1;
                    diagonal[i][j] = i > 0 && j > 0 ? diagonal[i - 1][j - 1] + 1 : 1;
                    antidiagonal[i][j] = i > 0 && j < M[0].length - 1 ? antidiagonal[i - 1][j + 1] + 1 : 1;
                    ans = Math.max(ans, horizontal[i][j]);
                    ans = Math.max(ans, vertical[i][j]);
                    ans = Math.max(ans, diagonal[i][j]);
                    ans = Math.max(ans, antidiagonal[i][j]);
                }
            }
        }
        return ans;
    }
}
```

**复杂度分析**
  * 时间复杂度：$O(mn)$，$m$ 为矩阵行数，$n$ 为矩阵列数。
  动态规划矩阵大小为 $O(mn)$，遍历计算每个位置的值需要 $O(mn)$ 的时间。
  * 空间复杂度：$O(mn)$，$m$ 为矩阵行数，$n$ 为矩阵列数。
  动态规划矩阵大小为 $O(mn)$，矩阵共有 4 个。4 为常数，因此空间复杂度为 $O(mn)$。

#### 方法三：一维动态规划
在方法二中，`dp` 数组中的每一个位置的值只依赖于上一行。因此不需要将整个矩阵的结果全部存储，只需要保留上一行的结果即可。而对于横向的 dp 数组，由于其不依赖于上一行，上一行的结果也可以不存储。这样可以达到节省空间的效果。
```python []
class Solution:
    def longestLine(self, M: List[List[int]]) -> int:
        ans = 0
        for i, l in enumerate(M):
            horizontal = []
            vertical_new = []
            diagonal_new = []
            antidiagonal_new = []
            for j, n in enumerate(l):
                if n == 0:
                    horizontal.append(0)
                    vertical_new.append(0)
                    diagonal_new.append(0)
                    antidiagonal_new.append(0)
                else:
                    horizontal.append(horizontal[j - 1] + 1 if j > 0 else 1)
                    vertical_new.append(vertical[j] + 1 if i > 0 else 1)
                    diagonal_new.append(diagonal[j - 1] + 1 if i > 0 and j > 0 else 1)
                    antidiagonal_new.append(antidiagonal[j + 1] + 1 if i > 0 and j < len(M[0]) - 1 else 1)
                    ans = max(ans, horizontal[j])
                    ans = max(ans, vertical_new[j])
                    ans = max(ans, diagonal_new[j])
                    ans = max(ans, antidiagonal_new[j])
            vertical = vertical_new
            diagonal = diagonal_new
            antidiagonal = antidiagonal_new
        return ans
```
```C++ []
class Solution {
public:
    int longestLine(vector<vector<int>>& M) {
        if (M.empty())
            return 0;
        int ans = 0;
        int* horizontal = new int[M[0].size()];
        int* vertical = new int[M[0].size()];
        int* diagonal = new int[M[0].size()];
        int* antidiagonal = new int[M[0].size()];
        for (int i = 0; i != M.size(); ++i) {
            int* vertical_new = new int[M[0].size()];
            int* diagonal_new = new int[M[0].size()];
            int* antidiagonal_new = new int[M[0].size()];
            for (int j = 0; j != M[0].size(); ++j) {
                if (M[i][j] == 0) {
                    horizontal[j] = 0;
                    vertical_new[j] = 0;
                    diagonal_new[j] = 0;
                    antidiagonal_new[j] = 0;
                } else {
                    horizontal[j] = j > 0 ? horizontal[j - 1] + 1 : 1;
                    vertical_new[j] = i > 0 ? vertical[j] + 1 : 1;
                    diagonal_new[j] = i > 0 && j > 0 ? diagonal[j - 1] + 1 : 1;
                    antidiagonal_new[j] = i > 0 && j < M[0].size() - 1 ? antidiagonal[j + 1] + 1 : 1;
                    ans = max(ans, horizontal[j]);
                    ans = max(ans, vertical_new[j]);
                    ans = max(ans, diagonal_new[j]);
                    ans = max(ans, antidiagonal_new[j]);
                }
            }
            delete[] vertical;
            delete[] diagonal;
            delete[] antidiagonal;
            vertical = vertical_new;
            diagonal = diagonal_new;
            antidiagonal = antidiagonal_new;
        }
        return ans;
    }
};
```

```Java []
class Solution {
    public int longestLine(int[][] M) {
        if (M == null || M.length == 0 || M[0].length == 0)
            return 0;
        int ans = 0;
        int[] horizontal = new int[M[0].length];
        int[] vertical = new int[M[0].length];
        int[] diagonal = new int[M[0].length];
        int[] antidiagonal = new int[M[0].length];
        for (int i = 0; i != M.length; ++i) {
            int[] vertical_new = new int[M[0].length];
            int[] diagonal_new = new int[M[0].length];
            int[] antidiagonal_new = new int[M[0].length];
            for (int j = 0; j != M[0].length; ++j) {
                if (M[i][j] == 0) {
                    horizontal[j] = 0;
                    vertical_new[j] = 0;
                    diagonal_new[j] = 0;
                    antidiagonal_new[j] = 0;
                } else {
                    horizontal[j] = j > 0 ? horizontal[j - 1] + 1 : 1;
                    vertical_new[j] = i > 0 ? vertical[j] + 1 : 1;
                    diagonal_new[j] = i > 0 && j > 0 ? diagonal[j - 1] + 1 : 1;
                    antidiagonal_new[j] = i > 0 && j < M[0].length - 1 ? antidiagonal[j + 1] + 1 : 1;
                    ans = Math.max(ans, horizontal[j]);
                    ans = Math.max(ans, vertical_new[j]);
                    ans = Math.max(ans, diagonal_new[j]);
                    ans = Math.max(ans, antidiagonal_new[j]);
                }
            }
            vertical = vertical_new;
            diagonal = diagonal_new;
            antidiagonal = antidiagonal_new;
        }
        return ans;
    }
}
```

**复杂度分析**
  * 时间复杂度：$O(mn)$，$m$ 为矩阵行数，$n$ 为矩阵列数。
  动态规划需要计算的解的数量与解法二相同，为 $O(mn)$。
  * 空间复杂度：$O(n)$，$n$ 为矩阵列数。
  动态规划数组大小为 $O(n)$，同一时间数组最多存在 8 个。8 为常数，因此空间复杂度为 $O(n)$。

**预备知识**

本题需要用到一些位运算的知识：

- 对于十进制整数 `x`，我们可以用 `x & 1` 得到 `x` 的二进制表示的最低位，它等价于 `x % 2`：

  - 例如当 `x = 3` 时，`x` 的二进制表示为 `11`，`x & 1` 的值为 `1`；

  - 例如当 `x = 6` 时，`x` 的二进制表示为 `110`，`x & 1` 的值为 `0`。

- 对于十进制整数 `x`，我们可以用 `x & (1 << k)` 来判断 `x` 二进制表示的第 `k` 位（最低位为第 `0` 位）是否为 `1`。如果该表达式的值大于零，那么第 `k` 位为 `1`：

  - 例如当 `x = 3` 时，`x` 的二进制表示为 `11`，`x & (1 << 1) = 11 & 10 = 10 > 0`，说明第 `1` 位为 `1`；

  - 例如当 `x = 5` 时，`x` 的二进制表示为 `101`，`x & (1 << 1) = 101 & 10 = 0`，说明第 `1` 位不为 `1`。

**方法一：广度优先搜索**

由于题目需要我们求出将矩阵 `mat` 变为全零矩阵的最少翻转次数，因此一种合适的方法是使用广度优先搜索。我们把起始状态加入队列，每次取出队首的状态，并搜索其相邻的状态。如果相邻的状态未被搜索过，则将其加入队尾，直至搜索到全零状态。

然而本题的状态表示是一个二维矩阵。如果将二维矩阵直接作为状态进行存储，会占用较多空间，并且不容易判断其是否被搜索过：在 `Python` 语言中，可以使用 `set()` 存储和判断这些二维矩阵，但在 `Java` 和 `C++` 中实现起来较为复杂。因此我们需要考虑将二维矩阵与语言中的内置类型进行映射。

一种简单的方法是将二维矩阵按照行优先的顺序展开，看成一个十进制整数的二进制表示。例如矩阵

```
[0,0,1]
[1,0,0]
[0,1,1]
```

将其按照行优先的顺序展开可以得到

```
[0,0,1,1,0,0,0,1,1]
```

再看成一个二进制表示

```
001100011
```

即为十进制整数 `99`。这样我们就设计了一种从二维矩阵到整数的映射方法，可以看出此映射是单射，因此就可以使用哈希集合（HashSet）来存储已经被搜索过的状态了。综上所述，我们需要实现如下函数：

- 函数 `encode(mat) -> x`，将二维矩阵 `mat` 映射成十进制整数 `x`。具体地，我们按照行优先的顺序遍历 `mat`，并使用二进制转十进制的方法即可得到 `x`；

- 函数 `decode(x) -> mat`，将十进制整数 `x` 映射成二维矩阵 `mat`。具体地，我们每次取出 `x` 二进制表示的最低位，依次填入 `mat` 中，填入的顺序为行优先顺序的反序。

实现了这两个函数之后，广度优先搜索的部分就很容易了。我们首先对初始状态调用 `encode()` 并加入队列。在搜索过程中，我们依次取出队首的状态，调用 `decode()` 得到二维矩阵，枚举二维矩阵中的每个位置进行翻转。对于每个翻转后的状态，我们调用 `encode()` 函数，通过哈希集合判断该状态是否被搜索过。如果未被搜索，则将其加入队尾。当搜索到全零状态，即 `encode()` 的值也为 `0` 时，搜索结束。

```C++ [sol1]
class Solution {
private:
    static constexpr int dirs[5][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}, {0, 0}};

public:
    int encode(const vector<vector<int>>& mat, int m, int n) {
        int x = 0;
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                x = x * 2 + mat[i][j];
            }
        }
        return x;
    }

    vector<vector<int>> decode(int x, int m, int n) {
        vector<vector<int>> mat(m, vector<int>(n));
        for (int i = m - 1; i >= 0; --i) {
            for (int j = n - 1; j >= 0; --j) {
                mat[i][j] = x & 1;
                x >>= 1;
            }
        }
        return mat;
    }

    void convert(vector<vector<int>>& mat, int m, int n, int i, int j) {
        for (int k = 0; k < 5; ++k) {
            int i0 = i + dirs[k][0], j0 = j + dirs[k][1];
            if (i0 >= 0 && i0 < m && j0 >= 0 && j0 < n) {
                mat[i0][j0] ^= 1;
            }
        }
    }

    int minFlips(vector<vector<int>>& mat) {
        int m = mat.size(), n = mat[0].size();
        int x_start = encode(mat, m, n), step = 0;
        if (x_start == 0) {
            return step;
        }

        unordered_set<int> visited;
        queue<int> q;
        visited.insert(x_start);
        q.push(x_start);

        while (!q.empty()) {
            ++step;
            int k = q.size();
            for (int _ = 0; _ < k; ++_) {
                vector<vector<int>> status = decode(q.front(), m, n);
                q.pop();
                for (int i = 0; i < m; ++i) {
                    for (int j = 0; j < n; ++j) {
                        convert(status, m, n, i, j);
                        int x_cur = encode(status, m, n);
                        if (x_cur == 0) {
                            return step;
                        }
                        if (!visited.count(x_cur)) {
                            visited.insert(x_cur);
                            q.push(x_cur);
                        }
                        convert(status, m, n, i, j);
                    }
                }
            }
        }

        return -1;
    }
};
```

```Python [sol1]
class Solution:
    def encode(self, mat, m, n):
        x = 0
        for i in range(m):
            for j in range(n):
                x = x * 2 + mat[i][j]
        return x

    def decode(self, x, m, n):
        mat = [[0] * n for _ in range(m)]
        for i in range(m - 1, -1, -1):
            for j in range(n - 1, -1, -1):
                mat[i][j] = x & 1
                x >>= 1
        return mat

    def convert(self, mat, m, n, i, j):
        for di, dj in [(-1, 0), (1, 0), (0, -1), (0, 1), (0, 0)]:
            i0, j0 = i + di, j + dj
            if 0 <= i0 < m and 0 <= j0 < n:
                mat[i0][j0] ^= 1

    def minFlips(self, mat: List[List[int]]) -> int:
        m, n = len(mat), len(mat[0])
        x_start, step = self.encode(mat, m, n), 0
        if x_start == 0:
            return step

        visited = {x_start}
        q = queue.Queue()
        q.put_nowait(x_start)

        while not q.empty():
            step += 1
            k = q.qsize()
            for _ in range(k):
                status = self.decode(q.get_nowait(), m, n)
                for i in range(m):
                    for j in range(n):
                        self.convert(status, m, n, i, j)
                        x_cur = self.encode(status, m, n)
                        if x_cur == 0:
                            return step
                        if x_cur not in visited:
                            visited.add(x_cur)
                            q.put_nowait(x_cur)
                        self.convert(status, m, n, i, j)

        return -1
```

**复杂度分析**

- 时间复杂度：$O(2^{MN} * MN)$。二维矩阵 `mat` 中的每个位置可以为 `0` 或 `1`，则二维矩阵的总数目为 $O(2^{MN})$。对于每个矩阵，我们在搜索时都会枚举其中的所有位置进行翻转，枚举的时间复杂度为 $O(MN)$。因此总的时间复杂度为 $O(2^{MN} * MN)$。

- 空间复杂度：$O(2^{MN})$。我们将二维矩阵映射为整数后，空间复杂度在数量级上就等同于矩阵的总数目了。

**方法二：深度优先搜索**

假设二维矩阵 `mat` 经过 `k` 次翻转操作 `T1, T2, ..., Tk` 后变成全零矩阵，且 `k` 是最少的翻转次数，那么我们可以发现如下两个性质：

- **顺序无关性：** 将这 `k` 次翻转操作任意打乱顺序，再从二维矩阵 `mat` 开始依次进行这些翻转操作，最后仍然会得到全零矩阵。证明如下：对于 `mat` 中的任意位置 `(x, y)`，假设 `T1, T2, ..., Tk` 中有 `c` 次翻转操作会将其进行翻转，那么无论操作的顺序怎么被打乱，位置 `(x, y)` 被翻转的次数总是为 `c` 次，即位置 `(x, y)` 的最终状态不会受到操作顺序的影响。

- **翻转唯一性：** 这 `k` 次翻转操作中，不会有两次翻转操作选择了相同的位置。证明方法类似：对于 `mat` 中的任意位置 `(x, y)`，假设 `T1, T2, ..., Tk` 中有 `c` 次翻转操作会将其进行翻转，如果有两次翻转操作选择了相同的位置，那么将它们一起移除后，位置 `(x, y)` 要么被翻转 `c` 次，要么被翻转 `c - 2` 次。而减少一个位置 `2` 次翻转次数，对该位置不会有任何影响，即位置 `(x, y)` 的最终状态不会受到移除这两次翻转操作的影响。这样我们只使用 `k - 2` 次翻转操作，就可以得到全零矩阵，与 `k` 是最少的翻转次数矛盾。

根据上面两个结论，我们可以发现：对于二维矩阵 `mat`，如果我们希望它通过最少的翻转操作得到全零矩阵，那么 `mat` 中每个位置至多被翻转一次，并且翻转的顺序不会影响最终的结果。这样以来，翻转的方法一共只有 $2^{MN}$ 种，即对于 `mat` 中的每个位置，可以选择翻转或不翻转 `2` 种情况，位置的数量为 $MN$。

因此我们可以使用深度优先搜索来枚举所有的翻转方法。我们按照行优先的顺序搜索二维矩阵 `mat` 中的每个位置，对于当前位置，我们可以选择翻转或不翻转。当搜索完 `mat` 的所有位置时，如果 `mat` 变成了全零矩阵，那么我们就找到了一种满足要求的翻转方法。在所有满足要求的方法中，操作次数最少的即为答案。

```C++ [sol2]
class Solution {
private:
    static constexpr int dirs[5][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}, {0, 0}};
    int ans;

public:
    Solution(): ans(1e9) {

    }

    void convert(vector<vector<int>>& mat, int m, int n, int i, int j) {
        for (int k = 0; k < 5; ++k) {
            int i0 = i + dirs[k][0], j0 = j + dirs[k][1];
            if (i0 >= 0 && i0 < m && j0 >= 0 && j0 < n) {
                mat[i0][j0] ^= 1;
            }
        }
    }

    void dfs(vector<vector<int>>& mat, int m, int n, int pos, int flip_cnt) {
        if (pos == m * n) {
            bool flag = true;
            for (int i = 0; i < m; ++i) {
                for (int j = 0; j < n; ++j) {
                    if (mat[i][j] != 0) {
                        flag = false;
                    }
                }
            }
            if (flag) {
                ans = min(ans, flip_cnt);
            }
            return;
        }

        int x = pos / n, y = pos % n;
        // not flip
        dfs(mat, m, n, pos + 1, flip_cnt);
        // flip
        convert(mat, m, n, x, y);
        dfs(mat, m, n, pos + 1, flip_cnt + 1);
        convert(mat, m, n, x, y);
    }

    int minFlips(vector<vector<int>>& mat) {
        int m = mat.size(), n = mat[0].size();
        dfs(mat, m, n, 0, 0);    
        return (ans != 1e9 ? ans : -1);
    }
};
```

```Python [sol2]
class Solution:
    def __init__(self):
        self.ans = 10**9

    def convert(self, mat, m, n, i, j):
        for di, dj in [(-1, 0), (1, 0), (0, -1), (0, 1), (0, 0)]:
            i0, j0 = i + di, j + dj
            if 0 <= i0 < m and 0 <= j0 < n:
                mat[i0][j0] ^= 1

    def dfs(self, mat, m, n, pos, flip_cnt):
        if pos == m * n:
            if all(mat[i][j] == 0 for i in range(m) for j in range(n)):
                self.ans = min(self.ans, flip_cnt)
            return

        x, y = pos // n, pos % n
        # not flip
        self.dfs(mat, m, n, pos + 1, flip_cnt)
        # flip
        self.convert(mat, m, n, x, y)
        self.dfs(mat, m, n, pos + 1, flip_cnt + 1)
        self.convert(mat, m, n, x, y)

    def minFlips(self, mat: List[List[int]]) -> int:
        m, n = len(mat), len(mat[0])
        self.dfs(mat, m, n, 0, 0)
        return self.ans if self.ans != 10**9 else -1
```

**复杂度分析**

- 时间复杂度：$O(2^{MN} * MN)$。翻转的方法一共有 $2^{MN}$ 种，在搜索完一种方法后，我们需要用 $O(MN)$ 的时间检查 `mat` 是否为全零矩阵。因此总时间复杂度为 $O(2^{MN} * MN)$。

- 空间复杂度：$O(MN)$。二维矩阵 `mat` 中有 $MN$ 个位置，那么深度优先搜索的层数（栈的深度）为 $MN$。在每一层搜索中，我们只使用了常数大小的空间，因此空间复杂度为 $O(MN)$。

**方法三：深度优先搜索 + 可行性判定优化**

在方法二中，我们使用深度优先搜索枚举了所有可能的翻转方法。在这些翻转方法中，满足要求且操作次数最少的即为答案。

然而真的有必要枚举所有的方法吗？考虑下面这个例子，二维矩阵 `mat` 的初始值为：

```
010
100
011
```

在某一时刻，我们搜索完了第一行的三个位置：`(0, 0)` 翻转；`(0, 1)` 不翻转；`(0, 2)` 翻转，那么 `mat` 会变为：

```
  000        110        101
  100   ->   000   ->   001
  011        011        011
初始状态   翻转(0, 0)  翻转(0, 2)
```

我们接下来需要选择位置 `(1, 0)` 是否翻转。由于位置 `(0, 0)` 的值为 `1`，而 `(1, 0)` 是唯一与位置 `(0, 0)` 相邻且还没有选择是否翻转的位置。如果位置 `(1, 0)` 不翻转，那么在接下来的搜索中，位置 `(0, 0)` 再也没有机会被翻转了，它会保持值为 `1` 不变。因此我们必须翻转位置 `(1, 0)`，得到：

```
  000        110        101        001
  100   ->   000   ->   001   ->   111
  011        011        011        111
初始状态   翻转(0, 0)  翻转(0, 2)  翻转(1, 0)
```

同理，当我们选择 `(1, 1)` 是否翻转时，考虑到位置 `(0, 1)` 的值为 `0`，如果翻转位置 `(1, 1)`，那么位置 `(0, 1)` 的值会变为 `1`，并保持到搜索结束。因此我们不能翻转位置 `(1, 1)`。

综上所述，我们可以发现，当我们在搜索完第一行之后，剩下的位置就不用进行是否翻转的选择了，因为其是否能翻转就取决于其上方位置的值。如果其上方位置的值为 `0`，那么该位置不能翻转；如果其上方位置的值为 `1`，那么该位置必须翻转。因此我们可以优化方法二中的深度优先搜索，得到一种时间复杂度更优的方法：

- 我们从按照行优先的顺序搜索二维矩阵 `mat` 中的每个位置；

- 当搜索到第一行的位置时，我们可以选择翻转或不翻转；但当搜索到第二行及以后的位置时，我们是否选择翻转取决于其上方位置的值；

- 当搜索完 `mat` 的所有位置时，我们需要判断 `mat` 的最后一行是否为 `0`。根据我们的优化方法，`mat` 中除了最后一行外的所有位置此时均为 `0`，因此只需要判断最后一行是否为 `0` 即可。

```C++ [sol3]
class Solution {
private:
    static constexpr int dirs[5][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}, {0, 0}};
    int ans;

public:
    Solution(): ans(1e9) {

    }

    void convert(vector<vector<int>>& mat, int m, int n, int i, int j) {
        for (int k = 0; k < 5; ++k) {
            int i0 = i + dirs[k][0], j0 = j + dirs[k][1];
            if (i0 >= 0 && i0 < m && j0 >= 0 && j0 < n) {
                mat[i0][j0] ^= 1;
            }
        }
    }

    void dfs(vector<vector<int>>& mat, int m, int n, int pos, int flip_cnt) {
        if (pos == m * n) {
            bool flag = true;
            for (int j = 0; j < n; ++j) {
                if (mat[m - 1][j] != 0) {
                    flag = false;
                    break;
                }
            }
            if (flag) {
                ans = min(ans, flip_cnt);
            }
            return;
        }

        int x = pos / n, y = pos % n;
        if (x == 0) {
            // in the first line we can choose either flip or not flip
            // not flip
            dfs(mat, m, n, pos + 1, flip_cnt);
            // flip
            convert(mat, m, n, x, y);
            dfs(mat, m, n, pos + 1, flip_cnt + 1);
            convert(mat, m, n, x, y);
        }
        else {
            // otherwise it depends on the upper grid
            if (mat[x - 1][y] == 0) {
                dfs(mat, m, n, pos + 1, flip_cnt);
            }
            else {
                convert(mat, m, n, x, y);
                dfs(mat, m, n, pos + 1, flip_cnt + 1);
                convert(mat, m, n, x, y);
            }
        }
    }

    int minFlips(vector<vector<int>>& mat) {
        int m = mat.size(), n = mat[0].size();
        dfs(mat, m, n, 0, 0);    
        return (ans != 1e9 ? ans : -1);
    }
};
```

```Python [sol3]
class Solution:
    def __init__(self):
        self.ans = 10**9

    def convert(self, mat, m, n, i, j):
        for di, dj in [(-1, 0), (1, 0), (0, -1), (0, 1), (0, 0)]:
            i0, j0 = i + di, j + dj
            if 0 <= i0 < m and 0 <= j0 < n:
                mat[i0][j0] ^= 1

    def dfs(self, mat, m, n, pos, flip_cnt):
        if pos == m * n:
            if all(mat[m - 1][j] == 0 for j in range(n)):
                self.ans = min(self.ans, flip_cnt)
            return

        x, y = pos // n, pos % n
        if x == 0:
            # in the first line we can choose either flip or not flip
            # not flip
            self.dfs(mat, m, n, pos + 1, flip_cnt)
            # flip
            self.convert(mat, m, n, x, y)
            self.dfs(mat, m, n, pos + 1, flip_cnt + 1)
            self.convert(mat, m, n, x, y)
        else:
            # otherwise it depends on the upper grid
            if mat[x - 1][y] == 0:
                self.dfs(mat, m, n, pos + 1, flip_cnt)
            else:
                self.convert(mat, m, n, x, y)
                self.dfs(mat, m, n, pos + 1, flip_cnt + 1)
                self.convert(mat, m, n, x, y)

    def minFlips(self, mat: List[List[int]]) -> int:
        m, n = len(mat), len(mat[0])
        self.dfs(mat, m, n, 0, 0)
        return self.ans if self.ans != 10**9 else -1
```

**复杂度分析**

- 时间复杂度：$O(2^N * MN)$。搜索第一行需要的总时间复杂度为 $O(2^N)$。在搜索第二行以及后的位置时，时间复杂度为 $O(MN)$。在搜索完一种方法后，我们需要用 $O(N)$ 的时间检查 `mat` 是否为全零矩阵，由于 $O(N) < O(MN)$，检查的时间复杂度可忽略不计。因此总时间复杂度为 $O(2^{MN} * MN)$。

- 空间复杂度：$O(MN)$。

**方法四：另一种写法**

在方法三中，当我们搜索到第二行及以后的位置时，我们的选择已经确定，这其实不能算是 “搜索” 了。因此我们可以在搜索完第一行之后，直接按照行优先的顺序遍历剩下的位置，并根据其上方位置的值来决定是否翻转。然而这样的写法不太和谐。因为我们通常只使用一个函数，通过递归调用的方式实现深度优先搜索，而此时这个函数既要实现 “搜索” 又要实现 “遍历”，显得十分突兀。

因此我们可以考虑使用非递归的形式对第一行进行搜索。第一行的 `N` 个位置共有 `2^N` 种不同的翻转方法。联想到方法一中的映射方式，我们可以把每一种翻转方法看成一个长度为 `N` 的二进制表示。二进制表示的第 `j` 位（低位在右侧，最低位为第 `0` 位）为 `1`，等价于翻转第一行的第 `j` 个位置；第 `j` 位为 `0`，等价于不翻转第一行的第 `j` 个位置。

我们只需要在十进制的意义下枚举区间 `[0, 2^N)` 中的所有整数，这 `2^N` 个整数的二进制表示对应着第一行 `N` 个位置的 `2^N` 种不同的翻转方法。在枚举了第一行的翻转方法后，我们按照行优先的顺序遍历剩下的位置，并根据其上方位置的值来决定是否翻转，在遍历完成后，判断最后一行是否均为 `0` 即可。这样以来，我们就实现了与方法三等价，但不需要使用递归的一种新的方法。

```C++ [sol4]
class Solution {
private:
    static constexpr int dirs[5][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}, {0, 0}};

public:
    void convert(vector<vector<int>>& mat, int m, int n, int i, int j) {
        for (int k = 0; k < 5; ++k) {
            int i0 = i + dirs[k][0], j0 = j + dirs[k][1];
            if (i0 >= 0 && i0 < m && j0 >= 0 && j0 < n) {
                mat[i0][j0] ^= 1;
            }
        }
    }

    int minFlips(vector<vector<int>>& mat) {
        int m = mat.size(), n = mat[0].size();
        int ans = 1e9;
        for (int bin = 0; bin < (1 << n); ++bin) {
            vector<vector<int>> mat_copy = mat;
            int flip_cnt = 0;
            for (int j = 0; j < n; ++j) {
                if (bin & (1 << j)) {
                    ++flip_cnt;
                    convert(mat_copy, m, n, 0, j);
                }
            }

            for (int i = 1; i < m; ++i) {
                for (int j = 0; j < n; ++j) {
                    if (mat_copy[i - 1][j] == 1) {
                        ++flip_cnt;
                        convert(mat_copy, m, n, i, j);
                    }
                }
            }

            bool flag = true;
            for (int j = 0; j < n; ++j) {
                if (mat_copy[m - 1][j] != 0) {
                    flag = false;
                    break;
                }
            }
            if (flag) {
                ans = min(ans, flip_cnt);
            }
        }
        return (ans != 1e9 ? ans : -1);
    }
};
```

```Python [sol4]
class Solution:
    def convert(self, mat, m, n, i, j):
        for di, dj in [(-1, 0), (1, 0), (0, -1), (0, 1), (0, 0)]:
            i0, j0 = i + di, j + dj
            if 0 <= i0 < m and 0 <= j0 < n:
                mat[i0][j0] ^= 1

    def minFlips(self, mat: List[List[int]]) -> int:
        m, n = len(mat), len(mat[0])
        ans = 1e9
        for binary in range(0, 1 << n):
            mat_copy = [line[:] for line in mat]
            flip_cnt = 0
            for j in range(n):
                if binary & (1 << j):
                    flip_cnt += 1
                    self.convert(mat_copy, m, n, 0, j)

            for i in range(1, m):
                for j in range(n):
                    if mat_copy[i - 1][j] == 1:
                        flip_cnt += 1
                        self.convert(mat_copy, m, n, i, j)

            if all(mat_copy[m - 1][j] == 0 for j in range(n)):
                ans = min(ans, flip_cnt)
        return ans if ans != 10**9 else -1
```

**复杂度分析**

- 时间复杂度：$O(2^N * MN)$。

- 空间复杂度：$O(MN)$。
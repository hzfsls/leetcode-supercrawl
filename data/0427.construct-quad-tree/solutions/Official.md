#### 方法一：递归

**思路与算法**

我们可以使用递归的方法构建出四叉树。

具体地，我们用递归函数 $\text{dfs}(r_0, c_0, r_1, c_1)$ 处理给定的矩阵 $\textit{grid}$ 从 $r_0$ 行开始到 $r_1-1$ 行，从 $c_0$ 和 $c_1-1$ 列的部分。我们首先判定这一部分是否均为 $0$ 或 $1$，如果是，那么这一部分对应的是一个叶节点，我们构造出对应的叶节点并结束递归；如果不是，那么这一部分对应的是一个非叶节点，我们需要将其分成四个部分：行的分界线为 $\dfrac{r_0+r_1}{2}$，列的分界线为 $\dfrac{c_0+c_1}{2}$，根据这两条分界线递归地调用 $\text{dfs}$ 函数得到四个部分对应的树，再将它们对应地挂在非叶节点的四个子节点上。

**代码**

```Python [sol1-Python3]
class Solution:
    def construct(self, grid: List[List[int]]) -> 'Node':
        def dfs(r0: int, c0: int, r1: int, c1: int) -> 'Node':
            if all(grid[i][j] == grid[r0][c0] for i in range(r0, r1) for j in range(c0, c1)):
                return Node(grid[r0][c0] == 1, True)
            return Node(
                True,
                False,
                dfs(r0, c0, (r0 + r1) // 2, (c0 + c1) // 2),
                dfs(r0, (c0 + c1) // 2, (r0 + r1) // 2, c1),
                dfs((r0 + r1) // 2, c0, r1, (c0 + c1) // 2),
                dfs((r0 + r1) // 2, (c0 + c1) // 2, r1, c1),
            )
        return dfs(0, 0, len(grid), len(grid))
```

```C++ [sol1-C++]
class Solution {
public:
    Node *construct(vector<vector<int>> &grid) {
        function<Node*(int, int, int, int)> dfs = [&](int r0, int c0, int r1, int c1) {
            for (int i = r0; i < r1; ++i) {
                for (int j = c0; j < c1; ++j) {
                    if (grid[i][j] != grid[r0][c0]) { // 不是叶节点
                        return new Node(
                                true,
                                false,
                                dfs(r0, c0, (r0 + r1) / 2, (c0 + c1) / 2),
                                dfs(r0, (c0 + c1) / 2, (r0 + r1) / 2, c1),
                                dfs((r0 + r1) / 2, c0, r1, (c0 + c1) / 2),
                                dfs((r0 + r1) / 2, (c0 + c1) / 2, r1, c1)
                        );
                    }
                }
            }
            // 是叶节点
            return new Node(grid[r0][c0], true);
        };
        return dfs(0, 0, grid.size(), grid.size());
    }
};
```

```Java [sol1-Java]
class Solution {
    public Node construct(int[][] grid) {
        return dfs(grid, 0, 0, grid.length, grid.length);
    }

    public Node dfs(int[][] grid, int r0, int c0, int r1, int c1) {
        boolean same = true;
        for (int i = r0; i < r1; ++i) {
            for (int j = c0; j < c1; ++j) {
                if (grid[i][j] != grid[r0][c0]) {
                    same = false;
                    break;
                }
            }
            if (!same) {
                break;
            }
        }

        if (same) {
            return new Node(grid[r0][c0] == 1, true);
        }

        Node ret = new Node(
            true,
            false,
            dfs(grid, r0, c0, (r0 + r1) / 2, (c0 + c1) / 2),
            dfs(grid, r0, (c0 + c1) / 2, (r0 + r1) / 2, c1),
            dfs(grid, (r0 + r1) / 2, c0, r1, (c0 + c1) / 2),
            dfs(grid, (r0 + r1) / 2, (c0 + c1) / 2, r1, c1)
        );
        return ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public Node Construct(int[][] grid) {
        return DFS(grid, 0, 0, grid.Length, grid.Length);
    }

    public Node DFS(int[][] grid, int r0, int c0, int r1, int c1) {
        bool same = true;
        for (int i = r0; i < r1; ++i) {
            for (int j = c0; j < c1; ++j) {
                if (grid[i][j] != grid[r0][c0]) {
                    same = false;
                    break;
                }
            }
            if (!same) {
                break;
            }
        }

        if (same) {
            return new Node(grid[r0][c0] == 1, true);
        }

        Node ret = new Node(
            true,
            false,
            DFS(grid, r0, c0, (r0 + r1) / 2, (c0 + c1) / 2),
            DFS(grid, r0, (c0 + c1) / 2, (r0 + r1) / 2, c1),
            DFS(grid, (r0 + r1) / 2, c0, r1, (c0 + c1) / 2),
            DFS(grid, (r0 + r1) / 2, (c0 + c1) / 2, r1, c1)
        );
        return ret;
    }
}
```

```go [sol1-Golang]
func construct(grid [][]int) *Node {
    var dfs func([][]int, int, int) *Node
    dfs = func(rows [][]int, c0, c1 int) *Node {
        for _, row := range rows {
            for _, v := range row[c0:c1] {
                if v != rows[0][c0] { // 不是叶节点
                    rMid, cMid := len(rows)/2, (c0+c1)/2
                    return &Node{
                        true,
                        false,
                        dfs(rows[:rMid], c0, cMid),
                        dfs(rows[:rMid], cMid, c1),
                        dfs(rows[rMid:], c0, cMid),
                        dfs(rows[rMid:], cMid, c1),
                    }
                }
            }
        }
        // 是叶节点
        return &Node{Val: rows[0][c0] == 1, IsLeaf: true}
    }
    return dfs(grid, 0, len(grid))
}
```

```JavaScript [sol1-JavaScript]
var construct = function(grid) {
    return dfs(grid, 0, 0, grid.length, grid.length);
};

const dfs = (grid, r0, c0, r1, c1) => {
    let same = true;
    for (let i = r0; i < r1; ++i) {
        for (let j = c0; j < c1; ++j) {
            if (grid[i][j] !== grid[r0][c0]) {
                same = false;
                break;
            }
        }
        if (!same) {
            break;
        }
    }

    if (same) {
        return new Node(grid[r0][c0] === 1, true);
    }

    const ret = new Node(
        true,
        false,
        dfs(grid, r0, c0, Math.floor((r0 + r1) / 2), Math.floor((c0 + c1) / 2)),
        dfs(grid, r0, Math.floor((c0 + c1) / 2), Math.floor((r0 + r1) / 2), c1),
        dfs(grid, Math.floor((r0 + r1) / 2), c0, r1, Math.floor((c0 + c1) / 2)),
        dfs(grid, Math.floor((r0 + r1) / 2), Math.floor((c0 + c1) / 2), r1, c1)
    );
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2 \log n)$。这里给出一个较为宽松的时间复杂度上界。记 $T(n)$ 为边长为 $n$ 的数组需要的时间复杂度，那么「判定这一部分是否均为 $0$ 或 $1$」需要的时间为 $O(n^2)$，在这之后会递归调用 $4$ 规模为 $n/2$ 的子问题，那么有：

    $$
    T(n) = 4T(n/2) + O(n^2)
    $$

    以及：

    $$
    T(1) = O(1)
    $$

    根据主定理，可以得到 $T(n) = O(n^2 \log n)$。但如果判定需要的时间达到了渐近紧界 $\Theta(n^2)$，那么说明这一部分包含的元素大部分都是相同的，也就是说，有很大概率在深入递归时遇到元素完全相同的一部分，从而提前结束递归。因此 $O(n^2 \log n)$ 的时间复杂度是很宽松的，实际运行过程中可以跑出与方法二 $O(n^2)$ 时间复杂度代码相似的速度。

- 空间复杂度：$O(\log n)$，即为递归需要使用的栈空间。

#### 方法二：递归 + 二维前缀和优化

**思路与算法**

我们可以对方法一中暴力判定某一部分是否均为 $0$ 或 $1$ 的代码进行优化。

具体地，当某一部分均为 $0$ 时，它的和为 $0$；某一部分均为 $1$ 时，它的和为这一部分的面积大小。因此我们可以使用二维前缀和（参考[「304. 二维区域和检索 - 矩阵不可变」](https://leetcode-cn.com/problems/range-sum-query-2d-immutable/)）进行优化。我们可以与处理出数组 $\textit{grid}$ 的二维前缀和，这样一来，当我们需要判定某一部分是否均为 $0$ 或 $1$ 时，可以在 $O(1)$ 的时间内得到这一部分的和，从而快速地进行判断。

**代码**

```Python [sol2-Python3]
class Solution:
    def construct(self, grid: List[List[int]]) -> 'Node':
        n = len(grid)
        pre = [[0] * (n + 1) for _ in range(n + 1)]
        for i in range(1, n + 1):
            for j in range(1, n + 1):
                pre[i][j] = pre[i - 1][j] + pre[i][j - 1] - pre[i - 1][j - 1] + grid[i - 1][j - 1]

        def getSum(r0: int, c0: int, r1: int, c1: int) -> int:
            return pre[r1][c1] - pre[r1][c0] - pre[r0][c1] + pre[r0][c0]

        def dfs(r0: int, c0: int, r1: int, c1: int) -> 'Node':
            total = getSum(r0, c0, r1, c1)
            if total == 0:
                return Node(False, True)
            if total == (r1 - r0) * (c1 - c0):
                return Node(True, True)
            return Node(
                True,
                False,
                dfs(r0, c0, (r0 + r1) // 2, (c0 + c1) // 2),
                dfs(r0, (c0 + c1) // 2, (r0 + r1) // 2, c1),
                dfs((r0 + r1) // 2, c0, r1, (c0 + c1) // 2),
                dfs((r0 + r1) // 2, (c0 + c1) // 2, r1, c1),
            )

        return dfs(0, 0, n, n)
```

```C++ [sol2-C++]
class Solution {
public:
    Node *construct(vector<vector<int>> &grid) {
        int n = grid.size();
        vector<vector<int>> pre(n + 1, vector<int>(n + 1));
        for (int i = 1; i <= n; ++i) {
            for (int j = 1; j <= n; ++j) {
                pre[i][j] = pre[i - 1][j] + pre[i][j - 1] - pre[i - 1][j - 1] + grid[i - 1][j - 1];
            }
        }

        auto getSum = [&](int r0, int c0, int r1, int c1) {
            return pre[r1][c1] - pre[r1][c0] - pre[r0][c1] + pre[r0][c0];
        };

        function<Node *(int, int, int, int)> dfs = [&](int r0, int c0, int r1, int c1) {
            int total = getSum(r0, c0, r1, c1);
            if (total == 0) {
                return new Node(false, true);
            }
            if (total == (r1 - r0) * (c1 - c0)) {
                return new Node(true, true);
            }
            return new Node(
                    true,
                    false,
                    dfs(r0, c0, (r0 + r1) / 2, (c0 + c1) / 2),
                    dfs(r0, (c0 + c1) / 2, (r0 + r1) / 2, c1),
                    dfs((r0 + r1) / 2, c0, r1, (c0 + c1) / 2),
                    dfs((r0 + r1) / 2, (c0 + c1) / 2, r1, c1)
            );
        };

        return dfs(0, 0, n, n);
    }
};
```

```Java [sol2-Java]
class Solution {
    public Node construct(int[][] grid) {
        int n = grid.length;
        int[][] pre = new int[n + 1][n + 1];
        for (int i = 1; i <= n; ++i) {
            for (int j = 1; j <= n; ++j) {
                pre[i][j] = pre[i - 1][j] + pre[i][j - 1] - pre[i - 1][j - 1] + grid[i - 1][j - 1];
            }
        }
        return dfs(grid, pre, 0, 0, n, n);
    }

    public Node dfs(int[][] grid, int[][] pre, int r0, int c0, int r1, int c1) {
        int total = getSum(pre, r0, c0, r1, c1);
        if (total == 0) {
            return new Node(false, true);
        } else if (total == (r1 - r0) * (c1 - c0)) {
            return new Node(true, true);
        }

        Node ret = new Node(
            true,
            false,
            dfs(grid, pre, r0, c0, (r0 + r1) / 2, (c0 + c1) / 2),
            dfs(grid, pre, r0, (c0 + c1) / 2, (r0 + r1) / 2, c1),
            dfs(grid, pre, (r0 + r1) / 2, c0, r1, (c0 + c1) / 2),
            dfs(grid, pre, (r0 + r1) / 2, (c0 + c1) / 2, r1, c1)
        );
        return ret;
    }

    public int getSum(int[][] pre, int r0, int c0, int r1, int c1) {
        return pre[r1][c1] - pre[r1][c0] - pre[r0][c1] + pre[r0][c0];
    }
}
```

```C# [sol2-C#]
public class Solution {
    public Node Construct(int[][] grid) {
        int n = grid.Length;
        int[][] pre = new int[n + 1][];
        for (int i = 0; i <= n; ++i) {
            pre[i] = new int[n + 1];
        }
        for (int i = 1; i <= n; ++i) {
            for (int j = 1; j <= n; ++j) {
                pre[i][j] = pre[i - 1][j] + pre[i][j - 1] - pre[i - 1][j - 1] + grid[i - 1][j - 1];
            }
        }
        return DFS(grid, pre, 0, 0, n, n);
    }

    public Node DFS(int[][] grid, int[][] pre, int r0, int c0, int r1, int c1) {
        int total = GetSum(pre, r0, c0, r1, c1);
        if (total == 0) {
            return new Node(false, true);
        } else if (total == (r1 - r0) * (c1 - c0)) {
            return new Node(true, true);
        }

        Node ret = new Node(
            true,
            false,
            DFS(grid, pre, r0, c0, (r0 + r1) / 2, (c0 + c1) / 2),
            DFS(grid, pre, r0, (c0 + c1) / 2, (r0 + r1) / 2, c1),
            DFS(grid, pre, (r0 + r1) / 2, c0, r1, (c0 + c1) / 2),
            DFS(grid, pre, (r0 + r1) / 2, (c0 + c1) / 2, r1, c1)
        );
        return ret;
    }

    public int GetSum(int[][] pre, int r0, int c0, int r1, int c1) {
        return pre[r1][c1] - pre[r1][c0] - pre[r0][c1] + pre[r0][c0];
    }
}
```

```go [sol2-Golang]
func construct(grid [][]int) *Node {
    n := len(grid)
    pre := make([][]int, n+1)
    pre[0] = make([]int, n+1)
    for i, row := range grid {
        pre[i+1] = make([]int, n+1)
        for j, v := range row {
            pre[i+1][j+1] = pre[i+1][j] + pre[i][j+1] - pre[i][j] + v
        }
    }

    var dfs func(r0, c0, r1, c1 int) *Node
    dfs = func(r0, c0, r1, c1 int) *Node {
        total := pre[r1][c1] - pre[r1][c0] - pre[r0][c1] + pre[r0][c0]
        if total == 0 {
            return &Node{Val: false, IsLeaf: true}
        }
        if total == (r1-r0)*(c1-c0) {
            return &Node{Val: true, IsLeaf: true}
        }
        rMid, cMid := (r0+r1)/2, (c0+c1)/2
        return &Node{
            true,
            false,
            dfs(r0, c0, rMid, cMid),
            dfs(r0, cMid, rMid, c1),
            dfs(rMid, c0, r1, cMid),
            dfs(rMid, cMid, r1, c1),
        }
    }
    return dfs(0, 0, n, n)
}
```

```JavaScript [sol2-JavaScript]
var construct = function(grid) {
    const n = grid.length;
    const pre = new Array(n + 1).fill(0).map(() => new Array(n + 1).fill(0));
    for (let i = 1; i <= n; ++i) {
        for (let j = 1; j <= n; ++j) {
            pre[i][j] = pre[i - 1][j] + pre[i][j - 1] - pre[i - 1][j - 1] + grid[i - 1][j - 1];
        }
    }
    return dfs(grid, pre, 0, 0, n, n);
};

const dfs = (grid, pre, r0, c0, r1, c1) => {
    const total = getSum(pre, r0, c0, r1, c1);
    if (total === 0) {
        return new Node(false, true);
    } else if (total === (r1 - r0) * (c1 - c0)) {
        return new Node(true, true);
    }

    const ret = new Node(
        true,
        false,
        dfs(grid, pre, r0, c0, Math.floor((r0 + r1) / 2), Math.floor((c0 + c1) / 2)),
        dfs(grid, pre, r0, Math.floor((c0 + c1) / 2), Math.floor((r0 + r1) / 2), c1),
        dfs(grid, pre, Math.floor((r0 + r1) / 2), c0, r1, Math.floor((c0 + c1) / 2)),
        dfs(grid, pre, Math.floor((r0 + r1) / 2), Math.floor((c0 + c1) / 2), r1, c1)
    );
    return ret;
}

const getSum = (pre, r0, c0, r1, c1) => {
    return pre[r1][c1] - pre[r1][c0] - pre[r0][c1] + pre[r0][c0];
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$。在最坏情况下，数组 $\textit{grid}$ 中交替出现 $0$ 和 $1$，此时每一个叶节点对应着 $1 \times 1$ 的区域。记 $T(n)$ 为边长为 $n$ 的数组需要的时间复杂度，那么有： 

    $$
    T(n) = 4T(n/2) + O(1)
    $$

    以及：

    $$
    T(1) = O(1)
    $$

    根据主定理，可以得到 $T(n) = O(n^2)$。预处理二维前缀和需要的时间也为 $O(n^2)$，因此总时间复杂度为 $O(n^2)$。

- 空间复杂度：$O(n^2)$，即为二维前缀和需要使用的空间。
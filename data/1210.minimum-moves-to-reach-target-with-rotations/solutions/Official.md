#### 方法一：广度优先搜索

**思路与算法**

如果不考虑蛇的旋转，我们可以使用广度优先搜索的方法：即队列中存放蛇尾的坐标 $(x, y)$，每次从队列中取出一个坐标时，尝试向右移动一个单元格到 $(x, y+1)$，或向下移动一个单元格到 $(x+1, y)$。最后返回到 $(n-1, n-2)$ 最少需要的步数即可。

> 广度优先搜索方法的正确性在于：我们一定不会到达同一个位置两次及以上，因为这样必定不是最少的移动次数。

当考虑蛇的旋转时，我们可以有类似的结论。我们可以将蛇的状态本身与 $(x, y)$ 一起形成一个三元组 $(x, y, \textit{status})$。这样一来，我们一定不会到达同一个三元组两次及以上。其中 $\textit{status}$ 的值为 $0/1$，$0$ 表示水平状态，$1$ 表示竖直状态。

因此，我们仍然可以使用广度优先搜索的方法解决本题。当 $\textit{status} = 0$ 时，需要考虑「向右移动」「向下移动」「顺时针旋转」三种情况；当 $\textit{status} = 1$ 时，需要考虑「向右移动」「向下移动」「逆时针旋转」三种情况。读者可以自行思考每一种情况并编写代码，也可以参考下面的文字提示：

> 需要注意的是，$(x, y)$ 表示的是蛇尾坐标，这样的好处在于在进行旋转操作时，无需进行坐标的转换。

- 当 $\textit{status} = 0$ 时：

    - 「向右移动」：需要保证 $(x, y+2)$ 是空的单元格；
    - 「向下移动」：需要保证 $(x+1, y)$ 和 $(x+1, y+1)$ 均是空的单元格；
    - 「顺时针旋转」：需要保证 $(x+1, y)$ 和 $(x+1, y+1)$ 均是空的单元格。

- 当 $\textit{status} = 1$ 时：

    - 「向右移动」：需要保证 $(x, y+1)$ 和 $(x+1, y+1)$ 均是空的单元格；
    - 「向下移动」：需要保证 $(x+2, y)$ 是空的单元格；
    - 「逆时针旋转」：需要保证 $(x, y+1)$ 和 $(x+1, y+1)$ 均是空的单元格。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minimumMoves(vector<vector<int>>& grid) {
        int n = grid.size();
        vector<vector<array<int, 2>>> dist(n, vector<array<int, 2>>(n, {-1, -1}));
        dist[0][0][0] = 0;
        queue<tuple<int, int, int>> q;
        q.emplace(0, 0, 0);

        while (!q.empty()) {
            auto [x, y, status] = q.front();
            q.pop();
            if (status == 0) {
                // 向右移动一个单元格
                if (y + 2 < n && dist[x][y + 1][0] == -1 && grid[x][y + 2] == 0) {
                    dist[x][y + 1][0] = dist[x][y][0] + 1;
                    q.emplace(x, y + 1, 0);
                }
                // 向下移动一个单元格
                if (x + 1 < n && dist[x + 1][y][0] == -1 && grid[x + 1][y] == 0 && grid[x + 1][y + 1] == 0) {
                    dist[x + 1][y][0] = dist[x][y][0] + 1;
                    q.emplace(x + 1, y, 0);
                }
                // 顺时针旋转 90 度
                if (x + 1 < n && y + 1 < n && dist[x][y][1] == -1 && grid[x + 1][y] == 0 && grid[x + 1][y + 1] == 0) {
                    dist[x][y][1] = dist[x][y][0] + 1;
                    q.emplace(x, y, 1);
                }
            }
            else {
                // 向右移动一个单元格
                if (y + 1 < n && dist[x][y + 1][1] == -1 && grid[x][y + 1] == 0 && grid[x + 1][y + 1] == 0) {
                    dist[x][y + 1][1] = dist[x][y][1] + 1;
                    q.emplace(x, y + 1, 1);
                }
                // 向下移动一个单元格
                if (x + 2 < n && dist[x + 1][y][1] == -1 && grid[x + 2][y] == 0) {
                    dist[x + 1][y][1] = dist[x][y][1] + 1;
                    q.emplace(x + 1, y, 1);
                }
                // 逆时针旋转 90 度
                if (x + 1 < n && y + 1 < n && dist[x][y][0] == -1 && grid[x][y + 1] == 0 && grid[x + 1][y + 1] == 0) {
                    dist[x][y][0] = dist[x][y][1] + 1;
                    q.emplace(x, y, 0);
                }
            }
        }

        return dist[n - 1][n - 2][0];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minimumMoves(int[][] grid) {
        int n = grid.length;
        int[][][] dist = new int[n][n][2];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                Arrays.fill(dist[i][j], -1);
            }
        }
        dist[0][0][0] = 0;
        Queue<int[]> queue = new ArrayDeque<int[]>();
        queue.offer(new int[]{0, 0, 0});

        while (!queue.isEmpty()) {
            int[] arr = queue.poll();
            int x = arr[0], y = arr[1], status = arr[2];
            if (status == 0) {
                // 向右移动一个单元格
                if (y + 2 < n && dist[x][y + 1][0] == -1 && grid[x][y + 2] == 0) {
                    dist[x][y + 1][0] = dist[x][y][0] + 1;
                    queue.offer(new int[]{x, y + 1, 0});
                }
                // 向下移动一个单元格
                if (x + 1 < n && dist[x + 1][y][0] == -1 && grid[x + 1][y] == 0 && grid[x + 1][y + 1] == 0) {
                    dist[x + 1][y][0] = dist[x][y][0] + 1;
                    queue.offer(new int[]{x + 1, y, 0});
                }
                // 顺时针旋转 90 度
                if (x + 1 < n && y + 1 < n && dist[x][y][1] == -1 && grid[x + 1][y] == 0 && grid[x + 1][y + 1] == 0) {
                    dist[x][y][1] = dist[x][y][0] + 1;
                    queue.offer(new int[]{x, y, 1});
                }
            } else {
                // 向右移动一个单元格
                if (y + 1 < n && dist[x][y + 1][1] == -1 && grid[x][y + 1] == 0 && grid[x + 1][y + 1] == 0) {
                    dist[x][y + 1][1] = dist[x][y][1] + 1;
                    queue.offer(new int[]{x, y + 1, 1});
                }
                // 向下移动一个单元格
                if (x + 2 < n && dist[x + 1][y][1] == -1 && grid[x + 2][y] == 0) {
                    dist[x + 1][y][1] = dist[x][y][1] + 1;
                    queue.offer(new int[]{x + 1, y, 1});
                }
                // 逆时针旋转 90 度
                if (x + 1 < n && y + 1 < n && dist[x][y][0] == -1 && grid[x][y + 1] == 0 && grid[x + 1][y + 1] == 0) {
                    dist[x][y][0] = dist[x][y][1] + 1;
                    queue.offer(new int[]{x, y, 0});
                }
            }
        }

        return dist[n - 1][n - 2][0];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinimumMoves(int[][] grid) {
        int n = grid.Length;
        int[][][] dist = new int[n][][];
        for (int i = 0; i < n; i++) {
            dist[i] = new int[n][];
            for (int j = 0; j < n; j++) {
                dist[i][j] = new int[2];
                Array.Fill(dist[i][j], -1);
            }
        }
        dist[0][0][0] = 0;
        Queue<Tuple<int, int, int>> queue = new Queue<Tuple<int, int, int>>();
        queue.Enqueue(new Tuple<int, int, int>(0, 0, 0));

        while (queue.Count > 0) {
            Tuple<int, int, int> tuple = queue.Dequeue();
            int x = tuple.Item1, y = tuple.Item2, status = tuple.Item3;
            if (status == 0) {
                // 向右移动一个单元格
                if (y + 2 < n && dist[x][y + 1][0] == -1 && grid[x][y + 2] == 0) {
                    dist[x][y + 1][0] = dist[x][y][0] + 1;
                    queue.Enqueue(new Tuple<int, int, int>(x, y + 1, 0));
                }
                // 向下移动一个单元格
                if (x + 1 < n && dist[x + 1][y][0] == -1 && grid[x + 1][y] == 0 && grid[x + 1][y + 1] == 0) {
                    dist[x + 1][y][0] = dist[x][y][0] + 1;
                    queue.Enqueue(new Tuple<int, int, int>(x + 1, y, 0));
                }
                // 顺时针旋转 90 度
                if (x + 1 < n && y + 1 < n && dist[x][y][1] == -1 && grid[x + 1][y] == 0 && grid[x + 1][y + 1] == 0) {
                    dist[x][y][1] = dist[x][y][0] + 1;
                    queue.Enqueue(new Tuple<int, int, int>(x, y, 1));
                }
            } else {
                // 向右移动一个单元格
                if (y + 1 < n && dist[x][y + 1][1] == -1 && grid[x][y + 1] == 0 && grid[x + 1][y + 1] == 0) {
                    dist[x][y + 1][1] = dist[x][y][1] + 1;
                    queue.Enqueue(new Tuple<int, int, int>(x, y + 1, 1));
                }
                // 向下移动一个单元格
                if (x + 2 < n && dist[x + 1][y][1] == -1 && grid[x + 2][y] == 0) {
                    dist[x + 1][y][1] = dist[x][y][1] + 1;
                    queue.Enqueue(new Tuple<int, int, int>(x + 1, y, 1));
                }
                // 逆时针旋转 90 度
                if (x + 1 < n && y + 1 < n && dist[x][y][0] == -1 && grid[x][y + 1] == 0 && grid[x + 1][y + 1] == 0) {
                    dist[x][y][0] = dist[x][y][1] + 1;
                    queue.Enqueue(new Tuple<int, int, int>(x, y, 0));
                }
            }
        }

        return dist[n - 1][n - 2][0];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minimumMoves(self, grid: List[List[int]]) -> int:
        n = len(grid)
        dist = {(0, 0, 0): 0}
        q = deque([(0, 0, 0)])

        while q:
            x, y, status = q.popleft()
            if status == 0:
                # 向右移动一个单元格
                if y + 2 < n and (x, y + 1, 0) not in dist and grid[x][y + 2] == 0:
                    dist[(x, y + 1, 0)] = dist[(x, y, 0)] + 1
                    q.append((x, y + 1, 0))
                
                # 向下移动一个单元格
                if x + 1 < n and (x + 1, y, 0) not in dist and grid[x + 1][y] == grid[x + 1][y + 1] == 0:
                    dist[(x + 1, y, 0)] = dist[(x, y, 0)] + 1
                    q.append((x + 1, y, 0))
                
                # 顺时针旋转 90 度
                if x + 1 < n and y + 1 < n and (x, y, 1) not in dist and grid[x + 1][y] == grid[x + 1][y + 1] == 0:
                    dist[(x, y, 1)] = dist[(x, y, 0)] + 1
                    q.append((x, y, 1))
            else:
                # 向右移动一个单元格
                if y + 1 < n and (x, y + 1, 1) not in dist and grid[x][y + 1] == grid[x + 1][y + 1] == 0:
                    dist[(x, y + 1, 1)] = dist[(x, y, 1)] + 1
                    q.append((x, y + 1, 1))
                
                # 向下移动一个单元格
                if x + 2 < n and (x + 1, y, 1) not in dist and grid[x + 2][y] == 0:
                    dist[(x + 1, y, 1)] = dist[(x, y, 1)] + 1
                    q.append((x + 1, y, 1))
                
                # 逆时针旋转 90 度
                if x + 1 < n and y + 1 < n and (x, y, 0) not in dist and grid[x][y + 1] == grid[x + 1][y + 1] == 0:
                    dist[(x, y, 0)] = dist[(x, y, 1)] + 1
                    q.append((x, y, 0))

        return dist.get((n - 1, n - 2, 0), -1)
```

```JavaScript [sol1-JavaScript]
var minimumMoves = function(grid) {
    const n = grid.length;
    const dist = new Array(n).fill(0).map(() => new Array(n).fill(0).map(() => new Array(2).fill(-1)));
    dist[0][0][0] = 0;
    const queue = [[0, 0, 0]];

    while (queue.length) {
        const arr = queue.shift();
        let x = arr[0], y = arr[1], status = arr[2];
        if (status === 0) {
            // 向右移动一个单元格
            if (y + 2 < n && dist[x][y + 1][0] === -1 && grid[x][y + 2] === 0) {
                dist[x][y + 1][0] = dist[x][y][0] + 1;
                queue.push([x, y + 1, 0]);
            }
            // 向下移动一个单元格
            if (x + 1 < n && dist[x + 1][y][0] === -1 && grid[x + 1][y] === 0 && grid[x + 1][y + 1] === 0) {
                dist[x + 1][y][0] = dist[x][y][0] + 1;
                queue.push([x + 1, y, 0]);
            }
            // 顺时针旋转 90 度
            if (x + 1 < n && y + 1 < n && dist[x][y][1] === -1 && grid[x + 1][y] === 0 && grid[x + 1][y + 1] === 0) {
                dist[x][y][1] = dist[x][y][0] + 1;
                queue.push([x, y, 1]);
            }
        } else {
            // 向右移动一个单元格
            if (y + 1 < n && dist[x][y + 1][1] === -1 && grid[x][y + 1] === 0 && grid[x + 1][y + 1] === 0) {
                dist[x][y + 1][1] = dist[x][y][1] + 1;
                queue.push([x, y + 1, 1]);
            }
            // 向下移动一个单元格
            if (x + 2 < n && dist[x + 1][y][1] === -1 && grid[x + 2][y] === 0) {
                dist[x + 1][y][1] = dist[x][y][1] + 1;
                queue.push([x + 1, y, 1]);
            }
            // 逆时针旋转 90 度
            if (x + 1 < n && y + 1 < n && dist[x][y][0] === -1 && grid[x][y + 1] === 0 && grid[x + 1][y + 1] === 0) {
                dist[x][y][0] = dist[x][y][1] + 1;
                queue.push([x, y, 0]);
            }
        }
    }

    return dist[n - 1][n - 2][0];
};
```

```go [sol1-Golang]
func minimumMoves(grid [][]int) int {
    n := len(grid)
    dist := make([][][2]int, n)
    for i := range dist {
        dist[i] = make([][2]int, n)
        for j := range dist[i] {
            dist[i][j] = [2]int{-1, -1}
        }
    }
    dist[0][0][0] = 0
    queue := [][3]int{{0, 0, 0}}

    for len(queue) > 0 {
        arr := queue[0]
        queue = queue[1:]
        x := arr[0]
        y := arr[1]
        status := arr[2]
        if status == 0 {
            // 向右移动一个单元格
            if y+2 < n && dist[x][y+1][0] == -1 && grid[x][y+2] == 0 {
                dist[x][y+1][0] = dist[x][y][0] + 1
                queue = append(queue, [3]int{x, y + 1, 0})
            }
            // 向下移动一个单元格
            if x+1 < n && dist[x+1][y][0] == -1 && grid[x+1][y] == 0 && grid[x+1][y+1] == 0 {
                dist[x+1][y][0] = dist[x][y][0] + 1
                queue = append(queue, [3]int{x + 1, y, 0})
            }
            // 顺时针旋转 90 度
            if x+1 < n && y+1 < n && dist[x][y][1] == -1 && grid[x+1][y] == 0 && grid[x+1][y+1] == 0 {
                dist[x][y][1] = dist[x][y][0] + 1
                queue = append(queue, [3]int{x, y, 1})
            }
        } else {
            // 向右移动一个单元格
            if y+1 < n && dist[x][y+1][1] == -1 && grid[x][y+1] == 0 && grid[x+1][y+1] == 0 {
                dist[x][y+1][1] = dist[x][y][1] + 1
                queue = append(queue, [3]int{x, y + 1, 1})
            }
            // 向下移动一个单元格
            if x+2 < n && dist[x+1][y][1] == -1 && grid[x+2][y] == 0 {
                dist[x+1][y][1] = dist[x][y][1] + 1
                queue = append(queue, [3]int{x + 1, y, 1})
            }
            // 逆时针旋转 90 度
            if x+1 < n && y+1 < n && dist[x][y][0] == -1 && grid[x][y+1] == 0 && grid[x+1][y+1] == 0 {
                dist[x][y][0] = dist[x][y][1] + 1
                queue = append(queue, [3]int{x, y, 0})
            }
        }
    }

    return dist[n-1][n-2][0]
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，我们需要对整个网格进行一次广度优先搜索。

- 空间复杂度：$O(n^2)$，即为广度优先搜索中队列和存储距离的数组需要使用的空间。

#### 方法二：动态规划

**思路与算法**

由于蛇只能向右或者向下移动，因此 $(x, y, \textit{status})$ 这个状态只会从 $(x-1, y, \textit{status})$，$(x, y-1, \textit{status})$ 或者 $(x, y, 1 - \textit{status})$ 通过一次操作得到。因此，如果我们使用双重循环分别递增地遍历 $x$ 和 $y$，那么在计算 $(x, y, \textit{status})$ 时，$(x-1, y, \textit{status})$ 和 $(x, y-1, \textit{status})$ 都已经完成计算，这样我们只需要小心地考虑 $(x, y, 1 - \textit{status})$ 这种特殊的情况（即旋转），就可以使用动态规划解决本题了。

在进行状态转移之前，我们首先需要判断 $(x, y, \textit{status})$ 这个状态本身是否是合法的。这是因为在方法一的广度优先搜索中，我们只会从一个有效的状态转移到另一些新的有效状态，而在动态规划中，我们使用双重循环遍历所有状态，这些状态并不都是有效的。

我们用 $\textit{canHorizontal}$ 和 $\textit{canVertical}$ 这两个布尔变量分别表示当 $\textit{status} = 0$ 和 $\textit{status} = 1$ 时，$(x, y, \textit{status})$ 是否是合法的。当 $\textit{canHorizontal} = \text{True}$ 时，有如下两种状态转移：

$$
\begin{aligned}
& f(x, y, 0) \leftarrow f(x-1, y, 0) + 1 \\
& f(x, y, 0) \leftarrow f(x, y-1, 0) + 1 \\
\end{aligned}
$$

当 $\textit{canVertical} = \text{True}$ 时，有如下两种状态转移：

$$
\begin{aligned}
& f(x, y, 1) \leftarrow f(x-1, y, 1) + 1 \\
& f(x, y, 1) \leftarrow f(x, y-1, 1) + 1 \\
\end{aligned}
$$

如果一个状态不是合法的，我们可以将它赋值为一个很大的整数 $\infty$。这样一来，在进行状态转移时，我们无需考虑 $f(x-1, y, 0)$ 或 $f(x, y-1, 1)$ 本身是否合法：如果它们不合法，那么转移式的右侧是一个很大的整数，而我们要求的是最少移动次数，因此无法进行转移。

除了上述的四种状态转移之外，我们还需要考虑 $(x, y, 0)$ 与 $(x, y, 1)$ 之间通过一次旋转操作的转移。由于在同一个 $(x, y)$ 不会旋转两次及以上，因此在上述四种状态转移完成之后，我们额外进行两种状态转移：

$$
\begin{aligned}
& f(x, y, 0) \leftarrow f(x, y, 1) + 1 \\
& f(x, y, 1) \leftarrow f(x, y, 0) + 1 \\
\end{aligned}
$$

即可。需要注意的是，除了 $\textit{canHorizontal}$ 和 $\textit{canVertical}$ 均为 $\text{True}$ 以外，我们还需要保证 $(x+1, y+1)$ 也是空的单元格。

> 读者可以思考一下，为什么一定要在「上述四种状态转移完成之后」才进行这两种特殊转移。如果改变顺序会出现什么问题。

动态规划的初始值为 $f(0, 0, 0) = 0$，其余所有的 $f(x, y, \textit{status}) = \infty$。最终的答案即为 $f(n-1, n-2, 0)$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int minimumMoves(vector<vector<int>>& grid) {
        int n = grid.size();
        vector<vector<array<int, 2>>> f(n, vector<array<int, 2>>(n, {INVALID, INVALID}));
        f[0][0][0] = 0;

        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                bool canHorizontal = (j + 1 < n && grid[i][j] == 0 && grid[i][j + 1] == 0);
                bool canVertical = (i + 1 < n && grid[i][j] == 0 && grid[i + 1][j] == 0);

                if (i - 1 >= 0 && canHorizontal) {
                    f[i][j][0] = min(f[i][j][0], f[i - 1][j][0] + 1);
                }
                if (j - 1 >= 0 && canHorizontal) {
                    f[i][j][0] = min(f[i][j][0], f[i][j - 1][0] + 1);
                }
                if (i - 1 >= 0 && canVertical) {
                    f[i][j][1] = min(f[i][j][1], f[i - 1][j][1] + 1);
                }
                if (j - 1 >= 0 && canVertical) {
                    f[i][j][1] = min(f[i][j][1], f[i][j - 1][1] + 1);
                }

                if (canHorizontal && canVertical && grid[i + 1][j + 1] == 0) {
                    f[i][j][0] = min(f[i][j][0], f[i][j][1] + 1);
                    f[i][j][1] = min(f[i][j][1], f[i][j][0] + 1);
                }
            }
        }

        return (f[n - 1][n - 2][0] == INVALID ? -1 : f[n - 1][n - 2][0]);
    }

private:
    static constexpr int INVALID = INT_MAX / 2;
};
```

```Java [sol2-Java]
class Solution {
    static final int INVALID = Integer.MAX_VALUE / 2;

    public int minimumMoves(int[][] grid) {
        int n = grid.length;
        int[][][] f = new int[n][n][2];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                Arrays.fill(f[i][j], INVALID);
            }
        }
        f[0][0][0] = 0;

        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                boolean canHorizontal = (j + 1 < n && grid[i][j] == 0 && grid[i][j + 1] == 0);
                boolean canVertical = (i + 1 < n && grid[i][j] == 0 && grid[i + 1][j] == 0);

                if (i - 1 >= 0 && canHorizontal) {
                    f[i][j][0] = Math.min(f[i][j][0], f[i - 1][j][0] + 1);
                }
                if (j - 1 >= 0 && canHorizontal) {
                    f[i][j][0] = Math.min(f[i][j][0], f[i][j - 1][0] + 1);
                }
                if (i - 1 >= 0 && canVertical) {
                    f[i][j][1] = Math.min(f[i][j][1], f[i - 1][j][1] + 1);
                }
                if (j - 1 >= 0 && canVertical) {
                    f[i][j][1] = Math.min(f[i][j][1], f[i][j - 1][1] + 1);
                }

                if (canHorizontal && canVertical && grid[i + 1][j + 1] == 0) {
                    f[i][j][0] = Math.min(f[i][j][0], f[i][j][1] + 1);
                    f[i][j][1] = Math.min(f[i][j][1], f[i][j][0] + 1);
                }
            }
        }

        return (f[n - 1][n - 2][0] == INVALID ? -1 : f[n - 1][n - 2][0]);
    }
}
```

```C# [sol2-C#]
public class Solution {
    const int INVALID = int.MaxValue / 2;

    public int MinimumMoves(int[][] grid) {
        int n = grid.Length;
        int[][][] f = new int[n][][];
        for (int i = 0; i < n; i++) {
            f[i] = new int[n][];
            for (int j = 0; j < n; j++) {
                f[i][j] = new int[2];
                Array.Fill(f[i][j], INVALID);
            }
        }
        f[0][0][0] = 0;

        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                bool canHorizontal = (j + 1 < n && grid[i][j] == 0 && grid[i][j + 1] == 0);
                bool canVertical = (i + 1 < n && grid[i][j] == 0 && grid[i + 1][j] == 0);

                if (i - 1 >= 0 && canHorizontal) {
                    f[i][j][0] = Math.Min(f[i][j][0], f[i - 1][j][0] + 1);
                }
                if (j - 1 >= 0 && canHorizontal) {
                    f[i][j][0] = Math.Min(f[i][j][0], f[i][j - 1][0] + 1);
                }
                if (i - 1 >= 0 && canVertical) {
                    f[i][j][1] = Math.Min(f[i][j][1], f[i - 1][j][1] + 1);
                }
                if (j - 1 >= 0 && canVertical) {
                    f[i][j][1] = Math.Min(f[i][j][1], f[i][j - 1][1] + 1);
                }

                if (canHorizontal && canVertical && grid[i + 1][j + 1] == 0) {
                    f[i][j][0] = Math.Min(f[i][j][0], f[i][j][1] + 1);
                    f[i][j][1] = Math.Min(f[i][j][1], f[i][j][0] + 1);
                }
            }
        }

        return (f[n - 1][n - 2][0] == INVALID ? -1 : f[n - 1][n - 2][0]);
    }
}
```

```Python [sol2-Python3]
class Solution:
    def minimumMoves(self, grid: List[List[int]]) -> int:
        n = len(grid)
        f = [[[float("inf"), float("inf")] for _ in range(n)] for _ in range(n)]
        f[0][0][0] = 0

        for i in range(n):
            for j in range(n):
                canHorizontal = (j + 1 < n and grid[i][j] == grid[i][j + 1] == 0)
                canVertical = (i + 1 < n and grid[i][j] == grid[i + 1][j] == 0)

                if i - 1 >= 0 and canHorizontal:
                    f[i][j][0] = min(f[i][j][0], f[i - 1][j][0] + 1)
                if j - 1 >= 0 and canHorizontal:
                    f[i][j][0] = min(f[i][j][0], f[i][j - 1][0] + 1)
                if i - 1 >= 0 and canVertical:
                    f[i][j][1] = min(f[i][j][1], f[i - 1][j][1] + 1)
                if j - 1 >= 0 and canVertical:
                    f[i][j][1] = min(f[i][j][1], f[i][j - 1][1] + 1)
                
                if canHorizontal and canVertical and grid[i + 1][j + 1] == 0:
                    f[i][j][0] = min(f[i][j][0], f[i][j][1] + 1)
                    f[i][j][1] = min(f[i][j][1], f[i][j][0] + 1)

        return -1 if f[n - 1][n - 2][0] == float("inf") else f[n - 1][n - 2][0]
```

```C [sol2-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

typedef struct {
    int x;
    int y;
    int status;
} Tuple;

const int INVALID = INT_MAX / 2;

int minimumMoves(int** grid, int gridSize, int* gridColSize) {
    int n = gridSize;
    int f[n][n][2];
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            f[i][j][0] = f[i][j][1] = INVALID;
        }
    }
    f[0][0][0] = 0;

    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            bool canHorizontal = (j + 1 < n && grid[i][j] == 0 && grid[i][j + 1] == 0);
            bool canVertical = (i + 1 < n && grid[i][j] == 0 && grid[i + 1][j] == 0);

            if (i - 1 >= 0 && canHorizontal) {
                f[i][j][0] = MIN(f[i][j][0], f[i - 1][j][0] + 1);
            }
            if (j - 1 >= 0 && canHorizontal) {
                f[i][j][0] = MIN(f[i][j][0], f[i][j - 1][0] + 1);
            }
            if (i - 1 >= 0 && canVertical) {
                f[i][j][1] = MIN(f[i][j][1], f[i - 1][j][1] + 1);
            }
            if (j - 1 >= 0 && canVertical) {
                f[i][j][1] = MIN(f[i][j][1], f[i][j - 1][1] + 1);
            }

            if (canHorizontal && canVertical && grid[i + 1][j + 1] == 0) {
                f[i][j][0] = MIN(f[i][j][0], f[i][j][1] + 1);
                f[i][j][1] = MIN(f[i][j][1], f[i][j][0] + 1);
            }
        }
    }

    return (f[n - 1][n - 2][0] == INVALID ? -1 : f[n - 1][n - 2][0]);
}
```

```JavaScript [sol2-JavaScript]
var minimumMoves = function(grid) {
    const INVALID = Number.MAX_VALUE;
    const n = grid.length;
    const f = new Array(n).fill(0).map(() => new Array(n).fill(0).map(() => new Array(2).fill(INVALID)));
    f[0][0][0] = 0;

    for (let i = 0; i < n; ++i) {
        for (let j = 0; j < n; ++j) {
            const canHorizontal = (j + 1 < n && grid[i][j] === 0 && grid[i][j + 1] === 0);
            const canVertical = (i + 1 < n && grid[i][j] === 0 && grid[i + 1][j] === 0);

            if (i - 1 >= 0 && canHorizontal) {
                f[i][j][0] = Math.min(f[i][j][0], f[i - 1][j][0] + 1);
            }
            if (j - 1 >= 0 && canHorizontal) {
                f[i][j][0] = Math.min(f[i][j][0], f[i][j - 1][0] + 1);
            }
            if (i - 1 >= 0 && canVertical) {
                f[i][j][1] = Math.min(f[i][j][1], f[i - 1][j][1] + 1);
            }
            if (j - 1 >= 0 && canVertical) {
                f[i][j][1] = Math.min(f[i][j][1], f[i][j - 1][1] + 1);
            }

            if (canHorizontal && canVertical && grid[i + 1][j + 1] === 0) {
                f[i][j][0] = Math.min(f[i][j][0], f[i][j][1] + 1);
                f[i][j][1] = Math.min(f[i][j][1], f[i][j][0] + 1);
            }
        }
    }

    return (f[n - 1][n - 2][0] === INVALID ? -1 : f[n - 1][n - 2][0]);
};
```

```go [sol2-Golang]
func minimumMoves(grid [][]int) int {
    const inf = math.MaxInt / 2
    n := len(grid)
    f := make([][][2]int, n)
    for i := range f {
        f[i] = make([][2]int, n)
        for j := range f[i] {
            f[i][j] = [2]int{inf, inf}
        }
    }
    f[0][0][0] = 0

    for i := 0; i < n; i++ {
        for j := 0; j < n; j++ {
            canHorizontal := j+1 < n && grid[i][j] == 0 && grid[i][j+1] == 0
            canVertical := i+1 < n && grid[i][j] == 0 && grid[i+1][j] == 0

            if i-1 >= 0 && canHorizontal {
                f[i][j][0] = min(f[i][j][0], f[i-1][j][0]+1)
            }
            if j-1 >= 0 && canHorizontal {
                f[i][j][0] = min(f[i][j][0], f[i][j-1][0]+1)
            }
            if i-1 >= 0 && canVertical {
                f[i][j][1] = min(f[i][j][1], f[i-1][j][1]+1)
            }
            if j-1 >= 0 && canVertical {
                f[i][j][1] = min(f[i][j][1], f[i][j-1][1]+1)
            }

            if canHorizontal && canVertical && grid[i+1][j+1] == 0 {
                f[i][j][0] = min(f[i][j][0], f[i][j][1]+1)
                f[i][j][1] = min(f[i][j][1], f[i][j][0]+1)
            }
        }
    }
    if f[n-1][n-2][0] == inf {
        return -1
    }
    return f[n-1][n-2][0]
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，动态规划使用双重循环，而每个状态转移需要的时间为 $O(1)$。

- 空间复杂度：$O(n^2)$，即为数组 $f$ 需要使用的空间。注意到 $f(x, \cdots)$ 只会从 $f(x-1, \cdots)$ 和 $f(x, \cdots)$ 转移而来，因此可以使用滚动数组进行空间优化，使得空间复杂度降低至 $O(n)$。
## [1263.推箱子 中文官方题解](https://leetcode.cn/problems/minimum-moves-to-move-a-box-to-their-target-location/solutions/100000/tui-xiang-zi-by-leetcode-solution-spzi)

### 问题提示
- 如何表示状态？
- 如何处理边界情况？
- 如何处理玩家和箱子同时移动的情况？

### 前置知识
- 广度优先搜索（BFS）算法的原理和实现方式。
- 如何使用队列实现 BFS 算法。
- 如何表示状态、状态转移和判断状态是否合法的方法。

### 解题思路

#### 方法一：01-广度优先搜索

由题意可知，目标位置固定时，将箱子推到目标位置的最小推动次数与箱子位置和玩家位置相关。我们把箱子位置和玩家位置当成一个状态，那么状态的转移主要由玩家向上、下、左、右四个方向移动触发（如果玩家移动后的位置与箱子位置重叠，那么箱子也相应的作出同样的移动，即一次“推动”）。我们把状态看成有向图的节点，状态的转移看成有向图的边，对应的边长与是否推动箱子有关（推动箱子时，边长为 $1$，否则为 $0$）。将箱子推到目标位置对应多个状态，这些状态中箱子位置等于目标位置。因此问题可以转化为：给定一个有向图，边长为 $0$ 或 $1$，求某一节点到符合条件的任一节点的最短路径。边权非负时，可以使用 $\text{Dijkstra}$ 算法求解，但是本题的边权限定在 $0$ 与 $1$ 之间，可以应用时间复杂度更优的 [01-广度优先搜索算法](https://oi-wiki.org/graph/bfs/)。不同于等边权的广度优先搜索，01-广度优先搜索在访问节点时，下一个节点的路径长度可能与当前访问节点的路径长度相同，也可能等于当前访问节点的路径长度加 $1$，我们需要先访问完前者的节点，然后才开始访问后者的节点。

记地图行数为 $m$，列数为 $n$，将坐标 $(x,y)$ 按照 $x \times n + y$ 的形式进行编码。首先我们遍历整个地图 $\textit{grid}$，得到箱子初始位置为 $(b_x,b_y)$，玩家初始位置为 $(s_x,s_y)$。使用 $\textit{dp}$ 记录各个状态的最小推动次数，初始状态对应的最小推动次数为 $0$，即 $\textit{dp}[s_x \times n + s_y][b_x \times n + b_y] = 0$。我们使用队列 $q$ 保存相同最小推动次数的状态，队列 $q_1$ 保存最小推动次数等于 $q$ 中的状态的最小推动次数加 $1$ 的状态。初始时队列 $q$ 的元素为初始状态，队列 $q_1$ 为空。

我们不断地从队列 $q$ 中取出状态，如果状态对应的箱子位置等于目标位置，那么返回对应状态的最小推动次数，否则执行状态转移，即玩家位置移动：


1. 如果玩家移动后的位置不合法，即越界或在墙上，那么说明转移无效，等价于图中不存在对应的边，执行下一次状态转移，否则执行步骤 2。
2. 根据玩家移动后的位置与箱子位置是否一致，分为两种情况：
   * 玩家移动后位置与箱子位置一致：箱子发生相同的移动，如果箱子位置不合法或状态已被访问，那么执行下一次状态转移，否则记录转移后状态的最小推动次数等于当前状态的最小推动次数加 $1$，并且将转移后状态放入 $q_1$ 中。
   * 玩家移动后位置与箱子位置不一致：如果状态已被访问，那么执行下一次状态转移，否则记录转移后状态的最小推动次数等于当前状态的最小推动次数，并且将转移后状态放入 $q$ 中。

当队列 $q$ 为空时，如果队列 $q_1$ 非空，那么将 $q$ 与 $q_1$ 交换，否则说明无法将箱子推动到目标位置，返回 $-1$。

```C++ [sol1]
class Solution {
public:
    int minPushBox(vector<vector<char>>& grid) {
        int m = grid.size(), n = grid[0].size();
        int sx, sy, bx, by; // 玩家、箱子的初始位置
        for (int x = 0; x < m; x++) {
            for (int y = 0; y < n; y++) {
                if (grid[x][y] == 'S') {
                    sx = x;
                    sy = y;
                } else if (grid[x][y] == 'B') {
                    bx = x;
                    by = y;
                }
            }
        }

        auto ok = [&](int x, int y) -> bool { // 不越界且不在墙上
            return x >= 0 && x < m && y >= 0 && y < n && grid[x][y] != '#';
        };
        vector<int> d = {0, -1, 0, 1, 0};

        vector<vector<int>> dp(m * n, vector<int>(m * n, INT_MAX));
        queue<pair<int, int>> q;
        dp[sx * n + sy][bx * n + by] = 0; // 初始状态的推动次数为 0
        q.push({sx * n + sy, bx * n + by});
        while (!q.empty()) {
            queue<pair<int, int>> q1;
            while (!q.empty()) {
                auto [s1, b1] = q.front();
                q.pop();
                int sx1 = s1 / n, sy1 = s1 % n, bx1 = b1 / n, by1 = b1 % n;
                if (grid[bx1][by1] == 'T') { // 箱子已被推到目标处
                    return dp[s1][b1];
                }
                for (int i = 0; i < 4; i++) { // 玩家向四个方向移动到另一个状态
                    int sx2 = sx1 + d[i], sy2 = sy1 + d[i + 1], s2 = sx2*n+sy2;
                    if (!ok(sx2, sy2)) { // 玩家位置不合法
                        continue;
                    }
                    if (bx1 == sx2 && by1 == sy2) { // 推动箱子
                        int bx2 = bx1 + d[i], by2 = by1 + d[i + 1], b2 = bx2*n+by2;
                        if (!ok(bx2, by2) || dp[s2][b2] <= dp[s1][b1] + 1) { // 箱子位置不合法 或 状态已访问
                            continue;
                        }
                        dp[s2][b2] = dp[s1][b1] + 1;
                        q1.push({s2, b2});
                    } else {
                        if (dp[s2][b1] <= dp[s1][b1]) { // 状态已访问
                            continue;
                        }
                        dp[s2][b1] = dp[s1][b1];
                        q.push({s2, b1});
                    }
                }
            }
            q.swap(q1);
        }
        return -1;
    }
};
```
```Java [sol1]
class Solution {
    public int minPushBox(char[][] grid) {
        int m = grid.length, n = grid[0].length;
        int sx = -1, sy = -1, bx = -1, by = -1; // 玩家、箱子的初始位置
        for (int x = 0; x < m; x++) {
            for (int y = 0; y < n; y++) {
                if (grid[x][y] == 'S') {
                    sx = x;
                    sy = y;
                } else if (grid[x][y] == 'B') {
                    bx = x;
                    by = y;
                }
            }
        }

        int[] d = {0, -1, 0, 1, 0};

        int[][] dp = new int[m * n][m * n];
        for (int i = 0; i < m * n; i++) {
            Arrays.fill(dp[i], Integer.MAX_VALUE);
        }
        Queue<int[]> queue = new ArrayDeque<int[]>();
        dp[sx * n + sy][bx * n + by] = 0; // 初始状态的推动次数为 0
        queue.offer(new int[]{sx * n + sy, bx * n + by});
        while (!queue.isEmpty()) {
            Queue<int[]> queue1 = new ArrayDeque<int[]>();
            while (!queue.isEmpty()) {
                int[] arr = queue.poll();
                int s1 = arr[0], b1 = arr[1];
                int sx1 = s1 / n, sy1 = s1 % n, bx1 = b1 / n, by1 = b1 % n;
                if (grid[bx1][by1] == 'T') { // 箱子已被推到目标处
                    return dp[s1][b1];
                }
                for (int i = 0; i < 4; i++) { // 玩家向四个方向移动到另一个状态
                    int sx2 = sx1 + d[i], sy2 = sy1 + d[i + 1], s2 = sx2*n+sy2;
                    if (!ok(grid, m, n, sx2, sy2)) { // 玩家位置不合法
                        continue;
                    }
                    if (bx1 == sx2 && by1 == sy2) { // 推动箱子
                        int bx2 = bx1 + d[i], by2 = by1 + d[i + 1], b2 = bx2*n+by2;
                        if (!ok(grid, m, n, bx2, by2) || dp[s2][b2] <= dp[s1][b1] + 1) { // 箱子位置不合法 或 状态已访问
                            continue;
                        }
                        dp[s2][b2] = dp[s1][b1] + 1;
                        queue1.offer(new int[]{s2, b2});
                    } else {
                        if (dp[s2][b1] <= dp[s1][b1]) { // 状态已访问
                            continue;
                        }
                        dp[s2][b1] = dp[s1][b1];
                        queue.offer(new int[]{s2, b1});
                    }
                }
            }
            queue = queue1;
        }
        return -1;
    }

    public boolean ok(char[][] grid, int m, int n, int x, int y) { // 不越界且不在墙上
        return x >= 0 && x < m && y >= 0 && y < n && grid[x][y] != '#';
    }
}
```
```C# [sol1]
public class Solution {
    public int MinPushBox(char[][] grid) {
        int m = grid.Length, n = grid[0].Length;
        int sx = -1, sy = -1, bx = -1, by = -1; // 玩家、箱子的初始位置
        for (int x = 0; x < m; x++) {
            for (int y = 0; y < n; y++) {
                if (grid[x][y] == 'S') {
                    sx = x;
                    sy = y;
                } else if (grid[x][y] == 'B') {
                    bx = x;
                    by = y;
                }
            }
        }

        int[] d = {0, -1, 0, 1, 0};

        int[][] dp = new int[m * n][];
        for (int i = 0; i < m * n; i++) {
            dp[i] = new int[m * n];
            Array.Fill(dp[i], int.MaxValue);
        }
        Queue<Tuple<int, int>> queue = new Queue<Tuple<int, int>>();
        dp[sx * n + sy][bx * n + by] = 0; // 初始状态的推动次数为 0
        queue.Enqueue(new Tuple<int, int>(sx * n + sy, bx * n + by));
        while (queue.Count > 0) {
            Queue<Tuple<int, int>> queue1 = new Queue<Tuple<int, int>>();
            while (queue.Count > 0) {
                Tuple<int, int> tuple = queue.Dequeue();
                int s1 = tuple.Item1, b1 = tuple.Item2;
                int sx1 = s1 / n, sy1 = s1 % n, bx1 = b1 / n, by1 = b1 % n;
                if (grid[bx1][by1] == 'T') { // 箱子已被推到目标处
                    return dp[s1][b1];
                }
                for (int i = 0; i < 4; i++) { // 玩家向四个方向移动到另一个状态
                    int sx2 = sx1 + d[i], sy2 = sy1 + d[i + 1], s2 = sx2*n+sy2;
                    if (!Ok(grid, m, n, sx2, sy2)) { // 玩家位置不合法
                        continue;
                    }
                    if (bx1 == sx2 && by1 == sy2) { // 推动箱子
                        int bx2 = bx1 + d[i], by2 = by1 + d[i + 1], b2 = bx2*n+by2;
                        if (!Ok(grid, m, n, bx2, by2) || dp[s2][b2] <= dp[s1][b1] + 1) { // 箱子位置不合法 或 状态已访问
                            continue;
                        }
                        dp[s2][b2] = dp[s1][b1] + 1;
                        queue1.Enqueue(new Tuple<int, int>(s2, b2));
                    } else {
                        if (dp[s2][b1] <= dp[s1][b1]) { // 状态已访问
                            continue;
                        }
                        dp[s2][b1] = dp[s1][b1];
                        queue.Enqueue(new Tuple<int, int>(s2, b1));
                    }
                }
            }
            queue = queue1;
        }
        return -1;
    }

    public bool Ok(char[][] grid, int m, int n, int x, int y) { // 不越界且不在墙上
        return x >= 0 && x < m && y >= 0 && y < n && grid[x][y] != '#';
    }
}
```
```Python [sol1]
class Solution:
    def minPushBox(self, grid: List[List[str]]) -> int:
        m = len(grid)
        n = len(grid[0])
        sx, sy, bx, by = None, None, None, None # 玩家、箱子的初始位置
        for x in range(m):
            for y in range(n):
                if grid[x][y] == 'S':
                    sx = x
                    sy = y
                elif grid[x][y] == 'B':
                    bx = x
                    by = y

        # 不越界且不在墙上
        def ok(x, y):
            return (0 <= x < m and 0 <= y < n and grid[x][y] != '#')

        d = [0, -1, 0, 1, 0]

        dp = [[float('inf')] * (m * n) for _ in range(m * n)]
        dp[sx * n + sy][bx * n + by] = 0 # 初始状态的推动次数为 0
        q = deque([(sx * n + sy, bx * n + by)])
        while q:
            q1 = deque()
            while q:
                s1, b1 = q.popleft()
                sx1, sy1 = s1 // n, s1 % n
                bx1, by1 = b1 // n, b1 % n
                if grid[bx1][by1] == 'T': # 箱子已被推到目标处
                    return dp[s1][b1]
                for i in range(4): # 玩家向四个方向移动到另一个状态
                    sx2, sy2 = sx1 + d[i], sy1 + d[i + 1]
                    s2 = sx2 * n + sy2
                    if not ok(sx2, sy2): # 玩家位置不合法
                        continue
                    if sx2 == bx1 and sy2 == by1: # 推动箱子
                        bx2, by2 = bx1 + d[i], by1 + d[i + 1]
                        b2 = bx2 * n + by2
                        if not ok(bx2, by2) or dp[s2][b2] <= dp[s1][b1] + 1: # 箱子位置不合法 或 状态已访问
                            continue
                        dp[s2][b2] = dp[s1][b1] + 1
                        q1.append((s2, b2))
                    else:
                        if dp[s2][b1] <= dp[s1][b1]: # 状态已访问
                            continue
                        dp[s2][b1] = dp[s1][b1]
                        q.append((s2, b1))
            q, q1 = q1, q
        return -1
```
```Golang [sol1]
func minPushBox(grid [][]byte) int {
    m, n := len(grid), len(grid[0])
    var sx, sy, bx, by int // 玩家、箱子的初始位置
    for x := 0; x < m; x++ {
        for y := 0; y < n; y++ {
            if grid[x][y] == 'S' {
                sx, sy = x, y
            } else if grid[x][y] == 'B' {
                bx, by = x, y
            }
        }
    }

    ok := func(x, y int) bool { // 不越界且不在墙上
        return x >= 0 && x < m && y >= 0 && y < n && grid[x][y] != '#'
    }
    d := []int{0, -1, 0, 1, 0}

    dp := make([][]int, m * n)
    for i := 0; i < m * n; i++ {
        dp[i] = make([]int, m * n)
        for j := 0; j < m * n; j++ {
            dp[i][j] = 0x3f3f3f3f
        }
    }
    dp[sx*n+sy][bx*n+by] = 0 // 初始状态的推动次数为 0
    q := [][2]int{{sx*n+sy, bx*n+by}}
    for len(q) > 0 {
        q1 := [][2]int{}
        for len(q) > 0 {
            s1, b1 := q[0][0], q[0][1]
            q = q[1:]
            sx1, sy1, bx1, by1 := s1 / n, s1 % n, b1 / n, b1 % n
            if grid[bx1][by1] == 'T' { // 箱子已被推到目标处
                return dp[s1][b1]
            }
            for i := 0; i < 4; i++ { // 玩家向四个方向移动到另一个状态
                sx2, sy2 := sx1 + d[i], sy1 + d[i + 1]
                s2 := sx2*n+sy2
                if !ok(sx2, sy2) { // 玩家位置不合法
                    continue
                }
                if bx1 == sx2 && by1 == sy2 { // 推动箱子
                    bx2, by2 := bx1 + d[i], by1 + d[i + 1]
                    b2 := bx2*n+by2
                    if !ok(bx2, by2) || dp[s2][b2] <= dp[s1][b1] + 1 { // 箱子位置不合法 或 状态已访问
                        continue
                    }
                    dp[s2][b2] = dp[s1][b1] + 1
                    q1 = append(q1, [2]int{s2, b2})
                } else {
                    if dp[s2][b1] <= dp[s1][b1] { // 状态已访问
                        continue
                    }
                    dp[s2][b1] = dp[s1][b1]
                    q = append(q, [2]int{s2, b1})
                }
            }
        }
        q = q1
    }
    return -1
}
```
```C [sol1]
const int INF = 0x3f3f3f3f;

bool ok(int x, int y, int m, int n, const char **grid) { // 不越界且不在墙上
    return x >= 0 && x < m && y >= 0 && y < n && grid[x][y] != '#';
}

int minPushBox(char** grid, int gridSize, int* gridColSize) {
    int m = gridSize, n = gridColSize[0];
    int sx, sy, bx, by; // 玩家、箱子的初始位置
    for (int x = 0; x < m; x++) {
        for (int y = 0; y < n; y++) {
            if (grid[x][y] == 'S') {
                sx = x;
                sy = y;
            } else if (grid[x][y] == 'B') {
                bx = x;
                by = y;
            }
        }
    }
    
    int k = m * m * n * n;
    int d[] = {0, -1, 0, 1, 0};
    int dp[m * n][m * n];
    memset(dp, 0x3f, sizeof(dp));
    int queue[k][2];
    int queue1[k][2];
    dp[sx * n + sy][bx * n + by] = 0; // 初始状态的推动次数为 0
    int head = 0, tail = 0;
    int pos = 0;
    queue[tail][0] = sx * n + sy;
    queue[tail][1] = bx * n + by;
    tail++;
    while (tail != head) {
        pos = 0;
        while (tail != head) {
            int s1 = queue[head][0];
            int b1 = queue[head][1];
            head++;
            int sx1 = s1 / n, sy1 = s1 % n, bx1 = b1 / n, by1 = b1 % n;
            if (grid[bx1][by1] == 'T') { // 箱子已被推到目标处
                return dp[s1][b1];
            }
            for (int i = 0; i < 4; i++) { // 玩家向四个方向移动到另一个状态
                int sx2 = sx1 + d[i], sy2 = sy1 + d[i + 1], s2 = sx2*n+sy2;
                if (!ok(sx2, sy2, m, n, grid)) { // 玩家位置不合法
                    continue;
                }
                if (bx1 == sx2 && by1 == sy2) { // 推动箱子
                    int bx2 = bx1 + d[i], by2 = by1 + d[i + 1], b2 = bx2 * n + by2;
                    if (!ok(bx2, by2, m, n, grid) || dp[s2][b2] <= dp[s1][b1] + 1) { // 箱子位置不合法 或 状态已访问
                        continue;
                    }
                    dp[s2][b2] = dp[s1][b1] + 1;
                    queue1[pos][0] = s2;
                    queue1[pos][1] = b2;
                    pos++;
                } else {
                    if (dp[s2][b1] <= dp[s1][b1]) { // 状态已访问
                        continue;
                    }
                    dp[s2][b1] = dp[s1][b1];
                    queue[tail][0] = s2;
                    queue[tail][1] = b1;
                    tail++;
                }
            }
        }
        memcpy(queue, queue1, sizeof(int) * 2 * pos);
        head = 0;
        tail = pos;
    }
    return -1;
}
```
```JavaScript [sol1]
var minPushBox = function(grid) {
    const m = grid.length, n = grid[0].length;
    let sx = -1, sy = -1, bx = -1, by = -1; // 玩家、箱子的初始位置
    for (let x = 0; x < m; x++) {
        for (let y = 0; y < n; y++) {
            if (grid[x][y] === 'S') {
                sx = x;
                sy = y;
            } else if (grid[x][y] === 'B') {
                bx = x;
                by = y;
            }
        }
    }

    const d = [0, -1, 0, 1, 0];

    const dp = new Array(m * n).fill(0).map(() => new Array(m * n).fill(Number.MAX_VALUE));
    let queue = [];
    dp[sx * n + sy][bx * n + by] = 0; // 初始状态的推动次数为 0
    queue.push([sx * n + sy, bx * n + by]);
    while (queue.length) {
        const queue1 = [];
        while (queue.length) {
            const arr = queue.shift();
            const s1 = arr[0], b1 = arr[1];
            const sx1 = Math.floor(s1 / n), sy1 = s1 % n, bx1 = Math.floor(b1 / n), by1 = b1 % n;
            if (grid[bx1][by1] === 'T') { // 箱子已被推到目标处
                return dp[s1][b1];
            }
            for (let i = 0; i < 4; i++) { // 玩家向四个方向移动到另一个状态
                const sx2 = sx1 + d[i], sy2 = sy1 + d[i + 1], s2 = sx2*n+sy2;
                if (!ok(grid, m, n, sx2, sy2)) { // 玩家位置不合法
                    continue;
                }
                if (bx1 === sx2 && by1 === sy2) { // 推动箱子
                    const bx2 = bx1 + d[i], by2 = by1 + d[i + 1], b2 = bx2*n+by2;
                    if (!ok(grid, m, n, bx2, by2) || dp[s2][b2] <= dp[s1][b1] + 1) { // 箱子位置不合法 或 状态已访问
                        continue;
                    }
                    dp[s2][b2] = dp[s1][b1] + 1;
                    queue1.push([s2, b2]);
                } else {
                    if (dp[s2][b1] <= dp[s1][b1]) { // 状态已访问
                        continue;
                    }
                    dp[s2][b1] = dp[s1][b1];
                    queue.push([s2, b1]);
                }
            }
        }
        queue = queue1;
    }
    return -1;
}

const ok = (grid, m, n, x, y) => { // 不越界且不在墙上
    return x >= 0 && x < m && y >= 0 && y < n && grid[x][y] !== '#';
};
```

**复杂度分析**

* 时间复杂度：$O(m^2n^2)$，其中 $m$ 和 $n$ 分别是 $\textit{grid}$ 的行数和列数。最多访问到 $m^2n^2$ 个状态，因此时间复杂度为 $O(m^2n^2)$。
* 空间复杂度：$O(m^2n^2)$。保存 $\textit{dp}$ 和队列的空间复杂度都是 $O(m^2n^2)$。

### 拓展题目推荐
[695.岛屿的最大面积](https://leetcode-cn.com/problems/max-area-of-island/)
[841.钥匙和房间](https://leetcode-cn.com/problems/keys-and-rooms/)

### 思考
如果地图中存在多个目标位置，如何修改算法来解决问题？
## [909.蛇梯棋 中文官方题解](https://leetcode.cn/problems/snakes-and-ladders/solutions/100000/she-ti-qi-by-leetcode-solution-w0vl)
#### 方法一：广度优先搜索

我们可以将棋盘抽象成一个包含 $N^2$ 个节点的有向图，对于每个节点 $x$，若 $x+i\ (1\le i \le 6)$ 上没有蛇或梯子，则连一条从 $x$ 到 $x+i$ 的有向边；否则记蛇梯的目的地为 $y$，连一条从 $x$ 到 $y$ 的有向边。

如此转换后，原问题等价于在这张有向图上求出从 $1$ 到 $N^2$ 的最短路长度。

对于该问题，我们可以使用广度优先搜索。将节点编号和到达该节点的移动次数作为搜索状态，顺着该节点的出边扩展新状态，直至到达终点 $N^2$，返回此时的移动次数。若无法到达终点则返回 $-1$。

代码实现时，我们可以用一个队列来存储搜索状态，初始时将起点状态 $(1,0)$ 加入队列，表示当前位于起点 $1$，移动次数为 $0$。然后不断取出队首，每次取出队首元素时扩展新状态，即遍历该节点的出边，若出边对应节点未被访问，则将该节点和移动次数加一的结果作为新状态，加入队列。如此循环直至到达终点或队列为空。

此外，我们需要计算出编号在棋盘中的对应行列，以便从 $\textit{board}$ 中得到目的地。设编号为 $\textit{id}$，由于每行有 $n$ 个数字，其位于棋盘从下往上数的第 $\left \lfloor \dfrac{\textit{id}-1}{n} \right \rfloor$ 行，记作 $r$。由于棋盘的每一行会交替方向，若 $r$ 为偶数，则编号方向从左向右，列号为 $(\textit{id}-1) \bmod n$；若 $r$ 为奇数，则编号方向从右向左，列号为 $n-1-((\textit{id}-1) \bmod n)$。

```C++ [sol1-C++]
class Solution {
    pair<int, int> id2rc(int id, int n) {
        int r = (id - 1) / n, c = (id - 1) % n;
        if (r % 2 == 1) {
            c = n - 1 - c;
        }
        return {n - 1 - r, c};
    }

public:
    int snakesAndLadders(vector<vector<int>> &board) {
        int n = board.size();
        vector<int> vis(n * n + 1);
        queue<pair<int, int>> q;
        q.emplace(1, 0);
        while (!q.empty()) {
            auto p = q.front();
            q.pop();
            for (int i = 1; i <= 6; ++i) {
                int nxt = p.first + i;
                if (nxt > n * n) { // 超出边界
                    break;
                }
                auto rc = id2rc(nxt, n); // 得到下一步的行列
                if (board[rc.first][rc.second] > 0) { // 存在蛇或梯子
                    nxt = board[rc.first][rc.second];
                }
                if (nxt == n * n) { // 到达终点
                    return p.second + 1;
                }
                if (!vis[nxt]) {
                    vis[nxt] = true;
                    q.emplace(nxt, p.second + 1); // 扩展新状态
                }
            }
        }
        return -1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int snakesAndLadders(int[][] board) {
        int n = board.length;
        boolean[] vis = new boolean[n * n + 1];
        Queue<int[]> queue = new LinkedList<int[]>();
        queue.offer(new int[]{1, 0});
        while (!queue.isEmpty()) {
            int[] p = queue.poll();
            for (int i = 1; i <= 6; ++i) {
                int nxt = p[0] + i;
                if (nxt > n * n) { // 超出边界
                    break;
                }
                int[] rc = id2rc(nxt, n); // 得到下一步的行列
                if (board[rc[0]][rc[1]] > 0) { // 存在蛇或梯子
                    nxt = board[rc[0]][rc[1]];
                }
                if (nxt == n * n) { // 到达终点
                    return p[1] + 1;
                }
                if (!vis[nxt]) {
                    vis[nxt] = true;
                    queue.offer(new int[]{nxt, p[1] + 1}); // 扩展新状态
                }
            }
        }
        return -1;
    }

    public int[] id2rc(int id, int n) {
        int r = (id - 1) / n, c = (id - 1) % n;
        if (r % 2 == 1) {
            c = n - 1 - c;
        }
        return new int[]{n - 1 - r, c};
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int SnakesAndLadders(int[][] board) {
        int n = board.Length;
        bool[] vis = new bool[n * n + 1];
        Queue<Tuple<int, int>> queue = new Queue<Tuple<int, int>>();
        queue.Enqueue(new Tuple<int, int>(1, 0));
        while (queue.Count > 0) {
            Tuple<int, int> p = queue.Dequeue();
            for (int i = 1; i <= 6; ++i) {
                int nxt = p.Item1 + i;
                if (nxt > n * n) { // 超出边界
                    break;
                }
                Tuple<int, int> rc = Id2Rc(nxt, n); // 得到下一步的行列
                if (board[rc.Item1][rc.Item2] > 0) { // 存在蛇或梯子
                    nxt = board[rc.Item1][rc.Item2];
                }
                if (nxt == n * n) { // 到达终点
                    return p.Item2 + 1;
                }
                if (!vis[nxt]) {
                    vis[nxt] = true;
                    queue.Enqueue(new Tuple<int, int>(nxt, p.Item2 + 1)); // 扩展新状态
                }
            }
        }
        return -1;
    }

    public Tuple<int, int> Id2Rc(int id, int n) {
        int r = (id - 1) / n, c = (id - 1) % n;
        if (r % 2 == 1) {
            c = n - 1 - c;
        }
        return new Tuple<int, int>(n - 1 - r, c);
    }
}
```

```go [sol1-Golang]
func id2rc(id, n int) (r, c int) {
    r, c = (id-1)/n, (id-1)%n
    if r%2 == 1 {
        c = n - 1 - c
    }
    r = n - 1 - r
    return
}

func snakesAndLadders(board [][]int) int {
    n := len(board)
    vis := make([]bool, n*n+1)
    type pair struct{ id, step int }
    q := []pair{{1, 0}}
    for len(q) > 0 {
        p := q[0]
        q = q[1:]
        for i := 1; i <= 6; i++ {
            nxt := p.id + i
            if nxt > n*n { // 超出边界
                break
            }
            r, c := id2rc(nxt, n) // 得到下一步的行列
            if board[r][c] > 0 {  // 存在蛇或梯子
                nxt = board[r][c]
            }
            if nxt == n*n { // 到达终点
                return p.step + 1
            }
            if !vis[nxt] {
                vis[nxt] = true
                q = append(q, pair{nxt, p.step + 1}) // 扩展新状态
            }
        }
    }
    return -1
}
```

```JavaScript [sol1-JavaScript]
var snakesAndLadders = function(board) {
    const n = board.length;
    const vis = new Array(n * n + 1).fill(0);
    const queue = [[1, 0]];
    while (queue.length) {
        const p = queue.shift();
        for (let i = 1; i <= 6; ++i) {
            let nxt = p[0] + i;
            if (nxt > n * n) { // 超出边界
                break;
            }
            const rc = id2rc(nxt, n); // 得到下一步的行列
            if (board[rc[0]][rc[1]] > 0) { // 存在蛇或梯子
                nxt = board[rc[0]][rc[1]];
            }
            if (nxt === n * n) { // 到达终点
                return p[1] + 1;
            }
            if (!vis[nxt]) {
                vis[nxt] = true;
                queue.push([nxt, p[1] + 1]); // 扩展新状态
            }
        }
    }
    return -1;
};

const id2rc = (id, n) => {
    let r = Math.floor((id - 1) / n), c = (id - 1) % n;
    if (r % 2 === 1) {
        c = n - 1 - c;
    }
    return [n - 1 - r, c];
}
```

```Python [sol1-Python3]
class Solution:
    def snakesAndLadders(self, board: List[List[int]]) -> int:
        n = len(board)

        def id2rc(idx: int) -> (int, int):
            r, c = (idx - 1) // n, (idx - 1) % n
            if r % 2 == 1:
                c = n - 1 - c
            return n - 1 - r, c
        
        vis = set()
        q = deque([(1, 0)])
        while q:
            idx, step = q.popleft()
            for i in range(1, 6 + 1):
                idx_nxt = idx + i
                if idx_nxt > n * n:   # 超出边界
                    break
                
                x_nxt, y_nxt = id2rc(idx_nxt)   # 得到下一步的行列
                if board[x_nxt][y_nxt] > 0:   # 存在蛇或梯子
                    idx_nxt = board[x_nxt][y_nxt]
                if idx_nxt == n * n:   # 到达终点
                    return step + 1
                if idx_nxt not in vis:
                    vis.add(idx_nxt)
                    q.append((idx_nxt, step + 1))   # 扩展新状态
        
        return -1
```

```C [sol1-C]
struct Pair {
    int first;
    int second;
};

struct Pair id2rc(int id, int n) {
    int r = (id - 1) / n, c = (id - 1) % n;
    if (r % 2 == 1) {
        c = n - 1 - c;
    }
    return (struct Pair){n - 1 - r, c};
}

int snakesAndLadders(int** board, int boardSize, int* boardColSize) {
    int n = boardSize;
    int vis[n * n + 1];
    memset(vis, 0, sizeof(vis));
    struct Pair que[n * n];
    int left = 0, right = 0;
    que[right].first = 1, que[right++].second = 0;
    while (left < right) {
        struct Pair p = que[left++];
        for (int i = 1; i <= 6; ++i) {
            int nxt = p.first + i;
            if (nxt > n * n) {  // 超出边界
                break;
            }
            struct Pair rc = id2rc(nxt, n);  // 得到下一步的行列
            if (board[rc.first][rc.second] > 0) {  // 存在蛇或梯子
                nxt = board[rc.first][rc.second];
            }
            if (nxt == n * n) {  // 到达终点
                return p.second + 1;
            }
            if (!vis[nxt]) {
                vis[nxt] = true;
                que[right].first = nxt, que[right++].second = p.second + 1;  // 扩展新状态
            }
        }
    }
    return -1;
}
```

**复杂度分析**

- 时间复杂度：$O(N^2)$，其中 $N$ 为棋盘 $\textit{board}$ 的边长。棋盘的每个格子至多入队一次，因此时间复杂度为 $O(N^2)$。

- 空间复杂度：$O(N^2)$。我们需要 $O(N^2)$ 的空间来存储每个格子是否被访问过。
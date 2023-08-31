## [743.网络延迟时间 中文官方题解](https://leetcode.cn/problems/network-delay-time/solutions/100000/wang-luo-yan-chi-shi-jian-by-leetcode-so-6phc)

#### 前言

本题需要用到单源最短路径算法 $\text{Dijkstra}$，现在让我们回顾该算法，其主要思想是贪心。

将所有节点分成两类：已确定从起点到当前点的最短路长度的节点，以及未确定从起点到当前点的最短路长度的节点（下面简称「未确定节点」和「已确定节点」）。

每次从「未确定节点」中取一个与起点距离最短的点，将它归类为「已确定节点」，并用它「更新」从起点到其他所有「未确定节点」的距离。直到所有点都被归类为「已确定节点」。

用节点 $A$「更新」节点 $B$ 的意思是，用起点到节点 $A$ 的最短路长度加上从节点 $A$ 到节点 $B$ 的边的长度，去比较起点到节点 $B$ 的最短路长度，如果前者小于后者，就用前者更新后者。这种操作也被叫做「松弛」。

这里暗含的信息是：每次选择「未确定节点」时，起点到它的最短路径的长度可以被确定。

可以这样理解，因为我们已经用了每一个「已确定节点」更新过了当前节点，无需再次更新（因为一个点不能多次到达）。而当前节点已经是所有「未确定节点」中与起点距离最短的点，不可能被其它「未确定节点」更新。所以当前节点可以被归类为「已确定节点」。

#### 方法一：$\text{Dijkstra}$ 算法

根据题意，从节点 $k$ 发出的信号，到达节点 $x$ 的时间就是节点 $k$ 到节点 $x$ 的最短路的长度。因此我们需要求出节点 $k$ 到其余所有点的最短路，其中的最大值就是答案。若存在从 $k$ 出发无法到达的点，则返回 $-1$。

下面的代码将节点编号减小了 $1$，从而使节点编号位于 $[0,n-1]$ 范围。

```C++ [sol11-C++]
class Solution {
public:
    int networkDelayTime(vector<vector<int>> &times, int n, int k) {
        const int inf = INT_MAX / 2;
        vector<vector<int>> g(n, vector<int>(n, inf));
        for (auto &t : times) {
            int x = t[0] - 1, y = t[1] - 1;
            g[x][y] = t[2];
        }

        vector<int> dist(n, inf);
        dist[k - 1] = 0;
        vector<int> used(n);
        for (int i = 0; i < n; ++i) {
            int x = -1;
            for (int y = 0; y < n; ++y) {
                if (!used[y] && (x == -1 || dist[y] < dist[x])) {
                    x = y;
                }
            }
            used[x] = true;
            for (int y = 0; y < n; ++y) {
                dist[y] = min(dist[y], dist[x] + g[x][y]);
            }
        }

        int ans = *max_element(dist.begin(), dist.end());
        return ans == inf ? -1 : ans;
    }
};
```

```Java [sol11-Java]
class Solution {
    public int networkDelayTime(int[][] times, int n, int k) {
        final int INF = Integer.MAX_VALUE / 2;
        int[][] g = new int[n][n];
        for (int i = 0; i < n; ++i) {
            Arrays.fill(g[i], INF);
        }
        for (int[] t : times) {
            int x = t[0] - 1, y = t[1] - 1;
            g[x][y] = t[2];
        }

        int[] dist = new int[n];
        Arrays.fill(dist, INF);
        dist[k - 1] = 0;
        boolean[] used = new boolean[n];
        for (int i = 0; i < n; ++i) {
            int x = -1;
            for (int y = 0; y < n; ++y) {
                if (!used[y] && (x == -1 || dist[y] < dist[x])) {
                    x = y;
                }
            }
            used[x] = true;
            for (int y = 0; y < n; ++y) {
                dist[y] = Math.min(dist[y], dist[x] + g[x][y]);
            }
        }

        int ans = Arrays.stream(dist).max().getAsInt();
        return ans == INF ? -1 : ans;
    }
}
```

```C# [sol11-C#]
public class Solution {
    public int NetworkDelayTime(int[][] times, int n, int k) {
        const int INF = int.MaxValue / 2;
        int[,] g = new int[n, n];
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                g[i, j] = INF;
            }
        }
        foreach (int[] t in times) {
            int x = t[0] - 1, y = t[1] - 1;
            g[x, y] = t[2];
        }

        int[] dist = new int[n];
        Array.Fill(dist, INF);
        dist[k - 1] = 0;
        bool[] used = new bool[n];
        for (int i = 0; i < n; ++i) {
            int x = -1;
            for (int y = 0; y < n; ++y) {
                if (!used[y] && (x == -1 || dist[y] < dist[x])) {
                    x = y;
                }
            }
            used[x] = true;
            for (int y = 0; y < n; ++y) {
                dist[y] = Math.Min(dist[y], dist[x] + g[x, y]);
            }
        }

        int ans = dist.Max();
        return ans == INF ? -1 : ans;
    }
}
```

```go [sol11-Golang]
func networkDelayTime(times [][]int, n, k int) (ans int) {
    const inf = math.MaxInt64 / 2
    g := make([][]int, n)
    for i := range g {
        g[i] = make([]int, n)
        for j := range g[i] {
            g[i][j] = inf
        }
    }
    for _, t := range times {
        x, y := t[0]-1, t[1]-1
        g[x][y] = t[2]
    }

    dist := make([]int, n)
    for i := range dist {
        dist[i] = inf
    }
    dist[k-1] = 0
    used := make([]bool, n)
    for i := 0; i < n; i++ {
        x := -1
        for y, u := range used {
            if !u && (x == -1 || dist[y] < dist[x]) {
                x = y
            }
        }
        used[x] = true
        for y, time := range g[x] {
            dist[y] = min(dist[y], dist[x]+time)
        }
    }

    for _, d := range dist {
        if d == inf {
            return -1
        }
        ans = max(ans, d)
    }
    return
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```Python [sol11-Python3]
class Solution:
    def networkDelayTime(self, times: List[List[int]], n: int, k: int) -> int:
        g = [[float('inf')] * n for _ in range(n)]
        for x, y, time in times:
            g[x - 1][y - 1] = time

        dist = [float('inf')] * n
        dist[k - 1] = 0
        used = [False] * n
        for _ in range(n):
            x = -1
            for y, u in enumerate(used):
                if not u and (x == -1 or dist[y] < dist[x]):
                    x = y
            used[x] = True
            for y, time in enumerate(g[x]):
                dist[y] = min(dist[y], dist[x] + time)

        ans = max(dist)
        return ans if ans < float('inf') else -1
```

```JavaScript [sol11-JavaScript]
var networkDelayTime = function(times, n, k) {
    const INF = Number.MAX_SAFE_INTEGER;
    const g = new Array(n).fill(INF).map(() => new Array(n).fill(INF));
    for (const t of times) {
        const x = t[0] - 1, y = t[1] - 1;
        g[x][y] = t[2];
    }

    const dist = new Array(n).fill(INF);
    dist[k - 1] = 0;
    const used = new Array(n).fill(false);
    for (let i = 0; i < n; ++i) {
        let x = -1;
        for (let y = 0; y < n; ++y) {
            if (!used[y] && (x === -1 || dist[y] < dist[x])) {
                x = y;
            }
        }
        used[x] = true;
        for (let y = 0; y < n; ++y) {
            dist[y] = Math.min(dist[y], dist[x] + g[x][y]);
        }
    }

    let ans = Math.max(...dist);
    return ans === INF ? -1 : ans;
};
```

```C [sol11-C]
int networkDelayTime(int** times, int timesSize, int* timesColSize, int n, int k) {
    const int inf = 0x3f3f3f3f;
    int g[n][n];
    memset(g, 0x3f, sizeof(g));
    for (int i = 0; i < timesSize; i++) {
        int x = times[i][0] - 1, y = times[i][1] - 1;
        g[x][y] = times[i][2];
    }

    int dist[n];
    memset(dist, 0x3f, sizeof(dist));
    dist[k - 1] = 0;
    int used[n];
    memset(used, 0, sizeof(used));
    int ans = 0;
    for (int i = 0; i < n; ++i) {
        int x = -1;
        for (int y = 0; y < n; ++y) {
            if (!used[y] && (x == -1 || dist[y] < dist[x])) {
                x = y;
            }
        }
        used[x] = true;
        ans = fmax(ans, dist[x]);
        for (int y = 0; y < n; ++y) {
            dist[y] = fmin(dist[y], dist[x] + g[x][y]);
        }
    }

    return ans == inf ? -1 : ans;
}
```

除了枚举，我们还可以使用一个小根堆来寻找「未确定节点」中与起点距离最近的点。

```C++ [sol12-C++]
class Solution {
public:
    int networkDelayTime(vector<vector<int>> &times, int n, int k) {
        const int inf = INT_MAX / 2;
        vector<vector<pair<int, int>>> g(n);
        for (auto &t : times) {
            int x = t[0] - 1, y = t[1] - 1;
            g[x].emplace_back(y, t[2]);
        }

        vector<int> dist(n, inf);
        dist[k - 1] = 0;
        priority_queue<pair<int, int>, vector<pair<int, int>>, greater<>> q;
        q.emplace(0, k - 1);
        while (!q.empty()) {
            auto p = q.top();
            q.pop();
            int time = p.first, x = p.second;
            if (dist[x] < time) {
                continue;
            }
            for (auto &e : g[x]) {
                int y = e.first, d = dist[x] + e.second;
                if (d < dist[y]) {
                    dist[y] = d;
                    q.emplace(d, y);
                }
            }
        }

        int ans = *max_element(dist.begin(), dist.end());
        return ans == inf ? -1 : ans;
    }
};
```

```Java [sol12-Java]
class Solution {
    public int networkDelayTime(int[][] times, int n, int k) {
        final int INF = Integer.MAX_VALUE / 2;
        List<int[]>[] g = new List[n];
        for (int i = 0; i < n; ++i) {
            g[i] = new ArrayList<int[]>();
        }
        for (int[] t : times) {
            int x = t[0] - 1, y = t[1] - 1;
            g[x].add(new int[]{y, t[2]});
        }

        int[] dist = new int[n];
        Arrays.fill(dist, INF);
        dist[k - 1] = 0;
        PriorityQueue<int[]> pq = new PriorityQueue<int[]>((a, b) -> a[0] != b[0] ? a[0] - b[0] : a[1] - b[1]);
        pq.offer(new int[]{0, k - 1});
        while (!pq.isEmpty()) {
            int[] p = pq.poll();
            int time = p[0], x = p[1];
            if (dist[x] < time) {
                continue;
            }
            for (int[] e : g[x]) {
                int y = e[0], d = dist[x] + e[1];
                if (d < dist[y]) {
                    dist[y] = d;
                    pq.offer(new int[]{d, y});
                }
            }
        }

        int ans = Arrays.stream(dist).max().getAsInt();
        return ans == INF ? -1 : ans;
    }
}
```

```go [sol12-Golang]
func networkDelayTime(times [][]int, n, k int) (ans int) {
    type edge struct{ to, time int }
    g := make([][]edge, n)
    for _, t := range times {
        x, y := t[0]-1, t[1]-1
        g[x] = append(g[x], edge{y, t[2]})
    }

    const inf int = math.MaxInt64 / 2
    dist := make([]int, n)
    for i := range dist {
        dist[i] = inf
    }
    dist[k-1] = 0
    h := &hp{{0, k - 1}}
    for h.Len() > 0 {
        p := heap.Pop(h).(pair)
        x := p.x
        if dist[x] < p.d {
            continue
        }
        for _, e := range g[x] {
            y := e.to
            if d := dist[x] + e.time; d < dist[y] {
                dist[y] = d
                heap.Push(h, pair{d, y})
            }
        }
    }

    for _, d := range dist {
        if d == inf {
            return -1
        }
        ans = max(ans, d)
    }
    return
}

type pair struct{ d, x int }
type hp []pair

func (h hp) Len() int              { return len(h) }
func (h hp) Less(i, j int) bool    { return h[i].d < h[j].d }
func (h hp) Swap(i, j int)         { h[i], h[j] = h[j], h[i] }
func (h *hp) Push(v interface{})   { *h = append(*h, v.(pair)) }
func (h *hp) Pop() (v interface{}) { a := *h; *h, v = a[:len(a)-1], a[len(a)-1]; return }

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```Python [sol12-Python3]
class Solution:
    def networkDelayTime(self, times: List[List[int]], n: int, k: int) -> int:
        g = [[] for _ in range(n)]
        for x, y, time in times:
            g[x - 1].append((y - 1, time))

        dist = [float('inf')] * n
        dist[k - 1] = 0
        q = [(0, k - 1)]
        while q:
            time, x = heapq.heappop(q)
            if dist[x] < time:
                continue
            for y, time in g[x]:
                if (d := dist[x] + time) < dist[y]:
                    dist[y] = d
                    heapq.heappush(q, (d, y))

        ans = max(dist)
        return ans if ans < float('inf') else -1
```

**复杂度分析**

枚举写法的复杂度如下：

- 时间复杂度：$O(n^2+m)$，其中 $m$ 是数组 $\textit{times}$ 的长度。

- 空间复杂度：$O(n^2)$。邻接矩阵需占用 $O(n^2)$ 的空间。

堆的写法复杂度如下：

- 时间复杂度：$O(m\log m)$，其中 $m$ 是数组 $\textit{times}$ 的长度。

- 空间复杂度：$O(n+m)$。

值得注意的是，由于本题边数远大于点数，是一张稠密图，因此在运行时间上，枚举写法要略快于堆的写法。
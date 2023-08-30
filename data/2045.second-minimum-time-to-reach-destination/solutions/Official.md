#### 方法一：广度优先搜索

**思路与算法**

依题意知，同一路径长度所需要花费的时间是相同的，且路径越长，所需时间越久。因此，如果我们可以求得到达目的地的严格次短路径，就可以直接计算到达目的地的第二短时间。

求解权重相同的最短路径问题可以采用广度优先搜索，这里我们做一些修改。使用广度优先搜索求解最短路径时，经过的点与初始点的路径长度是所有未搜索过的路径中的最小值，因此每次广度优先搜索获得的经过点与初始点的路径长度是非递减的。我们可以记录下所有点与初始点的最短路径与严格次短路径，一旦求得目的点的严格次短路径，我们就可以直接计算到达目的地的第二短时间。

对于路径长度与时间的计算，假设到达节点 $i$ 的时间为 $t_i$，则到达节点 $i+1$ 的时间为：

$$t_{i+1} = t_i + t_\textit{wait} + \textit{time}$$

其中 $t_\textit{wait}$ 的计算如下：

$$
t_\textit{wait}=
\begin{cases}
    0, & t_i \bmod (2 \times \textit{change}) \in [0, ~\textit{change})
    \\
    2 \times \textit{change} - t_i \bmod (2 \times \textit{change}), & t_i \bmod (2 \times \textit{change}) \in [\textit{change}, ~2 \times \textit{change})
\end{cases}
$$

**代码**

```Python [sol1-Python3]
class Solution:
    def secondMinimum(self, n: int, edges: List[List[int]], time: int, change: int) -> int:
        graph = [[] for _ in range(n + 1)]
        for e in edges:
            x, y = e[0], e[1]
            graph[x].append(y)
            graph[y].append(x)

        # dist[i][0] 表示从 1 到 i 的最短路长度，dist[i][1] 表示从 1 到 i 的严格次短路长度
        dist = [[float('inf')] * 2 for _ in range(n + 1)]
        dist[1][0] = 0
        q = deque([(1, 0)])
        while dist[n][1] == float('inf'):
            p = q.popleft()
            for y in graph[p[0]]:
                d = p[1] + 1
                if d < dist[y][0]:
                    dist[y][0] = d
                    q.append((y, d))
                elif dist[y][0] < d < dist[y][1]:
                    dist[y][1] = d
                    q.append((y, d))

        ans = 0
        for _ in range(dist[n][1]):
            if ans % (change * 2) >= change:
                ans += change * 2 - ans % (change * 2)
            ans += time
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int secondMinimum(int n, vector<vector<int>>& edges, int time, int change) {
        vector<vector<int>> graph(n + 1);
        for (auto &e : edges) {
            graph[e[0]].push_back(e[1]);
            graph[e[1]].push_back(e[0]);
        }

        // path[i][0] 表示从 1 到 i 的最短路长度，path[i][1] 表示从 1 到 i 的严格次短路长度
        vector<vector<int>> path(n + 1, vector<int>(2, INT_MAX));
        path[1][0] = 0;
        queue<pair<int, int>> q;
        q.push({1, 0});
        while (path[n][1] == INT_MAX) {
            auto [cur, len] = q.front();
            q.pop();
            for (auto next : graph[cur]) {
                if (len + 1 < path[next][0]) {
                    path[next][0] = len + 1;
                    q.push({next, len + 1});
                } else if (len + 1 > path[next][0] && len + 1 < path[next][1]) {
                    path[next][1] = len + 1;
                    q.push({next, len + 1});
                }
            }
        }

        int ret = 0;
        for (int i = 0; i < path[n][1]; i++) {
            if (ret % (2 * change) >= change) {
                ret = ret + (2 * change - ret % (2 * change));
            }
            ret = ret + time;
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int secondMinimum(int n, int[][] edges, int time, int change) {
        List<Integer>[] graph = new List[n + 1];
        for (int i = 0; i <= n; i++) {
            graph[i] = new ArrayList<Integer>();
        }
        for (int[] edge : edges) {
            graph[edge[0]].add(edge[1]);
            graph[edge[1]].add(edge[0]);
        }

        // path[i][0] 表示从 1 到 i 的最短路长度，path[i][1] 表示从 1 到 i 的严格次短路长度
        int[][] path = new int[n + 1][2];
        for (int i = 0; i <= n; i++) {
            Arrays.fill(path[i], Integer.MAX_VALUE);
        }
        path[1][0] = 0;
        Queue<int[]> queue = new ArrayDeque<int[]>();
        queue.offer(new int[]{1, 0});
        while (path[n][1] == Integer.MAX_VALUE) {
            int[] arr = queue.poll();
            int cur = arr[0], len = arr[1];
            for (int next : graph[cur]) {
                if (len + 1 < path[next][0]) {
                    path[next][0] = len + 1;
                    queue.offer(new int[]{next, len + 1});
                } else if (len + 1 > path[next][0] && len + 1 < path[next][1]) {
                    path[next][1] = len + 1;
                    queue.offer(new int[]{next, len + 1});
                }
            }
        }

        int ret = 0;
        for (int i = 0; i < path[n][1]; i++) {
            if (ret % (2 * change) >= change) {
                ret = ret + (2 * change - ret % (2 * change));
            }
            ret = ret + time;
        }
        return ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int SecondMinimum(int n, int[][] edges, int time, int change) {
        IList<int>[] graph = new IList<int>[n + 1];
        for (int i = 0; i <= n; i++) {
            graph[i] = new List<int>();
        }
        foreach (int[] edge in edges) {
            graph[edge[0]].Add(edge[1]);
            graph[edge[1]].Add(edge[0]);
        }

        // path[i][0] 表示从 1 到 i 的最短路长度，path[i][1] 表示从 1 到 i 的严格次短路长度
        int[,] path = new int[n + 1, 2];
        for (int i = 0; i <= n; i++) {
            for (int j = 0; j < 2; j++) {
                path[i, j] = int.MaxValue;
            }
        }
        path[1, 0] = 0;
        Queue<int[]> queue = new Queue<int[]>();
        queue.Enqueue(new int[]{1, 0});
        while (path[n, 1] == int.MaxValue) {
            int[] arr = queue.Dequeue();
            int cur = arr[0], len = arr[1];
            foreach (int next in graph[cur]) {
                if (len + 1 < path[next, 0]) {
                    path[next, 0] = len + 1;
                    queue.Enqueue(new int[]{next, len + 1});
                } else if (len + 1 > path[next, 0] && len + 1 < path[next, 1]) {
                    path[next, 1] = len + 1;
                    queue.Enqueue(new int[]{next, len + 1});
                }
            }
        }

        int ret = 0;
        for (int i = 0; i < path[n, 1]; i++) {
            if (ret % (2 * change) >= change) {
                ret = ret + (2 * change - ret % (2 * change));
            }
            ret = ret + time;
        }
        return ret;
    }
}
```

```C [sol1-C]
struct Node {
    int val;
    struct Node *next;
};

struct Node *lst_alloc() {
    struct Node *ret = (struct Node *)malloc(sizeof(struct Node));
    memset(ret, 0, sizeof(struct Node));
    return ret;
}

void lst_free(struct Node *lst) {
    while (lst != NULL) {
        struct Node *tmp = lst->next;
        free(lst);
        lst = tmp;
    }
}

void lst_push_front(struct Node **plst, int val) {
    struct Node *node = lst_alloc();
    node->val = val;
    node->next = *plst;
    *plst = node;
}

struct Pair {
    int node;
    int len;
};

int secondMinimum(int n, int** edges, int edgesSize, int* edgesColSize, int time, int change) {
    struct Node **graph = (struct Node **)malloc((n + 1) * sizeof(struct Node *));
    memset(graph, 0, (n + 1) * sizeof(struct Node *));
    for (int i = 0; i < edgesSize; i++) {
        lst_push_front(&graph[edges[i][0]], edges[i][1]);
        lst_push_front(&graph[edges[i][1]], edges[i][0]);
    }

    // path[i] 表示从 1 到 i 的最短路长度，path[i+n] 表示从 1 到 i 的严格次短路长度
    int *path = (int *)malloc((2 * n + 1) * sizeof(int));
    for (int i = 1; i <= n; i++) {
        path[i] = INT_MAX;
        path[i + n] = INT_MAX;
    }

    struct Pair *queue = (struct Pair *)malloc((2 * n + 1) * sizeof(struct Pair));
    int front = 0, back = 0;

    path[1] = 0;
    queue[back].node = 1;
    queue[back++].len = 0;

    while (path[n + n] == INT_MAX) {
        int cur = queue[front].node;
        int len = queue[front++].len;
        struct Node *next = graph[cur];
        while (next) {
            if (len + 1 < path[next->val]) {
                path[next->val] = len + 1;
                queue[back].node = next->val;
                queue[back++].len = len + 1;
            } else if (len + 1 > path[next->val] && len + 1 < path[next->val + n]) {
                path[next->val + n] = len + 1;
                queue[back].node = next->val;
                queue[back++].len = len + 1;
            }
            next = next->next;
        }
    }

    int ret = 0;
    for (int i = 0; i < path[n + n]; i++) {
        if (ret % (2 * change) >= change) {
            ret = ret + 2 * change - ret % (2 * change);
        }
        ret = ret + time;
    }

    free(queue);
    free(path);
    for (int i = 1; i <= n; i++) {
        lst_free(graph[i]);
    }
    free(graph);

    return ret;
}
```

```JavaScript [sol1-JavaScript]
var secondMinimum = function(n, edges, time, change) {
    const graph = new Array(n + 1).fill(0).map(() => new Array());
    for (const edge of edges) {
        graph[edge[0]].push(edge[1]);
        graph[edge[1]].push(edge[0]);
    }

    // path[i][0] 表示从 1 到 i 的最短路长度，path[i][1] 表示从 1 到 i 的严格次短路长度
    const path = new Array(n + 1).fill(0).map(() => new Array(2).fill(Number.MAX_VALUE));
    path[1][0] = 0;
    const queue = [];
    queue.push([1, 0]);
    while (path[n][1] === Number.MAX_VALUE) {
        const [cur, len] = queue.shift();
        for (const next of graph[cur]) {
            if (len + 1 < path[next][0]) {
                path[next][0] = len + 1;
                queue.push([next, len + 1]);
            } else if (len + 1 > path[next][0] && len + 1 < path[next][1]) {
                path[next][1] = len + 1;
                queue.push([next, len + 1]);
            }
        }
    }

    let ret = 0;
    for (let i = 0; i < path[n][1]; i++) {
        if (ret % (2 * change) >= change) {
            ret = ret + (2 * change - ret % (2 * change));
        }
        ret = ret + time;
    }
    return ret;
};
```

```go [sol1-Golang]
func secondMinimum(n int, edges [][]int, time, change int) (ans int) {
    graph := make([][]int, n+1)
    for _, e := range edges {
        x, y := e[0], e[1]
        graph[x] = append(graph[x], y)
        graph[y] = append(graph[y], x)
    }

    // dist[i][0] 表示从 1 到 i 的最短路长度，dist[i][1] 表示从 1 到 i 的严格次短路长度
    dist := make([][2]int, n+1)
    dist[1][1] = math.MaxInt32
    for i := 2; i <= n; i++ {
        dist[i] = [2]int{math.MaxInt32, math.MaxInt32}
    }
    type pair struct{ x, d int }
    q := []pair{{1, 0}}
    for dist[n][1] == math.MaxInt32 {
        p := q[0]
        q = q[1:]
        for _, y := range graph[p.x] {
            d := p.d + 1
            if d < dist[y][0] {
                dist[y][0] = d
                q = append(q, pair{y, d})
            } else if dist[y][0] < d && d < dist[y][1] {
                dist[y][1] = d
                q = append(q, pair{y, d})
            }
        }
    }

    for i := 0; i < dist[n][1]; i++ {
        if ans%(change*2) >= change {
            ans += change*2 - ans%(change*2)
        }
        ans += time
    }
    return
}
```

**复杂度分析**

+ 时间复杂度：$O(n+e)$，其中 $n$ 是图的节点数，$e$ 是图的边数。广度优先搜索队列保存过的元素不超过 $2 \times n$，因此整个循环的次数不超过 $2 \times n$，即 $O(n)$，而循环内访问边的总次数不会超过 $2 \times e$，因此访问边需要 $O(e)$。

+ 空间复杂度：$O(n+e)$。建图 $\textit{graph}$ 需要 $O(e)$ 的空间，保存路径长度 $\textit{path}$ 需要 $O(n)$ 的空间，广度优先搜索队列的元素个数不超过 $2 \times n$，需要 $O(n)$ 的空间。
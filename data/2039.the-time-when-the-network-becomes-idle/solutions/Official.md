## [2039.网络空闲的时刻 中文官方题解](https://leetcode.cn/problems/the-time-when-the-network-becomes-idle/solutions/100000/wang-luo-kong-xian-de-shi-ke-by-leetcode-qttv)

#### 方法一：广度优先搜索

**思路**

我们可以将整个计算机网络视为一个无向图，服务器为图中的节点。根据图中的边对应的关系 $\textit{edges}$ 即可求出图中任意节点之间的最短距离。利用广度优先搜索求出节点 $0$ 到其他节点的最短距离，然后依次求出每个节点变为空闲的时间，当所有节点都变为空闲时，整个网络即变空闲状态，因此网络的最早空闲时间即为各个节点中最晚的空闲时间。定义节点的空闲状态定义为该节点不再发送和接收消息。

+ 求各个节点与 $0$ 号服务器的最短路径，直接利用广度优先搜索即可。

+ 设节点 $v$ 与节点 $0$ 之间的最短距离为 $\textit{dist}$，则此时当节点 $v$ 接收到主服务器节点 $0$ 的最后一个回复后的下一秒，则节点 $v$ 变为空闲状态。节点 $v$ 发送一个消息经过 $\textit{dist}$ 秒到达节点 $0$，节点 $0$ 回复消息又经过 $\textit{dist}$ 秒到达节点 $v$，因此节点 $v$ 每发送一次消息后，经过 $2 \times \textit{dist}$ 秒才能收到回复。由于节点 $v$ 在未收到节点 $0$ 的回复时，会周期性每 $\textit{patience}[v]$ 秒发送一次消息，一旦收到来自节点 $0$ 的回复后就停止发送消息，需要分以下两种情况进行讨论：

    - 当 $2 \times \textit{dist} \le \textit{patience}[v]$ 时，则此时节点 $v$ 还未开始发送第二次消息就已收到回复，因此节点 $v$ 只会发送一次消息，则此时节点 $v$ 变为空闲的时间为 $2 \times \textit{dist} + 1$。

    - 当 $2 \times \textit{dist} > \textit{patience}[v]$ 时，则此时节点还在等待第一次发送消息的回复时，就会开始再次重发消息，经过计算可以知道在 $[1,2 \times \textit{dist})$ 时间范围内会最多再次发送 $\Big\lfloor\dfrac{2 \times \textit{dist}-1}{\textit{patience}[i]}\Big\rfloor$ 次消息，最后一次发送消息的时间为 $\textit{patience}[v] \times \Big\lfloor\dfrac{2 \times \textit{dist}-1}{\textit{patience}[v]}\Big\rfloor$，而节点 $v$ 每发送一次消息就会经过 $2 \times \textit{dist}[v]$ 收到回复，因此节点 $v$ 最后一次收到回复的时间为 $\textit{patience}[v] \times \Big\lfloor\dfrac{2 \times \textit{dist}-1}{\textit{patience}[v]}\Big\rfloor + 2 \times \textit{dist}$，则此时可知节点 $v$ 变为空闲的时间为 $\textit{patience}[v] \times \Big\lfloor\dfrac{2 \times \textit{dist}-1}{\textit{patience}[v]}\Big\rfloor + 2 \times \textit{dist} + 1$。
    
   当 $2 \times \textit{dist} \le \textit{patience}[v]$ 时，$\Big\lfloor\dfrac{2 \times \textit{dist}-1}{\textit{patience}[v]}\Big\rfloor = 0$，因此以上两种情况可以进行合并，即节点 $v$ 变为空闲的时间为 $\textit{patience}[v] \times \Big\lfloor\dfrac{2 \times \textit{dist}-1}{\textit{patience}[v]}\Big\rfloor + 2 \times \textit{dist} + 1$。

依次求出每个节点变为空闲的时间，返回最大值即为答案。

**代码**

```Python [sol1-Python3]
class Solution:
    def networkBecomesIdle(self, edges: List[List[int]], patience: List[int]) -> int:
        n = len(patience)
        g = [[] for _ in range(n)]
        for u, v in edges:
            g[u].append(v)
            g[v].append(u)

        vis = [False] * n
        vis[0] = True
        q = deque([0])
        ans, dist = 0, 1
        while q:
            for _ in range(len(q)):
                u = q.popleft()
                for v in g[u]:
                    if vis[v]:
                        continue
                    vis[v] = True
                    q.append(v)
                    ans = max(ans, (dist * 2 - 1) // patience[v] * patience[v] + dist * 2 + 1)
            dist += 1
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int networkBecomesIdle(vector<vector<int>>& edges, vector<int>& patience) {
        int n = patience.size();       
        vector<vector<int>> adj(n);
        vector<bool> visit(n, false);  
        for (auto & v : edges) {
            adj[v[0]].emplace_back(v[1]);
            adj[v[1]].emplace_back(v[0]);
        }

        queue<int> qu;
        qu.emplace(0);
        visit[0] = true;
        int dist = 1;
        int ans = 0;
        while (!qu.empty()) {
            int sz = qu.size();
            for (int i = 0; i < sz; ++i) {
                int curr = qu.front();
                qu.pop();
                for (auto & v : adj[curr]) {
                    if (visit[v]) {
                        continue;
                    }
                    qu.emplace(v);
                    int time = patience[v] * ((2 * dist - 1) / patience[v]) + 2 * dist + 1;
                    ans = max(ans, time);
                    visit[v] = true;
                }
            }
            dist++;
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int networkBecomesIdle(int[][] edges, int[] patience) {
        int n = patience.length;       
        List<Integer>[] adj = new List[n];
        for (int i = 0; i < n; ++i) {
            adj[i] = new ArrayList<Integer>();
        }
        boolean[] visit = new boolean[n];
        for (int[] v : edges) {
            adj[v[0]].add(v[1]);
            adj[v[1]].add(v[0]);
        }

        Queue<Integer> queue = new ArrayDeque<Integer>();
        queue.offer(0);
        visit[0] = true;
        int dist = 1;
        int ans = 0;
        while (!queue.isEmpty()) {
            int size = queue.size();
            for (int i = 0; i < size; i++) {
                int curr = queue.poll();
                for (int v : adj[curr]) {
                    if (visit[v]) {
                        continue;
                    }
                    queue.offer(v);
                    int time = patience[v] * ((2 * dist - 1) / patience[v]) + 2 * dist + 1;
                    ans = Math.max(ans, time);
                    visit[v] = true;
                }
            }
            dist++;
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NetworkBecomesIdle(int[][] edges, int[] patience) {
        int n = patience.Length;       
        IList<int>[] adj = new IList<int>[n];
        for (int i = 0; i < n; ++i) {
            adj[i] = new List<int>();
        }
        bool[] visit = new bool[n];
        foreach (int[] v in edges) {
            adj[v[0]].Add(v[1]);
            adj[v[1]].Add(v[0]);
        }

        Queue<int> queue = new Queue<int>();
        queue.Enqueue(0);
        visit[0] = true;
        int dist = 1;
        int ans = 0;
        while (queue.Count > 0) {
            int size = queue.Count;
            for (int i = 0; i < size; i++) {
                int curr = queue.Dequeue();
                foreach (int v in adj[curr]) {
                    if (visit[v]) {
                        continue;
                    }
                    queue.Enqueue(v);
                    int time = patience[v] * ((2 * dist - 1) / patience[v]) + 2 * dist + 1;
                    ans = Math.Max(ans, time);
                    visit[v] = true;
                }
            }
            dist++;
        }
        return ans;
    }
}
```

```C [sol1-C]
static inline int max(int x, int y) {
    return x > y ? x : y;
}

int networkBecomesIdle(int** edges, int edgesSize, int* edgesColSize, int* patience, int patienceSize) {
    int n = patienceSize;
    struct ListNode ** adj = (struct ListNode **)malloc(sizeof(struct ListNode * ) * n);
    bool * visit = (bool *)malloc(sizeof(bool) * n);
    for (int i = 0; i < n; i++) {
        visit[i] = false;
        adj[i] = NULL;
    }
    struct ListNode * node = NULL;
    for (int i = 0; i < edgesSize; i++) {
        node = (struct ListNode *)malloc(sizeof(struct ListNode));
        node->val = edges[i][0];
        node->next = adj[edges[i][1]];
        adj[edges[i][1]] = node;
        node = (struct ListNode *)malloc(sizeof(struct ListNode));
        node->val = edges[i][1];
        node->next = adj[edges[i][0]];
        adj[edges[i][0]] = node;
    }

    int * queue = (int *)malloc(sizeof(int) * n);
    int head = 0;
    int tail = 0;
    queue[tail++] = 0;
    visit[0] = true;
    int dist = 1;
    int ans = 0;
    while (head != tail) {
        int sz = tail - head;
        for (int i = 0; i < sz; ++i) {
            int curr = queue[head];
            head++;
            for (struct ListNode * node = adj[curr]; node; node = node->next) {
                int v = node->val;
                if (visit[v]) {
                    continue;
                }
                queue[tail++] = v;
                int time = patience[v] * ((2 * dist - 1) / patience[v]) + 2 * dist + 1;
                ans = max(ans, time);
                visit[v] = true;
            }
        }
        dist++;
    }
    free(queue);
    free(visit);
    for (int i = 0; i < n; i++) {
        for (struct ListNode * curr = adj[i]; curr;) {
            struct ListNode * next = curr->next;
            free(curr);
            curr = next;
        }
    }
    return ans;
}
```

```go [sol1-Golang]
func networkBecomesIdle(edges [][]int, patience []int) (ans int) {
    n := len(patience)
    g := make([][]int, n)
    for _, e := range edges {
        x, y := e[0], e[1]
        g[x] = append(g[x], y)
        g[y] = append(g[y], x)
    }

    vis := make([]bool, n)
    vis[0] = true
    q := []int{0}
    for dist := 1; q != nil; dist++ {
        tmp := q
        q = nil
        for _, x := range tmp {
            for _, v := range g[x] {
                if vis[v] {
                    continue
                }
                vis[v] = true
                q = append(q, v)
                ans = max(ans, (dist*2-1)/patience[v]*patience[v]+dist*2+1)
            }
        }
    }
    return
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n + m)$，其中 $n$ 为节点的数目，$m$ 为 $\textit{edges}$ 数组的大小。利用广度优先搜索求每个节点到节点 $0$ 的最短距离的时间复杂度为 $O(n + m)$，求出每个节点的空闲时间的时间复杂度为 $O(n)$，因此总的时间复杂度为 $O(n + m)$。

- 空间复杂度：$O(n + m)$，其中 $n$ 为节点的数目，$m$ 为 $\textit{edges}$ 数组的大小。需要利用 $\textit{edges}$ 重建图的关系，需要的空间为 $O(n + m)$，记录每个节点到节点 $0$ 的最短距离需要的空间为 $O(n)$，因此总的空间复杂度为 $O(n + m)$。
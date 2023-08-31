## [2203.得到要求路径的最小带权子图 中文官方题解](https://leetcode.cn/problems/minimum-weighted-subgraph-with-the-required-paths/solutions/100000/de-dao-yao-qiu-lu-jing-de-zui-xiao-dai-q-mj2c)

#### 方法一：分析 + 三次最短路

**提示 $1$**

边权和最小的子图呈现「$Y$ 型」。

**提示 $1$ 解释**

首先我们可以知道，在边权和最小的子图中的任意两个点 $u$ 和 $v$，如果 $u$ 可以到达 $v$，那么从 $u$ 到 $v$ 一定只有**唯一**的一条简单路径。这是因为如果存在多条路径，我们也只会走最短的那一条，因此不在最短路径上的那些边都是无意义的，我们可以将它们移除。

这样一来：

- 从 $\textit{src}_1$ 到 $\textit{dest}$ 有唯一的一条简单路径，记为 $X$；

- 从 $\textit{src}_2$ 到 $\textit{dest}$ 有唯一的一条简单路径，记为 $Y$。

假设 $X$ 上第一个与 $Y$ 共有的节点为 $c$，显然这样的 $c$ 是一定存在的，因为 $\textit{dest}$ 就是 $X$ 和 $Y$ 的一个共有节点（但可能存在更早的共有节点）。我们可以断定，从 $c$ 开始到 $\textit{dest}$ 结束的这一部分，在 $X$ 和 $Y$ 中一定是**完全相同的**，这是因为 $c$ 到 $\textit{dest}$ 一定只有唯一的一条简单路径，因此 $X$ 和 $Y$ 必定共有这条路径。因此，整个子图可以看成是三部分的并集：

- 从 $\textit{src}_1$ 到 $c$ 的一条简单路径；

- 从 $\textit{src}_2$ 到 $c$ 的一条简单路径；

- 从 $c$ 到 $\textit{dest}$ 的一条简单路径。

此时子图的边权和即为这三部分的边权和之和，即子图呈现「$Y$ 型」。如果 $c$ 与 $\textit{src}_1$，$\textit{src}_2$ 或者 $\textit{dest}$ 中的某个节点重合，那么也是满足要求的。

**思路与算法**

我们可以枚举 $c$ 来得到边权和最小的子图。此时，我们就需要计算出「从 $\textit{src}_1$ 到 $c$」「从 $\textit{src}_2$ 到 $c$」「从 $c$ 到 $\textit{dest}$」这三部分的最短路径。

对于「从 $\textit{src}_1$ 到 $c$」「从 $\textit{src}_2$ 到 $c$」这两部分而言，我们可以使用两次 $\text{Dijkstra}$ 算法计算出以 $\textit{src}_1$ 为出发点和以 $\textit{src}_2$ 为出发点，到所有节点的最短路径长度。而对于「从 $c$ 到 $\textit{dest}$」这一部分，我们可以将原图中的所有边反向，这样就变成了「从 $\textit{dest}$ 到 $c$」。我们就可以使用 $\text{Dijkstra}$ 算法计算出以 $\textit{dest}$ 为出发点，到所有节点的最短路径长度。

在得到了所有需要的最短路径的长度之后，我们就可以枚举 $c$ 得出答案了。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    long long minimumWeight(int n, vector<vector<int>>& edges, int src1, int src2, int dest) {
        vector<vector<pair<int, int>>> g(n), grev(n);
        for (const auto& edge: edges) {
            int x = edge[0], y = edge[1], z = edge[2];
            g[x].emplace_back(y, z);
            grev[y].emplace_back(x, z);
        }
        
        auto dijkstra = [&n](const vector<vector<pair<int, int>>>& graph, int start) -> vector<long long> {
            vector<long long> dist(n, -1);
            dist[start] = 0;
            vector<int> used(n);
            priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> q;
            q.emplace(0, start);
            
            while (!q.empty()) {
                int u = q.top().second;
                q.pop();
                if (used[u]) {
                    continue;
                }
                used[u] = true;
                
                for (const auto& [v, weight]: graph[u]) {
                    long long target = dist[u] + weight;
                    if (dist[v] == -1 || target < dist[v]) {
                        dist[v] = target;
                        q.emplace(dist[v], v);
                    }
                }
            }
            
            return dist;
        };
        
        vector<long long> dist1 = dijkstra(g, src1);
        vector<long long> dist2 = dijkstra(g, src2);
        vector<long long> dist3 = dijkstra(grev, dest);
        
        long long ans = -1;
        for (int i = 0; i < n; ++i) {
            if (dist1[i] != -1 && dist2[i] != -1 && dist3[i] != -1) {
                long long result = dist1[i] + dist2[i] + dist3[i];
                if (ans == -1 || result < ans) {
                    ans = result;
                }
            }
        }
        
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minimumWeight(self, n: int, edges: List[List[int]], src1: int, src2: int, dest: int) -> int:
        g, grev = defaultdict(list), defaultdict(list)
        for (x, y, z) in edges:
            g[x].append((y, z))
            grev[y].append((x, z))
        
        def dijkstra(graph: Dict[int, List[int]], start: int) -> List[int]:
            dist = [-1] * n
            dist[start] = 0
            used = set()
            q = [(0, start)]

            while q:
                u = heapq.heappop(q)[1]
                if u in used:
                    continue
                
                used.add(u)
                for (v, weight) in graph[u]:
                    target = dist[u] + weight
                    if dist[v] == -1 or target < dist[v]:
                        dist[v] = target
                        heapq.heappush(q, (dist[v], v))
            
            return dist
        
        dist1, dist2, dist3 = dijkstra(g, src1), dijkstra(g, src2), dijkstra(grev, dest)
        
        ans = -1
        for i in range(n):
            if dist1[i] != -1 and dist2[i] != -1 and dist3[i] != -1:
                result = dist1[i] + dist2[i] + dist3[i]
                if ans == -1 or result < ans:
                    ans = result
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n + m \log m)$，其中 $m$ 是数组 $\textit{edges}$ 的长度。

- 空间复杂度：$O(m)$，即为存储图和反向图的邻接表需要使用的空间。
## [882.细分图中的可到达节点 中文官方题解](https://leetcode.cn/problems/reachable-nodes-in-subdivided-graph/solutions/100000/xi-fen-tu-zhong-de-ke-dao-da-jie-dian-by-u8m1)

#### 方法一：Dijkstra 算法

**思路**

当图中只存在原始节点而不存在细分节点时，此题可以用 Dijkstra 算法解决：将输入的 $\textit{edges}$ 转换成邻接表 $\textit{adList}$，维护一个小顶堆 $\textit{pq}$ 可以依次计算出图中的起点到各个点最短路径，从而计算出可到达节点。$\textit{pq}$ 中的元素为节点以及起点到该节点的路径长度，并以路径长度为比较元素。每次取出未访问过的节点中的路径最短的节点，并访问其邻接点，若路径长度仍小于等于 $\textit{maxMoves}$ 且未访问过，可将其放入 $\textit{pq}$，直至 $\textit{pq}$ 为空或 $\textit{pq}$ 最短路径大于 $\textit{maxMoves}$。

但当每条边上都加入细分节点后，需要考虑细分节点是否可达。用一个哈希表 $\textit{used}$ 记录各条边上的细分节点的可达情况，键为二元点对 $(u,v)$ 表示从点 $u$ 到点 $v$ 的边，值为这条边上的可达细分节点数。注意在计算细分节点时，是考虑单向的情况，即会分别计算 $\textit{used}[(u, v)]$ 和 $\textit{used}[(v, u)]$，并且这两个值不一定相等。计算 $\textit{used}$ 时，是要在访问路径最短的节点 $u$ 的邻接节点 $v$ 时计算。如果邻接节点的路径长度小于等于 $\textit{maxMoves}$，说明这条边上的细分节点都可达，否则只有一部分可达，且这部分细分节点是靠近节点 $u$ 的。

计算总的可达节点时，需要加上细分节点的部分。但每条边上的细分节点可能会被计算过两次，即 $\textit{used}[(u, v)$ 和 $\textit{used}[(v, u)]$，他们分别是是靠近 $u$ 开始计算的和靠近 $v$ 开始计算的，需要对这两部分进行去重。

**代码**

```Python [sol1-Python3]
class Solution:
    def reachableNodes(self, edges: List[List[int]], maxMoves: int, n: int) -> int:
        adList = defaultdict(list)
        for u, v, nodes in edges:
            adList[u].append([v, nodes])
            adList[v].append([u, nodes])
        used = {}
        visited = set()
        reachableNodes = 0
        pq = [[0, 0]]

        while pq and pq[0][0] <= maxMoves:
            step, u = heapq.heappop(pq)
            if u in visited:
                continue
            visited.add(u)
            reachableNodes += 1
            for v, nodes in adList[u]:
                if nodes + step + 1 <= maxMoves and v not in visited:
                    heappush(pq, [nodes + step + 1, v])
                used[(u, v)] = min(nodes, maxMoves - step)

        for u, v, nodes in edges:
            reachableNodes += min(nodes, used.get((u, v), 0) + used.get((v, u), 0))
        return reachableNodes
```

```Java [sol1-Java]
class Solution {
    public int reachableNodes(int[][] edges, int maxMoves, int n) {
        List<int[]>[] adList = new List[n];
        for (int i = 0; i < n; i++) {
            adList[i] = new ArrayList<int[]>();
        }
        for (int[] edge : edges) {
            int u = edge[0], v = edge[1], nodes = edge[2];
            adList[u].add(new int[]{v, nodes});
            adList[v].add(new int[]{u, nodes});
        }
        Map<Integer, Integer> used = new HashMap<Integer, Integer>();
        Set<Integer> visited = new HashSet<Integer>();
        int reachableNodes = 0;
        PriorityQueue<int[]> pq = new PriorityQueue<int[]>((a, b) -> a[0] - b[0]);
        pq.offer(new int[]{0, 0});

        while (!pq.isEmpty() && pq.peek()[0] <= maxMoves) {
            int[] pair = pq.poll();
            int step = pair[0], u = pair[1];
            if (!visited.add(u)) {
                continue;
            }
            reachableNodes++;
            for (int[] next : adList[u]) {
                int v = next[0], nodes = next[1];
                if (nodes + step + 1 <= maxMoves && !visited.contains(v)) {
                    pq.offer(new int[]{nodes + step + 1, v});
                }
                used.put(encode(u, v, n), Math.min(nodes, maxMoves - step));
            }
        }

        for (int[] edge : edges) {
            int u = edge[0], v = edge[1], nodes = edge[2];
            reachableNodes += Math.min(nodes, used.getOrDefault(encode(u, v, n), 0) + used.getOrDefault(encode(v, u, n), 0));
        }
        return reachableNodes;
    }

    public int encode(int u, int v, int n) {
        return u * n + v;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int ReachableNodes(int[][] edges, int maxMoves, int n) {
        IList<int[]>[] adList = new IList<int[]>[n];
        for (int i = 0; i < n; i++) {
            adList[i] = new List<int[]>();
        }
        foreach (int[] edge in edges) {
            int u = edge[0], v = edge[1], nodes = edge[2];
            adList[u].Add(new int[]{v, nodes});
            adList[v].Add(new int[]{u, nodes});
        }
        IDictionary<int, int> used = new Dictionary<int, int>();
        ISet<int> visited = new HashSet<int>();
        int reachableNodes = 0;
        PriorityQueue<int[], int> pq = new PriorityQueue<int[], int>();
        pq.Enqueue(new int[]{0, 0}, 0);

        while (pq.Count > 0 && pq.Peek()[0] <= maxMoves) {
            int[] pair = pq.Dequeue();
            int step = pair[0], u = pair[1];
            if (!visited.Add(u)) {
                continue;
            }
            reachableNodes++;
            foreach (int[] next in adList[u]) {
                int v = next[0], nodes = next[1];
                if (nodes + step + 1 <= maxMoves && !visited.Contains(v)) {
                    pq.Enqueue(new int[]{nodes + step + 1, v}, nodes + step + 1);
                }
                used.Add(Encode(u, v, n), Math.Min(nodes, maxMoves - step));
            }
        }

        foreach (int[] edge in edges) {
            int u = edge[0], v = edge[1], nodes = edge[2];
            int key1 = Encode(u, v, n), key2 = Encode(v, u, n);
            reachableNodes += Math.Min(nodes, (used.ContainsKey(key1) ? used[key1] : 0) + (used.ContainsKey(key2) ? used[key2] : 0));
        }
        return reachableNodes;
    }

    public int Encode(int u, int v, int n) {
        return u * n + v;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int encode(int u, int v, int n) {
        return u * n + v;
    }

    int reachableNodes(vector<vector<int>>& edges, int maxMoves, int n) {
        vector<vector<pair<int, int>>> adList(n);
        for (auto &edge : edges) {
            int u = edge[0], v = edge[1], nodes = edge[2];
            adList[u].emplace_back(v, nodes);
            adList[v].emplace_back(u, nodes);
        }

        unordered_map<int, int> used;
        unordered_set<int> visited;
        int reachableNodes = 0;
        priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pq;
        pq.emplace(0, 0);
        while (!pq.empty() && pq.top().first <= maxMoves) {
            auto [step, u] = pq.top();
            pq.pop();
            if (visited.count(u)) {
                continue;
            }
            visited.emplace(u);
            reachableNodes++;
            for (auto [v, nodes] : adList[u]) {
                if (nodes + step + 1 <= maxMoves && !visited.count(v)) {
                    pq.emplace(nodes + step + 1, v);
                }
                used[encode(u, v, n)] = min(nodes, maxMoves - step);
            }
        }

        for (auto &edge : edges) {
            int u = edge[0], v = edge[1], nodes = edge[2];
            reachableNodes += min(nodes, used[encode(u, v, n)] + used[encode(v, u, n)]);
        }
        return reachableNodes;
    }
};
```

```go [sol1-Golang]
func reachableNodes(edges [][]int, maxMoves, n int) int {
    adList := map[int][][]int{}
    for _, edge := range edges {
        u, v, nodes := edge[0], edge[1], edge[2]
        adList[u] = append(adList[u], []int{v, nodes})
        adList[v] = append(adList[v], []int{u, nodes})
    }
    used := map[int]int{}
    visited := map[int]bool{}
    reachableNodes := 0
    pq := myHeap{}
    heap.Push(&pq, []int{0, 0})

    for pq.Len() > 0 && pq[0][0] <= maxMoves {
        p := heap.Pop(&pq).([]int)
        step, u := p[0], p[1]
        if visited[u] {
            continue
        }
        visited[u] = true
        reachableNodes++
        for _, q := range adList[u] {
            v, nodes := q[0], q[1]
            if nodes+step+1 <= maxMoves && !visited[v] {
                heap.Push(&pq, []int{nodes + step + 1, v})
            }
            used[u*n+v] = min(nodes, maxMoves-step)
        }
    }

    for _, edge := range edges {
        u, v, nodes := edge[0], edge[1], edge[2]
        reachableNodes += min(nodes, used[u*n+v]+used[v*n+u])
    }
    return reachableNodes
}

func min(x, y int) int {
    if x > y {
        return y
    }
    return x
}

type myHeap [][]int

func (h myHeap) Len() int {
    return len(h)
}

func (h myHeap) Less(i, j int) bool {
    return h[i][0] < h[j][0]
}

func (h myHeap) Swap(i, j int) {
    h[i], h[j] = h[j], h[i]
}

func (h *myHeap) Push(val interface{}) {
    *h = append(*h, val.([]int))
}

func (h *myHeap) Pop() interface{} {
    hp := *h
    val := hp[len(hp)-1]
    *h = hp[:len(hp)-1]
    return val
}
```

**复杂度分析**

- 时间复杂度：$O(E \times \log V)$，$V$ 为节点数，即 $n$，$E$ 为输入 $\textit{edges}$ 的长度。邻接表 $\textit{adList}$ 的时间复杂度为 $O(E)$，Dijkstra 算法的时间复杂度为 $O(E \times \log V)$。总的时间复杂度为 $O(E \times \log V)$。

- 空间复杂度：$O(V+E)$，邻接表 $\textit{adList}$ 的空间复杂度为 $O(E)$，$\textit{pq}$ 的空间复杂度为 $O(E)$，$\textit{visited}$ 的空间复杂度为 $O(V)$，$\textit{used}$ 的空间复杂度为 $O(E)$，总的空间复杂度为 $O(V+E)$。
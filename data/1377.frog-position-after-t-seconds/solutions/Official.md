#### 方法一：深度优先搜索

首先我们根据 $\textit{edges}$ 求出树的邻接表，方便我们对图进行搜索。并且定义数组 $\textit{seen}$ 用来记录已经遍历过的顶点。此外 $\textit{dfs}$ 的参数还包括当前遍历的顶点序号，和剩余时间 $t$。青蛙从顶点1开始起跳，所以我们从定点 $1$ 开始进行搜索，初始剩余时间为 $t$。

每次遍历一个节点时候，如果当前节点没有后续节点，或者剩余时间为 $0$， 我们不能继续搜索了。此时当前节点是 $\textit{target}$ ， 我们返回概率 $1.0$， 否则返回概率为 $0.0$。如果有后续节点，并且剩余时间不为 $0$，我们继续深度优先搜索，如果有子节点返回概率 $p > 0$，说明已经找到了节点 $\textit{target}$ ， 又因为跳到任意一个后续子节点上的机率都相同， 我们返回概率 $p$ 除以后续节点个数的商，作为最后的结果。

此外还可以使用「广度优先搜索」，方法类似。

```C++ [sol1-C++]
class Solution {
public:
    double frogPosition(int n, vector<vector<int>>& edges, int t, int target) {
        vector<vector<int>> G(n + 1);
        for (int i = 0; i < edges.size(); ++i) {
            G[edges[i][0]].push_back(edges[i][1]);
            G[edges[i][1]].push_back(edges[i][0]);
        }
        vector<bool> visited(n + 1, false);
        return dfs(G, visited, 1, t, target);
    }

    double dfs(vector<vector<int>>& G, vector<bool>& visited, int i, int t, int target) {
        int nxt = i == 1 ? G[i].size() : G[i].size() - 1;
        if (t == 0 || nxt == 0) {
            return i == target ? 1.0 : 0.0;
        }
        visited[i] = true;
        double ans = 0.0;
        for (int j : G[i]) {
            if (!visited[j]) {
                ans += dfs(G, visited, j, t - 1, target);
            }
        }
        return ans / nxt;
    }
};
```

```Java [sol1-Java]
public class Solution {
    public double frogPosition(int n, int[][] edges, int t, int target) {
        List<Integer>[] G = new ArrayList[n + 1];
        for (int i = 1; i <= n; ++i)
            G[i] = new ArrayList<>();
        for (int[] e : edges) {
            G[e[0]].add(e[1]);
            G[e[1]].add(e[0]);
        }
        boolean[] seen = new boolean[n + 1];
        return dfs(G, seen, 1, t, target);
    }

    private double dfs(List<Integer>[] G, boolean[] seen, int i, int t, int target) {
        int nxt = i == 1 ? G[i].size() : G[i].size() - 1;
        if (t == 0 || nxt == 0) {
            return i == target ? 1.0 : 0.0;
        }
        seen[i] = true;
        double ans = 0.0;
        for (int j : G[i]) {
            if (!seen[j]) {
                ans += dfs(G, seen, j, t - 1, target);
            }
        }
        return ans / nxt;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def frogPosition(self, n: int, edges: List[List[int]], t: int, target: int) -> float:
        G = [[] for i in range(n + 1)]
        for i, j in edges:
            G[i].append(j)
            G[j].append(i)
        seen = [0] * (n + 1)

        def dfs(i, t):
            nxt = len(G[i])
            if i > 1:
                nxt -= 1
            if nxt == 0 or t == 0:
                return 1.0 if i == target else 0.0
            seen[i] = 1
            for j in G[i]:
                if not seen[j]:
                    p = dfs(j, t - 1)
                    if p > 0:
                        return p / nxt
            return 0.0

        return dfs(1, t)
```

```JavaScript [sol1-JavaScript]
var frogPosition = function(n, edges, t, target) {
    let G = [];
    for (let i = 0; i <= n; i++) {
        G.push([]);
    }
    for (let e of edges) {
        G[e[0]].push(e[1]);
        G[e[1]].push(e[0]);
    }
    let seen = new Array(n).fill(false);
    return dfs(G, seen, 1, t, target);
}

function dfs(G, seen, i, t, target) {
    let nxt = i == 1 ? G[i].length : G[i].length - 1;
    if (t == 0 || nxt == 0) {
        return i == target ? 1.0 : 0.0;
    }
    seen[i] = true;
    let ans = 0.0;
    for (let j of G[i]) {
        if (!seen[j]) {
            ans += dfs(G, seen, j, t - 1, target);
        }
    }
    return ans / nxt;
}

```
```C# [sol1-C#]
public class Solution {
    public double FrogPosition(int n, int[][] edges, int t, int target) {
        List<List<int>> g = new List<List<int>>();
        for (int i = 0; i <= n; i++) {
            g.Add(new List<int>());
        }
        for (int i = 0; i < edges.Length; i++) {
            g[edges[i][0]].Add(edges[i][1]);
            g[edges[i][1]].Add(edges[i][0]);
        }
        bool[] seen = new bool[n + 1];
        return Dfs(g, seen, 1, t, target);
    }

    private double Dfs(List<List<int>> g, bool[] seen, int i, int t, int target) {
        int nxt = i == 1 ? g[i].Count : g[i].Count - 1;
        if (t == 0 || nxt == 0) {
            return i == target ? 1.0 : 0.0;
        }
        seen[i] = true;
        double ans = 0.0;
        foreach (int j in g[i]) {
            if (!seen[j]) {
                ans += Dfs(g, seen, j, t - 1, target);
            }
        }
        return ans / nxt;
    }
}
```

```Golang [sol1-Golang]
func frogPosition(n int, edges [][]int, t int, target int) float64 {
    G := make([][]int, n+1)
    for i := 0; i <= n; i++ {
        G[i] = make([]int, 0)
    }
    for _, e := range edges {
        G[e[0]] = append(G[e[0]], e[1])
        G[e[1]] = append(G[e[1]], e[0])
    }
    seen := make([]bool, n+1)
    return dfs(G, seen, 1, t, target)
}

func dfs(G [][]int, seen []bool, i int, t int, target int) float64 {
    nxt := len(G[i])
    if i > 1 {
        nxt -= 1
    }
    if t == 0 || nxt == 0 {
        if i == target {
            return 1.0
        } else {
            return 0.0
        }
    }
    seen[i] = true
    ans := 0.0
    for _, j := range G[i] {
        if !seen[j] {
            ans += dfs(G, seen, j, t - 1, target)
        }
    }
    return ans / float64(nxt)
}
```

```C [sol1-C]
double dfs(const int **G, const int *GColSize, bool *visited, int i, int t, int target) {
    int nxt = i == 1 ? GColSize[i] : GColSize[i] - 1;
    if (t == 0 || nxt == 0) {
        return i == target ? 1.0 : 0.0;
    }
    visited[i] = true;
    double ans = 0.0;
    for (int k = 0; k < GColSize[i]; k++) {
        int j = G[i][k];
        if (!visited[j]) {
            ans += dfs(G, GColSize, visited, j, t - 1, target);
        }
    }
    return ans / nxt;
}

double frogPosition(int n, int** edges, int edgesSize, int* edgesColSize, int t, int target) {
    int *G[n + 1];
    int GColSize[n + 1];
    memset(GColSize, 0, sizeof(GColSize));
    for (int i = 1; i <= n; i++) {
        G[i] = (int *)calloc(n + 1, sizeof(int));
    }
    for (int i = 0; i < edgesSize; ++i) {
        int from = edges[i][0], to = edges[i][1];
        G[from][GColSize[from]++] = to;
        G[to][GColSize[to]++] = from;
    }
    bool visited[n + 1];
    memset(visited, 0, sizeof(visited));
    double ret = dfs(G, GColSize, visited, 1, t, target);
    for (int i = 1; i <= n; i++) {
        free(G[i]);
    }
    return ret;
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，$n$ 是节点数量。
+ 空间复杂度：$O(n)$，$n$ 是节点数量。
#### 前言

树上任意两节点之间最长的简单路径即为树的「直径」，可以参考「[树的直径](https://oi-wiki.org/graph/tree-diameter/)」、「[二叉树的直径](https://leetcode.cn/problems/diameter-of-binary-tree/solutions/139683/er-cha-shu-de-zhi-jing-by-leetcode-solution/)」等相关解法。一颗树可以有多条直径，但直径的长度都是一样的，计算树的直径长度有常见的两种方法:
+ 动态规划：我们记录当 $\textit{root}$ 为树的根时，每个节点作为子树的根向下，所能延伸的最远距离 $d_1$ 和次远距离 $d_2$，那么直径的长度就是所有 $d_1 + d_2$ 的最大值。
+ 深度优先搜索：首先从任意节点 $x$ 开始进行第一次深度优先搜索，到达距离其最远的节点，记为 $y$，然后再从 $y$ 开始做第二次深度优先搜索，到达距离 $y$ 最远的节点，记为 $z$，则 $\delta(y,z)$ 即为树的直径，节点 $y$ 与 节点 $z$ 之间的距离即为直径的长度。

#### 方法一：动态规划

**思路与算法**

题目要求找到城市间最大距离恰好为 $d$ 的所有子树数目，子树中的任意两个节点的最大距离即为「[树的直径](https://oi-wiki.org/graph/tree-diameter/)」。根据题意可以知道城市是一个含有 $n$ 个节点的无向连通图，且该图中只含有 $n-1$ 条边，最大距离为 $d$ 子树需要满足以下条件：
+ 该子树为该无向图中的一个连通单元；
+ 该子树的直径长度为 $d$；

根据以上提示，我们只需计算出图中所有连通子树的直径即可。由于图中的节点数 $n$ 的取值范围为 $1 \le n \le 16$，我们采用状态压缩的思想，用二进制掩码 $\textit{mask}$ 来表示图中的一个子树，枚举所有可能的子树，并检测该子树的连通性。如果该子树为一个连通单元，则计算该子树的直径即可。对于枚举的子树都需要进行如下计算：
+ 检测树的连通性：此时可以通过深度优先搜索或者广度优先搜索来检测连通性即可，从任意节点 $\textit{root}$ 出发，子树中所有的节点均可达；
+ 计算树的直径：在此方法中我们采用树形动态规划的方式计算树的直径即可。每次计算以当前节点为根节点形成的子树向下延伸的最远距离 $\textit{first}$ 与次远距离 $\textit{second}$，计算所有的 $\textit{first} + \textit{second}$ 的最大值即可。
  
我们统计所有子树的直径的不同计数，并返回结果即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:      
    vector<int> countSubgraphsForEachDiameter(int n, vector<vector<int>>& edges) {
        vector<vector<int>> adj(n);        
        for (auto &edge : edges) {
            int x = edge[0] - 1;
            int y = edge[1] - 1;
            adj[x].emplace_back(y);
            adj[y].emplace_back(x);
        }
        function<int(int, int&, int&)> dfs = [&](int root, int& mask, int& diameter)->int {
            int first = 0, second = 0;
            mask &= ~(1 << root);
            for (int vertex : adj[root]) {
                if (mask & (1 << vertex)) {
                    mask &= ~(1 << vertex);
                    int distance = 1 + dfs(vertex, mask, diameter);
                    if (distance > first) {
                        second = first;
                        first = distance;
                    } else if (distance > second) {
                        second = distance;
                    }
                }
            }
            diameter = max(diameter, first + second);
            return first;
        };

        vector<int> ans(n - 1);
        for (int i = 1; i < (1 << n); i++) {
            int root = 32 - __builtin_clz(i) - 1;
            int mask = i;
            int diameter = 0;
            dfs(root, mask, diameter);
            if (mask == 0 && diameter > 0) {
                ans[diameter - 1]++;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    int mask;
    int diameter;

    public int[] countSubgraphsForEachDiameter(int n, int[][] edges) {
        List<Integer>[] adj = new List[n];
        for (int i = 0; i < n; i++) {
            adj[i] = new ArrayList<Integer>();
        }
        for (int[] edge : edges) {
            int x = edge[0] - 1;
            int y = edge[1] - 1;
            adj[x].add(y);
            adj[y].add(x);
        }

        int[] ans = new int[n - 1];
        for (int i = 1; i < (1 << n); i++) {
            int root = 32 - Integer.numberOfLeadingZeros(i) - 1;
            mask = i;
            diameter = 0;
            dfs(root, adj);
            if (mask == 0 && diameter > 0) {
                ans[diameter - 1]++;
            }
        }
        return ans;
    }

    public int dfs(int root, List<Integer>[] adj) {
        int first = 0, second = 0;
        mask &= ~(1 << root);
        for (int vertex : adj[root]) {
            if ((mask & (1 << vertex)) != 0) {
                mask &= ~(1 << vertex);
                int distance = 1 + dfs(vertex, adj);
                if (distance > first) {
                    second = first;
                    first = distance;
                } else if (distance > second) {
                    second = distance;
                }
            }
        }
        diameter = Math.max(diameter, first + second);
        return first;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int dfs(int root, int* mask, int* diameter, int **adj, int *adjColSize) {
    int first = 0, second = 0;
    (*mask) &= ~(1 << root);
    for (int i = 0; i < adjColSize[root]; i++) {
        int vertex = adj[root][i];
        if ((*mask) & (1 << vertex)) {
            (*mask) &= ~(1 << vertex);
            int distance = 1 + dfs(vertex, mask, diameter, adj, adjColSize);
            if (distance > first) {
                second = first;
                first = distance;
            } else if (distance > second) {
                second = distance;
            }
        }
    }
    *diameter = MAX(*diameter, first + second);
    return first;
}

int* countSubgraphsForEachDiameter(int n, int** edges, int edgesSize, int* edgesColSize, int* returnSize) {
    int *adj[n];
    int adjColSize[n];
    for (int i = 0; i < n; i++) {
        adj[i] = (int*)calloc(n, sizeof(int));;
    }
    memset(adjColSize, 0, sizeof(adjColSize));
    for (int i = 0; i < edgesSize; i++) {
        int x = edges[i][0] - 1;
        int y = edges[i][1] - 1;
        adj[x][adjColSize[x]++] = y;
        adj[y][adjColSize[y]++] = x;
    }
    int *ans = (int *)calloc(n - 1, sizeof(int));
    for (int i = 1; i < (1 << n); i++) {
        int root = 32 - __builtin_clz(i) - 1;
        int mask = i;
        int diameter = 0;
        dfs(root, &mask, &diameter, adj, adjColSize);
        if (mask == 0 && diameter > 0) {
            ans[diameter - 1]++;
        }
    }
    for (int i = 0; i < n; i++) {
        free(adj[i]);
    }
    *returnSize = n - 1;
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var countSubgraphsForEachDiameter = function(n, edges) {
    const adj = new Array(n).fill(0);
    for (let i = 0; i < n; i++) {
        adj[i] = [];
    }
    for (const edge of edges) {
        const x = edge[0] - 1;
        const y = edge[1] - 1;
        adj[x].push(y);
        adj[y].push(x);
    }

    const ans = new Array(n - 1).fill(0);
    for (let i = 1; i < (1 << n); i++) {
        const root = 32 - numberOfLeadingZeros(i) - 1;
        mask = i;
        diameter = 0;
        dfs(root, adj);
        if (mask === 0 && diameter > 0) {
            ans[diameter - 1]++;
        }
    }
    return ans;
}

const dfs = (root, adj) => {
    let first = 0, second = 0;
    mask &= ~(1 << root);
    for (const vertex of adj[root]) {
        if ((mask & (1 << vertex)) !== 0) {
            mask &= ~(1 << vertex);
            const distance = 1 + dfs(vertex, adj);
            if (distance > first) {
                second = first;
                first = distance;
            } else if (distance > second) {
                second = distance;
            }
        }
    }
    diameter = Math.max(diameter, first + second);
    return first;
};

const numberOfLeadingZeros = (i) => {
    if (i === 0)
        return 32;
    let n = 1;
    if (i >>> 16 === 0) { n += 16; i <<= 16; }
    if (i >>> 24 === 0) { n +=  8; i <<=  8; }
    if (i >>> 28 === 0) { n +=  4; i <<=  4; }
    if (i >>> 30 === 0) { n +=  2; i <<=  2; }
    n -= i >>> 31;
    return n;
}
```

**复杂度分析**

- 时间复杂度：$O(n \times 2^n)$，其中 $n$ 表示给定的城市的数目。我们枚举图中所有可能的子树，一共最多有 $2^n$ 个子树，检测子树的连通性与计算子树的直径需要的时间为 $O(n)$，因此总的时间复杂度为 $O(n \times 2^n)$。

- 空间复杂度：$O(n)$，其中 $n$ 表示给定的城市的数目。我们需要存储图的邻接关系，由于图中只有 $n-1$ 条边，存储图的邻接关系需要的空间为 $O(n)$，每次递归求树的直径中递归的最大深度为 $n$，因此总的空间复杂度为 $O(n)$。

#### 方法二：深度优先搜索

**思路与算法**

方法二与方法一一样通过状态压缩，来枚举子树，并计算连通子树的直径，计算直径的方法采用深度优先搜索。
+ 首先我们利用广度优先搜索或者深度优先搜索检测子树的连通性，并从任意节点 $x$ 开始找到距离 $x$ 的最远节点 $y$；
+ 找到以节点 $y$ 为根节点的子树的最大深度即为该子树的直径。

**代码**

```C++ [sol2-C++]
class Solution {
public:      
    vector<int> countSubgraphsForEachDiameter(int n, vector<vector<int>>& edges) {
        vector<vector<int>> adj(n);        
        for (auto &edge : edges) {
            int x = edge[0] - 1;
            int y = edge[1] - 1;
            adj[x].emplace_back(y);
            adj[y].emplace_back(x);
        }

        function<int(int, int, int)> dfs = [&](int parent, int u, int mask)->int {
            int depth = 0;
            for (int v : adj[u]) {
                if (v != parent && mask & (1 << v)) {
                    depth = max(depth, 1 + dfs(u, v, mask));
                }
            }
            return depth;
        };

        vector<int> ans(n - 1);
        for (int i = 1; i < (1 << n); i++) {
            int x = 32 - __builtin_clz(i) - 1;
            int mask = i;
            int y = -1;
            queue<int> qu;
            qu.emplace(x);
            mask &= ~(1 << x);
            while (!qu.empty()) {
                y = qu.front();
                qu.pop();
                for (int vertex : adj[y]) {
                    if (mask & (1 << vertex)) {
                        mask &= ~(1 << vertex);
                        qu.emplace(vertex);
                    }
                }
            }
            if (mask == 0) {
                int diameter = dfs(-1, y, i);
                if (diameter > 0) {
                    ans[diameter - 1]++;
                }
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    int mask;
    int diameter;

    public int[] countSubgraphsForEachDiameter(int n, int[][] edges) {
        List<Integer>[] adj = new List[n];
        for (int i = 0; i < n; i++) {
            adj[i] = new ArrayList<Integer>();
        }
        for (int[] edge : edges) {
            int x = edge[0] - 1;
            int y = edge[1] - 1;
            adj[x].add(y);
            adj[y].add(x);
        }

        int[] ans = new int[n - 1];
        for (int i = 1; i < (1 << n); i++) {
            int x = 32 - Integer.numberOfLeadingZeros(i) - 1;
            int mask = i;
            int y = -1;
            Queue<Integer> queue = new ArrayDeque<Integer>();
            queue.offer(x);
            mask &= ~(1 << x);
            while (!queue.isEmpty()) {
                y = queue.poll();
                for (int vertex : adj[y]) {
                    if ((mask & (1 << vertex)) != 0) {
                        mask &= ~(1 << vertex);
                        queue.offer(vertex);
                    }
                }
            }
            if (mask == 0) {
                int diameter = dfs(adj, -1, y, i);
                if (diameter > 0) {
                    ans[diameter - 1]++;
                }
            }
        }
        return ans;
    }

    public int dfs(List<Integer>[] adj, int parent, int u, int mask) {
        int depth = 0;
        for (int v : adj[u]) {
            if (v != parent && (mask & (1 << v)) != 0) {
                depth = Math.max(depth, 1 + dfs(adj, u, v, mask));
            }
        }
        return depth;
    }
}
```

```C [sol2-C]
static inline int max(int a, int b) {
    return a > b ? a : b;
}

int dfs(int parent, int u, int mask, int **adj, int *adjColSize) {
    int depth = 0;
    for (int i = 0; i < adjColSize[u]; i++) {
        int vertex = adj[u][i];
        if (vertex != parent && mask & (1 << vertex)) {
            depth = max(depth, 1 + dfs(u, vertex, mask, adj, adjColSize));
        }
    }
    return depth;
}

int* countSubgraphsForEachDiameter(int n, int** edges, int edgesSize, int* edgesColSize, int* returnSize) {
    int *adj[n];
    int adjColSize[n];
    for (int i = 0; i < n; i++) {
        adj[i] = (int*)calloc(n, sizeof(int));;
    }
    memset(adjColSize, 0, sizeof(adjColSize));
    for (int i = 0; i < edgesSize; i++) {
        int x = edges[i][0] - 1;
        int y = edges[i][1] - 1;
        adj[x][adjColSize[x]++] = y;
        adj[y][adjColSize[y]++] = x;
    }

    int *ans = (int *)calloc(n - 1, sizeof(int));
    for (int i = 1; i < (1 << n); i++) {
        int root = 32 - __builtin_clz(i) - 1, mask = i;
        int queue[n];
        int head = 0, tail = 0;
        int node = -1;
        queue[tail++] = root;
        mask &= ~(1 << root);
        while (head != tail) {
            node = queue[head++];
            for (int j = 0; j < adjColSize[node]; j++) {
                int vertex = adj[node][j];
                if (mask & (1 << vertex)) {
                    mask &= ~(1 << vertex);
                    queue[tail++] = vertex;
                }
            }
        }
        if (mask == 0) {
            int diameter = dfs(-1, node, i, adj, adjColSize);
            if (diameter > 0) {
                ans[diameter - 1]++;
            }
        }
    }
    for (int i = 0; i < n; i++) {
        free(adj[i]);
    }
    *returnSize = n - 1;
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var countSubgraphsForEachDiameter = function(n, edges) {
    const adj = new Array(n).fill(0);
    for (let i = 0; i < n; i++) {
        adj[i] = [];
    }
    for (const edge of edges) {
        const x = edge[0] - 1;
        const y = edge[1] - 1;
        adj[x].push(y);
        adj[y].push(x);
    }

    const ans = new Array(n - 1).fill(0);
    for (let i = 1; i < (1 << n); i++) {
        const x = 32 - numberOfLeadingZeros(i) - 1;
        let mask = i;
        let y = -1;
        const queue = [x];
        mask &= ~(1 << x);
        while (queue.length) {
            y = queue.shift();
            for (const vertex of adj[y]) {
                if ((mask & (1 << vertex)) !== 0) {
                    mask &= ~(1 << vertex);
                    queue.push(vertex);
                }
            }
        }
        if (mask === 0) {
            const diameter = dfs(adj, -1, y, i);
            if (diameter > 0) {
                ans[diameter - 1]++;
            }
        }
    }
    return ans;
}

const dfs = (adj, parent, u, mask) => {
    let depth = 0;
    for (const v of adj[u]) {
        if (v !== parent && (mask & (1 << v)) !== 0) {
            depth = Math.max(depth, 1 + dfs(adj, u, v, mask));
        }
    }
    return depth;
}
const numberOfLeadingZeros = (i) => {
    if (i === 0)
        return 32;
    let n = 1;
    if (i >>> 16 === 0) { n += 16; i <<= 16; }
    if (i >>> 24 === 0) { n +=  8; i <<=  8; }
    if (i >>> 28 === 0) { n +=  4; i <<=  4; }
    if (i >>> 30 === 0) { n +=  2; i <<=  2; }
    n -= i >>> 31;
    return n;
}
```

**复杂度分析**

- 时间复杂度：$O(n \times 2^n)$，其中 $n$ 表示给定的城市的数目。我们枚举图中所有可能的子树，一共最多有 $2^n$ 个子树，检测子树的连通性与计算子树的直径需要的时间为 $O(n)$，因此总的时间复杂度为 $O(n \times 2^n)$。

- 空间复杂度：$O(n)$，其中 $n$ 表示给定的城市的数目。我们需要存储图的邻接关系，由于图中只有 $n-1$ 条边，存储图的邻接关系需要的空间为 $O(n)$，每次递归求树的直径中递归的最大深度为 $n$，因此总的空间复杂度为 $O(n)$。

#### 方法三：枚举任意两点直径

**思路与算法**

设城市中的任意两个节点为 $x,y$，它们之间的距离为 $\textit{dist}[x][y]$，如果我们可以求出以 $\textit{dist}[x][y]$ 为直径且包含 $x,y$ 的子树数目，就可以求出所有直径的子树数目。该算法的难点在于如何求出以 $\textit{dist}[x][y]$ 为直径且包含 $x,y$ 的子树，假设当前已知符合上述要求子树的数目为 $c(x,y)$，如果子树可以扩展到当前节点 $u$，则节点 $u$ 是否可以加入到子树中？节点 $u$ 可以加入到子树直径为 $\textit{dist}[x][y]$ 的子树中，需要满足以下条件：
+ 节点 $u$ 到节点 $x$ 与 $y$ 的距离均应小于 $\textit{dist}[x][y]$，即 $\textit{dist}[u][x] \le \textit{dist}[x][y],\textit{dist}[u][y] \le \textit{dist}[x][y]$；
+ 如果 $\textit{dist}[x][y]$ 为包含节点 $x,y$ 的子树的直径，则 $x,y$ 在该子树中一定为叶子节点，且子树中所有直径的两个起始端点均为叶子节点，可以通过反证明法来证明；

设两个节点 $x,y$ 且满足 $x < y$，则此时我们以 $x$ 为根节点开始构造直径为 $\textit{dist}[x][y]$ 的子树：
+ 如果以当前相邻的节点 $u$ 满足 $\textit{dist}[u][x] < \textit{dist}[x][y],\textit{dist}[u][y] < \textit{dist}[x][y]$，此时节点 $u$ 一定可以加入到子树中，此时的直径即为 $\textit{dist}[x][y]$，此时我们继续向外延伸到 $u$ 的孩子节点；
+ 如果以当前相邻的节点 $u$ 满足 $\textit{dist}[u][x] = \textit{dist}[x][y]$ 或者 $\textit{dist}[u][y] = \textit{dist}[x][y]$ 时，此时 $u$ 也一定可以加入到子树中，但可能存在重复计算的问题，为了防止重复计算，对于每对 $(x,y)$ 且 $x < y$，如果加入新的节点 $u$ 后，存在相等的直径 $\textit{dist}[u][x]$ 或者 $\textit{dist}[u][y]$，此时我们要求直径的两个端点之和一定要大于等于 $x + y$：
  + 如果 $\textit{dist}[x][u] = \textit{dist}[x][y]$，即 $u$ 到较小的节点 $x$ 的距离等于当前的直径，则此时要求 $(u + x) \ge (x + y)$，即此时需要满足 $u \ge y$;
  + 如果 $\textit{dist}[y][u] = \textit{dist}[x][y]$，即 $u$ 到较大的节点 $y$ 的距离等于当前的直径，则此时要求 $(u + y) \ge (x + y)$，即此时需要满足 $u \ge x$;
+ 如果当前节点 $u$ 可以加入时，如果节点 $u$ 不在 $x$ 到 $y$ 的关键路径上时，此时节点 $u$ 可以不在目标子树中，以节点 $u$ 为根节点的子树为空，即空子树也计数为一种子树。

<![update1](https://assets.leetcode-cn.com/solution-static/1617/1617_1.png),![update2](https://assets.leetcode-cn.com/solution-static/1617/1617_2.png),![update3](https://assets.leetcode-cn.com/solution-static/1617/1617_3.png),![update4](https://assets.leetcode-cn.com/solution-static/1617/1617_4.png),![update5](https://assets.leetcode-cn.com/solution-static/1617/1617_5.png),![update6](https://assets.leetcode-cn.com/solution-static/1617/1617_6.png),![update7](https://assets.leetcode-cn.com/solution-static/1617/1617_7.png),![update8](https://assets.leetcode-cn.com/solution-static/1617/1617_8.png)>

我们每次计算以 $u$ 为根节点构成满足要求的子树的数目 $\textit{count}(u)$，此时它们之间的关系为相乘。即假设根节点 $x$ 含有 $m$ 个孩子节点分别为 $c_0,c_1,\cdots,c_{m-1}$，每个孩子节点可以构成的子树的数目为 $\textit{count}(c_0),\textit{count}(c_1),\cdots,\textit{count}(c_{m-1})$，则此时构成的子树的总数目为 $\prod\limits_{i=0}^{m-1}\textit{count}(c_i)$。枚举所有的节点对 $(x,y)$ 且满足 $x < y$，并计算以 $\textit{dist}[x][y]$ 为直径的子树数目，即可计算出所有符合要求的子树的数目。

**代码**

```C++ [sol3-C++]
class Solution {
public:      
    vector<int> countSubgraphsForEachDiameter(int n, vector<vector<int>>& edges) {
        vector<vector<int>> adj(n);        
        vector<vector<int>> dist(n, vector<int>(n, INT_MAX));
        for (auto &edge : edges) {
            int x = edge[0] - 1;
            int y = edge[1] - 1;
            adj[x].emplace_back(y);
            adj[y].emplace_back(x);
            dist[x][y] = dist[y][x] = 1;
        }
        for (int i = 0; i < n; i++) {
            dist[i][i] = 0;
        }
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                for (int k = 0; k < n; k++) {
                    if (dist[j][i] != INT_MAX && dist[i][k] != INT_MAX) {
                        dist[j][k] = min(dist[j][k], dist[j][i] + dist[i][k]);
                    }
                }
            }
        }
        function<int(int, int, int, int)> dfs = [&](int u, int parent, int x, int y) -> int {
            if (dist[u][x] > dist[x][y] || dist[u][y] > dist[x][y]) {
                return 1;
            }
            if ((dist[u][y] == dist[x][y] && u < x) || (dist[u][x] == dist[x][y] && u < y)) {
                return 1;
            }
            int ret = 1;
            for (int v : adj[u]) {
                if (v != parent) {
                    ret *= dfs(v, u, x, y);
                }
            }
            if (dist[u][x] + dist[u][y] > dist[x][y]) {
                ret++;
            }
            return ret;
        };
        vector<int> ans(n - 1);
        for (int i = 0; i < n - 1; i++) {
            for (int j = i + 1; j < n; j++) {
                ans[dist[i][j] - 1] += dfs(i, -1, i, j);
            }
        }
        return ans;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int[] countSubgraphsForEachDiameter(int n, int[][] edges) {
        List<Integer>[] adj = new List[n];
        int[][] dist = new int[n][n];
        for (int i = 0; i < n; i++) {
            Arrays.fill(dist[i], Integer.MAX_VALUE);
            dist[i][i] = 0;
        }
        for (int i = 0; i < n; i++) {
            adj[i] = new ArrayList<Integer>();
        }
        for (int[] edge : edges) {
            int x = edge[0] - 1;
            int y = edge[1] - 1;
            adj[x].add(y);
            adj[y].add(x);
            dist[x][y] = dist[y][x] = 1;
        }
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                for (int k = 0; k < n; k++) {
                    if (dist[j][i] != Integer.MAX_VALUE && dist[i][k] != Integer.MAX_VALUE) {
                        dist[j][k] = Math.min(dist[j][k], dist[j][i] + dist[i][k]);
                    }
                }
            }
        }
        int[] ans = new int[n - 1];
        for (int i = 0; i < n - 1; i++) {
            for (int j = i + 1; j < n; j++) {
                ans[dist[i][j] - 1] += dfs(adj, dist, i, -1, i, j);
            }
        }
        return ans;
    }

    public int dfs(List<Integer>[] adj, int[][] dist, int u, int parent, int x, int y) {
        if (dist[u][x] > dist[x][y] || dist[u][y] > dist[x][y]) {
            return 1;
        }
        if ((dist[u][y] == dist[x][y] && u < x) || (dist[u][x] == dist[x][y] && u < y)) {
            return 1;
        }
        int ret = 1;
        for (int v : adj[u]) {
            if (v != parent) {
                ret *= dfs(adj, dist, v, u, x, y);
            }
        }
        if (dist[u][x] + dist[u][y] > dist[x][y]) {
            ret++;
        }
        return ret;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int[] CountSubgraphsForEachDiameter(int n, int[][] edges) {
        IList<int>[] adj = new IList<int>[n];
        int[][] dist = new int[n][];
        for (int i = 0; i < n; i++) {
            dist[i] = new int[n];
            Array.Fill(dist[i], int.MaxValue);
            dist[i][i] = 0;
        }
        for (int i = 0; i < n; i++) {
            adj[i] = new List<int>();
        }
        foreach (int[] edge in edges) {
            int x = edge[0] - 1;
            int y = edge[1] - 1;
            adj[x].Add(y);
            adj[y].Add(x);
            dist[x][y] = dist[y][x] = 1;
        }
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                for (int k = 0; k < n; k++) {
                    if (dist[j][i] != int.MaxValue && dist[i][k] != int.MaxValue) {
                        dist[j][k] = Math.Min(dist[j][k], dist[j][i] + dist[i][k]);
                    }
                }
            }
        }
        int[] ans = new int[n - 1];
        for (int i = 0; i < n - 1; i++) {
            for (int j = i + 1; j < n; j++) {
                ans[dist[i][j] - 1] += DFS(adj, dist, i, -1, i, j);
            }
        }
        return ans;
    }

    public int DFS(IList<int>[] adj, int[][] dist, int u, int parent, int x, int y) {
        if (dist[u][x] > dist[x][y] || dist[u][y] > dist[x][y]) {
            return 1;
        }
        if ((dist[u][y] == dist[x][y] && u < x) || (dist[u][x] == dist[x][y] && u < y)) {
            return 1;
        }
        int ret = 1;
        foreach (int v in adj[u]) {
            if (v != parent) {
                ret *= DFS(adj, dist, v, u, x, y);
            }
        }
        if (dist[u][x] + dist[u][y] > dist[x][y]) {
            ret++;
        }
        return ret;
    }
}
```

```C [sol3-C]
const int INFI = 0x3f3f3f3f;

static inline int min(int a, int b) {
    return a < b ? a : b;
}

int dfs(int u, int parent, int x, int y, int **dist, int **adj, int *adjColSize) {
    if (dist[u][x] > dist[x][y] || dist[u][y] > dist[x][y]) {
        return 1;
    }
    if ((dist[u][y] == dist[x][y] && u < x) || (dist[u][x] == dist[x][y] && u < y)) {
        return 1;
    }
    int ret = 1;
    for (int i = 0; i < adjColSize[u]; i++) {
        int v = adj[u][i];
        if (v != parent) {
            ret *= dfs(v, u, x, y, dist, adj, adjColSize);
        }
    }
    if (dist[u][x] + dist[u][y] > dist[x][y]) {
        ret++;
    }
    return ret;
};

int* countSubgraphsForEachDiameter(int n, int** edges, int edgesSize, int* edgesColSize, int* returnSize) {
    int *adj[n], *dist[n];
    int adjColSize[n];
    for (int i = 0; i < n; i++) {
        adj[i] = (int *)calloc(n, sizeof(int));
        dist[i] = (int *)calloc(n, sizeof(int));
        memset(dist[i], 0x3f, sizeof(int) * n);
        dist[i][i] = 0;
    }
    memset(adjColSize, 0, sizeof(adjColSize));
    for (int i = 0; i < edgesSize; i++) {
        int x = edges[i][0] - 1;
        int y = edges[i][1] - 1;
        adj[x][adjColSize[x]++] = y;
        adj[y][adjColSize[y]++] = x;
        dist[x][y] = dist[y][x] = 1;
    }
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            for (int k = 0; k < n; k++) {
                if (dist[j][i] != INFI && dist[i][k] != INFI) {
                    dist[j][k] = min(dist[j][k], dist[j][i] + dist[i][k]);
                }
            }
        }
    }

    int *ans = (int *)calloc(n - 1, sizeof(int));
    for (int i = 0; i < n - 1; i++) {
        for (int j = i + 1; j < n; j++) {
            ans[dist[i][j] - 1] += dfs(i, -1, i, j, dist, adj, adjColSize);
        }
    }
    for (int i = 0; i < n; i++) {
        free(adj[i]);
        free(dist[i]);
    }
    *returnSize = n - 1;
    return ans;
}
```

```JavaScript [sol3-JavaScript]
var countSubgraphsForEachDiameter = function(n, edges) {
    const adj = new Array(n).fill(0);
    const dist = new Array(n).fill(0).map(() => new Array(n).fill(Number.MAX_SAFE_INTEGER));
    for (let i = 0; i < n; i++) {
        dist[i][i] = 0;
    }
    for (let i = 0; i < n; i++) {
        adj[i] = [];
    }
    for (const edge of edges) {
        const x = edge[0] - 1;
        const y = edge[1] - 1;
        adj[x].push(y);
        adj[y].push(x);
        dist[x][y] = dist[y][x] = 1;
    }
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < n; j++) {
            for (let k = 0; k < n; k++) {
                if (dist[j][i] !== Number.MAX_VALUE && dist[i][k] !== Number.MAX_VALUE) {
                    dist[j][k] = Math.min(dist[j][k], dist[j][i] + dist[i][k]);
                }
            }
        }
    }
    const ans = new Array(n - 1).fill(0);
    for (let i = 0; i < n - 1; i++) {
        for (let j = i + 1; j < n; j++) {
            ans[dist[i][j] - 1] += dfs(adj, dist, i, -1, i, j);
        }
    }
    return ans;
}

const dfs = (adj, dist, u, parent, x, y) => {
    if (dist[u][x] > dist[x][y] || dist[u][y] > dist[x][y]) {
        return 1;
    }
    if ((dist[u][y] === dist[x][y] && u < x) || (dist[u][x] === dist[x][y] && u < y)) {
        return 1;
    }
    let ret = 1;
    for (const v of adj[u]) {
        if (v !== parent) {
            ret *= dfs(adj, dist, v, u, x, y);
        }
    }
    if (dist[u][x] + dist[u][y] > dist[x][y]) {
        ret++;
    }
    return ret;
}
const numberOfLeadingZeros = (i) => {
    if (i === 0)
        return 32;
    let n = 1;
    if (i >>> 16 === 0) { n += 16; i <<= 16; }
    if (i >>> 24 === 0) { n +=  8; i <<=  8; }
    if (i >>> 28 === 0) { n +=  4; i <<=  4; }
    if (i >>> 30 === 0) { n +=  2; i <<=  2; }
    n -= i >>> 31;
    return n;
}
```

**复杂度分析**

- 时间复杂度：$O(n^3)$，其中 $n$ 表示给定的城市的数目。我们利用 $\textit{Floyd}$ 算法求图中任意两个节点的最短距离需要的时间为 $O(n^3)$，枚举任意两点为直径，一共最多可以有 $n^2$ 种枚举，每次生成给定直径长度的子树需要的时间为 $O(n)$，因此枚举任意两点为直径的子树需要的时间为 $O(n^3)$，总的时间复杂度为 $O(n^3)$。

- 空间复杂度：$O(n^2)$，其中 $n$ 表示给定的城市的数目。我们需要存储图的邻接关系，由于图中只有 $n-1$ 条边，存储图的邻接关系需要的空间为 $O(n)$，存储任意两点的最大距离需要的空间为 $O(n^2)$，因此总的空间复杂度为 $O(n^2)$。
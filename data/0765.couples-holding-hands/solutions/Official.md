## [765.情侣牵手 中文官方题解](https://leetcode.cn/problems/couples-holding-hands/solutions/100000/qing-lu-qian-shou-by-leetcode-solution-bvzr)
#### 方法一：并查集

假定第一对情侣的男生与第二对情侣的女生坐在了一起，而第二对情侣的男生与第三对情侣的女生坐在了一起。根据题意，要想让第二对情侣之间能够成功牵手，要么交换第一对情侣的男生与第二对情侣的男生，要么交换第二对情侣的女生与第三对情侣的女生。

既然存在这两种交换方式，那么有必要两种方式都考虑吗？答案是无需都考虑。不难注意到，无论采用了两种交换方式中的哪一种，最后的结局都是「第二对情侣坐在了一起，且第一对情侣的男生与第三对情侣的女生坐在了一起」，因此两种交换方式是等价的。

因此，我们将 $N$ 对情侣看做图中的 $N$ 个节点；对于每对相邻的位置，如果是第 $i$ 对与第 $j$ 对坐在了一起，则在 $i$ 号节点与 $j$ 号节点之间连接一条边，代表需要交换这两对情侣的位置。

如果图中形成了一个大小为 $k$ 的环：$i \rightarrow j \rightarrow k \rightarrow \ldots \rightarrow l \rightarrow i$，则我们沿着环的方向，先交换 $i,j$ 的位置，再交换 $j,k$ 的位置，以此类推。在进行了 $k-1$ 次交换后，这 $k$ 对情侣就都能够彼此牵手了。

故我们只需要利用并查集求出图中的每个连通分量；对于每个连通分量而言，其大小减 $1$ 就是需要交换的次数。

```C++ [sol1-C++]
class Solution {
public:
    int getf(vector<int>& f, int x) {
        if (f[x] == x) {
            return x;
        }
        int newf = getf(f, f[x]);
        f[x] = newf;
        return newf;
    }

    void add(vector<int>& f, int x, int y) {
        int fx = getf(f, x);
        int fy = getf(f, y);
        f[fx] = fy;
    }

    int minSwapsCouples(vector<int>& row) {
        int n = row.size();
        int tot = n / 2;
        vector<int> f(tot, 0);
        for (int i = 0; i < tot; i++) {
            f[i] = i;
        }

        for (int i = 0; i < n; i += 2) {
            int l = row[i] / 2;
            int r = row[i + 1] / 2;
            add(f, l, r);
        }

        unordered_map<int, int> m;
        for (int i = 0; i < tot; i++) {
            int fx = getf(f, i);
            m[fx]++;
        }
        
        int ret = 0;
        for (const auto& [f, sz]: m) {
            ret += sz - 1;
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minSwapsCouples(int[] row) {
        int n = row.length;
        int tot = n / 2;
        int[] f = new int[tot];
        for (int i = 0; i < tot; i++) {
            f[i] = i;
        }

        for (int i = 0; i < n; i += 2) {
            int l = row[i] / 2;
            int r = row[i + 1] / 2;
            add(f, l, r);
        }

        Map<Integer, Integer> map = new HashMap<Integer, Integer>();
        for (int i = 0; i < tot; i++) {
            int fx = getf(f, i);
            map.put(fx, map.getOrDefault(fx, 0) + 1);
        }
        
        int ret = 0;
        for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
            ret += entry.getValue() - 1;
        }
        return ret;
    }

    public int getf(int[] f, int x) {
        if (f[x] == x) {
            return x;
        }
        int newf = getf(f, f[x]);
        f[x] = newf;
        return newf;
    }

    public void add(int[] f, int x, int y) {
        int fx = getf(f, x);
        int fy = getf(f, y);
        f[fx] = fy;
    }
}
```

```go [sol1-Golang]
type unionFind struct {
    parent, size []int
    setCount     int // 当前连通分量数目
}

func newUnionFind(n int) *unionFind {
    parent := make([]int, n)
    size := make([]int, n)
    for i := range parent {
        parent[i] = i
        size[i] = 1
    }
    return &unionFind{parent, size, n}
}

func (uf *unionFind) find(x int) int {
    if uf.parent[x] != x {
        uf.parent[x] = uf.find(uf.parent[x])
    }
    return uf.parent[x]
}

func (uf *unionFind) union(x, y int) {
    fx, fy := uf.find(x), uf.find(y)
    if fx == fy {
        return
    }
    if uf.size[fx] < uf.size[fy] {
        fx, fy = fy, fx
    }
    uf.size[fx] += uf.size[fy]
    uf.parent[fy] = fx
    uf.setCount--
}

func minSwapsCouples(row []int) int {
    n := len(row)
    uf := newUnionFind(n / 2)
    for i := 0; i < n; i += 2 {
        uf.union(row[i]/2, row[i+1]/2)
    }
    return n/2 - uf.setCount
}
```

```C [sol1-C]
int getf(int* f, int x) {
    if (f[x] == x) {
        return x;
    }
    int newf = getf(f, f[x]);
    f[x] = newf;
    return newf;
}

void add(int* f, int x, int y) {
    int fx = getf(f, x);
    int fy = getf(f, y);
    f[fx] = fy;
}

int minSwapsCouples(int* row, int rowSize) {
    int n = rowSize;
    int tot = n / 2;
    int f[tot];
    memset(f, 0, sizeof(f));
    for (int i = 0; i < tot; i++) {
        f[i] = i;
    }

    for (int i = 0; i < n; i += 2) {
        int l = row[i] / 2;
        int r = row[i + 1] / 2;
        add(f, l, r);
    }

    int m[tot];
    memset(m, 0, sizeof(m));
    for (int i = 0; i < tot; i++) {
        int fx = getf(f, i);
        m[fx]++;
    }

    int ret = 0;
    for (int i = 0; i < tot; i++) {
        if (f[i] == i) {
            ret += m[i] - 1;
        }
    }
    return ret;
}
```

```JavaScript [sol1-JavaScript]
/**
 * @param {number[]} row
 * @return {number}
 */
var minSwapsCouples = function(row) {
    const n = row.length;
    const tot = n / 2;
    const f = new Array(tot).fill(0).map((element, index) => index);
    
    for (let i = 0; i < n; i += 2) {
        const l = Math.floor(row[i] / 2);
        const r = Math.floor(row[i + 1] / 2);
        add(f, l, r);
    }
    const map = new Map();
    for (let i = 0; i < tot; i++) {
        const fx = getf(f, i);
        if (map.has(fx)) {
            map.set(fx, map.get(fx) + 1);
        } else {
            map.set(fx, 1)
        }
    }
    
    let ret = 0;
    for (const [f, sz] of map.entries()) {
        ret += sz - 1;
    }
    return ret;
};  

const getf = (f, x) => {
    if (f[x] === x) {
        return x;
    }
    const newf = getf(f, f[x]);
    f[x] = newf;
    return newf;
}

const add = (f, x, y) => {
    const fx = getf(f, x);
    const fy = getf(f, y);
    f[fx] = fy;
}
```

**复杂度分析**

- 时间复杂度：$O(N \log N)$，其中 $N$ 为情侣的总数。这里的并查集使用了路径压缩，但是没有使用按秩合并，最坏情况下的时间复杂度是 $O(N \log N)$，平均情况下的时间复杂度依然是 $O(N \alpha (N))$，其中 $\alpha$ 为阿克曼函数的反函数，$\alpha (N)$ 可以认为是一个很小的常数。

- 空间复杂度：$O(N)$。

#### 方法二：广度优先搜索

我们也可以通过广度优先搜索的方式，求解图中的连通分量。

起初，我们将每个节点都标记为「未访问」，并遍历图中的每个节点。如果发现一个「未访问」的节点，就从该节点出发，沿着图中的边，将其余的「未访问」的节点都标记为「已访问」，并同时统计标记的次数。当遍历过程终止时，标记的数量次数即为连通分量的大小。

```C++ [sol2-C++]
class Solution {
public:
    int minSwapsCouples(vector<int>& row) {
        int n = row.size();
        int tot = n / 2;
        
        vector<vector<int>> graph(tot);
        for (int i = 0; i < n; i += 2) {
            int l = row[i] / 2;
            int r = row[i + 1] / 2;
            if (l != r) {
                graph[l].push_back(r);
                graph[r].push_back(l);
            }
        }
        vector<int> visited(tot, 0);
        int ret = 0;
        for (int i = 0; i < tot; i++) {
            if (visited[i] == 0) {
                queue<int> q;
                visited[i] = 1;
                q.push(i);
                int cnt = 0;

                while (!q.empty()) {
                    int x = q.front();
                    q.pop();
                    cnt += 1;

                    for (int y: graph[x]) {
                        if (visited[y] == 0) {
                            visited[y] = 1;
                            q.push(y);
                        }
                    }
                }
                ret += cnt - 1;
            }
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int minSwapsCouples(int[] row) {
        int n = row.length;
        int tot = n / 2;
        
        List<Integer>[] graph = new List[tot];
        for (int i = 0; i < tot; i++) {
            graph[i] = new ArrayList<Integer>();
        }
        for (int i = 0; i < n; i += 2) {
            int l = row[i] / 2;
            int r = row[i + 1] / 2;
            if (l != r) {
                graph[l].add(r);
                graph[r].add(l);
            }
        }
        boolean[] visited = new boolean[tot];
        int ret = 0;
        for (int i = 0; i < tot; i++) {
            if (!visited[i]) {
                Queue<Integer> queue = new LinkedList<Integer>();
                visited[i] = true;
                queue.offer(i);
                int cnt = 0;

                while (!queue.isEmpty()) {
                    int x = queue.poll();
                    cnt += 1;

                    for (int y : graph[x]) {
                        if (!visited[y]) {
                            visited[y] = true;
                            queue.offer(y);
                        }
                    }
                }
                ret += cnt - 1;
            }
        }
        return ret;
    }
}
```

```go [sol2-Golang]
func minSwapsCouples(row []int) (ans int) {
    n := len(row)
    graph := make([][]int, n/2)
    for i := 0; i < n; i += 2 {
        l, r := row[i]/2, row[i+1]/2
        if l != r {
            graph[l] = append(graph[l], r)
            graph[r] = append(graph[r], l)
        }
    }
    vis := make([]bool, n/2)
    for i, vs := range vis {
        if !vs {
            vis[i] = true
            cnt := 0
            q := []int{i}
            for len(q) > 0 {
                cnt++
                v := q[0]
                q = q[1:]
                for _, w := range graph[v] {
                    if !vis[w] {
                        vis[w] = true
                        q = append(q, w)
                    }
                }
            }
            ans += cnt - 1
        }
    }
    return
}
```

```C [sol2-C]
int minSwapsCouples(int* row, int rowSize) {
    int n = rowSize;
    int tot = n / 2;

    int* graph[tot];
    int graphColSize[tot];
    memset(graphColSize, 0, sizeof(graphColSize));
    for (int i = 0; i < n; i += 2) {
        int l = row[i] / 2;
        int r = row[i + 1] / 2;
        if (l != r) {
            graphColSize[l]++;
            graphColSize[r]++;
        }
    }
    for (int i = 0; i < tot; i++) {
        graph[i] = malloc(sizeof(int) * graphColSize[i]);
        graphColSize[i] = 0;
    }
    for (int i = 0; i < n; i += 2) {
        int l = row[i] / 2;
        int r = row[i + 1] / 2;
        if (l != r) {
            graph[l][graphColSize[l]++] = r;
            graph[r][graphColSize[r]++] = l;
        }
    }
    int visited[tot];
    memset(visited, 0, sizeof(visited));
    int que[n];
    int ret = 0;
    for (int i = 0; i < tot; i++) {
        if (visited[i] == 0) {
            int left = 0, right = 0;
            visited[i] = 1;
            que[right++] = i;
            int cnt = 0;

            while (left < right) {
                int x = que[left++];
                cnt += 1;
                for (int j = 0; j < graphColSize[x]; j++) {
                    if (visited[graph[x][j]] == 0) {
                        visited[graph[x][j]] = 1;
                        que[right++] = graph[x][j];
                    }
                }
            }
            ret += cnt - 1;
        }
    }
    return ret;
}
```

```JavaScript [sol2-JavaScript]
var minSwapsCouples = function(row) {
    const n = row.length;
    const tot = n / 2;
    
    const graph = new Array(tot).fill(0).map(() => new Array());
    for (let i = 0; i < n; i += 2) {
        const l = Math.floor(row[i] / 2);
        const r = Math.floor(row[i + 1] / 2);
        if (l != r) {
            graph[l].push(r);
            graph[r].push(l);
        }
    }
    const visited = new Array(tot).fill(false);
    let ret = 0;
    for (let i = 0; i < tot; i++) {
        if (!visited[i]) {
            const queue = [];
            visited[i] = true;
            queue.push(i);
            let cnt = 0;

            while (queue.length) {
                const x = queue.shift();
                cnt += 1;

                for (const y of graph[x]) {
                    if (!visited[y]) {
                        visited[y] = true;
                        queue.push(y);
                    }
                }
            }
            ret += cnt - 1;
        }
    }
    return ret;
};
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 为情侣的总数。每个节点最多只被标记 $1$ 次。

- 空间复杂度：$O(N)$，其中 $N$ 为情侣的总数。为队列的开销。
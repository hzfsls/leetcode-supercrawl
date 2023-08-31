## [815.公交路线 中文官方题解](https://leetcode.cn/problems/bus-routes/solutions/100000/gong-jiao-lu-xian-by-leetcode-solution-yifz)

#### 方法一：优化建图 + 广度优先搜索

**思路及算法**

由于求解的目标是最少乘坐的公交车数量，对于同一辆公交车，乘客可以在其路线中的任意车站间无代价地移动，于是我们可以把公交路线当作点。如果两条公交路线有相同车站，则可以在这两条路线间换乘公交车，那么这两条公交路线之间可视作有一条长度为 $1$ 的边。这样建出的图包含的点数即为公交路线的数量，记作 $n$。

完成了建图后，我们需要先明确新的图的起点和终点，然后使用广度优先搜索，计算出的起点和终点的最短路径，从而得到最少换乘次数。

注意到原本的起点车站和终点车站可能同时位于多条公交路线上，因此在新图上可能有多个起点和终点。对于这种情况，我们初始可以同时入队多个点，并在广度优先搜索结束后检查到各个终点的最短路径，取其最小值才是最少换乘次数。

实际建图时，我们有以下两种方案：

- 方案一：我们直接枚举左右两端点，检查两点对应的两公交路线是否有公共车站。利用哈希表，我们可以将单次比较的时间复杂度优化到均摊 $O(n)$。
- 方案二：我们遍历所有公交路线，记录每一个车站属于哪些公交路线。然后我们遍历每一个车站，如果有多条公交路线经过该点，则在这些公交路线之间连边。

本题中我们采用方案二，据此还可以直接得到起点和终点在新图中对应的点。

实际代码中，我们使用哈希映射来实时维护「车站所属公交路线列表」。假设当前枚举到公交路线 $i$ 中的车站 $\textit{site}$，此时哈希映射中已记录若干条公交路线经过车站 $\textit{site}$，我们只需要让点 $i$ 与这些点公交路线对应的点相连即可。完成了连线后，我们再将公交路线 $i$ 加入到「车站 $\textit{site}$ 所属公交路线列表」中。

特别地，起点和终点相同时，我们可以直接返回 $0$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int numBusesToDestination(vector<vector<int>>& routes, int source, int target) {
        if (source == target) {
            return 0;
        }

        int n = routes.size();
        vector<vector<int>> edge(n, vector<int>(n));
        unordered_map<int, vector<int>> rec;
        for (int i = 0; i < n; i++) {
            for (int site : routes[i]) {
                for (int j : rec[site]) {
                    edge[i][j] = edge[j][i] = true;
                }
                rec[site].push_back(i);
            }
        }

        vector<int> dis(n, -1);
        queue<int> que;
        for (int bus : rec[source]) {
            dis[bus] = 1;
            que.push(bus);
        }
        while (!que.empty()) {
            int x = que.front();
            que.pop();
            for (int y = 0; y < n; y++) {
                if (edge[x][y] && dis[y] == -1) {
                    dis[y] = dis[x] + 1;
                    que.push(y);
                }
            }
        }

        int ret = INT_MAX;
        for (int bus : rec[target]) {
            if (dis[bus] != -1) {
                ret = min(ret, dis[bus]);
            }
        }
        return ret == INT_MAX ? -1 : ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numBusesToDestination(int[][] routes, int source, int target) {
        if (source == target) {
            return 0;
        }

        int n = routes.length;
        boolean[][] edge = new boolean[n][n];
        Map<Integer, List<Integer>> rec = new HashMap<Integer, List<Integer>>();
        for (int i = 0; i < n; i++) {
            for (int site : routes[i]) {
                List<Integer> list = rec.getOrDefault(site, new ArrayList<Integer>());
                for (int j : list) {
                    edge[i][j] = edge[j][i] = true;
                }
                list.add(i);
                rec.put(site, list);
            }
        }

        int[] dis = new int[n];
        Arrays.fill(dis, -1);
        Queue<Integer> que = new LinkedList<Integer>();
        for (int bus : rec.getOrDefault(source, new ArrayList<Integer>())) {
            dis[bus] = 1;
            que.offer(bus);
        }
        while (!que.isEmpty()) {
            int x = que.poll();
            for (int y = 0; y < n; y++) {
                if (edge[x][y] && dis[y] == -1) {
                    dis[y] = dis[x] + 1;
                    que.offer(y);
                }
            }
        }

        int ret = Integer.MAX_VALUE;
        for (int bus : rec.getOrDefault(target, new ArrayList<Integer>())) {
            if (dis[bus] != -1) {
                ret = Math.min(ret, dis[bus]);
            }
        }
        return ret == Integer.MAX_VALUE ? -1 : ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumBusesToDestination(int[][] routes, int source, int target) {
        if (source == target) {
            return 0;
        }

        int n = routes.Length;
        bool[,] edge = new bool[n, n];
        Dictionary<int, IList<int>> rec = new Dictionary<int, IList<int>>();
        for (int i = 0; i < n; i++) {
            foreach (int site in routes[i]) {
                IList<int> list = new List<int>();
                if (rec.ContainsKey(site)) {
                    list = rec[site];
                    foreach (int j in list) {
                        edge[i, j] = edge[j, i] = true;
                    }
                    rec[site].Add(i);
                } else {
                    list.Add(i);
                    rec.Add(site, list);
                }
            }
        }

        int[] dis = new int[n];
        Array.Fill(dis, -1);
        Queue<int> que = new Queue<int>();
        if (rec.ContainsKey(source)) {
            foreach (int bus in rec[source]) {
                dis[bus] = 1;
                que.Enqueue(bus);
            }
        }
        while (que.Count > 0) {
            int x = que.Dequeue();
            for (int y = 0; y < n; y++) {
                if (edge[x, y] && dis[y] == -1) {
                    dis[y] = dis[x] + 1;
                    que.Enqueue(y);
                }
            }
        }

        int ret = int.MaxValue;
        if (rec.ContainsKey(target)) {
            foreach (int bus in rec[target]) {
                if (dis[bus] != -1) {
                    ret = Math.Min(ret, dis[bus]);
                }
            }
        }
        return ret == int.MaxValue ? -1 : ret;
    }
}
```

```JavaScript [sol1-JavaScript]
var numBusesToDestination = function(routes, source, target) {
    if (source === target) {
        return 0;
    }

    const n = routes.length;
    const edge = new Array(n).fill(0).map(() => new Array(n).fill(0));
    const rec = new Map();
    for (let i = 0; i < n; i++) {
        for (const site of routes[i]) {
            const list = (rec.get(site) || []);
            for (const j of list) {
                edge[i][j] = edge[j][i] = true;
            }
            list.push(i);
            rec.set(site, list);
        }
    }

    const dis = new Array(n).fill(-1);
    const que = [];
    for (const bus of (rec.get(source) || [])) {
        dis[bus] = 1;
        que.push(bus);
    }
    while (que.length) {
        const x = que.shift();
        for (let y = 0; y < n; y++) {
            if (edge[x][y] && dis[y] === -1) {
                dis[y] = dis[x] + 1;
                que.push(y);
            }
        }
    }

    let ret = Number.MAX_VALUE;
    for (const bus of (rec.get(target) || [])) {
        if (dis[bus] !== -1) {
            ret = Math.min(ret, dis[bus]);
        }
    }
    return ret === Number.MAX_VALUE ? -1 : ret;
};
```

```go [sol1-Golang]
func numBusesToDestination(routes [][]int, source, target int) int {
    if source == target {
        return 0
    }

    n := len(routes)
    edge := make([][]bool, n)
    for i := range edge {
        edge[i] = make([]bool, n)
    }
    rec := map[int][]int{}
    for i, route := range routes {
        for _, site := range route {
            for _, j := range rec[site] {
                edge[i][j] = true
                edge[j][i] = true
            }
            rec[site] = append(rec[site], i)
        }
    }

    dis := make([]int, n)
    for i := range dis {
        dis[i] = -1
    }
    q := []int{}
    for _, bus := range rec[source] {
        dis[bus] = 1
        q = append(q, bus)
    }
    for len(q) > 0 {
        x := q[0]
        q = q[1:]
        for y, b := range edge[x] {
            if b && dis[y] == -1 {
                dis[y] = dis[x] + 1
                q = append(q, y)
            }
        }
    }

    ans := math.MaxInt32
    for _, bus := range rec[target] {
        if dis[bus] != -1 && dis[bus] < ans {
            ans = dis[bus]
        }
    }
    if ans < math.MaxInt32 {
        return ans
    }
    return -1
}
```

```C [sol1-C]
struct Vector {
    int* arr;
    int capacity;
    int size;
};

void init(struct Vector* vec) {
    vec->arr = malloc(sizeof(int));
    vec->capacity = 1;
    vec->size = 0;
}

void push_back(struct Vector* vec, int val) {
    if (vec->size == vec->capacity) {
        vec->capacity <<= 1;
        vec->arr = realloc(vec->arr, sizeof(int) * vec->capacity);
    }
    vec->arr[vec->size++] = val;
}

int numBusesToDestination(int** routes, int routesSize, int* routesColSize, int source, int target) {
    if (source == target) {
        return 0;
    }

    int n = routesSize;
    int edge[n][n];
    memset(edge, 0, sizeof(edge));
    struct Vector rec[100001];
    for (int i = 0; i < 100001; i++) {
        init(&rec[i]);
    }
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < routesColSize[i]; j++) {
            int site = routes[i][j];
            for (int k = 0; k < rec[site].size; k++) {
                edge[i][rec[site].arr[k]] = edge[rec[site].arr[k]][i] = true;
            }
            push_back(&rec[site], i);
        }
    }
    int dis[n];
    memset(dis, -1, sizeof(dis));
    int que[n];
    int left = 0, right = 0;

    for (int i = 0; i < rec[source].size; i++) {
        dis[rec[source].arr[i]] = 1;
        que[right++] = rec[source].arr[i];
    }
    while (left < right) {
        int x = que[left++];
        for (int y = 0; y < n; y++) {
            if (edge[x][y] && dis[y] == -1) {
                dis[y] = dis[x] + 1;
                que[right++] = y;
            }
        }
    }

    int ret = INT_MAX;

    for (int i = 0; i < rec[target].size; i++) {
        if (dis[rec[target].arr[i]] != -1) {
            ret = fmin(ret, dis[rec[target].arr[i]]);
        }
    }
    return ret == INT_MAX ? -1 : ret;
}
```

**复杂度分析**

- 时间复杂度：$O(nm+n^2)$，其中 $n$ 是公交路线的数量，$m$ 是车站的总数量。建图时最坏的情况是，所有的公交路线都经过相同的车站，而本题中限制了所有公交路线的车站总数。因此最坏的情况为，每条公交路都经过相同的 $O(\frac{m}{n})$ 个车站，建图的时间复杂度为 $O(\frac{m}{n}) \times O(n) \times O(n) = O(nm)$。同时广度优先搜索的时间复杂度为 $O(n^2)$，因此总时间复杂度为 $O(nm+n^2)$。

- 空间复杂度：$O(n^2+m)$，其中 $n$ 是公交路线的数量，$m$ 是车站的总数量。记录「经过任意车站的公交路线的列表」的空间复杂度为 $O(m)$，使用邻接矩阵存图的空间复杂度为 $O(n^2)$。
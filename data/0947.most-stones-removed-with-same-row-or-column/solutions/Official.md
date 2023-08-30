#### 方法一：深度优先搜索

**思路及解法**

我们将这个二维平面抽象成图，把石子看作「点」，石子间的同行或同列关系看作「边」。如果两个石子同属某一行或某一列，我们就认为这两个石子之间有一条边。由题意可知，对于任意一个点，只要有点和它相连，我们就可以将其删除。

显然，对于任意一个连通图，我们总可以通过调整节点的删除顺序，把这个连通图中删到只剩下一个节点。本题中我们不需要关注如何安排删除顺序，只需要了解这个性质即可。

**拓展**：对于希望进一步拓展的同学，这里给出一个方法：从连通块中处理出任意一个生成树，该生成树的以任意一点为根节点的后序遍历均为可行解。

这样我们只需要统计整张图中有多少个极大连通子图（也叫做连通块或连通分量）即可。最终能够留下来的点的数量，即为连通块的数量。我们用总点数减去连通块的数量，即可知道我们可以删去的点的最大数量。

在实际代码实现中，我们首先枚举计算任意两点间的连通性，然后使用深度优先搜索的方式计算连通块的数量即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    void dfs(int x, vector<vector<int>> &edge, vector<int> &vis) {
        vis[x] = true;
        for (auto &y : edge[x]) {
            if (!vis[y]) {
                dfs(y, edge, vis);
            }
        }
    }

    int removeStones(vector<vector<int>> &stones) {
        int n = stones.size();
        vector<vector<int>> edge(n);
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (stones[i][0] == stones[j][0] || stones[i][1] == stones[j][1]) {
                    edge[i].push_back(j);
                }
            }
        }
        vector<int> vis(n);
        int num = 0;
        for (int i = 0; i < n; i++) {
            if (!vis[i]) {
                num++;
                dfs(i, edge, vis);
            }
        }
        return n - num;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int removeStones(int[][] stones) {
        int n = stones.length;
        List<List<Integer>> edge = new ArrayList<List<Integer>>();
        for (int i = 0; i < n; i++) {
            edge.add(new ArrayList<Integer>());
            for (int j = 0; j < n; j++) {
                if (stones[i][0] == stones[j][0] || stones[i][1] == stones[j][1]) {
                    edge.get(i).add(j);
                }
            }
        }
        boolean[] vis = new boolean[n];
        int num = 0;
        for (int i = 0; i < n; i++) {
            if (!vis[i]) {
                num++;
                dfs(i, edge, vis);
            }
        }
        return n - num;
    }

    public void dfs(int x, List<List<Integer>> edge, boolean[] vis) {
        vis[x] = true;
        for (int y : edge.get(x)) {
            if (!vis[y]) {
                dfs(y, edge, vis);
            }
        }
    }
}
```

```go [sol1-Golang]
func removeStones(stones [][]int) int {
    n := len(stones)
    graph := make([][]int, n)
    for i, p := range stones {
        for j, q := range stones {
            if p[0] == q[0] || p[1] == q[1] {
                graph[i] = append(graph[i], j)
            }
        }
    }
    vis := make([]bool, n)
    var dfs func(int)
    dfs = func(v int) {
        vis[v] = true
        for _, w := range graph[v] {
            if !vis[w] {
                dfs(w)
            }
        }
    }
    cnt := 0
    for i, v := range vis {
        if !v {
            cnt++
            dfs(i)
        }
    }
    return n - cnt
}
```

```Python [sol1-Python3]
class Solution:
    def removeStones(self, stones: List[List[int]]) -> int:
        n = len(stones)
        edge = collections.defaultdict(list)
        for i, (x1, y1) in enumerate(stones):
            for j, (x2, y2) in enumerate(stones):
                if x1 == x2 or y1 == y2:
                    edge[i].append(j)
        
        def dfs(x: int):
            vis.add(x)
            for y in edge[x]:
                if y not in vis:
                    dfs(y)
        
        vis = set()
        num = 0
        for i in range(n):
            if i not in vis:
                num += 1
                dfs(i)
        
        return n - num
```

```C [sol1-C]
void dfs(int x, int **edge, int *edgeSize, int *vis) {
    vis[x] = true;
    for (int i = 0; i < edgeSize[x]; i++) {
        int y = edge[x][i];
        if (!vis[y]) {
            dfs(y, edge, edgeSize, vis);
        }
    }
}

int removeStones(int **stones, int stonesSize, int *stonesColSize) {
    int *edge[stonesSize];
    for (int i = 0; i < stonesSize; i++) {
        edge[i] = malloc(sizeof(int) * stonesSize);
    }
    int edgeSize[stonesSize];
    memset(edgeSize, 0, sizeof(edgeSize));
    for (int i = 0; i < stonesSize; i++) {
        for (int j = 0; j < stonesSize; j++) {
            if (stones[i][0] == stones[j][0] || stones[i][1] == stones[j][1]) {
                edge[i][edgeSize[i]++] = j;
            }
        }
    }
    int vis[stonesSize];
    memset(vis, 0, sizeof(vis));
    int num = 0;
    for (int i = 0; i < stonesSize; i++) {
        if (!vis[i]) {
            num++;
            dfs(i, edge, edgeSize, vis);
        }
    }
    return stonesSize - num;
}
```

```JavaScript [sol1-JavaScript]
var removeStones = function(stones) {
    const n = stones.length;
    const edge = {};
    for (const [i, [x1, y1]] of stones.entries()) {
        for (const [j, [x2, y2]] of stones.entries()) {
            if (x1 === x2 || y1 === y2) {
                edge[i] ? edge[i].push(j) : edge[i] = [j];
            }
        }
    }

    vis = new Set();
    let num = 0;
    for (let i = 0; i < n; i++) {
        if (!vis.has(i)) {
            num++;
            dfs(i, vis, edge);
        }
    }
    return n - num;
};

const dfs = (x, vis, edge) => {
    vis.add(x);
    for (let y of edge[x]) {
        if (!vis.has(y)) {
            dfs(y, vis, edge);
        }
    }
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 为石子的数量。我们需要枚举计算任意两个石子是否在同行或同列，建图时间复杂度 $O(n^2)$，同时我们需要通过深度优先搜索计算连通块数量，每一个点和每一条边都被枚举一次，时间复杂度 $O(n+m)$。其中 $m$ 是边数，可以保证 $m < n^2$。因此总时间复杂度为 $O(n^2)$。

- 空间复杂度：$O(n^2)$。最坏情况下任意两点都相连，用来保存连通属性的边集数组将会达到 $O(n^2)$ 的大小。

#### 方法二：优化建图 + 深度优先搜索

**思路及解法**

注意到方法一中，建图的效率太过低下，我们考虑对其优化。

注意到任意两点间之间直接相连与间接相连并无影响，即我们只关注两点间的连通性，而不关注具体如何联通。因此考虑对于拥有 $k$ 个石子的任意一行或一列，我们都恰使用 $k-1$ 条边进行连接。这样我们就可以将边数从 $O(n^2)$ 的数量级降低到 $O(n)$。

这样，我们首先利用哈希表存储每一行或每一列所拥有的石子，然后分别处理每一行或每一列的连通属性即可。

注意到每一个石子的横坐标与纵坐标的范围均在 $[1,10^4]$，因此在实际代码中，我们可以使用同一张哈希表，只需要令纵坐标加 $10^4$，以区别横坐标与纵坐标即可。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    void dfs(int x, vector<vector<int>> &edge, vector<int> &vis) {
        vis[x] = true;
        for (auto &y : edge[x]) {
            if (!vis[y]) {
                dfs(y, edge, vis);
            }
        }
    }

    int removeStones(vector<vector<int>> &stones) {
        int n = stones.size();
        vector<vector<int>> edge(n);
        unordered_map<int, vector<int>> rec;
        for (int i = 0; i < n; i++) {
            rec[stones[i][0]].push_back(i);
            rec[stones[i][1] + 10001].push_back(i);
        }
        for (auto &[_, vec] : rec) {
            int k = vec.size();
            for (int i = 1; i < k; i++) {
                edge[vec[i - 1]].push_back(vec[i]);
                edge[vec[i]].push_back(vec[i - 1]);
            }
        }

        vector<int> vis(n);
        int num = 0;
        for (int i = 0; i < n; i++) {
            if (!vis[i]) {
                num++;
                dfs(i, edge, vis);
            }
        }
        return n - num;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int removeStones(int[][] stones) {
        int n = stones.length;
        List<List<Integer>> edge = new ArrayList<List<Integer>>();
        for (int i = 0; i < n; i++) {
            edge.add(new ArrayList<Integer>());
        }

        Map<Integer, List<Integer>> rec = new HashMap<Integer, List<Integer>>();
        for (int i = 0; i < n; i++) {
            if (!rec.containsKey(stones[i][0])) {
                rec.put(stones[i][0], new ArrayList<Integer>());
            }
            rec.get(stones[i][0]).add(i);
            if (!rec.containsKey(stones[i][1] + 10001)) {
                rec.put(stones[i][1] + 10001, new ArrayList<Integer>());
            }
            rec.get(stones[i][1] + 10001).add(i);
        }
        for (Map.Entry<Integer, List<Integer>> entry : rec.entrySet()) {
            List<Integer> list = entry.getValue();
            int k = list.size();
            for (int i = 1; i < k; i++) {
                edge.get(list.get(i - 1)).add(list.get(i));
                edge.get(list.get(i)).add(list.get(i - 1));
            }
        }

        boolean[] vis = new boolean[n];
        int num = 0;
        for (int i = 0; i < n; i++) {
            if (!vis[i]) {
                num++;
                dfs(i, edge, vis);
            }
        }
        return n - num;
    }

    public void dfs(int x, List<List<Integer>> edge, boolean[] vis) {
        vis[x] = true;
        for (int y : edge.get(x)) {
            if (!vis[y]) {
                dfs(y, edge, vis);
            }
        }
    }
}
```

```go [sol2-Golang]
func removeStones(stones [][]int) int {
    n := len(stones)
    rowCol := map[int][]int{}
    for i, p := range stones {
        x, y := p[0], p[1]+10001
        rowCol[x] = append(rowCol[x], i)
        rowCol[y] = append(rowCol[y], i)
    }

    graph := make([][]int, n)
    for _, id := range rowCol {
        for i := 1; i < len(id); i++ {
            v, w := id[i-1], id[i]
            graph[v] = append(graph[v], w)
            graph[w] = append(graph[w], v)
        }
    }

    vis := make([]bool, n)
    var dfs func(int)
    dfs = func(v int) {
        vis[v] = true
        for _, w := range graph[v] {
            if !vis[w] {
                dfs(w)
            }
        }
    }
    cnt := 0
    for i, v := range vis {
        if !v {
            cnt++
            dfs(i)
        }
    }
    return n - cnt
}
```

```Python [sol2-Python3]
class Solution:
    def removeStones(self, stones: List[List[int]]) -> int:
        n = len(stones)
        edge = collections.defaultdict(list)
        rec = collections.defaultdict(list)
        for i, (x, y) in enumerate(stones):
            rec[x].append(i)
            rec[y + 10001].append(i)
        
        for vec in rec.values():
            k = len(vec)
            for i in range(1, k):
                edge[vec[i - 1]].append(vec[i])
                edge[vec[i]].append(vec[i - 1])
        
        def dfs(x: int):
            vis.add(x)
            for y in edge[x]:
                if y not in vis:
                    dfs(y)
        
        vis = set()
        num = 0
        for i in range(n):
            if i not in vis:
                num += 1
                dfs(i)
        
        return n - num
```

```JavaScript [sol2-JavaScript]
var removeStones = function(stones) {
    const n = stones.length;
    const edge = {};
    const rec = {};
    for (const [i, [x, y]] of stones.entries()) {
        rec[x] ? rec[x].push(i) : rec[x] = [i];
        rec[y + 10001] ? rec[y + 10001].push(i) : rec[y + 10001] = [i];
    }

    for (const vec of Object.values(rec)) {
        const k = vec.length;
        for (let i = 1; i < k; i++) {
            edge[vec[i - 1]] ? edge[vec[i - 1]].push(vec[i]) : edge[vec[i - 1]] = [vec[i]];
            edge[vec[i]] ? edge[vec[i]].push(vec[i - 1]) : edge[vec[i]] = [vec[i - 1]];
        }
    }

    const vis = new Set();
    let num = 0;
    for (let i = 0; i < n; i++) {
        if (!vis.has(i)) {
            num++;
            dfs(i, vis, edge);
        }
    }
    return n - num;
};

const dfs = (x, vis, edge) => {
    vis.add(x);
    if (edge[x]){
        for (const y of edge[x]) {
            if (!vis.has(y)) {
                dfs(y, vis, edge);
            }
        }
    }
    
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为石子的数量。任意一个石子至多只有四条边与其相连，且至多被遍历一次。

- 空间复杂度：$O(n)$。任意一个石子至多只有四条边与其相连，用来保存连通属性的边集数组至多只会达到 $O(n)$ 的大小。

#### 方法三：优化建图 + 并查集

**思路及解法**

我们也可以变换思路，在方法一与方法二中，我们维护的是石子，实际上我们也可以直接维护石子所在的行与列。

实际操作时，我们直接将每一个石子的行与列进行合并即可，可以理解为，每一个点不是与其他所有点进行连接，而是连接到自己所在的行与列上，由行与列进行合并。

同时，既然我们只关注连通性本身，我们就可以利用并查集维护连通性。在实际代码中，我们以哈希表为底层数据结构实现父亲数组 $f$，最后哈希表中所有的键均为出现过的行与列，我们计算有多少行与列的父亲恰为自己，即可知道连通块的数量。

**代码**

```C++ [sol3-C++]
class DisjointSetUnion {
private:
    unordered_map<int, int> f, rank;

public:
    int find(int x) {
        if (!f.count(x)) {
            f[x] = x;
            rank[x] = 1;
        }
        return f[x] == x ? x : f[x] = find(f[x]);
    }

    void unionSet(int x, int y) {
        int fx = find(x), fy = find(y);
        if (fx == fy) {
            return;
        }
        if (rank[fx] < rank[fy]) {
            swap(fx, fy);
        }
        rank[fx] += rank[fy];
        f[fy] = fx;
    }

    int numberOfConnectedComponent() {
        int num = 0;
        for (auto &[x, fa] : f) {
            if (x == fa) {
                num++;
            }
        }
        return num;
    }
};

class Solution {
public:
    int removeStones(vector<vector<int>> &stones) {
        int n = stones.size();
        DisjointSetUnion dsu;
        for (int i = 0; i < n; i++) {
            dsu.unionSet(stones[i][0], stones[i][1] + 10001);
        }

        return n - dsu.numberOfConnectedComponent();
    }
};
```

```Java [sol3-Java]
class Solution {
    public int removeStones(int[][] stones) {
        int n = stones.length;
        DisjointSetUnion dsu = new DisjointSetUnion();
        for (int i = 0; i < n; i++) {
            dsu.unionSet(stones[i][0], stones[i][1] + 10001);
        }

        return n - dsu.numberOfConnectedComponent();
    }
}

class DisjointSetUnion {
    int[] f;
    int[] rank;

    public DisjointSetUnion() {
        f = new int[20001];
        rank = new int[20001];
        Arrays.fill(f, -1);
        Arrays.fill(rank, -1);
    }

    public int find(int x) {
        if (f[x] < 0) {
            f[x] = x;
            rank[x] = 1;
        }
        return f[x] == x ? x : (f[x] = find(f[x]));
    }

    public void unionSet(int x, int y) {
        int fx = find(x), fy = find(y);
        if (fx == fy) {
            return;
        }
        if (rank[fx] < rank[fy]) {
            int temp = fx;
            fx = fy;
            fy = temp;
        }
        rank[fx] += rank[fy];
        f[fy] = fx;
    }

    public int numberOfConnectedComponent() {
        int num = 0;
        for (int i = 0; i < 20000; i++) {
            if (f[i] == i) {
                num++;
            }
        }
        return num;
    }
}
```

```go [sol3-Golang]
func removeStones(stones [][]int) int {
    fa, rank := map[int]int{}, map[int]int{}
    var find func(int) int
    find = func(x int) int {
        if _, has := fa[x]; !has {
            fa[x], rank[x] = x, 1
        }
        if fa[x] != x {
            fa[x] = find(fa[x])
        }
        return fa[x]
    }
    union := func(x, y int) {
        fx, fy := find(x), find(y)
        if fx == fy {
            return
        }
        if rank[fx] < rank[fy] {
            fx, fy = fy, fx
        }
        rank[fx] += rank[fy]
        fa[fy] = fx
    }

    for _, p := range stones {
        union(p[0], p[1]+10001)
    }
    ans := len(stones)
    for x, fx := range fa {
        if x == fx {
            ans--
        }
    }
    return ans
}
```

```Python [sol3-Python3]
class DisjointSetUnion:
    def __init__(self):
        self.f = dict()
        self.rank = dict()
    
    def find(self, x: int) -> int:
        if x not in self.f:
            self.f[x] = x
            self.rank[x] = 1
            return x
        if self.f[x] == x:
            return x
        self.f[x] = self.find(self.f[x])
        return self.f[x]
    
    def unionSet(self, x: int, y: int):
        fx, fy = self.find(x), self.find(y)
        if fx == fy:
            return
        if self.rank[fx] < self.rank[fy]:
            fx, fy = fy, fx
        self.rank[fx] += self.rank[fy]
        self.f[fy] = fx

    def numberOfConnectedComponent(self) -> int:
        return sum(1 for x, fa in self.f.items() if x == fa)


class Solution:
    def removeStones(self, stones: List[List[int]]) -> int:
        dsu = DisjointSetUnion()
        for x, y in stones:
            dsu.unionSet(x, y + 10001)
        return len(stones) - dsu.numberOfConnectedComponent()
```

```C [sol3-C]
struct DisjointSetUnion {
    int key, f, rank;
    UT_hash_handle hh;
};

struct DisjointSetUnion *find(struct DisjointSetUnion **obj, int x) {
    struct DisjointSetUnion *tmp;
    HASH_FIND_INT(*obj, &x, tmp);
    if (tmp == NULL) {
        tmp = malloc(sizeof(struct DisjointSetUnion));
        tmp->key = x, tmp->f = x, tmp->rank = 1;
        HASH_ADD_INT(*obj, key, tmp);
    }
    if (tmp->key == tmp->f) {
        return tmp;
    }
    struct DisjointSetUnion *ret = find(obj, tmp->f);
    tmp->f = ret->f;
    return ret;
}

void unionSet(struct DisjointSetUnion **obj, int x, int y) {
    struct DisjointSetUnion *fx = find(obj, x), *fy = find(obj, y);
    if (fx->f == fy->f) {
        return;
    }
    if (fx->rank < fy->rank) {
        struct DisjointSetUnion *tmp = fx;
        fx = fy, fy = tmp;
    }
    fx->rank += fy->rank;
    fy->f = fx->key;
}

int numberOfConnectedComponent(struct DisjointSetUnion *obj) {
    int num = 0;
    struct DisjointSetUnion *iter, *tmp;
    HASH_ITER(hh, obj, iter, tmp) {
        if (iter->key == iter->f) {
            num++;
        }
    }
    return num;
}

int removeStones(int **stones, int stonesSize, int *stonesColSize) {
    struct DisjointSetUnion *dsu = NULL;
    for (int i = 0; i < stonesSize; i++) {
        unionSet(&dsu, stones[i][0], stones[i][1] + 10001);
    }
    return stonesSize - numberOfConnectedComponent(dsu);
}
```

```JavaScript [sol3-JavaScript]
var removeStones = function(stones) {
    const dsu = new DisjointSetUnion();
    for (const [x, y] of stones) {
        dsu.unionSet(x, y + 10001);
    }
    return stones.length - dsu.numberOfConnectedComponent();
};

class DisjointSetUnion {
    constructor() {
        this.f = new Map();
        this.rank = new Map();
    }

    find (x) {
        if (!this.f.has(x)) {
            this.f.set(x, x);
            this.rank.set(x, 1);
            return x;
        }
        if (this.f.get(x) === x) {
            return x;
        }
        this.f.set(x, this.find(this.f.get(x)));
        return this.f.get(x);
    }

    unionSet (x, y) {
        let fx = this.find(x), fy = this.find(y);
        if (fx  && fy) {

        }
        if (fx === fy) {
            return;
        }
        if (this.rank.get(fx) < this.rank.get(fy)) {
            [fx, fy] = [fy, fx];
        }
        this.rank.set(fx, this.rank.get(fy) + this.rank.get(fx));
        this.f.set(fy, fx);
    }

    numberOfConnectedComponent () {
        let sum = 0;
        for (const [x, fa] of this.f.entries()) {
            if (x === fa) {
                sum++;
            }
        }
        return sum;
    }
}
```

**复杂度分析**

- 时间复杂度：$O(n\alpha(n))$，其中 $n$ 为石子的数量。$\alpha$ 是反 $\text{Ackerman}$ 函数。

- 空间复杂度：$O(n)$。空间为并查集和哈希表的开销。
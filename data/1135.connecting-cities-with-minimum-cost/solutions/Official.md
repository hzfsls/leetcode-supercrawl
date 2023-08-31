## [1135.最低成本联通所有城市 中文官方题解](https://leetcode.cn/problems/connecting-cities-with-minimum-cost/solutions/100000/zui-di-cheng-ben-lian-tong-suo-you-cheng-shi-by-le)

#### 预备知识

[**最小生成树**](https://baike.baidu.com/item/最小生成树)
图的生成树是一棵含有其所有的顶点的无环联通子图，一幅加权图的**最小生成树（ MST ）** 是它的一颗权值（树中所有边的权值之和）最小的生成树。

[**并查集**](https://baike.baidu.com/item/并查集)
并查集是一种树型的数据结构，用于处理一些不相交集合的合并及查询问题。常常在使用中以森林来表示。

#### 方法一：Kruskal 算法

**思路**

根据题意，我们可以把 `n` 座城市看成 `n` 个顶点，连接两个城市的成本 `cost` 就是对应的权重，需要返回连接所有城市的最小成本。很显然，这是一个标准的最小生成树，首先我们介绍第一种经典算法： **Kruskal 算法**。

既然我们需要求最小成本，那么可以肯定的是这个图没有环（如果有环的话无论如何都可以删掉一条边使得成本更小）。该算法就是基于这个特性：
按照边的权重顺序（从小到大）处理所有的边，将边加入到最小生成树中，加入的边不会与已经加入的边构成环，直到树中含有 `n - 1` 条边为止。这些边会由一片森林变成一个树，这个树就是图的最小生成树。

![fig1](https://assets.leetcode-cn.com/solution-static/1135_fig1.gif)

**算法**

1. 将所有的边按照权重从小到大排序。
2. 取一条权重最小的边。
3. 使用并查集（union-find）数据结构来判断加入这条边后是否会形成环。若不会构成环，则将这条边加入最小生成树中。
4. 检查所有的结点是否已经全部联通，这一点可以通过目前已经加入的边的数量来判断。若全部联通，则结束算法；否则返回步骤 2.


**代码**

```Golang [sol1-Golang]
func minimumCost(n int, connections [][]int) int {
    id := make([]int, n)
    // 初始化并查集
    for i := 0; i < n; i++ {
    	id[i] = i
    }

    // 将所有的边按照权重从小到大排序
    sort.Slice(connections, func(i, j int) bool {
        return connections[i][2] < connections[j][2]
    })
    count, cost := 0, 0
    for _, connect := range connections {
        if count == n - 1 { // 如果已经有 n - 1 条边，说明说有点的点都已经联通
            break
        }
        if find(connect[0] - 1, id) == find(connect[1] - 1, id) { // 会形成环，不需要加入
            continue
        }
        union(connect[0] - 1, connect[1] - 1, id) // 关联两个点，并加入到最小生成树中
        count++
        cost += connect[2]
    }
    if count != n - 1 {
        return -1
    }
    return cost
}

func union(i, j int, id []int) {
    x := find(i, id)
    y := find(j, id)
    if x == y {
    	return
    }
    id[x] = y
}

func find(x int, id []int) int {
    if x == id[x] {
        return x
    }
    return find(id[x], id)
}
```

```Python [sol1-Python3]
class Solution:
    def find(self, x):
        if x == self.father[x]:
            return x
        return self.find(self.father[x])

    def minimumCost(self, n: int, connections: List[List[int]]) -> int:
        self.father = [i for i in range(n + 1)]
        connections.sort(key=lambda edge: edge[2])
        ans = 0
        edge_cnt = 0
        for a, b, cost in connections:
            root_a = self.find(a)
            root_b = self.find(b)
            if root_a != root_b:
                self.father[root_a] = root_b
                ans += cost
                edge_cnt += 1
            if edge_cnt == n - 1:
                return ans
        return -1
```


**复杂度分析**

- 时间复杂度：$O(e \log e + e*n)$，其中 $e$ 为边的数量，$n$ 为城市的数量。排序的时间复杂度为 $O(e \log e)$，我们需要遍历 $e$ 条边。对于每条边，查找两个端点的根结点最多需要经过 $2n$ 个结点。所以时间复杂度最坏为 $O(e*n)$。

- 空间复杂度：$O(n)$，需要大小为 $n$ 的并查集结构存储点的关系，其中 $n$ 为城市的个数。

#### 方法二：Kruskal 算法 + 加权 Union 算法

**思路**

方法一我们检查环的过程中，最坏的情况下每次需要遍历所有的边，形成一个永远只有左子节点的树。为了避免形成这样的结构，我们可以记录每一颗树的大小并且总是将较小的树连接到较大的树上，这个算法就叫**加权 Union 算法**。该算法需要添加一个数组记录树中的节点数，并且在联通的时候比较节点个数，将较小的树连接到较大的树上。

**代码**

```Golang [sol2-Golang]
func minimumCost(n int, connections [][]int) int {
    sz := make([]int, n) // 记录树的大小
    id := make([]int, n)
    for i := 0; i < n; i++ {
    	sz[i] = 1
    	id[i] = i
    }
    sort.Slice(connections, func(i, j int) bool {
        return connections[i][2] < connections[j][2]
    })
    count, cost := 0, 0
    for _, connect := range connections {
        if count == n - 1 {
            break
        }
        if find(connect[0] - 1, id) == find(connect[1] - 1, id) {
            continue
        }
        union(connect[0] - 1, connect[1] - 1, sz, id)
        count++
        cost += connect[2]
    }
    if count != n - 1 {
        return -1
    }
    return cost
}

// 将较小的树连接到较大的树上
func union(i, j int, sz, id []int) {
    x := find(i, id)
    y := find(j, id)
    if x == y {
    	return
    }
    if sz[x] < sz[y] {
    	id[x] = y
    	sz[y] += sz[x]
    } else {
    	id[y] = x
    	sz[x] += sz[y]
    }
}

func find(x int, id []int) int {
    if x == id[x] {
        return x
    }
    return find(id[x], id)
}

```

```Python [sol2-Python3]
class Solution:
    def find(self, x):
        if x == self.father[x]:
            return x
        return self.find(self.father[x])

    def minimumCost(self, n: int, connections: List[List[int]]) -> int:
        self.father = [i for i in range(n + 1)]
        self.size = [1 for i in range(n + 1)]
        connections.sort(key=lambda edge: edge[2])
        ans = 0
        edge_cnt = 0
        for a, b, cost in connections:
            root_a = self.find(a)
            root_b = self.find(b)
            if root_a != root_b:
                if self.size[root_a] > self.size[root_b]:
                    root_a, root_b = root_b, root_a
                self.father[root_a] = root_b
                self.size[root_b] += self.size[root_a]
                ans += cost
                edge_cnt += 1
            if edge_cnt == n - 1:
                return ans
        return -1
```

**复杂度分析**

- 时间复杂度：$O(e(\log e + \log n))$，使用加权 Union 算法后，`find` 操作的时间复杂度为 $O(\log n)$。另外此时的时间复杂度还受排序操作制约，排序操作复杂度为 $O(e\log e)$，综合起来时间复杂度为 $O(e(\log e + \log n))$。

- 空间复杂度：$O(n)$，需要大小为 $n$ 的并查集结构存储点的关系，其中 $n$ 为城市的个数。

#### 方法三：Kruskal 算法 + 加权 Union 算法 + 路径压缩

**思路**

考虑在方法一和方法二中我们使用的 `find` 函数，可以发现，一些路径是被重复寻找了的。

举个例子，假设在并查集中有四个结点，其中 `1` 的父亲是 `2`，`2` 的父亲是 `3`，`3` 的父亲是 `4`。那么我们在以后每次寻找 `1` 所在的集合时，都需要经过 `1-2-3` 这条路径；查找 `2` 所在的集合时，都需要经过 `2-3-4` 这条路径。可以想到，在一个大型图中，查找根结点的路径中会存在大量与此类似的重复查询。

而事实上，我们通过一个简单的操作来避免这样的重复查询：我们可以在 `find` 函数结束的时候，将路径上所有的结点，修改为根结点的直接子结点。这样，我们下次查询时，就可以直接找到刚才找到的根结点，不需要再查询一次相同的路径了。

**代码**

```Golang [sol3-Golang]
func minimumCost(n int, connections [][]int) int {
    sz := make([]int, n) // 记录树的大小
    id := make([]int, n)
    for i := 0; i < n; i++ {
    	sz[i] = 1
    	id[i] = i
    }
    sort.Slice(connections, func(i, j int) bool {
        return connections[i][2] < connections[j][2]
    })
    count, cost := 0, 0
    for _, connect := range connections {
        if count == n - 1 {
            break
        }
        if find(connect[0] - 1, id) == find(connect[1] - 1, id) {
            continue
        }
        union(connect[0] - 1, connect[1] - 1, sz, id)
        count++
        cost += connect[2]
    }
    if count != n - 1 {
        return -1
    }
    return cost
}

// 将较小的树连接到较大的树上
func union(i, j int, sz, id []int) {
    x := find(i, id)
    y := find(j, id)
    if x == y {
    	return
    }
    if sz[x] < sz[y] {
    	id[x] = y
    	sz[y] += sz[x]
    } else {
    	id[y] = x
    	sz[x] += sz[y]
    }
}

func find(x int, id []int) int {
    for x != id[x] {
    	id[x] = id[id[x]]
    	x = id[x]
    }
    return id[x]
}
```

```Python [sol3-Python3]
class Solution:
    def find(self, x):
        if x == self.father[x]:
            return x
        self.father[x] = self.find(self.father[x])
        return self.father[x]

    def minimumCost(self, n: int, connections: List[List[int]]) -> int:
        self.father = [i for i in range(n + 1)]
        self.size = [1 for i in range(n + 1)]
        connections.sort(key=lambda edge: edge[2])
        ans = 0
        edge_cnt = 0
        for a, b, cost in connections:
            root_a = self.find(a)
            root_b = self.find(b)
            if root_a != root_b:
                if self.size[root_a] > self.size[root_b]:
                    root_a, root_b = root_b, root_a
                self.father[root_a] = root_b
                self.size[root_b] += self.size[root_a]
                ans += cost
                edge_cnt += 1
            if edge_cnt == n - 1:
                return ans
        return -1
```

**复杂度分析**

- 时间复杂度：$O(e*(\log e + \alpha(n)))$，其中 $e$ 为边的数量，$n$ 为城市的数量。经过优化后，`find` 操作的时间复杂度为 $O(\alpha(n))$ ，其中 $\alpha$ 为[反阿克曼函数](https://baike.baidu.com/item/阿克曼函数)，其增长极其缓慢，也就是说其单次操作的平均运行时间可以认为是一个很小的常数。具体的证明过于复杂，了解结论即可。此时算法的总体时间复杂度仍然受排序操作制约，为 $O(e\log e)$，综合可得时间复杂度为 $O(e*(\log e + \alpha(n)))$。

- 空间复杂度：$O(n)$，需要大小为 $n$ 的并查集结构存储点的关系，其中 $n$ 为城市的个数。

#### 方法四：Prim 算法

**思路**

Kruskal 算法的核心思想是每次把权重最小的边加入到树中，Prim 算法则是依据顶点来生成的，它的每一步都会为一颗生长中的树添加一条边，一开始这棵树只有一个顶点，然后会添加 `n - 1` 条边，每次都是将下一条连接树中的顶点与不在树中的顶点且权重最小的边加入到树中。

**算法**

1. 根据 `connections` 记录每个顶点到其他顶点的权重，记为 `edges` 。
2. 使用 `visited` 记录所有被访问过的点。
3. 使用堆来根据权重比较所有的边。
4. 将任意一个点记为已访问，并将其所有连接的边放入堆中。
5. 从堆中拿出权重最小的边。
6. 如果已经访问过，直接丢弃。
7. 如果未访问过，标记为已访问，并且将其所有连接的边放入堆中，检查是否有 n 个点。
8. 重复操作 5。

**代码**

```Golang [sol4-Golang]
// 为了方便存储，将 1 - n 改成 0 - n-1
func minimumCost(n int, connections [][]int) int {
    var (
        cost = 0
        edges = make([][]Edge, n)
        visited = make([]bool, n)
        h = &EdgeHeap{}
    )
    heap.Init(h)
    visited[0] = true // 从第 0 个开始
    for _, connect := range connections {
        edges[connect[0] - 1] = append(edges[connect[0] - 1], Edge{connect[1] - 1, connect[2]})
        edges[connect[1] - 1] = append(edges[connect[1] - 1], Edge{connect[0] - 1, connect[2]})
    }
    // 将与第一个城市连接的城市放入 heap 中
    for _, edge := range edges[0] {
        heap.Push(h,edge)
    }

    count := 1
    for h.Len() > 0 {    
        e := heap.Pop(h).(Edge)
        if visited[e.city] {
            continue
        }
        visited[e.city] = true
        for _, edge := range edges[e.city] {
            heap.Push(h, edge)
        }
        cost += e.cost
        count++
        if count == n {
            return cost
        }
    }
    return -1
}

type Edge struct {
    city int
    cost int
}

type EdgeHeap []Edge

func (h EdgeHeap) Len() int           { return len(h) }
func (h EdgeHeap) Less(i, j int) bool { return h[i].cost < h[j].cost }
func (h EdgeHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }

func (h *EdgeHeap) Push(x interface{}) {
    *h = append(*h, x.(Edge))
}

func (h *EdgeHeap) Pop() interface{} {
    old := *h
    n := len(old)
    x := old[n-1]
    *h = old[0 : n-1]
    return x
}
```

```Python [sol4-Python3]
class Solution:
    def minimumCost(self, n: int, connections: List[List[int]]) -> int:
        edges = [[] for i in range(n + 1)]
        for a, b, cost in connections:
            edges[a].append((b, cost))
            edges[b].append((a, cost))
        intree = set()
        # 存储可以向外扩展的边，格式为（开销，目的城市）
        out_edges = [(0, 1)]
        ans = 0
        while out_edges and len(intree) != n:
            cost, city = heapq.heappop(out_edges)
            if city not in intree:
                intree.add(city)
                ans += cost
                for next_city, next_cost in edges[city]:
                    heapq.heappush(out_edges, (next_cost, next_city))
        if len(intree) != n:
            return -1
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n + e\log e)$ ，其中 $e$ 为边的个数。堆的操作时间复杂度为 $O(\log e)$，最多需要进行 $2e$ 次操作，所以时间复杂度为 $O(e\log e)$。另外建立表头长度为 $n$，总长度为 $e$ 的 `edges` 数组需要 $O(n + e)$ 的时间。

- 空间复杂度：$O(e + n)$，`edge` 的长度为 $n$，并且需要存 $e$ 个边。
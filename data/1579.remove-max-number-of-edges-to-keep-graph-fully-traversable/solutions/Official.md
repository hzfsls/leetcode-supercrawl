## [1579.保证图可完全遍历 中文官方题解](https://leetcode.cn/problems/remove-max-number-of-edges-to-keep-graph-fully-traversable/solutions/100000/bao-zheng-tu-ke-wan-quan-bian-li-by-leet-mtrw)
#### 方法一：并查集

**思路与算法**

我们称类型 $1, 2, 3$ 的边分别为「Alice 独占边」「Bob 独占边」以及「公共边」。

首先我们需要思考什么样的图是可以被 Alice 和 Bob 完全遍历的。对于 Alice 而言，她可以经过的边是「Alice 独占边」以及「公共边」，由于她需要能够从任意节点到达任意节点，那么就说明：

> 当图中仅有「Alice 独占边」以及「公共边」时，整个图是连通的，即整个图只包含一个连通分量。

同理，对于 Bob 而言，当图中仅有「Bob 独占边」以及「公共边」时，整个图也要是连通的。

由于题目描述中希望我们删除**最多数目**的边，这等价于保留**最少数目**的边。换句话说，我们可以从一个仅包含 $n$ 个节点（而没有边）的无向图开始，逐步添加边，使得满足上述的要求。

那么我们应该按照什么策略来添加边呢？直觉告诉我们，「公共边」的重要性大于「Alice 独占边」以及「Bob 独占边」，因为「公共边」是 Alice 和 Bob 都可以使用的，而他们各自的独占边却不能给对方使用。「公共边」的重要性也是可以证明的：

> 对于一条连接了两个**不同**的连通分量的「公共边」而言，如果我们不保留这条公共边，那么 Alice 和 Bob 就无法往返这两个连通分量，即他们分别需要使用各自的独占边。因此，Alice 需要一条连接这两个连通分量的独占边，Bob 同样也需要一条连接这两个连通分量的独占边，那么一共需要两条边，这就严格不优于直接使用一条连接这两个连通分量的「公共边」了。

因此，我们可以遵从优先添加「公共边」的策略。具体地，我们遍历每一条「公共边」，对于其连接的的两个节点：

- 如果这两个节点在同一个连通分量中，那么添加这条「公共边」是无意义的；

- 如果这两个节点不在同一个连通分量中，我们就可以（并且一定）添加这条「公共边」，然后合并这两个节点所在的连通分量。

这就提示了我们使用**并查集**来维护整个图的连通性，上述的策略只需要用到并查集的「查询」和「合并」这两个最基础的操作。

在处理完了所有的「公共边」之后，我们需要处理他们各自的独占边，而方法也与添加「公共边」类似。我们将当前的并查集复制一份，一份交给 Alice，一份交给 Bob。随后 Alice 不断地向并查集中添加「Alice 独占边」，Bob 不断地向并查集中添加「Bob 独占边」。在处理完了所有的独占边之后，如果这两个并查集都只包含一个连通分量，那么就说明 Alice 和 Bob 都可以遍历整个无向图。

**细节**

在使用并查集进行合并的过程中，我们每遇到一次失败的合并操作（即需要合并的两个点属于同一个连通分量），那么就说明当前这条边可以被删除，将答案增加 $1$。

**代码**

```C++ [sol1-C++]
// 并查集模板
class UnionFind {
public:
    vector<int> parent;
    vector<int> size;
    int n;
    // 当前连通分量数目
    int setCount;
    
public:
    UnionFind(int _n): n(_n), setCount(_n), parent(_n), size(_n, 1) {
        iota(parent.begin(), parent.end(), 0);
    }
    
    int findset(int x) {
        return parent[x] == x ? x : parent[x] = findset(parent[x]);
    }
    
    bool unite(int x, int y) {
        x = findset(x);
        y = findset(y);
        if (x == y) {
            return false;
        }
        if (size[x] < size[y]) {
            swap(x, y);
        }
        parent[y] = x;
        size[x] += size[y];
        --setCount;
        return true;
    }
    
    bool connected(int x, int y) {
        x = findset(x);
        y = findset(y);
        return x == y;
    }
};

class Solution {
public:
    int maxNumEdgesToRemove(int n, vector<vector<int>>& edges) {
        UnionFind ufa(n), ufb(n);
        int ans = 0;

        // 节点编号改为从 0 开始
        for (auto& edge: edges) {
            --edge[1];
            --edge[2];
        }

        // 公共边
        for (const auto& edge: edges) {
            if (edge[0] == 3) {
                if (!ufa.unite(edge[1], edge[2])) {
                    ++ans;
                }
                else {
                    ufb.unite(edge[1], edge[2]);
                }
            }
        }

        // 独占边
        for (const auto& edge: edges) {
            if (edge[0] == 1) {
                // Alice 独占边
                if (!ufa.unite(edge[1], edge[2])) {
                    ++ans;
                }
            }
            else if (edge[0] == 2) {
                // Bob 独占边
                if (!ufb.unite(edge[1], edge[2])) {
                    ++ans;
                }
            }
        }

        if (ufa.setCount != 1 || ufb.setCount != 1) {
            return -1;
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxNumEdgesToRemove(int n, int[][] edges) {
        UnionFind ufa = new UnionFind(n);
        UnionFind ufb = new UnionFind(n);
        int ans = 0;

        // 节点编号改为从 0 开始
        for (int[] edge : edges) {
            --edge[1];
            --edge[2];
        }

        // 公共边
        for (int[] edge : edges) {
            if (edge[0] == 3) {
                if (!ufa.unite(edge[1], edge[2])) {
                    ++ans;
                } else {
                    ufb.unite(edge[1], edge[2]);
                }
            }
        }

        // 独占边
        for (int[] edge : edges) {
            if (edge[0] == 1) {
                // Alice 独占边
                if (!ufa.unite(edge[1], edge[2])) {
                    ++ans;
                }
            } else if (edge[0] == 2) {
                // Bob 独占边
                if (!ufb.unite(edge[1], edge[2])) {
                    ++ans;
                }
            }
        }

        if (ufa.setCount != 1 || ufb.setCount != 1) {
            return -1;
        }
        return ans;
    }
}

// 并查集模板
class UnionFind {
    int[] parent;
    int[] size;
    int n;
    // 当前连通分量数目
    int setCount;

    public UnionFind(int n) {
        this.n = n;
        this.setCount = n;
        this.parent = new int[n];
        this.size = new int[n];
        Arrays.fill(size, 1);
        for (int i = 0; i < n; ++i) {
            parent[i] = i;
        }
    }
    
    public int findset(int x) {
        return parent[x] == x ? x : (parent[x] = findset(parent[x]));
    }
    
    public boolean unite(int x, int y) {
        x = findset(x);
        y = findset(y);
        if (x == y) {
            return false;
        }
        if (size[x] < size[y]) {
            int temp = x;
            x = y;
            y = temp;
        }
        parent[y] = x;
        size[x] += size[y];
        --setCount;
        return true;
    }
    
    public boolean connected(int x, int y) {
        x = findset(x);
        y = findset(y);
        return x == y;
    }
}
```

```Python [sol1-Python3]
# 并查集模板
class UnionFind:
    def __init__(self, n: int):
        self.parent = list(range(n))
        self.size = [1] * n
        self.n = n
        # 当前连通分量数目
        self.setCount = n
    
    def findset(self, x: int) -> int:
        if self.parent[x] == x:
            return x
        self.parent[x] = self.findset(self.parent[x])
        return self.parent[x]
    
    def unite(self, x: int, y: int) -> bool:
        x, y = self.findset(x), self.findset(y)
        if x == y:
            return False
        if self.size[x] < self.size[y]:
            x, y = y, x
        self.parent[y] = x
        self.size[x] += self.size[y]
        self.setCount -= 1
        return True
    
    def connected(self, x: int, y: int) -> bool:
        x, y = self.findset(x), self.findset(y)
        return x == y

class Solution:
    def maxNumEdgesToRemove(self, n: int, edges: List[List[int]]) -> int:
        ufa, ufb = UnionFind(n), UnionFind(n)
        ans = 0
        
        # 节点编号改为从 0 开始
        for edge in edges:
            edge[1] -= 1
            edge[2] -= 1

        # 公共边
        for t, u, v in edges:
            if t == 3:
                if not ufa.unite(u, v):
                    ans += 1
                else:
                    ufb.unite(u, v)

        # 独占边
        for t, u, v in edges:
            if t == 1:
                # Alice 独占边
                if not ufa.unite(u, v):
                    ans += 1
            elif t == 2:
                # Bob 独占边
                if not ufb.unite(u, v):
                    ans += 1

        if ufa.setCount != 1 or ufb.setCount != 1:
            return -1
        return ans
```

```JavaScript [sol1-JavaScript]
// 并查集模板
class UnionFind {
    constructor (n) {
        this.parent = new Array(n).fill(0).map((element, index) => index);
        this.size = new Array(n).fill(1);
        // 当前连通分量数目
        this.setCount = n;
    }

    findset (x) {
        if (this.parent[x] === x) {
            return x;
        }
        this.parent[x] = this.findset(this.parent[x]);
        return this.parent[x];
    }

    unite (a, b) {
        let x = this.findset(a), y = this.findset(b);
        if (x === y) {
            return false;
        }
        if (this.size[x] < this.size[y]) {
            [x, y] = [y, x];
        }
        this.parent[y] = x;
        this.size[x] += this.size[y];
        this.setCount -= 1;
        return true;
    }

    connected (a, b) {
        const x = this.findset(a), y = this.findset(b);
        return x === y;
    }
}

var maxNumEdgesToRemove = function(n, edges) {
    const ufa = new UnionFind(n), ufb = new UnionFind(n);
    let ans = 0;

    // 节点编号改为从 0 开始
    for (const edge of edges) {
        edge[1] -= 1;
        edge[2] -= 1;
    }
    // 公共边
    for (const [t, u, v] of edges) {
        if (t === 3) {
            if (!ufa.unite(u, v)) {
                ans += 1;
            } else {
                ufb.unite(u, v);
            }
        }
    }
    // 独占边
    for (const [t, u, v] of edges) {
        if (t === 1) {
            // Alice 独占边
            if (!ufa.unite(u, v)) {
                ans += 1;
            }
        } else if (t === 2) {
            // Bob 独占边
            if (!ufb.unite(u, v)) {
                ans += 1;
            }
        }
    }
    if (ufa.setCount !== 1 || ufb.setCount !== 1) {
        return -1;
    }
    return ans;
};
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

func (uf *unionFind) union(x, y int) bool {
    fx, fy := uf.find(x), uf.find(y)
    if fx == fy {
        return false
    }
    if uf.size[fx] < uf.size[fy] {
        fx, fy = fy, fx
    }
    uf.size[fx] += uf.size[fy]
    uf.parent[fy] = fx
    uf.setCount--
    return true
}

func (uf *unionFind) inSameSet(x, y int) bool {
    return uf.find(x) == uf.find(y)
}

func maxNumEdgesToRemove(n int, edges [][]int) int {
    ans := len(edges)
    alice, bob := newUnionFind(n), newUnionFind(n)
    for _, e := range edges {
        x, y := e[1]-1, e[2]-1
        if e[0] == 3 && (!alice.inSameSet(x, y) || !bob.inSameSet(x, y)) {
            // 保留这条公共边
            alice.union(x, y)
            bob.union(x, y)
            ans--
        }
    }
    uf := [2]*unionFind{alice, bob}
    for _, e := range edges {
        if tp := e[0]; tp < 3 && uf[tp-1].union(e[1]-1, e[2]-1) {
            // 保留这条独占边
            ans--
        }
    }
    if alice.setCount > 1 || bob.setCount > 1 {
        return -1
    }
    return ans
}
```

```C [sol1-C]
void swap(int* a, int* b) {
    int tmp = *a;
    *a = *b, *b = tmp;
}

struct DisjointSetUnion {
    int *f, *size;
    int n, setCount;
};

void initDSU(struct DisjointSetUnion* obj, int n) {
    obj->f = malloc(sizeof(int) * n);
    obj->size = malloc(sizeof(int) * n);
    obj->n = n;
    obj->setCount = n;
    for (int i = 0; i < n; i++) {
        obj->f[i] = i;
        obj->size[i] = 1;
    }
}

int find(struct DisjointSetUnion* obj, int x) {
    return obj->f[x] == x ? x : (obj->f[x] = find(obj, obj->f[x]));
}

int unionSet(struct DisjointSetUnion* obj, int x, int y) {
    int fx = find(obj, x), fy = find(obj, y);
    if (fx == fy) {
        return false;
    }
    if (obj->size[fx] < obj->size[fy]) {
        swap(&fx, &fy);
    }
    obj->size[fx] += obj->size[fy];
    obj->f[fy] = fx;
    obj->setCount--;
    return true;
}

int maxNumEdgesToRemove(int n, int** edges, int edgesSize, int* edgesColSize) {
    struct DisjointSetUnion* ufa = malloc(sizeof(struct DisjointSetUnion));
    initDSU(ufa, n);
    struct DisjointSetUnion* ufb = malloc(sizeof(struct DisjointSetUnion));
    initDSU(ufb, n);
    int ans = 0;

    // 节点编号改为从 0 开始
    for (int i = 0; i < edgesSize; i++) {
        edges[i][1]--;
        edges[i][2]--;
    }

    // 公共边
    for (int i = 0; i < edgesSize; i++) {
        if (edges[i][0] == 3) {
            if (!unionSet(ufa, edges[i][1], edges[i][2])) {
                ++ans;
            } else {
                unionSet(ufb, edges[i][1], edges[i][2]);
            }
        }
    }

    // 独占边
    for (int i = 0; i < edgesSize; i++) {
        if (edges[i][0] == 1) {
            // Alice 独占边
            if (!unionSet(ufa, edges[i][1], edges[i][2])) {
                ++ans;
            }
        } else if (edges[i][0] == 2) {
            // Bob 独占边
            if (!unionSet(ufb, edges[i][1], edges[i][2])) {
                ++ans;
            }
        }
    }

    if (ufa->setCount != 1 || ufb->setCount != 1) {
        return -1;
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(m \cdot \alpha(n))$，其中 $m$ 是数组 $\textit{edges}$ 的长度，$\alpha$ 是阿克曼函数的反函数。

- 空间复杂度：$O(n)$，即为并查集需要使用的空间。
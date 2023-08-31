## [959.由斜杠划分区域 中文官方题解](https://leetcode.cn/problems/regions-cut-by-slashes/solutions/100000/you-xie-gang-hua-fen-qu-yu-by-leetcode-s-ztob)
#### 方法一：并查集

**思路分析**

我们沿着一个方块的两条对角线，能够将正方形切分成四个小三角形。而方块上的字符 `\`、`/` 可以被看做两条对角线中的一条，并将正方形网格切分成两个不联通的部分。

下图给出了一个简单的示例，其中黑色的实线代表方块的边界，红色的实线代表方块位置的字符，而黑色的虚线代表着方块内（除字符之外）的对角线。

![fig1](https://assets.leetcode-cn.com/solution-static/959/1.png){:width="60%"}

从图中可以观察到以下信息：
- 如果方块上的字符为 `/`，则右下角的两个小三角形会与左上角的两个小三角形分隔开；
- 如果方块上的字符为 `\`，则右上角的两个小三角形会和左下角的两个小三角形分隔开；
- 一个联通的区域，必然由若干个「相邻」的小三角形构成。两个小三角形「相邻」的条件是它们有一条公共的边，且**它们没有被方块上的字符分隔开**。

因此，我们可以构建这样一张新图：每个小三角形为该图中的顶点；如果两个小三角形「相邻」，则在对应的两个顶点中间连接一条边。于是原图中一个联通的区域，就等价于新图中的一个联通分量。

为了求解图中的联通分量数目，应当使用并查集来解决本题。

**算法详解**

设网格为 $n \times n$ 大小，则图中有 $4n^2$ 个节点，每个方块对应其中的 $4$ 个节点。、

为了下文中描述方便，我们按照下图的方式，给每个方块的四个小三角形编号 $0,1,2,3$：

![fig2](https://assets.leetcode-cn.com/solution-static/959/2.png){:width="60%"}

随后，我们遍历网格中的每一个方块。对于当前方块而言，考虑其位置上的字符：

- 如果为空格，则该方块的四个小三角形应当同属于同一区域，因此在它们对应的顶点之间各连接一条边；

- 如果为字符 `/`，则方块被切分成两个部分，此时在 $0$ 号和 $3$ 号小三角形之间连接一条边，并在 $1$ 号和 $2$ 号小三角形之间连接一条边；

- 如果为字符 `\`，则方块被切分成两个部分，此时在 $0$ 号和 $1$ 号小三角形之间连接一条边，并在 $2$ 号和 $3$ 号小三角形之间连接一条边；

此外，我们还需要考虑两个相邻方块的三角形之间的连接关系：

- 一个方块中最下方的三角形（$2$ 号），必然和下面的方块（如果存在）中最上方的三角形（$0$ 号）连通；

- 一个方块中最右方的三角形（$1$ 号），必然和右边的方块（如果存在）中最左方的三角形（$3$ 号）连通。

故我们还需要根据上面两条规则，在相邻方块的相应三角形中间再连接边。

最终，在构造出节点之间的连接关系后后，就可以利用并查集求出连通分量的数目了。

**代码**

由于图中有 $4n^2$ 个节点，因此我们需要给每个小三角形赋予一个唯一的整数标号。

在下面的代码中，首先会给每个方块赋予一个 $[0,n^2)$ 之间的整数值：对于一个第 $i$ 行第 $j$ 列的方块，其对应的整数值为 $\textit{idx} = i\cdot n + j$。

随后再给每个小三角形赋予一个 $[0,4n^2)$ 的整数值：对于一个标号为 $\textit{idx}$ 的方块中的 $k$ 号小三角形，其整数值为 $4\textit{idx} + k$。


```C++ [sol1-C++]
class Solution {
public:
    int find(vector<int>& f, int x) {
        if (f[x] == x) {
            return x;
        }
        int fa = find(f, f[x]);
        f[x] = fa;
        return fa;
    }

    void merge(vector<int>& f, int x, int y) {
        int fx = find(f, x);
        int fy = find(f, y);
        f[fx] = fy;
    }

    int regionsBySlashes(vector<string>& grid) {
        int n = grid.size();
        vector<int> f(n * n * 4);
        for (int i = 0; i < n * n * 4; i++) {
            f[i] = i;
        }

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                int idx = i * n + j;
                if (i < n - 1) {
                    int bottom = idx + n;
                    merge(f, idx * 4 + 2, bottom * 4);
                }
                if (j < n - 1) {
                    int right = idx + 1;
                    merge(f, idx * 4 + 1, right * 4 + 3);
                }
                if (grid[i][j] == '/') {
                    merge(f, idx * 4, idx * 4 + 3);
                    merge(f, idx * 4 + 1, idx * 4 + 2);
                } else if (grid[i][j] == '\\') {
                    merge(f, idx * 4, idx * 4 + 1);
                    merge(f, idx * 4 + 2, idx * 4 + 3);
                } else {
                    merge(f, idx * 4, idx * 4 + 1);
                    merge(f, idx * 4 + 1, idx * 4 + 2);
                    merge(f, idx * 4 + 2, idx * 4 + 3);
                }
            }
        }

        unordered_set<int> fathers;
        for (int i = 0; i < n * n * 4; i++) {
            int fa = find(f, i);
            fathers.insert(fa);
        }
        return fathers.size();
    }
};
```

```Java [sol1-Java]
class Solution {
    public int regionsBySlashes(String[] grid) {
        int n = grid.length;
        int[] f = new int[n * n * 4];
        for (int i = 0; i < n * n * 4; i++) {
            f[i] = i;
        }

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                int idx = i * n + j;
                if (i < n - 1) {
                    int bottom = idx + n;
                    merge(f, idx * 4 + 2, bottom * 4);
                }
                if (j < n - 1) {
                    int right = idx + 1;
                    merge(f, idx * 4 + 1, right * 4 + 3);
                }
                if (grid[i].charAt(j) == '/') {
                    merge(f, idx * 4, idx * 4 + 3);
                    merge(f, idx * 4 + 1, idx * 4 + 2);
                } else if (grid[i].charAt(j) == '\\') {
                    merge(f, idx * 4, idx * 4 + 1);
                    merge(f, idx * 4 + 2, idx * 4 + 3);
                } else {
                    merge(f, idx * 4, idx * 4 + 1);
                    merge(f, idx * 4 + 1, idx * 4 + 2);
                    merge(f, idx * 4 + 2, idx * 4 + 3);
                }
            }
        }

        Set<Integer> fathers = new HashSet<Integer>();
        for (int i = 0; i < n * n * 4; i++) {
            int fa = find(f, i);
            fathers.add(fa);
        }
        return fathers.size();
    }

    public int find(int[] f, int x) {
        if (f[x] == x) {
            return x;
        }
        int fa = find(f, f[x]);
        f[x] = fa;
        return fa;
    }

    public void merge(int[] f, int x, int y) {
        int fx = find(f, x);
        int fy = find(f, y);
        f[fx] = fy;
    }
}
```

```JavaScript [sol1-JavaScript]
var regionsBySlashes = function(grid) {
    const n = grid.length;
    const f = new Array(n * n * 4).fill(0)
                                  .map((element, index) => {return index});
    
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < n; j++) {
            const idx = i * n + j;
            if (i < n - 1) {
                const bottom = idx + n;
                merge(f, idx * 4 + 2, bottom * 4);
            }
            if (j < n - 1) {
                const right = idx + 1;
                merge(f, idx * 4 + 1, right * 4 + 3);
            }
            if (grid[i][j] === '/') {
                merge(f, idx * 4, idx * 4 + 3);
                merge(f, idx * 4 + 1, idx * 4 + 2);
            } else if (grid[i][j] == '\\') {
                merge(f, idx * 4, idx * 4 + 1);
                merge(f, idx * 4 + 2, idx * 4 + 3);
            } else {
                merge(f, idx * 4, idx * 4 + 1);
                merge(f, idx * 4 + 1, idx * 4 + 2);
                merge(f, idx * 4 + 2, idx * 4 + 3);
            }
        }
    }
    
    let ret = 0;
    f.forEach((element, index) => {
        if (element === index) {
            ret++;
        }
    })
    return ret;
};

find = (f, x) => {
    if (f[x] === x) {
        return x;
    }
    return find(f, f[x]);
}

merge = (f, x, y) => {
    const fx = find(f, x), fy = find(f, y);
    f[fx] = fy;
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

func regionsBySlashes(grid []string) int {
    n := len(grid)
    uf := newUnionFind(4 * n * n)
    for i := 0; i < n; i++ {
        for j := 0; j < n; j++ {
            idx := i*n + j
            if i < n-1 {
                bottom := idx + n
                uf.union(idx*4+2, bottom*4)
            }
            if j < n-1 {
                right := idx + 1
                uf.union(idx*4+1, right*4+3)
            }
            if grid[i][j] == '/' {
                uf.union(idx*4, idx*4+3)
                uf.union(idx*4+1, idx*4+2)
            } else if grid[i][j] == '\\' {
                uf.union(idx*4, idx*4+1)
                uf.union(idx*4+2, idx*4+3)
            } else {
                uf.union(idx*4, idx*4+1)
                uf.union(idx*4+1, idx*4+2)
                uf.union(idx*4+2, idx*4+3)
            }
        }
    }
    return uf.setCount
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

struct HashTable {
    int val;
    UT_hash_handle hh;
};

int regionsBySlashes(char** grid, int gridSize) {
    int n = gridSize;
    struct DisjointSetUnion* uf = malloc(sizeof(struct DisjointSetUnion));
    initDSU(uf, n * n * 4);

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            int idx = i * n + j;
            if (i < n - 1) {
                int bottom = idx + n;
                unionSet(uf, idx * 4 + 2, bottom * 4);
            }
            if (j < n - 1) {
                int right = idx + 1;
                unionSet(uf, idx * 4 + 1, right * 4 + 3);
            }
            if (grid[i][j] == '/') {
                unionSet(uf, idx * 4, idx * 4 + 3);
                unionSet(uf, idx * 4 + 1, idx * 4 + 2);
            } else if (grid[i][j] == '\\') {
                unionSet(uf, idx * 4, idx * 4 + 1);
                unionSet(uf, idx * 4 + 2, idx * 4 + 3);
            } else {
                unionSet(uf, idx * 4, idx * 4 + 1);
                unionSet(uf, idx * 4 + 1, idx * 4 + 2);
                unionSet(uf, idx * 4 + 2, idx * 4 + 3);
            }
        }
    }

    struct HashTable* fathers = NULL;
    for (int i = 0; i < n * n * 4; i++) {
        int fa = find(uf, i);
        struct HashTable* tmp;
        HASH_FIND_INT(fathers, &fa, tmp);
        if (tmp == NULL) {
            tmp = malloc(sizeof(struct HashTable));
            tmp->val = fa;
            HASH_ADD_INT(fathers, val, tmp);
        }
    }
    return HASH_COUNT(fathers);
}
```

**复杂度分析**

- 时间复杂度：$O(n^2\log n)$，其中 $n$ 是网格的边长。仅使用路径压缩的并查集的复杂度为 $O(n^2\log n^2)=O(n^2\times 2\log n)=O(n^2\log n)$。

- 空间复杂度：$O(n^2)$。
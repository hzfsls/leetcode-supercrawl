## [1697.检查边长度限制的路径是否存在 中文官方题解](https://leetcode.cn/problems/checking-existence-of-edge-length-limited-paths/solutions/100000/jian-cha-bian-chang-du-xian-zhi-de-lu-ji-cdr5)

#### 前言

关于并查集的详细说明可以参考 OI Wiki「[并查集](https://oi-wiki.org/ds/dsu/)」或者 LeetBook「[并查集](https://leetcode.cn/leetbook/detail/disjoint-set/)」，本文不作过多说明。

#### 方法一：离线查询 + 并查集

给定一个查询时，我们可以遍历 $\textit{edgeList}$ 中的所有边，依次将长度小于 $\textit{limit}$ 的边加入到并查集中，然后使用并查集查询 $p$ 和 $q$ 是否属于同一个集合。如果 $p$ 和 $q$ 属于同一个集合，则说明存在从 $p$ 到 $q$ 的路径，且这条路径上的每一条边的长度都严格小于 $\textit{limit}$，查询返回 $\text{true}$，否则查询返回 $\text{false}$。

如果 $\textit{queries}$ 的 $\textit{limit}$ 是非递减的，显然上一次查询的并查集里的边都是满足当前查询的 $\textit{limit}$ 要求的，我们只需要将剩余的长度小于 $\textit{limit}$ 的边加入并查集中即可。基于此，我们首先将 $\textit{edgeList}$ 按边长度从小到大进行排序，然后将 $\textit{queries}$ 按 $\textit{limit}$ 从小到大进行排序，使用 $k$ 指向上一次查询中不满足 $\textit{limit}$ 要求的长度最小的边，显然初始时 $k=0$。

我们依次遍历 $\textit{queries}$：如果 $k$ 指向的边的长度小于对应查询的 $\textit{limit}$，则将该边加入并查集中，然后将 $k$ 加 $1$，直到 $k$ 指向的边不满足要求；最后根据并查集查询对应的 $p$ 和 $q$ 是否属于同一集合来保存查询的结果。

```Python [sol1-Python3]
class Solution:
    def distanceLimitedPathsExist(self, n: int, edgeList: List[List[int]], queries: List[List[int]]) -> List[bool]:
        edgeList.sort(key=lambda e: e[2])

        # 并查集模板
        fa = list(range(n))
        def find(x: int) -> int:
            if fa[x] != x:
                fa[x] = find(fa[x])
            return fa[x]
        def merge(from_: int, to: int) -> None:
            fa[find(from_)] = find(to)

        ans, k = [False] * len(queries), 0
        # 查询的下标按照 limit 从小到大排序，方便离线
        for i, (p, q, limit) in sorted(enumerate(queries), key=lambda p: p[1][2]):
            while k < len(edgeList) and edgeList[k][2] < limit:
                merge(edgeList[k][0], edgeList[k][1])
                k += 1
            ans[i] = find(p) == find(q)
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int find(vector<int> &uf, int x) {
        if (uf[x] == x) {
            return x;
        }
        return uf[x] = find(uf, uf[x]);
    }

    void merge(vector<int> &uf, int x, int y) {
        x = find(uf, x);
        y = find(uf, y);
        uf[y] = x;
    }

    vector<bool> distanceLimitedPathsExist(int n, vector<vector<int>>& edgeList, vector<vector<int>>& queries) {
        sort(edgeList.begin(), edgeList.end(), [](vector<int> &e1, vector<int> &e2) {
            return e1[2] < e2[2];
        });

        vector<int> index(queries.size());
        iota(index.begin(), index.end(), 0);
        sort(index.begin(), index.end(), [&](int i1, int i2) {
            return queries[i1][2] < queries[i2][2];
        });

        vector<int> uf(n);
        iota(uf.begin(), uf.end(), 0);
        vector<bool> res(queries.size());
        int k = 0;
        for (auto i : index) {
            while (k < edgeList.size() && edgeList[k][2] < queries[i][2]) {
                merge(uf, edgeList[k][0], edgeList[k][1]);
                k++;
            }
            res[i] = find(uf, queries[i][0]) == find(uf, queries[i][1]);
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean[] distanceLimitedPathsExist(int n, int[][] edgeList, int[][] queries) {
        Arrays.sort(edgeList, (a, b) -> a[2] - b[2]);

        Integer[] index = new Integer[queries.length];
        for (int i = 0; i < queries.length; i++) {
            index[i] = i;
        }
        Arrays.sort(index, (a, b) -> queries[a][2] - queries[b][2]);

        int[] uf = new int[n];
        for (int i = 0; i < n; i++) {
            uf[i] = i;
        }
        boolean[] res = new boolean[queries.length];
        int k = 0;
        for (int i : index) {
            while (k < edgeList.length && edgeList[k][2] < queries[i][2]) {
                merge(uf, edgeList[k][0], edgeList[k][1]);
                k++;
            }
            res[i] = find(uf, queries[i][0]) == find(uf, queries[i][1]);
        }
        return res;
    }

    public int find(int[] uf, int x) {
        if (uf[x] == x) {
            return x;
        }
        return uf[x] = find(uf, uf[x]);
    }

    public void merge(int[] uf, int x, int y) {
        x = find(uf, x);
        y = find(uf, y);
        uf[y] = x;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool[] DistanceLimitedPathsExist(int n, int[][] edgeList, int[][] queries) {
        Array.Sort(edgeList, (a, b) => a[2] - b[2]);

        int[] index = new int[queries.Length];
        for (int i = 0; i < queries.Length; i++) {
            index[i] = i;
        }
        Array.Sort(index, (a, b) => queries[a][2] - queries[b][2]);

        int[] uf = new int[n];
        for (int i = 0; i < n; i++) {
            uf[i] = i;
        }
        bool[] res = new bool[queries.Length];
        int k = 0;
        foreach (int i in index) {
            while (k < edgeList.Length && edgeList[k][2] < queries[i][2]) {
                Merge(uf, edgeList[k][0], edgeList[k][1]);
                k++;
            }
            res[i] = Find(uf, queries[i][0]) == Find(uf, queries[i][1]);
        }
        return res;
    }

    public int Find(int[] uf, int x) {
        if (uf[x] == x) {
            return x;
        }
        return uf[x] = Find(uf, uf[x]);
    }

    public void Merge(int[] uf, int x, int y) {
        x = Find(uf, x);
        y = Find(uf, y);
        uf[y] = x;
    }
}
```

```C [sol1-C]
static int find(int *uf, int x) {
    if (uf[x] == x) {
        return x;
    }
    return uf[x] = find(uf, uf[x]);
}

static void merge(int *uf, int x, int y) {
    x = find(uf, x);
    y = find(uf, y);
    uf[y] = x;
}

static int cmp1(const void *pa, const void *pb) {
    int *a = *(int **)pa;
    int *b = *(int **)pb;
    return a[2] - b[2];
}

static int cmp2(const void *pa, const void *pb) {
    int *a = (int *)pa;
    int *b = (int *)pb;
    return a[1] - b[1];
}

bool* distanceLimitedPathsExist(int n, int** edgeList, int edgeListSize, int* edgeListColSize, int** queries, int queriesSize, int* queriesColSize, int* returnSize) {
    qsort(edgeList, edgeListSize, sizeof(edgeList[0]), cmp1);
    int index[queriesSize][2];
    for (int i = 0; i < queriesSize; i++) {
        index[i][0] = i;
        index[i][1] = queries[i][2];
        
    }
    qsort(index, queriesSize, sizeof(index[0]), cmp2);
    int uf[n];
    bool *res = (bool *)malloc(sizeof(bool) * queriesSize);
    for (int i = 0; i < n; i++) {
        uf[i] = i;
    }
    for (int j = 0, k = 0; j < queriesSize; j++) {
        int i = index[j][0];
        while (k < edgeListSize && edgeList[k][2] < queries[i][2]) {
            merge(uf, edgeList[k][0], edgeList[k][1]);
            k++;
        }
        res[i] = find(uf, queries[i][0]) == find(uf, queries[i][1]);
    }
    *returnSize = queriesSize;
    return res;
}
```

```JavaScript [sol1-JavaScript]
var distanceLimitedPathsExist = function(n, edgeList, queries) {
    edgeList.sort((a, b) => a[2] - b[2]);
    const index = new Array(queries.length).fill(0);
    for (let i = 0; i < queries.length; i++) {
        index[i] = i;
    }
    index.sort((a, b) => queries[a][2] - queries[b][2]);

    const uf = new Array(n).fill(0);
    for (let i = 0; i < n; i++) {
        uf[i] = i;
    }
    const res = new Array(queries.length).fill(0);
    let k = 0;
    for (let i of index) {
        while (k < edgeList.length && edgeList[k][2] < queries[i][2]) {
            merge(uf, edgeList[k][0], edgeList[k][1]);
            k++;
        }
        res[i] = find(uf, queries[i][0]) == find(uf, queries[i][1]);
    }
    return res;
}

const find = (uf, x) => {
    if (uf[x] === x) {
        return x;
    }
    return uf[x] = find(uf, uf[x]);
}

const merge = (uf, x, y) => {
    x = find(uf, x);
    y = find(uf, y);
    uf[y] = x;
};
```

```go [sol1-Golang]
func distanceLimitedPathsExist(n int, edgeList [][]int, queries [][]int) []bool {
    sort.Slice(edgeList, func(i, j int) bool { return edgeList[i][2] < edgeList[j][2] })

    // 并查集模板
    fa := make([]int, n)
    for i := range fa {
        fa[i] = i
    }
    var find func(int) int
    find = func(x int) int {
        if fa[x] != x {
            fa[x] = find(fa[x])
        }
        return fa[x]
    }
    merge := func(from, to int) {
        fa[find(from)] = find(to)
    }

    for i := range queries {
        queries[i] = append(queries[i], i)
    }
    // 按照 limit 从小到大排序，方便离线
    sort.Slice(queries, func(i, j int) bool { return queries[i][2] < queries[j][2] })

    ans := make([]bool, len(queries))
    k := 0
    for _, q := range queries {
        for ; k < len(edgeList) && edgeList[k][2] < q[2]; k++ {
            merge(edgeList[k][0], edgeList[k][1])
        }
        ans[q[3]] = find(q[0]) == find(q[1])
    }
    return ans
}
```

**复杂度分析**

+ 时间复杂度：$O \big ( E \log E + m \log m + (E + m) \log n + n \big )$，其中 $E$ 是 $\textit{edgeList}$ 的长度，$m$ 是 $queries$ 的长度，$n$ 是点数。对 $\textit{edgeList}$ 和 $\textit{queries}$ 进行排序分别需要 $O(E\log E)$ 和 $O(m\log m)$，并查集初始化需要 $O(n)$，并查集查询和合并总共需要 $O \big ((E+m)\log n \big )$。

+ 空间复杂度：$O(\log E + m + n)$。保存并查集需要 $O(n)$ 的空间，保存 $\textit{index}$ 需要 $O(m)$ 的空间，以及排序需要的栈空间。
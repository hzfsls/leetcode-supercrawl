#### 方法一：并查集

**思路及解法**

既然可以任意地交换通过「索引对」直接相连的字符，那么我们也任意地交换通过「索引对」间接相连的字符。我们利用这个性质将该字符串抽象：将每一个字符抽象为「点」，那么这些「索引对」即为「边」，我们只需要维护这个「图」的连通性即可。对于同属一个连通块（极大连通子图）内的字符，我们可以任意地交换它们。

这样我们的思路就很清晰了：利用并查集维护任意两点的连通性，将同属一个连通块内的点提取出来，直接排序后放置回其在字符串中的原位置即可。

**代码**

```C++ [sol1-C++]
class DisjointSetUnion {
private:
    vector<int> f, rank;
    int n;

public:
    DisjointSetUnion(int _n) {
        n = _n;
        rank.resize(n, 1);
        f.resize(n);
        for (int i = 0; i < n; i++) {
            f[i] = i;
        }
    }

    int find(int x) {
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
};

class Solution {
public:
    string smallestStringWithSwaps(string s, vector<vector<int>>& pairs) {
        DisjointSetUnion dsu(s.length());
        for (auto& it : pairs) {
            dsu.unionSet(it[0], it[1]);
        }
        unordered_map<int, vector<int>> mp;
        for (int i = 0; i < s.length(); i++) {
            mp[dsu.find(i)].emplace_back(s[i]);
        }
        for (auto& [x, vec] : mp) {
            sort(vec.begin(), vec.end(), greater<int>());
        }
        for (int i = 0; i < s.length(); i++) {
            int x = dsu.find(i);
            s[i] = mp[x].back();
            mp[x].pop_back();
        }
        return s;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String smallestStringWithSwaps(String s, List<List<Integer>> pairs) {
        DisjointSetUnion dsu = new DisjointSetUnion(s.length());
        for (List<Integer> pair : pairs) {
            dsu.unionSet(pair.get(0), pair.get(1));
        }
        Map<Integer, List<Character>> map = new HashMap<Integer, List<Character>>();
        for (int i = 0; i < s.length(); i++) {
            int parent = dsu.find(i);
            if (!map.containsKey(parent)) {
                map.put(parent, new ArrayList<Character>());
            }
            map.get(parent).add(s.charAt(i));
        }
        for (Map.Entry<Integer, List<Character>> entry : map.entrySet()) {
            Collections.sort(entry.getValue(), new Comparator<Character>() {
                public int compare(Character c1, Character c2) {
                    return c2 - c1;
                }
            });
        }
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < s.length(); i++) {
            int x = dsu.find(i);
            List<Character> list = map.get(x);
            sb.append(list.remove(list.size() - 1));
        }
        return sb.toString();
    }
}

class DisjointSetUnion {
    int[] f;
    int[] rank;
    int n;

    public DisjointSetUnion(int n) {
        this.n = n;
        rank = new int[n];
        Arrays.fill(rank, 1);
        f = new int[n];
        for (int i = 0; i < n; i++) {
            f[i] = i;
        }
    }

    public int find(int x) {
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
}
```

```go [sol1-Golang]
func smallestStringWithSwaps(s string, pairs [][]int) string {
    n := len(s)
    fa := make([]int, n)
    rank := make([]int, n)
    for i := range fa {
        fa[i] = i
        rank[i] = 1
    }
    var find func(int) int
    find = func(x int) int {
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

    for _, p := range pairs {
        union(p[0], p[1])
    }

    groups := map[int][]byte{}
    for i := range s {
        f := find(i)
        groups[f] = append(groups[f], s[i])
    }

    for _, bytes := range groups {
        sort.Slice(bytes, func(i, j int) bool { return bytes[i] < bytes[j] })
    }

    ans := make([]byte, n)
    for i := range ans {
        f := find(i)
        ans[i] = groups[f][0]
        groups[f] = groups[f][1:]
    }
    return string(ans)
}
```

```C [sol1-C]
struct HashTable {
    int key;
    int len;
    int* vec;
    UT_hash_handle hh;
};

int cmp(int* a, int* b) {
    return *b - *a;
}

void swap(int* a, int* b) {
    int tmp = *a;
    *a = *b, *b = tmp;
}

struct DisjointSetUnion {
    int *f, *rank;
    int n;
};

void init(struct DisjointSetUnion* obj, int _n) {
    obj->n = _n;
    obj->rank = malloc(sizeof(int) * obj->n);
    memset(obj->rank, 0, sizeof(int) * obj->n);
    obj->f = malloc(sizeof(int) * obj->n);
    for (int i = 0; i < obj->n; i++) {
        obj->f[i] = i;
    }
}

int find(struct DisjointSetUnion* obj, int x) {
    return obj->f[x] == x ? x : (obj->f[x] = find(obj, obj->f[x]));
}

void unionSet(struct DisjointSetUnion* obj, int x, int y) {
    int fx = find(obj, x), fy = find(obj, y);
    if (fx == fy) {
        return;
    }
    if (obj->rank[fx] < obj->rank[fy]) {
        swap(&fx, &fy);
    }
    obj->rank[fx] += obj->rank[fy];
    obj->f[fy] = fx;
}

char* smallestStringWithSwaps(char* s, int** pairs, int pairsSize, int* pairsColSize) {
    int n = strlen(s);
    struct DisjointSetUnion* dsu = malloc(sizeof(struct DisjointSetUnion));
    init(dsu, n);
    for (int i = 0; i < pairsSize; i++) {
        unionSet(dsu, pairs[i][0], pairs[i][1]);
    }
    struct HashTable *mp = NULL, *iter, *tmp;
    for (int i = 0; i < n; i++) {
        int ikey = find(dsu, i);
        HASH_FIND_INT(mp, &ikey, tmp);
        if (tmp == NULL) {
            tmp = malloc(sizeof(struct HashTable));
            tmp->key = ikey;
            tmp->len = 1;
            tmp->vec = NULL;
            HASH_ADD_INT(mp, key, tmp);
        } else {
            tmp->len++;
        }
    }
    HASH_ITER(hh, mp, iter, tmp) {
        iter->vec = malloc(sizeof(int) * iter->len);
        iter->len = 0;
    }
    for (int i = 0; i < n; i++) {
        int ikey = find(dsu, i);
        HASH_FIND_INT(mp, &ikey, tmp);
        tmp->vec[tmp->len++] = s[i];
    }
    HASH_ITER(hh, mp, iter, tmp) {
        qsort(iter->vec, iter->len, sizeof(int), cmp);
    }

    for (int i = 0; i < n; i++) {
        int ikey = find(dsu, i);
        HASH_FIND_INT(mp, &ikey, tmp);
        s[i] = tmp->vec[--tmp->len];
    }
    return s;
}
```

```JavaScript [sol1-JavaScript]
var smallestStringWithSwaps = function(s, pairs) {
    const fa = new Array(100010).fill(0);

    const find = (x) => {
        return x === fa[x] ? x : fa[x] = find(fa[x]);
    }

    const n = s.length;
    for (let i = 0; i < n; i++) {
        fa[i] = i;
    }
    for (let i = 0; i < pairs.length; ++i) {
        const x = pairs[i][0], y = pairs[i][1];
        const ux = find(x), uy = find(y);
        if (ux ^ uy) {
            fa[ux] = uy;
        }
    }

    const vec = new Array(n).fill(0).map(() => new Array());
    for (let i = 0; i < n; i++) {
        fa[i] = find(i);
        vec[fa[i]].push(s[i]);
    }

    for (let i = 0; i < n; ++i) { 
        if (vec[i].length > 0) {
            vec[i].sort((a, b) => a.charCodeAt() - b.charCodeAt());
        }
    }
    const p = new Array(n).fill(0);
    let ans = [];
    for (let i = 0; i < n; ++i) {
        ans.push('1');
    }

    for (let i = 0; i < n; ++i) {
        ans[i] = vec[fa[i]][p[fa[i]]];
        p[fa[i]]++;
    }
    
    return ans.join('');
};
```

```Python [sol1-Python3]
class DisjointSetUnion:
    def __init__(self, n: int):
        self.n = n
        self.rank = [1] * n
        self.f = list(range(n))
    
    def find(self, x: int) -> int:
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
        
class Solution:
    def smallestStringWithSwaps(self, s: str, pairs: List[List[int]]) -> str:
        dsu = DisjointSetUnion(len(s))
        for x, y in pairs:
            dsu.unionSet(x, y)
        
        mp = collections.defaultdict(list)
        for i, ch in enumerate(s):
            mp[dsu.find(i)].append(ch)
        
        for vec in mp.values():
            vec.sort(reverse=True)
        
        ans = list()
        for i in range(len(s)):
            x = dsu.find(i)
            ans.append(mp[x][-1])
            mp[x].pop()
        
        return "".join(ans)
```

**复杂度分析**

- 时间复杂度：$O(n \log n + m \alpha(m)))$，其中 $n$ 为字符串的长度，$m$ 为「索引对」数量。并查集单次合并时间复杂度为 $O(\alpha(n))$。而最坏情况下任意两点均联通，我们需要将整个字符串排序，时间复杂度 $O(n \log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 为字符串的长度。并查集需要占用 $O(n)$ 的空间，排序所用数组也需要总计 $O(n)$ 的空间。
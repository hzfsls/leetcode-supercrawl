#### 方法一：哈希表

**思路与算法**

将网格转换成一个坐标系，行下标作为 $x$ 坐标，列下标作为 $y$ 坐标。我们使用直线与坐标轴上交点的数值来唯一标识行，列和正/反对角线。相应的规则为：

> 求解通过灯坐标的行直线与 $x$ 轴的交点，将交点的 $x$ 坐标作为通过灯坐标的行的数值。
> 求解通过灯坐标的列直线与 $y$ 轴的交点，将交点的 $y$ 坐标作为通过灯坐标的列的数值。
> 求解通过灯坐标的正对角线与 $x$ 轴的交点，将交点的 $x$ 坐标作为通过灯坐标的正对角线的数值。
> 求解通过灯坐标的反对角线与 $y$ 轴的交点，将交点的 $y$ 坐标作为通过灯坐标的反对角线的数值。

假设一盏灯的坐标为 $(x_i,~y_i)$，那么它所在的行的数值为 $x_i$，列的数值为 $y_i$，正对角线的数值为 $x_i-y_i$，反对角线的数值为 $x_i+y_i$。确定某一直线的唯一数值标识后，我们就可以通过哈希表来记录某一直线所拥有的灯的数目。

遍历 $\textit{lamps}$，将当前遍历到的灯所在的行，列和正/反对角线拥有灯的数目分别加一。

> 在处理 $\textit{lamps}$ 时，需要进行去重，因为我们将重复的灯看作同一盏灯。

遍历 $\textit{queries}$，判断当前查询点所在的行，列和正/反对角线是否有灯，如果有，则置 $1$，即该点在查询时是被照亮的。然后进行关闭操作，查找查询点所在的八近邻点及它本身是否有灯，如果有，将该点所在的行，列和正/反对角线的灯数目分别减一，并且将灯从网格中去掉。

**代码**

```Python [sol1-Python3]
class Solution:
    def gridIllumination(self, n: int, lamps: List[List[int]], queries: List[List[int]]) -> List[int]:
        points = set()
        row, col, diagonal, antiDiagonal = Counter(), Counter(), Counter(), Counter()
        for r, c in lamps:
            if (r, c) in points:
                continue
            points.add((r, c))
            row[r] += 1
            col[c] += 1
            diagonal[r - c] += 1
            antiDiagonal[r + c] += 1

        ans = [0] * len(queries)
        for i, (r, c) in enumerate(queries):
            if row[r] or col[c] or diagonal[r - c] or antiDiagonal[r + c]:
                ans[i] = 1
            for x in range(r - 1, r + 2):
                for y in range(c - 1, c + 2):
                    if x < 0 or y < 0 or x >= n or y >= n or (x, y) not in points:
                        continue
                    points.remove((x, y))
                    row[x] -= 1
                    col[y] -= 1
                    diagonal[x - y] -= 1
                    antiDiagonal[x + y] -= 1
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> gridIllumination(int n, vector<vector<int>> &lamps, vector<vector<int>> &queries) {
        unordered_map<int, int> row, col, diagonal, antiDiagonal;
        auto hash_p = [](const pair<int, int> &p) -> size_t {
            static hash<long long> hash_ll;
            return hash_ll(p.first + (static_cast<long long>(p.second) << 32));
        };
        unordered_set<pair<int, int>, decltype(hash_p)> points(0, hash_p);
        for (auto &lamp : lamps) {
            if (points.count({lamp[0], lamp[1]}) > 0) {
                continue;
            }
            points.insert({lamp[0], lamp[1]});
            row[lamp[0]]++;
            col[lamp[1]]++;
            diagonal[lamp[0] - lamp[1]]++;
            antiDiagonal[lamp[0] + lamp[1]]++;
        }
        vector<int> ret(queries.size());
        for (int i = 0; i < queries.size(); i++) {
            int r = queries[i][0], c = queries[i][1];
            if (row.count(r) > 0 && row[r] > 0) {
                ret[i] = 1;
            } else if (col.count(c) > 0 && col[c] > 0) {
                ret[i] = 1;
            } else if (diagonal.count(r - c) > 0 && diagonal[r - c] > 0) {
                ret[i] = 1;
            } else if (antiDiagonal.count(r + c) > 0 && antiDiagonal[r + c] > 0) {
                ret[i] = 1;
            }
            for (int x = r - 1; x <= r + 1; x++) {
                for (int y = c - 1; y <= c + 1; y++) {
                    if (x < 0 || y < 0 || x >= n || y >= n) {
                        continue;
                    }
                    auto p = points.find({x, y});
                    if (p != points.end()) {
                        points.erase(p);
                        row[x]--;
                        col[y]--;
                        diagonal[x - y]--;
                        antiDiagonal[x + y]--;
                    }
                }
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] gridIllumination(int n, int[][] lamps, int[][] queries) {
        Map<Integer, Integer> row = new HashMap<Integer, Integer>();
        Map<Integer, Integer> col = new HashMap<Integer, Integer>();
        Map<Integer, Integer> diagonal = new HashMap<Integer, Integer>();
        Map<Integer, Integer> antiDiagonal = new HashMap<Integer, Integer>();
        Set<Long> points = new HashSet<Long>();
        for (int[] lamp : lamps) {
            if (!points.add(hash(lamp[0], lamp[1]))) {
                continue;
            }
            row.put(lamp[0], row.getOrDefault(lamp[0], 0) + 1);
            col.put(lamp[1], col.getOrDefault(lamp[1], 0) + 1);
            diagonal.put(lamp[0] - lamp[1], diagonal.getOrDefault(lamp[0] - lamp[1], 0) + 1);
            antiDiagonal.put(lamp[0] + lamp[1], antiDiagonal.getOrDefault(lamp[0] + lamp[1], 0) + 1);
        }
        int[] ret = new int[queries.length];
        for (int i = 0; i < queries.length; i++) {
            int r = queries[i][0], c = queries[i][1];
            if (row.getOrDefault(r, 0) > 0) {
                ret[i] = 1;
            } else if (col.getOrDefault(c, 0) > 0) {
                ret[i] = 1;
            } else if (diagonal.getOrDefault(r - c, 0) > 0) {
                ret[i] = 1;
            } else if (antiDiagonal.getOrDefault(r + c, 0) > 0) {
                ret[i] = 1;
            }
            for (int x = r - 1; x <= r + 1; x++) {
                for (int y = c - 1; y <= c + 1; y++) {
                    if (x < 0 || y < 0 || x >= n || y >= n) {
                        continue;
                    }
                    if (points.remove(hash(x, y))) {
                        row.put(x, row.get(x) - 1);
                        if (row.get(x) == 0) {
                            row.remove(x);
                        }
                        col.put(y, col.get(y) - 1);
                        if (col.get(y) == 0) {
                            col.remove(y);
                        }
                        diagonal.put(x - y, diagonal.get(x - y) - 1);
                        if (diagonal.get(x - y) == 0) {
                            diagonal.remove(x - y);
                        }
                        antiDiagonal.put(x + y, antiDiagonal.get(x + y) - 1);
                        if (antiDiagonal.get(x + y) == 0) {
                            antiDiagonal.remove(x + y);
                        }
                    }
                }
            }
        }
        return ret;
    }

    public long hash(int x, int y) {
        return (long) x + ((long) y << 32);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] GridIllumination(int n, int[][] lamps, int[][] queries) {
        Dictionary<int, int> row = new Dictionary<int, int>();
        Dictionary<int, int> col = new Dictionary<int, int>();
        Dictionary<int, int> diagonal = new Dictionary<int, int>();
        Dictionary<int, int> antiDiagonal = new Dictionary<int, int>();
        ISet<long> points = new HashSet<long>();
        foreach (int[] lamp in lamps) {
            if (!points.Add(Hash(lamp[0], lamp[1]))) {
                continue;
            }
            if (!row.ContainsKey(lamp[0])) {
                row.Add(lamp[0], 0);
            }
            row[lamp[0]]++;
            if (!col.ContainsKey(lamp[1])) {
                col.Add(lamp[1], 0);
            }
            col[lamp[1]]++;
            if (!diagonal.ContainsKey(lamp[0] - lamp[1])) {
                diagonal.Add(lamp[0] - lamp[1], 0);
            }
            diagonal[lamp[0] - lamp[1]]++;
            if (!antiDiagonal.ContainsKey(lamp[0] + lamp[1])) {
                antiDiagonal.Add(lamp[0] + lamp[1], 0);
            }
            antiDiagonal[lamp[0] + lamp[1]]++;
        }
        int[] ret = new int[queries.Length];
        for (int i = 0; i < queries.Length; i++) {
            int r = queries[i][0], c = queries[i][1];
            if (row.ContainsKey(r) && row[r] > 0) {
                ret[i] = 1;
            } else if (col.ContainsKey(c) && col[c] > 0) {
                ret[i] = 1;
            } else if (diagonal.ContainsKey(r - c) && diagonal[r - c] > 0) {
                ret[i] = 1;
            } else if (antiDiagonal.ContainsKey(r + c) && antiDiagonal[r + c] > 0) {
                ret[i] = 1;
            }
            for (int x = r - 1; x <= r + 1; x++) {
                for (int y = c - 1; y <= c + 1; y++) {
                    if (x < 0 || y < 0 || x >= n || y >= n) {
                        continue;
                    }
                    if (points.Remove(Hash(x, y))) {
                        row[x]--;
                        if (row[x] == 0) {
                            row.Remove(x);
                        }
                        col[y]--;
                        if (col[y] == 0) {
                            col.Remove(y);
                        }
                        diagonal[x - y]--;
                        if (diagonal[x - y] == 0) {
                            diagonal.Remove(x - y);
                        }
                        antiDiagonal[x + y]--;
                        if (antiDiagonal[x + y] == 0) {
                            antiDiagonal.Remove(x + y);
                        }
                    }
                }
            }
        }
        return ret;
    }

    public long Hash(int x, int y) {
        return (long) x + ((long) y << 32);
    }
}
```

```C [sol1-C]
typedef struct {
    long long key;
    int val;
    UT_hash_handle hh;
} HashEntry;

static inline long long hash(int x, int y) {
    return (long long) x + ((long long) y << 32);
}

void hashInsert(HashEntry ** obj, long long key) {
    HashEntry * pEntry = NULL;
    HASH_FIND(hh, *obj, &key, sizeof(long long), pEntry);
    if (NULL == pEntry) {
        pEntry = (HashEntry *)malloc(sizeof(HashEntry));
        pEntry->key = key;
        pEntry->val = 1;
        HASH_ADD(hh, *obj, key, sizeof(long long), pEntry);
    } else {
        pEntry->val++;
    }
}

void hashErase(HashEntry ** obj, long long key) {
    HashEntry * pEntry = NULL;
    HASH_FIND(hh, *obj, &key, sizeof(long long), pEntry);
    if (NULL != pEntry) {
        pEntry->val -= 1;
        if (pEntry->val == 0) {
            HASH_DEL(*obj, pEntry);
            free(pEntry);
        }
    }
}

void hashDelete(HashEntry ** obj, long long key) {
    HashEntry * pEntry = NULL;
    HASH_FIND(hh, *obj, &key, sizeof(long long), pEntry);
    if (NULL != pEntry) {
        HASH_DEL(*obj, pEntry);
        free(pEntry);
    }
}

bool hashFind(HashEntry ** obj, long long key) {
    HashEntry * pEntry = NULL;
    HASH_FIND(hh, *obj, &key, sizeof(long long), pEntry);
    if (NULL == pEntry) {
        return false;
    } else {
        return true;
    }
}

void hashFreeAll(HashEntry ** obj) {
    HashEntry *curr, *next;
    HASH_ITER(hh, *obj, curr, next) {
        HASH_DEL(*obj, curr);  
        free(curr);
    }
}

int* gridIllumination(int n, int** lamps, int lampsSize, int* lampsColSize, int** queries, int queriesSize, int* queriesColSize, int* returnSize){
    HashEntry * row = NULL, * col = NULL;
    HashEntry * diagonal = NULL, * antiDiagonal = NULL;
    HashEntry * points = NULL;
    for (int i = 0; i < lampsSize; i++) {
        HashEntry * pEntry = NULL;
        long long p = hash(lamps[i][0], lamps[i][1]);
        HASH_FIND(hh, points, &p, sizeof(long long), pEntry);
        if (NULL != pEntry) {
            continue;
        }
        hashInsert(&points, p);
        hashInsert(&row, (long long)lamps[i][0]);
        hashInsert(&col, (long long)lamps[i][1]);
        hashInsert(&diagonal, (long long)(lamps[i][0] - lamps[i][1]));
        hashInsert(&antiDiagonal, (long long)(lamps[i][0] + lamps[i][1]));
    }

    int * ret = (int *)malloc(sizeof(int) * queriesSize);
    memset(ret, 0, sizeof(int) * queriesSize);
    for (int i = 0; i < queriesSize; i++) {
        int r = queries[i][0], c = queries[i][1];
        if (hashFind(&row, (long long)r)) {
            ret[i] = 1;
        } else if (hashFind(&col, (long long)c)) {
            ret[i] = 1;
        } else if (hashFind(&diagonal, (long long)(r - c))) {
            ret[i] = 1;
        } else if (hashFind(&antiDiagonal, (long long)(r + c))) {
            ret[i] = 1;
        }
        for (int x = r - 1; x <= r + 1; x++) {
            for (int y = c - 1; y <= c + 1; y++) {
                if (x < 0 || y < 0 || x >= n || y >= n) {
                    continue;
                }
                if (hashFind(&points, hash(x, y))) {
                    hashDelete(&points, hash(x, y));
                    hashErase(&row, (long long)x);
                    hashErase(&col, (long long)y);
                    hashErase(&diagonal, (long long)(x - y));
                    hashErase(&antiDiagonal, (long long)(x + y));
                }
            }
        }
    }
    hashFreeAll(&points);
    hashFreeAll(&row);
    hashFreeAll(&col);
    hashFreeAll(&diagonal);
    hashFreeAll(&antiDiagonal);
    *returnSize = queriesSize;
    return ret;
}
```

```go [sol1-Golang]
func gridIllumination(n int, lamps, queries [][]int) []int {
    type pair struct{ x, y int }
    points := map[pair]bool{}
    row := map[int]int{}
    col := map[int]int{}
    diagonal := map[int]int{}
    antiDiagonal := map[int]int{}
    for _, lamp := range lamps {
        r, c := lamp[0], lamp[1]
        p := pair{r, c}
        if points[p] {
            continue
        }
        points[p] = true
        row[r]++
        col[c]++
        diagonal[r-c]++
        antiDiagonal[r+c]++
    }

    ans := make([]int, len(queries))
    for i, query := range queries {
        r, c := query[0], query[1]
        if row[r] > 0 || col[c] > 0 || diagonal[r-c] > 0 || antiDiagonal[r+c] > 0 {
            ans[i] = 1
        }
        for x := r - 1; x <= r+1; x++ {
            for y := c - 1; y <= c+1; y++ {
                if x < 0 || y < 0 || x >= n || y >= n || !points[pair{x, y}] {
                    continue
                }
                delete(points, pair{x, y})
                row[x]--
                col[y]--
                diagonal[x-y]--
                antiDiagonal[x+y]--
            }
        }
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var gridIllumination = function(n, lamps, queries) {
    const row = new Map();
    const col = new Map();
    const diagonal = new Map();
    const antiDiagonal = new Map();
    const points = new Set();
    for (const lamp of lamps) {
        if (points.has(hash(lamp[0], lamp[1]))) {
            continue;
        }
        points.add(hash(lamp[0], lamp[1]));
        row.set(lamp[0], (row.get(lamp[0]) || 0) + 1);
        col.set(lamp[1], (col.get(lamp[1]) || 0) + 1);
        diagonal.set(lamp[0] - lamp[1], (diagonal.get(lamp[0] - lamp[1]) || 0) + 1);
        antiDiagonal.set(lamp[0] + lamp[1], (antiDiagonal.get(lamp[0] + lamp[1]) || 0) + 1);
    }
    const ret = new Array(queries.length).fill(0);
    for (const [i, [r, c]] of queries.entries()) {
        if (row.get(r) || col.get(c) || diagonal.get(r - c) || antiDiagonal.get(r + c)) {
            ret[i] = 1;
        }
        for (let x = r - 1; x < r + 2; x++) {
            for (let y = c - 1; y < c + 2; y++) {
                if (x < 0 || y < 0 || x >= n || y >= n || !points.has(hash(x, y))) {
                    continue;
                }
                points.delete(hash(x, y));
                row.set(x, row.get(x) - 1);
                col.set(y, col.get(y) - 1);
                diagonal.set(x - y, diagonal.get(x - y) - 1);
                antiDiagonal.set(x + y, antiDiagonal.get(x + y) - 1);
            }
        }
    }
    return ret;
}

const hash = (x, y) => {
    return x + ',' + y;
};
```

**复杂度分析**

* 时间复杂度：$O(l+q)$，其中 $l$ 和 $q$ 分别是 $\textit{lamps}$ 和 $\textit{queries}$ 的长度。遍历两个数组的时间复杂度分别为 $O(l)$ 和 $O(q)$。

* 空间复杂度：$O(l)$。保存 $5$ 个哈希表需要 $O(l)$ 的空间，返回值不计入空间复杂度。
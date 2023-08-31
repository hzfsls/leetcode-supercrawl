## [2013.检测正方形 中文官方题解](https://leetcode.cn/problems/detect-squares/solutions/100000/jian-ce-zheng-fang-xing-by-leetcode-solu-vwzs)
#### 方法一：哈希表

**思路**

先考虑如何实现 `int count(int[] point)`，记输入的 $\textit{point}$ 的横纵坐标分别为 $x$ 和 $y$。则形成的正方形的上下两条边中，其中一条边的纵坐标为 $y$， 我们枚举另一条边的纵坐标为 $col$，则正方形的边长 $d$ 为 $|y - col|$ 且大于 $0$。有了其中一个点的坐标 $(x, y)$ 和一条横边的纵坐标 $col$，我们可以得到正方形的四个点的坐标分别为 $(x, y)$，$(x, col)$，$(x+d, y)$，$(x+d, col)$ 或 $(x, y)$，$(x, col)$，$(x-d, y)$，$(x-d, col)$。

据此，我们可以用一个哈希表来存储 `void add(int[] point)` 函数中加入的点。先把点按照行来划分，键为行的纵坐标，值为另一个哈希表，其中键为该行中的点的横坐标，值为这样的点的个数。因为点会重复出现，所以计算正方形的个数时需要把另外三个坐标出现的次数相乘。

**代码**

```Python [sol1-Python3]
class DetectSquares:

    def __init__(self):
        self.map = defaultdict(Counter)

    def add(self, point: List[int]) -> None:
        x, y = point
        self.map[y][x] += 1

    def count(self, point: List[int]) -> int:
        res = 0
        x, y = point

        if not y in self.map:
            return 0
        yCnt = self.map[y]

        for col, colCnt in self.map.items():
            if col != y:
                # 根据对称性，这里可以不用取绝对值
                d = col - y
                res += colCnt[x] * yCnt[x + d] * colCnt[x + d]
                res += colCnt[x] * yCnt[x - d] * colCnt[x - d]
        
        return res
```

```Java [sol1-Java]
class DetectSquares {
    Map<Integer, Map<Integer, Integer>> cnt;

    public DetectSquares() {
        cnt = new HashMap<Integer, Map<Integer, Integer>>();
    }

    public void add(int[] point) {
        int x = point[0], y = point[1];
        cnt.putIfAbsent(y, new HashMap<Integer, Integer>());
        Map<Integer, Integer> yCnt = cnt.get(y);
        yCnt.put(x, yCnt.getOrDefault(x, 0) + 1);
    }

    public int count(int[] point) {
        int res = 0;
        int x = point[0], y = point[1];
        if (!cnt.containsKey(y)) {
            return 0;
        }
        Map<Integer, Integer> yCnt = cnt.get(y);
        Set<Map.Entry<Integer, Map<Integer, Integer>>> entries = cnt.entrySet();
        for (Map.Entry<Integer, Map<Integer, Integer>> entry : entries) {
            int col = entry.getKey();
            Map<Integer, Integer> colCnt = entry.getValue();
            if (col != y) {
                // 根据对称性，这里可以不用取绝对值
                int d = col - y;
                res += colCnt.getOrDefault(x, 0) * yCnt.getOrDefault(x + d, 0) * colCnt.getOrDefault(x + d, 0);
                res += colCnt.getOrDefault(x, 0) * yCnt.getOrDefault(x - d, 0) * colCnt.getOrDefault(x - d, 0);
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class DetectSquares {
    Dictionary<int, Dictionary<int, int>> cnt;

    public DetectSquares() {
        cnt = new Dictionary<int, Dictionary<int, int>>();
    }

    public void Add(int[] point) {
        int x = point[0], y = point[1];
        if (!cnt.ContainsKey(y)) {
            cnt.Add(y, new Dictionary<int, int>());
        }
        Dictionary<int, int> yCnt = cnt[y];
        if (!yCnt.ContainsKey(x)) {
            yCnt.Add(x, 0);
        }
        yCnt[x]++;
    }

    public int Count(int[] point) {
        int res = 0;
        int x = point[0], y = point[1];
        if (!cnt.ContainsKey(y)) {
            return 0;
        }
        Dictionary<int, int> yCnt = cnt[y];
        foreach(KeyValuePair<int, Dictionary<int, int>> pair in cnt) {
            int col = pair.Key;
            Dictionary<int, int> colCnt = pair.Value;
            if (col != y) {
                // 根据对称性，这里可以不用取绝对值
                int d = col - y;
                int cnt1 = colCnt.ContainsKey(x) ? colCnt[x] : 0;
                int cnt2 = colCnt.ContainsKey(x + d) ? colCnt[x + d] : 0;
                int cnt3 = colCnt.ContainsKey(x - d) ? colCnt[x - d] : 0;
                res += (colCnt.ContainsKey(x) ? colCnt[x] : 0) * (yCnt.ContainsKey(x + d) ? yCnt[x + d] : 0) * (colCnt.ContainsKey(x + d) ? colCnt[x + d] : 0);
                res += (colCnt.ContainsKey(x) ? colCnt[x] : 0) * (yCnt.ContainsKey(x - d) ? yCnt[x - d] : 0) * (colCnt.ContainsKey(x - d) ? colCnt[x - d] : 0);
            }
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class DetectSquares {
public:
    unordered_map<int, unordered_map<int, int>> cnt;
    DetectSquares() {

    }
    
    void add(vector<int> point) {
        int x = point[0], y = point[1];
        cnt[y][x]++;
    }
    
    int count(vector<int> point) {
        int res = 0;
        int x = point[0], y = point[1];
        if (!cnt.count(y)) {
            return 0;
        }
        unordered_map<int, int> & yCnt = cnt[y];
        for (auto & [col, colCnt] : cnt) {
            if (col != y) {
                // 根据对称性，这里可以不用取绝对值
                int d = col - y;
                res += (colCnt.count(x) ? colCnt[x] : 0) * (yCnt.count(x + d) ? yCnt[x + d] : 0) * 
                       (colCnt.count(x + d)? colCnt[x + d] : 0);
                res += (colCnt.count(x) ? colCnt[x] : 0) * (yCnt.count(x - d) ? yCnt[x - d] : 0) * 
                       (colCnt.count(x - d) ? colCnt[x - d] : 0);
            }
        }
        return res;
    }
};
```

```C [sol1-C]
typedef struct {
    int key; 
    int val;
    UT_hash_handle hh;         
} HashMapEntry;

typedef struct {
    int key;
    HashMapEntry * obj;
    UT_hash_handle hh;     
} HashMapDictEntry;

int hashMapGetVal(const HashMapEntry ** obj, int key) {
    HashMapEntry * pEntry = NULL;
    HASH_FIND(hh, *obj, &key, sizeof(int), pEntry);
    if (NULL == pEntry) {
        return 0;
    }
    return pEntry->val;
}

void hashMapFree(HashMapEntry ** obj) {
    HashMapEntry *curr = NULL, *next = NULL;
    HASH_ITER(hh, *obj, curr, next)
    {
        HASH_DEL(*obj, curr);  
        free(curr);      
    }
}

typedef struct {
    HashMapDictEntry * dict;
} DetectSquares;

DetectSquares* detectSquaresCreate() {
    DetectSquares * obj = (DetectSquares *)malloc(sizeof(DetectSquares));
    obj->dict = NULL;
    return obj;
}

void detectSquaresAdd(DetectSquares* obj, int* point, int pointSize) {
    int x = point[0], y = point[1];
    HashMapDictEntry * pEntry = NULL;
    HashMapEntry * pItemEntry = NULL;
    
    HASH_FIND(hh, obj->dict, &y, sizeof(int), pEntry);
    if (NULL == pEntry) {
        pItemEntry = (HashMapEntry *)malloc(sizeof(HashMapEntry));
        pItemEntry->key = x;
        pItemEntry->val = 1;
        pEntry = (HashMapDictEntry *)malloc(sizeof(HashMapDictEntry));
        pEntry->key = y;
        pEntry->obj = NULL;
        HASH_ADD(hh, pEntry->obj, key, sizeof(int), pItemEntry);
        HASH_ADD(hh, obj->dict, key, sizeof(int), pEntry);
    } else {
        HASH_FIND(hh, pEntry->obj, &x, sizeof(int), pItemEntry);
        if (NULL == pItemEntry) {
            pItemEntry = (HashMapEntry *)malloc(sizeof(HashMapEntry));
            pItemEntry->key = x;
            pItemEntry->val = 1;
            HASH_ADD(hh, pEntry->obj, key, sizeof(int), pItemEntry);
        } else {
            pItemEntry->val++;
        }
    }
}

int detectSquaresCount(DetectSquares* obj, int* point, int pointSize) {
    int res = 0;
    int x = point[0], y = point[1];
    HashMapDictEntry * pEntry = NULL;
    HashMapEntry * yCnt = NULL;
    HASH_FIND(hh, obj->dict, &y, sizeof(int), pEntry);
    if (NULL == pEntry) {
        return 0;
    }
    yCnt = pEntry->obj;
    HashMapDictEntry *curr = NULL, *next = NULL;
    HASH_ITER(hh, obj->dict, curr, next) {
        int col = curr->key;
        HashMapEntry * colCnt = curr->obj;
        if (col != y) {
            // 根据对称性，这里可以不用取绝对值
            int d = col - y;
            res += hashMapGetVal(&colCnt, x) * hashMapGetVal(&yCnt, x + d) * hashMapGetVal(&colCnt, x + d);
            res += hashMapGetVal(&colCnt, x) * hashMapGetVal(&yCnt, x - d) * hashMapGetVal(&colCnt, x - d);
        }   
    }
    return res;
}

void detectSquaresFree(DetectSquares* obj) {
    HashMapDictEntry *curr = NULL, *next = NULL;
    HASH_ITER(hh, obj->dict, curr, next)
    {
        hashMapFree(&(curr->obj));
        HASH_DEL(obj->dict, curr); 
        free(curr);      
    }
}
```

```JavaScript [sol1-JavaScript]
var DetectSquares = function() {
    this.cnt = new Map();
};

DetectSquares.prototype.add = function(point) {
    const x = point[0], y = point[1];
    if (!this.cnt.has(y)) {
        this.cnt.set(y, new Map());
    }
    const yCnt = this.cnt.get(y);
    yCnt.set(x, (yCnt.get(x) || 0) + 1);
};

DetectSquares.prototype.count = function(point) {
    let res = 0;
    let x = point[0], y = point[1];
    if (!this.cnt.has(y)) {
        return 0;
    }
    const yCnt = this.cnt.get(y);
    const entries = this.cnt.entries();
    for (const [col, colCnt] of entries) {
        if (col !== y) {
            // 根据对称性，这里可以不用取绝对值
            let d = col - y;
            res += (colCnt.get(x) || 0) * (yCnt.get(x + d) || 0) * (colCnt.get(x + d) || 0);
            res += (colCnt.get(x) || 0) * (yCnt.get(x - d) || 0) * (colCnt.get(x - d) || 0);
        }
    }
    return res;
};
```

```go [sol1-Golang]
type DetectSquares map[int]map[int]int

func Constructor() DetectSquares {
    return DetectSquares{}
}

func (s DetectSquares) Add(point []int) {
    x, y := point[0], point[1]
    if s[y] == nil {
        s[y] = map[int]int{}
    }
    s[y][x]++
}

func (s DetectSquares) Count(point []int) (ans int) {
    x, y := point[0], point[1]
    if s[y] == nil {
        return
    }
    yCnt := s[y]
    for col, colCnt := range s {
        if col != y {
            // 根据对称性，这里可以不用取绝对值
            d := col - y
            ans += colCnt[x] * yCnt[x+d] * colCnt[x+d]
            ans += colCnt[x] * yCnt[x-d] * colCnt[x-d]
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：`DetectSquares()` 消耗 $O(1)$ 时间复杂度，`void add(int[] point)` 消耗 $O(1)$ 时间复杂度，`int count(int[] point)` 消耗 $O(n)$ 时间复杂度，其中 $n$ 为 `void add(int[] point)` 已经调用的次数。

- 空间复杂度：`DetectSquares()` 消耗 $O(1)$ 空间复杂度，`void add(int[] point)` 消耗 $O(1)$ 空间复杂度，`int count(int[] point)` 消耗 $O(1)$ 空间复杂度。
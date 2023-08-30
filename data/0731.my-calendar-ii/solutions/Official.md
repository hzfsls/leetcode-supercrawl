#### 方法一：直接遍历

记录下所有已经预定的课程安排区间与已经预定过两次的课程安排区间，当我们预定新的区间 $[\textit{start}, \textit{end})$ 时，此时检查当前已经预定过两次的每个日程安排是否与新日程安排冲突。若不冲突，则可以添加新的日程安排。
+ 对于两个区间 $[s_1，e_1)$ 和 $[s_2，e_2)$，如果二者没有交集，则此时应当满足 $s_1 \ge e_2$ 或者 $s_2 \ge e_1$，这就意味着如果满足 $s_1 < e_2$ 并且 $s_2 < e_1$ 时，则两者会产生差集。
+ 首先检测新加入的区间 $[\textit{start}, \textit{end})$ 是否与已经预定过两次的区间有交集，如果没有冲突，则将新加入的区间与已经预定的区间进行检查，求出新增的预定两次的区间。对于两个区间 $[s_1，e_1)$ 和 $[s_2，e_2)$，则他们之间的交集为 $[\max(s_1,s_2), \min(e_1,e_2))$。

```Python [sol1-Python3]
class MyCalendarTwo:
    def __init__(self):
        self.booked = []
        self.overlaps = []

    def book(self, start: int, end: int) -> bool:
        if any(s < end and start < e for s, e in self.overlaps):
            return False
        for s, e in self.booked:
            if s < end and start < e:
                self.overlaps.append((max(s, start), min(e, end)))
        self.booked.append((start, end))
        return True
```

```C++ [sol1-C++]
class MyCalendarTwo {
public:
    MyCalendarTwo() {

    }

    bool book(int start, int end) {
        for (auto &[l, r] : overlaps) {
            if (l < end && start < r) {
                return false;
            }
        }
        for (auto &[l, r] : booked) {
            if (l < end && start < r) {
                overlaps.emplace_back(max(l, start), min(r, end));
            }
        }
        booked.emplace_back(start, end);
        return true;
    }
private:
    vector<pair<int, int>> booked;
    vector<pair<int, int>> overlaps;
};
```

```Java [sol1-Java]
class MyCalendarTwo {
    List<int[]> booked;
    List<int[]> overlaps;

    public MyCalendarTwo() {
        booked = new ArrayList<int[]>();
        overlaps = new ArrayList<int[]>();
    }

    public boolean book(int start, int end) {
        for (int[] arr : overlaps) {
            int l = arr[0], r = arr[1];
            if (l < end && start < r) {
                return false;
            }
        }
        for (int[] arr : booked) {
            int l = arr[0], r = arr[1];
            if (l < end && start < r) {
                overlaps.add(new int[]{Math.max(l, start), Math.min(r, end)});
            }
        }
        booked.add(new int[]{start, end});
        return true;
    }
}
```

```C# [sol1-C#]
public class MyCalendarTwo {
    List<Tuple<int, int>> booked;
    List<Tuple<int, int>> overlaps;

    public MyCalendarTwo() {
        booked = new List<Tuple<int, int>>();
        overlaps = new List<Tuple<int, int>>();
    }

    public bool Book(int start, int end) {
        foreach (Tuple<int, int> tuple in overlaps) {
            int l = tuple.Item1, r = tuple.Item2;
            if (l < end && start < r) {
                return false;
            }
        }
        foreach (Tuple<int, int> tuple in booked) {
            int l = tuple.Item1, r = tuple.Item2;
            if (l < end && start < r) {
                overlaps.Add(new Tuple<int, int>(Math.Max(l, start), Math.Min(r, end)));
            }
        }
        booked.Add(new Tuple<int, int>(start, end));
        return true;
    }
}
```

```C [sol1-C]
typedef struct {
    int *booked;
    int bookedSize;
    int *overlaps;
    int overlapsSize;
} MyCalendarTwo;

#define MAX_BOOK_SIZE 1001
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define MAX(a, b) ((a) > (b) ? (a) : (b))

MyCalendarTwo* myCalendarTwoCreate() {
    MyCalendarTwo *obj = (MyCalendarTwo *)malloc(sizeof(MyCalendarTwo));
    obj->booked = (int *)malloc(sizeof(int) * 2 * MAX_BOOK_SIZE);
    obj->overlaps = (int *)malloc(sizeof(int) * 2 * MAX_BOOK_SIZE);
    obj->bookedSize = 0;
    obj->overlapsSize = 0;
    return obj;
}

bool myCalendarTwoBook(MyCalendarTwo* obj, int start, int end) {
    for (int i = 0; i < obj->overlapsSize; i++) {
        int l = obj->overlaps[2 * i];
        int r = obj->overlaps[2 * i + 1];
        if (l < end && start < r) {
            return false;
        }
    }
    for (int i = 0; i < obj->bookedSize; i++) {
        int l = obj->booked[2 * i];
        int r = obj->booked[2 * i + 1];
        if (l < end && start < r) {
            obj->overlaps[obj->overlapsSize * 2] = MAX(l, start);
            obj->overlaps[obj->overlapsSize * 2 + 1] = MIN(r, end);
            obj->overlapsSize++;
        }
    }
    obj->booked[obj->bookedSize * 2] = start;
    obj->booked[obj->bookedSize * 2 + 1] = end;
    obj->bookedSize++;
    return true;
}

void myCalendarTwoFree(MyCalendarTwo* obj) {
    free(obj->booked);
    free(obj->overlaps);
}
```

```JavaScript [sol1-JavaScript]
var MyCalendarTwo = function() {
    this.booked = [];
    this.overlaps = [];
};

MyCalendarTwo.prototype.book = function(start, end) {
    for (const arr of this.overlaps) {
        let l = arr[0], r = arr[1];
        if (l < end && start < r) {
            return false;
        }
    }
    for (const arr of this.booked) {
        let l = arr[0], r = arr[1];
        if (l < end && start < r) {
            this.overlaps.push([Math.max(l, start), Math.min(r, end)]);
        }
    }
    this.booked.push([start, end]);
    return true;
};
```

```go [sol1-Golang]
type pair struct{ start, end int }
type MyCalendarTwo struct{ booked, overlaps []pair }

func Constructor() MyCalendarTwo {
    return MyCalendarTwo{}
}

func (c *MyCalendarTwo) Book(start, end int) bool {
    for _, p := range c.overlaps {
        if p.start < end && start < p.end {
            return false
        }
    }
    for _, p := range c.booked {
        if p.start < end && start < p.end {
            c.overlaps = append(c.overlaps, pair{max(p.start, start), min(p.end, end)})
        }
    }
    c.booked = append(c.booked, pair{start, end})
    return true
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$, 其中 $n$ 表示日程安排的数量。由于每次在进行预定时，都需要遍历所有已经预定的行程安排。

- 空间复杂度：$O(n)$，其中 $n$ 表示日程安排的数量。需要保存所有已经预定的行程。

#### 方法二：差分数组

利用差分数组的思想，每当我们预定一个新的日程安排 $[\textit{start}, \textit{end})$，在 $\textit{start}$ 计数 $\textit{cnt}[\textit{start}]$ 加 $1$，表示从 $\textit{start}$ 预定的数目加 $1$；从 $\textit{end}$ 计数 $\textit{cnt}[\textit{end}]$ 减 $1$，表示从 $\textit{end}$ 开始预定的数目减 $1$。此时以起点 $x$ 开始的预定的数目 $\textit{book}_x = \sum_{y \le x}\textit{cnt}[y]$，当我们将 $[\textit{start}, \textit{end})$ 加入后，如果发现存在区间的预定数目大于 $2$ 时，此时为非法应去除新加入的区间 $[\textit{start}, \textit{end})$。由于本题中 $\textit{start}, \textit{end}$ 数量较大，我们利用 $\texttt{TreeMap}$ 计数即可。

```Python [sol2-Python3]
from sortedcontainers import SortedDict

class MyCalendarTwo:
    def __init__(self):
        self.cnt = SortedDict()

    def book(self, start: int, end: int) -> bool:
        self.cnt[start] = self.cnt.get(start, 0) + 1
        self.cnt[end] = self.cnt.get(end, 0) - 1
        maxBook = 0
        for c in self.cnt.values():
            maxBook += c
            if maxBook > 2:
                self.cnt[start] = self.cnt.get(start, 0) - 1
                self.cnt[end] = self.cnt.get(end, 0) + 1
                return False
        return True
```

```C++ [sol2-C++]
class MyCalendarTwo {
public:
    MyCalendarTwo() {

    }

    bool book(int start, int end) {
        int ans = 0;
        int maxBook = 0;
        cnt[start]++;
        cnt[end]--;
        for (auto &[_, freq] : cnt) {
            maxBook += freq;
            ans = max(maxBook, ans);
            if (maxBook > 2) {
                cnt[start]--;
                cnt[end]++;
                return false;
            }
        }
        return true;
    }
private:
    map<int, int> cnt;
};
```

```Java [sol2-Java]
class MyCalendarTwo {
    TreeMap<Integer, Integer> cnt;

    public MyCalendarTwo() {
        cnt = new TreeMap<Integer, Integer>();
    }

    public boolean book(int start, int end) {
        int ans = 0;
        int maxBook = 0;
        cnt.put(start, cnt.getOrDefault(start, 0) + 1);
        cnt.put(end, cnt.getOrDefault(end, 0) - 1);
        for (Map.Entry<Integer, Integer> entry : cnt.entrySet()) {
            int freq = entry.getValue();
            maxBook += freq;
            ans = Math.max(maxBook, ans);
            if (maxBook > 2) {
                cnt.put(start, cnt.getOrDefault(start, 0) - 1);
                cnt.put(end, cnt.getOrDefault(end, 0) + 1);
                return false;
            }
        }
        return true;
    }
}
```

```go [sol2-Golang]
type MyCalendarTwo struct {
    *redblacktree.Tree
}

func Constructor() MyCalendarTwo {
    return MyCalendarTwo{redblacktree.NewWithIntComparator()}
}

func (c MyCalendarTwo) add(key, value int) {
    if v, ok := c.Get(key); ok {
        c.Put(key, v.(int)+value)
    } else {
        c.Put(key, value)
    }
}

func (c MyCalendarTwo) Book(start, end int) bool {
    c.add(start, 1)
    c.add(end, -1)
    maxBook := 0
    it := c.Iterator()
    for it.Next() {
        maxBook += it.Value().(int)
        if maxBook > 2 {
            c.add(start, -1)
            c.add(end, 1)
            return false
        }
    }
    return true
}
```

**复杂度分析**

+ 时间复杂度：$O(n^2)$，其中 $n$ 为日程安排的数量。每次求的最大的预定需要遍历所有的日程安排。

+ 空间复杂度：$O(n)$，其中 $n$ 为日程安排的数量。需要空间存储所有的日程安排计数，需要的空间为 $O(n)$。

#### 方法三：线段树

利用线段树，假设我们开辟了数组 $\textit{arr}[0,\cdots, 10^9]$，初始时每个元素的值都为 $0$，对于每次行程预定的区间 $[\textit{start}, \textit{end})$ ，则我们将区间中的元素 $\textit{arr}[\textit{start},\cdots,\textit{end}-1]$ 中的每个元素加 $1$，如果数组 $arr$ 的最大元素大于 $2$ 时，此时则出现某个区间被安排了 $2$ 次上，此时返回 $\texttt{false}$，同时将数组区间 $\textit{arr}[\textit{start},\cdots,\textit{end}-1]$ 进行减 $1$ 即可恢复。实际我们不必实际开辟数组 $\textit{arr}$，可采用动态线段树，懒标记 $\textit{lazy}$ 标记区间 $[l,r]$ 进行累加的次数，$\textit{tree}$ 记录区间 $[l,r]$ 的最大值，每次动态更新线段树即可。

```Python [sol3-Python3]
class MyCalendarTwo:
    def __init__(self):
        self.tree = {}

    def update(self, start: int, end: int, val: int, l: int, r: int, idx: int) -> None:
        if r < start or end < l:
            return
        if start <= l and r <= end:
            p = self.tree.get(idx, [0, 0])
            p[0] += val
            p[1] += val
            self.tree[idx] = p
            return
        mid = (l + r) // 2
        self.update(start, end, val, l, mid, 2 * idx)
        self.update(start, end, val, mid + 1, r, 2 * idx + 1)
        p = self.tree.get(idx, [0, 0])
        p[0] = p[1] + max(self.tree.get(2 * idx, (0,))[0], self.tree.get(2 * idx + 1, (0,))[0])
        self.tree[idx] = p

    def book(self, start: int, end: int) -> bool:
        self.update(start, end - 1, 1, 0, 10 ** 9, 1)
        if self.tree[1][0] > 2:
            self.update(start, end - 1, -1, 0, 10 ** 9, 1)
            return False
        return True
```

```C++ [sol3-C++]
class MyCalendarTwo {
public:
    MyCalendarTwo() {

    }

    void update(int start, int end, int val, int l, int r, int idx) {
        if (r < start || end < l) {
            return;
        } 
        if (start <= l && r <= end) {
            tree[idx].first += val;
            tree[idx].second += val;
        } else {
            int mid = (l + r) >> 1;
            update(start, end, val, l, mid, 2 * idx);
            update(start, end, val, mid + 1, r, 2 * idx + 1);
            tree[idx].first = tree[idx].second + max(tree[2 * idx].first, tree[2 * idx + 1].first);
        }
    }

    bool book(int start, int end) {            
        update(start, end - 1, 1, 0, 1e9, 1);
        if (tree[1].first > 2) {
            update(start, end - 1, -1, 0, 1e9, 1);
            return false;
        }
        return true;
    }
private:
    unordered_map<int, pair<int, int>> tree;
};
```

```Java [sol3-Java]
class MyCalendarTwo {
    Map<Integer, int[]> tree;

    public MyCalendarTwo() {
        tree = new HashMap<Integer, int[]>();
    }

    public boolean book(int start, int end) {
        update(start, end - 1, 1, 0, 1000000000, 1);
        tree.putIfAbsent(1, new int[2]);
        if (tree.get(1)[0] > 2) {
            update(start, end - 1, -1, 0, 1000000000, 1);
            return false;
        }
        return true;
    }

    public void update(int start, int end, int val, int l, int r, int idx) {
        if (r < start || end < l) {
            return;
        } 
        tree.putIfAbsent(idx, new int[2]);
        if (start <= l && r <= end) {
            tree.get(idx)[0] += val;
            tree.get(idx)[1] += val;
        } else {
            int mid = (l + r) >> 1;
            update(start, end, val, l, mid, 2 * idx);
            update(start, end, val, mid + 1, r, 2 * idx + 1);
            tree.putIfAbsent(2 * idx, new int[2]);
            tree.putIfAbsent(2 * idx + 1, new int[2]);
            tree.get(idx)[0] = tree.get(idx)[1] + Math.max(tree.get(2 * idx)[0], tree.get(2 * idx + 1)[0]);
        }
    }
}
```

```C# [sol3-C#]
public class MyCalendarTwo {
    Dictionary<int, int[]> tree;

    public MyCalendarTwo() {
        tree = new Dictionary<int, int[]>();
    }

    public bool Book(int start, int end) {
        Update(start, end - 1, 1, 0, 1000000000, 1);
        if (!tree.ContainsKey(1)) {
            tree.Add(1, new int[2]);
        }
        if (tree[1][0] > 2) {
            Update(start, end - 1, -1, 0, 1000000000, 1);
            return false;
        }
        return true;
    }

    public void Update(int start, int end, int val, int l, int r, int idx) {
        if (r < start || end < l) {
            return;
        } 
        if (!tree.ContainsKey(idx)) {
            tree.Add(idx, new int[2]);
        }
        if (start <= l && r <= end) {
            tree[idx][0] += val;
            tree[idx][1] += val;
        } else {
            int mid = (l + r) >> 1;
            Update(start, end, val, l, mid, 2 * idx);
            Update(start, end, val, mid + 1, r, 2 * idx + 1);
            if (!tree.ContainsKey(2 * idx)) {
                tree.Add(2 * idx, new int[2]);
            }
            if (!tree.ContainsKey(2 * idx + 1)) {
                tree.Add(2 * idx + 1, new int[2]);
            }
            tree[idx][0] = tree[idx][1] + Math.Max(tree[2 * idx][0], tree[2 * idx + 1][0]);
        }
    }
}
```

```C [sol3-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

typedef struct HashItem {
    int key;
    int maxBook;
    int lazy;
    UT_hash_handle hh;
} HashItem;

typedef struct {
    HashItem *tree;
} MyCalendarTwo;

MyCalendarTwo* myCalendarTwoCreate() {
    MyCalendarTwo *obj = (MyCalendarTwo *)malloc(sizeof(MyCalendarTwo));
    obj->tree = NULL;
    return obj;    
}

void update(MyCalendarTwo* obj, int start, int end, int val, int l, int r, int idx) {
    if (r < start || end < l) {
        return;
    } 
    if (start <= l && r <= end) {
        HashItem *pEntry = NULL;
        HASH_FIND_INT(obj->tree, &idx, pEntry);
        if (pEntry == NULL) {
            pEntry = (HashItem *)malloc(sizeof(HashItem));
            pEntry->key = idx;
            pEntry->maxBook = val;
            pEntry->lazy = val;
            HASH_ADD_INT(obj->tree, key, pEntry);
        } else {
            pEntry->maxBook += val;
            pEntry->lazy += val;
        }
    } else {
        int mid = (l + r) >> 1;
        update(obj, start, end, val, l, mid, 2 * idx);
        update(obj, start, end, val, mid + 1, r, 2 * idx + 1);
        int lchid = idx * 2, rchid = idx * 2 + 1;
        int lmax = 0, rmax = 0;
        HashItem *pEntry1 = NULL, *pEntry2 = NULL;
        HASH_FIND_INT(obj->tree, &lchid, pEntry1);
        HASH_FIND_INT(obj->tree, &rchid, pEntry2);
        if (pEntry1) {
            lmax = pEntry1->maxBook;
        }
        if (pEntry2) {
            rmax = pEntry2->maxBook;
        }
        HashItem *pEntry = NULL;
        HASH_FIND_INT(obj->tree, &idx, pEntry);
        if (pEntry) {
            pEntry->maxBook = pEntry->lazy + MAX(lmax, rmax);
        } else {
            pEntry = (HashItem *)malloc(sizeof(HashItem));
            pEntry->key = idx;
            pEntry->maxBook = 1;
            pEntry->lazy = 0;
            HASH_ADD_INT(obj->tree, key, pEntry);
        }
    }
}

bool myCalendarTwoBook(MyCalendarTwo* obj, int start, int end) {
    update(obj, start, end - 1, 1, 0, 1e9, 1);
    int idx = 1;
    HashItem *pEntry = NULL;
    HASH_FIND_INT(obj->tree, &idx, pEntry);
    if (pEntry->maxBook > 2) {
        update(obj, start, end - 1, -1, 0, 1e9, 1);
        return false;
    }
    return true;
}

void myCalendarTwoFree(MyCalendarTwo* obj) {
    struct HashItem *curr,*tmp;
    HASH_ITER(hh, obj->tree, curr, tmp) {
        HASH_DEL(obj->tree, curr); 
        free(curr);             
    } 
    free(obj); 
}
```

```JavaScript [sol3-JavaScript]
var MyCalendarTwo = function() {
    this.tree = new Map();
};

MyCalendarTwo.prototype.book = function(start, end) {
    const update = (start, end, val, l, r, idx) => {
        if (r < start || end < l) {
            return;
        } 
        if (!this.tree.has(idx)) {
            this.tree.set(idx, [0, 0]);
        }
        if (start <= l && r <= end) {
            this.tree.get(idx)[0] += val;
            this.tree.get(idx)[1] += val;
        } else {
            const mid = (l + r) >> 1;
            update(start, end, val, l, mid, 2 * idx);
            update(start, end, val, mid + 1, r, 2 * idx + 1);
            if (!this.tree.has(2 * idx)) {
                this.tree.set(2 * idx, [0, 0]);
            }
            if (!this.tree.has(2 * idx + 1)) {
                this.tree.set(2 * idx + 1, [0, 0]);
            }
            this.tree.get(idx)[0] = this.tree.get(idx)[1] + Math.max(this.tree.get(2 * idx)[0], this.tree.get(2 * idx + 1)[0]);
        }
    }
    update(start, end - 1, 1, 0, 1000000000, 1);
    if (!this.tree.has(1)) {
        this.tree.set(1, [0, 0])
    }
    if (this.tree.get(1)[0] > 2) {
        update(start, end - 1, -1, 0, 1000000000, 1);
        return false;
    }
    return true;
};
```

```go [sol3-Golang]
type pair struct{ first, second int }
type MyCalendarTwo map[int]pair

func Constructor() MyCalendarTwo {
    return MyCalendarTwo{}
}

func (tree MyCalendarTwo) update(start, end, val, l, r, idx int) {
    if r < start || end < l {
        return
    }
    if start <= l && r <= end {
        p := tree[idx]
        p.first += val
        p.second += val
        tree[idx] = p
        return
    }
    mid := (l + r) >> 1
    tree.update(start, end, val, l, mid, 2*idx)
    tree.update(start, end, val, mid+1, r, 2*idx+1)
    p := tree[idx]
    p.first = p.second + max(tree[2*idx].first, tree[2*idx+1].first)
    tree[idx] = p
}

func (tree MyCalendarTwo) Book(start, end int) bool {
    tree.update(start, end-1, 1, 0, 1e9, 1)
    if tree[1].first > 2 {
        tree.update(start, end-1, -1, 0, 1e9, 1)
        return false
    }
    return true
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

+ 时间复杂度：$O(n \log C)$，其中 $n$ 为日程安排的数量。由于使用了线段树查询，线段树的最大深度为 $\log C$, 每次最多会查询 $\log C$ 个节点，每次求最大的预定需的时间复杂度为 $O(\log C + \log C)$，因此时间复杂度为 $O(n \log C)$，在此 $C$ 取固定值即为 $10^9$。

+ 空间复杂度：$O(n \log C)$，其中 $n$ 为日程安排的数量。由于该解法采用的为动态线段树，线段树的最大深度为 $\log C$，每次预定最多会在线段树上增加 $\log C$ 个节点，因此空间复杂度为 $O(n \log C)$，在此 $C$ 取固定值即为 $10^9$。
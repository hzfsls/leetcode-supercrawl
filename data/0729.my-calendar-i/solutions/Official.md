## [729.我的日程安排表 I 中文官方题解](https://leetcode.cn/problems/my-calendar-i/solutions/100000/wo-de-ri-cheng-an-pai-biao-i-by-leetcode-nlxr)

#### 方法一：直接遍历

我们记录下所有已经预订的课程安排区间，当我们预订新的区间 $[\textit{start}, \textit{end})$ 时，此时检查当前已经预订的每个日程安排是否与新日程安排冲突。若不冲突，则可以添加新的日程安排。
+ 对于两个区间 $[s_1, e_1)$ 和 $[s_2, e_2)$，如果二者没有交集，则此时应当满足 $s_1 \ge e_2$ 或者 $s_2 \ge e_1$，这就意味着如果满足 $s_1 < e_2$ 并且 $s_2 < e_1$，则两者会产生交集。

```Python [sol1-Python3]
class MyCalendar:
    def __init__(self):
        self.booked = []

    def book(self, start: int, end: int) -> bool:
        if any(l < end and start < r for l, r in self.booked):
            return False
        self.booked.append((start, end))
        return True
```

```C++ [sol1-C++]
class MyCalendar {
    vector<pair<int, int>> booked;

public:
    bool book(int start, int end) {
        for (auto &[l, r] : booked) {
            if (l < end && start < r) {
                return false;
            }
        }
        booked.emplace_back(start, end);
        return true;
    }
};
```

```Java [sol1-Java]
class MyCalendar {
    List<int[]> booked;

    public MyCalendar() {
        booked = new ArrayList<int[]>();
    }

    public boolean book(int start, int end) {
        for (int[] arr : booked) {
            int l = arr[0], r = arr[1];
            if (l < end && start < r) {
                return false;
            }
        }
        booked.add(new int[]{start, end});
        return true;
    }
}
```

```C# [sol1-C#]
public class MyCalendar {
    IList<Tuple<int, int>> booked;

    public MyCalendar() {
        booked = new List<Tuple<int, int>>();
    }

    public bool Book(int start, int end) {
        foreach (Tuple<int, int> tuple in booked) {
            int l = tuple.Item1, r = tuple.Item2;
            if (l < end && start < r) {
                return false;
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
} MyCalendar;

#define MAX_BOOK_SIZE 1001

MyCalendar* myCalendarCreate() {
    MyCalendar *obj = (MyCalendar *)malloc(sizeof(MyCalendar));
    obj->booked = (int *)malloc(sizeof(int) * 2 * MAX_BOOK_SIZE);
    obj->bookedSize = 0;
    return obj;
}

bool myCalendarBook(MyCalendar* obj, int start, int end) {
    for (int i = 0; i < obj->bookedSize; i++) {
        int l = obj->booked[2 * i];
        int r = obj->booked[2 * i + 1];
        if (l < end && start < r) {
            return false;
        }
    }
    obj->booked[obj->bookedSize * 2] = start;
    obj->booked[obj->bookedSize * 2 + 1] = end;
    obj->bookedSize++;
    return true;
}

void myCalendarFree(MyCalendar* obj) {
    free(obj->booked);
    free(obj);
}
```

```JavaScript [sol1-JavaScript]
var MyCalendar = function() {
    this.booked = [];
};

MyCalendar.prototype.book = function(start, end) {
    for (const arr of this.booked) {
        let l = arr[0], r = arr[1];
        if (l < end && start < r) {
            return false;
        }
    }
    this.booked.push([start, end]);
    return true;
};
```

```go [sol1-Golang]
type pair struct{ start, end int }
type MyCalendar []pair

func Constructor() MyCalendar {
    return MyCalendar{}
}

func (c *MyCalendar) Book(start, end int) bool {
    for _, p := range *c {
        if p.start < end && start < p.end {
            return false
        }
    }
    *c = append(*c, pair{start, end})
    return true
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$, 其中 $n$ 表示日程安排的数量。由于每次在进行预订时，都需要遍历所有已经预订的行程安排。

- 空间复杂度：$O(n)$，其中 $n$ 表示日程安排的数量。需要保存所有已经预订的行程。

#### 方法二：二分查找

如果我们按时间顺序维护日程安排，则可以通过二分查找日程安排的情况来检查新日程安排是否可以预订，若可以预订则在排序结构中更新插入日程安排。
+ 需要一个数据结构能够保持元素排序和支持快速插入，可以用 $\texttt{TreeSet}$ 来构建。对于给定的区间 $[\textit{start}, \textit{end})$，我们每次查找起点大于等于 $\textit{end}$ 的第一个区间 $[l_1,r_1)$，同时紧挨着 $[l_1,r_1)$ 的前一个区间为 $[l_2,r_2)$，此时如果满足 $r_2 \le \textit{start} < \textit{end} \le l_1$，则该区间可以预订。

```Python [sol2-Python3]
from sortedcontainers import SortedDict

class MyCalendar:
    def __init__(self):
        self.booked = SortedDict()

    def book(self, start: int, end: int) -> bool:
        i = self.booked.bisect_left(end)
        if i == 0 or self.booked.items()[i - 1][1] <= start:
            self.booked[start] = end
            return True
        return False
```

```C++ [sol2-C++]
class MyCalendar {
    set<pair<int, int>> booked;

public:
    bool book(int start, int end) {
        auto it = booked.lower_bound({end, 0});
        if (it == booked.begin() || (--it)->second <= start) {
            booked.emplace(start, end);
            return true;
        }
        return false;
    }
};
```

```Java [sol2-Java]
class MyCalendar {
    TreeSet<int[]> booked;

    public MyCalendar() {
        booked = new TreeSet<int[]>((a, b) -> a[0] - b[0]);
    }

    public boolean book(int start, int end) {
        if (booked.isEmpty()) {
            booked.add(new int[]{start, end});
            return true;
        }
        int[] tmp = {end, 0};
        int[] arr = booked.ceiling(tmp);
        int[] prev = arr == null ? booked.last() : booked.lower(arr);
        if (arr == booked.first() || booked.lower(tmp)[1] <= start) {
            booked.add(new int[]{start, end});
            return true;
        }
        return false;
    }
}
```

```go [sol2-Golang]
type MyCalendar struct {
    *redblacktree.Tree
}

func Constructor() MyCalendar {
    t := redblacktree.NewWithIntComparator()
    t.Put(math.MaxInt32, nil) // 哨兵，简化代码
    return MyCalendar{t}
}

func (c MyCalendar) Book(start, end int) bool {
    node, _ := c.Ceiling(end)
    it := c.IteratorAt(node)
    if !it.Prev() || it.Value().(int) <= start {
        c.Put(start, end)
        return true
    }
    return false
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$, 其中 $n$ 表示日程安排的数量。由于每次在进行预订时，都需要进行二分查找，需要的时间为 $O(\log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 表示日程安排的数量。需要保存所有已经预订的行程。

#### 方法三：线段树

利用线段树，假设我们开辟了数组 $\textit{arr}[0,\cdots, 10^9]$，初始时每个元素的值都为 $0$，对于每次行程预订的区间 $[\textit{start}, \textit{end})$ ，则我们将区间中的元素 $\textit{arr}[\textit{start},\cdots,\textit{end}-1]$ 中的每个元素都标记为 $1$，每次调用 $\texttt{book}$ 时，我们只需要检测 $\textit{arr}[\textit{start},\cdots,\textit{end}-1]$ 区间内是否有元素被标记为 $1$。实际我们不必实际开辟数组 $\textit{arr}$，可采用动态线段树，懒标记 $\textit{lazy}$ 标记区间 $[l,r]$ 已经被预订，$\textit{tree}$ 记录区间 $[l,r]$ 的是否存在标记为 $1$ 的元素。

+ 每次进行 $\texttt{book}$ 操作时，首先判断区间 $[\textit{start},\cdots,\textit{end}-1]$ 是否存在元素被标记，如果存在被标记为 $1$ 的元素，则表明该区间不可预订；否则，则将可以预订。预订完成后，将 $\textit{arr}[\textit{start},\cdots,\textit{end}-1]$ 进行标记为 $1$，并同时更新线段树。

```Python [sol3-Python3]
class MyCalendar:
    def __init__(self):
        self.tree = set()
        self.lazy = set()

    def query(self, start: int, end: int, l: int, r: int, idx: int) -> bool:
        if r < start or end < l:
            return False
        if idx in self.lazy:  # 如果该区间已被预订，则直接返回
            return True
        if start <= l and r <= end:
            return idx in self.tree
        mid = (l + r) // 2
        return self.query(start, end, l, mid, 2 * idx) or \
               self.query(start, end, mid + 1, r, 2 * idx + 1)

    def update(self, start: int, end: int, l: int, r: int, idx: int) -> None:
        if r < start or end < l:
            return
        if start <= l and r <= end:
            self.tree.add(idx)
            self.lazy.add(idx)
        else:
            mid = (l + r) // 2
            self.update(start, end, l, mid, 2 * idx)
            self.update(start, end, mid + 1, r, 2 * idx + 1)
            self.tree.add(idx)
            if 2 * idx in self.lazy and 2 * idx + 1 in self.lazy:
                self.lazy.add(idx)

    def book(self, start: int, end: int) -> bool:
        if self.query(start, end - 1, 0, 10 ** 9, 1):
            return False
        self.update(start, end - 1, 0, 10 ** 9, 1)
        return True
```

```C++ [sol3-C++]
class MyCalendar {
    unordered_set<int> tree, lazy;

public:
    bool query(int start, int end, int l, int r, int idx) {
        if (r < start || end < l) {
            return false;
        }
        /* 如果该区间已被预订，则直接返回 */
        if (lazy.count(idx)) {
            return true;
        }
        if (start <= l && r <= end) {
            return tree.count(idx);
        }
        int mid = (l + r) >> 1;
        return query(start, end, l, mid, 2 * idx) ||
               query(start, end, mid + 1, r, 2 * idx + 1);
    }

    void update(int start, int end, int l, int r, int idx) {
        if (r < start || end < l) {
            return;
        }
        if (start <= l && r <= end) {
            tree.emplace(idx);
            lazy.emplace(idx);
        } else {
            int mid = (l + r) >> 1;
            update(start, end, l, mid, 2 * idx);
            update(start, end, mid + 1, r, 2 * idx + 1);
            tree.emplace(idx);
            if (lazy.count(2 * idx) && lazy.count(2 * idx + 1)) {
                lazy.emplace(idx);
            }
        }
    }

    bool book(int start, int end) {
        if (query(start, end - 1, 0, 1e9, 1)) {
            return false;
        }
        update(start, end - 1, 0, 1e9, 1);
        return true;
    }
};
```

```Java [sol3-Java]
class MyCalendar {
    Set<Integer> tree;
    Set<Integer> lazy;

    public MyCalendar() {
        tree = new HashSet<Integer>();
        lazy = new HashSet<Integer>();
    }

    public boolean book(int start, int end) {
        if (query(start, end - 1, 0, 1000000000, 1)) {
            return false;
        }
        update(start, end - 1, 0, 1000000000, 1);
        return true;
    }

    public boolean query(int start, int end, int l, int r, int idx) {
        if (start > r || end < l) {
            return false;
        }
        /* 如果该区间已被预订，则直接返回 */
        if (lazy.contains(idx)) {
            return true;
        }
        if (start <= l && r <= end) {
            return tree.contains(idx);
        } else {
            int mid = (l + r) >> 1;
            if (end <= mid) {
                return query(start, end, l, mid, 2 * idx);
            } else if (start > mid) {
                return query(start, end, mid + 1, r, 2 * idx + 1);
            } else {
                return query(start, end, l, mid, 2 * idx) | query(start, end, mid + 1, r, 2 * idx + 1);
            }
        }
    }

    public void update(int start, int end, int l, int r, int idx) {
        if (r < start || end < l) {
            return;
        } 
        if (start <= l && r <= end) {
            tree.add(idx);
            lazy.add(idx);
        } else {
            int mid = (l + r) >> 1;
            update(start, end, l, mid, 2 * idx);
            update(start, end, mid + 1, r, 2 * idx + 1);
            tree.add(idx);
        }
    }
}
```

```C# [sol3-C#]
public class MyCalendar {
    ISet<int> tree;
    ISet<int> lazy;

    public MyCalendar() {
        tree = new HashSet<int>();
        lazy = new HashSet<int>();
    }

    public bool Book(int start, int end) {
        if (Query(start, end - 1, 0, 1000000000, 1)) {
            return false;
        }
        Update(start, end - 1, 0, 1000000000, 1);
        return true;
    }

    public bool Query(int start, int end, int l, int r, int idx) {
        if (start > r || end < l) {
            return false;
        }
        /* 如果该区间已被预订，则直接返回 */
        if (lazy.Contains(idx)) {
            return true;
        }
        if (start <= l && r <= end) {
            return tree.Contains(idx);
        } else {
            int mid = (l + r) >> 1;
            if (end <= mid) {
                return Query(start, end, l, mid, 2 * idx);
            } else if (start > mid) {
                return Query(start, end, mid + 1, r, 2 * idx + 1);
            } else {
                return Query(start, end, l, mid, 2 * idx) | Query(start, end, mid + 1, r, 2 * idx + 1);
            }
        }
    }

    public void Update(int start, int end, int l, int r, int idx) {
        if (r < start || end < l) {
            return;
        } 
        if (start <= l && r <= end) {
            tree.Add(idx);
            lazy.Add(idx);
        } else {
            int mid = (l + r) >> 1;
            Update(start, end, l, mid, 2 * idx);
            Update(start, end, mid + 1, r, 2 * idx + 1);
            tree.Add(idx);
        }
    }
}
```

```C [sol3-C]
typedef struct HashItem {
    int key;
    bool hasBooked;
    bool lazy;
    UT_hash_handle hh;
} HashItem;

typedef struct {
    HashItem *tree;
} MyCalendar;

MyCalendar* myCalendarCreate() {
    MyCalendar *obj = (MyCalendar *)malloc(sizeof(MyCalendar));
    obj->tree = NULL;
    return obj;
}

bool query(MyCalendar* obj, int start, int end, int l, int r, int idx) {
    if (r < start || end < l) {
        return false;
    } 
    HashItem *pEntry = NULL;
    HASH_FIND_INT(obj->tree, &idx, pEntry);
    /* 如果该区间已被预订，则直接返回 */
    if (pEntry && pEntry->lazy) {
        return true;
    }
    if (start <= l && r <= end) {
        if (pEntry) {
            return pEntry->hasBooked;
        } else {
            return false;
        }
    } else {
        int mid = (l + r) >> 1;
        if (end <= mid) {
            return query(obj, start, end, l, mid, 2 * idx);
        } else if (start > mid) {
            return query(obj, start, end, mid + 1, r, 2 * idx + 1);
        } else {
            return query(obj, start, end, l, mid, 2 * idx) | \
                   query(obj, start, end, mid + 1, r, 2 * idx + 1);
        }
    }
}

void update(MyCalendar* obj, int start, int end, int l, int r, int idx) {
    if (r < start || end < l) {
        return;
    } 
    if (start <= l && r <= end) {
        HashItem *pEntry = NULL;
        HASH_FIND_INT(obj->tree, &idx, pEntry);
        if (!pEntry) {
            pEntry = (HashItem *)malloc(sizeof(HashItem));
            pEntry->key = idx;
            HASH_ADD_INT(obj->tree, key, pEntry);
        }
        pEntry->hasBooked = true;
        pEntry->lazy = true;
    } else {
        int mid = (l + r) >> 1;
        update(obj, start, end, l, mid, 2 * idx);
        update(obj, start, end, mid + 1, r, 2 * idx + 1);
        HashItem *pEntry = NULL;
        HASH_FIND_INT(obj->tree, &idx, pEntry);
        if (!pEntry) {
            pEntry = (HashItem *)malloc(sizeof(HashItem));
            pEntry->key = idx;
            HASH_ADD_INT(obj->tree, key, pEntry);
        }   
        pEntry->hasBooked = true;
        pEntry->lazy = false;
        HashItem *pEntry1 = NULL, *pEntry2 = NULL;
        int lchild = 2 * idx, rchild = 2 * idx + 1;
        HASH_FIND_INT(obj->tree, &lchild, pEntry1);
        HASH_FIND_INT(obj->tree, &rchild, pEntry2);
        if (pEntry1 && pEntry1->lazy && pEntry2 && pEntry2->lazy) {
            pEntry->lazy = true;
        }
    }
}

bool myCalendarBook(MyCalendar* obj, int start, int end) {
    if (query(obj, start, end - 1, 0, 1e9, 1)) {
        return false;
    }
    update(obj, start, end - 1, 0, 1e9, 1);
    return true;
}

void myCalendarFree(MyCalendar* obj) {
    struct HashItem *curr, *tmp;
    HASH_ITER(hh, obj->tree, curr, tmp) {
        HASH_DEL(obj->tree, curr); 
        free(curr);             
    } 
    free(obj);
}
```

```go [sol3-Golang]
type MyCalendar struct {
    tree, lazy map[int]bool
}

func Constructor() MyCalendar {
    return MyCalendar{map[int]bool{}, map[int]bool{}}
}

func (c MyCalendar) query(start, end, l, r, idx int) bool {
    if r < start || end < l {
        return false
    }
    if c.lazy[idx] { // 如果该区间已被预订，则直接返回
        return true
    }
    if start <= l && r <= end {
        return c.tree[idx]
    }
    mid := (l + r) >> 1
    return c.query(start, end, l, mid, 2*idx) ||
        c.query(start, end, mid+1, r, 2*idx+1)
}

func (c MyCalendar) update(start, end, l, r, idx int) {
    if r < start || end < l {
        return
    }
    if start <= l && r <= end {
        c.tree[idx] = true
        c.lazy[idx] = true
    } else {
        mid := (l + r) >> 1
        c.update(start, end, l, mid, 2*idx)
        c.update(start, end, mid+1, r, 2*idx+1)
        c.tree[idx] = true
        if c.lazy[2*idx] && c.lazy[2*idx+1] {
            c.lazy[idx] = true
        }
    }
}

func (c MyCalendar) Book(start, end int) bool {
    if c.query(start, end-1, 0, 1e9, 1) {
        return false
    }
    c.update(start, end-1, 0, 1e9, 1)
    return true
}
```

```JavaScript [sol3-JavaScript]
var MyCalendar = function() {
    this.tree = new Set();
    this.lazy = new Set();
};

MyCalendar.prototype.book = function(start, end) {
    if (this.query(start, end - 1, 0, 1000000000, 1)) {
        return false;
    }
    this.update(start, end - 1, 0, 1000000000, 1);
    return true;
};

MyCalendar.prototype.query = function(start, end, l, r, idx) {
    if (start > r || end < l) {
        return false;
    }
    /* 如果该区间已被预订，则直接返回 */
    if (this.lazy.has(idx)) {
        return true;
    }
    if (start <= l && r <= end) {
        return this.tree.has(idx);
    } else {
        const mid = (l + r) >> 1;
        if (end <= mid) {
            return this.query(start, end, l, mid, 2 * idx);
        } else if (start > mid) {
            return this.query(start, end, mid + 1, r, 2 * idx + 1);
        } else {
            return this.query(start, end, l, mid, 2 * idx) | this.query(start, end, mid + 1, r, 2 * idx + 1);
        }
    }
}

MyCalendar.prototype.update = function(start, end, l, r, idx) {
    if (r < start || end < l) {
        return;
    } 
    if (start <= l && r <= end) {
        this.tree.add(idx);
        this.lazy.add(idx);
    } else {
        const mid = (l + r) >> 1;
        this.update(start, end, l, mid, 2 * idx);
        this.update(start, end, mid + 1, r, 2 * idx + 1);
        this.tree.add(idx);
    }
}
```

**复杂度分析**

+ 时间复杂度：$O(n \log C)$，其中 $n$ 为日程安排的数量。由于使用了线段树查询，线段树的最大深度为 $\log C$，每次最多会查询 $\log C$ 个节点，每次求最大的预订需的时间复杂度为 $O(\log C + \log C)$，因此时间复杂度为 $O(n \log C)$，在此 $C$ 取固定值 $10^9$。

+ 空间复杂度：$O(n \log C)$，其中 $n$ 为日程安排的数量。由于该解法采用的为动态线段树，线段树的最大深度为 $\log C$，每次预订最多会在线段树上增加 $\log C$ 个节点，因此空间复杂度为 $O(n \log C)$，在此 $C$ 取固定值 $10^9$。
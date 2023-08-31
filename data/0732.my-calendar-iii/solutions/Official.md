## [732.我的日程安排表 III 中文官方题解](https://leetcode.cn/problems/my-calendar-iii/solutions/100000/wo-de-ri-cheng-an-pai-biao-iii-by-leetco-9rif)

#### 方法一：差分数组

**思路与算法**

可以参考「[731. 我的日程安排表 II](https://leetcode.cn/problems/my-calendar-ii/)」的解法二，我们可以采用同样的思路即可。利用差分数组的思想，每当我们预定一个新的日程安排 $[\textit{start}, \textit{end})$，在 $\textit{start}$ 计数 $\textit{cnt}[\textit{start}]$ 加 $1$，表示从 $\textit{start}$ 预定的数目加 $1$；从 $\textit{end}$ 计数 $\textit{cnt}[\textit{end}]$ 减 $1$，表示从 $\textit{end}$ 开始预定的数目减 $1$。此时以起点 $x$ 开始的预定的数目 $\textit{book}_x = \sum_{y \le x}\textit{cnt}[y]$，我们对计数进行累加依次求出最大的预定数目即可。由于本题中 $\textit{start}, \textit{end}$ 数量较大，我们利用 $\texttt{TreeMap}$ 计数即可。

**代码**

```Python [sol1-Python3]
from sortedcontainers import SortedDict

class MyCalendarThree:
    def __init__(self):
        self.d = SortedDict()

    def book(self, start: int, end: int) -> int:
        self.d[start] = self.d.setdefault(start, 0) + 1
        self.d[end] = self.d.setdefault(end, 0) - 1

        ans = maxBook = 0
        for freq in self.d.values():
            maxBook += freq
            ans = max(ans, maxBook)
        return ans
```

```Java [sol1-Java]
class MyCalendarThree {
    private TreeMap<Integer, Integer> cnt;

    public MyCalendarThree() {
        cnt = new TreeMap<Integer, Integer>();
    }
    
    public int book(int start, int end) {
        int ans = 0;
        int maxBook = 0;
        cnt.put(start, cnt.getOrDefault(start, 0) + 1);
        cnt.put(end, cnt.getOrDefault(end, 0) - 1);
        for (Map.Entry<Integer, Integer> entry : cnt.entrySet()) {
            int freq = entry.getValue();
            maxBook += freq;
            ans = Math.max(maxBook, ans);
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class MyCalendarThree {
public:
    MyCalendarThree() {
        
    }
    
    int book(int start, int end) {
        int ans = 0;
        int maxBook = 0;
        cnt[start]++;
        cnt[end]--;
        for (auto &[_, freq] : cnt) {
            maxBook += freq;
            ans = max(maxBook, ans);
        }
        return ans;
    }
private:
    map<int, int> cnt;
};
```

```go [sol1-Golang]
type MyCalendarThree struct {
    *redblacktree.Tree
}

func Constructor() MyCalendarThree {
    return MyCalendarThree{redblacktree.NewWithIntComparator()}
}

func (t MyCalendarThree) add(x, delta int) {
    if val, ok := t.Get(x); ok {
        delta += val.(int)
    }
    t.Put(x, delta)
}

func (t MyCalendarThree) Book(start, end int) (ans int) {
    t.add(start, 1)
    t.add(end, -1)

    maxBook := 0
    for it := t.Iterator(); it.Next(); {
        maxBook += it.Value().(int)
        if maxBook > ans {
            ans = maxBook
        }
    }
    return
}
```

**复杂度分析**

+ 时间复杂度：$O(n^2)$，其中 $n$ 为日程安排的数量。每次求的最大的预定需要遍历所有的日程安排。

+ 空间复杂度：$O(n)$，其中 $n$ 为日程安排的数量。需要空间存储所有的日程安排计数，需要的空间为 $O(n)$。

#### 方法二：线段树

**思路与算法**

利用线段树，假设我们开辟了数组 $\textit{arr}[0,\cdots, 10^9]$，初始时每个元素的值都为 $0$，对于每次行程预定的区间 $[\textit{start}, \textit{end})$ ，则我们将区间中的元素 $\textit{arr}[\textit{start},\cdots,\textit{end}-1]$ 中的每个元素加 $1$，最终只需要求出数组 $arr$ 的最大元素即可。实际我们不必实际开辟数组 $\textit{arr}$，可采用动态线段树，懒标记 $\textit{lazy}$ 标记区间 $[l,r]$ 进行累加的次数，$\textit{tree}$ 记录区间 $[l,r]$ 的最大值，最终返回区间 $[0,10^9]$ 中的最大元素即可。

**代码**

```Python [sol2-Python3]
class MyCalendarThree:
    def __init__(self):
        self.tree = defaultdict(int)
        self.lazy = defaultdict(int)

    def update(self, start: int, end: int, l: int, r: int, idx: int):
        if r < start or end < l:
            return
        if start <= l and r <= end:
            self.tree[idx] += 1
            self.lazy[idx] += 1
        else:
            mid = (l + r) // 2
            self.update(start, end, l, mid, idx * 2)
            self.update(start, end, mid + 1, r, idx * 2 + 1)
            self.tree[idx] = self.lazy[idx] + max(self.tree[idx * 2], self.tree[idx * 2 + 1])

    def book(self, start: int, end: int) -> int:
        self.update(start, end - 1, 0, 10 ** 9, 1)
        return self.tree[1]
```

```Java [sol2-Java]
class MyCalendarThree {
    private Map<Integer, Integer> tree;
    private Map<Integer, Integer> lazy;

    public MyCalendarThree() {
        tree = new HashMap<Integer, Integer>();
        lazy = new HashMap<Integer, Integer>();
    }
    
    public int book(int start, int end) {
        update(start, end - 1, 0, 1000000000, 1);
        return tree.getOrDefault(1, 0);
    }

    public void update(int start, int end, int l, int r, int idx) {
        if (r < start || end < l) {
            return;
        } 
        if (start <= l && r <= end) {
            tree.put(idx, tree.getOrDefault(idx, 0) + 1);
            lazy.put(idx, lazy.getOrDefault(idx, 0) + 1);
        } else {
            int mid = (l + r) >> 1;
            update(start, end, l, mid, 2 * idx);
            update(start, end, mid + 1, r, 2 * idx + 1);
            tree.put(idx, lazy.getOrDefault(idx, 0) + Math.max(tree.getOrDefault(2 * idx, 0), tree.getOrDefault(2 * idx + 1, 0)));
        }
    }
}
```

```C++ [sol2-C++]
class MyCalendarThree {
public:
    unordered_map<int, pair<int, int>> tree;

    MyCalendarThree() {

    }
    
    void update(int start, int end, int l, int r, int idx) {
        if (r < start || end < l) {
            return;
        } 
        if (start <= l && r <= end) {
            tree[idx].first++;
            tree[idx].second++;
        } else {
            int mid = (l + r) >> 1;
            update(start, end, l, mid, 2 * idx);
            update(start, end, mid + 1, r, 2 * idx + 1);
            tree[idx].first = tree[idx].second + max(tree[2 * idx].first, tree[2 * idx + 1].first);
        }
    }

    int book(int start, int end) {            
        update(start, end - 1, 0, 1e9, 1);
        return tree[1].first;
    }
};
```

```C# [sol2-C#]
public class MyCalendarThree {
    private Dictionary<int, int[]> tree;

    public MyCalendarThree() {
        tree = new Dictionary<int, int[]>();
    }
    
    public int Book(int start, int end) {
        Update(start, end - 1, 0, 1000000000, 1);
        return tree[1][0];
    }

    public void Update(int start, int end, int l, int r, int idx) {
        if (r < start || end < l) {
            return;
        } 
        if (start <= l && r <= end) {
            if (!tree.ContainsKey(idx)) {
                tree.Add(idx, new int[2]);
            }
            tree[idx][0]++;
            tree[idx][1]++;
        } else {
            int mid = (l + r) >> 1;
            Update(start, end, l, mid, 2 * idx);
            Update(start, end, mid + 1, r, 2 * idx + 1);
            if (!tree.ContainsKey(idx)) {
                tree.Add(idx, new int[2]);
            }
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

```C [sol2-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

typedef struct HashItem {
    int key;
    int maxBook;
    int lazy;
    UT_hash_handle hh;
} HashItem;

typedef struct {
    HashItem *tree;
} MyCalendarThree;


MyCalendarThree* myCalendarThreeCreate() {
    MyCalendarThree *obj = (MyCalendarThree *)malloc(sizeof(MyCalendarThree));
    obj->tree = NULL;
    return obj;
}

void update(MyCalendarThree* obj, int start, int end, int l, int r, int idx) {
    if (r < start || end < l) {
        return;
    } 
    if (start <= l && r <= end) {
        HashItem *pEntry = NULL;
        HASH_FIND_INT(obj->tree, &idx, pEntry);
        if (pEntry == NULL) {
            pEntry = (HashItem *)malloc(sizeof(HashItem));
            pEntry->key = idx;
            pEntry->maxBook = 1;
            pEntry->lazy = 1;
            HASH_ADD_INT(obj->tree, key, pEntry);
        } else {
            pEntry->maxBook++;
            pEntry->lazy++;
        }
    } else {
        int mid = (l + r) >> 1;
        update(obj, start, end, l, mid, 2 * idx);
        update(obj, start, end, mid + 1, r, 2 * idx + 1);
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

int myCalendarThreeBook(MyCalendarThree* obj, int start, int end) {
    update(obj, start, end - 1, 0, 1e9, 1);
    int idx = 1;
    HashItem *pEntry = NULL;
    HASH_FIND_INT(obj->tree, &idx, pEntry);
    if (pEntry) {
        return pEntry->maxBook;
    }
    return 0;
}

void myCalendarThreeFree(MyCalendarThree* obj) {
    struct HashItem *curr,*tmp;
    HASH_ITER(hh, obj->tree, curr, tmp) {
        HASH_DEL(obj->tree, curr); 
        free(curr);             
    } 
    free(obj); 
}
```

```go [sol2-Golang]
type pair struct{ num, lazy int }

type MyCalendarThree map[int]pair

func Constructor() MyCalendarThree {
    return MyCalendarThree{}
}

func (t MyCalendarThree) update(start, end, l, r, idx int) {
    if r < start || end < l {
        return
    }
    if start <= l && r <= end {
        p := t[idx]
        p.num++
        p.lazy++
        t[idx] = p
    } else {
        mid := (l + r) / 2
        t.update(start, end, l, mid, idx*2)
        t.update(start, end, mid+1, r, idx*2+1)
        p := t[idx]
        p.num = p.lazy + max(t[idx*2].num, t[idx*2+1].num)
        t[idx] = p
    }
}

func (t MyCalendarThree) Book(start, end int) int {
    t.update(start, end-1, 0, 1e9, 1)
    return t[1].num
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

```JavaScript [sol2-JavaScript]
var MyCalendarThree = function() {
    this.tree = new Map();
    this.lazy = new Map();
};

MyCalendarThree.prototype.book = function(start, end) {
    this.update(start, end - 1, 0, 1000000000, 1);
    return this.tree.get(1) || 0;
};

MyCalendarThree.prototype.update = function(start, end, l, r, idx) {
    if (r < start || end < l) {
        return;
    } 
    if (start <= l && r <= end) {
        this.tree.set(idx, (this.tree.get(idx) || 0) + 1);
        this.lazy.set(idx, (this.lazy.get(idx) || 0) + 1);
    } else {
        const mid = (l + r) >> 1;
        this.update(start, end, l, mid, 2 * idx);
        this.update(start, end, mid + 1, r, 2 * idx + 1);
        this.tree.set(idx, (this.lazy.get(idx) || 0) + Math.max((this.tree.get(2 * idx) || 0), (this.tree.get(2 * idx + 1) || 0)));
    }
}
```

**复杂度分析**

+ 时间复杂度：$O(n \log C)$，其中 $n$ 为日程安排的数量。由于使用了线段树查询，线段树的最大深度为 $\log C$，每次最多会查询 $\log C$ 个节点，每次求最大的预定需的时间复杂度为 $O(\log C + \log C)$，因此时间复杂度为 $O(n \log C)$，在此 $C$ 取固定值即为 $10^9$。

+ 空间复杂度：$O(n \log C)$，其中 $n$ 为日程安排的数量。由于该解法采用的为动态线段树，线段树的最大深度为 $\log C$，每次预定最多会在线段树上增加 $\log C$ 个节点，因此空间复杂度为 $O(n \log C)$，在此 $C$ 取固定值即为 $10^9$。
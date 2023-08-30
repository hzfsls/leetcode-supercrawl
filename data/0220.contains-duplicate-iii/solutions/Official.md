#### 方法一：滑动窗口 + 有序集合

**思路及算法**

对于序列中每一个元素 $x$ 左侧的至多 $k$ 个元素，如果这 $k$ 个元素中存在一个元素落在区间 $[x - t, x + t]$ 中，我们就找到了一对符合条件的元素。注意到对于两个相邻的元素，它们各自的左侧的 $k$ 个元素中有 $k - 1$ 个是重合的。于是我们可以使用滑动窗口的思路，维护一个大小为 $k$ 的滑动窗口，每次遍历到元素 $x$ 时，滑动窗口中包含元素 $x$ 前面的最多 $k$ 个元素，我们检查窗口中是否存在元素落在区间 $[x - t, x + t]$ 中即可。

如果使用队列维护滑动窗口内的元素，由于元素是无序的，我们只能对于每个元素都遍历一次队列来检查是否有元素符合条件。如果数组的长度为 $n$，则使用队列的时间复杂度为 $O(nk)$，会超出时间限制。

因此我们希望能够找到一个数据结构维护滑动窗口内的元素，该数据结构需要满足以下操作：

- 支持添加和删除指定元素的操作，否则我们无法维护滑动窗口；

- 内部元素有序，支持二分查找的操作，这样我们可以快速判断滑动窗口中是否存在元素满足条件，具体而言，对于元素 $x$，当我们希望判断滑动窗口中是否存在某个数 $y$ 落在区间 $[x - t, x + t]$ 中，只需要判断滑动窗口中所有大于等于 $x - t$ 的元素中的最小元素是否小于等于 $x + t$ 即可。

我们可以使用有序集合来支持这些操作。

实现方面，我们在有序集合中查找大于等于 $x - t$ 的最小的元素 $y$，如果 $y$ 存在，且 $y \leq x + t$，我们就找到了一对符合条件的元素。完成检查后，我们将 $x$ 插入到有序集合中，如果有序集合中元素数量超过了 $k$，我们将有序集合中最早被插入的元素删除即可。

**注意**

如果当前有序集合中存在相同元素，那么此时程序将直接返回 $\texttt{true}$。因此本题中的有序集合无需处理相同元素的情况。

为防止整型 $\texttt{int}$ 溢出，我们既可以使用长整型 $\texttt{long}$，也可以对查找区间 $[x - t, x + t]$ 进行限制，使其落在 $\texttt{int}$ 范围内。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool containsNearbyAlmostDuplicate(vector<int>& nums, int k, int t) {
        int n = nums.size();
        set<int> rec;
        for (int i = 0; i < n; i++) {
            auto iter = rec.lower_bound(max(nums[i], INT_MIN + t) - t);
            if (iter != rec.end() && *iter <= min(nums[i], INT_MAX - t) + t) {
                return true;
            }
            rec.insert(nums[i]);
            if (i >= k) {
                rec.erase(nums[i - k]);
            }
        }
        return false;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean containsNearbyAlmostDuplicate(int[] nums, int k, int t) {
        int n = nums.length;
        TreeSet<Long> set = new TreeSet<Long>();
        for (int i = 0; i < n; i++) {
            Long ceiling = set.ceiling((long) nums[i] - (long) t);
            if (ceiling != null && ceiling <= (long) nums[i] + (long) t) {
                return true;
            }
            set.add((long) nums[i]);
            if (i >= k) {
                set.remove((long) nums[i - k]);
            }
        }
        return false;
    }
}
```

```go [sol1-Golang]
import "math/rand"

type node struct {
    ch       [2]*node
    priority int
    val      int
}

func (o *node) cmp(b int) int {
    switch {
    case b < o.val:
        return 0
    case b > o.val:
        return 1
    default:
        return -1
    }
}

func (o *node) rotate(d int) *node {
    x := o.ch[d^1]
    o.ch[d^1] = x.ch[d]
    x.ch[d] = o
    return x
}

type treap struct {
    root *node
}

func (t *treap) _put(o *node, val int) *node {
    if o == nil {
        return &node{priority: rand.Int(), val: val}
    }
    d := o.cmp(val)
    o.ch[d] = t._put(o.ch[d], val)
    if o.ch[d].priority > o.priority {
        o = o.rotate(d ^ 1)
    }
    return o
}

func (t *treap) put(val int) {
    t.root = t._put(t.root, val)
}

func (t *treap) _delete(o *node, val int) *node {
    if d := o.cmp(val); d >= 0 {
        o.ch[d] = t._delete(o.ch[d], val)
        return o
    }
    if o.ch[1] == nil {
        return o.ch[0]
    }
    if o.ch[0] == nil {
        return o.ch[1]
    }
    d := 0
    if o.ch[0].priority > o.ch[1].priority {
        d = 1
    }
    o = o.rotate(d)
    o.ch[d] = t._delete(o.ch[d], val)
    return o
}

func (t *treap) delete(val int) {
    t.root = t._delete(t.root, val)
}

func (t *treap) lowerBound(val int) (lb *node) {
    for o := t.root; o != nil; {
        switch c := o.cmp(val); {
        case c == 0:
            lb = o
            o = o.ch[0]
        case c > 0:
            o = o.ch[1]
        default:
            return o
        }
    }
    return
}

func containsNearbyAlmostDuplicate(nums []int, k, t int) bool {
    set := &treap{}
    for i, v := range nums {
        if lb := set.lowerBound(v - t); lb != nil && lb.val <= v+t {
            return true
        }
        set.put(v)
        if i >= k {
            set.delete(nums[i-k])
        }
    }
    return false
}
```

**复杂度分析**

- 时间复杂度：$O(n \log(\min(n, k)))$，其中 $n$ 是给定数组的长度。每个元素至多被插入有序集合和从有序集合中删除一次，每次操作时间复杂度均为 $O(\log(\min(n, k))$。

- 空间复杂度：$O(\min(n, k))$，其中 $n$ 是给定数组的长度。有序集合中至多包含 $\min(n, k + 1)$ 个元素。

#### 方法二：桶

**思路及算法**

我们也可以使用利用桶排序的思想解决本题。我们按照元素的大小进行分桶，维护一个滑动窗口内的元素对应的元素。

对于元素 $x$，其影响的区间为 $[x - t, x + t]$。于是我们可以设定桶的大小为 $t + 1$。如果两个元素同属一个桶，那么这两个元素必然符合条件。如果两个元素属于相邻桶，那么我们需要校验这两个元素是否差值不超过 $t$。如果两个元素既不属于同一个桶，也不属于相邻桶，那么这两个元素必然不符合条件。

具体地，我们遍历该序列，假设当前遍历到元素 $x$，那么我们首先检查 $x$ 所属于的桶是否已经存在元素，如果存在，那么我们就找到了一对符合条件的元素，否则我们继续检查两个相邻的桶内是否存在符合条件的元素。

实现方面，我们将 $\texttt{int}$ 范围内的每一个整数 $x$ 表示为 $x = (t + 1) \times a + b(0 \leq b \leq t)$ 的形式，这样 $x$ 即归属于编号为 $a$ 的桶。因为一个桶内至多只会有一个元素，所以我们使用哈希表实现即可。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int getID(int x, long w) {
        return x < 0 ? (x + 1ll) / w - 1 : x / w;
    }

    bool containsNearbyAlmostDuplicate(vector<int>& nums, int k, int t) {
        unordered_map<int, int> mp;
        int n = nums.size();
        for (int i = 0; i < n; i++) {
            long x = nums[i];
            int id = getID(x, t + 1ll);
            if (mp.count(id)) {
                return true;
            }
            if (mp.count(id - 1) && abs(x - mp[id - 1]) <= t) {
                return true;
            }
            if (mp.count(id + 1) && abs(x - mp[id + 1]) <= t) {
                return true;
            }
            mp[id] = x;
            if (i >= k) {
                mp.erase(getID(nums[i - k], t + 1ll));
            }
        }
        return false;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean containsNearbyAlmostDuplicate(int[] nums, int k, int t) {
        int n = nums.length;
        Map<Long, Long> map = new HashMap<Long, Long>();
        long w = (long) t + 1;
        for (int i = 0; i < n; i++) {
            long id = getID(nums[i], w);
            if (map.containsKey(id)) {
                return true;
            }
            if (map.containsKey(id - 1) && Math.abs(nums[i] - map.get(id - 1)) < w) {
                return true;
            }
            if (map.containsKey(id + 1) && Math.abs(nums[i] - map.get(id + 1)) < w) {
                return true;
            }
            map.put(id, (long) nums[i]);
            if (i >= k) {
                map.remove(getID(nums[i - k], w));
            }
        }
        return false;
    }

    public long getID(long x, long w) {
        if (x >= 0) {
            return x / w;
        }
        return (x + 1) / w - 1;
    }
}
```

```JavaScript [sol2-JavaScript]
var containsNearbyAlmostDuplicate = function(nums, k, t) {
    const n = nums.length;
    const mp = new Map();
    for (let i = 0; i < n; ++i) {
        const x = nums[i];
        const id = getID(x, t + 1);
        if (mp.has(id)) {
            return true;
        }
        if (mp.has(id - 1) && Math.abs(x - mp.get(id - 1)) <= t) {
            return true;
        }
        if (mp.has(id + 1) && Math.abs(x - mp.get(id + 1)) <= t) {
            return true;
        }
        mp.set(id, x);
        if (i >= k) {
            mp.delete(getID(nums[i - k], t + 1));
        }
    }
    return false;
};

const getID = (x, w) => {
    return x < 0 ? Math.floor((x + 1) / w) - 1 : Math.floor(x / w);
}
```

```go [sol2-Golang]
func getID(x, w int) int {
    if x >= 0 {
        return x / w
    }
    return (x+1)/w - 1
}

func containsNearbyAlmostDuplicate(nums []int, k, t int) bool {
    mp := map[int]int{}
    for i, x := range nums {
        id := getID(x, t+1)
        if _, has := mp[id]; has {
            return true
        }
        if y, has := mp[id-1]; has && abs(x-y) <= t {
            return true
        }
        if y, has := mp[id+1]; has && abs(x-y) <= t {
            return true
        }
        mp[id] = x
        if i >= k {
            delete(mp, getID(nums[i-k], t+1))
        }
    }
    return false
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

```C [sol2-C]
struct HashTable {
    int key;
    int val;
    UT_hash_handle hh;
};

int getID(int x, long long w) {
    return x < 0 ? (x + 1ll) / w - 1 : x / w;
}

struct HashTable* query(struct HashTable* hashTable, int x) {
    struct HashTable* tmp;
    HASH_FIND_INT(hashTable, &x, tmp);
    return tmp;
}

bool containsNearbyAlmostDuplicate(int* nums, int numsSize, int k, int t) {
    struct HashTable* hashTable = NULL;
    for (int i = 0; i < numsSize; i++) {
        long long x = nums[i];
        int id = getID(x, t + 1ll);
        struct HashTable* tmp;
        tmp = query(hashTable, id - 1);
        if (tmp != NULL && fabs(x - tmp->val) <= t) {
            return true;
        }
        tmp = query(hashTable, id + 1);
        if (tmp != NULL && fabs(x - tmp->val) <= t) {
            return true;
        }
        tmp = query(hashTable, id);
        if (tmp != NULL) {
            return true;
        } else {
            tmp = malloc(sizeof(struct HashTable));
            tmp->key = id;
            tmp->val = x;
            HASH_ADD_INT(hashTable, key, tmp);
        }
        if (i >= k) {
            tmp = query(hashTable, getID(nums[i - k], t + 1ll));
            HASH_DEL(hashTable, tmp);
        }
    }
    return false;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是给定数组的长度。每个元素至多被插入哈希表和从哈希表中删除一次，每次操作的时间复杂度均为 $O(1)$。

- 空间复杂度：$O(\min(n, k))$，其中 $n$ 是给定数组的长度。哈希表中至多包含 $\min(n, k + 1)$ 个元素。
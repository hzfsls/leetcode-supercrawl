#### 方法一：随机化 + 二分查找

**思路与算法**

根据题目的要求，每次询问给定的 $\textit{threshold}$ 的 $2$ 倍一定严格大于给定区间的长度。因此，我们实际上要找出的是区间的「绝对众数」：即出现次数严格超过区间长度一半的数，并判断该「绝对众数」的出现次数是否至少为 $\textit{threshold}$。

若区间的「绝对众数」存在，记为 $x$，那么当我们在区间中「随机」选择一个数时，会有至少 $\dfrac{1}{2}$ 的概率选到 $x$。如果我们进行 $k$ 次选择，那么一次都没有选到 $x$ 的概率不会超过 $\left( \dfrac{1}{2} \right)^k$。当 $k$ 的值较大时，例如 $k=20$，$\left( \dfrac{1}{2} \right)^k$ 的数量级在 $10^{-6}$ 左右，我们可以认为 $k$ 次选择中几乎不可能没有选择到 $x$。

当我们选择到一个数 $x'$ 时，我们如何统计它在区间中出现的次数呢？我们可以使用预处理 + 二分查找的方法。我们使用一个哈希表来存储每个数出现的位置，对于哈希表中的每个键值对 $(\textit{key}, \textit{value})$，$\textit{key}$ 表示一个数，$\textit{value}$ 是一个数组，按照递增的顺序存储了 $\textit{key}$ 在数组 $\textit{arr}$ 中每一次出现的位置。这样一来，我们在哈希表中以 $x'$ 为键得到的数组上，分别二分查找 $\textit{left}$ 和 $\textit{right} + 1$，得到的两个下标之间包含的元素个数，就是子区间 $[\textit{left}, \textit{right}]$ 中包含 $x'$ 的个数。

我们将「个数」记为 $\textit{occ}$：

- 如果 $\textit{occ} \geq \textit{threshold}$，那么我们就找到了答案 $x'$；

- 如果 $\textit{occ} < \textit{threshold}$ 但 $\textit{occ}$ 至少为区间长度的一半，那么说明 $\textit{occ}$：
    
    - 是「绝对众数」，但它出现的次数不够多。由于「绝对众数」只能有一个，因此一定不存在满足要求的元素；
    - 恰好出现了区间长度一半的次数，那么其它的数最多也只会出现区间长度一半的次数，也不够多，因此也不存在满足要求的元素。

- 如果 $\textit{occ}$ 小于区间长度的一半，那么我们再随机选择一个数并进行二分查找。

当 $k$ 次随机选择都完成，但我们仍然没有找到答案时，就可以认为不存在这样的元素。

**随机化正确性分析**

记询问的次数为 $q$，假设询问之间是独立的，那么我们最后给出的所有答案均正确的概率为：

$$
\left( 1 - \left( \frac{1}{2} \right)^k \right)^q \sim 1 - q \cdot \left( \frac{1}{2} \right)^k
$$

当 $k=20$，$q = 10^4$ 时，正确的概率约为 $1 - 10^4 \times 10^{-6} = 99\%$，已经是一个非常优秀的随机化算法。如果读者觉得这个概率仍然不够高，可以取 $k=30$，这样正确的概率约为 $1 - 10^4 \times 10^{-9} = 99.999\%$。

**代码**

```C++ [sol1-C++]
class MajorityChecker {
public:
    MajorityChecker(vector<int>& arr): arr(arr) {
        for (int i = 0; i < arr.size(); ++i) {
            loc[arr[i]].push_back(i);
        }
    }
    
    int query(int left, int right, int threshold) {
        int length = right - left + 1;
        uniform_int_distribution<int> dis(left, right);

        for (int i = 0; i < k; ++i) {
            int x = arr[dis(gen)];
            vector<int>& pos = loc[x];
            int occ = upper_bound(pos.begin(), pos.end(), right) - lower_bound(pos.begin(), pos.end(), left);
            if (occ >= threshold) {
                return x;
            }
            else if (occ * 2 >= length) {
                return -1;
            }
        }

        return -1;
    }

private:
    static constexpr int k = 20;

    const vector<int>& arr;
    unordered_map<int, vector<int>> loc;
    mt19937 gen{random_device{}()};
};
```

```Java [sol1-Java]
class MajorityChecker {
    public static final int K = 20;
    private int[] arr;
    private Map<Integer, List<Integer>> loc;
    private Random random;

    public MajorityChecker(int[] arr) {
        this.arr = arr;
        this.loc = new HashMap<Integer, List<Integer>>();
        for (int i = 0; i < arr.length; ++i) {
            loc.putIfAbsent(arr[i], new ArrayList<Integer>());
            loc.get(arr[i]).add(i);
        }
        this.random = new Random();
    }

    public int query(int left, int right, int threshold) {
        int length = right - left + 1;

        for (int i = 0; i < K; ++i) {
            int x = arr[left + random.nextInt(length)];
            List<Integer> pos = loc.get(x);
            int occ = searchEnd(pos, right) - searchStart(pos, left);
            if (occ >= threshold) {
                return x;
            } else if (occ * 2 >= length) {
                return -1;
            }
        }

        return -1;
    }

    private int searchStart(List<Integer> pos, int target) {
        int low = 0, high = pos.size();
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (pos.get(mid) >= target) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }

    private int searchEnd(List<Integer> pos, int target) {
        int low = 0, high = pos.size();
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (pos.get(mid) > target) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }
}
```

```C# [sol1-C#]
public class MajorityChecker {
    public const int K = 20;
    private int[] arr;
    private IDictionary<int, IList<int>> loc;
    private Random random;

    public MajorityChecker(int[] arr) {
        this.arr = arr;
        this.loc = new Dictionary<int, IList<int>>();
        for (int i = 0; i < arr.Length; ++i) {
            loc.TryAdd(arr[i], new List<int>());
            loc[arr[i]].Add(i);
        }
        this.random = new Random();
    }

    public int Query(int left, int right, int threshold) {
        int length = right - left + 1;

        for (int i = 0; i < K; ++i) {
            int x = arr[left + random.Next(length)];
            IList<int> pos = loc[x];
            int occ = SearchEnd(pos, right) - SearchStart(pos, left);
            if (occ >= threshold) {
                return x;
            } else if (occ * 2 >= length) {
                return -1;
            }
        }

        return -1;
    }

    private int SearchStart(IList<int> pos, int target) {
        int low = 0, high = pos.Count;
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (pos[mid] >= target) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }

    private int SearchEnd(IList<int> pos, int target) {
        int low = 0, high = pos.Count;
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (pos[mid] > target) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }
}
```

```Python [sol1-Python3]
class MajorityChecker:
    k = 20

    def __init__(self, arr: List[int]):
        self.arr = arr
        self.loc = defaultdict(list)

        for i, val in enumerate(arr):
            self.loc[val].append(i)

    def query(self, left: int, right: int, threshold: int) -> int:
        arr_ = self.arr
        loc_ = self.loc
        
        length = right - left + 1
        for i in range(MajorityChecker.k):
            x = arr_[randint(left, right)]
            pos = loc_[x]
            occ = bisect_right(pos, right) - bisect_left(pos, left)
            if occ >= threshold:
                return x
            elif occ * 2 >= length:
                return -1

        return -1
```

```go [sol1-Golang]
type MajorityChecker struct {
    arr []int
    loc map[int][]int
}

func Constructor(arr []int) MajorityChecker {
    rand.Seed(time.Now().UnixNano())
    loc := map[int][]int{}
    for i, x := range arr {
        loc[x] = append(loc[x], i)
    }
    return MajorityChecker{arr, loc}
}

func (mc *MajorityChecker) Query(left, right, threshold int) int {
    length := right - left + 1
    for i := 0; i < 20; i++ {
        x := mc.arr[rand.Intn(right-left+1)+left]
        pos := mc.loc[x]
        occ := sort.SearchInts(pos, right+1) - sort.SearchInts(pos, left)
        if occ >= threshold {
            return x
        }
        if occ*2 >= length {
            break
        }
    }
    return -1
}
```

```C [sol1-C]
typedef struct Element {
    int *arr;
    int arrSize;
} Element;

typedef struct {
    int key;
    Element *val;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

const int k = 20;

bool hashAddItem(HashItem **obj, int key, Element *val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

Element* hashGetItem(HashItem **obj, int key) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return NULL;
    }
    return pEntry->val;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr->val->arr);
        free(curr->val);
        free(curr);             
    }
}

typedef struct {
    int *arr;
    int arrSize;
    HashItem *loc;
} MajorityChecker;

static int cmp(const void *pa, const void *pb) {
    int *a = (int *)pa;
    int *b = (int *)pb;
    return a[0] - b[0];
}

int searchStart(const int *pos, int posSize, int target) {
    int low = 0, high = posSize;
    while (low < high) {
        int mid = low + (high - low) / 2;
        if (pos[mid] >= target) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    return low;
}

int searchEnd(const int *pos, int posSize, int target) {
    int low = 0, high = posSize;
    while (low < high) {
        int mid = low + (high - low) / 2;
        if (pos[mid] > target) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    return low;
}

MajorityChecker* majorityCheckerCreate(int* arr, int arrSize) {
    MajorityChecker *obj = (MajorityChecker *)malloc(sizeof(MajorityChecker));
    obj->arr = arr;
    obj->arrSize = arrSize;
    obj->loc = NULL;
    int cnt[arrSize][2];
    for (int i = 0; i < arrSize; i++) {
        cnt[i][0] = arr[i];
        cnt[i][1] = i;
    }
    qsort(cnt, arrSize, sizeof(cnt[0]), cmp);
    for (int i = 0, j = 0; i <= arrSize; i++) {
        if (i == arrSize || cnt[i][0] != cnt[j][0]) {
            Element *cur = (Element *)malloc(sizeof(Element));
            cur->arr = (int *)malloc(sizeof(int) * (i - j));
            cur->arrSize = i - j;
            for (int k = 0; k < i - j; k++) {
                cur->arr[k] = cnt[j + k][1];
            }            
            hashAddItem(&obj->loc, cnt[j][0], cur);
            j = i;
        }
    }
    return obj;
}

int majorityCheckerQuery(MajorityChecker* obj, int left, int right, int threshold) {
    int length = right - left + 1;
    srand(time(NULL));

    for (int i = 0; i < k; ++i) {
        int x = obj->arr[rand() % length + left];
        Element *cur = hashGetItem(&obj->loc, x);
        int *pos = cur->arr;
        int posSize = cur->arrSize;
        int occ = searchEnd(pos, posSize, right) - searchStart(pos, posSize, left);
        if (occ >= threshold) {
            return x;
        } else if (occ * 2 >= length) {
            return -1;
        }
    }
    return -1;
}

void majorityCheckerFree(MajorityChecker* obj) {
    hashFree(&obj->loc);
    free(obj);
}
```

```JavaScript [sol1-JavaScript]
const K = 20;
var MajorityChecker = function(arr) {
    this.arr = arr;
    this.loc = new Map();
    for (let i = 0; i < arr.length; ++i) {
        if (!this.loc.has(arr[i])) {
            this.loc.set(arr[i], []);
        }
        this.loc.get(arr[i]).push(i);
    }
};

MajorityChecker.prototype.query = function(left, right, threshold) {
    const length = right - left + 1;
    for (let i = 0; i < K; ++i) {
        const x = this.arr[left + Math.floor(Math.random() * length)];
        const pos = this.loc.get(x);
        const occ = searchEnd(pos, right) - searchStart(pos, left);
        if (occ >= threshold) {
            return x;
        } else if (occ * 2 >= length) {
            return -1;
        }
    }

    return -1;
};

const searchStart = (pos, target) => {
    let low = 0, high = pos.length;
    while (low < high) {
        const mid = low + Math.floor((high - low) / 2);
        if (pos[mid] >= target) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    return low;
}

const searchEnd = (pos, target) => {
    let low = 0, high = pos.length;
    while (low < high) {
        const mid = low + Math.floor((high - low) / 2);
        if (pos[mid] > target) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    return low;
}
```

**复杂度分析**

- 时间复杂度：$O(n + kq\log n)$，其中 $n$ 是数组 $\textit{arr}$ 的长度，$q$ 是询问的次数，$k$ 是每次询问随机选择的次数。预处理哈希表需要 $O(n)$ 的时间，单次询问需要 $O(k \log n)$ 的时间。

- 空间复杂度：$O(n)$，即为哈希表需要使用的空间。

#### 方法二：摩尔投票 + 线段树

**前言**

本方法严重超纲。读者至少需要掌握：

- 「[169. 多数元素](https://leetcode.cn/problems/majority-element/)」中的「Boyer-Moore 投票算法」；

- 「[线段树](https://oi-wiki.org/ds/seg/)」的建立和区间查询。

**投票算法的结合性**

对于每一次查询，我们可以对子数组先进行一次遍历，使用投票算法找出可能的「绝对众数」$x'$，再使用一次遍历，记录 $x'$ 真正出现的次数，与 $\textit{threshold}$ 进行比较并得出答案。

这样做的时间复杂度为 $O(l)$，其中 $l$ 是子数组的长度，并不是一种高效率的做法。但我们可以发现，摩尔投票中存储的两个值是具有结合性质的：

- 在摩尔投票中，我们会存储两个值 $(x', \textit{cnt})$，其中 $x'$ 表示答案，$\textit{cnt}$ 表示 $x'$ 当前的价值。如果下一个数 $y' = x'$，那么 $\textit{cnt}$ 的值加 $1$，否则减 $1$。当 $\textit{cnt}$ 变为 $-1$ 时，会将 $x'$ 替换成 $y'$ 并将 $\textit{cnt}$ 初始化为 $1$；

- 对于一个给定的数组，我们可以将它分成任意的两部分（即使不连续都可以），分别使用投票算法得到 $(x_0', \textit{cnt}_0)$ 和 $(x_1', \textit{cnt}_1)$。那么整个数组使用投票算法得到的结果为：

    - 如果 $x_0' = x_1'$，结果为 $(x_0', \textit{cnt}_0 + \textit{cnt}_1)$；

    - 如果 $x_0' \neq x_1'$，结果为 $\textit{cnt}_0$ 和 $\textit{cnt}_1$ 中较大的那个对应的 $x'$，以及 $|\textit{cnt}_0 - \textit{cnt}_1|$。

我们可以使用通俗的解释证明正确性：投票算法本质上是在数组中不断找出两个不同的整数，把它们消除。当数组中只剩下一种整数时，这个整数就是 $x'$，它出现的次数就是 $\textit{cnt}$。如果数组中存在「绝对众数」，那么它就是 $x'$，否则最后剩下的 $x'$ 可能是任何值。因此，我们先将数组分成任意的两部分，分别进行消除，得到了 $\textit{cnt}_0$ 个 $x_0'$ 以及 $\textit{cnt}_1$ 个 $x_1'$。再将它们进行消除，就得到了整个数组进行投票算法的结果：

- 如果数组中存在「绝对众数」$x'$，那么根据鸽巢原理，一定有一个部分的绝对众数也是 $x'$，它可以在 $(x_0', \textit{cnt}_0)$ 或 $(x_1', \textit{cnt}_1)$ 中得到保留；

- 如果不存在，那么 $(x_0', \textit{cnt}_0)$ 和 $(x_1', \textit{cnt}_1)$ 的值都无关紧要。

上述结合性可以推广到将数组拆分成任意多个部分的情形，因此我们就可以使用线段树，每个节点存储对应区间的 $(x', \textit{cnt})$。

**算法**

我们使用线段树解决本题。线段树的每个节点存储两个值，即对应区间的 $(x', \textit{cnt})$。

对于每个查询操作 $(\textit{left}, \textit{right}, \textit{threshold})$，我们在线段树上查询区间 $[\textit{left}, \textit{right}]$，合并所有区间的值，得到答案 $(x', \textit{cnt})$。随后我们使用与方法一中相同的哈希表，进行二分查找，判断 $x'$ 是否出现了至少 $\textit{threshold}$ 次即可。

**代码**

```C++ [sol2-C++]
struct Node {
    Node(int x = 0, int cnt = 0): x(x), cnt(cnt) {}
    Node& operator+=(const Node& that) {
        if (x == that.x) {
            cnt += that.cnt;
        }
        else if (cnt >= that.cnt) {
            cnt -= that.cnt;
        }
        else {
            x = that.x;
            cnt = that.cnt - cnt;
        }
        return *this;
    }

    int x, cnt;
};

class MajorityChecker {
public:
    MajorityChecker(vector<int>& arr): arr(arr) {
        n = arr.size();
        for (int i = 0; i < n; ++i) {
            loc[arr[i]].push_back(i);
        }

        tree.resize(n * 4);
        seg_build(0, 0, n - 1);
    }
    
    int query(int left, int right, int threshold) {
        Node ans;
        seg_query(0, 0, n - 1, left, right, ans);
        vector<int>& pos = loc[ans.x];
        int occ = upper_bound(pos.begin(), pos.end(), right) - lower_bound(pos.begin(), pos.end(), left);
        return (occ >= threshold ? ans.x : -1);
    }

private:
    int n;
    const vector<int>& arr;
    unordered_map<int, vector<int>> loc;
    vector<Node> tree;

    void seg_build(int id, int l, int r) {
        if (l == r) {
            tree[id] = {arr[l], 1};
            return;
        }

        int mid = (l + r) / 2;
        seg_build(id * 2 + 1, l, mid);
        seg_build(id * 2 + 2, mid + 1, r);
        tree[id] += tree[id * 2 + 1];
        tree[id] += tree[id * 2 + 2];
    }

    void seg_query(int id, int l, int r, int ql, int qr, Node& ans) {
        if (l > qr || r < ql) {
            return;
        }
        if (ql <= l && r <= qr) {
            ans += tree[id];
            return;
        }

        int mid = (l + r) / 2;
        seg_query(id * 2 + 1, l, mid, ql, qr, ans);
        seg_query(id * 2 + 2, mid + 1, r, ql, qr, ans);
    }
};
```

```Java [sol2-Java]
class MajorityChecker {
    private int n;
    private int[] arr;
    private Map<Integer, List<Integer>> loc;
    private Node[] tree;

    public MajorityChecker(int[] arr) {
        this.n = arr.length;
        this.arr = arr;
        this.loc = new HashMap<Integer, List<Integer>>();
        for (int i = 0; i < arr.length; ++i) {
            loc.putIfAbsent(arr[i], new ArrayList<Integer>());
            loc.get(arr[i]).add(i);
        }

        this.tree = new Node[n * 4];
        for (int i = 0; i < n * 4; i++) {
            tree[i] = new Node();
        }
        segBuild(0, 0, n - 1);
    }

    public int query(int left, int right, int threshold) {
        Node ans = new Node();
        segQuery(0, 0, n - 1, left, right, ans);
        List<Integer> pos = loc.getOrDefault(ans.x, new ArrayList<Integer>());
        int occ = searchEnd(pos, right) - searchStart(pos, left);
        return occ >= threshold ? ans.x : -1;
    }

    private void segBuild(int id, int l, int r) {
        if (l == r) {
            tree[id] = new Node(arr[l], 1);
            return;
        }

        int mid = (l + r) / 2;
        segBuild(id * 2 + 1, l, mid);
        segBuild(id * 2 + 2, mid + 1, r);
        tree[id].add(tree[id * 2 + 1]);
        tree[id].add(tree[id * 2 + 2]);
    }

    private void segQuery(int id, int l, int r, int ql, int qr, Node ans) {
        if (l > qr || r < ql) {
            return;
        }
        if (ql <= l && r <= qr) {
            ans.add(tree[id]);
            return;
        }

        int mid = (l + r) / 2;
        segQuery(id * 2 + 1, l, mid, ql, qr, ans);
        segQuery(id * 2 + 2, mid + 1, r, ql, qr, ans);
    }

    private int searchStart(List<Integer> pos, int target) {
        int low = 0, high = pos.size();
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (pos.get(mid) >= target) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }

    private int searchEnd(List<Integer> pos, int target) {
        int low = 0, high = pos.size();
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (pos.get(mid) > target) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }
}

class Node {
    int x;
    int cnt;

    public Node() {
        this(0, 0);
    }

    public Node(int x, int cnt) {
        this.x = x;
        this.cnt = cnt;
    }

    public void add(Node that) {
        if (x == that.x) {
            cnt += that.cnt;
        } else if (cnt >= that.cnt) {
            cnt -= that.cnt;
        } else {
            x = that.x;
            cnt = that.cnt - cnt;
        }
    }
}
```

```C# [sol2-C#]
public class MajorityChecker {
    private int n;
    private int[] arr;
    private IDictionary<int, List<int>> loc;
    private Node[] tree;

    public MajorityChecker(int[] arr) {
        this.n = arr.Length;
        this.arr = arr;
        this.loc = new Dictionary<int, List<int>>();
        for (int i = 0; i < arr.Length; ++i) {
            loc.TryAdd(arr[i], new List<int>());
            loc[arr[i]].Add(i);
        }

        this.tree = new Node[n * 4];
        for (int i = 0; i < n * 4; i++) {
            tree[i] = new Node();
        }
        SegBuild(0, 0, n - 1);
    }

    public int Query(int left, int right, int threshold) {
        Node ans = new Node();
        SegQuery(0, 0, n - 1, left, right, ans);
        IList<int> pos = loc.ContainsKey(ans.x) ? loc[ans.x] : new List<int>();
        int occ = SearchEnd(pos, right) - SearchStart(pos, left);
        return occ >= threshold ? ans.x : -1;
    }

    private void SegBuild(int id, int l, int r) {
        if (l == r) {
            tree[id] = new Node(arr[l], 1);
            return;
        }

        int mid = (l + r) / 2;
        SegBuild(id * 2 + 1, l, mid);
        SegBuild(id * 2 + 2, mid + 1, r);
        tree[id].Add(tree[id * 2 + 1]);
        tree[id].Add(tree[id * 2 + 2]);
    }

    private void SegQuery(int id, int l, int r, int ql, int qr, Node ans) {
        if (l > qr || r < ql) {
            return;
        }
        if (ql <= l && r <= qr) {
            ans.Add(tree[id]);
            return;
        }

        int mid = (l + r) / 2;
        SegQuery(id * 2 + 1, l, mid, ql, qr, ans);
        SegQuery(id * 2 + 2, mid + 1, r, ql, qr, ans);
    }

    private int SearchStart(IList<int> pos, int target) {
        int low = 0, high = pos.Count;
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (pos[mid] >= target) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }

    private int SearchEnd(IList<int> pos, int target) {
        int low = 0, high = pos.Count;
        while (low < high) {
            int mid = low + (high - low) / 2;
            if (pos[mid] > target) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }
}

class Node {
    public int x;
    public int cnt;

    public Node() : this(0, 0) {

    }

    public Node(int x, int cnt) {
        this.x = x;
        this.cnt = cnt;
    }

    public void Add(Node that) {
        if (x == that.x) {
            cnt += that.cnt;
        } else if (cnt >= that.cnt) {
            cnt -= that.cnt;
        } else {
            x = that.x;
            cnt = that.cnt - cnt;
        }
    }
}
```

```Python [sol2-Python3]
class Node:
    def __init__(self, x: int = 0, cnt: int = 0):
        self.x = x
        self.cnt = cnt
    
    def __iadd__(self, that: "Node") -> "Node":
        if self.x == that.x:
            self.cnt += that.cnt
        elif self.cnt >= that.cnt:
            self.cnt -= that.cnt
        else:
            self.x = that.x
            self.cnt = that.cnt - self.cnt
        return self

class MajorityChecker:
    def __init__(self, arr: List[int]):
        self.n = len(arr)
        self.arr = arr
        self.loc = defaultdict(list)

        for i, val in enumerate(arr):
            self.loc[val].append(i)
        
        self.tree = [Node() for _ in range(self.n * 4)]
        self.seg_build(0, 0, self.n - 1)

    def query(self, left: int, right: int, threshold: int) -> int:
        loc_ = self.loc

        ans = Node()
        self.seg_query(0, 0, self.n - 1, left, right, ans)
        pos = loc_[ans.x]
        occ = bisect_right(pos, right) - bisect_left(pos, left)
        return ans.x if occ >= threshold else -1
    
    def seg_build(self, idx: int, l: int, r: int):
        arr_ = self.arr
        tree_ = self.tree

        if l == r:
            tree_[idx] = Node(arr_[l], 1)
            return
        
        mid = (l + r) // 2
        self.seg_build(idx * 2 + 1, l, mid)
        self.seg_build(idx * 2 + 2, mid + 1, r)
        tree_[idx] += tree_[idx * 2 + 1]
        tree_[idx] += tree_[idx * 2 + 2]

    def seg_query(self, idx: int, l: int, r: int, ql: int, qr: int, ans: Node):
        tree_ = self.tree

        if l > qr or r < ql:
            return
        
        if ql <= l and r <= qr:
            ans += tree_[idx]
            return

        mid = (l + r) // 2
        self.seg_query(idx * 2 + 1, l, mid, ql, qr, ans)
        self.seg_query(idx * 2 + 2, mid + 1, r, ql, qr, ans)
```

```C [sol2-C]
typedef struct Element {
    int *arr;
    int arrSize;
} Element;

typedef struct {
    int key;
    Element *val;
    UT_hash_handle hh;
} HashItem; 

typedef struct Node {
    int x;
    int cnt;
} Node;

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key, Element *val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

Element* hashGetItem(HashItem **obj, int key) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return NULL;
    }
    return pEntry->val;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr->val->arr);
        free(curr->val);
        free(curr);             
    }
}

typedef struct {
    int *arr;
    int arrSize;
    HashItem *loc;
    Node *tree;
} MajorityChecker;

static int cmp(const void *pa, const void *pb) {
    int *a = (int *)pa;
    int *b = (int *)pb;
    return a[0] - b[0];
}

void addNode(Node *node, Node *that) {
    if (node->x == that->x) {
        node->cnt += that->cnt;
    } else if (node->cnt > that->cnt) {
        node->cnt -= that->cnt;
    } else {
        node->x = that->x;
        node->cnt = that->cnt - node->cnt;
    }
}

void seg_build(Node *tree, const int *arr, int id, int l, int r) {
    if (l == r) {
        tree[id].x = arr[l];
        tree[id].cnt = 1;
        return;
    }

    int mid = (l + r) / 2;
    seg_build(tree, arr, id * 2 + 1, l, mid);
    seg_build(tree, arr, id * 2 + 2, mid + 1, r);
    addNode(&tree[id], &tree[id * 2 + 1]);
    addNode(&tree[id], &tree[id * 2 + 2]);
}

void seg_query(Node *tree, int id, int l, int r, int ql, int qr, Node* ans) {
    if (l > qr || r < ql) {
        return;
    }
    if (ql <= l && r <= qr) {
        addNode(ans, &tree[id]);
        return;
    }
    int mid = (l + r) / 2;
    seg_query(tree, id * 2 + 1, l, mid, ql, qr, ans);
    seg_query(tree, id * 2 + 2, mid + 1, r, ql, qr, ans);
}

int searchStart(const int *pos, int posSize, int target) {
    int low = 0, high = posSize;
    while (low < high) {
        int mid = low + (high - low) / 2;
        if (pos[mid] >= target) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    return low;
}

int searchEnd(const int *pos, int posSize, int target) {
    int low = 0, high = posSize;
    while (low < high) {
        int mid = low + (high - low) / 2;
        if (pos[mid] > target) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    return low;
}

MajorityChecker* majorityCheckerCreate(int* arr, int arrSize) {
    MajorityChecker *obj = (MajorityChecker *)malloc(sizeof(MajorityChecker));
    obj->arr = arr;
    obj->arrSize = arrSize;
    obj->loc = NULL;
    int cnt[arrSize][2];
    for (int i = 0; i < arrSize; i++) {
        cnt[i][0] = arr[i];
        cnt[i][1] = i;
    }
    qsort(cnt, arrSize, sizeof(cnt[0]), cmp);
    for (int i = 0, j = 0; i <= arrSize; i++) {
        if (i == arrSize || cnt[i][0] != cnt[j][0]) {
            Element *cur = (Element *)malloc(sizeof(Element));
            cur->arr = (int *)malloc(sizeof(int) * (i - j));
            cur->arrSize = i - j;
            for (int k = 0; k < i - j; k++) {
                cur->arr[k] = cnt[j + k][1];
            }            
            hashAddItem(&obj->loc, cnt[j][0], cur);
            j = i;
        }
    }
    obj->tree = (Node *)malloc(sizeof(Node) * 4 * arrSize);
    memset(obj->tree, 0, sizeof(Node) * 4 * arrSize);
    seg_build(obj->tree, arr, 0, 0, arrSize - 1);
    return obj;
}

int majorityCheckerQuery(MajorityChecker* obj, int left, int right, int threshold) {
    Node ans;
    memset(&ans, 0, sizeof(ans));
    seg_query(obj->tree, 0, 0, obj->arrSize - 1, left, right, &ans);
    Element *cur = hashGetItem(&obj->loc, ans.x);
    int *pos = cur->arr;
    int posSize = cur->arrSize;
    int occ = searchEnd(pos, posSize, right) - searchStart(pos, posSize, left);
    return (occ >= threshold ? ans.x : -1);
}

void majorityCheckerFree(MajorityChecker* obj) {
    hashFree(&obj->loc);
    free(obj->tree);
    free(obj);
}
```

**复杂度分析**

- 时间复杂度：$O(n + q\log n)$，其中 $n$ 是数组 $\textit{arr}$ 的长度，$q$ 是询问的次数。预处理哈希表和线段树需要 $O(n)$ 的时间，单次询问需要 $O(\log n)$ 的时间。

- 空间复杂度：$O(n)$，即为哈希表和线段树需要使用的空间。
## [954.二倍数对数组 中文官方题解](https://leetcode.cn/problems/array-of-doubled-pairs/solutions/100000/er-bei-shu-dui-shu-zu-by-leetcode-soluti-2mqj)

#### 方法一：哈希表 + 排序

设 $\textit{arr}$ 的长度为 $n$，题目本质上是问 $\textit{arr}$ 能否分成 $\dfrac{n}{2}$ 对元素，每对元素中一个数是另一个数的两倍。

设 $\textit{cnt}[x]$ 表示 $\textit{arr}$ 中 $x$ 的个数。

对于 $\textit{arr}$ 中的 $0$，它只能与 $0$ 匹配。如果 $\textit{cnt}[0]$ 是奇数，那么必然无法满足题目要求。

去掉 $\textit{arr}$ 中的 $0$。设 $x$ 为 $\textit{arr}$ 中绝对值最小的元素，由于没有绝对值比 $x$ 更小的数，因此 $x$ 只能与 $2x$ 匹配。如果此时 $\textit{cnt}[2x] < \textit{cnt}[x]$，那么会有部分 $x$ 无法找到它的另一半，即无法满足题目要求；否则将所有 $x$ 和 $\textit{cnt}[x]$ 个 $2x$ 从 $\textit{arr}$ 中去掉，继续判断剩余元素是否满足题目要求。不断重复此操作，如果某个时刻 $\textit{arr}$ 为空，则说明 $\textit{arr}$ 可以满足题目要求。

代码实现时，我们可以用一个哈希表来统计 $\textit{cnt}$，并将其键值按绝对值从小到大排序，然后模拟上述操作，去掉元素的操作可以改为从 $\textit{cnt}$ 中减去对应值。

```Python [sol1-Python3]
class Solution:
    def canReorderDoubled(self, arr: List[int]) -> bool:
        cnt = Counter(arr)
        if cnt[0] % 2:
            return False
        for x in sorted(cnt, key=abs):
            if cnt[2 * x] < cnt[x]:  # 无法找到足够的 2x 与 x 配对
                return False
            cnt[2 * x] -= cnt[x]
        return True
```

```C++ [sol1-C++]
class Solution {
public:
    bool canReorderDoubled(vector<int> &arr) {
        unordered_map<int, int> cnt;
        for (int x : arr) {
            ++cnt[x];
        }
        if (cnt[0] % 2) {
            return false;
        }

        vector<int> vals;
        vals.reserve(cnt.size());
        for (auto &[x, _] : cnt) {
            vals.push_back(x);
        }
        sort(vals.begin(), vals.end(), [](int a, int b) { return abs(a) < abs(b); });

        for (int x : vals) {
            if (cnt[2 * x] < cnt[x]) { // 无法找到足够的 2x 与 x 配对
                return false;
            }
            cnt[2 * x] -= cnt[x];
        }
        return true;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean canReorderDoubled(int[] arr) {
        Map<Integer, Integer> cnt = new HashMap<Integer, Integer>();
        for (int x : arr) {
            cnt.put(x, cnt.getOrDefault(x, 0) + 1);
        }
        if (cnt.getOrDefault(0, 0) % 2 != 0) {
            return false;
        }

        List<Integer> vals = new ArrayList<Integer>();
        for (int x : cnt.keySet()) {
            vals.add(x);
        }
        Collections.sort(vals, (a, b) -> Math.abs(a) - Math.abs(b));

        for (int x : vals) {
            if (cnt.getOrDefault(2 * x, 0) < cnt.get(x)) { // 无法找到足够的 2x 与 x 配对
                return false;
            }
            cnt.put(2 * x, cnt.getOrDefault(2 * x, 0) - cnt.get(x));
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool CanReorderDoubled(int[] arr) {
        Dictionary<int, int> cnt = new Dictionary<int, int>();
        foreach (int x in arr) {
            if (!cnt.ContainsKey(x)) {
                cnt.Add(x, 1);
            } else {
                ++cnt[x];
            }
        }
        if (cnt.ContainsKey(0) && cnt[0] % 2 != 0) {
            return false;
        }

        List<int> vals = new List<int>();
        foreach (int x in cnt.Keys) {
            vals.Add(x);
        }
        vals.Sort((a, b) => Math.Abs(a) - Math.Abs(b));

        foreach (int x in vals) {
            if ((cnt.ContainsKey(2 * x) ? cnt[2 * x] : 0) < cnt[x]) { // 无法找到足够的 2x 与 x 配对
                return false;
            }
            if (cnt.ContainsKey(2 * x)) {
                cnt[2 * x] -= cnt[x];
            } else {
                cnt.Add(2 * x, -cnt[x]);
            }
        }
        return true;
    }
}
```

```go [sol1-Golang]
func canReorderDoubled(arr []int) bool {
    cnt := make(map[int]int, len(arr))
    for _, x := range arr {
        cnt[x]++
    }
    if cnt[0]%2 == 1 {
        return false
    }

    vals := make([]int, 0, len(cnt))
    for x := range cnt {
        vals = append(vals, x)
    }
    sort.Slice(vals, func(i, j int) bool { return abs(vals[i]) < abs(vals[j]) })

    for _, x := range vals {
        if cnt[2*x] < cnt[x] { // 无法找到足够的 2x 与 x 配对
            return false
        }
        cnt[2*x] -= cnt[x]
    }
    return true
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

```C [sol1-C]
typedef struct {
    int key;
    int val;
    UT_hash_handle hh;
} HashItem;

static int cmp(const int * pa, const int * pb) {
    return abs(*pa) - abs(*pb);
}

bool canReorderDoubled(int* arr, int arrSize){
    HashItem * cnt = NULL;
    HashItem * pEntry = NULL;
    for (int i = 0; i < arrSize; i++) {
        pEntry = NULL;
        HASH_FIND_INT(cnt, &arr[i], pEntry);
        if (NULL == pEntry) {
            pEntry = (HashItem *)malloc(sizeof(HashItem));
            pEntry->key = arr[i];
            pEntry->val = 1;
            HASH_ADD_INT(cnt, key, pEntry);
        } else {
            pEntry->val++;
        }
    }
    pEntry = NULL;
    int key = 0;
    HASH_FIND_INT(cnt, &key, pEntry);
    if (pEntry != NULL && pEntry->val % 2) {
        return false;
    }
 
    int cntSize = HASH_COUNT(cnt);
    int * vals = (int *)malloc(sizeof(int) * cntSize);
    int pos = 0;
    HashItem * tmp;
    HASH_ITER(hh, cnt, pEntry, tmp) {
        vals[pos++] = pEntry->key; 
    }
    qsort(vals, cntSize, sizeof(int), cmp);
    for (int i = 0; i < cntSize; i++) {
        int c1 = 0, c2 = 0;
        int key = vals[i];
        HashItem * pEntry1 = NULL;
        HashItem * pEntry2 = NULL;
        HASH_FIND_INT(cnt, &key, pEntry1);
        if (pEntry1) {
            c1 = pEntry1->val;
        }
        key = 2 * vals[i];
        HASH_FIND_INT(cnt, &key, pEntry2);
        if (pEntry2) {
            c2 = pEntry2->val;
        }
        if (c2 < c1) {
            return false;
        }
        if (pEntry2) {
            pEntry2->val -= c1;
        }
    }
    HASH_ITER(hh, cnt, pEntry, tmp) {
        HASH_DEL(cnt, pEntry);
        free(pEntry);
    }
    free(vals);
    return true;
}
```

```JavaScript [sol1-JavaScript]
var canReorderDoubled = function(arr) {
    const cnt = new Map();
    for (const x of arr) {
        cnt.set(x, (cnt.get(x) || 0) + 1);
    }
    if ((cnt.get(0) || 0) % 2 !== 0) {
        return false;
    }

    const vals = [];
    for (const x of cnt.keys()) {
        vals.push(x);
    }
    vals.sort((a, b) => Math.abs(a) - Math.abs(b));

    for (const x of vals) {
        if ((cnt.get(2 * x) || 0) < cnt.get(x)) { // 无法找到足够的 2x 与 x 配对
            return false;
        }
        cnt.set(2 * x, (cnt.get(2 * x) || 0) - cnt.get(x));
    }
    return true;
};
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。最坏情况下哈希表中有 $n$ 个元素，对其排序需要 $O(n\log n)$ 的时间。

- 空间复杂度：$O(n)$。最坏情况下哈希表中有 $n$ 个元素，需要 $O(n)$ 的空间。
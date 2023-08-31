## [1090.受标签影响的最大值 中文官方题解](https://leetcode.cn/problems/largest-values-from-labels/solutions/100000/shou-biao-qian-ying-xiang-de-zui-da-zhi-5h9ll)
#### 方法一：排序 + 哈希表

**思路与算法**

我们首先将元素按照 $\textit{values}$ 的值进行降序排序。待排序完成后，我们依次遍历每个元素并判断是否选择。我们可以使用一个变量 $\textit{choose}$ 记录已经选择的元素个数，以及一个哈希表记录每一种标签已经选择的元素个数（键表示标签，值表示该标签已经选择的元素个数）：

- 如果 $\textit{choose} = \textit{numWanted}$，我们可以直接退出遍历；

- 如果当前元素的标签在哈希表中对应的值等于 $\textit{useLimit}$，我们忽略这个元素，否则我们选择这个元素，并更新 $\textit{choose}$、哈希表以及答案。

**细节**

由于题目中的 $\textit{values}$ 和 $\textit{labels}$ 是分成两个数组给出的，直接排序会比较困难。我们可以额外开辟一个同样长度为 $n$ 的数组，存储下标，并直接在该数组上进行排序即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int largestValsFromLabels(vector<int>& values, vector<int>& labels, int numWanted, int useLimit) {
        int n = values.size();
        vector<int> id(n);
        iota(id.begin(), id.end(), 0);
        sort(id.begin(), id.end(), [&](int i, int j) {
            return values[i] > values[j];
        });

        int ans = 0, choose = 0;
        unordered_map<int, int> cnt;
        for (int i = 0; i < n && choose < numWanted; ++i) {
            int label = labels[id[i]];
            if (cnt[label] == useLimit) {
                continue;
            }
            ++choose;
            ans += values[id[i]];
            ++cnt[label];
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int largestValsFromLabels(int[] values, int[] labels, int numWanted, int useLimit) {
        int n = values.length;
        Integer[] id = new Integer[n];
        for (int i = 0; i < n; i++) {
            id[i] = i;
        }
        Arrays.sort(id, (a, b) -> values[b] - values[a]);

        int ans = 0, choose = 0;
        Map<Integer, Integer> cnt = new HashMap<Integer, Integer>();
        for (int i = 0; i < n && choose < numWanted; ++i) {
            int label = labels[id[i]];
            if (cnt.getOrDefault(label, 0) == useLimit) {
                continue;
            }
            ++choose;
            ans += values[id[i]];
            cnt.put(label, cnt.getOrDefault(label, 0) + 1);
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int LargestValsFromLabels(int[] values, int[] labels, int numWanted, int useLimit) {
        int n = values.Length;
        int[] id = new int[n];
        for (int i = 0; i < n; i++) {
            id[i] = i;
        }
        Array.Sort(id, (a, b) => values[b] - values[a]);

        int ans = 0, choose = 0;
        IDictionary<int, int> cnt = new Dictionary<int, int>();
        for (int i = 0; i < n && choose < numWanted; ++i) {
            int label = labels[id[i]];
            if (cnt.ContainsKey(label) && cnt[label] == useLimit) {
                continue;
            }
            ++choose;
            ans += values[id[i]];
            cnt.TryAdd(label, 0);
            ++cnt[label];
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def largestValsFromLabels(self, values: List[int], labels: List[int], numWanted: int, useLimit: int) -> int:
        n = len(values)
        idx = list(range(n))
        idx.sort(key=lambda i: -values[i])

        ans = choose = 0
        cnt = Counter()
        for i in range(n):
            label = labels[idx[i]]
            if cnt[label] == useLimit:
                continue;
            
            choose += 1
            ans += values[idx[i]]
            cnt[label] += 1
            if choose == numWanted:
                break
        return ans
```

```Go [sol1-Go]
func largestValsFromLabels(values []int, labels []int, numWanted int, useLimit int) int {
    n := len(values)
    idx := make([]int, n)
    for i := 0; i < n; i++ {
        idx[i] = i
    }
    sort.Slice(idx, func(i, j int) bool {
        return values[idx[i]] > values[idx[j]]
    })

    ans, choose := 0, 0
    cnt := make(map[int]int)
    for i := 0; i < n; i++ {
        label := labels[idx[i]]
        if cnt[label] == useLimit {
            continue
        }
        choose++
        ans += values[idx[i]]
        cnt[label]++
        if choose == numWanted {
            break
        }
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var largestValsFromLabels = function(values, labels, numWanted, useLimit) {
    const n = values.length;
    const idx = Array.from(Array(n), (_, i) => i);
    idx.sort((i, j) => values[j] - values[i]);

    let ans = 0, choose = 0;
    const cnt = {};
    for (let i = 0; i < n; i++) {
        const label = labels[idx[i]];
        if (cnt[label] === useLimit) {
            continue;
        }
        choose++;
        ans += values[idx[i]];
        cnt[label] = (cnt[label] || 0) + 1;
        if (choose === numWanted) {
            break;
        }
    }
    return ans;
}
```

```C [sol1-C]
typedef struct {
    int key;
    int val;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key, int val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

bool hashSetItem(HashItem **obj, int key, int val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        hashAddItem(obj, key, val);
    } else {
        pEntry->val = val;
    }
    return true;
}

int hashGetItem(HashItem **obj, int key, int defaultVal) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return defaultVal;
    }
    return pEntry->val;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);
    }
}

static int cmp(const void *pa, const void *pb) {
    return ((int *)pb)[0] - ((int *)pa)[0];
}

int largestValsFromLabels(int* values, int valuesSize, int* labels, int labelsSize, int numWanted, int useLimit) {
    int n = valuesSize;
    int arr[n][2];
    for (int i = 0; i < n; i++) {
        arr[i][0] = values[i];
        arr[i][1] = i;
    }
    qsort(arr, n, sizeof(arr[0]), cmp);

    int ans = 0, choose = 0;
    HashItem *cnt = NULL;
    for (int i = 0; i < n && choose < numWanted; ++i) {
        int id = arr[i][1];
        int label = labels[id];
        if (hashGetItem(&cnt, label, 0) == useLimit) {
            continue;
        }
        ++choose;
        ans += values[id];
        hashSetItem(&cnt, label, hashGetItem(&cnt, label, 0) + 1);
    }
    hashFree(&cnt);
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，即为排序需要的时间。后续遍历需要的时间为 $O(n)$，在渐进意义下小于 $O(n \log n)$。

- 空间复杂度：$O(n)$，即为存储下标的数组以及哈希表需要使用的空间。
## [2363.合并相似的物品 中文官方题解](https://leetcode.cn/problems/merge-similar-items/solutions/100000/he-bing-xiang-si-de-wu-pin-by-leetcode-s-ywx0)

#### 方法一：哈希表

**思路与算法**

我们建立一个哈希表，其键值表示物品价值，其值为对应价值物品的重量之和。依次遍历 $\textit{items}_1$ 和 $\textit{items}_2$ 中的每一项物品，同时更新哈希表。最后，我们取出哈希表中的每一个键值对放入数组，对数组按照 $\textit{value}$ 值排序即可。

有些语言可以在维护键值对的同时，对键值对按照「键」进行排序，比如 $\text{C++}$ 中的 $\text{std::map}$，这样我们可以省略掉最后对数组的排序过程。

**代码**

```Python [sol1-Python3]
class Solution:
    def mergeSimilarItems(self, items1: List[List[int]], items2: List[List[int]]) -> List[List[int]]:
        map = Counter()
        for a, b in items1:
            map[a] += b
        for a, b in items2:
            map[a] += b
        return sorted([a, b] for a, b in map.items())
```

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> mergeSimilarItems(vector<vector<int>>& items1, vector<vector<int>>& items2) {
        map<int, int> mp;
        for (auto &v : items1) {
            mp[v[0]] += v[1];
        }
        for (auto &v : items2) {
            mp[v[0]] += v[1];
        }

        vector<vector<int>> res;
        for (auto &[k, v] : mp) {
            res.push_back({k, v});
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<List<Integer>> mergeSimilarItems(int[][] items1, int[][] items2) {
        Map<Integer, Integer> map = new HashMap<Integer, Integer>();
        for (int[] v : items1) {
            map.put(v[0], map.getOrDefault(v[0], 0) + v[1]);
        }
        for (int[] v : items2) {
            map.put(v[0], map.getOrDefault(v[0], 0) + v[1]);
        }

        List<List<Integer>> res = new ArrayList<List<Integer>>();
        for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
            int k = entry.getKey(), v = entry.getValue();
            List<Integer> pair = new ArrayList<Integer>();
            pair.add(k);
            pair.add(v);
            res.add(pair);
        }
        Collections.sort(res, (a, b) -> a.get(0) - b.get(0));
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<IList<int>> MergeSimilarItems(int[][] items1, int[][] items2) {
        IDictionary<int, int> dictionary = new Dictionary<int, int>();
        foreach (int[] v in items1) {
            dictionary.TryAdd(v[0], 0);
            dictionary[v[0]] += v[1];
        }
        foreach (int[] v in items2) {
            dictionary.TryAdd(v[0], 0);
            dictionary[v[0]] += v[1];
        }

        IList<IList<int>> res = new List<IList<int>>();
        foreach (KeyValuePair<int, int> kv in dictionary) {
            int k = kv.Key, v = kv.Value;
            res.Add(new List<int>{k, v});
        }
        ((List<IList<int>>) res).Sort((a, b) => a[0] - b[0]);
        return res;
    }
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
    int *a = *(int **)pa;
    int *b = *(int **)pb;
    return a[0] - b[0];
}

int** mergeSimilarItems(int** items1, int items1Size, int* items1ColSize, int** items2, int items2Size, int* items2ColSize, int* returnSize, int** returnColumnSizes) {
    HashItem *mp = NULL;
    for (int i = 0; i < items1Size; i++) {
        hashSetItem(&mp, items1[i][0], items1[i][1] + hashGetItem(&mp, items1[i][0], 0));
    }
    for (int i = 0; i < items2Size; i++) {
        hashSetItem(&mp, items2[i][0], items2[i][1] + hashGetItem(&mp, items2[i][0], 0));
    }
    int len = HASH_COUNT(mp);
    int **res = (int **)malloc(sizeof(int *) * len);
    for (int i = 0; i < len; i++) {
        res[i] = (int *)malloc(sizeof(int) * 2);
    }
    
    int pos = 0;
    HashItem *pEntry = NULL;
    for (pEntry = mp; pEntry != NULL; pEntry = pEntry->hh.next) {
        res[pos][0] = pEntry->key;
        res[pos][1] = pEntry->val;
        pos++;
    }
    qsort(res, len, sizeof(int *), cmp);
    *returnSize = len;
    *returnColumnSizes = (int *)malloc(sizeof(int) * len);
    for (int i = 0; i < len; i++) {
        (*returnColumnSizes)[i] = 2;
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var mergeSimilarItems = function(items1, items2) {
    const map = new Map();
    for (const v of items1) {
        map.set(v[0], (map.get(v[0]) || 0) + v[1]);
    }
    for (const v of items2) {
        map.set(v[0], (map.get(v[0]) || 0) + v[1]);
    }

    const res = [];
    for (const [k, v] of map.entries()) {
        const pair = [];
        pair.push(k);
        pair.push(v);
        res.push(pair);
    }
    res.sort((a, b) => a[0] - b[0]);
    return res;
};
```

```go [sol1-Golang]
func mergeSimilarItems(item1, item2 [][]int) [][]int {
    mp := map[int]int{}
    for _, a := range item1 {
        mp[a[0]] += a[1]
    }
    for _, a := range item2 {
        mp[a[0]] += a[1]
    }
    var ans [][]int
    for a, b := range mp {
        ans = append(ans, []int{a, b})
    }
    sort.Slice(ans, func(i, j int) bool {
        return ans[i][0] < ans[j][0]
    })
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O((n + m)\log (n + m))$，其中 $n$ 是 $\textit{items}_1$ 的长度，$m$ 是 $\textit{items}_2$ 的长度。更新哈希表的时间复杂度为 $O(n + m)$，最后排序的时间复杂度为 $(n + m)\log (n + m)$，所以总的时间复杂度为 $(n + m)\log (n + m)$。如果使用有序容器（例如 $\text{C++}$ 中的 $\text{std::map}$），其插入和查询的时间复杂度为 $O(\log (n + m))$，故总体时间复杂度仍然是 $O((n + m)\log (n + m))$。

- 空间复杂度：$O(n + m)$。哈希表所使用的空间为 $O(n + m)$。如果使用有序容器（例如 $\text{C++}$ 中的 $\text{std::map}$），其内部实现为红黑树，空间复杂度为 $O(n + m)$。
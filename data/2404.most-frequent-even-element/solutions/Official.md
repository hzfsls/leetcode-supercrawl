#### 方法一：哈希表计数

遍历数组 $\textit{nums}$，并且使用哈希表 $\textit{count}$ 记录偶数元素的出现次数。使用 $\textit{res}$ 和 $\textit{ct}$ 分别记录当前出现次数最多的元素值以及对应的出现次数。遍历哈希表中的元素，如果元素的出现次数大于 $\textit{ct}$ 或者出现次数等于 $\textit{ct}$ 且元素值小于 $\textit{res}$，那么用 $\textit{res}$ 记录当前遍历的元素值，并且用 $\textit{ct}$ 记录当前遍历的元素的出现次数。

```C++ [sol1-C++]
class Solution {
public:
    int mostFrequentEven(vector<int>& nums) {
        unordered_map<int, int> count;
        for (auto x : nums) {
            if (x % 2 == 0) {
                count[x]++;
            }
        }
        int res = -1, ct = 0;
        for (auto &p : count) {
            if (res == -1 || p.second > ct || p.second == ct && res > p.first) {
                res = p.first;
                ct = p.second;
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int mostFrequentEven(int[] nums) {
        Map<Integer, Integer> count = new HashMap<Integer, Integer>();
        for (int x : nums) {
            if (x % 2 == 0) {
                count.put(x, count.getOrDefault(x, 0) + 1);
            }
        }
        int res = -1, ct = 0;
        for (Map.Entry<Integer, Integer> entry : count.entrySet()) {
            if (res == -1 || entry.getValue() > ct || entry.getValue() == ct && res > entry.getKey()) {
                res = entry.getKey();
                ct = entry.getValue();
            }
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def mostFrequentEven(self, nums: List[int]) -> int:
        count = Counter()
        for x in nums:
            if x % 2 == 0:
                count[x] += 1
        res, ct = -1, 0
        for k, v in count.items():
            if res == -1 or v > ct or (v == ct and res > k):
                res = k
                ct = v
        return res
```

```C# [sol1-C#]
public class Solution {
    public int MostFrequentEven(int[] nums) {
        IDictionary<int, int> count = new Dictionary<int, int>();
        foreach (int x in nums) {
            if (x % 2 == 0) {
                count.TryAdd(x, 0);
                count[x]++;
            }
        }
        int res = -1, ct = 0;
        foreach (KeyValuePair<int, int> pair in count) {
            if (res == -1 || pair.Value > ct || pair.Value == ct && res > pair.Key) {
                res = pair.Key;
                ct = pair.Value;
            }
        }
        return res;
    }
}
```

```Golang [sol1-Golang]
func mostFrequentEven(nums []int) int {
    count := map[int]int{}
    for _, x := range nums {
        if x % 2 == 0 {
            count[x]++
        }
    }
    res, ct := -1, 0
    for k, v := range count {
        if res == -1 || ct < v || ct == v && k < res {
            res = k
            ct = v
        }
    }
    return res
}
```

```JavaScript [sol1-JavaScript]
var mostFrequentEven = function(nums) {
    let count = new Map();
    for (let x of nums) {
        if (x % 2 == 0) {
            count.set(x, (count.get(x) || 0) + 1);
        }
    }
    let res = -1, ct = 0;
    for (let [k, v] of count) {
        if (res == -1 || v > ct || v == ct && k < res) {
            res = k;
            ct = v;
        }
    }
    return res;
};
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

int mostFrequentEven(int* nums, int numsSize){
    HashItem *count = NULL;
    for (int i = 0; i < numsSize; i++) {
        if (nums[i] % 2 == 0) {
            hashSetItem(&count, nums[i], hashGetItem(&count, nums[i], 0) + 1);
        }
    }
    int res = -1, ct = 0;
    HashItem *pEntry = NULL;
    for (pEntry = count; pEntry != NULL; pEntry = pEntry->hh.next) {
        if (res == -1 || pEntry->val > ct || pEntry->val == ct && res > pEntry->key) {
            res = pEntry->key;
            ct = pEntry->val;
        }
    }
    hashFree(&count);
    return res;
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。遍历数组与哈希表都需要 $O(n)$。

+ 空间复杂度：$O(n)$。保存哈希表需要 $O(n)$。
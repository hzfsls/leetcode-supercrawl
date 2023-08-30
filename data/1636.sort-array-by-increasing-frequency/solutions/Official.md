#### 方法一：模拟

**思路**

按着题目的要求，先算出数组 $\textit{nums}$ 中各元素的频率，然后按照元素频率和数值对数组进行排序即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def frequencySort(self, nums: List[int]) -> List[int]:
        cnt = Counter(nums)
        nums.sort(key=lambda x: (cnt[x], -x))
        return nums
```

```Java [sol1-Java]
class Solution {
    public int[] frequencySort(int[] nums) {
        Map<Integer, Integer> cnt = new HashMap<Integer, Integer>();
        for (int num : nums) {
            cnt.put(num, cnt.getOrDefault(num, 0) + 1);
        }
        List<Integer> list = new ArrayList<Integer>();
        for (int num : nums) {
            list.add(num);
        }
        Collections.sort(list, (a, b) -> {
            int cnt1 = cnt.get(a), cnt2 = cnt.get(b);
            return cnt1 != cnt2 ? cnt1 - cnt2 : b - a;
        });
        int length = nums.length;
        for (int i = 0; i < length; i++) {
            nums[i] = list.get(i);
        }
        return nums;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] FrequencySort(int[] nums) {
        Dictionary<int, int> cnt = new Dictionary<int, int>();
        foreach (int num in nums) {
            cnt.TryAdd(num, 0);
            cnt[num]++;
        }
        List<int> list = new List<int>();
        foreach (int num in nums) {
            list.Add(num);
        }
        list.Sort((a, b) => {
            int cnt1 = cnt[a], cnt2 = cnt[b];
            return cnt1 != cnt2 ? cnt1 - cnt2 : b - a;
        });
        return list.ToArray();
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> frequencySort(vector<int>& nums) {
        unordered_map<int, int> cnt;
        for (int num : nums) {
            cnt[num]++;
        }
        sort(nums.begin(), nums.end(), [&](const int a, const int b) {
            if (cnt[a] != cnt[b]) {
                return cnt[a] < cnt[b];
            }
            return a > b;
        });
        return nums;
    }
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

HashItem *cnt = NULL;

static inline int cmp(const void *pa, const void *pb) {
    int a = *(int *)pa;
    int b = *(int *)pb;
    int cnta = hashGetItem(&cnt, a, 0);
    int cntb = hashGetItem(&cnt, b, 0);
    if (cnta != cntb) {
        return cnta - cntb;
    }
    return b - a;
}

int* frequencySort(int* nums, int numsSize, int* returnSize) {
    cnt = NULL;
    for (int i = 0; i < numsSize; i++) {
        hashSetItem(&cnt, nums[i], hashGetItem(&cnt, nums[i], 0) + 1);
    }
    qsort(nums, numsSize, sizeof(int), cmp);
    hashFree(&cnt);
    *returnSize = numsSize;
    return nums;
}
```

```JavaScript [sol1-JavaScript]
var frequencySort = function(nums) {
    const cnt = new Map();
    for (const num of nums) {
        cnt.set(num, (cnt.get(num) || 0) + 1);
    }
    const list = [...nums];
    list.sort((a, b) => {
        const cnt1 = cnt.get(a), cnt2 = cnt.get(b);
        return cnt1 !== cnt2 ? cnt1 - cnt2 : b - a;
    });
    const length = nums.length;
    for (let i = 0; i < length; i++) {
        nums[i] = list[i];
    }
    return nums;
};
```

```go [sol1-Golang]
func frequencySort(nums []int) []int {
    cnt := map[int]int{}
    for _, x := range nums {
        cnt[x]++
    }
    sort.Slice(nums, func(i, j int) bool {
        a, b := nums[i], nums[j]
        return cnt[a] < cnt[b] || cnt[a] == cnt[b] && a > b
    })
    return nums
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。排序消耗 $O(n \log n)$ 时间。

- 空间复杂度：$O(n)$，存储数组元素频率的哈希表消耗 $O(n)$ 空间。
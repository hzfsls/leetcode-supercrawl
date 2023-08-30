#### 方法一：哈希表

使用哈希表 $\textit{count}$ 记录数 $x$ 出现的次数 $\textit{count}[x]$，$\textit{freq}$ 记录出现次数为 $f$ 的数的数目为 $\textit{freq}[f]$，$\textit{maxFreq}$ 表示最大出现次数。

依次遍历数组，假设当前访问的数为 $\textit{nums}[i]$，对应地更新 $\textit{count}$，$\textit{freq}$ 以及 $\textit{maxFreq}$。以 $\textit{nums}[i]$ 结尾的数组前缀符合要求的充要条件为满足以下三个条件之一：

+ 最大出现次数 $\textit{maxFreq} = 1$：那么所有数的出现次数都是一次，随意删除一个数既可符合要求。

+ 所有数的出现次数都是 $\textit{maxFreq}$ 或 $\textit{maxFreq} - 1$，并且最大出现次数的数只有一个：删除一个最大出现次数的数，那么所有数的出现次数都是 $\textit{maxFreq} - 1$。

+ 除开一个数，其他所有数的出现次数都是 $\textit{maxFreq}$，并且该数的出现次数为 $1$：直接删除出现次数为 $1$ 的数，那么所有数的出现次数都是 $\textit{maxFreq}$。

```Python [sol1-Python3]
class Solution:
    def maxEqualFreq(self, nums: List[int]) -> int:
        freq, count = Counter(), Counter()
        ans = maxFreq = 0
        for i, num in enumerate(nums):
            if count[num]:
                freq[count[num]] -= 1
            count[num] += 1
            maxFreq = max(maxFreq, count[num])
            freq[count[num]] += 1
            if maxFreq == 1 or \
               freq[maxFreq] * maxFreq + freq[maxFreq - 1] * (maxFreq - 1) == i + 1 and freq[maxFreq] == 1 or \
               freq[maxFreq] * maxFreq + 1 == i + 1 and freq[1] == 1:
                ans = max(ans, i + 1)
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int maxEqualFreq(vector<int>& nums) {
        unordered_map<int, int> freq, count;
        int res = 0, maxFreq = 0;
        for (int i = 0; i < nums.size(); i++) {
            if (count[nums[i]] > 0) {
                freq[count[nums[i]]]--;
            }
            count[nums[i]]++;
            maxFreq = max(maxFreq, count[nums[i]]);
            freq[count[nums[i]]]++;
            bool ok = maxFreq == 1 ||
                    freq[maxFreq] * maxFreq + freq[maxFreq - 1] * (maxFreq - 1) == i + 1 && freq[maxFreq] == 1 ||
                    freq[maxFreq] * maxFreq + 1 == i + 1 && freq[1] == 1;
            if (ok) {
                res = max(res, i + 1);
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxEqualFreq(int[] nums) {
        Map<Integer, Integer> freq = new HashMap<Integer, Integer>();
        Map<Integer, Integer> count = new HashMap<Integer, Integer>();
        int res = 0, maxFreq = 0;
        for (int i = 0; i < nums.length; i++) {
            if (count.getOrDefault(nums[i], 0) > 0) {
                freq.put(count.get(nums[i]), freq.get(count.get(nums[i])) - 1);
            }
            count.put(nums[i], count.getOrDefault(nums[i], 0) + 1);
            maxFreq = Math.max(maxFreq, count.get(nums[i]));
            freq.put(count.get(nums[i]), freq.getOrDefault(count.get(nums[i]), 0) + 1);
            boolean ok = maxFreq == 1 ||
                    freq.get(maxFreq) * maxFreq + freq.get(maxFreq - 1) * (maxFreq - 1) == i + 1 && freq.get(maxFreq) == 1 ||
                    freq.get(maxFreq) * maxFreq + 1 == i + 1 && freq.get(1) == 1;
            if (ok) {
                res = Math.max(res, i + 1);
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxEqualFreq(int[] nums) {
        Dictionary<int, int> freq = new Dictionary<int, int>();
        Dictionary<int, int> count = new Dictionary<int, int>();
        int res = 0, maxFreq = 0;
        for (int i = 0; i < nums.Length; i++) {
            if (!count.ContainsKey(nums[i])) {
                count.Add(nums[i], 0);
            }
            if (count[nums[i]] > 0) {
                freq[count[nums[i]]]--;
            }
            count[nums[i]]++;
            maxFreq = Math.Max(maxFreq, count[nums[i]]);
            if (!freq.ContainsKey(count[nums[i]])) {
                freq.Add(count[nums[i]], 0);
            }
            freq[count[nums[i]]]++;
            bool ok = maxFreq == 1 ||
                    freq[maxFreq] * maxFreq + freq[maxFreq - 1] * (maxFreq - 1) == i + 1 && freq[maxFreq] == 1 ||
                    freq[maxFreq] * maxFreq + 1 == i + 1 && freq[1] == 1;
            if (ok) {
                res = Math.Max(res, i + 1);
            }
        }
        return res;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

typedef struct {
    int key;
    int val;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(const HashItem **obj, int key) {
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

int hashGetItem(const HashItem **obj, int key, int defaultVal) {
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

int maxEqualFreq(int* nums, int numsSize) {
    HashItem *freq = NULL, *count = NULL;
    int res = 0, maxFreq = 0;
    for (int i = 0; i < numsSize; i++) {
        int val = hashGetItem(&count, nums[i], 0);
        if (val > 0) {
            hashSetItem(&freq, val, hashGetItem(&freq, val, 0) - 1);
        }
        hashSetItem(&count, nums[i], hashGetItem(&count, nums[i], 0) + 1);
        maxFreq = MAX(maxFreq,  hashGetItem(&count, nums[i], 0));
        val = hashGetItem(&count, nums[i], 0);
        hashSetItem(&freq, val, hashGetItem(&freq, val, 0) + 1);
        int val1 = hashGetItem(&freq, maxFreq, 0);
        int val2 = hashGetItem(&freq, maxFreq - 1, 0);
        int val3 = hashGetItem(&freq, 1, 0);
        bool ok = maxFreq == 1 ||
                val1 * maxFreq + val2 * (maxFreq - 1) == i + 1 && val1 == 1 ||
                val1 * maxFreq + 1 == i + 1 && val3 == 1;
        if (ok) {
            res = MAX(res, i + 1);
        }
    }
    hashFree(&count);
    hashFree(&freq);
    return res;
}
```

```JavaScript [sol1-JavaScript]
var maxEqualFreq = function(nums) {
    const freq = new Map();
    const count = new Map();
    let res = 0, maxFreq = 0;
    for (let i = 0; i < nums.length; i++) {
        if (!count.has(nums[i])) {
            count.set(nums[i], 0);
        }
        if (count.get(nums[i]) > 0) {
            freq.set(count.get(nums[i]), freq.get(count.get(nums[i])) - 1);
        }
        count.set(nums[i], count.get(nums[i]) + 1);
        maxFreq = Math.max(maxFreq, count.get(nums[i]));
        if (!freq.has(count.get(nums[i]))) {
            freq.set(count.get(nums[i]), 0);
        }
        freq.set(count.get(nums[i]), freq.get(count.get(nums[i])) + 1);
        const ok = maxFreq === 1 ||
                freq.get(maxFreq) * maxFreq + freq.get(maxFreq - 1) * (maxFreq - 1) === i + 1 && freq.get(maxFreq) === 1 ||
                freq.get(maxFreq) * maxFreq + 1 === i + 1 && freq.get(1) === 1;
        if (ok) {
            res = Math.max(res, i + 1);
        }
    }
    return res;
};
```

```go [sol1-Golang]
func maxEqualFreq(nums []int) (ans int) {
    freq := map[int]int{}
    count := map[int]int{}
    maxFreq := 0
    for i, num := range nums {
        if count[num] > 0 {
            freq[count[num]]--
        }
        count[num]++
        maxFreq = max(maxFreq, count[num])
        freq[count[num]]++
        if maxFreq == 1 ||
            freq[maxFreq]*maxFreq+freq[maxFreq-1]*(maxFreq-1) == i+1 && freq[maxFreq] == 1 ||
            freq[maxFreq]*maxFreq+1 == i+1 && freq[1] == 1 {
            ans = max(ans, i+1)
        }
    }
    return
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。遍历数组 $\textit{nums}$ 需要 $O(n)$。

+ 空间复杂度：$O(n)$。保存两个哈希表需要 $O(n)$ 的空间。
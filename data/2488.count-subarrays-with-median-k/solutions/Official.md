#### 方法一：前缀和

由于数组 $\textit{nums}$ 的长度是 $n$，数组由从 $1$ 到 $n$ 的不同整数组成，因此数组中的元素各不相同，满足 $1 \le k \le n$ 的正整数 $k$ 在数组中恰好出现一次。

用 $\textit{kIndex}$ 表示正整数 $k$ 在数组 $\textit{nums}$ 中的下标。根据中位数的定义，中位数等于 $k$ 的非空子数组应满足以下条件：

- 子数组的开始下标小于等于 $\textit{kIndex}$ 且结束下标大于等于 $\textit{kIndex}$；

- 子数组中的大于 $k$ 的元素个数与小于 $k$ 的元素个数之差为 $0$ 或 $1$。

为了计算每个子数组中的大于 $k$ 的元素个数与小于 $k$ 的元素个数之差，需要将原始数组做转换，将大于 $k$ 的元素转换成 $1$，小于 $k$ 的元素转换成 $-1$，等于 $k$ 的元素转换成 $0$，转换后的数组中，每个子数组的元素和为对应的原始子数组中的大于 $k$ 的元素个数与小于 $k$ 的元素个数之差。

为了在转换后的数组中寻找符合要求的子数组，可以计算转换后的数组的前缀和，根据前缀和寻找符合要求的子数组。规定空前缀的前缀和是 $0$ 且对应下标 $-1$。如果存在下标 $\textit{left}$ 和 $\textit{right}$ 满足 $-1 \le \textit{left} < \textit{kIndex} \le \textit{right} < n$ 且下标 $\textit{right}$ 处的前缀和与下标 $\textit{left}$ 处的前缀和之差为 $0$ 或 $1$，则等价于下标范围 $[\textit{left} + 1, \textit{right}]$ 包含下标 $\textit{kIndex}$ 且该下标范围的转换后的子数组的元素和为 $0$ 或 $1$，对应该下标范围的原始子数组的中位数等于 $k$。

根据上述分析，可以从左到右遍历数组 $\textit{nums}$，遍历过程中计算转换后的数组的前缀和，并计算中位数等于 $k$ 的非空子数组的数目。

使用哈希表记录转换后的数组的每个前缀和的出现次数。由于空前缀的前缀和是 $0$，因此首先将前缀和 $0$ 与次数 $1$ 存入哈希表。

用 $\textit{sum}$ 表示转换后的数组的前缀和，遍历过程中维护 $\textit{sum}$ 的值。对于 $0 \le i < n$，当遍历到下标 $i$ 时，更新 $\textit{sum}$ 的值，然后执行如下操作：

- 如果 $i < \textit{kIndex}$，则下标 $i + 1$ 可以作为中位数等于 $k$ 的非空子数组的开始下标，将 $\textit{sum}$ 在哈希表中的出现次数加 $1$；

- 如果 $i \ge \textit{kIndex}$，则下标 $i$ 可以作为中位数等于 $k$ 的非空子数组的结束下标，从哈希表中获得前缀和 $\textit{sum}$ 的出现次数 $\textit{prev}_0$ 与前缀和 $\textit{sum} - 1$ 的出现次数 $\textit{prev}_1$，则以下标 $i$ 作为结束下标且中位数等于 $k$ 的非空子数组的数目是 $\textit{prev}_0 + \textit{prev}_1$，将答案增加 $\textit{prev}_0 + \textit{prev}_1$。

遍历结束之后，即可得到中位数等于 $k$ 的非空子数组的数目。

```Python [sol1-Python3]
class Solution:
    def sign(self, num: int) -> int:
        return (num > 0) - (num < 0)

    def countSubarrays(self, nums: List[int], k: int) -> int:
        kIndex = nums.index(k)
        ans = 0
        counts = Counter()
        counts[0] = 1
        sum = 0
        for i, num in enumerate(nums):
            sum += self.sign(num - k)
            if i < kIndex:
                counts[sum] += 1
            else:
                prev0 = counts[sum]
                prev1 = counts[sum - 1]
                ans += prev0 + prev1
        return ans
```

```Java [sol1-Java]
class Solution {
    public int countSubarrays(int[] nums, int k) {
        int n = nums.length;
        int kIndex = -1;
        for (int i = 0; i < n; i++) {
            if (nums[i] == k) {
                kIndex = i;
                break;
            }
        }
        int ans = 0;
        Map<Integer, Integer> counts = new HashMap<Integer, Integer>();
        counts.put(0, 1);
        int sum = 0;
        for (int i = 0; i < n; i++) {
            sum += sign(nums[i] - k);
            if (i < kIndex) {
                counts.put(sum, counts.getOrDefault(sum, 0) + 1);
            } else {
                int prev0 = counts.getOrDefault(sum, 0);
                int prev1 = counts.getOrDefault(sum - 1, 0);
                ans += prev0 + prev1;
            }
        }
        return ans;
    }

    public int sign(int num) {
        if (num == 0) {
            return 0;
        }
        return num > 0 ? 1 : -1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountSubarrays(int[] nums, int k) {
        int n = nums.Length;
        int kIndex = -1;
        for (int i = 0; i < n; i++) {
            if (nums[i] == k) {
                kIndex = i;
                break;
            }
        }
        int ans = 0;
        IDictionary<int, int> counts = new Dictionary<int, int>();
        counts.Add(0, 1);
        int sum = 0;
        for (int i = 0; i < n; i++) {
            sum += sign(nums[i] - k);
            if (i < kIndex) {
                if (!counts.ContainsKey(sum)) {
                    counts.Add(sum, 1);
                } else {
                    counts[sum]++;
                }
            } else {
                int prev0 = counts.ContainsKey(sum) ? counts[sum] : 0;
                int prev1 = counts.ContainsKey(sum - 1) ? counts[sum - 1] : 0;
                ans += prev0 + prev1;
            }
        }
        return ans;
    }

    public int sign(int num) {
        if (num == 0) {
            return 0;
        }
        return num > 0 ? 1 : -1;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    inline int sign(int num) {
        if (num == 0) {
            return 0;
        }
        return num > 0 ? 1 : -1;
    }

    int countSubarrays(vector<int>& nums, int k) {
        int n = nums.size();
        int kIndex = -1;
        for (int i = 0; i < n; i++) {
            if (nums[i] == k) {
                kIndex = i;
                break;
            }
        }
        int ans = 0;
        unordered_map<int, int> counts;
        counts[0] = 1;
        int sum = 0;
        for (int i = 0; i < n; i++) {
            sum += sign(nums[i] - k);
            if (i < kIndex) {
                counts[sum]++;
            } else {
                int prev0 = counts[sum];
                int prev1 = counts[sum - 1];
                ans += prev0 + prev1;
            }
        }
        return ans;
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

static inline int sign(int num) {
    if (num == 0) {
        return 0;
    }
    return num > 0 ? 1 : -1;
}

int countSubarrays(int* nums, int numsSize, int k) {
    int kIndex = -1;
    for (int i = 0; i < numsSize; i++) {
        if (nums[i] == k) {
            kIndex = i;
            break;
        }
    }
    int ans = 0;
    HashItem *counts = NULL;
    hashAddItem(&counts, 0, 1);
    int sum = 0;
    for (int i = 0; i < numsSize; i++) {
        sum += sign(nums[i] - k);
        if (i < kIndex) {
            hashSetItem(&counts, sum, hashGetItem(&counts, sum, 0) + 1);
        } else {
            int prev0 = hashGetItem(&counts, sum, 0);
            int prev1 = hashGetItem(&counts, sum - 1, 0);
            ans += prev0 + prev1;
        }
    }
    hashFree(&counts);
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var countSubarrays = function(nums, k) {
    const n = nums.length;
    let kIndex = -1;
    for (let i = 0; i < n; i++) {
        if (nums[i] === k) {
            kIndex = i;
            break;
        }
    }
    let ans = 0;
    const counts = new Map();
    counts.set(0, 1);
    let sum = 0;
    for (let i = 0; i < n; i++) {
        sum += sign(nums[i] - k);
        if (i < kIndex) {
            counts.set(sum, (counts.get(sum) || 0) + 1);
        } else {
            const prev0 = (counts.get(sum) || 0);
            const prev1 = (counts.get(sum - 1) || 0);
            ans += prev0 + prev1;
        }
    }
    return ans;
}

const sign = (num) => {
    if (num === 0) {
        return 0;
    }
    return num > 0 ? 1 : -1;
};
```

```go [sol1-Golang]
func countSubarrays(nums []int, k int) int {
    kIndex := -1
    for i, num := range nums {
        if num == k {
            kIndex = i
            break
        }
    }
    ans := 0
    counts := map[int]int{}
    counts[0] = 1
    sum := 0
    for i, num := range nums {
        sum += sign(num - k)
        if i < kIndex {
            counts[sum]++
        } else {
            prev0 := counts[sum]
            prev1 := counts[sum-1]
            ans += prev0 + prev1
        }
    }
    return ans
}

func sign(num int) int {
    if num == 0 {
        return 0
    }
    if num > 0 {
        return 1
    }
    return -1
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。遍历数组寻找正整数 $k$ 所在下标需要 $O(n)$ 的时间，遍历数组计算中位数等于 $k$ 的非空子数组数目需要 $O(n)$ 的时间。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。哈希表需要 $O(n)$ 的空间。
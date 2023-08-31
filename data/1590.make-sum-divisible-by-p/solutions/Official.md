## [1590.使数组和能被 P 整除 中文官方题解](https://leetcode.cn/problems/make-sum-divisible-by-p/solutions/100000/shi-shu-zu-he-neng-bei-p-zheng-chu-by-le-dob9)
#### 方法一：前缀和

> 定理一：给定正整数 $x$、$y$、$z$、$p$，如果 $y \bmod p = x$，那么 $(y - z) \bmod p = 0$ 等价于 $z \bmod p = x$。
>
> 证明：$y \bmod p = x$ 等价于 $y = k_1 \times p + x$，$(y-z) \bmod p = 0$ 等价于 $y - z = k_2 \times p$，$z \bmod p = x$ 等价于 $z = k_3 \times p + x$，其中 $k_1$、$k_2$、$k_3$ 都是整数，那么给定 $y = k_1 \times p + x$，有 $y - z = k_2 \times p \leftrightarrow z = (k_1 - k_2) \times p + x \leftrightarrow z = k_3 \times p + x$。

> 定理二：给定正整数 $x$，$y$，$z$，$p$，那么 $(y - z) \bmod p = x$ 等价于 $z \bmod p = (y - x) \bmod p$。
>
> 证明：$(y - z) \bmod p = x$ 等价于 $y - z = k_1 \times p + x$，其中 $k_1$ 是整数，经过变换有 $z = y - k_1 \times p - x = k_2 \times p + (y - x) \bmod p - k_1 \times p = (k_2 - k_1) \times p + (y - x) \bmod p$，等价于 $z \bmod p = (y - x) \bmod p$。

记数组和除以 $p$ 的余数为 $x$，如果 $x=0$ 成立，那么需要移除的最短子数组长度为 $0$。

记前 $i$ 个元素（不包括第 $i$ 个元素）的和为 $\textit{f}_i$，我们考虑最右元素为 $\textit{nums}[i]$ 的所有子数组，假设最左元素为 $\textit{nums}[j]~(0 \le j \le i)$，那么对应的子数组和为 $\textit{f}_{i+1}-\textit{f}_j$，对应的长度为 $i-j+1$。由定理一可知，如果剩余子数组和能被 $p$ 整除，那么 $(\textit{f}_{i+1}-\textit{f}_j) \bmod p = x$。同时由定理二可知，$\textit{f}_j \bmod p = (\textit{f}_{i+1} - x) \bmod p$。因此当 $\textit{f}_{i+1}$ 已知时，我们需要找到所有满足 $\textit{f}_j \bmod p = (\textit{f}_{i+1} - x) \bmod p$ 的 $\textit{f}_j$（$0 \le j \le i$），从中找到最短子数组。

由于需要移除最短子数组，因此对于所有 $f_j$（$0 \le j \le i$），只需要保存 $f_j \bmod p$ 对应的最大下标。

> 有些编程语言对负数进行取余时，余数为负数，因此计算 $f_{i+1} - x$ 除以 $p$ 的余数时，使用 $f_{i+1} - x + p$ 替代。

```Python [sol1-Python3]
class Solution:
    def minSubarray(self, nums: List[int], p: int) -> int:
        x = sum(nums) % p
        if x == 0:
            return 0
        y = 0
        index = {0: -1}
        ans = len(nums)
        for i, v in enumerate(nums):
            y = (y + v) % p
            if (y - x) % p in index:
                ans = min(ans, i - index[(y - x) % p])
            index[y] = i
        return ans if ans < len(nums) else -1
```

```C++ [sol1-C++]
class Solution {
public:
    int minSubarray(vector<int>& nums, int p) {
        int x = 0;
        for (auto num : nums) {
            x = (x + num) % p;
        }
        if (x == 0) {
            return 0;
        }
        unordered_map<int, int> index;
        int y = 0, res = nums.size();
        for (int i = 0; i < nums.size(); i++) {
            index[y] = i; // f[i] mod p = y，因此哈希表记录 y 对应的下标为 i
            y = (y + nums[i]) % p;
            if (index.count((y - x + p) % p) > 0) {
                res = min(res, i - index[(y - x + p) % p] + 1);
            }
        }
        return res == nums.size() ? -1 : res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minSubarray(int[] nums, int p) {
        int x = 0;
        for (int num : nums) {
            x = (x + num) % p;
        }
        if (x == 0) {
            return 0;
        }
        Map<Integer, Integer> index = new HashMap<Integer, Integer>();
        int y = 0, res = nums.length;
        for (int i = 0; i < nums.length; i++) {
            index.put(y, i); // f[i] mod p = y，因此哈希表记录 y 对应的下标为 i
            y = (y + nums[i]) % p;
            if (index.containsKey((y - x + p) % p)) {
                res = Math.min(res, i - index.get((y - x + p) % p) + 1);
            }
        }
        return res == nums.length ? -1 : res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinSubarray(int[] nums, int p) {
        int x = 0;
        foreach (int num in nums) {
            x = (x + num) % p;
        }
        if (x == 0) {
            return 0;
        }
        IDictionary<int, int> index = new Dictionary<int, int>();
        int y = 0, res = nums.Length;
        for (int i = 0; i < nums.Length; i++) {
            // f[i] mod p = y，因此哈希表记录 y 对应的下标为 i
            if (!index.ContainsKey(y)) {
                index.Add(y, i);
            } else {
                index[y] = i;
            }
            y = (y + nums[i]) % p;
            if (index.ContainsKey((y - x + p) % p)) {
                res = Math.Min(res, i - index[(y - x + p) % p] + 1);
            }
        }
        return res == nums.Length ? -1 : res;
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

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

int minSubarray(int* nums, int numsSize, int p) {
     int x = 0;
    for (int i = 0; i < numsSize; i++) {
        x = (x + nums[i]) % p;
    }
    if (x == 0) {
        return 0;
    }
    HashItem *index = NULL;
    int y = 0, res = numsSize;
    for (int i = 0; i < numsSize; i++) {
        hashSetItem(&index, y, i); // f[i] mod p = y，因此哈希表记录 y 对应的下标为 i
        y = (y + nums[i]) % p;
        if (hashFindItem(&index, (y - x + p) % p)) {
            int val = hashGetItem(&index, (y - x + p) % p, 0);
            res = MIN(res, i - val + 1);
        }
    }
    hashFree(&index);
    return res == numsSize ? -1 : res;
}
```

```JavaScript [sol1-JavaScript]
var minSubarray = function(nums, p) {
    let x = 0;
    for (const num of nums) {
        x = (x + num) % p;
    }
    if (x === 0) {
        return 0;
    }
    const index = new Map();
    let y = 0, res = nums.length;
    for (let i = 0; i < nums.length; i++) {
        index.set(y, i); // f[i] mod p = y，因此哈希表记录 y 对应的下标为 i
        y = (y + nums[i]) % p;
        if (index.has((y - x + p) % p)) {
            res = Math.min(res, i - index.get((y - x + p) % p) + 1);
        }
    }
    return res === nums.length ? -1 : res;
};
```

```go [sol1-Golang]
func minSubarray(nums []int, p int) int {
    sum := 0
    mp := map[int]int{0: -1}
    for _, v := range nums {
        sum += v
    }
    rem := sum%p
    if rem == 0 {
        return 0
    }
    minCount := len(nums)
    sum = 0
    for i := 0; i < len(nums); i++ {
        sum += nums[i]
        tempRem := sum%p
        k := (tempRem - rem + p) % p
        if _, ok := mp[k]; ok {
            minCount = min(minCount, i - mp[k])
        }
        mp[tempRem] = i
    }
    
    if minCount >= len(nums) {
        return -1
    }
    
    return minCount
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。遍历数组 $\textit{nums}$ 需要 $O(n)$ 的时间。

+ 空间复杂度：$O(n)$。保存哈希表需要 $O(n)$ 的空间。
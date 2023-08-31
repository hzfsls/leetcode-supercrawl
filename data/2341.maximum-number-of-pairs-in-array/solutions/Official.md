## [2341.数组能形成多少数对 中文官方题解](https://leetcode.cn/problems/maximum-number-of-pairs-in-array/solutions/100000/shu-zu-neng-xing-cheng-duo-shao-shu-dui-jq01j)

#### 方法一：哈希表

**思路**

遍历一次数组，用一个哈希表保存元素个数的奇偶性，偶数为 $\text{false}$，奇数则为 $\text{true}$。每遇到一个元素，则将奇偶性取反，若取反完后为偶数个，则表明在上次偶数个之后又遇到了两个该元素，可以形成一个数对。最后返回一个数组，第一个元素是数对数，第二个元素是数组长度减去数对数的两倍。

**代码**

```Python [sol1-Python3]
class Solution:
    def numberOfPairs(self, nums: List[int]) -> List[int]:
        cnt = defaultdict(bool)
        res = 0
        for num in nums:
            cnt[num] = not cnt[num]
            if not cnt[num]:
                res += 1
        return [res, len(nums) - 2 * res]
```

```Java [sol1-Java]
class Solution {
    public int[] numberOfPairs(int[] nums) {
        Map<Integer, Boolean> cnt = new HashMap<Integer, Boolean>();
        int res = 0;
        for (int num : nums) {
            cnt.put(num, !cnt.getOrDefault(num, false));
            if (!cnt.get(num)) {
                res++;
            }
        }
        return new int[]{res, nums.length - 2 * res};
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] NumberOfPairs(int[] nums) {
        IDictionary<int, bool> cnt = new Dictionary<int, bool>();
        int res = 0;
        foreach (int num in nums) {
            if (cnt.ContainsKey(num)) {
                cnt[num] = !cnt[num];
            } else {
                cnt.Add(num, true);
            }
            if (!cnt[num]) {
                res++;
            }
        }
        return new int[]{res, nums.Length - 2 * res};
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> numberOfPairs(vector<int>& nums) {
        unordered_map<int, bool> cnt;
        int res = 0;
        for (int num : nums) {
            if (cnt.count(num)) {
                cnt[num] = !cnt[num];
            } else {
                cnt[num] = true;
            }
            if (!cnt[num]) {
                res++;
            }
        }
        return {res, (int)nums.size() - 2 * res};
    }
};
```

```C [sol1-C]
typedef struct {
    int key;
    bool val;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key, bool val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

bool hashSetItem(HashItem **obj, int key, bool val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        hashAddItem(obj, key, val);
    } else {
        pEntry->val = val;
    }
    return true;
}

bool hashGetItem(HashItem **obj, int key, bool defaultVal) {
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

int* numberOfPairs(int* nums, int numsSize, int* returnSize) {
    HashItem *cnt = NULL;
    int res = 0;
    for (int i = 0; i < numsSize; i++) {
        if (hashFindItem(&cnt, nums[i])) {
            hashSetItem(&cnt, nums[i], !hashGetItem(&cnt, nums[i], false));
        } else {
            hashAddItem(&cnt, nums[i], true);
        }
        if (!hashGetItem(&cnt, nums[i], false)) {
            res++;
        }
    }
    hashFree(&cnt);
    int *ans = (int *)malloc(sizeof(int) * 2);
    ans[0] = res;
    ans[1] = numsSize - 2 * res;
    *returnSize = 2;
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var numberOfPairs = function(nums) {
    const cnt = new Map();
    let res = 0;
    for (const num of nums) {
        cnt.set(num, !(cnt.get(num) || false));
        if (!cnt.get(num)) {
            res++;
        }
    }
    return [res, nums.length - 2 * res];
};
```

```go [sol1-Golang]
func numberOfPairs(nums []int) []int {
    cnt := map[int]bool{}
    res := 0
    for _, num := range nums {
        cnt[num] = !cnt[num]
        if !cnt[num] {
            res++
        }
    }
    return []int{res, len(nums) - 2*res}
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组的长度。需要遍历一次数组。

- 空间复杂度：$O(n)$。哈希表中最多保存 $n$ 个元素。
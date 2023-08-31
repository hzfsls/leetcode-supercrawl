## [219.存在重复元素 II 中文官方题解](https://leetcode.cn/problems/contains-duplicate-ii/solutions/100000/cun-zai-zhong-fu-yuan-su-ii-by-leetcode-kluvk)

#### 方法一：哈希表

从左到右遍历数组 $\textit{nums}$，当遍历到下标 $i$ 时，如果存在下标 $j < i$ 使得 $\textit{nums}[i] = \textit{nums}[j]$，则当 $i - j \le k$ 时即找到了两个符合要求的下标 $j$ 和 $i$。

如果在下标 $i$ 之前存在多个元素都和 $\textit{nums}[i]$ 相等，为了判断是否存在满足 $\textit{nums}[i] = \textit{nums}[j]$ 且 $i - j \le k$ 的下标 $j$，应该在这些元素中寻找下标最大的元素，将最大下标记为 $j$，判断 $i - j \le k$ 是否成立。

如果 $i - j \le k$，则找到了两个符合要求的下标 $j$ 和 $i$；如果 $i - j > k$，则在下标 $i$ 之前不存在任何元素满足与 $\textit{nums}[i]$ 相等且下标差的绝对值不超过 $k$，理由如下。

> 假设存在下标 $j'$ 满足 $j' < j < i$ 且 $\textit{nums}[j'] = \textit{nums}[j] = \textit{nums}[i]$，则 $i - j' > i - j$，由于 $i - j > k$，因此必有 $i - j' > k$。

因此，当遍历到下标 $i$ 时，如果在下标 $i$ 之前存在与 $\textit{nums}[i]$ 相等的元素，应该在这些元素中寻找最大的下标 $j$，判断 $i - j \le k$ 是否成立。

可以使用哈希表记录每个元素的最大下标。从左到右遍历数组 $\textit{nums}$，当遍历到下标 $i$ 时，进行如下操作：

1. 如果哈希表中已经存在和 $\textit{nums}[i]$ 相等的元素且该元素在哈希表中记录的下标 $j$ 满足 $i - j \le k$，返回 $\text{true}$；

2. 将 $\textit{nums}[i]$ 和下标 $i$ 存入哈希表，此时 $i$ 是 $\textit{nums}[i]$ 的最大下标。

上述两步操作的顺序不能改变，因为当遍历到下标 $i$ 时，只能在下标 $i$ 之前的元素中寻找与当前元素相等的元素及该元素的最大下标。

当遍历结束时，如果没有遇到两个相等元素的下标差的绝对值不超过 $k$，返回 $\text{false}$。

```Java [sol1-Java]
class Solution {
    public boolean containsNearbyDuplicate(int[] nums, int k) {
        Map<Integer, Integer> map = new HashMap<Integer, Integer>();
        int length = nums.length;
        for (int i = 0; i < length; i++) {
            int num = nums[i];
            if (map.containsKey(num) && i - map.get(num) <= k) {
                return true;
            }
            map.put(num, i);
        }
        return false;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool ContainsNearbyDuplicate(int[] nums, int k) {
        Dictionary<int, int> dictionary = new Dictionary<int, int>();
        int length = nums.Length;
        for (int i = 0; i < length; i++) {
            int num = nums[i];
            if (dictionary.ContainsKey(num) && i - dictionary[num] <= k) {
                return true;
            }
            if (dictionary.ContainsKey(num)) {
                dictionary[num] = i;
            } else {
                dictionary.Add(num, i);
            }
        }
        return false;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool containsNearbyDuplicate(vector<int>& nums, int k) {
        unordered_map<int, int> dictionary;
        int length = nums.size();
        for (int i = 0; i < length; i++) {
            int num = nums[i];
            if (dictionary.count(num) && i - dictionary[num] <= k) {
                return true;
            }
            dictionary[num] = i;
        }
        return false;
    }
};
```

```C [sol1-C]
struct HashEntry {
    int key;                  
    int val;
    UT_hash_handle hh;         
};

void hashAddItem(struct HashEntry **obj, int key, int val) {
    struct HashEntry *pEntry;
    pEntry = malloc(sizeof(struct HashEntry));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_INT(*obj, key, pEntry);
} 

struct HashEntry *hashFindItem(const struct HashEntry **obj, int key)
{
    struct HashEntry *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

void hashFreeAll(struct HashEntry **obj)
{
    struct HashEntry *curr, *next;
    HASH_ITER(hh, *obj, curr, next)
    {
        HASH_DEL(*obj,curr);  
        free(curr);      
    }
}

bool containsNearbyDuplicate(int* nums, int numsSize, int k){
    struct HashEntry *dictionary = NULL;
    for (int i = 0; i < numsSize; i++) {
        struct HashEntry * pEntry = hashFindItem(&dictionary, nums[i]);
        if (NULL != pEntry && i - pEntry->val <= k) {
            hashFreeAll(&dictionary);
            return true;
        }
        hashAddItem(&dictionary, nums[i], i);
    }
    hashFreeAll(&dictionary);
    return false;
}
```

```Python [sol1-Python3]
class Solution:
    def containsNearbyDuplicate(self, nums: List[int], k: int) -> bool:
        pos = {}
        for i, num in enumerate(nums):
            if num in pos and i - pos[num] <= k:
                return True
            pos[num] = i
        return False
```

```go [sol1-Golang]
func containsNearbyDuplicate(nums []int, k int) bool {
    pos := map[int]int{}
    for i, num := range nums {
        if p, ok := pos[num]; ok && i-p <= k {
            return true
        }
        pos[num] = i
    }
    return false
}
```

```JavaScript [sol1-JavaScript]
var containsNearbyDuplicate = function(nums, k) {
    const map = new Map();
    const length = nums.length;
    for (let i = 0; i < length; i++) {
        const num = nums[i];
        if (map.has(num) && i - map.get(num) <= k) {
            return true;
        }
        map.set(num, i);
    }
    return false;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要遍历数组一次，对于每个元素，哈希表的操作时间都是 $O(1)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要使用哈希表记录每个元素的最大下标，哈希表中的元素个数不会超过 $n$。

#### 方法二：滑动窗口

考虑数组 $\textit{nums}$ 中的每个长度不超过 $k + 1$ 的滑动窗口，同一个滑动窗口中的任意两个下标差的绝对值不超过 $k$。如果存在一个滑动窗口，其中有重复元素，则存在两个不同的下标 $i$ 和 $j$ 满足 $\textit{nums}[i] = \textit{nums}[j]$ 且 $|i - j| \le k$。如果所有滑动窗口中都没有重复元素，则不存在符合要求的下标。因此，只要遍历每个滑动窗口，判断滑动窗口中是否有重复元素即可。

如果一个滑动窗口的结束下标是 $i$，则该滑动窗口的开始下标是 $\max(0, i - k)$。可以使用哈希集合存储滑动窗口中的元素。从左到右遍历数组 $\textit{nums}$，当遍历到下标 $i$ 时，具体操作如下：

1. 如果 $i > k$，则下标 $i - k - 1$ 处的元素被移出滑动窗口，因此将 $\textit{nums}[i - k - 1]$ 从哈希集合中删除；

2. 判断 $\textit{nums}[i]$ 是否在哈希集合中，如果在哈希集合中则在同一个滑动窗口中有重复元素，返回 $\text{true}$，如果不在哈希集合中则将其加入哈希集合。

当遍历结束时，如果所有滑动窗口中都没有重复元素，返回 $\text{false}$。

```Java [sol2-Java]
class Solution {
    public boolean containsNearbyDuplicate(int[] nums, int k) {
        Set<Integer> set = new HashSet<Integer>();
        int length = nums.length;
        for (int i = 0; i < length; i++) {
            if (i > k) {
                set.remove(nums[i - k - 1]);
            }
            if (!set.add(nums[i])) {
                return true;
            }
        }
        return false;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool ContainsNearbyDuplicate(int[] nums, int k) {
        ISet<int> set = new HashSet<int>();
        int length = nums.Length;
        for (int i = 0; i < length; i++) {
            if (i > k) {
                set.Remove(nums[i - k - 1]);
            }
            if (!set.Add(nums[i])) {
                return true;
            }
        }
        return false;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    bool containsNearbyDuplicate(vector<int>& nums, int k) {
        unordered_set<int> s;
        int length = nums.size();
        for (int i = 0; i < length; i++) {
            if (i > k) {
                s.erase(nums[i - k - 1]);
            }
            if (s.count(nums[i])) {
                return true;
            }
            s.emplace(nums[i]);
        }
        return false;
    }
};
```

```C [sol2-C]
struct HashEntry {
    int key;                  
    int val;
    UT_hash_handle hh;         
};

void hashAddItem(struct HashEntry **obj, int key, int val) {
    struct HashEntry *pEntry;
    pEntry = malloc(sizeof(struct HashEntry));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_INT(*obj, key, pEntry);
} 

struct HashEntry *hashFindItem(const struct HashEntry **obj, int key)
{
    struct HashEntry *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

void hashEraseItem(struct HashEntry **obj, int key)
{   
    struct HashEntry *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    if (NULL != pEntry) {
        HASH_DEL(*obj, pEntry);
        free(pEntry);
    } 
}

void hashFreeAll(struct HashEntry **obj)
{
    struct HashEntry *curr, *next;
    HASH_ITER(hh, *obj, curr, next)
    {
        HASH_DEL(*obj,curr);  
        free(curr);      
    }
}

bool containsNearbyDuplicate(int* nums, int numsSize, int k){
    struct HashEntry *cnt = NULL;
    for (int i = 0; i < numsSize; i++) {
        if (i > k) {
            hashEraseItem(&cnt, nums[i - k - 1]);
        }
        struct HashEntry * pEntry = hashFindItem(&cnt, nums[i]);
        if (NULL != pEntry) {
            return true;
        }
        hashAddItem(&cnt, nums[i], 1);
    }
    hashFreeAll(&cnt);
    return false;
}
```

```Python [sol2-Python3]
class Solution:
    def containsNearbyDuplicate(self, nums: List[int], k: int) -> bool:
        s = set()
        for i, num in enumerate(nums):
            if i > k:
                s.remove(nums[i - k - 1])
            if num in s:
                return True
            s.add(num)
        return False
```

```go [sol2-Golang]
func containsNearbyDuplicate(nums []int, k int) bool {
    set := map[int]struct{}{}
    for i, num := range nums {
        if i > k {
            delete(set, nums[i-k-1])
        }
        if _, ok := set[num]; ok {
            return true
        }
        set[num] = struct{}{}
    }
    return false
}
```

```JavaScript [sol2-JavaScript]
var containsNearbyDuplicate = function(nums, k) {
    const set = new Set();
    const length = nums.length;
    for (let i = 0; i < length; i++) {
        if (i > k) {
            set.delete(nums[i - k - 1]);
        }
        if (set.has(nums[i])) {
            return true;
        }
        set.add(nums[i])
    }
    return false;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要遍历数组一次，对于每个元素，哈希集合的操作时间都是 $O(1)$。

- 空间复杂度：$O(k)$，其中 $k$ 是判断重复元素时允许的下标差的绝对值的最大值。需要使用哈希集合存储滑动窗口中的元素，任意时刻滑动窗口中的元素个数最多为 $k + 1$ 个。
## [2006.差的绝对值为 K 的数对数目 中文官方题解](https://leetcode.cn/problems/count-number-of-pairs-with-absolute-difference-k/solutions/100000/chai-de-jue-dui-zhi-wei-k-de-shu-dui-shu-xspo)

#### 方法一：暴力

**思路**

我们可以使用两层循环，一层遍历 $i$，一层遍历 $j$，对每个 $(i，j)$ 的组合，判断差的绝对值是否为 $k$，统计所有符合条件的数对。

**代码**

```Python [sol1-Python3]
class Solution:
    def countKDifference(self, nums: List[int], k: int) -> int:
        res, n = 0, len(nums)
        for i in range(n):
            for j in range(i + 1, n):
                if abs(nums[i] - nums[j]) == k:
                    res += 1
        return res
```

```Java [sol1-Java]
class Solution {
    public int countKDifference(int[] nums, int k) {
        int res = 0, n = nums.length;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                if (Math.abs(nums[i] - nums[j]) == k) {
                    ++res;
                }
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountKDifference(int[] nums, int k) {
        int res = 0, n = nums.Length;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                if (Math.Abs(nums[i] - nums[j]) == k) {
                    ++res;
                }
            }
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int countKDifference(vector<int>& nums, int k) {
        int res = 0, n = nums.size();
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                if (abs(nums[i] - nums[j]) == k) {
                    ++res;
                }
            }
        }
        return res;
    }
};
```

```C [sol1-C]
int countKDifference(int* nums, int numsSize, int k){
    int res = 0;
    for (int i = 0; i < numsSize; ++i) {
        for (int j = i + 1; j < numsSize; ++j) {
            if (abs(nums[i] - nums[j]) == k) {
                ++res;
            }
        }
    }
    return res;
}
```

```go [sol1-Golang]
func countKDifference(nums []int, k int) (ans int) {
    for j, x := range nums {
        for _, y := range nums[:j] {
            if abs(x-y) == k {
                ans++
            }
        }
    }
    return
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

```JavaScript [sol1-JavaScript]
var countKDifference = function(nums, k) {
    let res = 0, n = nums.length;
    for (let i = 0; i < n; ++i) {
        for (let j = i + 1; j < n; ++j) {
            if (Math.abs(nums[i] - nums[j]) == k) {
                ++res;
            }
        }
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。我们使用了两层循环来寻找所有符合条件的数对。

- 空间复杂度：$O(1)$。我们仅使用常数空间。

#### 方法二：哈希表 + 一次遍历

**思路**

我们进行一次遍历，遍历时下标代表 $j$。对每一个 $j$，我们需要知道在这个 $j$ 之前的符合条件的 $i$ 的个数，即满足 $|\texttt{nums}[i] - \texttt{nums}[j]| = k$ 的 $i$ 的个数，亦即满足 $\texttt{nums}[i] = \texttt{nums}[j] + k$ 或 $\texttt{nums}[i] = \texttt{nums}[j] - k$ 的 $i$ 的个数。使用哈希表可以在 $O(1)$ 的时间内统计出这样的个数，因此在遍历时我们可以使用一个哈希表来维护不同数值的频率，并统计符合条件的数对总数。

**代码**

```Python [sol2-Python3]
class Solution:
    def countKDifference(self, nums: List[int], k: int) -> int:
        res = 0
        cnt = Counter()
        for num in nums:
            res += cnt[num - k] + cnt[num + k]
            cnt[num] += 1
        return res
```

```Java [sol2-Java]
class Solution {
    public int countKDifference(int[] nums, int k) {
        int res = 0, n = nums.length;
        Map<Integer, Integer> cnt = new HashMap<Integer, Integer>();
        for (int j = 0; j < n; ++j) {
            res += cnt.getOrDefault(nums[j] - k, 0) + cnt.getOrDefault(nums[j] + k, 0);
            cnt.put(nums[j], cnt.getOrDefault(nums[j], 0) + 1);
        }
        return res;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int CountKDifference(int[] nums, int k) {
        int res = 0, n = nums.Length;
        Dictionary<int, int> cnt = new Dictionary<int, int>();
        for (int j = 0; j < n; ++j) {
            res += (cnt.ContainsKey(nums[j] - k) ? cnt[nums[j] - k] : 0) + (cnt.ContainsKey(nums[j] + k) ? cnt[nums[j] + k] : 0);
            if (!cnt.ContainsKey(nums[j])) {
                cnt.Add(nums[j], 0);
            }
            ++cnt[nums[j]];
        }
        return res;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int countKDifference(vector<int>& nums, int k) {
        int res = 0, n = nums.size();
        unordered_map<int, int> cnt;
        for (int j = 0; j < n; ++j) {
            res += (cnt.count(nums[j] - k) ? cnt[nums[j] - k] : 0);
            res += (cnt.count(nums[j] + k) ? cnt[nums[j] + k] : 0);
            ++cnt[nums[j]];
        }
        return res;
    }
};
```

```C [sol2-C]
typedef struct  {
    int key;            
    int val;
    UT_hash_handle hh;
} HashEntry;

int countKDifference(int* nums, int numsSize, int k){
    int res = 0;
    HashEntry * cnt = NULL;
    for (int j = 0; j < numsSize; ++j) {
        HashEntry * pEntry = NULL;
        int curr = nums[j] - k;
        HASH_FIND_INT(cnt, &curr, pEntry);
        if (NULL != pEntry) {
            res += pEntry->val;
        }
        curr = nums[j] + k;
        HASH_FIND_INT(cnt, &curr, pEntry);
        if (NULL != pEntry) {
            res += pEntry->val;
        }
        HASH_FIND_INT(cnt, &nums[j], pEntry);
        if (NULL == pEntry) {
            pEntry = (HashEntry *)malloc(sizeof(HashEntry));
            pEntry->key = nums[j];
            pEntry->val = 1;
            HASH_ADD_INT(cnt, key, pEntry);
        } else {
            ++pEntry->val;
        }
    }
    HashEntry * curr = NULL, * next = NULL;
    HASH_ITER(hh, cnt, curr, next) {
        HASH_DEL(cnt, curr);
    }
    return res;
}
```

```go [sol2-Golang]
func countKDifference(nums []int, k int) (ans int) {
    cnt := map[int]int{}
    for _, num := range nums {
        ans += cnt[num-k] + cnt[num+k]
        cnt[num]++
    }
    return
}
```

```JavaScript [sol2-JavaScript]
var countKDifference = function(nums, k) {
    let res = 0, n = nums.length;
    const cnt = new Map();
    for (let j = 0; j < n; ++j) {
        res += (cnt.get(nums[j] - k) || 0) + (cnt.get(nums[j] + k) || 0);
        cnt.set(nums[j], (cnt.get(nums[j]) || 0) + 1);
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。我们仅使用了一次遍历来寻找所有符合条件的数对。

- 空间复杂度：$O(n)$。哈希表消耗了 $O(n)$ 的空间。
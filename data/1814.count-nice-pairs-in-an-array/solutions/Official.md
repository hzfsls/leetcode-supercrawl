## [1814.统计一个数组中好对子的数目 中文官方题解](https://leetcode.cn/problems/count-nice-pairs-in-an-array/solutions/100000/tong-ji-yi-ge-shu-zu-zhong-hao-dui-zi-de-ywux)

#### 方法一：哈希表

**思路与算法**

首先题目给出一个下标从 $0$ 开始长度为 $n$ 的非负整数数组 $\textit{nums}$，并给出「好下标对」的定义——对于某一个下标对 $(i, j)$，$0 \le i < j < n$，若满足：

$$\textit{nums}[i] + \textit{rev}(\textit{nums}[j]) = \textit{nums}[j] + \textit{rev}(\textit{nums}[i]) \tag{1}$$

则该下标对为「好下标对」。现在我们设：$f(i) = \textit{nums}[i] - \textit{rev}(\textit{nums}[i])$，则表达式 $(1)$ 可以等价于：

$$f(i) = f(j) \tag{2}$$

那么我们从左到右遍历数组 $\textit{nums}$，并在遍历的过程用「哈希表」统计每一个位置 $i$，$0 \le i < n$ 的 $f(i)$ 的个数，则对于位置 $j$，$0 \le j < n$，以 $j$ 结尾的「好下标对」的个数为此时「哈希表」中 $f(j)$ 的数目。那么我们只需要在遍历时同时统计以每一个位置为结尾的「好下标对」数目即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def countNicePairs(self, nums: List[int]) -> int:
        res = 0
        cnt = Counter()
        for i in nums:
            j = int(str(i)[::-1])
            res += cnt[i - j]
            cnt[i - j] += 1
        return res % (10 ** 9 + 7)
```

```Java [sol1-Java]
class Solution {
    public int countNicePairs(int[] nums) {
        final int MOD = 1000000007;
        int res = 0;
        Map<Integer, Integer> h = new HashMap<Integer, Integer>();
        for (int i : nums) {
            int temp = i, j = 0;
            while (temp > 0) {
                j = j * 10 + temp % 10;
                temp /= 10;
            }
            res = (res + h.getOrDefault(i - j, 0)) % MOD;
            h.put(i - j, h.getOrDefault(i - j, 0) + 1);
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountNicePairs(int[] nums) {
        const int MOD = 1000000007;
        int res = 0;
        IDictionary<int, int> h = new Dictionary<int, int>();
        foreach (int i in nums) {
            int temp = i, j = 0;
            while (temp > 0) {
                j = j * 10 + temp % 10;
                temp /= 10;
            }
            h.TryAdd(i - j, 0);
            res = (res + h[i - j]) % MOD;
            h[i - j]++;
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int countNicePairs(vector<int>& nums) {
        const int MOD = 1000000007;
        int res = 0;
        unordered_map<int, int> h;
        for (int i : nums) {
            int temp = i, j = 0;
            while (temp > 0) {
                j = j * 10 + temp % 10;
                temp /= 10;
            }
            res = (res + h[i - j]) % MOD;
            h[i - j]++;
        }
        return res;
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

int countNicePairs(int* nums, int numsSize) {
    const int MOD = 1000000007;
    int res = 0;
    HashItem *h = NULL;
    for (int i = 0; i < numsSize; i++) {
        int temp = nums[i], j = 0;
        while (temp > 0) {
            j = j * 10 + temp % 10;
            temp /= 10;
        }
        int val = hashGetItem(&h, nums[i] - j, 0);
        res = (res + val) % MOD;
        hashSetItem(&h, nums[i] - j, val + 1);
    }
    hashFree(&h);
    return res;
}
```

```JavaScript [sol1-JavaScript]
var countNicePairs = function(nums) {
    const MOD = 1000000007;
    let res = 0;
    const h = new Map();
    for (const i of nums) {
        let temp = i, j = 0;
        while (temp > 0) {
            j = j * 10 + temp % 10;
            temp = Math.floor(temp / 10);
        }
        res = (res + (h.get(i - j) || 0)) % MOD;
        h.set(i - j, (h.get(i - j) || 0) + 1);
    }
    return res;
};
```

```go [sol1-Golang]
func countNicePairs(nums []int) (ans int) {
    cnt := map[int]int{}
    for _, num := range nums {
        rev := 0
        for x := num; x > 0; x /= 10 {
            rev = rev*10 + x%10
        }
        ans += cnt[num-rev]
        cnt[num-rev]++
    }
    return ans % (1e9 + 7)
}
```

**复杂度分析**

- 时间复杂度：$O(n \times \log C)$，其中 $n$ 为数组 $\textit{nums}$ 的长度，$C$ 为数组 $\textit{nums}$ 中的数字范围。其中 $O(\log C)$ 为反转数位的时间复杂度。
- 空间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度，主要为哈希表的空间开销。
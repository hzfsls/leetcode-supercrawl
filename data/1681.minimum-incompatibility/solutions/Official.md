#### 前言

本题解涉及到「二进制」中的「子集枚举」，具体表示为对给定的一个整数 $x$，不重复地枚举 $x$ 的「二进制」表示的非空子集 $y$，其中 $y$ 满足 $y \And x = y$。以下为以 `C++` 实现枚举 $x$ 的非空子集的代码，其正确性证明详细可以见 [OI_WIKI-二进制集合操作-子集遍历部分](https://oi-wiki.org/math/binary-set/)。

```C++
// 降序遍历 x 的非空子集
for (int sub = x; sub; sub = (sub - 1) & x) {
    // sub 是 x 的一个非空子集
}
```

对于一个有「二进制」表示中有 $k$ 个 $1$ 的正整数 $x$，其非空子集有 $2^k - 1$ 个。所以对于 $x$ 枚举子集的时间复杂度为 $O(2^k)$。

本题中，数组 $\textit{nums}$ 的大小 $n$ 最多 $16$，所以我们可以通过「二进制」和「状态压缩」，用一个整数 $\textit{mask}$ 来表示一个子集。从 $\textit{mask}$ 「二进制」表示的低位到高位，第 $i$ 位为 $1$ 则表示元素 $\textit{nums}[i]$ 存在这个子集中。

#### 方法一：动态规划 + 状态压缩

**思路与算法** 

题目给定一个整数数组 $\textit{nums}$ 和一个整数 $k$。我们需要将这个数组划分到 $k$ 个相同大小的子集中，使得同一个子集里面没有两个相同的元素。题目保证 $\textit{nums}$ 大小能被 $k$ 整除。

一个子集的不兼容是该子集里面最大值和最小值的差。我们需要返回将数组分成 $k$ 个子集后，各子集不兼容性的和的最小值，如果无法分成分成 $k$ 个子集，返回 $-1$。

首先我们做一步预处理，从 $1$ 到 $(1 << n) - 1$ 遍历所有子集，筛选出所有大小符合条件的子集 $\textit{mask}$，并求出子集对应的不兼容性 $\textit{values}[\textit{mask}]$ 并保存在哈希表中，以便后续快速查找符合条件的子集。

然后我们尝试用「状态压缩动态规划」来解决本题，设 $\textit{dp}[\textit{mask}]$ 表示已经分配过的元素集合的不兼容性之和，$\textit{dp}[0]$ 初始化为 $0$，因为集合为空集，其余 $\textit{dp}[\textit{mask}]$ 初始化为最大整数，表示尚未确定最小不兼容性。

我们从 $1$ 到 $(1 << n) - 1$ 依次遍历 $\textit{mask}$ 所有状态。 对于每一个状态，我们求出还没有被分配的元素集合 $\textit{sub}$，并且保证相等元素只保留最后出现的一个。再遍历 $\textit{sub}$ 的子集 $\textit{nxt}$，检查是否符合条件，作为下一组划分的元素集合。由此我们可以写出状态转移方程：

$$\textit{dp}[\textit{mask} | \textit{nxt}] = \min_{\textit{nxt} \text{ is valid}}({dp[\textit{mask}]} + \textit{values}[\textit{nxt}])$$

按照上面状态转移方程，我们从小到大来遍历每一个状态，最终返回 $\textit{dp}[(1 << n) - 1]$ 的结果，即为划分所有元素后的最小不兼容性。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minimumIncompatibility(vector<int>& nums, int k) {
        int n = nums.size();
        vector<int> dp(1 << n, INT_MAX);
        dp[0] = 0;
        int group = n / k;
        unordered_map<int, int> values;

        for (int mask = 1; mask < (1 << n); mask++) {
            if (__builtin_popcount(mask) != group) {
                continue;
            }
            int mn = 20, mx = 0;
            unordered_set<int> cur;
            for (int i = 0; i < n; i++) {
                if (mask & (1 << i)) {
                    if (cur.count(nums[i]) > 0) {
                        break;
                    }
                    cur.insert(nums[i]);
                    mn = min(mn, nums[i]);
                    mx = max(mx, nums[i]);
                }
            }
            if (cur.size() == group) {
                values[mask] = mx - mn;
            }
        }

        for (int mask = 0; mask < (1 << n); mask++) {
            if (dp[mask] == INT_MAX) {
                continue;
            }
            unordered_map<int, int> seen;
            for (int i = 0; i < n; i++) {
                if ((mask & (1 << i)) == 0) {
                    seen[nums[i]] = i;
                }
            }
            if (seen.size() < group) {
                continue;
            }
            int sub = 0;
            for (auto& pair : seen) {
                sub |= (1 << pair.second);
            }
            int nxt = sub;
            while (nxt > 0) {
                if (values.count(nxt) > 0) {
                    dp[mask | nxt] = min(dp[mask | nxt], dp[mask] + values[nxt]);
                }
                nxt = (nxt - 1) & sub;
            }
        }

        return (dp[(1 << n) - 1] < INT_MAX) ? dp[(1 << n) - 1] : -1;
    }
};
```

```Python [sol1-Python3]
from typing import *


class Solution:
    def minimumIncompatibility(self, nums: List[int], k: int) -> int:
        n = len(nums)
        dp = [inf] * (1 << n)
        dp[0] = 0
        group = n // k
        values = {}

        for mask in range(1 << n):
            if mask.bit_count() != group:
                continue
            mn = 20
            mx = 0
            cur = set()
            for i in range(n):
                if mask & (1 << i) > 0:
                    if nums[i] in cur:
                        break
                    cur.add(nums[i])
                    mn = min(mn, nums[i])
                    mx = max(mx, nums[i])
            if len(cur) == group:
                values[mask] = mx - mn

        for mask in range(1 << n):
            if dp[mask] == inf:
                continue
            seen = {}
            for i in range(n):
                if mask & (1 << i) == 0:
                    seen[nums[i]] = i
            if len(seen) < group:
                continue
            sub = 0
            for v in seen:
                sub |= 1 << seen[v]
            nxt = sub
            while nxt > 0:
                if nxt in values:
                    dp[mask | nxt] = min(dp[mask | nxt], dp[mask] + values[nxt])
                nxt = (nxt - 1) & sub

        return dp[-1] if dp[-1] < inf else -1

```

```Java [sol1-Java]
class Solution {
    public int minimumIncompatibility(int[] nums, int k) {
        int n = nums.length, group = n / k, inf = Integer.MAX_VALUE;
        int[] dp = new int[1 << n];
        Arrays.fill(dp, inf);
        dp[0] = 0;
        HashMap<Integer, Integer> values = new HashMap<>();

        for (int mask = 1; mask < (1 << n); mask++) {
            if (Integer.bitCount(mask) != group) {
                continue;
            }
            int mn = 20, mx = 0;
            HashSet<Integer> cur = new HashSet<>();
            for (int i = 0; i < n; i++) {
                if ((mask & (1 << i)) > 0) {
                    if (cur.contains(nums[i])) {
                        break;
                    }
                    cur.add(nums[i]);
                    mn = Math.min(mn, nums[i]);
                    mx = Math.max(mx, nums[i]);
                }
            }
            if (cur.size() == group) {
                values.put(mask, mx - mn);
            }
        }

        for (int mask = 0; mask < (1 << n); mask++) {
            if (dp[mask] == inf) {
                continue;
            }
            HashMap<Integer, Integer> seen = new HashMap<>();
            for (int i = 0; i < n; i++) {
                if ((mask & (1 << i)) == 0) {
                    seen.put(nums[i], i);
                }
            }
            if (seen.size() < group) {
                continue;
            }
            int sub = 0;
            for (int v : seen.values()) {
                sub |= (1 << v);
            }
            int nxt = sub;
            while (nxt > 0) {
                if (values.containsKey(nxt)) {
                    dp[mask | nxt] = Math.min(dp[mask | nxt], dp[mask] + values.get(nxt));
                }
                nxt = (nxt - 1) & sub;
            }
        }

        return (dp[(1 << n) - 1] < inf) ? dp[(1 << n) - 1] : -1;
    }
}
```

```Go [sol1-Go]
func minimumIncompatibility(nums []int, k int) int {
    n := len(nums)
    group := n / k
    inf := math.MaxInt32
    dp := make([]int, 1 << n)
    for i := range dp {
        dp[i] = inf
    }
    dp[0] = 0
    values := make(map[int]int)

    for mask := 1; mask < (1 << n); mask++ {
        if bits.OnesCount(uint(mask)) != group {
            continue
        }
        minVal := 20
        maxVal := 0
        cur := make(map[int]bool)
        for i := 0; i < n; i++ {
            if mask & (1 << i) != 0 {
                if cur[nums[i]] {
                    break
                }
                cur[nums[i]] = true
                minVal = min(minVal, nums[i])
                maxVal = max(maxVal, nums[i])
            }
        }
        if len(cur) == group {
            values[mask] = maxVal - minVal
        }
    }

    for mask := 0; mask < (1 << n); mask++ {
        if dp[mask] == inf {
            continue
        }
        seen := make(map[int]int)
        for i := 0; i < n; i++ {
            if (mask & (1 << i)) == 0 {
                seen[nums[i]] = i
            }
        }
        if len(seen) < group {
            continue
        }
        sub := 0
        for _, v := range seen {
            sub |= (1 << v)
        }
        nxt := sub
        for nxt > 0 {
            if val, ok := values[nxt]; ok {
                dp[mask|nxt] = min(dp[mask|nxt], dp[mask] + val)
            }
            nxt = (nxt - 1) & sub
        }
    }
    if (dp[(1 << n) - 1] < inf) {
        return  dp[(1 << n) - 1]
    }
    return -1
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var minimumIncompatibility = function(nums, k) {
    const n = nums.length, group = n / k, inf = Infinity;
    const dp = new Array(1 << n).fill(inf);
    dp[0] = 0;
    const values = new Map();

    for (let mask = 1; mask < (1 << n); mask++) {
        if (countOnes(mask) !== group) {
            continue;
        }
        let mn = 20,
            mx = 0;
        const cur = new Set();
        for (let i = 0; i < n; i++) {
            if ((mask & (1 << i)) > 0) {
                if (cur.has(nums[i])) {
                    break;
                }
                cur.add(nums[i]);
                mn = Math.min(mn, nums[i]);
                mx = Math.max(mx, nums[i]);
            }
        }
        if (cur.size == group) {
            values.set(mask, mx - mn);
        }
    }

    for (let mask = 0; mask < (1 << n); mask++) {
        if (dp[mask] == inf) {
            continue;
        }
        const seen = new Map();
        for (let i = 0; i < n; i++) {
            if ((mask & (1 << i)) == 0) {
                seen.set(nums[i], i);
            }
        }
        if (seen.size < group) {
            continue;
        }
        let sub = 0;
        for (let v of seen.values()) {
            sub |= (1 << v);
        }
        let nxt = sub;
        while (nxt > 0) {
            if (values.has(nxt)) {
                dp[mask | nxt] = Math.min(dp[mask | nxt], dp[mask] + values.get(nxt));
            }
            nxt = (nxt - 1) & sub;
        }
    }

    return (dp[(1 << n) - 1] < inf) ? dp[(1 << n) - 1] : -1;
}

function countOnes(n) {
    let count = 0;
    while (n > 0) {
        count++;
        n &= n - 1;
    }
    return count;
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

int minimumIncompatibility(int* nums, int numsSize, int k) {
    int n = numsSize;
    HashItem *values = NULL;
    int dp[1 << n];
    for (int i = 0; i < (1 << n); i++) {
        dp[i] = INT_MAX;
    }
    dp[0] = 0;
    int group = n / k;

    for (int mask = 1; mask < (1 << n); mask++) {
        if (__builtin_popcount(mask) != group) {
            continue;
        }
        int mn = 20, mx = 0;
        int cur[n + 1];
        memset(cur, 0, sizeof(cur));
        for (int i = 0; i < n; i++) {
            if (mask & (1 << i)) {
                if (cur[nums[i]] > 0) {
                    break;
                }
                cur[nums[i]] = 1;
                mn = fmin(mn, nums[i]);
                mx = fmax(mx, nums[i]);
            }
        }
        int curSize = 0;
        for (int i = 0; i <= n; i++) {
            if (cur[i] > 0) {
                curSize++;
            }
        }
        if (curSize == group) {
            hashAddItem(&values, mask, mx - mn);
        }
    }
    for (int mask = 0; mask < (1 << n); mask++) {
        if (dp[mask] == INT_MAX) {
            continue;
        }
        HashItem *seen = NULL;
        for (int i = 0; i < n; i++) {
            if ((mask & (1 << i)) == 0) {
                hashAddItem(&seen, nums[i], i);
            }
        }
        if (HASH_COUNT(seen) < group) {
            continue;
        }
        int sub = 0;
        for (HashItem *pEntry = seen; pEntry; pEntry = pEntry->hh.next) {
            sub |= (1 << pEntry->val);
        }
        hashFree(&seen);
        int nxt = sub;
        while (nxt > 0) {
            if (hashFindItem(&values, nxt)) {
                dp[mask | nxt] = fmin(dp[mask | nxt], dp[mask] + hashGetItem(&values, nxt, 0));
            }
            nxt = (nxt - 1) & sub;
        }
    }
    hashFree(&values);
    return (dp[(1 << n) - 1] < INT_MAX) ? dp[(1 << n) - 1] : -1;
}
```

**复杂度分析**

- 时间复杂度：$O(3^n)$，其中 $n$ 为数组长度。
    
    预处理中，每个元素有（已选，未选）共 $2$ 种状态，总共有 $O(2^n)$ 个子集，预处理每个子集需要遍历数组是 $O(n)$， 总体复杂度 $O(n\times 2^n)$，小于 $O(3^n)$。

    动态规划转移中，每个元素有（已选，将选，未选）共 $3$ 种状态，转移方程最多被执行 $O(3^n)$ 次，总体复杂度 $O(3^n)$。

- 空间复杂度：$O(2^n)$，其中 $n$ 为数组长度。我们需要保存预处理和动态规划中的每一个状态。
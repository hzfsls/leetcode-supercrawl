## [446.等差数列划分 II - 子序列 中文官方题解](https://leetcode.cn/problems/arithmetic-slices-ii-subsequence/solutions/100000/deng-chai-shu-lie-hua-fen-ii-zi-xu-lie-b-77pl)
#### 方法一：动态规划 + 哈希表

我们首先考虑至少有两个元素的等差子序列，下文将其称作**弱等差子序列**。

由于尾项和公差可以确定一个等差数列，因此我们定义状态 $f[i][d]$ 表示尾项为 $\textit{nums}[i]$，公差为 $d$ 的弱等差子序列的个数。

我们用一个二重循环去遍历 $\textit{nums}$ 中的所有元素对 $(\textit{nums}[i],\textit{nums}[j])$，其中 $j<i$。将 $\textit{nums}[i]$ 和 $\textit{nums}[j]$ 分别当作等差数列的尾项和倒数第二项，则该等差数列的公差 $d=\textit{nums}[i]-\textit{nums}[j]$。由于公差相同，我们可以将 $\textit{nums}[i]$ 加到以 $\textit{nums}[j]$ 为尾项，公差为 $d$ 的弱等差子序列的末尾，这对应着状态转移 $f[i][d] += f[j][d]$。同时，$(\textit{nums}[i],\textit{nums}[j])$ 这一对元素也可以当作一个弱等差子序列，故有状态转移

$$
f[i][d] += f[j][d] + 1
$$

由于题目要统计的等差子序列至少有三个元素，我们回顾上述二重循环，其中「将 $\textit{nums}[i]$ 加到以 $\textit{nums}[j]$ 为尾项，公差为 $d$ 的弱等差子序列的末尾」这一操作，实际上就构成了一个至少有三个元素的等差子序列，因此我们将循环中的 $f[j][d]$ 累加，即为答案。

代码实现时，由于 $\textit{nums}[i]$ 的范围很大，所以计算出的公差的范围也很大，我们可以将状态转移数组 $f$ 的第二维用哈希表代替。

```Python [sol1-Python3]
class Solution:
    def numberOfArithmeticSlices(self, nums: List[int]) -> int:
        ans = 0
        f = [defaultdict(int) for _ in nums]
        for i, x in enumerate(nums):
            for j in range(i):
                d = x - nums[j]
                cnt = f[j][d]
                ans += cnt
                f[i][d] += cnt + 1
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int numberOfArithmeticSlices(vector<int> &nums) {
        int ans = 0;
        int n = nums.size();
        vector<unordered_map<long long, int>> f(n);
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < i; ++j) {
                long long d = 1LL * nums[i] - nums[j];
                auto it = f[j].find(d);
                int cnt = it == f[j].end() ? 0 : it->second;
                ans += cnt;
                f[i][d] += cnt + 1;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numberOfArithmeticSlices(int[] nums) {
        int ans = 0;
        int n = nums.length;
        Map<Long, Integer>[] f = new Map[n];
        for (int i = 0; i < n; ++i) {
            f[i] = new HashMap<Long, Integer>();
        }
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < i; ++j) {
                long d = 1L * nums[i] - nums[j];
                int cnt = f[j].getOrDefault(d, 0);
                ans += cnt;
                f[i].put(d, f[i].getOrDefault(d, 0) + cnt + 1);
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumberOfArithmeticSlices(int[] nums) {
        int ans = 0;
        int n = nums.Length;
        Dictionary<long, int>[] f = new Dictionary<long, int>[n];
        for (int i = 0; i < n; ++i) {
            f[i] = new Dictionary<long, int>();
        }
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < i; ++j) {
                long d = 1L * nums[i] - nums[j];
                int cnt = f[j].ContainsKey(d) ? f[j][d] : 0;
                ans += cnt;
                if (f[i].ContainsKey(d)) {
                    f[i][d] += cnt + 1;
                } else {
                    f[i].Add(d, cnt + 1);
                }
            }
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func numberOfArithmeticSlices(nums []int) (ans int) {
    f := make([]map[int]int, len(nums))
    for i, x := range nums {
        f[i] = map[int]int{}
        for j, y := range nums[:i] {
            d := x - y
            cnt := f[j][d]
            ans += cnt
            f[i][d] += cnt + 1
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var numberOfArithmeticSlices = function(nums) {
    let ans = 0;
    const n = nums.length;
    const f = new Map();
    for (let i = 0; i < n; ++i) {
        f[i] = new Map();
    }
    for (let i = 0; i < n; ++i) {
        for (let j = 0; j < i; ++j) {
            const d = nums[i] - nums[j];
            const cnt = f[j].get(d) || 0;
            ans += cnt;
            f[i].set(d, (f[i].get(d) || 0) + cnt + 1);
        }
    }
    return ans;
};
```

```C [sol1-C]
#define HASH_FIND_LONG(head, findint, out) HASH_FIND(hh, head, findint, sizeof(long), out)
#define HASH_ADD_LONG(head, intfield, add) HASH_ADD(hh, head, intfield, sizeof(long), add)

struct HashTable {
    long key;
    int val;
    UT_hash_handle hh;
};

int query(struct HashTable** HashTable, long ikey) {
    struct HashTable* tmp;
    HASH_FIND_LONG(*HashTable, &ikey, tmp);
    return tmp == NULL ? 0 : tmp->val;
}

void add(struct HashTable** HashTable, long ikey, int ival) {
    struct HashTable* tmp;
    HASH_FIND_LONG(*HashTable, &ikey, tmp);
    if (tmp == NULL) {
        tmp = malloc(sizeof(struct HashTable));
        tmp->key = ikey, tmp->val = ival;
        HASH_ADD_LONG(*HashTable, key, tmp);
    } else {
        tmp->val += ival;
    }
}

int numberOfArithmeticSlices(int* nums, int numsSize) {
    int ans = 0;
    struct HashTable* hashTable[numsSize];
    memset(hashTable, 0, sizeof(hashTable));
    for (int i = 0; i < numsSize; ++i) {
        for (int j = 0; j < i; ++j) {
            long long d = 1LL * nums[i] - nums[j];
            int cnt = query(&hashTable[j], d);
            ans += cnt;
            add(&hashTable[i], d, cnt + 1);
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(n^2)$。
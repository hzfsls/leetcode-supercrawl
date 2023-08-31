## [1296.划分数组为连续数字的集合 中文官方题解](https://leetcode.cn/problems/divide-array-in-sets-of-k-consecutive-numbers/solutions/100000/hua-fen-shu-zu-wei-lian-xu-shu-zi-de-ji-he-by-le-2)

#### 方法一：贪心

题目要求将数组 $\textit{nums}$ 中的元素分组使得每组的大小是 $k$。假设数组 $\textit{nums}$ 的长度是 $n$，只有当 $n \bmod k = 0$ 时才可能完成分组，因此如果 $n \bmod k \ne 0$ 则直接返回 $\text{false}$。

当 $n \bmod k = 0$ 时，可以将数组 $\textit{nums}$ 中的元素分组使得每组的大小是 $k$，此时需要判断是否存在一种分组方式使得同一组的元素都是连续的。

由于每个元素都必须被分到某个组，因此可以使用贪心的策略。假设尚未分组的元素中，最小的数字是 $x$，则如果存在符合要求的分组方式，$x$ 一定是某个组中的最小数字（否则 $x$ 不属于任何一个组，不符合每个元素都必须被分到某个组），该组的数字范围是 $[x, x + k - 1]$。在将 $x$ 到 $x + k - 1$ 的 $k$ 个元素分成一个组之后，继续使用贪心的策略对剩下的元素分组，直到所有的元素分组结束或者无法完成分组。如果在分组过程中发现从最小数字开始的连续 $k$ 个数字中有不存在的数字，则无法完成分组。

首先对数组 $\textit{nums}$ 排序，并使用哈希表记录数组 $\textit{nums}$ 中每个元素的出现次数，然后遍历数组 $\textit{nums}$，使用基于上述贪心策略的做法判断是否可以完成分组。贪心策略的具体做法如下：

1. 将当前元素记为 $x$，如果 $x$ 不在哈希表中则跳过，如果 $x$ 在哈希表中，则 $x$ 是某个组中的最小数字（因为数组 $\textit{nums}$ 有序，当遍历到 $x$ 时，$x$ 一定是所有尚未分组的元素中的最小数字），该组的数字范围是 $[x, x + k - 1]$；

2. 如果可以完成分组，则 $x$ 到 $x + k - 1$ 的每个整数在哈希表中记录的出现次数都至少为 $1$，如果遇到某个整数的出现次数为 $0$ 则无法完成分组，返回 $\text{false}$；

3. 将 $x$ 到 $x + k - 1$ 的每个整数在哈希表中记录的出现次数减 $1$，如果出现次数减为 $0$ 则从哈希表中移除该整数；

4. 对于其余元素，重复上述操作，直到遍历结束。

遍历结束之后，如果没有出现无法完成分组的情况，返回 $\text{true}$。

```Java [sol1-Java]
class Solution {
    public boolean isPossibleDivide(int[] nums, int k) {
        int n = nums.length;
        if (n % k != 0) {
            return false;
        }
        Arrays.sort(nums);
        Map<Integer, Integer> cnt = new HashMap<Integer, Integer>();
        for (int x : nums) {
            cnt.put(x, cnt.getOrDefault(x, 0) + 1);
        }
        for (int x : nums) {
            if (!cnt.containsKey(x)) {
                continue;
            }
            for (int j = 0; j < k; j++) {
                int num = x + j;
                if (!cnt.containsKey(num)) {
                    return false;
                }
                cnt.put(num, cnt.get(num) - 1);
                if (cnt.get(num) == 0) {
                    cnt.remove(num);
                }
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool IsPossibleDivide(int[] nums, int k) {
        int n = nums.Length;
        if (n % k != 0) {
            return false;
        }
        Array.Sort(nums);
        Dictionary<int, int> cnt = new Dictionary<int, int>();
        foreach (int x in nums) {
            if (!cnt.ContainsKey(x)) {
                cnt.Add(x, 0);
            }
            cnt[x]++;
        }
        foreach (int x in nums) {
            if (!cnt.ContainsKey(x)) {
                continue;
            }
            for (int j = 0; j < k; j++) {
                int num = x + j;
                if (!cnt.ContainsKey(num)) {
                    return false;
                }
                cnt[num]--;
                if (cnt[num] == 0) {
                    cnt.Remove(num);
                }
            }
        }
        return true;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool isPossibleDivide(vector<int>& nums, int k) {
        int n = nums.size();
        if (n % k != 0) {
            return false;
        }
        sort(nums.begin(), nums.end());
        unordered_map<int, int> cnt;
        for (auto & num : nums) {
            cnt[num]++;
        }
        for (auto & x : nums) {
            if (!cnt.count(x)) {
                continue;
            }
            for (int j = 0; j < k; j++) {
                int num = x + j;
                if (!cnt.count(num)) {
                    return false;
                }
                cnt[num]--;
                if (cnt[num] == 0) {
                    cnt.erase(num);
                }
            }
        }
        return true;
    }
};
```

```C [sol1-C]
static int cmp(const void * pa, const void * pb) {
    return *(int *)pa - *(int *)pb;
}

typedef struct Node {
    int val;
    int freq;
} Node;

bool isPossibleDivide(int* nums, int numsSize, int k) {
    if (numsSize % k != 0) {
        return false;
    }
    qsort(nums, numsSize, sizeof(int), cmp);
    Node * cnt = (Node *)malloc(sizeof(Node) * numsSize);
    memset(cnt, 0, sizeof(Node) * numsSize);
    int cardSize = 0;
    for (int i = 0; i < numsSize; ++i) {
        if (i == 0) {
            cnt[cardSize].val = nums[i];
            cnt[cardSize].freq = 1;
        } else {
            if(nums[i] != cnt[cardSize].val) {
                cardSize++;
            } 
            cnt[cardSize].val = nums[i];
            cnt[cardSize].freq++;
        }
    }
    int pos = 0;
    for (int i = 0; i < numsSize; ++i) {
        while (pos < cardSize && cnt[pos].freq == 0) {
            pos++;
        }
        if (cnt[pos].val == nums[i] && cnt[pos].freq > 0) {
            for (int j = 0; j < k; ++j) {
                int num = nums[i] + j;
                if (cnt[pos + j].freq > 0 && cnt[pos + j].val == num) {
                    cnt[pos + j].freq--;
                } else {
                    return false;
                }
            }
        } 
    }
    free(cnt);
    return true;
}
```

```JavaScript [sol1-JavaScript]
var isPossibleDivide = function(nums, k) {
    const n = nums.length;
    if (n % k !== 0) {
        return false;
    }
    nums.sort((a, b) => a - b);
    const cnt = new Map();
    for (const x of nums) {
        cnt.set(x, (cnt.get(x) || 0) + 1);
    }
    for (const x of nums) {
        if (!cnt.has(x)) {
            continue;
        }
        for (let j = 0; j < k; j++) {
            const num = x + j;
            if (!cnt.has(num)) {
                return false;
            }
            cnt.set(num, cnt.get(num) - 1);
            if (cnt.get(num) == 0) {
                cnt.delete(num);
            }
        }
    }
    return true;
};
```

```Python [sol1-Python3]
class Solution:
    def isPossibleDivide(self, nums: List[int], k: int) -> bool:
        if len(nums) % k > 0:
            return False
        nums.sort()
        cnt = Counter(nums)
        for x in nums:
            if cnt[x] == 0:
                continue
            for num in range(x, x + k):
                if cnt[num] == 0:
                    return False
                cnt[num] -= 1
        return True
```

```go [sol1-Golang]
func isPossibleDivide(nums []int, k int) bool {
    if len(nums)%k > 0 {
        return false
    }
    sort.Ints(nums)
    cnt := map[int]int{}
    for _, num := range nums {
        cnt[num]++
    }
    for _, x := range nums {
        if cnt[x] == 0 {
            continue
        }
        for num := x; num < x+k; num++ {
            if cnt[num] == 0 {
                return false
            }
            cnt[num]--
        }
    }
    return true
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。对数组 $\textit{nums}$ 排序需要 $O(n \log n)$ 的时间，排序之后遍历数组 $\textit{nums}$ 两次，每次遍历过程中，每个元素的处理时间都是 $O(1)$，因此每次遍历的时间复杂度都是 $O(n)$，总时间复杂度是 $O(n \log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。空间复杂度主要取决于哈希表，哈希表中最多存储 $n$ 个元素。
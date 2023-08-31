## [698.划分为k个相等的子集 中文官方题解](https://leetcode.cn/problems/partition-to-k-equal-sum-subsets/solutions/100000/hua-fen-wei-kge-xiang-deng-de-zi-ji-by-l-v66o)
#### 方法一：状态压缩 + 记忆化搜索

**思路与算法**

题目给定长度为 $n$ 的数组 $\textit{nums}$，和整数 $k$，我们需要判断是否能将数组分成 $k$ 个总和相等的非空子集。首先计算数组的和 $\textit{all}$，如果 $\textit{all}$ 不是 $k$ 的倍数，那么不可能能有合法方案，此时直接返回 $\text{False}$。否则我们需要得到 $k$ 个和为 $\textit{per} = \frac{\textit{all}}{k}$ 的集合，那么我们每次尝试选择一个还在数组中的数，若选择后当前已选数字和等于 $\textit{per}$ 则说明得到了一个集合，而已选数字和大于 $\textit{per}$ 时，不可能形成一个集合从而停止继续往下选择新的数字。又因为 $n$ 满足 $1 \le n \le 16$，所以我们可以用一个整数 $S$ 来表示当前可用的数字集合：从低位到高位，第 $i$ 位为 $1$ 则表示数字 $\textit{nums}[i]$ 可以使用，否则表示 $\textit{nums}[i]$ 已被使用。为了避免相同状态的重复计算，我们用 $\textit{dp}[S]$ 来表示在可用的数字状态为 $S$ 的情况下是否可行，初始全部状态为记录为可行状态 $\text{True}$。这样我们就可以通过记忆化搜索这种「自顶向下」的方式来进行求解原始状态的可行性，而当状态集合中不存在任何数字时，即 $S = 0$ 时，表示原始数组可以按照题目要求来进行分配，此时返回 $\text{True}$ 即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def canPartitionKSubsets(self, nums: List[int], k: int) -> bool:
        all = sum(nums)
        if all % k:
            return False
        per = all // k
        nums.sort()  # 方便下面剪枝
        if nums[-1] > per:
            return False
        n = len(nums)

        @cache
        def dfs(s, p):
            if s == 0:
                return True
            for i in range(n):
                if nums[i] + p > per:
                    break
                if s >> i & 1 and dfs(s ^ (1 << i), (p + nums[i]) % per):  # p + nums[i] 等于 per 时置为 0
                    return True
            return False
        return dfs((1 << n) - 1, 0)
```

```Java [sol1-Java]
class Solution {
    int[] nums;
    int per, n;
    boolean[] dp;

    public boolean canPartitionKSubsets(int[] nums, int k) {
        this.nums = nums;
        int all = Arrays.stream(nums).sum();
        if (all % k != 0) {
            return false;
        }
        per = all / k;
        Arrays.sort(nums);
        n = nums.length;
        if (nums[n - 1] > per) {
            return false;
        }
        dp = new boolean[1 << n];
        Arrays.fill(dp, true);
        return dfs((1 << n) - 1, 0);
    }

    public boolean dfs(int s, int p) {
        if (s == 0) {
            return true;
        }
        if (!dp[s]) {
            return dp[s];
        }
        dp[s] = false;
        for (int i = 0; i < n; i++) {
            if (nums[i] + p > per) {
                break;
            }
            if (((s >> i) & 1) != 0) {
                if (dfs(s ^ (1 << i), (p + nums[i]) % per)) {
                    return true;
                }
            }
        }
        return false;
    }
}
```

```C# [sol1-C#]
public class Solution {
    int[] nums;
    int per, n;
    bool[] dp;

    public bool CanPartitionKSubsets(int[] nums, int k) {
        this.nums = nums;
        int all = nums.Sum();
        if (all % k != 0) {
            return false;
        }
        per = all / k;
        Array.Sort(nums);
        n = nums.Length;
        if (nums[n - 1] > per) {
            return false;
        }
        dp = new bool[1 << n];
        Array.Fill(dp, true);
        return DFS((1 << n) - 1, 0);
    }

    public bool DFS(int s, int p) {
        if (s == 0) {
            return true;
        }
        if (!dp[s]) {
            return dp[s];
        }
        dp[s] = false;
        for (int i = 0; i < n; i++) {
            if (nums[i] + p > per) {
                break;
            }
            if (((s >> i) & 1) != 0) {
                if (DFS(s ^ (1 << i), (p + nums[i]) % per)) {
                    return true;
                }
            }
        }
        return false;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool canPartitionKSubsets(vector<int>& nums, int k) {
        int all = accumulate(nums.begin(), nums.end(), 0);
        if (all % k > 0) {
            return false;
        }
        int per = all / k; 
        sort(nums.begin(), nums.end());
        if (nums.back() > per) {
            return false;
        }
        int n = nums.size();
        vector<bool> dp(1 << n, true);
        function<bool(int,int)> dfs = [&](int s, int p)->bool {
            if (s == 0) {
                return true;
            }
            if (!dp[s]) {
                return dp[s];
            }
            dp[s] = false;
            for (int i = 0; i < n; i++) {
                if (nums[i] + p > per) {
                    break;
                }
                if ((s >> i) & 1) {
                    if (dfs(s ^ (1 << i), (p + nums[i]) % per)) {
                        return true;
                    }
                }
            }
            return false;
        };
        return dfs((1 << n) - 1, 0);
    }
};
```

```C [sol1-C]
static inline int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

static bool dfs(int s, int p, int per, int* nums, int numsSize, bool* dp) {
    if (s == 0) {
        return true;
    }
    if (!dp[s]) {
        return dp[s];
    }
    dp[s] = false;
    for (int i = 0; i < numsSize; i++) {
        if (nums[i] + p > per) {
            break;
        }
        if ((s >> i) & 1) {
            if (dfs(s ^ (1 << i), (p + nums[i]) % per, per, nums, numsSize, dp)) {
                return true;
            }
        }
    }
    return false;
}

bool canPartitionKSubsets(int* nums, int numsSize, int k) {
    int all = 0;
    for (int i = 0; i < numsSize; i++) {
        all += nums[i];
    }
    if (all % k > 0) {
        return false;
    }
    int per = all / k; 
    qsort(nums, numsSize, sizeof(int), cmp);
    if (nums[numsSize - 1] > per) {
        return false;
    }
    bool *dp = (bool *)malloc(sizeof(bool) * (1 << numsSize));
    memset(dp, true, sizeof(bool) * (1 << numsSize));
    return dfs((1 << numsSize) - 1, 0, per, nums, numsSize, dp);
}
```

```JavaScript [sol1-JavaScript]
var canPartitionKSubsets = function(nums, k) {
    const dfs = (s, p) => {
        if (s === 0) {
            return true;
        }
        if (!dp[s]) {
            return dp[s];
        }
        dp[s] = false;
        for (let i = 0; i < n; i++) {
            if (nums[i] + p > per) {
                break;
            }
            if (((s >> i) & 1) != 0) {
                if (dfs(s ^ (1 << i), (p + nums[i]) % per)) {
                    return true;
                }
            }
        }
        return false;
    };
    const all = _.sum(nums);
    if (all % k !== 0) {
        return false;
    }
    per = all / k;
    nums.sort((a, b) => a - b);
    n = nums.length;
    if (nums[n - 1] > per) {
        return false;
    }
    dp = new Array(1 << n).fill(true);
    return dfs((1 << n) - 1, 0);
}
```

```go [sol1-Golang]
func canPartitionKSubsets(nums []int, k int) bool {
    all := 0
    for _, v := range nums {
        all += v
    }
    if all%k > 0 {
        return false
    }
    per := all / k
    sort.Ints(nums)
    n := len(nums)
    if nums[n-1] > per {
        return false
    }

    dp := make([]bool, 1<<n)
    for i := range dp {
        dp[i] = true
    }
    var dfs func(int, int) bool
    dfs = func(s, p int) bool {
        if s == 0 {
            return true
        }
        if !dp[s] {
            return dp[s]
        }
        dp[s] = false
        for i, num := range nums {
            if num+p > per {
                break
            }
            if s>>i&1 > 0 && dfs(s^1<<i, (p+nums[i])%per) {
                return true
            }
        }
        return false
    }
    return dfs(1<<n-1, 0)
}
```

**复杂度分析**

- 时间复杂度：$O(n \times 2^n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度，共有 $2^n$ 个状态，每一个状态进行了 $n$ 次尝试。
- 空间复杂度：$O(2^n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度，主要为状态数组的空间开销。

#### 方法二：状态压缩 + 动态规划

**思路与算法**

我们同样可以用「动态规划」这种「自底向上」的方法来求解是否存在可行方案：同样我们用一个整数 $S$ 来表示当前可用的数字集合：从低位到高位，第 $i$ 位为 $0$ 则表示数字 $\textit{nums}[i]$ 可以使用，否则表示 $\textit{nums}[i]$ 已被使用。然后我们用 $\textit{dp}[S]$ 来表示在可用的数字状态为 $S$ 的情况下是否可能可行，初始全部状态为记录为不可行状态 $\text{False}$，只记 $\textit{dp}[0] = \text{True}$ 为可行状态。同样我们每次对于当前状态下从可用的数字中选择一个数字，若此时选择全部数字取模后小于等于 $\textit{per}$。则说明选择该数字后的状态再继续往下添加数字是可能能满足题意的，并且此时标记状为可能可行状态，否则就一定不能达到满足。最终 $\textit{dp}[U]$ 即可，其中 $U$ 表示全部数字使用的集合状态。

**代码**

```Python [sol2-Python3]
class Solution:
    def canPartitionKSubsets(self, nums: List[int], k: int) -> bool:
        all = sum(nums)
        if all % k:
            return False
        per = all // k
        nums.sort()
        if nums[-1] > per:
            return False
        n = len(nums)
        dp = [False] * (1 << n)
        dp[0] = True
        cursum = [0] * (1 << n)
        for i in range(0, 1 << n):
            if not dp[i]:
                continue
            for j in range(n):
                if cursum[i] + nums[j] > per:
                    break
                if (i >> j & 1) == 0:
                    next = i | (1 << j)
                    if not dp[next]:
                        cursum[next] = (cursum[i] + nums[j]) % per
                        dp[next] = True
        return dp[(1 << n) - 1]
```

```Java [sol2-Java]
class Solution {
    public boolean canPartitionKSubsets(int[] nums, int k) {
        int all = Arrays.stream(nums).sum();
        if (all % k != 0) {
            return false;
        }
        int per = all / k;
        Arrays.sort(nums);
        int n = nums.length;
        if (nums[n - 1] > per) {
            return false;
        }
        boolean[] dp = new boolean[1 << n];
        int[] curSum = new int[1 << n];
        dp[0] = true;
        for (int i = 0; i < 1 << n; i++) {
            if (!dp[i]) {
                continue;
            }
            for (int j = 0; j < n; j++) {
                if (curSum[i] + nums[j] > per) {
                    break;
                }
                if (((i >> j) & 1) == 0) {
                    int next = i | (1 << j);
                    if (!dp[next]) {
                        curSum[next] = (curSum[i] + nums[j]) % per;
                        dp[next] = true;
                    }
                }
            }
        }
        return dp[(1 << n) - 1];
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool CanPartitionKSubsets(int[] nums, int k) {
        int all = nums.Sum();
        if (all % k != 0) {
            return false;
        }
        int per = all / k;
        Array.Sort(nums);
        int n = nums.Length;
        if (nums[n - 1] > per) {
            return false;
        }
        bool[] dp = new bool[1 << n];
        int[] curSum = new int[1 << n];
        dp[0] = true;
        for (int i = 0; i < 1 << n; i++) {
            if (!dp[i]) {
                continue;
            }
            for (int j = 0; j < n; j++) {
                if (curSum[i] + nums[j] > per) {
                    break;
                }
                if (((i >> j) & 1) == 0) {
                    int next = i | (1 << j);
                    if (!dp[next]) {
                        curSum[next] = (curSum[i] + nums[j]) % per;
                        dp[next] = true;
                    }
                }
            }
        }
        return dp[(1 << n) - 1];
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    bool canPartitionKSubsets(vector<int>& nums, int k) {
        int all = accumulate(nums.begin(), nums.end(), 0);
        if (all % k > 0) {
            return false;
        }
        int per = all / k; 
        sort(nums.begin(), nums.end());
        if (nums.back() > per) {
            return false;
        }
        int n = nums.size();
        vector<bool> dp(1 << n, false);
        vector<int> curSum(1 << n, 0);
        dp[0] = true;
        for (int i = 0; i < 1 << n; i++) {
            if (!dp[i]) {
                continue;
            }
            for (int j = 0; j < n; j++) {
                if (curSum[i] + nums[j] > per) {
                    break;
                }
                if (((i >> j) & 1) == 0) {
                    int next = i | (1 << j);
                    if (!dp[next]) {
                        curSum[next] = (curSum[i] + nums[j]) % per;
                        dp[next] = true;
                    }
                }
            }
        }
        return dp[(1 << n) - 1];
    }
};
```

```C [sol2-C]
static inline int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

bool canPartitionKSubsets(int* nums, int numsSize, int k) {
    int all = 0;
    for (int i = 0; i < numsSize; i++) {
        all += nums[i];
    }
    if (all % k > 0) {
        return false;
    }
    int per = all / k; 
    qsort(nums, numsSize, sizeof(int), cmp);
    if (nums[numsSize - 1] > per) {
        return false;
    }
    bool *dp = (bool *)malloc(sizeof(bool) * (1 << numsSize));
    int *curSum = (int *)malloc(sizeof(int) * (1 << numsSize));
    memset(dp, false, sizeof(bool) * (1 << numsSize));
    memset(curSum, 0, sizeof(int) * (1 << numsSize));
    dp[0] = true;
    for (int i = 0; i < 1 << numsSize; i++) {
        if (!dp[i]) {
            continue;
        }
        for (int j = 0; j < numsSize; j++) {
            if (curSum[i] + nums[j] > per) {
                break;
            }
            if (((i >> j) & 1) == 0) {
                int next = i | (1 << j);
                if (!dp[next]) {
                    curSum[next] = (curSum[i] + nums[j]) % per;
                    dp[next] = true;
                }
            }
        }
    }
    bool res = dp[(1 << numsSize) - 1];
    free(dp);
    free(curSum);
    return res;
}
```

```JavaScript [sol2-JavaScript]
var canPartitionKSubsets = function(nums, k) {
    const all = _.sum(nums);
    if (all % k !== 0) {
        return false;
    }
    let per = all / k;
    nums.sort((a, b) => a - b);
    const n = nums.length;
    if (nums[n - 1] > per) {
        return false;
    }
    const dp = new Array(1 << n).fill(false);
    const curSum = new Array(1 << n).fill(0);
    dp[0] = true;
    for (let i = 0; i < 1 << n; i++) {
        if (!dp[i]) {
            continue;
        }
        for (let j = 0; j < n; j++) {
            if (curSum[i] + nums[j] > per) {
                break;
            }
            if (((i >> j) & 1) == 0) {
                let next = i | (1 << j);
                if (!dp[next]) {
                    curSum[next] = (curSum[i] + nums[j]) % per;
                    dp[next] = true;
                }
            }
        }
    }
    return dp[(1 << n) - 1];
}
```

```go [sol2-Golang]
func canPartitionKSubsets(nums []int, k int) bool {
    all := 0
    for _, v := range nums {
        all += v
    }
    if all%k > 0 {
        return false
    }
    per := all / k
    sort.Ints(nums)
    n := len(nums)
    if nums[n-1] > per {
        return false
    }

    dp := make([]bool, 1<<n)
    dp[0] = true
    curSum := make([]int, 1<<n)
    for i, v := range dp {
        if !v {
            continue
        }
        for j, num := range nums {
            if curSum[i]+num > per {
                break
            }
            if i>>j&1 == 0 {
                next := i | 1<<j
                if !dp[next] {
                    curSum[next] = (curSum[i] + nums[j]) % per
                    dp[next] = true

                }
            }
        }
    }
    return dp[1<<n-1]
}
```

**复杂度分析**

- 时间复杂度：$O(n \times 2^n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度，共有 $2^n$ 个状态，每一个状态进行了 $n$ 次尝试。
- 空间复杂度：$O(2^n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度，主要为状态数组的空间开销。
## [1723.完成所有工作的最短时间 中文官方题解](https://leetcode.cn/problems/find-minimum-time-to-finish-all-jobs/solutions/100000/wan-cheng-suo-you-gong-zuo-de-zui-duan-s-hrhu)

#### 方法一：二分查找 + 回溯 + 剪枝

**思路及算法**

在本题中，我们很难直接计算出完成所有工作的最短时间。而注意到，当完成所有工作的最短时间已经确定为 $\textit{limit}$ 时，如果存在可行的方案，那么对于任意长于 $\textit{limit}$ 的最短时间，都一定也存在可行的方案。因此我们可以考虑使用二分查找的方法寻找最小的存在可行方案的 $\textit{limit}$ 值。

当完成所有工作的最短时间已经确定为 $\textit{limit}$ 时，我们可以利用回溯的方式来寻找方案。

一个朴素的方案是，开辟一个大小为 $k$ 的数组 $\textit{workloads}$，$\textit{workloads}[i]$ 表示第 $i$ 个工人的当前已经被分配的工作量，然后我们利用一个递归函数 $\text{backtrack}(i)$ 递归地枚举第 $i$ 个任务的分配方案，过程中实时地更新 $\textit{workloads}$ 数组。具体地，函数中我们检查每一个工人 $j$ 当前已经被分配的工作量，如果被分配的工作量 $\textit{workloads}[j]$ 与当前工作的工作量 $\textit{jobs}[i]$ 之和不超过 $\textit{limit}$ 的限制，我们即可以将该工作分配给工人 $j$，然后计算下一个工作 $jobs[i+1]$ 的分配方案。过程中一旦我们找到了一个可行方案，我们即可以返回 $\text{true}$，而无需枚举完所有的方案。

朴素的方案中，$\text{backtrack}$ 函数的效率可能十分低下，有可能需要枚举完所有的分配方案才能得到答案，因此我们提出几个优化措施：

1. 缩小二分查找的上下限，下限为所有工作中的最大工作量，上限为所有工作的工作量之和。
   - 每一个工作都必须被分配，因此必然有一个工人承接了工作量最大的工作；
   - 在最坏情况下，只有一个工人，他必须承接所有工作。
2. 优先分配工作量大的工作。
   - 感性地理解，如果要求将小石子和大石块放入玻璃瓶中，优先放入大石块更容易使得工作变得简单。
   - 在搜索过程中，优先分配工作量小的工作会使得工作量大的工作更有可能最后无法被分配。
3. 当工人 $i$ 还没被分配工作时，我们不给工人 $i+1$ 分配工作。
   - 如果当前工人 $i$ 和 $i+1$ 都没有被分配工作，那么我们将工作先分配给任何一个人都没有区别，如果分配给工人 $i$ 不能成功完成分配任务，那么分配给工人 $i+1$ 也一样无法完成。
4. 当我们将工作 $i$ 分配给工人 $j$，使得工人 $j$ 的工作量恰好达到 $\textit{limit}$，且计算分配下一个工作的递归函数返回了 $\text{false}$，此时即无需尝试将工作 $i$ 分配给其他工人，直接返回 $\text{false}$ 即可。
   - 常规逻辑下，递归函数返回了 $\text{false}$，那么我们需要尝试将工作 $i$ 分配给其他工人，假设分配给了工人 $j'$，那么此时工人 $j'$ 的工作量必定不多于工人 $j$ 的工作量；
   - 如果存在一个方案使得分配给工人 $j'$ 能够成功完成分配任务，那么此时必然有一个或一组工作 $i'$ 取代了工作 $i$ 被分配给工人 $j$，否则我们可以直接将工作 $i$ 移交给工人 $j$，仍然能成功完成分配任务。而我们知道工作 $i'$ 的总工作量不会超过工作 $i$，因此我们可以直接交换工作 $i$ 与工作 $i'$，仍然能成功完成分配任务。这与假设不符，可知不存在这样一个满足条件的工人 $j'$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool backtrack(vector<int>& jobs, vector<int>& workloads, int idx, int limit) {
        if (idx >= jobs.size()) {
            return true;
        }
        int cur = jobs[idx];
        for (auto& workload : workloads) {
            if (workload + cur <= limit) {
                workload += cur;
                if (backtrack(jobs, workloads, idx + 1, limit)) {
                    return true;
                }
                workload -= cur;
            }
            // 如果当前工人未被分配工作，那么下一个工人也必然未被分配工作
            // 或者当前工作恰能使该工人的工作量达到了上限
            // 这两种情况下我们无需尝试继续分配工作
            if (workload == 0 || workload + cur == limit) {
                break;
            }
        }
        return false;
    }

    bool check(vector<int>& jobs, int k, int limit) {
        vector<int> workloads(k, 0);
        return backtrack(jobs, workloads, 0, limit);
    }

    int minimumTimeRequired(vector<int>& jobs, int k) {
        sort(jobs.begin(), jobs.end(), greater<int>());
        int l = jobs[0], r = accumulate(jobs.begin(), jobs.end(), 0);
        while (l < r) {
            int mid = (l + r) >> 1;
            if (check(jobs, k, mid)) {
                r = mid;
            } else {
                l = mid + 1;
            }
        }
        return l;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minimumTimeRequired(int[] jobs, int k) {
        Arrays.sort(jobs);
        int low = 0, high = jobs.length - 1;
        while (low < high) {
            int temp = jobs[low];
            jobs[low] = jobs[high];
            jobs[high] = temp;
            low++;
            high--;
        }
        int l = jobs[0], r = Arrays.stream(jobs).sum();
        while (l < r) {
            int mid = (l + r) >> 1;
            if (check(jobs, k, mid)) {
                r = mid;
            } else {
                l = mid + 1;
            }
        }
        return l;
    }

    public boolean check(int[] jobs, int k, int limit) {
        int[] workloads = new int[k];
        return backtrack(jobs, workloads, 0, limit);
    }

    public boolean backtrack(int[] jobs, int[] workloads, int i, int limit) {
        if (i >= jobs.length) {
            return true;
        }
        int cur = jobs[i];
        for (int j = 0; j < workloads.length; ++j) {
            if (workloads[j] + cur <= limit) {
                workloads[j] += cur;
                if (backtrack(jobs, workloads, i + 1, limit)) {
                    return true;
                }
                workloads[j] -= cur;
            }
            // 如果当前工人未被分配工作，那么下一个工人也必然未被分配工作
            // 或者当前工作恰能使该工人的工作量达到了上限
            // 这两种情况下我们无需尝试继续分配工作
            if (workloads[j] == 0 || workloads[j] + cur == limit) {
                break;
            }
        }
        return false;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinimumTimeRequired(int[] jobs, int k) {
        Array.Sort(jobs);
        Array.Reverse(jobs);
        int l = jobs[0], r = jobs.Sum();
        while (l < r) {
            int mid = (l + r) >> 1;
            if (Check(jobs, k, mid)) {
                r = mid;
            } else {
                l = mid + 1;
            }
        }
        return l;
    }

    public bool Check(int[] jobs, int k, int limit) {
        int[] workloads = new int[k];
        return Backtrack(jobs, workloads, 0, limit);
    }

    public bool Backtrack(int[] jobs, int[] workloads, int i, int limit) {
        if (i >= jobs.Length) {
            return true;
        }
        int cur = jobs[i];
        for (int j = 0; j < workloads.Length; ++j) {
            if (workloads[j] + cur <= limit) {
                workloads[j] += cur;
                if (Backtrack(jobs, workloads, i + 1, limit)) {
                    return true;
                }
                workloads[j] -= cur;
            }
            // 如果当前工人未被分配工作，那么下一个工人也必然未被分配工作
            // 或者当前工作恰能使该工人的工作量达到了上限
            // 这两种情况下我们无需尝试继续分配工作
            if (workloads[j] == 0 || workloads[j] + cur == limit) {
                break;
            }
        }
        return false;
    }
}
```

```JavaScript [sol1-JavaScript]
var minimumTimeRequired = function(jobs, k) {
    jobs.sort((a, b) => a - b);
    let low = 0, high = jobs.length - 1;
    while (low < high) {
        const temp = jobs[low];
        jobs[low] = jobs[high];
        jobs[high] = temp;
        low++;
        high--;
    }
    let l = jobs[0], r = jobs.reduce(function(prev, curr, idx, jobs){ return prev + curr });
    while (l < r) {
        const mid = Math.floor((l + r) >> 1);
        if (check(jobs, k, mid)) {
            r = mid;
        } else {
            l = mid + 1;
        }
    }
    return l;
};

const check = (jobs, k, limit) => {
    const workloads = new Array(k).fill(0);
    return backtrack(jobs, workloads, 0, limit);
}

const backtrack = (jobs, workloads, i, limit) => {
    if (i >= jobs.length) {
        return true;
    }
    let cur = jobs[i];
    for (let j = 0; j < workloads.length; ++j) {
        if (workloads[j] + cur <= limit) {
            workloads[j] += cur;
            if (backtrack(jobs, workloads, i + 1, limit)) {
                return true;
            }
            workloads[j] -= cur;
        }
        // 如果当前工人未被分配工作，那么下一个工人也必然未被分配工作
        // 或者当前工作恰能使该工人的工作量达到了上限
        // 这两种情况下我们无需尝试继续分配工作
        if (workloads[j] === 0 || workloads[j] + cur === limit) {
            break;
        }
    }
    return false;
}
```

```go [sol1-Golang]
func minimumTimeRequired(jobs []int, k int) int {
    n := len(jobs)
    sort.Sort(sort.Reverse(sort.IntSlice(jobs)))
    l, r := jobs[0], 0
    for _, v := range jobs {
        r += v
    }
    return l + sort.Search(r-l, func(limit int) bool {
        limit += l
        workloads := make([]int, k)
        var backtrack func(int) bool
        backtrack = func(idx int) bool {
            if idx == n {
                return true
            }
            cur := jobs[idx]
            for i := range workloads {
                if workloads[i]+cur <= limit {
                    workloads[i] += cur
                    if backtrack(idx + 1) {
                        return true
                    }
                    workloads[i] -= cur
                }
                // 如果当前工人未被分配工作，那么下一个工人也必然未被分配工作
                // 或者当前工作恰能使该工人的工作量达到了上限
                // 这两种情况下我们无需尝试继续分配工作
                if workloads[i] == 0 || workloads[i]+cur == limit {
                    break
                }
            }
            return false
        }
        return backtrack(0)
    })
}
```

```C [sol1-C]
bool backtrack(int* jobs, int jobsSize, int* workloads, int workloadsSize, int idx, int limit) {
    if (idx >= jobsSize) {
        return true;
    }
    int cur = jobs[idx];
    for (int i = 0; i < workloadsSize; i++) {
        if (workloads[i] + cur <= limit) {
            workloads[i] += cur;
            if (backtrack(jobs, jobsSize, workloads, workloadsSize, idx + 1, limit)) {
                return true;
            }
            workloads[i] -= cur;
        }
        // 如果当前工人未被分配工作，那么下一个工人也必然未被分配工作
        // 或者当前工作恰能使该工人的工作量达到了上限
        // 这两种情况下我们无需尝试继续分配工作
        if (workloads[i] == 0 || workloads[i] + cur == limit) {
            break;
        }
    }
    return false;
}

bool check(int* jobs, int jobsSize, int k, int limit) {
    int workloads[k];
    memset(workloads, 0, sizeof(workloads));
    return backtrack(jobs, jobsSize, workloads, k, 0, limit);
}

int cmp(int* a, int* b) {
    return *b - *a;
}

int accumulate(int* arr, int* arrSize) {
    int ret = 0;
    for (int i = 0; i < arrSize; i++) {
        ret += arr[i];
    }
    return ret;
}

int minimumTimeRequired(int* jobs, int jobsSize, int k) {
    qsort(jobs, jobsSize, sizeof(int), cmp);
    int l = jobs[0], r = accumulate(jobs, jobsSize);
    while (l < r) {
        int mid = (l + r) >> 1;
        if (check(jobs, jobsSize, k, mid)) {
            r = mid;
        } else {
            l = mid + 1;
        }
    }
    return l;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n + \log (S-M) \times k^n)$，其中 $n$ 是数组 $\textit{jobs}$ 的长度，$S$ 是数组 $\textit{jobs}$ 的元素之和，$M$ 是数组 $\textit{jobs}$ 中元素的最大值。最坏情况下每次二分需要遍历所有分配方案的排列，但经过一系列优化后，实际上可以规避掉绝大部分不必要的计算。

- 空间复杂度：$O(n)$。空间复杂度主要取决于递归的栈空间的消耗，而递归至多有 $n$ 层。


#### 方法二：动态规划 + 状态压缩

**思路及算法**

按照朴素的思路，我们按顺序给每一个工人安排工作，注意到当我们给第 $i$ 个工人分配工作的时候，能够选择的分配方案仅和前 $i-1$ 个人被分配的工作有关。因此我们考虑使用动态规划解决本题，只需要记录已经被分配了工作的工人数量，以及已经被分配的工作是哪些即可。

因为工作数量较少，我们可以使用状态压缩的方式来表示已经被分配的工作是哪些。具体地，假设有 $n$ 个工作需要被分配，我们就使用一个 $n$ 位的二进制整数来表示哪些工作已经被分配，哪些工作尚未被分配，如果该二进制整数的第 $i$ 位为 $1$，那么第 $i$ 个工作已经被分配，否则第 $i$ 个工作尚未被分配。如有 $3$ 个工作需要被分配，那么 $5=(101)_2$ 即代表 第 $0$ 和第 $2$ 个工作已经被分配，第 $1$ 个工作还未被分配。

这样我们可以写出状态方程：$f[i][j]$ 表示给前 $i$ 个人分配工作，工作的分配情况为 $j$ 时，完成所有工作的最短时间。注意这里的 $j$ 是一个二进制整数，表示了工作的分配情况。实际上我们也可以将 $j$ 看作一个集合，包含了已经被分配的工作。

那么我们可以写出状态转移方程：

$$
f[i][j] = \min_{j'\in j}\{ \max(f[i-1][\complement_{j}j'], \textit{sum}[j'])\}
$$

式中 $\textit{sum}[j']$ 表示集合 $j'$ 中的工作的总工作量，$\complement_{j}j'$ 表示集合 $j$ 中子集 $j'$ 的补集。状态转移方程的含义为，我们枚举 $j$ 的每一个子集 $j'$，让其作为分配给工人 $i$ 的工作，这样我们需要给前 $i-1$ 个人分配 $\complement_{j}j'$ 的工作。

在实际代码中，我们首先预处理出 $\textit{sum}$ 数组，然后初始化 $f[0][j]=sum[j]$，最终答案即为 $f[k-1][2^n-1]$（表示给全部 $k$ 个工人分配全部 $n$ 个工作，完成所有工作的最短时间）。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int minimumTimeRequired(vector<int>& jobs, int k) {
        int n = jobs.size();
        vector<int> sum(1 << n);
        for (int i = 1; i < (1 << n); i++) {
            int x = __builtin_ctz(i), y = i - (1 << x);
            sum[i] = sum[y] + jobs[x];
        }

        vector<vector<int>> dp(k, vector<int>(1 << n));
        for (int i = 0; i < (1 << n); i++) {
            dp[0][i] = sum[i];
        }

        for (int i = 1; i < k; i++) {
            for (int j = 0; j < (1 << n); j++) {
                int minn = INT_MAX;
                for (int x = j; x; x = (x - 1) & j) {
                    minn = min(minn, max(dp[i - 1][j - x], sum[x]));
                }
                dp[i][j] = minn;
            }
        }
        return dp[k - 1][(1 << n) - 1];
    }
};
```

```Java [sol2-Java]
class Solution {
    public int minimumTimeRequired(int[] jobs, int k) {
        int n = jobs.length;
        int[] sum = new int[1 << n];
        for (int i = 1; i < (1 << n); i++) {
            int x = Integer.numberOfTrailingZeros(i), y = i - (1 << x);
            sum[i] = sum[y] + jobs[x];
        }

        int[][] dp = new int[k][1 << n];
        for (int i = 0; i < (1 << n); i++) {
            dp[0][i] = sum[i];
        }

        for (int i = 1; i < k; i++) {
            for (int j = 0; j < (1 << n); j++) {
                int minn = Integer.MAX_VALUE;
                for (int x = j; x != 0; x = (x - 1) & j) {
                    minn = Math.min(minn, Math.max(dp[i - 1][j - x], sum[x]));
                }
                dp[i][j] = minn;
            }
        }
        return dp[k - 1][(1 << n) - 1];
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MinimumTimeRequired(int[] jobs, int k) {
        int n = jobs.Length;
        int[] sum = new int[1 << n];
        for (uint i = 1; i < (1 << n); i++) {
            int x = NumberOfTrailingZeros(i), y = (int)i - (int)(1 << x);
            sum[i] = sum[y] + jobs[x];
        }

        int[,] dp = new int[k, 1 << n];
        for (int i = 0; i < (1 << n); i++) {
            dp[0, i] = sum[i];
        }

        for (int i = 1; i < k; i++) {
            for (int j = 0; j < (1 << n); j++) {
                int minn = int.MaxValue;
                for (int x = j; x != 0; x = (x - 1) & j) {
                    minn = Math.Min(minn, Math.Max(dp[i - 1, j - x], sum[x]));
                }
                dp[i, j] = minn;
            }
        }
        return dp[k - 1, (1 << n) - 1];
    }

    private static int NumberOfTrailingZeros(uint i) {
        uint y;
        if (i == 0) return 32;
        int n = 31;
        y = i <<16; if (y != 0) { n = n -16; i = y; }
        y = i << 8; if (y != 0) { n = n - 8; i = y; }
        y = i << 4; if (y != 0) { n = n - 4; i = y; }
        y = i << 2; if (y != 0) { n = n - 2; i = y; }
        return (int)n - (int)((i << 1) >> 31);
    }
}
```

```JavaScript [sol2-JavaScript]
var minimumTimeRequired = function(jobs, k) {
    const n = jobs.length;
    const sum = new Array(1 << n).fill(0);
    for (let i = 1; i < (1 << n); i++) {
        const x = NumberOfTrailingZeros(i), y = i - (1 << x);
        sum[i] = sum[y] + jobs[x];
    }

    const dp = new Array(k).fill(0).map(() => new Array(1 << n).fill(0));
    for (let i = 0; i < (1 << n); i++) {
        dp[0][i] = sum[i];
    }

    for (let i = 1; i < k; i++) {
        for (let j = 0; j < (1 << n); j++) {
            let minn = Number.MAX_VALUE;
            for (let x = j; x != 0; x = (x - 1) & j) {
                minn = Math.min(minn, Math.max(dp[i - 1][j - x], sum[x]));
            }
            dp[i][j] = minn;
        }
    }
    return dp[k - 1][(1 << n) - 1];
};

const NumberOfTrailingZeros = (number) => {
    const num = parseInt(number).toString(2);
    const multiply_De_Bruijn_position = [
        0, 1, 28, 2, 29, 14, 24, 3, 30, 22, 20, 15, 25, 17, 4, 8,
        31, 27, 13, 23, 21, 19, 16, 7, 26, 12, 18, 6, 11, 5, 10, 9];
    return multiply_De_Bruijn_position[(((num & (-num)) * 0x077CB531) >> 27) & 31]
}
```

```go [sol2-Golang]
func minimumTimeRequired(jobs []int, k int) int {
    n := len(jobs)
    m := 1 << n
    sum := make([]int, m)
    for i := 1; i < m; i++ {
        x := bits.TrailingZeros(uint(i))
        y := i ^ 1<<x
        sum[i] = sum[y] + jobs[x]
    }

    dp := make([][]int, k)
    for i := range dp {
        dp[i] = make([]int, m)
    }
    for i, s := range sum {
        dp[0][i] = s
    }

    for i := 1; i < k; i++ {
        for j := 0; j < (1 << n); j++ {
            minn := math.MaxInt64
            for x := j; x > 0; x = (x - 1) & j {
                minn = min(minn, max(dp[i-1][j-x], sum[x]))
            }
            dp[i][j] = minn
        }
    }
    return dp[k-1][(1<<n)-1]
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

```C [sol2-C]
int minimumTimeRequired(int* jobs, int jobsSize, int k) {
    int n = jobsSize;
    int sum[1 << n];
    sum[0] = 0;
    for (int i = 1; i < (1 << n); i++) {
        int x = __builtin_ctz(i), y = i - (1 << x);
        sum[i] = sum[y] + jobs[x];
    }
    int dp[k][1 << n];
    for (int i = 0; i < (1 << n); i++) {
        dp[0][i] = sum[i];
    }

    for (int i = 1; i < k; i++) {
        for (int j = 0; j < (1 << n); j++) {
            int minn = INT_MAX;
            for (int x = j; x; x = (x - 1) & j) {
                minn = fmin(minn, fmax(dp[i - 1][j - x], sum[x]));
            }
            dp[i][j] = minn;
        }
    }
    return dp[k - 1][(1 << n) - 1];
}
```

**复杂度分析**

- 时间复杂度：$O(n\times 3^n)$，其中 $n$ 是数组 $\textit{jobs}$ 的长度。我们需要 $O(2^n)$ 的时间预处理 $\textit{sum}$ 数组。动态规划中共有 $O(n \times 2^n)$ 种状态，将每个状态看作集合，大小为 $k$ 的集合有 $n \times C_n^k$ 个，其转移个数为 $2^k$，根据二项式定理有 
  
  $$
  
  \sum_{k=0}^nC_n^k2^k=\sum_{k=0}^nC_n^k2^k1^{n-k}=(2+1)^n=3^n
  
  $$ 
  
  因此动态规划的时间复杂度为 $O(n \times 3^n)$，故总时间复杂度为 $O(n\times 3^n)$。

- 空间复杂度：$O(n\times 2^{n})$。我们需要保存动态规划的每一个状态。
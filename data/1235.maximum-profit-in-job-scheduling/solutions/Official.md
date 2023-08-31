## [1235.规划兼职工作 中文官方题解](https://leetcode.cn/problems/maximum-profit-in-job-scheduling/solutions/100000/gui-hua-jian-zhi-gong-zuo-by-leetcode-so-gu0e)
#### 方法一：动态规划 + 二分查找

由题意知，兼职工作由开始时间 $\textit{startTime}$，结束时间 $\textit{endTime}$ 和预计报酬 $\textit{profit}$ 三种属性表示。我们首先将兼职工作按结束时间 $\textit{endTime}$ 从小到大进行排序。使用 $\textit{dp}[i]$ 表示前 $i$ 份兼职工作可以获得的最大报酬，即区间 $[0, i - 1]$ 的所有兼职工作可以获得的最大报酬。初始时 $\textit{dp}[0] = 0$，表示没有兼职工作时报酬为 $0$。那么对于 $i \gt 0$，根据第 $i - 1$ 份兼职工作是否被选择，我们有以下转移方程：

$$\textit{dp}[i] = \max(\textit{dp}[i - 1], \textit{dp}[k] + \textit{profit}[i - 1])$$

其中 $k$ 表示满足结束时间小于等于第 $i - 1$ 份工作开始时间的兼职工作数量（因为兼职工作是按照结束时间从小到大进行排序的，所以选择第 $i-1$ 份兼职工作后，我们只能继续选择前 $k$ 份兼职工作），可以通过二分查找获得。

```Python [sol1-Python3]
class Solution:
    def jobScheduling(self, startTime: List[int], endTime: List[int], profit: List[int]) -> int:
        n = len(startTime)
        jobs = sorted(zip(startTime, endTime, profit), key=lambda p: p[1])
        dp = [0] * (n + 1)
        for i in range(1, n + 1):
            k = bisect_right(jobs, jobs[i - 1][0], hi=i, key=lambda p: p[1])
            dp[i] = max(dp[i - 1], dp[k] + jobs[i - 1][2])
        return dp[n]
```

```C++ [sol1-C++]
class Solution {
public:
    int jobScheduling(vector<int> &startTime, vector<int> &endTime, vector<int> &profit) {
        int n = startTime.size();
        vector<vector<int>> jobs(n);
        for (int i = 0; i < n; i++) {
            jobs[i] = {startTime[i], endTime[i], profit[i]};
        }
        sort(jobs.begin(), jobs.end(), [](const vector<int> &job1, const vector<int> &job2) -> bool {
            return job1[1] < job2[1];
        });
        vector<int> dp(n + 1);
        for (int i = 1; i <= n; i++) {
            int k = upper_bound(jobs.begin(), jobs.begin() + i - 1, jobs[i - 1][0], [&](int st, const vector<int> &job) -> bool {
                return st < job[1];
            }) - jobs.begin();
            dp[i] = max(dp[i - 1], dp[k] + jobs[i - 1][2]);
        }
        return dp[n];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int jobScheduling(int[] startTime, int[] endTime, int[] profit) {
        int n = startTime.length;
        int[][] jobs = new int[n][];
        for (int i = 0; i < n; i++) {
            jobs[i] = new int[]{startTime[i], endTime[i], profit[i]};
        }
        Arrays.sort(jobs, (a, b) -> a[1] - b[1]);
        int[] dp = new int[n + 1];
        for (int i = 1; i <= n; i++) {
            int k = binarySearch(jobs, i - 1, jobs[i - 1][0]);
            dp[i] = Math.max(dp[i - 1], dp[k] + jobs[i - 1][2]);
        }
        return dp[n];
    }

    public int binarySearch(int[][] jobs, int right, int target) {
        int left = 0;
        while (left < right) {
            int mid = left + (right - left) / 2;
            if (jobs[mid][1] > target) {
                right = mid;
            } else {
                left = mid + 1;
            }
        }
        return left;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int JobScheduling(int[] startTime, int[] endTime, int[] profit) {
        int n = startTime.Length;
        int[][] jobs = new int[n][];
        for (int i = 0; i < n; i++) {
            jobs[i] = new int[]{startTime[i], endTime[i], profit[i]};
        }
        Array.Sort(jobs, (a, b) => a[1] - b[1]);
        int[] dp = new int[n + 1];
        for (int i = 1; i <= n; i++) {
            int k = BinarySearch(jobs, i - 1, jobs[i - 1][0]);
            dp[i] = Math.Max(dp[i - 1], dp[k] + jobs[i - 1][2]);
        }
        return dp[n];
    }

    public int BinarySearch(int[][] jobs, int right, int target) {
        int left = 0;
        while (left < right) {
            int mid = left + (right - left) / 2;
            if (jobs[mid][1] > target) {
                right = mid;
            } else {
                left = mid + 1;
            }
        }
        return left;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int binarySearch(const int jobs[][3], int right, int target) {
    int left = 0;
    while (left < right) {
        int mid = left + (right - left) / 2;
        if (jobs[mid][1] > target) {
            right = mid;
        } else {
            left = mid + 1;
        }
    }
    return left;
}

static inline int cmp(const void *pa, const void *pb) {
    int *a = (int *)pa;
    int *b = (int *)pb;
    return a[1] - b[1];
}

int jobScheduling(int* startTime, int startTimeSize, int* endTime, int endTimeSize, int* profit, int profitSize) {
    int n = startTimeSize;
    int jobs[n][3];
    for (int i = 0; i < n; i++) {
        jobs[i][0] = startTime[i];
        jobs[i][1] = endTime[i];
        jobs[i][2] = profit[i];
    }
    qsort(jobs, n, sizeof(jobs[0]), cmp);
    int dp[n + 1];
    memset(dp, 0, sizeof(dp));
    for (int i = 1; i <= n; i++) {
        int k = binarySearch(jobs, i - 1, jobs[i - 1][0]);
        dp[i] = MAX(dp[i - 1], dp[k] + jobs[i - 1][2]);
    }
    return dp[n];
}
```

```JavaScript [sol1-JavaScript]
/**
 * @param {number[]} startTime
 * @param {number[]} endTime
 * @param {number[]} profit
 * @return {number}
 */
var jobScheduling = function(startTime, endTime, profit) {
    const n = startTime.length;
    const jobs = new Array(n).fill(0).map((_, i) => [startTime[i], endTime[i], profit[i]]);
    jobs.sort((a, b) => a[1] - b[1]);
    const dp = new Array(n + 1).fill(0);
    for (let i = 1; i <= n; i++) {
        const k = binarySearch(jobs, i - 1, jobs[i - 1][0]);
        dp[i] = Math.max(dp[i - 1], dp[k] + jobs[i - 1][2]);
    }
    return dp[n];
}

const binarySearch = (jobs, right, target) => {
    let left = 0;
    while (left < right) {
        const mid = left + Math.floor((right - left) / 2);
        if (jobs[mid][1] > target) {
            right = mid;
        } else {
            left = mid + 1;
        }
    }
    return left;
};
```

```go [sol1-Golang]
func jobScheduling(startTime, endTime, profit []int) int {
    n := len(startTime)
    jobs := make([][3]int, n)
    for i := 0; i < n; i++ {
        jobs[i] = [3]int{startTime[i], endTime[i], profit[i]}
    }
    sort.Slice(jobs, func(i, j int) bool { return jobs[i][1] < jobs[j][1] })

    dp := make([]int, n+1)
    for i := 1; i <= n; i++ {
        k := sort.Search(i, func(j int) bool { return jobs[j][1] > jobs[i-1][0] })
        dp[i] = max(dp[i-1], dp[k]+jobs[i-1][2])
    }
    return dp[n]
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

+ 时间复杂度：$O(n \log n)$，其中 $n$ 是兼职工作的数量。排序需要 $O(n \log n)$，遍历 + 二分查找需要 $O(n \log n)$，因此总时间复杂度为 $O(n \log n)$。

+ 空间复杂度：$O(n)$。需要 $O(n)$ 的空间来保存 $\textit{dp}$。
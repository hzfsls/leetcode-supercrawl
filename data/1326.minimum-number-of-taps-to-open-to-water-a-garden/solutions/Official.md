#### 方法一：动态规划

**思路与算法**

本题目为经典问题，本题中我们可以将水龙头的覆盖区域看做为一个小区间，本题即转换为求选择最少的区间数目可以覆盖连续区间 $[0,n]$。在力扣平台中有一些类似的题目，本质也是上述的模型，例如「[45. 跳跃游戏 II](https://leetcode.cn/problems/jump-game-ii/)」和「[1024. 视频拼接](https://leetcode.cn/problems/video-stitching/)」。

对于位置为 $i$ 的水龙头，已知它可以灌溉的区间为 $[i - \textit{ranges}[i], i + \textit{ranges}[i]]$。由于整个花园的区间为 $[0, n]$，我们将灌溉的区间约束在 $[0, n]$ 的范围内即可，超出的区间范围可以丢弃掉。我们将约束后的区间记为 $[\textit{start}_i, \textit{end}_i]$，即：

$$
\textit{start}_i = \max(i - \textit{ranges}[i], 0) \\
\textit{end}_i = \min(i + \textit{ranges}[i], n) \\
$$

那么我们需要在 $[\textit{start}_0, \textit{end}_0], [\textit{start}_1, \textit{end}_1], ..., [\textit{start}_n, \textit{end}_n]$ 中选出最少数目的区间，使得它们可以覆盖 $[0, n]$。

我们设 $\textit{dp}[i]$ 表示覆盖区间 $[0,i]$ 所需要的最少的区间数目，那么如何进行状态转移呢？我们假设当前第 $j$ 个区间 $[\textit{start}_j, \textit{end}_j]$ 覆盖了区间 $[0,i]$ 的最右边的部分区域 $[\textit{start}_j, i]$，即此时满足 $\textit{start}_j \le i \le \textit{end}_j$。假设我们选择了区间 $[\textit{start}_j, \textit{end}_j]$，此时我们只需知道区间 $[0,\textit{start}_j]$ 区间的最少覆盖数目即可得到递推公式 $\textit{dp}[i] = \min(\textit{dp}[i], 1 + \textit{dp}[\textit{start}_j])$。自然想到将所有的区间按照从左到右进行排序，当我们遍历当前子区间 $[\textit{start}_j, \textit{end}_j]$ 时，从而保证区间的左侧 $[0,\textit{start}_j]$ 的最终状态已经全部计算出来，此时我们即可利用上述的状态转移方程。

假设当前新加入的区间为 $[\textit{start}_j, \textit{end}_j]$，此时我们需要更新计算状态 $\textit{dp}[\textit{start}_j + 1],\textit{dp}[\textit{start}_j + 2],\textit{dp}[\textit{start}_j + \cdots], \textit{dp}[\textit{end}_j]$，此时 $\textit{dp}[k] = \min(\textit{dp}[k], \textit{dp}[\textit{start}_j] + 1),k\in[\textit{start}_j, \textit{end}_j]$。根据上述递推公式我们最终计算出 $\textit{dp}[n]$ 即可得到区间 $[0,n]$ 的最小覆盖数目。

最后，我们还需要考虑不合法的情况。我们可以用 $\textit{dp}[i] = \inf$ 表示花园子区间 $[0, i]$ 无法被覆盖，其中 $\inf$ 表示一个很大的整数。在进行状态转移时，如果 $\textit{dp}[\textit{start}_j] = \inf$，则表示花园子区间 $[0,\textit{start}_j]$ 无法完成覆盖，此时我们直接返回 $-1$。

**代码**

```Python [sol1-Python3]
class Solution:
    def minTaps(self, n: int, ranges: List[int]) -> int:
        intervals = []
        for i, r in enumerate(ranges):
            start = max(0, i - r)
            end = min(n, i + r)
            intervals.append((start, end))
        intervals.sort()

        dp = [inf] * (n + 1)
        dp[0] = 0
        for start, end in intervals:
            if dp[start] == inf:
                return -1
            for j in range(start, end + 1):
                dp[j] = min(dp[j], dp[start] + 1)
        return dp[n]
```

```C++ [sol1-C++]
class Solution {
public:
    int minTaps(int n, vector<int>& ranges) {
        vector<pair<int, int>> intervals;
        for (int i = 0; i <= n; i++) {
            int start = max(0, i - ranges[i]);
            int end = min(n, i + ranges[i]);
            intervals.emplace_back(start, end);
        }
        sort(intervals.begin(), intervals.end());
        vector<int> dp(n + 1, INT_MAX);
        dp[0] = 0;
        for (auto [start, end] : intervals) {
            if (dp[start] == INT_MAX) {
                return -1;
            }
            for (int j = start; j <= end; j++) {
                dp[j] = min(dp[j], dp[start] + 1);
            }
        }
        return dp[n];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minTaps(int n, int[] ranges) {
        int[][] intervals = new int[n + 1][];
        for (int i = 0; i <= n; i++) {
            int start = Math.max(0, i - ranges[i]);
            int end = Math.min(n, i + ranges[i]);
            intervals[i] = new int[]{start, end};
        }
        Arrays.sort(intervals, (a, b) -> a[0] - b[0]);
        int[] dp = new int[n + 1];
        Arrays.fill(dp, Integer.MAX_VALUE);
        dp[0] = 0;
        for (int[] interval : intervals) {
            int start = interval[0], end = interval[1];
            if (dp[start] == Integer.MAX_VALUE) {
                return -1;
            }
            for (int j = start; j <= end; j++) {
                dp[j] = Math.min(dp[j], dp[start] + 1);
            }
        }
        return dp[n];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinTaps(int n, int[] ranges) {
        int[][] intervals = new int[n + 1][];
        for (int i = 0; i <= n; i++) {
            int start = Math.Max(0, i - ranges[i]);
            int end = Math.Min(n, i + ranges[i]);
            intervals[i] = new int[]{start, end};
        }
        Array.Sort(intervals, (a, b) => a[0] - b[0]);
        int[] dp = new int[n + 1];
        Array.Fill(dp, int.MaxValue);
        dp[0] = 0;
        foreach (int[] interval in intervals) {
            int start = interval[0], end = interval[1];
            if (dp[start] == int.MaxValue) {
                return -1;
            }
            for (int j = start; j <= end; j++) {
                dp[j] = Math.Min(dp[j], dp[start] + 1);
            }
        }
        return dp[n];
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define MAX(a, b) ((a) > (b) ? (a) : (b))

const int INF = 0x3f3f3f3f;

static int cmp(const void *pa, const void *pb) {
    int la = ((int *)pa)[0], ra = ((int *)pa)[1];
    int lb = ((int *)pb)[0], rb = ((int *)pb)[1];
    if (la == lb) {
        return ra - rb;
    }
    return la - lb;
}

int minTaps(int n, int* ranges, int rangesSize) {
    int seglines[n + 1][2];
    for (int i = 0; i <= n; i++) {
        seglines[i][0] = MAX(0, i - ranges[i]);
        seglines[i][1] = MIN(n, i + ranges[i]);
    }
    qsort(seglines, n + 1, sizeof(seglines[0]), cmp);
    int dp[n + 1];
    memset(dp, 0x3f, sizeof(dp));
    dp[0] = 0;
    for (int i = 0; i <= n; i++) {
        int start = seglines[i][0];
        int end = seglines[i][1];
        if (dp[start] == INF) {
            return -1;
        }
        for (int j = start; j <= end; j++) {
            dp[j] = MIN(dp[j], dp[start] + 1);
        }
    }
    return dp[n];
}
```

```JavaScript [sol1-JavaScript]
var minTaps = function(n, ranges) {
    const intervals = new Array(n + 1).fill(new Array());
    for (let i = 0; i <= n; i++) {
        const start = Math.max(0, i - ranges[i]);
        const end = Math.min(n, i + ranges[i]);
        intervals[i] = [start, end];
    }
    intervals.sort((a, b) => a[0] - b[0]);
    const dp = new Array(n + 1).fill(Number.MAX_VALUE);
    dp[0] = 0;
    for (const interval of intervals) {
        let start = interval[0], end = interval[1];
        if (dp[start] === Number.MAX_VALUE) {
            return -1;
        }
        for (let j = start; j <= end; j++) {
            dp[j] = Math.min(dp[j], dp[start] + 1);
        }
    }
    return dp[n];
};
```

```go [sol1-Golang]
func minTaps(n int, ranges []int) int {
    intervals := [][2]int{}
    for i, r := range ranges {
        start := max(0, i-r)
        end := min(n, i+r)
        intervals = append(intervals, [2]int{start, end})
    }
    sort.Slice(intervals, func(i, j int) bool {
        a, b := intervals[i], intervals[j]
        return a[0] < b[0]
    })

    dp := make([]int, n+1)
    for i := range dp {
        dp[i] = math.MaxInt
    }
    dp[0] = 0
    for _, p := range intervals {
        start, end := p[0], p[1]
        if dp[start] == math.MaxInt {
            return -1
        }
        for j := start; j <= end; j++ {
            dp[j] = min(dp[j], dp[start]+1)
        }
    }
    return dp[n]
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n \times (\log n + \max(\textit{ranges})))$，其中 $n$ 表示给定的数字 $n$，$\max(\textit{ranges})$ 表示数组 $\textit{ranges}$ 中的最大元素。对所有的线段进行排序需要的时间为 $O(n \log n)$；求线段中的每个点的左侧最小覆盖数目需要的时间为 $O(\max(\textit{ranges}))$，一共有 $n+1$ 个线段，因此需要的总的时间复杂度为 $O(n \times (\log n + \max(\textit{ranges})))$。

- 空间复杂度：$O(n)$，其中 $n$ 表示给定的数字 $n$。我们需要保存每个线段的起始位置，需要的空间的为 $O(n)$，线段排序需要的空间为 $O(\log n)$，保存每个位置左侧的最小覆盖数目需要的空间为 $O(n)$，因此总的空间复杂度为 $O(n)$。

#### 方法二：贪心算法

**思路与算法**

方法一中的状态转移方程看上去非常简单，给我们一种直观的感受：它可以继续优化下去。我们不妨倒过来考虑这个问题，对于花园区间 $[0, n]$，首先我们必须选取左端点以 $0$ 开始的某个区间 $[0,j]$。假设当前有 $k$ 个待选区间 $[0,r_1],[0,r_2],\cdots[0,r_k]$，我们直观的感受是应该是尽可能的选择右端点最大的区间 $[0,\max(r)]$，这样即保障用最少的区间数量覆盖的区域足够大。如果所示我们应当选择区间 $[0,r_3]$，即可保证覆盖的区间最大。

![1](https://assets.leetcode-cn.com/solution-static/1326/1326_1.png)

当我们选择下一个区间时，此时该区间的左端点 $\textit{start}$ 一定要满足 $\textit{start} \le \max(r)$，而右端点 $\textit{end}$ 要尽可能的大。如图所示我们当前应选择右端点为 $t_3$ 的区间，这样即可保证覆盖区间 $[0,t_3]$ 用的子区间数目最少，我们可以通过反证法来证明，在此不再详细描述。

![2](https://assets.leetcode-cn.com/solution-static/1326/1326_2.png)

按照上述的贪心选择法，我们依次选择最优的区间即可保证最终找到覆盖区间 $[0,n]$ 的最少区间数目。

上述的贪心算法与「[1024. 视频拼接](https://leetcode.cn/problems/video-stitching/solutions/458461/shi-pin-pin-jie-by-leetcode-solution/)」中的方法二原理一样，我们参考该题的题解算法，具体算法描述如下：
+ 预处理所有的子区间，对于每一个位置 $i$，我们记录以其为左端点的子区间中最远的右端点，记为 $\textit{rightMost}[i]$。
+ 我们枚举每一个位置，假设当枚举到位置 $i$ 时，记左端点不大于 $i$ 的所有子区间的最远右端点为 $\textit{last}$。这样 $\textit{last}$ 就代表了当前能覆盖到的最远的右端点。
+ 每次我们枚举到一个新位置 $i$ ，我们都用 $\textit{rightMost}[i]$ 来更新 $\textit{last}$。如果更新后 $\textit{last} =i$，那么说明下一个位置无法被覆盖，我们无法完成目标。同时我们还需要记录上一个被使用的子区间的结束位置为 $\textit{pre}$，每次我们越过一个被使用的子区间，就说明我们要启用一个新子区间，这个新子区间的结束位置即为当前的 $\textit{last}$。也就是说，每次我们遇到 $i =\textit{pre}$ 时，则说明我们用完了一个被使用的子区间。这种情况下我们让答案加 $1$，并更新 $\textit{pre}$ 即可。

**代码**

```Python [sol2-Python3]
class Solution:
    def minTaps(self, n: int, ranges: List[int]) -> int:
        rightMost = list(range(n + 1))
        for i, r in enumerate(ranges):
            start = max(0, i - r)
            end = min(n, i + r)
            rightMost[start] = max(rightMost[start], end)

        last = ret = pre = 0
        for i in range(n):
            last = max(last, rightMost[i])
            if i == last:
                return -1
            if i == pre:
                ret += 1
                pre = last
        return ret
```

```C++ [sol2-C++]
class Solution {
public:
    int minTaps(int n, vector<int>& ranges) {
        vector<int> rightMost(n + 1);
        iota(rightMost.begin(), rightMost.end(), 0);
        for (int i = 0; i <= n; i++) {
            int start = max(0, i - ranges[i]);
            int end = min(n, i + ranges[i]);
            rightMost[start] = max(rightMost[start], end);
        }
        int last = 0, ret = 0, pre = 0;
        for (int i = 0; i < n; i++) {
            last = max(last, rightMost[i]);
            if (i == last) {
                return -1;
            }
            if (i == pre) {
                ret++;
                pre = last;
            }
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int minTaps(int n, int[] ranges) {
        int[] rightMost = new int[n + 1];
        for (int i = 0; i <= n; i++) {
            rightMost[i] = i;
        }
        for (int i = 0; i <= n; i++) {
            int start = Math.max(0, i - ranges[i]);
            int end = Math.min(n, i + ranges[i]);
            rightMost[start] = Math.max(rightMost[start], end);
        }
        int last = 0, ret = 0, pre = 0;
        for (int i = 0; i < n; i++) {
            last = Math.max(last, rightMost[i]);
            if (i == last) {
                return -1;
            }
            if (i == pre) {
                ret++;
                pre = last;
            }
        }
        return ret;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MinTaps(int n, int[] ranges) {
        int[] rightMost = new int[n + 1];
        for (int i = 0; i <= n; i++) {
            rightMost[i] = i;
        }
        for (int i = 0; i <= n; i++) {
            int start = Math.Max(0, i - ranges[i]);
            int end = Math.Min(n, i + ranges[i]);
            rightMost[start] = Math.Max(rightMost[start], end);
        }
        int last = 0, ret = 0, pre = 0;
        for (int i = 0; i < n; i++) {
            last = Math.Max(last, rightMost[i]);
            if (i == last) {
                return -1;
            }
            if (i == pre) {
                ret++;
                pre = last;
            }
        }
        return ret;
    }
}
```

```C [sol2-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int minTaps(int n, int* ranges, int rangesSize) {
    int rightMost[n + 1];
    memset(rightMost, 0, sizeof(rightMost));
    for (int i = 0; i <= n; i++) {
        int start = MAX(0, i - ranges[i]);
        int end = MIN(n, i + ranges[i]);
        rightMost[start] = MAX(rightMost[start], end);
    }
    int last = 0, ret = 0, pre = 0;
    for (int i = 0; i < n; i++) {
        last = MAX(last, rightMost[i]);
        if (i == last) {
            return -1;
        }
        if (i == pre) {
            ret++;
            pre = last;
        }
    }
    return ret;
}
```

```JavaScript [sol2-JavaScript]
var minTaps = function(n, ranges) {
    const rightMost = new Array(n + 1).fill(0).map((_, i) => i);
    for (let i = 0; i <= n; i++) {
        const start = Math.max(0, i - ranges[i]);
        const end = Math.min(n, i + ranges[i]);
        rightMost[start] = Math.max(rightMost[start], end);
    }
    let last = 0, ret = 0, pre = 0;
    for (let i = 0; i < n; i++) {
        last = Math.max(last, rightMost[i]);
        if (i === last) {
            return -1;
        }
        if (i === pre) {
            ret++;
            pre = last;
        }
    }
    return ret;
};
```

```go [sol2-Golang]
func minTaps(n int, ranges []int) int {
    rightMost := make([]int, n+1)
    for i := range rightMost {
        rightMost[i] = i
    }
    for i, r := range ranges {
        start := max(0, i-r)
        end := min(n, i+r)
        rightMost[start] = max(rightMost[start], end)
    }

    last, ret, pre := 0, 0, 0
    for i := 0; i < n; i++ {
        last = max(last, rightMost[i])
        if i == last {
            return -1
        }
        if i == pre {
            ret++
            pre = last
        }
    }
    return ret
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 表示给定的数字 $n$。我们需遍历 $\textit{ranges}$ 数组一遍，然后再遍历 $[0,n]$ 每个位置，因此时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 表示给定的数字 $n$。保存每个位置 $i\in[0,n]$ 为起点的子区间的右端点的最大值，需要的空间为 $O(n)$，因此总的空间复杂度为 $O(n)$。
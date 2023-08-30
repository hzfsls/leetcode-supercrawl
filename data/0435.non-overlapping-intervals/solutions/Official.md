#### 方法一：动态规划

**思路与算法**

题目的要求等价于「选出最多数量的区间，使得它们互不重叠」。由于选出的区间互不重叠，因此我们可以将它们按照端点从小到大的顺序进行排序，并且无论我们按照左端点还是右端点进行排序，得到的结果都是唯一的。

这样一来，我们可以先将所有的 $n$ 个区间按照左端点（或者右端点）从小到大进行排序，随后使用动态规划的方法求出区间数量的最大值。设排完序后这 $n$ 个区间的左右端点分别为 $l_0, \cdots, l_{n-1}$ 以及 $r_0, \cdots, r_{n-1}$，那么我们令 $f_i$ 表示「以区间 $i$ 为最后一个区间，可以选出的区间数量的最大值」，状态转移方程即为：

$$
f_i = \max_{j < i ~\wedge~ r_j \leq l_i} \{  f_j \} + 1
$$

即我们枚举倒数第二个区间的编号 $j$，满足 $j < i$，并且第 $j$ 个区间必须要与第 $i$ 个区间不重叠。由于我们已经按照左端点进行升序排序了，因此只要第 $j$ 个区间的右端点 $r_j$ 没有越过第 $i$ 个区间的左端点 $l_i$，即 $r_j \leq l_i$，那么第 $j$ 个区间就与第 $i$ 个区间不重叠。我们在所有满足要求的 $j$ 中，选择 $f_j$ 最大的那一个进行状态转移，如果找不到满足要求的区间，那么状态转移方程中 $\max$ 这一项就为 $0$，$f_i$ 就为 $1$。

最终的答案即为所有 $f_i$ 中的最大值。

**代码**

由于方法一的时间复杂度较高，因此在下面的 $\texttt{Python}$ 代码中，我们尽量使用列表推导优化常数，使得其可以在时间限制内通过所有测试数据。

```C++ [sol1-C++]
class Solution {
public:
    int eraseOverlapIntervals(vector<vector<int>>& intervals) {
        if (intervals.empty()) {
            return 0;
        }
        
        sort(intervals.begin(), intervals.end(), [](const auto& u, const auto& v) {
            return u[0] < v[0];
        });

        int n = intervals.size();
        vector<int> f(n, 1);
        for (int i = 1; i < n; ++i) {
            for (int j = 0; j < i; ++j) {
                if (intervals[j][1] <= intervals[i][0]) {
                    f[i] = max(f[i], f[j] + 1);
                }
            }
        }
        return n - *max_element(f.begin(), f.end());
    }
};
```

```Java [sol1-Java]
class Solution {
    public int eraseOverlapIntervals(int[][] intervals) {
        if (intervals.length == 0) {
            return 0;
        }
        
        Arrays.sort(intervals, new Comparator<int[]>() {
            public int compare(int[] interval1, int[] interval2) {
                return interval1[0] - interval2[0];
            }
        });

        int n = intervals.length;
        int[] f = new int[n];
        Arrays.fill(f, 1);
        for (int i = 1; i < n; ++i) {
            for (int j = 0; j < i; ++j) {
                if (intervals[j][1] <= intervals[i][0]) {
                    f[i] = Math.max(f[i], f[j] + 1);
                }
            }
        }
        return n - Arrays.stream(f).max().getAsInt();
    }
}
```

```Python [sol1-Python3]
class Solution:
    def eraseOverlapIntervals(self, intervals: List[List[int]]) -> int:
        if not intervals:
            return 0
        
        intervals.sort()
        n = len(intervals)
        f = [1]

        for i in range(1, n):
            f.append(max((f[j] for j in range(i) if intervals[j][1] <= intervals[i][0]), default=0) + 1)

        return n - max(f)
```

```go [sol1-Golang]
func eraseOverlapIntervals(intervals [][]int) int {
    n := len(intervals)
    if n == 0 {
        return 0
    }
    sort.Slice(intervals, func(i, j int) bool { return intervals[i][0] < intervals[j][0] })
    dp := make([]int, n)
    for i := range dp {
        dp[i] = 1
    }
    for i := 1; i < n; i++ {
        for j := 0; j < i; j++ {
            if intervals[j][1] <= intervals[i][0] {
                dp[i] = max(dp[i], dp[j]+1)
            }
        }
    }
    return n - max(dp...)
}

func max(a ...int) int {
    res := a[0]
    for _, v := range a[1:] {
        if v > res {
            res = v
        }
    }
    return res
}
```

```C [sol1-C]
int cmp(int** a, int** b) {
    return (*a)[0] - (*b)[0];
}

int eraseOverlapIntervals(int** intervals, int intervalsSize, int* intervalsColSize) {
    if (intervalsSize == 0) {
        return 0;
    }

    qsort(intervals, intervalsSize, sizeof(int*), cmp);
    int f[intervalsSize];
    for (int i = 0; i < intervalsSize; i++) {
        f[i] = 1;
    }
    int maxn = 1;
    for (int i = 1; i < intervalsSize; ++i) {
        for (int j = 0; j < i; ++j) {
            if (intervals[j][1] <= intervals[i][0]) {
                f[i] = fmax(f[i], f[j] + 1);
            }
        }
        maxn = fmax(maxn, f[i]);
    }
    return intervalsSize - maxn;
}
```

```JavaScript [sol1-JavaScript]
var eraseOverlapIntervals = function(intervals) {
    if (!intervals.length) {
        return 0;
    }

    intervals.sort((a, b) => a[0] - b[0]);
    const n = intervals.length;
    const f = new Array(n).fill(1);

    for (let i = 1; i < n; i++) {
        for (let j = 0; j < i; j++) {
            if (intervals[j][1] <= intervals[i][0]) {
                f[i] = Math.max(f[i], f[j] + 1);
            }
        }
    }
    return n - Math.max(...f);
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是区间的数量。我们需要 $O(n \log n)$ 的时间对所有的区间按照左端点进行升序排序，并且需要 $O(n^2)$ 的时间进行动态规划。由于前者在渐进意义下小于后者，因此总时间复杂度为 $O(n^2)$。

    注意到方法一本质上是一个「最长上升子序列」问题，因此我们可以将时间复杂度优化至 $O(n \log n)$，具体可以参考「[300. 最长递增子序列的官方题解](https://leetcode-cn.com/problems/longest-increasing-subsequence/solution/zui-chang-shang-sheng-zi-xu-lie-by-leetcode-soluti/)」。

- 空间复杂度：$O(n)$，即为存储所有状态 $f_i$ 需要的空间。

#### 方法二：贪心

**思路与算法**

我们不妨想一想应该选择哪一个区间作为首个区间。

假设在某一种**最优**的选择方法中，$[l_k, r_k]$ 是首个（即最左侧的）区间，那么它的左侧没有其它区间，右侧有若干个不重叠的区间。设想一下，如果此时存在一个区间 $[l_j, r_j]$，使得 $r_j < r_k$，即区间 $j$ 的右端点在区间 $k$ 的左侧，那么我们将区间 $k$ 替换为区间 $j$，其与剩余右侧被选择的区间仍然是不重叠的。而当我们将区间 $k$ 替换为区间 $j$ 后，就得到了另一种**最优**的选择方法。

我们可以不断地寻找右端点在首个区间右端点左侧的新区间，将首个区间替换成该区间。那么当我们无法替换时，**首个区间就是所有可以选择的区间中右端点最小的那个区间**。因此我们将所有区间按照右端点从小到大进行排序，那么排完序之后的首个区间，就是我们选择的首个区间。

如果有多个区间的右端点都同样最小怎么办？由于我们选择的是首个区间，因此在左侧不会有其它的区间，那么左端点在何处是不重要的，我们只要任意选择一个右端点最小的区间即可。

当确定了首个区间之后，所有与首个区间不重合的区间就组成了一个规模更小的子问题。由于我们已经在初始时将所有区间按照右端点排好序了，因此对于这个子问题，我们无需再次进行排序，只要找出其中**与首个区间不重合**并且右端点最小的区间即可。用相同的方法，我们可以依次确定后续的所有区间。

在实际的代码编写中，我们对按照右端点排好序的区间进行遍历，并且实时维护上一个选择区间的右端点 $\textit{right}$。如果当前遍历到的区间 $[l_i, r_i]$ 与上一个区间不重合，即 $l_i \geq \textit{right}$，那么我们就可以贪心地选择这个区间，并将 $\textit{right}$ 更新为 $r_i$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int eraseOverlapIntervals(vector<vector<int>>& intervals) {
        if (intervals.empty()) {
            return 0;
        }
        
        sort(intervals.begin(), intervals.end(), [](const auto& u, const auto& v) {
            return u[1] < v[1];
        });

        int n = intervals.size();
        int right = intervals[0][1];
        int ans = 1;
        for (int i = 1; i < n; ++i) {
            if (intervals[i][0] >= right) {
                ++ans;
                right = intervals[i][1];
            }
        }
        return n - ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int eraseOverlapIntervals(int[][] intervals) {
        if (intervals.length == 0) {
            return 0;
        }
        
        Arrays.sort(intervals, new Comparator<int[]>() {
            public int compare(int[] interval1, int[] interval2) {
                return interval1[1] - interval2[1];
            }
        });

        int n = intervals.length;
        int right = intervals[0][1];
        int ans = 1;
        for (int i = 1; i < n; ++i) {
            if (intervals[i][0] >= right) {
                ++ans;
                right = intervals[i][1];
            }
        }
        return n - ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def eraseOverlapIntervals(self, intervals: List[List[int]]) -> int:
        if not intervals:
            return 0
        
        intervals.sort(key=lambda x: x[1])
        n = len(intervals)
        right = intervals[0][1]
        ans = 1

        for i in range(1, n):
            if intervals[i][0] >= right:
                ans += 1
                right = intervals[i][1]
        
        return n - ans
```

```go [sol2-Golang]
func eraseOverlapIntervals(intervals [][]int) int {
    n := len(intervals)
    if n == 0 {
        return 0
    }
    sort.Slice(intervals, func(i, j int) bool { return intervals[i][1] < intervals[j][1] })
    ans, right := 1, intervals[0][1]
    for _, p := range intervals[1:] {
        if p[0] >= right {
            ans++
            right = p[1]
        }
    }
    return n - ans
}
```

```C [sol2-C]
int cmp(int** a, int** b) {
    return (*a)[1] - (*b)[1];
}

int eraseOverlapIntervals(int** intervals, int intervalsSize, int* intervalsColSize) {
    if (intervalsSize == 0) {
        return 0;
    }

    qsort(intervals, intervalsSize, sizeof(int*), cmp);

    int right = intervals[0][1];
    int ans = 1;
    for (int i = 1; i < intervalsSize; ++i) {
        if (intervals[i][0] >= right) {
            ++ans;
            right = intervals[i][1];
        }
    }
    return intervalsSize - ans;
}
```

```JavaScript [sol2-JavaScript]
var eraseOverlapIntervals = function(intervals) {
    if (!intervals.length) {
        return 0;
    }

    intervals.sort((a, b) => a[1] - b[1]);

    const n = intervals.length;
    let right = intervals[0][1];
    let ans = 1;
    for (let i = 1; i < n; ++i) {
        if (intervals[i][0] >= right) {
            ++ans;
            right = intervals[i][1];
        }
    }
    return n - ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是区间的数量。我们需要 $O(n \log n)$ 的时间对所有的区间按照右端点进行升序排序，并且需要 $O(n)$ 的时间进行遍历。由于前者在渐进意义下大于后者，因此总时间复杂度为 $O(n \log n)$。

- 空间复杂度：$O(\log n)$，即为排序需要使用的栈空间。
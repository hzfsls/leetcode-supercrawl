## [436.寻找右区间 中文官方题解](https://leetcode.cn/problems/find-right-interval/solutions/100000/xun-zhao-you-qu-jian-by-leetcode-solutio-w2ic)

#### 方法一：二分查找

**思路与算法**

最简单的解决方案是对于集合中的每个区间，我们扫描所有区间找到其起点大于当前区间的终点的区间（具有最小差值），时间复杂度为 $O(n^2)$，在此我们不详细描述。

首先我们可以对区间 $\textit{intervals}$ 的起始位置进行排序，并将每个起始位置  $\textit{intervals}[i][0]$ 对应的索引 $i$ 存储在数组 $\textit{startIntervals}$ 中，然后枚举每个区间 $i$ 的右端点 $\textit{intervals}[i][1]$，利用二分查找来找到大于等于 $\textit{intervals}[i][1]$ 的最小值 $\textit{val}$ 即可，此时区间 $i$ 对应的右侧区间即为右端点 $\textit{val}$ 对应的索引。

**代码**

```Python [sol1-Python3]
class Solution:
    def findRightInterval(self, intervals: List[List[int]]) -> List[int]:
        for i, interval in enumerate(intervals):
            interval.append(i)
        intervals.sort()

        n = len(intervals)
        ans = [-1] * n
        for _, end, id in intervals:
            i = bisect_left(intervals, [end])
            if i < n:
                ans[id] = intervals[i][2]
        return ans
```

```Java [sol1-Java]
class Solution {
    public int[] findRightInterval(int[][] intervals) {
        int n = intervals.length;
        int[][] startIntervals = new int[n][2];
        for (int i = 0; i < n; i++) {
            startIntervals[i][0] = intervals[i][0];
            startIntervals[i][1] = i;
        }
        Arrays.sort(startIntervals, (o1, o2) -> o1[0] - o2[0]);

        int[] ans = new int[n];
        for (int i = 0; i < n; i++) {
            int left = 0;
            int right = n - 1;
            int target = -1;
            while (left <= right) {
                int mid = (left + right) / 2;
                if (startIntervals[mid][0] >= intervals[i][1]) {
                    target = startIntervals[mid][1];
                    right = mid - 1;
                } else {
                    left = mid + 1;
                }
            }
            ans[i] = target;
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> findRightInterval(vector<vector<int>>& intervals) {
        vector<pair<int, int>> startIntervals;
        int n = intervals.size();
        for (int i = 0; i < n; i++) {
            startIntervals.emplace_back(intervals[i][0], i);
        }
        sort(startIntervals.begin(), startIntervals.end());

        vector<int> ans(n, -1);
        for (int i = 0; i < n; i++) {
            auto it = lower_bound(startIntervals.begin(), startIntervals.end(), make_pair(intervals[i][1], 0));
            if (it != startIntervals.end()) {
                ans[i] = it->second;
            }
        }
        return ans;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public int[] FindRightInterval(int[][] intervals) {
        int n = intervals.Length;
        int[][] startIntervals = new int[n][];
        for (int i = 0; i < n; i++) {
            startIntervals[i] = new int[2];
            startIntervals[i][0] = intervals[i][0];
            startIntervals[i][1] = i;
        }
        Array.Sort(startIntervals, (o1, o2) => o1[0] - o2[0]);

        int[] ans = new int[n];
        for (int i = 0; i < n; i++) {
            int left = 0;
            int right = n - 1;
            int target = -1;
            while (left <= right) {
                int mid = (left + right) / 2;
                if (startIntervals[mid][0] >= intervals[i][1]) {
                    target = startIntervals[mid][1];
                    right = mid - 1;
                } else {
                    left = mid + 1;
                }
            }
            ans[i] = target;
        }
        return ans;
    }
}
```

```C [sol1-C]
typedef struct {
    int start;
    int index;
} Node;

int cmp(const void *pa, const void *pb) {
    return ((Node *)pa)->start - ((Node *)pb)->start;
}

int* findRightInterval(int** intervals, int intervalsSize, int* intervalsColSize, int* returnSize) {
    Node * startIntervals = (Node *)malloc(sizeof(Node) * intervalsSize);
    for (int i = 0; i < intervalsSize; i++) {
        startIntervals[i].start = intervals[i][0];
        startIntervals[i].index = i;
    }
    qsort(startIntervals, intervalsSize, sizeof(Node), cmp);

    int * ans = (int *)malloc(sizeof(int) * intervalsSize);
    for (int i = 0; i < intervalsSize; i++) {
        int left = 0;
        int right = intervalsSize - 1;
        int target = -1;
        while (left <= right) {
            int mid = (left + right) / 2;
            if (startIntervals[mid].start >= intervals[i][1]) {
                target = startIntervals[mid].index;
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        ans[i] = target;
    }
    *returnSize = intervalsSize;
    return ans;
}
```

```go [sol1-Golang]
func findRightInterval(intervals [][]int) []int {
    for i := range intervals {
        intervals[i] = append(intervals[i], i)
    }
    sort.Slice(intervals, func(i, j int) bool { return intervals[i][0] < intervals[j][0] })

    n := len(intervals)
    ans := make([]int, n)
    for _, p := range intervals {
        i := sort.Search(n, func(i int) bool { return intervals[i][0] >= p[1] })
        if i < n {
            ans[p[2]] = intervals[i][2]
        } else {
            ans[p[2]] = -1
        }
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var findRightInterval = function(intervals) {
    const n = intervals.length;
    const startIntervals = new Array(n).fill(0).map(() => new Array(2).fill(0));
    for (let i = 0; i < n; i++) {
        startIntervals[i][0] = intervals[i][0];
        startIntervals[i][1] = i;
    }
    startIntervals.sort((o1, o2) => o1[0] - o2[0]);

    const ans = new Array(n).fill(0);
    for (let i = 0; i < n; i++) {
        let left = 0;
        let right = n - 1;
        let target = -1;
        while (left <= right) {
            const mid = Math.floor((left + right) / 2);
            if (startIntervals[mid][0] >= intervals[i][1]) {
                target = startIntervals[mid][1];
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        ans[i] = target;
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为区间数组的长度。排序的时间为 $O(n \log n)$，每次进行二分查找花费的时间为 $O(\log n)$，一共需要进行 $n$ 次二分查找，因此总的时间复杂度为 $O(n \log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 为区间数组的长度。$\textit{startIntervals}$ 一共存储了 $n$ 个元素，因此空间复杂度为 $O(n)$。

#### 方法二：双指针

**思路与算法**

我们可以开辟两个新的数组：
+ $\textit{startIntervals}$，基于所有区间的起始点从小到大排序。
+ $\textit{endIntervals}$，基于所有区间的结束点从小到大排序。

我们从 $\textit{endIntervals}$ 数组中取出第 $i$ 个区间，就可以从左到右扫描 $\textit{startIntervals}$ 数组中的区间起点来找到满足右区间条件的区间。设 $\textit{endIntervals}$ 数组中第 $i$ 个元素的右区间为 $\textit{startIntervals}$ 数组中的第 $j$ 个元素，此时可以知道 $\textit{startIntervals}[j-1][0] < \textit{endIntervals}[i][0], \textit{startIntervals}[j][0] \ge \textit{endIntervals}[i][0]$。当我们遍历 $\textit{endIntervals}$ 数组中第 $i+1$ 个元素时，我们不需要从第一个索引开始扫描 $\textit{startIntervals}$ 数组，可以直接从第 $j$ 个元素开始扫描 ${startIntervals}$ 数组。由于数组中所有的元素都是已排序，因此可以知道 $\textit{startIntervals}[j-1][0] < \textit{endIntervals}[i][0] \le \textit{endIntervals}[i+1][0]$，所以数组 $\textit{startIntervals}$ 的前 $j-1$ 的元素的起始点都小于 $\textit{endIntervals}[i+1][0]$，因此可以直接跳过前 $j-1$ 个元素，只需要从 $j$ 开始搜索即可。

**代码**

```Python [sol2-Python3]
class Solution:
    def findRightInterval(self, intervals: List[List[int]]) -> List[int]:
        n = len(intervals)
        starts, ends = list(zip(*intervals))
        starts = sorted(zip(starts, range(n)))
        ends = sorted(zip(ends, range(n)))

        ans, j = [-1] * n, 0
        for end, id in ends:
            while j < n and starts[j][0] < end:
                j += 1
            if j < n:
                ans[id] = starts[j][1]
        return ans
```

```Java [sol2-Java]
class Solution {
    public int[] findRightInterval(int[][] intervals) {
        int n = intervals.length;
        int[][] startIntervals = new int[n][2];
        int[][] endIntervals = new int[n][2];
        for (int i = 0; i < n; i++) {
            startIntervals[i][0] = intervals[i][0];
            startIntervals[i][1] = i;
            endIntervals[i][0] = intervals[i][1];
            endIntervals[i][1] = i;
        }
        Arrays.sort(startIntervals, (o1, o2) -> o1[0] - o2[0]);
        Arrays.sort(endIntervals, (o1, o2) -> o1[0] - o2[0]);

        int[] ans = new int[n];
        for (int i = 0, j = 0; i < n; i++) {
            while (j < n && endIntervals[i][0] > startIntervals[j][0]) {
                j++;
            }
            if (j < n) {
                ans[endIntervals[i][1]] = startIntervals[j][1];
            } else {
                ans[endIntervals[i][1]] = -1;
            }
        }
        return ans;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    vector<int> findRightInterval(vector<vector<int>>& intervals) {
        vector<pair<int, int>> startIntervals;
        vector<pair<int, int>> endIntervals;
        int n = intervals.size();
        for (int i = 0; i < n; i++) {
            startIntervals.emplace_back(intervals[i][0], i);
            endIntervals.emplace_back(intervals[i][1], i);
        }
        sort(startIntervals.begin(), startIntervals.end());
        sort(endIntervals.begin(), endIntervals.end());

        vector<int> ans(n, -1);
        for (int i = 0, j = 0; i < n && j < n; i++) {
            while (j < n && endIntervals[i].first > startIntervals[j].first) {
                j++;
            }
            if (j < n) {
                ans[endIntervals[i].second] = startIntervals[j].second;
            }
        }
        return ans;
    }
};
```

```C# [sol2-C#]
public class Solution {
    public int[] FindRightInterval(int[][] intervals) {
        int n = intervals.Length;
        int[][] startIntervals = new int[n][];
        int[][] endIntervals = new int[n][];
        for (int i = 0; i < n; i++) {
            startIntervals[i] = new int[2];
            startIntervals[i][0] = intervals[i][0];
            startIntervals[i][1] = i;
            endIntervals[i] = new int[2];
            endIntervals[i][0] = intervals[i][1];
            endIntervals[i][1] = i;
        }
        Array.Sort(startIntervals, (o1, o2) => o1[0] - o2[0]);
        Array.Sort(endIntervals, (o1, o2) => o1[0] - o2[0]);

        int[] ans = new int[n];
        for (int i = 0, j = 0; i < n; i++) {
            while (j < n && endIntervals[i][0] > startIntervals[j][0]) {
                j++;
            }
            if (j < n) {
                ans[endIntervals[i][1]] = startIntervals[j][1];
            } else {
                ans[endIntervals[i][1]] = -1;
            }
        }
        return ans;
    }
}
```

```C [sol2-C]
typedef struct {
    int start;
    int index;
} Node;

int cmp(const void *pa, const void *pb) {
    return ((Node *)pa)->start - ((Node *)pb)->start;
}

int* findRightInterval(int** intervals, int intervalsSize, int* intervalsColSize, int* returnSize){
    Node * startIntervals = (Node *)malloc(sizeof(Node) * intervalsSize);
    Node * endIntervals = (Node *)malloc(sizeof(Node) * intervalsSize);
    for (int i = 0; i < intervalsSize; i++) {
        startIntervals[i].start = intervals[i][0];
        startIntervals[i].index = i;
        endIntervals[i].start = intervals[i][1];
        endIntervals[i].index = i;
    }
    qsort(startIntervals, intervalsSize, sizeof(Node), cmp);
    qsort(endIntervals, intervalsSize, sizeof(Node), cmp);

    int * ans = (int *)malloc(sizeof(int) * intervalsSize);
    for (int i = 0, j = 0; i < intervalsSize; i++) {
        while (j < intervalsSize && endIntervals[i].start > startIntervals[j].start) {
            j++;
        }
        if (j < intervalsSize) {
            ans[endIntervals[i].index] = startIntervals[j].index;
        } else {
            ans[endIntervals[i].index] = -1;
        }
    }
    *returnSize = intervalsSize;
    free(startIntervals);
    free(endIntervals);
    return ans;
}
```

```go [sol2-Golang]
func findRightInterval(intervals [][]int) []int {
    n := len(intervals)
    type pair struct{ x, i int }
    starts := make([]pair, n)
    ends := make([]pair, n)
    for i, p := range intervals {
        starts[i] = pair{p[0], i}
        ends[i] = pair{p[1], i}
    }
    sort.Slice(starts, func(i, j int) bool { return starts[i].x < starts[j].x })
    sort.Slice(ends, func(i, j int) bool { return ends[i].x < ends[j].x })

    ans := make([]int, n)
    j := 0
    for _, p := range ends {
        for j < n && starts[j].x < p.x {
            j++
        }
        if j < n {
            ans[p.i] = starts[j].i
        } else {
            ans[p.i] = -1
        }
    }
    return ans
}
```

```JavaScript [sol2-JavaScript]
var findRightInterval = function(intervals) {
    const n = intervals.length;
    const startIntervals = new Array(n).fill(0).map(() => new Array(2).fill(0));
    const endIntervals = new Array(n).fill(0).map(() => new Array(2).fill(0));
    for (let i = 0; i < n; i++) {
        startIntervals[i][0] = intervals[i][0];
        startIntervals[i][1] = i;
        endIntervals[i][0] = intervals[i][1];
        endIntervals[i][1] = i;
    }
    startIntervals.sort((o1, o2) => o1[0] - o2[0]);
    endIntervals.sort((o1, o2) => o1[0] - o2[0]);

    const ans = new Array(n).fill(0);
    for (let i = 0, j = 0; i < n; i++) {
        while (j < n && endIntervals[i][0] > startIntervals[j][0]) {
            j++;
        }
        if (j < n) {
            ans[endIntervals[i][1]] = startIntervals[j][1];
        } else {
            ans[endIntervals[i][1]] = -1;
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为区间数组的长度。两个数组的排序时间一共为 $O(n \log n)$，查找每个区间的右侧区间的时间复杂度为 $O(n)$，因此总的时间复杂度为 $O(n \log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 为区间数组的长度。$\textit{startIntervals}, \textit{endIntervals}$ 均存储了 $n$ 个元素，因此空间复杂度为 $O(n)$。
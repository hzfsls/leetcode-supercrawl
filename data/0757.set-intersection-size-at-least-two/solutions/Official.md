## [757.设置交集大小至少为2 中文官方题解](https://leetcode.cn/problems/set-intersection-size-at-least-two/solutions/100000/she-zhi-jiao-ji-da-xiao-zhi-shao-wei-2-b-vuiv)
#### 方法一：贪心

**思路与算法**

首先我们从稍简化的情况开始分析：如果题目条件为设置交集大小为 $1$，为了更好的分析我们将 $\textit{intervals}$ 按照 $[s,e]$ 序对进行升序排序，其中 $\textit{intervals}$ 为题目给出的区间集合，$s,e$ 为区间的左右边界。设排序后的 $\textit{intervals} = \{[s_1,e_1,],\dots,[s_n,e_n]\}$，其中 $n$ 为区间集合的大小，并满足 $\forall i,j \in [1,n],i < j$ 有 $s_i \leq s_j$ 成立。然后对于最后一个区间 $[s_n,e_n]$ 来说一定是要提供一个最后交集集合中的元素，那么我们思考我们选择该区间中哪个元素是最优的——最优的元素应该尽可能的把之前的区间尽可能的覆盖。那么我们选择该区间的开头元素 $s_n$ 一定是最优的，因为对于前面的某一个区间 $[s_i,s_j]$：

- 如果 $s_j < s_n$：那么无论选择最后一个区间中的哪个数字都不会在区间 $[s_i,s_j]$ 中。
- 否则 $s_j \geq s_n$：因为 $s_n \geq s_i$ 所以此时选择 $s_n$ 一定会在区间 $[s_i,s_j]$ 中。

即对于最后一个区间 $[s_n，e_n]$ 来说选择区间的开头元素 $s_n$ 一定是最优的。那么贪心的思路就出来了：排序后从后往前进行遍历，每次选取与当前交集集合相交为空的区间的最左边的元素即可，然后往前判断前面是否有区间能因此产生交集，产生交集的直接跳过即可。此时算法的时间复杂度为：$O(n \log n)$ 主要为排序的时间复杂度。对于这种情况具体也可以见本站题目 [452. 用最少数量的箭引爆气球](https://leetcode.cn/problems/minimum-number-of-arrows-to-burst-balloons/)。

那么我们用同样的思路来扩展到需要交集为 $m~,~m > 1$ 的情况：此时同样首先对 $\textit{intervals}$ 按照 $[s,e]$ 序对进行升序排序，然后我们需要额外记录每一个区间与最后交集集合中相交的元素（只记录到 $m$ 个为止）。同样我们从最后一个区间往前进行处理，如果该区间与交集集合相交元素个数小于 $m$ 个时，我们从该区间左边界开始往后添加不在交集集合中的元素，并往前进行更新需要更新的区间，重复该过程直至该区间与交集元素集合有 $m$ 个元素相交。到此就可以解决问题了，不过我们也可以来修改排序的规则——我们将区间 $[s,e]$ 序对按照 $s$ 升序，当 $s$ 相同时按照 $e$ 降序来进行排序，这样可以实现在处理与交集集合相交元素个数小于 $m$ 个的区间 $[s_i,e_i]$ 时，保证不足的元素都是在区间的开始部分，即我们可以直接从区间开始部分进行往交集集合中添加元素。

而对于本题来说，我们只需要取 $m = 2$ 的情况即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def intersectionSizeTwo(self, intervals: List[List[int]]) -> int:
        intervals.sort(key=lambda x: (x[0], -x[1]))
        ans, n, m = 0, len(intervals), 2
        vals = [[] for _ in range(n)]
        for i in range(n - 1, -1, -1):
            j = intervals[i][0]
            for k in range(len(vals[i]), m):
                ans += 1
                for p in range(i - 1, -1, -1):
                    if intervals[p][1] < j:
                        break
                    vals[p].append(j)
                j += 1
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    void help(vector<vector<int>>& intervals, vector<vector<int>>& temp, int pos, int num) {
        for (int i = pos; i >= 0; i--) {
            if (intervals[i][1] < num) {
                break;
            }
            temp[i].push_back(num);
        }
    }

    int intersectionSizeTwo(vector<vector<int>>& intervals) {
        int n = intervals.size();
        int res = 0;
        int m = 2;
        sort(intervals.begin(), intervals.end(), [&](vector<int>& a, vector<int>& b) {
            if (a[0] == b[0]) {
                return a[1] > b[1];
            }
            return a[0] < b[0];
        });
        vector<vector<int>> temp(n);
        for (int i = n - 1; i >= 0; i--) {
            for (int j = intervals[i][0], k = temp[i].size(); k < m; j++, k++) {
                res++;
                help(intervals, temp, i - 1, j);
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int intersectionSizeTwo(int[][] intervals) {
        int n = intervals.length;
        int res = 0;
        int m = 2;
        Arrays.sort(intervals, (a, b) -> {
            if (a[0] == b[0]) {
                return b[1] - a[1];
            }
            return a[0] - b[0];
        });
        List<Integer>[] temp = new List[n];
        for (int i = 0; i < n; i++) {
            temp[i] = new ArrayList<Integer>();
        }
        for (int i = n - 1; i >= 0; i--) {
            for (int j = intervals[i][0], k = temp[i].size(); k < m; j++, k++) {
                res++;
                help(intervals, temp, i - 1, j);
            }
        }
        return res;
    }

    public void help(int[][] intervals, List<Integer>[] temp, int pos, int num) {
        for (int i = pos; i >= 0; i--) {
            if (intervals[i][1] < num) {
                break;
            }
            temp[i].add(num);
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int IntersectionSizeTwo(int[][] intervals) {
        int n = intervals.Length;
        int res = 0;
        int m = 2;
        Array.Sort(intervals, (a, b) => {
            if (a[0] == b[0]) {
                return b[1] - a[1];
            }
            return a[0] - b[0];
        });
        IList<int>[] temp = new IList<int>[n];
        for (int i = 0; i < n; i++) {
            temp[i] = new List<int>();
        }
        for (int i = n - 1; i >= 0; i--) {
            for (int j = intervals[i][0], k = temp[i].Count; k < m; j++, k++) {
                res++;
                Help(intervals, temp, i - 1, j);
            }
        }
        return res;
    }

    public void Help(int[][] intervals, IList<int>[] temp, int pos, int num) {
        for (int i = pos; i >= 0; i--) {
            if (intervals[i][1] < num) {
                break;
            }
            temp[i].Add(num);
        }
    }
}
```

```C [sol1-C]
static void help(int** intervals, int** temp, int *colSize, int pos, int num) {
    for (int i = pos; i >= 0; i --) {
        if (intervals[i][1] < num) {
            break;
        }
        temp[i][colSize[i]++] = num;
    }
}

static inline int cmp(const void* pa, const void* pb) {
    if ((*(int **)pa)[0] == (*(int **)pb)[0]) {
        return (*(int **)pb)[1] - (*(int **)pa)[1];
    }
    return (*(int **)pa)[0] - (*(int **)pb)[0];
}

int intersectionSizeTwo(int** intervals, int intervalsSize, int* intervalsColSize){
    int res = 0;
    int m = 2;
    qsort(intervals, intervalsSize, sizeof(int *), cmp);
    int **temp = (int **)malloc(sizeof(int *) * intervalsSize);
    for (int i = 0; i < intervalsSize; i++) {
        temp[i] = (int *)malloc(sizeof(int) * 2);
    }
    int *colSize = (int *)malloc(sizeof(int) * intervalsSize);
    memset(colSize, 0, sizeof(int) * intervalsSize);
    for (int i = intervalsSize - 1; i >= 0; i --) {
        for (int j = intervals[i][0], k = colSize[i]; k < m; j++, k++) {
            res++;
            help(intervals, temp, colSize, i - 1, j);
        }
    }
    for (int i = 0; i < intervalsSize; i++) {
        free(temp[i]);
    }
    free(colSize);
    return res;
}
```

```go [sol1-Golang]
func intersectionSizeTwo(intervals [][]int) (ans int) {
    sort.Slice(intervals, func(i, j int) bool {
        a, b := intervals[i], intervals[j]
        return a[0] < b[0] || a[0] == b[0] && a[1] > b[1]
    })
    n, m := len(intervals), 2
    vals := make([][]int, n)
    for i := n - 1; i >= 0; i-- {
        for j, k := intervals[i][0], len(vals[i]); k < m; k++ {
            ans++
            for p := i - 1; p >= 0 && intervals[p][1] >= j; p-- {
                vals[p] = append(vals[p], j)
            }
            j++
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var intersectionSizeTwo = function(intervals) {
    const n = intervals.length;
    let res = 0;
    let m = 2;
    intervals.sort((a, b) => {
        if (a[0] === b[0]) {
            return b[1] - a[1];
        }
        return a[0] - b[0];
    });
    const temp = new Array(n).fill(0);
    for (let i = 0; i < n; i++) {
        temp[i] = [];
    }

    const help = (intervals, temp, pos, num) => {
        for (let i = pos; i >= 0; i--) {
            if (intervals[i][1] < num) {
                break;
            }
            temp[i].push(num);
        }
    }

    for (let i = n - 1; i >= 0; i--) {
        for (let j = intervals[i][0], k = temp[i].length; k < m; j++, k++) {
            res++;
            help(intervals, temp, i - 1, j);
        }
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n \log n + nm)$，其中 $n$ 为给定区间集合 $\textit{intervals}$ 的大小，$m$ 为设置交集大小，本题为 $2$。

- 空间复杂度：$O(nm)$，其中 $n$ 为给定区间集合 $\textit{intervals}$ 的大小，$m$ 为设置交集的大小，本题为 $2$。主要开销为存储每一个区间与交集集合的相交的元素的开销。
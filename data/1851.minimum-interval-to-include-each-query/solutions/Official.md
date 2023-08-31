## [1851.包含每个查询的最小区间 中文官方题解](https://leetcode.cn/problems/minimum-interval-to-include-each-query/solutions/100000/bao-han-mei-ge-cha-xun-de-zui-xiao-qu-ji-e21j)

#### 方法一：离线算法 + 优先队列

首先我们对问题进行分析，对于第 $j$ 个查询，可以遍历 $\textit{intervals}$，找到满足 $\textit{left}_i \le \textit{queries}_j \le \textit{right}_i$ 的长度最小区间 $i$ 的长度。以上思路对于每个查询，都需要重新遍历 $\textit{intervals}$。

如果查询是递增的，那么我们可以对 $\textit{intervals}$ 按左端点 $\textit{left}$ 从小到大进行排序，使用一个指针 $i$ 记录下一个要访问的区间 $\textit{intervals}[i]$，初始时 $i = 0$，使用优先队列 $\textit{pq}$ 保存区间（优先队列的比较 $\textit{key}$ 为区间的长度，队首元素为长度最小的区间）。对于第 $j$ 个查询，我们执行以下步骤：

1. 如果 $i$ 等于 $\textit{intervals}$ 的长度或 $\textit{left}_i \gt \textit{queries}[j]$，终止步骤；

2. 将 $\textit{intervals}[i]$ 添加到优先队列 $\textit{pq}$，将 $i$ 的值加 $1$，继续执行步骤 $1$。

此时所有符合 $\textit{left} \le \textit{queries}_j \le \textit{right}$ 的区间都在 $\textit{pq}$，我们不断地获取优先队列 $\textit{pq}$ 的队首区间：

+ 如果队首区间的右端点 $\textit{right} \lt \textit{queries}[j]$，那么说明该区间不满足条件，从 $\textit{pq}$ 中出队；

+ 如果队首区间的右端点 $\textit{right} \ge \textit{queries}[j]$，那么该区间为第 $j$ 个查询的最小区间，终止过程。

对于第 $j + 1$ 个查询，因为查询是递增的，所以有 $\textit{queries}[j + 1] \ge \textit{queries}[j]$，那么此时 $\textit{pq}$ 中的区间都满足 $\textit{left} \le \textit{queries}[j + 1]$。在第 $j$ 个查询中丢弃的区间有 $\textit{right} \lt \textit{queries}[j] \le \textit{queries}[j + 1]$，因此丢弃的区间不满足第 $j + 1$ 个查询。同样在第 $j + 1$ 个查询执行与第 $j$ 个查询类似的步骤，将可能满足条件的区间加入优先队列 $\textit{pq}$ 中，那么此时所有满足条件的区间都在优先队列 $\textit{pq}$ 中，执行类似第 $j$ 个查询的出队操作。

由以上分析，如果查询满足递增的条件，那么可以利用优先队列进行优化。题目一次性提供所有的查询，基于离线原理，我们对所有查询从小到大进行排序，然后执行以上算法。

```C++ [sol1-C++]
class Solution {
public:
    vector<int> minInterval(vector<vector<int>>& intervals, vector<int>& queries) {
        vector<int> qindex(queries.size());
        iota(qindex.begin(), qindex.end(), 0);
        sort(qindex.begin(), qindex.end(), [&](int i, int j) -> bool {
            return queries[i] < queries[j];
        });
        sort(intervals.begin(), intervals.end(), [](const vector<int> &it1, const vector<int> &it2) -> bool {
            return it1[0] < it2[0];
        });
        priority_queue<vector<int>> pq;
        vector<int> res(queries.size(), -1);
        int i = 0;
        for (auto qi : qindex) {
            while (i < intervals.size() && intervals[i][0] <= queries[qi]) {
                int l = intervals[i][1] - intervals[i][0] + 1;
                pq.push({-l, intervals[i][0], intervals[i][1]});
                i++;
            }
            while (!pq.empty() && pq.top()[2] < queries[qi]) {
                pq.pop();
            }
            if (!pq.empty()) {
                res[qi] = -pq.top()[0];
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] minInterval(int[][] intervals, int[] queries) {
        Integer[] qindex = new Integer[queries.length];
        for (int i = 0; i < queries.length; i++) {
            qindex[i] = i;
        }
        Arrays.sort(qindex, (i, j) -> queries[i] - queries[j]);
        Arrays.sort(intervals, (i, j) -> i[0] - j[0]);
        PriorityQueue<int[]> pq = new PriorityQueue<int[]>((a, b) -> a[0] - b[0]);
        int[] res = new int[queries.length];
        Arrays.fill(res, -1);
        int i = 0;
        for (int qi : qindex) {
            while (i < intervals.length && intervals[i][0] <= queries[qi]) {
                pq.offer(new int[]{intervals[i][1] - intervals[i][0] + 1, intervals[i][0], intervals[i][1]});
                i++;
            }
            while (!pq.isEmpty() && pq.peek()[2] < queries[qi]) {
                pq.poll();
            }
            if (!pq.isEmpty()) {
                res[qi] = pq.peek()[0];
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] MinInterval(int[][] intervals, int[] queries) {
        int[] qindex = new int[queries.Length];
        for (int idx = 0; idx < queries.Length; idx++) {
            qindex[idx] = idx;
        }
        Array.Sort(qindex, (i, j) => queries[i] - queries[j]);
        Array.Sort(intervals, (i, j) => i[0] - j[0]);
        PriorityQueue<int[], int> pq = new PriorityQueue<int[], int>();
        int[] res = new int[queries.Length];
        Array.Fill(res, -1);
        int i = 0;
        foreach (int qi in qindex) {
            while (i < intervals.Length && intervals[i][0] <= queries[qi]) {
                pq.Enqueue(new int[]{intervals[i][1] - intervals[i][0] + 1, intervals[i][0], intervals[i][1]}, intervals[i][1] - intervals[i][0] + 1);
                i++;
            }
            while (pq.Count > 0 && pq.Peek()[2] < queries[qi]) {
                pq.Dequeue();
            }
            if (pq.Count > 0) {
                res[qi] = pq.Peek()[0];
            }
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minInterval(self, intervals: List[List[int]], queries: List[int]) -> List[int]:
        qindex = list(range(len(queries)))
        qindex.sort(key=lambda i: queries[i])
        intervals.sort(key=lambda i: i[0])
        pq = []
        res = [-1] * len(queries)
        i = 0
        for qi in qindex:
            while i < len(intervals) and intervals[i][0] <= queries[qi]:
                heappush(pq, (intervals[i][1] - intervals[i][0] + 1, intervals[i][0], intervals[i][1]))
                i += 1
            while pq and pq[0][2] < queries[qi]:
                heappop(pq)
            if pq:
                res[qi] = pq[0][0]
        return res
```

```Golang [sol1-Golang]
type PriorityQueue [][]int

func (pq PriorityQueue) Len() int {
    return len(pq)
}

func (pq PriorityQueue) Less(i, j int) bool {
    return pq[i][0] < pq[j][0]
}

func (pq PriorityQueue) Swap(i, j int) {
    pq[i], pq[j] = pq[j], pq[i]
}

func (pq *PriorityQueue) Push(x any) {
    *pq = append(*pq, x.([]int))
}

func (pq *PriorityQueue) Pop() any {
    n, old := len(*pq), *pq
    x := old[n - 1]
    *pq = old[0 : n-1]
    return x
}

func (pq PriorityQueue) Top() []int {
    return pq[0]
}

func minInterval(intervals [][]int, queries []int) []int {
    qindex := make([]int, len(queries))
    for i := 0; i < len(queries); i++ {
        qindex[i] = i
    }
    sort.Slice(qindex, func(i, j int) bool {
        return queries[qindex[i]] < queries[qindex[j]]
    })
    sort.Slice(intervals, func(i, j int) bool {
        return intervals[i][0] < intervals[j][0]
    })
    pq := &PriorityQueue{}
    res, i := make([]int, len(queries)), 0
    for _, qi := range qindex {
        for ; i < len(intervals) && intervals[i][0] <= queries[qi]; i++ {
            heap.Push(pq, []int{intervals[i][1] - intervals[i][0] + 1, intervals[i][0], intervals[i][1]})
        }
        for pq.Len() > 0 && pq.Top()[2] < queries[qi] {
            heap.Pop(pq)
        }
        if pq.Len() > 0 {
            res[qi] = pq.Top()[0]
        } else {
            res[qi] = -1
        }
    }
    return res
}
```

**复杂度分析**

+ 时间复杂度：$O(m \log m + n \log n)$，其中 $m$ 和 $n$ 分别为 $\textit{intervals}$ 和 $\textit{queries}$ 的长度。排序需要 $O(m \log m + n \log n)$，最多执行 $m$ 次入队和出队操作，需要 $O(m \log m)$。

+ 空间复杂度：$O(m + n)$。保存 $\textit{qindex}$ 需要 $O(m)$，保存 $\textit{pq}$ 需要 $O(n)$。
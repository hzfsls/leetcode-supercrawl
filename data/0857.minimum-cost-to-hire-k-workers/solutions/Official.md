#### 方法一：贪心 + 优先队列

**思路与算法**

题目给出 $n$ 名工人和他们的工作质量数组 $\textit{quality}$ 和薪资数组 $\textit{wage}$。其中 $\textit{quality}[i]$ 表示第 $i$ 名工人的工作质量，$\textit{wage}[i]$ 表示第 $i$ 名工人的最低期望工资。现在我们需要选择 $k$ 名工人来组成一个工资组，支付工资时我们需要按照下述的规则来向这些工人支付工资：

1. 对工资组中的每名工人，应当按其工作质量与同组其他工人的工作质量的比例来支付工资。
2. 工资组中的每名工人至少应当得到他们的最低期望工资。

然后我们需要求符合上述条件的最小支付金额。那么首先假设我们已经选择了某一个工资组，组成成员为 $[h_1,h_2,\cdots,h_k]$，其中 $h_i$ 表示第 $h_i$ 个工人，整个工作组的总工作质量为：$\textit{totalq}$，总的支付金额为 $\textit{totalc}$。那么按照题目的要求对于任意工人 $h_i$ 需要满足：

$$\textit{totalc} \times \frac{\textit{quality}[h_i]}{\textit{totalq}}\ge \textit{wage}[h_i]$$

即：

$$\textit{totalc} \ge \textit{totalq} \times \frac{\textit{wage}[h_i]}{\textit{quality}[h_i]}$$

所以当某一个工资组的总工作质量固定时，最少的付费金额只与工资组中 $\max \frac{\textit{wage}[h_i]}{\textit{quality}[h_i]}, 1 \le i \le k$ 有关。那么贪心的思路就出来了：设一个工人 $i$ 在某一个工资组中的权重表示为 $\frac{\textit{wage}[i]}{\textit{quality}[i]}$，那么当我们以某一个工人 $x$ 作为一个工资组中权重最高时，工资组中其他人员只需要在权重小于工人 $x$ 的集合中选择工作质量最少的 $k-1$ 名工人来组成工资组即可，此时便能达到以工人 $x$ 为权重最高的工资组的总工作量最小，从而达到以工人 $x$ 为权重最高的工资组的最小工资开销。然后我们枚举以每一个能成为工资组中权重最大的工人来计算最小工资组开销，然后取其中的最小即可。在处理的过程中，我们可以先将工人按照权重进行升序排序，然后在遍历过程中可以用优先队列来维护之前工作质量最少的 $k-1$ 名工人。

**代码**

```Python [sol1-Python3]
class Solution:
    def mincostToHireWorkers(self, quality: List[int], wage: List[int], k: int) -> float:
        pairs = sorted(zip(quality, wage), key=lambda p: p[1] / p[0])
        ans = inf
        totalq = 0
        h = []
        for q, w in pairs[:k - 1]:
            totalq += q
            heappush(h, -q)
        for q, w in pairs[k - 1:]:
            totalq += q
            heappush(h, -q)
            ans = min(ans, w / q * totalq)
            totalq += heappop(h)
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    double mincostToHireWorkers(vector<int>& quality, vector<int>& wage, int k) {
        int n = quality.size();
        vector<int> h(n, 0);
        iota(h.begin(), h.end(), 0);
        sort(h.begin(), h.end(), [&](int& a, int& b) {
            return quality[a] * wage[b] > quality[b] * wage[a];
        });
        double res = 1e9;
        double totalq = 0.0;
        priority_queue<int, vector<int>, less<int>> q;
        for (int i = 0; i < k - 1; i++) {
            totalq += quality[h[i]];
            q.push(quality[h[i]]);
        }
        for (int i = k - 1; i < n; i++) {
            int idx = h[i];
            totalq += quality[idx];
            q.push(quality[idx]);
            double totalc = ((double) wage[idx] / quality[idx]) * totalq;
            res = min(res, totalc);
            totalq -= q.top();
            q.pop();
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public double mincostToHireWorkers(int[] quality, int[] wage, int k) {
        int n = quality.length;
        Integer[] h = new Integer[n];
        for (int i = 0; i < n; i++) {
            h[i] = i;
        }
        Arrays.sort(h, (a, b) -> {
            return quality[b] * wage[a] - quality[a] * wage[b];
        });
        double res = 1e9;
        double totalq = 0.0;
        PriorityQueue<Integer> pq = new PriorityQueue<Integer>((a, b) -> b - a);
        for (int i = 0; i < k - 1; i++) {
            totalq += quality[h[i]];
            pq.offer(quality[h[i]]);
        }
        for (int i = k - 1; i < n; i++) {
            int idx = h[i];
            totalq += quality[idx];
            pq.offer(quality[idx]);
            double totalc = ((double) wage[idx] / quality[idx]) * totalq;
            res = Math.min(res, totalc);
            totalq -= pq.poll();
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public double MincostToHireWorkers(int[] quality, int[] wage, int k) {
        int n = quality.Length;
        int[] h = new int[n];
        for (int i = 0; i < n; i++) {
            h[i] = i;
        }
        Array.Sort(h, (a, b) => {
            return quality[b] * wage[a] - quality[a] * wage[b];
        });
        double res = 1e9;
        double totalq = 0.0;
        PriorityQueue<int, int> pq = new PriorityQueue<int, int>();
        for (int i = 0; i < k - 1; i++) {
            totalq += quality[h[i]];
            pq.Enqueue(quality[h[i]], -quality[h[i]]);
        }
        for (int i = k - 1; i < n; i++) {
            int idx = h[i];
            totalq += quality[idx];
            pq.Enqueue(quality[idx], -quality[idx]);
            double totalc = ((double) wage[idx] / quality[idx]) * totalq;
            res = Math.Min(res, totalc);
            totalq -= pq.Dequeue();
        }
        return res;
    }
}
```

```JavaScript [sol1-JavaScript]
var mincostToHireWorkers = function(quality, wage, k) {
    const n = quality.length;
    const h = new Array(n).fill(0).map((_, i) => i);
    h.sort((a, b) => {
        return quality[b] * wage[a] - quality[a] * wage[b];
    });
    let res = 1e9;
    let totalq = 0.0;
    const pq = new MaxPriorityQueue();
    for (let i = 0; i < k - 1; i++) {
        totalq += quality[h[i]];
        pq.enqueue(quality[h[i]]);
    }
    for (let i = k - 1; i < n; i++) {
        let idx = h[i];
        totalq += quality[idx];
        pq.enqueue(quality[idx]);
        const totalc = (wage[idx] / quality[idx]) * totalq;
        res = Math.min(res, totalc);
        totalq -= pq.dequeue().element;
    }
    return res;
};
```

```go [sol1-Golang]
func mincostToHireWorkers(quality, wage []int, k int) float64 {
    n := len(quality)
    h := make([]int, n)
    for i := range h {
        h[i] = i
    }
    sort.Slice(h, func(i, j int) bool {
        a, b := h[i], h[j]
        return quality[a]*wage[b] > quality[b]*wage[a]
    })
    totalq := 0
    q := hp{}
    for i := 0; i < k-1; i++ {
        totalq += quality[h[i]]
        heap.Push(&q, quality[h[i]])
    }
    ans := 1e9
    for i := k - 1; i < n; i++ {
        idx := h[i]
        totalq += quality[idx]
        heap.Push(&q, quality[idx])
        ans = math.Min(ans, float64(wage[idx])/float64(quality[idx])*float64(totalq))
        totalq -= heap.Pop(&q).(int)
    }
    return ans
}

type hp struct{ sort.IntSlice }

func (h hp) Less(i, j int) bool  { return h.IntSlice[i] > h.IntSlice[j] }
func (h *hp) Push(v interface{}) { h.IntSlice = append(h.IntSlice, v.(int)) }
func (h *hp) Pop() interface{}   { a := h.IntSlice; v := a[len(a)-1]; h.IntSlice = a[:len(a)-1]; return v }
``` 

**复杂度分析**

- 时间复杂度：$O(n \times \log n)$，主要为排序和每一个元素进出优先队列的时间复杂度。
- 空间复杂度：$O(n)$，主要为排序的辅助数组和优先队列的空间开销。
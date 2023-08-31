## [1792.最大平均通过率 中文官方题解](https://leetcode.cn/problems/maximum-average-pass-ratio/solutions/100000/zui-da-ping-jun-tong-guo-lu-by-leetcode-dm7y3)

#### 方法一：优先队列

**思路与算法**

由于班级总数不会变化，因此题目所求「最大化平均通过率」等价于「最大化总通过率」。设某个班级的人数为 $\textit{total}$，其中通过考试的人数为 $\textit{pass}$，那么给这个班级安排一个额外通过考试的学生，其通过率会增加：

$$\frac{\textit{pass} + 1}{\textit{total} + 1} - \frac{\textit{pass}}{\textit{total}}$$

我们会优先选择通过率增加量最大的班级，这样做的正确性在于给同一个班级不断地增加安排的学生数量时，其增加的通过率是单调递减的，即：

$$\frac{\textit{pass} + 2}{\textit{total} + 2} - \frac{\textit{pass} + 1}{\textit{total} + 1} < \frac{\textit{pass} + 1}{\textit{total} + 1} - \frac{\textit{pass}}{\textit{total}}$$

因此当以下条件满足时，班级 $j$ 比班级 $i$ 优先级更大：

$$\frac{\textit{pass}_i + 1}{\textit{total}_i + 1} - \frac{\textit{pass}_i}{\textit{total}_i} < \frac{\textit{pass}_j + 1}{\textit{total}_j + 1} - \frac{\textit{pass}_j}{\textit{total}_j}$$

化简后可得：

$$(\textit{total}_j + 1) \times (\textit{total}_j) \times (\textit{total}_i - \textit{pass}_i) < (\textit{total}_i + 1) \times (\textit{total}_i) \times (\textit{total}_j - \textit{pass}_j)$$

我们按照上述比较规则将每个班级放入优先队列中，进行 $\textit{extraStudents}$ 次操作。每一次操作，我们取出优先队列的堆顶元素，令其 $\textit{pass}$ 和 $\textit{total}$ 分别加 $1$，然后再放回优先队列。

最后我们遍历优先队列的每一个班级，计算其平均通过率即可得到答案。

**代码**

```Python [sol1-Python3]
class Entry:
    __slots__ = 'p', 't'

    def __init__(self, p: int, t: int):
        self.p = p
        self.t = t

    def __lt__(self, b: 'Entry') -> bool:
        return (self.t - self.p) * b.t * (b.t + 1) > (b.t - b.p) * self.t * (self.t + 1)

class Solution:
    def maxAverageRatio(self, classes: List[List[int]], extraStudents: int) -> float:
        h = [Entry(*c) for c in classes]
        heapify(h)
        for _ in range(extraStudents):
            heapreplace(h, Entry(h[0].p + 1, h[0].t + 1))
        return sum(e.p / e.t for e in h) / len(h)
```

```C++ [sol1-C++]
class Solution {
public:
    struct Ratio {
        int pass, total;
        bool operator < (const Ratio& oth) const {
            return (long long) (oth.total + 1) * oth.total * (total - pass) < (long long) (total + 1) * total * (oth.total - oth.pass);
        }
    };

    double maxAverageRatio(vector<vector<int>>& classes, int extraStudents) {
        priority_queue<Ratio> q;
        for (auto &c : classes) {
            q.push({c[0], c[1]});
        }

        for (int i = 0; i < extraStudents; i++) {
            auto [pass, total] = q.top();
            q.pop();
            q.push({pass + 1, total + 1});
        }

        double res = 0;
        for (int i = 0; i < classes.size(); i++) {
            auto [pass, total] = q.top();
            q.pop();
            res += 1.0 * pass / total;
        }
        return res / classes.size();
    }
};
```

```Java [sol1-Java]
class Solution {
    public double maxAverageRatio(int[][] classes, int extraStudents) {
        PriorityQueue<int[]> pq = new PriorityQueue<int[]>((a, b) -> {
            long val1 = (long) (b[1] + 1) * b[1] * (a[1] - a[0]);
            long val2 = (long) (a[1] + 1) * a[1] * (b[1] - b[0]);
            if (val1 == val2) {
                return 0;
            }
            return val1 < val2 ? 1 : -1;
        });
        for (int[] c : classes) {
            pq.offer(new int[]{c[0], c[1]});
        }

        for (int i = 0; i < extraStudents; i++) {
            int[] arr = pq.poll();
            int pass = arr[0], total = arr[1];
            pq.offer(new int[]{pass + 1, total + 1});
        }

        double res = 0;
        for (int i = 0; i < classes.length; i++) {
            int[] arr = pq.poll();
            int pass = arr[0], total = arr[1];
            res += 1.0 * pass / total;
        }
        return res / classes.length;
    }
}
```

```go [sol1-Golang]
func maxAverageRatio(classes [][]int, extraStudents int) (ans float64) {
    h := hp(classes)
    heap.Init(&h)
    for ; extraStudents > 0; extraStudents-- {
        h[0][0]++
        h[0][1]++
        heap.Fix(&h, 0)
    }
    for _, c := range h {
        ans += float64(c[0]) / float64(c[1])
    }
    return ans / float64(len(classes))
}

type hp [][]int
func (h hp) Len() int { return len(h) }
func (h hp) Less(i, j int) bool { a, b := h[i], h[j]; return (a[1]-a[0])*b[1]*(b[1]+1) > (b[1]-b[0])*a[1]*(a[1]+1) }
func (h hp) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }
func (hp) Push(interface{})     {}
func (hp) Pop() (_ interface{}) { return }
```

**复杂度分析**

- 时间复杂度：$O((n + m)\log n)$ 或 $O(n + m\log n)$，其中 $n$ 为 $\textit{classes}$ 的长度，$m$ 等于 $\textit{extraStudents}$。每次从优先队列中取出或者放入元素的时间复杂度为 $O(\log n)$，共需操作 $O(n + m)$ 次，故总复杂度为 $O((n + m)\log n)$。堆化写法的时间复杂度为 $O(n + m\log n)$。

- 空间复杂度：$O(n)$ 或 $O(1)$。使用优先队列需要用到 $O(n)$ 的空间，但若直接在 $\textit{classes}$ 上原地堆化，则可以做到 $O(1)$ 额外空间。
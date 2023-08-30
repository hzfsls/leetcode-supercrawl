#### 方法一：优先队列 + 贪心

**思路**

对于两门课 $(t_1, d_1)$ 和 $(t_2, d_2)$，如果后者的关闭时间较晚，即 $d_1 \leq d_2$，那么我们先学习前者，再学习后者，总是最优的。这是因为：

- 设开始学习的时间点为 $x$。如果先学习前者，再学习后者，那么需要满足：

    $$
    \begin{cases}
    x + t_1 \leq d_1 \\
    x + t_1 + t_2 \leq d_2
    \end{cases}
    $$

- 如果先学习后者，再学习前者，那么需要满足：

    $$
    \begin{cases}
    x + t_2 \leq d_2 \\
    x + t_2 + t_1 \leq d_1
    \end{cases}
    $$

如果 $x + t_2 + t_1 \leq d_1$ 成立，由于 $d_1 \leq d_2$，那么 $x + t_1 \leq d_1$ 和 $x + t_1 + t_2 \leq d_2$ 同时成立。这说明如果能「先学习后者，再学习前者」那么一定能「先学习前者，再学习后者」。反之如果 $x + t_1 + t_2 \leq d_2$ 成立，则不能推出 $x + t_2 + t_1 \leq d_1$ 成立，例如当 $x = 0$, $(t_1, d_1) = (2, 3)$，$(t_2, d_2) = (5, 100)$ 时，虽然能「先学习前者，再学习后者」，但不能「先学习后者，再学习前者」。

因此，我们可以讲所有的课程按照关闭时间 $d$ 进行升序排序，再依次挑选课程并按照顺序进行学习。

在遍历的过程中，假设我们当前遍历到了第 $i$ 门课 $(t_i, d_i)$，而在前 $i-1$ 门课程中我们选择了 $k$ 门课 $(t_{x_1}, d_{x_1}), (t_{x_2}, d_{x_2}), \cdots, (t_{x_k}, d_{x_k})$，满足 $x_1 < x_2 < \cdots < x_k$，那么有：

$$
\begin{cases}
    t_{x_1} \leq d_{x_1} \\
    t_{x_1} + t_{x_2} \leq d_{x_2} \\
    \cdots \\
    t_{x_1} + t_{x_2} + \cdots + t_{x_k} \leq d_{x_k}
\end{cases}
$$

如果上述选择方案是前 $i-1$ 门课程的「最优方案」：即不存在能选择 $k+1$ 门课程的方法，也不存在能选择 $k$ 门课程，并且总时长更短（小于 $t_{x_1} + t_{x_2} + \cdots + t_{x_k}$）的方案，那么我们可以基于该方案与第 $i$ 门课程 $(t_i, d_i)$，构造出前 $i$ 门课程的最优方案：

- 如果 $t_{x_1} + t_{x_2} + \cdots + t_{x_k} + t_i \leq d_i$，那么我们可以将第 $i$ 门课程 $(t_i, d_i)$ 直接加入方案，得到选择 $k+1$ 门课程的最优方案。

    这里的「最优性」可以使用反证法来证明。如果存在更优的方案，那么该方案一定包含 $(t_i, d_i)$，如果不包含，那么说明前 $i-1$ 门课程就存在更优的方案，这与我们的假设相矛盾。当最优方案包含 $(t_i, d_i)$ 时，根据之前的证明，「先学习前者，再学习后者」总是最优的，我们就可以把 $(t_i, d_i)$ 作为该方案的最后一门课程。由于该方案优于选择 $x_1, x_2, \cdots, x_k, i$ 的构造方案，因此同时将最后一门课程 $i$ 去除后，该方案仍然优于选择 $x_1, x_2, \cdots, x_k$ 的方案，同样说明前 $i-1$ 门课程存在更优的方案，这与我们的假设相矛盾。

- 如果 $t_{x_1} + t_{x_2} + \cdots + t_{x_k} + t_i > d_i$，那么我们无法将第 $i$ 门课程 $(t_i, d_i)$ 直接加入方案。我们可以使用类似的反证法，证明出此时前 $i$ 门课程不可能存在选择 $k+1$ 门课程的更优方案，因此我们的目标仍然为选择 $k$ 门课程，但最小化它们的总时间，为后续的课程腾出更多的时间。

    如果 $t_{x_1}, t_{x_2}, \cdots, t_{x_k}$ 都小于等于 $t_i$，那么我们显然没有办法通过第 $i$ 门课来使得总时间更小。但如果其中时间最长的那门课（记为 $t_{x_j}$）满足 $t_{x_j} > t_i$，那么我们就可以尝试将第 $x_j$ 门课程替换成第 $i$ 门课程了。这样的替换会使得总时间减少 $t_{x_j} - t_i$，也是我们能做到的减少的上限了。

    那么将第 $x_j$ 门课程替换成第 $i$ 门课程后，这些课程是否满足题目的要求呢？我们将这些课程按照 $x_1, x_2, \cdots, x_{j-1}, x_{j+1}, \cdots, x_k, i$ 的顺序进行学习：

    - 对于 $x_1, x_2, \cdots, x_{j-1}$，它们需要满足的不等式与之前是一致的，因此仍然满足要求；

    - 对于 $x_{j+1}, \cdots, x_{k}$，原先需要满足的不等式的左侧少了 $t_{x_j}$ 这一项，由于是左侧 $\leq$ 右侧，因此仍然满足要求；

    - 对于 $i$，由于 $t_{x_1} + t_{x_2} + \cdots + t_{x_k} \leq d_{x_k}$ 成立，而 $t_{x_{j}} > t_i$，因此：

        $$
        t_{x_1} + t_{x_2} + \cdots + t_{x_{j-1}} + t_{x_{j+1}} + \cdots + t_{x_k} + t_i \leq d_{x_k}
        $$

        满足要求。
    
    这就说明我们可以将第 $x_j$ 门课程替换成第 $i$ 门课程。

这样一来，当我们遍历完所有的 $n$ 门课程后，就可以得到最终的答案。

**算法**

我们需要一个数据结构支持「取出 $t$ 值最大的那门课程」，因此我们可以使用优先队列（大根堆）。

我们依次遍历每一门课程，当遍历到 $(t_i, d_i)$ 时：

- 如果当前优先队列中所有课程的总时间与 $t_i$ 之和小于等于 $d_i$，那么我们就把 $t_i$ 加入优先队列中；

- 如果当前优先队列中所有课程的总时间与 $t_i$ 之和大于 $d_i$，那么我们找到优先队列中的最大元素 $t_{x_j}$。如果 $t_{x_j} > t_i$，则将它移出优先队列，并把 $t_i$ 加入优先队列中。

在遍历完成后，优先队列中包含的元素个数即为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int scheduleCourse(vector<vector<int>>& courses) {
        sort(courses.begin(), courses.end(), [](const auto& c0, const auto& c1) {
            return c0[1] < c1[1];
        });

        priority_queue<int> q;
        // 优先队列中所有课程的总时间
        int total = 0;

        for (const auto& course: courses) {
            int ti = course[0], di = course[1];
            if (total + ti <= di) {
                total += ti;
                q.push(ti);
            }
            else if (!q.empty() && q.top() > ti) {
                total -= q.top() - ti;
                q.pop();
                q.push(ti);
            }
        }

        return q.size();
    }
};
```

```Java [sol1-Java]
class Solution {
    public int scheduleCourse(int[][] courses) {
        Arrays.sort(courses, (a, b) -> a[1] - b[1]);

        PriorityQueue<Integer> q = new PriorityQueue<Integer>((a, b) -> b - a);
        // 优先队列中所有课程的总时间
        int total = 0;

        for (int[] course : courses) {
            int ti = course[0], di = course[1];
            if (total + ti <= di) {
                total += ti;
                q.offer(ti);
            } else if (!q.isEmpty() && q.peek() > ti) {
                total -= q.poll() - ti;
                q.offer(ti);
            }
        }

        return q.size();
    }
}
```

```Python [sol1-Python3]
class Solution:
    def scheduleCourse(self, courses: List[List[int]]) -> int:
        courses.sort(key=lambda c: c[1])

        q = list()
        # 优先队列中所有课程的总时间
        total = 0

        for ti, di in courses:
            if total + ti <= di:
                total += ti
                # Python 默认是小根堆
                heapq.heappush(q, -ti)
            elif q and -q[0] > ti:
                total -= -q[0] - ti
                heapq.heappop(q)
                heapq.heappush(q, -ti)

        return len(q)
```

```go [sol1-Golang]
func scheduleCourse(courses [][]int) int {
    sort.Slice(courses, func(i, j int) bool {
        return courses[i][1] < courses[j][1]
    })

    h := &Heap{}
    total := 0 // 优先队列中所有课程的总时间
    for _, course := range courses {
        if t := course[0]; total+t <= course[1] {
            total += t
            heap.Push(h, t)
        } else if h.Len() > 0 && t < h.IntSlice[0] {
            total += t - h.IntSlice[0]
            h.IntSlice[0] = t
            heap.Fix(h, 0)
        }
    }
    return h.Len()
}

type Heap struct {
    sort.IntSlice
}

func (h Heap) Less(i, j int) bool {
    return h.IntSlice[i] > h.IntSlice[j]
}

func (h *Heap) Push(x interface{}) {
    h.IntSlice = append(h.IntSlice, x.(int))
}

func (h *Heap) Pop() interface{} {
    a := h.IntSlice
    x := a[len(a)-1]
    h.IntSlice = a[:len(a)-1]
    return x
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$。排序需要 $O(n \log n)$ 的时间，优先队列的单次操作需要 $O(\log n)$ 的时间，每个任务会最多被放入和取出优先队列一次，这一部分的时间复杂度为 $O(n \log n)$。因此总时间复杂度也为 $O(n \log n)$。

- 空间复杂度：$O(n)$，即为优先队列需要使用的空间。
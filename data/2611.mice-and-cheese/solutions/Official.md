#### 方法一：贪心 + 排序

有 $n$ 块不同类型的奶酪，分别位于下标 $0$ 到 $n - 1$。下标 $i$ 处的奶酪被第一只老鼠吃掉的得分为 $\textit{reward}_1[i]$，被第二只老鼠吃掉的得分为 $\textit{reward}_2[i]$。

如果 $n$ 块奶酪都被第二只老鼠吃掉，则得分为数组 $\textit{reward}_2$ 的元素之和，记为 $\textit{sum}$。如果下标 $i$ 处的奶酪被第一只老鼠吃掉，则得分的变化量是 $\textit{reward}_1[i] - \textit{reward}_2[i]$。

创建长度为 $n$ 的数组 $\textit{diffs}$，其中 $\textit{diffs}[i] = \textit{reward}_1[i] - \textit{reward}_2[i]$。题目要求计算第一只老鼠恰好吃掉 $k$ 块奶酪的情况下的最大得分，假设第一只老鼠吃掉的 $k$ 块奶酪的下标分别是 $i_1$ 到 $i_k$，则总得分为：

$$
\textit{sum} + \sum_{j = 1}^k \textit{diffs}[i_j]
$$

其中 $\textit{sum}$ 为确定的值。根据贪心思想，为了使总得分最大化，应使下标 $i_1$ 到 $i_k$ 对应的 $\textit{diffs}$ 的值最大，即应该选择 $\textit{diffs}$ 中的 $k$ 个最大值。

贪心思想的正确性说明如下：假设下标 $i_1$ 到 $i_k$ 对应的 $\textit{diffs}$ 的值不是最大的 $k$ 个值，则一定存在下标 $i_j$ 和下标 $p$ 满足 $\textit{diffs}[p] \ge \textit{diffs}[i_j]$ 且 $p$ 不在 $i_1$ 到 $i_k$ 的 $k$ 个下标中，将 $\textit{diffs}[i_j]$ 替换成 $\textit{diffs}[p]$ 之后的总得分不变或增加。因此使用贪心思想可以使总得分最大。

具体做法是，将数组 $\textit{diffs}$ 排序，然后计算 $\textit{sum}$ 与数组 $\textit{diffs}$ 的 $k$ 个最大值之和，即为第一只老鼠恰好吃掉 $k$ 块奶酪的情况下的最大得分。

```Java [sol1-Java]
class Solution {
    public int miceAndCheese(int[] reward1, int[] reward2, int k) {
        int ans = 0;
        int n = reward1.length;
        int[] diffs = new int[n];
        for (int i = 0; i < n; i++) {
            ans += reward2[i];
            diffs[i] = reward1[i] - reward2[i];
        }
        Arrays.sort(diffs);
        for (int i = 1; i <= k; i++) {
            ans += diffs[n - i];
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MiceAndCheese(int[] reward1, int[] reward2, int k) {
        int ans = 0;
        int n = reward1.Length;
        int[] diffs = new int[n];
        for (int i = 0; i < n; i++) {
            ans += reward2[i];
            diffs[i] = reward1[i] - reward2[i];
        }
        Array.Sort(diffs);
        for (int i = 1; i <= k; i++) {
            ans += diffs[n - i];
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int miceAndCheese(vector<int>& reward1, vector<int>& reward2, int k) {
        int ans = 0;
        int n = reward1.size();
        vector<int> diffs(n);
        for (int i = 0; i < n; i++) {
            ans += reward2[i];
            diffs[i] = reward1[i] - reward2[i];
        }
        sort(diffs.begin(), diffs.end());
        for (int i = 1; i <= k; i++) {
            ans += diffs[n - i];
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def miceAndCheese(self, reward1: List[int], reward2: List[int], k: int) -> int:
        ans = 0
        n = len(reward1)
        diffs = [reward1[i] - reward2[i] for i in range(n)]
        ans += sum(reward2)
        diffs.sort()
        for i in range(1, k+1):
            ans += diffs[n - i]
        return ans
```

```Go [sol1-Go]
func miceAndCheese(reward1 []int, reward2 []int, k int) int {
    ans := 0
    n := len(reward1)
    diffs := make([]int, n)
    for i:= 0; i < n; i++ {
        ans += reward2[i]
        diffs[i] = reward1[i] - reward2[i]
    }
    sort.Ints(diffs)
    for i:=1; i <= k; i++ {
        ans += diffs[n - i]
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var miceAndCheese = function(reward1, reward2, k) {
    let ans = 0;
    let n = reward1.length;
    let diffs = new Array(n);
    for (let i = 0; i < n; i++) {
        ans += reward2[i];
        diffs[i] = reward1[i] - reward2[i];
    }
    diffs.sort((a, b) => a - b);
    for (let i = 1; i <= k; i++) {
        ans += diffs[n - i];
    }
    return ans;
}
```

```C [sol1-C]
static int cmp(const void* pa, const void* pb) {
    return *(int *)pa - *(int *)pb;
}

int miceAndCheese(int* reward1, int reward1Size, int* reward2, int reward2Size, int k) {
    int ans = 0;
    int n = reward1Size;
    int diffs[n];
    for (int i = 0; i < n; i++) {
        ans += reward2[i];
        diffs[i] = reward1[i] - reward2[i];
    }
    qsort(diffs, n, sizeof(int), cmp);
    for (int i = 1; i <= k; i++) {
        ans += diffs[n - i];
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{reward}_1$ 和 $\textit{reward}_2$ 的长度。创建数组 $\textit{diffs}$ 需要 $O(n)$ 的时间，将数组 $\textit{diffs}$ 排序需要 $O(n \log n)$ 的时间，排序后计算 $\textit{diffs}$ 的 $k$ 个最大值之和需要 $O(k)$ 的时间，其中 $k \le n$，因此时间复杂度是 $O(n \log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{reward}_1$ 和 $\textit{reward}_2$ 的长度。需要创建长度为 $n$ 的数组 $\textit{diffs}$ 并排序，数组需要 $O(n)$ 的空间，排序需要 $O(\log n)$ 的递归调用栈空间，因此空间复杂度是 $O(n)$。

#### 方法二：贪心 + 优先队列

方法一当中，计算最大得分的做法是创建长度为 $n$ 的数组 $\textit{diffs}$，其中 $\textit{diffs}[i] = \textit{reward}_1[i] - \textit{reward}_2[i]$，将数组 $\textit{diffs}$ 排序之后计算 $\textit{sum}$ 与数组 $\textit{diffs}$ 的 $k$ 个最大值之和。也可以使用优先队列存储数组 $\textit{diffs}$ 中的 $k$ 个最大值，优先队列的队首元素为最小元素，优先队列的空间是 $O(k)$。

用 $\textit{sum}$ 表示数组 $\textit{reward}_2$ 的元素之和。同时遍历数组 $\textit{reward}_1$ 和 $\textit{reward}_2$，当遍历到下标 $i$ 时，执行如下操作。

1. 将 $\textit{reward}_1[i] - \textit{reward}_2[i]$ 添加到优先队列。

2. 如果优先队列中的元素个数大于 $k$，则取出优先队列的队首元素，确保优先队列中的元素个数不超过 $k$。

遍历结束时，优先队列中有 $k$ 个元素，为数组 $\textit{reward}_1$ 和 $\textit{reward}_2$ 的 $k$ 个最大差值。计算 $\textit{sum}$ 与优先队列中的 $k$ 个元素之和，即为第一只老鼠恰好吃掉 $k$ 块奶酪的情况下的最大得分。

```Java [sol2-Java]
class Solution {
    public int miceAndCheese(int[] reward1, int[] reward2, int k) {
        int ans = 0;
        int n = reward1.length;
        PriorityQueue<Integer> pq = new PriorityQueue<Integer>();
        for (int i = 0; i < n; i++) {
            ans += reward2[i];
            pq.offer(reward1[i] - reward2[i]);
            if (pq.size() > k) {
                pq.poll();
            }
        }
        while (!pq.isEmpty()) {
            ans += pq.poll();
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MiceAndCheese(int[] reward1, int[] reward2, int k) {
        int ans = 0;
        int n = reward1.Length;
        PriorityQueue<int, int> pq = new PriorityQueue<int, int>();
        for (int i = 0; i < n; i++) {
            ans += reward2[i];
            pq.Enqueue(reward1[i] - reward2[i], reward1[i] - reward2[i]);
            if (pq.Count > k) {
                pq.Dequeue();
            }
        }
        while (pq.Count > 0) {
            ans += pq.Dequeue();
        }
        return ans;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int miceAndCheese(vector<int>& reward1, vector<int>& reward2, int k) {
        int ans = 0;
        int n = reward1.size();
        priority_queue<int, vector<int>, greater<int>> pq;
        for (int i = 0; i < n; i++) {
            ans += reward2[i];
            pq.emplace(reward1[i] - reward2[i]);
            if (pq.size() > k) {
                pq.pop();
            }
        }
        while (!pq.empty()) {
            ans += pq.top();
            pq.pop();
        }
        return ans;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def miceAndCheese(self, reward1: List[int], reward2: List[int], k: int) -> int:
        ans = 0
        n = len(reward1)
        pq = []
        for i in range(n):
            ans += reward2[i]
            heappush(pq, reward1[i] - reward2[i])
            if len(pq) > k:
                heappop(pq)
        while pq:
            ans += heappop(pq)
        return ans
```

```Go [sol2-Go]
type IntHeap []int
 
func (h IntHeap) Less(i, j int) bool {
    return h[i] < h[j]
}
func (h IntHeap) Swap(i, j int) {
    h[i], h[j] = h[j], h[i]
}
func (h *IntHeap) Push(x interface{}) {
    *h = append(*h, x.(int))
}
func (h IntHeap) Len() int {
    return len(h)
}
func (h *IntHeap) Pop() interface{} {
    old := *h
    n := len(old)
    x := old[n - 1]
    *h = old[:n - 1]
    return x
}

func miceAndCheese(reward1 []int, reward2 []int, k int) int {
    ans := 0
    n := len(reward1)
    pq := &IntHeap{}
    heap.Init(pq)
    for i := 0; i < n; i++ {
        ans += reward2[i]
        diff := reward1[i] - reward2[i]
        heap.Push(pq, diff)
        if pq.Len() > k {
            heap.Pop(pq)
        }
    }
    for pq.Len() > 0 {
        ans += heap.Pop(pq).(int)
    }
    return ans
}
```

```JavaScript [sol2-JavaScript]
class Heap {
    constructor() {
        this.heap = [];
    }

    push(value) {
        this.heap.push(value);
        this.bubbleUp(this.heap.length - 1);
    }

    poll() {
        const result = this.heap[0];
        const end = this.heap.pop();
        if (this.heap.length > 0) {
            this.heap[0] = end;
            this.sinkDown(0);
        }
        return result;
    }

    size() {
        return this.heap.length;
    }

    isEmpty() {
        return this.heap.length === 0;
    }

    bubbleUp(index) {
        const element = this.heap[index];
        while (index > 0) {
            const parentIndex = Math.floor((index - 1) / 2);
            const parent = this.heap[parentIndex];
            if (element >= parent) {
                break;
            }
            this.heap[parentIndex] = element;
            this.heap[index] = parent;
            index = parentIndex;
        }
    }

    sinkDown(index) {
        const element = this.heap[index];
        const length = this.heap.length;
        while (true) {
            let leftChildIndex = 2 * index + 1;
            let rightChildIndex = 2 * index + 2;
            let leftChild, rightChild;
            let swap = null;

            if (leftChildIndex < length) {
                leftChild = this.heap[leftChildIndex];
                if (leftChild < element) {
                    swap = leftChildIndex;
                }
            }

            if (rightChildIndex < length) {
                rightChild = this.heap[rightChildIndex];
                if ((swap === null && rightChild < element) ||
                    (swap !== null && rightChild < leftChild)) {
                    swap = rightChildIndex;
                }
            }

            if (swap === null) {
                break;
            }

            this.heap[index] = this.heap[swap];
            this.heap[swap] = element;
            index = swap;
        }
    }
}

var miceAndCheese = function(reward1, reward2, k) {
    let ans = 0;
    let n = reward1.length;
    let pq = new Heap();
    for (let i = 0; i < n; i++) {
        ans += reward2[i];
        pq.push(reward1[i] - reward2[i]);
        if (pq.size() > k) {
            pq.poll();
        }
    }
    while (!pq.isEmpty()) {
        ans += pq.poll();
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log k)$，其中 $n$ 是数组 $\textit{reward}_1$ 和 $\textit{reward}_2$ 的长度，$k$ 是第一只老鼠吃掉的奶酪块数。遍历两个数组的过程中，每个下标处的优先队列操作时间是 $O(\log k)$，共需要 $O(n \log k)$ 的时间，遍历数组之后计算优先队列中的 $k$ 个元素之和需要 $O(k \log k)$ 的时间，其中 $k \le n$，因此时间复杂度是 $O(n \log k + k \log k) = O(n \log k)$。

- 空间复杂度：$O(k)$，其中 $k$ 是第一只老鼠吃掉的奶酪块数。优先队列需要 $O(k)$ 的空间。
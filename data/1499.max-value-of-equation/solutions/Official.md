#### 方法一：堆

**思路**

题目要求 $y_i+y_j+|x_i-x_j|$，其中 $|x_i-x_j| \leq k$ 的最大值。根据题目条件，$i \lt j$ 时，$x_i \leq x_j $，可以拆去绝对值符号，得到 $(-x_i+y_i)+(x_j+y_j)$，其中 $x_j-x_i \leq k$。

根据这个等式，可以遍历 $\textit{points}$ 所有点，使每个点作为 $[x_j, y_j]$，并且求出满足 $x_j-x_i \leq k$ 的最大的 $(-x_i+y_i)$，而这一步，可以用堆来完成。用一个最小堆，堆的元素是 $[x-y,x]$，堆顶元素的 $(x-y)$ 值最小，即 $(-x+y)$ 值最大。每次遍历一个点时，先弹出堆顶不满足当前 $x_j-x_i \leq k$ 的元素，然后用堆顶元素和当前元素计算 $(-x_i+y_i)+(x_j+y_j)$，再将当前元素放入堆。遍历完后，即得到了式子的最大值。

**代码**

```Python [sol1-Python3]
class Solution:
    def findMaxValueOfEquation(self, points: List[List[int]], k: int) -> int:
        res = -inf
        heap = []
        for x, y in points:
            while heap and x - heap[0][1] > k:
                heappop(heap)
            if heap:
                res = max(res, x + y - heap[0][0])
            heappush(heap, [x - y, x])
        return res
```

```Java [sol1-Java]
class Solution {
    public int findMaxValueOfEquation(int[][] points, int k) {
        int res = Integer.MIN_VALUE;
        PriorityQueue<int[]> heap = new PriorityQueue<int[]>((a, b) -> a[0] - b[0]);
        for (int[] point : points) {
            int x = point[0], y = point[1];
            while (!heap.isEmpty() && x - heap.peek()[1] > k) {
                heap.poll();
            }
            if (!heap.isEmpty()) {
                res = Math.max(res, x + y - heap.peek()[0]);
            }
            heap.offer(new int[]{x - y, x});
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindMaxValueOfEquation(int[][] points, int k) {
        int res = int.MinValue;
        PriorityQueue<Tuple<int, int>, int> heap = new PriorityQueue<Tuple<int, int>, int>();
        foreach (int[] point in points) {
            int x = point[0], y = point[1];
            while (heap.Count > 0 && x - heap.Peek().Item2 > k) {
                heap.Dequeue();
            }
            if (heap.Count > 0) {
                res = Math.Max(res, x + y - heap.Peek().Item1);
            }
            heap.Enqueue(new Tuple<int, int>(x - y, x), x - y);
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    using pii = pair<int, int>;
    int findMaxValueOfEquation(vector<vector<int>>& points, int k) {
        int res = INT_MIN;
        priority_queue<pii, vector<pii>, greater<pii>> heap;
        for (auto &point : points) {
            int x = point[0], y = point[1];
            while (!heap.empty() && x - heap.top().second > k) {
                heap.pop();
            }
            if (!heap.empty()) {
                res = max(res, x + y - heap.top().first);
            }
            heap.emplace(x - y, x);
        }
        return res;
    }
};
```

```Golang [sol1-Golang]
type PriorityQueue [][]int

func (pq PriorityQueue) Len() int {
    return len(pq)
}

func (pq PriorityQueue) Swap(i, j int) {
    pq[i], pq[j] = pq[j], pq[i]
}

func (pq PriorityQueue) Less(i, j int) bool {
    if pq[i][0] != pq[j][0] {
        return pq[i][0] < pq[j][0]
    }
    return pq[i][1] < pq[j][1]
}

func (pq *PriorityQueue) Push(x any) {
    *pq = append(*pq, x.([]int))
}

func (pq *PriorityQueue) Pop() any {
    n, old := len(*pq), *pq
    x := old[n - 1]
    *pq = old[:n-1]
    return x
}

func (pq PriorityQueue) Top() []int {
    return pq[0]
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func findMaxValueOfEquation(points [][]int, k int) int {
    res := -0x3f3f3f3f
    pq := &PriorityQueue{}
    for _, point := range points {
        x, y := point[0], point[1]
        for pq.Len() > 0 && x - pq.Top()[1] > k {
            heap.Pop(pq)
        }
        if pq.Len() > 0 {
            res = max(res, x + y - pq.Top()[0])
        }
        heap.Push(pq, []int{x - y, x})
    }
    return res
}
```

```JavaScript [sol1-JavaScript]
var findMaxValueOfEquation = function (points, k) {
    let res = Number.MIN_SAFE_INTEGER;
    const heap = new MinHeap((a, b) => a[0] < b[0]);
    for (const point of points) {
        const x = point[0], y = point[1];
        while (heap.size !== 0 && x - heap.peek()[1] > k) {
            heap.poll();
        }
        if (heap.size !== 0) {
            res = Math.max(res, x + y - heap.peek()[0]);
        }
        heap.add([x - y, x]);
    }
    return res;
};

class MinHeap {
    constructor(compareFunc = (a, b) => a < b) {
        this.compare = compareFunc;
        this.heap = [];
    }

    get size() {
        return this.heap.length;
    }

    peek() {
        return this.heap[0];
    }

    add(value) {
        this.heap.push(value);
        this.heapifyUp();
    }

    poll() {
        if (this.size === 0) {
            return null;
        }
        if (this.size === 1) {
            return this.heap.pop();
        }
        const max = this.heap[0];
        this.heap[0] = this.heap.pop();
        this.heapifyDown();
        return max;
    }

    heapifyUp() {
        let currentIndex = this.size - 1;
        while (currentIndex > 0) {
            const parentIndex = Math.floor((currentIndex - 1) / 2);
            if (this.compare(this.heap[currentIndex], this.heap[parentIndex])) {
                [this.heap[currentIndex], this.heap[parentIndex]] = [this.heap[parentIndex], this.heap[currentIndex]];
                currentIndex = parentIndex;
            } else {
                break;
            }
        }
    }

    heapifyDown() {
        let currentIndex = 0;
        while (currentIndex < this.size) {
            let largestIndex = currentIndex;
            const leftChildIndex = 2 * currentIndex + 1;
            const rightChildIndex = 2 * currentIndex + 2;
            if (leftChildIndex < this.size && this.compare(this.heap[leftChildIndex], this.heap[largestIndex])) {
                largestIndex = leftChildIndex;
            }
            if (rightChildIndex < this.size && this.compare(this.heap[rightChildIndex], this.heap[largestIndex])) {
                largestIndex = rightChildIndex;
            }
            if (largestIndex !== currentIndex) {
                [this.heap[currentIndex], this.heap[largestIndex]] = [this.heap[largestIndex], this.heap[currentIndex]];
                currentIndex = largestIndex;
            } else {
                break;
            }
        }
    }
}
```

**复杂度分析**

- 时间复杂度：$O(n \times \log n)$，其中 $n$ 是 $\textit{points}$ 的长度，每个元素最多进入并离开 $\textit{heap}$ 一次。

- 空间复杂度：$O(n)$，是 $\textit{heap}$ 的空间复杂度。

#### 方法二：双端队列

**思路**

与方法一思路类似，方法一用堆来求满足 $x_j-x_i \leq k$ 的最大的 $(-x_i+y_i)$，而这一步可以用双端队列来求，从而降低时间复杂度。使用一个双端队列 $q$，元素为 $[y-x,x]$。每次遍历一个点时，首先同样要弹出队列头部不满足 $x_j-x_i \leq k$ 的元素，然后用队列头部元素和当前元素计算 $(y_i-x_i)+(x_j+y_j)$。在当前元素进入队列尾端时，需要弹出队列末端小于等于当前 $y_j-x_j$ 的元素，这样以来，可以使得双端队列保持递减，从而头部元素最大。然后将当前元素压入队列末端。遍历完后，即得到了式子的最大值。

**代码**

```Python [sol2-Python3]
class Solution:
    def findMaxValueOfEquation(self, points: List[List[int]], k: int) -> int:
        res = -inf
        q = deque()
        for x, y in points:
            while q and x - q[0][1] > k:
                q.popleft()
            if q:
                res = max(res, x + y + q[0][0])
            while q and y - x >= q[-1][0]:
                q.pop()
            q.append([y - x, x])
        return res
```

```Java [sol2-Java]
class Solution {
    public int findMaxValueOfEquation(int[][] points, int k) {
        int res = Integer.MIN_VALUE;
        Deque<int[]> queue = new ArrayDeque<int[]>();
        for (int[] point : points) {
            int x = point[0], y = point[1];
            while (!queue.isEmpty() && x - queue.peekFirst()[1] > k) {
                queue.pollFirst();
            }
            if (!queue.isEmpty()) {
                res = Math.max(res, x + y + queue.peekFirst()[0]);
            }
            while (!queue.isEmpty() && y - x >= queue.peekLast()[0]) {
                queue.pollLast();
            }
            queue.offer(new int[]{y - x, x});
        }
        return res;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    using pii = pair<int, int>;
    int findMaxValueOfEquation(vector<vector<int>>& points, int k) {
        int res = INT_MIN;
        deque<pii> qu;
        for (auto &point : points) {
            int x = point[0], y = point[1];
            while (!qu.empty() && x - qu.front().second > k) {
                qu.pop_front();
            }
            if (!qu.empty()) {
                res = max(res, x + y + qu.front().first);
            }
            while (!qu.empty() && y - x >= qu.back().first) {
                qu.pop_back();
            }
            qu.emplace_back(y - x, x);
        }
        return res;
    }
};
```

```Golang [sol2-Golang]
func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func findMaxValueOfEquation(points [][]int, k int) int {
    res := -0x3f3f3f3f
    q := [][]int{}
    for _, point := range points {
        x, y := point[0], point[1]
        for len(q) > 0 && x - q[0][1] > k {
            q = q[1:]
        }
        if len(q) > 0 {
            res = max(res, x + y + q[0][0])
        }
        for len(q) > 0 && y - x >= q[len(q) - 1][0] {
            q = q[:len(q) - 1]
        }
        q = append(q, []int{y - x, x})
    }
    return res
}
```

```C [sol2-C]
int findMaxValueOfEquation(int** points, int pointsSize, int* pointsColSize, int k) {
    int res = INT_MIN;
    int deque[pointsSize][2];
    int head = 0, tail = 0;
    for (int i = 0; i < pointsSize; i++) {
        int x = points[i][0], y = points[i][1];
        while (head != tail && x - deque[head][1] > k) {
            head++;
        }
        if (head != tail) {
            res = fmax(res, x + y + deque[head][0]);
        }
        while (head != tail && y - x >= deque[tail - 1][0]) {
            tail--;
        }
        deque[tail][0] = y - x;
        deque[tail][1] = x;
        tail++;
    }
    return res;
}
```

```JavaScript [sol2-JavaScript]
var findMaxValueOfEquation = function(points, k) {
    let res = Number.MIN_SAFE_INTEGER;
    const queue = [];
    for (const point of points) {
        let x = point[0], y = point[1];
        while (queue.length !== 0 && x - queue[0][1] > k) {
            queue.shift();
        }
        if (queue.length !== 0) {
            res = Math.max(res, x + y + queue[0][0]);
        }
        while (queue.length !== 0 && y - x >= queue[queue.length - 1][0]) {
            queue.pop();
        }
        queue.push([y - x, x]);
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{points}$ 的长度，每个元素最多进入并离开 $q$ 一次。

- 空间复杂度：$O(n)$，是 $q$ 的空间复杂度。
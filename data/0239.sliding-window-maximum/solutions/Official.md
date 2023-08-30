#### 前言

对于每个滑动窗口，我们可以使用 $O(k)$ 的时间遍历其中的每一个元素，找出其中的最大值。对于长度为 $n$ 的数组 $\textit{nums}$ 而言，窗口的数量为 $n-k+1$，因此该算法的时间复杂度为 $O((n-k+1)k)=O(nk)$，会超出时间限制，因此我们需要进行一些优化。

我们可以想到，对于两个相邻（只差了一个位置）的滑动窗口，它们共用着 $k-1$ 个元素，而只有 $1$ 个元素是变化的。我们可以根据这个特点进行优化。

#### 方法一：优先队列

**思路与算法**

对于「最大值」，我们可以想到一种非常合适的数据结构，那就是优先队列（堆），其中的大根堆可以帮助我们实时维护一系列元素中的最大值。

对于本题而言，初始时，我们将数组 $\textit{nums}$ 的前 $k$ 个元素放入优先队列中。每当我们向右移动窗口时，我们就可以把一个新的元素放入优先队列中，此时堆顶的元素就是堆中所有元素的最大值。然而这个最大值可能并不在滑动窗口中，在这种情况下，**这个值在数组 $\textit{nums}$ 中的位置出现在滑动窗口左边界的左侧**。因此，当我们后续继续向右移动窗口时，这个值就永远不可能出现在滑动窗口中了，我们可以将其永久地从优先队列中移除。

我们不断地移除堆顶的元素，直到其确实出现在滑动窗口中。此时，堆顶元素就是滑动窗口中的最大值。为了方便判断堆顶元素与滑动窗口的位置关系，我们可以在优先队列中存储二元组 $(\textit{num}, \textit{index})$，表示元素 $\textit{num}$ 在数组中的下标为 $\textit{index}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> maxSlidingWindow(vector<int>& nums, int k) {
        int n = nums.size();
        priority_queue<pair<int, int>> q;
        for (int i = 0; i < k; ++i) {
            q.emplace(nums[i], i);
        }
        vector<int> ans = {q.top().first};
        for (int i = k; i < n; ++i) {
            q.emplace(nums[i], i);
            while (q.top().second <= i - k) {
                q.pop();
            }
            ans.push_back(q.top().first);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] maxSlidingWindow(int[] nums, int k) {
        int n = nums.length;
        PriorityQueue<int[]> pq = new PriorityQueue<int[]>(new Comparator<int[]>() {
            public int compare(int[] pair1, int[] pair2) {
                return pair1[0] != pair2[0] ? pair2[0] - pair1[0] : pair2[1] - pair1[1];
            }
        });
        for (int i = 0; i < k; ++i) {
            pq.offer(new int[]{nums[i], i});
        }
        int[] ans = new int[n - k + 1];
        ans[0] = pq.peek()[0];
        for (int i = k; i < n; ++i) {
            pq.offer(new int[]{nums[i], i});
            while (pq.peek()[1] <= i - k) {
                pq.poll();
            }
            ans[i - k + 1] = pq.peek()[0];
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maxSlidingWindow(self, nums: List[int], k: int) -> List[int]:
        n = len(nums)
        # 注意 Python 默认的优先队列是小根堆
        q = [(-nums[i], i) for i in range(k)]
        heapq.heapify(q)

        ans = [-q[0][0]]
        for i in range(k, n):
            heapq.heappush(q, (-nums[i], i))
            while q[0][1] <= i - k:
                heapq.heappop(q)
            ans.append(-q[0][0])
        
        return ans
```

```go [sol1-Golang]
var a []int
type hp struct{ sort.IntSlice }
func (h hp) Less(i, j int) bool  { return a[h.IntSlice[i]] > a[h.IntSlice[j]] }
func (h *hp) Push(v interface{}) { h.IntSlice = append(h.IntSlice, v.(int)) }
func (h *hp) Pop() interface{}   { a := h.IntSlice; v := a[len(a)-1]; h.IntSlice = a[:len(a)-1]; return v }

func maxSlidingWindow(nums []int, k int) []int {
    a = nums
    q := &hp{make([]int, k)}
    for i := 0; i < k; i++ {
        q.IntSlice[i] = i
    }
    heap.Init(q)

    n := len(nums)
    ans := make([]int, 1, n-k+1)
    ans[0] = nums[q.IntSlice[0]]
    for i := k; i < n; i++ {
        heap.Push(q, i)
        for q.IntSlice[0] <= i-k {
            heap.Pop(q)
        }
        ans = append(ans, nums[q.IntSlice[0]])
    }
    return ans
}
```

```C [sol1-C]
void swap(int** a, int** b) {
    int* tmp = *a;
    *a = *b, *b = tmp;
}

int cmp(int* a, int* b) {
    return a[0] == b[0] ? a[1] - b[1] : a[0] - b[0];
}

struct Heap {
    int** heap;
    int size;
    int capacity;
};

void init(struct Heap* obj, int capacity) {
    obj->size = 0;
    obj->heap = NULL;
    obj->capacity = capacity;
    obj->heap = malloc(sizeof(int*) * (obj->capacity + 1));
    for (int i = 1; i <= obj->capacity; i++) {
        obj->heap[i] = malloc(sizeof(int) * 2);
    }
}

void setFree(struct Heap* obj) {
    for (int i = 1; i <= obj->capacity; i++) {
        free(obj->heap[i]);
    }
    free(obj->heap);
    free(obj);
}

void push(struct Heap* obj, int num0, int num1) {
    int sub1 = ++(obj->size), sub2 = sub1 >> 1;
    (obj->heap[sub1])[0] = num0, (obj->heap[sub1])[1] = num1;
    while (sub2 > 0 && cmp(obj->heap[sub2], obj->heap[sub1]) < 0) {
        swap(&(obj->heap[sub1]), &(obj->heap[sub2]));
        sub1 = sub2, sub2 = sub1 >> 1;
    }
}

void pop(struct Heap* obj) {
    int sub = 1;
    swap(&(obj->heap[sub]), &(obj->heap[(obj->size)--]));
    while (sub <= obj->size) {
        int sub1 = sub << 1, sub2 = sub << 1 | 1;
        int maxSub = sub;
        if (sub1 <= obj->size && cmp(obj->heap[maxSub], obj->heap[sub1]) < 0) {
            maxSub = sub1;
        }
        if (sub2 <= obj->size && cmp(obj->heap[maxSub], obj->heap[sub2]) < 0) {
            maxSub = sub2;
        }
        if (sub == maxSub) {
            break;
        }
        swap(&(obj->heap[sub]), &(obj->heap[maxSub]));
        sub = maxSub;
    }
}

int* top(struct Heap* obj) {
    return obj->heap[1];
}

int* maxSlidingWindow(int* nums, int numsSize, int k, int* returnSize) {
    struct Heap* q = malloc(sizeof(struct Heap));
    init(q, numsSize);
    for (int i = 0; i < k; i++) {
        push(q, nums[i], i);
    }
    int* ans = malloc(sizeof(int) * (numsSize - k + 1));
    *returnSize = 0;
    ans[(*returnSize)++] = top(q)[0];

    for (int i = k; i < numsSize; ++i) {
        push(q, nums[i], i);
        while (top(q)[1] <= i - k) {
            pop(q);
        }
        ans[(*returnSize)++] = top(q)[0];
    }
    setFree(q);
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。在最坏情况下，数组 $\textit{nums}$ 中的元素单调递增，那么最终优先队列中包含了所有元素，没有元素被移除。由于将一个元素放入优先队列的时间复杂度为 $O(\log n)$，因此总时间复杂度为 $O(n \log n)$。

- 空间复杂度：$O(n)$，即为优先队列需要使用的空间。**这里所有的空间复杂度分析都不考虑返回的答案需要的 $O(n)$ 空间，只计算额外的空间使用。**

#### 方法二：单调队列

**思路与算法**

我们可以顺着方法一的思路继续进行优化。

由于我们需要求出的是滑动窗口的最大值，如果当前的滑动窗口中有两个下标 $i$ 和 $j$，其中 $i$ 在 $j$ 的左侧（$i < j$），并且 $i$ 对应的元素不大于 $j$ 对应的元素（$\textit{nums}[i] \leq \textit{nums}[j]$），那么会发生什么呢？

当滑动窗口向右移动时，**只要 $i$ 还在窗口中，那么 $j$ 一定也还在窗口中**，这是 $i$ 在 $j$ 的左侧所保证的。因此，由于 $\textit{nums}[j]$ 的存在，**$\textit{nums}[i]$ 一定不会是滑动窗口中的最大值了**，我们可以将 $\textit{nums}[i]$ 永久地移除。

因此我们可以使用一个队列存储所有还没有被移除的下标。在队列中，这些下标按照从小到大的顺序被存储，并且它们在数组 $\textit{nums}$ 中对应的值是严格单调递减的。因为如果队列中有两个相邻的下标，它们对应的值相等或者递增，那么令前者为 $i$，后者为 $j$，就对应了上面所说的情况，即 $\textit{nums}[i]$ 会被移除，这就产生了矛盾。

当滑动窗口向右移动时，我们需要把一个新的元素放入队列中。为了保持队列的性质，我们会不断地将新的元素与队尾的元素相比较，如果前者大于等于后者，那么队尾的元素就可以被永久地移除，我们将其弹出队列。我们需要不断地进行此项操作，直到队列为空或者新的元素小于队尾的元素。

由于队列中下标对应的元素是严格单调递减的，因此此时队首下标对应的元素就是滑动窗口中的最大值。但与方法一中相同的是，此时的最大值可能在滑动窗口左边界的左侧，并且随着窗口向右移动，它永远不可能出现在滑动窗口中了。因此我们还需要不断从队首弹出元素，直到队首元素在窗口中为止。

为了可以同时弹出队首和队尾的元素，我们需要使用双端队列。满足这种单调性的双端队列一般称作「单调队列」。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    vector<int> maxSlidingWindow(vector<int>& nums, int k) {
        int n = nums.size();
        deque<int> q;
        for (int i = 0; i < k; ++i) {
            while (!q.empty() && nums[i] >= nums[q.back()]) {
                q.pop_back();
            }
            q.push_back(i);
        }

        vector<int> ans = {nums[q.front()]};
        for (int i = k; i < n; ++i) {
            while (!q.empty() && nums[i] >= nums[q.back()]) {
                q.pop_back();
            }
            q.push_back(i);
            while (q.front() <= i - k) {
                q.pop_front();
            }
            ans.push_back(nums[q.front()]);
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int[] maxSlidingWindow(int[] nums, int k) {
        int n = nums.length;
        Deque<Integer> deque = new LinkedList<Integer>();
        for (int i = 0; i < k; ++i) {
            while (!deque.isEmpty() && nums[i] >= nums[deque.peekLast()]) {
                deque.pollLast();
            }
            deque.offerLast(i);
        }

        int[] ans = new int[n - k + 1];
        ans[0] = nums[deque.peekFirst()];
        for (int i = k; i < n; ++i) {
            while (!deque.isEmpty() && nums[i] >= nums[deque.peekLast()]) {
                deque.pollLast();
            }
            deque.offerLast(i);
            while (deque.peekFirst() <= i - k) {
                deque.pollFirst();
            }
            ans[i - k + 1] = nums[deque.peekFirst()];
        }
        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def maxSlidingWindow(self, nums: List[int], k: int) -> List[int]:
        n = len(nums)
        q = collections.deque()
        for i in range(k):
            while q and nums[i] >= nums[q[-1]]:
                q.pop()
            q.append(i)

        ans = [nums[q[0]]]
        for i in range(k, n):
            while q and nums[i] >= nums[q[-1]]:
                q.pop()
            q.append(i)
            while q[0] <= i - k:
                q.popleft()
            ans.append(nums[q[0]])
        
        return ans
```

```go [sol2-Golang]
func maxSlidingWindow(nums []int, k int) []int {
    q := []int{}
    push := func(i int) {
        for len(q) > 0 && nums[i] >= nums[q[len(q)-1]] {
            q = q[:len(q)-1]
        }
        q = append(q, i)
    }

    for i := 0; i < k; i++ {
        push(i)
    }

    n := len(nums)
    ans := make([]int, 1, n-k+1)
    ans[0] = nums[q[0]]
    for i := k; i < n; i++ {
        push(i)
        for q[0] <= i-k {
            q = q[1:]
        }
        ans = append(ans, nums[q[0]])
    }
    return ans
}
```

```C [sol2-C]
int* maxSlidingWindow(int* nums, int numsSize, int k, int* returnSize) {
    int q[numsSize];
    int left = 0, right = 0;
    for (int i = 0; i < k; ++i) {
        while (left < right && nums[i] >= nums[q[right - 1]]) {
            right--;
        }
        q[right++] = i;
    }
    *returnSize = 0;
    int* ans = malloc(sizeof(int) * (numsSize - k + 1));
    ans[(*returnSize)++] = nums[q[left]];
    for (int i = k; i < numsSize; ++i) {
        while (left < right && nums[i] >= nums[q[right - 1]]) {
            right--;
        }
        q[right++] = i;
        while (q[left] <= i - k) {
            left++;
        }
        ans[(*returnSize)++] = nums[q[left]];
    }
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var maxSlidingWindow = function(nums, k) {
    const n = nums.length;
    const q = [];
    for (let i = 0; i < k; i++) {
        while (q.length && nums[i] >= nums[q[q.length - 1]]) {
            q.pop();
        }
        q.push(i);
    }

    const ans = [nums[q[0]]];
    for (let i = k; i < n; i++) {
        while (q.length && nums[i] >= nums[q[q.length - 1]]) {
            q.pop();
        }
        q.push(i);
        while (q[0] <= i - k) {
            q.shift();
        }
        ans.push(nums[q[0]]);
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。每一个下标恰好被放入队列一次，并且最多被弹出队列一次，因此时间复杂度为 $O(n)$。

- 空间复杂度：$O(k)$。与方法一不同的是，在方法二中我们使用的数据结构是双向的，因此「不断从队首弹出元素」保证了队列中最多不会有超过 $k+1$ 个元素，因此队列使用的空间为 $O(k)$。

#### 方法三：分块 + 预处理

**思路与算法**

除了基于「随着窗口的移动实时维护最大值」的方法一以及方法二之外，我们还可以考虑其他有趣的做法。

我们可以将数组 $\textit{nums}$ 从左到右按照 $k$ 个一组进行分组，最后一组中元素的数量可能会不足 $k$ 个。如果我们希望求出 $\textit{nums}[i]$ 到 $\textit{nums}[i+k-1]$ 的最大值，就会有两种情况：

- 如果 $i$ 是 $k$ 的倍数，那么 $\textit{nums}[i]$ 到 $\textit{nums}[i+k-1]$ 恰好是一个分组。我们只要预处理出每个分组中的最大值，即可得到答案；

- 如果 $i$ 不是 $k$ 的倍数，那么 $\textit{nums}[i]$ 到 $\textit{nums}[i+k-1]$ 会跨越两个分组，**占有第一个分组的后缀以及第二个分组的前缀**。假设 $j$ 是 $k$ 的倍数，并且满足 $i < j \leq i+k-1$，那么 $\textit{nums}[i]$ 到 $\textit{nums}[j-1]$ 就是第一个分组的后缀，$\textit{nums}[j]$ 到 $\textit{nums}[i+k-1]$ 就是第二个分组的前缀。如果我们能够预处理出每个分组中的前缀最大值以及后缀最大值，同样可以在 $O(1)$ 的时间得到答案。

因此我们用 $\textit{prefixMax}[i]$ 表示下标 $i$ 对应的分组中，以 $i$ 结尾的前缀最大值；$\textit{suffixMax}[i]$ 表示下标 $i$ 对应的分组中，以 $i$ 开始的后缀最大值。它们分别满足如下的递推式

$$
\textit{prefixMax}[i]=\begin{cases}
\textit{nums}[i], & \quad i ~是~ k ~的倍数 \\
\max\{ \textit{prefixMax}[i-1], \textit{nums}[i] \}, & \quad i ~不是~ k ~的倍数
\end{cases}
$$

以及

$$
\textit{suffixMax}[i]=\begin{cases}
\textit{nums}[i], & \quad i+1 ~是~ k ~的倍数 \\
\max\{ \textit{suffixMax}[i+1], \textit{nums}[i] \}, & \quad i+1 ~不是~ k ~的倍数
\end{cases}
$$

需要注意在递推 $\textit{suffixMax}[i]$ 时需要考虑到边界条件 $\textit{suffixMax}[n-1]=\textit{nums}[n-1]$，而在递推 $\textit{prefixMax}[i]$ 时的边界条件 $\textit{prefixMax}[0]=\textit{nums}[0]$ 恰好包含在递推式的第一种情况中，因此无需特殊考虑。

在预处理完成之后，对于 $\textit{nums}[i]$ 到 $\textit{nums}[i+k-1]$ 的所有元素，如果 $i$ 不是 $k$ 的倍数，那么窗口中的最大值为 $\textit{suffixMax}[i]$ 与 $\textit{prefixMax}[i+k-1]$ 中的较大值；如果 $i$ 是 $k$ 的倍数，那么此时窗口恰好对应一整个分组，$\textit{suffixMax}[i]$ 和 $\textit{prefixMax}[i+k-1]$ 都等于分组中的最大值，因此无论窗口属于哪一种情况，

$$
\max\big\{ \textit{suffixMax}[i], \textit{prefixMax}[i+k-1] \big\}
$$

即为答案。

这种方法与稀疏表（Sparse Table）非常类似，感兴趣的读者可以自行查阅资料进行学习。

**代码**

```C++ [sol3-C++]
class Solution {
public:
    vector<int> maxSlidingWindow(vector<int>& nums, int k) {
        int n = nums.size();
        vector<int> prefixMax(n), suffixMax(n);
        for (int i = 0; i < n; ++i) {
            if (i % k == 0) {
                prefixMax[i] = nums[i];
            }
            else {
                prefixMax[i] = max(prefixMax[i - 1], nums[i]);
            }
        }
        for (int i = n - 1; i >= 0; --i) {
            if (i == n - 1 || (i + 1) % k == 0) {
                suffixMax[i] = nums[i];
            }
            else {
                suffixMax[i] = max(suffixMax[i + 1], nums[i]);
            }
        }

        vector<int> ans;
        for (int i = 0; i <= n - k; ++i) {
            ans.push_back(max(suffixMax[i], prefixMax[i + k - 1]));
        }
        return ans;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int[] maxSlidingWindow(int[] nums, int k) {
        int n = nums.length;
        int[] prefixMax = new int[n];
        int[] suffixMax = new int[n];
        for (int i = 0; i < n; ++i) {
            if (i % k == 0) {
                prefixMax[i] = nums[i];
            }
            else {
                prefixMax[i] = Math.max(prefixMax[i - 1], nums[i]);
            }
        }
        for (int i = n - 1; i >= 0; --i) {
            if (i == n - 1 || (i + 1) % k == 0) {
                suffixMax[i] = nums[i];
            } else {
                suffixMax[i] = Math.max(suffixMax[i + 1], nums[i]);
            }
        }

        int[] ans = new int[n - k + 1];
        for (int i = 0; i <= n - k; ++i) {
            ans[i] = Math.max(suffixMax[i], prefixMax[i + k - 1]);
        }
        return ans;
    }
}
```

```Python [sol3-Python3]
class Solution:
    def maxSlidingWindow(self, nums: List[int], k: int) -> List[int]:
        n = len(nums)
        prefixMax, suffixMax = [0] * n, [0] * n
        for i in range(n):
            if i % k == 0:
                prefixMax[i] = nums[i]
            else:
                prefixMax[i] = max(prefixMax[i - 1], nums[i])
        for i in range(n - 1, -1, -1):
            if i == n - 1 or (i + 1) % k == 0:
                suffixMax[i] = nums[i]
            else:
                suffixMax[i] = max(suffixMax[i + 1], nums[i])

        ans = [max(suffixMax[i], prefixMax[i + k - 1]) for i in range(n - k + 1)]
        return ans
```

```go [sol3-Golang]
func maxSlidingWindow(nums []int, k int) []int {
    n := len(nums)
    prefixMax := make([]int, n)
    suffixMax := make([]int, n)
    for i, v := range nums {
        if i%k == 0 {
            prefixMax[i] = v
        } else {
            prefixMax[i] = max(prefixMax[i-1], v)
        }
    }
    for i := n - 1; i >= 0; i-- {
        if i == n-1 || (i+1)%k == 0 {
            suffixMax[i] = nums[i]
        } else {
            suffixMax[i] = max(suffixMax[i+1], nums[i])
        }
    }

    ans := make([]int, n-k+1)
    for i := range ans {
        ans[i] = max(suffixMax[i], prefixMax[i+k-1])
    }
    return ans
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol3-C]
int* maxSlidingWindow(int* nums, int numsSize, int k, int* returnSize) {
    int prefixMax[numsSize], suffixMax[numsSize];
    for (int i = 0; i < numsSize; ++i) {
        if (i % k == 0) {
            prefixMax[i] = nums[i];
        } else {
            prefixMax[i] = fmax(prefixMax[i - 1], nums[i]);
        }
    }
    for (int i = numsSize - 1; i >= 0; --i) {
        if (i == numsSize - 1 || (i + 1) % k == 0) {
            suffixMax[i] = nums[i];
        } else {
            suffixMax[i] = fmax(suffixMax[i + 1], nums[i]);
        }
    }

    *returnSize = 0;
    int* ans = malloc(sizeof(int) * (numsSize - k + 1));
    for (int i = 0; i <= numsSize - k; ++i) {
        ans[(*returnSize)++] = fmax(suffixMax[i], prefixMax[i + k - 1]);
    }
    return ans;
}
```

```JavaScript [sol3-JavaScript]
var maxSlidingWindow = function(nums, k) {
    const n = nums.length;
    const prefixMax = new Array(n).fill(0);
    const suffixMax = new Array(n).fill(0);
    for (let i = 0; i < n; i++) {
        if (i % k === 0) {
            prefixMax[i] = nums[i];
        } else {
            prefixMax[i] = Math.max(prefixMax[i - 1], nums[i]);
        }
    }
    for (let i = n - 1; i >= 0; --i) {
        if (i === n || (i + 1) % k === 0) {
            suffixMax[i] = nums[i];
        } else {
            suffixMax[i] = Math.max(suffixMax[i + 1], nums[i]);
        }
    }
    const ans = [];
    for (let i = 0; i < n - k + 1; i++) {
        ans.push(Math.max(suffixMax[i], prefixMax[i + k - 1]));
    }
    return ans;
};  
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。我们需要 $O(n)$ 的时间预处理出数组 $\textit{prefixMax}$，$\textit{suffixMax}$ 以及计算答案。

- 空间复杂度：$O(n)$，即为存储 $\textit{prefixMax}$ 和 $\textit{suffixMax}$ 需要的空间。
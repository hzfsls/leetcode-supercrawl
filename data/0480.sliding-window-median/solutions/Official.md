## [480.滑动窗口中位数 中文官方题解](https://leetcode.cn/problems/sliding-window-median/solutions/100000/hua-dong-chuang-kou-zhong-wei-shu-by-lee-7ai6)
#### 前言

本题是「[295. 数据流的中位数](https://leetcode-cn.com/problems/find-median-from-data-stream/)」的进阶版本。

我们首先思考一下完成本题需要做哪些事情：

- 初始时，我们需要将数组 $\textit{nums}$ 中的前 $k$ 个元素放入一个滑动窗口，并且求出它们的中位数；

- 随后滑动窗口会向右进行移动。每一次移动后，会将一个新的元素放入滑动窗口，并且将一个旧的元素移出滑动窗口，最后再求出它们的中位数。

因此，我们需要设计一个「数据结构」，用来维护滑动窗口，并且需要提供如下的三个接口：

- $\texttt{insert(num)}$：将一个数 $\textit{num}$ 加入数据结构；

- $\texttt{erase(num)}$：将一个数 $\textit{num}$ 移出数据结构；

- $\texttt{getMedian()}$：返回当前数据结构中所有数的中位数。

#### 方法一：双优先队列 + 延迟删除

**思路与算法**

我们可以使用两个优先队列（堆）维护所有的元素，第一个优先队列 $\textit{small}$ 是一个大根堆，它负责维护所有元素中较小的那一半；第二个优先队列 $\textit{large}$ 是一个小根堆，它负责维护所有元素中较大的那一半。具体地，如果当前需要维护的元素个数为 $x$，那么 $\textit{small}$ 中维护了 $\lceil \frac{x}{2} \rceil$ 个元素，$\textit{large}$ 中维护了 $\lfloor \frac{x}{2} \rfloor$ 个元素，其中 $\lceil y \rceil$ 和 $\lfloor y \rfloor$ 分别表示将 $y$ 向上取整和向下取整。也就是说：

> $\textit{small}$ 中的元素个数要么与 $\textit{large}$ 中的元素个数相同，要么比 $\textit{large}$ 中的元素个数恰好多 $1$ 个。

这样设计的好处在于：当二者包含的元素个数相同时，它们各自的堆顶元素的平均值即为中位数；而当 $\textit{small}$ 包含的元素多了一个时，$\textit{small}$ 的堆顶元素即为中位数。这样 $\texttt{getMedian()}$ 就设计完成了。

而对于 $\texttt{insert(num)}$ 而言，如果当前两个优先队列都为空，那么根据元素个数的要求，我们必须将这个元素加入 $\textit{small}$；如果 $\textit{small}$ 非空（显然不会存在 $\textit{small}$ 空而 $\textit{large}$ 非空的情况），我们就可以将 $\textit{num}$ 与 $\textit{small}$ 的堆顶元素 $\textit{top}$ 比较：

- 如果 $\textit{num} \leq \textit{top}$，我们就将其加入 $\textit{small}$ 中；

- 如果 $\textit{num} > \textit{top}$，我们就将其加入 $\textit{large}$ 中。

在成功地加入元素 $\textit{num}$ 之后，两个优先队列的元素个数可能会变得不符合要求。由于我们只加入了一个元素，那么不符合要求的情况只能是下面的二者之一：

- $\textit{small}$ 比 $\textit{large}$ 的元素个数多了 $2$ 个；

- $\textit{small}$ 比 $\textit{large}$ 的元素个数少了 $1$ 个。

对于第一种情况，我们将 $\textit{small}$ 的堆顶元素放入 $\textit{large}$；对于第二种情况，我们将 $\textit{large}$ 的堆顶元素放入 $\textit{small}$，这样就可以解决问题了，$\texttt{insert(num)}$ 也就设计完成了。

然而对于 $\texttt{erase(num)}$ 而言，设计起来就不是那么容易了，因为我们知道，**优先队列是不支持移出非堆顶元素**这一操作的，因此我们可以考虑使用「延迟删除」的技巧，即：

> 当我们需要移出优先队列中的某个元素时，我们只将这个删除操作「记录」下来，而不去真的删除这个元素。当这个元素出现在 $\textit{small}$ 或者 $\textit{large}$ 的堆顶时，我们再去将其移出对应的优先队列。

「延迟删除」使用到的辅助数据结构一般为哈希表 $\textit{delayed}$，其中的每个键值对 $(\textit{num}, \textit{freq})$，表示元素 $\textit{num}$ 还需要被删除 $\textit{freq}$ 次。「优先队列 + 延迟删除」有非常多种设计方式，体现在「延迟删除」的时机选择。在本题解中，我们使用一种比较容易编写代码的设计方式，即：

> 我们保证在任意操作 $\texttt{insert(num)}$，$\texttt{erase(num)}$，$\texttt{getMedian()}$ 完成之后（或者说任意操作开始之前），$\textit{small}$ 和 $\textit{large}$ 的堆顶元素都是不需要被「延迟删除」的。这样设计的好处在于：我们无需更改 $\texttt{getMedian()}$ 的设计，只需要略加修改 $\texttt{insert(num)}$ 即可。

我们首先设计一个辅助函数 $\texttt{prune(heap)}$，它的作用很简单，就是对 $\textit{heap}$ 这个优先队列（$\textit{small}$ 或者 $\textit{large}$ 之一），不断地弹出其需要被删除的堆顶元素，并且减少 $\textit{delayed}$ 中对应项的值。在 $\texttt{prune(heap)}$ 完成之后，我们就可以保证 **$\textit{heap}$ 的堆顶元素是不需要被「延迟删除」的**。

这样我们就可以在 $\texttt{prune(heap)}$ 的基础上设计另一个辅助函数 $\texttt{makeBalance()}$，它的作用即为调整 $\textit{small}$ 和 $\textit{large}$ 中的元素个数，使得二者的元素个数满足要求。由于有了 $\texttt{erase(num)}$ 以及「延迟删除」，我们在将一个优先队列的堆顶元素放入另一个优先队列时，第一个优先队列的堆顶元素可能是需要删除的。因此我们就可以用 $\texttt{makeBalance()}$ 将 $\texttt{prune(heap)}$ 封装起来，它的逻辑如下：

- 如果 $\textit{small}$ 和 $\textit{large}$ 中的元素个数满足要求，则不进行任何操作；

- 如果 $\textit{small}$ 比 $\textit{large}$ 的元素个数多了 $2$ 个，那么我们我们将 $\textit{small}$ 的堆顶元素放入 $\textit{large}$。此时 $\textit{small}$ 的对应元素可能是需要删除的，因此我们调用 $\texttt{prune(small)}$；

- 如果 $\textit{small}$ 比 $\textit{large}$ 的元素个数少了 $1$ 个，那么我们将 $\textit{large}$ 的堆顶元素放入 $\textit{small}$。此时 $\textit{large}$ 的对应的元素可能是需要删除的，因此我们调用 $\texttt{prune(large)}$。

此时，我们只需要在原先 $\texttt{insert(num)}$ 的设计的最后加上一步 $\texttt{makeBalance()}$ 即可。然而对于 $\texttt{erase(num)}$，我们还是需要进行一些思考的：

- 如果 $\textit{num}$ 与 $\textit{small}$ 和 $\textit{large}$ 的堆顶元素都不相同，那么 $\textit{num}$ 是需要被「延迟删除」的，我们将其在哈希表中的值增加 $1$；

- 否则，例如 $\textit{num}$ 与 $\textit{small}$ 的堆顶元素相同，那么该元素是可以理解被删除的。虽然我们没有实现「立即删除」这个辅助函数，但只要我们将 $\textit{num}$ 在哈希表中的值增加 $1$，并且调用「延迟删除」的辅助函数 $\texttt{prune(small)}$，那么就相当于实现了「立即删除」的功能。

无论是「立即删除」还是「延迟删除」，其中一个优先队列中的元素个数发生了变化（减少了 $1$），因此我们还需要用 $\texttt{makeBalance()}$ 调整元素的个数。

此时，所有的接口都已经设计完成了。由于 $\texttt{insert(num)}$ 和 $\texttt{erase(num)}$ 的最后一步都是 $\texttt{makeBalance()}$，而 $\texttt{makeBalance()}$ 的最后一步是 $\texttt{prune(heap)}$，因此我们就保证了任意操作完成之后，$\textit{small}$ 和 $\textit{large}$ 的堆顶元素都是不需要被「延迟删除」的。

具体实现的细节相对较多，读者可以参考下面的代码和注释进一步理解。

**代码**

```C++ [sol1-C++]
class DualHeap {
private:
    // 大根堆，维护较小的一半元素
    priority_queue<int> small;
    // 小根堆，维护较大的一半元素
    priority_queue<int, vector<int>, greater<int>> large;
    // 哈希表，记录「延迟删除」的元素，key 为元素，value 为需要删除的次数
    unordered_map<int, int> delayed;

    int k;
    // small 和 large 当前包含的元素个数，需要扣除被「延迟删除」的元素
    int smallSize, largeSize;

public:
    DualHeap(int _k): k(_k), smallSize(0), largeSize(0) {}

private:
    // 不断地弹出 heap 的堆顶元素，并且更新哈希表
    template<typename T>
    void prune(T& heap) {
        while (!heap.empty()) {
            int num = heap.top();
            if (delayed.count(num)) {
                --delayed[num];
                if (!delayed[num]) {
                    delayed.erase(num);
                }
                heap.pop();
            }
            else {
                break;
            }
        }
    }

    // 调整 small 和 large 中的元素个数，使得二者的元素个数满足要求
    void makeBalance() {
        if (smallSize > largeSize + 1) {
            // small 比 large 元素多 2 个
            large.push(small.top());
            small.pop();
            --smallSize;
            ++largeSize;
            // small 堆顶元素被移除，需要进行 prune
            prune(small);
        }
        else if (smallSize < largeSize) {
            // large 比 small 元素多 1 个
            small.push(large.top());
            large.pop();
            ++smallSize;
            --largeSize;
            // large 堆顶元素被移除，需要进行 prune
            prune(large);
        }
    }

public:
    void insert(int num) {
        if (small.empty() || num <= small.top()) {
            small.push(num);
            ++smallSize;
        }
        else {
            large.push(num);
            ++largeSize;
        }
        makeBalance();
    }

    void erase(int num) {
        ++delayed[num];
        if (num <= small.top()) {
            --smallSize;
            if (num == small.top()) {
                prune(small);
            }
        }
        else {
            --largeSize;
            if (num == large.top()) {
                prune(large);
            }
        }
        makeBalance();
    }

    double getMedian() {
        return k & 1 ? small.top() : ((double)small.top() + large.top()) / 2;
    }
};

class Solution {
public:
    vector<double> medianSlidingWindow(vector<int>& nums, int k) {
        DualHeap dh(k);
        for (int i = 0; i < k; ++i) {
            dh.insert(nums[i]);
        }
        vector<double> ans = {dh.getMedian()};
        for (int i = k; i < nums.size(); ++i) {
            dh.insert(nums[i]);
            dh.erase(nums[i - k]);
            ans.push_back(dh.getMedian());
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public double[] medianSlidingWindow(int[] nums, int k) {
        DualHeap dh = new DualHeap(k);
        for (int i = 0; i < k; ++i) {
            dh.insert(nums[i]);
        }
        double[] ans = new double[nums.length - k + 1];
        ans[0] = dh.getMedian();
        for (int i = k; i < nums.length; ++i) {
            dh.insert(nums[i]);
            dh.erase(nums[i - k]);
            ans[i - k + 1] = dh.getMedian();
        }
        return ans;
    }
}

class DualHeap {
    // 大根堆，维护较小的一半元素
    private PriorityQueue<Integer> small;
    // 小根堆，维护较大的一半元素
    private PriorityQueue<Integer> large;
    // 哈希表，记录「延迟删除」的元素，key 为元素，value 为需要删除的次数
    private Map<Integer, Integer> delayed;

    private int k;
    // small 和 large 当前包含的元素个数，需要扣除被「延迟删除」的元素
    private int smallSize, largeSize;

    public DualHeap(int k) {
        this.small = new PriorityQueue<Integer>(new Comparator<Integer>() {
            public int compare(Integer num1, Integer num2) {
                return num2.compareTo(num1);
            }
        });
        this.large = new PriorityQueue<Integer>(new Comparator<Integer>() {
            public int compare(Integer num1, Integer num2) {
                return num1.compareTo(num2);
            }
        });
        this.delayed = new HashMap<Integer, Integer>();
        this.k = k;
        this.smallSize = 0;
        this.largeSize = 0;
    }

    public double getMedian() {
        return (k & 1) == 1 ? small.peek() : ((double) small.peek() + large.peek()) / 2;
    }

    public void insert(int num) {
        if (small.isEmpty() || num <= small.peek()) {
            small.offer(num);
            ++smallSize;
        } else {
            large.offer(num);
            ++largeSize;
        }
        makeBalance();
    }

    public void erase(int num) {
        delayed.put(num, delayed.getOrDefault(num, 0) + 1);
        if (num <= small.peek()) {
            --smallSize;
            if (num == small.peek()) {
                prune(small);
            }
        } else {
            --largeSize;
            if (num == large.peek()) {
                prune(large);
            }
        }
        makeBalance();
    }

    // 不断地弹出 heap 的堆顶元素，并且更新哈希表
    private void prune(PriorityQueue<Integer> heap) {
        while (!heap.isEmpty()) {
            int num = heap.peek();
            if (delayed.containsKey(num)) {
                delayed.put(num, delayed.get(num) - 1);
                if (delayed.get(num) == 0) {
                    delayed.remove(num);
                }
                heap.poll();
            } else {
                break;
            }
        }
    }

    // 调整 small 和 large 中的元素个数，使得二者的元素个数满足要求
    private void makeBalance() {
        if (smallSize > largeSize + 1) {
            // small 比 large 元素多 2 个
            large.offer(small.poll());
            --smallSize;
            ++largeSize;
            // small 堆顶元素被移除，需要进行 prune
            prune(small);
        } else if (smallSize < largeSize) {
            // large 比 small 元素多 1 个
            small.offer(large.poll());
            ++smallSize;
            --largeSize;
            // large 堆顶元素被移除，需要进行 prune
            prune(large);
        }
    }
}
```

```Python [sol1-Python3]
class DualHeap:
    def __init__(self, k: int):
        # 大根堆，维护较小的一半元素，注意 python 没有大根堆，需要将所有元素取相反数并使用小根堆
        self.small = list()
        # 小根堆，维护较大的一半元素
        self.large = list()
        # 哈希表，记录「延迟删除」的元素，key 为元素，value 为需要删除的次数
        self.delayed = collections.Counter()

        self.k = k
        # small 和 large 当前包含的元素个数，需要扣除被「延迟删除」的元素
        self.smallSize = 0
        self.largeSize = 0


    # 不断地弹出 heap 的堆顶元素，并且更新哈希表
    def prune(self, heap: List[int]):
        while heap:
            num = heap[0]
            if heap is self.small:
                num = -num
            if num in self.delayed:
                self.delayed[num] -= 1
                if self.delayed[num] == 0:
                    self.delayed.pop(num)
                heapq.heappop(heap)
            else:
                break
    
    # 调整 small 和 large 中的元素个数，使得二者的元素个数满足要求
    def makeBalance(self):
        if self.smallSize > self.largeSize + 1:
            # small 比 large 元素多 2 个
            heapq.heappush(self.large, -self.small[0])
            heapq.heappop(self.small)
            self.smallSize -= 1
            self.largeSize += 1
            # small 堆顶元素被移除，需要进行 prune
            self.prune(self.small)
        elif self.smallSize < self.largeSize:
            # large 比 small 元素多 1 个
            heapq.heappush(self.small, -self.large[0])
            heapq.heappop(self.large)
            self.smallSize += 1
            self.largeSize -= 1
            # large 堆顶元素被移除，需要进行 prune
            self.prune(self.large)

    def insert(self, num: int):
        if not self.small or num <= -self.small[0]:
            heapq.heappush(self.small, -num)
            self.smallSize += 1
        else:
            heapq.heappush(self.large, num)
            self.largeSize += 1
        self.makeBalance()

    def erase(self, num: int):
        self.delayed[num] += 1
        if num <= -self.small[0]:
            self.smallSize -= 1
            if num == -self.small[0]:
                self.prune(self.small)
        else:
            self.largeSize -= 1
            if num == self.large[0]:
                self.prune(self.large)
        self.makeBalance()

    def getMedian(self) -> float:
        return float(-self.small[0]) if self.k % 2 == 1 else (-self.small[0] + self.large[0]) / 2


class Solution:
    def medianSlidingWindow(self, nums: List[int], k: int) -> List[float]:
        dh = DualHeap(k)
        for num in nums[:k]:
            dh.insert(num)
        
        ans = [dh.getMedian()]
        for i in range(k, len(nums)):
            dh.insert(nums[i])
            dh.erase(nums[i - k])
            ans.append(dh.getMedian())
        
        return ans
```

```go [sol1-Golang]
type hp struct {
    sort.IntSlice
    size int
}
func (h *hp) Push(v interface{}) { h.IntSlice = append(h.IntSlice, v.(int)) }
func (h *hp) Pop() interface{}   { a := h.IntSlice; v := a[len(a)-1]; h.IntSlice = a[:len(a)-1]; return v }
func (h *hp) push(v int)         { h.size++; heap.Push(h, v) }
func (h *hp) pop() int           { h.size--; return heap.Pop(h).(int) }
func (h *hp) prune() {
    for h.Len() > 0 {
        num := h.IntSlice[0]
        if h == small {
            num = -num
        }
        if d, has := delayed[num]; has {
            if d > 1 {
                delayed[num]--
            } else {
                delete(delayed, num)
            }
            heap.Pop(h)
        } else {
            break
        }
    }
}

var delayed map[int]int
var small, large *hp

func medianSlidingWindow(nums []int, k int) []float64 {
    delayed = map[int]int{} // 哈希表，记录「延迟删除」的元素，key 为元素，value 为需要删除的次数
    small = &hp{}           // 大根堆，维护较小的一半元素
    large = &hp{}           // 小根堆，维护较大的一半元素
    makeBalance := func() {
        // 调整 small 和 large 中的元素个数，使得二者的元素个数满足要求
        if small.size > large.size+1 { // small 比 large 元素多 2 个
            large.push(-small.pop())
            small.prune() // small 堆顶元素被移除，需要进行 prune
        } else if small.size < large.size { // large 比 small 元素多 1 个
            small.push(-large.pop())
            large.prune() // large 堆顶元素被移除，需要进行 prune
        }
    }
    insert := func(num int) {
        if small.Len() == 0 || num <= -small.IntSlice[0] {
            small.push(-num)
        } else {
            large.push(num)
        }
        makeBalance()
    }
    erase := func(num int) {
        delayed[num]++
        if num <= -small.IntSlice[0] {
            small.size--
            if num == -small.IntSlice[0] {
                small.prune()
            }
        } else {
            large.size--
            if num == large.IntSlice[0] {
                large.prune()
            }
        }
        makeBalance()
    }
    getMedian := func() float64 {
        if k&1 > 0 {
            return float64(-small.IntSlice[0])
        }
        return float64(-small.IntSlice[0]+large.IntSlice[0]) / 2
    }

    for _, num := range nums[:k] {
        insert(num)
    }
    n := len(nums)
    ans := make([]float64, 1, n-k+1)
    ans[0] = getMedian()
    for i := k; i < n; i++ {
        insert(nums[i])
        erase(nums[i-k])
        ans = append(ans, getMedian())
    }
    return ans
}
```

```C [sol1-C]
struct Heap {
    int* heap;
    int heapSize;
    int realSize;
    bool (*cmp)(int, int);
};

void init(struct Heap* obj, int n, bool (*cmp)(int, int)) {
    obj->heap = malloc(sizeof(int) * (n + 1));
    obj->heapSize = 0;
    obj->cmp = cmp;
}

bool cmp1(int a, int b) {
    return a < b;
}

bool cmp2(int a, int b) {
    return a > b;
}

void swap(int* a, int* b) {
    int tmp = *a;
    *a = *b, *b = tmp;
}

void push(struct Heap* obj, int x) {
    int p = ++(obj->heapSize), q = p >> 1;
    obj->heap[p] = x;
    while (q) {
        if (!obj->cmp(obj->heap[q], obj->heap[p])) {
            break;
        }
        swap(&(obj->heap[q]), &(obj->heap[p]));
        p = q, q = p >> 1;
    }
}

void pop(struct Heap* obj) {
    swap(&(obj->heap[1]), &(obj->heap[(obj->heapSize)--]));
    int p = 1, q = p << 1;
    while (q <= obj->heapSize) {
        if (q + 1 <= obj->heapSize) {
            if (obj->cmp(obj->heap[q], obj->heap[q + 1])) {
                q++;
            }
        }
        if (!obj->cmp(obj->heap[p], obj->heap[q])) {
            break;
        }
        swap(&(obj->heap[q]), &(obj->heap[p]));
        p = q, q = p << 1;
    }
}

int top(struct Heap* obj) {
    return obj->heap[1];
}

bool empty(struct Heap* obj) {
    return obj->heapSize == 0;
}

struct HashTable {
    int key;
    int val;
    UT_hash_handle hh;
} * hashtable;

void prune(struct Heap* obj) {
    while (!empty(obj)) {
        int num = top(obj);
        struct HashTable* tmp;
        HASH_FIND_INT(hashtable, &num, tmp);
        if (tmp == NULL) {
            break;
        }
        tmp->val--;
        if (!(tmp->val)) {
            HASH_DEL(hashtable, tmp);
            free(tmp);
        }
        pop(obj);
    }
}

void makeBalance(struct Heap* small, struct Heap* large) {
    if (small->realSize > large->realSize + 1) {
        push(large, top(small));
        pop(small);
        --(small->realSize);
        ++(large->realSize);
        prune(small);
    } else if (small->realSize < large->realSize) {
        push(small, top(large));
        pop(large);
        ++(small->realSize);
        --(large->realSize);
        prune(large);
    }
}

void insert(struct Heap* small, struct Heap* large, int num) {
    if (empty(small) || num <= top(small)) {
        push(small, num);
        ++(small->realSize);
    } else {
        push(large, num);
        ++(large->realSize);
    }
    makeBalance(small, large);
}

void erase(struct Heap* small, struct Heap* large, int num) {
    struct HashTable* tmp;
    HASH_FIND_INT(hashtable, &num, tmp);
    if (tmp == NULL) {
        tmp = malloc(sizeof(struct HashTable));
        tmp->key = num;
        tmp->val = 1;
        HASH_ADD_INT(hashtable, key, tmp);
    } else {
        tmp->val++;
    }
    if (num <= top(small)) {
        --(small->realSize);
        if (num == top(small)) {
            prune(small);
        }
    } else {
        --(large->realSize);
        if (num == top(large)) {
            prune(large);
        }
    }
    makeBalance(small, large);
}

double getMedian(struct Heap* small, struct Heap* large, int k) {
    return (k & 1) ? top(small) : (((double)top(small) + top(large)) / 2);
}

double* medianSlidingWindow(int* nums, int numsSize, int k, int* returnSize) {
    hashtable = NULL;
    struct Heap* small = malloc(sizeof(struct Heap));
    init(small, numsSize, cmp1);
    struct Heap* large = malloc(sizeof(struct Heap));
    init(large, numsSize, cmp2);
    for (int i = 0; i < k; ++i) {
        insert(small, large, nums[i]);
    }
    double* ans = malloc(sizeof(double) * (numsSize - k + 1));
    *returnSize = 0;
    ans[(*returnSize)++] = getMedian(small, large, k);
    for (int i = k; i < numsSize; ++i) {
        insert(small, large, nums[i]);
        erase(small, large, nums[i - k]);
        ans[(*returnSize)++] = getMedian(small, large, k);
    }
    return ans;
}
```

**复杂度分析**

由于「延迟删除」的存在，$\textit{small}$ 比 $\textit{large}$ 在最坏情况下可能包含所有的 $n$ 个元素，即没有一个元素被真正删除了。因此优先队列的大小是 $O(n)$ 而不是 $O(k)$ 的，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 时间复杂度：$O(n\log n)$。$\texttt{insert(num)}$ 和 $\texttt{erase(num)}$ 的单次时间复杂度为 $O(\log n)$，$\texttt{getMedian()}$ 的单次时间复杂度为 $O(1)$。因此总时间复杂度为 $O(n\log n)$。

- 空间复杂度：$O(n)$。即为 $\textit{small}$，$\textit{large}$ 和 $\textit{delayed}$ 需要使用的空间。

#### 结语

读者可以尝试回答如下的两个问题来检验自己是否掌握了该方法：

- 在 $\texttt{insert(num)}$ 的最后我们加上了一步 $\texttt{makeBalance()}$，其中包括可能进行的 $\texttt{prune(heap)}$ 操作，这对于 $\texttt{insert(num)}$ 操作而言是否是必要的？

- 在 $\texttt{insert(num)}$ 的过程中，如果我们将 $\texttt{insert(num)}$ 放入了 $\textit{large}$ 中，并且 $\textit{num}$ 恰好出现在 $\textit{large}$ 的堆顶位置，且两个优先队列的元素个数满足要求，不需要进行调整。此时会不会出现 $\textit{num}$ 是一个需要被「延迟删除」的元素的情况，这样就不满足在 $\texttt{insert(num)}$ 操作完成之后 $\textit{large}$ 的堆顶是不需要被「延迟删除」的要求了？

**答案**

- 是必要的。举个例子：在 $\texttt{insert(num)}$ 操作之前，$\textit{large}$ 的堆顶元素是有效的，但其中第二小的元素是需要被删除的。此时，如果我们将一个很大的元素加入 $\textit{large}$ 中，并且 $\textit{large}$ 包含的元素数量超过了 $\textit{small}$，那么我们就需要将 $\textit{large}$ 的堆顶元素放入 $\textit{small}$ 中。这样一来，$\textit{large}$ 的堆顶元素就变成了那个需要被删除的第二小的元素了，所以 $\texttt{prune(heap)}$ 操作是必要的。

- 不可能会出现这种情况，假设出现了这种情况，那么 $\textit{num}$ 显然不会等于 $\textit{large}$ 原先的堆顶元素，因为 $\textit{large}$ 原先的堆顶元素一定是不需要被删除的。那么 $\textit{num}$ 满足：

    $$
    \textit{small} ~的堆顶元素 < \textit{num} < \textit{large} ~的堆顶元素
    $$

    由于 $\textit{small}$ 是大根堆，$\textit{large}$ 是小根堆，因此**根本就不存在与 $\textit{num}$ 值相同的元素**，也就不可能会被延迟删除了。
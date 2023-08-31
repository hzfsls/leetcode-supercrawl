## [703.数据流中的第 K 大元素 中文官方题解](https://leetcode.cn/problems/kth-largest-element-in-a-stream/solutions/100000/shu-ju-liu-zhong-de-di-k-da-yuan-su-by-l-woz8)
#### 方法一：优先队列

我们可以使用一个大小为 $k$ 的优先队列来存储前 $k$ 大的元素，其中优先队列的队头为队列中最小的元素，也就是第 $k$ 大的元素。

在单次插入的操作中，我们首先将元素 $\textit{val}$ 加入到优先队列中。如果此时优先队列的大小大于 $k$，我们需要将优先队列的队头元素弹出，以保证优先队列的大小为 $k$。

```C++ [sol1-C++]
class KthLargest {
public:
    priority_queue<int, vector<int>, greater<int>> q;
    int k;
    KthLargest(int k, vector<int>& nums) {
        this->k = k;
        for (auto& x: nums) {
            add(x);
        }
    }
    
    int add(int val) {
        q.push(val);
        if (q.size() > k) {
            q.pop();
        }
        return q.top();
    }
};
```

```Java [sol1-Java]
class KthLargest {
    PriorityQueue<Integer> pq;
    int k;

    public KthLargest(int k, int[] nums) {
        this.k = k;
        pq = new PriorityQueue<Integer>();
        for (int x : nums) {
            add(x);
        }
    }
    
    public int add(int val) {
        pq.offer(val);
        if (pq.size() > k) {
            pq.poll();
        }
        return pq.peek();
    }
}
```

```go [sol1-Golang]
type KthLargest struct {
    sort.IntSlice
    k int
}

func Constructor(k int, nums []int) KthLargest {
    kl := KthLargest{k: k}
    for _, val := range nums {
        kl.Add(val)
    }
    return kl
}

func (kl *KthLargest) Push(v interface{}) {
    kl.IntSlice = append(kl.IntSlice, v.(int))
}

func (kl *KthLargest) Pop() interface{} {
    a := kl.IntSlice
    v := a[len(a)-1]
    kl.IntSlice = a[:len(a)-1]
    return v
}

func (kl *KthLargest) Add(val int) int {
    heap.Push(kl, val)
    if kl.Len() > kl.k {
        heap.Pop(kl)
    }
    return kl.IntSlice[0]
}
```

```C [sol1-C]
struct Heap {
    int* heap;
    int heapSize;
    bool (*cmp)(int, int);
};

void init(struct Heap* obj, int n, bool (*cmp)(int, int)) {
    obj->heap = malloc(sizeof(int) * (n + 1));
    obj->heapSize = 0;
    obj->cmp = cmp;
}

bool cmp(int a, int b) {
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

typedef struct {
    struct Heap* heap;
    int maxSize;
} KthLargest;

KthLargest* kthLargestCreate(int k, int* nums, int numsSize) {
    KthLargest* ret = malloc(sizeof(KthLargest));
    ret->heap = malloc(sizeof(struct Heap));
    init(ret->heap, k + 1, cmp);
    ret->maxSize = k;
    for (int i = 0; i < numsSize; i++) {
        kthLargestAdd(ret, nums[i]);
    }
    return ret;
}

int kthLargestAdd(KthLargest* obj, int val) {
    push(obj->heap, val);
    if (obj->heap->heapSize > obj->maxSize) {
        pop(obj->heap);
    }
    return top(obj->heap);
}

void kthLargestFree(KthLargest* obj) {
    free(obj->heap->heap);
    free(obj->heap);
    free(obj);
}
```

```JavaScript [sol1-JavaScript]
var KthLargest = function(k, nums) {
    this.k = k;
    this.heap = new MinHeap();
    for (const x of nums) {
        this.add(x);
    }
};

KthLargest.prototype.add = function(val) {
    this.heap.offer(val);
    if (this.heap.size() > this.k) {
        this.heap.poll();
    }
    return this.heap.peek();
};

class MinHeap {
    constructor(data = []) {
        this.data = data;
        this.comparator = (a, b) => a - b;
        this.heapify();
    }

    heapify() {
        if (this.size() < 2) return;
        for (let i = 1; i < this.size(); i++) {
        this.bubbleUp(i);
        }
    }

    peek() {
        if (this.size() === 0) return null;
        return this.data[0];
    }

    offer(value) {
        this.data.push(value);
        this.bubbleUp(this.size() - 1);
    }

    poll() {
        if (this.size() === 0) {
            return null;
        }
        const result = this.data[0];
        const last = this.data.pop();
        if (this.size() !== 0) {
            this.data[0] = last;
            this.bubbleDown(0);
        }
        return result;
    }

    bubbleUp(index) {
        while (index > 0) {
            const parentIndex = (index - 1) >> 1;
            if (this.comparator(this.data[index], this.data[parentIndex]) < 0) {
                this.swap(index, parentIndex);
                index = parentIndex;
            } else {
                break;
            }
        }
    }

    bubbleDown(index) {
        const lastIndex = this.size() - 1;
        while (true) {
            const leftIndex = index * 2 + 1;
            const rightIndex = index * 2 + 2;
            let findIndex = index;
            if (
                leftIndex <= lastIndex &&
                this.comparator(this.data[leftIndex], this.data[findIndex]) < 0
            ) {
                findIndex = leftIndex;
            }
            if (
                rightIndex <= lastIndex &&
                this.comparator(this.data[rightIndex], this.data[findIndex]) < 0
            ) {
                findIndex = rightIndex;
            }
            if (index !== findIndex) {
                this.swap(index, findIndex);
                index = findIndex;
            } else {
                break;
            }
        }
    }

  swap(index1, index2) {
        [this.data[index1], this.data[index2]] = [this.data[index2], this.data[index1]];
    }

    size() {
        return this.data.length;
    }
}
```

**复杂度分析**

- 时间复杂度：

  - 初始化时间复杂度为：$O(n \log k)$ ，其中 $n$ 为初始化时 $\textit{nums}$ 的长度；

  - 单次插入时间复杂度为：$O(\log k)$。

- 空间复杂度：$O(k)$。需要使用优先队列存储前 $k$ 大的元素。
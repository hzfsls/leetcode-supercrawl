## [1046.最后一块石头的重量 中文官方题解](https://leetcode.cn/problems/last-stone-weight/solutions/100000/zui-hou-yi-kuai-shi-tou-de-zhong-liang-b-xgsx)
#### 方法一：最大堆

将所有石头的重量放入最大堆中。每次依次从队列中取出最重的两块石头 $a$ 和 $b$，必有 $a \ge b$。如果 $a>b$，则将新石头 $a-b$ 放回到最大堆中；如果 $a=b$，两块石头完全被粉碎，因此不会产生新的石头。重复上述操作，直到剩下的石头少于 $2$ 块。

最终可能剩下 $1$ 块石头，该石头的重量即为最大堆中剩下的元素，返回该元素；也可能没有石头剩下，此时最大堆为空，返回 $0$。

```C++ [sol1-C++]
class Solution {
public:
    int lastStoneWeight(vector<int>& stones) {
        priority_queue<int> q;
        for (int s: stones) {
            q.push(s);
        }

        while (q.size() > 1) {
            int a = q.top();
            q.pop();
            int b = q.top();
            q.pop();
            if (a > b) {
                q.push(a - b);
            }
        }
        return q.empty() ? 0 : q.top();
    }
};
```

```Java [sol1-Java]
class Solution {
    public int lastStoneWeight(int[] stones) {
        PriorityQueue<Integer> pq = new PriorityQueue<Integer>((a, b) -> b - a);
        for (int stone : stones) {
            pq.offer(stone);
        }

        while (pq.size() > 1) {
            int a = pq.poll();
            int b = pq.poll();
            if (a > b) {
                pq.offer(a - b);
            }
        }
        return pq.isEmpty() ? 0 : pq.poll();
    }
}
```

```JavaScript [sol1-JavaScript]
var lastStoneWeight = function(stones) {
    const pq = new MaxPriorityQueue();
    for (const stone of stones) {
        pq.enqueue('x', stone);
    }
    
    while (pq.size() > 1) {
        const a = pq.dequeue()['priority'];
        const b = pq.dequeue()['priority'];
        if (a > b) {
            pq.enqueue('x', a - b);
        }
    }
    return pq.isEmpty() ? 0 : pq.dequeue()['priority'];
};
```

```go [sol1-Golang]
type hp struct{ sort.IntSlice }

func (h hp) Less(i, j int) bool  { return h.IntSlice[i] > h.IntSlice[j] }
func (h *hp) Push(v interface{}) { h.IntSlice = append(h.IntSlice, v.(int)) }
func (h *hp) Pop() interface{}   { a := h.IntSlice; v := a[len(a)-1]; h.IntSlice = a[:len(a)-1]; return v }
func (h *hp) push(v int)         { heap.Push(h, v) }
func (h *hp) pop() int           { return heap.Pop(h).(int) }

func lastStoneWeight(stones []int) int {
    q := &hp{stones}
    heap.Init(q)
    for q.Len() > 1 {
        x, y := q.pop(), q.pop()
        if x > y {
            q.push(x - y)
        }
    }
    if q.Len() > 0 {
        return q.IntSlice[0]
    }
    return 0
}
```

```C [sol1-C]
void swap(int *a, int *b) {
    int tmp = *a;
    *a = *b, *b = tmp;
}

void push(int *heap, int *heapSize, int x) {
    heap[++(*heapSize)] = x;
    for (int i = (*heapSize); i > 1 && heap[i] > heap[i >> 1]; i >>= 1) {
        swap(&heap[i], &heap[i >> 1]);
    }
}

void pop(int *heap, int *heapSize) {
    int tmp = heap[1] = heap[(*heapSize)--];
    int i = 1, j = 2;
    while (j <= (*heapSize)) {
        if (j != (*heapSize) && heap[j + 1] > heap[j]) ++j;
        if (heap[j] > tmp) {
            heap[i] = heap[j];
            i = j;
            j = i << 1;
        } else {
            break;
        }
    }
    heap[i] = tmp;
}

int top(int *heap) {
    return heap[1];
}

int lastStoneWeight(int *stones, int stonesSize) {
    if (stonesSize == 1) {
        return stones[0];
    }
    if (stonesSize == 2) {
        return fabs(stones[0] - stones[1]);
    }
    int heap[stonesSize + 2], heapSize = 0;
    for (int i = 0; i < stonesSize; i++) {
        push(heap, &heapSize, stones[i]);
    }

    while (heapSize > 1) {
        int a = top(heap);
        pop(heap, &heapSize);
        int b = top(heap);
        pop(heap, &heapSize);
        if (a > b) {
            push(heap, &heapSize, a - b);
        }
    }
    return heapSize ? top(heap) : 0;
}
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 是石头数量。每次从队列中取出元素需要花费 $O(\log n)$ 的时间，最多共需要粉碎 $n - 1$ 次石头。

- 空间复杂度：$O(n)$。
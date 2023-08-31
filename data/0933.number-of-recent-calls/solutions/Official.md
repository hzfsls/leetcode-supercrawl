## [933.最近的请求次数 中文官方题解](https://leetcode.cn/problems/number-of-recent-calls/solutions/100000/zui-jin-de-qing-qiu-ci-shu-by-leetcode-s-ncm1)

#### 方法一：队列

我们可以用一个队列维护发生请求的时间，当在时间 $t$ 收到请求时，将时间 $t$ 入队。

由于每次收到的请求的时间都比之前的大，因此从队首到队尾的时间值是单调递增的。当在时间 $t$ 收到请求时，为了求出 $[t-3000,t]$ 内发生的请求数，我们可以不断从队首弹出早于 $t-3000$ 的时间。循环结束后队列的长度就是 $[t-3000,t]$ 内发生的请求数。

```Python [sol1-Python3]
class RecentCounter:
    def __init__(self):
        self.q = deque()

    def ping(self, t: int) -> int:
        self.q.append(t)
        while self.q[0] < t - 3000:
            self.q.popleft()
        return len(self.q)
```

```C++ [sol1-C++]
class RecentCounter {
    queue<int> q;
public:
    RecentCounter() {}

    int ping(int t) {
        q.push(t);
        while (q.front() < t - 3000) {
            q.pop();
        }
        return q.size();
    }
};
```

```Java [sol1-Java]
class RecentCounter {
    Queue<Integer> queue;

    public RecentCounter() {
        queue = new ArrayDeque<Integer>();
    }

    public int ping(int t) {
        queue.offer(t);
        while (queue.peek() < t - 3000) {
            queue.poll();
        }
        return queue.size();
    }
}
```

```C# [sol1-C#]
public class RecentCounter {
    Queue<int> queue;

    public RecentCounter() {
        queue = new Queue<int>();
    }

    public int Ping(int t) {
        queue.Enqueue(t);
        while (queue.Peek() < t - 3000) {
            queue.Dequeue();
        }
        return queue.Count;
    }
}
```

```go [sol1-Golang]
type RecentCounter []int

func Constructor() (_ RecentCounter) { return }

func (q *RecentCounter) Ping(t int) int {
    *q = append(*q, t)
    for (*q)[0] < t-3000 {
        *q = (*q)[1:]
    }
    return len(*q)
}
```

```C [sol1-C]
typedef struct {
    int *queue;
    int capability;
    int head;
    int tail;
} RecentCounter;


RecentCounter* recentCounterCreate() {
    RecentCounter *obj = (RecentCounter *)malloc(sizeof(RecentCounter));
    obj->capability = 10001;
    obj->queue = (int *)malloc(sizeof(int) * obj->capability);
    obj->head = 0;
    obj->tail = 0;
    return obj;
}

int recentCounterPing(RecentCounter* obj, int t) {
    obj->queue[obj->tail++] = t;
    while (obj->queue[obj->head] < t - 3000) {
        obj->head++;
    }
    return obj->tail - obj->head;
}

void recentCounterFree(RecentCounter* obj) {
    free(obj->queue);
    free(obj);
}
```

```JavaScript [sol1-JavaScript]
var RecentCounter = function() {
    this.queue = [];
};

RecentCounter.prototype.ping = function(t) {
    this.queue.push(t);
    while (this.queue[0] < t - 3000) {
        this.queue.shift();
    }
    return this.queue.length;
};
```

**复杂度分析**

- 时间复杂度：均摊 $O(1)$，每个元素至多入队出队各一次。

- 空间复杂度：$O(L)$，其中 $L$ 为队列的最大元素个数。
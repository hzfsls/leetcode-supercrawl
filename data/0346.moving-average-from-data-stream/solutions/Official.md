## [346.数据流中的移动平均值 中文官方题解](https://leetcode.cn/problems/moving-average-from-data-stream/solutions/100000/shu-ju-liu-zhong-de-yi-dong-ping-jun-zhi-7oqj)

#### 方法一：队列

这道题要求根据给定的数据流计算滑动窗口中所有数字的平均值，滑动窗口的大小为给定的参数 $\textit{size}$。当数据流中的数字个数不超过滑动窗口的大小时，计算数据流中的所有数字的平均值；当数据流中的数字个数超过滑动窗口的大小时，只计算滑动窗口中的数字的平均值，数据流中更早的数字被移出滑动窗口。

由于数字进入滑动窗口和移出滑动窗口的规则符合先进先出，因此可以使用队列存储滑动窗口中的数字，同时维护滑动窗口的大小以及滑动窗口的数字之和。

初始时，队列为空，滑动窗口的大小设为给定的参数 $\textit{size}$，滑动窗口的数字之和为 $0$。

每次调用 $\texttt{next}$ 时，需要将 $\textit{val}$ 添加到滑动窗口中，同时确保滑动窗口中的数字个数不超过 $\textit{size}$，如果数字个数超过 $\textit{size}$ 则需要将多余的数字移除，在添加和移除数字的同时需要更新滑动窗口的数字之和。由于每次调用只会将一个数字添加到滑动窗口中，因此每次调用最多只需要将一个多余的数字移除。具体操作如下。

1. 如果队列中的数字个数等于滑动窗口的大小，则移除队首的数字，将移除的数字从滑动窗口的数字之和中减去。如果队列中的数字个数小于滑动窗口的大小，则不移除队首的数字。

2. 将 $\textit{val}$ 添加到队列中，并加到滑动窗口的数字之和中。

3. 计算滑动窗口的数字之和与队列中的数字个数之商，即为滑动窗口中所有数字的平均值。

```Python [sol1-Python3]
class MovingAverage:
    def __init__(self, size: int):
        self.size = size
        self.sum = 0
        self.q = deque()

    def next(self, val: int) -> float:
        if len(self.q) == self.size:
            self.sum -= self.q.popleft()
        self.sum += val
        self.q.append(val)
        return self.sum / len(self.q)
```

```Java [sol1-Java]
class MovingAverage {
    Queue<Integer> queue;
    int size;
    double sum;

    public MovingAverage(int size) {
        queue = new ArrayDeque<Integer>();
        this.size = size;
        sum = 0;
    }

    public double next(int val) {
        if (queue.size() == size) {
            sum -= queue.poll();
        }
        queue.offer(val);
        sum += val;
        return sum / queue.size();
    }
}
```

```C# [sol1-C#]
public class MovingAverage {
    Queue<int> queue;
    int size;
    double sum;

    public MovingAverage(int size) {
        queue = new Queue<int>();
        this.size = size;
        sum = 0;
    }
    
    public double Next(int val) {
        if (queue.Count == size) {
            sum -= queue.Dequeue();
        }
        queue.Enqueue(val);
        sum += val;
        return sum / queue.Count;
    }
}
```

```C++ [sol1-C++]
class MovingAverage {
public:
    MovingAverage(int size) {
        this->size = size;
        this->sum = 0.0;
    }
    
    double next(int val) {
        if (qu.size() == size) {
            sum -= qu.front();
            qu.pop();
        }
        qu.emplace(val);
        sum += val;
        return sum / qu.size();
    }
private:
    int size;
    double sum;
    queue<int> qu;
};
```

```C [sol1-C]
typedef struct {
    int size;
    double sum;
    int *queue;
    int front;
    int rear;
} MovingAverage;


MovingAverage* movingAverageCreate(int size) {
    MovingAverage *obj = (MovingAverage *)malloc(sizeof(MovingAverage));
    obj->size = size;
    obj->sum = 0;
    obj->queue = (int *)malloc(sizeof(int) * (size + 1));
    obj->front = 0;
    obj->rear = 0;
    return obj;
}

double movingAverageNext(MovingAverage* obj, int val) {
    int size = (obj->rear - obj->front + obj->size + 1) % (obj->size + 1);
    if (size == obj->size) {
        obj->sum -= obj->queue[obj->front];
        obj->front = (obj->front + 1) % (obj->size + 1);
        size--;
    }
    obj->queue[obj->rear] = val;
    obj->rear = (obj->rear + 1) % (obj->size + 1);
    obj->sum += val;
    size++;
    return obj->sum / size;
}

void movingAverageFree(MovingAverage* obj) {
    free(obj->queue);
    free(obj);
}
```

```go [sol1-Golang]
type MovingAverage struct {
    size, sum int
    q         []int
}

func Constructor(size int) MovingAverage {
    return MovingAverage{size: size}
}

func (m *MovingAverage) Next(val int) float64 {
    if len(m.q) == m.size {
        m.sum -= m.q[0]
        m.q = m.q[1:]
    }
    m.sum += val
    m.q = append(m.q, val)
    return float64(m.sum) / float64(len(m.q))
}
```

```JavaScript [sol1-JavaScript]
var MovingAverage = function(size) {
    this.queue = [];
    this.size = size;
    this.sum = 0;
};

MovingAverage.prototype.next = function(val) {
    if (this.queue.length === this.size) {
        this.sum -= this.queue.shift();
    }
    this.queue.push(val);
    this.sum += val;
    return this.sum / this.queue.length;
};
```

**复杂度分析**

- 时间复杂度：初始化和每次调用 $\texttt{next}$ 的时间复杂度都是 $O(1)$。

- 空间复杂度：$O(\textit{size})$，其中 $\textit{size}$ 是滑动窗口的大小。空间复杂度主要取决于队列，队列中的数字个数不超过 $\textit{size}$。
## [901.股票价格跨度 中文官方题解](https://leetcode.cn/problems/online-stock-span/solutions/100000/gu-piao-jie-ge-kua-du-by-leetcode-soluti-5cm7)

#### 方法一：单调栈

**思路**

调用 $\textit{next}$ 时，输入是新的一天的股票价格，需要返回包含此日在内的，往前数最多有连续多少日的股票价格是小于等于今日股票价格的。如果把每日的 $\textit{price}$ 当成数组不同下标的值，即需要求出每个值与上一个更大元素之间的下标之差。这种题目可以用单调栈求解，具体原理可以参考「[496. 下一个更大元素 I 的官方题解的方法二](https://leetcode.cn/problems/next-greater-element-i/solution/xia-yi-ge-geng-da-yuan-su-i-by-leetcode-bfcoj/)」。此题的具体解法上，栈的元素可以是股票价格的下标（即天数）和股票价格的二元数对，并且在栈中先插入一个最大值作为天数为 $-1$ 天的价格，来保证栈不会为空。调用 $\textit{next}$ 时，先将栈中价格小于等于此时 $\textit{price}$ 的元素都弹出，直到遇到一个大于 $\textit{price}$ 的值，并将 $\textit{price}$ 入栈，计算下标差返回。

**代码**

```Python [sol1-Python3]
class StockSpanner:
    def __init__(self):
        self.stack = [(-1, inf)]
        self.idx = -1

    def next(self, price: int) -> int:
        self.idx += 1
        while price >= self.stack[-1][1]:
            self.stack.pop()
        self.stack.append((self.idx, price))
        return self.idx - self.stack[-2][0]
```

```Java [sol1-Java]
class StockSpanner {
    Deque<int[]> stack;
    int idx;

    public StockSpanner() {
        stack = new ArrayDeque<int[]>();
        stack.push(new int[]{-1, Integer.MAX_VALUE});
        idx = -1;
    }

    public int next(int price) {
        idx++;
        while (price >= stack.peek()[1]) {
            stack.pop();
        }
        int ret = idx - stack.peek()[0];
        stack.push(new int[]{idx, price});
        return ret;
    }
}
```

```C# [sol1-C#]
public class StockSpanner {
    Stack<Tuple<int, int>> stack;
    int idx;

    public StockSpanner() {
        stack = new Stack<Tuple<int, int>>();
        stack.Push(new Tuple<int, int>(-1, int.MaxValue));
        idx = -1;
    }

    public int Next(int price) {
        idx++;
        while (price >= stack.Peek().Item2) {
            stack.Pop();
        }
        int ret = idx - stack.Peek().Item1;
        stack.Push(new Tuple<int, int>(idx, price));
        return ret;
    }
}
```

```C++ [sol1-C++]
class StockSpanner {
public:
    StockSpanner() {
        this->stk.emplace(-1, INT_MAX);
        this->idx = -1;
    }
    
    int next(int price) {
        idx++;
        while (price >= stk.top().second) {
            stk.pop();
        }
        int ret = idx - stk.top().first;
        stk.emplace(idx, price);
        return ret;
    }

private:
    stack<pair<int, int>> stk; 
    int idx;
};
```

```C [sol1-C]
typedef struct Node {
    int first;
    int second;
    struct Node *next;
} Node;

typedef struct {
    Node *stack;
    int idx;
} StockSpanner;

Node* nodeCreate(int first, int second) {
    Node *obj = (Node *)malloc(sizeof(Node));
    obj->first = first;
    obj->second = second;
    obj->next = NULL;   
    return obj; 
}

StockSpanner* stockSpannerCreate() {
    StockSpanner *obj = (StockSpanner *)malloc(sizeof(StockSpanner));
    obj->idx = -1;
    obj->stack = nodeCreate(-1, INT_MAX);
    return obj;
}

int stockSpannerNext(StockSpanner* obj, int price) {
    obj->idx++;
    while (price >= obj->stack->second) {
        Node *p = obj->stack;
        obj->stack = obj->stack->next;
        free(p);
    }
    int ret = obj->idx - obj->stack->first;
    Node *p = nodeCreate(obj->idx, price);
    p->next = obj->stack;
    obj->stack = p;
    return ret;
}

void stockSpannerFree(StockSpanner* obj) {
    for (Node *p = obj->stack; p;) {
        Node *node = p;
        p = p->next;
        free(node);
    }
    free(obj);
}
```

```JavaScript [sol1-JavaScript]
var StockSpanner = function() {
    this.stack = [];
    this.stack.push([-1, Number.MAX_VALUE]);
    this.idx = -1;
};

StockSpanner.prototype.next = function(price) {
    this.idx++;
    while (price >= this.stack[this.stack.length - 1][1]) {
        this.stack.pop();
    }
    let ret = this.idx - this.stack[this.stack.length - 1][0];
    this.stack.push([this.idx, price]);
    return ret;
};
```

```go [sol1-Golang]
type StockSpanner struct {
    stack [][2]int
    idx   int
}

func Constructor() StockSpanner {
    return StockSpanner{[][2]int{{-1, math.MaxInt32}}, -1}
}

func (s *StockSpanner) Next(price int) int {
    s.idx++
    for price >= s.stack[len(s.stack)-1][1] {
        s.stack = s.stack[:len(s.stack)-1]
    }
    s.stack = append(s.stack, [2]int{s.idx, price})
    return s.idx - s.stack[len(s.stack)-2][0]
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为调用 $\textit{next}$ 函数的次数，每个 $\textit{price}$ 值最多都会入栈出栈各 $1$ 次。

- 空间复杂度：$O(n)$，栈中最多有 $n$ 个元素。
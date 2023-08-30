### 📺 视频题解  
![225. 用队列实现栈 2.mp4](904c0b3d-b8cc-4560-95d2-a5cd2d59effd)

### 📖 文字题解
#### 绪论

这道题目是为初级读者准备的，题目涉及到栈和队列两种数据结构。

栈是一种后进先出的数据结构，元素从顶端入栈，然后从顶端出栈。

队列是一种先进先出的数据结构，元素从后端入队，然后从前端出队。

#### 方法一：两个队列

为了满足栈的特性，即最后入栈的元素最先出栈，在使用队列实现栈时，应满足队列前端的元素是最后入栈的元素。可以使用两个队列实现栈的操作，其中 $\textit{queue}_1$ 用于存储栈内的元素，$\textit{queue}_2$ 作为入栈操作的辅助队列。

入栈操作时，首先将元素入队到 $\textit{queue}_2$，然后将 $\textit{queue}_1$ 的全部元素依次出队并入队到 $\textit{queue}_2$，此时 $\textit{queue}_2$ 的前端的元素即为新入栈的元素，再将 $\textit{queue}_1$ 和 $\textit{queue}_2$ 互换，则 $\textit{queue}_1$ 的元素即为栈内的元素，$\textit{queue}_1$ 的前端和后端分别对应栈顶和栈底。

由于每次入栈操作都确保 $\textit{queue}_1$ 的前端元素为栈顶元素，因此出栈操作和获得栈顶元素操作都可以简单实现。出栈操作只需要移除 $\textit{queue}_1$ 的前端元素并返回即可，获得栈顶元素操作只需要获得 $\textit{queue}_1$ 的前端元素并返回即可（不移除元素）。

由于 $\textit{queue}_1$ 用于存储栈内的元素，判断栈是否为空时，只需要判断 $\textit{queue}_1$ 是否为空即可。

![fig1](https://assets.leetcode-cn.com/solution-static/225/225_fig1.gif)

```Java [sol1-Java]
class MyStack {
    Queue<Integer> queue1;
    Queue<Integer> queue2;

    /** Initialize your data structure here. */
    public MyStack() {
        queue1 = new LinkedList<Integer>();
        queue2 = new LinkedList<Integer>();
    }
    
    /** Push element x onto stack. */
    public void push(int x) {
        queue2.offer(x);
        while (!queue1.isEmpty()) {
            queue2.offer(queue1.poll());
        }
        Queue<Integer> temp = queue1;
        queue1 = queue2;
        queue2 = temp;
    }
    
    /** Removes the element on top of the stack and returns that element. */
    public int pop() {
        return queue1.poll();
    }
    
    /** Get the top element. */
    public int top() {
        return queue1.peek();
    }
    
    /** Returns whether the stack is empty. */
    public boolean empty() {
        return queue1.isEmpty();
    }
}
```

```cpp [sol1-C++]
class MyStack {
public:
    queue<int> queue1;
    queue<int> queue2;

    /** Initialize your data structure here. */
    MyStack() {

    }

    /** Push element x onto stack. */
    void push(int x) {
        queue2.push(x);
        while (!queue1.empty()) {
            queue2.push(queue1.front());
            queue1.pop();
        }
        swap(queue1, queue2);
    }
    
    /** Removes the element on top of the stack and returns that element. */
    int pop() {
        int r = queue1.front();
        queue1.pop();
        return r;
    }
    
    /** Get the top element. */
    int top() {
        int r = queue1.front();
        return r;
    }
    
    /** Returns whether the stack is empty. */
    bool empty() {
        return queue1.empty();
    }
};
```

```Python [sol1-Python3]
class MyStack:

    def __init__(self):
        """
        Initialize your data structure here.
        """
        self.queue1 = collections.deque()
        self.queue2 = collections.deque()


    def push(self, x: int) -> None:
        """
        Push element x onto stack.
        """
        self.queue2.append(x)
        while self.queue1:
            self.queue2.append(self.queue1.popleft())
        self.queue1, self.queue2 = self.queue2, self.queue1


    def pop(self) -> int:
        """
        Removes the element on top of the stack and returns that element.
        """
        return self.queue1.popleft()


    def top(self) -> int:
        """
        Get the top element.
        """
        return self.queue1[0]


    def empty(self) -> bool:
        """
        Returns whether the stack is empty.
        """
        return not self.queue1
```

```Golang [sol1-Golang]
type MyStack struct {
    queue1, queue2 []int
}

/** Initialize your data structure here. */
func Constructor() (s MyStack) {
    return
}

/** Push element x onto stack. */
func (s *MyStack) Push(x int) {
    s.queue2 = append(s.queue2, x)
    for len(s.queue1) > 0 {
        s.queue2 = append(s.queue2, s.queue1[0])
        s.queue1 = s.queue1[1:]
    }
    s.queue1, s.queue2 = s.queue2, s.queue1
}

/** Removes the element on top of the stack and returns that element. */
func (s *MyStack) Pop() int {
    v := s.queue1[0]
    s.queue1 = s.queue1[1:]
    return v
}

/** Get the top element. */
func (s *MyStack) Top() int {
    return s.queue1[0]
}

/** Returns whether the stack is empty. */
func (s *MyStack) Empty() bool {
    return len(s.queue1) == 0
}
```

```C [sol1-C]
#define LEN 20
typedef struct queue {
    int *data;
    int head;
    int rear;
    int size;
} Queue;

typedef struct {
    Queue *queue1, *queue2;
} MyStack;

Queue *initQueue(int k) {
    Queue *obj = (Queue *)malloc(sizeof(Queue));
    obj->data = (int *)malloc(k * sizeof(int));
    obj->head = -1;
    obj->rear = -1;
    obj->size = k;
    return obj;
}

void enQueue(Queue *obj, int e) {
    if (obj->head == -1) {
        obj->head = 0;
    }
    obj->rear = (obj->rear + 1) % obj->size;
    obj->data[obj->rear] = e;
}

int deQueue(Queue *obj) {
    int a = obj->data[obj->head];
    if (obj->head == obj->rear) {
        obj->rear = -1;
        obj->head = -1;
        return a;
    }
    obj->head = (obj->head + 1) % obj->size;
    return a;
}

int isEmpty(Queue *obj) {
    return obj->head == -1;
}

MyStack *myStackCreate() {
    MyStack *obj = (MyStack *)malloc(sizeof(MyStack));
    obj->queue1 = initQueue(LEN);
    obj->queue2 = initQueue(LEN);
    return obj;
}

void myStackPush(MyStack *obj, int x) {
    if (isEmpty(obj->queue1)) {
        enQueue(obj->queue2, x);
    } else {
        enQueue(obj->queue1, x);
    }
}

int myStackPop(MyStack *obj) {
    if (isEmpty(obj->queue1)) {
        while (obj->queue2->head != obj->queue2->rear) {
            enQueue(obj->queue1, deQueue(obj->queue2));
        }
        return deQueue(obj->queue2);
    }
    while (obj->queue1->head != obj->queue1->rear) {
        enQueue(obj->queue2, deQueue(obj->queue1));
    }
    return deQueue(obj->queue1);
}

int myStackTop(MyStack *obj) {
    if (isEmpty(obj->queue1)) {
        return obj->queue2->data[obj->queue2->rear];
    }
    return obj->queue1->data[obj->queue1->rear];
}

bool myStackEmpty(MyStack *obj) {
    if (obj->queue1->head == -1 && obj->queue2->head == -1) {
        return true;
    }
    return false;
}

void myStackFree(MyStack *obj) {
    free(obj->queue1->data);
    obj->queue1->data = NULL;
    free(obj->queue1);
    obj->queue1 = NULL;
    free(obj->queue2->data);
    obj->queue2->data = NULL;
    free(obj->queue2);
    obj->queue2 = NULL;
    free(obj);
    obj = NULL;
}
```

**复杂度分析**

- 时间复杂度：入栈操作 $O(n)$，其余操作都是 $O(1)$，其中 $n$ 是栈内的元素个数。
  入栈操作需要将 $\textit{queue}_1$ 中的 $n$ 个元素出队，并入队 $n+1$ 个元素到 $\textit{queue}_2$，共有 $2n+1$ 次操作，每次出队和入队操作的时间复杂度都是 $O(1)$，因此入栈操作的时间复杂度是 $O(n)$。
  出栈操作对应将 $\textit{queue}_1$ 的前端元素出队，时间复杂度是 $O(1)$。
  获得栈顶元素操作对应获得 $\textit{queue}_1$ 的前端元素，时间复杂度是 $O(1)$。
  判断栈是否为空操作只需要判断 $\textit{queue}_1$ 是否为空，时间复杂度是 $O(1)$。

- 空间复杂度：$O(n)$，其中 $n$ 是栈内的元素个数。需要使用两个队列存储栈内的元素。

#### 方法二：一个队列

方法一使用了两个队列实现栈的操作，也可以使用一个队列实现栈的操作。

使用一个队列时，为了满足栈的特性，即最后入栈的元素最先出栈，同样需要满足队列前端的元素是最后入栈的元素。

入栈操作时，首先获得入栈前的元素个数 $n$，然后将元素入队到队列，再将队列中的前 $n$ 个元素（即除了新入栈的元素之外的全部元素）依次出队并入队到队列，此时队列的前端的元素即为新入栈的元素，且队列的前端和后端分别对应栈顶和栈底。

由于每次入栈操作都确保队列的前端元素为栈顶元素，因此出栈操作和获得栈顶元素操作都可以简单实现。出栈操作只需要移除队列的前端元素并返回即可，获得栈顶元素操作只需要获得队列的前端元素并返回即可（不移除元素）。

由于队列用于存储栈内的元素，判断栈是否为空时，只需要判断队列是否为空即可。

![fig2](https://assets.leetcode-cn.com/solution-static/225/225_fig2.gif)

```Java [sol2-Java]
class MyStack {
    Queue<Integer> queue;

    /** Initialize your data structure here. */
    public MyStack() {
        queue = new LinkedList<Integer>();
    }
    
    /** Push element x onto stack. */
    public void push(int x) {
        int n = queue.size();
        queue.offer(x);
        for (int i = 0; i < n; i++) {
            queue.offer(queue.poll());
        }
    }
    
    /** Removes the element on top of the stack and returns that element. */
    public int pop() {
        return queue.poll();
    }
    
    /** Get the top element. */
    public int top() {
        return queue.peek();
    }
    
    /** Returns whether the stack is empty. */
    public boolean empty() {
        return queue.isEmpty();
    }
}
```

```cpp [sol2-C++]
class MyStack {
public:
    queue<int> q;

    /** Initialize your data structure here. */
    MyStack() {

    }

    /** Push element x onto stack. */
    void push(int x) {
        int n = q.size();
        q.push(x);
        for (int i = 0; i < n; i++) {
            q.push(q.front());
            q.pop();
        }
    }
    
    /** Removes the element on top of the stack and returns that element. */
    int pop() {
        int r = q.front();
        q.pop();
        return r;
    }
    
    /** Get the top element. */
    int top() {
        int r = q.front();
        return r;
    }
    
    /** Returns whether the stack is empty. */
    bool empty() {
        return q.empty();
    }
};
```

```Python [sol2-Python3]
class MyStack:

    def __init__(self):
        """
        Initialize your data structure here.
        """
        self.queue = collections.deque()


    def push(self, x: int) -> None:
        """
        Push element x onto stack.
        """
        n = len(self.queue)
        self.queue.append(x)
        for _ in range(n):
            self.queue.append(self.queue.popleft())


    def pop(self) -> int:
        """
        Removes the element on top of the stack and returns that element.
        """
        return self.queue.popleft()


    def top(self) -> int:
        """
        Get the top element.
        """
        return self.queue[0]


    def empty(self) -> bool:
        """
        Returns whether the stack is empty.
        """
        return not self.queue
```

```Golang [sol2-Golang]
type MyStack struct {
    queue []int
}

/** Initialize your data structure here. */
func Constructor() (s MyStack) {
    return
}

/** Push element x onto stack. */
func (s *MyStack) Push(x int) {
    n := len(s.queue)
    s.queue = append(s.queue, x)
    for ; n > 0; n-- {
        s.queue = append(s.queue, s.queue[0])
        s.queue = s.queue[1:]
    }
}

/** Removes the element on top of the stack and returns that element. */
func (s *MyStack) Pop() int {
    v := s.queue[0]
    s.queue = s.queue[1:]
    return v
}

/** Get the top element. */
func (s *MyStack) Top() int {
    return s.queue[0]
}

/** Returns whether the stack is empty. */
func (s *MyStack) Empty() bool {
    return len(s.queue) == 0
}
```

```C [sol2-C]
typedef struct tagListNode {
    struct tagListNode* next;
    int val;
} ListNode;

typedef struct {
    ListNode* top;
} MyStack;

MyStack* myStackCreate() {
    MyStack* stk = calloc(1, sizeof(MyStack));
    return stk;
}

void myStackPush(MyStack* obj, int x) {
    ListNode* node = malloc(sizeof(ListNode));
    node->val = x;
    node->next = obj->top;
    obj->top = node;
}

int myStackPop(MyStack* obj) {
    ListNode* node = obj->top;
    int val = node->val;
    obj->top = node->next;
    free(node);

    return val;
}

int myStackTop(MyStack* obj) {
    return obj->top->val;
}

bool myStackEmpty(MyStack* obj) {
    return (obj->top == NULL);
}

void myStackFree(MyStack* obj) {
    while (obj->top != NULL) {
        ListNode* node = obj->top;
        obj->top = obj->top->next;
        free(node);
    }
    free(obj);
}
```

**复杂度分析**

- 时间复杂度：入栈操作 $O(n)$，其余操作都是 $O(1)$，其中 $n$ 是栈内的元素个数。
  入栈操作需要将队列中的 $n$ 个元素出队，并入队 $n+1$ 个元素到队列，共有 $2n+1$ 次操作，每次出队和入队操作的时间复杂度都是 $O(1)$，因此入栈操作的时间复杂度是 $O(n)$。
  出栈操作对应将队列的前端元素出队，时间复杂度是 $O(1)$。
  获得栈顶元素操作对应获得队列的前端元素，时间复杂度是 $O(1)$。
  判断栈是否为空操作只需要判断队列是否为空，时间复杂度是 $O(1)$。

- 空间复杂度：$O(n)$，其中 $n$ 是栈内的元素个数。需要使用一个队列存储栈内的元素。
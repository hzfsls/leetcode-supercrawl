## [622.设计循环队列 中文官方题解](https://leetcode.cn/problems/design-circular-queue/solutions/100000/she-ji-xun-huan-dui-lie-by-leetcode-solu-1w0a)
#### 方法一：数组

关于循环队列的概念可以参考：「[循环队列](https://baike.baidu.com/item/%E5%BE%AA%E7%8E%AF%E9%98%9F%E5%88%97/3685773?fr=aladdin)」，我们可以通过一个数组进行模拟，通过操作数组的索引构建一个虚拟的首尾相连的环。在循环队列结构中，设置一个队尾 $\textit{rear}$ 与队首 $\textit{front}$，且大小固定，结构如下图所示:
![1](https://assets.leetcode-cn.com/solution-static/622/622_1.png)
在循环队列中，当队列为空，可知 $\textit{front}=\textit{rear}$；而当所有队列空间全占满时，也有 $\textit{front}=\textit{rear}$。为了区别这两种情况，假设队列使用的数组有 $\textit{capacity}$ 个存储空间，则此时规定循环队列最多只能有$\textit{capacity} - 1$ 个队列元素，当循环队列中只剩下一个空存储单元时，则表示队列已满。根据以上可知，队列判空的条件是 $\textit{front}=\textit{rear}$，而队列判满的条件是 $\textit{front} = (\textit{rear} + 1) \bmod \textit{capacity}$。 
对于一个固定大小的数组，只要知道队尾 $\textit{rear}$ 与队首 $\textit{front}$，即可计算出队列当前的长度：
$$
(\textit{rear} - \textit{front} + \textit{capacity}) \bmod \textit{capacity}
$$

循环队列的属性如下:
+ $\textit{elements}$：一个固定大小的数组，用于保存循环队列的元素。
+ $\textit{capacity}$：循环队列的容量，即队列中最多可以容纳的元素数量。
+ $\textit{front}$：队列首元素对应的数组的索引。
+ $\textit{rear}$：队列尾元素对应的索引的下一个索引。

循环队列的接口方法如下：
+ $\texttt{MyCircularQueue(int k)}$: 初始化队列，同时$\textit{base}$ 数组的空间初始化大小为 $k + 1$。$\textit{front}, \textit{rear}$ 全部初始化为 $0$。
+ $\texttt{enQueue(int value)}$：在队列的尾部插入一个元素，并同时将队尾的索引 $\textit{rear}$ 更新为 $(\textit{rear} + 1) \bmod capacity$。
+ $\texttt{deQueue()}$：从队首取出一个元素，并同时将队首的索引 $\textit{front}$ 更新为 $(\textit{front} + 1) \bmod capacity$。
+ $\texttt{Front()}$：返回队首的元素，需要检测队列是否为空。
+ $\texttt{Rear()}$：返回队尾的元素，需要检测队列是否为空。
+ $\texttt{isEmpty()}$：检测队列是否为空，根据之前的定义只需判断 $\textit{rear}$ 是否等于 $\textit{front}$。
+ $\texttt{isFull()}$：检测队列是否已满，根据之前的定义只需判断 $\textit{front}$ 是否等于 $(\textit{rear} + 1) \bmod \textit{capacity}$。

```Python [sol1-Python3]
class MyCircularQueue:
    def __init__(self, k: int):
        self.front = self.rear = 0
        self.elements = [0] * (k + 1)

    def enQueue(self, value: int) -> bool:
        if self.isFull():
            return False
        self.elements[self.rear] = value
        self.rear = (self.rear + 1) % len(self.elements)
        return True

    def deQueue(self) -> bool:
        if self.isEmpty():
            return False
        self.front = (self.front + 1) % len(self.elements)
        return True

    def Front(self) -> int:
        return -1 if self.isEmpty() else self.elements[self.front]

    def Rear(self) -> int:
        return -1 if self.isEmpty() else self.elements[(self.rear - 1) % len(self.elements)]

    def isEmpty(self) -> bool:
        return self.rear == self.front

    def isFull(self) -> bool:
        return (self.rear + 1) % len(self.elements) == self.front
```

```C++ [sol1-C++]
class MyCircularQueue {
private:
    int front;
    int rear;
    int capacity;
    vector<int> elements;

public:
    MyCircularQueue(int k) {
        this->capacity = k + 1;
        this->elements = vector<int>(capacity);
        rear = front = 0;
    }

    bool enQueue(int value) {
        if (isFull()) {
            return false;
        }
        elements[rear] = value;
        rear = (rear + 1) % capacity;
        return true;
    }

    bool deQueue() {
        if (isEmpty()) {
            return false;
        }
        front = (front + 1) % capacity;
        return true;
    }

    int Front() {
        if (isEmpty()) {
            return -1;
        }
        return elements[front];
    }

    int Rear() {
        if (isEmpty()) {
            return -1;
        }
        return elements[(rear - 1 + capacity) % capacity];
    }

    bool isEmpty() {
        return rear == front;
    }

    bool isFull() {
        return ((rear + 1) % capacity) == front;
    }
};
```

```Java [sol1-Java]
class MyCircularQueue {
    private int front;
    private int rear;
    private int capacity;
    private int[] elements;

    public MyCircularQueue(int k) {
        capacity = k + 1;
        elements = new int[capacity];
        rear = front = 0;
    }

    public boolean enQueue(int value) {
        if (isFull()) {
            return false;
        }
        elements[rear] = value;
        rear = (rear + 1) % capacity;
        return true;
    }

    public boolean deQueue() {
        if (isEmpty()) {
            return false;
        }
        front = (front + 1) % capacity;
        return true;
    }

    public int Front() {
        if (isEmpty()) {
            return -1;
        }
        return elements[front];
    }

    public int Rear() {
        if (isEmpty()) {
            return -1;
        }
        return elements[(rear - 1 + capacity) % capacity];
    }

    public boolean isEmpty() {
        return rear == front;
    }

    public boolean isFull() {
        return ((rear + 1) % capacity) == front;
    }
}
```

```C# [sol1-C#]
public class MyCircularQueue {
    private int front;
    private int rear;
    private int capacity;
    private int[] elements;

    public MyCircularQueue(int k) {
        capacity = k + 1;
        elements = new int[capacity];
        rear = front = 0;
    }

    public bool EnQueue(int value) {
        if (IsFull()) {
            return false;
        }
        elements[rear] = value;
        rear = (rear + 1) % capacity;
        return true;
    }

    public bool DeQueue() {
        if (IsEmpty()) {
            return false;
        }
        front = (front + 1) % capacity;
        return true;
    }

    public int Front() {
        if (IsEmpty()) {
            return -1;
        }
        return elements[front];
    }

    public int Rear() {
        if (IsEmpty()) {
            return -1;
        }
        return elements[(rear - 1 + capacity) % capacity];
    }

    public bool IsEmpty() {
        return rear == front;
    }

    public bool IsFull() {
        return ((rear + 1) % capacity) == front;
    }
}
```

```C [sol1-C]
typedef struct {
    int front;
    int rear;
    int capacity;
    int *elements;
} MyCircularQueue;

MyCircularQueue* myCircularQueueCreate(int k) {
    MyCircularQueue *obj = (MyCircularQueue *)malloc(sizeof(MyCircularQueue));
    obj->capacity = k + 1;
    obj->rear = obj->front = 0;
    obj->elements = (int *)malloc(sizeof(int) * obj->capacity);
    return obj;
}

bool myCircularQueueEnQueue(MyCircularQueue* obj, int value) {
    if ((obj->rear + 1) % obj->capacity == obj->front) {
        return false;
    }
    obj->elements[obj->rear] = value;
    obj->rear = (obj->rear + 1) % obj->capacity;
    return true;
}

bool myCircularQueueDeQueue(MyCircularQueue* obj) {
    if (obj->rear == obj->front) {
        return false;
    }
    obj->front = (obj->front + 1) % obj->capacity;
    return true;
}

int myCircularQueueFront(MyCircularQueue* obj) {
    if (obj->rear == obj->front) {
        return -1;
    }
    return obj->elements[obj->front];
}

int myCircularQueueRear(MyCircularQueue* obj) {
    if (obj->rear == obj->front) {
        return -1;
    }
    return obj->elements[(obj->rear - 1 + obj->capacity) % obj->capacity];
}

bool myCircularQueueIsEmpty(MyCircularQueue* obj) {
    return obj->rear == obj->front;
}

bool myCircularQueueIsFull(MyCircularQueue* obj) {
    return (obj->rear + 1) % obj->capacity == obj->front;
}

void myCircularQueueFree(MyCircularQueue* obj) {
    free(obj->elements);
    free(obj);
}
```

```go [sol1-Golang]
type MyCircularQueue struct {
    front, rear int
    elements    []int
}

func Constructor(k int) MyCircularQueue {
    return MyCircularQueue{elements: make([]int, k+1)}
}

func (q *MyCircularQueue) EnQueue(value int) bool {
    if q.IsFull() {
        return false
    }
    q.elements[q.rear] = value
    q.rear = (q.rear + 1) % len(q.elements)
    return true
}

func (q *MyCircularQueue) DeQueue() bool {
    if q.IsEmpty() {
        return false
    }
    q.front = (q.front + 1) % len(q.elements)
    return true
}

func (q MyCircularQueue) Front() int {
    if q.IsEmpty() {
        return -1
    }
    return q.elements[q.front]
}

func (q MyCircularQueue) Rear() int {
    if q.IsEmpty() {
        return -1
    }
    return q.elements[(q.rear-1+len(q.elements))%len(q.elements)]
}

func (q MyCircularQueue) IsEmpty() bool {
    return q.rear == q.front
}

func (q MyCircularQueue) IsFull() bool {
    return (q.rear+1)%len(q.elements) == q.front
}
```

```JavaScript [sol1-JavaScript]
var MyCircularQueue = function(k) {
    this.capacity = k + 1;
    this.elements = new Array(this.capacity).fill(0);
    this.rear = 0;
    this.front = 0;
};

MyCircularQueue.prototype.enQueue = function(value) {
    if (this.isFull()) {
        return false;
    }
    this.elements[this.rear] = value;
    this.rear = (this.rear + 1) % this.capacity;
    return true;
};

MyCircularQueue.prototype.deQueue = function() {
    if (this.isEmpty()) {
        return false;
    }
    this.front = (this.front + 1) % this.capacity;
    return true;
};

MyCircularQueue.prototype.Front = function() {
    if (this.isEmpty()) {
        return -1;
    }
    return this.elements[this.front];
};

MyCircularQueue.prototype.Rear = function() {
    if (this.isEmpty()) {
        return -1;
    }
    return this.elements[(this.rear - 1 + this.capacity) % this.capacity];
};

MyCircularQueue.prototype.isEmpty = function() {
    return this.rear == this.front;
};

MyCircularQueue.prototype.isFull = function() {
    return ((this.rear + 1) % this.capacity) === this.front;
};
```

**复杂度分析**

- 时间复杂度：初始化和每项操作的时间复杂度均为 $O(1)$。

- 空间复杂度：$O(k)$，其中 $k$ 为给定的队列元素数目。

#### 方法二：链表

我们同样可以用链表实现队列，用链表实现队列则较为简单，因为链表可以在 $O(1)$ 时间复杂度完成插入与删除。入队列时，将新的元素插入到链表的尾部；出队列时，将链表的头节点返回，并将头节点指向下一个节点。

循环队列的属性如下:
+ $\textit{head}$：链表的头节点，队列的头节点。
+ $\textit{tail}$：链表的尾节点，队列的尾节点。
+ $\textit{capacity}$：队列的容量，即队列可以存储的最大元素数量。
+ $\textit{size}$：队列当前的元素的数量。

```Python [sol2-Python3]
class MyCircularQueue:
    def __init__(self, k: int):
        self.head = self.tail = None
        self.capacity = k
        self.size = 0

    def enQueue(self, value: int) -> bool:
        if self.isFull():
            return False
        node = ListNode(value)
        if self.head is None:
            self.head = node
            self.tail = node
        else:
            self.tail.next = node
            self.tail = node
        self.size += 1
        return True

    def deQueue(self) -> bool:
        if self.isEmpty():
            return False
        self.head = self.head.next
        self.size -= 1
        return True

    def Front(self) -> int:
        return -1 if self.isEmpty() else self.head.val

    def Rear(self) -> int:
        return -1 if self.isEmpty() else self.tail.val

    def isEmpty(self) -> bool:
        return self.size == 0

    def isFull(self) -> bool:
        return self.size == self.capacity
```

```C++ [sol2-C++]
class MyCircularQueue {
private:
    ListNode *head;
    ListNode *tail;
    int capacity;
    int size;

public:
    MyCircularQueue(int k) {
        this->capacity = k;
        this->size = 0;
        this->head = this->tail = nullptr;
    }

    bool enQueue(int value) {
        if (isFull()) {
            return false;
        }
        ListNode *node = new ListNode(value);
        if (!head) {
            head = tail = node;
        } else {
            tail->next = node;
            tail = node;
        }
        size++;
        return true;
    }

    bool deQueue() {
        if (isEmpty()) {
            return false;
        }
        ListNode *node = head;
        head = head->next;  
        size--;
        delete node;
        return true;
    }

    int Front() {
        if (isEmpty()) {
            return -1;
        }
        return head->val;
    }

    int Rear() {
        if (isEmpty()) {
            return -1;
        }
        return tail->val;
    }

    bool isEmpty() {
        return size == 0;
    }

    bool isFull() {
        return size == capacity;
    }
};
```

```Java [sol2-Java]
class MyCircularQueue {
    private ListNode head;
    private ListNode tail;
    private int capacity;
    private int size;

    public MyCircularQueue(int k) {
        capacity = k;
        size = 0;
    }

    public boolean enQueue(int value) {
        if (isFull()) {
            return false;
        }
        ListNode node = new ListNode(value);
        if (head == null) {
            head = tail = node;
        } else {
            tail.next = node;
            tail = node;
        }
        size++;
        return true;
    }

    public boolean deQueue() {
        if (isEmpty()) {
            return false;
        }
        ListNode node = head;
        head = head.next;  
        size--;
        return true;
    }

    public int Front() {
        if (isEmpty()) {
            return -1;
        }
        return head.val;
    }

    public int Rear() {
        if (isEmpty()) {
            return -1;
        }
        return tail.val;
    }

    public boolean isEmpty() {
        return size == 0;
    }

    public boolean isFull() {
        return size == capacity;
    }
}
```

```C# [sol2-C#]
public class MyCircularQueue {
    private ListNode head;
    private ListNode tail;
    private int capacity;
    private int size;

    public MyCircularQueue(int k) {
        capacity = k;
        size = 0;
    }

    public bool EnQueue(int value) {
        if (IsFull()) {
            return false;
        }
        ListNode node = new ListNode(value);
        if (head == null) {
            head = tail = node;
        } else {
            tail.next = node;
            tail = node;
        }
        size++;
        return true;
    }

    public bool DeQueue() {
        if (IsEmpty()) {
            return false;
        }
        ListNode node = head;
        head = head.next;  
        size--;
        return true;
    }

    public int Front() {
        if (IsEmpty()) {
            return -1;
        }
        return head.val;
    }

    public int Rear() {
        if (IsEmpty()) {
            return -1;
        }
        return tail.val;
    }

    public bool IsEmpty() {
        return size == 0;
    }

    public bool IsFull() {
        return size == capacity;
    }
}
```

```C [sol2-C]
typedef struct {
    struct ListNode *head;
    struct ListNode *tail;
    int capacity;
    int size;
} MyCircularQueue;


MyCircularQueue* myCircularQueueCreate(int k) {
    MyCircularQueue *obj = (MyCircularQueue *)malloc(sizeof(MyCircularQueue));
    obj->capacity = k;
    obj->size = 0;
    obj->head = obj->tail = NULL;
    return obj;
}

bool myCircularQueueEnQueue(MyCircularQueue* obj, int value) {
    if (obj->size >= obj->capacity) {
        return false;
    }
    struct ListNode *node = (struct ListNode *)malloc(sizeof(struct ListNode));
    node->val = value;
    node->next = NULL;
    if (!obj->head) {
        obj->head = obj->tail = node;
    } else {
        obj->tail->next = node;
        obj->tail = node;
    }
    obj->size++;
    return true;
}

bool myCircularQueueDeQueue(MyCircularQueue* obj) {
    if (obj->size == 0) {
        return false;
    }
    struct ListNode *node = obj->head;
    obj->head = obj->head->next;  
    obj->size--;
    free(node);
    return true;
}

int myCircularQueueFront(MyCircularQueue* obj) {
    if (obj->size == 0) {
        return -1;
    }
    return obj->head->val;
}

int myCircularQueueRear(MyCircularQueue* obj) {
    if (obj->size == 0) {
        return -1;
    }
    return obj->tail->val;
}

bool myCircularQueueIsEmpty(MyCircularQueue* obj) {
    return obj->size == 0;
}

bool myCircularQueueIsFull(MyCircularQueue* obj) {
    return obj->size == obj->capacity;
}

void myCircularQueueFree(MyCircularQueue* obj) {
    for (struct ListNode *curr = obj->head; curr;) {
        struct ListNode *node = curr;
        curr = curr->next;
        free(node);
    }
    free(obj);
}
```

```go [sol2-Golang]
type MyCircularQueue struct {
    head, tail     *ListNode
    capacity, size int
}

func Constructor(k int) MyCircularQueue {
    return MyCircularQueue{capacity: k}
}

func (q *MyCircularQueue) EnQueue(value int) bool {
    if q.IsFull() {
        return false
    }
    node := &ListNode{Val: value}
    if q.head == nil {
        q.head = node
        q.tail = node
    } else {
        q.tail.Next = node
        q.tail = node
    }
    q.size++
    return true
}

func (q *MyCircularQueue) DeQueue() bool {
    if q.IsEmpty() {
        return false
    }
    q.head = q.head.Next
    q.size--
    return true
}

func (q MyCircularQueue) Front() int {
    if q.IsEmpty() {
        return -1
    }
    return q.head.Val
}

func (q MyCircularQueue) Rear() int {
    if q.IsEmpty() {
        return -1
    }
    return q.tail.Val
}

func (q MyCircularQueue) IsEmpty() bool {
    return q.size == 0
}

func (q MyCircularQueue) IsFull() bool {
    return q.size == q.capacity
}
```

**复杂度分析**

- 时间复杂度：初始化和每项操作的时间复杂度均为 $O(1)$。

- 空间复杂度：$O(k)$，其中 $k$ 为给定的队列元素数目。
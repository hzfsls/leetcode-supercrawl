## [641.设计循环双端队列 中文官方题解](https://leetcode.cn/problems/design-circular-deque/solutions/100000/she-ji-xun-huan-shuang-duan-dui-lie-by-l-97v0)
#### 方法一：数组

可以参考循环队列：「[622. 设计循环队列](https://leetcode.cn/problems/design-circular-queue/)」，我们利用循环队列实现双端队列。在循环队列中的基础上，我们增加 $\texttt{insertFront}$ 和 $\texttt{deleteFront}$ 函数实现即可。根据循环队列的定义，队列判空的条件是 $\textit{front}=\textit{rear}$，而队列判满的条件是 $\textit{front} = (\textit{rear} + 1) \bmod \textit{capacity}$。

对于一个固定大小的数组，只要知道队尾 $\textit{rear}$ 与队首 $\textit{front}$，即可计算出队列当前的长度：

$$
(\textit{rear} - \textit{front} + \textit{capacity}) \bmod \textit{capacity}
$$

循环双端队列与循环队列的属性一致:
+ $\texttt{elements}$：一个固定大小的数组，用于保存循环队列的元素。
+ $\texttt{capacity}$：循环队列的容量，即队列中最多可以容纳的元素数量。
+ $\texttt{front}$：队列首元素对应的数组的索引。
+ $\texttt{rear}$：队列尾元素对应的索引的下一个索引。

循环双端队列的接口方法如下：
+ $\texttt{MyCircularDeque(int k)}$：初始化队列，同时 $\textit{base}$ 数组的空间初始化大小为 $k + 1$。$\textit{front},\textit{rear}$ 全部初始化为 $0$。
+ $\texttt{insertFront(int value)}$：队列未满时，在队首插入一个元素。我们首先将队首 $\textit{front}$ 移动一个位置，更新队首索引为 $\textit{front}$ 更新为 $(\textit{front} - 1 + \textit{capacity}) \bmod \textit{capacity}$。
+ $\texttt{insertLast(int value)}$：队列未满时，在队列的尾部插入一个元素，并同时将队尾的索引 $\textit{rear}$ 更新为 $(\textit{rear} + 1) \bmod \textit{capacity}$。
+ $\texttt{deleteFront()}$：队列不为空时，从队首删除一个元素，并同时将队首的索引 $\textit{front}$ 更新为 $(\textit{front} + 1) \bmod \textit{capacity}$。
+ $\texttt{deleteLast()}$：队列不为空时，从队尾删除一个元素。并同时将队尾的索引 $\textit{rear}$ 更新为 $(rear - 1 + capacity) \bmod \textit{capacity}$。
+ $\texttt{getFront()}$：返回队首的元素，需要检测队列是否为空。
+ $\texttt{getRear()}$：返回队尾的元素，需要检测队列是否为空。
+ $\texttt{isEmpty()}$：检测队列是否为空，根据之前的定义只需判断 $\textit{rear}$ 是否等于 $\textit{front}$。
+ $\texttt{isFull()}$：检测队列是否已满，根据之前的定义只需判断 $\textit{front}$ 是否等于 $(\textit{rear} + 1) \bmod \textit{capacity}$。

```Python [sol1-Python3]
class MyCircularDeque:
    def __init__(self, k: int):
        self.front = self.rear = 0
        self.elements = [0] * (k + 1)

    def insertFront(self, value: int) -> bool:
        if self.isFull():
            return False
        self.front = (self.front - 1) % len(self.elements)
        self.elements[self.front] = value
        return True

    def insertLast(self, value: int) -> bool:
        if self.isFull():
            return False
        self.elements[self.rear] = value
        self.rear = (self.rear + 1) % len(self.elements)
        return True

    def deleteFront(self) -> bool:
        if self.isEmpty():
            return False
        self.front = (self.front + 1) % len(self.elements)
        return True

    def deleteLast(self) -> bool:
        if self.isEmpty():
            return False
        self.rear = (self.rear - 1) % len(self.elements)
        return True

    def getFront(self) -> int:
        return -1 if self.isEmpty() else self.elements[self.front]

    def getRear(self) -> int:
        return -1 if self.isEmpty() else self.elements[(self.rear - 1) % len(self.elements)]

    def isEmpty(self) -> bool:
        return self.rear == self.front

    def isFull(self) -> bool:
        return (self.rear + 1) % len(self.elements) == self.front
```

```C++ [sol1-C++]
class MyCircularDeque {
private:
    vector<int> elements;
    int rear, front;
    int capacity;

public:
    MyCircularDeque(int k) {
        capacity = k + 1;
        rear = front = 0;
        elements = vector<int>(k + 1);
    }

    bool insertFront(int value) {
        if (isFull()) {
            return false;
        }
        front = (front - 1 + capacity) % capacity;
        elements[front] = value;
        return true;
    }

    bool insertLast(int value) {
        if (isFull()) {
            return false;
        }
        elements[rear] = value;
        rear = (rear + 1) % capacity;
        return true;
    }

    bool deleteFront() {
        if (isEmpty()) {
            return false;
        }
        front = (front + 1) % capacity;
        return true;
    }

    bool deleteLast() {
        if (isEmpty()) {
            return false;
        }
        rear = (rear - 1 + capacity) % capacity;
        return true;
    }

    int getFront() {
        if (isEmpty()) {
            return -1;
        }
        return elements[front];
    }

    int getRear() {
        if (isEmpty()) {
            return -1;
        }
        return elements[(rear - 1 + capacity) % capacity];
    }   

    bool isEmpty() {
        return rear == front;
    }

    bool isFull() {
        return (rear + 1) % capacity == front;
    }
};
```

```Java [sol1-Java]
class MyCircularDeque {
    private int[] elements;
    private int rear, front;
    private int capacity;

    public MyCircularDeque(int k) {
        capacity = k + 1;
        rear = front = 0;
        elements = new int[k + 1];
    }

    public boolean insertFront(int value) {
        if (isFull()) {
            return false;
        }
        front = (front - 1 + capacity) % capacity;
        elements[front] = value;
        return true;
    }

    public boolean insertLast(int value) {
        if (isFull()) {
            return false;
        }
        elements[rear] = value;
        rear = (rear + 1) % capacity;
        return true;
    }

    public boolean deleteFront() {
        if (isEmpty()) {
            return false;
        }
        front = (front + 1) % capacity;
        return true;
    }

    public boolean deleteLast() {
        if (isEmpty()) {
            return false;
        }
        rear = (rear - 1 + capacity) % capacity;
        return true;
    }

    public int getFront() {
        if (isEmpty()) {
            return -1;
        }
        return elements[front];
    }

    public int getRear() {
        if (isEmpty()) {
            return -1;
        }
        return elements[(rear - 1 + capacity) % capacity];
    }

    public boolean isEmpty() {
        return rear == front;
    }

    public boolean isFull() {
        return (rear + 1) % capacity == front;
    }
}
```

```C# [sol1-C#]
public class MyCircularDeque {
    private int[] elements;
    private int rear, front;
    private int capacity;

    public MyCircularDeque(int k) {
        capacity = k + 1;
        rear = front = 0;
        elements = new int[k + 1];
    }

    public bool InsertFront(int value) {
        if (IsFull()) {
            return false;
        }
        front = (front - 1 + capacity) % capacity;
        elements[front] = value;
        return true;
    }

    public bool InsertLast(int value) {
        if (IsFull()) {
            return false;
        }
        elements[rear] = value;
        rear = (rear + 1) % capacity;
        return true;
    }

    public bool DeleteFront() {
        if (IsEmpty()) {
            return false;
        }
        front = (front + 1) % capacity;
        return true;
    }

    public bool DeleteLast() {
        if (IsEmpty()) {
            return false;
        }
        rear = (rear - 1 + capacity) % capacity;
        return true;
    }

    public int GetFront() {
        if (IsEmpty()) {
            return -1;
        }
        return elements[front];
    }

    public int GetRear() {
        if (IsEmpty()) {
            return -1;
        }
        return elements[(rear - 1 + capacity) % capacity];
    }

    public bool IsEmpty() {
        return rear == front;
    }

    public bool IsFull() {
        return (rear + 1) % capacity == front;
    }
}
```

```C [sol1-C]
typedef struct {
    int *elements;
    int rear, front;
    int capacity;
} MyCircularDeque;

MyCircularDeque* myCircularDequeCreate(int k) {
    MyCircularDeque *obj = (MyCircularDeque *)malloc(sizeof(MyCircularDeque));
    obj->capacity = k + 1;
    obj->rear = obj->front = 0;
    obj->elements = (int *)malloc(sizeof(int) * obj->capacity);
    return obj;
}

bool myCircularDequeInsertFront(MyCircularDeque* obj, int value) {
    if ((obj->rear + 1) % obj->capacity == obj->front) {
        return false;
    }
    obj->front = (obj->front - 1 + obj->capacity) % obj->capacity;
    obj->elements[obj->front] = value;
    return true;
}

bool myCircularDequeInsertLast(MyCircularDeque* obj, int value) {
    if ((obj->rear + 1) % obj->capacity == obj->front) {
        return false;
    }
    obj->elements[obj->rear] = value;
    obj->rear = (obj->rear + 1) % obj->capacity;
    return true;
}

bool myCircularDequeDeleteFront(MyCircularDeque* obj) {
    if (obj->rear == obj->front) {
        return false;
    }
    obj->front = (obj->front + 1) % obj->capacity;
    return true;
}

bool myCircularDequeDeleteLast(MyCircularDeque* obj) {
    if (obj->rear == obj->front) {
        return false;
    }
    obj->rear = (obj->rear - 1 + obj->capacity) % obj->capacity;
    return true;
}

int myCircularDequeGetFront(MyCircularDeque* obj) {
    if (obj->rear == obj->front) {
        return -1;
    }
    return obj->elements[obj->front];
}

int myCircularDequeGetRear(MyCircularDeque* obj) {
    if (obj->rear == obj->front) {
        return -1;
    }
    return obj->elements[(obj->rear - 1 + obj->capacity) % obj->capacity];
}

bool myCircularDequeIsEmpty(MyCircularDeque* obj) {
    return obj->rear == obj->front;
}

bool myCircularDequeIsFull(MyCircularDeque* obj) {
    return (obj->rear + 1) % obj->capacity == obj->front;
}

void myCircularDequeFree(MyCircularDeque* obj) {
    free(obj->elements);
    free(obj);
}
```

```JavaScript [sol1-JavaScript]
var MyCircularDeque = function(k) {
    this.capacity = k + 1;
    this.rear = this.front = 0;
    this.elements = new Array(k + 1).fill(0);
};

MyCircularDeque.prototype.insertFront = function(value) {
    if (this.isFull()) {
        return false;
    }
    this.front = (this.front - 1 + this.capacity) % this.capacity;
    this.elements[this.front] = value;
    return true;
};

MyCircularDeque.prototype.insertLast = function(value) {
    if (this.isFull()) {
        return false;
    }
    this.elements[this.rear] = value;
    this.rear = (this.rear + 1) % this.capacity;
    return true;
};

MyCircularDeque.prototype.deleteFront = function() {
    if (this.isEmpty()) {
        return false;
    }
    this.front = (this.front + 1) % this.capacity;
    return true;
};

MyCircularDeque.prototype.deleteLast = function() {
    if (this.isEmpty()) {
        return false;
    }
    this.rear = (this.rear - 1 + this.capacity) % this.capacity;
    return true;
};

MyCircularDeque.prototype.getFront = function() {
    if (this.isEmpty()) {
        return -1;
    }
    return this.elements[this.front];
};

MyCircularDeque.prototype.getRear = function() {
    if (this.isEmpty()) {
        return -1;
    }
    return this.elements[(this.rear - 1 + this.capacity) % this.capacity];
};

MyCircularDeque.prototype.isEmpty = function() {
    return this.rear == this.front;
};

MyCircularDeque.prototype.isFull = function() {
    return (this.rear + 1) % this.capacity == this.front;
};
```

```go [sol1-Golang]
type MyCircularDeque struct {
    front, rear int
    elements    []int
}

func Constructor(k int) MyCircularDeque {
    return MyCircularDeque{elements: make([]int, k+1)}
}

func (q *MyCircularDeque) InsertFront(value int) bool {
    if q.IsFull() {
        return false
    }
    q.front = (q.front - 1 + len(q.elements)) % len(q.elements)
    q.elements[q.front] = value
    return true
}

func (q *MyCircularDeque) InsertLast(value int) bool {
    if q.IsFull() {
        return false
    }
    q.elements[q.rear] = value
    q.rear = (q.rear + 1) % len(q.elements)
    return true
}

func (q *MyCircularDeque) DeleteFront() bool {
    if q.IsEmpty() {
        return false
    }
    q.front = (q.front + 1) % len(q.elements)
    return true
}

func (q *MyCircularDeque) DeleteLast() bool {
    if q.IsEmpty() {
        return false
    }
    q.rear = (q.rear - 1 + len(q.elements)) % len(q.elements)
    return true
}

func (q MyCircularDeque) GetFront() int {
    if q.IsEmpty() {
        return -1
    }
    return q.elements[q.front]
}

func (q MyCircularDeque) GetRear() int {
    if q.IsEmpty() {
        return -1
    }
    return q.elements[(q.rear-1+len(q.elements))%len(q.elements)]
}

func (q MyCircularDeque) IsEmpty() bool {
    return q.rear == q.front
}

func (q MyCircularDeque) IsFull() bool {
    return (q.rear+1)%len(q.elements) == q.front
}
```

**复杂度分析**

- 时间复杂度：初始化和每项操作的时间复杂度均为 $O(1)$。

- 空间复杂度：$O(k)$，其中 $k$ 为给定的队列元素数目。

#### 方法二：链表

我们同样可以使用双向链表来模拟双端队列，实现双端队列队首与队尾元素的添加、删除。双向链表实现比较简单，双向链表支持 $O(1)$ 时间复杂度内在指定节点的前后插入新的节点或者删除新的节点。

![1](https://assets.leetcode-cn.com/solution-static/641/641_1.png)

循环双端队列的属性如下:
+ $\texttt{head}$：队列的头节点；
+ $\texttt{tail}$：队列的尾节点
+ $\texttt{capacity}$：队列的容量大小。
+ $\texttt{size}$：队列当前的元素数量。

循环双端队列的接口方法如下：
+ $\texttt{MyCircularDeque(int k)}$：初始化队列，同时初始化队列元素数量 $\textit{size}$ 为 $0$。$\textit{head},\textit{tail}$ 初始化为空。 
+ $\texttt{insertFront(int value)}$：队列未满时，在队首头结点 $\textit{head}$ 之前插入一个新的节点，并更新 $\textit{head}$，并更新 $\textit{size}$。
+ $\texttt{insertLast(int value)}$：队列未满时，在队w尾节点 $\textit{tail}$ 之后插入一个新的节点，并更新 $\textit{tail}$，并更新 $\textit{size}$。
+ $\texttt{deleteFront()}$：队列不为空时，删除头结点 $\textit{head}$，并更新 $\textit{head}$ 为 $\textit{head}$ 的后一个节点，并更新 $\textit{size}$。
+ $\texttt{deleteLast()}$：队列不为空时，删除尾结点 $\textit{tail}$，并更新 $\textit{tail}$ 为 $\textit{tail}$ 的前一个节点，并更新 $\textit{size}$。
+ $\texttt{getFront()}$：返回队首节点指向的值，需要检测队列是否为空。
+ $\texttt{getRear()}$：返回队尾节点指向的值，需要检测队列是否为空。
+ $\texttt{isEmpty()}$：检测当前 $\textit{size}$ 是否为 $0$。
+ $\texttt{isFull()}$：检测当前 $\textit{size}$ 是否为 $\textit{capacity}$。

```Python [sol2-Python3]
class Node:
    __slots__ = 'prev', 'next', 'val'

    def __init__(self, val):
        self.prev = self.next = None
        self.val = val


class MyCircularDeque:
    def __init__(self, k: int):
        self.head = self.tail = None
        self.capacity = k
        self.size = 0

    def insertFront(self, value: int) -> bool:
        if self.isFull():
            return False
        node = Node(value)
        if self.isEmpty():
            self.head = node
            self.tail = node
        else:
            node.next = self.head
            self.head.prev = node
            self.head = node
        self.size += 1
        return True

    def insertLast(self, value: int) -> bool:
        if self.isFull():
            return False
        node = Node(value)
        if self.isEmpty():
            self.head = node
            self.tail = node
        else:
            self.tail.next = node
            node.prev = self.tail
            self.tail = node
        self.size += 1
        return True

    def deleteFront(self) -> bool:
        if self.isEmpty():
            return False
        self.head = self.head.next
        if self.head:
            self.head.prev = None
        self.size -= 1
        return True

    def deleteLast(self) -> bool:
        if self.isEmpty():
            return False
        self.tail = self.tail.prev
        if self.tail:
            self.tail.next = None
        self.size -= 1
        return True

    def getFront(self) -> int:
        return -1 if self.isEmpty() else self.head.val

    def getRear(self) -> int:
        return -1 if self.isEmpty() else self.tail.val

    def isEmpty(self) -> bool:
        return self.size == 0

    def isFull(self) -> bool:
        return self.size == self.capacity
```

```C++ [sol2-C++]
struct DLinkListNode {
    int val;
    DLinkListNode *prev, *next;
    DLinkListNode(int _val): val(_val), prev(nullptr), next(nullptr) {

    }
};

class MyCircularDeque {
private:
    DLinkListNode *head, *tail;
    int capacity;
    int size;

public:
    MyCircularDeque(int k): capacity(k), size(0), head(nullptr), tail(nullptr) {
        
    }

    bool insertFront(int value) {
        if (size == capacity) {
            return false;
        }
        DLinkListNode *node = new DLinkListNode(value);
        if (size == 0) {
            head = tail = node;
        } else {
            node->next = head;
            head->prev = node;
            head = node;
        }
        size++;
        return true;
    }

    bool insertLast(int value) {
        if (size == capacity) {
            return false;
        }
        DLinkListNode *node = new DLinkListNode(value);
        if (size == 0) {
            head = tail = node;
        } else {
            tail->next = node;
            node->prev = tail;
            tail = node;
        }
        size++;
        return true;
    }

    bool deleteFront() {
        if (size == 0) {
            return false;
        }
        DLinkListNode *node = head;
        head = head->next;
        if (head) {
            head->prev = nullptr;
        }
        delete node;
        size--;
        return true;
    }

    bool deleteLast() {
        if (size == 0) {
            return false;
        }
        DLinkListNode *node = tail;
        tail = tail->prev;
        if (tail) {
            tail->next = nullptr;
        }
        delete node;
        size--;
        return true;
    }

    int getFront() {
        if (size == 0) {
            return -1;
        }
        return head->val;
    }

    int getRear() {
        if (size == 0) {
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
class MyCircularDeque {
    private class DLinkListNode {
        int val;
        DLinkListNode prev, next;

        DLinkListNode(int val) {
            this.val = val;
        }
    }

    private DLinkListNode head, tail;
    private int capacity;
    private int size;

    public MyCircularDeque(int k) {
        capacity = k;
        size = 0;
    }

    public boolean insertFront(int value) {
        if (size == capacity) {
            return false;
        }
        DLinkListNode node = new DLinkListNode(value);
        if (size == 0) {
            head = tail = node;
        } else {
            node.next = head;
            head.prev = node;
            head = node;
        }
        size++;
        return true;
    }

    public boolean insertLast(int value) {
        if (size == capacity) {
            return false;
        }
        DLinkListNode node = new DLinkListNode(value);
        if (size == 0) {
            head = tail = node;
        } else {
            tail.next = node;
            node.prev = tail;
            tail = node;
        }
        size++;
        return true;
    }

    public boolean deleteFront() {
        if (size == 0) {
            return false;
        }
        head = head.next;
        if (head != null) {
            head.prev = null;
        }
        size--;
        return true;
    }

    public boolean deleteLast() {
        if (size == 0) {
            return false;
        }
        tail = tail.prev;
        if (tail != null) {
            tail.next = null;
        }
        size--;
        return true;
    }

    public int getFront() {
        if (size == 0) {
            return -1;
        }
        return head.val;
    }

    public int getRear() {
        if (size == 0) {
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
public class MyCircularDeque {
    private class DLinkListNode {
        public int val;
        public DLinkListNode prev, next;

        public DLinkListNode(int val) {
            this.val = val;
        }
    }

    private DLinkListNode head, tail;
    private int capacity;
    private int size;

    public MyCircularDeque(int k) {
        capacity = k;
        size = 0;
    }

    public bool InsertFront(int value) {
        if (size == capacity) {
            return false;
        }
        DLinkListNode node = new DLinkListNode(value);
        if (size == 0) {
            head = tail = node;
        } else {
            node.next = head;
            head.prev = node;
            head = node;
        }
        size++;
        return true;
    }

    public bool InsertLast(int value) {
        if (size == capacity) {
            return false;
        }
        DLinkListNode node = new DLinkListNode(value);
        if (size == 0) {
            head = tail = node;
        } else {
            tail.next = node;
            node.prev = tail;
            tail = node;
        }
        size++;
        return true;
    }

    public bool DeleteFront() {
        if (size == 0) {
            return false;
        }
        head = head.next;
        if (head != null) {
            head.prev = null;
        }
        size--;
        return true;
    }

    public bool DeleteLast() {
        if (size == 0) {
            return false;
        }
        tail = tail.prev;
        if (tail != null) {
            tail.next = null;
        }
        size--;
        return true;
    }

    public int GetFront() {
        if (size == 0) {
            return -1;
        }
        return head.val;
    }

    public int GetRear() {
        if (size == 0) {
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
typedef struct DLinkListNode {
    int val;
    struct DLinkListNode *prev, *next;
} DLinkListNode;

typedef struct {
    DLinkListNode *head, *tail;
    int capacity;
    int size;
} MyCircularDeque;

DLinkListNode * dLinkListNodeCreat(int val) {
    DLinkListNode *obj = (DLinkListNode *)malloc(sizeof(DLinkListNode));
    obj->val = val;
    obj->prev = NULL;
    obj->next = NULL;
    return obj;
} 

MyCircularDeque* myCircularDequeCreate(int k) {
    MyCircularDeque *obj = (MyCircularDeque *)malloc(sizeof(MyCircularDeque));
    obj->capacity = k;
    obj->size = 0;
    obj->head = obj->tail = NULL;
    return obj;
}

bool myCircularDequeInsertFront(MyCircularDeque* obj, int value) {
    if (obj->size == obj->capacity) {
        return false;
    }
    DLinkListNode *node = dLinkListNodeCreat(value);
    if (obj->size == 0) {
        obj->head = obj->tail = node;
    } else {
        node->next = obj->head;
        obj->head->prev = node;
        obj->head = node;
    }
    obj->size++;
    return true;
}

bool myCircularDequeInsertLast(MyCircularDeque* obj, int value) {
    if (obj->size == obj->capacity) {
        return false;
    }
    DLinkListNode *node = dLinkListNodeCreat(value);
    if (obj->size == 0) {
        obj->head = obj->tail = node;
    } else {
        obj->tail->next = node;
        node->prev = obj->tail;
        obj->tail = node;
    }
    obj->size++;
    return true;
}

bool myCircularDequeDeleteFront(MyCircularDeque* obj) {
    if (obj->size == 0) {
        return false;
    }
    DLinkListNode *node = obj->head;
    obj->head = obj->head->next;
    if (obj->head) {
        obj->head->prev = NULL;
    }
    free(node);
    obj->size--;
    return true;
}

bool myCircularDequeDeleteLast(MyCircularDeque* obj) {
    if (obj->size == 0) {
        return false;
    }
    DLinkListNode *node = obj->tail;
    obj->tail = obj->tail->prev;
    if (obj->tail) {
        obj->tail->next = NULL;
    }
    free(node);
    obj->size--;
    return true;
}

int myCircularDequeGetFront(MyCircularDeque* obj) {
    if (obj->size == 0) {
        return -1;
    }
    return obj->head->val;
}

int myCircularDequeGetRear(MyCircularDeque* obj) {
    if (obj->size == 0) {
        return -1;
    }
    return obj->tail->val;
}

bool myCircularDequeIsEmpty(MyCircularDeque* obj) {
    return obj->size == 0;
}

bool myCircularDequeIsFull(MyCircularDeque* obj) {
    return obj->size == obj->capacity;
}

void myCircularDequeFree(MyCircularDeque* obj) {
    for (DLinkListNode *curr = obj->head; curr;) {
        DLinkListNode *node = curr;
        curr = curr->next;
        free(node);
    }
    free(obj);
}
```

```go [sol2-Golang]
type node struct {
    prev, next *node
    val        int
}

type MyCircularDeque struct {
    head, tail     *node
    capacity, size int
}

func Constructor(k int) MyCircularDeque {
    return MyCircularDeque{capacity: k}
}

func (q *MyCircularDeque) InsertFront(value int) bool {
    if q.IsFull() {
        return false
    }
    node := &node{val: value}
    if q.IsEmpty() {
        q.head = node
        q.tail = node
    } else {
        node.next = q.head
        q.head.prev = node
        q.head = node
    }
    q.size++
    return true
}

func (q *MyCircularDeque) InsertLast(value int) bool {
    if q.IsFull() {
        return false
    }
    node := &node{val: value}
    if q.IsEmpty() {
        q.head = node
        q.tail = node
    } else {
        q.tail.next = node
        node.prev = q.tail
        q.tail = node
    }
    q.size++
    return true
}

func (q *MyCircularDeque) DeleteFront() bool {
    if q.IsEmpty() {
        return false
    }
    q.head = q.head.next
    if q.head != nil {
        q.head.prev = nil
    }
    q.size--
    return true
}

func (q *MyCircularDeque) DeleteLast() bool {
    if q.IsEmpty() {
        return false
    }
    q.tail = q.tail.prev
    if q.tail != nil {
        q.tail.next = nil
    }
    q.size--
    return true
}

func (q MyCircularDeque) GetFront() int {
    if q.IsEmpty() {
        return -1
    }
    return q.head.val
}

func (q MyCircularDeque) GetRear() int {
    if q.IsEmpty() {
        return -1
    }
    return q.tail.val
}

func (q MyCircularDeque) IsEmpty() bool {
    return q.size == 0
}

func (q MyCircularDeque) IsFull() bool {
    return q.size == q.capacity
}
```

**复杂度分析**

- 时间复杂度：初始化和每项操作的时间复杂度均为 $O(1)$。

- 空间复杂度：$O(k)$，其中 $k$ 为给定的队列元素数目。
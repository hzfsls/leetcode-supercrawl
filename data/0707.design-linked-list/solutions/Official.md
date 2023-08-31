## [707.设计链表 中文官方题解](https://leetcode.cn/problems/design-linked-list/solutions/100000/she-ji-lian-biao-by-leetcode-solution-abix)
#### 方法一：单向链表

**思路**

实现单向链表，即每个节点仅存储本身的值和后继节点。除此之外，我们还需要一个哨兵（sentinel）节点作为头节点，和一个 $\textit{size}$ 参数保存有效节点数。如下图所示。
![img](https://assets.leetcode-cn.com/solution-static/707/1_1.png)

初始化时，只需创建头节点 $\textit{head}$ 和 $\textit{size}$ 即可。

实现 $\textit{get}(\textit{index})$ 时，先判断有效性，再通过循环来找到对应的节点的值。如下图所示。
![img](https://assets.leetcode-cn.com/solution-static/707/1_4.png)

实现 $\textit{addAtIndex}(\textit{index, val})$ 时，如果 $\textit{index}$ 是有效值，则需要找到原来下标为 $\textit{index}$ 的节点的前驱节点 $\textit{pred}$，并创建新节点 $\textit{to\_add}$，将$\textit{to\_add}$ 的后继节点设为 $\textit{pred}$ 的后继节点，将 $\textit{pred}$ 的后继节点更新为 $\textit{to\_add}$，这样就将 $\textit{to\_add}$ 插入到了链表中。最后需要更新 $\textit{size}$。这样的操作对于 $\textit{index} = 0$ 也成立，如以下两张图所示。
![img](https://assets.leetcode-cn.com/solution-static/707/1_2.png)
![img](https://assets.leetcode-cn.com/solution-static/707/1_3.png)

实现 $\textit{addAtHead}(\textit{val})$ 和 $\textit{addAtTail}(\textit{val})$ 时，可以借助 $\textit{addAtIndex}(\textit{index, val})$ 来实现。

实现 $\textit{deleteAtIndex}(\textit{index})$，先判断参数有效性。然后找到下标为 $\textit{index}$ 的节点的前驱节点 $\textit{pred}$，通过将 $\textit{pred}$ 的后继节点更新为 $\textit{pred}$ 的后继节点的后继节点，来达到删除节点的效果。同时也要更新 $\textit{size}$。如下图所示。
![img](https://assets.leetcode-cn.com/solution-static/707/1_5.png)

**代码**

```Python [sol1-Python3]
class ListNode:

    def __init__(self, val):
        self.val = val
        self.next = None


class MyLinkedList:

    def __init__(self):
        self.size = 0
        self.head = ListNode(0)


    def get(self, index: int) -> int:
        if index < 0 or index >= self.size:
            return -1
        cur = self.head
        for _ in range(index + 1):
            cur = cur.next
        return cur.val


    def addAtHead(self, val: int) -> None:
        self.addAtIndex(0, val)


    def addAtTail(self, val: int) -> None:
        self.addAtIndex(self.size, val)


    def addAtIndex(self, index: int, val: int) -> None:
        if index > self.size:
            return
        index = max(0, index)
        self.size += 1
        pred = self.head
        for _ in range(index):
            pred = pred.next
        to_add = ListNode(val)
        to_add.next = pred.next
        pred.next = to_add

    def deleteAtIndex(self, index: int) -> None:
        if index < 0 or index >= self.size:
            return
        self.size -= 1
        pred = self.head
        for _ in range(index):
            pred = pred.next
        pred.next = pred.next.next
```

```Java [sol1-Java]
class MyLinkedList {
    int size;
    ListNode head;

    public MyLinkedList() {
        size = 0;
        head = new ListNode(0);
    }

    public int get(int index) {
        if (index < 0 || index >= size) {
            return -1;
        }
        ListNode cur = head;
        for (int i = 0; i <= index; i++) {
            cur = cur.next;
        }
        return cur.val;
    }

    public void addAtHead(int val) {
        addAtIndex(0, val);
    }

    public void addAtTail(int val) {
        addAtIndex(size, val);
    }

    public void addAtIndex(int index, int val) {
        if (index > size) {
            return;
        }
        index = Math.max(0, index);
        size++;
        ListNode pred = head;
        for (int i = 0; i < index; i++) {
            pred = pred.next;
        }
        ListNode toAdd = new ListNode(val);
        toAdd.next = pred.next;
        pred.next = toAdd;
    }

    public void deleteAtIndex(int index) {
        if (index < 0 || index >= size) {
            return;
        }
        size--;
        ListNode pred = head;
        for (int i = 0; i < index; i++) {
            pred = pred.next;
        }
        pred.next = pred.next.next;
    }
}

class ListNode {
    int val;
    ListNode next;

    public ListNode(int val) {
        this.val = val;
    }
}
```

```C# [sol1-C#]
public class MyLinkedList {
    int size;
    ListNode head;

    public MyLinkedList() {
        size = 0;
        head = new ListNode(0);
    }

    public int Get(int index) {
         if (index < 0 || index >= size) {
            return -1;
        }
        ListNode cur = head;
        for (int i = 0; i <= index; i++) {
            cur = cur.next;
        }
        return cur.val;
    }

    public void AddAtHead(int val) {
        AddAtIndex(0, val);
    }

    public void AddAtTail(int val) {
        AddAtIndex(size, val);
    }

    public void AddAtIndex(int index, int val) {
        if (index > size) {
            return;
        }
        index = Math.Max(0, index);
        size++;
        ListNode pred = head;
        for (int i = 0; i < index; i++) {
            pred = pred.next;
        }
        ListNode toAdd = new ListNode(val);
        toAdd.next = pred.next;
        pred.next = toAdd;
    }

    public void DeleteAtIndex(int index) {
        if (index < 0 || index >= size) {
            return;
        }
        size--;
        ListNode pred = head;
        for (int i = 0; i < index; i++) {
            pred = pred.next;
        }
        pred.next = pred.next.next;
    }
}

class ListNode {
    public int val;
    public ListNode next;

    public ListNode(int val) {
        this.val = val;
    }
}
```

```C++ [sol1-C++]
class MyLinkedList {
public:
    MyLinkedList() {
        this->size = 0;
        this->head = new ListNode(0);
    }
    
    int get(int index) {
        if (index < 0 || index >= size) {
            return -1;
        }
        ListNode *cur = head;
        for (int i = 0; i <= index; i++) {
            cur = cur->next;
        }
        return cur->val;
    }
    
    void addAtHead(int val) {
        addAtIndex(0, val);
    }
    
    void addAtTail(int val) {
        addAtIndex(size, val);
    }
    
    void addAtIndex(int index, int val) {
        if (index > size) {
            return;
        }
        index = max(0, index);
        size++;
        ListNode *pred = head;
        for (int i = 0; i < index; i++) {
            pred = pred->next;
        }
        ListNode *toAdd = new ListNode(val);
        toAdd->next = pred->next;
        pred->next = toAdd;
    }
    
    void deleteAtIndex(int index) {
        if (index < 0 || index >= size) {
            return;
        }
        size--;
        ListNode *pred = head;
        for (int i = 0; i < index; i++) {
            pred = pred->next;
        }
        ListNode *p = pred->next;
        pred->next = pred->next->next;
        delete p;
    }
private:
    int size;
    ListNode *head;
};
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

typedef struct {
    struct ListNode *head;
    int size;
} MyLinkedList;

struct ListNode *ListNodeCreat(int val) {
    struct ListNode * node = (struct ListNode *)malloc(sizeof(struct ListNode));
    node->val = val;
    node->next = NULL;
    return node;
}

MyLinkedList* myLinkedListCreate() {
    MyLinkedList * obj = (MyLinkedList *)malloc(sizeof(MyLinkedList));
    obj->head = ListNodeCreat(0);
    obj->size = 0;
    return obj;
}

int myLinkedListGet(MyLinkedList* obj, int index) {
    if (index < 0 || index >= obj->size) {
        return -1;
    }
    struct ListNode *cur = obj->head;
    for (int i = 0; i <= index; i++) {
        cur = cur->next;
    }
    return cur->val;
}

void myLinkedListAddAtIndex(MyLinkedList* obj, int index, int val) {
    if (index > obj->size) {
        return;
    }
    index = MAX(0, index);
    obj->size++;
    struct ListNode *pred = obj->head;
    for (int i = 0; i < index; i++) {
        pred = pred->next;
    }
    struct ListNode *toAdd = ListNodeCreat(val);
    toAdd->next = pred->next;
    pred->next = toAdd;
}

void myLinkedListAddAtHead(MyLinkedList* obj, int val) {
    myLinkedListAddAtIndex(obj, 0, val);
}

void myLinkedListAddAtTail(MyLinkedList* obj, int val) {
    myLinkedListAddAtIndex(obj, obj->size, val);
}

void myLinkedListDeleteAtIndex(MyLinkedList* obj, int index) {
    if (index < 0 || index >= obj->size) {
        return;
    }
    obj->size--;
    struct ListNode *pred = obj->head;
    for (int i = 0; i < index; i++) {
        pred = pred->next;
    }
    struct ListNode *p = pred->next;
    pred->next = pred->next->next;
    free(p);
}

void myLinkedListFree(MyLinkedList* obj) {
    struct ListNode *cur = NULL, *tmp = NULL;
    for (cur = obj->head; cur;) {
        tmp = cur;
        cur = cur->next;
        free(tmp);
    }
    free(obj);
}
```

```JavaScript [sol1-JavaScript]
var MyLinkedList = function() {
    this.size = 0;
    this.head = new ListNode(0);
};

MyLinkedList.prototype.get = function(index) {
    if (index < 0 || index >= this.size) {
        return -1;
    }
    let cur = this.head;
    for (let i = 0; i <= index; i++) {
        cur = cur.next;
    }
    return cur.val;
};

MyLinkedList.prototype.addAtHead = function(val) {
    this.addAtIndex(0, val);
};

MyLinkedList.prototype.addAtTail = function(val) {
    this.addAtIndex(this.size, val);
};

MyLinkedList.prototype.addAtIndex = function(index, val) {
    if (index > this.size) {
        return;
    }
    index = Math.max(0, index);
    this.size++;
    let pred = this.head;
    for (let i = 0; i < index; i++) {
        pred = pred.next;
    }
    let toAdd = new ListNode(val);
    toAdd.next = pred.next;
    pred.next = toAdd;
};

MyLinkedList.prototype.deleteAtIndex = function(index) {
    if (index < 0 || index >= this.size) {
        return;
    }
    this.size--;
    let pred = this.head;
    for (let i = 0; i < index; i++) {
        pred = pred.next;
    }
    pred.next = pred.next.next;
};

function ListNode(val, next) {
    this.val = (val===undefined ? 0 : val)
    this.next = (next===undefined ? null : next)
}
```

```go [sol1-Golang]
type MyLinkedList struct {
    head *ListNode
    size int
}

func Constructor() MyLinkedList {
    return MyLinkedList{&ListNode{}, 0}
}

func (l *MyLinkedList) Get(index int) int {
    if index < 0 || index >= l.size {
        return -1
    }
    cur := l.head
    for i := 0; i <= index; i++ {
        cur = cur.Next
    }
    return cur.Val
}

func (l *MyLinkedList) AddAtHead(val int) {
    l.AddAtIndex(0, val)
}

func (l *MyLinkedList) AddAtTail(val int) {
    l.AddAtIndex(l.size, val)
}

func (l *MyLinkedList) AddAtIndex(index, val int) {
    if index > l.size {
        return
    }
    index = max(index, 0)
    l.size++
    pred := l.head
    for i := 0; i < index; i++ {
        pred = pred.Next
    }
    toAdd := &ListNode{val, pred.Next}
    pred.Next = toAdd
}

func (l *MyLinkedList) DeleteAtIndex(index int) {
    if index < 0 || index >= l.size {
        return
    }
    l.size--
    pred := l.head
    for i := 0; i < index; i++ {
        pred = pred.Next
    }
    pred.Next = pred.Next.Next
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：初始化消耗 $O(1)$，$\textit{get}$ 消耗 $O(\textit{index})$，$\textit{addAtHead}$ 消耗 $O(1)$，$\textit{addAtTail}$ 消耗 $O(n)$，其中 $n$ 为链表当前长度，即 $\textit{addAtHead}$，$\textit{addAtTail}$ 和 $\textit{addAtIndex}$ 已调用次数之和，$\textit{addAtIndex}$ 消耗 $O(\textit{index})$。

- 空间复杂度：所有函数的单次调用空间复杂度均为 $O(1)$，总体空间复杂度为 $O(n)$，其中 $n$ 为 $\textit{addAtHead}$，$\textit{addAtTail}$ 和 $\textit{addAtIndex}$ 调用次数之和。

#### 方法二：双向链表

**思路**

实现双向链表，即每个节点要存储本身的值，后继节点和前驱节点。除此之外，需要一个哨兵节点作为头节点 $\textit{head}$ 和一个哨兵节点作为尾节点 $\textit{tail}$。仍需要一个 $\textit{size}$ 参数保存有效节点数。如下图所示。
![img](https://assets.leetcode-cn.com/solution-static/707/1_6.png)

初始化时，只需创建头节点 $\textit{head}$ 和 $\textit{size}$ 即可。

实现 $\textit{get}(\textit{index})$ 时，先判断有效性，然后再比较从 $\textit{head}$ 还是 $\textit{tail}$ 来遍历会比较快找到目标，然后进行遍历。如下图所示。
![img](https://assets.leetcode-cn.com/solution-static/707/1_7.png)

实现 $\textit{addAtIndex}(\textit{index, val})$ 时，如果 $\textit{index}$ 是有效值，则需要找到原来下标为 $\textit{index}$ 的节点 $\textit{succ}$ 和前驱节点 $\textit{pred}$，并创建新节点 $\textit{to\_add}$，再通过各自 $\textit{prev}$ 和 $\textit{next}$ 变量的更新来增加 $\textit{to\_add}$。最后需要更新 $\textit{size}$。如以下两张图所示。
![img](https://assets.leetcode-cn.com/solution-static/707/1_8.png)

实现 $\textit{addAtHead}(\textit{val})$ 和 $\textit{addAtTail}(\textit{val})$ 时，可以借助 $\textit{addAtIndex}(\textit{index, val})$ 来实现。

实现 $\textit{deleteAtIndex}(\textit{index})$，先判断参数有效性。然后找到下标为 $\textit{index}$ 的节点的前驱节点 $\textit{pred}$ 和后继节点 $\textit{succ}$，再通过各自 $\textit{prev}$ 和 $\textit{next}$ 变量的更新来删除节点，来达到删除节点的效果。同时也要更新 $\textit{size}$。如下图所示。
![img](https://assets.leetcode-cn.com/solution-static/707/1_9.png)

**代码**

```Python [sol2-Python3]
class ListNode:

    def __init__(self, x):
        self.val = x
        self.next = None
        self.prev = None


class MyLinkedList:

    def __init__(self):
        self.size = 0
        self.head, self.tail = ListNode(0), ListNode(0) 
        self.head.next = self.tail
        self.tail.prev = self.head


    def get(self, index: int) -> int:
        if index < 0 or index >= self.size:
            return -1
        if index + 1 < self.size - index:
            curr = self.head
            for _ in range(index + 1):
                curr = curr.next
        else:
            curr = self.tail
            for _ in range(self.size - index):
                curr = curr.prev
        return curr.val


    def addAtHead(self, val: int) -> None:
        self.addAtIndex(0, val)


    def addAtTail(self, val: int) -> None:
        self.addAtIndex(self.size, val)


    def addAtIndex(self, index: int, val: int) -> None:
        if index > self.size:
            return
        index = max(0, index)
        if index < self.size - index:
            pred = self.head
            for _ in range(index):
                pred = pred.next
            succ = pred.next
        else:
            succ = self.tail
            for _ in range(self.size - index):
                succ = succ.prev
            pred = succ.prev
        self.size += 1
        to_add = ListNode(val)
        to_add.prev = pred
        to_add.next = succ
        pred.next = to_add
        succ.prev = to_add


    def deleteAtIndex(self, index: int) -> None:
        if index < 0 or index >= self.size:
            return
        if index < self.size - index:
            pred = self.head
            for _ in range(index):
                pred = pred.next
            succ = pred.next.next
        else:
            succ = self.tail
            for _ in range(self.size - index - 1):
                succ = succ.prev
            pred = succ.prev.prev
        self.size -= 1
        pred.next = succ
        succ.prev = pred
```

```Java [sol2-Java]
class MyLinkedList {
    int size;
    ListNode head;
    ListNode tail;

    public MyLinkedList() {
        size = 0;
        head = new ListNode(0);
        tail = new ListNode(0);
        head.next = tail;
        tail.prev = head;
    }

    public int get(int index) {
        if (index < 0 || index >= size) {
            return -1;
        }
        ListNode curr;
        if (index + 1 < size - index) {
            curr = head;
            for (int i = 0; i <= index; i++) {
                curr = curr.next;
            }
        } else {
            curr = tail;
            for (int i = 0; i < size - index; i++) {
                curr = curr.prev;
            }
        }
        return curr.val;
    }

    public void addAtHead(int val) {
        addAtIndex(0, val);
    }

    public void addAtTail(int val) {
        addAtIndex(size, val);
    }

    public void addAtIndex(int index, int val) {
        if (index > size) {
            return;
        }
        index = Math.max(0, index);
        ListNode pred, succ;
        if (index < size - index) {
            pred = head;
            for (int i = 0; i < index; i++) {
                pred = pred.next;
            }
            succ = pred.next;
        } else {
            succ = tail;
            for (int i = 0; i < size - index; i++) {
                succ = succ.prev;
            }
            pred = succ.prev;
        }
        size++;
        ListNode toAdd = new ListNode(val);
        toAdd.prev = pred;
        toAdd.next = succ;
        pred.next = toAdd;
        succ.prev = toAdd;
    }

    public void deleteAtIndex(int index) {
        if (index < 0 || index >= size) {
            return;
        }
        ListNode pred, succ;
        if (index < size - index) {
            pred = head;
            for (int i = 0; i < index; i++) {
                pred = pred.next;
            }
            succ = pred.next.next;
        } else {
            succ = tail;
            for (int i = 0; i < size - index - 1; i++) {
                succ = succ.prev;
            }
            pred = succ.prev.prev;
        }
        size--;
        pred.next = succ;
        succ.prev = pred;
    }
}

class ListNode {
    int val;
    ListNode next;
    ListNode prev;

    public ListNode(int val) {
        this.val = val;
    }
}
```

```C# [sol2-C#]
public class MyLinkedList {
    int size;
    ListNode head;
    ListNode tail;

    public MyLinkedList() {
        size = 0;
        head = new ListNode(0);
        tail = new ListNode(0);
        head.next = tail;
        tail.prev = head;
    }

    public int Get(int index) {
        if (index < 0 || index >= size) {
            return -1;
        }
        ListNode curr;
        if (index + 1 < size - index) {
            curr = head;
            for (int i = 0; i <= index; i++) {
                curr = curr.next;
            }
        } else {
            curr = tail;
            for (int i = 0; i < size - index; i++) {
                curr = curr.prev;
            }
        }
        return curr.val;
    }

    public void AddAtHead(int val) {
        AddAtIndex(0, val);
    }

    public void AddAtTail(int val) {
        AddAtIndex(size, val);
    }

    public void AddAtIndex(int index, int val) {
        if (index > size) {
            return;
        }
        index = Math.Max(0, index);
        ListNode pred, succ;
        if (index < size - index) {
            pred = head;
            for (int i = 0; i < index; i++) {
                pred = pred.next;
            }
            succ = pred.next;
        } else {
            succ = tail;
            for (int i = 0; i < size - index; i++) {
                succ = succ.prev;
            }
            pred = succ.prev;
        }
        size++;
        ListNode toAdd = new ListNode(val);
        toAdd.prev = pred;
        toAdd.next = succ;
        pred.next = toAdd;
        succ.prev = toAdd;
    }

    public void DeleteAtIndex(int index) {
        if (index < 0 || index >= size) {
            return;
        }
        ListNode pred, succ;
        if (index < size - index) {
            pred = head;
            for (int i = 0; i < index; i++) {
                pred = pred.next;
            }
            succ = pred.next.next;
        } else {
            succ = tail;
            for (int i = 0; i < size - index - 1; i++) {
                succ = succ.prev;
            }
            pred = succ.prev.prev;
        }
        size--;
        pred.next = succ;
        succ.prev = pred;
    }
}

class ListNode {
    public int val;
    public ListNode next;
    public ListNode prev;

    public ListNode(int val) {
        this.val = val;
    }
}
```

```C++ [sol2-C++]
struct DLinkListNode {
    int val;
    DLinkListNode *prev, *next;
    DLinkListNode(int _val) : val(_val), prev(nullptr), next(nullptr) {}
};

class MyLinkedList {
public:
    MyLinkedList() {
        this->size = 0;
        this->head = new DLinkListNode(0);
        this->tail = new DLinkListNode(0);
        head->next = tail;
        tail->prev = head;
    }
    
    int get(int index) {
        if (index < 0 || index >= size) {
            return -1;
        }
        DLinkListNode *curr;
        if (index + 1 < size - index) {
            curr = head;
            for (int i = 0; i <= index; i++) {
                curr = curr->next;
            }
        } else {
            curr = tail;
            for (int i = 0; i < size - index; i++) {
                curr = curr->prev;
            }
        }
        return curr->val;
    }
    
    void addAtHead(int val) {
        addAtIndex(0, val);
    }
    
    void addAtTail(int val) {
        addAtIndex(size, val);
    }
    
    void addAtIndex(int index, int val) {
        if (index > size) {
            return;
        }
        index = max(0, index);
        DLinkListNode *pred, *succ;
        if (index < size - index) {
            pred = head;
            for (int i = 0; i < index; i++) {
                pred = pred->next;
            }
            succ = pred->next;
        } else {
            succ = tail;
            for (int i = 0; i < size - index; i++) {
                succ = succ->prev;
            }
            pred = succ->prev;
        }
        size++;
        DLinkListNode *toAdd = new DLinkListNode(val);
        toAdd->prev = pred;
        toAdd->next = succ;
        pred->next = toAdd;
        succ->prev = toAdd;
    }
    
    void deleteAtIndex(int index) {
        if (index < 0 || index >= size) {
            return;
        }
        DLinkListNode *pred, *succ;
        if (index < size - index) {
            pred = head;
            for (int i = 0; i < index; i++) {
                pred = pred->next;
            }
            succ = pred->next->next;
        } else {
            succ = tail;
            for (int i = 0; i < size - index - 1; i++) {
                succ = succ->prev;
            }
            pred = succ->prev->prev;
        }
        size--;
        DLinkListNode *p = pred->next;
        pred->next = succ;
        succ->prev = pred;
        delete p;
    }
private:
    int size;
    DLinkListNode *head;
    DLinkListNode *tail;
};
```

```C [sol2-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

typedef struct DLinkListNode {
    int val;
    struct DLinkListNode *prev, *next;
} DLinkListNode;

typedef struct {
    struct DLinkListNode *head, *tail;
    int size;
} MyLinkedList;

DLinkListNode *dLinkListNodeCreat(int val) {
    DLinkListNode * node = (DLinkListNode *)malloc(sizeof(struct DLinkListNode));
    node->val = val;
    node->prev = NULL;
    node->next = NULL;
    return node;
}

MyLinkedList* myLinkedListCreate() {
    MyLinkedList * obj = (MyLinkedList *)malloc(sizeof(MyLinkedList));
    obj->size = 0;
    obj->head = dLinkListNodeCreat(0);
    obj->tail = dLinkListNodeCreat(0);
    obj->head->next = obj->tail;
    obj->tail->prev = obj->head; 
    return obj;
}

int myLinkedListGet(MyLinkedList* obj, int index) {
    if (index < 0 || index >= obj->size) {
        return -1;
    }
    DLinkListNode *curr;
    if (index + 1 < obj->size - index) {
        curr = obj->head;
        for (int i = 0; i <= index; i++) {
            curr = curr->next;
        }
    } else {
        curr = obj->tail;
        for (int i = 0; i < obj->size - index; i++) {
            curr = curr->prev;
        }
    }
    return curr->val;
}

void myLinkedListAddAtIndex(MyLinkedList* obj, int index, int val) {
    if (index > obj->size) {
        return;
    }
    index = MAX(0, index);
    DLinkListNode *pred, *succ;
    if (index < obj->size - index) {
        pred = obj->head;
        for (int i = 0; i < index; i++) {
            pred = pred->next;
        }
        succ = pred->next;
    } else {
        succ = obj->tail;
        for (int i = 0; i < obj->size - index; i++) {
            succ = succ->prev;
        }
        pred = succ->prev;
    }
    obj->size++;
    DLinkListNode *toAdd = dLinkListNodeCreat(val);
    toAdd->prev = pred;
    toAdd->next = succ;
    pred->next = toAdd;
    succ->prev = toAdd;
}

void myLinkedListAddAtHead(MyLinkedList* obj, int val) {
    myLinkedListAddAtIndex(obj, 0, val);
}

void myLinkedListAddAtTail(MyLinkedList* obj, int val) {
    myLinkedListAddAtIndex(obj, obj->size, val);
}

void myLinkedListDeleteAtIndex(MyLinkedList* obj, int index) {
    if (index < 0 || index >= obj->size) {
        return;
    }
    DLinkListNode *pred, *succ;
    if (index < obj->size - index) {
        pred = obj->head;
        for (int i = 0; i < index; i++) {
            pred = pred->next;
        }
        succ = pred->next->next;
    } else {
        succ = obj->tail;
        for (int i = 0; i < obj->size - index - 1; i++) {
            succ = succ->prev;
        }
        pred = succ->prev->prev;
    }
    obj->size--;
    DLinkListNode *p = pred->next;
    pred->next = succ;
    succ->prev = pred;
    free(p);
}

void myLinkedListFree(MyLinkedList* obj) {
    struct DLinkListNode *cur = NULL, *tmp = NULL;
    for (cur = obj->head; cur;) {
        tmp = cur;
        cur = cur->next;
        free(tmp);
    }
    free(obj);
}
```

```JavaScript [sol2-JavaScript]
var MyLinkedList = function() {
    this.size = 0;
    this.head = new ListNode(0);
    this.tail = new ListNode(0);
    this.head.next = this.tail;
    this.tail.prev = this.head;
};

MyLinkedList.prototype.get = function(index) {
    if (index < 0 || index >= this.size) {
        return -1;
    }
    let curr;
    if (index + 1 < this.size - index) {
        curr = this.head;
        for (let i = 0; i <= index; i++) {
            curr = curr.next;
        }
    } else {
        curr = this.tail;
        for (let i = 0; i < this.size - index; i++) {
            curr = curr.prev;
        }
    }
    return curr.val;
};

MyLinkedList.prototype.addAtHead = function(val) {
    this.addAtIndex(0, val);
};

MyLinkedList.prototype.addAtTail = function(val) {
    this.addAtIndex(this.size, val);
};

MyLinkedList.prototype.addAtIndex = function(index, val) {
    if (index > this.size) {
        return;
    }
    index = Math.max(0, index);
    let pred, succ;
    if (index < this.size - index) {
        pred = this.head;
        for (let i = 0; i < index; i++) {
            pred = pred.next;
        }
        succ = pred.next;
    } else {
        succ = this.tail;
        for (let i = 0; i < this.size - index; i++) {
            succ = succ.prev;
        }
        pred = succ.prev;
    }
    this.size++;
    const toAdd = new ListNode(val);
    toAdd.prev = pred;
    toAdd.next = succ;
    pred.next = toAdd;
    succ.prev = toAdd;
};

MyLinkedList.prototype.deleteAtIndex = function(index) {
    if (index < 0 || index >= this.size) {
        return;
    }
    let pred, succ;
    if (index < this.size - index) {
        pred = this.head;
        for (let i = 0; i < index; i++) {
            pred = pred.next;
        }
        succ = pred.next.next;
    } else {
        succ = this.tail;
        for (let i = 0; i < this.size - index - 1; i++) {
            succ = succ.prev;
        }
        pred = succ.prev.prev;
    }
    this.size--;
    pred.next = succ;
    succ.prev = pred;
};

function ListNode(val, next, prev) {
    this.val = (val===undefined ? 0 : val)
    this.next = (next===undefined ? null : next)
    this.prev = (prev===undefined ? null : next)
}
```

```go [sol2-Golang]
type node struct {
    val        int
    next, prev *node
}

type MyLinkedList struct {
    head, tail *node
    size       int
}

func Constructor() MyLinkedList {
    head := &node{}
    tail := &node{}
    head.next = tail
    tail.prev = head
    return MyLinkedList{head, tail, 0}
}

func (l *MyLinkedList) Get(index int) int {
    if index < 0 || index >= l.size {
        return -1
    }
    var curr *node
    if index+1 < l.size-index {
        curr = l.head
        for i := 0; i <= index; i++ {
            curr = curr.next
        }
    } else {
        curr = l.tail
        for i := 0; i < l.size-index; i++ {
            curr = curr.prev
        }
    }
    return curr.val
}

func (l *MyLinkedList) AddAtHead(val int) {
    l.AddAtIndex(0, val)
}

func (l *MyLinkedList) AddAtTail(val int) {
    l.AddAtIndex(l.size, val)
}

func (l *MyLinkedList) AddAtIndex(index, val int) {
    if index > l.size {
        return
    }
    index = max(0, index)
    var pred, succ *node
    if index < l.size-index {
        pred = l.head
        for i := 0; i < index; i++ {
            pred = pred.next
        }
        succ = pred.next
    } else {
        succ = l.tail
        for i := 0; i < l.size-index; i++ {
            succ = succ.prev
        }
        pred = succ.prev
    }
    l.size++
    toAdd := &node{val, succ, pred}
    pred.next = toAdd
    succ.prev = toAdd
}

func (l *MyLinkedList) DeleteAtIndex(index int) {
    if index < 0 || index >= l.size {
        return
    }
    var pred, succ *node
    if index < l.size-index {
        pred = l.head
        for i := 0; i < index; i++ {
            pred = pred.next
        }
        succ = pred.next.next
    } else {
        succ = l.tail
        for i := 0; i < l.size-index-1; i++ {
            succ = succ.prev
        }
        pred = succ.prev.prev
    }
    l.size--
    pred.next = succ
    succ.prev = pred
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：初始化消耗 $O(1)$，$\textit{get}$ 消耗 $O(\textit{index})$，$\textit{addAtHead}$ 消耗 $O(1)$，$\textit{addAtTail}$ 消耗 $O(1)$，$\textit{addAtIndex}$ 消耗 $O(\textit{index})$。

- 空间复杂度：所有函数单次调用的空间复杂度均为 $O(1)$，总体空间复杂度为 $O(n)$，其中 $n$ 为 $\textit{addAtHead}$，$\textit{addAtTail}$ 和 $\textit{addAtIndex}$ 调用次数之和。
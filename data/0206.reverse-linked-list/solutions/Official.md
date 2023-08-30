#### 方法一：迭代

假设链表为 $1 \rightarrow 2 \rightarrow 3 \rightarrow \varnothing$，我们想要把它改成 $\varnothing \leftarrow 1 \leftarrow 2 \leftarrow 3$。

在遍历链表时，将当前节点的 $\textit{next}$ 指针改为指向前一个节点。由于节点没有引用其前一个节点，因此必须事先存储其前一个节点。在更改引用之前，还需要存储后一个节点。最后返回新的头引用。

```Java [sol1-Java]
class Solution {
    public ListNode reverseList(ListNode head) {
        ListNode prev = null;
        ListNode curr = head;
        while (curr != null) {
            ListNode next = curr.next;
            curr.next = prev;
            prev = curr;
            curr = next;
        }
        return prev;
    }
}
```

```JavaScript [sol1-JavaScript]
var reverseList = function(head) {
    let prev = null;
    let curr = head;
    while (curr) {
        const next = curr.next;
        curr.next = prev;
        prev = curr;
        curr = next;
    }
    return prev;
};
```

```go [sol1-Golang]
func reverseList(head *ListNode) *ListNode {
    var prev *ListNode
    curr := head
    for curr != nil {
        next := curr.Next
        curr.Next = prev
        prev = curr
        curr = next
    }
    return prev
}
```

```C++ [sol1-C++]
class Solution {
public:
    ListNode* reverseList(ListNode* head) {
        ListNode* prev = nullptr;
        ListNode* curr = head;
        while (curr) {
            ListNode* next = curr->next;
            curr->next = prev;
            prev = curr;
            curr = next;
        }
        return prev;
    }
};
```

```C [sol1-C]
struct ListNode* reverseList(struct ListNode* head) {
    struct ListNode* prev = NULL;
    struct ListNode* curr = head;
    while (curr) {
        struct ListNode* next = curr->next;
        curr->next = prev;
        prev = curr;
        curr = next;
    }
    return prev;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是链表的长度。需要遍历链表一次。

- 空间复杂度：$O(1)$。

#### 方法二：递归

递归版本稍微复杂一些，其关键在于反向工作。假设链表的其余部分已经被反转，现在应该如何反转它前面的部分？

假设链表为：
$$n_1\rightarrow \ldots \rightarrow n_{k-1} \rightarrow n_k \rightarrow n_{k+1} \rightarrow \ldots \rightarrow n_m \rightarrow \varnothing$$

若从节点 $n_{k+1}$ 到 $n_m$ 已经被反转，而我们正处于 $n_k$。

$$n_1\rightarrow \ldots \rightarrow n_{k-1} \rightarrow n_k \rightarrow n_{k+1} \leftarrow \ldots \leftarrow n_m$$

我们希望 $n_{k+1}$ 的下一个节点指向 $n_k$。

所以，$n_k.\textit{next}.\textit{next} = n_k$。

需要注意的是 $n_1$ 的下一个节点必须指向 $\varnothing$。如果忽略了这一点，链表中可能会产生环。

```Java [sol2-Java]
class Solution {
    public ListNode reverseList(ListNode head) {
        if (head == null || head.next == null) {
            return head;
        }
        ListNode newHead = reverseList(head.next);
        head.next.next = head;
        head.next = null;
        return newHead;
    }
}
```

```JavaScript [sol2-JavaScript]
var reverseList = function(head) {
    if (head == null || head.next == null) {
        return head;
    }
    const newHead = reverseList(head.next);
    head.next.next = head;
    head.next = null;
    return newHead;
};
```

```go [sol2-Golang]
func reverseList(head *ListNode) *ListNode {
    if head == nil || head.Next == nil {
        return head
    }
    newHead := reverseList(head.Next)
    head.Next.Next = head
    head.Next = nil
    return newHead
}
```

```C++ [sol2-C++]
class Solution {
public:
    ListNode* reverseList(ListNode* head) {
        if (!head || !head->next) {
            return head;
        }
        ListNode* newHead = reverseList(head->next);
        head->next->next = head;
        head->next = nullptr;
        return newHead;
    }
};
```

```C [sol2-C]
struct ListNode* reverseList(struct ListNode* head) {
    if (head == NULL || head->next == NULL) {
        return head;
    }
    struct ListNode* newHead = reverseList(head->next);
    head->next->next = head;
    head->next = NULL;
    return newHead;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是链表的长度。需要对链表的每个节点进行反转操作。

- 空间复杂度：$O(n)$，其中 $n$ 是链表的长度。空间复杂度主要取决于递归调用的栈空间，最多为 $n$ 层。

>本题为后端高频面试题，收录于《[热招技术岗上岸指南](https://leetcode.cn/leetbook/detail/2021-fall-recruitment/)》


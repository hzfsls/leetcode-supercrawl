## [86.分隔链表 中文官方题解](https://leetcode.cn/problems/partition-list/solutions/100000/fen-ge-lian-biao-by-leetcode-solution-7ade)
#### 方法一：模拟

直观来说我们只需维护两个链表 $\textit{small}$ 和 $\textit{large}$ 即可，$\textit{small}$ 链表按顺序存储所有小于 $x$ 的节点，$\textit{large}$ 链表按顺序存储所有大于等于 $x$ 的节点。遍历完原链表后，我们只要将 $\textit{small}$ 链表尾节点指向 $\textit{large}$ 链表的头节点即能完成对链表的分隔。

为了实现上述思路，我们设 $\textit{smallHead}$ 和 $\textit{largeHead}$ 分别为两个链表的哑节点，即它们的 $\textit{next}$ 指针指向链表的头节点，这样做的目的是为了更方便地处理头节点为空的边界条件。同时设 $\textit{small}$ 和 $\textit{large}$ 节点指向当前链表的末尾节点。开始时 $\textit{smallHead}=\textit{small},\textit{largeHead}=\textit{large}$。随后，从前往后遍历链表，判断当前链表的节点值是否小于 $x$，如果小于就将 $\textit{small}$ 的 $\textit{next}$ 指针指向该节点，否则将 $\textit{large}$ 的 $\textit{next}$ 指针指向该节点。

遍历结束后，我们将 $\textit{large}$ 的 $\textit{next}$ 指针置空，这是因为当前节点复用的是原链表的节点，而其 $\textit{next}$ 指针可能指向一个小于 $x$ 的节点，我们需要切断这个引用。同时将 $\textit{small}$ 的 $\textit{next}$ 指针指向 $\textit{largeHead}$ 的 $\textit{next}$ 指针指向的节点，即真正意义上的 $\textit{large}$ 链表的头节点。最后返回 $\textit{smallHead}$ 的 $\textit{next}$ 指针即为我们要求的答案。

```C++ [sol1-C++]
class Solution {
public:
    ListNode* partition(ListNode* head, int x) {
        ListNode* small = new ListNode(0);
        ListNode* smallHead = small;
        ListNode* large = new ListNode(0);
        ListNode* largeHead = large;
        while (head != nullptr) {
            if (head->val < x) {
                small->next = head;
                small = small->next;
            } else {
                large->next = head;
                large = large->next;
            }
            head = head->next;
        }
        large->next = nullptr;
        small->next = largeHead->next;
        return smallHead->next;
    }
};
```

```Java [sol1-Java]
class Solution {
    public ListNode partition(ListNode head, int x) {
        ListNode small = new ListNode(0);
        ListNode smallHead = small;
        ListNode large = new ListNode(0);
        ListNode largeHead = large;
        while (head != null) {
            if (head.val < x) {
                small.next = head;
                small = small.next;
            } else {
                large.next = head;
                large = large.next;
            }
            head = head.next;
        }
        large.next = null;
        small.next = largeHead.next;
        return smallHead.next;
    }
}
```

```JavaScript [sol1-JavaScript]
var partition = function(head, x) {
    let small = new ListNode(0);
    const smallHead = small;
    let large = new ListNode(0);
    const largeHead = large;
    while (head !== null) {
        if (head.val < x) {
            small.next = head;
            small = small.next;
        } else {
            large.next = head;
            large = large.next;
        }
        head = head.next;
    }
    large.next = null;
    small.next = largeHead.next;
    return smallHead.next;
};
```

```go [sol1-Golang]
func partition(head *ListNode, x int) *ListNode {
    small := &ListNode{}
    smallHead := small
    large := &ListNode{}
    largeHead := large
    for head != nil {
        if head.Val < x {
            small.Next = head
            small = small.Next
        } else {
            large.Next = head
            large = large.Next
        }
        head = head.Next
    }
    large.Next = nil
    small.Next = largeHead.Next
    return smallHead.Next
}
```

```C [sol1-C]
struct ListNode* partition(struct ListNode* head, int x) {
    struct ListNode* small = malloc(sizeof(struct ListNode));
    struct ListNode* smallHead = small;
    struct ListNode* large = malloc(sizeof(struct ListNode));
    struct ListNode* largeHead = large;
    while (head != NULL) {
        if (head->val < x) {
            small->next = head;
            small = small->next;
        } else {
            large->next = head;
            large = large->next;
        }
        head = head->next;
    }
    large->next = NULL;
    small->next = largeHead->next;
    return smallHead->next;
}
```

**复杂度分析**

- 时间复杂度: $O(n)$，其中 $n$ 是原链表的长度。我们对该链表进行了一次遍历。

- 空间复杂度: $O(1)$。
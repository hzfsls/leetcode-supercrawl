## [328.奇偶链表 中文官方题解](https://leetcode.cn/problems/odd-even-linked-list/solutions/100000/qi-ou-lian-biao-by-leetcode-solution)
#### 方法一：分离节点后合并

如果链表为空，则直接返回链表。

对于原始链表，每个节点都是奇数节点或偶数节点。头节点是奇数节点，头节点的后一个节点是偶数节点，相邻节点的奇偶性不同。因此可以将奇数节点和偶数节点分离成奇数链表和偶数链表，然后将偶数链表连接在奇数链表之后，合并后的链表即为结果链表。

原始链表的头节点 `head` 也是奇数链表的头节点以及结果链表的头节点，`head` 的后一个节点是偶数链表的头节点。令 `evenHead = head.next`，则 `evenHead` 是偶数链表的头节点。

维护两个指针 `odd` 和 `even` 分别指向奇数节点和偶数节点，初始时 `odd = head`，`even = evenHead`。通过迭代的方式将奇数节点和偶数节点分离成两个链表，每一步首先更新奇数节点，然后更新偶数节点。

- 更新奇数节点时，奇数节点的后一个节点需要指向偶数节点的后一个节点，因此令 `odd.next = even.next`，然后令 `odd = odd.next`，此时 `odd` 变成 `even` 的后一个节点。

- 更新偶数节点时，偶数节点的后一个节点需要指向奇数节点的后一个节点，因此令 `even.next = odd.next`，然后令 `even = even.next`，此时 `even` 变成 `odd` 的后一个节点。

在上述操作之后，即完成了对一个奇数节点和一个偶数节点的分离。重复上述操作，直到全部节点分离完毕。全部节点分离完毕的条件是 `even` 为空节点或者 `even.next` 为空节点，此时 `odd` 指向最后一个奇数节点（即奇数链表的最后一个节点）。

最后令 `odd.next = evenHead`，将偶数链表连接在奇数链表之后，即完成了奇数链表和偶数链表的合并，结果链表的头节点仍然是 `head`。

![fig1](https://assets.leetcode-cn.com/solution-static/328/1.png)

```Java [sol1-Java]
class Solution {
    public ListNode oddEvenList(ListNode head) {
        if (head == null) {
            return head;
        }
        ListNode evenHead = head.next;
        ListNode odd = head, even = evenHead;
        while (even != null && even.next != null) {
            odd.next = even.next;
            odd = odd.next;
            even.next = odd.next;
            even = even.next;
        }
        odd.next = evenHead;
        return head;
    }
}
```

```JavaScript [sol1-JavaScript]
var oddEvenList = function(head) {
    if (head === null) {
        return head;
    }
    let evenHead = head.next;
    let odd = head, even = evenHead;
    while (even !== null && even.next !== null) {
        odd.next = even.next;
        odd = odd.next;
        even.next = odd.next;
        even = even.next;
    }
    odd.next = evenHead;
    return head;
};
```

```C++ [sol1-C++]
class Solution {
public:
    ListNode* oddEvenList(ListNode* head) {
        if (head == nullptr) {
            return head;
        }
        ListNode* evenHead = head->next;
        ListNode* odd = head;
        ListNode* even = evenHead;
        while (even != nullptr && even->next != nullptr) {
            odd->next = even->next;
            odd = odd->next;
            even->next = odd->next;
            even = even->next;
        }
        odd->next = evenHead;
        return head;
    }
};
```

```Golang [sol1-Golang]
func oddEvenList(head *ListNode) *ListNode {
    if head == nil {
        return head
    }
    evenHead := head.Next
    odd := head
    even := evenHead
    for even != nil && even.Next != nil {
        odd.Next = even.Next
        odd = odd.Next
        even.Next = odd.Next
        even = even.Next
    }
    odd.Next = evenHead
    return head
}
```

```Python [sol1-Python3]
class Solution:
    def oddEvenList(self, head: ListNode) -> ListNode:
        if not head:
            return head
        
        evenHead = head.next
        odd, even = head, evenHead
        while even and even.next:
            odd.next = even.next
            odd = odd.next
            even.next = odd.next
            even = even.next
        odd.next = evenHead
        return head
```

```C [sol1-C]
struct ListNode* oddEvenList(struct ListNode* head) {
    if (head == NULL) {
        return head;
    }
    struct ListNode* evenHead = head->next;
    struct ListNode* odd = head;
    struct ListNode* even = evenHead;
    while (even != NULL && even->next != NULL) {
        odd->next = even->next;
        odd = odd->next;
        even->next = odd->next;
        even = even->next;
    }
    odd->next = evenHead;
    return head;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是链表的节点数。需要遍历链表中的每个节点，并更新指针。

- 空间复杂度：$O(1)$。只需要维护有限的指针。
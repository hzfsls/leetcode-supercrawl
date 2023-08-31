## [83.删除排序链表中的重复元素 中文官方题解](https://leetcode.cn/problems/remove-duplicates-from-sorted-list/solutions/100000/shan-chu-pai-xu-lian-biao-zhong-de-zhong-49v5)
#### 方法一：一次遍历

**思路与算法**

由于给定的链表是排好序的，因此**重复的元素在链表中出现的位置是连续的**，因此我们只需要对链表进行一次遍历，就可以删除重复的元素。

具体地，我们从指针 $\textit{cur}$ 指向链表的头节点，随后开始对链表进行遍历。如果当前 $\textit{cur}$ 与 $\textit{cur.next}$ 对应的元素相同，那么我们就将 $\textit{cur.next}$ 从链表中移除；否则说明链表中已经不存在其它与 $\textit{cur}$ 对应的元素相同的节点，因此可以将 $\textit{cur}$ 指向 $\textit{cur.next}$。

当遍历完整个链表之后，我们返回链表的头节点即可。

**细节**

当我们遍历到链表的最后一个节点时，$\textit{cur.next}$ 为空节点，如果不加以判断，访问 $\textit{cur.next}$ 对应的元素会产生运行错误。因此我们只需要遍历到链表的最后一个节点，而不需要遍历完整个链表。

**代码**

注意下面 $\texttt{C++}$ 代码中并没有释放被删除的链表节点的空间。如果在面试中遇到本题，读者需要针对这一细节与面试官进行沟通。

```C++ [sol1-C++]
class Solution {
public:
    ListNode* deleteDuplicates(ListNode* head) {
        if (!head) {
            return head;
        }

        ListNode* cur = head;
        while (cur->next) {
            if (cur->val == cur->next->val) {
                cur->next = cur->next->next;
            }
            else {
                cur = cur->next;
            }
        }

        return head;
    }
};
```

```Java [sol1-Java]
class Solution {
    public ListNode deleteDuplicates(ListNode head) {
        if (head == null) {
            return head;
        }

        ListNode cur = head;
        while (cur.next != null) {
            if (cur.val == cur.next.val) {
                cur.next = cur.next.next;
            } else {
                cur = cur.next;
            }
        }

        return head;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def deleteDuplicates(self, head: ListNode) -> ListNode:
        if not head:
            return head

        cur = head
        while cur.next:
            if cur.val == cur.next.val:
                cur.next = cur.next.next
            else:
                cur = cur.next

        return head
```

```JavaScript [sol1-JavaScript]
var deleteDuplicates = function(head) {
    if (!head) {
        return head;
    }

    let cur = head;
    while (cur.next) {
        if (cur.val === cur.next.val) {
            cur.next = cur.next.next;
        } else {
            cur = cur.next;
        }
    }
    return head;
};
```

```go [sol1-Golang]
func deleteDuplicates(head *ListNode) *ListNode {
    if head == nil {
        return nil
    }

    cur := head
    for cur.Next != nil {
        if cur.Val == cur.Next.Val {
            cur.Next = cur.Next.Next
        } else {
            cur = cur.Next
        }
    }

    return head
}
```

```C [sol1-C]
struct ListNode* deleteDuplicates(struct ListNode* head) {
    if (!head) {
        return head;
    }

    struct ListNode* cur = head;
    while (cur->next) {
        if (cur->val == cur->next->val) {
            cur->next = cur->next->next;
        } else {
            cur = cur->next;
        }
    }

    return head;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是链表的长度。

- 空间复杂度：$O(1)$。
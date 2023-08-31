## [2095.删除链表的中间节点 中文官方题解](https://leetcode.cn/problems/delete-the-middle-node-of-a-linked-list/solutions/100000/shan-chu-lian-biao-de-zhong-jian-jie-dia-yvv7)

#### 方法一：快慢指针

**思路与算法**

由于链表不支持随机访问，因此常见的找出链表中间节点的方法是使用快慢指针：即我们使用两个指针 $\textit{fast}$ 和 $\textit{slow}$ 对链表进行遍历，其中快指针 $\textit{fast}$ 每次遍历两个元素，慢指针 $\textit{slow}$ 每次遍历一个元素。这样在快指针遍历完链表时，慢指针就恰好在链表的中间位置。

在本题中，我们还需要删除链表的中间节点，因此除了慢指针 $\textit{slow}$ 外，我们再使用一个指针 $\textit{pre}$ 时刻指向 $\textit{slow}$ 的前一个节点。这样我们就可以在遍历结束后，通过 $\textit{pre}$ 将 $\textit{slow}$ 删除了。

**细节**

当链表中只有一个节点时，我们会删除这个节点并返回空链表。但这个节点不存在前一个节点，即 $\textit{pre}$ 是没有意义的，因此对于这种情况，我们可以在遍历前进行特殊判断，直接返回空指针作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    ListNode* deleteMiddle(ListNode* head) {
        if (head->next == nullptr) {
            return nullptr;
        }
        
        ListNode* slow = head;
        ListNode* fast = head;
        ListNode* pre = nullptr;
        while (fast && fast->next) {
            fast = fast->next->next;
            pre = slow;
            slow = slow->next;
        }
        pre->next = pre->next->next;
        return head;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def deleteMiddle(self, head: Optional[ListNode]) -> Optional[ListNode]:
        if head.next is None:
            return None
        
        slow, fast, pre = head, head, None
        while fast and fast.next:
            fast = fast.next.next
            pre = slow
            slow = slow.next
        
        pre.next = pre.next.next
        return head
```

**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：$O(1)$。
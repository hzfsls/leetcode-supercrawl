#### 方法一：快慢指针 + 反转链表

**思路与算法**

我们首先使用快满指针找出后一半部分的起始节点。具体地，我们用慢指针 $\textit{slow}$ 指向 $\textit{head}$，快指针 $\textit{fast}$ 指向 $\textit{head}$ 的下一个节点。随后，我们每次将 $\textit{slow}$ 向后移动一个节点，同时 $\textit{fast}$ 向后移动两个节点。当 $\textit{fast}$ 到达链表的最后一个节点（即下一个节点是空节点）时：

- $\textit{slow}$ 刚好指向链表前一半部分的末尾节点；

- $\textit{slow}$ 的下一个节点即为链表后一半部分的起始节点。

随后，我们需要将链表的后一半部分进行反转。如果读者不知道如何实现这一步，可以参考[「206. 反转链表」的官方题解](https://leetcode-cn.com/problems/reverse-linked-list/solution/fan-zhuan-lian-biao-by-leetcode-solution-d1k2/)。当链表的后一半部分被反转后，原先我们需要求出的是第 $i$ 个节点和第 $n-1-i$ 的节点的和，此时就变成了求出第 $i$ 个节点和第 $i+n/2$ 个节点的和。

这样一来，我们就可以使用两个指针分别从「链表前一半部分的起始节点」和「链表后一半部分的起始节点」开始遍历。在遍历的过程中，我们计算两个指针指向节点的元素之和，并维护最大值即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int pairSum(ListNode* head) {
        ListNode* slow = head;
        ListNode* fast = head->next;
        while (fast->next) {
            slow = slow->next;
            fast = fast->next->next;
        }
        // 反转链表
        ListNode* last = slow->next;
        while (last->next) {
            ListNode* cur = last->next;
            last->next = cur->next;
            cur->next = slow->next;
            slow->next = cur;
        }
        int ans = 0;
        ListNode* x = head;
        ListNode* y = slow->next;
        while (y) {
            ans = max(ans, x->val + y->val);
            x = x->next;
            y = y->next;
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def pairSum(self, head: Optional[ListNode]) -> int:
        slow, fast = head, head.next
        while fast.next:
            slow = slow.next
            fast = fast.next.next
        
        # 反转链表
        last = slow.next
        while last.next:
            cur = last.next
            last.next = cur.next
            cur.next = slow.next
            slow.next = cur

        ans = 0
        x, y = head, slow.next
        while y:
            ans = max(ans, x.val + y.val)
            x, y = x.next, y.next
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：$O(1)$。
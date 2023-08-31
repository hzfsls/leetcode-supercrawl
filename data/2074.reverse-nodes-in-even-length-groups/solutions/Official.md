## [2074.反转偶数长度组的节点 中文官方题解](https://leetcode.cn/problems/reverse-nodes-in-even-length-groups/solutions/100000/fan-zhuan-ou-shu-chang-du-zu-de-jie-dian-owra)

#### 方法一：对每个组进行两次遍历

**思路与算法**

我们可以从链表的首节点开始进行遍历，并且使用一个计数器 $i$，它既表示当前遍历的组数，也表示当前的组最多能包含的节点个数。

记当前组的首节点为 $\textit{cur}$，其前驱节点为 $\textit{pre}$，那么我们可以当前组进行**最多两次**遍历：

- 第一次遍历时，我们的目的是获取当前组包含的节点个数。我们从 $\textit{cur}$ 开始，遍历最多不超过 $i$ 个节点，并记录遍历到的节点个数，记为 $\textit{len}$。

- 第二次遍历时，我们的目的是反转当前组包含的节点。如果 $\textit{len}$ 为偶数，那么我们就需要反转。具体的做法时，我们从 $\textit{cur}$ 的后继节点开始遍历，遍历恰好 $\textit{len} - 1$ 个节点，每遍历到一个节点，就将该节点「插入」到 $\textit{pre}$ 的后面，这样就能实现对链表的反转，读者也可以参考[「206. 反转链表」的官方题解](https://leetcode-cn.com/problems/reverse-linked-list/solution/fan-zhuan-lian-biao-by-leetcode-solution-d1k2/)。

- 第三次遍历时，我们的目的是将 $\textit{cur}$ 和 $\textit{pre}$ 移动到下一个组的首节点以及其前驱节点。如果我们执行了第二次遍历（$\textit{len}$ 为偶数），那么 $\textit{cur}$ 就从组的首节点变成了尾节点，即 $\textit{cur}$ 的后继节点就是下一个组的首节点，而 $\textit{cur}$ 本身就是下一个组的 $\textit{pre}$。如果我们没有执行第二次遍历，那么就需要将 $\textit{pre}$ 和 $\textit{cur}$ 分别向后移动 $\textit{len}$ 个节点。

可以发现，如果 $\textit{len}$ 为偶数，那么只需要执行第一和二次遍历，如果 $\textit{len}$ 为奇数，那么只需要执行第一和第三次遍历。因此每一个组最多会被遍历两次。

当 $\textit{cur}$ 移动到空节点时，说明我们处理完了整个链表，此时就完成了遍历。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    ListNode* reverseEvenLengthGroups(ListNode* head) {
        int i = 0;
        ListNode* cur = head;
        ListNode* pre = nullptr;
        while (cur) {
            ++i;
            ListNode* it = cur;
            int len = 0;
            for (; len < i && it; ++len) {
                it = it->next;
            }
            
            if (len & 1) {
                for (int j = 1; j <= len; ++j) {
                    tie(pre, cur) = tuple{cur, cur->next};
                }
            }
            else {
                for (int j = 1; j < len; ++j) {
                    tie(pre->next, cur->next, cur->next->next) = tuple{cur->next, cur->next->next, pre->next};
                }
                tie(pre, cur) = tuple{cur, cur->next};
            }
        }
        return head;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def reverseEvenLengthGroups(self, head: Optional[ListNode]) -> Optional[ListNode]:
        i = 0
        cur, pre = head, None
        while cur:
            i += 1
            it = cur
            length = 0
            while length < i and it:
                length += 1
                it = it.next
            
            if length & 1:
                for j in range(length):
                    pre, cur = cur, cur.next
            else:
                for j in range(length - 1):
                    pre.next, cur.next.next, cur.next = cur.next, pre.next, cur.next.next
                pre, cur = cur, cur.next

        return head
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是链表的长度。

- 空间复杂度：$O(1)$。
## [2181.合并零之间的节点 中文官方题解](https://leetcode.cn/problems/merge-nodes-in-between-zeros/solutions/100000/he-bing-ling-zhi-jian-de-jie-dian-by-lee-zo9b)
#### 方法一：模拟

**思路与算法**

我们从链表头节点 $\textit{head}$ 的下一个节点开始遍历，并使用一个变量 $\textit{total}$ 维护当前遍历到的节点的元素之和。

如果当前节点的值为 $0$，那么我们就新建一个值为 $\textit{total}$ 的节点，放在答案链表的尾部，并将 $\textit{total}$ 置零，否则我们将值累加进 $\textit{total}$ 中。

**细节**

为了方便维护答案，我们可以在遍历前新建一个伪头节点 $\textit{dummy}$，并在遍历完成之后返回 $\textit{dummy}$ 的下一个节点作为答案。

**代码**

下面给出的 $\texttt{C++}$ 代码中没有释放 $\textit{dummy}$ 节点的空间。如果在面试中遇到本题，需要和面试官进行沟通。

```C++ [sol1-C++]
class Solution {
public:
    ListNode* mergeNodes(ListNode* head) {
        ListNode* dummy = new ListNode();
        ListNode* tail = dummy;
        
        int total = 0;
        for (ListNode* cur = head->next; cur; cur = cur->next) {
            if (cur->val == 0) {
                ListNode* node = new ListNode(total);
                tail->next = node;
                tail = tail->next;
                total = 0;
            }
            else {
                total += cur->val;
            }
        }
        
        return dummy->next;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def mergeNodes(self, head: Optional[ListNode]) -> Optional[ListNode]:
        dummy = tail = ListNode()
        total = 0
        cur = head.next

        while cur:
            if cur.val == 0:
                node = ListNode(total)
                tail.next = node
                tail = tail.next
                total = 0
            else:
                total += cur.val
            
            cur = cur.next
        
        return dummy.next
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是给定链表的长度。

- 空间复杂度：$O(1)$。
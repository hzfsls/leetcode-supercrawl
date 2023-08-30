#### 方法一：拆分链表

题目要求将给定的链表分隔成 $k$ 个连续的部分。由于分隔成的每个部分的长度和原始链表的长度有关，因此需要首先遍历链表，得到链表的长度 $n$。

得到链表的长度 $n$ 之后，记 $\textit{quotient} = \Big\lfloor \dfrac{n}{k} \Big\rfloor$，$\textit{remainder} = n \bmod k$，则在分隔成的 $k$ 个部分中，前 $\textit{remainder}$ 个部分的长度各为 $\textit{quotient} + 1$，其余每个部分的长度各为 $\textit{quotient}$。

分隔链表时，从链表的头结点开始遍历，记当前结点为 $\textit{curr}$，对于每个部分，进行如下操作：

1. 将 $\textit{curr}$ 作为当前部分的头结点；

2. 计算当前部分的长度 $\textit{partSize}$；

3. 将 $\textit{curr}$ 向后移动 $\textit{partSize}$ 步，则 $\textit{curr}$ 为当前部分的尾结点；

4. 当 $\textit{curr}$ 到达当前部分的尾结点时，需要拆分 $\textit{curr}$ 和后面一个结点之间的连接关系，在拆分之前需要存储 $\textit{curr}$ 的后一个结点 $\textit{next}$；

5. 令 $\textit{curr}$ 的 $\textit{next}$ 指针指向 $\text{null}$，完成 $\textit{curr}$ 和 $\textit{next}$ 的拆分；

6. 将 $\textit{next}$ 赋值给 $\textit{curr}$。

完成上述操作之后，即得到分隔链表后的一个部分。重复上述操作，直到分隔出 $k$ 个部分，或者链表遍历结束，即 $\textit{curr}$ 指向 $\text{null}$。

```Java [sol1-Java]
class Solution {
    public ListNode[] splitListToParts(ListNode head, int k) {
        int n = 0;
        ListNode temp = head;
        while (temp != null) {
            n++;
            temp = temp.next;
        }
        int quotient = n / k, remainder = n % k;

        ListNode[] parts = new ListNode[k];
        ListNode curr = head;
        for (int i = 0; i < k && curr != null; i++) {
            parts[i] = curr;
            int partSize = quotient + (i < remainder ? 1 : 0);
            for (int j = 1; j < partSize; j++) {
                curr = curr.next;
            }
            ListNode next = curr.next;
            curr.next = null;
            curr = next;
        }
        return parts;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public ListNode[] SplitListToParts(ListNode head, int k) {
        int n = 0;
        ListNode temp = head;
        while (temp != null) {
            n++;
            temp = temp.next;
        }
        int quotient = n / k, remainder = n % k;

        ListNode[] parts = new ListNode[k];
        ListNode curr = head;
        for (int i = 0; i < k && curr != null; i++) {
            parts[i] = curr;
            int partSize = quotient + (i < remainder ? 1 : 0);
            for (int j = 1; j < partSize; j++) {
                curr = curr.next;
            }
            ListNode next = curr.next;
            curr.next = null;
            curr = next;
        }
        return parts;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def splitListToParts(self, head: ListNode, k: int) -> List[ListNode]:
        n = 0
        node = head
        while node:
            n += 1
            node = node.next
        quotient, remainder = n // k, n % k

        parts = [None for _ in range(k)]
        i, curr = 0, head
        while i < k and curr:
            parts[i] = curr
            part_size = quotient + (1 if i < remainder else 0)
            for _ in range(part_size - 1):
                curr = curr.next
            next = curr.next
            curr.next = None
            curr = next
            i += 1
        return parts
```

```JavaScript [sol1-JavaScript]
var splitListToParts = function(head, k) {
    let n = 0;
    let temp = head;
    while (temp != null) {
        n++;
        temp = temp.next;
    }
    let quotient = Math.floor(n / k), remainder = n % k;

    const parts = new Array(k).fill(null);
    let curr = head;
    for (let i = 0; i < k && curr != null; i++) {
        parts[i] = curr;
        let partSize = quotient + (i < remainder ? 1 : 0);
        for (let j = 1; j < partSize; j++) {
            curr = curr.next;
        }
        const next = curr.next;
        curr.next = null;
        curr = next;
    }
    return parts;
};
```

```go [sol1-Golang]
func splitListToParts(head *ListNode, k int) []*ListNode {
    n := 0
    for node := head; node != nil; node = node.Next {
        n++
    }
    quotient, remainder := n/k, n%k

    parts := make([]*ListNode, k)
    for i, curr := 0, head; i < k && curr != nil; i++ {
        parts[i] = curr
        partSize := quotient
        if i < remainder {
            partSize++
        }
        for j := 1; j < partSize; j++ {
            curr = curr.Next
        }
        curr, curr.Next = curr.Next, nil
    }
    return parts
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<ListNode*> splitListToParts(ListNode* head, int k) {
        int n = 0;
        ListNode *temp = head;
        while (temp != nullptr) {
            n++;
            temp = temp->next;
        }
        int quotient = n / k, remainder = n % k;

        vector<ListNode*> parts(k,nullptr);
        ListNode *curr = head;
        for (int i = 0; i < k && curr != nullptr; i++) {
            parts[i] = curr;
            int partSize = quotient + (i < remainder ? 1 : 0);
            for (int j = 1; j < partSize; j++) {
                curr = curr->next;
            }
            ListNode *next = curr->next;
            curr->next = nullptr;
            curr = next;
        }
        return parts;
    }
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是链表的长度。需要遍历链表两次，得到链表的长度和分隔链表。

- 空间复杂度：$O(1)$。只使用了常量的额外空间，注意返回值不计入空间复杂度。
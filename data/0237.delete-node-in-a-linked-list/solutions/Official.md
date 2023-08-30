#### 方法一：和下一个节点交换

删除链表中的节点的常见的方法是定位到待删除节点的上一个节点，修改上一个节点的 $\textit{next}$ 指针，使其指向待删除节点的下一个节点，即可完成删除操作。

这道题中，传入的参数 $\textit{node}$ 为要被删除的节点，无法定位到该节点的上一个节点。注意到要被删除的节点不是链表的末尾节点，因此 $\textit{node}.\textit{next}$ 不为空，可以通过对 $\textit{node}$ 和 $\textit{node}.\textit{next}$ 进行操作实现删除节点。

在给定节点 $\textit{node}$ 的情况下，可以通过修改 $\textit{node}$ 的 $\textit{next}$ 指针的指向，删除 $\textit{node}$ 的下一个节点。但是题目要求删除 $\textit{node}$，为了达到删除 $\textit{node}$ 的效果，只要在删除节点之前，将 $\textit{node}$ 的节点值修改为 $\textit{node}.\textit{next}$ 的节点值即可。

例如，给定链表 $4 \rightarrow 5 \rightarrow 1 \rightarrow 9$，要被删除的节点是 $5$，即链表中的第 $2$ 个节点。可以通过如下两步操作实现删除节点的操作。

1. 将第 $2$ 个节点的值修改为第 $3$ 个节点的值，即将节点 $5$ 的值修改为 $1$，此时链表如下：

$$
4 \rightarrow 1 \rightarrow 1 \rightarrow 9
$$

2. 删除第 $3$ 个节点，此时链表如下：

$$
4 \rightarrow 1 \rightarrow 9
$$

达到删除节点 $5$ 的效果。

```Java [sol1-Java]
class Solution {
    public void deleteNode(ListNode node) {
        node.val = node.next.val;
        node.next = node.next.next;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public void DeleteNode(ListNode node) {
        node.val = node.next.val;
        node.next = node.next.next;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    void deleteNode(ListNode* node) {
        node->val = node->next->val;
        node->next = node->next->next;
    }
};
```

```JavaScript [sol1-JavaScript]
var deleteNode = function(node) {
    node.val = node.next.val;
    node.next = node.next.next;
};
```

```TypeScript [sol1-TypeScript]
function deleteNode(root: ListNode | null): void {
    root.val = root.next.val;
    root.next = root.next.next;
};
```

```Python [sol1-Python3]
class Solution:
    def deleteNode(self, node):
        node.val = node.next.val
        node.next = node.next.next
```

```go [sol1-Golang]
func deleteNode(node *ListNode) {
    node.Val = node.Next.Val
    node.Next = node.Next.Next
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。
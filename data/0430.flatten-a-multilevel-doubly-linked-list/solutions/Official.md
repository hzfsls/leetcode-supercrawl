## [430.扁平化多级双向链表 中文官方题解](https://leetcode.cn/problems/flatten-a-multilevel-doubly-linked-list/solutions/100000/bian-ping-hua-duo-ji-shuang-xiang-lian-b-383h)
#### 方法一：深度优先搜索

**思路与算法**

当我们遍历到某个节点 $\textit{node}$ 时，如果它的 $\textit{child}$ 成员不为空，那么我们需要将 $\textit{child}$ 指向的链表结构进行扁平化，并且插入 $\textit{node}$ 与 $\textit{node}$ 的下一个节点之间。

因此，我们在遇到 $\textit{child}$ 成员不为空的节点时，就要先去处理 $\textit{child}$ 指向的链表结构，这就是一个「深度优先搜索」的过程。当我们完成了对 $\textit{child}$ 指向的链表结构的扁平化之后，就可以「回溯」到 $\textit{node}$ 节点。

为了能够将扁平化的链表插入 $\textit{node}$ 与 $\textit{node}$ 的下一个节点之间，我们需要知道扁平化的链表的最后一个节点 $\textit{last}$，随后进行如下的三步操作：

- 将 $\textit{node}$ 与 $\textit{node}$ 的下一个节点 $\textit{next}$ 断开：

- 将 $\textit{node}$ 与 $\textit{child}$ 相连；

- 将 $\textit{last}$ 与 $\textit{next}$ 相连。

这样一来，我们就可以将扁平化的链表成功地插入。

![fig1](https://assets.leetcode-cn.com/solution-static/430/1.png)

在深度优先搜索完成后，我们返回给定的首节点即可。

**细节**

需要注意的是，$\textit{node}$ 可能没有下一个节点，即 $\textit{next}$ 为空。此时，我们只需进行第二步操作。

此外，在插入扁平化的链表后，我们需要将 $\textit{node}$ 的 $\textit{child}$ 成员置为空。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    Node* flatten(Node* head) {
        function<Node*(Node*)> dfs = [&](Node* node) {
            Node* cur = node;
            // 记录链表的最后一个节点
            Node* last = nullptr;

            while (cur) {
                Node* next = cur->next;
                //  如果有子节点，那么首先处理子节点
                if (cur->child) {
                    Node* child_last = dfs(cur->child);

                    next = cur->next;
                    //  将 node 与 child 相连
                    cur->next = cur->child;
                    cur->child->prev = cur;

                    //  如果 next 不为空，就将 last 与 next 相连
                    if (next) {
                        child_last->next = next;
                        next->prev = child_last;
                    }

                    // 将 child 置为空
                    cur->child = nullptr;
                    last = child_last;
                }
                else {
                    last = cur;
                }
                cur = next;
            }
            return last;
        };

        dfs(head);
        return head;
    }
};
```

```Java [sol1-Java]
class Solution {
    public Node flatten(Node head) {
        dfs(head);
        return head;
    }

    public Node dfs(Node node) {
        Node cur = node;
        // 记录链表的最后一个节点
        Node last = null;

        while (cur != null) {
            Node next = cur.next;
            //  如果有子节点，那么首先处理子节点
            if (cur.child != null) {
                Node childLast = dfs(cur.child);

                next = cur.next;
                //  将 node 与 child 相连
                cur.next = cur.child;
                cur.child.prev = cur;

                //  如果 next 不为空，就将 last 与 next 相连
                if (next != null) {
                    childLast.next = next;
                    next.prev = childLast;
                }

                // 将 child 置为空
                cur.child = null;
                last = childLast;
            } else {
                last = cur;
            }
            cur = next;
        }
        return last;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public Node Flatten(Node head) {
        DFS(head);
        return head;
    }

    public Node DFS(Node node) {
        Node cur = node;
        // 记录链表的最后一个节点
        Node last = null;

        while (cur != null) {
            Node next = cur.next;
            //  如果有子节点，那么首先处理子节点
            if (cur.child != null) {
                Node childLast = DFS(cur.child);

                next = cur.next;
                //  将 node 与 child 相连
                cur.next = cur.child;
                cur.child.prev = cur;

                //  如果 next 不为空，就将 last 与 next 相连
                if (next != null) {
                    childLast.next = next;
                    next.prev = childLast;
                }

                // 将 child 置为空
                cur.child = null;
                last = childLast;
            } else {
                last = cur;
            }
            cur = next;
        }
        return last;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def flatten(self, head: "Node") -> "Node":
        def dfs(node: "Node") -> "Node":
            cur = node
            # 记录链表的最后一个节点
            last = None

            while cur:
                nxt = cur.next
                # 如果有子节点，那么首先处理子节点
                if cur.child:
                    child_last = dfs(cur.child)
                    
                    nxt = cur.next
                    # 将 node 与 child 相连
                    cur.next = cur.child
                    cur.child.prev = cur

                    # 如果 nxt 不为空，就将 last 与 nxt 相连
                    if nxt:
                        child_last.next = nxt
                        nxt.prev = child_last

                    # 将 child 置为空
                    cur.child = None
                    last = child_last
                else:
                    last = cur
                cur = nxt

            return last

        dfs(head)
        return head
```

```JavaScript [sol1-JavaScript]
var flatten = function(head) {
    const dfs = (node) => {
        let cur = node;
        // 记录链表的最后一个节点
        let last = null;

        while (cur) {
            let next = cur.next;
            //  如果有子节点，那么首先处理子节点
            if (cur.child) {
                const childLast = dfs(cur.child);

                next = cur.next;
                //  将 node 与 child 相连
                cur.next = cur.child;
                cur.child.prev = cur;

                //  如果 next 不为空，就将 last 与 next 相连
                if (next != null) {
                    childLast.next = next;
                    next.prev = childLast;
                }

                // 将 child 置为空
                cur.child = null;
                last = childLast;
            } else {
                last = cur;
            }
            cur = next;

        }
        return last;
    }

    dfs(head);
    return head;
};
```

```go [sol1-Golang]
func dfs(node *Node) (last *Node) {
    cur := node
    for cur != nil {
        next := cur.Next
        // 如果有子节点，那么首先处理子节点
        if cur.Child != nil {
            childLast := dfs(cur.Child)

            next = cur.Next
            // 将 node 与 child 相连
            cur.Next = cur.Child
            cur.Child.Prev = cur

            // 如果 next 不为空，就将 last 与 next 相连
            if next != nil {
                childLast.Next = next
                next.Prev = childLast
            }

            // 将 child 置为空
            cur.Child = nil
            last = childLast
        } else {
            last = cur
        }
        cur = next
    }
    return
}

func flatten(root *Node) *Node {
    dfs(root)
    return root
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是链表中的节点个数。

- 空间复杂度：$O(n)$。上述代码中使用的空间为深度优先搜索中的栈空间，如果给定的链表的「深度」为 $d$，那么空间复杂度为 $O(d)$。在最换情况下，链表中的每个节点的 $\textit{next}$ 都为空，且除了最后一个节点外，每个节点的 $\textit{child}$ 都不为空，整个链表的深度为 $n$，因此时间复杂度为 $O(n)$。
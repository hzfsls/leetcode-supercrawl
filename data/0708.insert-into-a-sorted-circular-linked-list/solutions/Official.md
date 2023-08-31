## [708.循环有序列表的插入 中文官方题解](https://leetcode.cn/problems/insert-into-a-sorted-circular-linked-list/solutions/100000/xun-huan-you-xu-lie-biao-de-cha-ru-by-le-tiow)

[TOC] 
 ## 解决方案 

---
 #### 方法 1：双指针
 **简述**
 虽然这个问题看起来简单，但实际上写一个能覆盖所有情况的解决方案并不容易。 
 >对于链表问题，我们常常可以采用**双指针迭代**的方法 ，使用两个指针替代性地遍历链表。 

 我们选择两个指针而不是一个指针的原因之一是，在单向链表中，我们没有前一个节点的引用，因此我们需要一个额外的指针指向前一个节点。

 >对于这个问题，我们使用两个指针，即 `prev` 和 `curr`，遍历循环列表。当我们找到一个适合插入新值的地方时，我们在 `prev` 和 `curr` 节点之间插入它。 

 ![image.png](https://pic.leetcode.cn/1692168046-nPZMuH-image.png){:width=600}

 **算法**
 首先，让我们定义下两指针迭代算法的框架，如下所述： 
 - 正如我们在直观理解中提到的，我们用两个指针（即 `prev` 和 `curr`）逐步遍历链表。循环的终止条件是我们回到了两个指针的起始点（即 `prev == head`） 
 - 在循环中，每一步，我们检查由两个指针限定的当前位置是否是插入新值的正确位置。 
 - 如果不是，我们将两个指针向前移动一步。 
 现在，这个问题的难点在于，在循环中整理出我们的算法应该处理的不同情况，然后设计一个 *简洁* 的逻辑来妥善处理。在这里，我们将其分为 _三个_ 通用情况。 
 >情况 1. 新节点的值位于当前列表的最小值和最大值之间。因此，它应该插入到列表中。 

 ![image.png](https://pic.leetcode.cn/1692168126-wuQhjw-image.png){:width=600}

 如上例所示，新值（`6`）位于列表的最小值（`1`）和最大值（`9`）之间。无论我们从哪里开始（在这个例子中我们从节点 `{3}` 开始），新节点最终都会被插入到节点 `{5}` 和 `{7}` 之间。 
 _找到满足 `{prev.val <= insertVal <= curr.val}` 约束的位置。_ 
 >情况 2. 新节点的值超出了当前列表的最小值和最大值，即小于最小值或大于最大值。在这两种情况下，新节点应该在 _tail_ 节点之后添加（即，列表中值最大的节点）。 

 以下是两个例子，输入列表与前一个例子相同。 

 ![image.png](https://pic.leetcode.cn/1692168173-LTGYoS-image.png){:width=600}

 ![image.png](https://pic.leetcode.cn/1692168209-QssRVw-image.png){:width=600}

 首先，我们应该找到 **tail** 节点的位置，通过查找相邻节点之间的降序顺序，即 `{prev.val > curr.val}` 条件，因为节点是按升序排序的，所以 tail 节点有最大的值。 
 然后，我们检查新值是否超过了 tail 和 head 节点的值，这些节点分别由 `prev` 和 `curr` 指针指向。 
 情况 2.1 对应于要插入的值大于或等于 tail 节点的值即 `{insertVal >= prev.val}` 的情况。 
 情况 2.2 对应于要插入的值小于或等于 head 节点的值的情况即 `{insertVal <= curr.val}`。 
 一旦我们找到 tail 和 head 节点，我们基本上通过在 tail 和 head 节点之间插入值，即在 `prev` 和 `curr` 指针之间，来 **_扩展_** 原始列表，这与情况 1 中的操作相同。 
 >情况 3. 最后，有一种情况不属于以上两种情况。这是列表包含统一值的情况。 

 尽管问题描述中没有明确说明，但我们的排序列表可以包含一些重复的值。在极端情况下，整个列表只有一个唯一的值。 

 ![image.png](https://pic.leetcode.cn/1692168248-ZZrFxw-image.png){:width=600}

 在这种情况下，我们会遍历整个列表并回到起点。 
 _接下来的操作就是在列表中的任何节点后添加新节点，不管要插入的值是多少。_ 既然我们已经回到了起点，我们也可以在起点之后添加新节点（我们的入口节点）。 
 注意，我们不能跳过迭代，因为我们必须遍历列表才能确定我们的列表是否包含一个唯一的值。 
 >上述三种情况涵盖了我们在迭代循环中和之后可能遇到的场景。然而，还有一个小的 **边界** 案例我们还需要处理，即我们有一个 **空** 列表。对于这个问题，我们可以在循环开始前很容易地处理。 

 ```Java [sol1-Java]
class Solution {
  public Node insert(Node head, int insertVal) {
    if (head == null) {
      Node newNode = new Node(insertVal, null);
      newNode.next = newNode;
      return newNode;
    }

    Node prev = head;
    Node curr = head.next;
    boolean toInsert = false;

    do {
      if (prev.val <= insertVal && insertVal <= curr.val) {
        // Case 1).
        toInsert = true;
      } else if (prev.val > curr.val) {
        // Case 2).
        if (insertVal >= prev.val || insertVal <= curr.val)
          toInsert = true;
      }

      if (toInsert) {
        prev.next = new Node(insertVal, curr);
        return head;
      }

      prev = curr;
      curr = curr.next;
    } while (prev != head);

    // Case 3).
    prev.next = new Node(insertVal, curr);
    return head;
  }
}
 ```

```Python [sol1-Python]
class Solution:
    def insert(self, head: 'Node', insertVal: int) -> 'Node':

        if head == None:
            newNode = Node(insertVal, None)
            newNode.next = newNode
            return newNode
 
        prev, curr = head, head.next
        toInsert = False

        while True:
            
            if prev.val <= insertVal <= curr.val:
                # Case #1.
                toInsert = True
            elif prev.val > curr.val:
                # Case #2. 我们定位尾部元素‘prev’的位置指向尾部
                # 例. 最大的元素！
                if insertVal >= prev.val or insertVal <= curr.val:
                    toInsert = True

            if toInsert:
                prev.next = Node(insertVal, curr)
                # 任务完成
                return head

            prev, curr = curr, curr.next
            # 循环条件
            if prev == head:
                break
        # Case #3.
        # 未在循环中插入节点
        prev.next = Node(insertVal, curr)
        return head
```

```C# [sol1-C#]
public class Solution {
    public Node Insert(Node head, int insertVal) {
        Node node = new Node(insertVal);
        if (head == null) {
            node.next = node;
            return node;
        }
        if (head.next == head) {
            head.next = node;
            node.next = head;
            return head;
        }
        Node curr = head, next = head.next;
        while (next != head) {
            if (insertVal >= curr.val && insertVal <= next.val) {
                break;
            }
            if (curr.val > next.val) {
                if (insertVal > curr.val || insertVal < next.val) {
                    break;
                }
            }
            curr = curr.next;
            next = next.next;
        }
        curr.next = node;
        node.next = next;
        return head;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    Node* insert(Node* head, int insertVal) {
        Node *node = new Node(insertVal);
        if (head == nullptr) {
            node->next = node;
            return node;
        }
        if (head->next == head) {
            head->next = node;
            node->next = head;
            return head;
        }
        Node *curr = head, *next = head->next;
        while (next != head) {
            if (insertVal >= curr->val && insertVal <= next->val) {
                break;
            }
            if (curr->val > next->val) {
                if (insertVal > curr->val || insertVal < next->val) {
                    break;
                }
            }
            curr = curr->next;
            next = next->next;
        }
        curr->next = node;
        node->next = next;
        return head;
    }
};
```

```C [sol1-C]
struct Node* insert(struct Node* head, int insertVal) {
    struct Node *node = (struct Node*)malloc(sizeof(struct Node));
    node->val = insertVal;
    node->next = NULL;
    if (head == NULL) {
        node->next = node;
        return node;
    }
    if (head->next == head) {
        head->next = node;
        node->next = head;
        return head;
    }
    struct Node *curr = head, *next = head->next;
    while (next != head) {
        if (insertVal >= curr->val && insertVal <= next->val) {
            break;
        }
        if (curr->val > next->val) {
            if (insertVal > curr->val || insertVal < next->val) {
                break;
            }
        }
        curr = curr->next;
        next = next->next;
    }
    curr->next = node;
    node->next = next;
    return head;
}
```

```JavaScript [sol1-JavaScript]
var insert = function(head, insertVal) {
    const node = new Node(insertVal);
    if (!head) {
        node.next = node;
        return node;
    }
    if (head.next === head) {
        head.next = node;
        node.next = head;
        return head;
    }
    let curr = head, next = head.next;
    while (next !== head) {
        if (insertVal >= curr.val && insertVal <= next.val) {
            break;
        }
        if (curr.val > next.val) {
            if (insertVal > curr.val || insertVal < next.val) {
                break;
            }
        }
        curr = curr.next;
        next = next.next;
    }
    curr.next = node;
    node.next = next;
    return head;
};
```

```go [sol1-Golang]
func insert(head *Node, insertVal int) *Node {
    node := &Node{Val: insertVal}
    if head == nil {
        node.Next = node
        return node
    }
    if head.Next == head {
        head.Next = node
        node.Next = head
        return head
    }
    curr, next := head, head.Next
    for next != head {
        if insertVal >= curr.Val && insertVal <= next.Val {
            break
        }
        if curr.Val > next.Val {
            if insertVal > curr.Val || insertVal < next.Val {
                break
            }
        }
        curr = curr.Next
        next = next.Next
    }
    curr.Next = node
    node.Next = next
    return head
}
```

 **复杂度分析**
 - 时间复杂度：$\mathcal{O}(N)$，其中 $N$ 是列表的大小。在最坏的情况下，我们将遍历整个列表。 
 - 空间复杂度：$\mathcal{O}(1)$. 这是一个常数空间解决方案。
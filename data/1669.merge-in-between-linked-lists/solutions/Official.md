#### 方法一：模拟

**思路与算法**

题目要求将 $\textit{list}_1$ 的第 $a$ 到 $b$ 个节点都删除，将其替换为 $\textit{list}_2$。因此，我们首先找到 $\textit{list}_1$ 中第 $a - 1$ 个节点 $\textit{preA}$，以及第 $b + 1$ 个节点 $\textit{aftB}$。由于 $1 \le a \le b \lt n - 1$（其中 $n$ 是 $\textit{list}_1$ 的长度），所以 $preA$ 和 $aftB$ 是一定存在的。

然后我们让 $\textit{preA}$ 的 $\textit{next}$ 指向 $\textit{list}_2$ 的头节点，再让 $\textit{list}_2$ 的尾节点的 $\textit{next}$ 指向 $\textit{aftB}$ 即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def mergeInBetween(self, list1: ListNode, a: int, b: int, list2: ListNode) -> ListNode:
        preA = list1
        for _ in range(a - 1):
            preA = preA.next
        preB = preA
        for _ in range(b - a + 2):
            preB = preB.next
        preA.next = list2
        while list2.next:
            list2 = list2.next
        list2.next = preB
        return list1
```

```C++ [sol1-C++]
class Solution {
public:
    ListNode* mergeInBetween(ListNode* list1, int a, int b, ListNode* list2) {
        ListNode* preA = list1;
        for (int i = 0; i < a - 1; i++) {
            preA = preA->next;
        }
        ListNode* preB = preA;
        for (int i = 0; i < b - a + 2; i++) {
            preB = preB->next;
        }
        preA->next = list2;
        while (list2->next != nullptr) {
            list2 = list2->next;
        }
        list2->next = preB;
        return list1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public ListNode mergeInBetween(ListNode list1, int a, int b, ListNode list2) {
        ListNode preA = list1;
        for (int i = 0; i < a - 1; i++) {
            preA = preA.next;
        }
        ListNode preB = preA;
        for (int i = 0; i < b - a + 2; i++) {
            preB = preB.next;
        }
        preA.next = list2;
        while (list2.next != null) {
            list2 = list2.next;
        }
        list2.next = preB;
        return list1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public ListNode MergeInBetween(ListNode list1, int a, int b, ListNode list2) {
        ListNode preA = list1;
        for (int i = 0; i < a - 1; i++) {
            preA = preA.next;
        }
        ListNode preB = preA;
        for (int i = 0; i < b - a + 2; i++) {
            preB = preB.next;
        }
        preA.next = list2;
        while (list2.next != null) {
            list2 = list2.next;
        }
        list2.next = preB;
        return list1;
    }
}
```

```C [sol1-C]
struct ListNode* mergeInBetween(struct ListNode* list1, int a, int b, struct ListNode* list2) {
    struct ListNode* preA = list1;
    for (int i = 0; i < a - 1; i++) {
        preA = preA->next;
    }
    struct ListNode* preB = preA;
    for (int i = 0; i < b - a + 2; i++) {
        preB = preB->next;
    }
    preA->next = list2;
    while (list2->next != NULL) {
        list2 = list2->next;
    }
    list2->next = preB;
    return list1;
}
```

```JavaScript [sol1-JavaScript]
var mergeInBetween = function(list1, a, b, list2) {
    let preA = list1;
    for (let i = 0; i < a - 1; i++) {
        preA = preA.next;
    }
    let preB = preA;
    for (let i = 0; i < b - a + 2; i++) {
        preB = preB.next;
    }
    preA.next = list2;
    while (list2.next) {
        list2 = list2.next;
    }
    list2.next = preB;
    return list1;
};
```

```go [sol1-Golang]
func mergeInBetween(list1 *ListNode, a int, b int, list2 *ListNode) *ListNode {
    preA := list1
    for i := 0; i < a-1; i++ {
        preA = preA.Next
    }
    preB := preA
    for i := 0; i < b-a+2; i++ {
        preB = preB.Next
    }
    preA.Next = list2
    for list2.Next != nil {
        list2 = list2.Next
    }
    list2.Next = preB
    return list1
}
```

**复杂度分析**

- 时间复杂度：$O(n + m)$，其中 $n$ 是 $\textit{list}_1$ 的长度，$m$ 是 $\textit{list}_2$ 的长度。
- 空间复杂度：$O(1)$。
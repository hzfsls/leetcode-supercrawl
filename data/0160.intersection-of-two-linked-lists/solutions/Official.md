## [160.相交链表 中文官方题解](https://leetcode.cn/problems/intersection-of-two-linked-lists/solutions/100000/xiang-jiao-lian-biao-by-leetcode-solutio-a8jn)

#### 方法一：哈希集合

**思路和算法**

判断两个链表是否相交，可以使用哈希集合存储链表节点。

首先遍历链表 $\textit{headA}$，并将链表 $\textit{headA}$ 中的每个节点加入哈希集合中。然后遍历链表 $\textit{headB}$，对于遍历到的每个节点，判断该节点是否在哈希集合中：

- 如果当前节点不在哈希集合中，则继续遍历下一个节点；

- 如果当前节点在哈希集合中，则后面的节点都在哈希集合中，即从当前节点开始的所有节点都在两个链表的相交部分，因此在链表 $\textit{headB}$ 中遍历到的第一个在哈希集合中的节点就是两个链表相交的节点，返回该节点。

如果链表 $\textit{headB}$ 中的所有节点都不在哈希集合中，则两个链表不相交，返回 $\text{null}$。

**代码**

```Java [sol1-Java]
public class Solution {
    public ListNode getIntersectionNode(ListNode headA, ListNode headB) {
        Set<ListNode> visited = new HashSet<ListNode>();
        ListNode temp = headA;
        while (temp != null) {
            visited.add(temp);
            temp = temp.next;
        }
        temp = headB;
        while (temp != null) {
            if (visited.contains(temp)) {
                return temp;
            }
            temp = temp.next;
        }
        return null;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public ListNode GetIntersectionNode(ListNode headA, ListNode headB) {
        ISet<ListNode> visited = new HashSet<ListNode>();
        ListNode temp = headA;
        while (temp != null) {
            visited.Add(temp);
            temp = temp.next;
        }
        temp = headB;
        while (temp != null) {
            if (visited.Contains(temp)) {
                return temp;
            }
            temp = temp.next;
        }
        return null;
    }
}
```

```JavaScript [sol1-JavaScript]
var getIntersectionNode = function(headA, headB) {
    const visited = new Set();
    let temp = headA;
    while (temp !== null) {
        visited.add(temp);
        temp = temp.next;
    }
    temp = headB;
    while (temp !== null) {
        if (visited.has(temp)) {
            return temp;
        }
        temp = temp.next;
    }
    return null;
};
```

```go [sol1-Golang]
func getIntersectionNode(headA, headB *ListNode) *ListNode {
    vis := map[*ListNode]bool{}
    for tmp := headA; tmp != nil; tmp = tmp.Next {
        vis[tmp] = true
    }
    for tmp := headB; tmp != nil; tmp = tmp.Next {
        if vis[tmp] {
            return tmp
        }
    }
    return nil
}
```

```C++ [sol1-C++]
class Solution {
public:
    ListNode *getIntersectionNode(ListNode *headA, ListNode *headB) {
        unordered_set<ListNode *> visited;
        ListNode *temp = headA;
        while (temp != nullptr) {
            visited.insert(temp);
            temp = temp->next;
        }
        temp = headB;
        while (temp != nullptr) {
            if (visited.count(temp)) {
                return temp;
            }
            temp = temp->next;
        }
        return nullptr;
    }
};
```

```C [sol1-C]
struct HashTable {
    struct ListNode *key;
    UT_hash_handle hh;
};

struct ListNode *getIntersectionNode(struct ListNode *headA, struct ListNode *headB) {
    struct HashTable *hashTable = NULL;
    struct ListNode *temp = headA;
    while (temp != NULL) {
        struct HashTable *tmp;
        HASH_FIND(hh, hashTable, &temp, sizeof(struct HashTable *), tmp);
        if (tmp == NULL) {
            tmp = malloc(sizeof(struct HashTable));
            tmp->key = temp;
            HASH_ADD(hh, hashTable, key, sizeof(struct HashTable *), tmp);
        }
        temp = temp->next;
    }
    temp = headB;
    while (temp != NULL) {
        struct HashTable *tmp;
        HASH_FIND(hh, hashTable, &temp, sizeof(struct HashTable *), tmp);
        if (tmp != NULL) {
            return temp;
        }
        temp = temp->next;
    }
    return NULL;
}
```

**复杂度分析**

- 时间复杂度：$O(m+n)$，其中 $m$ 和 $n$ 是分别是链表 $\textit{headA}$ 和 $\textit{headB}$ 的长度。需要遍历两个链表各一次。

- 空间复杂度：$O(m)$，其中 $m$ 是链表 $\textit{headA}$ 的长度。需要使用哈希集合存储链表 $\textit{headA}$ 中的全部节点。

#### 方法二：双指针

**思路和算法**

使用双指针的方法，可以将空间复杂度降至 $O(1)$。

只有当链表 $\textit{headA}$ 和 $\textit{headB}$ 都不为空时，两个链表才可能相交。因此首先判断链表 $\textit{headA}$ 和 $\textit{headB}$ 是否为空，如果其中至少有一个链表为空，则两个链表一定不相交，返回 $\text{null}$。

当链表 $\textit{headA}$ 和 $\textit{headB}$ 都不为空时，创建两个指针 $\textit{pA}$ 和 $\textit{pB}$，初始时分别指向两个链表的头节点 $\textit{headA}$ 和 $\textit{headB}$，然后将两个指针依次遍历两个链表的每个节点。具体做法如下：

- 每步操作需要同时更新指针 $\textit{pA}$ 和 $\textit{pB}$。

- 如果指针 $\textit{pA}$ 不为空，则将指针 $\textit{pA}$ 移到下一个节点；如果指针 $\textit{pB}$ 不为空，则将指针 $\textit{pB}$ 移到下一个节点。

- 如果指针 $\textit{pA}$ 为空，则将指针 $\textit{pA}$ 移到链表 $\textit{headB}$ 的头节点；如果指针 $\textit{pB}$ 为空，则将指针 $\textit{pB}$ 移到链表 $\textit{headA}$ 的头节点。

- 当指针 $\textit{pA}$ 和 $\textit{pB}$ 指向同一个节点或者都为空时，返回它们指向的节点或者 $\text{null}$。

**证明**

下面提供双指针方法的正确性证明。考虑两种情况，第一种情况是两个链表相交，第二种情况是两个链表不相交。

情况一：两个链表相交

链表 $\textit{headA}$ 和 $\textit{headB}$ 的长度分别是 $m$ 和 $n$。假设链表 $\textit{headA}$ 的不相交部分有 $a$ 个节点，链表 $\textit{headB}$ 的不相交部分有 $b$ 个节点，两个链表相交的部分有 $c$ 个节点，则有 $a+c=m$，$b+c=n$。

- 如果 $a=b$，则两个指针会同时到达两个链表相交的节点，此时返回相交的节点；

- 如果 $a \ne b$，则指针 $\textit{pA}$ 会遍历完链表 $\textit{headA}$，指针 $\textit{pB}$ 会遍历完链表 $\textit{headB}$，两个指针不会同时到达链表的尾节点，然后指针 $\textit{pA}$ 移到链表 $\textit{headB}$ 的头节点，指针 $\textit{pB}$ 移到链表 $\textit{headA}$ 的头节点，然后两个指针继续移动，在指针 $\textit{pA}$ 移动了 $a+c+b$ 次、指针 $\textit{pB}$ 移动了 $b+c+a$ 次之后，两个指针会同时到达两个链表相交的节点，该节点也是两个指针第一次同时指向的节点，此时返回相交的节点。

情况二：两个链表不相交

链表 $\textit{headA}$ 和 $\textit{headB}$ 的长度分别是 $m$ 和 $n$。考虑当 $m=n$ 和 $m \ne n$ 时，两个指针分别会如何移动：

- 如果 $m=n$，则两个指针会同时到达两个链表的尾节点，然后同时变成空值 $\text{null}$，此时返回 $\text{null}$；

- 如果 $m \ne n$，则由于两个链表没有公共节点，两个指针也不会同时到达两个链表的尾节点，因此两个指针都会遍历完两个链表，在指针 $\textit{pA}$ 移动了 $m+n$ 次、指针 $\textit{pB}$ 移动了 $n+m$ 次之后，两个指针会同时变成空值 $\text{null}$，此时返回 $\text{null}$。

**代码**

```Java [sol2-Java]
public class Solution {
    public ListNode getIntersectionNode(ListNode headA, ListNode headB) {
        if (headA == null || headB == null) {
            return null;
        }
        ListNode pA = headA, pB = headB;
        while (pA != pB) {
            pA = pA == null ? headB : pA.next;
            pB = pB == null ? headA : pB.next;
        }
        return pA;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public ListNode GetIntersectionNode(ListNode headA, ListNode headB) {
        if (headA == null || headB == null) {
            return null;
        }
        ListNode pA = headA, pB = headB;
        while (pA != pB) {
            pA = pA == null ? headB : pA.next;
            pB = pB == null ? headA : pB.next;
        }
        return pA;
    }
}
```

```JavaScript [sol2-JavaScript]
var getIntersectionNode = function(headA, headB) {
    if (headA === null || headB === null) {
        return null;
    }
    let pA = headA, pB = headB;
    while (pA !== pB) {
        pA = pA === null ? headB : pA.next;
        pB = pB === null ? headA : pB.next;
    }
    return pA;
};
```

```go [sol2-Golang]
func getIntersectionNode(headA, headB *ListNode) *ListNode {
    if headA == nil || headB == nil {
        return nil
    }
    pa, pb := headA, headB
    for pa != pb {
        if pa == nil {
            pa = headB
        } else {
            pa = pa.Next
        }
        if pb == nil {
            pb = headA
        } else {
            pb = pb.Next
        }
    }
    return pa
}
```

```C++ [sol2-C++]
class Solution {
public:
    ListNode *getIntersectionNode(ListNode *headA, ListNode *headB) {
        if (headA == nullptr || headB == nullptr) {
            return nullptr;
        }
        ListNode *pA = headA, *pB = headB;
        while (pA != pB) {
            pA = pA == nullptr ? headB : pA->next;
            pB = pB == nullptr ? headA : pB->next;
        }
        return pA;
    }
};
```

```C [sol2-C]
struct ListNode *getIntersectionNode(struct ListNode *headA, struct ListNode *headB) {
    if (headA == NULL || headB == NULL) {
        return NULL;
    }
    struct ListNode *pA = headA, *pB = headB;
    while (pA != pB) {
        pA = pA == NULL ? headB : pA->next;
        pB = pB == NULL ? headA : pB->next;
    }
    return pA;
}
```

**复杂度分析**

- 时间复杂度：$O(m+n)$，其中 $m$ 和 $n$ 是分别是链表 $\textit{headA}$ 和 $\textit{headB}$ 的长度。两个指针同时遍历两个链表，每个指针遍历两个链表各一次。

- 空间复杂度：$O(1)$。
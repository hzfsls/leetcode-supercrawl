## [1171.从链表中删去总和值为零的连续节点 中文官方题解](https://leetcode.cn/problems/remove-zero-sum-consecutive-nodes-from-linked-list/solutions/100000/cong-lian-biao-zhong-shan-qu-zong-he-zhi-h18o)

#### 方法一：哈希表

给你一个链表的头节点 $\textit{head}$，反复删去链表中总和值为 $0$ 的连续节点组成的序列。

建立一个 $\textit{dummy}$ 节点，指向 $\textit{head}$，节点值为 $0$。遍历一遍链表，同时记录前缀和，以当前前缀和为 $\textit{key}$，当前节点为 $\textit{value}$，存入哈希表中。如果相同前缀和已经存在，就可以直接覆盖掉原有节点。

第二遍重新遍历链表，同时记录前缀和 $\textit{prefix}$，哈希表中对应 $\textit{prefix}$ 的节点是最后一次出现相同前缀和的节点，我们将这个节点的下一个节点，赋值给当前节点的下一个节点，中间跳过的部分总和即为 $0$。

最后我们返回 $\textit{dummy}$ 节点的下一节点，作为新的头节点。注意满足题目要求的答案不唯一，可以返回任何满足题目要求的答案。


```C++ [sol1-C++]
class Solution {
public:
    ListNode* removeZeroSumSublists(ListNode* head) {
        ListNode* dummy = new ListNode(0);
        dummy->next = head;
        int prefix = 0;
        unordered_map<int, ListNode*> seen;
        for (ListNode* node = dummy; node; node = node->next) {
            prefix += node->val;
            seen[prefix] = node;
        }
        prefix = 0;
        for (ListNode* node = dummy; node; node = node->next) {
            prefix += node->val;
            node->next = seen[prefix]->next;
        }
        return dummy->next;
    }
};
```

```Java [sol1-Java]
class Solution {
    public ListNode removeZeroSumSublists(ListNode head) {
        ListNode dummy = new ListNode(0);
        dummy.next = head;
        Map<Integer, ListNode> seen = new HashMap<>();
        int prefix = 0;
        for (ListNode node = dummy; node != null; node = node.next) {
            prefix += node.val;
            seen.put(prefix, node);
        }
        prefix = 0;
        for (ListNode node = dummy; node != null; node = node.next) {
            prefix += node.val;
            node.next = seen.get(prefix).next;
        }
        return dummy.next;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public ListNode RemoveZeroSumSublists(ListNode head) {
        int prefix = 0;
        ListNode dummy = new ListNode(0);
        dummy.next = head;
        Dictionary<int, ListNode> seen = new Dictionary<int, ListNode>();
        seen[0] = dummy;
        for (ListNode node = dummy; node != null; node = node.next) {
            prefix += node.val;
            seen[prefix] = node;
        }
        prefix = 0;
        for (ListNode node = dummy; node != null; node = node.next) {
            prefix += node.val;
            node.next = seen[prefix].next;
        }
        return dummy.next;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def removeZeroSumSublists(self, head: Optional[ListNode]) -> Optional[ListNode]:
        prefix = 0
        seen = {}
        seen[0] = dummy = ListNode(0)
        dummy.next = head
        while head:
            prefix += head.val
            seen[prefix] = head
            head = head.next
        head = dummy
        prefix = 0
        while head:
            prefix += head.val
            head.next = seen[prefix].next
            head = head.next
        return dummy.next
```

```JavaScript [sol1-JavaScript]
var removeZeroSumSublists = function(head) {
    let dummy = new ListNode(0);
    dummy.next = head;
    let seen = {};
    let prefix = 0;
    for (let node = dummy; node !== null; node = node.next) {
        prefix += node.val;
        seen[prefix] = node;
    }
    prefix = 0;
    for (let node = dummy; node !== null; node = node.next) {
        prefix += node.val;
        node.next = seen[prefix].next;
    }
    return dummy.next;
};
```

```Go [sol1-Go]
func removeZeroSumSublists(head *ListNode) *ListNode {
    dummy := &ListNode{Val: 0}
    dummy.Next = head
    seen := map[int]*ListNode{}
    prefix := 0
    for node := dummy; node != nil; node = node.Next {
        prefix += node.Val
        seen[prefix] = node
    }
    prefix = 0
    for node := dummy; node != nil; node = node.Next {
        prefix += node.Val
        node.Next = seen[prefix].Next
    }
    return dummy.Next
}
```

```C [sol1-C]
typedef struct {
    int key;
    struct ListNode *val;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key, const struct ListNode* val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

bool hashSetItem(HashItem **obj, int key, const struct ListNode* val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        hashAddItem(obj, key, val);
    } else {
        pEntry->val = val;
    }
    return true;
}

struct ListNode * hashGetItem(HashItem **obj, int key) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return NULL;
    }
    return pEntry->val;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);
    }
}

struct ListNode* createListNode(int val) {
    struct ListNode *obj = (struct ListNode *)malloc(sizeof(struct ListNode));
    obj->val = val;
    obj->next = NULL;
    return obj;
}

struct ListNode* removeZeroSumSublists(struct ListNode* head) {
    struct ListNode* dummy = createListNode(0);
    dummy->next = head;
    int prefix = 0;
    HashItem *seen = NULL;
    for (struct ListNode* node = dummy; node; node = node->next) {
        prefix += node->val;
        hashSetItem(&seen, prefix, node);
    }
    prefix = 0;
    for (struct ListNode* node = dummy; node; node = node->next) {
        prefix += node->val;
        struct ListNode *curr = hashGetItem(&seen, prefix);
        if (curr) {
            node->next = curr->next;
        }
    }
    hashFree(&seen);
    struct ListNode* ret = dummy->next;
    free(dummy);
    return ret;
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是链表的长度。

+ 空间复杂度：$O(n)$，其中 $n$ 是链表的长度。
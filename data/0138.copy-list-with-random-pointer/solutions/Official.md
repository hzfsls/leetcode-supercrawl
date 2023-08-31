## [138.复制带随机指针的链表 中文官方题解](https://leetcode.cn/problems/copy-list-with-random-pointer/solutions/100000/fu-zhi-dai-sui-ji-zhi-zhen-de-lian-biao-rblsf)

#### 方法一：回溯 + 哈希表

**思路及算法**

本题要求我们对一个特殊的链表进行深拷贝。如果是普通链表，我们可以直接按照遍历的顺序创建链表节点。而本题中因为随机指针的存在，当我们拷贝节点时，「当前节点的随机指针指向的节点」可能还没创建，因此我们需要变换思路。一个可行方案是，我们利用回溯的方式，让每个节点的拷贝操作相互独立。对于当前节点，我们首先要进行拷贝，然后我们进行「当前节点的后继节点」和「当前节点的随机指针指向的节点」拷贝，拷贝完成后将创建的新节点的指针返回，即可完成当前节点的两指针的赋值。

具体地，我们用哈希表记录每一个节点对应新节点的创建情况。遍历该链表的过程中，我们检查「当前节点的后继节点」和「当前节点的随机指针指向的节点」的创建情况。如果这两个节点中的任何一个节点的新节点没有被创建，我们都立刻递归地进行创建。当我们拷贝完成，回溯到当前层时，我们即可完成当前节点的指针赋值。注意一个节点可能被多个其他节点指向，因此我们可能递归地多次尝试拷贝某个节点，为了防止重复拷贝，我们需要首先检查当前节点是否被拷贝过，如果已经拷贝过，我们可以直接从哈希表中取出拷贝后的节点的指针并返回即可。

在实际代码中，我们需要特别判断给定节点为空节点的情况。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    unordered_map<Node*, Node*> cachedNode;

    Node* copyRandomList(Node* head) {
        if (head == nullptr) {
            return nullptr;
        }
        if (!cachedNode.count(head)) {
            Node* headNew = new Node(head->val);
            cachedNode[head] = headNew;
            headNew->next = copyRandomList(head->next);
            headNew->random = copyRandomList(head->random);
        }
        return cachedNode[head];
    }
};
```

```Java [sol1-Java]
class Solution {
    Map<Node, Node> cachedNode = new HashMap<Node, Node>();

    public Node copyRandomList(Node head) {
        if (head == null) {
            return null;
        }
        if (!cachedNode.containsKey(head)) {
            Node headNew = new Node(head.val);
            cachedNode.put(head, headNew);
            headNew.next = copyRandomList(head.next);
            headNew.random = copyRandomList(head.random);
        }
        return cachedNode.get(head);
    }
}
```

```C# [sol1-C#]
public class Solution {
    Dictionary<Node, Node> cachedNode = new Dictionary<Node, Node>();

    public Node CopyRandomList(Node head) {
        if (head == null) {
            return null;
        }
        if (!cachedNode.ContainsKey(head)) {
            Node headNew = new Node(head.val);
            cachedNode.Add(head, headNew);
            headNew.next = CopyRandomList(head.next);
            headNew.random = CopyRandomList(head.random);
        }
        return cachedNode[head];
    }
}
```

```JavaScript [sol1-JavaScript]
var copyRandomList = function(head, cachedNode = new Map()) {
    if (head === null) {
        return null;
    }
    if (!cachedNode.has(head)) {
        cachedNode.set(head, {val: head.val}), Object.assign(cachedNode.get(head), {next: copyRandomList(head.next, cachedNode), random: copyRandomList(head.random, cachedNode)})
    }
    return cachedNode.get(head);
}
```

```go [sol1-Golang]
var cachedNode map[*Node]*Node

func deepCopy(node *Node) *Node {
    if node == nil {
        return nil
    }
    if n, has := cachedNode[node]; has {
        return n
    }
    newNode := &Node{Val: node.Val}
    cachedNode[node] = newNode
    newNode.Next = deepCopy(node.Next)
    newNode.Random = deepCopy(node.Random)
    return newNode
}

func copyRandomList(head *Node) *Node {
    cachedNode = map[*Node]*Node{}
    return deepCopy(head)
}
```

```C [sol1-C]
struct HashTable {
    struct Node *key, *val;
    UT_hash_handle hh;
} * cachedNode;

struct Node* deepCopy(struct Node* head) {
    if (head == NULL) {
        return NULL;
    }
    struct HashTable* tmp;
    HASH_FIND_PTR(cachedNode, &head, tmp);
    if (tmp == NULL) {
        struct Node* headNew = malloc(sizeof(struct Node));
        headNew->val = head->val;
        tmp = malloc(sizeof(struct HashTable));
        tmp->key = head, tmp->val = headNew;
        HASH_ADD_PTR(cachedNode, key, tmp);
        headNew->next = deepCopy(head->next);
        headNew->random = deepCopy(head->random);
    }
    return tmp->val;
}

struct Node* copyRandomList(struct Node* head) {
    cachedNode = NULL;
    return deepCopy(head);
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是链表的长度。对于每个节点，我们至多访问其「后继节点」和「随机指针指向的节点」各一次，均摊每个点至多被访问两次。

- 空间复杂度：$O(n)$，其中 $n$ 是链表的长度。为哈希表的空间开销。

#### 方法二：迭代 + 节点拆分

**思路及算法**

注意到方法一需要使用哈希表记录每一个节点对应新节点的创建情况，而我们可以使用一个小技巧来省去哈希表的空间。

我们首先将该链表中每一个节点拆分为两个相连的节点，例如对于链表 $A \rightarrow B \rightarrow C$，我们可以将其拆分为 $A \rightarrow A' \rightarrow B \rightarrow B' \rightarrow C \rightarrow C'$。对于任意一个原节点 $S$，其拷贝节点 $S'$ 即为其后继节点。

这样，我们可以直接找到每一个拷贝节点 $S'$ 的随机指针应当指向的节点，即为其原节点 $S$ 的随机指针指向的节点 $T$ 的后继节点 $T'$。需要注意原节点的随机指针可能为空，我们需要特别判断这种情况。

当我们完成了拷贝节点的随机指针的赋值，我们只需要将这个链表按照原节点与拷贝节点的种类进行拆分即可，只需要遍历一次。同样需要注意最后一个拷贝节点的后继节点为空，我们需要特别判断这种情况。

<![ppt1](https://assets.leetcode-cn.com/solution-static/138/1.png),![ppt2](https://assets.leetcode-cn.com/solution-static/138/2.png),![ppt3](https://assets.leetcode-cn.com/solution-static/138/3.png),![ppt4](https://assets.leetcode-cn.com/solution-static/138/4.png)>

**代码**

```C++ [sol2-C++]
class Solution {
public:
    Node* copyRandomList(Node* head) {
        if (head == nullptr) {
            return nullptr;
        }
        for (Node* node = head; node != nullptr; node = node->next->next) {
            Node* nodeNew = new Node(node->val);
            nodeNew->next = node->next;
            node->next = nodeNew;
        }
        for (Node* node = head; node != nullptr; node = node->next->next) {
            Node* nodeNew = node->next;
            nodeNew->random = (node->random != nullptr) ? node->random->next : nullptr;
        }
        Node* headNew = head->next;
        for (Node* node = head; node != nullptr; node = node->next) {
            Node* nodeNew = node->next;
            node->next = node->next->next;
            nodeNew->next = (nodeNew->next != nullptr) ? nodeNew->next->next : nullptr;
        }
        return headNew;
    }
};
```

```Java [sol2-Java]
class Solution {
    public Node copyRandomList(Node head) {
        if (head == null) {
            return null;
        }
        for (Node node = head; node != null; node = node.next.next) {
            Node nodeNew = new Node(node.val);
            nodeNew.next = node.next;
            node.next = nodeNew;
        }
        for (Node node = head; node != null; node = node.next.next) {
            Node nodeNew = node.next;
            nodeNew.random = (node.random != null) ? node.random.next : null;
        }
        Node headNew = head.next;
        for (Node node = head; node != null; node = node.next) {
            Node nodeNew = node.next;
            node.next = node.next.next;
            nodeNew.next = (nodeNew.next != null) ? nodeNew.next.next : null;
        }
        return headNew;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public Node CopyRandomList(Node head) {
        if (head == null) {
            return null;
        }
        for (Node node = head; node != null; node = node.next.next) {
            Node nodeNew = new Node(node.val);
            nodeNew.next = node.next;
            node.next = nodeNew;
        }
        for (Node node = head; node != null; node = node.next.next) {
            Node nodeNew = node.next;
            nodeNew.random = (node.random != null) ? node.random.next : null;
        }
        Node headNew = head.next;
        for (Node node = head; node != null; node = node.next) {
            Node nodeNew = node.next;
            node.next = node.next.next;
            nodeNew.next = (nodeNew.next != null) ? nodeNew.next.next : null;
        }
        return headNew;
    }
}
```

```JavaScript [sol2-JavaScript]
var copyRandomList = function(head) {
    if (head === null) {
        return null;
    }
    for (let node = head; node !== null; node = node.next.next) {
        const nodeNew = new Node(node.val, node.next, null);
        node.next = nodeNew;
    }
    for (let node = head; node !== null; node = node.next.next) {
        const nodeNew = node.next;
        nodeNew.random = (node.random !== null) ? node.random.next : null;
    }
    const headNew = head.next;
    for (let node = head; node !== null; node = node.next) {
        const nodeNew = node.next;
        node.next = node.next.next;
        nodeNew.next = (nodeNew.next !== null) ? nodeNew.next.next : null;
    }
    return headNew;
};
```

```go [sol2-Golang]
func copyRandomList(head *Node) *Node {
    if head == nil {
        return nil
    }
    for node := head; node != nil; node = node.Next.Next {
        node.Next = &Node{Val: node.Val, Next: node.Next}
    }
    for node := head; node != nil; node = node.Next.Next {
        if node.Random != nil {
            node.Next.Random = node.Random.Next
        }
    }
    headNew := head.Next
    for node := head; node != nil; node = node.Next {
        nodeNew := node.Next
        node.Next = node.Next.Next
        if nodeNew.Next != nil {
            nodeNew.Next = nodeNew.Next.Next
        }
    }
    return headNew
}
```

```C [sol2-C]
struct Node* copyRandomList(struct Node* head) {
    if (head == NULL) {
        return NULL;
    }
    for (struct Node* node = head; node != NULL; node = node->next->next) {
        struct Node* nodeNew = malloc(sizeof(struct Node));
        nodeNew->val = node->val;
        nodeNew->next = node->next;
        node->next = nodeNew;
    }
    for (struct Node* node = head; node != NULL; node = node->next->next) {
        struct Node* nodeNew = node->next;
        nodeNew->random = (node->random != NULL) ? node->random->next : NULL;
    }
    struct Node* headNew = head->next;
    for (struct Node* node = head; node != NULL; node = node->next) {
        struct Node* nodeNew = node->next;
        node->next = node->next->next;
        nodeNew->next = (nodeNew->next != NULL) ? nodeNew->next->next : NULL;
    }
    return headNew;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是链表的长度。我们只需要遍历该链表三次。

  - 读者们也可以自行尝试在计算拷贝节点的随机指针的同时计算其后继指针，这样只需要遍历两次。

- 空间复杂度：$O(1)$。注意返回值不计入空间复杂度。
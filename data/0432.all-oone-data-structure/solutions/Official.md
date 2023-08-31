## [432.全 O(1) 的数据结构 中文官方题解](https://leetcode.cn/problems/all-oone-data-structure/solutions/100000/quan-o1-de-shu-ju-jie-gou-by-leetcode-so-7gdv)
#### 方法一：双向链表 + 哈希表

本题要求每次操作的时间复杂度均为 $O(1)$（字符串长度视作常数）。我们可以结合双向链表和哈希表来实现，具体如下：

链表中的每个节点存储一个字符串集合 $\textit{keys}$，和一个正整数 $\textit{count}$，表示 $\textit{keys}$ 中的字符串均出现 $\textit{count}$ 次。链表从头到尾的每个节点的 $\textit{count}$ 值单调递增（但不一定连续）。此外，每个节点还需存储指向上一个节点的指针 $\textit{prev}$ 和指向下一个节点的指针 $\textit{next}$。

另外还要用一个哈希表 $\textit{nodes}$ 维护每个字符串当前所处的链表节点。

- 对于 $\text{inc}$ 操作：
  - 若 $\textit{key}$ 不在链表中：若链表为空或头节点的 $\textit{count}>1$，则先插入一个 $\textit{count}=1$ 的新节点至链表头部，然后将 $\textit{key}$ 插入到头节点的 $\textit{keys}$ 中。
  - 若 $\textit{key}$ 在链表中：设 $\textit{key}$ 所在节点为 $\textit{cur}$，若 $\textit{cur}.\textit{next}$ 为空或 $\textit{cur}.\textit{next}.\textit{count}>\textit{cur}.\textit{count}+1$，则先插入一个 $\textit{count}=\textit{cur}.\textit{count}+1$ 的新节点至 $\textit{cur}$ 之后，然后将 $\textit{key}$ 插入到 $\textit{cur}.\textit{next}.\textit{keys}$ 中。最后，将 $\textit{key}$ 从 $\textit{cur}.\textit{keys}$ 中移除，若移除后 $\textit{cur}.\textit{keys}$ 为空，则将 $\textit{cur}$ 从链表中移除。
  - 更新 $\textit{nodes}$ 中 $\textit{key}$ 所处的节点。

- 对于 $\text{dec}$ 操作，测试用例保证 $\textit{key}$ 在链表中。
  - 若 $\textit{key}$ 仅出现一次：将其从 $\textit{nodes}$ 中移除。
  - 若 $\textit{key}$ 出现不止一次：设 $\textit{key}$ 所在节点为 $\textit{cur}$，若 $\textit{cur}.\textit{prev}$ 为空或 $\textit{cur}.\textit{prev}.\textit{count}<\textit{cur}.\textit{count}-1$，则先插入一个 $\textit{count}=\textit{cur}.\textit{count}-1$ 的新节点至 $\textit{cur}$ 之前，然后将 $\textit{key}$ 插入到 $\textit{cur}.\textit{prev}.\textit{keys}$ 中。更新 $\textit{nodes}$ 中 $\textit{key}$ 所处的节点。
  - 最后，将 $\textit{key}$ 从 $\textit{cur}.\textit{keys}$ 中移除，若移除后 $\textit{cur}.\textit{keys}$ 为空，则将 $\textit{cur}$ 从链表中移除。

- 对于 $\text{getMaxKey}$ 操作，在链表不为空时，返回链表尾节点的 $\textit{keys}$ 中的任一元素，否则返回空字符串。

- 对于 $\text{getMinKey}$ 操作，在链表不为空时，返回链表头节点的 $\textit{keys}$ 中的任一元素，否则返回空字符串。

```Python [sol1-Python3]
class Node:
    def __init__(self, key="", count=0):
        self.prev = None
        self.next = None
        self.keys = {key}
        self.count = count

    def insert(self, node: 'Node') -> 'Node':  # 在 self 后插入 node
        node.prev = self
        node.next = self.next
        node.prev.next = node
        node.next.prev = node
        return node

    def remove(self):  # 从链表中移除 self
        self.prev.next = self.next
        self.next.prev = self.prev

class AllOne:
    def __init__(self):
        self.root = Node()
        self.root.prev = self.root
        self.root.next = self.root  # 初始化链表哨兵，下面判断节点的 next 若为 self.root，则表示 next 为空（prev 同理）
        self.nodes = {}

    def inc(self, key: str) -> None:
        if key not in self.nodes:  # key 不在链表中
            if self.root.next is self.root or self.root.next.count > 1:
                self.nodes[key] = self.root.insert(Node(key, 1))
            else:
                self.root.next.keys.add(key)
                self.nodes[key] = self.root.next
        else:
            cur = self.nodes[key]
            nxt = cur.next
            if nxt is self.root or nxt.count > cur.count + 1:
                self.nodes[key] = cur.insert(Node(key, cur.count + 1))
            else:
                nxt.keys.add(key)
                self.nodes[key] = nxt
            cur.keys.remove(key)
            if len(cur.keys) == 0:
                cur.remove()

    def dec(self, key: str) -> None:
        cur = self.nodes[key]
        if cur.count == 1:  # key 仅出现一次，将其移出 nodes
            del self.nodes[key]
        else:
            pre = cur.prev
            if pre is self.root or pre.count < cur.count - 1:
                self.nodes[key] = cur.prev.insert(Node(key, cur.count - 1))
            else:
                pre.keys.add(key)
                self.nodes[key] = pre
        cur.keys.remove(key)
        if len(cur.keys) == 0:
            cur.remove()

    def getMaxKey(self) -> str:
        return next(iter(self.root.prev.keys)) if self.root.prev is not self.root else ""

    def getMinKey(self) -> str:
        return next(iter(self.root.next.keys)) if self.root.next is not self.root else ""
```

```C++ [sol1-C++]
class AllOne {
    list<pair<unordered_set<string>, int>> lst;
    unordered_map<string, list<pair<unordered_set<string>, int>>::iterator> nodes;

public:
    AllOne() {}

    void inc(string key) {
        if (nodes.count(key)) {
            auto cur = nodes[key], nxt = next(cur);
            if (nxt == lst.end() || nxt->second > cur->second + 1) {
                unordered_set<string> s({key});
                nodes[key] = lst.emplace(nxt, s, cur->second + 1);
            } else {
                nxt->first.emplace(key);
                nodes[key] = nxt;
            }
            cur->first.erase(key);
            if (cur->first.empty()) {
                lst.erase(cur);
            }
        } else { // key 不在链表中
            if (lst.empty() || lst.begin()->second > 1) {
                unordered_set<string> s({key});
                lst.emplace_front(s, 1);
            } else {
                lst.begin()->first.emplace(key);
            }
            nodes[key] = lst.begin();
        }
    }

    void dec(string key) {
        auto cur = nodes[key];
        if (cur->second == 1) { // key 仅出现一次，将其移出 nodes
            nodes.erase(key);
        } else {
            auto pre = prev(cur);
            if (cur == lst.begin() || pre->second < cur->second - 1) {
                unordered_set<string> s({key});
                nodes[key] = lst.emplace(cur, s, cur->second - 1);
            } else {
                pre->first.emplace(key);
                nodes[key] = pre;
            }
        }
        cur->first.erase(key);
        if (cur->first.empty()) {
            lst.erase(cur);
        }
    }

    string getMaxKey() {
        return lst.empty() ? "" : *lst.rbegin()->first.begin();
    }

    string getMinKey() {
        return lst.empty() ? "" : *lst.begin()->first.begin();
    }
};
```

```Java [sol1-Java]
class AllOne {
    Node root;
    Map<String, Node> nodes;

    public AllOne() {
        root = new Node();
        root.prev = root;
        root.next = root;  // 初始化链表哨兵，下面判断节点的 next 若为 root，则表示 next 为空（prev 同理）
        nodes = new HashMap<String, Node>();
    }
    
    public void inc(String key) {
        if (nodes.containsKey(key)) {
            Node cur = nodes.get(key);
            Node nxt = cur.next;
            if (nxt == root || nxt.count > cur.count + 1) {
                nodes.put(key, cur.insert(new Node(key, cur.count + 1)));
            } else {
                nxt.keys.add(key);
                nodes.put(key, nxt);
            }
            cur.keys.remove(key);
            if (cur.keys.isEmpty()) {
                cur.remove();
            }
        } else {  // key 不在链表中
            if (root.next == root || root.next.count > 1) {
                nodes.put(key, root.insert(new Node(key, 1)));
            } else {
                root.next.keys.add(key);
                nodes.put(key, root.next);
            }
        }
    }
    
    public void dec(String key) {
        Node cur = nodes.get(key);
        if (cur.count == 1) {  // key 仅出现一次，将其移出 nodes
            nodes.remove(key);
        } else {
            Node pre = cur.prev;
            if (pre == root || pre.count < cur.count - 1) {
                nodes.put(key, cur.prev.insert(new Node(key, cur.count - 1)));
            } else {
                pre.keys.add(key);
                nodes.put(key, pre);
            }
        }
        cur.keys.remove(key);
        if (cur.keys.isEmpty()) {
            cur.remove();
        }
    }
    
    public String getMaxKey() {
        return root.prev != null ? root.prev.keys.iterator().next() : "";
    }
    
    public String getMinKey() {
        return root.next != null ? root.next.keys.iterator().next() : "";
    }
}

class Node {
    Node prev;
    Node next;
    Set<String> keys;
    int count;

    public Node() {
        this("", 0);
    }

    public Node(String key, int count) {
        this.count = count;
        keys = new HashSet<String>();
        keys.add(key);
    }

    public Node insert(Node node) {  // 在 this 后插入 node
        node.prev = this;
        node.next = this.next;
        node.prev.next = node;
        node.next.prev = node;
        return node;
    }

    public void remove() {
        this.prev.next = this.next;
        this.next.prev = this.prev;
    }
}
```

```C# [sol1-C#]
public class AllOne {
    Node root;
    Dictionary<string, Node> nodes;

    public AllOne() {
        root = new Node();
        root.Prev = root;
        root.Next = root;  // 初始化链表哨兵，下面判断节点的 Next 若为 root，则表示 Next 为空（Prev 同理）
        nodes = new Dictionary<string, Node>();
    }
    
    public void Inc(string key) {
        if (nodes.ContainsKey(key)) {
            Node cur = nodes[key];
            Node nxt = cur.Next;
            if (nxt == root || nxt.Count > cur.Count + 1) {
                nodes[key] = cur.Insert(new Node(key, cur.Count + 1));
            } else {
                nxt.Keys.Add(key);
                nodes[key] = nxt;
            }
            cur.Keys.Remove(key);
            if (cur.Keys.Count == 0) {
                cur.Remove();
            }
        } else {  // key 不在链表中
            if (root.Next == root || root.Next.Count > 1) {
                nodes.Add(key, root.Insert(new Node(key, 1)));
            } else {
                root.Next.Keys.Add(key);
                nodes.Add(key, root.Next);
            }
        }
    }
    
    public void Dec(string key) {
        Node cur = nodes[key];
        if (cur.Count == 1) {  // key 仅出现一次，将其移出 nodes
            nodes.Remove(key);
        } else {
            Node pre = cur.Prev;
            if (pre == root || pre.Count < cur.Count - 1) {
                nodes[key] = cur.Prev.Insert(new Node(key, cur.Count - 1));
            } else {
                pre.Keys.Add(key);
                nodes[key] = pre;
            }
        }
        cur.Keys.Remove(key);
        if (cur.Keys.Count == 0) {
            cur.Remove();
        }
    }
    
    public string GetMaxKey() {
        if (root.Prev == null) {
            return "";
        }
        string maxKey = "";
        foreach (string key in root.Prev.Keys) {
            maxKey = key;
            break;
        }
        return maxKey;
    }
    
    public string GetMinKey() {
        if (root.Next == null) {
            return "";
        }
        string minKey = "";
        foreach (string key in root.Next.Keys) {
            minKey = key;
            break;
        }
        return minKey;
    }
}

class Node {
    public Node Prev { get; set; }
    public Node Next { get; set; }
    public ISet<string> Keys { get; set; }
    public int Count { get; set; }

    public Node() : this("", 0) {

    }

    public Node(string key, int count) {
        this.Count = count;
        Keys = new HashSet<string>();
        Keys.Add(key);
    }

    public Node Insert(Node node) {  // 在 this 后插入 node
        node.Prev = this;
        node.Next = this.Next;
        node.Prev.Next = node;
        node.Next.Prev = node;
        return node;
    }

    public void Remove() {
        this.Prev.Next = this.Next;
        this.Next.Prev = this.Prev;
    }
}
```

```go [sol1-Golang]
type node struct {
    keys  map[string]struct{}
    count int
}

type AllOne struct {
    *list.List
    nodes map[string]*list.Element
}

func Constructor() AllOne {
    return AllOne{list.New(), map[string]*list.Element{}}
}

func (l *AllOne) Inc(key string) {
    if cur := l.nodes[key]; cur != nil {
        curNode := cur.Value.(node)
        if nxt := cur.Next(); nxt == nil || nxt.Value.(node).count > curNode.count+1 {
            l.nodes[key] = l.InsertAfter(node{map[string]struct{}{key: {}}, curNode.count + 1}, cur)
        } else {
            nxt.Value.(node).keys[key] = struct{}{}
            l.nodes[key] = nxt
        }
        delete(curNode.keys, key)
        if len(curNode.keys) == 0 {
            l.Remove(cur)
        }
    } else { // key 不在链表中
        if l.Front() == nil || l.Front().Value.(node).count > 1 {
            l.nodes[key] = l.PushFront(node{map[string]struct{}{key: {}}, 1})
        } else {
            l.Front().Value.(node).keys[key] = struct{}{}
            l.nodes[key] = l.Front()
        }
    }
}

func (l *AllOne) Dec(key string) {
    cur := l.nodes[key]
    curNode := cur.Value.(node)
    if curNode.count > 1 {
        if pre := cur.Prev(); pre == nil || pre.Value.(node).count < curNode.count-1 {
            l.nodes[key] = l.InsertBefore(node{map[string]struct{}{key: {}}, curNode.count - 1}, cur)
        } else {
            pre.Value.(node).keys[key] = struct{}{}
            l.nodes[key] = pre
        }
    } else { // key 仅出现一次，将其移出 nodes
        delete(l.nodes, key)
    }
    delete(curNode.keys, key)
    if len(curNode.keys) == 0 {
        l.Remove(cur)
    }
}

func (l *AllOne) GetMaxKey() string {
    if b := l.Back(); b != nil {
        for key := range b.Value.(node).keys {
            return key
        }
    }
    return ""
}

func (l *AllOne) GetMinKey() string {
    if f := l.Front(); f != nil {
        for key := range f.Value.(node).keys {
            return key
        }
    }
    return ""
}
```

```JavaScript [sol1-JavaScript]
var AllOne = function() {
    this.root = new Node();
    this.root.prev = this.root;
    this.root.next = this.root; // 初始化链表哨兵，下面判断节点的 next 若为 root，则表示 next 为空（prev 同理）
    this.nodes = new Map();
};

AllOne.prototype.inc = function(key) {
    if (this.nodes.has(key)) {
        const cur = this.nodes.get(key);
        const nxt = cur.next;
        if (nxt === this.root || nxt.count > cur.count + 1) {
            this.nodes.set(key, cur.insert(new Node(key, cur.count + 1)));
        } else {
            nxt.keys.add(key);
            this.nodes.set(key, nxt);
        }
        cur.keys.delete(key);
        if (cur.keys.size === 0) {
            cur.remove();
        }
    } else {  // key 不在链表中
        if (this.root.next === this.root || this.root.next.count > 1) {
            this.nodes.set(key, this.root.insert(new Node(key, 1)));
        } else {
            this.root.next.keys.add(key);
            this.nodes.set(key, this.root.next);
        }
    }    
};

AllOne.prototype.dec = function(key) {
    const cur = this.nodes.get(key);
    if (cur.count === 1) {  // key 仅出现一次，将其移出 nodes
        this.nodes.delete(key);
    } else {
        const pre = cur.prev;
        if (pre === this.root || pre.count < cur.count - 1) {
            this.nodes.set(key, cur.prev.insert(new Node(key, cur.count - 1)));
        } else {
            pre.keys.add(key);
            this.nodes.set(key, pre);
        }
    }
    cur.keys.delete(key);
    if (cur.keys.size === 0) {
        cur.remove();
    }
};

AllOne.prototype.getMaxKey = function() {
    if (!this.root.prev) {
        return "";
    }
    let maxKey = "";
    for (const key of this.root.prev.keys) {
        maxKey = key;
        break;
    }
    return maxKey;
};

AllOne.prototype.getMinKey = function() {
    if (!this.root.next) {
        return "";
    }
    let minKey = "";
    for (const key of this.root.next.keys) {
        minKey = key;
        break;
    }
    return minKey;
};

class Node {
    constructor(key, count) {
        count ? this.count = count : 0;
        this.keys = new Set();
        key ? this.keys.add(key) : this.keys.add("");
    }

    insert(node) {  // 在 this 后插入 node
        node.prev = this;
        node.next = this.next;
        node.prev.next = node;
        node.next.prev = node;
        return node;
    }

    remove() {
        this.prev.next = this.next;
        this.next.prev = this.prev;
    }
}
```

**复杂度分析**

- 时间复杂度：所有操作均为 $O(1)$，这里将字符串长度视作常数。

- 空间复杂度：$O(I)$，其中 $I$ 是调用 $\text{inc}$ 的次数。最坏情况下每次调用 $\text{inc}$ 传入的字符串均不相同，我们需要 $O(I)$ 大小的哈希表来存储所有字符串。
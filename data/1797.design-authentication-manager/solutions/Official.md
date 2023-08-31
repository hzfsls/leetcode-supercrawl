## [1797.设计一个验证系统 中文官方题解](https://leetcode.cn/problems/design-authentication-manager/solutions/100000/she-ji-yi-ge-yan-zheng-xi-tong-by-leetco-kqqb)

#### 方法一：哈希表

**思路**

按照题意，用一个哈希表 $\textit{map}$ 保存验证码和过期时间。调用 $\textit{generate}$ 时，将验证码-过期时间对直接插入 $\textit{map}$。调用 $\textit{renew}$ 时，如果验证码存在并且未过期，则更新过期时间。调用 $\textit{countUnexpiredTokens}$ 时，遍历整个 $\textit{map}$，统计未过期的验证码的数量。

**代码**

```Python [sol1-Python3]
class AuthenticationManager:
    def __init__(self, timeToLive: int):
        self.ttl = timeToLive
        self.map = {}

    def generate(self, tokenId: str, currentTime: int) -> None:
        self.map[tokenId] = currentTime + self.ttl

    def renew(self, tokenId: str, currentTime: int) -> None:
        if tokenId in self.map and self.map[tokenId] > currentTime:
            self.map[tokenId] = self.ttl + currentTime

    def countUnexpiredTokens(self, currentTime: int) -> int:
        res = 0
        for time in self.map.values():
            if time > currentTime:
                res += 1
        return res
```

```Java [sol1-Java]
class AuthenticationManager {
    int timeToLive;
    Map<String, Integer> map;

    public AuthenticationManager(int timeToLive) {
        this.timeToLive = timeToLive;
        this.map = new HashMap<String, Integer>();
    }

    public void generate(String tokenId, int currentTime) {
        map.put(tokenId, currentTime + timeToLive);
    }

    public void renew(String tokenId, int currentTime) {
        if (map.getOrDefault(tokenId, 0) > currentTime) {
            map.put(tokenId, currentTime + timeToLive);
        }
    }

    public int countUnexpiredTokens(int currentTime) {
        int res = 0;
        for (int time : map.values()) {
            if (time > currentTime) {
                res++;
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class AuthenticationManager {
    int timeToLive;
    IDictionary<string, int> dictionary;

    public AuthenticationManager(int timeToLive) {
        this.timeToLive = timeToLive;
        this.dictionary = new Dictionary<string, int>();
    }

    public void Generate(string tokenId, int currentTime) {
        if (!dictionary.ContainsKey(tokenId)) {
            dictionary.Add(tokenId, currentTime + timeToLive);
        } else {
            dictionary[tokenId] = currentTime + timeToLive;
        }
    }

    public void Renew(string tokenId, int currentTime) {
        if (dictionary.ContainsKey(tokenId) && dictionary[tokenId] > currentTime) {
            dictionary[tokenId] = currentTime + timeToLive;
        }
    }

    public int CountUnexpiredTokens(int currentTime) {
        int res = 0;
        foreach (int time in dictionary.Values) {
            if (time > currentTime) {
                res++;
            }
        }
        return res;
    }
}
```

```JavaScript [sol1-JavaScript]
var AuthenticationManager = function(timeToLive) {
    this.timeToLive = timeToLive;
    this.map = new Map();
};

AuthenticationManager.prototype.generate = function(tokenId, currentTime) {
    this.map.set(tokenId, currentTime + this.timeToLive);
};

AuthenticationManager.prototype.renew = function(tokenId, currentTime) {
    if ((this.map.get(tokenId) || 0) > currentTime) {
        this.map.set(tokenId, currentTime + this.timeToLive);
    }
};

AuthenticationManager.prototype.countUnexpiredTokens = function(currentTime) {
    let res = 0;
    for (const time of this.map.values()) {
        if (time > currentTime) {
            res++;
        }
    }
    return res;
};
```

```C++ [sol1-C++]
class AuthenticationManager {
private:
    int timeToLive;
    unordered_map<string, int> mp;
public:
    AuthenticationManager(int timeToLive) {
        this->timeToLive = timeToLive;
    }

    void generate(string tokenId, int currentTime) {
        mp[tokenId] = currentTime + timeToLive;
    }

    void renew(string tokenId, int currentTime) {
        if (mp.count(tokenId) && mp[tokenId] > currentTime) {
            mp[tokenId] = currentTime + timeToLive;
        }
    }

    int countUnexpiredTokens(int currentTime) {
        int res = 0;
        for (auto &[_, time] : mp) {
            if (time > currentTime) {
                res++;
            }
        }
        return res;
    }
};
```

```C [sol1-C]
typedef struct {
    char *key;
    int val;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, char *key) {
    HashItem *pEntry = NULL;
    HASH_FIND_STR(*obj, key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, char *key, int val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_STR(*obj, key, pEntry);
    return true;
}

bool hashSetItem(HashItem **obj, char *key, int val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        hashAddItem(obj, key, val);
    } else {
        pEntry->val = val;
    }
    return true;
}

int hashGetItem(HashItem **obj, char *key, int defaultVal) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return defaultVal;
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

typedef struct {
    int timeToLive;
    HashItem *map;
} AuthenticationManager;

AuthenticationManager* authenticationManagerCreate(int timeToLive) {
    AuthenticationManager *obj = (AuthenticationManager *)malloc(sizeof(AuthenticationManager));
    obj->timeToLive = timeToLive;
    obj->map = NULL;
    return obj;
}

void authenticationManagerGenerate(AuthenticationManager* obj, char * tokenId, int currentTime) {
    hashAddItem(&obj->map, tokenId, obj->timeToLive + currentTime);
}

void authenticationManagerRenew(AuthenticationManager* obj, char * tokenId, int currentTime) {
    if (hashGetItem(&obj->map, tokenId, 0) > currentTime) {
        hashSetItem(&obj->map, tokenId, currentTime + obj->timeToLive);
    }
}

int authenticationManagerCountUnexpiredTokens(AuthenticationManager* obj, int currentTime) {
    int res = 0;
    HashItem *cur = NULL, *tmp = NULL;
    HASH_ITER(hh, obj->map, cur, tmp) {
        if (cur->val > currentTime) {
            res++;
        }
    }
    return res;
}

void authenticationManagerFree(AuthenticationManager* obj) {
    hashFree(&obj->map);
    free(obj);
}
```

```go [sol1-Golang]
type AuthenticationManager struct {
    mp  map[string]int
    ttl int
}

func Constructor(timeToLive int) AuthenticationManager {
    return AuthenticationManager{map[string]int{}, timeToLive}
}

func (m *AuthenticationManager) Generate(tokenId string, currentTime int) {
    m.mp[tokenId] = currentTime
}

func (m *AuthenticationManager) Renew(tokenId string, currentTime int) {
    if v, ok := m.mp[tokenId]; ok && v+m.ttl > currentTime {
        m.mp[tokenId] = currentTime
    }
}

func (m *AuthenticationManager) CountUnexpiredTokens(currentTime int) (ans int) {
    for _, t := range m.mp {
        if t+m.ttl > currentTime {
            ans++
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：构造函数：$O(1)$，$\textit{generate}$：$O(1)$，$\textit{renew}$：$O(1)$，$\textit{countUnexpiredTokens}$：$O(n)$，其中 $n$ 为 $\textit{generate}$ 的调用次数。

- 空间复杂度：$O(n)$，其中 $n$ 为 $\textit{generate}$ 的调用次数，$\textit{map}$ 中有 $n$ 个元素。

#### 方法二：哈希表 + 双向链表

**思路**

用一个双向链表保存验证码和过期时间的顺序。链表的节点保存验证码和过期时间信息，并且在一条链表上，节点保存的过期时间是递增的。额外用一个哈希表 $\textit{map}$ 来保存验证码-节点对，提供根据验证码来快速访问节点的方法。调用 $\textit{generate}$ 时，新建节点，将节点插入链表末尾，并插入 $\textit{map}$。调用 $\textit{renew}$ 时，如果验证码存在并且未过期，根据 $\textit{map}$ 访问到节点，更新过期时间，并将节点从原来位置移动到链表末尾。调用 $\textit{countUnexpiredTokens}$ 时，从链表头部开始，删除过期的节点，并从 $\textit{map}$ 删除。最后 $\textit{map}$ 的长度就是未过期的验证码的数量。

**代码**

```Python [sol2-Python3]
class AuthenticationManager:
    def __init__(self, timeToLive: int):
        self.ttl = timeToLive
        self.head = Node(-1)
        self.tail = Node(-1)
        self.head.next = self.tail
        self.tail.prev = self.head
        self.map = {}

    def generate(self, tokenId: str, currentTime: int) -> None:
        node = Node(currentTime + self.ttl, tokenId)
        self.map[tokenId] = node
        last = self.tail.prev
        last.next = node
        node.prev = last
        self.tail.prev = node
        node.next = self.tail

    def renew(self, tokenId: str, currentTime: int) -> None:
        if tokenId in self.map and self.map[tokenId].expire > currentTime:
            node = self.map[tokenId]
            prev = node.prev
            next = node.next
            prev.next = next
            next.prev = prev
            node.expire = currentTime + self.ttl
            last = self.tail.prev
            last.next = node
            node.prev = last
            self.tail.prev = node
            node.next = self.tail
        
    def countUnexpiredTokens(self, currentTime: int) -> int:
        while self.head.next.expire != -1 and self.head.next.expire <= currentTime:
            node = self.head.next
            self.map.pop(node.key)
            self.head.next = node.next
            node.next.prev = self.head
        return len(self.map)

class Node:
    def __init__(self, val=0, key=None, prev=None, next=None):
        self.expire = val
        self.key = key
        self.prev = prev
        self.next = next
```

```Java [sol2-Java]
class AuthenticationManager {
    int timeToLive;
    Node head;
    Node tail;
    Map<String, Node> map;

    public AuthenticationManager(int timeToLive) {
        this.timeToLive = timeToLive;
        this.head = new Node(-1);
        this.tail = new Node(-1);
        this.head.next = this.tail;
        this.tail.prev = this.head;
        this.map = new HashMap<String, Node>();
    }

    public void generate(String tokenId, int currentTime) {
        Node node = new Node(currentTime + timeToLive, tokenId);
        map.put(tokenId, node);
        Node last = tail.prev;
        last.next = node;
        node.prev = last;
        tail.prev = node;
        node.next = tail;
    }

    public void renew(String tokenId, int currentTime) {
        if (map.containsKey(tokenId) && map.get(tokenId).expire > currentTime) {
            Node node = map.get(tokenId);
            Node prev = node.prev;
            Node next = node.next;
            prev.next = next;
            next.prev = prev;
            node.expire = currentTime + timeToLive;
            Node last = tail.prev;
            last.next = node;
            node.prev = last;
            tail.prev = node;
            node.next = tail;
        }
    }

    public int countUnexpiredTokens(int currentTime) {
        while (head.next.expire > 0 && head.next.expire <= currentTime) {
            Node node = head.next;
            map.remove(node.key);
            head.next = node.next;
            node.next.prev = head;
        }
        return map.size();
    }
}

class Node {
    int expire;
    String key;
    Node prev;
    Node next;

    public Node(int expire) {
        this(expire, null, null, null);
    }

    public Node(int expire, String key) {
        this(expire, key, null, null);
    }

    public Node(int expire, String key, Node prev, Node next) {
        this.expire = expire;
        this.key = key;
        this.prev = prev;
        this.next = next;
    }
}
```

```C# [sol2-C#]
public class AuthenticationManager {
    int timeToLive;
    Node head;
    Node tail;
    IDictionary<String, Node> dictionary;

    public AuthenticationManager(int timeToLive) {
        this.timeToLive = timeToLive;
        this.head = new Node(-1);
        this.tail = new Node(-1);
        this.head.next = this.tail;
        this.tail.prev = this.head;
        this.dictionary = new Dictionary<String, Node>();
    }

    public void Generate(string tokenId, int currentTime) {
        Node node = new Node(currentTime + timeToLive, tokenId);
        if (!dictionary.ContainsKey(tokenId)) {
            dictionary.Add(tokenId, node);
        } else {
            dictionary[tokenId] = node;
        }
        Node last = tail.prev;
        last.next = node;
        node.prev = last;
        tail.prev = node;
        node.next = tail;
    }

    public void Renew(string tokenId, int currentTime) {
        if (dictionary.ContainsKey(tokenId) && dictionary[tokenId].expire > currentTime) {
            Node node = dictionary[tokenId];
            Node prev = node.prev;
            Node next = node.next;
            prev.next = next;
            next.prev = prev;
            node.expire = currentTime + timeToLive;
            Node last = tail.prev;
            last.next = node;
            node.prev = last;
            tail.prev = node;
            node.next = tail;
        }
    }

    public int CountUnexpiredTokens(int currentTime) {
        while (head.next.expire > 0 && head.next.expire <= currentTime) {
            Node node = head.next;
            dictionary.Remove(node.key);
            head.next = node.next;
            node.next.prev = head;
        }
        return dictionary.Count;
    }
}

class Node {
    public int expire;
    public string key;
    public Node prev;
    public Node next;

    public Node(int expire) : this(expire, null, null, null) {

    }

    public Node(int expire, string key) : this(expire, key, null, null) {

    }

    public Node(int expire, string key, Node prev, Node next) {
        this.expire = expire;
        this.key = key;
        this.prev = prev;
        this.next = next;
    }
}
```

```JavaScript [sol2-JavaScript]
var AuthenticationManager = function(timeToLive) {
    this.timeToLive = timeToLive;
    this.head = new Node(-1);
    this.tail = new Node(-1);
    this.head.next = this.tail;
    this.tail.prev = this.head;
    this.map = new Map();
};

AuthenticationManager.prototype.generate = function(tokenId, currentTime) {
    const node = new Node(currentTime + this.timeToLive, tokenId);
    this.map.set(tokenId, node);
    const last = this.tail.prev;
    last.next = node;
    node.prev = last;
    this.tail.prev = node;
    node.next = this.tail;
};

AuthenticationManager.prototype.renew = function(tokenId, currentTime) {
    if (this.map.has(tokenId) && this.map.get(tokenId).expire > currentTime) {
        const node = this.map.get(tokenId);
        const prev = node.prev;
        const next = node.next;
        prev.next = next;
        next.prev = prev;
        node.expire = currentTime + this.timeToLive;
        const last = this.tail.prev;
        last.next = node;
        node.prev = last;
        this.tail.prev = node;
        node.next = this.tail;
    }
};

AuthenticationManager.prototype.countUnexpiredTokens = function(currentTime) {
    while (this.head.next.expire > 0 && this.head.next.expire <= currentTime) {
        const node = this.head.next;
        this.map.delete(node.key);
        this.head.next = node.next;
        node.next.prev = this.head;
    }
    return this.map.size;
};

class Node {
    constructor(expire, key, prev, next) {
        this.expire = expire;
        this.key = key;
        this.prev = prev;
        this.next = next;
    }
}
```

```C++ [sol2-C++]
struct Node {   
public:
    int expire;
    string key;
    Node *prev;
    Node *next;

    Node(int expire_) : expire(expire_), prev(nullptr), next(nullptr) {
    }

    Node(int expire_, string key_) : expire(expire_), key(key_), prev(nullptr), next(nullptr) {
    }

    Node(int expire_, string key_, Node *prev_, Node *next_) : expire(expire_), key(key_), prev(prev_), next(next_) {
    }
};

class AuthenticationManager {
private:
    int timeToLive;
    Node *head;
    Node *tail;
    unordered_map<string, Node*> mp;
public:
    AuthenticationManager(int timeToLive) {
        this->timeToLive = timeToLive;
        this->head = new Node(-1);
        this->tail = new Node(-1);
        this->head->next = this->tail;
        this->tail->prev = this->head;
    }
    
    void generate(string tokenId, int currentTime) {
        Node *node = new Node(currentTime + timeToLive, tokenId);
        mp[tokenId] = node;
        Node *last = tail->prev;
        last->next = node;
        node->prev = last;
        tail->prev = node;
        node->next = tail;
    }
    
    void renew(string tokenId, int currentTime) {
        if (mp.count(tokenId) && mp[tokenId]->expire > currentTime) {
            Node *node = mp[tokenId];
            Node *prev = node->prev;
            Node *next = node->next;
            prev->next = next;
            next->prev = prev;
            node->expire = currentTime + timeToLive;
            Node *last = tail->prev;
            last->next = node;
            node->prev = last;
            tail->prev = node;
            node->next = tail;
        }
    }
    
    int countUnexpiredTokens(int currentTime) {
        while (head->next->expire > 0 && head->next->expire <= currentTime) {
            Node *node = head->next;
            mp.erase(node->key);
            head->next = node->next;
            node->next->prev = head;
            delete node;
        }
        return mp.size();
    }
};
```

```C [sol2-C]
typedef struct Node {
    int expire;
    char *key;
    struct Node *prev;
    struct Node *next;
} Node;

typedef struct {
    char *key;
    Node *val;
    UT_hash_handle hh;
} HashItem; 

typedef struct {
    int timeToLive;
    Node *head;
    Node *tail;
    HashItem *map;
} AuthenticationManager;

HashItem *hashFindItem(HashItem **obj, const char *key) {
    HashItem *pEntry = NULL;
    HASH_FIND_STR(*obj, key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, char *key, Node *val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_STR(*obj, key, pEntry);
    return true;
}

Node* hashGetItem(HashItem **obj, const char *key, Node *defaultVal) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return defaultVal;
    }
    return pEntry->val;
}

void hashEraseItem(HashItem **obj, const char *key) {
    HashItem *pEntry = hashFindItem(obj, key);
    HASH_DEL(*obj, pEntry);
    free(pEntry);      
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);             
    }
}

Node *nodeCreate(int expire, char *key, Node *prev, Node *next) {
    Node *obj = (Node *)malloc(sizeof(Node));
    obj->expire = expire;
    obj->key = key;
    obj->prev = prev;
    obj->next = next;
    return obj;
}

void nodeFree(Node *obj) {
    free(obj);
}

AuthenticationManager* authenticationManagerCreate(int timeToLive) {
    AuthenticationManager *obj = (AuthenticationManager *)malloc(sizeof(AuthenticationManager));
    obj->timeToLive = timeToLive;
    obj->head = nodeCreate(-1, "", NULL, NULL);
    obj->tail = nodeCreate(-1, "", NULL, NULL);
    obj->head->next = obj->tail;
    obj->tail->prev = obj->head;
    obj->map = NULL;
    return obj;
}

void authenticationManagerGenerate(AuthenticationManager* obj, char * tokenId, int currentTime) {
    Node *node = nodeCreate(currentTime + obj->timeToLive, tokenId, NULL, NULL);
    hashAddItem(&obj->map, tokenId, node);
    Node *last = obj->tail->prev;
    last->next = node;
    node->prev = last;
    obj->tail->prev = node;
    node->next = obj->tail;
}

void authenticationManagerRenew(AuthenticationManager* obj, char * tokenId, int currentTime) {
    Node *node = hashGetItem(&obj->map, tokenId, NULL);
    if (node && node->expire > currentTime) {
        Node *prev = node->prev;
        Node *next = node->next;
        prev->next = next;
        next->prev = prev;
        node->expire = currentTime + obj->timeToLive;
        Node *last = obj->tail->prev;
        last->next = node;
        node->prev = last;
        obj->tail->prev = node;
        node->next = obj->tail;
    }
}

int authenticationManagerCountUnexpiredTokens(AuthenticationManager* obj, int currentTime) {
    while (obj->head->next->expire > 0 && obj->head->next->expire <= currentTime) {
        Node *node = obj->head->next;
        hashEraseItem(&obj->map, node->key);
        obj->head->next = node->next;
        node->next->prev = obj->head;
        nodeFree(node);
    }
    return HASH_COUNT(obj->map);
}

void authenticationManagerFree(AuthenticationManager* obj) {
    hashFree(&obj->map);
    Node *cur = obj->head;
    while (cur) {
        Node *tmp = cur;
        cur = cur->next;
        free(tmp);
    }
    free(obj);
}
```

**复杂度分析**

- 时间复杂度：构造函数：$O(1)$，$\textit{generate}$：$O(1)$，$\textit{renew}$：$O(1)$，所有 $\textit{countUnexpiredTokens}$ 的调用加起来的复杂度是 $O(n)$，其中 $n$ 为 $\textit{generate}$ 的总调用次数。

- 空间复杂度：$O(n)$，其中 $n$ 为 $\textit{generate}$ 的调用次数，$\textit{map}$ 和链表中有 $n$ 个元素。
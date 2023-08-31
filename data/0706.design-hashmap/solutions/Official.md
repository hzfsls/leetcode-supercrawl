## [706.设计哈希映射 中文官方题解](https://leetcode.cn/problems/design-hashmap/solutions/100000/she-ji-ha-xi-ying-she-by-leetcode-soluti-klu9)
#### 方法一：链地址法

我们假定读者已经完成了「[705. 设计哈希集合](https://leetcode-cn.com/problems/design-hashset/)」这一题目。

「设计哈希映射」与「设计哈希集合」解法接近，唯一的区别在于我们存储的不是 $\textit{key}$ 本身，而是 $(\textit{key}, \textit{value})$ 对。除此之外，代码基本是类似的。

```C++ [sol1-C++]
class MyHashMap {
private:
    vector<list<pair<int, int>>> data;
    static const int base = 769;
    static int hash(int key) {
        return key % base;
    }
public:
    /** Initialize your data structure here. */
    MyHashMap(): data(base) {}
    
    /** value will always be non-negative. */
    void put(int key, int value) {
        int h = hash(key);
        for (auto it = data[h].begin(); it != data[h].end(); it++) {
            if ((*it).first == key) {
                (*it).second = value;
                return;
            }
        }
        data[h].push_back(make_pair(key, value));
    }
    
    /** Returns the value to which the specified key is mapped, or -1 if this map contains no mapping for the key */
    int get(int key) {
        int h = hash(key);
        for (auto it = data[h].begin(); it != data[h].end(); it++) {
            if ((*it).first == key) {
                return (*it).second;
            }
        }
        return -1;
    }
    
    /** Removes the mapping of the specified value key if this map contains a mapping for the key */
    void remove(int key) {
        int h = hash(key);
        for (auto it = data[h].begin(); it != data[h].end(); it++) {
            if ((*it).first == key) {
                data[h].erase(it);
                return;
            }
        }
    }
};
```

```Java [sol1-Java]
class MyHashMap {
    private class Pair {
        private int key;
        private int value;

        public Pair(int key, int value) {
            this.key = key;
            this.value = value;
        }

        public int getKey() {
            return key;
        }

        public int getValue() {
            return value;
        }

        public void setValue(int value) {
            this.value = value;
        }
    }

    private static final int BASE = 769;
    private LinkedList[] data;

    /** Initialize your data structure here. */
    public MyHashMap() {
        data = new LinkedList[BASE];
        for (int i = 0; i < BASE; ++i) {
            data[i] = new LinkedList<Pair>();
        }
    }
    
    /** value will always be non-negative. */
    public void put(int key, int value) {
        int h = hash(key);
        Iterator<Pair> iterator = data[h].iterator();
        while (iterator.hasNext()) {
            Pair pair = iterator.next();
            if (pair.getKey() == key) {
                pair.setValue(value);
                return;
            }
        }
        data[h].offerLast(new Pair(key, value));
    }
    
    /** Returns the value to which the specified key is mapped, or -1 if this map contains no mapping for the key */
    public int get(int key) {
        int h = hash(key);
        Iterator<Pair> iterator = data[h].iterator();
        while (iterator.hasNext()) {
            Pair pair = iterator.next();
            if (pair.getKey() == key) {
                return pair.value;
            }
        }
        return -1;
    }
    
    /** Removes the mapping of the specified value key if this map contains a mapping for the key */
    public void remove(int key) {
        int h = hash(key);
        Iterator<Pair> iterator = data[h].iterator();
        while (iterator.hasNext()) {
            Pair pair = iterator.next();
            if (pair.key == key) {
                data[h].remove(pair);
                return;
            }
        }
    }

    private static int hash(int key) {
        return key % BASE;
    }
}
```

```go [sol1-Golang]
const base = 769

type entry struct {
    key, value int
}

type MyHashMap struct {
    data []list.List
}

func Constructor() MyHashMap {
    return MyHashMap{make([]list.List, base)}
}

func (m *MyHashMap) hash(key int) int {
    return key % base
}

func (m *MyHashMap) Put(key, value int) {
    h := m.hash(key)
    for e := m.data[h].Front(); e != nil; e = e.Next() {
        if et := e.Value.(entry); et.key == key {
            e.Value = entry{key, value}
            return
        }
    }
    m.data[h].PushBack(entry{key, value})
}

func (m *MyHashMap) Get(key int) int {
    h := m.hash(key)
    for e := m.data[h].Front(); e != nil; e = e.Next() {
        if et := e.Value.(entry); et.key == key {
            return et.value
        }
    }
    return -1
}

func (m *MyHashMap) Remove(key int) {
    h := m.hash(key)
    for e := m.data[h].Front(); e != nil; e = e.Next() {
        if e.Value.(entry).key == key {
            m.data[h].Remove(e)
        }
    }
}
```

```JavaScript [sol1-JavaScript]
var MyHashMap = function() {
    this.BASE = 769;
    this.data = new Array(this.BASE).fill(0).map(() => new Array());
};

MyHashMap.prototype.put = function(key, value) {
    const h = this.hash(key);
    for (const it of this.data[h]) {
        if (it[0] === key) {
            it[1] = value;
            return;
        }
    }
    this.data[h].push([key, value]);
};

MyHashMap.prototype.get = function(key) {
    const h = this.hash(key);
    for (const it of this.data[h]) {
        if (it[0] === key) {
            return it[1];
        }
    }
    return -1;
};

MyHashMap.prototype.remove = function(key) {
    const h = this.hash(key);
    for (const it of this.data[h]) {
        if (it[0] === key) {
            const idx = this.data[h].indexOf(it);
            this.data[h].splice(idx, 1);
            return;
        }
    }
};

MyHashMap.prototype.hash = function(key) {
    return key % this.BASE;
}
```

```C [sol1-C]
struct List {
    int key;
    int val;
    struct List* next;
};

void listPush(struct List* head, int key, int val) {
    struct List* tmp = malloc(sizeof(struct List));
    tmp->key = key;
    tmp->val = val;
    tmp->next = head->next;
    head->next = tmp;
}

void listDelete(struct List* head, int key) {
    for (struct List* it = head; it->next; it = it->next) {
        if (it->next->key == key) {
            struct List* tmp = it->next;
            it->next = tmp->next;
            free(tmp);
            break;
        }
    }
}

struct List* listFind(struct List* head, int key) {
    for (struct List* it = head; it->next; it = it->next) {
        if (it->next->key == key) {
            return it->next;
        }
    }
    return NULL;
}

void listFree(struct List* head) {
    while (head->next) {
        struct List* tmp = head->next;
        head->next = tmp->next;
        free(tmp);
    }
}

const int base = 769;

int hash(int key) {
    return key % base;
}

typedef struct {
    struct List* data;
} MyHashMap;

MyHashMap* myHashMapCreate() {
    MyHashMap* ret = malloc(sizeof(MyHashMap));
    ret->data = malloc(sizeof(struct List) * base);
    for (int i = 0; i < base; i++) {
        ret->data[i].key = 0;
        ret->data[i].val = 0;
        ret->data[i].next = NULL;
    }
    return ret;
}

void myHashMapPut(MyHashMap* obj, int key, int value) {
    int h = hash(key);
    struct List* rec = listFind(&(obj->data[h]), key);
    if (rec == NULL) {
        listPush(&(obj->data[h]), key, value);
    } else {
        rec->val = value;
    }
}

int myHashMapGet(MyHashMap* obj, int key) {
    int h = hash(key);
    struct List* rec = listFind(&(obj->data[h]), key);
    if (rec == NULL) {
        return -1;
    } else {
        return rec->val;
    }
}

void myHashMapRemove(MyHashMap* obj, int key) {
    int h = hash(key);
    listDelete(&(obj->data[h]), key);
}

void myHashMapFree(MyHashMap* obj) {
    for (int i = 0; i < base; i++) {
        listFree(&(obj->data[i]));
    }
    free(obj->data);
}
```

**复杂度分析**

- 时间复杂度：$O(\frac{n}{b})$。其中 $n$ 为哈希表中的元素数量，$b$ 为链表的数量。假设哈希值是均匀分布的，则每个链表大概长度为 $\frac{n}{b}$。

- 空间复杂度：$O(n+b)$。
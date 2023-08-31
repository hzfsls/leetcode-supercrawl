## [677.键值映射 中文官方题解](https://leetcode.cn/problems/map-sum-pairs/solutions/100000/jian-zhi-ying-she-by-leetcode-solution-j4xy)
#### 方法一：暴力扫描

**思路与算法**

我们将所有的 $\texttt{key-val}$ 键值进行存储，每次需要搜索给定的前缀 $\textit{prefix}$ 时，我们依次搜索所有的键值。如果键值包含给定的前缀，则我们将其 $\textit{val}$ 进行相加，返回所有符合要求的 $\textit{val}$ 的和。

**代码**

```C++ [sol1-C++]
class MapSum {
public:
    MapSum() {

    }
    
    void insert(string key, int val) {
        cnt[key] = val;
    }
    
    int sum(string prefix) {
        int res = 0;
        for (auto & [key,val] : cnt) {
            if (key.substr(0, prefix.size()) == prefix) {
                res += val;
            }
        }
        return res;
    }
private:
    unordered_map<string, int> cnt;
};
```

```Java [sol1-Java]
class MapSum {
    Map<String, Integer> map;

    public MapSum() {
        map = new HashMap<>();
    }
    
    public void insert(String key, int val) {
        map.put(key,val);
    }
    
    public int sum(String prefix) {
        int res = 0;
        for (String s : map.keySet()) {
            if (s.startsWith(prefix)) {
                res += map.get(s);
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class MapSum {
    Dictionary<string, int> dictionary;

    public MapSum() {
        dictionary = new Dictionary<string, int>();
    }
    
    public void Insert(string key, int val) {
        if (dictionary.ContainsKey(key)) {
            dictionary[key] = val;
        } else {
            dictionary.Add(key, val);
        }
    }
    
    public int Sum(string prefix) {
        int res = 0;
        foreach (KeyValuePair<string, int> pair in dictionary) {
            if (pair.Key.StartsWith(prefix)) {
                res += pair.Value;
            }
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class MapSum:
    def __init__(self):
        self.map = {}

    def insert(self, key: str, val: int) -> None:
        self.map[key] = val

    def sum(self, prefix: str) -> int:
        res = 0
        for key,val in self.map.items():
            if key.startswith(prefix):
                res += val
        return res
```

```JavaScript [sol1-JavaScript]
var MapSum = function() {
    this.map = new Map();

};

MapSum.prototype.insert = function(key, val) {
    this.map.set(key, val);
};

MapSum.prototype.sum = function(prefix) {
    let res = 0;
    for (const s of this.map.keys()) {
        if (s.startsWith(prefix)) {
            res += this.map.get(s);
        }
    }
    return res;
};
```

```go [sol1-Golang]
type MapSum map[string]int

func Constructor() MapSum {
    return MapSum{}
}

func (m MapSum) Insert(key string, val int) {
    m[key] = val
}

func (m MapSum) Sum(prefix string) (sum int) {
    for s, v := range m {
        if strings.HasPrefix(s, prefix) {
            sum += v
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$\texttt{insert}$ 操作时间复杂度为 $O(1)$。$\texttt{sum}$ 操作时间复杂度为 $O(NM)$，其中 $N$ 是插入的 $\textit{key}$ 的数目，$M$ 是给定前缀 $\textit{prefix}$ 的长度。

- 空间复杂度：$O(NM)$，其中 $N$ 是插入的 $\textit{key}$ 的数目，$M$ 是字符串 $\textit{key}$ 的最大长度。

#### 方法二：前缀哈希映射

**思路与算法**

我们可以用哈希表存储所有可能前缀的值。当我们得到一个新的 $\texttt{key-val}$ 键值，我们将 $\textit{key}$ 的每个前缀 $\textit{prefix}[i]$ 都在哈希表中进行存储，我们需要更新每个前缀 $\textit{prefix}[i]$ 对应的值。我们计算出它对应的值的增加为 $\textit{delta}$，计算方式如下：
+ 如果键 $\textit{key}$ 不存在，则此时 $\textit{delta}$ 等于 $\textit{val}$。
+ 如果键 $\textit{key}$ 存在，则此时键 $\textit{key}$ 对应得前缀的值都增加 $\textit{val} - \textit{map}[\textit{key}]$，其中 $\textit{map}[\textit{key}]$ 表示键 $\textit{key}$ 当前对应的值。
+ 我们在完成前缀的值改写后，同时要更新键 $\textit{key}$ 对应的值为 $\textit{val}$。

求 $\texttt{sum}$ 时,我们直接利用哈希表查找给定的前缀对应的值即可。

**代码**

```C++ [sol2-C++]
class MapSum {
public:
    MapSum() {

    }
    
    void insert(string key, int val) {
        int delta = val;
        if (map.count(key)) {
            delta -= map[key];
        }
        map[key] = val;
        for (int i = 1; i <= key.size(); ++i) {
            prefixmap[key.substr(0, i)] += delta;
        }
    }
    
    int sum(string prefix) {
        return prefixmap[prefix];
    }
private:
    unordered_map<string, int> map;
    unordered_map<string, int> prefixmap;
};
```

```Java [sol2-Java]
class MapSum {
    Map<String, Integer> map;
    Map<String, Integer> prefixmap;

    public MapSum() {
        map = new HashMap<>();
        prefixmap = new HashMap<>();
    }
    
    public void insert(String key, int val) {
        int delta = val - map.getOrDefault(key, 0);
        map.put(key, val);
        for (int i = 1; i <= key.length(); ++i) {
            String currprefix = key.substring(0, i);
            prefixmap.put(currprefix, prefixmap.getOrDefault(currprefix, 0) + delta);
        }
    }
    
    public int sum(String prefix) {
        return prefixmap.getOrDefault(prefix, 0);
    }
}
```

```C# [sol2-C#]
public class MapSum {
    Dictionary<string, int> dictionary;
    Dictionary<string, int> prefixDictionary;

    public MapSum() {
        dictionary = new Dictionary<string, int>();
        prefixDictionary = new Dictionary<string, int>();
    }
    
    public void Insert(string key, int val) {
        int delta = val;
        if (dictionary.ContainsKey(key)) {
            delta -= dictionary[key];
            dictionary[key] = val;
        } else {
            dictionary.Add(key, val);
        }
        for (int i = 1; i <= key.Length; ++i) {
            string currprefix = key.Substring(0, i);
            if (prefixDictionary.ContainsKey(currprefix)) {
                prefixDictionary[currprefix] += delta;
            } else {
                prefixDictionary.Add(currprefix, delta);
            }
        }
    }
    
    public int Sum(string prefix) {
        return prefixDictionary.ContainsKey(prefix) ? prefixDictionary[prefix] : 0;
    }
}
```

```Python [sol2-Python3]
class MapSum:
    def __init__(self):
        self.map = {}
        self.prefixmap = {}

    def insert(self, key: str, val: int) -> None:
        delta = val
        if key in self.map:
            delta -= self.map[key]
        self.map[key] = val
        for i in range(len(key)):
            currprefix = key[0:i+1]
            if currprefix in self.prefixmap:
                self.prefixmap[currprefix] += delta
            else:
                self.prefixmap[currprefix] = delta

    def sum(self, prefix: str) -> int:
        if prefix in self.prefixmap:
            return self.prefixmap[prefix]
        else:
            return 0
```

```JavaScript [sol2-JavaScript]
var MapSum = function() {
    this.map = new Map();
    this.prefixmap = new Map();

};

MapSum.prototype.insert = function(key, val) {
    const delta = val - (this.map.get(key) || 0);
    this.map.set(key, val);
    for (let i = 1; i <= key.length; ++i) {
        const currprefix = key.substring(0, i);
        this.prefixmap.set(currprefix, (this.prefixmap.get(currprefix) || 0) + delta);
    }
};

MapSum.prototype.sum = function(prefix) {
    return this.prefixmap.get(prefix) || 0;
};
```

```go [sol2-Golang]
type MapSum struct {
    m, pre map[string]int
}

func Constructor() MapSum {
    return MapSum{map[string]int{}, map[string]int{}}
}

func (m *MapSum) Insert(key string, val int) {
    delta := val
    if m.m[key] > 0 {
        delta -= m.m[key]
    }
    m.m[key] = val
    for i := range key {
        m.pre[key[:i+1]] += delta
    }
}

func (m *MapSum) Sum(prefix string) int {
    return m.pre[prefix]
}
```

**复杂度分析**

- 时间复杂度：$\texttt{insert}$ 操作时间复杂度为 $O(N^2)$，其中 $N$ 是插入的字符串 $\textit{key}$ 的长度，我们需要把字符串的所有前缀都在哈希表中插入一次。$\texttt{sum}$ 操作时间复杂度为 $O(1)$。

- 空间复杂度：$O(MN)$，其中 $M$ 表示 $\texttt{key-val}$ 键值的数目，$N$ 表示字符串 $\textit{key}$ 的最大长度，由于我们需要用哈希表存储所有的 $\textit{key}$ 的前缀，每个字符串 $\textit{key}$ 最多有 $N$ 个前缀，因此空间复杂度为$O(MN)$。

#### 方法三：字典树

**思路与算法**

由于我们要处理前缀，自然而然联想到可以用 $\textit{Trie}$（前缀树）来处理此问题。处理方法跟方法二的原理一样，我们直接在前缀对应的 $\textit{Trie}$ 的每个节点存储该前缀对应的值。
+ $\texttt{insert}$ 操作：原理与方法二一样，我们首先求出前缀对应的值的改变 $\textit{delta}$，我们直接在 $\textit{Trie}$ 节点上更新键 $\textit{key}$ 的每个前缀对应的值。
+ $\texttt{sum}$ 操作: 我们直接在前缀树上搜索该给定的前缀对应的值即可，如果给定的前缀不在前缀树中，则返回 $0$。
当然在实际中我们也可以在 $\textit{Trie}$ 的节点只存储键 $\textit{key}$ 对应的 $\textit{val}$, 每次求 $\texttt{sum}$ 时利用 $\textit{DFS}$ 或者 $\textit{BFS}$ 遍历前缀树的子树即可。

**代码**

```C++ [sol3-C++]
struct TrieNode {
    int val;
    TrieNode * next[26];
    TrieNode() {
        this->val = 0;
        for (int i = 0; i < 26; ++i) {
            this->next[i] = nullptr;
        }
    }
};

class MapSum {
public:
    MapSum() {
        this->root = new TrieNode();
    }
    
    void insert(string key, int val) {
        int delta = val;
        if (cnt.count(key)) {
            delta -= cnt[key];
        }
        cnt[key] = val;
        TrieNode * node = root;
        for (auto c : key) {
            if (node->next[c - 'a'] == nullptr) {
                node->next[c - 'a'] = new TrieNode();
            }
            node = node->next[c - 'a'];
            node->val += delta;
        }
    }
    
    int sum(string prefix) {
        TrieNode * node = root;
        for (auto c : prefix) {
            if (node->next[c - 'a'] == nullptr) {
                return 0;
            } else {
                node = node->next[c - 'a'];
            }
        }
        return node->val;
    }
private:
    TrieNode * root;
    unordered_map<string, int> cnt;
};
```

```Java [sol3-Java]
class MapSum {
    class TrieNode {
        int val = 0;
        TrieNode[] next = new TrieNode[26];
    }

    TrieNode root;
    Map<String, Integer> map;

    public MapSum() {
        root = new TrieNode();
        map = new HashMap<>();
    }
    
    public void insert(String key, int val) {        
        int delta = val - map.getOrDefault(key, 0);
        map.put(key, val);
        TrieNode node = root;
        for (char c : key.toCharArray()) {
            if (node.next[c - 'a'] == null) {
                node.next[c - 'a'] = new TrieNode();
            }
            node = node.next[c - 'a'];
            node.val += delta;
        }
    }
    
    public int sum(String prefix) {
        TrieNode node = root;
        for (char c : prefix.toCharArray()) {
            if (node.next[c - 'a'] == null) {
                return 0;
            }
            node = node.next[c - 'a'];
        }
        return node.val;
    }
}
```

```C# [sol3-C#]
public class MapSum {
    class TrieNode {
        public int val = 0;
        public TrieNode[] next = new TrieNode[26];
    }

    TrieNode root;
    Dictionary<string, int> dictionary;

    public MapSum() {
        root = new TrieNode();
        dictionary = new Dictionary<string, int>();
    }
    
    public void Insert(string key, int val) {
        int delta = val;
        if (dictionary.ContainsKey(key)) {
            delta -= dictionary[key];
            dictionary[key] = val;
        } else {
            dictionary.Add(key, val);
        }
        TrieNode node = root;
        foreach (char c in key) {
            if (node.next[c - 'a'] == null) {
                node.next[c - 'a'] = new TrieNode();
            }
            node = node.next[c - 'a'];
            node.val += delta;
        }
    }
    
    public int Sum(string prefix) {
        TrieNode node = root;
        foreach (char c in prefix) {
            if (node.next[c - 'a'] == null) {
                return 0;
            }
            node = node.next[c - 'a'];
        }
        return node.val;
    }
}
```

```Python [sol3-Python3]
class TrieNode:
    def __init__(self):
        self.val = 0
        self.next = [None for _ in range(26)]

class MapSum:
    def __init__(self):
        self.root = TrieNode()
        self.map = {}

    def insert(self, key: str, val: int) -> None:
        delta = val
        if key in self.map:
            delta -= self.map[key]
        self.map[key] = val
        node = self.root
        for c in key:
            if node.next[ord(c) - ord('a')] is None:
                node.next[ord(c) - ord('a')] = TrieNode()
            node = node.next[ord(c) - ord('a')]
            node.val += delta

    def sum(self, prefix: str) -> int:
        node = self.root
        for c in prefix:
            if node.next[ord(c) - ord('a')] is None:
                return 0            
            node = node.next[ord(c) - ord('a')]
        return node.val
```

```JavaScript [sol3-JavaScript]
class TrieNode {
    constructor() {
        this.val = 0;
        this.next = new Array(26).fill(0);
    }
}

var MapSum = function() {
    this.root = new TrieNode();
    this.map = new Map();

};

MapSum.prototype.insert = function(key, val) {
    const delta = val - (this.map.get(key) || 0);
    this.map.set(key, val);
    let node = this.root;
    for (const c of key) {
        if (node.next[c.charCodeAt() - 'a'.charCodeAt()] === 0) {
            node.next[c.charCodeAt() - 'a'.charCodeAt()] = new TrieNode();
        }
        node = node.next[c.charCodeAt() - 'a'.charCodeAt()];
        node.val += delta;
    }
};

MapSum.prototype.sum = function(prefix) {
    let node = this.root;
    for (const c of prefix) {
        if (node.next[c.charCodeAt() - 'a'.charCodeAt()] === 0) {
            return 0;
        }
        node = node.next[c.charCodeAt() - 'a'.charCodeAt()];
    }
    return node.val;
};
```

```go [sol3-Golang]
type TrieNode struct {
    children [26]*TrieNode
    val      int
}

type MapSum struct {
    root *TrieNode
    cnt  map[string]int
}

func Constructor() MapSum {
    return MapSum{&TrieNode{}, map[string]int{}}
}

func (m *MapSum) Insert(key string, val int) {
    delta := val
    if m.cnt[key] > 0 {
        delta -= m.cnt[key]
    }
    m.cnt[key] = val
    node := m.root
    for _, ch := range key {
        ch -= 'a'
        if node.children[ch] == nil {
            node.children[ch] = &TrieNode{}
        }
        node = node.children[ch]
        node.val += delta
    }
}

func (m *MapSum) Sum(prefix string) int {
    node := m.root
    for _, ch := range prefix {
        ch -= 'a'
        if node.children[ch] == nil {
            return 0
        }
        node = node.children[ch]
    }
    return node.val
}
```

**复杂度分析**

- 时间复杂度：$\texttt{insert}$ 操作时间复杂度为 $O(N)$，其中 $N$ 是插入的字符串 $\textit{key}$ 的长度。$\texttt{sum}$ 操作时间复杂度为 $O(N)$，其中 $O(N)$ 为给定的查询字符的长度，需要在前缀树中搜索给定的前缀。

- 空间复杂度：$O(CNM)$，其中 $M$ 表示 $\texttt{key-val}$ 键值的数目，$N$ 表示字符串 $\textit{key}$ 的最大长度，$C$ 为常数。
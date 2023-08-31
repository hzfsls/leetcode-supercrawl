## [208.实现 Trie (前缀树) 中文官方题解](https://leetcode.cn/problems/implement-trie-prefix-tree/solutions/100000/shi-xian-trie-qian-zhui-shu-by-leetcode-ti500)
#### 方法一：字典树

$\text{Trie}$，又称前缀树或字典树，是一棵有根树，其每个节点包含以下字段：

- 指向子节点的指针数组 $\textit{children}$。对于本题而言，数组长度为 $26$，即小写英文字母的数量。此时 $\textit{children}[0]$ 对应小写字母 $a$，$\textit{children}[1]$ 对应小写字母 $b$，…，$\textit{children}[25]$ 对应小写字母 $z$。
- 布尔字段 $\textit{isEnd}$，表示该节点是否为字符串的结尾。

**插入字符串**

我们从字典树的根开始，插入字符串。对于当前字符对应的子节点，有两种情况：

- 子节点存在。沿着指针移动到子节点，继续处理下一个字符。
- 子节点不存在。创建一个新的子节点，记录在 $\textit{children}$ 数组的对应位置上，然后沿着指针移动到子节点，继续搜索下一个字符。

重复以上步骤，直到处理字符串的最后一个字符，然后将当前节点标记为字符串的结尾。

**查找前缀**

我们从字典树的根开始，查找前缀。对于当前字符对应的子节点，有两种情况：

- 子节点存在。沿着指针移动到子节点，继续搜索下一个字符。
- 子节点不存在。说明字典树中不包含该前缀，返回空指针。

重复以上步骤，直到返回空指针或搜索完前缀的最后一个字符。

若搜索到了前缀的末尾，就说明字典树中存在该前缀。此外，若前缀末尾对应节点的 $\textit{isEnd}$ 为真，则说明字典树中存在该字符串。

**代码**

```C++ [sol1-C++]
class Trie {
private:
    vector<Trie*> children;
    bool isEnd;

    Trie* searchPrefix(string prefix) {
        Trie* node = this;
        for (char ch : prefix) {
            ch -= 'a';
            if (node->children[ch] == nullptr) {
                return nullptr;
            }
            node = node->children[ch];
        }
        return node;
    }

public:
    Trie() : children(26), isEnd(false) {}

    void insert(string word) {
        Trie* node = this;
        for (char ch : word) {
            ch -= 'a';
            if (node->children[ch] == nullptr) {
                node->children[ch] = new Trie();
            }
            node = node->children[ch];
        }
        node->isEnd = true;
    }

    bool search(string word) {
        Trie* node = this->searchPrefix(word);
        return node != nullptr && node->isEnd;
    }

    bool startsWith(string prefix) {
        return this->searchPrefix(prefix) != nullptr;
    }
};
```

```Java [sol1-Java]
class Trie {
    private Trie[] children;
    private boolean isEnd;

    public Trie() {
        children = new Trie[26];
        isEnd = false;
    }
    
    public void insert(String word) {
        Trie node = this;
        for (int i = 0; i < word.length(); i++) {
            char ch = word.charAt(i);
            int index = ch - 'a';
            if (node.children[index] == null) {
                node.children[index] = new Trie();
            }
            node = node.children[index];
        }
        node.isEnd = true;
    }
    
    public boolean search(String word) {
        Trie node = searchPrefix(word);
        return node != null && node.isEnd;
    }
    
    public boolean startsWith(String prefix) {
        return searchPrefix(prefix) != null;
    }

    private Trie searchPrefix(String prefix) {
        Trie node = this;
        for (int i = 0; i < prefix.length(); i++) {
            char ch = prefix.charAt(i);
            int index = ch - 'a';
            if (node.children[index] == null) {
                return null;
            }
            node = node.children[index];
        }
        return node;
    }
}
```

```go [sol1-Golang]
type Trie struct {
    children [26]*Trie
    isEnd    bool
}

func Constructor() Trie {
    return Trie{}
}

func (t *Trie) Insert(word string) {
    node := t
    for _, ch := range word {
        ch -= 'a'
        if node.children[ch] == nil {
            node.children[ch] = &Trie{}
        }
        node = node.children[ch]
    }
    node.isEnd = true
}

func (t *Trie) SearchPrefix(prefix string) *Trie {
    node := t
    for _, ch := range prefix {
        ch -= 'a'
        if node.children[ch] == nil {
            return nil
        }
        node = node.children[ch]
    }
    return node
}

func (t *Trie) Search(word string) bool {
    node := t.SearchPrefix(word)
    return node != nil && node.isEnd
}

func (t *Trie) StartsWith(prefix string) bool {
    return t.SearchPrefix(prefix) != nil
}
```

```JavaScript [sol1-JavaScript]
var Trie = function() {
    this.children = {};
};

Trie.prototype.insert = function(word) {
    let node = this.children;
    for (const ch of word) {
        if (!node[ch]) {
            node[ch] = {};
        }
        node = node[ch];
    }
    node.isEnd = true;
};

Trie.prototype.searchPrefix = function(prefix) {
    let node = this.children;
    for (const ch of prefix) {
        if (!node[ch]) {
            return false;
        }
        node = node[ch];
    }
    return node;
}

Trie.prototype.search = function(word) {
    const node = this.searchPrefix(word);
    return node !== undefined && node.isEnd !== undefined;
};

Trie.prototype.startsWith = function(prefix) {
    return this.searchPrefix(prefix);
};
```

```Python [sol1-Python3]
class Trie:
    def __init__(self):
        self.children = [None] * 26
        self.isEnd = False
    
    def searchPrefix(self, prefix: str) -> "Trie":
        node = self
        for ch in prefix:
            ch = ord(ch) - ord("a")
            if not node.children[ch]:
                return None
            node = node.children[ch]
        return node

    def insert(self, word: str) -> None:
        node = self
        for ch in word:
            ch = ord(ch) - ord("a")
            if not node.children[ch]:
                node.children[ch] = Trie()
            node = node.children[ch]
        node.isEnd = True

    def search(self, word: str) -> bool:
        node = self.searchPrefix(word)
        return node is not None and node.isEnd

    def startsWith(self, prefix: str) -> bool:
        return self.searchPrefix(prefix) is not None
```

```C [sol1-C]
typedef struct Trie {
    struct Trie* children[26];
    bool isEnd;
} Trie;

Trie* trieCreate() {
    Trie* ret = malloc(sizeof(Trie));
    memset(ret->children, 0, sizeof(ret->children));
    ret->isEnd = false;
    return ret;
}

void trieInsert(Trie* obj, char* word) {
    int n = strlen(word);
    for (int i = 0; i < n; i++) {
        int ch = word[i] - 'a';
        if (obj->children[ch] == NULL) {
            obj->children[ch] = trieCreate();
        }
        obj = obj->children[ch];
    }
    obj->isEnd = true;
}

bool trieSearch(Trie* obj, char* word) {
    int n = strlen(word);
    for (int i = 0; i < n; i++) {
        int ch = word[i] - 'a';
        if (obj->children[ch] == NULL) {
            return false;
        }
        obj = obj->children[ch];
    }
    return obj->isEnd;
}

bool trieStartsWith(Trie* obj, char* prefix) {
    int n = strlen(prefix);
    for (int i = 0; i < n; i++) {
        int ch = prefix[i] - 'a';
        if (obj->children[ch] == NULL) {
            return false;
        }
        obj = obj->children[ch];
    }
    return true;
}

void trieFree(Trie* obj) {
    for (int i = 0; i < 26; i++) {
        if (obj->children[i]) {
            trieFree(obj->children[i]);
        }
    }
    free(obj);
}
```

**复杂度分析**

- 时间复杂度：初始化为 $O(1)$，其余操作为 $O(|S|)$，其中 $|S|$ 是每次插入或查询的字符串的长度。

- 空间复杂度：$O(|T|\cdot\Sigma)$，其中 $|T|$ 为所有插入字符串的长度之和，$\Sigma$ 为字符集的大小，本题 $\Sigma=26$。
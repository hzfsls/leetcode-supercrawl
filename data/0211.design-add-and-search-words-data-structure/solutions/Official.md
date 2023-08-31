## [211.添加与搜索单词 - 数据结构设计 中文官方题解](https://leetcode.cn/problems/design-add-and-search-words-data-structure/solutions/100000/tian-jia-yu-sou-suo-dan-ci-shu-ju-jie-go-n4ud)
#### 方法一：字典树

**预备知识**

字典树（前缀树）是一种树形数据结构，用于高效地存储和检索字符串数据集中的键。前缀树可以用 $O(|S|)$ 的时间复杂度完成如下操作，其中 $|S|$ 是插入字符串或查询前缀的长度：

- 向字典树中插入字符串 $\textit{word}$；

- 查询字符串 $\textit{word}$ 是否已经插入到字典树中。

字典树的实现可以参考「[208. 实现 Trie (前缀树) 的官方题解](https://leetcode-cn.com/problems/implement-trie-prefix-tree/solution/shi-xian-trie-qian-zhui-shu-by-leetcode-ti500/)」。

**思路和算法**

根据题意，$\texttt{WordDictionary}$ 类需要支持添加单词和搜索单词的操作，可以使用字典树实现。

对于添加单词，将单词添加到字典树中即可。

对于搜索单词，从字典树的根结点开始搜索。由于待搜索的单词可能包含点号，因此在搜索过程中需要考虑点号的处理。对于当前字符是字母和点号的情况，分别按照如下方式处理：

- 如果当前字符是字母，则判断当前字符对应的子结点是否存在，如果子结点存在则移动到子结点，继续搜索下一个字符，如果子结点不存在则说明单词不存在，返回 $\text{false}$；

- 如果当前字符是点号，由于点号可以表示任何字母，因此需要对当前结点的所有非空子结点继续搜索下一个字符。

重复上述步骤，直到返回 $\text{false}$ 或搜索完给定单词的最后一个字符。

如果搜索完给定的单词的最后一个字符，则当搜索到的最后一个结点的 $\textit{isEnd}$ 为 $\text{true}$ 时，给定的单词存在。

特别地，当搜索到点号时，只要存在一个非空子结点可以搜索到给定的单词，即返回 $\text{true}$。

**代码**

```Java [sol1-Java]
class WordDictionary {
    private Trie root;

    public WordDictionary() {
        root = new Trie();
    }
    
    public void addWord(String word) {
        root.insert(word);
    }
    
    public boolean search(String word) {
        return dfs(word, 0, root);
    }

    private boolean dfs(String word, int index, Trie node) {
        if (index == word.length()) {
            return node.isEnd();
        }
        char ch = word.charAt(index);
        if (Character.isLetter(ch)) {
            int childIndex = ch - 'a';
            Trie child = node.getChildren()[childIndex];
            if (child != null && dfs(word, index + 1, child)) {
                return true;
            }
        } else {
            for (int i = 0; i < 26; i++) {
                Trie child = node.getChildren()[i];
                if (child != null && dfs(word, index + 1, child)) {
                    return true;
                }
            }
        }
        return false;
    }
}

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

    public Trie[] getChildren() {
        return children;
    }

    public boolean isEnd() {
        return isEnd;
    }
}
```

```C# [sol1-C#]
public class WordDictionary {
    private Trie root;

    public WordDictionary() {
        root = new Trie();
    }
    
    public void AddWord(string word) {
        root.Insert(word);
    }
    
    public bool Search(string word) {
        return DFS(word, 0, root);
    }

    private bool DFS(String word, int index, Trie node) {
        if (index == word.Length) {
            return node.IsEnd;
        }
        char ch = word[index];
        if (char.IsLetter(ch)) {
            int childIndex = ch - 'a';
            Trie child = node.Children[childIndex];
            if (child != null && DFS(word, index + 1, child)) {
                return true;
            }
        } else {
            for (int i = 0; i < 26; i++) {
                Trie child = node.Children[i];
                if (child != null && DFS(word, index + 1, child)) {
                    return true;
                }
            }
        }
        return false;
    }
}

class Trie {
    public Trie[] Children { get; }
    public bool IsEnd { get; set; }

    public Trie() {
        Children = new Trie[26];
        IsEnd = false;
    }
    
    public void Insert(String word) {
        Trie node = this;
        for (int i = 0; i < word.Length; i++) {
            char ch = word[i];
            int index = ch - 'a';
            if (node.Children[index] == null) {
                node.Children[index] = new Trie();
            }
            node = node.Children[index];
        }
        node.IsEnd = true;
    }
}
```

```C++ [sol1-C++]
struct TrieNode{
    vector<TrieNode *> child;
    bool isEnd;
    TrieNode() {
        this->child = vector<TrieNode *>(26,nullptr);
        this->isEnd = false;
    }
};

void insert(TrieNode * root, const string & word) {
    TrieNode * node = root;
    for (auto c : word) {
        if (node->child[c - 'a'] == nullptr) {
            node->child[c - 'a'] = new TrieNode();
        }
        node = node->child[c - 'a'];
    }
    node->isEnd = true;
}

class WordDictionary {
public:
    WordDictionary() {
        trie = new TrieNode();
    }
    
    void addWord(string word) {
        insert(trie,word);
    }
    
    bool search(string word) {
        return dfs(word, 0, trie);
    }

    bool dfs(const string & word,int index,TrieNode * node) {
　　　　if (index == word.size()) {
            return node->isEnd;    
        }
        char ch = word[index];
        if (ch >= 'a' && ch <= 'z') {
            TrieNode * child = node->child[ch - 'a'];
            if (child != nullptr && dfs(word, index + 1, child)) {
                return true;
            }
        } else if (ch == '.') {
            for (int i = 0; i < 26; i++) {
                TrieNode * child = node->child[i];
                if (child != nullptr && dfs(word, index + 1, child)) {
                    return true;
                }
            }
        }
        return false;
    }
private:
    TrieNode * trie;
};
```

```go [sol1-Golang]
type TrieNode struct {
    children [26]*TrieNode
    isEnd    bool
}

func (t *TrieNode) Insert(word string) {
    node := t
    for _, ch := range word {
        ch -= 'a'
        if node.children[ch] == nil {
            node.children[ch] = &TrieNode{}
        }
        node = node.children[ch]
    }
    node.isEnd = true
}

type WordDictionary struct {
    trieRoot *TrieNode
}

func Constructor() WordDictionary {
    return WordDictionary{&TrieNode{}}
}

func (d *WordDictionary) AddWord(word string) {
    d.trieRoot.Insert(word)
}

func (d *WordDictionary) Search(word string) bool {
    var dfs func(int, *TrieNode) bool
    dfs = func(index int, node *TrieNode) bool {
        if index == len(word) {
            return node.isEnd
        }
        ch := word[index]
        if ch != '.' {
            child := node.children[ch-'a']
            if child != nil && dfs(index+1, child) {
                return true
            }
        } else {
            for i := range node.children {
                child := node.children[i]
                if child != nil && dfs(index+1, child) {
                    return true
                }
            }
        }
        return false
    }
    return dfs(0, d.trieRoot)
}
```

```Python [sol1-Python3]
class TrieNode:
    def __init__(self):
        self.children = [None] * 26
        self.isEnd = False

    def insert(self, word: str) -> None:
        node = self
        for ch in word:
            ch = ord(ch) - ord('a')
            if not node.children[ch]:
                node.children[ch] = TrieNode()
            node = node.children[ch]
        node.isEnd = True


class WordDictionary:
    def __init__(self):
        self.trieRoot = TrieNode()

    def addWord(self, word: str) -> None:
        self.trieRoot.insert(word)

    def search(self, word: str) -> bool:
        def dfs(index: int, node: TrieNode) -> bool:
            if index == len(word):
                return node.isEnd
            ch = word[index]
            if ch != '.':
                child = node.children[ord(ch) - ord('a')]
                if child is not None and dfs(index + 1, child):
                    return True
            else:
                for child in node.children:
                    if child is not None and dfs(index + 1, child):
                        return True
            return False

        return dfs(0, self.trieRoot)
```

```JavaScript [sol1-JavaScript]
var WordDictionary = function() {
    this.trieRoot = new TrieNode();
};

WordDictionary.prototype.addWord = function(word) {
    this.trieRoot.insert(word);
};

WordDictionary.prototype.search = function(word) {
    const dfs = (index, node) => {
        if (index === word.length) {
            return node.isEnd;
        }
        const ch = word[index];
        if (ch !== '.') {
            const child = node.children[ch.charCodeAt() - 'a'.charCodeAt()]
            if (child && dfs(index + 1, child)) {
                return true;
            }
        } else {
            for (const child of node.children) {
                if (child && dfs(index + 1, child)) {
                    return true;
                }
            }
        }
        return false;
    }
    
    return dfs(0, this.trieRoot);
};

class TrieNode {
    constructor() {
        this.children = new Array(26).fill(0);
        this.isEnd = false;
    }

    insert(word) {
        let node = this;
        for (let i = 0; i < word.length; i++) {
            const ch = word[i];
            const index = ch.charCodeAt() - 'a'.charCodeAt();
            if (node.children[index] === 0) {
                node.children[index] = new TrieNode();
            }
            node = node.children[index];
        }
        node.isEnd = true;
    }

    getChildren() {
        return this.children;
    }

    isEnd() {
        return this.isEnd;
    }
}
```

**复杂度分析**

- 时间复杂度：初始化为 $O(1)$，添加单词为 $O(|S|)$，搜索单词为 $O(|\Sigma|^{|S|})$，其中 $|S|$ 是每次添加或搜索的单词的长度，$\Sigma$ 是字符集，这道题中的字符集为全部小写英语字母，$|\Sigma| = 26$。
  最坏情况下，待搜索的单词中的每个字符都是点号，则每个字符都有 $|\Sigma|$ 种可能。

- 空间复杂度：$O(|T|\cdot|\Sigma|)$，其中 $|T|$ 是所有添加的单词的长度之和，$\Sigma$ 是字符集，这道题中的字符集为全部小写英语字母，$|\Sigma| = 26$。
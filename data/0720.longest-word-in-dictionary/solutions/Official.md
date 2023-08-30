#### 方法一：哈希集合

**思路和算法**

定义「符合要求的单词」如下：

- 空字符串是符合要求的单词；

- 在符合要求的单词的末尾添加一个字母，得到的新单词是符合要求的单词。

这道题要求返回数组 $\textit{words}$ 中的最长的符合要求的单词，如果有多个最长的符合要求的单词则返回其中字典序最小的单词。以下将返回值称为「答案」。

为了方便处理，需要将数组 $\textit{words}$ 排序，排序的规则是首先按照单词的长度升序排序，如果单词的长度相同则按照字典序降序排序。排序之后，可以确保当遍历到每个单词时，比该单词短的全部单词都已经遍历过，且每次遇到符合要求的单词一定是最长且字典序最小的单词，可以直接更新答案。

将答案初始化为空字符串。使用哈希集合存储所有符合要求的单词，初始时将空字符串加入哈希集合。遍历数组 $\textit{words}$，对于每个单词，判断当前单词去掉最后一个字母之后的前缀是否在哈希集合中，如果该前缀在哈希集合中则当前单词是符合要求的单词，将当前单词加入哈希集合，并将答案更新为当前单词。

遍历结束之后，返回答案。

**代码**

```Python [sol1-Python3]
class Solution:
    def longestWord(self, words: List[str]) -> str:
        words.sort(key=lambda x: (-len(x), x), reverse=True)
        longest = ""
        candidates = {""}
        for word in words:
            if word[:-1] in candidates:
                longest = word
                candidates.add(word)
        return longest
```

```Java [sol1-Java]
class Solution {
    public String longestWord(String[] words) {
        Arrays.sort(words, (a, b) ->  {
            if (a.length() != b.length()) {
                return a.length() - b.length();
            } else {
                return b.compareTo(a);
            }
        });
        String longest = "";
        Set<String> candidates = new HashSet<String>();
        candidates.add("");
        int n = words.length;
        for (int i = 0; i < n; i++) {
            String word = words[i];
            if (candidates.contains(word.substring(0, word.length() - 1))) {
                candidates.add(word);
                longest = word;
            }
        }
        return longest;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string LongestWord(string[] words) {
        Array.Sort(words, (a, b) =>  {
            if (a.Length != b.Length) {
                return a.Length - b.Length;
            } else {
                return b.CompareTo(a);
            }
        });
        string longest = "";
        ISet<string> candidates = new HashSet<string>();
        candidates.Add("");
        int n = words.Length;
        for (int i = 0; i < n; i++) {
            string word = words[i];
            if (candidates.Contains(word.Substring(0, word.Length - 1))) {
                candidates.Add(word);
                longest = word;
            }
        }
        return longest;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    string longestWord(vector<string> &words) {
        sort(words.begin(), words.end(), [](const string &a, const string &b) {
            return a.size() != b.size() ? a.size() < b.size() : a > b;
        });
        string longest;
        unordered_set<string> candidates = {""};
        for (const auto &word: words) {
            if (candidates.count(word.substr(0, word.size() - 1))) {
                candidates.emplace(word);
                longest = word;
            }
        }
        return longest;
    }
};
```

```C [sol1-C]
#define MAX_STR_LEN 32

typedef struct {
    char * key;
    UT_hash_handle hh;
} HashEntry;

void hashInsert(HashEntry ** obj, const char * str) {
    HashEntry * pEntry = NULL;
    HASH_FIND_STR(*obj, str, pEntry);
    if (NULL == pEntry) {
        pEntry = (HashEntry *)malloc(sizeof(HashEntry));
        pEntry->key = str;
        HASH_ADD_STR(*obj, key, pEntry);
    }
}

bool hashFind(const HashEntry ** obj, const char * str) {
    HashEntry * pEntry = NULL;
    HASH_FIND_STR(*obj, str, pEntry);
    if (NULL == pEntry) {
        return false;
    } else {
        return true;
    }
}

bool hashRelease(HashEntry ** obj) {
    HashEntry * curr = NULL, * next = NULL;
     HASH_ITER(hh, *obj, curr, next) {
      HASH_DEL(*obj, curr);
      free(curr);
    }
    return true;
}

int cmp(const void * a, const void * b) {
    char * pa = *(char **)a;
    char * pb = *(char **)b;
    int la = strlen(pa);
    int lb = strlen(pb);
    if (la != lb) {
        return la - lb;
    } else {
        return strcmp(pb, pa);
    }
}

char * longestWord(char ** words, int wordsSize){
    qsort(words, wordsSize, sizeof(char *), cmp);
    char * longest = "";
    HashEntry * candidates = NULL;
    hashInsert(&candidates, "");
    char str[MAX_STR_LEN] = {0};
    for (int i = 0; i < wordsSize; i++) {
        snprintf(str, strlen(words[i]), "%s", words[i]);
        if (hashFind(&candidates, str)) {
            hashInsert(&candidates, words[i]);
            longest = words[i];
        }
    }
    hashRelease(&candidates);
    return longest;
}
```

```JavaScript [sol1-JavaScript]
var longestWord = function(words) {
    words.sort((a, b) => {
        if (a.length !== b.length) {
            return a.length - b.length;
        } else {
            return b.localeCompare(a);
        }
    })
    let longest = "";
    let candidates = new Set();
    candidates.add("");
    const n = words.length;
    for (let i = 0; i < n; i++) {
        const word = words[i];
        if (candidates.has(word.slice(0, word.length - 1))) {
            candidates.add(word);
            longest = word;
        }
    }
    return longest;
};
```

```go [sol1-Golang]
func longestWord(words []string) (longest string) {
    sort.Slice(words, func(i, j int) bool {
        s, t := words[i], words[j]
        return len(s) < len(t) || len(s) == len(t) && s > t
    })

    candidates := map[string]struct{}{"": {}}
    for _, word := range words {
        if _, ok := candidates[word[:len(word)-1]]; ok {
            longest = word
            candidates[word] = struct{}{}
        }
    }
    return longest
}
```

**复杂度分析**

- 时间复杂度：$O(\sum_{0 \le i < n} l_i \times \log n)$，其中 $n$ 是数组 $\textit{words}$ 的长度，$l_i$ 是单词 $\textit{words}[i]$ 的长度。对数组 $\textit{words}$ 排序最多需要 $O(\sum_{0 \le i < n} l_i \times \log n)$ 的时间，排序后遍历数组 $\textit{words}$ 将单词加入哈希集合并得到答案最多需要 $O(\sum_{0 \le i < n} l_i)$ 的时间。由于在渐进意义下 $O(\sum_{0 \le i < n} l_i)$ 小于 $O(\sum_{0 \le i < n} l_i \times \log n)$，因此时间复杂度是 $O(\sum_{0 \le i < n} l_i \times \log n)$。

- 空间复杂度：$O(\sum_{0 \le i < n} l_i)$，其中 $n$ 是数组 $\textit{words}$ 的长度，$l_i$ 是单词 $\textit{words}[i]$ 的长度。排序需要 $O(\log n)$ 的空间，哈希集合需要 $O(\sum_{0 \le i < n} l_i)$ 的空间，由于在渐进意义下 $O(\log n)$ 小于 $O(\sum_{0 \le i < n} l_i)$，因此空间复杂度是 $O(\sum_{0 \le i < n} l_i)$。

#### 方法二：字典树

**预备知识**

该方法需要使用字典树。如果读者对字典树不了解，建议首先阅读「[208. 实现 Trie (前缀树) 的官方题解](https://leetcode-cn.com/problems/implement-trie-prefix-tree/solution/shi-xian-trie-qian-zhui-shu-by-leetcode-ti500/)」，在理解字典树的实现之后继续阅读。

**思路和算法**

由于符合要求的单词的每个前缀都是符合要求的单词，因此可以使用字典树存储所有符合要求的单词。

创建字典树，遍历数组 $\textit{words}$ 并将每个单词插入字典树。当所有的单词都插入字典树之后，将答案初始化为空字符串，再次遍历数组 $\textit{words}$，判断每个单词是否是符合要求的单词，并更新答案。如果一个单词是符合要求的单词，则比较当前单词与答案，如果当前单词的长度大于答案的长度，或者当前单词的长度等于答案的长度且当前单词的字典序小于答案的字典序，则将答案更新为当前单词。

**代码**

```Python [sol2-Python3]
class Trie:
    def __init__(self):
        self.children = [None] * 26
        self.isEnd = False

    def insert(self, word: str) -> None:
        node = self
        for ch in word:
            ch = ord(ch) - ord('a')
            if not node.children[ch]:
                node.children[ch] = Trie()
            node = node.children[ch]
        node.isEnd = True

    def search(self, word: str) -> bool:
        node = self
        for ch in word:
            ch = ord(ch) - ord('a')
            if node.children[ch] is None or not node.children[ch].isEnd:
                return False
            node = node.children[ch]
        return True

class Solution:
    def longestWord(self, words: List[str]) -> str:
        t = Trie()
        for word in words:
            t.insert(word)
        longest = ""
        for word in words:
            if t.search(word) and (len(word) > len(longest) or len(word) == len(longest) and word < longest):
                longest = word
        return longest
```

```Java [sol2-Java]
class Solution {
    public String longestWord(String[] words) {
        Trie trie = new Trie();
        for (String word : words) {
            trie.insert(word);
        }
        String longest = "";
        for (String word : words) {
            if (trie.search(word)) {
                if (word.length() > longest.length() || (word.length() == longest.length() && word.compareTo(longest) < 0)) {
                    longest = word;
                }
            }
        }
        return longest;
    }
}

class Trie {
    Trie[] children;
    boolean isEnd;

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
        Trie node = this;
        for (int i = 0; i < word.length(); i++) {
            char ch = word.charAt(i);
            int index = ch - 'a';
            if (node.children[index] == null || !node.children[index].isEnd) {
                return false;
            }
            node = node.children[index];
        }
        return node != null && node.isEnd;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public string LongestWord(string[] words) {
        Trie trie = new Trie();
        foreach (string word in words) {
            trie.Insert(word);
        }
        string longest = "";
        foreach (string word in words) {
            if (trie.Search(word)) {
                if (word.Length > longest.Length || (word.Length == longest.Length && word.CompareTo(longest) < 0)) {
                    longest = word;
                }
            }
        }
        return longest;
    }
}

class Trie {
    public Trie[] Children { get; set; }
    public bool IsEnd { get; set; }

    public Trie() {
        Children = new Trie[26];
        IsEnd = false;
    }
    
    public void Insert(string word) {
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
    
    public bool Search(string word) {
        Trie node = this;
        for (int i = 0; i < word.Length; i++) {
            char ch = word[i];
            int index = ch - 'a';
            if (node.Children[index] == null || !node.Children[index].IsEnd) {
                return false;
            }
            node = node.Children[index];
        }
        return node != null && node.IsEnd;
    }
}
```

```C++ [sol2-C++]
class Trie {
public:
    Trie() {
        this->children = vector<Trie *>(26, nullptr);
        this->isEnd = false;
    }
    
    bool insert(const string & word) {
        Trie * node = this;
        for (const auto & ch : word) {
            int index = ch - 'a';
            if (node->children[index] == nullptr) {
                node->children[index] = new Trie();
            }
            node = node->children[index];
        }
        node->isEnd = true;
        return true;
    }

    bool search(const string & word) {
        Trie * node = this;
        for (const auto & ch : word) {
            int index = ch - 'a';
            if (node->children[index] == nullptr || !node->children[index]->isEnd) {
                return false;
            }
            node = node->children[index];
        }
        return node != nullptr && node->isEnd;
    }
private:
    vector<Trie *> children;
    bool isEnd;
};

class Solution {
public:
    string longestWord(vector<string>& words) {
        Trie trie;
        for (const auto & word : words) {
            trie.insert(word);
        }
        string longest = "";
        for (const auto & word : words) {
            if (trie.search(word)) {
                if (word.size() > longest.size() || (word.size() == longest.size() && word < longest)) {
                    longest = word;
                }
            }
        }
        return longest;
    }
};
```

```C [sol2-C]
#define MAX_STR_LEN 32

typedef struct Trie {
    struct Trie * children[26];
    bool isEnd;
} Trie;


void initTrie(Trie * trie) {
    for (int i = 0; i < 26; i++) {
        trie->children[i] = NULL;
    }
    trie->isEnd = false;
}

bool insertTrie(Trie * trie, const char * word) {
    Trie * node = trie;
    int len = strlen(word);
    for (int i = 0; i < len; i++) {
        char ch = word[i];
        int index = ch - 'a';
        if (node->children[index] == NULL) {
            node->children[index] = (Trie *)malloc(sizeof(Trie));
            initTrie(node->children[index]);
        }
        node = node->children[index];
    }
    node->isEnd = true;
    return true;
}

bool searchTrie(const Trie * trie, const char * word) {
    Trie * node = trie;
    int len = strlen(word);
    for (int i = 0; i < len; i++) {
        char ch = word[i];
        int index = ch - 'a';
        if (node->children[index] == NULL || !node->children[index]->isEnd) {
            return false;
        }
        node = node->children[index];
    }
    return node != NULL && node->isEnd;
}

char * longestWord(char ** words, int wordsSize){
    Trie * trie = (Trie *)malloc(sizeof(Trie));
    initTrie(trie);
    for (int i = 0; i < wordsSize; i++) {
        insertTrie(trie, words[i]);
    }
    char * longest = "";
    for (int i = 0; i < wordsSize; i++) {
        if (searchTrie(trie, words[i])) {
            if (strlen(words[i]) > strlen(longest) || (strlen(words[i]) == strlen(longest) && strcmp(words[i], longest) < 0)) {
                longest = words[i];
            }
        }
    }
    return longest;
}
```

```go [sol2-Golang]
type Trie struct {
	children [26]*Trie
	isEnd    bool
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

func (t *Trie) Search(word string) bool {
	node := t
	for _, ch := range word {
		ch -= 'a'
		if node.children[ch] == nil || !node.children[ch].isEnd {
			return false
		}
		node = node.children[ch]
	}
	return true
}

func longestWord(words []string) (longest string) {
	t := &Trie{}
	for _, word := range words {
		t.Insert(word)
	}
	for _, word := range words {
		if t.Search(word) && (len(word) > len(longest) || len(word) == len(longest) && word < longest) {
			longest = word
		}
	}
	return longest
}
```

```JavaScript [sol2-JavaScript]
var longestWord = function(words) {
    const trie = new Trie();
    for (const word of words) {
        trie.insert(word);
    }
    let longest = "";
    for (const word of words) {
        if (trie.search(word)) {
            if (word.length > longest.length || (word.length === longest.length && word.localeCompare(longest) < 0)) {
                longest = word;
            }
        }
    }
    return longest;
};

class Node {
    constructor() {
        this.children = {};
        this.isEnd = false;
    }
}

class Trie {
    constructor() {
        this.children = new Node();
        this.isEnd = false;
    }

    insert(word) {
        let node = this;
        for (let i = 0; i < word.length; i++) {
            const ch = word[i];
            const index = ch.charCodeAt() - 'a'.charCodeAt();
            if (!node.children[index]) {
                node.children[index] = new Node();
            }
            node = node.children[index];
        }
        node.isEnd = true;
    }

    search(word) {
        let node = this;
        for (let i = 0; i < word.length; i++) {
            const ch = word[i];
            const index = ch.charCodeAt() - 'a'.charCodeAt();
            if (!node.children[index] || !node.children[index].isEnd) {
                return false;
            }
            node = node.children[index];
        }
        return node && node.isEnd;
    }
}
```

**复杂度分析**

- 时间复杂度：$O(\sum_{0 \le i < n} l_i)$，其中 $n$ 是数组 $\textit{words}$ 的长度，$l_i$ 是单词 $\textit{words}[i]$ 的长度。将数组 $\textit{words}$ 中的每个单词加入字典树需要 $O(\sum_{0 \le i < n} l_i)$ 的时间，在字典树中判断每个单词是否符合要求并得到答案也需要 $O(\sum_{0 \le i < n} l_i)$ 的时间。

- 空间复杂度：$O(\sum_{0 \le i < n} l_i)$，其中 $n$ 是数组 $\textit{words}$ 的长度，$l_i$ 是单词 $\textit{words}[i]$ 的长度。字典树最多需要 $O(\sum_{0 \le i < n} l_i)$ 的空间。
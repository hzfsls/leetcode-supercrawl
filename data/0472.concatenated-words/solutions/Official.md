#### 前言

本文的解法需要使用字典树。如果读者对字典树不了解，建议首先阅读「[208. 实现 Trie (前缀树) 的官方题解](https://leetcode-cn.com/problems/implement-trie-prefix-tree/solution/shi-xian-trie-qian-zhui-shu-by-leetcode-ti500/)」，在理解字典树的实现之后继续阅读本文。

#### 方法一：字典树 + 记忆化搜索

判断一个单词是不是连接词，需要判断这个单词是否完全由至少两个给定数组中的更短的非空单词（可以重复）组成。判断更短的单词是否在给定数组中，可以使用字典树实现。

为了方便处理，首先将数组 $\textit{words}$ 按照字符串的长度递增的顺序排序，排序后可以确保当遍历到任意单词时，比该单词短的单词一定都已经遍历过，因此可以根据已经遍历过的全部单词判断当前单词是不是连接词。

在将数组 $\textit{words}$ 排序之后，遍历数组，跳过空字符串，对于每个非空单词，判断该单词是不是连接词，如果是连接词则将该单词加入结果数组，如果不是连接词则将该单词加入字典树。

判断一个单词是不是连接词的做法是在字典树中搜索。从该单词的第一个字符（即下标 $0$ 处的字符）开始，在字典树中依次搜索每个字符对应的结点，可能有以下几种情况：

- 如果一个字符对应的结点是单词的结尾，则找到了一个更短的单词，从该字符的后一个字符开始搜索下一个更短的单词；

- 如果一个字符对应的结点在字典树中不存在，则当前的搜索结果失败，回到上一个单词的结尾继续搜索。

如果找到一个更短的单词且这个更短的单词的最后一个字符是当前单词的最后一个字符，则当前单词是连接词。由于数组 $\textit{words}$ 中没有重复的单词，因此在判断一个单词是不是连接词时，该单词一定没有加入字典树，由此可以确保判断连接词的条件成立。

**由于一个连接词由多个更短的非空单词组成，如果存在一个较长的连接词的组成部分之一是一个较短的连接词，则一定可以将这个较短的连接词换成多个更短的非空单词，因此不需要将连接词加入字典树。**

为了降低时间复杂度，需要使用记忆化搜索。对于每个单词，创建与单词相同长度的数组记录该单词的每一个下标是否被访问过，然后进行记忆化搜索。搜索过程中，如果一个下标已经被访问过，则从该下标到末尾的部分一定不是由给定数组中的一个或多个非空单词组成（否则上次访问时已经可以知道当前单词是连接词），只有尚未访问过的下标才需要进行搜索。

```Java [sol1-Java]
class Solution {
    Trie trie = new Trie();

    public List<String> findAllConcatenatedWordsInADict(String[] words) {
        List<String> ans = new ArrayList<String>();
        Arrays.sort(words, (a, b) -> a.length() - b.length());
        for (int i = 0; i < words.length; i++) {
            String word = words[i];
            if (word.length() == 0) {
                continue;
            }
            boolean[] visited = new boolean[word.length()];
            if (dfs(word, 0, visited)) {
                ans.add(word);
            } else {
                insert(word);
            }
        }
        return ans;
    }

    public boolean dfs(String word, int start, boolean[] visited) {
        if (word.length() == start) {
            return true;
        }
        if (visited[start]) {
            return false;
        }
        visited[start] = true;
        Trie node = trie;
        for (int i = start; i < word.length(); i++) {
            char ch = word.charAt(i);
            int index = ch - 'a';
            node = node.children[index];
            if (node == null) {
                return false;
            }
            if (node.isEnd) {
                if (dfs(word, i + 1, visited)) {
                    return true;
                }
            }
        }
        return false;
    }
    
    public void insert(String word) {
        Trie node = trie;
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
}

class Trie {
    Trie[] children;
    boolean isEnd;

    public Trie() {
        children = new Trie[26];
        isEnd = false;
    }
}
```

```C# [sol1-C#]
public class Solution {
    Trie trie = new Trie();

    public IList<string> FindAllConcatenatedWordsInADict(string[] words) {
        IList<string> ans = new List<string>();
        Array.Sort(words, (a, b) => a.Length - b.Length);
        for (int i = 0; i < words.Length; i++) {
            string word = words[i];
            if (word.Length == 0) {
                continue;
            }
            bool[] visited = new bool[word.Length];
            if (DFS(word, 0, visited)) {
                ans.Add(word);
            } else {
                Insert(word);
            }
        }
        return ans;
    }

    public bool DFS(string word, int start, bool[] visited) {
        if (word.Length == start) {
            return true;
        }
        if (visited[start]) {
            return false;
        }
        visited[start] = true;
        Trie node = trie;
        for (int i = start; i < word.Length; i++) {
            char ch = word[i];
            int index = ch - 'a';
            node = node.children[index];
            if (node == null) {
                return false;
            }
            if (node.isEnd) {
                if (DFS(word, i + 1, visited)) {
                    return true;
                }
            }
        }
        return false;
    }
    
    public void Insert(string word) {
        Trie node = trie;
        for (int i = 0; i < word.Length; i++) {
            char ch = word[i];
            int index = ch - 'a';
            if (node.children[index] == null) {
                node.children[index] = new Trie();
            }
            node = node.children[index];
        }
        node.isEnd = true;
    }
}

class Trie {
    public Trie[] children;
    public bool isEnd;

    public Trie() {
        children = new Trie[26];
        isEnd = false;
    }
}
```

```C++ [sol1-C++]
struct Trie {
    bool isEnd;
    vector<Trie *> children;
    Trie() {
        this->children = vector<Trie *>(26, nullptr);
        this->isEnd = false;
    }
};

class Solution {
public:
    Trie * trie = new Trie();

    vector<string> findAllConcatenatedWordsInADict(vector<string>& words) {
        vector<string> ans;
        sort(words.begin(), words.end(), [&](const string & a, const string & b){
            return a.size() < b.size(); 
        });
        for (int i = 0; i < words.size(); i++) {
            string word = words[i];
            if (word.size() == 0) {
                continue;
            }
            vector<int> visited(word.size(), 0);
            if (dfs(word, 0, visited)) {
                ans.emplace_back(word);
            } else {
                insert(word);
            }
        }
        return ans;
    }

    bool dfs(const string & word, int start, vector<int> & visited) {
        if (word.size() == start) {
            return true;
        }
        if (visited[start]) {
            return false;
        }
        visited[start] = true;
        Trie * node = trie;
        for (int i = start; i < word.size(); i++) {
            char ch = word[i];
            int index = ch - 'a';
            node = node->children[index];
            if (node == nullptr) {
                return false;
            }
            if (node->isEnd) {
                if (dfs(word, i + 1, visited)) {
                    return true;
                }
            }
        }
        return false;
    }

    void insert(const string & word) {
        Trie * node = trie;
        for (int i = 0; i < word.size(); i++) {
            char ch = word[i];
            int index = ch - 'a';
            if (node->children[index] == nullptr) {
                node->children[index] = new Trie();
            }
            node = node->children[index];
        }
        node->isEnd = true;
    }
};
```

```Python [sol1-Python3]
class Trie:
    def __init__(self):
        self.children = [None] * 26
        self.isEnd = False

    def insert(self, word: str):
        node = self
        for ch in word:
            ch = ord(ch) - ord('a')
            if not node.children[ch]:
                node.children[ch] = Trie()
            node = node.children[ch]
        node.isEnd = True

    def dfs(self, word: str, start: int, vis: List[bool]) -> bool:
        if start == len(word):
            return True
        if vis[start]:
            return False
        vis[start] = True
        node = self
        for i in range(start, len(word)):
            node = node.children[ord(word[i]) - ord('a')]
            if node is None:
                return False
            if node.isEnd and self.dfs(word, i + 1, vis):
                return True
        return False


class Solution:
    def findAllConcatenatedWordsInADict(self, words: List[str]) -> List[str]:
        words.sort(key=len)

        ans = []
        root = Trie()
        for word in words:
            if word == "":
                continue
            if root.dfs(word, 0, [False] * len(word)):
                ans.append(word)
            else:
                root.insert(word)
        return ans
```

```go [sol1-Golang]
type trie struct {
    children [26]*trie
    isEnd    bool
}

func (root *trie) insert(word string) {
    node := root
    for _, ch := range word {
        ch -= 'a'
        if node.children[ch] == nil {
            node.children[ch] = &trie{}
        }
        node = node.children[ch]
    }
    node.isEnd = true
}

func (root *trie) dfs(vis []bool, word string) bool {
    if word == "" {
        return true
    }
    if vis[len(word)-1] {
        return false
    }
    vis[len(word)-1] = true
    node := root
    for i, ch := range word {
        node = node.children[ch-'a']
        if node == nil {
            return false
        }
        if node.isEnd && root.dfs(vis, word[i+1:]) {
            return true
        }
    }
    return false
}

func findAllConcatenatedWordsInADict(words []string) (ans []string) {
    sort.Slice(words, func(i, j int) bool { return len(words[i]) < len(words[j]) })

    root := &trie{}
    for _, word := range words {
        if word == "" {
            continue
        }
        vis := make([]bool, len(word))
        if root.dfs(vis, word) {
            ans = append(ans, word)
        } else {
            root.insert(word)
        }
    }
    return
}
```

```C [sol1-C]
typedef struct Trie {
    struct Trie * children[26];
    bool isEnd;
}Trie;

#define TRIE_INITIAL(node) do { \
    for (int i = 0; i < 26; ++i) { \
        (node)->children[i] = NULL; \
    } \
    (node)->isEnd = false; \
}while(0);

static void freeTrie(Trie * node) {
    if (NULL == node) {
        return;
    }
    for (int i = 0; i < 26; ++i) {
        if (node->children[i] != NULL) {
            freeTrie(node->children[i]);
        }
    }
    free(node);
}

static int cmp(const void * pa, const void * pb){
    int la = strlen(*(char **)pa);
    int lb = strlen(*(char **)pb);
    return la - lb;
}

bool dfs(Trie * trie, const char * word, int wordSize, int start, int* visited) {
    if (wordSize == start) {
        return true;
    }
    if (visited[start]) {
        return false;
    }
    visited[start] = 1;
    Trie * node = trie;
    for (int i = start; i < wordSize; i++) {
        char ch = word[i];
        int index = ch - 'a';
        node = node->children[index];
        if (node == NULL) {
            return false;
        }
        if (node->isEnd) {
            if (dfs(trie, word, wordSize, i + 1, visited)) {
                return true;
            }
        }
    }
    return false;
}

void insert(Trie * trie, const char * word, int wordSize) {
    Trie * node = trie;
    for (int i = 0; i < wordSize; i++) {
        char ch = word[i];
        int index = ch - 'a';
        if (node->children[index] == NULL) {
            node->children[index] = (Trie *)malloc(sizeof(Trie));
            TRIE_INITIAL(node->children[index]);
        }
        node = node->children[index];
    }
    node->isEnd = true;
}

char ** findAllConcatenatedWordsInADict(char ** words, int wordsSize, int* returnSize){    
    int pos = 0;
    char ** ans = (char **)malloc(sizeof(char *) * wordsSize);
    Trie * trie = (Trie *)malloc(sizeof(Trie));

    TRIE_INITIAL(trie);
    qsort(words, wordsSize, sizeof(char *), cmp);
    for (int i = 0; i < wordsSize; i++) {
        int len = strlen(words[i]);
        if (len == 0) {
            continue;
        }
        int * visited = (int *)malloc(sizeof(int) * len);
        memset(visited, 0, sizeof(int) * len);
        if (dfs(trie, words[i], len, 0, visited)) {
            ans[pos] = (char *)malloc(sizeof(char) * (len + 1));
            strncpy(ans[pos], words[i], len);
            ans[pos][len] = '\0';
            pos++;
        } else {
            insert(trie, words[i], len);
        }
        free(visited);
    }
    freeTrie(trie);
    *returnSize = pos;
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n + \sum_{0 \le i < n} l_i)$，其中 $n$ 是数组 $\textit{words}$ 的长度，$l_i$ 是单词 $\textit{words}[i]$ 的长度。对数组 $\textit{words}$ 按照字符串的长度递增的顺序排序需要 $O(n \log n)$ 的时间，判断单词 $\textit{words}[i]$ 是不是连接词的时间复杂度是 $O(l_i)$。

- 空间复杂度：$O(\sum_{0 \le i < n} l_i \times |S|)$，其中 $n$ 是数组 $\textit{words}$ 的长度，$l_i$ 是单词 $\textit{words}[i]$ 的长度，$S$ 是字符集，这道题中 $S$ 为全部小写英语字母，$|S| = 26$。空间复杂度主要取决于字典树，最坏情况下需要将所有的单词加入字典树。
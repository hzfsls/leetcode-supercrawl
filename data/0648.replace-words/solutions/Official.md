## [648.单词替换 中文官方题解](https://leetcode.cn/problems/replace-words/solutions/100000/dan-ci-ti-huan-by-leetcode-solution-pl6v)

#### 方法一：哈希集合

**思路**

首先将 $\textit{dictionary}$ 中所有词根放入哈希集合中，然后对于 $\textit{sentence}$ 中的每个单词，由短至长遍历它所有的前缀，如果这个前缀出现在哈希集合中，则我们找到了当前单词的最短词根，将这个词根替换原来的单词。最后返回重新拼接的句子。

**代码**

```Python [sol1-Python3]
class Solution:
    def replaceWords(self, dictionary: List[str], sentence: str) -> str:
        dictionarySet = set(dictionary)
        words = sentence.split(' ')
        for i, word in enumerate(words):
            for j in range(1, len(words) + 1):
                if word[:j] in dictionarySet:
                    words[i] = word[:j]
                    break
        return ' '.join(words)
```

```Java [sol1-Java]
class Solution {
    public String replaceWords(List<String> dictionary, String sentence) {
        Set<String> dictionarySet = new HashSet<String>();
        for (String root : dictionary) {
            dictionarySet.add(root);
        }
        String[] words = sentence.split(" ");
        for (int i = 0; i < words.length; i++) {
            String word = words[i];
            for (int j = 0; j < word.length(); j++) {
                if (dictionarySet.contains(word.substring(0, 1 + j))) {
                    words[i] = word.substring(0, 1 + j);
                    break;
                }
            }
        }
        return String.join(" ", words);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string ReplaceWords(IList<string> dictionary, string sentence) {
        ISet<string> dictionarySet = new HashSet<string>();
        foreach (string root in dictionary) {
            dictionarySet.Add(root);
        }
        string[] words = sentence.Split(" ");
        for (int i = 0; i < words.Length; i++) {
            string word = words[i];
            for (int j = 0; j < word.Length; j++) {
                if (dictionarySet.Contains(word.Substring(0, 1 + j))) {
                    words[i] = word.Substring(0, 1 + j);
                    break;
                }
            }
        }
        return String.Join(" ", words);
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<string_view> split(string &str, char ch) {
        int pos = 0;
        int start = 0;
        string_view s(str);
        vector<string_view> ret;
        while (pos < s.size()) {
            while (pos < s.size() && s[pos] == ch) {
                pos++;
            }
            start = pos;
            while (pos < s.size() && s[pos] != ch) {
                pos++;
            }
            if (start < s.size()) {
                ret.emplace_back(s.substr(start, pos - start));
            }
        }
        return ret;
    }

    string replaceWords(vector<string>& dictionary, string sentence) {
        unordered_set<string_view> dictionarySet;
        for (auto &root : dictionary) {
            dictionarySet.emplace(root);
        }
        vector<string_view> words = split(sentence, ' ');
        for (auto &word : words) {
            for (int j = 0; j < word.size(); j++) {
                if (dictionarySet.count(word.substr(0, 1 + j))) {
                    word = word.substr(0, 1 + j);
                    break;
                }
            }
        }
        string ans;
        for (int i = 0; i < words.size() - 1; i++) {
            ans.append(words[i]);
            ans.append(" ");
        }
        ans.append(words.back());
        return ans;
    }
};
```

```C [sol1-C]
#define MAX_STR_LEN 1024

typedef struct {
    char *key;
    UT_hash_handle hh;
} HashItem;

char ** split(char *str, char ch, int *returnSize) {
    int len = strlen(str);
    char **res = (char **)malloc(sizeof(char *) * len);
    int i = 0, pos = 0;
    while (i < len) {
        while (i < len && str[i] == ch) {
            i++;
        }
        int start = i;
        while (i < len && str[i] != ch) {
            i++;
        }
        if (start < len) {
            res[pos] = (char *)malloc(sizeof(char) * (i - start + 1));
            memcpy(res[pos], str + start, sizeof(char) * (i - start));
            res[pos][i - start] = '\0';
            pos++;
        }
    }
    *returnSize = pos;
    return res;
}

char * replaceWords(char ** dictionary, int dictionarySize, char * sentence){
    HashItem *dictionarySet = NULL;
    for (int i = 0; i < dictionarySize; i++) {
        HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
        pEntry->key = dictionary[i];
        HASH_ADD_STR(dictionarySet, key, pEntry);
    }
    int n = strlen(sentence);
    int wordsSize = 0;
    char **words = split(sentence, ' ', &wordsSize);
    char str[MAX_STR_LEN];
    for (int i = 0; i < wordsSize; i++) {
        int len = strlen(words[i]);
        for (int j = 0; j < len; j++) {
            snprintf(str, j + 2, "%s", words[i]);
            HashItem *pEntry = NULL;
            HASH_FIND_STR(dictionarySet, str, pEntry);
            if (pEntry) {
                words[i][j + 1] = '\0';
                break;
            }
        }
    }
    char *res = (char *)malloc(sizeof(char) * (n + 1));
    int pos = 0;
    for (int i = 0; i < wordsSize - 1; i++) {
        pos += sprintf(res + pos, "%s ", words[i]);
    }
    pos += sprintf(res + pos, "%s", words[wordsSize - 1]);
    for (int i = 0; i < wordsSize; i++) {
        free(words[i]);
    }
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, dictionarySet, curr, tmp) {
        HASH_DEL(dictionarySet, curr);  
        free(curr);         
    }
    return res;
}
```

```go [sol1-Golang]
func replaceWords(dictionary []string, sentence string) string {
    dictionarySet := map[string]bool{}
    for _, s := range dictionary {
        dictionarySet[s] = true
    }
    words := strings.Split(sentence, " ")
    for i, word := range words {
        for j := 1; j <= len(word); j++ {
            if dictionarySet[word[:j]] {
                words[i] = word[:j]
                break
            }
        }
    }
    return strings.Join(words, " ")
}
```

```JavaScript [sol1-JavaScript]
var replaceWords = function(dictionary, sentence) {
    const dictionarySet = new Set();
    for (const root of dictionary) {
        dictionarySet.add(root);
    }
    const words = sentence.split(" ");
    for (let i = 0; i < words.length; i++) {
        const word = words[i];
        for (let j = 0; j < word.length; j++) {
            if (dictionarySet.has(word.substring(0, 1 + j))) {
                words[i] = word.substring(0, 1 + j);
                break;
            }
        }
    }
    return words.join(' ');
};
```

**复杂度分析**

- 时间复杂度：$O(d + \sum w_i^2)$。其中 $d$ 是 $\textit{dictionary}$ 的字符数，构建哈希集合消耗 $O(d)$ 时间。$w_i$ 是 $\textit{sentence}$ 分割后第 $i$ 个单词的字符数，判断单词的前缀子字符串是否位于哈希集合中消耗 $O(w_i^2)$ 时间。

- 空间复杂度：$O(d + s)$，其中 $s$ 是 $\textit{sentence}$ 的字符数。构建哈希集合消耗 $O(d)$ 空间，分割 $\textit{sentence}$ 消耗 $O(s)$ 空间。

#### 方法二：字典树

**思路**

与哈希集合不同，我们用 $\textit{dictionary}$ 中所有词根构建一棵字典树，并用特殊符号标记结尾。在搜索前缀时，只需在字典树上搜索出一条最短的前缀路径即可。

**代码**

```Python [sol2-Python3]
class Solution:
    def replaceWords(self, dictionary: List[str], sentence: str) -> str:
        trie = {}
        for word in dictionary:
            cur = trie
            for c in word:
                if c not in cur:
                    cur[c] = {}
                cur = cur[c]
            cur['#'] = {}

        words = sentence.split(' ')
        for i, word in enumerate(words):
            cur = trie
            for j, c in enumerate(word):
                if '#' in cur:
                    words[i] = word[:j]
                    break
                if c not in cur:
                    break
                cur = cur[c]
        return ' '.join(words)
```

```Java [sol2-Java]
class Solution {
    public String replaceWords(List<String> dictionary, String sentence) {
        Trie trie = new Trie();
        for (String word : dictionary) {
            Trie cur = trie;
            for (int i = 0; i < word.length(); i++) {
                char c = word.charAt(i);
                cur.children.putIfAbsent(c, new Trie());
                cur = cur.children.get(c);
            }
            cur.children.put('#', new Trie());
        }
        String[] words = sentence.split(" ");
        for (int i = 0; i < words.length; i++) {
            words[i] = findRoot(words[i], trie);
        }
        return String.join(" ", words);
    }

    public String findRoot(String word, Trie trie) {
        StringBuffer root = new StringBuffer();
        Trie cur = trie;
        for (int i = 0; i < word.length(); i++) {
            char c = word.charAt(i);
            if (cur.children.containsKey('#')) {
                return root.toString();
            }
            if (!cur.children.containsKey(c)) {
                return word;
            }
            root.append(c);
            cur = cur.children.get(c);
        }
        return root.toString();
    }
}

class Trie {
    Map<Character, Trie> children;

    public Trie() {
        children = new HashMap<Character, Trie>();
    }
}
```

```C# [sol2-C#]
public class Solution {
    public string ReplaceWords(IList<string> dictionary, string sentence) {
        Trie trie = new Trie();
        foreach (string word in dictionary) {
            Trie cur = trie;
            for (int i = 0; i < word.Length; i++) {
                char c = word[i];
                if (!cur.Children.ContainsKey(c)) {
                    cur.Children.Add(c, new Trie());
                }
                cur = cur.Children[c];
            }
            cur.Children.Add('#', new Trie());
        }
        string[] words = sentence.Split(" ");
        for (int i = 0; i < words.Length; i++) {
            words[i] = FindRoot(words[i], trie);
        }
        return string.Join(" ", words);
    }

    public string FindRoot(string word, Trie trie) {
        StringBuilder root = new StringBuilder();
        Trie cur = trie;
        for (int i = 0; i < word.Length; i++) {
            char c = word[i];
            if (cur.Children.ContainsKey('#')) {
                return root.ToString();
            }
            if (!cur.Children.ContainsKey(c)) {
                return word;
            }
            root.Append(c);
            cur = cur.Children[c];
        }
        return root.ToString();
    }
}

public class Trie {
    public Dictionary<char, Trie> Children;

    public Trie() {
        Children = new Dictionary<char, Trie>();
    }
}
```

```C++ [sol2-C++]
struct Trie {
    unordered_map<char, Trie *> children;
};

class Solution {
public:
    string replaceWords(vector<string>& dictionary, string sentence) {
        Trie *trie = new Trie();
        for (auto &word : dictionary) {
            Trie *cur = trie;
            for (char &c: word) {
                if (!cur->children.count(c)) {
                    cur->children[c] = new Trie();
                }
                cur = cur->children[c];
            }
            cur->children['#'] = new Trie();
        }
        vector<string> words = split(sentence, ' ');
        for (auto &word : words) {
            word = findRoot(word, trie);
        }
        string ans;
        for (int i = 0; i < words.size() - 1; i++) {
            ans.append(words[i]);
            ans.append(" ");
        }
        ans.append(words.back());
        return ans;
    }

    vector<string> split(string &str, char ch) {
        int pos = 0;
        int start = 0;
        vector<string> ret;
        while (pos < str.size()) {
            while (pos < str.size() && str[pos] == ch) {
                pos++;
            }
            start = pos;
            while (pos < str.size() && str[pos] != ch) {
                pos++;
            }
            if (start < str.size()) {
                ret.emplace_back(str.substr(start, pos - start));
            }
        }
        return ret;
    }

    string findRoot(string &word, Trie *trie) {
        string root;
        Trie *cur = trie;
        for (char &c : word) {
            if (cur->children.count('#')) {
                return root;
            }
            if (!cur->children.count(c)) {
                return word;
            }
            root.push_back(c);
            cur = cur->children[c];
        }
        return root;
    }
};
```

```C [sol2-C]
#define MAX_STR_LEN 1024

typedef struct Trie {
    bool isEnd;
    struct Trie *children[26];
} Trie;

Trie * creatTrie() {
    Trie *node = (Trie *)malloc(sizeof(Trie));
    for (int i = 0; i < 26; i++) {
        node->children[i] = NULL;
    }
    node->isEnd = false;
    return node;
}

void freeTrie(Trie *root) {
    for (int i = 0; i < 26; i++) {
        if (root->children[i]) {
            freeTrie(root->children[i]);
        }
    }
    free(root);
}

char *findRoot(const char *word, Trie *trie) {
    char *root = (char *)malloc(sizeof(char) * MAX_STR_LEN);
    Trie *cur = trie;
    int len = strlen(word);
    int pos = 0;
    for (int i = 0; i < len; i++) {
        char c = word[i];
        if (cur->isEnd) {
            root[pos] = 0;
            return root;
        }
        if (!cur->children[c - 'a']) {
            free(root);
            return word;
        }
        root[pos++] = c;
        cur = cur->children[c - 'a'];
    }
    root[pos] = 0;
    return root;
}

char ** split(char *str, char ch, int *returnSize) {
    int len = strlen(str);
    char **res = (char **)malloc(sizeof(char *) * len);
    int i = 0, pos = 0;
    while (i < len) {
        while (i < len && str[i] == ch) {
            i++;
        }
        int start = i;
        while (i < len && str[i] != ch) {
            i++;
        }
        if (start < len) {
            res[pos] = (char *)malloc(sizeof(char) * (i - start + 1));
            memcpy(res[pos], str + start, sizeof(char) * (i - start));
            res[pos][i - start] = '\0';
            pos++;
        }
    }
    *returnSize = pos;
    return res;
}

char * replaceWords(char ** dictionary, int dictionarySize, char * sentence){
    Trie *trie = creatTrie();
    for (int i = 0; i < dictionarySize; i++) {
        Trie *cur = trie;
        int len = strlen(dictionary[i]);
        for (int j = 0; j < len; j++) {
            char c = dictionary[i][j];
            if (!cur->children[c - 'a']) {
                cur->children[c - 'a'] = creatTrie();
            }
            cur = cur->children[c - 'a'];
        }
        cur->isEnd = true;
    }
    int wordsSize = 0, pos = 0;
    char **words = split(sentence, ' ', &wordsSize);
    char *ans = (char *)malloc(sizeof(char) * (strlen(sentence) + 2));
    for (int i = 0; i < wordsSize; i++) {
        char * ret = findRoot(words[i], trie);
        pos += sprintf(ans + pos, "%s ", ret);
        free(words[i]);
        if (ret != words[i]) {
            free(ret);
        }
    }
    ans[pos - 1] = '\0';
    freeTrie(trie);
    return ans;
}
```

```go [sol2-Golang]
func replaceWords(dictionary []string, sentence string) string {
    type trie map[rune]trie
    root := trie{}
    for _, s := range dictionary {
        cur := root
        for _, c := range s {
            if cur[c] == nil {
                cur[c] = trie{}
            }
            cur = cur[c]
        }
        cur['#'] = trie{}
    }

    words := strings.Split(sentence, " ")
    for i, word := range words {
        cur := root
        for j, c := range word {
            if cur['#'] != nil {
                words[i] = word[:j]
                break
            }
            if cur[c] == nil {
                break
            }
            cur = cur[c]
        }
    }
    return strings.Join(words, " ")
}
```

```JavaScript [sol2-JavaScript]
var replaceWords = function(dictionary, sentence) {
    const trie = new Trie();
    for (const word of dictionary) {
        let cur = trie;
        for (let i = 0; i < word.length; i++) {
            const c = word[i];
            if (!cur.children.has(c)) {
                cur.children.set(c, new Trie());
            }
            cur = cur.children.get(c);
        }
        cur.children.set('#', new Trie());
    }
    const words = sentence.split(" ");
    for (let i = 0; i < words.length; i++) {
        words[i] = findRoot(words[i], trie);
    }
    return words.join(" ");
};

const findRoot = (word, trie) => {
    let root = '';
    let cur = trie;
    for (let i = 0; i < word.length; i++) {
        const c = word[i];
        if (cur.children.has('#')) {
            return root;
        }
        if (!cur.children.has(c)) {
            return word;
        }
        root += c;
        cur = cur.children.get(c);
    }
    return root;
}

class Trie {
    constructor() {
        this.children = new Map();
    }
}
```

**复杂度分析**

- 时间复杂度：$O(d + s)$。其中 $d$ 是 $\textit{dictionary}$ 的字符数，$s$ 是 $\textit{sentence}$ 的字符数。构建字典树消耗 $O(d)$ 时间，每个单词搜索前缀均消耗线性时间。

- 空间复杂度：$O(d + s)$，构建哈希集合消耗 $O(d)$ 空间，分割 $\textit{sentence}$ 消耗 $O(s)$ 空间。
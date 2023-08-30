#### 方法一：计算每个单词的前缀后缀组合可能性

**思路**

预先计算出每个单词的前缀后缀组合可能性，用特殊符号连接，作为键，对应的最大下标作为值保存入哈希表。检索时，同样用特殊符号连接前后缀，在哈希表中进行搜索。

**代码**

```Python [sol1-Python3]
class WordFilter:

    def __init__(self, words: List[str]):
        self.d = {}
        for i, word in enumerate(words):
            m = len(word)
            for prefixLength in range(1, m + 1):
                for suffixLength in range(1, m + 1):
                    self.d[word[:prefixLength] + '#' + word[-suffixLength:]] = i


    def f(self, pref: str, suff: str) -> int:
        return self.d.get(pref + '#' + suff, -1)
```

```Java [sol1-Java]
class WordFilter {
    Map<String, Integer> dictionary;

    public WordFilter(String[] words) {
        dictionary = new HashMap<String, Integer>();
        for (int i = 0; i < words.length; i++) {
            String word = words[i];
            int m = word.length();
            for (int prefixLength = 1; prefixLength <= m; prefixLength++) {
                for (int suffixLength = 1; suffixLength <= m; suffixLength++) {
                    dictionary.put(word.substring(0, prefixLength) + "#" + word.substring(m - suffixLength), i);
                }
            }
        }
    }

    public int f(String pref, String suff) {
        return dictionary.getOrDefault(pref + "#" + suff, -1);
    }
}
```

```C# [sol1-C#]
public class WordFilter {
    Dictionary<string, int> dictionary;

    public WordFilter(string[] words) {
        dictionary = new Dictionary<string, int>();
        for (int i = words.Length - 1; i >= 0; i--) {
            string word = words[i];
            int m = word.Length;
            for (int prefixLength = 1; prefixLength <= m; prefixLength++) {
                for (int suffixLength = 1; suffixLength <= m; suffixLength++) {
                    dictionary.TryAdd(word.Substring(0, prefixLength) + "#" + word.Substring(m - suffixLength), i);
                }
            }
        }
    }

    public int F(string pref, string suff) {
        if (dictionary.ContainsKey(pref + "#" + suff)) {
            return dictionary[pref + "#" + suff];
        }
        return -1;
    }
}
```

```C++ [sol1-C++]
class WordFilter {
private:
    unordered_map<string, int> dict;
public:
    WordFilter(vector<string>& words) {
        for (int i = 0; i < words.size(); i++) {
            int m = words[i].size();
            string word = words[i];
            for (int prefixLength = 1; prefixLength <= m; prefixLength++) {
                for (int suffixLength = 1; suffixLength <= m; suffixLength++) {
                    string key = word.substr(0, prefixLength) + '#' + word.substr(m - suffixLength);
                    dict[key] = i;
                }
            }
        }
    }
    
    int f(string pref, string suff) {
        string target = pref + '#' + suff;
        return dict.count(target) ? dict[target] : -1;
    }
};
```

```C [sol1-C]
#define MAX_STR_LEN 16

typedef struct {
    char key[MAX_STR_LEN];
    int val;
    UT_hash_handle hh;
} HashItem;

typedef struct {
    HashItem *dict;
} WordFilter;

WordFilter* wordFilterCreate(char ** words, int wordsSize) {
    WordFilter *obj = (WordFilter *)malloc(sizeof(WordFilter));
    obj->dict = NULL;
    for (int i = 0; i < wordsSize; i++) {
        int m = strlen(words[i]);
        for (int prefixLength = 1; prefixLength <= m; prefixLength++) {
            for (int suffixLength = 1; suffixLength <= m; suffixLength++) {
                char key[MAX_STR_LEN];
                strncpy(key, words[i], prefixLength);
                key[prefixLength] = '#';
                strcpy(key + prefixLength + 1, words[i] + m - suffixLength);
                key[prefixLength + 1 + suffixLength] = '\0';
                HashItem *pEntry = NULL;
                HASH_FIND_STR(obj->dict, key, pEntry);
                if (NULL == pEntry) {
                    pEntry = (HashItem *)malloc(sizeof(HashItem));
                    strcpy(pEntry->key, key);
                    HASH_ADD_STR(obj->dict, key, pEntry);
                }
                pEntry->val = i;
            }
        }
    }
    return obj;
}

int wordFilterF(WordFilter* obj, char * pref, char * suff) {
    char target[MAX_STR_LEN];
    sprintf(target, "%s#%s", pref, suff);
    HashItem *pEntry = NULL;
    HASH_FIND_STR(obj->dict, target, pEntry);
    if (NULL == pEntry) {
        return -1;
    }
    return pEntry->val;
}

void wordFilterFree(WordFilter* obj) {
    HashItem *curr, *tmp;
    HASH_ITER(hh, obj->dict, curr, tmp) {
        HASH_DEL(obj->dict, curr);  
        free(curr);          
    }
    free(obj);
}
```

```JavaScript [sol1-JavaScript]
var WordFilter = function(words) {
    this.dictionary = new Map();
    for (let i = 0; i < words.length; i++) {
        const word = words[i];
        const m = word.length;
        for (let prefixLength = 1; prefixLength <= m; prefixLength++) {
            for (let suffixLength = 1; suffixLength <= m; suffixLength++) {
                this.dictionary.set(word.substring(0, prefixLength) + "#" + word.substring(m - suffixLength), i);
            }
        }
    }
};

WordFilter.prototype.f = function(pref, suff) {
    if (this.dictionary.has(pref + "#" + suff)) {
        return this.dictionary.get(pref + "#" + suff);
    }
    return -1;
};
```

```go [sol1-Golang]
type WordFilter map[string]int

func Constructor(words []string) WordFilter {
    wf := WordFilter{}
    for i, word := range words {
        for j, n := 1, len(word); j <= n; j++ {
            for k := 0; k < n; k++ {
                wf[word[:j]+"#"+word[k:]] = i
            }
        }
    }
    return wf
}

func (wf WordFilter) F(pref, suff string) int {
    if i, ok := wf[pref+"#"+suff]; ok {
        return i
    }
    return -1
}
```

**复杂度分析**

- 时间复杂度：初始化消耗 $O(\sum\limits_{i=0}^{n-1}w_i^3)$ 时间，其中 $w_i$ 是每个单词的字符数。每次检索消耗 $O(p + s)$，其中 $p$ 和 $s$ 分别是输入的 $\textit{pref}$ 和 $\textit{suff}$ 的长度。

- 空间复杂度：初始化消耗 $O(\sum\limits_{i=0}^{n-1}w_i^3)$ 空间，每次检索消耗 $O(p + s)$ 空间。

#### 方法二：字典树

**思路**

调用 $f$ 时，如果前缀和后缀的长度相同，那么此题可以用字典树来解决。初始化时，只需将单词正序和倒序后得到的单词对依次插入字典树即可。比如要插入 $\text{``apple"}$ 时，只需依次插入 $\text{(`a', `e'), (`p', `l'), (`p', `p'), (`l', `p'), (`e', `a')}$ 即可。这样初始化后，对于前缀和后缀相同的检索，也只需要在字典树上检索前缀和后缀倒序得到的单词对。但是调用 $f$ 时，还有可能遇到前缀和后缀长度不同的情况。为了应对这一情况，可以将短的字符串用特殊字符补足，使得前缀和后缀长度相同。而在初始化时，也需要考虑到这个情况，特殊字符组成的单词对，也要插入字典树中。

**代码**

```Python [sol2-Python3]
class WordFilter:

    def __init__(self, words: List[str]):
        self.trie = {}
        self.weightKey = ('#', '#')
        for i, word in enumerate(words):
            cur = self.trie
            m = len(word)
            for j in range(m):
                tmp = cur
                for k in range(j, m):
                    key = (word[k], '#')
                    if key not in tmp:
                        tmp[key] = {}
                    tmp = tmp[key]
                    tmp[self.weightKey] = i
                tmp = cur
                for k in range(j, m):
                    key = ('#', word[-k - 1])
                    if key not in tmp:
                        tmp[key] = {}
                    tmp = tmp[key]
                    tmp[self.weightKey] = i
                key = (word[j], word[-j - 1])
                if key not in cur:
                    cur[key] = {}
                cur = cur[key]
                cur[self.weightKey] = i
                
    def f(self, pref: str, suff: str) -> int:
        cur = self.trie
        for key in zip_longest(pref, suff[::-1], fillvalue='#'):
            if key not in cur: 
                return -1
            cur = cur[key]
        return cur[self.weightKey]
```

```Java [sol2-Java]
class WordFilter {
    Trie trie;
    String weightKey;

    public WordFilter(String[] words) {
        trie = new Trie();
        weightKey = "##";
        for (int i = 0; i < words.length; i++) {
            String word = words[i];
            Trie cur = trie;
            int m = word.length();
            for (int j = 0; j < m; j++) {
                Trie tmp = cur;
                for (int k = j; k < m; k++) {
                    String key = new StringBuilder().append(word.charAt(k)).append('#').toString();
                    if (!tmp.children.containsKey(key)) {
                        tmp.children.put(key, new Trie());
                    }
                    tmp = tmp.children.get(key);
                    tmp.weight.put(weightKey, i);
                }
                tmp = cur;
                for (int k = j; k < m; k++) {
                    String key = new StringBuilder().append('#').append(word.charAt(m - k - 1)).toString();
                    if (!tmp.children.containsKey(key)) {
                        tmp.children.put(key, new Trie());
                    }
                    tmp = tmp.children.get(key);
                    tmp.weight.put(weightKey, i);
                }
                String key = new StringBuilder().append(word.charAt(j)).append(word.charAt(m - j - 1)).toString();
                if (!cur.children.containsKey(key)) {
                    cur.children.put(key, new Trie());
                }
                cur = cur.children.get(key);
                cur.weight.put(weightKey, i);
            }
        }
    }

    public int f(String pref, String suff) {
        Trie cur = trie;
        int m = Math.max(pref.length(), suff.length());
        for (int i = 0; i < m; i++) {
            char c1 = i < pref.length() ? pref.charAt(i) : '#';
            char c2 = i < suff.length() ? suff.charAt(suff.length() - 1 - i) : '#';
            String key = new StringBuilder().append(c1).append(c2).toString();
            if (!cur.children.containsKey(key)) {
                return -1;
            }
            cur = cur.children.get(key);
        }
        return cur.weight.get(weightKey);
    }
}

class Trie {
    Map<String, Trie> children;
    Map<String, Integer> weight;

    public Trie() {
        children = new HashMap<String, Trie>();
        weight = new HashMap<String, Integer>();
    }
}
```

```C# [sol2-C#]
public class WordFilter {
    Trie trie;
    string weightKey;

    public WordFilter(string[] words) {
        trie = new Trie();
        weightKey = "##";
        for (int i = words.Length - 1; i >= 0; i--) {
            string word = words[i];
            Trie cur = trie;
            string key;
            int m = word.Length;
            for (int j = 0; j < m; j++) {
                Trie tmp = cur;
                for (int k = j; k < m; k++) {
                    key = new StringBuilder().Append(word[k]).Append('#').ToString();
                    if (!tmp.Children.ContainsKey(key)) {
                        tmp.Children.TryAdd(key, new Trie());
                    }
                    tmp = tmp.Children[key];
                    tmp.Weight.TryAdd(weightKey, i);
                }
                tmp = cur;
                for (int k = j; k < m; k++) {
                    key = new StringBuilder().Append('#').Append(word[m - k - 1]).ToString();
                    if (!tmp.Children.ContainsKey(key)) {
                        tmp.Children.TryAdd(key, new Trie());
                    }
                    tmp = tmp.Children[key];
                    tmp.Weight.TryAdd(weightKey, i);
                }
                key = new StringBuilder().Append(word[j]).Append(word[m - j - 1]).ToString();
                if (!cur.Children.ContainsKey(key)) {
                    cur.Children.TryAdd(key, new Trie());
                }
                cur = cur.Children[key];
                cur.Weight.TryAdd(weightKey, i);
            }
        }
    }

    public int F(string pref, string suff) {
        Trie cur = trie;
        int m = Math.Max(pref.Length, suff.Length);
        for (int i = 0; i < m; i++) {
            char c1 = i < pref.Length ? pref[i] : '#';
            char c2 = i < suff.Length ? suff[suff.Length - 1 - i] : '#';
            string key = new StringBuilder().Append(c1).Append(c2).ToString();
            if (!cur.Children.ContainsKey(key)) {
                return -1;
            }
            cur = cur.Children[key];
        }
        return cur.Weight[weightKey];
    }
}

public class Trie {
    public Dictionary<string, Trie> Children;
    public Dictionary<string, int> Weight;

    public Trie() {
        Children = new Dictionary<string, Trie>();
        Weight = new Dictionary<string, int>();
    }
}
```

```C++ [sol2-C++]
struct Trie {
    unordered_map<string, Trie *> children;
    int weight;
};

class WordFilter {
private:
    Trie *trie;

public:
    WordFilter(vector<string>& words) {
        trie = new Trie();
        for (int i = 0; i < words.size(); i++) {
            string word = words[i];
            Trie *cur = trie;
            int m = word.size();
            for (int j = 0; j < m; j++) {
                Trie *tmp = cur;
                for (int k = j; k < m; k++) {
                    string key({word[k], '#'});
                    if (!tmp->children.count(key)) {
                        tmp->children[key] = new Trie();
                    }
                    tmp = tmp->children[key];
                    tmp->weight = i;
                }
                tmp = cur;
                for (int k = j; k < m; k++) {
                    string key({'#', word[m - k - 1]});
                    if (!tmp->children.count(key)) {
                        tmp->children[key] = new Trie();
                    }
                    tmp = tmp->children[key];
                    tmp->weight = i;
                }
                string key({word[j], word[m - j - 1]});
                if (!cur->children.count(key)) {
                    cur->children[key] = new Trie();
                }
                cur = cur->children[key];
                cur->weight = i;
            }
        }
    }
    
    int f(string pref, string suff) {
        Trie *cur = trie;
        int m = max(pref.size(), suff.size());
        for (int i = 0; i < m; i++) {
            char c1 = i < pref.size() ? pref[i] : '#';
            char c2 = i < suff.size() ? suff[suff.size() - 1 - i] : '#';
            string key({c1, c2});
            if (!cur->children.count(key)) {
                return -1;
            }
            cur = cur->children[key];
        }
        return cur->weight;
    }
};
```

```C [sol2-C]
#define MAX_STR_LEN 4
#define MAX(a, b) ((a) > (b) ? (a) : (b))

struct Trie;

typedef struct HashItem {
    int key;
    struct Trie *val;
    UT_hash_handle hh;
} HashItem;

typedef struct Trie {
    HashItem *children;
    int weight;
} Trie;

typedef struct {
    Trie *trie;
} WordFilter;

WordFilter* wordFilterCreate(char ** words, int wordsSize) {
    WordFilter *obj = (WordFilter *)malloc(sizeof(WordFilter));
    obj->trie = (Trie *)malloc(sizeof(Trie));
    obj->trie->children = NULL;
    for (int i = 0; i < wordsSize; i++) {
        char *word = words[i];
        Trie *cur = obj->trie;
        int m = strlen(word);
        for (int j = 0; j < m; j++) {
            Trie *tmp = cur;
            for (int k = j; k < m; k++) {
                int key = (word[k] << 8) + '#';
                HashItem *pEntry = NULL;
                HASH_FIND_INT(tmp->children, &key, pEntry);
                if (NULL == pEntry) {
                    pEntry = (HashItem *)malloc(sizeof(HashItem));
                    pEntry->key = key;
                    pEntry->val = (Trie *)malloc(sizeof(Trie));
                    pEntry->val->children = NULL;
                    HASH_ADD_INT(tmp->children, key, pEntry);
                }
                tmp = pEntry->val;
                tmp->weight = i;
            }
            tmp = cur;
            for (int k = j; k < m; k++) {
                int key = ('#' << 8) + word[m - k - 1];
                HashItem *pEntry = NULL;
                HASH_FIND_INT(tmp->children, &key, pEntry);
                if (NULL == pEntry) {
                    pEntry = (HashItem *)malloc(sizeof(HashItem));
                    pEntry->key = key;
                    pEntry->val = (Trie *)malloc(sizeof(Trie));
                    pEntry->val->children = NULL;
                    HASH_ADD_INT(tmp->children, key, pEntry);
                }
                tmp = pEntry->val;
                tmp->weight = i;
            }
            int key = (word[j] << 8) + word[m - j - 1];
            HashItem *pEntry = NULL;
            HASH_FIND_INT(cur->children, &key, pEntry);
            if (NULL == pEntry) {
                pEntry = (HashItem *)malloc(sizeof(HashItem));
                pEntry->key = key;
                pEntry->val = (Trie *)malloc(sizeof(Trie));
                pEntry->val->children = NULL;
                HASH_ADD_INT(cur->children, key, pEntry);
            }
            cur = pEntry->val;
            cur->weight = i;
        }
    }
    return obj;
}

int wordFilterF(WordFilter* obj, char * pref, char * suff) {
    Trie *cur = obj->trie;
    int prefSize = strlen(pref);
    int suffSize = strlen(suff);
    int m = MAX(prefSize, suffSize);
    for (int i = 0; i < m; i++) {
        char c1 = i < prefSize ? pref[i] : '#';
        char c2 = i < suffSize ? suff[suffSize - 1 - i] : '#';
        int key = (c1 << 8) + c2;
        HashItem *pEntry = NULL;
        HASH_FIND_INT(cur->children, &key, pEntry);
        if (NULL == pEntry) {
            return -1;
        }
        cur = pEntry->val;
    }
    return cur->weight;
}

void freeTrie(Trie *obj) {
    HashItem *cur, *tmp;
    HASH_ITER(hh, obj->children, cur, tmp) {
        HASH_DEL(obj->children, cur);
        freeTrie(cur->val);
        free(cur);
    }
    free(obj);
}

void wordFilterFree(WordFilter* obj) {
    freeTrie(obj->trie);
}
```

**复杂度分析**

- 时间复杂度：初始化消耗 $O(\sum\limits_{i=0}^{n-1}w_i^2)$ 时间，其中 $w_i$ 是每个单词的字符数。每次检索消耗 $O(\max(p, s))$，其中 $p$ 和 $s$ 分别是输入的 $\textit{pref}$ 和 $\textit{suff}$ 的长度。

- 空间复杂度：初始化消耗 $O(\sum\limits_{i=0}^{n-1}w_i^2)$ 空间，每次检索消耗 $O(1)$ 空间。
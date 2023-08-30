#### 方法一：排序

**思路与算法**

我们可以将字符串数组 $\textit{folder}$ 按照字典序进行排序。在排序完成后，对于每一个 $\textit{folder}[i]$，如果 $\textit{folder}[i-1]$ 恰好是它的前缀，并且 $\textit{folder}[i]$ 第一个多出的字符是 $\text{/}$，那么我们就可以把 $\textit{folder}[i]$ 删除。

> 注意当 $\textit{folder}[i]$ 被删除后，后续的所有字符串都需要向前移动一个位置。例如 $\text{[``/a'',``/a/b'',``/a/c'']}$ 中，$\text{``/a/b''}$ 被删除后，数组会变为 $\text{[``/a'',``/a/c'']}$，$\text{``/a/c''}$ 也会被删除。

这样做的必要性是显然的，因为如果上述条件满足，就说明 $\textit{folder}[i]$ 是 $\textit{folder}[i-1]$ 的子文件夹。对于充分性，我们可以使用反证法：

> 假设 $\textit{folder}[i]$ 是某个 $\textit{folder}[j]~(j \neq i-1)$ 的子文件夹但不是 $\textit{folder}[i-1]$ 的子文件夹，那么在排序后，$\textit{folder}[j]$ 一定出现在 $\textit{folder}[i]$ 的前面，也就是有 $j < i$。如果有多个满足要求的 $j$，我们选择最早出现的那个。这样就保证了 $\textit{folder}[j]$ 本身不会是其它文件夹的子文件夹。
>
> 由于 $\text{``/''}$ 的字典序小于所有的小写字母，并且 $\textit{folder}[i]$ 是由 $\textit{folder}[j]$ 加上 $\text{``/''}$ 再加上后续字符组成，因此在 $\textit{folder}[i]$ 和 $\textit{folder}[j]$ 之间的所有字符串也都一定是由 $\textit{folder}[j]$ 加上 $\text{``/''}$ 再加上后续字符组成。这些字符串都是 $\textit{folder}[i]$ 的子文件夹，它们会依次被删除。当遍历到 $\textit{folder}[i]$ 时，它的上一个元素恰好是 $\textit{folder}[j]$，因此它一定会被删除。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<string> removeSubfolders(vector<string>& folder) {
        sort(folder.begin(), folder.end());
        vector<string> ans = {folder[0]};
        for (int i = 1; i < folder.size(); ++i) {
            if (int pre = ans.end()[-1].size(); !(pre < folder[i].size() && ans.end()[-1] == folder[i].substr(0, pre) && folder[i][pre] == '/')) {
                ans.push_back(folder[i]);
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<String> removeSubfolders(String[] folder) {
        Arrays.sort(folder);
        List<String> ans = new ArrayList<String>();
        ans.add(folder[0]);
        for (int i = 1; i < folder.length; ++i) {
            int pre = ans.get(ans.size() - 1).length();
            if (!(pre < folder[i].length() && ans.get(ans.size() - 1).equals(folder[i].substring(0, pre)) && folder[i].charAt(pre) == '/')) {
                ans.add(folder[i]);
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<string> RemoveSubfolders(string[] folder) {
        Array.Sort(folder);
        IList<string> ans = new List<string>();
        ans.Add(folder[0]);
        for (int i = 1; i < folder.Length; ++i) {
            int pre = ans[ans.Count - 1].Length;
            if (!(pre < folder[i].Length && ans[ans.Count - 1].Equals(folder[i].Substring(0, pre)) && folder[i][pre] == '/')) {
                ans.Add(folder[i]);
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def removeSubfolders(self, folder: List[str]) -> List[str]:
        folder.sort()
        ans = [folder[0]]
        for i in range(1, len(folder)):
            if not ((pre := len(ans[-1])) < len(folder[i]) and ans[-1] == folder[i][:pre] and folder[i][pre] == "/"):
                ans.append(folder[i])
        return ans
```

```C [sol1-C]
static int cmp(const int *pa, const int *pb) {
    return strcmp(*(char **)pa, *(char **)pb);
}

char ** removeSubfolders(char ** folder, int folderSize, int* returnSize) {
    qsort(folder, folderSize, sizeof(char *), cmp);
    char **ans = (char **)malloc(sizeof(char *) * folderSize);
    int pos = 0;
    ans[pos++] = folder[0];
    for (int i = 1; i < folderSize; ++i) {
        int pre = strlen(ans[pos - 1]);
        if (!(pre < strlen(folder[i]) && !strncmp(ans[pos - 1], folder[i], pre) && folder[i][pre] == '/')) {
            ans[pos++] = folder[i];
        }
    }
    *returnSize = pos;
    return ans;
}
```

```go [sol1-Golang]
func removeSubfolders(folder []string) (ans []string) {
    sort.Strings(folder)
    ans = append(ans, folder[0])
    for _, f := range folder[1:] {
        last := ans[len(ans)-1]
        if !strings.HasPrefix(f, last) || f[len(last)] != '/' {
            ans = append(ans, f)
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var removeSubfolders = function(folder) {
    folder.sort();
    const ans = [folder[0]];
    for (let i = 1; i < folder.length; ++i) {
        const pre = ans[ans.length - 1].length;
        if (!(pre < folder[i].length && ans[ans.length - 1] === (folder[i].substring(0, pre)) && folder[i].charAt(pre) === '/')) {
            ans.push(folder[i]);
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(nl \cdot \log n)$，其中 $n$ 和 $l$ 分别是数组 $\textit{folder}$ 的长度和文件夹的平均长度。$O(nl \cdot \log n)$ 为排序需要的时间，后续构造答案需要的时间为 $O(nl)$，在渐进意义下小于前者。

- 空间复杂度：$O(l)$。在构造答案比较前缀时，我们使用了字符串的截取子串操作，因此需要 $O(l)$ 的临时空间。我们也可以使用一个递增的指针依次对两个字符串的每个相同位置进行比较，省去这一部分的空间，使得空间复杂度降低至排序需要的栈空间 $O(\log n)$。但空间优化并不是本题的重点，因此上述的代码中仍然采用空间复杂度为 $O(l)$ 的写法。注意这里不计入返回值占用的空间。

#### 方法二：字典树

**思路与算法**

我们也可以使用字典树来解决本题。文件夹的拓扑结构正好是树形结构，即字典树上的每一个节点就是一个文件夹。

对于字典树中的每一个节点，我们仅需要存储一个变量 $\textit{ref}$，如果 $\textit{ref} \geq 0$，说明该节点对应着 $\textit{folder}[\textit{ref}~]$，否则（$\textit{ref} = -1$）说明该节点只是一个中间节点。

我们首先将每一个文件夹按照 $\text{``/''}$ 进行分割，作为一条路径加入字典树中。随后我们对字典树进行一次深度优先搜索，搜索的过程中，如果我们走到了一个 $\textit{ref} \geq 0$ 的节点，就将其加入答案，并且可以直接回溯，因为后续（更深的）所有节点都是该节点的子文件夹。

**代码**

```C++ [sol2-C++]
struct Trie {
    Trie(): ref(-1) {}

    unordered_map<string, Trie*> children;
    int ref;
};

class Solution {
public:
    vector<string> removeSubfolders(vector<string>& folder) {
        auto split = [](const string& s) -> vector<string> {
            vector<string> ret;
            string cur;
            for (char ch: s) {
                if (ch == '/') {
                    ret.push_back(move(cur));
                    cur.clear();
                }
                else {
                    cur.push_back(ch);
                }
            }
            ret.push_back(move(cur));
            return ret;
        };

        Trie* root = new Trie();
        for (int i = 0; i < folder.size(); ++i) {
            vector<string> path = split(folder[i]);
            Trie* cur = root;
            for (const string& name: path) {
                if (!cur->children.count(name)) {
                    cur->children[name] = new Trie();
                }
                cur = cur->children[name];
            }
            cur->ref = i;
        }

        vector<string> ans;

        function<void(Trie*)> dfs = [&](Trie* cur) {
            if (cur->ref != -1) {
                ans.push_back(folder[cur->ref]);
                return;
            }
            for (auto&& [_, child]: cur->children) {
                dfs(child);
            }
        };

        dfs(root);
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<String> removeSubfolders(String[] folder) {
        Trie root = new Trie();
        for (int i = 0; i < folder.length; ++i) {
            List<String> path = split(folder[i]);
            Trie cur = root;
            for (String name : path) {
                cur.children.putIfAbsent(name, new Trie());
                cur = cur.children.get(name);
            }
            cur.ref = i;
        }

        List<String> ans = new ArrayList<String>();
        dfs(folder, ans, root);
        return ans;
    }

    public List<String> split(String s) {
        List<String> ret = new ArrayList<String>();
        StringBuilder cur = new StringBuilder();
        for (int i = 0; i < s.length(); ++i) {
            char ch = s.charAt(i);
            if (ch == '/') {
                ret.add(cur.toString());
                cur.setLength(0);
            } else {
                cur.append(ch);
            }
        }
        ret.add(cur.toString());
        return ret;
    }

    public void dfs(String[] folder, List<String> ans, Trie cur) {
        if (cur.ref != -1) {
            ans.add(folder[cur.ref]);
            return;
        }
        for (Trie child : cur.children.values()) {
            dfs(folder, ans, child);
        }
    }
}

class Trie {
    int ref;
    Map<String, Trie> children;

    public Trie() {
        ref = -1;
        children = new HashMap<String, Trie>();
    }
}
```

```C# [sol2-C#]
public class Solution {
    public IList<string> RemoveSubfolders(string[] folder) {
        Trie root = new Trie();
        for (int i = 0; i < folder.Length; ++i) {
            IList<string> path = Split(folder[i]);
            Trie cur = root;
            foreach (string name in path) {
                cur.children.TryAdd(name, new Trie());
                cur = cur.children[name];
            }
            cur.reference = i;
        }

        IList<string> ans = new List<string>();
        DFS(folder, ans, root);
        return ans;
    }

    public IList<string> Split(string s) {
        IList<string> ret = new List<string>();
        StringBuilder cur = new StringBuilder();
        foreach (char ch in s) {
            if (ch == '/') {
                ret.Add(cur.ToString());
                cur.Length = 0;
            } else {
                cur.Append(ch);
            }
        }
        ret.Add(cur.ToString());
        return ret;
    }

    public void DFS(string[] folder, IList<string> ans, Trie cur) {
        if (cur.reference != -1) {
            ans.Add(folder[cur.reference]);
            return;
        }
        foreach (Trie child in cur.children.Values) {
            DFS(folder, ans, child);
        }
    }
}

public class Trie {
    public int reference;
    public IDictionary<string, Trie> children;

    public Trie() {
        reference = -1;
        children = new Dictionary<string, Trie>();
    }
}
```

```Python [sol2-Python3]
class Trie:
    def __init__(self):
        self.children = dict()
        self.ref = -1

class Solution:
    def removeSubfolders(self, folder: List[str]) -> List[str]:
        root = Trie()
        for i, path in enumerate(folder):
            path = path.split("/")
            cur = root
            for name in path:
                if name not in cur.children:
                    cur.children[name] = Trie()
                cur = cur.children[name]
            cur.ref = i
        
        ans = list()

        def dfs(cur: Trie):
            if cur.ref != -1:
                ans.append(folder[cur.ref])
                return
            for child in cur.children.values():
                dfs(child)

        dfs(root)
        return ans
```

```C [sol2-C]
typedef struct {
    char *key;
    struct Trie *val;
    UT_hash_handle hh;
} HashItem; 

typedef struct Trie {
    HashItem *children;
    int ref;
} Trie;

Trie *creatTrie() {
    Trie *obj = (Trie *)malloc(sizeof(Trie));
    obj->children = NULL;
    obj->ref = -1;
    return obj;
}

HashItem *hashFindItem(HashItem **obj, char *key) {
    HashItem *pEntry = NULL;
    HASH_FIND_STR(*obj, key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, char *key, Trie *val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_STR(*obj, key, pEntry);
    return true;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);             
    }
}

char **split(char *str, int *returnSize) {
    int len = strlen(str);
    char **ret = (char *)malloc(sizeof(char *) * len);
    char *p = strtok(str, "/");
    int pos = 0;
    while (p != NULL) {
        ret[pos++] = p;
        p = strtok(NULL, "/");
    }
    *returnSize = pos;
    return ret;
}

void dfs(Trie* cur, char **res, int *pos, char **folder) {
    if (cur->ref != -1) {
        res[(*pos)++] = folder[cur->ref];
        return;
    }

    for (HashItem *pEntry = cur->children; pEntry != NULL; pEntry = pEntry->hh.next) {
        dfs(pEntry->val, res, pos, folder);
    }
};

void freeTrie(Trie* root) {
    for (HashItem *pEntry = root->children; pEntry != NULL; pEntry = pEntry->hh.next) {
        freeTrie(pEntry->val);
    }
}

char ** removeSubfolders(char ** folder, int folderSize, int* returnSize) {
    Trie *root = creatTrie();
    char **copy = (char **)malloc(sizeof(char *) * folderSize); 
    for (int i = 0; i < folderSize; ++i) {
        copy[i] = (char *)malloc(sizeof(char) * (strlen(folder[i]) + 1));
        strcpy(copy[i], folder[i]);
        int pathSize = 0;
        char **path = split(copy[i], &pathSize);
        Trie *cur = root;
        for (int j = 0; j < pathSize; j++) {
            char *name = path[j];
            HashItem *pEntry = hashFindItem(&cur->children, name);
            Trie *node = NULL;
            if (pEntry == NULL) {
                node = creatTrie();
                hashAddItem(&cur->children, name, node);
            } else {
                node = pEntry->val;
            }
            cur = node;
        }
        free(path);
        cur->ref = i;
    }
    char **ans = (char **)malloc(sizeof(char *) * folderSize);
    int pos = 0;
    dfs(root, ans, &pos, folder);
    freeTrie(root);
    for (int i = 0; i < folderSize; i++) {
        free(copy[i]);
    }
    free(copy);
    *returnSize = pos;
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var removeSubfolders = function(folder) {
    const root = new Trie();
    for (let i = 0; i < folder.length; ++i) {
        const path = split(folder[i]);
        let cur = root;
        for (const name of path) {
            if (!cur.children.has(name)) {
                cur.children.set(name, new Trie());
            }
            cur = cur.children.get(name);
        }
        cur.ref = i;
    }

    const ans = [];

    const dfs = (folder, ans, cur) => {
        if (cur.ref !== -1) {
            ans.push(folder[cur.ref]);
            return;
        }
        for (const child of cur.children.values()) {
            dfs(folder, ans, child);
        }
    }

    dfs(folder, ans, root);
    return ans;
}

const split = (s) => {
    const ret = [];
    let cur = '';
    for (let i = 0; i < s.length; ++i) {
        const ch = s[i];
        if (ch === '/') {
            ret.push(cur);
            cur = ''
        } else {
            cur += ch;
        }
    }
    ret.push(cur);
    return ret;
}

class Trie {
    constructor() {
        this.ref = -1;
        this.children = new Map();
    }
}
```

**复杂度分析**

- 时间复杂度：$O(nl)$，其中 $n$ 和 $l$ 分别是数组 $\textit{folder}$ 的长度和文件夹的平均长度。即为构造字典树和答案需要的时间。

- 空间复杂度：$O(nl)$，即为字典树需要使用的空间。注意这里不计入返回值占用的空间。
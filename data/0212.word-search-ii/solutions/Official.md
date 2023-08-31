## [212.单词搜索 II 中文官方题解](https://leetcode.cn/problems/word-search-ii/solutions/100000/dan-ci-sou-suo-ii-by-leetcode-solution-7494)

#### 方法一：回溯 + 字典树

**预备知识**

前缀树（字典树）是一种树形数据结构，用于高效地存储和检索字符串数据集中的键。前缀树可以用 $O(|S|)$ 的时间复杂度完成如下操作，其中 $|S|$ 是插入字符串或查询前缀的长度：

- 向前缀树中插入字符串 $\textit{word}$；

- 查询前缀串 $\textit{prefix}$ 是否为已经插入到前缀树中的任意一个字符串 $\textit{word}$ 的前缀；

前缀树的实现可以参考「[208. 实现 Trie (前缀树) 的官方题解](https://leetcode-cn.com/problems/implement-trie-prefix-tree/solution/shi-xian-trie-qian-zhui-shu-by-leetcode-ti500/)」。

**思路和算法**

根据题意，我们需要逐个遍历二维网格中的每一个单元格；然后搜索从该单元格出发的所有路径，找到其中对应 $\textit{words}$ 中的单词的路径。因为这是一个回溯的过程，所以我们有如下算法：

- 遍历二维网格中的所有单元格。

- 深度优先搜索所有从当前正在遍历的单元格出发的、由相邻且不重复的单元格组成的路径。因为题目要求同一个单元格内的字母在一个单词中不能被重复使用；所以我们在深度优先搜索的过程中，每经过一个单元格，都将该单元格的字母临时修改为特殊字符（例如 `#`），以避免再次经过该单元格。

- 如果当前路径是 $\textit{words}$ 中的单词，则将其添加到结果集中。如果当前路径是 $words$ 中任意一个单词的前缀，则继续搜索；反之，如果当前路径不是 $words$ 中任意一个单词的前缀，则剪枝。我们可以将 $\textit{words}$ 中的所有字符串先添加到前缀树中，而后用 $O(|S|)$ 的时间复杂度查询当前路径是否为 $\textit{words}$ 中任意一个单词的前缀。

在具体实现中，我们需要注意如下情况：

- 因为同一个单词可能在多个不同的路径中出现，所以我们需要使用哈希集合对结果集去重。

- 在回溯的过程中，我们不需要每一步都判断完整的当前路径是否是 $words$ 中任意一个单词的前缀；而是可以记录下路径中每个单元格所对应的前缀树结点，每次只需要判断新增单元格的字母是否是上一个单元格对应前缀树结点的子结点即可。

**代码**

```Python [sol1-Python3]
from collections import defaultdict


class Trie:
    def __init__(self):
        self.children = defaultdict(Trie)
        self.word = ""

    def insert(self, word):
        cur = self
        for c in word:
            cur = cur.children[c]
        cur.is_word = True
        cur.word = word


class Solution:
    def findWords(self, board: List[List[str]], words: List[str]) -> List[str]:
        trie = Trie()
        for word in words:
            trie.insert(word)

        def dfs(now, i1, j1):
            if board[i1][j1] not in now.children:
                return

            ch = board[i1][j1]

            now = now.children[ch]
            if now.word != "":
                ans.add(now.word)

            board[i1][j1] = "#"
            for i2, j2 in [(i1 + 1, j1), (i1 - 1, j1), (i1, j1 + 1), (i1, j1 - 1)]:
                if 0 <= i2 < m and 0 <= j2 < n:
                    dfs(now, i2, j2)
            board[i1][j1] = ch

        ans = set()
        m, n = len(board), len(board[0])

        for i in range(m):
            for j in range(n):
                dfs(trie, i, j)

        return list(ans)
```

```Java [sol1-Java]
class Solution {
    int[][] dirs = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};

    public List<String> findWords(char[][] board, String[] words) {
        Trie trie = new Trie();
        for (String word : words) {
            trie.insert(word);
        }

        Set<String> ans = new HashSet<String>();
        for (int i = 0; i < board.length; ++i) {
            for (int j = 0; j < board[0].length; ++j) {
                dfs(board, trie, i, j, ans);
            }
        }

        return new ArrayList<String>(ans);
    }

    public void dfs(char[][] board, Trie now, int i1, int j1, Set<String> ans) {
        if (!now.children.containsKey(board[i1][j1])) {
            return;
        }
        char ch = board[i1][j1];
        now = now.children.get(ch);
        if (!"".equals(now.word)) {
            ans.add(now.word);
        }

        board[i1][j1] = '#';
        for (int[] dir : dirs) {
            int i2 = i1 + dir[0], j2 = j1 + dir[1];
            if (i2 >= 0 && i2 < board.length && j2 >= 0 && j2 < board[0].length) {
                dfs(board, now, i2, j2, ans);
            }
        }
        board[i1][j1] = ch;
    }
}

class Trie {
    String word;
    Map<Character, Trie> children;
    boolean isWord;

    public Trie() {
        this.word = "";
        this.children = new HashMap<Character, Trie>();
    }

    public void insert(String word) {
        Trie cur = this;
        for (int i = 0; i < word.length(); ++i) {
            char c = word.charAt(i);
            if (!cur.children.containsKey(c)) {
                cur.children.put(c, new Trie());
            }
            cur = cur.children.get(c);
        }
        cur.word = word;
    }
}
```

```C# [sol1-C#]
public class Solution {
    int[][] dirs = new int[][] {
        new int[]{1, 0},
        new int[]{-1, 0},
        new int[]{0, 1},
        new int[]{0, -1}
    };

    public IList<string> FindWords(char[][] board, string[] words) {
        Trie trie = new Trie();
        foreach (string word in words) {
            trie.Insert(word);
        }

        ISet<string> ans = new HashSet<string>();
        for (int i = 0; i < board.Length; ++i) {
            for (int j = 0; j < board[0].Length; ++j) {
                DFS(board, trie, i, j, ans);
            }
        }

        return new List<string>(ans);
    }

    void DFS(char[][] board, Trie now, int i1, int j1, ISet<string> ans) {
        if (!now.children.ContainsKey(board[i1][j1])) {
            return;
        }
        char ch = board[i1][j1];
        now = now.children[ch];
        if (!"".Equals(now.word)) {
            ans.Add(now.word);
        }

        board[i1][j1] = '#';
        foreach (int[] dir in dirs) {
            int i2 = i1 + dir[0], j2 = j1 + dir[1];
            if (i2 >= 0 && i2 < board.Length && j2 >= 0 && j2 < board[0].Length) {
                DFS(board, now, i2, j2, ans);
            }
        }
        board[i1][j1] = ch;
    }
}

class Trie {
    public string word;
    public Dictionary<char, Trie> children;
    public bool isWord;

    public Trie() {
        this.word = "";
        this.children = new Dictionary<char, Trie>();
    }

    public void Insert(string word) {
        Trie cur = this;
        foreach (char c in word) {
            if (!cur.children.ContainsKey(c)) {
                cur.children.Add(c, new Trie());
            }
            cur = cur.children[c];
        }
        cur.word = word;
    }
}
```

```go [sol1-Golang]
type Trie struct {
    children [26]*Trie
    word     string
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
    node.word = word
}

var dirs = []struct{ x, y int }{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func findWords(board [][]byte, words []string) []string {
    t := &Trie{}
    for _, word := range words {
        t.Insert(word)
    }

    m, n := len(board), len(board[0])
    seen := map[string]bool{}

    var dfs func(node *Trie, x, y int)
    dfs = func(node *Trie, x, y int) {
        ch := board[x][y]
        node = node.children[ch-'a']
        if node == nil {
            return
        }

        if node.word != "" {
            seen[node.word] = true
        }

        board[x][y] = '#'
        for _, d := range dirs {
            nx, ny := x+d.x, y+d.y
            if 0 <= nx && nx < m && 0 <= ny && ny < n && board[nx][ny] != '#' {
                dfs(node, nx, ny)
            }
        }
        board[x][y] = ch
    }
    for i, row := range board {
        for j := range row {
            dfs(t, i, j)
        }
    }

    ans := make([]string, 0, len(seen))
    for s := range seen {
        ans = append(ans, s)
    }
    return ans
}
```

```C++ [sol1-C++]
struct TrieNode {
    string word;
    unordered_map<char,TrieNode *> children;
    TrieNode() {
        this->word = "";
    }   
};

void insertTrie(TrieNode * root,const string & word) {
    TrieNode * node = root;
    for (auto c : word){
        if (!node->children.count(c)) {
            node->children[c] = new TrieNode();
        }
        node = node->children[c];
    }
    node->word = word;
}

class Solution {
public:
    int dirs[4][2] = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};

    bool dfs(vector<vector<char>>& board, int x, int y, TrieNode * root, set<string> & res) {
        char ch = board[x][y];        
        if (!root->children.count(ch)) {
            return false;
        }
        root = root->children[ch];
        if (root->word.size() > 0) {
            res.insert(root->word);
        }

        board[x][y] = '#';
        for (int i = 0; i < 4; ++i) {
            int nx = x + dirs[i][0];
            int ny = y + dirs[i][1];
            if (nx >= 0 && nx < board.size() && ny >= 0 && ny < board[0].size()) {
                if (board[nx][ny] != '#') {
                    dfs(board, nx, ny, root,res);
                }
            }
        }
        board[x][y] = ch;

        return true;      
    }

    vector<string> findWords(vector<vector<char>> & board, vector<string> & words) {
        TrieNode * root = new TrieNode();
        set<string> res;
        vector<string> ans;

        for (auto & word: words){
            insertTrie(root,word);
        }
        for (int i = 0; i < board.size(); ++i) {
            for (int j = 0; j < board[0].size(); ++j) {
                dfs(board, i, j, root, res);
            }
        }        
        for (auto & word: res) {
            ans.emplace_back(word);
        }
        return ans;        
    }
};
```

**复杂度分析**

- 时间复杂度：$O(m \times n \times 3^{l-1})$，其中 $m$ 是二维网格的高度，$n$ 是二维网格的宽度，$l$ 是最长单词的长度。我们需要遍历 $m \times n$ 个单元格，每个单元格最多需要遍历 $4 \times 3^{l-1}$ 条路径。

- 空间复杂度：$O(k \times l)$，其中 $k$ 是 $\textit{words}$ 的长度，$l$ 是最长单词的长度。最坏情况下，我们需要 $O(k \times l)$ 用于存储前缀树。

#### 方法二：删除被匹配的单词

**思路和算法**

考虑以下情况。假设给定一个所有单元格都是 `a` 的二维字符网格和单词列表 `["a", "aa", "aaa", "aaaa"]` 。当我们使用方法一来找出所有同时在二维网格和单词列表中出现的单词时，我们需要遍历每一个单元格的所有路径，会找到大量重复的单词。

为了缓解这种情况，我们可以将匹配到的单词从前缀树中移除，来避免重复寻找相同的单词。因为这种方法可以保证每个单词只能被匹配一次；所以我们也不需要再对结果集去重了。

**代码**

```Python [sol2-Python3]
from collections import defaultdict


class Trie:
    def __init__(self):
        self.children = defaultdict(Trie)
        self.word = ""

    def insert(self, word):
        cur = self
        for c in word:
            cur = cur.children[c]
        cur.is_word = True
        cur.word = word


class Solution:
    def findWords(self, board: List[List[str]], words: List[str]) -> List[str]:
        trie = Trie()
        for word in words:
            trie.insert(word)
		
        def dfs(now, i1, j1):
            if board[i1][j1] not in now.children:
                return

            ch = board[i1][j1]

            nxt = now.children[ch]
            if nxt.word != "":
                ans.append(nxt.word)
                nxt.word = ""

            if nxt.children:
                board[i1][j1] = "#"
                for i2, j2 in [(i1 + 1, j1), (i1 - 1, j1), (i1, j1 + 1), (i1, j1 - 1)]:
                    if 0 <= i2 < m and 0 <= j2 < n:
                        dfs(nxt, i2, j2)
                board[i1][j1] = ch

            if not nxt.children:
                now.children.pop(ch)

        ans = []
        m, n = len(board), len(board[0])

        for i in range(m):
            for j in range(n):
                dfs(trie, i, j)

        return ans
```

```Java [sol2-Java]
class Solution {
    int[][] dirs = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};

    public List<String> findWords(char[][] board, String[] words) {
        Trie trie = new Trie();
        for (String word : words) {
            trie.insert(word);
        }

        Set<String> ans = new HashSet<String>();
        for (int i = 0; i < board.length; ++i) {
            for (int j = 0; j < board[0].length; ++j) {
                dfs(board, trie, i, j, ans);
            }
        }

        return new ArrayList<String>(ans);
    }

    public void dfs(char[][] board, Trie now, int i1, int j1, Set<String> ans) {
        if (!now.children.containsKey(board[i1][j1])) {
            return;
        }
        char ch = board[i1][j1];
        Trie nxt = now.children.get(ch);
        if (!"".equals(nxt.word)) {
            ans.add(nxt.word);
            nxt.word = "";
        }

        if (!nxt.children.isEmpty()) {
            board[i1][j1] = '#';
            for (int[] dir : dirs) {
                int i2 = i1 + dir[0], j2 = j1 + dir[1];
                if (i2 >= 0 && i2 < board.length && j2 >= 0 && j2 < board[0].length) {
                    dfs(board, nxt, i2, j2, ans);
                }
            }
            board[i1][j1] = ch;
        }

        if (nxt.children.isEmpty()) {
            now.children.remove(ch);
        }
    }
}

class Trie {
    String word;
    Map<Character, Trie> children;
    boolean isWord;

    public Trie() {
        this.word = "";
        this.children = new HashMap<Character, Trie>();
    }

    public void insert(String word) {
        Trie cur = this;
        for (int i = 0; i < word.length(); ++i) {
            char c = word.charAt(i);
            if (!cur.children.containsKey(c)) {
                cur.children.put(c, new Trie());
            }
            cur = cur.children.get(c);
        }
        cur.word = word;
    }
}
```

```C# [sol2-C#]
public class Solution {
    int[][] dirs = new int[][] {
        new int[]{1, 0},
        new int[]{-1, 0},
        new int[]{0, 1},
        new int[]{0, -1}
    };

    public IList<string> FindWords(char[][] board, string[] words) {
        Trie trie = new Trie();
        foreach (string word in words) {
            trie.Insert(word);
        }

        ISet<string> ans = new HashSet<string>();
        for (int i = 0; i < board.Length; ++i) {
            for (int j = 0; j < board[0].Length; ++j) {
                DFS(board, trie, i, j, ans);
            }
        }

        return new List<string>(ans);
    }

    void DFS(char[][] board, Trie now, int i1, int j1, ISet<string> ans) {
        if (!now.children.ContainsKey(board[i1][j1])) {
            return;
        }
        char ch = board[i1][j1];
        Trie nxt = now.children[ch];
        if (!"".Equals(nxt.word)) {
            ans.Add(nxt.word);
            nxt.word = "";
        }

        if (nxt.children.Count > 0) {
            board[i1][j1] = '#';
            int[][] dirs = new int[][] {
                new int[]{1, 0},
                new int[]{-1, 0},
                new int[]{0, 1},
                new int[]{0, -1}
            };
            foreach (int[] dir in dirs) {
                int i2 = i1 + dir[0], j2 = j1 + dir[1];
                if (i2 >= 0 && i2 < board.Length && j2 >= 0 && j2 < board[0].Length) {
                    DFS(board, nxt, i2, j2, ans);
                }
            }
            board[i1][j1] = ch;
        }

        if (nxt.children.Count == 0) {
            now.children.Remove(ch);
        }
    }
}

class Trie {
    public string word;
    public Dictionary<char, Trie> children;
    public bool isWord;

    public Trie() {
        this.word = "";
        this.children = new Dictionary<char, Trie>();
    }

    public void Insert(string word) {
        Trie cur = this;
        foreach (char c in word) {
            if (!cur.children.ContainsKey(c)) {
                cur.children.Add(c, new Trie());
            }
            cur = cur.children[c];
        }
        cur.word = word;
    }
}
```

```go [sol2-Golang]
type Trie struct {
    children map[byte]*Trie
    word     string
}

func (t *Trie) Insert(word string) {
    node := t
    for i := range word {
        ch := word[i]
        if node.children[ch] == nil {
            node.children[ch] = &Trie{children: map[byte]*Trie{}}
        }
        node = node.children[ch]
    }
    node.word = word
}

var dirs = []struct{ x, y int }{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func findWords(board [][]byte, words []string) (ans []string) {
    t := &Trie{children: map[byte]*Trie{}}
    for _, word := range words {
        t.Insert(word)
    }

    m, n := len(board), len(board[0])

    var dfs func(node *Trie, x, y int)
    dfs = func(node *Trie, x, y int) {
        ch := board[x][y]
        nxt := node.children[ch]
        if nxt == nil {
            return
        }

        if nxt.word != "" {
            ans = append(ans, nxt.word)
            nxt.word = ""
        }

        if len(nxt.children) > 0 {
            board[x][y] = '#'
            for _, d := range dirs {
                nx, ny := x+d.x, y+d.y
                if 0 <= nx && nx < m && 0 <= ny && ny < n && board[nx][ny] != '#' {
                    dfs(nxt, nx, ny)
                }
            }
            board[x][y] = ch
        }
        
        if len(nxt.children) == 0 {
            delete(node.children, ch)
        }
    }
    for i, row := range board {
        for j := range row {
            dfs(t, i, j)
        }
    }

    return
}
```

```C++ [sol2-C++]
struct TrieNode {
    string word;
    unordered_map<char, TrieNode *> children;
    TrieNode() {
        this->word = "";
    }   
};

void insertTrie(TrieNode * root, const string & word) {
    TrieNode * node = root;

    for (auto c : word) {
        if (!node->children.count(c)) {
            node->children[c] = new TrieNode();
        }
        node = node->children[c];
    }

    node->word = word;
}

class Solution {
public:
    int dirs[4][2] = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};

    bool dfs(vector<vector<char>>& board, int x, int y, TrieNode * root, set<string> & res) {
        char ch = board[x][y];   
     
        if (root == nullptr || !root->children.count(ch)) {
            return false;
        }

        TrieNode * nxt = root->children[ch];
        if (nxt->word.size() > 0) {
            res.insert(nxt->word);
            nxt->word = "";
        }
        if (!nxt->children.empty()) {
            board[x][y] = '#';
            for (int i = 0; i < 4; ++i) {
                int nx = x + dirs[i][0];
                int ny = y + dirs[i][1];
                if (nx >= 0 && nx < board.size() && ny >= 0 && ny < board[0].size()) {
                    if (board[nx][ny] != '#') {
                        dfs(board, nx, ny, nxt,res);
                    }
                }
            }
            board[x][y] = ch;
        }
        if (nxt->children.empty()) {
            root->children.erase(ch);
        }

        return true;      
    }

    vector<string> findWords(vector<vector<char>> & board, vector<string> & words) {
        TrieNode * root = new TrieNode();
        set<string> res;
        vector<string> ans;

        for (auto & word: words) {
            insertTrie(root,word);
        }
        for (int i = 0; i < board.size(); ++i) {
            for(int j = 0; j < board[0].size(); ++j) {
                dfs(board, i, j, root, res);
            }
        }        
        for (auto & word: res) {
            ans.emplace_back(word);
        }
        
        return ans;        
    }
};
```

**复杂度分析**

- 时间复杂度：$O(m \times n \times 3^{l-1})$，其中 $m$ 是二维网格的高度，$n$ 是二维网格的宽度，$l$ 是最长单词的长度。我们仍需要遍历 $m \times n$ 个单元格，每个单元格在最坏情况下仍需要遍历 $4 \times 3^{l-1}$ 条路径。

- 空间复杂度：$O(k \times l)$，其中 $k$ 是 $\textit{words}$ 的长度，$l$ 是最长单词的长度。最坏情况下，我们需要 $O(k \times l)$ 用于存储前缀树。
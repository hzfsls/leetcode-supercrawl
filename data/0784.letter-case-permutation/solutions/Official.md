#### 方法一：广度优先搜索

从左往右依次遍历字符，在队列中存储当前为已遍历过字符的字母大小全排列。例如当前字符串为:

> $s = \text{``abc"}$

假设我们当前已经遍历到字符的第 $2$ 个字符 $\text{`b'}$ 时，则此时队列中已经存储的序列为:

> $\text{``ab"},\text{``Ab"}, \text{``aB"}, \text{``AB"}$

当我们遍历下一个字符 $c$ 时：
+ 如果 $c$ 为一个数字，则队列中所有的序列的末尾均加上 $c$，将修改后的序列再次进入到队列中；
+ 如果 $c$ 为一个字母，此时我们在上述序列的末尾依次分别加上 $c$ 的小写形式 $\text{lowercase}(c)$ 和 $c$ 的大写形式 $\textit{uppercase}(c)$ 后，再次将上述数列放入队列；
+ 如果队列中当前序列的长度等于 $s$ 的长度，则表示当前序列已经搜索完成，该序列为全排列中的一个合法序列；

由于每个字符的大小写形式刚好差了 $32$，因此在大小写转换时可以用 $c \oplus 32$ 来进行转换。

```Python [sol1-Python3]
class Solution:
    def letterCasePermutation(self, s: str) -> List[str]:
        ans = []
        q = deque([''])
        while q:
            cur = q[0]
            pos = len(cur)
            if pos == len(s):
                ans.append(cur)
                q.popleft()
            else:
                if s[pos].isalpha():
                    q.append(cur + s[pos].swapcase())
                q[0] += s[pos]
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    vector<string> letterCasePermutation(string s) {
        vector<string> ans;
        queue<string> qu;
        qu.emplace("");
        while (!qu.empty()) {
            string &curr = qu.front();
            if (curr.size() == s.size()) {
                ans.emplace_back(curr);
                qu.pop();
            } else {
                int pos = curr.size();
                if (isalpha(s[pos])) {
                    string next = curr;
                    next.push_back(s[pos] ^ 32);
                    qu.emplace(next);
                }
                curr.push_back(s[pos]);                
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<String> letterCasePermutation(String s) {
        List<String> ans = new ArrayList<String>();
        Queue<StringBuilder> queue = new ArrayDeque<StringBuilder>();
        queue.offer(new StringBuilder());
        while (!queue.isEmpty()) {
            StringBuilder curr = queue.peek();
            if (curr.length() == s.length()) {
                ans.add(curr.toString());
                queue.poll();
            } else {
                int pos = curr.length();
                if (Character.isLetter(s.charAt(pos))) {
                    StringBuilder next = new StringBuilder(curr);
                    next.append((char) (s.charAt(pos) ^ 32));
                    queue.offer(next);
                }
                curr.append(s.charAt(pos));
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<string> LetterCasePermutation(string s) {
        IList<string> ans = new List<string>();
        Queue<StringBuilder> queue = new Queue<StringBuilder>();
        queue.Enqueue(new StringBuilder());
        while (queue.Count > 0) {
            StringBuilder curr = queue.Peek();
            if (curr.Length == s.Length) {
                ans.Add(curr.ToString());
                queue.Dequeue();
            } else {
                int pos = curr.Length;
                if (char.IsLetter(s[pos])) {
                    StringBuilder next = new StringBuilder(curr.ToString());
                    next.Append((char) (s[pos] ^ 32));
                    queue.Enqueue(next);
                }
                curr.Append(s[pos]);
            }
        }
        return ans;
    }
}
```

```C [sol1-C]
#define MAX_STR_LEN 16

typedef struct Node {
    char str[MAX_STR_LEN];
    struct Node *next;
} Node;

Node *creatNode(const char *str) {
    Node * node = (Node *)malloc(sizeof(Node));
    memset(node->str, 0, sizeof(node->str));
    strcpy(node->str, str);
    node->next = NULL;
    return node;
}

char ** letterCasePermutation(char * s, int* returnSize) {
    int n = strlen(s);
    char **ans = (char **)malloc(sizeof(char *) * (1 << n));
    int pos = 0;
    Node *head = NULL, *tail = NULL;
    head = tail = creatNode("");
    while (head) {
        char *curr = head->str;
        int len = strlen(curr);
        if (len == n) {
            ans[pos] = (char *)malloc(sizeof(char) * MAX_STR_LEN);
            strcpy(ans[pos], curr);
            pos++;
            Node *node = head;
            head = head->next;
            free(node);
        } else {
            if (isalpha(s[len])) {
                tail->next = creatNode(curr);
                tail = tail->next;
                tail->str[len] = s[len] ^ 32;
            }
            curr[len] = s[len];
        }
       
    }
    *returnSize = pos;
    return ans;
}
```

```go [sol1-Golang]
func letterCasePermutation(s string) (ans []string) {
    q := []string{""}
    for len(q) > 0 {
        cur := q[0]
        pos := len(cur)
        if pos == len(s) {
            ans = append(ans, cur)
            q = q[1:]
        } else {
            if unicode.IsLetter(rune(s[pos])) {
                q = append(q, cur+string(s[pos]^32))
            }
            q[0] += string(s[pos])
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var letterCasePermutation = function(s) {
    const ans = [];
    const q = [""];
    while (q.length !== 0) {
        let cur = q[0];
        const pos = cur.length;
        if (pos === s.length) {
            ans.push(cur);
            q.shift();
        } else {
            if (isLetter(s[pos])) {
                q.push(cur + swapCase(s[pos]));
            }
            q[0] += s[pos];
        }
    }
    return ans;
};

const swapCase = (ch) => {
    if ('a' <= ch && ch <= 'z') {
        return ch.toUpperCase();
    }
    if ('A' <= ch && ch <= 'Z') {
        return ch.toLowerCase();
    }
}

const isLetter = (ch) => {
    return 'a' <= ch && ch <= 'z' || 'A' <= ch && ch <= 'Z';
}
```

**复杂度分析**

- 时间复杂度：$O(n \times 2^n)$，其中 $n$ 表示字符串的长度。全排列的数目最多为 $2^n$ 个，每次生成一个新的序列的时间为 $O(n)$，因此时间复杂度为 $O(n \times 2^n)$。

- 空间复杂度：$O(n \times 2^n)$。其中 $n$ 表示字符串的长度。队列中的元素数目最多为 $2^n$ 个，每个序列需要的空间为 $O(n)$，因此空间复杂度为 $O(n \times 2^n)$。

#### 方法二：回溯

同样的思路我们还可以采用回溯的思想，从左往右依次遍历字符，当在进行搜索时，搜索到字符串 $s$ 的第 $i$ 个字符 $c$ 时:
+ 如果 $c$ 为一个数字，则我们继续检测下一个字符；
+ 如果 $c$ 为一个字母，我们将字符中的第 $i$ 个字符 $c$ 改变大小写形式后，往后继续搜索，完成改写形式的子状态搜索后，我们将 $c$ 进行恢复，继续往后搜索；
+ 如果当前完成字符串搜索后，则表示当前的子状态已经搜索完成，该序列为全排列中的一个；

由于每个字符的大小写形式刚好差了 $32$，因此在大小写装换时可以用 $c \oplus 32$ 来进行转换和恢复。

```Python [sol2-Python3]
class Solution:
    def letterCasePermutation(self, s: str) -> List[str]:
        ans = []
        def dfs(s: List[str], pos: int) -> None:
            while pos < len(s) and s[pos].isdigit():
                pos += 1
            if pos == len(s):
                ans.append(''.join(s))
                return
            dfs(s, pos + 1)
            s[pos] = s[pos].swapcase()
            dfs(s, pos + 1)
            s[pos] = s[pos].swapcase()
        dfs(list(s), 0)
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    void dfs(string &s, int pos, vector<string> &res) {
        while (pos < s.size() && isdigit(s[pos])) {
            pos++;
        }
        if (pos == s.size()) {
            res.emplace_back(s);
            return;
        }
        s[pos] ^= 32;
        dfs(s, pos + 1, res);
        s[pos] ^= 32;
        dfs(s, pos + 1, res);
    }

    vector<string> letterCasePermutation(string s) {
        vector<string> ans;
        dfs(s, 0, ans);
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<String> letterCasePermutation(String s) {
        List<String> ans = new ArrayList<String>();
        dfs(s.toCharArray(), 0, ans);
        return ans;
    }

    public void dfs(char[] arr, int pos, List<String> res) {
        while (pos < arr.length && Character.isDigit(arr[pos])) {
            pos++;
        }
        if (pos == arr.length) {
            res.add(new String(arr));
            return;
        }
        arr[pos] ^= 32;
        dfs(arr, pos + 1, res);
        arr[pos] ^= 32;
        dfs(arr, pos + 1, res);
    }
}
```

```C# [sol2-C#]
public class Solution {
    public IList<string> LetterCasePermutation(string s) {
        IList<string> ans = new List<string>();
        DFS(s.ToCharArray(), 0, ans);
        return ans;
    }

    public void DFS(char[] arr, int pos, IList<string> res) {
        while (pos < arr.Length && char.IsDigit(arr[pos])) {
            pos++;
        }
        if (pos == arr.Length) {
            res.Add(new string(arr));
            return;
        }
        arr[pos] = (char) (arr[pos] ^ 32);
        DFS(arr, pos + 1, res);
        arr[pos] = (char) (arr[pos] ^ 32);
        DFS(arr, pos + 1, res);
    }
}
```

```C [sol2-C]
void dfs(char *s, int pos, char **res,int* returnSize) {
    while (s[pos] != '\0' && isdigit(s[pos])) {
        pos++;
    }
    if (s[pos] == '\0') {
        res[*returnSize] = (char *)malloc(sizeof(char) * (strlen(s) + 1));
        strcpy(res[*returnSize], s);
        (*returnSize)++;
        return;
    }
    s[pos] ^= 32;
    dfs(s, pos + 1, res, returnSize);
    s[pos] ^= 32;
    dfs(s, pos + 1, res, returnSize);
}

char ** letterCasePermutation(char * s, int* returnSize) {
    int n = strlen(s);
    *returnSize = 0;
    char **ans = (char **)malloc(sizeof(char *) * (1 << n));
    dfs(s, 0, ans, returnSize);
    return ans;
}
```

```go [sol2-Golang]
func letterCasePermutation(s string) (ans []string) {
    var dfs func([]byte, int)
    dfs = func(s []byte, pos int) {
        for pos < len(s) && unicode.IsDigit(rune(s[pos])) {
            pos++
        }
        if pos == len(s) {
            ans = append(ans, string(s))
            return
        }
        dfs(s, pos+1)
        s[pos] ^= 32
        dfs(s, pos+1)
        s[pos] ^= 32
    }
    dfs([]byte(s), 0)
    return
}
```

```JavaScript [sol2-JavaScript]
var letterCasePermutation = function(s) {
    const ans = [];
    const dfs = (arr, pos, res) => {
        while (pos < arr.length && isDigit(arr[pos])) {
            pos++;
        }
        if (pos === arr.length) {
            res.push(arr.join(""));
            return;
        }
        arr[pos] = String.fromCharCode(arr[pos].charCodeAt() ^ 32);
        dfs(arr, pos + 1, res);
        arr[pos] = String.fromCharCode(arr[pos].charCodeAt() ^ 32);
        dfs(arr, pos + 1, res);
        }
    dfs([...s], 0, ans);
    return ans;
};

const isDigit = (ch) => {
    return parseFloat(ch).toString() === "NaN" ? false : true;
}

```

**复杂度分析**

- 时间复杂度：$O(n \times 2^n)$，其中 $n$ 表示字符串的长度。递归深度最多为 $n$，所有可能的递归子状态最多为 $2^n$ 个，每次个子状态的搜索时间为 $O(n)$，因此时间复杂度为 $O(n \times 2^n)$。

- 空间复杂度：$O(n \times 2^n)$。递归深度最多为 $n$，所有可能的递归子状态最多为 $2^n$ 个，每次个子状态的搜索时间为 $O(n)$，因此时间复杂度为 $O(n \times 2^n)$。

#### 方法三：二进制位图

假设字符串 $s$ 有 $m$ 个字母，那么全排列就有 $2^m$ 个字符串序列，且可以用位掩码 $\textit{bits}$ 唯一地表示一个字符串。
+ $\textit{bits}$ 的第 $i$ 为 $0$ 表示字符串 $s$ 中从左往右第 $i$ 个字母为小写形式；
+ $\textit{bits}$ 的第 $i$ 为 $1$ 表示字符串 $s$ 中从左往右第 $i$ 个字母为大写形式；

我们采用的位掩码只计算字符串 $s$ 中的字母，对于数字则直接跳过，通过位图计算从而构造正确的全排列。我们依次检测字符串第 $i$ 个字符串 $c$：
+ 如果字符串 $c$ 为数字，则我们直接在当前的序列中添加字符串 $c$；
+ 如果字符串 $c$ 为字母，且 $c$ 为字符串中的第 $k$ 个字母，如果掩码 $bits$ 中的第 $k$ 位为 $0$，则添加字符串 $c$ 的小写形式；如果掩码 $bits$ 中的第 $k$ 位为 $1$，则添加字符串 $c$ 的大写形式；

```Python [sol3-Python3]
class Solution:
    def letterCasePermutation(self, s: str) -> List[str]:
        ans = []
        m = sum(c.isalpha() for c in s)
        for mask in range(1 << m):
            t, k = [], 0
            for c in s:
                if c.isalpha():
                    t.append(c.upper() if mask >> k & 1 else c.lower())
                    k += 1
                else:
                    t.append(c)
            ans.append(''.join(t))
        return ans
```

```C++ [sol3-C++]
class Solution {
public:
    vector<string> letterCasePermutation(string s) {
        int n = s.size();
        int m = 0;
        for (auto c : s) {
            if (isalpha(c)) {
                m++;
            }
        }
        vector<string> ans;
        for (int mask = 0; mask < (1 << m); mask++) {
            string str;
            for (int j = 0, k = 0; j < n; j++) {
                if (isalpha(s[j]) && (mask & (1 << k++))) {
                    str.push_back(toupper(s[j]));
                } else {
                    str.push_back(tolower(s[j]));
                }
            }
            ans.emplace_back(str);
        }
        return ans;
    }
};
```

```Java [sol3-Java]
class Solution {
    public List<String> letterCasePermutation(String s) {
        int n = s.length();
        int m = 0;
        for (int i = 0; i < n; i++) {
            if (Character.isLetter(s.charAt(i))) {
                m++;
            }
        }
        List<String> ans = new ArrayList<String>();
        for (int mask = 0; mask < (1 << m); mask++) {
            StringBuilder sb = new StringBuilder();
            for (int j = 0, k = 0; j < n; j++) {
                if (Character.isLetter(s.charAt(j)) && (mask & (1 << k++)) != 0) {
                    sb.append(Character.toUpperCase(s.charAt(j)));
                } else {
                    sb.append(Character.toLowerCase(s.charAt(j)));
                }
            }
            ans.add(sb.toString());
        }
        return ans;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public IList<string> LetterCasePermutation(string s) {
        int n = s.Length;
        int m = 0;
        for (int i = 0; i < n; i++) {
            if (char.IsLetter(s[i])) {
                m++;
            }
        }
        IList<string> ans = new List<string>();
        for (int mask = 0; mask < (1 << m); mask++) {
            StringBuilder sb = new StringBuilder();
            for (int j = 0, k = 0; j < n; j++) {
                if (char.IsLetter(s[j]) && (mask & (1 << k++)) != 0) {
                    sb.Append(char.ToUpper(s[j]));
                } else {
                    sb.Append(char.ToLower(s[j]));
                }
            }
            ans.Add(sb.ToString());
        }
        return ans;
    }
}
```

```C [sol3-C]
char ** letterCasePermutation(char * s, int* returnSize){
    int n = strlen(s);
    int m = 0;
    for (int i = 0; i < n; i++) {
        if (isalpha(s[i])) {
            m++;
        }
    }
    char **ans = (char **)malloc(sizeof(char *) * (1 << m));
    for (int mask = 0; mask < (1 << m); mask++) {
        ans[mask] = (char *)malloc(sizeof(char) * (n + 1));
        ans[mask][n] = '\0';
        for (int j = 0, k = 0; j < n; j++) {
            if (isalpha(s[j]) && (mask & (1 << k++))) {
                ans[mask][j] = toupper(s[j]);
            } else {
                ans[mask][j] = tolower(s[j]);
            }
        }
    }
    *returnSize = (1 << m);
    return ans;
}
```

```go [sol3-Golang]
func letterCasePermutation(s string) (ans []string) {
    m := 0
    for _, c := range s {
        if unicode.IsLetter(c) {
            m++
        }
    }
    for mask := 0; mask < 1<<m; mask++ {
        t, k := []rune(s), 0
        for i, c := range t {
            if unicode.IsLetter(c) {
                if mask>>k&1 > 0 {
                    t[i] = unicode.ToUpper(c)
                } else {
                    t[i] = unicode.ToLower(c)
                }
                k++
            }
        }
        ans = append(ans, string(t))
    }
    return
}
```

```JavaScript [sol3-JavaScript]
var letterCasePermutation = function(s) {
    const n = s.length;
    let m = 0;
    for (let i = 0; i < n; i++) {
        if (isLetter(s[i])) {
            m++;
        }
    }
    const ans = [];
    for (let mask = 0; mask < (1 << m); mask++) {
        let sb = '';
        for (let j = 0, k = 0; j < n; j++) {
            if (isLetter(s[j]) && (mask & (1 << k++)) !== 0) {
                sb += s[j].toUpperCase();
            } else {
                sb += s[j].toLowerCase();
            }
        }
        ans.push(sb);
    }
    return ans;
};

const isDigit = (ch) => {
    return parseFloat(ch).toString() === "NaN" ? false : true;
}

const isLetter = (ch) => {
    return 'a' <= ch && ch <= 'z' || 'A' <= ch && ch <= 'Z';
}
```

**复杂度分析**

- 时间复杂度：$O(n \times 2^n)$，其中 $n$ 表示字符串的长度。最多有 $2^n$ 个序列，生成每个序列的时间为 $O(n)$，总的时间复杂度为 $O(n \times 2^n)$。

- 空间复杂度：$O(1)$。除返回值以外不需要额外的空间。
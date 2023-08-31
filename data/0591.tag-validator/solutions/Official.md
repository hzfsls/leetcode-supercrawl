## [591.标签验证器 中文官方题解](https://leetcode.cn/problems/tag-validator/solutions/100000/biao-qian-yan-zheng-qi-by-leetcode-solut-fecy)
#### 方法一：栈 + 字符串遍历

**思路与算法**

本题是一道解析字符串的题目，涉及到标签的闭合。由于标签具有「最先开始的标签最后结束」的特性，因此我们可以考虑使用一个栈存储当前开放的标签。除此之外，我们还需要考虑 $\text{cdata}$ 以及一般的字符，二者都可以使用遍历 + 判断的方法直接进行验证。

我们可以对字符串 $\textit{code}$ 进行一次遍历。在遍历的过程中，根据遍历到位置 $i$ 的当前字符，采取对应的判断：

- 如果当前的字符为 $\texttt{<}$，那么需要考虑下面的四种情况：

    - 如果下一个字符为 $\texttt{/}$，那么说明我们遇到了一个结束标签。我们需要定位下一个 $\texttt{>}$ 的位置 $j$，此时 $\textit{code}[i+2..j-1]$ 就是该结束标签的名称。我们需要判断该名称与当前栈顶的名称是否匹配，如果匹配，说明名称的标签已经闭合，我们需要将当前栈顶的名称弹出。同时根据规则 $1$，我们需要保证整个 $\textit{code}$ 被闭合标签包围，因此如果栈中已经没有标签，但是 $j$ 并不是 $\textit{code}$ 的末尾，那么说明后续还会有字符，它们不被闭合标签包围。

    - 如果下一个字符为 $\texttt{!}$，那么说明我们遇到了一个 $\text{cdata}$，我们需要继续往后读 $7$ 个字符，判断其是否为 $\texttt{[CDATA[}$。在这之后，我们定位下一个 $\texttt{]]>}$ 的位置 $j$，此时 $\textit{code}[i+9..j-1]$ 就是 $\text{cdata}$ 中的内容，它不需要被解析，所以我们也不必进行任何验证。需要注意的是，根据规则 $1$，栈中需要存在至少一个开放的标签。

    - 如果下一个字符为大写字母，那么说明我们遇到了一个开始标签。我们需要定位下一个 $\texttt{>}$ 的位置 $j$，此时 $\textit{code}[i+2..j-1]$ 就是该开始标签的名称。我们需要判断该名称是否恰好由 $1$ 至 $9$ 个大写字母组成，如果是，说明该标签合法，我们需要将该名称放入栈顶。

    - 除此之外，如果不存在下一个字符，或者下一个字符不属于上述三种情况，那么 $\textit{code}$ 是不合法的。

- 如果当前的字符为其它字符，那么根据规则 $1$，栈中需要存在至少一个开放的标签。

在遍历完成后，我们还需要保证此时栈中没有任何（还没有结束的）标签。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool isValid(string code) {
        int n = code.size();
        stack<string> tags;

        int i = 0;
        while (i < n) {
            if (code[i] == '<') {
                if (i == n - 1) {
                    return false;
                }
                if (code[i + 1] == '/') {
                    int j = code.find('>', i);
                    if (j == string::npos) {
                        return false;
                    }
                    string tagname = code.substr(i + 2, j - (i + 2));
                    if (tags.empty() || tags.top() != tagname) {
                        return false;
                    }
                    tags.pop();
                    i = j + 1;
                    if (tags.empty() && i != n) {
                        return false;
                    }
                }
                else if (code[i + 1] == '!') {
                    if (tags.empty()) {
                        return false;
                    }
                    string cdata = code.substr(i + 2, 7);
                    if (cdata != "[CDATA[") {
                        return false;
                    }
                    int j = code.find("]]>", i);
                    if (j == string::npos) {
                        return false;
                    }
                    i = j + 3;
                }
                else {
                    int j = code.find('>', i);
                    if (j == string::npos) {
                        return false;
                    }
                    string tagname = code.substr(i + 1, j - (i + 1));
                    if (tagname.size() < 1 || tagname.size() > 9) {
                        return false;
                    }
                    if (!all_of(tagname.begin(), tagname.end(), [](unsigned char c) { return isupper(c); })) {
                        return false;
                    }
                    tags.push(move(tagname));
                    i = j + 1;
                }
            }
            else {
                if (tags.empty()) {
                    return false;
                }
                ++i;
            }
        }

        return tags.empty();
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean isValid(String code) {
        int n = code.length();
        Deque<String> tags = new ArrayDeque<String>();

        int i = 0;
        while (i < n) {
            if (code.charAt(i) == '<') {
                if (i == n - 1) {
                    return false;
                }
                if (code.charAt(i + 1) == '/') {
                    int j = code.indexOf('>', i);
                    if (j < 0) {
                        return false;
                    }
                    String tagname = code.substring(i + 2, j);
                    if (tags.isEmpty() || !tags.peek().equals(tagname)) {
                        return false;
                    }
                    tags.pop();
                    i = j + 1;
                    if (tags.isEmpty() && i != n) {
                        return false;
                    }
                } else if (code.charAt(i + 1) == '!') {
                    if (tags.isEmpty()) {
                        return false;
                    }
                    if (i + 9 > n) {
                        return false;
                    }
                    String cdata = code.substring(i + 2, i + 9);
                    if (!"[CDATA[".equals(cdata)) {
                        return false;
                    }
                    int j = code.indexOf("]]>", i);
                    if (j < 0) {
                        return false;
                    }
                    i = j + 3;
                } else {
                    int j = code.indexOf('>', i);
                    if (j < 0) {
                        return false;
                    }
                    String tagname = code.substring(i + 1, j);
                    if (tagname.length() < 1 || tagname.length() > 9) {
                        return false;
                    }
                    for (int k = 0; k < tagname.length(); ++k) {
                        if (!Character.isUpperCase(tagname.charAt(k))) {
                            return false;
                        }
                    }
                    tags.push(tagname);
                    i = j + 1;
                }
            } else {
                if (tags.isEmpty()) {
                    return false;
                }
                ++i;
            }
        }

        return tags.isEmpty();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool IsValid(string code) {
        int n = code.Length;
        Stack<string> tags = new Stack<string>();

        int i = 0;
        while (i < n) {
            if (code[i] == '<') {
                if (i == n - 1) {
                    return false;
                }
                if (code[i + 1] == '/') {
                    int j = code.IndexOf('>', i);
                    if (j < 0) {
                        return false;
                    }
                    string tagname = code.Substring(i + 2, j - (i + 2));
                    if (tags.Count == 0 || !tags.Peek().Equals(tagname)) {
                        return false;
                    }
                    tags.Pop();
                    i = j + 1;
                    if (tags.Count == 0 && i != n) {
                        return false;
                    }
                } else if (code[i + 1] == '!') {
                    if (tags.Count == 0) {
                        return false;
                    }
                    if (i + 9 > n) {
                        return false;
                    }
                    string cdata = code.Substring(i + 2, 7);
                    if (!"[CDATA[".Equals(cdata)) {
                        return false;
                    }
                    int j = code.IndexOf("]]>", i);
                    if (j < 0) {
                        return false;
                    }
                    i = j + 3;
                } else {
                    int j = code.IndexOf('>', i);
                    if (j < 0) {
                        return false;
                    }
                    string tagname = code.Substring(i + 1, j - (i + 1));
                    if (tagname.Length < 1 || tagname.Length > 9) {
                        return false;
                    }
                    foreach (char c in tagname) {
                        if (!char.IsUpper(c)) {
                            return false;
                        }
                    }
                    tags.Push(tagname);
                    i = j + 1;
                }
            } else {
                if (tags.Count == 0) {
                    return false;
                }
                ++i;
            }
        }

        return tags.Count == 0;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def isValid(self, code: str) -> bool:
        n = len(code)
        tags = list()

        i = 0
        while i < n:
            if code[i] == "<":
                if i == n - 1:
                    return False
                if code[i + 1] == "/":
                    j = code.find(">", i)
                    if j == -1:
                        return False
                    tagname = code[i+2:j]
                    if not tags or tags[-1] != tagname:
                        return False
                    tags.pop()
                    i = j + 1
                    if not tags and i != n:
                        return False
                elif code[i + 1] == "!":
                    if not tags:
                        return False
                    cdata = code[i+2:i+9]
                    if cdata != "[CDATA[":
                        return False
                    j = code.find("]]>", i)
                    if j == -1:
                        return False
                    i = j + 3
                else:
                    j = code.find(">", i)
                    if j == -1:
                        return False
                    tagname = code[i+1:j]
                    if not 1 <= len(tagname) <= 9 or not all(ch.isupper() for ch in tagname):
                        return False
                    tags.append(tagname)
                    i = j + 1
            else:
                if not tags:
                    return False
                i += 1
        
        return not tags
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

bool isValid(char * code){
    int n = strlen(code);
    char ** tags = (char **)malloc(sizeof(char *) * n);

    int i = 0;
    int top = 0;
    while (i < n) {
        if (code[i] == '<') {
            if (i == n - 1) {
                return false;
            }
            if (code[i + 1] == '/') {
                char *p = strchr(code + i, '>');
                if (NULL == p) {
                    return false;
                }
                int j = p - code;
                if (top == 0 || strncmp(tags[top - 1], code + i + 2, j - (i + 2)) != 0) {
                    return false;
                }
                free(tags[top - 1]);
                top--;
                i = j + 1;
                if (top == 0 && i != n) {
                    return false;
                }
            } else if (code[i + 1] == '!') {
                if (top == 0) {
                    return false;
                }
                if (strncmp(code + i + 2, "[CDATA[", 7) != 0) {
                    return false;
                }
                char *p = strstr(code + i, "]]>");
                if (NULL == p) {
                    return false;
                }
                int j = p - code;
                i = j + 3;
            } else {
                char *p = strchr(code + i, '>');
                if (NULL == p) {
                    return false;
                }
                int j = p - code;
                int len = MIN(n - i - 1, j - (i + 1));
                if (len < 1 || len > 9) {
                    return false;
                }
                for (int k = 0; k < len; k++) {
                    if (!isupper(code[i + 1 + k])) {
                        return false;
                    }
                }
                char *tagname = (char *)malloc(sizeof(char) * (len + 1));
                strncpy(tagname, code + i + 1, len);
                tagname[len] = 0;
                tags[top++] = tagname;
                i = j + 1;
            }
        } else {
            if (top == 0) {
                return false;
            }
            ++i;
        }
    }
    return top == 0;
}
```

```JavaScript [sol1-JavaScript]
var isValid = function(code) {
    const n = code.length;
    const tags = [];

    let i = 0;
    while (i < n) {
        if (code[i] === '<') {
            if (i === n - 1) {
                return false;
            }
            if (code[i + 1] === '/') {
                const j = code.indexOf('>', i);
                if (j < 0) {
                    return false;
                }
                const tagname = code.slice(i + 2, j);
                if (tags.length === 0 || tags[tags.length - 1] !== tagname) {
                    return false;
                }
                tags.pop();
                i = j + 1;
                if (tags.length === 0 && i !== n) {
                    return false;
                }
            } else if (code[i + 1] === '!') {
                if (tags.length === 0) {
                    return false;
                }
                if (i + 9 > n) {
                    return false;
                }
                const cdata = code.slice(i + 2, i + 9);
                if ("[CDATA[" !== cdata) {
                    return false;
                }
                const j = code.indexOf("]]>", i);
                if (j < 0) {
                    return false;
                }
                i = j + 3;
            } else {
                const j = code.indexOf('>', i);
                if (j < 0) {
                    return false;
                }
                const tagname = code.slice(i + 1, j);
                if (tagname.length < 1 || tagname.length > 9) {
                    return false;
                }
                for (let k = 0; k < tagname.length; ++k) {
                    if (!(tagname[k] >= 'A' && tagname[k] <= 'Z')) {
                        return false;
                    }
                }
                tags.push(tagname);
                i = j + 1;
            }
        } else {
            if (tags.length === 0) {
                return false;
            }
            ++i;
        }
    }

    return tags.length === 0;
};
```

```go [sol1-Golang]
func isValid(code string) bool {
    tags := []string{}
    for code != "" {
        if code[0] != '<' {
            if len(tags) == 0 {
                return false
            }
            code = code[1:]
            continue
        }
        if len(code) == 1 {
            return false
        }
        if code[1] == '/' {
            j := strings.IndexByte(code, '>')
            if j == -1 {
                return false
            }
            if len(tags) == 0 || tags[len(tags)-1] != code[2:j] {
                return false
            }
            tags = tags[:len(tags)-1]
            code = code[j+1:]
            if len(tags) == 0 && code != "" {
                return false
            }
        } else if code[1] == '!' {
            if len(tags) == 0 || len(code) < 9 || code[2:9] != "[CDATA[" {
                return false
            }
            j := strings.Index(code, "]]>")
            if j == -1 {
                return false
            }
            code = code[j+3:]
        } else {
            j := strings.IndexByte(code, '>')
            if j == -1 {
                return false
            }
            tagName := code[1:j]
            if tagName == "" || len(tagName) > 9 {
                return false
            }
            for _, ch := range tagName {
                if !unicode.IsUpper(ch) {
                    return false
                }
            }
            tags = append(tags, tagName)
            code = code[j+1:]
        }
    }
    return len(tags) == 0
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{code}$ 的长度。我们只需要对 $\textit{code}$ 进行一次遍历。

- 空间复杂度：$O(n)$，即为栈存储标签名称需要使用的空间。
#### 方法一：栈

**思路与算法**

我们首先将给定的字符串 $\textit{path}$ 根据 $\texttt{/}$ 分割成一个由若干字符串组成的列表，记为 $\textit{names}$。根据题目中规定的「规范路径的下述格式」，$\textit{names}$ 中包含的字符串只能为以下几种：

- 空字符串。例如当出现多个连续的 $\texttt{/}$，就会分割出空字符串；

- 一个点 $\texttt{.}$；

- 两个点 $\texttt{..}$；

- 只包含英文字母、数字或 $\texttt{\_}$ 的目录名。

对于「空字符串」以及「一个点」，我们实际上无需对它们进行处理，因为「空字符串」没有任何含义，而「一个点」表示当前目录本身，我们无需切换目录。

对于「两个点」或者「目录名」，我们则可以用一个栈来维护路径中的每一个目录名。当我们遇到「两个点」时，需要将目录切换到上一级，因此只要栈不为空，我们就弹出栈顶的目录。当我们遇到「目录名」时，就把它放入栈。

这样一来，我们只需要遍历 $\textit{names}$ 中的每个字符串并进行上述操作即可。在所有的操作完成后，我们将从栈底到栈顶的字符串用 $\texttt{/}$ 进行连接，再在最前面加上 $\texttt{/}$ 表示根目录，就可以得到简化后的规范路径。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string simplifyPath(string path) {
        auto split = [](const string& s, char delim) -> vector<string> {
            vector<string> ans;
            string cur;
            for (char ch: s) {
                if (ch == delim) {
                    ans.push_back(move(cur));
                    cur.clear();
                }
                else {
                    cur += ch;
                }
            }
            ans.push_back(move(cur));
            return ans;
        };

        vector<string> names = split(path, '/');
        vector<string> stack;
        for (string& name: names) {
            if (name == "..") {
                if (!stack.empty()) {
                    stack.pop_back();
                }
            }
            else if (!name.empty() && name != ".") {
                stack.push_back(move(name));
            }
        }
        string ans;
        if (stack.empty()) {
            ans = "/";
        }
        else {
            for (string& name: stack) {
                ans += "/" + move(name);
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String simplifyPath(String path) {
        String[] names = path.split("/");
        Deque<String> stack = new ArrayDeque<String>();
        for (String name : names) {
            if ("..".equals(name)) {
                if (!stack.isEmpty()) {
                    stack.pollLast();
                }
            } else if (name.length() > 0 && !".".equals(name)) {
                stack.offerLast(name);
            }
        }
        StringBuffer ans = new StringBuffer();
        if (stack.isEmpty()) {
            ans.append('/');
        } else {
            while (!stack.isEmpty()) {
                ans.append('/');
                ans.append(stack.pollFirst());
            }
        }
        return ans.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string SimplifyPath(string path) {
        string[] names = path.Split("/");
        IList<string> stack = new List<string>();
        foreach (string name in names) {
            if ("..".Equals(name)) {
                if (stack.Count > 0) {
                    stack.RemoveAt(stack.Count - 1);
                }
            } else if (name.Length > 0 && !".".Equals(name)) {
                stack.Add(name);
            }
        }
        StringBuilder ans = new StringBuilder();
        if (stack.Count == 0) {
            ans.Append('/');
        } else {
            foreach (string name in stack) {
                ans.Append('/');
                ans.Append(name);
            }
        }
        return ans.ToString();
    }
}
```

```Python [sol1-Python3]
class Solution:
    def simplifyPath(self, path: str) -> str:
        names = path.split("/")
        stack = list()
        for name in names:
            if name == "..":
                if stack:
                    stack.pop()
            elif name and name != ".":
                stack.append(name)
        return "/" + "/".join(stack)
```

```C [sol1-C]
char ** split(const char * s, char delim, int * returnSize) {
    int n = strlen(s);
    char ** ans = (char **)malloc(sizeof(char *) * n);
    int pos = 0;
    int curr = 0;
    int len = 0;
    
    while (pos < n) {
        while (pos < n && s[pos] == delim) {
            ++pos;
        }
        curr = pos;
        while (pos < n && s[pos] != delim) {
            ++pos;
        }
        if (curr < n) {
            ans[len] = (char *)malloc(sizeof(char) * (pos - curr + 1)); 
            strncpy(ans[len], s + curr, pos - curr);
            ans[len][pos - curr] = '\0';
            ++len;
        }
    }
    *returnSize = len;
    return ans;
}

char * simplifyPath(char * path){
    int namesSize = 0;
    int n = strlen(path);
    char ** names = split(path, '/', &namesSize);
    char ** stack = (char **)malloc(sizeof(char *) * namesSize);
    int stackSize = 0;
    for (int i = 0; i < namesSize; ++i) {
        if (!strcmp(names[i], "..")) {
            if (stackSize > 0) {
                --stackSize;
            } 
        } else if (strcmp(names[i], ".")){
            stack[stackSize] = names[i];
            ++stackSize;
        } 
    }
    
    char * ans = (char *)malloc(sizeof(char) * (n + 1));
    int curr = 0;
    if (stackSize == 0) {
        ans[curr] = '/';
        ++curr;
    } else {
        for (int i = 0; i < stackSize; ++i) {
            ans[curr] = '/';
            ++curr;
            strcpy(ans + curr, stack[i]);
            curr += strlen(stack[i]);
        }
    }
    ans[curr] = '\0';
    for (int i = 0; i < namesSize; ++i) {
        free(names[i]);
    }
    free(names);
    free(stack);
    return ans;
}
```

```go [sol1-Golang]
func simplifyPath(path string) string {
    stack := []string{}
    for _, name := range strings.Split(path, "/") {
        if name == ".." {
            if len(stack) > 0 {
                stack = stack[:len(stack)-1]
            }
        } else if name != "" && name != "." {
            stack = append(stack, name)
        }
    }
    return "/" + strings.Join(stack, "/")
}
```

```JavaScript [sol1-JavaScript]
var simplifyPath = function(path) {
    const names = path.split("/");
    const stack = [];
    for (const name of names) {
        if (name === "..") {
            if (stack.length) {
                stack.pop();
            } 
        } else if (name.length && name !== ".") {
            stack.push(name);

        }
    }
    
    return "/" + stack.join("/");
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{path}$ 的长度。

- 空间复杂度：$O(n)$。我们需要 $O(n)$ 的空间存储 $\textit{names}$ 中的所有字符串。
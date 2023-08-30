#### 方法一：模拟

**思路与算法**

我们需要逐行分析源代码。每个字符有两种情况，要么在一个注释内要么不在。因此我们用 $\textit{in\_block}$ 变量来标记状态，该变量为 $\textit{true}$ 表示在注释内，反之则不在。

假设此刻不在注释块内：

- 遇到 $\text{`/*'}$，则将状态改为在注释块内，继续遍历后面第三个字符。
- 遇到 $\text{`//'}$，则直接忽略该行后面的部分。
- 遇到其他字符，将该字符记录到 $\textit{new\_line}$ 中。

假设此刻在注释块内，遇到 $\text{`*/'}$，则将状态改为不在注释块内，继续遍历后面第三个字符。

我们用 $\textit{new\_line}$ 记录新的一行，当遍历到每行的末尾时，如果不在注释块内并且 $\textit{new\_line}$ 不为空，就把它放入答案中。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<string> removeComments(vector<string>& source) {
        vector<string> res;
        string new_line = "";
        bool in_block = false;
        for (auto& line : source) {
            for (int i = 0; i < line.size(); i++) {
                if (in_block) {
                    if (i + 1 < line.size() && line[i] == '*' && line[i + 1] == '/') {
                        in_block = false;
                        i++;
                    }
                } else {
                    if (i + 1 < line.size() && line[i] == '/' && line[i + 1] == '*') {
                        in_block = true;
                        i++;
                    } else if (i + 1 < line.size() && line[i] == '/' && line[i + 1] == '/') {
                        break;
                    } else {
                        new_line += line[i];
                    }
                }
            }
            if (!in_block && new_line != "") {
                res.push_back(new_line);
                new_line = "";
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<String> removeComments(String[] source) {
        List<String> res = new ArrayList<String>();
        StringBuilder newLine = new StringBuilder();
        boolean inBlock = false;
        for (String line : source) {
            for (int i = 0; i < line.length(); i++) {
                if (inBlock) {
                    if (i + 1 < line.length() && line.charAt(i) == '*' && line.charAt(i + 1) == '/') {
                        inBlock = false;
                        i++;
                    }
                } else {
                    if (i + 1 < line.length() && line.charAt(i) == '/' && line.charAt(i + 1) == '*') {
                        inBlock = true;
                        i++;
                    } else if (i + 1 < line.length() && line.charAt(i) == '/' && line.charAt(i + 1) == '/') {
                        break;
                    } else {
                        newLine.append(line.charAt(i));
                    }
                }
            }
            if (!inBlock && newLine.length() > 0) {
                res.add(newLine.toString());
                newLine.setLength(0);
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<string> RemoveComments(string[] source) {
        IList<string> res = new List<string>();
        StringBuilder newLine = new StringBuilder();
        bool inBlock = false;
        foreach (string line in source) {
            for (int i = 0; i < line.Length; i++) {
                if (inBlock) {
                    if (i + 1 < line.Length && line[i] == '*' && line[i + 1] == '/') {
                        inBlock = false;
                        i++;
                    }
                } else {
                    if (i + 1 < line.Length && line[i] == '/' && line[i + 1] == '*') {
                        inBlock = true;
                        i++;
                    } else if (i + 1 < line.Length && line[i] == '/' && line[i + 1] == '/') {
                        break;
                    } else {
                        newLine.Append(line[i]);
                    }
                }
            }
            if (!inBlock && newLine.Length > 0) {
                res.Add(newLine.ToString());
                newLine.Length = 0;
            }
        }
        return res;
    }
}
```

```C [sol1-C]
#define MAX_LINE_LEN 80

char ** removeComments(char ** source, int sourceSize, int* returnSize) {
    char **res = (char **)calloc(sourceSize, sizeof(char *));
    char new_line[sourceSize * MAX_LINE_LEN + 1];
    int pos = 0, new_line_pos = 0;
    bool in_block = false;
    for (int j = 0; j < sourceSize; j++) {
        char *line = source[j];
        int line_size = strlen(line);
        for (int i = 0; i < line_size; i++) {
            if (in_block) {
                if (i + 1 < line_size && line[i] == '*' && line[i + 1] == '/') {
                    in_block = false;
                    i++;
                }
            } else {
                if (i + 1 < line_size && line[i] == '/' && line[i + 1] == '*') {
                    in_block = true;
                    i++;
                } else if (i + 1 < line_size && line[i] == '/' && line[i + 1] == '/') {
                    break;
                } else {
                    new_line[new_line_pos++] = line[i];
                }
            }
        }
        if (!in_block && new_line_pos > 0) {
            new_line[new_line_pos] = '\0';
            res[pos] = (char *)calloc(new_line_pos + 1, sizeof(char));
            strcpy(res[pos], new_line);
            pos++;
            new_line_pos = 0;
        }
        *returnSize = pos;
    }
    return res;
}
```

```Python [sol1-Python3]
class Solution:
    def removeComments(self, source: List[str]) -> List[str]:
        res = []
        new_line = []
        in_block = False
        for line in source:
            i = 0
            while i < len(line):
                if in_block:
                    if i + 1 < len(line) and line[i] == '*' and line[i + 1] == '/':
                        in_block = False
                        i += 1
                else:
                    if i + 1 < len(line) and line[i] == '/' and line[i + 1] == '*':
                        in_block = True
                        i += 1
                    elif i + 1 < len(line) and line[i] == '/' and line[i + 1] == '/':
                        break
                    else:
                        new_line.append(line[i])
                i += 1
                
            if  not in_block and len(new_line) > 0:
                res.append(''.join(new_line))
                new_line = []
        return res
```

```JavaScript [sol1-JavaScript]
var removeComments = function(source) {
    let res = [];
    let newLine = '';
    let inBlock = false;
    for (let line of source) {
        for (let i = 0; i < line.length; i++) {
            if (inBlock) {
                if (i + 1 < line.length && line[i] === '*' && line[i + 1] === '/') {
                    inBlock = false;
                    i++;
                }
            } else {
                if (i + 1 < line.length && line[i] === '/' && line[i + 1] === '*') {
                    inBlock = true;
                    i++;
                } else if (i + 1 < line.length && line[i] === '/' && line[i + 1] === '/') {
                    break;
                } else {
                    newLine += line[i];
                }
            }
        }
        if (!inBlock && newLine.length > 0) {
            res.push(newLine);
            newLine = '';
        }
    }
    return res;
};
```

```Go [sol1-Go]
func removeComments(source []string) []string {
    res := []string{}
    new_line := []byte{}
    in_block := false
    for _, line := range source {
        for i := 0; i < len(line); i++ {
            if in_block {
                if i + 1 < len(line) && line[i] == '*' && line[i + 1] == '/' {
                    in_block = false
                    i++
                }
            } else {
                if i + 1 < len(line) && line[i] == '/' && line[i + 1] == '*' {
                    in_block = true
                    i++
                } else if i + 1 < len(line) && line[i] == '/' && line[i + 1] == '/' {
                    break
                } else {
                    new_line = append(new_line, line[i])
                }
            }
        }
        if  !in_block && len(new_line) > 0 {
            res = append(res, string(new_line))
            new_line = []byte{}
        }
    }
    return res
}
```

**复杂度分析**

- 时间复杂度：$O(nm)$，其中 $n$ 是 $\textit{source}$ 的长度，$m$ 是 $\textit{source}[i]$ 的最大长度。

- 空间复杂度：$O(nm)$。在极端情况下，每一行的隐式换行符都被块注释删除，$\textit{new\_line}$ 的长度将会达到 $O(nm)$。
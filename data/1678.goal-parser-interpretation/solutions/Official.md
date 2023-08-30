#### 方法一：直接遍历

**思路与算法**

根据题意可以知道字符串 $\textit{command}$ 一定由三种不同的字符串 $\text{``G"},\text{``()"}, \text{``(al)}"$ 组合而成，其中的转换规则如下：
+  $\text{``G"}$ 转换为 $\text{``G"}$；
+  $\text{``()"}$ 转换为 $\text{``o"}$；
+  $\text{``(al)}$ 转换为 $\text{``al"}$；

由于三种不同的字符串由于模式不同，我们可以按照如下规则进行匹配：
+ 如果当前第 $i$ 个字符为 $\text{`G'}$，则表示当前字符串模式为 $\text{``G"}$，转换后的结果为 $\text{``G"}$，我们直接在结果中添加 $\text{``G"}$；

+ 如果当前第 $i$ 个字符为 $\text{`('}$，则表示当前字符串模式可能为 $\text{``()"}$ 或 $\text{``(al)"}$；
    - 如果第 $i+1$ 个字符为 $\text{`)'}$，则当前字符串模式为 $\text{``()"}$，我们应将其转换为 $\text{``o"}$；
    - 如果第 $i+1$ 个字符为 $\text{`a'}$，则当前字符串模式为 $\text{``(al)"}$，我们应将其转换为 $\text{``al"}$；

我们按照以上规则进行转换即可得到转换后的结果。

**代码**

```Python [sol1-Python3]
class Solution:
    def interpret(self, command: str) -> str:
        res = []
        for i, c in enumerate(command):
            if c == 'G':
                res.append(c)
            elif c == '(':
                res.append('o' if command[i + 1] == ')' else 'al')
        return ''.join(res)
```

```C++ [sol1-C++]
class Solution {
public:
    string interpret(string command) {
        string res;
        for (int i = 0; i < command.size(); i++) {
            if (command[i] == 'G') {
                res += "G";
            } else if (command[i] == '(') {
                if (command[i + 1] == ')') {
                    res += "o";
                } else {
                    res += "al";
                }
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String interpret(String command) {
        StringBuilder res = new StringBuilder();
        for (int i = 0; i < command.length(); i++) {
            if (command.charAt(i) == 'G') {
                res.append("G");
            } else if (command.charAt(i) == '(') {
                if (command.charAt(i + 1) == ')') {
                    res.append("o");
                } else {
                    res.append("al");
                }
            }
        }
        return res.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string Interpret(string command) {
        StringBuilder res = new StringBuilder();
        for (int i = 0; i < command.Length; i++) {
            if (command[i] == 'G') {
                res.Append("G");
            } else if (command[i] == '(') {
                if (command[i + 1] == ')') {
                    res.Append("o");
                } else {
                    res.Append("al");
                }
            }
        }
        return res.ToString();
    }
}
```

```C [sol1-C]
char * interpret(char * command) {
    int len = strlen(command);
    char *res = (char *)malloc(sizeof(char) * (len + 1));
    int pos = 0;
    for (int i = 0; i < len; i++) {
        if (command[i] == 'G') {
            pos += sprintf(res + pos, "%s", "G");
        } else if (command[i] == '(') {
            if (command[i + 1] == ')') {
                pos += sprintf(res + pos, "%s", "o");
            } else {
                pos += sprintf(res + pos, "%s", "al");
            }
        }
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var interpret = function(command) {
    let res = '';
    for (let i = 0; i < command.length; i++) {
        if (command[i] === 'G') {
            res += 'G';
        } else if (command[i] === '(') {
            if (command[i + 1] === ')') {
                res += 'o';
            } else {
                res += 'al';
            }
        }
    }
    return res;
};
```

```go [sol1-Golang]
func interpret(command string) string {
    res := &strings.Builder{}
    for i, c := range command {
        if c == 'G' {
            res.WriteByte('G')
        } else if c == '(' {
            if command[i+1] == ')' {
                res.WriteByte('o')
            } else {
                res.WriteString("al")
            }
        }
    }
    return res.String()
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 表示字符串的长度。我们只需遍历一遍字符串即可。

- 空间复杂度：$O(1)$。除返回值以外不需要额外的空间。
## [1021.删除最外层的括号 中文官方题解](https://leetcode.cn/problems/remove-outermost-parentheses/solutions/100000/shan-chu-zui-wai-ceng-de-gua-hao-by-leet-sux0)

#### 方法一：栈

**思路**

遍历 $s$，并用一个栈来表示括号的深度。遇到 $\text{`(’}$ 则将字符入栈，遇到 $\text{`)’}$ 则将栈顶字符出栈。栈从空到下一次空的过程，则是扫描了一个原语的过程。一个原语中，首字符和尾字符应该舍去，其他字符需放入结果字符串中。因此，在遇到 $\text{`(’}$ 并将字符入栈后，如果栈的深度为 $1$，则不把字符放入结果；在遇到 $\text{`)’}$ 并将栈顶字符出栈后，如果栈为空，则不把字符放入结果。其他情况下，需要把字符放入结果。代码对流程进行了部分优化，减少了判断语句。

**代码**

```Python [sol1-Python3]
class Solution:
    def removeOuterParentheses(self, s: str) -> str:
        res, stack = "", []
        for c in s:
            if c == ')':
                stack.pop()
            if stack:
                res += c
            if c == '(':
                stack.append(c)
        return res
```

```C++ [sol1-C++]
class Solution {
public:
    string removeOuterParentheses(string s) {
        string res;
        stack<char> st;
        for (auto c : s) {
            if (c == ')') {
                st.pop();
            }
            if (!st.empty()) {
                res.push_back(c);
            }
            if (c == '(') {
                st.emplace(c);
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String removeOuterParentheses(String s) {
        StringBuffer res = new StringBuffer();
        Deque<Character> stack = new ArrayDeque<Character>();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == ')') {
                stack.pop();
            }
            if (!stack.isEmpty()) {
                res.append(c);
            }
            if (c == '(') {
                stack.push(c);
            }
        }
        return res.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string RemoveOuterParentheses(string s) {
        StringBuilder res = new StringBuilder();
        Stack<char> stack = new Stack<char>();
        foreach (char c in s) {
            if (c == ')') {
                stack.Pop();
            }
            if (stack.Count > 0) {
                res.Append(c);
            }
            if (c == '(') {
                stack.Push(c);
            }
        }
        return res.ToString();
    }
}
```

```C [sol1-C]
char * removeOuterParentheses(char * s) {
    int len = strlen(s);
    char *res = (char *)malloc(sizeof(char) * len);
    char *stack = (char *)malloc(sizeof(char) * (len / 2));
    int pos = 0, top = 0;
    for (int i = 0; i < len; i++) {
        char c = s[i];
        if (c == ')') {
            top--;
        }
        if (top > 0) {
            res[pos++] = c;
        }
        if (c == '(') {
            stack[top++] = c;
        }
    }
    free(stack);
    res[pos] = '\0';
    return res;
}
```

```go [sol1-Golang]
func removeOuterParentheses(s string) string {
    var ans, st []rune
    for _, c := range s {
        if c == ')' {
            st = st[:len(st)-1]
        }
        if len(st) > 0 {
            ans = append(ans, c)
        }
        if c == '(' {
            st = append(st, c)
        }
    }
    return string(ans)
}
```

```JavaScript [sol1-JavaScript]
var removeOuterParentheses = function(s) {
    let res = '';
    const stack = [];
    for (let i = 0; i < s.length; i++) {
        const c = s[i];
        if (c === ')') {
            stack.pop();
        }
        if (stack.length) {
            res += c;
        }
        if (c === '(') {
            stack.push(c);
        }
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是输入 $s$ 的长度。仅需遍历 $s$ 一次。

- 空间复杂度：$O(n)$，其中 $n$ 是输入 $s$ 的长度。需要使用栈，长度最大为 $O(n)$。

#### 方法二：计数

**思路**

从 $s$ 开始位置计算子数组的和，遇到 $\text{`(’}$ 则加 $1$，遇到 $\text{`)’}$ 则减 $1$，第一次和为 $0$ 时则为第一个原语。从上一个原语的结束位置的下一个位置开始继续求子数组的和，和首次为 $0$ 时则是另一个新的原语，直到遇到 $s$ 的结尾。保存结果时，忽略每个原语的开始字符和结尾字符，其他字符均保存下来生成新的字符串。代码对流程进行了部分优化，减少了判断语句。

**代码**

```Python [sol2-Python3]
class Solution:
    def removeOuterParentheses(self, s: str) -> str:
        res, level = "", 0
        for c in s:
            if c == ')':
                level -= 1
            if level:
                res += c
            if c == '(':
                level += 1
        return res
```

```C++ [sol2-C++]
class Solution {
public:
    string removeOuterParentheses(string s) {
        int level = 0;
        string res;
        for (auto c : s) {
            if (c == ')') {
                level--;
            }
            if (level) {
                res.push_back(c);
            }
            if (c == '(') {
                level++;
            }
        }
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    public String removeOuterParentheses(String s) {
        int level = 0;
        StringBuffer res = new StringBuffer();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == ')') {
                level--;
            }
            if (level > 0) {
                res.append(c);
            }
            if (c == '(') {
                level++;
            }
        }
        return res.toString();
    }
}
```

```C# [sol2-C#]
public class Solution {
    public string RemoveOuterParentheses(string s) {
        int level = 0;
        StringBuilder res = new StringBuilder();
        foreach (char c in s) {
            if (c == ')') {
                level--;
            }
            if (level > 0) {
                res.Append(c);
            }
            if (c == '(') {
                level++;
            }
        }
        return res.ToString();
    }
}
```

```C [sol2-C]
char * removeOuterParentheses(char * s) {
    int len = strlen(s);
    int level = 0;
    char *res = (char *)malloc(sizeof(char) * (len + 1));
    int pos = 0;
    for (int i = 0; i < len; i++) {
        char c = s[i];
        if (c == ')') {
            level++;
        }
        if (level) {
            res[pos++] = c;
        }
        if (c == '(') {
            level--;
        }
    }
    res[pos] = '\0';    
    return res;
}
```

```go [sol2-Golang]
func removeOuterParentheses(s string) string {
    ans := []rune{}
    level := 0
    for _, c := range s {
        if c == ')' {
            level--
        }
        if level > 0 {
            ans = append(ans, c)
        }
        if c == '(' {
            level++
        }
    }
    return string(ans)
}
```

```JavaScript [sol2-JavaScript]
var removeOuterParentheses = function(s) {
    let level = 0;
    let res = '';
    for (let i = 0; i < s.length; i++) {
        const c = s[i];
        if (c === ')') {
            level--;
        }
        if (level > 0) {
            res += c;
        }
        if (c === '(') {
            level++;
        }
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是输入 $s$ 的长度。仅需遍历 $s$ 一次。

- 空间复杂度：$O(n)$，其中 $n$ 是输入 $s$ 的长度。需要用数组暂时保存结果，并转换为字符串。部分语言支持字符串的修改，可以做到 $O(1)$ 空间复杂度。
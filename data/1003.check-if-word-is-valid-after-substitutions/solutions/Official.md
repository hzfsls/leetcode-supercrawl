## [1003.检查替换后的词是否有效 中文官方题解](https://leetcode.cn/problems/check-if-word-is-valid-after-substitutions/solutions/100000/jian-cha-ti-huan-hou-de-ci-shi-fou-you-x-0247)

#### 方法一：栈

遍历字符串 $s$，将当前访问到的字符 $c$ 压入栈 $\textit{stk}$ 中，如果栈元素数目大于等于 $3$ 且栈顶的 $3$ 个元素依次等于 $\text{`a'}$、$\text{`b'}$ 和 $\text{`c'}$，那么将这三个元素出栈。如果最后栈为空，则字符串 $s$ 有效。

```C++ [sol1-C++]
class Solution {
public:
    bool isValid(string s) {
        string stk;
        for (auto c : s) {
            stk.push_back(c);
            if (stk.size() >= 3 && stk.substr(stk.size() - 3, 3) == "abc") {
                stk.erase(stk.end() - 3, stk.end());
            }
        }
        return stk.empty();
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean isValid(String s) {
        StringBuilder stk = new StringBuilder();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            stk.append(c);
            if (stk.length() >= 3 && stk.substring(stk.length() - 3).equals("abc")) {
                stk.delete(stk.length() - 3, stk.length());
            }
        }
        return stk.isEmpty();
    }
}
```

```Python [sol1-Python3]
class Solution:
    def isValid(self, s: str) -> bool:
        stk = []
        for c in s:
            stk.append(c)
            if ''.join(stk[-3:]) == "abc":
                stk[-3:] = []
        return len(stk) == 0
```

```C# [sol1-C#]
public class Solution {
    public bool IsValid(string s) {
        StringBuilder stk = new StringBuilder();
        foreach (char c in s) {
            stk.Append(c);
            if (stk.Length >= 3 && stk.ToString().Substring(stk.Length - 3).Equals("abc")) {
                stk.Remove(stk.Length - 3, 3);
            }
        }
        return stk.Length == 0;
    }
}
```

```Golang [sol1-Golang]
func isValid(s string) bool {
    stk := []byte{}
    for i, _ := range s {
        stk = append(stk, s[i])
        if len(stk) >= 3 && string(stk[len(stk) - 3:]) == "abc" {
            stk = stk[:len(stk) - 3]
        }
    }
    return len(stk) == 0
}
```

```C [sol1-C]
bool isValid(char * s) {
    int len = strlen(s);
    int top = 0;
    char stack[len];
    for (int i = 0; i < len; i++) {
        char c = s[i];
        stack[top++] = c;
        if (top >= 3 && strncmp(stack + top - 3, "abc", 3) == 0) {
            top -= 3;
        }
    }
    return top == 0;
}
```

```JavaScript [sol1-JavaScript]
var isValid = function(s) {
    const stk = [];
    for (let i = 0; i < s.length; i++) {
        const c = s[i];
        stk.push(c);
        if (stk.length >= 3 && stk.slice(stk.length - 3).join("") === "abc") {
            stk.splice(stk.length - 3, 3);
        }
    }
    return stk.length === 0;
};
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。

+ 空间复杂度：$O(n)$。栈需要占用 $O(n)$ 的空间。
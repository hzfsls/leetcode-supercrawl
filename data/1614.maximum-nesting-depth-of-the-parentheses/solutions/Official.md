## [1614.括号的最大嵌套深度 中文官方题解](https://leetcode.cn/problems/maximum-nesting-depth-of-the-parentheses/solutions/100000/gua-hao-de-zui-da-qian-tao-shen-du-by-le-av5b)
#### 方法一：遍历

对于括号计算类题目，我们往往可以用栈来思考。

遍历字符串 $s$，如果遇到了一个左括号，那么就将其入栈；如果遇到了一个右括号，那么就弹出栈顶的左括号，与该右括号匹配。这一过程中的栈的大小的最大值，即为 $s$ 的嵌套深度。

代码实现时，由于我们只需要考虑栈的大小，我们可以用一个变量 $\textit{size}$ 表示栈的大小，当遇到左括号时就将其加一，遇到右括号时就将其减一，从而表示栈中元素的变化。这一过程中 $\textit{size}$ 的最大值即为 $s$ 的嵌套深度。

```Python [sol1-Python3]
class Solution:
    def maxDepth(self, s: str) -> int:
        ans, size = 0, 0
        for ch in s:
            if ch == '(':
                size += 1
                ans = max(ans, size)
            elif ch == ')':
                size -= 1
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int maxDepth(string s) {
        int ans = 0, size = 0;
        for (char ch : s) {
            if (ch == '(') {
                ++size;
                ans = max(ans, size);
            } else if (ch == ')') {
                --size;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxDepth(String s) {
        int ans = 0, size = 0;
        for (int i = 0; i < s.length(); ++i) {
            char ch = s.charAt(i);
            if (ch == '(') {
                ++size;
                ans = Math.max(ans, size);
            } else if (ch == ')') {
                --size;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxDepth(string s) {
        int ans = 0, size = 0;
        foreach (char ch in s) {
            if (ch == '(') {
                ++size;
                ans = Math.Max(ans, size);
            } else if (ch == ')') {
                --size;
            }
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func maxDepth(s string) (ans int) {
    size := 0
    for _, ch := range s {
        if ch == '(' {
            size++
            if size > ans {
                ans = size
            }
        } else if ch == ')' {
            size--
        }
    }
    return
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int maxDepth(char * s){
    int ans = 0, size = 0;
    int n = strlen(s);
    for (int i = 0; i < n; ++i) {
        if (s[i] == '(') {
            ++size;
            ans = MAX(ans, size);
        } else if (s[i] == ')') {
            --size;
        }
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var maxDepth = function(s) {
    let ans = 0, size = 0;
    for (let i = 0; i < s.length; ++i) {
        const ch = s[i];
        if (ch === '(') {
            ++size;
            ans = Math.max(ans, size);
        } else if (ch === ')') {
            --size;
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{s}$ 的长度。

- 空间复杂度：$O(1)$。我们只需要常数空间来存放若干变量。
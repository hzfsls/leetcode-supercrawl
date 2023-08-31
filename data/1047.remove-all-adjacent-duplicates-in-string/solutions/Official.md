## [1047.删除字符串中的所有相邻重复项 中文官方题解](https://leetcode.cn/problems/remove-all-adjacent-duplicates-in-string/solutions/100000/shan-chu-zi-fu-chuan-zhong-de-suo-you-xi-4ohr)
#### 方法一：栈

充分理解题意后，我们可以发现，当字符串中同时有多组相邻重复项时，我们无论是先删除哪一个，都不会影响最终的结果。因此我们可以从左向右顺次处理该字符串。

而消除一对相邻重复项可能会导致新的相邻重复项出现，如从字符串 $\text{abba}$ 中删除 $\text{bb}$ 会导致出现新的相邻重复项 $\text{aa}$ 出现。因此我们需要保存当前还未被删除的字符。一种显而易见的数据结构呼之欲出：栈。我们只需要遍历该字符串，如果当前字符和栈顶字符相同，我们就贪心地将其消去，否则就将其入栈即可。

**代码**

在下面的 $\texttt{C++}$ 代码中，由于 $\texttt{std::string}$ 类本身就提供了类似「入栈」和「出栈」的接口，因此我们直接将需要被返回的字符串作为栈即可。对于其他的语言，如果字符串类没有提供相应的接口，则需要在遍历完成字符串后，使用栈中的字符显式地构造出需要被返回的字符串。

```C++ [sol1-C++]
class Solution {
public:
    string removeDuplicates(string s) {
        string stk;
        for (char ch : s) {
            if (!stk.empty() && stk.back() == ch) {
                stk.pop_back();
            } else {
                stk.push_back(ch);
            }
        }
        return stk;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String removeDuplicates(String s) {
        StringBuffer stack = new StringBuffer();
        int top = -1;
        for (int i = 0; i < s.length(); ++i) {
            char ch = s.charAt(i);
            if (top >= 0 && stack.charAt(top) == ch) {
                stack.deleteCharAt(top);
                --top;
            } else {
                stack.append(ch);
                ++top;
            }
        }
        return stack.toString();
    }
}
```

```JavaScript [sol1-JavaScript]
var removeDuplicates = function(s) {
    const stk = [];
    for (const ch of s) {
        if (stk.length && stk[stk.length - 1] === ch) {
            stk.pop();
        } else {
            stk.push(ch);
        }
    }
    return stk.join('');
};
```

```Python [sol1-Python3]
class Solution:
    def removeDuplicates(self, s: str) -> str:
        stk = list()
        for ch in s:
            if stk and stk[-1] == ch:
                stk.pop()
            else:
                stk.append(ch)
        return "".join(stk)
```

```go [sol1-Golang]
func removeDuplicates(s string) string {
    stack := []byte{}
    for i := range s {
        if len(stack) > 0 && stack[len(stack)-1] == s[i] {
            stack = stack[:len(stack)-1]
        } else {
            stack = append(stack, s[i])
        }
    }
    return string(stack)
}
```

```C [sol1-C]
char* removeDuplicates(char* s) {
    int n = strlen(s);
    char* stk = malloc(sizeof(char) * (n + 1));
    int retSize = 0;
    for (int i = 0; i < n; i++) {
        if (retSize > 0 && stk[retSize - 1] == s[i]) {
            retSize--;
        } else {
            stk[retSize++] = s[i];
        }
    }
    stk[retSize] = '\0';
    return stk;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串的长度。我们只需要遍历该字符串一次。

- 空间复杂度：$O(n)$ 或 $O(1)$，取决于使用的语言提供的字符串类是否提供了类似「入栈」和「出栈」的接口。注意返回值不计入空间复杂度。
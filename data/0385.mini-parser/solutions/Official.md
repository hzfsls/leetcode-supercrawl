#### 方法一：深度优先搜索

**思路**

根据题意，一个 $\texttt{NestedInteger}$ 实例只能包含下列两部分之一：1）一个整数；2）一个列表，列表中的每个元素都是一个 $\texttt{NestedInteger}$ 实例。据此，$\texttt{NestedInteger}$ 是通过递归定义的，因此也可以用递归的方式来解析。

从左至右遍历 $s$，
- 如果第一位是 $\texttt{`['}$ 字符，则表示待解析的是一个列表，从 $\texttt{`['}$ 后面的字符开始又是一个新的 $\texttt{NestedInteger}$ 实例，我们仍调用解析函数来解析列表的元素，调用结束后如果遇到的是 $,$ 字符，表示列表仍有其他元素，需要继续调用。如果是 $\texttt{`]'}$ 字符，表示这个列表已经解析完毕，可以返回 $\texttt{NestedInteger}$ 实例。
- 否则，则表示待解析的 $\texttt{NestedInteger}$ 只包含一个整数。我们可以从左至右解析这个整数，并注意是否是负数，直到遍历完或者遇到非数字字符（$\texttt{`]'}$ 或 $\texttt{`,'}$），并返回 $\texttt{NestedInteger}$ 实例。

**代码**

```Python [sol1-Python3]
class Solution:
    def deserialize(self, s: str) -> NestedInteger:
        index = 0

        def dfs() -> NestedInteger:
            nonlocal index
            if s[index] == '[':
                index += 1
                ni = NestedInteger()
                while s[index] != ']':
                    ni.add(dfs())
                    if s[index] == ',':
                        index += 1
                index += 1
                return ni
            else:
                negative = False
                if s[index] == '-':
                    negative = True
                    index += 1
                num = 0
                while index < len(s) and s[index].isdigit():
                    num *= 10
                    num += int(s[index])
                    index += 1
                if negative:
                    num = -num
                return NestedInteger(num)

        return dfs()
```

```Java [sol1-Java]
class Solution {
    int index = 0;

    public NestedInteger deserialize(String s) {
        if (s.charAt(index) == '[') {
            index++;
            NestedInteger ni = new NestedInteger();
            while (s.charAt(index) != ']') {
                ni.add(deserialize(s));
                if (s.charAt(index) == ',') {
                    index++;
                }
            }
            index++;
            return ni;
        } else {
            boolean negative = false;
            if (s.charAt(index) == '-') {
                negative = true;
                index++;
            }
            int num = 0;
            while (index < s.length() && Character.isDigit(s.charAt(index))) {
                num = num * 10 + s.charAt(index) - '0';
                index++;
            }
            if (negative) {
                num *= -1;
            }
            return new NestedInteger(num);
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    int index = 0;

    public NestedInteger Deserialize(string s) {
        if (s[index] == '[') {
            index++;
            NestedInteger ni = new NestedInteger();
            while (s[index] != ']') {
                ni.Add(Deserialize(s));
                if (s[index] == ',') {
                    index++;
                }
            }
            index++;
            return ni;
        } else {
            bool negative = false;
            if (s[index] == '-') {
                negative = true;
                index++;
            }
            int num = 0;
            while (index < s.Length && char.IsDigit(s[index])) {
                num = num * 10 + s[index] - '0';
                index++;
            }
            if (negative) {
                num *= -1;
            }
            return new NestedInteger(num);
        }
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int index = 0;

    NestedInteger deserialize(string s) {
        if (s[index] == '[') {
            index++;
            NestedInteger ni;
            while (s[index] != ']') {
                ni.add(deserialize(s));
                if (s[index] == ',') {
                    index++;
                }
            }
            index++;
            return ni;
        } else {
            bool negative = false;
            if (s[index] == '-') {
                negative = true;
                index++;
            }
            int num = 0;
            while (index < s.size() && isdigit(s[index])) {
                num = num * 10 + s[index] - '0';
                index++;
            }
            if (negative) {
                num *= -1;
            }
            return NestedInteger(num);
        }
    }
};
```

```C [sol1-C]
struct NestedInteger* helper(const char * s, int * index){
    if (s[*index] == '[') {
        (*index)++;
        struct NestedInteger * ni = NestedIntegerInit();
        while (s[*index] != ']') {
            NestedIntegerAdd(ni, helper(s, index));
            if (s[*index] == ',') {
                (*index)++;
            }
        }
        (*index)++;
        return ni;
    } else {
        bool negative = false;
        if (s[*index] == '-') {
            negative = true;
            (*index)++;
        }
        int num = 0;
        while (s[*index] && isdigit(s[*index])) {
            num = num * 10 + s[*index] - '0';
            (*index)++;
        }
        if (negative) {
            num *= -1;
        }
        struct NestedInteger * ni = NestedIntegerInit();
        NestedIntegerSetInteger(ni, num);
        return ni;
    }
}

struct NestedInteger* deserialize(char * s){
    int index = 0;
    return helper(s, &index);
}
```

```JavaScript [sol1-JavaScript]
var deserialize = function(s) {
    let index = 0;
    const dfs = (s) => {
        if (s[index] === '[') {
            index++;
            const ni = new NestedInteger();
            while (s[index] !== ']') {
                ni.add(dfs(s));
                if (s[index] === ',') {
                    index++;
                }
            }
            index++;
            return ni;
        } else {
            let negative = false;
            if (s[index] === '-') {
                negative = true;
                index++;
            }
            let num = 0;
            while (index < s.length && isDigit(s[index])) {
                num = num * 10 + s[index].charCodeAt() - '0'.charCodeAt();
                index++;
            }
            if (negative) {
                num *= -1;
            }
            return new NestedInteger(num);
        }
    }
    return dfs(s);
};

const isDigit = (ch) => {
    return parseFloat(ch).toString() === "NaN" ? false : true;
}
```

```go [sol1-Golang]
func deserialize(s string) *NestedInteger {
    index := 0
    var dfs func() *NestedInteger
    dfs = func() *NestedInteger {
        ni := &NestedInteger{}
        if s[index] == '[' {
            index++
            for s[index] != ']' {
                ni.Add(*dfs())
                if s[index] == ',' {
                    index++
                }
            }
            index++
            return ni
        }

        negative := s[index] == '-'
        if negative {
            index++
        }
        num := 0
        for ; index < len(s) && unicode.IsDigit(rune(s[index])); index++ {
            num = num*10 + int(s[index]-'0')
        }
        if negative {
            num = -num
        }
        ni.SetInteger(num)
        return ni
    }
    return dfs()
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $s$ 的长度。我们需要遍历 $s$ 的每一位来解析。

- 空间复杂度：$O(n)$，其中 $n$ 是 $s$ 的长度。深度优先搜索的深度最多为 $O(n)$，需要 $O(n)$ 的栈空间。

#### 方法二：栈

**思路**

上述递归的思路也可以用栈来模拟。从左至右遍历 $s$，如果遇到 $\texttt{`['}$，则表示是一个新的 $\texttt{NestedInteger}$ 实例，需要将其入栈。如果遇到 $\texttt{`]'}$ 或 $\texttt{`,'}$，则表示是一个数字或者 $\texttt{NestedInteger}$ 实例的结束，需要将其添加入栈顶的 $\texttt{NestedInteger}$ 实例。最后需返回栈顶的实例。

**代码**

```Python [sol2-Python3]
class Solution:
    def deserialize(self, s: str) -> NestedInteger:
        if s[0] != '[':
            return NestedInteger(int(s))
        stack, num, negative = [], 0, False
        for i, c in enumerate(s):
            if c == '-':
                negative = True
            elif c.isdigit():
                num = num * 10 + int(c)
            elif c == '[':
                stack.append(NestedInteger())
            elif c in ',]':
                if s[i-1].isdigit():
                    if negative:
                        num = -num
                    stack[-1].add(NestedInteger(num))
                num, negative = 0, False
                if c == ']' and len(stack) > 1:
                    stack[-2].add(stack.pop())
        return stack.pop()
```

```Java [sol2-Java]
class Solution {
    public NestedInteger deserialize(String s) {
        if (s.charAt(0) != '[') {
            return new NestedInteger(Integer.parseInt(s));
        }
        Deque<NestedInteger> stack = new ArrayDeque<NestedInteger>();
        int num = 0;
        boolean negative = false;
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == '-') {
                negative = true;
            } else if (Character.isDigit(c)) {
                num = num * 10 + c - '0';
            } else if (c == '[') {
                stack.push(new NestedInteger());
            } else if (c == ',' || c == ']') {
                if (Character.isDigit(s.charAt(i - 1))) {
                    if (negative) {
                        num *= -1;
                    }
                    stack.peek().add(new NestedInteger(num));
                }
                num = 0;
                negative = false;
                if (c == ']' && stack.size() > 1) {
                    NestedInteger ni = stack.pop();
                    stack.peek().add(ni);
                }
            }
        }
        return stack.pop();
    }
}
```

```C# [sol2-C#]
public class Solution {
    public NestedInteger Deserialize(string s) {
        if (s[0] != '[') {
            return new NestedInteger(int.Parse(s));
        }
        Stack<NestedInteger> stack = new Stack<NestedInteger>();
        int num = 0;
        bool negative = false;
        for (int i = 0; i < s.Length; i++) {
            char c = s[i];
            if (c == '-') {
                negative = true;
            } else if (char.IsDigit(c)) {
                num = num * 10 + c - '0';
            } else if (c == '[') {
                stack.Push(new NestedInteger());
            } else if (c == ',' || c == ']') {
                if (char.IsDigit(s[i - 1])) {
                    if (negative) {
                        num *= -1;
                    }
                    stack.Peek().Add(new NestedInteger(num));
                }
                num = 0;
                negative = false;
                if (c == ']' && stack.Count > 1) {
                    NestedInteger ni = stack.Pop();
                    stack.Peek().Add(ni);
                }
            }
        }
        return stack.Pop();
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    NestedInteger deserialize(string s) {
        if (s[0] != '[') {
            return NestedInteger(stoi(s));
        }
        stack<NestedInteger> st;
        int num = 0;
        bool negative = false;
        for (int i = 0; i < s.size(); i++) {
            char c = s[i];
            if (c == '-') {
                negative = true;
            } else if (isdigit(c)) {
                num = num * 10 + c - '0';
            } else if (c == '[') {
                st.emplace(NestedInteger());
            } else if (c == ',' || c == ']') {
                if (isdigit(s[i - 1])) {
                    if (negative) {
                        num *= -1;
                    }
                    st.top().add(NestedInteger(num));
                }
                num = 0;
                negative = false;
                if (c == ']' && st.size() > 1) {
                    NestedInteger ni = st.top();
                    st.pop();
                    st.top().add(ni);
                }
            }
        }
        return st.top();
    }
};
```

```C [sol2-C]
#define MAX_NEST_LEVEL 50001

struct NestedInteger* deserialize(char * s){
    if (s[0] != '[') {
        struct NestedInteger * ni = NestedIntegerInit();
        NestedIntegerSetInteger(ni, atoi(s));
        return ni;
    }
    struct NestedInteger **stack = (struct NestedInteger **)malloc(sizeof(struct NestedInteger *) * MAX_NEST_LEVEL);
    int top = 0;
    int num = 0;
    bool negative = false;
    int n = strlen(s);
    for (int i = 0; i < n; i++) {
        char c = s[i];
        if (c == '-') {
            negative = true;
        } else if (isdigit(c)) {
            num = num * 10 + c - '0';
        } else if (c == '[') {
            struct NestedInteger * ni = NestedIntegerInit();
            stack[top++] = ni;
        } else if (c == ',' || c == ']') {
            if (isdigit(s[i - 1])) {
                if (negative) {
                    num *= -1;
                }
                struct NestedInteger * ni = NestedIntegerInit();
                NestedIntegerSetInteger(ni, num);
                NestedIntegerAdd(stack[top - 1], ni);
            }
            num = 0;
            negative = false;
            if (c == ']' && top > 1) {
                struct NestedInteger *ni = stack[top - 1];
                top--;
                NestedIntegerAdd(stack[top - 1], ni);
            }
        }
    }
    struct NestedInteger * res = stack[top - 1];
    free(stack);
    return res;
}
```

```JavaScript [sol2-JavaScript]
var deserialize = function(s) {
    if (s[0] !== '[') {
        return new NestedInteger(parseInt(s));
    }
    const stack = [];
    let num = 0;
    let negative = false;
    for (let i = 0; i < s.length; i++) {
        const c = s[i];
        if (c === '-') {
            negative = true;
        } else if (isDigit(c)) {
            num = num * 10 + c.charCodeAt() - '0'.charCodeAt();
        } else if (c === '[') {
            stack.push(new NestedInteger());
        } else if (c === ',' || c === ']') {
            if (isDigit(s[i - 1])) {
                if (negative) {
                    num *= -1;
                }
                stack[stack.length - 1].add(new NestedInteger(num));
            }
            num = 0;
            negative = false;
            if (c === ']' && stack.length > 1) {
                const ni = stack.pop();
                stack[stack.length - 1].add(ni);
            }
        }
    }
    return stack.pop();
};

const isDigit = (ch) => {
    return parseFloat(ch).toString() === "NaN" ? false : true;
}
```

```go [sol2-Golang]
func deserialize(s string) *NestedInteger {
    if s[0] != '[' {
        num, _ := strconv.Atoi(s)
        ni := &NestedInteger{}
        ni.SetInteger(num)
        return ni
    }
    stack, num, negative := []*NestedInteger{}, 0, false
    for i, ch := range s {
        if ch == '-' {
            negative = true
        } else if unicode.IsDigit(ch) {
            num = num*10 + int(ch-'0')
        } else if ch == '[' {
            stack = append(stack, &NestedInteger{})
        } else if ch == ',' || ch == ']' {
            if unicode.IsDigit(rune(s[i-1])) {
                if negative {
                    num = -num
                }
                ni := NestedInteger{}
                ni.SetInteger(num)
                stack[len(stack)-1].Add(ni)
            }
            num, negative = 0, false
            if ch == ']' && len(stack) > 1 {
                stack[len(stack)-2].Add(*stack[len(stack)-1])
                stack = stack[:len(stack)-1]
            }
        }
    }
    return stack[len(stack)-1]
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $s$ 的长度。我们需要遍历 $s$ 的每一位来解析。

- 空间复杂度：$O(n)$，其中 $n$ 是 $s$ 的长度。栈的深度最多为 $O(n)$。
#### 方法一：栈

给定的字符串 $\textit{expression}$ 是有效的布尔表达式，每个运算符后面都有一对括号，括号中有一个或多个表达式。其中，逻辑非运算符后面的括号中有一个表达式，逻辑与运算符和逻辑或运算符后面的括号中有两个或以上表达式。

可以使用栈实现布尔表达式的解析。从左到右遍历布尔表达式，对于每种类型的字符，执行相应的操作：

- 如果当前字符是逗号，则跳过该字符；

- 如果当前字符是除了逗号和右括号以外的任意字符，则将该字符添加到栈内；

- 如果当前字符是右括号，则一个表达式遍历结束，需要解析该表达式的值，并将结果添加到栈内：

   1. 将栈内字符依次弹出，直到栈顶字符是左括号，然后将左括号和运算符从栈内弹出，记录弹出的 $\text{`t'}$ 和 $\text{`f'}$ 的个数；

   2. 根据运算符以及 $\text{`t'}$ 和 $\text{`f'}$ 的个数计算表达式的值，并将表达式的值添加到栈内：

      - 如果运算符是 $\text{`!'}$，则是逻辑非运算符，表达式的值为括号内的值取反，因此当 $\text{`f'}$ 的个数等于 $1$ 时表达式的值为 $\text{`t'}$，否则表达式的值为 $\text{`f'}$；

      - 如果运算符是 $\text{`\&'}$，则是逻辑与运算符，当括号内的所有值都是 $\text{`t'}$ 时结果是 $\text{`t'}$，否则结果是 $\text{`f'}$，因此当 $\text{`f'}$ 的个数等于 $0$ 时表达式的值为 $\text{`t'}$，否则表达式的值为 $\text{`f'}$；

      - 如果运算符是 $\text{`|'}$，则是逻辑或运算符，当括号内至少有一个值都是 $\text{`t'}$ 时结果是 $\text{`t'}$，否则结果是 $\text{`f'}$，因此当 $\text{`t'}$ 的个数大于 $0$ 时表达式的值为 $\text{`t'}$，否则表达式的值为 $\text{`f'}$；

遍历结束之后，栈内只有一个字符，该字符为 $\text{`t'}$ 或 $\text{`f'}$，如果字符为 $\text{`t'}$ 则返回 $\text{true}$，如果字符为 $\text{`f'}$ 则返回 $\text{false}$。

```Python [sol1-Python3]
class Solution:
    def parseBoolExpr(self, expression: str) -> bool:
        stk = []
        for c in expression:
            if c == ',':
                continue
            if c != ')':
                stk.append(c)
                continue
            t = f = 0
            while stk[-1] != '(':
                if stk.pop() == 't':
                    t += 1
                else:
                    f += 1
            stk.pop()
            op = stk.pop()
            if op == '!':
                stk.append('t' if f == 1 else 'f')
            elif op == '&':
                stk.append('t' if f == 0 else 'f')
            elif op == '|':
                stk.append('t' if t else 'f')
        return stk[-1] == 't'
```

```Java [sol1-Java]
class Solution {
    public boolean parseBoolExpr(String expression) {
        Deque<Character> stack = new ArrayDeque<Character>();
        int n = expression.length();
        for (int i = 0; i < n; i++) {
            char c = expression.charAt(i);
            if (c == ',') {
                continue;
            } else if (c != ')') {
                stack.push(c);
            } else {
                int t = 0, f = 0;
                while (stack.peek() != '(') {
                    char val = stack.pop();
                    if (val == 't') {
                        t++;
                    } else {
                        f++;
                    }
                }
                stack.pop();
                char op = stack.pop();
                switch (op) {
                case '!':
                    stack.push(f == 1 ? 't' : 'f');
                    break;
                case '&':
                    stack.push(f == 0 ? 't' : 'f');
                    break;
                case '|':
                    stack.push(t > 0 ? 't' : 'f');
                    break;
                default:
                }
            }
        }
        return stack.pop() == 't';
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool ParseBoolExpr(string expression) {
        Stack<char> stack = new Stack<char>();
        int n = expression.Length;
        for (int i = 0; i < n; i++) {
            char c = expression[i];
            if (c == ',') {
                continue;
            } else if (c != ')') {
                stack.Push(c);
            } else {
                int t = 0, f = 0;
                while (stack.Peek() != '(') {
                    char val = stack.Pop();
                    if (val == 't') {
                        t++;
                    } else {
                        f++;
                    }
                }
                stack.Pop();
                char op = stack.Pop();
                switch (op) {
                case '!':
                    stack.Push(f == 1 ? 't' : 'f');
                    break;
                case '&':
                    stack.Push(f == 0 ? 't' : 'f');
                    break;
                case '|':
                    stack.Push(t > 0 ? 't' : 'f');
                    break;
                default:
                    break;
                }
            }
        }
        return stack.Pop() == 't';
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool parseBoolExpr(string expression) {
        stack<char> stk;
        int n = expression.size();
        for (int i = 0; i < n; i++) {
            char c = expression[i];
            if (c == ',') {
                continue;
            } else if (c != ')') {
                stk.push(c);
            } else {
                int t = 0, f = 0;
                while (stk.top() != '(') {
                    char val = stk.top();
                    stk.pop();
                    if (val == 't') {
                        t++;
                    } else {
                        f++;
                    }
                }
                stk.pop();
                char op = stk.top();
                stk.pop();
                switch (op) {
                case '!':
                    stk.push(f == 1 ? 't' : 'f');
                    break;
                case '&':
                    stk.push(f == 0 ? 't' : 'f');
                    break;
                case '|':
                    stk.push(t > 0 ? 't' : 'f');
                    break;
                default:
                    break;
                }
            }
        }
        return stk.top() == 't';
    }
};
```

```C [sol1-C]
bool parseBoolExpr(char * expression){
    int n = strlen(expression);
    char stack[n];
    int top = 0;
    for (int i = 0; i < n; i++) {
        char c = expression[i];
        if (c == ',') {
            continue;
        } else if (c != ')') {
            stack[top++] = c;
        } else {
            int t = 0, f = 0;
            while (stack[top - 1] != '(') {
                char val = stack[top - 1];
                top--;
                if (val == 't') {
                    t++;
                } else {
                    f++;
                }
            }
            top--;
            char op = stack[top - 1];
            top--;
            switch (op) {
            case '!':
                stack[top++] = f == 1 ? 't' : 'f';
                break;
            case '&':
                stack[top++] = f == 0 ? 't' : 'f';
                break;
            case '|':
                stack[top++] = t > 0 ? 't' : 'f';
                break;
            default:
                break;
            }
        }
    }
    return stack[top - 1] == 't';
}
```

```JavaScript [sol1-JavaScript]
var parseBoolExpr = function(expression) {
    const stack = [];
    const n = expression.length;
    for (let i = 0; i < n; i++) {
        const c = expression[i];
        if (c === ',') {
            continue;
        } else if (c !== ')') {
            stack.push(c);
        } else {
            let t = 0, f = 0;
            while (stack[stack.length - 1] !== '(') {
                const val = stack.pop();
                if (val === 't') {
                    t++;
                } else {
                    f++;
                }
            }
            stack.pop();
            const op = stack.pop();
            switch (op) {
            case '!':
                stack.push(f === 1 ? 't' : 'f');
                break;
            case '&':
                stack.push(f === 0 ? 't' : 'f');
                break;
            case '|':
                stack.push(t > 0 ? 't' : 'f');
                break;
            default:
            }
        }
    }
    return stack.pop() === 't';
};
```

```go [sol1-Golang]
func parseBoolExpr(expression string) bool {
    stk := []rune{}
    for _, c := range expression {
        if c == ',' {
            continue
        }
        if c != ')' {
            stk = append(stk, c)
            continue
        }
        t := 0
        f := 0
        for stk[len(stk)-1] != '(' {
            val := stk[len(stk)-1]
            stk = stk[:len(stk)-1]
            if val == 't' {
                t++
            } else {
                f++
            }
        }
        stk = stk[:len(stk)-1]
        op := stk[len(stk)-1]
        stk = stk[:len(stk)-1]
        c = 't'
        switch op {
        case '!':
            if f != 1 {
                c = 'f'
            }
            stk = append(stk, c)
        case '&':
            if f != 0 {
                c = 'f'
            }
            stk = append(stk, c)
        case '|':
            if t == 0 {
                c = 'f'
            }
            stk = append(stk, c)
        }
    }
    return stk[len(stk)-1] == 't'
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是布尔表达式 $\textit{expression}$ 的长度。需要遍历布尔表达式一次并解析。

- 空间复杂度：$O(n)$，其中 $n$ 是布尔表达式 $\textit{expression}$ 的长度。空间复杂度主要取决于栈空间，栈内字符个数不超过 $n$。
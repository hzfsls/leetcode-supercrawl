#### 方法一：括号展开 + 栈

由于字符串除了数字与括号外，只有加号和减号两种运算符。因此，如果展开表达式中所有的括号，则得到的新表达式中，数字本身不会发生变化，只是每个数字前面的符号会发生变化。

因此，我们考虑使用一个取值为 $\{-1,+1\}$ 的整数 $\textit{sign}$ 代表「当前」的符号。根据括号表达式的性质，它的取值：
- 与字符串中当前位置的运算符有关；
- 如果当前位置处于一系列括号之内，则也与这些括号前面的运算符有关：每当遇到一个以 $-$ 号开头的括号，则意味着此后的符号都要被「翻转」。

考虑到第二点，我们需要维护一个栈 $\textit{ops}$，其中栈顶元素记录了当前位置所处的每个括号所「共同形成」的符号。例如，对于字符串 $\text{1+2+(3-(4+5))}$：
- 扫描到 $\text{1+2}$ 时，由于当前位置没有被任何括号所包含，则栈顶元素为初始值 $+1$；
- 扫描到 $\text{1+2+(3}$ 时，当前位置被一个括号所包含，该括号前面的符号为 $+$ 号，因此栈顶元素依然 $+1$；
- 扫描到 $\text{1+2+(3-(4}$ 时，当前位置被两个括号所包含，分别对应着 $+$ 号和 $-$ 号，由于 $+$ 号和 $-$ 号合并的结果为 $-$ 号，因此栈顶元素变为 $-1$。

在得到栈 $\textit{ops}$ 之后， $\textit{sign}$ 的取值就能够确定了：如果当前遇到了 $+$ 号，则更新 $\textit{sign} \leftarrow \text{ops.top()}$；如果遇到了遇到了 $-$ 号，则更新 $\textit{sign} \leftarrow -\text{ops.top()}$。

然后，每当遇到 $($ 时，都要将当前的 $\textit{sign}$ 取值压入栈中；每当遇到 $)$ 时，都从栈中弹出一个元素。这样，我们能够在扫描字符串的时候，即时地更新 $\textit{ops}$ 中的元素。

```C++ [sol1-C++]
class Solution {
public:
    int calculate(string s) {
        stack<int> ops;
        ops.push(1);
        int sign = 1;

        int ret = 0;
        int n = s.length();
        int i = 0;
        while (i < n) {
            if (s[i] == ' ') {
                i++;
            } else if (s[i] == '+') {
                sign = ops.top();
                i++;
            } else if (s[i] == '-') {
                sign = -ops.top();
                i++;
            } else if (s[i] == '(') {
                ops.push(sign);
                i++;
            } else if (s[i] == ')') {
                ops.pop();
                i++;
            } else {
                long num = 0;
                while (i < n && s[i] >= '0' && s[i] <= '9') {
                    num = num * 10 + s[i] - '0';
                    i++;
                }
                ret += sign * num;
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int calculate(String s) {
        Deque<Integer> ops = new LinkedList<Integer>();
        ops.push(1);
        int sign = 1;

        int ret = 0;
        int n = s.length();
        int i = 0;
        while (i < n) {
            if (s.charAt(i) == ' ') {
                i++;
            } else if (s.charAt(i) == '+') {
                sign = ops.peek();
                i++;
            } else if (s.charAt(i) == '-') {
                sign = -ops.peek();
                i++;
            } else if (s.charAt(i) == '(') {
                ops.push(sign);
                i++;
            } else if (s.charAt(i) == ')') {
                ops.pop();
                i++;
            } else {
                long num = 0;
                while (i < n && Character.isDigit(s.charAt(i))) {
                    num = num * 10 + s.charAt(i) - '0';
                    i++;
                }
                ret += sign * num;
            }
        }
        return ret;
    }
}
```

```JavaScript [sol1-JavaScript]
var calculate = function(s) {
    const ops = [1];
    let sign = 1;

    let ret = 0;
    const n = s.length;
    let i = 0;
    while (i < n) {
        if (s[i] === ' ') {
            i++;
        } else if (s[i] === '+') {
            sign = ops[ops.length - 1];
            i++;
        } else if (s[i] === '-') {
            sign = -ops[ops.length - 1];
            i++;
        } else if (s[i] === '(') {
            ops.push(sign);
            i++;
        } else if (s[i] === ')') {
            ops.pop();
            i++;
        } else {
            let num = 0;
            while (i < n && !(isNaN(Number(s[i]))) && s[i] !== ' ') {
                num = num * 10 + s[i].charCodeAt() - '0'.charCodeAt();
                i++;
            }
            ret += sign * num;
        }
    }
    return ret;
};
```

```go [sol1-Golang]
func calculate(s string) (ans int) {
    ops := []int{1}
    sign := 1
    n := len(s)
    for i := 0; i < n; {
        switch s[i] {
        case ' ':
            i++
        case '+':
            sign = ops[len(ops)-1]
            i++
        case '-':
            sign = -ops[len(ops)-1]
            i++
        case '(':
            ops = append(ops, sign)
            i++
        case ')':
            ops = ops[:len(ops)-1]
            i++
        default:
            num := 0
            for ; i < n && '0' <= s[i] && s[i] <= '9'; i++ {
                num = num*10 + int(s[i]-'0')
            }
            ans += sign * num
        }
    }
    return
}
```

```C [sol1-C]
int calculate(char* s) {
    int n = strlen(s);
    int ops[n], top = 0;
    int sign = 1;
    ops[top++] = sign;

    int ret = 0;
    int i = 0;
    while (i < n) {
        if (s[i] == ' ') {
            i++;
        } else if (s[i] == '+') {
            sign = ops[top - 1];
            i++;
        } else if (s[i] == '-') {
            sign = -ops[top - 1];
            i++;
        } else if (s[i] == '(') {
            ops[top++] = sign;
            i++;
        } else if (s[i] == ')') {
            top--;
            i++;
        } else {
            long num = 0;
            while (i < n && s[i] >= '0' && s[i] <= '9') {
                num = num * 10 + s[i] - '0';
                i++;
            }
            ret += sign * num;
        }
    }
    return ret;
}
```

```Python [sol1-Python3]
class Solution:
    def calculate(self, s: str) -> int:
        ops = [1]
        sign = 1

        ret = 0
        n = len(s)
        i = 0
        while i < n:
            if s[i] == ' ':
                i += 1
            elif s[i] == '+':
                sign = ops[-1]
                i += 1
            elif s[i] == '-':
                sign = -ops[-1]
                i += 1
            elif s[i] == '(':
                ops.append(sign)
                i += 1
            elif s[i] == ')':
                ops.pop()
                i += 1
            else:
                num = 0
                while i < n and s[i].isdigit():
                    num = num * 10 + ord(s[i]) - ord('0')
                    i += 1
                ret += num * sign
        return ret
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串 $s$ 的长度。需要遍历字符串 $s$ 一次，计算表达式的值。

- 空间复杂度：$O(n)$，其中 $n$ 为字符串 $s$ 的长度。空间复杂度主要取决于栈的空间，栈中的元素数量不超过 $n$。

#### 备注

本题有多种基于栈这一数据结构的解法，每种解法基于相近的思路，但具有完全不同的实现方式。感兴趣的读者可以尝试阅读其他基于栈的解法，本题解不再一一列举。
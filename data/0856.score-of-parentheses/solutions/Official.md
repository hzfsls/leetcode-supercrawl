## [856.括号的分数 中文官方题解](https://leetcode.cn/problems/score-of-parentheses/solutions/100000/gua-hao-de-fen-shu-by-leetcode-solution-we6b)
#### 方法一：分治

根据题意，一个平衡括号字符串 $s$ 可以被分解为 $A+B$ 或 $(A)$ 的形式，因此我们可以对 $s$ 进行分解，分而治之。

如何判断 $s$ 应该分解为 $A+B$ 或 $(A)$ 的哪一种呢？我们将左括号记为 $1$，右括号记为 $-1$，如果 $s$ 的某个非空前缀对应的和 $\textit{bal} = 0$，那么这个前缀就是一个平衡括号字符串。如果该前缀长度等于 $s$ 的长度，那么 $s$ 可以分解为 $(A)$ 的形式；否则 $s$ 可以分解为 $A + B$ 的形式，其中 $A$ 为该前缀。将 $s$ 分解之后，我们递归地求解子问题，并且 $s$ 的长度为 $2$ 时，分数为 $1$。

```Python [sol1-Python3]
class Solution:
    def scoreOfParentheses(self, s: str) -> int:
        n = len(s)
        if n == 2:
            return 1
        bal = 0
        for i, c in enumerate(s):
            bal += 1 if c == '(' else -1
            if bal == 0:
                if i == n - 1:
                    return 2 * self.scoreOfParentheses(s[1:-1])
                return self.scoreOfParentheses(s[:i + 1]) + self.scoreOfParentheses(s[i + 1:])
```

```C++ [sol1-C++]
class Solution {
public:
    int scoreOfParentheses(string s) {
        if (s.size() == 2) {
            return 1;
        }
        int bal = 0, n = s.size(), len;
        for (int i = 0; i < n; i++) {
            bal += (s[i] == '(' ? 1 : -1);
            if (bal == 0) {
                len = i + 1;
                break;
            }
        }
        if (len == n) {
            return 2 * scoreOfParentheses(s.substr(1, n - 2));
        } else {
            return scoreOfParentheses(s.substr(0, len)) + scoreOfParentheses(s.substr(len, n - len));
        }
    }
};
```

```Java [sol1-Java]
class Solution {
    public int scoreOfParentheses(String s) {
        if (s.length() == 2) {
            return 1;
        }
        int bal = 0, n = s.length(), len = 0;
        for (int i = 0; i < n; i++) {
            bal += (s.charAt(i) == '(' ? 1 : -1);
            if (bal == 0) {
                len = i + 1;
                break;
            }
        }
        if (len == n) {
            return 2 * scoreOfParentheses(s.substring(1, n - 1));
        } else {
            return scoreOfParentheses(s.substring(0, len)) + scoreOfParentheses(s.substring(len));
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int ScoreOfParentheses(string s) {
        if (s.Length == 2) {
            return 1;
        }
        int bal = 0, n = s.Length, len = 0;
        for (int i = 0; i < n; i++) {
            bal += (s[i] == '(' ? 1 : -1);
            if (bal == 0) {
                len = i + 1;
                break;
            }
        }
        if (len == n) {
            return 2 * ScoreOfParentheses(s.Substring(1, n - 2));
        } else {
            return ScoreOfParentheses(s.Substring(0, len)) + ScoreOfParentheses(s.Substring(len));
        }
    }
}
```

```C [sol1-C]
int scoreOfParentheses(char * s) {
    int n = strlen(s);
    if (n == 2) {
        return 1;
    }
    int bal = 0, len = 0;
    for (int i = 0; i < n; i++) {
        bal += (s[i] == '(' ? 1 : -1);
        if (bal == 0) {
            len = i + 1;
            break;
        }
    }
    if (len == n) {
        char str[n - 1];
        strncpy(str, s + 1, n - 2);
        str[n - 2] = '\0';
        return 2 * scoreOfParentheses(str);
    } else {
        char str1[len + 1], str2[n - len + 1];
        strncpy(str1, s, len);
        str1[len] = '\0';
        strncpy(str2, s + len, n - len);
        str2[n - len] = '\0';
        return scoreOfParentheses(str1) + scoreOfParentheses(str2);
    }
}
```

```go [sol1-Golang]
func scoreOfParentheses(s string) int {
    n := len(s)
    if n == 2 {
        return 1
    }
    for i, bal := 0, 0; ; i++ {
        if s[i] == '(' {
            bal++
        } else {
            bal--
            if bal == 0 {
                if i == n-1 {
                    return 2 * scoreOfParentheses(s[1:n-1])
                }
                return scoreOfParentheses(s[:i+1]) + scoreOfParentheses(s[i+1:])
            }
        }
    }
}
```

```JavaScript [sol1-JavaScript]
var scoreOfParentheses = function(s) {
    if (s.length === 2) {
        return 1;
    }
    let bal = 0, n = s.length, len = 0;
    for (let i = 0; i < n; i++) {
        bal += (s[i] === '(' ? 1 : -1);
        if (bal === 0) {
            len = i + 1;
            break;
        }
    }
    if (len === n) {
        return 2 * scoreOfParentheses(s.slice(1, n - 1));
    } else {
        return scoreOfParentheses(s.slice(0, len)) + scoreOfParentheses(s.slice(len));
    }
};
```

**复杂度分析**

+ 时间复杂度：$O(n^2)$，其中 $n$ 是字符串的长度。递归深度为 $O(n)$，每一层的所有函数调用的总时间复杂度都是 $O(n)$，因此总时间复杂度为 $O(n^2)$。

+ 空间复杂度：$O(n^2)$。每一层都需要将字符串复制一遍，因此总空间复杂度为 $O(n^2)$。对于字符串支持切片的语言，空间复杂度为递归栈所需的空间 $O(n)$。

#### 方法二：栈

我们把平衡字符串 $s$ 看作是一个空字符串加上 $s$ 本身，并且定义空字符串的分数为 $0$。使用栈 $\textit{st}$ 记录平衡字符串的分数，在开始之前要压入分数 $0$，表示空字符串的分数。

在遍历字符串 $s$ 的过程中：

+ 遇到左括号，那么我们需要计算该左括号内部的子平衡括号字符串 $A$ 的分数，我们也要先压入分数 $0$，表示 $A$ 前面的空字符串的分数。

+ 遇到右括号，说明该右括号内部的子平衡括号字符串 $A$ 的分数已经计算出来了，我们将它弹出栈，并保存到变量 $v$ 中。如果 $v = 0$，那么说明子平衡括号字符串 $A$ 是空串，$(A)$ 的分数为 $1$，否则 $(A)$ 的分数为 $2v$，然后将 $(A)$ 的分数加到栈顶元素上。

遍历结束后，栈顶元素保存的就是 $s$ 的分数。

```Python [sol2-Python3]
class Solution:
    def scoreOfParentheses(self, s: str) -> int:
        st = [0]
        for c in s:
            if c == '(':
                st.append(0)
            else:
                v = st.pop()
                st[-1] += max(2 * v, 1)
        return st[-1]
```

```C++ [sol2-C++]
class Solution {
public:
    int scoreOfParentheses(string s) {
        stack<int> st;
        st.push(0);
        for (auto c : s) {
            if (c == '(') {
                st.push(0);
            } else {
                int v = st.top();
                st.pop();
                st.top() += max(2 * v, 1);
            }
        }
        return st.top();
    }
};
```

```Java [sol2-Java]
class Solution {
    public int scoreOfParentheses(String s) {
        Deque<Integer> st = new ArrayDeque<Integer>();
        st.push(0);
        for (int i = 0; i < s.length(); i++) {
            if (s.charAt(i) == '(') {
                st.push(0);
            } else {
                int v = st.pop();
                int top = st.pop() + Math.max(2 * v, 1);
                st.push(top);
            }
        }
        return st.peek();
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int ScoreOfParentheses(string s) {
        Stack<int> st = new Stack<int>();
        st.Push(0);
        foreach (char c in s) {
            if (c == '(') {
                st.Push(0);
            } else {
                int v = st.Pop();
                int top = st.Pop() + Math.Max(2 * v, 1);
                st.Push(top);
            }
        }
        return st.Peek();
    }
}
```

```C [sol2-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int scoreOfParentheses(char * s) {
    int len = strlen(s);
    int stack[len + 1], top = 0;
    stack[top++] = 0;
    for (int i = 0; i < len; i++) {
        if (s[i] == '(') {
            stack[top++] = 0;
        } else {
            int v = stack[top - 1];
            top--;
            stack[top - 1] += MAX(2 * v, 1);
        }
    }
    return stack[top - 1];
}
```

```go [sol2-Golang]
func scoreOfParentheses(s string) int {
    st := []int{0}
    for _, c := range s {
        if c == '(' {
            st = append(st, 0)
        } else {
            v := st[len(st)-1]
            st = st[:len(st)-1]
            st[len(st)-1] += max(2*v, 1)
        }
    }
    return st[0]
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

```JavaScript [sol2-JavaScript]
var scoreOfParentheses = function(s) {
    const st = [0];
    for (let i = 0; i < s.length; i++) {
        if (s[i] === '(') {
            st.push(0);
        } else {
            let v = st.pop();
            let top = st.pop() + Math.max(2 * v, 1);
            st.push(top);
        }
    }
    return st[0];
};
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是字符串的长度。

+ 空间复杂度：$O(n)$。栈需要 $O(n)$ 的空间。

#### 方法三：计算最终分数和

根据题意，$s$ 的分数与 $1$ 分的 $()$ 有关。对于每个 $()$，它的最终分数与它所处的深度有关，如果深度为 $\textit{bal}$，那么它的最终分数为 $2^\textit{bal}$。我们统计所有 $()$ 的最终分数和即可。

```Python [sol3-Python3]
class Solution:
    def scoreOfParentheses(self, s: str) -> int:
        ans = bal = 0
        for i, c in enumerate(s):
            bal += 1 if c == '(' else -1
            if c == ')' and s[i - 1] == '(':
                ans += 1 << bal
        return ans
```

```C++ [sol3-C++]
class Solution {
public:
    int scoreOfParentheses(string s) {
        int bal = 0, n = s.size(), res = 0;
        for (int i = 0; i < n; i++) {
            bal += (s[i] == '(' ? 1 : -1);
            if (s[i] == ')' && s[i - 1] == '(') {
                res += 1 << bal;
            }
        }
        return res;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int scoreOfParentheses(String s) {
        int bal = 0, n = s.length(), res = 0;
        for (int i = 0; i < n; i++) {
            bal += (s.charAt(i) == '(' ? 1 : -1);
            if (s.charAt(i) == ')' && s.charAt(i - 1) == '(') {
                res += 1 << bal;
            }
        }
        return res;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int ScoreOfParentheses(string s) {
        int bal = 0, n = s.Length, res = 0;
        for (int i = 0; i < n; i++) {
            bal += (s[i] == '(' ? 1 : -1);
            if (s[i] == ')' && s[i - 1] == '(') {
                res += 1 << bal;
            }
        }
        return res;
    }
}
```

```C [sol3-C]
int scoreOfParentheses(char * s) {
    int bal = 0, n = strlen(s), res = 0;
    for (int i = 0; i < n; i++) {
        bal += (s[i] == '(' ? 1 : -1);
        if (s[i] == ')' && s[i - 1] == '(') {
            res += 1 << bal;
        }
    }
    return res;
}
```

```go [sol3-Golang]
func scoreOfParentheses(s string) (ans int) {
    bal := 0
    for i, c := range s {
        if c == '(' {
            bal++
        } else {
            bal--
            if s[i-1] == '(' {
                ans += 1 << bal
            }
        }
    }
    return
}
```

```JavaScript [sol3-JavaScript]
var scoreOfParentheses = function(s) {
    let bal = 0, n = s.length, res = 0;
    for (let i = 0; i < n; i++) {
        bal += (s[i] == '(' ? 1 : -1);
        if (s[i] == ')' && s[i - 1] === '(') {
            res += 1 << bal;
        }
    }
    return res;
};
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是字符串的长度。

+ 空间复杂度：$O(1)$。
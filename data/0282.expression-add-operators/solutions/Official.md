## [282.给表达式添加运算符 中文官方题解](https://leetcode.cn/problems/expression-add-operators/solutions/100000/gei-biao-da-shi-tian-jia-yun-suan-fu-by-2o1s7)

#### 方法一：回溯

设字符串 $\textit{num}$ 的长度为 $n$，为构建表达式，我们可以往 $\textit{num}$ 中间的 $n-1$ 个空隙添加 $\texttt{+}$ 号、$\texttt{-}$ 号或 $\texttt{*}$ 号，或者不添加符号。

我们可以用「回溯法」来模拟这个过程。从左向右构建表达式，并实时计算表达式的结果。由于乘法运算优先级高于加法和减法运算，我们还需要保存最后一个连乘串（如 $\texttt{2*3*4}$）的运算结果。

定义递归函数 $\textit{backtrack}(\textit{expr}, i, \textit{res}, \textit{mul})$，其中：

- $\textit{expr}$ 为当前构建出的表达式；
- $i$ 表示当前的枚举到了 $\textit{num}$ 的第 $i$ 个数字；
- $\textit{res}$ 为当前表达式的计算结果；
- $\textit{mul}$ 为表达式最后一个连乘串的计算结果。

该递归函数分为两种情况：

- 如果 $i=n$，说明表达式已经构造完成，若此时有 $\textit{res}=\textit{target}$，则找到了一个可行解，我们将 $\textit{expr}$ 放入答案数组中，递归结束；
- 如果 $i<n$，需要枚举当前表达式末尾要添加的符号（$\texttt{+}$ 号、$\texttt{-}$ 号或 $\texttt{*}$ 号），以及该符号之后需要截取多少位数字。设该符号之后的数字为 $\textit{val}$，按符号分类讨论：
   - 若添加 $\texttt{+}$ 号，则 $\textit{res}$ 增加 $\textit{val}$，且 $\textit{val}$ 单独组成表达式最后一个连乘串；
   - 若添加 $\texttt{-}$ 号，则 $\textit{res}$ 减少 $\textit{val}$，且 $-\textit{val}$ 单独组成表达式最后一个连乘串；
   - 若添加 $\texttt{*}$ 号，由于乘法运算优先级高于加法和减法运算，我们需要对 $\textit{res}$ 撤销之前 $\textit{mul}$ 的计算结果，并添加新的连乘结果 $\textit{mul}*\textit{val}$，也就是将 $\textit{res}$ 减少 $\textit{mul}$ 并增加 $\textit{mul}*\textit{val}$。

代码实现时，为避免字符串拼接所带来的额外时间开销，我们采用字符数组的形式来构建表达式。此外，运算过程中可能会产生超过 $32$ 位整数的结果，我们要用 $64$ 位整数存储中间运算结果。

```Python [sol1-Python3]
class Solution:
    def addOperators(self, num: str, target: int) -> List[str]:
        n = len(num)
        ans = []

        def backtrack(expr: List[str], i: int, res: int, mul: int):
            if i == n:
                if res == target:
                    ans.append(''.join(expr))
                return
            signIndex = len(expr)
            if i > 0:
                expr.append('')  # 占位，下面填充符号
            val = 0
            for j in range(i, n):  # 枚举截取的数字长度（取多少位）
                if j > i and num[i] == '0':  # 数字可以是单个 0 但不能有前导零
                    break
                val = val * 10 + int(num[j])
                expr.append(num[j])
                if i == 0:  # 表达式开头不能添加符号
                    backtrack(expr, j + 1, val, val)
                else:  # 枚举符号
                    expr[signIndex] = '+'; backtrack(expr, j + 1, res + val, val)
                    expr[signIndex] = '-'; backtrack(expr, j + 1, res - val, -val)
                    expr[signIndex] = '*'; backtrack(expr, j + 1, res - mul + mul * val, mul * val)
            del expr[signIndex:]

        backtrack([], 0, 0, 0)
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    vector<string> addOperators(string num, int target) {
        int n = num.length();
        vector<string> ans;

        function<void(string&, int, long, long)> backtrack = [&](string &expr, int i, long res, long mul) {
            if (i == n) {
                if (res == target) {
                    ans.emplace_back(expr);
                }
                return;
            }
            int signIndex = expr.size();
            if (i > 0) {
                expr.push_back(0); // 占位，下面填充符号
            }
            long val = 0;
            // 枚举截取的数字长度（取多少位），注意数字可以是单个 0 但不能有前导零
            for (int j = i; j < n && (j == i || num[i] != '0'); ++j) {
                val = val * 10 + num[j] - '0';
                expr.push_back(num[j]);
                if (i == 0) { // 表达式开头不能添加符号
                    backtrack(expr, j + 1, val, val);
                } else { // 枚举符号
                    expr[signIndex] = '+'; backtrack(expr, j + 1, res + val, val);
                    expr[signIndex] = '-'; backtrack(expr, j + 1, res - val, -val);
                    expr[signIndex] = '*'; backtrack(expr, j + 1, res - mul + mul * val, mul * val);
                }
            }
            expr.resize(signIndex);
        };

        string expr;
        backtrack(expr, 0, 0, 0);
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    int n;
    String num;
    int target;
    List<String> ans;

    public List<String> addOperators(String num, int target) {
        this.n = num.length();
        this.num = num;
        this.target = target;
        this.ans = new ArrayList<String>();
        StringBuffer expr = new StringBuffer();
        backtrack(expr, 0, 0, 0);
        return ans;
    }

    public void backtrack(StringBuffer expr, int i, long res, long mul) {
        if (i == n) {
            if (res == target) {
                ans.add(expr.toString());
            }
            return;
        }
        int signIndex = expr.length();
        if (i > 0) {
            expr.append(0); // 占位，下面填充符号
        }
        long val = 0;
        // 枚举截取的数字长度（取多少位），注意数字可以是单个 0 但不能有前导零
        for (int j = i; j < n && (j == i || num.charAt(i) != '0'); ++j) {
            val = val * 10 + num.charAt(j) - '0';
            expr.append(num.charAt(j));
            if (i == 0) { // 表达式开头不能添加符号
                backtrack(expr, j + 1, val, val);
            } else { // 枚举符号
                expr.setCharAt(signIndex, '+');
                backtrack(expr, j + 1, res + val, val);
                expr.setCharAt(signIndex, '-');
                backtrack(expr, j + 1, res - val, -val);
                expr.setCharAt(signIndex, '*');
                backtrack(expr, j + 1, res - mul + mul * val, mul * val);
            }
        }
        expr.setLength(signIndex);
    }
}
```

```C# [sol1-C#]
public class Solution {
    int n;
    string num;
    int target;
    IList<string> ans;
    
    public IList<string> AddOperators(string num, int target) {
        this.n = num.Length;
        this.num = num;
        this.target = target;
        this.ans = new List<string>();
        StringBuilder expr = new StringBuilder();
        Backtrack(expr, 0, 0, 0);
        return ans;
    }

    public void Backtrack(StringBuilder expr, int i, long res, long mul) {
        if (i == n) {
            if (res == target) {
                ans.Add(expr.ToString());
            }
            return;
        }
        int signIndex = expr.Length;
        if (i > 0) {
            expr.Append(0); // 占位，下面填充符号
        }
        long val = 0;
        // 枚举截取的数字长度（取多少位），注意数字可以是单个 0 但不能有前导零
        for (int j = i; j < n && (j == i || num[i] != '0'); ++j) {
            val = val * 10 + num[j] - '0';
            expr.Append(num[j]);
            if (i == 0) { // 表达式开头不能添加符号
                Backtrack(expr, j + 1, val, val);
            } else { // 枚举符号
                expr.Replace(expr[signIndex], '+', signIndex, 1);
                Backtrack(expr, j + 1, res + val, val);
                expr.Replace(expr[signIndex], '-', signIndex, 1);
                Backtrack(expr, j + 1, res - val, -val);
                expr.Replace(expr[signIndex], '*', signIndex, 1);
                Backtrack(expr, j + 1, res - mul + mul * val, mul * val);
            }
        }
        expr.Length = signIndex;
    }
}
```

```go [sol1-Golang]
func addOperators(num string, target int) (ans []string) {
    n := len(num)
    var backtrack func(expr []byte, i, res, mul int)
    backtrack = func(expr []byte, i, res, mul int) {
        if i == n {
            if res == target {
                ans = append(ans, string(expr))
            }
            return
        }
        signIndex := len(expr)
        if i > 0 {
            expr = append(expr, 0) // 占位，下面填充符号
        }
        // 枚举截取的数字长度（取多少位），注意数字可以是单个 0 但不能有前导零
        for j, val := i, 0; j < n && (j == i || num[i] != '0'); j++ {
            val = val*10 + int(num[j]-'0')
            expr = append(expr, num[j])
            if i == 0 { // 表达式开头不能添加符号
                backtrack(expr, j+1, val, val)
            } else { // 枚举符号
                expr[signIndex] = '+'; backtrack(expr, j+1, res+val, val)
                expr[signIndex] = '-'; backtrack(expr, j+1, res-val, -val)
                expr[signIndex] = '*'; backtrack(expr, j+1, res-mul+mul*val, mul*val)
            }
        }
    }
    backtrack(make([]byte, 0, n*2-1), 0, 0, 0)
    return
}
```

```JavaScript [sol1-JavaScript]
var addOperators = function(num, target) {
    const n = num.length;
    const ans = [];
    let expr = [];

    const backtrack = (expr, i, res, mul) => {
        if (i === n) {
            if (res === target) {
                ans.push(expr.join(''));
            }
            return;
        }
        const signIndex = expr.length;
        if (i > 0) {
            expr.push(''); // 占位，下面填充符号
        }
        let val = 0;
        // 枚举截取的数字长度（取多少位），注意数字可以是单个 0 但不能有前导零
        for (let j = i; j < n && (j === i || num[i] !== '0'); ++j) {
            val = val * 10 + num[j].charCodeAt() - '0'.charCodeAt();
            expr.push(num[j]);
            if (i === 0) { // 表达式开头不能添加符号
                backtrack(expr, j + 1, val, val);
            } else { // 枚举符号
                expr[signIndex] = '+';
                backtrack(expr, j + 1, res + val, val);
                expr[signIndex] = '-';
                backtrack(expr, j + 1, res - val, -val);
                expr[signIndex] = '*';
                backtrack(expr, j + 1, res - mul + mul * val, mul * val);
            }
        }
        expr = expr.splice(signIndex, expr.length - signIndex)
    }

    backtrack(expr, 0, 0, 0);
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(4^n)$，其中 $n$ 是字符串 $\textit{num}$ 的长度。由于在数字之间可以选择不添加符号、添加 $\texttt{+}$ 号、$\texttt{-}$ 号或 $\texttt{*}$ 号，一共有 $4$ 种选择，因此时间复杂度为 $O(4^n)$。
                                                
   注：考虑到将 $\textit{expr}$ 的拷贝存入答案需要花费 $O(n)$ 的时间，最终的时间复杂度似乎是 $O(n \times 4^n)$。果真如此吗？考虑合法表达式最多的情况，即 $\textit{num}$ 全为 $\texttt{0}$，且 $\textit{target}=0$ 的情况，由于不能有前导零，我们必须在数字之间添加 $\texttt{+ - *}$ 三者之一，所以合法表达式有 $3^{n-1}$ 个，因此「将 $\textit{expr}$ 的拷贝存入答案」这一部分的时间开销至多为 $O(n \times 3^n)$。

- 空间复杂度：$O(n)$。不考虑返回值的空间占用，空间复杂度取决于递归时的栈空间。
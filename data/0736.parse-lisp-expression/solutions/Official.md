## [736.Lisp 语法解析 中文官方题解](https://leetcode.cn/problems/parse-lisp-expression/solutions/100000/lisp-yu-fa-jie-xi-by-leetcode-solution-zycb)
#### 方法一：递归解析

对于一个表达式 $\textit{expression}$，如果它的首字符不等于左括号 $\text{`('}$，那么它只能是一个整数或者变量；否则它是 $\text{let}$，$\text{add}$ 和 $\text{mult}$ 三种表达式之一。

定义函数 $\text{parseVar}$ 用来解析变量以及函数 $\text{parseInt}$ 用来解析整数。使用 $\textit{scope}$ 来记录作用域，每个变量都依次记录下它从外到内的所有值，查找时只需要查找最后一个数值。我们递归地解析表达式 $\textit{expression}$。

+ $\textit{expression}$ 的下一个字符不等于左括号 $\text{`('}$。

    + $\textit{expression}$ 的下一个字符是小写字母，那么表达式是一个变量，使用函数 $\text{parseVar}$ 解析变量，然后在 $\textit{scope}$ 中查找变量的最后一个数值即最内层作用域的值并返回结果。

    + $\textit{expression}$ 的下一个字符不是小写字母，那么表达式是一个整数，使用函数 $\textit{parseInt}$ 解析并返回结果。

+ 去掉左括号后，$\textit{expression}$ 的下一个字符是 $\text{`l'}$，那么表达式是 $\text{let}$ 表达式。对于 $\text{let}$ 表达式，需要判断是否已经解析到最后一个 $\textit{expr}$ 表达式。

    + 如果下一个字符不是小写字母，或者解析变量后下一个字符是右括号 $\text{`)'}$，说明是最后一个 $\textit{expr}$ 表达式，计算它的值并返回结果。并且我们需要在 $\textit{scope}$ 中清除 $\text{let}$ 表达式对应的作用域变量。

    + 否则说明是交替的变量 $v_i$ 和表达式 $e_i$，在 $\textit{scope}$ 将变量 $v_i$ 的数值列表增加表达式 $e_i$ 的数值。

+ 去掉左括号后，$\textit{expression}$ 的下一个字符是 $\text{`a'}$，那么表达式是 $\text{add}$ 表达式。计算 $\text{add}$ 表达式对应的两个表达式 $e_1$ 和 $e_2$ 的值，返回两者之和。

+ 去掉左括号后，$\textit{expression}$ 的下一个字符是 $\text{`m'}$，那么表达式是 $\text{mult}$ 表达式。计算 $\text{mult}$ 表达式对应的两个表达式 $e_1$ 和 $e_2$ 的值，返回两者之积。

**代码**

```Python [sol1-Python3]
class Solution:
    def evaluate(self, expression: str) -> int:
        i, n = 0, len(expression)

        def parseVar() -> str:
            nonlocal i
            i0 = i
            while i < n and expression[i] != ' ' and expression[i] != ')':
                i += 1
            return expression[i0:i]

        def parseInt() -> int:
            nonlocal i
            sign, x = 1, 0
            if expression[i] == '-':
                sign = -1
                i += 1
            while i < n and expression[i].isdigit():
                x = x * 10 + int(expression[i])
                i += 1
            return sign * x

        scope = defaultdict(list)

        def innerEvaluate() -> int:
            nonlocal i
            if expression[i] != '(':  # 非表达式，可能为：整数或变量
                if expression[i].islower():  # 变量
                    return scope[parseVar()][-1]
                return parseInt()  # 整数
            i += 1  # 移除左括号
            if expression[i] == 'l':  # "let" 表达式
                i += 4  # 移除 "let "
                vars = []
                while True:
                    if not expression[i].islower():
                        ret = innerEvaluate()  # let 表达式的最后一个 expr 表达式的值
                        break
                    var = parseVar()
                    if expression[i] == ')':
                        ret = scope[var][-1]  # let 表达式的最后一个 expr 表达式的值
                        break
                    vars.append(var)
                    i += 1  # 移除空格
                    scope[var].append(innerEvaluate())
                    i += 1  # 移除空格
                for var in vars:
                    scope[var].pop()  # 清除当前作用域的变量
            elif expression[i] == 'a':  # "add" 表达式
                i += 4  # 移除 "add "
                e1 = innerEvaluate()
                i += 1  # 移除空格
                e2 = innerEvaluate()
                ret = e1 + e2
            else:  # "mult" 表达式
                i += 5  # 移除 "mult "
                e1 = innerEvaluate()
                i += 1  # 移除空格
                e2 = innerEvaluate()
                ret = e1 * e2
            i += 1  # 移除右括号
            return ret

        return innerEvaluate()
```

```C++ [sol1-C++]
class Solution {
private:
    unordered_map<string, vector<int>> scope;

public:
    int evaluate(string expression) {
        int start = 0;
        return innerEvaluate(expression, start);
    }

    int innerEvaluate(const string &expression, int &start) {
        if (expression[start] != '(') { // 非表达式，可能为：整数或变量
            if (islower(expression[start])) {
                string var = parseVar(expression, start); // 变量
                return scope[var].back();
            } else { // 整数
                return parseInt(expression, start);
            }
        }
        int ret;
        start++; // 移除左括号
        if (expression[start] == 'l') { // "let" 表达式
            start += 4; // 移除 "let "
            vector<string> vars;
            while (true) {
                if (!islower(expression[start])) {
                    ret = innerEvaluate(expression, start); // let 表达式的最后一个 expr 表达式的值
                    break;
                }
                string var = parseVar(expression, start);
                if (expression[start] == ')') {
                    ret = scope[var].back(); // let 表达式的最后一个 expr 表达式的值
                    break;
                }
                vars.push_back(var);
                start++; // 移除空格
                int e = innerEvaluate(expression, start);
                scope[var].push_back(e);
                start++; // 移除空格
            }
            for (auto var : vars) {
                scope[var].pop_back(); // 清除当前作用域的变量
            }
        } else if (expression[start] == 'a') { // "add" 表达式
            start += 4; // 移除 "add "
            int e1 = innerEvaluate(expression, start);
            start++; // 移除空格
            int e2 = innerEvaluate(expression, start);
            ret = e1 + e2;
        } else { // "mult" 表达式
            start += 5; // 移除 "mult "
            int e1 = innerEvaluate(expression, start);
            start++; // 移除空格
            int e2 = innerEvaluate(expression, start);
            ret = e1 * e2;
        }
        start++; // 移除右括号
        return ret;
    }

    int parseInt(const string &expression, int &start) { // 解析整数
        int n = expression.size();
        int ret = 0, sign = 1;
        if (expression[start] == '-') {
            sign = -1;
            start++;
        }
        while (start < n && isdigit(expression[start])) {
            ret = ret * 10 + (expression[start] - '0');
            start++;
        }
        return sign * ret;
    }

    string parseVar(const string &expression, int &start) { // 解析变量
        int n = expression.size();
        string ret;
        while (start < n && expression[start] != ' ' && expression[start] != ')') {
            ret.push_back(expression[start]);
            start++;
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    Map<String, Deque<Integer>> scope = new HashMap<String, Deque<Integer>>();
    int start = 0;

    public int evaluate(String expression) {
        return innerEvaluate(expression);
    }

    public int innerEvaluate(String expression) {
        if (expression.charAt(start) != '(') { // 非表达式，可能为：整数或变量
            if (Character.isLowerCase(expression.charAt(start))) {
                String var = parseVar(expression); // 变量
                return scope.get(var).peek();
            } else { // 整数
                return parseInt(expression);
            }
        }
        int ret;
        start++; // 移除左括号
        if (expression.charAt(start) == 'l') { // "let" 表达式
            start += 4; // 移除 "let "
            List<String> vars = new ArrayList<String>();
            while (true) {
                if (!Character.isLowerCase(expression.charAt(start))) {
                    ret = innerEvaluate(expression); // let 表达式的最后一个 expr 表达式的值
                    break;
                }
                String var = parseVar(expression);
                if (expression.charAt(start) == ')') {
                    ret = scope.get(var).peek(); // let 表达式的最后一个 expr 表达式的值
                    break;
                }
                vars.add(var);
                start++; // 移除空格
                int e = innerEvaluate(expression);
                scope.putIfAbsent(var, new ArrayDeque<Integer>());
                scope.get(var).push(e);
                start++; // 移除空格
            }
            for (String var : vars) {
                scope.get(var).pop(); // 清除当前作用域的变量
            }
        } else if (expression.charAt(start) == 'a') { // "add" 表达式
            start += 4; // 移除 "add "
            int e1 = innerEvaluate(expression);
            start++; // 移除空格
            int e2 = innerEvaluate(expression);
            ret = e1 + e2;
        } else { // "mult" 表达式
            start += 5; // 移除 "mult "
            int e1 = innerEvaluate(expression);
            start++; // 移除空格
            int e2 = innerEvaluate(expression);
            ret = e1 * e2;
        }
        start++; // 移除右括号
        return ret;
    }

    public int parseInt(String expression) { // 解析整数
        int n = expression.length();
        int ret = 0, sign = 1;
        if (expression.charAt(start) == '-') {
            sign = -1;
            start++;
        }
        while (start < n && Character.isDigit(expression.charAt(start))) {
            ret = ret * 10 + (expression.charAt(start) - '0');
            start++;
        }
        return sign * ret;
    }

    public String parseVar(String expression) { // 解析变量
        int n = expression.length();
        StringBuffer ret = new StringBuffer();
        while (start < n && expression.charAt(start) != ' ' && expression.charAt(start) != ')') {
            ret.append(expression.charAt(start));
            start++;
        }
        return ret.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    Dictionary<string, Stack<int>> scope = new Dictionary<string, Stack<int>>();
    int start = 0;

    public int Evaluate(string expression) {
        return InnerEvaluate(expression);
    }

    public int InnerEvaluate(string expression) {
        if (expression[start] != '(') { // 非表达式，可能为：整数或变量
            if (char.IsLower(expression[start])) {
                string var = ParseVar(expression); // 变量
                return scope[var].Peek();
            } else { // 整数
                return ParseInt(expression);
            }
        }
        int ret;
        start++; // 移除左括号
        if (expression[start] == 'l') { // "let" 表达式
            start += 4; // 移除 "let "
            IList<string> vars = new List<string>();
            while (true) {
                if (!char.IsLower(expression[start])) {
                    ret = InnerEvaluate(expression); // let 表达式的最后一个 expr 表达式的值
                    break;
                }
                string var = ParseVar(expression);
                if (expression[start] == ')') {
                    ret = scope[var].Peek(); // let 表达式的最后一个 expr 表达式的值
                    break;
                }
                vars.Add(var);
                start++; // 移除空格
                int e = InnerEvaluate(expression);
                if (!scope.ContainsKey(var)) {
                    scope.Add(var, new Stack<int>());
                }
                scope[var].Push(e);
                start++; // 移除空格
            }
            foreach (string var in vars) {
                scope[var].Pop(); // 清除当前作用域的变量
            }
        } else if (expression[start] == 'a') { // "add" 表达式
            start += 4; // 移除 "add "
            int e1 = InnerEvaluate(expression);
            start++; // 移除空格
            int e2 = InnerEvaluate(expression);
            ret = e1 + e2;
        } else { // "mult" 表达式
            start += 5; // 移除 "mult "
            int e1 = InnerEvaluate(expression);
            start++; // 移除空格
            int e2 = InnerEvaluate(expression);
            ret = e1 * e2;
        }
        start++; // 移除右括号
        return ret;
    }

    public int ParseInt(string expression) { // 解析整数
        int n = expression.Length;
        int ret = 0, sign = 1;
        if (expression[start] == '-') {
            sign = -1;
            start++;
        }
        while (start < n && char.IsDigit(expression[start])) {
            ret = ret * 10 + (expression[start] - '0');
            start++;
        }
        return sign * ret;
    }

    public string ParseVar(string expression) { // 解析变量
        int n = expression.Length;
        StringBuilder ret = new StringBuilder();
        while (start < n && expression[start] != ' ' && expression[start] != ')') {
            ret.Append(expression[start]);
            start++;
        }
        return ret.ToString();
    }
}
```

```C [sol1-C]
typedef struct {
    char *key;
    struct ListNode *lst;
    UT_hash_handle hh;
} HashItem;

typedef struct Node {
    char *var;
    struct Node *next;
} Node;

HashItem *scope = NULL;

int parseInt(const char *expression, int *start) { // 解析整数
    int n = strlen(expression);
    int ret = 0, sign = 1;
    if (expression[*start] == '-') {
        sign = -1;
        (*start)++;
    }
    while ((*start) < n && isdigit(expression[*start])) {
        ret = ret * 10 + (expression[*start] - '0');
        (*start)++;
    }
    return sign * ret;
}

char *parseVar(const char *expression, int *start) { // 解析变量
    int n = strlen(expression);
    char *ret = (char *)malloc(sizeof(char) * (n - (*start) + 1));
    int pos = 0;
    while ((*start) < n && expression[*start] != ' ' && expression[*start] != ')') {
        ret[pos++] = expression[(*start)++];
    }
    ret[pos] = '\0';
    return ret;
}

int innerEvaluate(const char *expression, int *start) {
    if (expression[*start] != '(') { // 非表达式，可能为：整数或变量
        if (islower(expression[*start])) {
            char *var = parseVar(expression, start); // 变量
            HashItem *pEntry = NULL;
            HASH_FIND_STR(scope, var, pEntry);
            free(var);
            return pEntry->lst->val;
        } else { // 整数
            return parseInt(expression, start);
        }
    }
    int ret;
    (*start)++; // 移除左括号
    if (expression[*start] == 'l') { // "let" 表达式
        (*start) += 4; // 移除 "let "
        Node *vars = NULL;
        while (true) {
            if (isdigit(expression[*start]) || expression[*start] == '(') {
                ret = innerEvaluate(expression, start); // let 表达式的最后一个 expr 表达式的值
                break;
            }
            char *var = parseVar(expression, start);
            if (expression[*start] == ')') {
                int start1 = 0;
                ret = innerEvaluate(var, &start1); // let 表达式的最后一个 expr 表达式的值
                break;
            }
            Node *node = (Node *)malloc(sizeof(Node));
            node->var = var;
            node->next = vars;
            vars = node;
            (*start)++; // 移除空格
            int e = innerEvaluate(expression, start);
            HashItem *pEntry = NULL;
            HASH_FIND_STR(scope, var, pEntry);
            if (NULL == pEntry) {
                pEntry = (HashItem *)malloc(sizeof(HashItem));
                pEntry->key = var;
                pEntry->lst = NULL;
                HASH_ADD_STR(scope, key, pEntry);
            }
            struct ListNode *pNode = (struct ListNode *)malloc(sizeof(struct ListNode));
            pNode->val = e;
            pNode->next = pEntry->lst;
            pEntry->lst = pNode; 
            (*start)++; // 移除空格
        }
        for (Node *node = vars; node; node = node->next) {
            HashItem *pEntry = NULL;
            HASH_FIND_STR(scope, node->var, pEntry);
            if (pEntry) {
                struct ListNode *pNode = pEntry->lst; // 清除当前作用域的变量
                pEntry->lst = pEntry->lst->next;
                free(pNode);
            }
        }
    } else if (expression[*start] == 'a') { // "add" 表达式
        (*start) += 4; // 移除 "add "
        int e1 = innerEvaluate(expression, start);
        (*start)++; // 移除空格
        int e2 = innerEvaluate(expression, start);
        ret = e1 + e2;
    } else { // "mult" 表达式
        (*start) += 5; // 移除 "mult "
        int e1 = innerEvaluate(expression, start);
        (*start)++; // 移除空格
        int e2 = innerEvaluate(expression, start);
        ret = e1 * e2;
    }
    (*start)++; // 移除右括号
    return ret;
}

void freeScope() {
    HashItem *curr, *tmp;
    HASH_ITER(hh, scope, curr, tmp) {
      HASH_DEL(scope, curr);
      free(curr->key);
      for (struct ListNode *node = curr->lst; node; ) {
          struct ListNode *pNode = node;
          node = node->next;
          free(pNode);
      }
      free(curr);
    }
}

int evaluate(char * expression){
    int start = 0;    
    int ret = innerEvaluate(expression, &start);
    freeScope();
    return ret;
}
```

```go [sol1-Golang]
func evaluate(expression string) int {
    i, n := 0, len(expression)
    parseVar := func() string {
        i0 := i
        for i < n && expression[i] != ' ' && expression[i] != ')' {
            i++
        }
        return expression[i0:i]
    }
    parseInt := func() int {
        sign, x := 1, 0
        if expression[i] == '-' {
            sign = -1
            i++
        }
        for i < n && unicode.IsDigit(rune(expression[i])) {
            x = x*10 + int(expression[i]-'0')
            i++
        }
        return sign * x
    }

    scope := map[string][]int{}
    var innerEvaluate func() int
    innerEvaluate = func() (ret int) {
        if expression[i] != '(' { // 非表达式，可能为：整数或变量
            if unicode.IsLower(rune(expression[i])) { // 变量
                vals := scope[parseVar()]
                return vals[len(vals)-1]
            }
            return parseInt() // 整数
        }
        i++ // 移除左括号
        if expression[i] == 'l' { // "let" 表达式
            i += 4 // 移除 "let "
            vars := []string{}
            for {
                if !unicode.IsLower(rune(expression[i])) {
                    ret = innerEvaluate() // let 表达式的最后一个 expr 表达式的值
                    break
                }
                vr := parseVar()
                if expression[i] == ')' {
                    vals := scope[vr]
                    ret = vals[len(vals)-1] // let 表达式的最后一个 expr 表达式的值
                    break
                }
                vars = append(vars, vr)
                i++ // 移除空格
                scope[vr] = append(scope[vr], innerEvaluate())
                i++ // 移除空格
            }
            for _, vr := range vars {
                scope[vr] = scope[vr][:len(scope[vr])-1] // 清除当前作用域的变量
            }
        } else if expression[i] == 'a' { // "add" 表达式
            i += 4 // 移除 "add "
            e1 := innerEvaluate()
            i++ // 移除空格
            e2 := innerEvaluate()
            ret = e1 + e2
        } else { // "mult" 表达式
            i += 5 // 移除 "mult "
            e1 := innerEvaluate()
            i++ // 移除空格
            e2 := innerEvaluate()
            ret = e1 * e2
        }
        i++ // 移除右括号
        return
    }
    return innerEvaluate()
}
```

```JavaScript [sol1-JavaScript]
var evaluate = function(expression) {
    const scope = new Map();
    let start = 0;

    const innerEvaluate = (expression) => {
        if (expression[start] !== '(') { // 非表达式，可能为：整数或变量
            if (isLowerCase(expression[start])) {
                const v = parseVar(expression); // 变量
                const n = scope.get(v).length;
                return scope.get(v)[n - 1];
            } else { // 整数
                return parseInt(expression);
            }
        }
        let ret;
        start++; // 移除左括号
        if (expression[start] === 'l') { // "let" 表达式
            start += 4; // 移除 "let "
            const vars = [];
            while (true) {
                if (!isLowerCase(expression[start])) {
                    ret = innerEvaluate(expression); // let 表达式的最后一个 expr 表达式的值
                    break;
                }
                const v = parseVar(expression);
                if (expression[start] === ')') {
                    const n = scope.get(v).length;
                    ret = scope.get(v)[n - 1]; // let 表达式的最后一个 expr 表达式的值
                    break;
                }
                vars.push(v);
                start++; // 移除空格
                const e = innerEvaluate(expression);
                if (!scope.has(v)) {
                    scope.set(v, []);
                }
                scope.get(v).push(e);
                start++; // 移除空格
            }
            for (const v of vars) {
                scope.get(v).pop(); // 清除当前作用域的变量
            }
        } else if (expression[start] === 'a') { // "add" 表达式
            start += 4; // 移除 "add "
            const e1 = innerEvaluate(expression);
            start++; // 移除空格
            const e2 = innerEvaluate(expression);
            ret = e1 + e2;
        } else { // "mult" 表达式
            start += 5; // 移除 "mult "
            const e1 = innerEvaluate(expression);
            start++; // 移除空格
            const e2 = innerEvaluate(expression);
            ret = e1 * e2;
        }
        start++; // 移除右括号
        return ret;
    }

    const parseInt = (expression) => { // 解析整数
        const n = expression.length;
        let ret = 0, sign = 1;
        if (expression[start] === '-') {
            sign = -1;
            start++;
        }
        while (start < n && isDigit(expression[start])) {
            ret = ret * 10 + (expression.charAt(start) - '0');
            start++;
        }
        return sign * ret;
    }

    const parseVar = (expression) => { // 解析变量
        const n = expression.length;
        let ret = '';
        while (start < n && expression[start] !== ' ' && expression[start] !== ')') {
            ret += expression[start];
            start++;
        }
        return ret;
    }

    return innerEvaluate(expression, start);
};

const isDigit = (ch) => {
    return parseFloat(ch).toString() === "NaN" ? false : true;
}

const isLowerCase = (ch) => {
    return ch >= 'a' && ch <= 'z';
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{expression}$ 的长度。递归调用函数 $\text{innerEvaluate}$ 在某一层调用的时间复杂度为 $O(k)$，其中 $k$ 为指针 $\textit{start}$ 在该层调用的移动次数。在整个递归调用过程中，指针 $\textit{start}$ 会遍历整个字符串，因此解析 $\textit{expression}$ 需要 $O(n)$。

+ 空间复杂度：$O(n)$。保存 $\textit{scope}$ 以及递归调用栈需要 $O(n)$ 的空间。

#### 方法二：状态机

定义状态 $\text{ExprStatus}$，状态机的初始状态 $\textit{cur}$ 为 $\text{VALUE}$。

当我们解析到一个左括号时，我们需要将当前状态 $\textit{cur}$ 压入栈中，然后将当前状态 $\textit{cur}$ 设为状态 $\text{NONE}$，表示对一个未知表达式的解析。当我们解析到一个右括号时，我们需要根据括号对应的表达式的类型来计算最终值，并且将它转换成一个 $\textit{token}$ 传回上层状态，将上层状态出栈并设为当前状态 $\textit{cur}$，对于 $\text{let}$ 表达式，我们还需要清除它的作用域。

以下的每次状态的转换都会伴随一个 $\textit{token}$，其中 $\textit{token}$ 表示被空格和括号分隔开的词块，并且 $\text{let}$，$\text{add}$ 和 $\text{mult}$ 三种表达式都可以转换成一个整数 $\textit{token}$。状态转换如下：

+ 状态 $\text{VALUE}$：

    + 将 $\textit{token}$ 直接解析成整数保存到 $\textit{value}$ 中，并将状态设为 $\text{DONE}$，标志解析完成。

+ 状态 $\text{NONE}$：

    + $\textit{token} = \text{``let"}$：将当前状态 $\textit{cur}$ 设为 $\text{LET}$。

    + $\textit{token} = \text{``add"}$：将当前状态 $\textit{cur}$ 设为 $\text{ADD}$。

    + $\textit{token} = \text{``mult"}$：将当前状态 $\textit{cur}$ 设为 $\text{MULT}$。

+ 状态 $\text{LET}$：

    + 下一个字符是右括号，说明已经到达 $\text{let}$ 表达式的最后一个 $\text{expr}$ 表达式，计算 $\textit{token}$ 的值并保存到 $\textit{value}$，并且将当前状态 $\textit{cur}$ 设为 $\text{LET2}$，标志着 $\text{let}$ 表达式的解析完成。

    + 下一个字符不是右括号，将 $\textit{token}$ 记录到 $\textit{var}$ 中，并且将当前状态 $\textit{cur}$ 设为 $\text{LET1}$。

+ 状态 $\text{LET1}$：

    + 计算 $\textit{token}$ 的值，在 $\textit{scope}$ 中将变量 $var$ 的数值列表增加该数值，并且将当前状态 $\textit{cur}$ 设为 $\text{LET}$。

+ 状态 $\text{ADD}$：

    + 计算 $\textit{token}$ 的值，为 $e_1$ 赋值，并且将当前状态 $\textit{cur}$ 设为 $\text{ADD1}$。

+ 状态 $\text{ADD1}$：

    + 计算 $\textit{token}$ 的值，为 $e_2$ 赋值，并且将当前状态 $\textit{cur}$ 设为 $\text{ADD2}$，标志着 $\text{add}$ 表达式的解析完成。

+ 状态 $\text{MULT}$：

    + 计算 $\textit{token}$ 的值，为 $e_1$ 赋值，并且将当前状态 $\textit{cur}$ 设为 $\text{MULT1}$。

+ 状态 $\text{MULT1}$：

    + 计算 $\textit{token}$ 的值，为 $e_2$ 赋值，并且将当前状态 $\textit{cur}$ 设为 $\text{MULT2}$，标志着 $\text{mult}$ 表达式的解析完成。

状态机有两种转换路线，第一种是从 $\text{VALUE}$ 到 $\text{DONE}$ 的转换路线，第二种是从 $\text{NONE}$ 到 $\text{LET2}$，$\text{ADD2}$ 或 $\text{MULT2}$ 的转换路线。

![状态机转换图](https://assets.leetcode-cn.com/solution-static/736/1.jpg)

**代码**

```Python [sol2-Python3]
from enum import Enum, auto

class ExprStatus(Enum):
    VALUE = auto()  # 初始状态
    NONE  = auto()  # 表达式类型未知
    LET   = auto()  # let 表达式
    LET1  = auto()  # let 表达式已经解析了 vi 变量
    LET2  = auto()  # let 表达式已经解析了最后一个表达式 expr
    ADD   = auto()  # add 表达式
    ADD1  = auto()  # add 表达式已经解析了 e1 表达式
    ADD2  = auto()  # add 表达式已经解析了 e2 表达式
    MULT  = auto()  # mult 表达式
    MULT1 = auto()  # mult 表达式已经解析了 e1 表达式
    MULT2 = auto()  # mult 表达式已经解析了 e2 表达式
    DONE  = auto()  # 解析完成

class Expr:
    __slots__ = 'status', 'var', 'value', 'e1', 'e2'

    def __init__(self, status):
        self.status = status
        self.var = ''  # let 的变量 vi
        self.value = 0  # VALUE 状态的数值，或者 LET2 状态最后一个表达式的数值
        self.e1 = self.e2 = 0  # add 或 mult 表达式的两个表达式 e1 和 e2 的数值

class Solution:
    def evaluate(self, expression: str) -> int:
        scope = defaultdict(list)

        def calculateToken(token: str) -> int:
            return scope[token][-1] if token[0].islower() else int(token)

        vars = []
        s = []
        cur = Expr(ExprStatus.VALUE)
        i, n = 0, len(expression)
        while i < n:
            if expression[i] == ' ':
                i += 1  # 去掉空格
                continue
            if expression[i] == '(':
                i += 1  # 去掉左括号
                s.append(cur)
                cur = Expr(ExprStatus.NONE)
                continue
            if expression[i] == ')':  # 本质上是把表达式转成一个 token
                i += 1  # 去掉右括号
                if cur.status is ExprStatus.LET2:
                    token = str(cur.value)
                    for var in vars[-1]:
                        scope[var].pop()  # 清除作用域
                    vars.pop()
                elif cur.status is ExprStatus.ADD2:
                    token = str(cur.e1 + cur.e2)
                else:
                    token = str(cur.e1 * cur.e2)
                cur = s.pop()  # 获取上层状态
            else:
                i0 = i
                while i < n and expression[i] != ' ' and expression[i] != ')':
                    i += 1
                token = expression[i0:i]

            if cur.status is ExprStatus.VALUE:
                cur.value = int(token)
                cur.status = ExprStatus.DONE
            elif cur.status is ExprStatus.NONE:
                if token == "let":
                    cur.status = ExprStatus.LET
                    vars.append([])  # 记录该层作用域的所有变量, 方便后续的清除
                elif token == "add":
                    cur.status = ExprStatus.ADD
                elif token == "mult":
                    cur.status = ExprStatus.MULT
            elif cur.status is ExprStatus.LET:
                if expression[i] == ')':  # let 表达式的最后一个 expr 表达式
                    cur.value = calculateToken(token)
                    cur.status = ExprStatus.LET2
                else:
                    cur.var = token
                    vars[-1].append(token)  # 记录该层作用域的所有变量, 方便后续的清除
                    cur.status = ExprStatus.LET1
            elif cur.status is ExprStatus.LET1:
                scope[cur.var].append(calculateToken(token))
                cur.status = ExprStatus.LET
            elif cur.status is ExprStatus.ADD:
                cur.e1 = calculateToken(token)
                cur.status = ExprStatus.ADD1
            elif cur.status is ExprStatus.ADD1:
                cur.e2 = calculateToken(token)
                cur.status = ExprStatus.ADD2
            elif cur.status is ExprStatus.MULT:
                cur.e1 = calculateToken(token)
                cur.status = ExprStatus.MULT1
            elif cur.status is ExprStatus.MULT1:
                cur.e2 = calculateToken(token)
                cur.status = ExprStatus.MULT2
        return cur.value
```

```C++ [sol2-C++]
enum ExprStatus {
    VALUE = 0, // 初始状态
    NONE,      // 表达式类型未知
    LET,       // let 表达式
    LET1,      // let 表达式已经解析了 vi 变量
    LET2,      // let 表达式已经解析了最后一个表达式 expr
    ADD,       // add 表达式
    ADD1,      // add 表达式已经解析了 e1 表达式
    ADD2,      // add 表达式已经解析了 e2 表达式
    MULT,      // mult 表达式
    MULT1,     // mult 表达式已经解析了 e1 表达式
    MULT2,     // mult 表达式已经解析了 e2 表达式
    DONE       // 解析完成
};

struct Expr {
    ExprStatus status;
    string var; // let 的变量 vi
    int value; // VALUE 状态的数值，或者 LET2 状态最后一个表达式的数值
    int e1, e2; // add 或 mult 表达式的两个表达式 e1 和 e2 的数值

    Expr(ExprStatus s) {
        status = s;
    }
};

class Solution {
private:
    unordered_map<string, vector<int>> scope;

public:
    int evaluate(string expression) {
        vector<vector<string>> vars;
        int start = 0, n = expression.size();
        stack<Expr> s;
        Expr cur(VALUE);
        while (start < n) {
            if (expression[start] == ' ') {
                start++; // 去掉空格
                continue;
            }
            if (expression[start] == '(') {
                start++; // 去掉左括号
                s.push(cur);
                cur = Expr(NONE);
                continue;
            }
            string token;
            if (expression[start] == ')') { // 本质上是把表达式转成一个 token
                start++; // 去掉右括号
                if (cur.status == LET2) {
                    token = to_string(cur.value);
                    for (auto var : vars.back()) { // 清除作用域
                        scope[var].pop_back();
                    }
                    vars.pop_back();
                } else if (cur.status == ADD2) {
                    token = to_string(cur.e1 + cur.e2);
                } else {
                    token = to_string(cur.e1 * cur.e2);
                }
                cur = s.top(); // 获取上层状态
                s.pop();
            } else {
                while (start < n && expression[start] != ' ' && expression[start] != ')') {
                    token.push_back(expression[start]);
                    start++;
                }
            }
            switch (cur.status) {
                case VALUE:
                    cur.value = stoi(token);
                    cur.status = DONE;
                    break;
                case NONE:
                    if (token == "let") {
                        cur.status = LET;
                        vars.emplace_back(); // 记录该层作用域的所有变量, 方便后续的清除
                    } else if (token == "add") {
                        cur.status = ADD;
                    } else if (token == "mult") {
                        cur.status = MULT;
                    }
                    break;
                case LET:
                    if (expression[start] == ')') { // let 表达式的最后一个 expr 表达式
                        cur.value = calculateToken(token);
                        cur.status = LET2;
                    } else {
                        cur.var = token;
                        vars.back().push_back(token); // 记录该层作用域的所有变量, 方便后续的清除
                        cur.status = LET1;
                    }
                    break;
                case LET1:
                    scope[cur.var].push_back(calculateToken(token));
                    cur.status = LET;
                    break;
                case ADD:
                    cur.e1 = calculateToken(token);
                    cur.status = ADD1;
                    break;
                case ADD1:
                    cur.e2 = calculateToken(token);
                    cur.status = ADD2;
                    break;
                case MULT:
                    cur.e1 = calculateToken(token);
                    cur.status = MULT1;
                    break;
                case MULT1:
                    cur.e2 = calculateToken(token);
                    cur.status = MULT2;
                    break;
            }
        }
        return cur.value;
    }

    int calculateToken(const string &token) {
        if (islower(token[0])) {
            return scope[token].back();
        } else {
            return stoi(token);
        }
    }
};
```

```Java [sol2-Java]
class Solution {
    Map<String, Deque<Integer>> scope = new HashMap<String, Deque<Integer>>();

    public int evaluate(String expression) {
        Deque<Deque<String>> vars = new ArrayDeque<Deque<String>>();
        int start = 0, n = expression.length();
        Deque<Expr> stack = new ArrayDeque<Expr>();
        Expr cur = new Expr(ExprStatus.VALUE);
        while (start < n) {
            if (expression.charAt(start) == ' ') {
                start++; // 去掉空格
                continue;
            }
            if (expression.charAt(start) == '(') {
                start++; // 去掉左括号
                stack.push(cur);
                cur = new Expr(ExprStatus.NONE);
                continue;
            }
            StringBuffer sb = new StringBuffer();
            if (expression.charAt(start) == ')') { // 本质上是把表达式转成一个 token
                start++; // 去掉右括号
                if (cur.status == ExprStatus.LET2) {
                    sb = new StringBuffer(Integer.toString(cur.value));
                    for (String var : vars.peek()) { // 清除作用域
                        scope.get(var).pop();
                    }
                    vars.pop();
                } else if (cur.status == ExprStatus.ADD2) {
                    sb = new StringBuffer(Integer.toString(cur.e1 + cur.e2));
                } else {
                    sb = new StringBuffer(Integer.toString(cur.e1 * cur.e2));
                }
                cur = stack.pop(); // 获取上层状态
            } else {
                while (start < n && expression.charAt(start) != ' ' && expression.charAt(start) != ')') {
                    sb.append(expression.charAt(start));
                    start++;
                }
            }
            String token = sb.toString();
            switch (cur.status.toString()) {
            case "VALUE":
                cur.value = Integer.parseInt(token);
                cur.status = ExprStatus.DONE;
                break;
            case "NONE":
                if ("let".equals(token)) {
                    cur.status = ExprStatus.LET;
                    vars.push(new ArrayDeque<String>()); // 记录该层作用域的所有变量, 方便后续的清除
                } else if ("add".equals(token)) {
                    cur.status = ExprStatus.ADD;
                } else if ("mult".equals(token)) {
                    cur.status = ExprStatus.MULT;
                }
                break;
            case "LET":
                if (expression.charAt(start) == ')') { // let 表达式的最后一个 expr 表达式
                    cur.value = calculateToken(token);
                    cur.status = ExprStatus.LET2;
                } else {
                    cur.var = token;
                    vars.peek().push(token); // 记录该层作用域的所有变量, 方便后续的清除
                    cur.status = ExprStatus.LET1;
                }
                break;
            case "LET1":
                scope.putIfAbsent(cur.var, new ArrayDeque<Integer>());
                scope.get(cur.var).push(calculateToken(token));
                cur.status = ExprStatus.LET;
                break;
            case "ADD":
                cur.e1 = calculateToken(token);
                cur.status = ExprStatus.ADD1;
                break;
            case "ADD1":
                cur.e2 = calculateToken(token);
                cur.status = ExprStatus.ADD2;
                break;
            case "MULT":
                cur.e1 = calculateToken(token);
                cur.status = ExprStatus.MULT1;
                break;
            case "MULT1":
                cur.e2 = calculateToken(token);
                cur.status = ExprStatus.MULT2;
                break;
            }
        }
        return cur.value;
    }

    public int calculateToken(String token) {
        if (Character.isLowerCase(token.charAt(0))) {
            return scope.get(token).peek();
        } else {
            return Integer.parseInt(token);
        }
    }
}

enum ExprStatus {
    VALUE,     // 初始状态
    NONE,      // 表达式类型未知
    LET,       // let 表达式
    LET1,      // let 表达式已经解析了 vi 变量
    LET2,      // let 表达式已经解析了最后一个表达式 expr
    ADD,       // add 表达式
    ADD1,      // add 表达式已经解析了 e1 表达式
    ADD2,      // add 表达式已经解析了 e2 表达式
    MULT,      // mult 表达式
    MULT1,     // mult 表达式已经解析了 e1 表达式
    MULT2,     // mult 表达式已经解析了 e2 表达式
    DONE       // 解析完成
}

class Expr {
    ExprStatus status;
    String var; // let 的变量 vi
    int value; // VALUE 状态的数值，或者 LET2 状态最后一个表达式的数值
    int e1, e2; // add 或 mult 表达式的两个表达式 e1 和 e2 的数值

    public Expr(ExprStatus s) {
        status = s;
    }
}
```

```C# [sol2-C#]
public class Solution {
    Dictionary<string, Stack<int>> scope = new Dictionary<string, Stack<int>>();

    public int Evaluate(string expression) {
        Stack<Stack<string>> vars = new Stack<Stack<string>>();
        int start = 0, n = expression.Length;
        Stack<Expr> stack = new Stack<Expr>();
        Expr cur = new Expr(ExprStatus.VALUE);
        while (start < n) {
            if (expression[start] == ' ') {
                start++; // 去掉空格
                continue;
            }
            if (expression[start] == '(') {
                start++; // 去掉左括号
                stack.Push(cur);
                cur = new Expr(ExprStatus.NONE);
                continue;
            }
            StringBuilder sb = new StringBuilder();
            if (expression[start] == ')') { // 本质上是把表达式转成一个 token
                start++; // 去掉右括号
                if (cur.status == ExprStatus.LET2) {
                    sb = new StringBuilder(cur.value.ToString());
                    foreach (string var in vars.Peek()) { // 清除作用域
                        scope[var].Pop();
                    }
                    vars.Pop();
                } else if (cur.status == ExprStatus.ADD2) {
                    sb = new StringBuilder((cur.e1 + cur.e2).ToString());
                } else {
                    sb = new StringBuilder((cur.e1 * cur.e2).ToString());
                }
                cur = stack.Pop(); // 获取上层状态
            } else {
                while (start < n && expression[start] != ' ' && expression[start] != ')') {
                    sb.Append(expression[start]);
                    start++;
                }
            }
            string token = sb.ToString();
            switch (cur.status.ToString()) {
            case "VALUE":
                cur.value = int.Parse(token);
                cur.status = ExprStatus.DONE;
                break;
            case "NONE":
                if ("let".Equals(token)) {
                    cur.status = ExprStatus.LET;
                    vars.Push(new Stack<string>()); // 记录该层作用域的所有变量, 方便后续的清除
                } else if ("add".Equals(token)) {
                    cur.status = ExprStatus.ADD;
                } else if ("mult".Equals(token)) {
                    cur.status = ExprStatus.MULT;
                }
                break;
            case "LET":
                if (expression[start] == ')') { // let 表达式的最后一个 expr 表达式
                    cur.value = CalculateToken(token);
                    cur.status = ExprStatus.LET2;
                } else {
                    cur.var = token;
                    vars.Peek().Push(token); // 记录该层作用域的所有变量, 方便后续的清除
                    cur.status = ExprStatus.LET1;
                }
                break;
            case "LET1":
                if (!scope.ContainsKey(cur.var)) {
                    scope.Add(cur.var, new Stack<int>());
                }
                scope[cur.var].Push(CalculateToken(token));
                cur.status = ExprStatus.LET;
                break;
            case "ADD":
                cur.e1 = CalculateToken(token);
                cur.status = ExprStatus.ADD1;
                break;
            case "ADD1":
                cur.e2 = CalculateToken(token);
                cur.status = ExprStatus.ADD2;
                break;
            case "MULT":
                cur.e1 = CalculateToken(token);
                cur.status = ExprStatus.MULT1;
                break;
            case "MULT1":
                cur.e2 = CalculateToken(token);
                cur.status = ExprStatus.MULT2;
                break;
            }
        }
        return cur.value;
    }

    public int CalculateToken(string token) {
        if (char.IsLower(token[0])) {
            return scope[token].Peek();
        } else {
            return int.Parse(token);
        }
    }
}

public enum ExprStatus {
    VALUE,     // 初始状态
    NONE,      // 表达式类型未知
    LET,       // let 表达式
    LET1,      // let 表达式已经解析了 vi 变量
    LET2,      // let 表达式已经解析了最后一个表达式 expr
    ADD,       // add 表达式
    ADD1,      // add 表达式已经解析了 e1 表达式
    ADD2,      // add 表达式已经解析了 e2 表达式
    MULT,      // mult 表达式
    MULT1,     // mult 表达式已经解析了 e1 表达式
    MULT2,     // mult 表达式已经解析了 e2 表达式
    DONE       // 解析完成
}

public class Expr {
    public ExprStatus status;
    public string var; // let 的变量 vi
    public int value; // VALUE 状态的数值，或者 LET2 状态最后一个表达式的数值
    public int e1, e2; // add 或 mult 表达式的两个表达式 e1 和 e2 的数值

    public Expr(ExprStatus s) {
        status = s;
    }
}
```

```C [sol2-C]
#define MAX_VAR_LEN 64
#define MAX_VAR_SIZE 1024

typedef struct {
    char key[MAX_VAR_LEN];
    struct ListNode *lst;
    UT_hash_handle hh;
} HashItem;

typedef struct VarNode {
    char *var[MAX_VAR_SIZE];
    int varSize;
    struct VarNode *next;
} VarNode;

HashItem *scope = NULL;

typedef enum ExprStatus {
    VALUE = 0, // 初始状态
    NONE,      // 表达式类型未知
    LET,       // let 表达式
    LET1,      // let 表达式已经解析了 vi 变量
    LET2,      // let 表达式已经解析了最后一个表达式 expr
    ADD,       // add 表达式
    ADD1,      // add 表达式已经解析了 e1 表达式
    ADD2,      // add 表达式已经解析了 e2 表达式
    MULT,      // mult 表达式
    MULT1,     // mult 表达式已经解析了 e1 表达式
    MULT2,     // mult 表达式已经解析了 e2 表达式
    DONE       // 解析完成
} ExprStatus;

typedef struct Expr {
    ExprStatus status;
    char var[MAX_VAR_LEN]; // let 的变量 vi
    int value; // VALUE 状态的数值，或者 LET2 状态最后一个表达式的数值
    int e1, e2; // add 或 mult 表达式的两个表达式 e1 和 e2 的数值
} Expr;

Expr *creatExpr(ExprStatus s) {
    Expr *e = (Expr *)malloc(sizeof(Expr));
    e->status = s;
    e->value = 0;
    return e;
}

VarNode *creatVarNode() {
    VarNode *node = (VarNode *)malloc(sizeof(VarNode));
    node->varSize = 0;
    node->next = NULL;
    return node;
}

int calculateToken(const char *token) {
    if (islower(token[0])) {
        HashItem *pEntry = NULL;
        HASH_FIND_STR(scope, token, pEntry);
        return pEntry->lst->val;
    } else {
        return atoi(token);
    }
}

void freeScope() {
    HashItem *curr, *tmp;
    HASH_ITER(hh, scope, curr, tmp) {
      HASH_DEL(scope, curr);
      for (struct ListNode *node = curr->lst; node; ) {
          struct ListNode *pNode = node;
          node = node->next;
          free(pNode);
      }
      free(curr);
    }
}

int evaluate(char * expression){
    VarNode *vars = NULL;
    int start = 0, n = strlen(expression);
    Expr **st = (Expr **)malloc(sizeof(Expr *) * n);
    int top = 0;
    Expr *cur = creatExpr(VALUE);
    HashItem *pEntry = NULL;
    while (start < n) {
        if (expression[start] == ' ') {
            start++; // 去掉空格
            continue;
        }
        if (expression[start] == '(') {
            start++; // 去掉左括号
            st[top++] = cur;
            cur = creatExpr(NONE);
            continue;
        }
        char token[MAX_VAR_LEN];
        int pos = 0;
        if (expression[start] == ')') { // 本质上是把表达式转成一个 token
            start++; // 去掉右括号
            if (cur->status == LET2) {
                pos = sprintf(token, "%d", cur->value);
                for (int i = 0; i < vars->varSize; i++) {
                    pEntry = NULL;
                    HASH_FIND_STR(scope, vars->var[i], pEntry);
                    if (pEntry) {
                        struct ListNode *pNode = pEntry->lst; // 清除当前作用域的变量
                        if (pEntry->lst) {
                            pEntry->lst = pEntry->lst->next;
                            free(pNode);
                        }
                    }
                    free(vars->var[i]);
                }
                VarNode *prev = vars;
                vars = vars->next;    
                free(prev);        
            } else if (cur->status == ADD2) {
                pos = sprintf(token, "%d", cur->e1 + cur->e2);
            } else {
                pos = sprintf(token, "%d", cur->e1 * cur->e2);
            }
            free(cur);
            cur = st[top - 1]; // 获取上层状态
            top--;
        } else {
            while (start < n && expression[start] != ' ' && expression[start] != ')') {
                token[pos++] = expression[start];
                token[pos] = '\0';
                start++;
            }
        }
        switch (cur->status) {
            case VALUE:
                cur->value = atoi(token);
                cur->status = DONE;
                break;
            case NONE:
                if (!strcmp(token, "let")) {
                    cur->status = LET;
                    VarNode *pNode = creatVarNode();
                    pNode->next = vars;
                    vars = pNode; // 记录该层作用域的所有变量, 方便后续的清除
                } else if (!strcmp(token, "add")) {
                    cur->status = ADD;
                } else if (!strcmp(token, "mult")) {
                    cur->status = MULT;
                }
                break;
            case LET:
                if (expression[start] == ')') { // let 表达式的最后一个 expr 表达式
                    cur->value = calculateToken(token);
                    cur->status = LET2;
                } else {
                    strcpy(cur->var, token);
                    vars->var[vars->varSize] = (char *)malloc(sizeof(char) * (strlen(token) + 1));
                    strcpy(vars->var[vars->varSize++], token); // 记录该层作用域的所有变量, 方便后续的清除      
                    cur->status = LET1;         
                }
                break;
            case LET1:
                pEntry = NULL;
                HASH_FIND_STR(scope, cur->var, pEntry);
                if (NULL == pEntry) {
                    pEntry = (HashItem *)malloc(sizeof(HashItem));
                    strcpy(pEntry->key, cur->var);
                    pEntry->lst = NULL;
                    HASH_ADD_STR(scope, key, pEntry);
                }
                struct ListNode *pNode = (struct ListNode *)malloc(sizeof(struct ListNode));
                pNode->val = calculateToken(token);
                pNode->next = pEntry->lst;
                pEntry->lst = pNode; 
                cur->status = LET;
                break;
            case ADD:
                cur->e1 = calculateToken(token);
                cur->status = ADD1;
                break;
            case ADD1:
                cur->e2 = calculateToken(token);
                cur->status = ADD2;
                break;
            case MULT:
                cur->e1 = calculateToken(token);
                cur->status = MULT1;
                break;
            case MULT1:
                cur->e2 = calculateToken(token);
                cur->status = MULT2;
                break;
        }
    }
    freeScope();
    return cur->value;
}
```

```go [sol2-Golang]
const (
    VALUE = iota // 初始状态
    NONE         // 表达式类型未知
    LET          // let 表达式
    LET1         // let 表达式已经解析了 vi 变量
    LET2         // let 表达式已经解析了最后一个表达式 expr
    ADD          // add 表达式
    ADD1         // add 表达式已经解析了 e1 表达式
    ADD2         // add 表达式已经解析了 e2 表达式
    MULT         // mult 表达式
    MULT1        // mult 表达式已经解析了 e1 表达式
    MULT2        // mult 表达式已经解析了 e2 表达式
    DONE         // 解析完成
)

type expr struct {
    status int
    vr     string // let 的变量 vi
    value  int    // VALUE 状态的数值，或者 LET2 状态最后一个表达式的数值
    e1, e2 int    // add 或 mult 表达式的两个表达式 e1 和 e2 的数值
}

func evaluate(expression string) int {
    scope := map[string][]int{}
    calculateToken := func(token string) int {
        if unicode.IsLower(rune(token[0])) {
            vals := scope[token]
            return vals[len(vals)-1]
        }
        val, _ := strconv.Atoi(token)
        return val
    }

    vars := [][]string{}
    s := []expr{}
    cur := expr{status: VALUE}
    for i, n := 0, len(expression); i < n; {
        if expression[i] == ' ' {
            i++ // 去掉空格
            continue
        }
        if expression[i] == '(' {
            i++ // 去掉左括号
            s = append(s, cur)
            cur.status = NONE
            continue
        }
        var token string
        if expression[i] == ')' { // 本质上是把表达式转成一个 token
            i++ // 去掉右括号
            if cur.status == LET2 {
                token = strconv.Itoa(cur.value)
                for _, vr := range vars[len(vars)-1] { // 清除作用域
                    scope[vr] = scope[vr][:len(scope[vr])-1]
                }
                vars = vars[:len(vars)-1]
            } else if cur.status == ADD2 {
                token = strconv.Itoa(cur.e1 + cur.e2)
            } else {
                token = strconv.Itoa(cur.e1 * cur.e2)
            }
            cur, s = s[len(s)-1], s[:len(s)-1] // 获取上层状态
        } else {
            i0 := i
            for i < n && expression[i] != ' ' && expression[i] != ')' {
                i++
            }
            token = expression[i0:i]
        }

        switch cur.status {
        case VALUE:
            cur.value, _ = strconv.Atoi(token)
            cur.status = DONE
        case NONE:
            if token == "let" {
                cur.status = LET
                vars = append(vars, nil) // 记录该层作用域的所有变量, 方便后续的清除
            } else if token == "add" {
                cur.status = ADD
            } else if token == "mult" {
                cur.status = MULT
            }
        case LET:
            if expression[i] == ')' { // let 表达式的最后一个 expr 表达式
                cur.value = calculateToken(token)
                cur.status = LET2
            } else {
                cur.vr = token
                vars[len(vars)-1] = append(vars[len(vars)-1], token) // 记录该层作用域的所有变量, 方便后续的清除
                cur.status = LET1
            }
        case LET1:
            scope[cur.vr] = append(scope[cur.vr], calculateToken(token))
            cur.status = LET
        case ADD:
            cur.e1 = calculateToken(token)
            cur.status = ADD1
        case ADD1:
            cur.e2 = calculateToken(token)
            cur.status = ADD2
        case MULT:
            cur.e1 = calculateToken(token)
            cur.status = MULT1
        case MULT1:
            cur.e2 = calculateToken(token)
            cur.status = MULT2
        }
    }
    return cur.value
}
```

```JavaScript [sol2-JavaScript]
var evaluate = function(expression) {
    const scope = new Map();
    let vars = [];
    let start = 0, n = expression.length;
    const stack = [];
    let cur = new Expr(ExprStatus.VALUE);

    while (start < n) {
        if (expression[start] === ' ') {
            start++; // 去掉空格
            continue;
        }
        if (expression[start] === '(') {
            start++; // 去掉左括号
            stack.push(cur);
            cur = new Expr(ExprStatus.NONE);
            continue;
        }
        let sb = '';
        if (expression[start] === ')') { // 本质上是把表达式转成一个 token
            start++; // 去掉右括号
            if (cur.status == ExprStatus.LET2) {
                sb = cur.value;
                for (const v of vars[vars.length - 1]) { // 清除作用域
                    scope.get(v).pop();
                }
                vars.pop();
            } else if (cur.status === ExprStatus.ADD2) {
                sb = cur.e1 + cur.e2;
            } else {
                sb = cur.e1 * cur.e2;
            }
            cur = stack.pop(); // 获取上层状态
        } else {
            while (start < n && expression[start] !== ' ' && expression[start] !== ')') {
                sb += expression[start];
                start++;
            }
        }
        let token = sb;
        switch (cur.status) {
        case "VALUE":
            cur.value = parseInt(token);
            cur.status = ExprStatus.DONE;
            break;
        case "NONE":
            if ("let" === token) {
                cur.status = ExprStatus.LET;
                vars.push([]); // 记录该层作用域的所有变量, 方便后续的清除
            } else if ("add" === token) {
                cur.status = ExprStatus.ADD;
            } else if ("mult" === token) {
                cur.status = ExprStatus.MULT;
            }
            break;
        case "LET":
            if (expression[start] === ')') { // let 表达式的最后一个 expr 表达式
                cur.value = calculateToken(scope, token);
                cur.status = ExprStatus.LET2;
            } else {
                cur.v = token;
                vars[vars.length - 1].push(token); // 记录该层作用域的所有变量, 方便后续的清除
                cur.status = ExprStatus.LET1;
            }
            break;
        case "LET1":
            if (!scope.has(cur.v)) {
                scope.set(cur.v, []);
            }
            scope.get(cur.v).push(calculateToken(scope, token));
            cur.status = ExprStatus.LET;
            break;
        case "ADD":
            cur.e1 = calculateToken(scope, token);
            cur.status = ExprStatus.ADD1;
            break;
        case "ADD1":
            cur.e2 = calculateToken(scope, token);
            cur.status = ExprStatus.ADD2;
            break;
        case "MULT":
            cur.e1 = calculateToken(scope, token);
            cur.status = ExprStatus.MULT1;
            break;
        case "MULT1":
            cur.e2 = calculateToken(scope, token);
            cur.status = ExprStatus.MULT2;
            break;
        }
    }
    return cur.value;
}

const calculateToken = (scope, token) => {
    if (token[0] >= 'a' && token[0] <= 'z') {
        const n = scope.get(token).length;
        return scope.get(token)[n - 1];
    } else {
        return parseInt(token);
    }
};

var ExprStatus = {
    VALUE: 'VALUE',     // 初始状态
    NONE: 'NONE',      // 表达式类型未知
    LET: 'LET',       // let 表达式
    LET1: 'LET1',      // let 表达式已经解析了 vi 变量
    LET2: 'LET2',      // let 表达式已经解析了最后一个表达式 expr
    ADD: 'ADD',       // add 表达式
    ADD1: 'ADD1',      // add 表达式已经解析了 e1 表达式
    ADD2: 'ADD2',      // add 表达式已经解析了 e2 表达式
    MULT: 'MULT',      // mult 表达式
    MULT1: 'MULT1',     // mult 表达式已经解析了 e1 表达式
    MULT2: 'MULT2',     // mult 表达式已经解析了 e2 表达式
    DONE: 'DONE'       // 解析完成
}

class Expr {
    constructor(s) {
        this.status = s;
        this.v = ''; // let 的变量 vi
        this.value = 0; // VALUE 状态的数值，或者 LET2 状态最后一个表达式的数值
        this.e1 = 0; // add 或 mult 表达式的两个表达式 e1 和 e2 的数值
        this.e2 = 0;
    }
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{expression}$ 的长度。状态机解析会遍历整个字符串，因此需要 $O(n)$ 的时间。

+ 空间复杂度：$O(n)$。保存状态的栈以及作用域变量都需要 $O(n)$ 的空间。
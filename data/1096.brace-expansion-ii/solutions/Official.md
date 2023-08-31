## [1096.花括号展开 II 中文官方题解](https://leetcode.cn/problems/brace-expansion-ii/solutions/100000/hua-gua-hao-zhan-kai-ii-by-leetcode-solu-1s1y)

#### 方法一：递归解析

**思路与算法**

表达式可以拆分为多个子表达式，以逗号分隔或者直接相接。我们应当先按照逗号分割成多个子表达式进行求解，然后再对所有结果求并集。这样做的原因是求积的优先级高于求并集的优先级。

我们用 $\textit{expr}$ 表示一个任意一种表达式，用 $\textit{term}$ 表示一个最外层没有逗号分割的表达式，那么 $\textit{expr}$ 可以按照如下规则分解：

$$\textit{expr} \rightarrow \textit{term}~|~\textit{term}, \textit{expr}$$

其中的 $|$ 表示或者，即 $\textit{expr}$ 可以分解为前者，也可以分解为后者。

再来看 $\textit{term}$, $\textit{term}$ 可以由小写英文字母或者花括号包括的表达式直接相接组成，我们用 item 来表示每一个相接单元，那么 term 可以按照如下规则分解：

$$\textit{term} \rightarrow \textit{item}~|~\textit{item}~\textit{term}$$

$\textit{item}$ 可以进一步分解为小写英文字母 $\textit{letter}$ 或者花括号包括的表达式，它的分解如下：

$$\textit{item} \rightarrow \textit{letter}~|~\{expr\}$$

在代码中，我们编写三个函数，分别负责以上三种规则的分解：
1. $\textit{expr}$ 函数，不断的调用 $\textit{term}$，并与其结果进行合并。如果匹配到表达式末尾或者当前字符不是逗号时，则返回。
2. $\textit{term}$ 函数，不断的调用 $\textit{item}$，并与其结果求积。如果匹配到表达式末尾或者当前字符不是小写字母，并且也不是左括号时，则返回。
3. $\textit{item}$ 函数，根据当前字符是不是左括号来求解。如果是左括号，则调用 $\textit{expr}$，返回结果；否则构造一个只包含当前字符的字符串集合，返回结果。

以下示意图以 $\{a,b\}\{c,\{d,e\}\}$ 为例，展示了表达式递归拆解以及回溯的全过程。

<![fig1](https://assets.leetcode-cn.com/solution-static/1096/1.png),![fig2](https://assets.leetcode-cn.com/solution-static/1096/2.png)>

在代码实现过程中有以下细节：

1. 维护一个外部指针来遍历整个表达式，或者将表达式和当前遍历下标以引用的方式传递给被调函数。
2. 因为最终答案需要去重，所以可以先用集合来求解中间结果，最后再转换成已排序的列表作为最终答案。

**代码**

```C++ [sol1-C++]
class Solution {
    string expression;
    int idx;

    // item -> letter | { expr }
    set<string> item() {
        set<string> ret;
        if (expression[idx] == '{') {
            idx++;
            ret = expr();
        } else {
            ret = {string(1, expression[idx])};
        }
        idx++;
        return move(ret);
    }

    // term -> item | item term
    set<string> term() {
        // 初始化空集合，与之后的求解结果求笛卡尔积
        set<string> ret = {""};
        // item 的开头是 { 或小写字母，只有符合时才继续匹配
        while (idx < expression.size() && (expression[idx] == '{' || isalpha(expression[idx]))) {
            auto sub = item();
            set<string> tmp;
            for (auto &left : ret) {
                for (auto &right : sub) {
                    tmp.insert(left + right);
                }
            }
            ret = move(tmp);
        }
        return move(ret);
    }

    // expr -> term | term, expr
    set<string> expr() {
        set<string> ret;
        while (true) {
            // 与 term() 求解结果求并集
            ret.merge(term());
            // 如果匹配到逗号则继续，否则结束匹配
            if (idx < expression.size() && expression[idx] == ',') {
                idx++;
                continue;
            } else {
                break;
            }
        }
        return move(ret);
    }

public:
    vector<string> braceExpansionII(string expression) {
        this->expression = expression;
        this->idx = 0;
        auto ret = expr();
        return {ret.begin(), ret.end()};
    }
};
```

```Java [sol1-Java]
class Solution {
    String expression;
    int idx;

    public List<String> braceExpansionII(String expression) {
        this.expression = expression;
        this.idx = 0;
        Set<String> ret = expr();
        return new ArrayList<String>(ret);
    }

    // item . letter | { expr }
    private Set<String> item() {
        Set<String> ret = new TreeSet<String>();
        if (expression.charAt(idx) == '{') {
            idx++;
            ret = expr();
        } else {
            StringBuilder sb = new StringBuilder();
            sb.append(expression.charAt(idx));
            ret.add(sb.toString());
        }
        idx++;
        return ret;
    }

    // term . item | item term
    private Set<String> term() {
        // 初始化空集合，与之后的求解结果求笛卡尔积
        Set<String> ret = new TreeSet<String>() {{
            add("");
        }};
        // item 的开头是 { 或小写字母，只有符合时才继续匹配
        while (idx < expression.length() && (expression.charAt(idx) == '{' || Character.isLetter(expression.charAt(idx)))) {
            Set<String> sub = item();
            Set<String> tmp = new TreeSet<String>();
            for (String left : ret) {
                for (String right : sub) {
                    tmp.add(left + right);
                }
            }
            ret = tmp;
        }
        return ret;
    }

    // expr . term | term, expr
    private Set<String> expr() {
        Set<String> ret = new TreeSet<String>();
        while (true) {
            // 与 term() 求解结果求并集
            ret.addAll(term());
            // 如果匹配到逗号则继续，否则结束匹配
            if (idx < expression.length() && expression.charAt(idx) == ',') {
                idx++;
                continue;
            } else {
                break;
            }
        }
        return ret;
    }
}
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 是 $\textit{expression}$ 的长度。整个 $\textit{expression}$ 只会遍历一次，时间复杂度为 $O(n)$，集合合并以及求积运算的时间复杂度为 $O(n\log n)$，因此总的时间复杂度为 $O(n \log n)$。

- 空间复杂度：$O(n)$。递归过程所需的栈空间为 $O(n)$，以及存放中间答案的空间复杂度为 $O(n)$，因此总的空间复杂度为 $O(n)$。

#### 方法二：栈

**思路与算法**

如果把题目中的表达式并列关系看做是求和，把相接看做是求积，那么求解整个表达式的过程可以类比于求解中缀表达式的过程，例如：$\{a,b\}\{c,\{d,e\}\}$ 可以看做是 $\{a,b\} \times \{c + \{d + e\}\}$。

与求解中缀表达式一样，在遍历表达式的过程中我们需要用到两个栈，一个用来存放运算符（即加号和乘号，以及左大括号），另一个用来存运算对象（即集合）。

在本题中有一个特殊情况需要处理，就是乘号需要我们自己来添加，我们按照当前字符的种类来判断前面是否需要添加乘号：

1. 如果当前字符是 $``\{"$，并且前面是 $``\}"$ 或者小写英文字母时，需要添加乘号运算。
2. 如果当前字符是小写字母，并且前面是 $``\}"$ 或者是小写英文字母时，需要添加乘号运算。
3. 如果当前字符是 $``,"$ ，则前面一定不需要添加乘号运算。
4. 如果当前字符是 $``\}"$，则前面一定不需要添加乘号运算。

因此，只有当前字符是 $``\{"$ 或者小写字母时，才需要考虑是否在前面添加乘号。

接下来我们分析运算优先级的问题，在本题中只涉及加法和乘法两种运算。如果一个表达式同时有并列和相接，那我们应该先计算相接的结果，再计算并列的结果。因此，乘法的优先级要大于加法。

至此，我们可以按照如下流程来计算表达式的值：

1. 如果遇到 $``,"$，则先判断运算符栈顶是否是乘号，如果是乘号则需要先计算乘法，直到栈顶不是乘号为止，再将加号放入运算符栈中。
2. 如果遇到 $``\{"$，则先判断是否需要添加乘号，再将 { 放入运算符栈。
3. 如果遇到 $``\}"$，则不断地弹出运算符栈顶，并进行相应的计算，直到栈顶为左括号为止。
4. 如果遇到小写字母，则先判断是否需要添加乘号，再构造一个只包含当前小写字母的字符串集合，放入集合栈中。

按照上述流程遍历完一次之后，由于题目给定的表达式中最外层可能没有大括号，例如 $\{a,b\}\{c,\{d,e\}\}$，因此运算符栈中可能依然有元素，我们需要依次将他们弹出并进行计算。最终，集合栈栈顶元素即为答案。

下面展示了以 $\{a,b\}\{c,\{d,e\}\}$ 为例求解的全过程：

<![fig3](https://assets.leetcode-cn.com/solution-static/1096/3.png),![fig4](https://assets.leetcode-cn.com/solution-static/1096/4.png),![fig5](https://assets.leetcode-cn.com/solution-static/1096/5.png),![fig6](https://assets.leetcode-cn.com/solution-static/1096/6.png),![fig7](https://assets.leetcode-cn.com/solution-static/1096/7.png),![fig8](https://assets.leetcode-cn.com/solution-static/1096/8.png),![fig9](https://assets.leetcode-cn.com/solution-static/1096/9.png),![fig10](https://assets.leetcode-cn.com/solution-static/1096/10.png),![fig11](https://assets.leetcode-cn.com/solution-static/1096/11.png),![fig12](https://assets.leetcode-cn.com/solution-static/1096/12.png),![fig13](https://assets.leetcode-cn.com/solution-static/1096/13.png),![fig14](https://assets.leetcode-cn.com/solution-static/1096/14.png),![fig15](https://assets.leetcode-cn.com/solution-static/1096/15.png),![fig16](https://assets.leetcode-cn.com/solution-static/1096/16.png),![fig17](https://assets.leetcode-cn.com/solution-static/1096/17.png)>

**代码**

```C++ [sol2-C++]
class Solution {
public:
    vector<string> braceExpansionII(string expression) {
        vector<char> op;
        vector<set<string>> stk;

        // 弹出栈顶运算符，并进行计算
        auto ope = [&]() {
            int l = stk.size() - 2, r = stk.size() - 1;
            if (op.back() == '+') {
                stk[l].merge(stk[r]);
            } else {
                set<string> tmp;
                for (auto &left : stk[l]) {
                    for (auto &right : stk[r]) {
                        tmp.insert(left + right);
                    }
                }
                stk[l] = move(tmp);
            }
            op.pop_back();
            stk.pop_back();
        };

        for (int i = 0; i < expression.size(); i++) {
            if (expression[i] == ',') {
                // 不断地弹出栈顶运算符，直到栈为空或者栈顶不为乘号
                while (op.size() && op.back() == '*') {
                    ope();
                }
                op.push_back('+');
            } else if (expression[i] == '{') {
                // 首先判断是否需要添加乘号，再将 { 添加到运算符栈中
                if (i > 0 && (expression[i - 1] == '}' || isalpha(expression[i - 1]))) {
                    op.push_back('*');
                }
                op.push_back('{');
            } else if (expression[i] == '}') {
                // 不断地弹出栈顶运算符，直到栈顶为 {
                while (op.size() && op.back() != '{') {
                    ope();
                }
                op.pop_back();
            } else {
                // 首先判断是否需要添加乘号，再将新构造的集合添加到集合栈中
                if (i > 0 && (expression[i - 1] == '}' || isalpha(expression[i - 1]))) {
                    op.push_back('*');
                }
                stk.push_back({string(1, expression[i])});
            }
        }
        
        while (op.size()) {
            ope();
        }
        return {stk.back().begin(), stk.back().end()};
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<String> braceExpansionII(String expression) {
        Deque<Character> op = new ArrayDeque<Character>();
        List<Set<String>> stk = new ArrayList<Set<String>>();

        for (int i = 0; i < expression.length(); i++) {
            if (expression.charAt(i) == ',') {
                // 不断地弹出栈顶运算符，直到栈为空或者栈顶不为乘号
                while (!op.isEmpty() && op.peek() == '*') {
                    ope(op, stk);
                }
                op.push('+');
            } else if (expression.charAt(i) == '{') {
                // 首先判断是否需要添加乘号，再将 { 添加到运算符栈中
                if (i > 0 && (expression.charAt(i - 1) == '}' || Character.isLetter(expression.charAt(i - 1)))) {
                    op.push('*');
                }
                op.push('{');
            } else if (expression.charAt(i) == '}') {
                // 不断地弹出栈顶运算符，直到栈顶为 {
                while (!op.isEmpty() && op.peek() != '{') {
                    ope(op, stk);
                }
                op.pop();
            } else {
                // 首先判断是否需要添加乘号，再将新构造的集合添加到集合栈中
                if (i > 0 && (expression.charAt(i - 1) == '}' || Character.isLetter(expression.charAt(i - 1)))) {
                    op.push('*');
                }
                StringBuilder sb = new StringBuilder();
                sb.append(expression.charAt(i));
                stk.add(new TreeSet<String>() {{
                    add(sb.toString());
                }});
            }
        }
        
        while (!op.isEmpty()) {
            ope(op, stk);
        }
        return new ArrayList<String>(stk.get(stk.size() - 1));
    }

    // 弹出栈顶运算符，并进行计算
    public void ope(Deque<Character> op, List<Set<String>> stk) {
        int l = stk.size() - 2, r = stk.size() - 1;
        if (op.peek() == '+') {
            stk.get(l).addAll(stk.get(r));
        } else {
            Set<String> tmp = new TreeSet<String>();
            for (String left : stk.get(l)) {
                for (String right : stk.get(r)) {
                    tmp.add(left + right);
                }
            }
            stk.set(l, tmp);
        }
        op.pop();
        stk.remove(stk.size() - 1);
    }
}
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 是 $\textit{expression}$ 的长度。整个 $\textit{expression}$ 只会遍历一次，时间复杂度为 $O(n)$，集合合并以及求积运算的时间复杂度为 $O(n\log n)$，因此总的时间复杂度为 $O(n \log n)$。

- 空间复杂度：$O(n)$。过程中用到了两个栈，他们都满足在任意时刻元素个数不超过 $O(n)$，包含 $n$ 个元素的集合的时间复杂度为 $O(n)$，因此总的空间复杂度为 $O(n)$。
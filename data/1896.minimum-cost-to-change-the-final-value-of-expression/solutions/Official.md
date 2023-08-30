#### 方法一：表达式解析 + 动态规划

**前言**

在阅读本题题解之前，我们希望读者已经掌握了[「224. 基本计算器」](https://leetcode-cn.com/problems/basic-calculator/)，并且知道如何使用两个栈（一个数字栈、一个符号栈）解决该问题。

我们会修改上面提到的表达式解析的方法，从而设计出一种可以解决本题的方法。在本题解中，我们不会去解释「表达式解析」中的每一步需要怎么做，以及为什么要这么做，因此我们希望读者在掌握了[「224. 基本计算器」](https://leetcode-cn.com/problems/basic-calculator/)后再来尝试解决本题。

这里我们给出几个简单的测试题，供读者测试自己是否已经掌握：

- 在[「224. 基本计算器」](https://leetcode-cn.com/problems/basic-calculator/)中，我们应当在什么时候取出数字栈顶的两个元素以及符号栈顶的一个符号，将它们进行运算，并将结果放回数字栈顶？在本题中，我们需要处理的数字只有 $0$ 和 $1$，是否可以进行一些优化？

- 当我们遇到左括号 $($ 时，我们应当如何操作？需要将左括号放入符号栈吗？需要进行运算吗？

- 当我们遇到右括号 $)$ 时，我们应当如何操作？需要将右括号放入符号栈吗？需要进行运算吗？

**思路与算法**

如果我们只需要对表达式进行解析，那么在数字栈中，我们存放表达式的值即可。

然而本题需要我们通过最少的操作次数，将表达式的值反转，即 $0$ 变成 $1$，$1$ 变成 $0$，因此我们可以考虑在数字栈中多存放一些值。一种解决方法是：

- 我们在数字栈中存放一个二元组 $(x, y)$，其中 $x$ 表示**将对应表达式的值变为 $0$，需要的最少操作次数**，$y$ 表示**将对应表达式的值变为 $1$，需要的最少操作次数**。

那么我们只需要修改表达式解析中的四个部分：

- 如果我们遇到一个 $0$，原先我们会将 $0$ 入数字栈，而此时我们需要将二元组 $(0, 1)$ 入数字栈。因为 $0$ 就是 $0$，而将 $0$ 变成 $1$ 需要一次操作；

- 如果我们遇到一个 $1$，原先我们会将 $1$ 入数字栈，而此时我们需要将二元组 $(1, 0)$ 入数字栈。因为 $1$ 就是 $1$，而将 $1$ 变成 $0$ 需要一次操作；

- 如果我们需要取出数字栈顶的两个二元组（原先是元素）以及符号栈顶的 $\texttt{\&}$ 与运算符进行运算，原先我们只需要将两个元素进行与运算，再将结果放回数字栈即可，而此时我们需要对两个二元组进行与运算：

    - 设两个二元组分别为 $(x_1, y_1)$ 以及 $(x_2, y_2)$。根据与运算的性质，只有 $\texttt{1 \& 1 = 1}$，其余情况均为 $0$，因此我们得到的二元组 $(x_\textit{and}, y_\textit{and})$ 有状态转移方程：

    $$
    \begin{cases}
    x_\textit{and} = \min\big\{ x_1+x_2, x_1+y_2, y_1+x_2 \big\} \\
    y_\textit{and} = y_1+y_2
    \end{cases}
    $$

- 如果我们需要取出数字栈顶的两个二元组（原先是元素）以及符号栈顶的 $\texttt{|}$ 或运算符进行运算，原先我们只需要将两个元素进行或运算，再将结果放回数字栈即可，而此时我们需要对两个二元组进行或运算：

    - 设两个二元组分别为 $(x_1, y_1)$ 以及 $(x_2, y_2)$。根据或运算的性质，只有 $\texttt{0 | 0 = 0}$，其余情况均为 $1$，因此我们得到的二元组 $(x_\textit{or}, y_\textit{or})$ 有状态转移方程：

    $$
    \begin{cases}
    x_\textit{or} = x_1+x_2 \\
    y_\textit{or} = \min\big\{ x_1+y_2, y_1+x_2, y_1+y_2 \big\} \\
    \end{cases}
    $$

- 根据题目描述，我们可以使用一次操作将 $\texttt{\&}$ 变成 $\texttt{|}$，或者将 $\texttt{|}$ 变成 $\texttt{\&}$，因此 $x_\textit{and}$ 还可以从 $x_\textit{or}+1$ 转移而来，其它的情况类似。因此，根据符号栈顶的符号，我们会选择：

    $$
    \begin{cases}
    x_\textit{and} = \min\big\{ x_1+x_2, x_1+y_2, y_1+x_2, x_\textit{or}+1 \big\} \\
    y_\textit{and} = \min\big\{ y_1+y_2, y_\textit{or}+1 \big\}
    \end{cases}
    $$

    或者：

    $$
    \begin{cases}
    x_\textit{or} = \min\big\{ x_1+x_2, x_\textit{and}+1 \big\} \\
    y_\textit{or} = \min\big\{ x_1+y_2, y_1+x_2, y_1+y_2, y_\textit{and}+1 \big\} \\
    \end{cases}
    $$

    进行状态转移。

当我们完成**修改后的**表达式解析时，符号栈为空，数字栈中恰好有一个二元组 $(x, y)$，其中 $x$ 表示将整个表达式的值变为 $0$ 最少需要的操作次数，$y$ 表示将整个表达式的值变为 $1$ 最少需要的操作次数。然而我们并不知道表达式的值究竟是 $0$ 还是 $1$，因此不能确定是返回 $x$ 和 $y$ 作为答案。

然而我们发现，由于**动态规划中的状态转移一定是最优的**，因此如果表达式的值为 $0$，那么 $x$ 的值一定为 $0$，答案为 $y$；如果表达式的值为 $1$，$y$ 的值一定为 $0$，答案为 $x$。因此，最终的答案即为 $\max(x, y)$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minOperationsToFlip(string expression) {
        // 数字栈
        vector<pair<int, int>> stack_num;
        // 符号栈
        vector<char> stack_op;

        auto op_and = [](int x1, int y1, int x2, int y2) -> pair<int, int> {
            return {min({x1 + x2, x1 + y2, y1 + x2}), y1 + y2};
        };

        auto op_or = [](int x1, int y1, int x2, int y2) -> pair<int, int> {
            return {x1 + x2, min({x1 + y2, y1 + x2, y1 + y2})};
        };

        // 尝试将数字栈顶的两个二元组和符号栈顶的运算符进行运算
        auto calc = [&]() {
            if (stack_num.size() >= 2 && (stack_op.back() == '|' || stack_op.back() == '&')) {
                auto [x1, y1] = stack_num.back();
                stack_num.pop_back();
                auto [x2, y2] = stack_num.back();
                stack_num.pop_back();

                auto [x_and, y_and] = op_and(x1, y1, x2, y2);
                auto [x_or, y_or] = op_or(x1, y1, x2, y2);
                
                if (stack_op.back() == '&') {
                    stack_num.emplace_back(min(x_and, x_or + 1), min(y_and, y_or + 1));
                }
                else {
                    stack_num.emplace_back(min(x_or, x_and + 1), min(y_or, y_and + 1));
                }
                stack_op.pop_back();
            }
        };
        
        for (char ch: expression) {
            if (ch == '(' || ch == '|' || ch == '&') {
                stack_op.push_back(ch);
            }
            else if (ch == '0') {
                stack_num.emplace_back(0, 1);
                calc();
            }
            else if (ch == '1') {
                stack_num.emplace_back(1, 0);
                calc();
            }
            else {
                assert(ch == ')');
                // 此时符号栈栈顶一定是左括号
                stack_op.pop_back();
                calc();
            }
        }

        return max(stack_num[0].first, stack_num[0].second);
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minOperationsToFlip(self, expression: str) -> int:
        # 数字栈
        stack_num = list()
        # 符号栈
        stack_op = list()

        def op_and(x1: int, y1: int, x2: int, y2: int) -> (int, int):
            return min(x1 + x2, x1 + y2, y1 + x2), y1 + y2

        def op_or(x1: int, y1: int, x2: int, y2: int) -> (int, int):
            return x1 + x2, min(x1 + y2, y1 + x2, y1 + y2)
        
        # 尝试将数字栈顶的两个二元组和符号栈顶的运算符进行运算
        def calc():
            if len(stack_num) >= 2 and stack_op[-1] in ["|", "&"]:
                x1, y1 = stack_num.pop()
                x2, y2 = stack_num.pop()
                
                x_and, y_and = op_and(x1, y1, x2, y2)
                x_or, y_or = op_or(x1, y1, x2, y2)

                if (op := stack_op.pop()) == "&":
                    stack_num.append((min(x_and, x_or + 1), min(y_and, y_or + 1)))
                else:
                    stack_num.append((min(x_or, x_and + 1), min(y_or, y_and + 1)))

        for ch in expression:
            if ch in ["(", "|", "&"]:
                stack_op.append(ch)
            elif ch == "0":
                stack_num.append((0, 1))
                calc()
            elif ch == "1":
                stack_num.append((1, 0))
                calc()
            else:
                assert ch == ")"
                # 此时符号栈栈顶一定是左括号
                stack_op.pop()
                calc()

        return max(stack_num[0])
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{expression}$ 的长度。

- 空间复杂度：$O(n)$。在最坏情况下，数字栈和符号栈需要使用 $O(n)$ 的空间。
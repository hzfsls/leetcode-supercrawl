## [8.字符串转换整数 (atoi) 中文官方题解](https://leetcode.cn/problems/string-to-integer-atoi/solutions/100000/zi-fu-chuan-zhuan-huan-zheng-shu-atoi-by-leetcode-)
### 视频题解 
#### 简述
根据问题的描述我们来判断并且描述对应的解题方法。对于这道题目，很明显是字符串的转化问题。需要明确转化规则，尽量根据转化规则编写对应的子函数。

这里我们要进行模式识别，一旦涉及整数的运算，我们需要注意溢出。本题可能产生溢出的步骤在于推入、乘以 $10$ 操作和累加操作都可能造成溢出。对于溢出的处理方式通常可以转换为 `INT_MAX` 的逆操作。比如判断某数乘以 $10$ 是否会溢出，那么就把该数和 `INT_MAX` 除以 $10$ 进行比较。

![.... 字符串转换整数 (atoi).mp4](3c712e6e-fcf7-4953-9401-bd1d5c2b9cb8)

### 文字题解
#### 方法一：自动机

**思路**

字符串处理的题目往往涉及复杂的流程以及条件情况，如果直接上手写程序，一不小心就会写出极其臃肿的代码。

因此，为了有条理地分析每个输入字符的处理方法，我们可以使用自动机这个概念：

我们的程序在每个时刻有一个状态 `s`，每次从序列中输入一个字符 `c`，并根据字符 `c` 转移到下一个状态 `s'`。这样，我们只需要建立一个覆盖所有情况的从 `s` 与 `c` 映射到 `s'` 的表格即可解决题目中的问题。

**算法**

本题可以建立如下图所示的自动机：

![fig1](https://assets.leetcode-cn.com/solution-static/8/fig1.png)

我们也可以用下面的表格来表示这个自动机：

|  | ' ' | +/- | number | other |
|-----------|:-----:|:------:|:---------:|:-----:|
| **start** | start | signed | in_number | end |
| **signed** | end | end | in_number | end |
| **in_number** | end | end | in_number | end |
| **end** | end | end | end | end |

接下来编程部分就非常简单了：我们只需要把上面这个状态转换表抄进代码即可。

另外自动机也需要记录当前已经输入的数字，只要在 `s'` 为 `in_number` 时，更新我们输入的数字，即可最终得到输入的数字。

```Python [sol1-Python3]
INT_MAX = 2 ** 31 - 1
INT_MIN = -2 ** 31

class Automaton:
    def __init__(self):
        self.state = 'start'
        self.sign = 1
        self.ans = 0
        self.table = {
            'start': ['start', 'signed', 'in_number', 'end'],
            'signed': ['end', 'end', 'in_number', 'end'],
            'in_number': ['end', 'end', 'in_number', 'end'],
            'end': ['end', 'end', 'end', 'end'],
        }
        
    def get_col(self, c):
        if c.isspace():
            return 0
        if c == '+' or c == '-':
            return 1
        if c.isdigit():
            return 2
        return 3

    def get(self, c):
        self.state = self.table[self.state][self.get_col(c)]
        if self.state == 'in_number':
            self.ans = self.ans * 10 + int(c)
            self.ans = min(self.ans, INT_MAX) if self.sign == 1 else min(self.ans, -INT_MIN)
        elif self.state == 'signed':
            self.sign = 1 if c == '+' else -1

class Solution:
    def myAtoi(self, str: str) -> int:
        automaton = Automaton()
        for c in str:
            automaton.get(c)
        return automaton.sign * automaton.ans
```
```C++ [sol1-C++]
class Automaton {
    string state = "start";
    unordered_map<string, vector<string>> table = {
        {"start", {"start", "signed", "in_number", "end"}},
        {"signed", {"end", "end", "in_number", "end"}},
        {"in_number", {"end", "end", "in_number", "end"}},
        {"end", {"end", "end", "end", "end"}}
    };

    int get_col(char c) {
        if (isspace(c)) return 0;
        if (c == '+' or c == '-') return 1;
        if (isdigit(c)) return 2;
        return 3;
    }
public:
    int sign = 1;
    long long ans = 0;

    void get(char c) {
        state = table[state][get_col(c)];
        if (state == "in_number") {
            ans = ans * 10 + c - '0';
            ans = sign == 1 ? min(ans, (long long)INT_MAX) : min(ans, -(long long)INT_MIN);
        }
        else if (state == "signed")
            sign = c == '+' ? 1 : -1;
    }
};

class Solution {
public:
    int myAtoi(string str) {
        Automaton automaton;
        for (char c : str)
            automaton.get(c);
        return automaton.sign * automaton.ans;
    }
};
```
```Java [sol1-Java]
class Solution {
    public int myAtoi(String str) {
        Automaton automaton = new Automaton();
        int length = str.length();
        for (int i = 0; i < length; ++i) {
            automaton.get(str.charAt(i));
        }
        return (int) (automaton.sign * automaton.ans);
    }
}

class Automaton {
    public int sign = 1;
    public long ans = 0;
    private String state = "start";
    private Map<String, String[]> table = new HashMap<String, String[]>() {{
        put("start", new String[]{"start", "signed", "in_number", "end"});
        put("signed", new String[]{"end", "end", "in_number", "end"});
        put("in_number", new String[]{"end", "end", "in_number", "end"});
        put("end", new String[]{"end", "end", "end", "end"});
    }};

    public void get(char c) {
        state = table.get(state)[get_col(c)];
        if ("in_number".equals(state)) {
            ans = ans * 10 + c - '0';
            ans = sign == 1 ? Math.min(ans, (long) Integer.MAX_VALUE) : Math.min(ans, -(long) Integer.MIN_VALUE);
        } else if ("signed".equals(state)) {
            sign = c == '+' ? 1 : -1;
        }
    }

    private int get_col(char c) {
        if (c == ' ') {
            return 0;
        }
        if (c == '+' || c == '-') {
            return 1;
        }
        if (Character.isDigit(c)) {
            return 2;
        }
        return 3;
    }
}
```

**复杂度分析**

* 时间复杂度：$O(n)$，其中 $n$ 为字符串的长度。我们只需要依次处理所有的字符，处理每个字符需要的时间为 $O(1)$。

* 空间复杂度：$O(1)$。自动机的状态只需要常数空间存储。
## [394.字符串解码 中文官方题解](https://leetcode.cn/problems/decode-string/solutions/100000/zi-fu-chuan-jie-ma-by-leetcode-solution)
### 📺 视频题解  
![394. 字符串解码.mp4](2a9aeb51-59d9-4cc3-9d02-4ac416c29cef)

### 📖 文字题解
#### 方法一：栈操作

**思路和算法**

本题中可能出现括号嵌套的情况，比如 `2[a2[bc]]`，这种情况下我们可以先转化成 `2[abcbc]`，在转化成 `abcbcabcbc`。我们可以把字母、数字和括号看成是独立的 TOKEN，并用栈来维护这些 TOKEN。具体的做法是，遍历这个栈：

+ 如果当前的字符为数位，解析出一个数字（连续的多个数位）并进栈
+ 如果当前的字符为字母或者左括号，直接进栈
+ 如果当前的字符为右括号，开始出栈，一直到左括号出栈，出栈序列反转后拼接成一个字符串，此时取出栈顶的数字（**此时栈顶一定是数字，想想为什么？**），就是这个字符串应该出现的次数，我们根据这个次数和字符串构造出新的字符串并进栈

重复如上操作，最终将栈中的元素按照从栈底到栈顶的顺序拼接起来，就得到了答案。**注意：这里可以用不定长数组来模拟栈操作，方便从栈底向栈顶遍历。**

```cpp [sol1-C++]
class Solution {
public:
    string getDigits(string &s, size_t &ptr) {
        string ret = "";
        while (isdigit(s[ptr])) {
            ret.push_back(s[ptr++]);
        }
        return ret;
    }

    string getString(vector <string> &v) {
        string ret;
        for (const auto &s: v) {
            ret += s;
        }
        return ret;
    }

    string decodeString(string s) {
        vector <string> stk;
        size_t ptr = 0;

        while (ptr < s.size()) {
            char cur = s[ptr];
            if (isdigit(cur)) {
                // 获取一个数字并进栈
                string digits = getDigits(s, ptr);
                stk.push_back(digits);
            } else if (isalpha(cur) || cur == '[') {
                // 获取一个字母并进栈
                stk.push_back(string(1, s[ptr++])); 
            } else {
                ++ptr;
                vector <string> sub;
                while (stk.back() != "[") {
                    sub.push_back(stk.back());
                    stk.pop_back();
                }
                reverse(sub.begin(), sub.end());
                // 左括号出栈
                stk.pop_back();
                // 此时栈顶为当前 sub 对应的字符串应该出现的次数
                int repTime = stoi(stk.back()); 
                stk.pop_back();
                string t, o = getString(sub);
                // 构造字符串
                while (repTime--) t += o; 
                // 将构造好的字符串入栈
                stk.push_back(t);
            }
        }

        return getString(stk);
    }
};
```

```Java [sol1-Java]
class Solution {
    int ptr;

    public String decodeString(String s) {
        LinkedList<String> stk = new LinkedList<String>();
        ptr = 0;

        while (ptr < s.length()) {
            char cur = s.charAt(ptr);
            if (Character.isDigit(cur)) {
                // 获取一个数字并进栈
                String digits = getDigits(s);
                stk.addLast(digits);
            } else if (Character.isLetter(cur) || cur == '[') {
                // 获取一个字母并进栈
                stk.addLast(String.valueOf(s.charAt(ptr++))); 
            } else {
                ++ptr;
                LinkedList<String> sub = new LinkedList<String>();
                while (!"[".equals(stk.peekLast())) {
                    sub.addLast(stk.removeLast());
                }
                Collections.reverse(sub);
                // 左括号出栈
                stk.removeLast();
                // 此时栈顶为当前 sub 对应的字符串应该出现的次数
                int repTime = Integer.parseInt(stk.removeLast());
                StringBuffer t = new StringBuffer();
                String o = getString(sub);
                // 构造字符串
                while (repTime-- > 0) {
                    t.append(o);
                }
                // 将构造好的字符串入栈
                stk.addLast(t.toString());
            }
        }

        return getString(stk);
    }

    public String getDigits(String s) {
        StringBuffer ret = new StringBuffer();
        while (Character.isDigit(s.charAt(ptr))) {
            ret.append(s.charAt(ptr++));
        }
        return ret.toString();
    }

    public String getString(LinkedList<String> v) {
        StringBuffer ret = new StringBuffer();
        for (String s : v) {
            ret.append(s);
        }
        return ret.toString();
    }
}
```

```golang [sol1-Golang]
func decodeString(s string) string {
    stk := []string{}
    ptr := 0
    for ptr < len(s) {
        cur := s[ptr]
        if cur >= '0' && cur <= '9' {
            digits := getDigits(s, &ptr)
            stk = append(stk, digits)
        } else if (cur >= 'a' && cur <= 'z' || cur >= 'A' && cur <= 'Z') || cur == '[' {
            stk = append(stk, string(cur))
            ptr++
        } else {
            ptr++
            sub := []string{}
            for stk[len(stk)-1] != "[" {
                sub = append(sub, stk[len(stk)-1])
                stk = stk[:len(stk)-1]
            }
            for i := 0; i < len(sub)/2; i++ {
                sub[i], sub[len(sub)-i-1] = sub[len(sub)-i-1], sub[i]
            }
            stk = stk[:len(stk)-1]
            repTime, _ := strconv.Atoi(stk[len(stk)-1])
            stk = stk[:len(stk)-1]
            t := strings.Repeat(getString(sub), repTime)
            stk = append(stk, t)
        }
    }
    return getString(stk)
}

func getDigits(s string, ptr *int) string {
    ret := ""
    for ; s[*ptr] >= '0' && s[*ptr] <= '9'; *ptr++ {
        ret += string(s[*ptr])
    }
    return ret
}

func getString(v []string) string {
    ret := ""
    for _, s := range v {
        ret += s
    }
    return ret
}
```

**复杂度分析**

+ 时间复杂度：记解码后得出的字符串长度为 $S$，除了遍历一次原字符串 $s$，我们还需要将解码后的字符串中的每个字符都入栈，并最终拼接进答案中，故渐进时间复杂度为 $O(S+|s|)$，即 $O(S)$。
+ 空间复杂度：记解码后得出的字符串长度为 $S$，这里用栈维护 TOKEN，栈的总大小最终与 $S$ 相同，故渐进空间复杂度为 $O(S)$。

#### 方法二：递归

**思路和算法**

我们也可以用递归来解决这个问题，从左向右解析字符串：

+ 如果当前位置为数字位，那么后面一定包含一个用方括号表示的字符串，即属于这种情况：`k[...]`：
  + 我们可以先解析出一个数字，然后解析到了左括号，递归向下解析后面的内容，遇到对应的右括号就返回，此时我们可以根据解析出的数字 $x$ 解析出的括号里的字符串 $s'$ 构造出一个新的字符串 $x \times s'$；
  + 我们把 `k[...]` 解析结束后，再次调用递归函数，解析右括号右边的内容。
+ 如果当前位置是字母位，那么我们直接解析当前这个字母，然后递归向下解析这个字母后面的内容。

**如果觉得这里讲的比较抽象，可以结合代码理解一下这个过程。**

**下面我们可以来讲讲这样做的依据，涉及到《编译原理》相关内容，感兴趣的同学可以参考阅读。** 根据题目的定义，我们可以推导出这样的巴科斯范式（BNF）：
$$
\begin{aligned} 
    {\rm String} &\rightarrow {
        \rm Digits \, [String] \, String \, | \,
        Alpha \, String \, | \, 
        \epsilon 
    } \\
    {\rm Digits} &\rightarrow {
        \rm Digit \, Digits \, | \,
        Digit 
    } \\
    {\rm Alpha} &\rightarrow { 
        a | \cdots | z | A | \cdots | Z
    } \\
    {\rm Digit} &\rightarrow { 
        0 | \cdots | 9
    } \\
    \end{aligned}
$$

+ $\rm Digit$ 表示十进制数位，可能的取值是 $0$ 到 $9$ 之间的整数
+ $\rm Alpha$ 表示字母，可能的取值是大小写字母的集合，共 $52$ 个
+ $\rm Digit$ 表示一个整数，它的组成是 $\rm Digit$ 出现一次或多次
+ $\rm String$ 代表一个代解析的字符串，它可能有三种构成，如 BNF 所示
+ $\rm \epsilon$ 表示空串，即没有任何子字符

由于 $\rm Digits$ 和 $\rm Alpha$ 构成简单，很容易进行词法分析，我们把它他们看作独立的 TOKEN。那么此时的非终结符有 $\rm String$，终结符有 $\rm Digits$、$\rm Alpha$ 和 $\rm  \epsilon$，我们可以根据非终结符和 FOLLOW 集构造出这样的预测分析表：
| |$\rm Alpha$|$\rm Digits$|$\rm \epsilon$|
|----|----|----|----|
|$\rm String$| $\rm String \rightarrow Alpha \, String$ | $\rm String \rightarrow Digits \, [String] \, String$ | $\rm String \rightarrow \epsilon$ |

可见不含多重定义的项，为 LL(1) 文法，即：

- 从左向右分析（Left-to-right-parse）
- 最左推导（Leftmost-derivation）
- 超前查看一个符号（1-symbol lookahead）

它决定了我们从左向右遍历这个字符串，每次只判断当前最左边的一个字符的分析方法是正确的。

代码如下。

```cpp [sol2-C++]
class Solution {
public:
    string src; 
    size_t ptr;

    int getDigits() {
        int ret = 0;
        while (ptr < src.size() && isdigit(src[ptr])) {
            ret = ret * 10 + src[ptr++] - '0';
        }
        return ret;
    }

    string getString() {
        if (ptr == src.size() || src[ptr] == ']') {
            // String -> EPS
            return "";
        }

        char cur = src[ptr]; int repTime = 1;
        string ret;

        if (isdigit(cur)) {
            // String -> Digits [ String ] String
            // 解析 Digits
            repTime = getDigits(); 
            // 过滤左括号
            ++ptr;
            // 解析 String
            string str = getString(); 
            // 过滤右括号
            ++ptr;
            // 构造字符串
            while (repTime--) ret += str; 
        } else if (isalpha(cur)) {
            // String -> Char String
            // 解析 Char
            ret = string(1, src[ptr++]);
        }
        
        return ret + getString();
    }

    string decodeString(string s) {
        src = s;
        ptr = 0;
        return getString();
    }
};
```

```Java [sol2-Java]
class Solution {
    String src;
    int ptr;

    public String decodeString(String s) {
        src = s;
        ptr = 0;
        return getString();
    }

    public String getString() {
        if (ptr == src.length() || src.charAt(ptr) == ']') {
            // String -> EPS
            return "";
        }

        char cur = src.charAt(ptr);
        int repTime = 1;
        String ret = "";

        if (Character.isDigit(cur)) {
            // String -> Digits [ String ] String
            // 解析 Digits
            repTime = getDigits(); 
            // 过滤左括号
            ++ptr;
            // 解析 String
            String str = getString(); 
            // 过滤右括号
            ++ptr;
            // 构造字符串
            while (repTime-- > 0) {
                ret += str;
            }
        } else if (Character.isLetter(cur)) {
            // String -> Char String
            // 解析 Char
            ret = String.valueOf(src.charAt(ptr++));
        }
        
        return ret + getString();
    }

    public int getDigits() {
        int ret = 0;
        while (ptr < src.length() && Character.isDigit(src.charAt(ptr))) {
            ret = ret * 10 + src.charAt(ptr++) - '0';
        }
        return ret;
    }
}
```

```golang [sol2-Golang]
var (
    src string
    ptr int
)

func decodeString(s string) string {
    src = s
    ptr = 0
    return getString()
}

func getString() string {
    if ptr == len(src) || src[ptr] == ']' {
        return ""
    }
    cur := src[ptr]
    repTime := 1
    ret := ""
    if cur >= '0' && cur <= '9' {
        repTime = getDigits()
        ptr++
        str := getString()
        ptr++
        ret = strings.Repeat(str, repTime)
    } else if cur >= 'a' && cur <= 'z' || cur >= 'A' && cur <= 'Z' {
        ret = string(cur)
        ptr++
    }
    return ret + getString()
}

func getDigits() int {
    ret := 0
    for ; src[ptr] >= '0' && src[ptr] <= '9'; ptr++ {
        ret = ret * 10 + int(src[ptr] - '0')
    }
    return ret
}
```

**复杂度分析**

+ 时间复杂度：记解码后得出的字符串长度为 $S$，除了遍历一次原字符串 $s$，我们还需要将解码后的字符串中的每个字符都拼接进答案中，故渐进时间复杂度为 $O(S+|s|)$，即 $O(S)$。
+ 空间复杂度：若不考虑答案所占用的空间，那么就只剩递归使用栈空间的大小，这里栈空间的使用和递归树的深度成正比，最坏情况下为 $O(|s|)$，故渐进空间复杂度为 $O(|s|)$。
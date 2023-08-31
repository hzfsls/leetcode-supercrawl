## [504.七进制数 中文官方题解](https://leetcode.cn/problems/base-7/solutions/100000/qi-jin-zhi-shu-by-leetcode-solution-cl2v)
#### 方法一：倒推 + 迭代

**思路**

一个正数的七进制表示 $\textit{num}_7: \overline{a_0a_1...a_{n-1}}$（其中 $n$ 为其七进制表示的位数，$a_0$ 为最高位，$a_{n-1}$ 为最低位），其对应的十进制表示为 $\textit{num}_{10} = \sum\limits_{i=0}^{n-1}a_i \times 7^{n-1-i}$。据此，当我们要计算一个十进制数对应的七进制表示时，可以先计算最低位 $a_{n-1} = \textit{num}_{10} \bmod 7$，因为 $\textit{num}_{10}$ 中对 $7$ 有余的部分仅由 $a_{n-1}$ 贡献。从两边都减去最低位 $a_{n-1}$ 可得，$\textit{num}_{10} - a_{n-1} = \sum\limits_{i=0}^{n-2}a_i \times 7^{n-1-i}$。两边都除以 $7$，可得 $\dfrac{\textit{num}_{10} - a_{n-1}}{7} = \sum\limits_{i=0}^{n-2}a_i \times 7^{n-2-i}$。此时，$\dfrac{\textit{num}_{10} - a_{n-1}}{7}$ 中对 $7$ 有余的部分仅由 $a_{n-2}$ 贡献，可得，$a_{n-2} = \dfrac{\textit{num}_{10} - a_{n-1}}{7} \bmod 7$。依此不停迭代，我们可以从最低位到最高位还原出 $\textit{num}_7$ 的各位数字，直到 $\textit{num}_{10}$ 归 $0$。

在代码实现上，输入 $\textit{num}$ 代表我们思路中的十进制表示 $\textit{num}_{10}$，我们需要将还原出的 $\textit{num}_7$ 以字符串的形式返回。

当输入为负时，我们可以先取 $\textit{num}$ 的绝对值来求七进制，最后再添加负号。 

**代码**

```Python [sol1-Python3]
class Solution:
    def convertToBase7(self, num: int) -> str:
        if num == 0:
            return "0"
        negative = num < 0
        num = abs(num)
        digits = []
        while num:
            digits.append(str(num % 7))
            num //= 7
        if negative:
            digits.append('-')
        return ''.join(reversed(digits))
```

```Java [sol1-Java]
class Solution {
    public String convertToBase7(int num) {
        if (num == 0) {
            return "0";
        }
        boolean negative = num < 0;
        num = Math.abs(num);
        StringBuffer digits = new StringBuffer();
        while (num > 0) {
            digits.append(num % 7);
            num /= 7;
        }
        if (negative) {
            digits.append('-');
        }
        return digits.reverse().toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string ConvertToBase7(int num) {
        if (num == 0) {
            return "0";
        }
        bool negative = num < 0;
        num = Math.Abs(num);
        StringBuilder sb = new StringBuilder();
        while (num > 0) {
            sb.Append(num % 7);
            num /= 7;
        }
        if (negative) {
            sb.Append('-');
        }
        StringBuilder digits = new StringBuilder();
        for (int i = sb.Length - 1; i >= 0; i--) {
            digits.Append(sb[i]);
        }
        return digits.ToString();
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    string convertToBase7(int num) {
        if (num == 0) {
            return "0";
        }
        bool negative = num < 0;
        num = abs(num);
        string digits;
        while (num > 0) {
            digits.push_back(num % 7 + '0');
            num /= 7;
        }
        if (negative) {
            digits.push_back('-');
        }
        reverse(digits.begin(), digits.end());
        return digits;
    }
};
```

```C [sol1-C]
char * convertToBase7(int num){
    if (num == 0) {
        return "0";
    }
    bool negative = num < 0;
    num = abs(num);
    char * digits = (char *)malloc(sizeof(char) * 32);
    int pos = 0;
    while (num > 0) {
        digits[pos++] = num % 7 + '0';
        num /= 7;
    }
    if (negative) {
        digits[pos++] = '-';
    }
    for (int l = 0, r = pos - 1; l < r; l++, r--) {
        char c = digits[l];
        digits[l] = digits[r];
        digits[r] = c;
    }
    digits[pos] = '\0';
    return digits;
}
```

```JavaScript [sol1-JavaScript]
var convertToBase7 = function(num) {
    if (num === 0) {
        return "0";
    }
    let negative = num < 0;
    num = Math.abs(num);
    const digits = [];
    while (num > 0) {
        digits.push(num % 7);
        num = Math.floor(num / 7);
    }
    if (negative) {
        digits.push('-');
    }
    return digits.reverse().join('');
};
```

```go [sol1-Golang]
func convertToBase7(num int) string {
    if num == 0 {
        return "0"
    }
    negative := num < 0
    if negative {
        num = -num
    }
    s := []byte{}
    for num > 0 {
        s = append(s, '0'+byte(num%7))
        num /= 7
    }
    if negative {
        s = append(s, '-')
    }
    for i, n := 0, len(s); i < n/2; i++ {
        s[i], s[n-1-i] = s[n-1-i], s[i]
    }
    return string(s)
}
```

**复杂度分析**

- 时间复杂度：$O(\log |\textit{num}|)$，其中 $|\textit{num}|$ 表示 $\textit{num}$ 的绝对值。循环中最多做 $O(\log |\textit{num}|)$ 次除法。

- 空间复杂度：$O(\log |\textit{num}|)$。字符数组的长度最多为 $O(\log |\textit{num}|)$。部分语言可以直接修改字符串，空间复杂度为 $O(1)$。
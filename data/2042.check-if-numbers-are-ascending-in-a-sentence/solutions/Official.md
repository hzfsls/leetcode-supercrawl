## [2042.检查句子中的数字是否递增 中文官方题解](https://leetcode.cn/problems/check-if-numbers-are-ascending-in-a-sentence/solutions/100000/jian-cha-ju-zi-zhong-de-shu-zi-shi-fou-d-uhaf)

#### 方法一：直接遍历

**思路与算法**

题目要求检查给定的字符串 $s$ 中 $\textit{token}$ 为数字时是否从左到右严格递增，根据题意可知相邻的 $\textit{token}$ 之间由空格分割，我们按照要求依次取出字符串中的每个 $\textit{token}$，如果当前的 $\textit{token}$ 由数字组成，将该 $\textit{token}$ 转换为十进制数 $\textit{cur}$，设前一个数字 $\textit{token}$ 转换后的整数 $\textit{pre}$，检验过程如下:
+ 如果 $\textit{cur}$ 大于 $\textit{pre}$，则认为当前的 $token$ 满足递增要求，更新 $pre$ 为 $cur$，并检测下一个数字 $token$ 是否满足递增； 
+ 如果 $\textit{cur}$ 小于或者等于 $\textit{pre}$，则认为不满足递增要求，返回 $\text{false}$；

由于题目中的每个数字 $\textit{token}$ 转换后的十进制数均为正整数且小于 $100$，因此我们可以初始化 $\textit{pre}$ 等于 $0$，我们依次检测每个为数字的 $\textit{token}$ 是否满足题目要求即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def areNumbersAscending(self, s: str) -> bool:
        pre = i = 0
        while i < len(s):
            if s[i].isdigit():
                cur = 0
                while i < len(s) and s[i].isdigit():
                    cur = cur * 10 + int(s[i])
                    i += 1
                if cur <= pre:
                    return False
                pre = cur
            else:
                i += 1
        return True
```

```C++ [sol1-C++]
class Solution {
public:
    bool areNumbersAscending(string s) {
        int pre = 0, pos = 0;
        while (pos < s.size()) {
            if (isdigit(s[pos])) {
                int cur = 0;
                while (pos < s.size() && isdigit(s[pos])) {
                    cur = cur * 10 + s[pos] - '0';
                    pos++;
                }
                if (cur <= pre) {
                    return false;
                }
                pre = cur;
            } else {
                pos++;
            }
        }
        return true;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean areNumbersAscending(String s) {
        int pre = 0, pos = 0;
        while (pos < s.length()) {
            if (Character.isDigit(s.charAt(pos))) {
                int cur = 0;
                while (pos < s.length() && Character.isDigit(s.charAt(pos))) {
                    cur = cur * 10 + s.charAt(pos) - '0';
                    pos++;
                }
                if (cur <= pre) {
                    return false;
                }
                pre = cur;
            } else {
                pos++;
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool AreNumbersAscending(string s) {
        int pre = 0, pos = 0;
        while (pos < s.Length) {
            if (char.IsDigit(s[pos])) {
                int cur = 0;
                while (pos < s.Length && char.IsDigit(s[pos])) {
                    cur = cur * 10 + s[pos] - '0';
                    pos++;
                }
                if (cur <= pre) {
                    return false;
                }
                pre = cur;
            } else {
                pos++;
            }
        }
        return true;
    }
}
```

```C [sol1-C]
bool areNumbersAscending(char * s) {
    int pre = 0, pos = 0;
    while (s[pos] != '\0') {
        if (isdigit(s[pos])) {
            int cur = 0;
            while (s[pos] != '\0' && isdigit(s[pos])) {
                cur = cur * 10 + s[pos] - '0';
                pos++;
            }
            if (cur <= pre) {
                return false;
            }
            pre = cur;
        } else {
            pos++;
        }
    }
    return true;
}
```

```JavaScript [sol1-JavaScript]
var areNumbersAscending = function(s) {
    let pre = 0, pos = 0;
    while (pos < s.length) {
        if (isDigit(s[pos])) {
            let cur = 0;
            while (pos < s.length && isDigit(s[pos])) {
                cur = cur * 10 + s[pos].charCodeAt() - '0'.charCodeAt();
                pos++;
            }
            if (cur <= pre) {
                return false;
            }
            pre = cur;
        } else {
            pos++;
        }
    }
    return true;
};

const isDigit = (ch) => {
    return parseFloat(ch).toString() === "NaN" ? false : true;
}
```

```go [sol1-Golang]
func areNumbersAscending(s string) bool {
    pre, i := 0, 0
    for i < len(s) {
        if unicode.IsDigit(rune(s[i])) {
            cur := 0
            for i < len(s) && unicode.IsDigit(rune(s[i])) {
                cur = cur*10 + int(s[i]-'0')
                i++
            }
            if cur <= pre {
                return false
            }
            pre = cur
        } else {
            i++
        }
    }
    return true
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 表示字符串的长度。我们只需遍历一遍字符串即可。

- 空间复杂度：$O(1)$。仅用到若干额外变量。
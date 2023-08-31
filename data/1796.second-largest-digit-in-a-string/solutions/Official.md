## [1796.字符串中第二大的数字 中文官方题解](https://leetcode.cn/problems/second-largest-digit-in-a-string/solutions/100000/zi-fu-chuan-zhong-di-er-da-de-shu-zi-by-ujgwp)

#### 方法一：直接遍历

**思路与算法**

题目要求找到字符串 $s$ 中第二大的数字，我们用 $\textit{first}$、$\textit{second}$ 分别记录 $s$ 中第一大的数字与第二大的数字，且初始化时二者均为 $-1$，当我们遍历字符串中第 $i$ 个字符 $s[i]$ 时：
+ 如果第 $s[i]$ 为字母则跳过；
+ 如果第 $s[i]$ 为数字，则令 $\textit{num}$ 表示 $s[i]$ 对应的十进制数字：
    - 如果满足 $\textit{num} > \textit{first}$，则当前最大的数字为 $\textit{num}$，第二大的数字为 $\textit{first}$，则此时更新 $\textit{second}$ 等于当前的 $\textit{first}$，更新当前的 $\textit{first}$ 为 $\textit{num}$ 即可。
    - 如果满足 $\textit{second} < \textit{num} < \textit{first}$，则当前最大的数字为 $\textit{first}$，第二大的数字为 $\textit{num}$，则此时更新当前的 $\textit{second}$ 为 $\textit{num}$ 即可。
    - 如果满足 $\textit{num} \le \textit{second}$，则此时不需要任何更新。

最终返回第二大数字 $\textit{second}$ 即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def secondHighest(self, s: str) -> int:
        first = second = -1
        for c in s:
            if c.isdigit():
                num = int(c)
                if num > first:
                    second = first
                    first = num
                elif second < num < first:
                    second = num
        return second
```

```C++ [sol1-C++]
class Solution {
public:
    int secondHighest(string s) {
        int first = -1, second = -1;
        for (auto c : s) {
            if (isdigit(c)) {
                int num = c - '0';
                if (num > first) {
                    second = first;
                    first = num;
                } else if (num < first && num > second) {
                    second = num;
                }
            }
        }
        return second;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int secondHighest(String s) {
        int first = -1, second = -1;
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (Character.isDigit(c)) {
                int num = c - '0';
                if (num > first) {
                    second = first;
                    first = num;
                } else if (num < first && num > second) {
                    second = num;
                }
            }
        }
        return second;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int SecondHighest(string s) {
        int first = -1, second = -1;
        foreach (char c in s) {
            if (char.IsDigit(c)) {
                int num = c - '0';
                if (num > first) {
                    second = first;
                    first = num;
                } else if (num < first && num > second) {
                    second = num;
                }
            }
        }
        return second;
    }
}
```

```C [sol1-C]
int secondHighest(char * s) {
    int first = -1, second = -1;
    for (int i = 0; s[i]; i++) {
        if (isdigit(s[i])) {
            int num = s[i] - '0';
            if (num > first) {
                second = first;
                first = num;
            } else if (num < first && num > second) {
                second = num;
            }
        }
    }
    return second;
}
```

```JavaScript [sol1-JavaScript]
var secondHighest = function(s) {
    let first = -1, second = -1;
    for (let i = 0; i < s.length; i++) {
        const c = s[i];
        if ('0' <= c && c <= '9') {
            const num = c.charCodeAt() - '0'.charCodeAt();
            if (num > first) {
                second = first;
                first = num;
            } else if (num < first && num > second) {
                second = num;
            }
        }
    }
    return second;
};
```

```go [sol1-Golang]
func secondHighest(s string) int {
    first, second := -1, -1
    for _, c := range s {
        if unicode.IsDigit(c) {
            num := int(c - '0')
            if num > first {
                second = first
                first = num
            } else if second < num && num < first {
                second = num
            }
        }
    }
    return second
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 表示字符串的长度。我们只需遍历一遍字符串即可。

- 空间复杂度：$O(1)$。仅需常数个空间即可。
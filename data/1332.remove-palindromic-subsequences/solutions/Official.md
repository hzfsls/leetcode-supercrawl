## [1332.删除回文子序列 中文官方题解](https://leetcode.cn/problems/remove-palindromic-subsequences/solutions/100000/shan-chu-hui-wen-zi-xu-lie-by-leetcode-s-tqtb)

#### 方法一：直接判断

由于字符串本身只含有字母 $\texttt{`a'}$ 和 $\texttt{`b'}$ 两种字符，题目要求每次删除回文子序列（不一定连续）而使得字符串最终为空。题目中只包含两种不同的字符，由于相同的字符组成的子序列一定是回文子序列，因此最多只需要删除 $2$ 次即可删除所有的字符。删除判断如下：
+ 如果该字符串本身为回文串，此时只需删除 $1$ 次即可，删除次数为 $1$。
+ 如果该字符串本身不是回文串，此时只需删除 $2$ 次即可，比如可以先删除所有的 $\texttt{`a'}$，再删除所有的 $\texttt{`b'}$，删除次数为 $2$。

**代码**

```Python [sol1-Python3]
class Solution:
    def removePalindromeSub(self, s: str) -> int:
        return 1 if s == s[::-1] else 2
```

```Java [sol1-Java]
class Solution {
    public int removePalindromeSub(String s) {
        int n = s.length();
        for (int i = 0; i < n / 2; ++i) {
            if (s.charAt(i) != s.charAt(n - 1 - i)) {
                return 2;
            }
        }
        return 1;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int removePalindromeSub(string s) {
        int n = s.size();
        for (int i = 0; i < n / 2; ++i) {
            if (s[i] != s[n - 1 - i]) {
                return 2;
            }
        }
        return 1;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public int RemovePalindromeSub(string s) {
        int n = s.Length;
        for (int i = 0; i < n / 2; ++i) {
            if (s[i] != s[n - 1 - i]) {
                return 2;
            }
        }
        return 1;
    }
}
```

```C [sol1-C]
int removePalindromeSub(char * s) {
    int n = strlen(s);
    for (int i = 0; i < n / 2; ++i) {
        if (s[i] != s[n - 1 - i]) {
            return 2;
        }
    }
    return 1;
}
```

```go [sol1-Golang]
func removePalindromeSub(s string) int {
    for i, n := 0, len(s); i < n/2; i++ {
        if s[i] != s[n-1-i] {
            return 2
        }
    }
    return 1
}
```

```JavaScript [sol1-JavaScript]
var removePalindromeSub = function(s) {
    const n = s.length;
    for (let i = 0; i < Math.floor(n / 2); ++i) {
        if (s[i] !== s[n - 1 - i]) {
            return 2;
        }
    }
    return 1;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串的长度。

- 空间复杂度：$O(1)$。
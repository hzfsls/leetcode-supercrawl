## [1576.替换所有的问号 中文官方题解](https://leetcode.cn/problems/replace-all-s-to-avoid-consecutive-repeating-characters/solutions/100000/ti-huan-suo-you-de-wen-hao-by-leetcode-s-f7mp)
#### 方法一：遍历扫描

题目要求将字符串 $s$ 中的 $\texttt{`?'}$ 转换为若干小写字母，转换后的字母与该字母的前后字母均不相同。遍历字符串 $s$，如果遇到第 $i$ 个字符 $s[i]$ 为 $\texttt{`?'}$ 时，此时直接在英文字母 $\texttt{`a'-`z'}$ 中找到一个与 $s[i-1]$ 和 $s[i+1]$ 均不相同的字母进行替换即可。

在替换时，实际不需要遍历所有的小写字母，只需要遍历三个互不相同的字母，就能保证一定找到一个与前后字符均不相同的字母，在此我们可以限定三个不同的字母为 $\texttt{(`a',`b',`c')}$。

**代码**

```Java [sol1-Java]
class Solution {
    public String modifyString(String s) {
        int n = s.length();
        char[] arr = s.toCharArray();
        for (int i = 0; i < n; ++i) {
            if (arr[i] == '?') {
                for (char ch = 'a'; ch <= 'c'; ++ch) {
                    if ((i > 0 && arr[i - 1] == ch) || (i < n - 1 && arr[i + 1] == ch)) {
                        continue;
                    }
                    arr[i] = ch;
                    break;
                }
            }
        }
        return new String(arr);
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    string modifyString(string s) {
        int n = s.size();
        for (int i = 0; i < n; ++i) {
            if (s[i] == '?') {
                for (char ch = 'a'; ch <= 'c'; ++ch) {
                    if ((i > 0 && s[i - 1] == ch) || (i < n - 1 && s[i + 1] == ch)) {
                        continue;
                    }
                    s[i] = ch;
                    break;
                }
            }
        }
        return s;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public string ModifyString(string s) {
        int n = s.Length;
        char[] arr = s.ToCharArray();
        for (int i = 0; i < n; ++i) {
            if (arr[i] == '?') {
                for (char ch = 'a'; ch <= 'c'; ++ch) {
                    if ((i > 0 && arr[i - 1] == ch) || (i < n - 1 && arr[i + 1] == ch)) {
                        continue;
                    }
                    arr[i] = ch;
                    break;
                }
            }
        }
        return new String(arr);
    }
}
```

```C [sol1-C]
char * modifyString(char * s) {
    int n = strlen(s);
    for (int i = 0; i < n; ++i) {
        if (s[i] == '?') {
            for (char ch = 'a'; ch <= 'c'; ++ch) {
                if ((i > 0 && s[i - 1] == ch) || (i < n - 1 && s[i + 1] == ch)) {
                    continue;
                }
                s[i] = ch;
                break;
            }
        }
    }
    return s;
}
```

```JavaScript [sol1-JavaScript]
var modifyString = function(s) {
    const n = s.length;
    const arr = [...s];
    for (let i = 0; i < n; ++i) {
        if (arr[i] === '?') {
            for (let j = 0; j < 3; ++j) {
                if ((i > 0 && arr[i - 1] === String.fromCharCode('a'.charCodeAt() + j)) || (i < n - 1 && arr[i + 1] === String.fromCharCode('a'.charCodeAt() + j))) {
                    continue;
                }
                arr[i] = String.fromCharCode('a'.charCodeAt() + j);
                break;
            }
        }
    }
    return arr.join('');
};
```

```go [sol1-Golang]
func modifyString(s string) string {
    res := []byte(s)
    n := len(res)
    for i, ch := range res {
        if ch == '?' {
            for b := byte('a'); b <= 'c'; b++ {
                if !(i > 0 && res[i-1] == b || i < n-1 && res[i+1] == b) {
                    res[i] = b
                    break
                }
            }
        }
    }
    return string(res)
}
```

```Python [sol1-Python3]
class Solution:
    def modifyString(self, s: str) -> str:
        res = list(s)
        n = len(res)
        for i in range(n):
            if res[i] == '?':
                for b in "abc":
                    if not (i > 0 and res[i - 1] == b or i < n - 1 and res[i + 1] == b):
                        res[i] = b
                        break
        return ''.join(res)
```

**复杂度分析**

- 时间复杂度：$O(C \times n)$，其中 $n$ 是字符串的长度，我们需要遍历一遍字符串，$C$ 表示可替代字符的数量，在本题中 $C=3$。

- 空间复杂度：$O(1)$。除了函数返回值以外我们不需要再申请额外的空间。
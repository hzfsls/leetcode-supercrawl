## [482.密钥格式化 中文官方题解](https://leetcode.cn/problems/license-key-formatting/solutions/100000/mi-yao-ge-shi-hua-by-leetcode-solution-xnae)
#### 方法一：数学

**思路及解法**

首先我们取出所有不为破折号的字符，题目要求对取出的字符进行重新分组，使得每个分组恰好包含 $k$ 个字符，且必须满足第一个分组包含的字符个数必须小于等于 $k$，但至少要包含 $1$ 个字符。设已经取出的字符的总数为 $n$，只需满足第一个分组包含的字符数目刚好等于 $n \bmod k$，剩余的分组包含的字符数目刚好等于 $k$。
+ 我们可以从字符串 $s$ 的末尾开始往前取出字符构建新的字符串 $\textit{ans}$。每次取出字符时首先判断该字符是否为破折号，如果为破折号则跳过；否则将当前的字符计数 $\textit{cnt}$ 加 $1$，同时检查如果当前字符为小写字母则将其转化为大写字母，将当前字符加入到字符串 $\textit{ans}$ 的末尾。
+ 对字符进行计数时，每隔 $k$ 个字符就在字符串 $\textit{ans}$ 中添加一个破折号。特殊情况需要处理，字符串 $\textit{ans}$ 的最后一个字符为破折号则将其去掉。
+ 我们对已经构建的字符串 $\textit{ans}$ 进行反转即为返回结果。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string licenseKeyFormatting(string s, int k) {
        string ans;
        int cnt = 0;
        
        for (int i = s.size() - 1; i >= 0; i--) {
            if (s[i] != '-') {
                ans.push_back(toupper(s[i]));
                cnt++;
                if (cnt % k == 0) {
                    ans.push_back('-');
                }  
            }
        }
        if (ans.size() > 0 && ans.back() == '-') {
            ans.pop_back();
        }
        reverse(ans.begin(), ans.end());
        
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String licenseKeyFormatting(String s, int k) {
        StringBuilder ans = new StringBuilder();
        int cnt = 0;

        for (int i = s.length() - 1; i >= 0; i--) {
            if (s.charAt(i) != '-') {
                cnt++;
                ans.append(Character.toUpperCase(s.charAt(i)));
                if (cnt % k == 0) {
                    ans.append("-");
                }
            }
        }
        if (ans.length() > 0 && ans.charAt(ans.length() - 1) == '-') {
            ans.deleteCharAt(ans.length() - 1);
        }
        
        return ans.reverse().toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string LicenseKeyFormatting(string s, int k) {
        StringBuilder sb = new StringBuilder();
        int cnt = 0;

        for (int i = s.Length - 1; i >= 0; i --) {
            if (s[i] != '-') {
                cnt++;
                sb.Append(char.ToUpper(s[i]));
                if (cnt % k == 0) {
                    sb.Append("-");
                }
            }
        }
        if (sb.Length > 0 && sb[sb.Length - 1] == '-') {
            sb.Remove(sb.Length - 1, 1);
        }

        char[] cs = sb.ToString().ToCharArray();
        Array.Reverse(cs);
        return new string(cs);
    }
}
```

```Python [sol1-Python3]
class Solution:
    def licenseKeyFormatting(self, s: str, k: int) -> str:
        ans = list()
        cnt = 0

        for i in range(len(s) - 1, -1, -1):
            if s[i] != "-":
                ans.append(s[i].upper())
                cnt += 1
                if cnt % k == 0:
                    ans.append("-")
        
        if ans and ans[-1] == "-":
            ans.pop()
        
        return "".join(ans[::-1])
```

```JavaScript [sol1-JavaScript]
var licenseKeyFormatting = function(s, k) {
    const ans = [];
    let cnt = 0;

    for (let i = s.length - 1; i >= 0; i--) {
        if (s[i] !== '-') {
            cnt++;
            ans.push(s[i].toUpperCase());
            if (cnt % k === 0) {
                ans.push("-");
            }
        }
    }
    if (ans.length > 0 && ans[ans.length - 1] === '-') {
        ans.pop();
    }
    
    return ans.reverse().join('');
};
```

```go [sol1-Golang]
func licenseKeyFormatting(s string, k int) string {
    ans := []byte{}
    for i, cnt := len(s)-1, 0; i >= 0; i-- {
        if s[i] != '-' {
            ans = append(ans, byte(unicode.ToUpper(rune(s[i]))))
            cnt++
            if cnt%k == 0 {
                ans = append(ans, '-')
            }
        }
    }
    if len(ans) > 0 && ans[len(ans)-1] == '-' {
        ans = ans[:len(ans)-1]
    }
    for i, n := 0, len(ans); i < n/2; i++ {
        ans[i], ans[n-1-i] = ans[n-1-i], ans[i]
    }
    return string(ans)
}
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 为字符串的长度。一共需要两次遍历，第一次遍历字符串求得目标字符串，第二次遍历需要将目标字符串进行反转。

- 空间复杂度：$O(1)$ 或 $O(N)$，其中 $N$ 为字符串的长度。这里的空间复杂度统计的是存储返回值以外的空间。如果使用的语言可以修改字符串，那么反转前后的字符串可以存储在同一片区域，空间复杂度为 $O(1)$；如果不可以修改，那么反转前的字符串需要额外的空间进行存储，空间复杂度为 $O(N)$。
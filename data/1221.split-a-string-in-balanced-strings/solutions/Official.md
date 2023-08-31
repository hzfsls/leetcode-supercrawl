## [1221.分割平衡字符串 中文官方题解](https://leetcode.cn/problems/split-a-string-in-balanced-strings/solutions/100000/fen-ge-ping-heng-zi-fu-chuan-by-leetcode-7y8u)
#### 方法一：贪心

根据题意，对于一个平衡字符串 $s$，若 $s$ 能从中间某处分割成左右两个子串，若其中一个是平衡字符串，则另一个的 $\texttt{L}$ 和 $\texttt{R}$ 字符的数量必然是相同的，所以也一定是平衡字符串。

为了最大化分割数量，我们可以不断循环，每次从 $s$ 中分割出一个最短的平衡前缀，由于剩余部分也是平衡字符串，我们可以将其当作 $s$ 继续分割，直至 $s$ 为空时，结束循环。

代码实现中，可以在遍历 $s$ 时用一个变量 $d$ 维护 $\texttt{L}$ 和 $\texttt{R}$ 字符的数量之差，当 $d=0$ 时就说明找到了一个平衡字符串，将答案加一。

```C++ [sol1-C++]
class Solution {
public:
    int balancedStringSplit(string s) {
        int ans = 0, d = 0;
        for (char ch : s) {
            ch == 'L' ? ++d : --d;
            if (d == 0) {
                ++ans;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int balancedStringSplit(String s) {
        int ans = 0, d = 0;
        for (int i = 0; i < s.length(); ++i) {
            char ch = s.charAt(i);
            if (ch == 'L') {
                ++d;
            } else {
                --d;
            }
            if (d == 0) {
                ++ans;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int BalancedStringSplit(string s) {
        int ans = 0, d = 0;
        foreach (char ch in s) {
            if (ch == 'L') {
                ++d;
            } else {
                --d;
            }
            if (d == 0) {
                ++ans;
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def balancedStringSplit(self, s: str) -> int:
        ans, d = 0, 0
        for ch in s:
            if ch == 'L':
                d += 1
            else:
                d -= 1
            if d == 0:
                ans += 1
        return ans
```

```go [sol1-Golang]
func balancedStringSplit(s string) (ans int) {
    d := 0
    for _, ch := range s {
        if ch == 'L' {
            d++
        } else {
            d--
        }
        if d == 0 {
            ans++
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var balancedStringSplit = function(s) {
    let ans = 0, d = 0;
    for (let i = 0; i < s.length; ++i) {
        const ch = s[i];
        if (ch === 'L') {
            ++d;
        } else {
            --d;
        }
        if (d === 0) {
            ++ans;
        }
    }
    return ans;
};
```

```C [sol1-C]
int balancedStringSplit(char* s) {
    int ans = 0, d = 0;
    for (int i = 0; s[i]; i++) {
        s[i] == 'L' ? ++d : --d;
        if (d == 0) {
            ++ans;
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。我们仅需遍历 $s$ 一次。

- 空间复杂度：$O(1)$。只需要常数的空间存放若干变量。
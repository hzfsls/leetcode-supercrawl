## [1446.连续字符 中文官方题解](https://leetcode.cn/problems/consecutive-characters/solutions/100000/lian-xu-zi-fu-by-leetcode-solution-lctm)
#### 方法一：一次遍历

题目中的「只包含一种字符的最长非空子字符串的长度」，即为某个字符连续出现次数的最大值。据此可以设计如下算法来求解：

初始化当前字符连续出现次数 $\textit{cnt}$ 为 $1$。

从 $s[1]$ 开始，向后遍历字符串，如果 $s[i]=s[i-1]$，则将 $\textit{cnt}$ 加一，否则将 $\textit{cnt}$ 重置为 $1$。

维护上述过程中 $\textit{cnt}$ 的最大值，即为答案。

```Python [sol1-Python3]
class Solution:
    def maxPower(self, s: str) -> int:
        ans, cnt = 1, 1
        for i in range(1, len(s)):
            if s[i] == s[i - 1]:
                cnt += 1
                ans = max(ans, cnt)
            else:
                cnt = 1
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int maxPower(string s) {
        int ans = 1, cnt = 1;
        for (int i = 1; i < s.length(); ++i) {
            if (s[i] == s[i - 1]) {
                ++cnt;
                ans = max(ans, cnt);
            } else {
                cnt = 1;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxPower(String s) {
        int ans = 1, cnt = 1;
        for (int i = 1; i < s.length(); ++i) {
            if (s.charAt(i) == s.charAt(i - 1)) {
                ++cnt;
                ans = Math.max(ans, cnt);
            } else {
                cnt = 1;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxPower(string s) {
        int ans = 1, cnt = 1;
        for (int i = 1; i < s.Length; ++i) {
            if (s[i] == s[i - 1]) {
                ++cnt;
                ans = Math.Max(ans, cnt);
            } else {
                cnt = 1;
            }
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func maxPower(s string) int {
    ans, cnt := 1, 1
    for i := 1; i < len(s); i++ {
        if s[i] == s[i-1] {
            cnt++
            if cnt > ans {
                ans = cnt
            }
        } else {
            cnt = 1
        }
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var maxPower = function(s) {
    let ans = 1, cnt = 1;
    for (let i = 1; i < s.length; ++i) {
        if (s[i] == s[i - 1]) {
            ++cnt;
            ans = Math.max(ans, cnt);
        } else {
            cnt = 1;
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。遍历一次 $s$ 的时间复杂度为 $O(n)$。

- 空间复杂度：$O(1)$。我们只需要常数的空间保存若干变量。
## [1624.两个相同字符之间的最长子字符串 中文官方题解](https://leetcode.cn/problems/largest-substring-between-two-equal-characters/solutions/100000/liang-ge-xiang-tong-zi-fu-zhi-jian-de-zu-9n2l)
#### 方法一：直接遍历

题目要求求出两个相同字符之间的最长子字符串的长度。对于字符 $\textit{ch}$，只需要求出 $\textit{ch}$ 第一次出现在字符串中的索引位置 $\textit{first}$ 和最后一次出现在字符串中的索引位置 $\textit{last}$，则以 $\textit{ch}$ 为相同字符之间的子字符串的最大长度一定为 $\textit{last} - \textit{first} - 1$，我们依次求出所有可能的子字符的长度的最大值即可。我们设数组 $\textit{firstIndex}$ 记录每个字符 $i$ 在字符串中第一次出现的索引，$\textit{maxLength}$ 表示当前子字符串的最大长度。
+ 初始化时 $\textit{firstIndex}$ 中的每个元素都初始化为 $-1$，表示该字符还未出现。
+ 当遍历到第 $i$ 个字符 $\textit{ch}$ 时，如果当前数组中 $\textit{firstIndex}[\textit{ch}] = -1$，则记录该字符第一次出现的索引为 $i$，更新 $\textit{firstIndex}[\textit{ch}] = i$；如果当前数组中 $\textit{firstIndex}[\textit{ch}] \ge 0$ 时，则表示字符 $\textit{ch}$ 之前已经出现过，此时两个 $\textit{ch}$ 之间的子字符串长度为 $i - \textit{firstIndex}[\textit{ch}] - 1$，同时更新 $\textit{maxLength}$。
+ 返回最大的长度 $\textit{maxLength}$ 即可。

```Python [sol1-Python3]
class Solution:
    def maxLengthBetweenEqualCharacters(self, s: str) -> int:
        ans = -1
        firstIndex = {}
        for i, c in enumerate(s):
            if c not in firstIndex:
                firstIndex[c] = i
            else:
                ans = max(ans, i - firstIndex[c] - 1)
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int maxLengthBetweenEqualCharacters(string s) {
        vector<int> firstIndex(26, -1);
        int maxLength = -1;
        for (int i = 0; i < s.size(); i++) {
            if (firstIndex[s[i] - 'a'] < 0) {
                firstIndex[s[i] - 'a'] = i;
            } else {
                maxLength = max(maxLength, i - firstIndex[s[i] - 'a'] - 1);
            }
        }
        return maxLength;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxLengthBetweenEqualCharacters(String s) {
        int[] firstIndex = new int[26];
        Arrays.fill(firstIndex, -1);
        int maxLength = -1;
        for (int i = 0; i < s.length(); i++) {
            if (firstIndex[s.charAt(i) - 'a'] < 0) {
                firstIndex[s.charAt(i) - 'a'] = i;
            } else {
                maxLength = Math.max(maxLength, i - firstIndex[s.charAt(i) - 'a'] - 1);
            }
        }
        return maxLength;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxLengthBetweenEqualCharacters(string s) {
        int[] firstIndex = new int[26];
        Array.Fill(firstIndex, -1);
        int maxLength = -1;
        for (int i = 0; i < s.Length; i++) {
            if (firstIndex[s[i] - 'a'] < 0) {
                firstIndex[s[i] - 'a'] = i;
            } else {
                maxLength = Math.Max(maxLength, i - firstIndex[s[i] - 'a'] - 1);
            }
        }
        return maxLength;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int maxLengthBetweenEqualCharacters(char * s){
    int maxLength = -1;
    int firstIndex[26];
    int len = strlen(s);
    memset(firstIndex, -1, sizeof(firstIndex));
    for (int i = 0; i < len; i++) {
        if (firstIndex[s[i] - 'a'] < 0) {
            firstIndex[s[i] - 'a'] = i;
        } else {
            maxLength = MAX(maxLength, i - firstIndex[s[i] - 'a'] - 1);
        }
    }
    return maxLength;
}
```

```JavaScript [sol1-JavaScript]
var maxLengthBetweenEqualCharacters = function(s) {
    const firstIndex = new Array(26).fill(-1);
    let maxLength = -1;
    for (let i = 0; i < s.length; i++) {
        if (firstIndex[s[i].charCodeAt() - 'a'.charCodeAt()] < 0) {
            firstIndex[s[i].charCodeAt() - 'a'.charCodeAt()] = i;
        } else {
            maxLength = Math.max(maxLength, i - firstIndex[s[i].charCodeAt() - 'a'.charCodeAt()] - 1);
        }
    }
    return maxLength;
};
```

```go [sol1-Golang]
func maxLengthBetweenEqualCharacters(s string) int {
    ans := -1
    firstIndex := [26]int{}
    for i := range firstIndex {
        firstIndex[i] = -1
    }
    for i, c := range s {
        c -= 'a'
        if firstIndex[c] < 0 {
            firstIndex[c] = i
        } else {
            ans = max(ans, i-firstIndex[c]-1)
        }
    }
    return ans
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 表示字符串的长度。我们只需遍历一遍字符串即可。

- 空间复杂度：$O(|\Sigma|)$，其中 $\Sigma$ 是字符集，在本题中字符集为所有小写字母，$|\Sigma|=26$。
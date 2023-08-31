## [521.最长特殊序列 Ⅰ 中文官方题解](https://leetcode.cn/problems/longest-uncommon-subsequence-i/solutions/100000/zui-chang-te-shu-xu-lie-i-by-leetcode-so-v9sr)

#### 方法一：脑筋急转弯

字符串的子序列的长度不会超过该字符串的长度。若子序列的长度等于字符串的长度，那么子序列就是该字符串。

若两字符串不相同，那么我们可以选择较长的字符串作为最长特殊序列，显然它不会是较短的字符串的子序列。特别地，当两字符串长度相同时（但不是同一字符串），我们仍然可以选择其中的一个字符串作为最长特殊序列，它不会是另一个字符串的子序列。

若两字符串相同，那么任一字符串的子序列均会出现在两个字符串中，此时应返回 $-1$。

```Python [sol1-Python3]
class Solution:
    def findLUSlength(self, a: str, b: str) -> int:
        return max(len(a), len(b)) if a != b else -1
```

```C++ [sol1-C++]
class Solution {
public:
    int findLUSlength(string a, string b) {
        return a != b ? max(a.length(), b.length()) : -1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int findLUSlength(String a, String b) {
        return !a.equals(b) ? Math.max(a.length(), b.length()) : -1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindLUSlength(string a, string b) {
        return !a.Equals(b) ? Math.Max(a.Length, b.Length) : -1;
    }
}
```

```go [sol1-Golang]
func findLUSlength(a, b string) int {
    if a != b {
        return max(len(a), len(b))
    }
    return -1
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int findLUSlength(char * a, char * b) {
    int lena = strlen(a);
    int lenb = strlen(b);
    return strcmp(a, b) != 0 ? MAX(lena, lenb) : -1;
    
}
```

```JavaScript [sol1-JavaScript]
var findLUSlength = function(a, b) {
    return a !== b ? Math.max(a.length, b.length) : -1;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $a$ 的长度。当两字符串长度不同时，时间复杂度为 $O(1)$；当字符串长度相同时，时间复杂度为 $O(n)$。因此时间复杂度为 $O(n)$。

- 空间复杂度：$O(1)$。
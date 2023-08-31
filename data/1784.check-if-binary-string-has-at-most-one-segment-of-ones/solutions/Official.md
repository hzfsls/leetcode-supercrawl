## [1784.检查二进制字符串字段 中文官方题解](https://leetcode.cn/problems/check-if-binary-string-has-at-most-one-segment-of-ones/solutions/100000/jian-cha-er-jin-zhi-zi-fu-chuan-zi-duan-b1phi)

#### 方法一：寻找 $01$ 串

**思路与算法**

题目给定一个长度为 $n$ 的二进制字符串 $s$，并满足该字符串不含前导零。现在我们需要判断字符串中是否只包含零个或一个由连续 $1$ 组成的字段。首先我们依次分析这两种情况：

- 字符串 $s$ 中包含零个由连续 $1$ 组成的字段，那么整个串的表示为 $00 \cdots 00$。
- 字符串 $s$ 中只包含一个由连续 $1$ 组成的字段，因为已知字符串 $s$ 不包含前导零，所以整个串的表示为 $1 \cdots 100 \cdots 00$。

那么可以看到两种情况中都不包含 $01$ 串。且不包含的 $01$ 串的一个二进制字符串也有且仅有上面两种情况。所以我们可以通过原字符串中是否有 $01$ 串来判断字符串中是否只包含零个或一个由连续 $1$ 组成的字段。如果有 $01$ 串则说明该情况不满足，否则即满足该情况条件。

**代码**

```Python [sol1-Python3]
class Solution:
    def checkOnesSegment(self, s: str) -> bool:
        return "01" not in s
```

```Java [sol1-Java]
class Solution {
    public boolean checkOnesSegment(String s) {
        return !s.contains("01");
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool CheckOnesSegment(string s) {
        return !s.Contains("01");
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool checkOnesSegment(string s) {
        return s.find("01") == string::npos;
    }
};
```

```C [sol1-C]
bool checkOnesSegment(char * s){
    return strstr(s, "01") == NULL;
}
```

```JavaScript [sol1-JavaScript]
var checkOnesSegment = function(s) {
    return s.indexOf('01') === -1;
};
```

```go [sol1-Golang]
func checkOnesSegment(s string) bool {
	return !strings.Contains(s, "01")
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串 $s$ 的长度。
- 空间复杂度：$O(1)$，仅适用常量空间。
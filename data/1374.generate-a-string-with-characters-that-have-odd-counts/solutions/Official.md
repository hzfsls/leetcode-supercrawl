## [1374.生成每种字符都是奇数个的字符串 中文官方题解](https://leetcode.cn/problems/generate-a-string-with-characters-that-have-odd-counts/solutions/100000/sheng-cheng-mei-chong-zi-fu-du-shi-qi-sh-c2yf)
#### 方法一：分类讨论

**思路与算法**

当 $n$ 为奇数时，我们返回 $n$ 个 $\texttt{`a'}$ 组成的字符串。

当 $n$ 为偶数时，我们返回 $n-1$ 个 $\texttt{`a'}$ 和一个 $\texttt{`b'}$ 组成的字符串。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string generateTheString(int n) {
        if (n % 2 == 1) {
            return string(n, 'a');
        }
        return string(n - 1, 'a') + 'b';
    }
};
```

```Java [sol1-Java]
class Solution {
    public String generateTheString(int n) {
        StringBuffer sb = new StringBuffer();
        if (n % 2 == 1) {
            return sb.append("a".repeat(n)).toString();
        }
        return sb.append("a".repeat(n - 1)).append("b").toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string GenerateTheString(int n) {
        StringBuilder sb = new StringBuilder();
        if (n % 2 == 1) {
            return new string('a', n);
        }
        return new string('a', n - 1) + "b";
    }
}
```

```Python [sol1-Python3]
class Solution:
    def generateTheString(self, n: int) -> str:
        if n % 2 == 1:
            return "a" * n
        return "a" * (n - 1) + "b"
```

```C [sol1-C]
char * generateTheString(int n) {
    char * ans = (char *)malloc(sizeof(char) * (n + 1));
    memset(ans, 'a', sizeof(char) * n);
    ans[n] = '\0';
    if (n % 2 == 1) {
        return ans;
    }
    ans[n - 1] = 'b';
    return ans;
}
```

```go [sol1-Golang]
func generateTheString(n int) string {
    if n%2 == 1 {
        return strings.Repeat("a", n)
    }
    return strings.Repeat("a", n-1) + "b"
}
```

```JavaScript [sol1-JavaScript]
var generateTheString = function(n) {
    const sb = '';
    if (n % 2 === 1) {
        return sb + 'a'.repeat(n);;
    }
    return sb + 'a'.repeat(n - 1) + 'b';
};
```

**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：$O(1)$。这里不计入返回值需要的空间。
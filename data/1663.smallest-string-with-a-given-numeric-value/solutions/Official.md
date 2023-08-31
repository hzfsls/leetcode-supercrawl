## [1663.具有给定数值的最小字符串 中文官方题解](https://leetcode.cn/problems/smallest-string-with-a-given-numeric-value/solutions/100000/ju-you-gei-ding-shu-zhi-de-zui-xiao-zi-f-e0e4)

#### 方法一：贪心

**思路与算法**

题目要求构造长度为 $n$ 的字符串且字符的数值之和为 $k$。要使得构造出的字符串字典序最小，可以贪心地从字符串左边起始位置开始构造，每次选择一个满足要求的最小字母，即可得到答案。
当然我们每次应尽量选择最小的字母 $\text{`a'}$，但这样可能导致构造出的数值之和小于 $n$，如何选择每次选择最小的字母才能满足构造的数字之和满足要求，分析如下：
+ 假设我们当前需要构造第 $i$ 个位置的字符 $c$，此时还剩下 $n-i$ 个位置的字符需要构造，这些字符的数值之和为 $k^{'}$，剩余的 $n-i$ 个位置的字符最大为 $\text{`z'}$，剩余的 $n-i$ 个位置的字符最小为 $\text{`a'}$，则此时可以知：
$$n - i \le k^{'} - c \le (n - i) \times 26$$
将上述不等式进行转换可得：
$$k^{'} - (n - i) \times 26 \le c \le k - (n - i)$$

由于 $c$ 最小取值为 $1$，我们可以得到 $c$ 的合法取值范围为 $[\max(1,k^{'} - (n - i) \times 26), k - (n - i)]$，按照贪心原则我们可以取 $c$ 的下限为 $\max(1, k^{'} - (n - i) \times 26)$，因此第 $i$ 个字符的最优取值如下:
+ 如果满足 $k^{'} - (n - i) \times 26 \le 0$ 时，此时选择字符 $\text{`a'}$；
+ 如果满足 $k^{'} - (n - i) \times 26 > 0$ 时，此时选择数值对应的字符即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def getSmallestString(self, n: int, k: int) -> str:
        s = []
        for i in range(1, n + 1):
            lower = max(1, k - (n - i) * 26)
            k -= lower
            s.append(ascii_lowercase[lower - 1])
        return ''.join(s)
```

```C++ [sol1-C++]
class Solution {
public:
    string getSmallestString(int n, int k) {
        string ans;
        for (int i = 1; i <= n; i++) {
            int lower = max(1, k - (n - i) * 26);
            k -= lower;
            ans.push_back('a' + lower - 1);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String getSmallestString(int n, int k) {
        StringBuilder ans = new StringBuilder();
        for (int i = 1; i <= n; i++) {
            int lower = Math.max(1, k - (n - i) * 26);
            k -= lower;
            ans.append((char) ('a' + lower - 1));
        }
        return ans.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string GetSmallestString(int n, int k) {
        StringBuilder ans = new StringBuilder();
        for (int i = 1; i <= n; i++) {
            int lower = Math.Max(1, k - (n - i) * 26);
            k -= lower;
            ans.Append((char) ('a' + lower - 1));
        }
        return ans.ToString();
    }
}
```

```C [sol1-C]
static inline int max(int a, int b) {
    return a > b ? a : b;
}

char * getSmallestString(int n, int k) {
    char *ans = (char *)malloc(sizeof(char) * (n + 1));
    for (int i = 1; i <= n; i++) {
        int lower = max(1, k - (n - i) * 26);
        k -= lower;
        ans[i - 1] = 'a' + lower - 1;
    }
    ans[n] = '\0';
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var getSmallestString = function(n, k) {
    let ans = '';
    for (let i = 1; i <= n; i++) {
        const lower = Math.max(1, k - (n - i) * 26);
        k -= lower;
        ans += String.fromCharCode('a'.charCodeAt() + lower - 1);
    }
    return ans;
};
```

```go [sol1-Golang]
func getSmallestString(n, k int) string {
    s := []byte{}
    for i := 1; i <= n; i++ {
        lower := max(1, k-(n-i)*26)
        k -= lower
        s = append(s, 'a'+byte(lower)-1)
    }
    return string(s)
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 表示给定的数字 $n$。我们只需依次构造 $n$ 个字符即可。

- 空间复杂度：$O(1)$。除返回值外不需要额外的空间。
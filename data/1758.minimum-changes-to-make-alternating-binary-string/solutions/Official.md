## [1758.生成交替二进制字符串的最少操作数 中文官方题解](https://leetcode.cn/problems/minimum-changes-to-make-alternating-binary-string/solutions/100000/sheng-cheng-jiao-ti-er-jin-zhi-zi-fu-chu-91c5)

#### 方法一：模拟

**思路**

根据题意，经过多次操作，$s$ 可能会变成两种不同的交替二进制字符串，即：

- 开头为 $0$，后续交替的字符串；
- 开头为 $1$，后续交替的字符串。

注意到，变成这两种不同的交替二进制字符串所需要的最少操作数加起来等于 $s$ 的长度，我们只需要计算出变为其中一种字符串的最少操作数，就可以推出另一个最少操作数，然后取最小值即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def minOperations(self, s: str) -> int:
        cnt = sum(int(c) != i % 2 for i, c in enumerate(s))
        return min(cnt, len(s) - cnt)
```

```Java [sol1-Java]
class Solution {
    public int minOperations(String s) {
        int cnt = 0;
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c != (char) ('0' + i % 2)) {
                cnt++;
            }
        }
        return Math.min(cnt, s.length() - cnt);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinOperations(string s) {
        int cnt = 0;
        for (int i = 0; i < s.Length; i++) {
            char c = s[i];
            if (c != (char) ('0' + i % 2)) {
                cnt++;
            }
        }
        return Math.Min(cnt, s.Length - cnt);
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minOperations(string s) {
        int cnt = 0;
        for (int i = 0; i < s.size(); i++) {
            char c = s[i];
            if (c != ('0' + i % 2)) {
                cnt++;
            }
        }
        return min(cnt, (int)s.size() - cnt);
    }
};
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int minOperations(char * s) {
    int cnt = 0, len = strlen(s);
    for (int i = 0; i < len; i++) {
        char c = s[i];
        if (c != ('0' + i % 2)) {
            cnt++;
        }
    }
    return MIN(cnt, len - cnt);
}
```

```JavaScript [sol1-JavaScript]
var minOperations = function(s) {
    let cnt = 0;
    for (let i = 0; i < s.length; i++) {
        const c = s[i];
        if (c !== (String.fromCharCode('0'.charCodeAt() + i % 2))) {
            cnt++;
        }
    }
    return Math.min(cnt, s.length - cnt);
};
```

```go [sol1-Golang]
func minOperations(s string) int {
    cnt := 0
    for i, c := range s {
        if i%2 != int(c-'0') {
            cnt++
        }
    }
    return min(cnt, len(s)-cnt)
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为输入 $s$ 的长度，仅需遍历一遍字符串。

- 空间复杂度：$O(1)$，只需要常数额外空间。
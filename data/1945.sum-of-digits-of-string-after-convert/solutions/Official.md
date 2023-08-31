## [1945.字符串转化后的各位数字之和 中文官方题解](https://leetcode.cn/problems/sum-of-digits-of-string-after-convert/solutions/100000/zi-fu-chuan-zhuan-hua-hou-de-ge-wei-shu-bhdx4)

#### 方法一：模拟

**思路与算法**

我们根据题目的要求模拟即可。

在第一次操作前，我们根据给定的字符串 $s$，得到对应的数字串 $\textit{digits}$。

随后我们进行 $k$ 次操作，每次操作将 $\textit{digits}$ 的每个数位进行累加，得到新的数字串。

注意到当 $\textit{digits}$ 的长度为 $1$ 时，后续的操作都不会改变结果。此时可以提前退出循环并返回答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int getLucky(string s, int k) {
        string digits;
        for (char ch: s) {
            digits += to_string(ch - 'a' + 1);
        }

        for (int i = 1; i <= k && digits.size() > 1; ++i) {
            int sum = 0;
            for (char ch: digits) {
                sum += ch - '0';
            }
            digits = to_string(sum);
        }

        return stoi(digits);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int getLucky(String s, int k) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < s.length(); ++i) {
            char ch = s.charAt(i);
            sb.append(ch - 'a' + 1);
        }
        String digits = sb.toString();
        for (int i = 1; i <= k && digits.length() > 1; ++i) {
            int sum = 0;
            for (int j = 0; j < digits.length(); ++j) {
                char ch = digits.charAt(j);
                sum += ch - '0';
            }
            digits = Integer.toString(sum);
        }

        return Integer.parseInt(digits);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int GetLucky(string s, int k) {
        StringBuilder sb = new StringBuilder();
        foreach (char ch in s) {
            sb.Append(ch - 'a' + 1);
        }
        string digits = sb.ToString();
        for (int i = 1; i <= k && digits.Length > 1; ++i) {
            int sum = 0;
            foreach (char ch in digits) {
                sum += ch - '0';
            }
            digits = sum.ToString();
        }

        return int.Parse(digits);
    }
}
```

```Python [sol1-Python3]
class Solution:
    def getLucky(self, s: str, k: int) -> int:
        digits = "".join(str(ord(ch) - ord("a") + 1) for ch in s)

        for i in range(k):
            if len(digits) == 1:
                break
            total = sum(int(ch) for ch in digits)
            digits = str(total)
        
        return int(digits)
```

```C [sol1-C]
int getLucky(char * s, int k) {
    int n = strlen(s);
    char digits[n * 2 + 1];
    int pos = 0;
    for (int i = 0; i < n; i++) {
        pos += sprintf(digits + pos, "%d", s[i] - 'a' + 1);
    }
    int len = pos;
    for (int i = 1; i <= k && len > 1; ++i) {
        int sum = 0;
        for (int j = 0; j < len; j++) {
            sum += digits[j] - '0';
        }
        len = sprintf(digits, "%d", sum);
    }
    return atoi(digits);
}
```

```go [sol1-Golang]
func getLucky(s string, k int) int {
    t := []byte{}
    for _, c := range s {
        t = append(t, strconv.Itoa(int(c-'a'+1))...)
    }
    digits := string(t)
    for i := 1; i <= k && len(digits) > 1; i++ {
        sum := 0
        for _, c := range digits {
            sum += int(c - '0')
        }
        digits = strconv.Itoa(sum)
    }
    ans, _ := strconv.Atoi(digits)
    return ans
}
```

```JavaScript [sol1-JavaScript]
var getLucky = function(s, k) {
    let sb = '';
    for (let i = 0; i < s.length; ++i) {
        const ch = s[i];
        sb += '' + ch.charCodeAt() - 'a'.charCodeAt() + 1;
    }
    let digits = sb.toString();
    for (let i = 1; i <= k && digits.length > 1; ++i) {
        let sum = 0;
        for (let j = 0; j < digits.length; ++j) {
            const ch = digits[j];
            sum += ch.charCodeAt()- '0'.charCodeAt();
        }
        digits = '' + sum;
    }

    return 0 + digits;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。构造第一次操作前的字符串需要 $O(n)$ 的时间。由于 $n \leq 100$，在最坏情况下：

    - 字符串 $s$ 由 $100$ 个字母 $\text{`s'}$ 组成，对应数字 $19$，第一次操作后得到的数为 $(1+9) \times 100 = 1000$；

    - 由上一步可知，第一次操作后得到的数在 $[1, 1000]$ 之间，其中数字和最大的为 $999$，说明第二次操作后得到的数最大为 $9+9+9=27$；

    - 由上一步可知，第二次操作后得到的数在 $[1, 27]$ 之间，其中数字和最大的为 $19$，说明第三次操作后得到的数最大为 $1+9=10$；

    - 由上一步可知，第三次操作后得到的数在 $[1, 10]$ 之间，其中数字和最大的为 $9$，说明第四次操作后，一定会得到一位数的结果。

    因此，循环最多会执行 $4$ 次，除了第一次循环以外，剩余循环需要处理的数字串的长度远小于 $n$（以 $\sim 9 \log_{10} n$ 的趋势递减），因此这一部分的时间复杂度可以看成 $O(n)$，总时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$，即为存储数字串需要的空间。我们也可以将空间复杂度优化至 $O(\log n)$，这是因为 $k \geq 1$，因此在遍历字符串 $s$ 时，可以直接累加出第一次操作后的结果，这样得到的数字串长度为 $O(\log n)$。
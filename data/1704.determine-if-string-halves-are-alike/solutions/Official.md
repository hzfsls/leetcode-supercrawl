## [1704.判断字符串的两半是否相似 中文官方题解](https://leetcode.cn/problems/determine-if-string-halves-are-alike/solutions/100000/pan-duan-zi-fu-chuan-de-liang-ban-shi-fo-d21g)

#### 方法一：计数

**思路与算法**

题目给定一个偶数长度的字符串 $s$，并给出字符串「相似」的定义：若两个字符串中含有相同数目的元音字母，则这两个字符串「相似」。现在我们将给定字符串 $s$ 拆分成长度相同的两半，前一半表示为字符串 $a$，后一半为字符串 $b$，我们需要判断字符串 $a$ 和 $b$ 是否「相似」，那么我们只需要按照「相似」的定义统计字符串 $a$ 和 $b$ 中的元音字母的个数是否相等即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def halvesAreAlike(self, s: str) -> bool:
        VOWELS = "aeiouAEIOU"
        a, b = s[:len(s) // 2], s[len(s) // 2:]
        return sum(c in VOWELS for c in a) == sum(c in VOWELS for c in b)
```

```Java [sol1-Java]
class Solution {
    public boolean halvesAreAlike(String s) {
        String a = s.substring(0, s.length() / 2);
        String b = s.substring(s.length() / 2);
        String h = "aeiouAEIOU";
        int sum1 = 0, sum2 = 0;
        for (int i = 0; i < a.length(); i++) {
            if (h.indexOf(a.charAt(i)) >= 0) {
                sum1++;
            }
        }
        for (int i = 0; i < b.length(); i++) {
            if (h.indexOf(b.charAt(i)) >= 0) {
                sum2++;
            }
        }
        return sum1 == sum2;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool HalvesAreAlike(string s) {
        string a = s.Substring(0, s.Length / 2);
        string b = s.Substring(s.Length / 2);
        string h = "aeiouAEIOU";
        int sum1 = 0, sum2 = 0;
        foreach (char c in a) {
            if (h.IndexOf(c) >= 0) {
                sum1++;
            }
        }
        foreach (char c in b) {
            if (h.IndexOf(c) >= 0) {
                sum2++;
            }
        }
        return sum1 == sum2;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool halvesAreAlike(string s) {
        string a = s.substr(0, s.size() / 2);
        string b = s.substr(s.size() / 2);
        string h = "aeiouAEIOU";
        int sum1 = 0, sum2 = 0;
        for (int i = 0; i < a.size(); i++) {
            if (h.find_first_of(a[i]) != string::npos) {
                sum1++;
            }
        }
        for (int i = 0; i < b.size(); i++) {
            if (h.find_first_of(b[i]) != string::npos) {
                sum2++;
            }
        }
        return sum1 == sum2;
    }
};
```

```C [sol1-C]
bool halvesAreAlike(char * s) {
    int len = strlen(s);
    char *h = "aeiouAEIOU";
    int sum1 = 0, sum2 = 0;
    for (int i = 0; i < len / 2; i++) {
        if (strchr(h, s[i])) {
            sum1++;
        }
    }
    for (int i = len / 2 ; i < len; i++) {
        if (strchr(h, s[i])) {
            sum2++;
        }
    }
    return sum1 == sum2;
}
```

```JavaScript [sol1-JavaScript]
var halvesAreAlike = function(s) {
    const a = s.substring(0, s.length / 2);
    const b = s.substring(s.length / 2);
    const h = "aeiouAEIOU";
    let sum1 = 0, sum2 = 0;
    for (let i = 0; i < a.length; i++) {
        if (h.indexOf(a[i]) >= 0) {
            sum1++;
        }
    }
    for (let i = 0; i < b.length; i++) {
        if (h.indexOf(b[i]) >= 0) {
            sum2++;
        }
    }
    return sum1 === sum2;
};
```

```go [sol1-Golang]
func halvesAreAlike(s string) bool {
    cnt := 0
    for _, c := range s[:len(s)/2] {
        if strings.ContainsRune("aeiouAEIOU", c) {
            cnt++
        }
    }
    for _, c := range s[len(s)/2:] {
        if strings.ContainsRune("aeiouAEIOU", c) {
            cnt--
        }
    }
    return cnt == 0
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串 $s$ 的长度。
- 空间复杂度：$O(n)$，其中 $n$ 为字符串 $s$ 的长度，主要为表示字符串 $a$, $b$ 的空间开销，也可以通过双指针在原字符串中遍历 $a$, $b$ 进行计数操作来实现 $O(1)$ 的空间开销。
## [1417.重新格式化字符串 中文官方题解](https://leetcode.cn/problems/reformat-the-string/solutions/100000/zhong-xin-ge-shi-hua-zi-fu-chuan-by-leet-lgqx)

#### 方法一：双指针

**思路与算法**

题目给定字符串 $s$，我们记 $\textit{sum\_digit}$ 为字符串中数字的个数，$\textit{sum\_alpha}$ 为字符串中字母的个数。那么能按照题目要求格式化字符串的充要条件为：

$$|\textit{sum\_digit} - \textit{sum\_alpha}| \le 1$$

那么当给定字符串 $s$ 满足上述条件时，我们把数字和字母中个数多的放在偶数位上（字符串下标从 $0$ 开始），个数少的放在奇数位上，此时可以构造出满足题目条件的字符串。那么我们用 $i$ 和 $j$ 来分别表示个数多的和个数少的字符放置的下标，初始为 $i = 0, j = 1$，然后从左到右移动 $i$，当 $s[i]$ 为个数少的字符类型时，那么向右移动 $j$ 找到往后的第一个 $s[j]$ 为个数多的字符类型，然后交换两个字符即可，不断重复该过程直至 $i$ 移动到字符串结尾即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def reformat(self, s: str) -> str:
        sumDigit = sum(c.isdigit() for c in s)
        sumAlpha = len(s) - sumDigit
        if abs(sumDigit - sumAlpha) > 1:
            return ""
        flag = sumDigit > sumAlpha
        t = list(s)
        j = 1
        for i in range(0, len(t), 2):
            if t[i].isdigit() != flag:
                while t[j].isdigit() != flag:
                    j += 2
                t[i], t[j] = t[j], t[i]
        return ''.join(t)
```

```C++ [sol1-C++]
class Solution {
public:
    string reformat(string s) {
        int sum_digit = 0;
        for (auto& c : s) {
            if (isdigit(c)) {
                sum_digit++;
            }
        }
        int sum_alpha = s.size() - sum_digit;
        if (abs(sum_digit - sum_alpha) > 1) {
            return "";
        }
        bool flag = sum_digit > sum_alpha;
        for (int i = 0, j = 1; i < s.size(); i += 2) {
            if (isdigit(s[i]) != flag) {
                while (isdigit(s[j]) != flag) {
                    j += 2;
                }
                swap(s[i], s[j]);
            }
        }
        return s;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String reformat(String s) {
        int sumDigit = 0;
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (Character.isDigit(c)) {
                sumDigit++;
            }
        }
        int sumAlpha = s.length() - sumDigit;
        if (Math.abs(sumDigit - sumAlpha) > 1) {
            return "";
        }
        boolean flag = sumDigit > sumAlpha;
        char[] arr = s.toCharArray();
        for (int i = 0, j = 1; i < s.length(); i += 2) {
            if (Character.isDigit(arr[i]) != flag) {
                while (Character.isDigit(arr[j]) != flag) {
                    j += 2;
                }
                swap(arr, i, j);
            }
        }
        return new String(arr);
    }

    public void swap(char[] arr, int i, int j) {
        char c = arr[i];
        arr[i] = arr[j];
        arr[j] = c;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string Reformat(string s) {
        int sumDigit = 0;
        foreach (char c in s) {
            if (char.IsDigit(c)) {
                sumDigit++;
            }
        }
        int sumAlpha = s.Length - sumDigit;
        if (Math.Abs(sumDigit - sumAlpha) > 1) {
            return "";
        }
        bool flag = sumDigit > sumAlpha;
        char[] arr = s.ToCharArray();
        for (int i = 0, j = 1; i < s.Length; i += 2) {
            if (char.IsDigit(arr[i]) != flag) {
                while (char.IsDigit(arr[j]) != flag) {
                    j += 2;
                }
                Swap(arr, i, j);
            }
        }
        return new String(arr);
    }

    public void Swap(char[] arr, int i, int j) {
        char c = arr[i];
        arr[i] = arr[j];
        arr[j] = c;
    }
}
```

```C [sol1-C]
char * reformat(char * s){
    int sum_digit = 0;
    int len = strlen(s);
    for (int i = 0; i < len; i++) {
        char c = s[i];
        if (isdigit(c)) {
            sum_digit++;
        }
    }
    int sum_alpha = len - sum_digit;
    if (abs(sum_digit - sum_alpha) > 1) {
        return "";
    }
    bool flag = sum_digit > sum_alpha;
    for (int i = 0, j = 1; i < len; i += 2) {
        if ((isdigit(s[i]) != 0) != flag) {
            while ((isdigit(s[j]) != 0) != flag) {
                j += 2;
            }
            char c = s[i];
            s[i] = s[j];
            s[j] = c;
        }
    }
    return s;
}
```

```go [sol1-Golang]
func reformat(s string) string {
    sumDigit := 0
    for _, c := range s {
        if unicode.IsDigit(c) {
            sumDigit++
        }
    }
    sumAlpha := len(s) - sumDigit
    if abs(sumDigit-sumAlpha) > 1 {
        return ""
    }
    flag := sumDigit > sumAlpha
    t := []byte(s)
    for i, j := 0, 1; i < len(t); i += 2 {
        if unicode.IsDigit(rune(t[i])) != flag {
            for unicode.IsDigit(rune(t[j])) != flag {
                j += 2
            }
            t[i], t[j] = t[j], t[i]
        }
    }
    return string(t)
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

```JavaScript [sol1-JavaScript]
var reformat = function(s) {
    let sumDigit = 0;
    for (let i = 0; i < s.length; i++) {
        const c = s[i];
        if (isDigit(c)) {
            sumDigit++;
        }
    }
    let sumAlpha = s.length - sumDigit;
    if (Math.abs(sumDigit - sumAlpha) > 1) {
        return "";
    }
    let flag = sumDigit > sumAlpha;
    const arr = [...s];
    for (let i = 0, j = 1; i < s.length; i += 2) {
        if (isDigit(arr[i]) !== flag) {
            while (isDigit(arr[j]) !== flag) {
                j += 2;
            }
            [arr[i], arr[j]] = [arr[j], arr[i]];
        }
    }
    return arr.join('');
}

const isDigit = (ch) => {
    return parseFloat(ch).toString() === "NaN" ? false : true;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串 $s$ 的长度，需要遍历两遍字符串。
- 空间复杂度：对于字符串可变的语言为 $O(1)$，仅使用常量空间。而对于字符串不可变的语言需要新建一个和 $s$ 等长的字符串，所以空间复杂度是 $O(n)$。
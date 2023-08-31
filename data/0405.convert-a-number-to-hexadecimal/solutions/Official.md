## [405.数字转换为十六进制数 中文官方题解](https://leetcode.cn/problems/convert-a-number-to-hexadecimal/solutions/100000/shu-zi-zhuan-huan-wei-shi-liu-jin-zhi-sh-2srt)
#### 方法一：位运算

题目要求将给定的整数 $\textit{num}$ 转换为十六进制数，负整数使用补码运算方法。

在补码运算中，最高位表示符号位，符号位是 $0$ 表示正整数和零，符号位是 $1$ 表示负整数。$32$ 位有符号整数的二进制数有 $32$ 位，由于一位十六进制数对应四位二进制数，因此 $32$ 位有符号整数的十六进制数有 $8$ 位。将 $\textit{num}$ 的二进制数按照四位一组分成 $8$ 组，依次将每一组转换为对应的十六进制数，即可得到 $\textit{num}$ 的十六进制数。

假设二进制数的 $8$ 组从低位到高位依次是第 $0$ 组到第 $7$ 组，则对于第 $i$ 组，可以通过 $(\textit{nums} >> (4 \times i))~\&~\text{0xf}$ 得到该组的值，其取值范围是 $0$ 到 $15$（即十六进制的 $\text{f}$）。将每一组的值转换为十六进制数的做法如下：

- 对于 $0$ 到 $9$，数字本身就是十六进制数；

- 对于 $10$ 到 $15$，将其转换为 $\text{a}$ 到 $\text{f}$ 中的对应字母。

对于负整数，由于最高位一定不是 $0$，因此不会出现前导零。对于零和正整数，可能出现前导零。避免前导零的做法如下：

- 如果 $\textit{num}=0$，则直接返回 $0$；

- 如果 $\textit{num}>0$，则在遍历每一组的值时，从第一个不是 $0$ 的值开始拼接成十六进制数。

```Java [sol1-Java]
class Solution {
    public String toHex(int num) {
        if (num == 0) {
            return "0";
        }
        StringBuffer sb = new StringBuffer();
        for (int i = 7; i >= 0; i --) {
            int val = (num >> (4 * i)) & 0xf;
            if (sb.length() > 0 || val > 0) {
                char digit = val < 10 ? (char) ('0' + val) : (char) ('a' + val - 10);
                sb.append(digit);
            }
        }
        return sb.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string ToHex(int num) {
        if (num == 0) {
            return "0";
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 7; i >= 0; i --) {
            int val = (num >> (4 * i)) & 0xf;
            if (sb.Length > 0 || val > 0) {
                char digit = val < 10 ? (char) ('0' + val) : (char) ('a' + val - 10);
                sb.Append(digit);
            }
        }
        return sb.ToString();
    }
}
```

```JavaScript [sol1-JavaScript]
var toHex = function(num) {
    if (num === 0) {
        return "0";
    }
    const sb = [];
    for (let i = 7; i >= 0; i --) {
        const val = (num >> (4 * i)) & 0xf;
        if (sb.length > 0 || val > 0) {
            const digit = val < 10 ? String.fromCharCode('0'.charCodeAt() + val) : String.fromCharCode('a'.charCodeAt() + val - 10);
            sb.push(digit);
        }
    }
    return sb.join('');
}
```

```C++ [sol1-C++]
class Solution {
public:
    string toHex(int num) {
        if (num == 0) {
            return "0";
        }
        string sb;
        for (int i = 7; i >= 0; i --) {
            int val = (num >> (4 * i)) & 0xf;
            if (sb.length() > 0 || val > 0) {
                char digit = val < 10 ? (char) ('0' + val) : (char) ('a' + val - 10);
                sb.push_back(digit);
            }
        }
        return sb;
    }
};
```

```go [sol1-Golang]
func toHex(num int) string {
    if num == 0 {
        return "0"
    }
    sb := &strings.Builder{}
    for i := 7; i >= 0; i-- {
        val := num >> (4 * i) & 0xf
        if val > 0 || sb.Len() > 0 {
            var digit byte
            if val < 10 {
                digit = '0' + byte(val)
            } else {
                digit = 'a' + byte(val-10)
            }
            sb.WriteByte(digit)
        }
    }
    return sb.String()
}
```

**复杂度分析**

- 时间复杂度：$O(k)$，其中 $k$ 是整数的十六进制数的位数，这道题中 $k=8$。无论 $\textit{num}$ 的值是多少，都需要遍历 $\textit{num}$ 的十六进制表示的全部数位。

- 空间复杂度：$O(k)$，其中 $k$ 是整数的十六进制数的位数，这道题中 $k=8$。空间复杂度主要取决于中间结果的存储空间，这道题中需要存储 $\textit{num}$ 的十六进制表示中的除了前导零以外的全部数位。
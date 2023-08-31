## [1017.负二进制转换 中文官方题解](https://leetcode.cn/problems/convert-to-base-2/solutions/100000/fu-er-jin-zhi-zhuan-huan-by-leetcode-sol-9qlh)
#### 方法一：模拟进位

**思路与算法**

对于「二进制数」我们可以很直观地得到以下结论：

+ 对于 $2^i$，如果 $i$ 为偶数时，此时 $2^i = (-2)^i$；
+ 对于 $2^i$，如果 $i$ 为奇数时，此时 $2^i = (-2)^{i+1} + (-2)^i$；

因此自然可以想到将 $n$ 转换为 $-2$ 的幂数和，即此时 $n = \sum\limits_{i=0}^{m}C_{i} \times (-2)^{i}$，由于 $-2$ 进制的每一位只能为 $0$ 或 $1$，需要对每一位进行加法「[进位](https://baike.baidu.com/item/%E8%BF%9B%E4%BD%8D/5989952?fr=aladdin)」运算即可得到完整的「负二进制」数。对于「负二进制」数，此时需要思考一下进位规则。对于 $C\times (-2)^i$，期望得到如下变换规则：
+ 如果 $C$ 为奇数则需要将等式变为 $C \times (-2)^i = a \times (-2)^{i + 1} + (-2)^{i}$，此时第 $i$ 位为 $1$，第 $i + 1$ 位需要加上 $a$；
+ 如果 $C$ 为偶数则需要将等式变为 $C \times (-2)^i = a \times (-2)^{i + 1}$，此时第 $i$ 位为 $0$，第 $i + 1$ 位需要加上 $a$；

根据以上的变换规则，只需要求出 $a$ 即可。假设当前数位上的数字为 $\textit{val}$，当前的位上保留的余数为 $r$，在 $x$ 进制下的进位为 $a$，根据「[进位](https://baike.baidu.com/item/%E8%BF%9B%E4%BD%8D/5989952?fr=aladdin)」的运算规则可知 $\textit{val} = a \times x + r$，此时可以得到进位 $a = \dfrac{\textit{val}-r}{x}$。根据题意可知，「负二进制」数的每一位上保留的余数为 $0$ 或 $1$，因此可以计算出当前的余数 $r$，由于在有符号整数的均采用补码表示，最低位的奇偶性保持不变，因此可以直接取 $\textit{val}$ 的最低位即可，此时可以得到 $r = \textit{val} \And 1$。根据上述等式可以知道，当前数位上的数字为 $\textit{val}$ 时，此时在「负二进制」下向高位的进位为 $\textit{a} = \dfrac{\textit{val}-(\textit{val} \And 1)}{-2}$。
基于以上进位规则，将变换出来的数列进行进位运算即可得到完整的「负二进制」数。整个转换过程如下：
+ 将 $n$ 转换为二进制数，并将二进制数中的每一位转换为「负二进制」中的每一位，变换后的数列为 $\textit{bits}$；
+ 将 $\textit{bits}$ 从低位向高位进行「[进位](https://baike.baidu.com/item/%E8%BF%9B%E4%BD%8D/5989952?fr=aladdin)」运算，即将 $\textit{bits}$ 中的每一位都变为 $0$ 或者 $1$；
+ 去掉前导 $0$ 以后，将 $\textit{bits}$ 转换为字符串返回即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string baseNeg2(int n) {
        if (n == 0) {
            return "0";
        }
        vector<int> bits(32);
        for (int i = 0; i < 32 && n != 0; i++) {
            if (n & 1) {
                bits[i]++;
                if (i & 1) {
                    bits[i + 1]++;
                }
            }
            n >>= 1;
        }
        int carry = 0;
        for (int i = 0; i < 32; i++) {
            int val = carry + bits[i];
            bits[i] = val & 1;
            carry = (val - bits[i]) / (-2);
        }
        int pos = 31;
        string res;
        while (pos >= 0 && bits[pos] == 0) {
            pos--;
        }
        while (pos >= 0) {
            res.push_back(bits[pos] + '0');
            pos--;
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String baseNeg2(int n) {
        if (n == 0) {
            return "0";
        }
        int[] bits = new int[32];
        for (int i = 0; i < 32 && n != 0; i++) {
            if ((n & 1) != 0) {
                bits[i]++;
                if ((i & 1) != 0) {
                    bits[i + 1]++;
                }
            }
            n >>= 1;
        }
        int carry = 0;
        for (int i = 0; i < 32; i++) {
            int val = carry + bits[i];
            bits[i] = val & 1;
            carry = (val - bits[i]) / (-2);
        }
        int pos = 31;
        StringBuilder res = new StringBuilder();
        while (pos >= 0 && bits[pos] == 0) {
            pos--;
        }
        while (pos >= 0) {
            res.append(bits[pos]);
            pos--;
        }
        return res.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string BaseNeg2(int n) {
        if (n == 0) {
            return "0";
        }
        int[] bits = new int[32];
        for (int i = 0; i < 32 && n != 0; i++) {
            if ((n & 1) != 0) {
                bits[i]++;
                if ((i & 1) != 0) {
                    bits[i + 1]++;
                }
            }
            n >>= 1;
        }
        int carry = 0;
        for (int i = 0; i < 32; i++) {
            int val = carry + bits[i];
            bits[i] = val & 1;
            carry = (val - bits[i]) / (-2);
        }
        int pos = 31;
        StringBuilder res = new StringBuilder();
        while (pos >= 0 && bits[pos] == 0) {
            pos--;
        }
        while (pos >= 0) {
            res.Append(bits[pos]);
            pos--;
        }
        return res.ToString();
    }
}
```

```C [sol1-C]
char * baseNeg2(int n) {
    if (n == 0) {
        return "0";
    }
    int bits[32];
    memset(bits, 0, sizeof(bits));
    for (int i = 0; i < 32 && n != 0; i++) {
        if (n & 1) {
            bits[i]++;
            if (i & 1) {
                bits[i + 1]++;
            }
        }
        n >>= 1;
    }
    int carry = 0;
    for (int i = 0; i < 32; i++) {
        int val = carry + bits[i];
        bits[i] = val & 1;
        carry = (val - bits[i]) / (-2);
    }
    int pos = 31;
    char *res = (char *)calloc(sizeof(char), 32);
    while (pos >= 0 && bits[pos] == 0) {
        pos--;
    }
    int i = 0;
    while (pos >= 0) {
        res[i] = bits[pos] + '0';
        pos--;
        i++;
    }
    return res;
}
```

```Python [sol1-Python3]
class Solution:
    def baseNeg2(self, n: int) -> str:
        if n == 0:
            return "0"

        bits = [0] * 32
        for i in range(32):
            if n == 0:
                break
            if n & 1:
                bits[i] += 1
                if i & 1:
                    bits[i + 1] += 1
            n >>= 1

        carry = 0
        for i in range(32):
            val = carry + bits[i]
            bits[i] = val & 1
            carry = (val - bits[i]) // -2

        pos = 31
        res = ""
        while pos >= 0 and bits[pos] == 0:
            pos -= 1
        while pos >= 0:
            res += str(bits[pos])
            pos -= 1
        return res
```

```JavaScript [sol1-JavaScript]
var baseNeg2 = function(n) {
    if (n === 0) {
        return "0";
    }
    const bits = new Array(32).fill(0);
    for (let i = 0; i < 32 && n !== 0; i++) {
        if ((n & 1) !== 0) {
            bits[i]++;
            if ((i & 1) !== 0) {
                bits[i + 1]++;
            }
        }
        n >>= 1;
    }
    let carry = 0;
    for (let i = 0; i < 32; i++) {
        const val = carry + bits[i];
        bits[i] = val & 1;
        carry = (val - bits[i]) / (-2);
    }
    let pos = 31;
    let res = "";
    while (pos >= 0 && bits[pos] === 0) {
        pos--;
    }
    while (pos >= 0) {
        res += bits[pos];
        pos--;
    }
    return res;
};
```

```go [sol1-Golang]
func baseNeg2(n int) string {
    if n == 0 {
        return "0"
    }
    bits := [32]int{}
    for i := 0; i < 32 && n != 0; i++ {
        if n&1 > 0 {
            bits[i]++
            if i&1 > 0 {
                bits[i+1]++
            }
        }
        n >>= 1
    }
    carry := 0
    for i := 0; i < 32; i++ {
        val := carry + bits[i]
        bits[i] = val & 1
        carry = (val - bits[i]) / -2
    }
    pos := 31
    res := []byte{}
    for pos >= 0 && bits[pos] == 0 {
        pos--
    }
    for pos >= 0 {
        res = append(res, byte(bits[pos])+'0')
        pos--
    }
    return string(res)
}
```

**复杂度分析**

- 时间复杂度：$O(C)$，其中 $C = 32$。需要对 $n$ 转换为二进制位，需要的时间复杂度为 $O(\log n)$，然后需要对其进行二进制位的中每一位进行「负二进制进位」运算，由于整数有 $32$ 位，因此需要「负二进制进位」运算 $32$ 次即可。

- 空间复杂度：$O(C)$，其中 $C = 32$。需要对 $n$ 转换为二进制位，由于整数最多只有 $32$ 位，在此每次采取固定的存储空间为 $O(32)$。

#### 方法二：进制转换

**思路与算法**

当基数 $x > 1$ 时，将整数 $n$ 转换成 $x$ 进制的原理是：令 $n_0 = n$，计算过程如下:
+ 当计算第 $0$ 位上的数字时，此时 $n_1 = \Big\lfloor \dfrac{n_0}{x} \Big\rfloor$，$n_0 = n_1 \times x  + r$，其中 $0 \le r < x$；
+ 当计算第 $i$ 位上的数字时，此时 $n_{i + 1} = \Big\lfloor \dfrac{n_i}{x} \Big\rfloor$，$n_i = n_{i+1} \times x  + r$，其中 $0 \le r < x$；
+ 按照上述计算方式进行计算，直到满足 $n_{i} = 0$ 结束。

如果基数 $x$ 为负数，只要能确定余数的可能取值，上述做法同样适用。由于「负二进制」表示中的每一位都是 $0$ 或 $1$，因此余数的可能取值是 $0$ 和 $1$，可以使用上述做法将整数 $n$ 转换成「负二进制」。具体转换过程如下：
+ ​如果 $n = 0$  则返回 $\text{``0"}$，$n = 1$ 则直接返回 $\text{``1"}$；
+ 如果 $n > 1$ 则使用一个字符串记录余数，将整数 $n$ 转换成「负二进制」，重复执行如下操作，直到 $n = 0$；
    + 计算当前 $n$ 的余数，由于当前的余数只能为 $0$ 或 $1$，由于有符号整数均采用补码表示，最低位的奇偶性保持不变，因此可以直接取 $C$ 的最低位即可，此时直接用 $n \And 1$ 即可得到最低位的余数，将余数拼接到字符串的末尾。
    + 将 $n$ 的值减去余数，然后将 $n$ 的值除以 $-2$。

上述操作结束之后，将字符串翻转之后得到「负二进制」数。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    string baseNeg2(int n) {
        if (n == 0 || n == 1) {
            return to_string(n);
        }
        string res;
        while (n != 0) {
            int remainder = n & 1;
            res.push_back('0' + remainder);
            n -= remainder;
            n /= -2;
        }
        reverse(res.begin(), res.end());
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    public String baseNeg2(int n) {
        if (n == 0 || n == 1) {
            return String.valueOf(n);
        }
        StringBuilder res = new StringBuilder();
        while (n != 0) {
            int remainder = n & 1;
            res.append(remainder);
            n -= remainder;
            n /= -2;
        }
        return res.reverse().toString();
    }
}
```

```C# [sol2-C#]
public class Solution {
    public string BaseNeg2(int n) {
        if (n == 0 || n == 1) {
            return n.ToString();
        }
        StringBuilder sb = new StringBuilder();
        while (n != 0) {
            int remainder = n & 1;
            sb.Append(remainder);
            n -= remainder;
            n /= -2;
        }
        StringBuilder res = new StringBuilder();
        for (int i = sb.Length - 1; i >= 0; i--) {
            res.Append(sb[i]);
        }
        return res.ToString();
    }
}
```

```C [sol2-C]
char * baseNeg2(int n) {
    if (n == 0) {
        return "0";
    }
    if (n == 1) {
        return "1";
    }
    char *res = (char *)calloc(sizeof(char), 32);
    int pos = 0;
    while (n != 0) {
        int remainder = n & 1;
        res[pos++] = '0' + remainder;
        n -= remainder;
        n /= -2;
    }
    for (int l = 0, r = pos - 1; l < r; l++, r--) {
        char c = res[l];
        res[l] = res[r];
        res[r] = c;
    }
    return res;
}
```

```Python [sol2-Python3]
class Solution:
    def baseNeg2(self, n: int) -> str:
        if n == 0 or n == 1:
            return str(n)
        res = []
        while n:
            remainder = n & 1
            res.append(str(remainder))
            n -= remainder
            n //= -2
        return ''.join(res[::-1])
```

```JavaScript [sol2-JavaScript]
var baseNeg2 = function(n) {
    if (n === 0 || n === 1) {
        return '' + n;
    }
    let res = '';
    while (n !== 0) {
        const remainder = n & 1;
        res += remainder;
        n -= remainder;
        n /= -2;
    }
    return res.split('').reverse().join('');
};
```

```go [sol2-Golang]
func baseNeg2(n int) string {
    if n == 0 || n == 1 {
        return strconv.Itoa(n)
    }
    res := []byte{}
    for n != 0 {
        remainder := n & 1
        res = append(res, '0'+byte(remainder))
        n -= remainder
        n /= -2
    }
    for i, n := 0, len(res); i < n/2; i++ {
        res[i], res[n-1-i] = res[n-1-i], res[i]
    }
    return string(res)
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$，其中 $n$ 是给定的整数。整数 $n$ 对应的「负二进制」表示的长度是 $\log n$，需要生成「负二进制」表示的每一位。

- 空间复杂度：$O(1)$。除返回值外，不需要额外的空间。

#### 方法三：数学计算

**思路与算法**

根据题意可知，$32$ 位「负二进制」数中第 $i$ 位则表示$(-2)^i$，当 $i$ 为偶数时，则 $(-2)^i = 2^i$，当 $i$ 为奇数时，则 $(-2)^i = -2^i$，因此可以得到其最大值与最小值分别为如下：
+ 最大值即所有的偶数位全部都为 $1$，奇数位全为 $0$，最大值即为 $\text{0x55555555} = 1,431,655,765$；
+ 最小值即所有的偶数位全部都为 $0$，奇数位全为 $1$，最小值即为 $\text{0xAAAAAAAA} = -2,863,311,530$；
+ $\text{0x55555555},\text{0xAAAAAAAA}$ 均为「十六进制」进制原码表示；

令 $\textit{maxVal} = \text{0x55555555}$，由于题目中 $n$ 给定的范围为 $0 \le n \le 10^9$，因此一定满足 $\textit{maxVal} > n$。设 $\textit{maxVal}$ 与 $n$ 的差为 $\textit{diff}$，则此时 $\textit{diff} =  \textit{maxVal} - n$，如果我们将 $\textit{maxVal}$ 在「负二进制」表示下减去 $\textit{diff}$，那么得到的「负二进制」一定为 $n$ 的「负二进制」。已知 $\textit{maxVal}$ 中的偶数位全为 $1$，奇数位全为 $0$，此时的减法操作可以用异或来实现:
+ 对于 $\textit{diff}$ 中偶数位为 $1$ 的位，在 $\textit{maxVal}$ 中需要将其置为 $0$，此时 $\textit{maxVal}$ 中偶数位全部为 $1$，$1 \oplus 1 = 0$，偶数位异或操作即可将需要的位置为 $0$；
+ 对于 $\textit{diff}$ 中奇数位为 $1$ 的位，在 $\textit{maxVal}$ 中需要将其置为 $1$，此时 $\textit{maxVal}$ 中奇数位全部为 $0$，$0 \oplus 1 = 1$，奇数位异或操作将需要的位置为 $1$，

根据以上推论可以知道，「负二进制」减法等同于 $\textit{maxVal} \oplus \textit{diff}$。按照上述方法可以知道 $n$ 的「负二进制」数等于 $\textit{maxVal} \oplus (\textit{maxVal} - n)$，我们求出 $n$ 的「负二进制」数，然后将其转换为二进制的字符串即可。

**代码**

```C++ [sol3-C++]
class Solution {
public:
    string baseNeg2(int n) {
        int val = 0x55555555 ^ (0x55555555 - n);
        if (val == 0) {
            return "0";
        }
        string res;
        while (val) {
            res.push_back('0' + (val & 1));
            val >>= 1;
        }
        reverse(res.begin(), res.end());
        return res;
    }
};
```

```Java [sol3-Java]
class Solution {
    public String baseNeg2(int n) {
        int val = 0x55555555 ^ (0x55555555 - n);
        if (val == 0) {
            return "0";
        }
        StringBuilder res = new StringBuilder();
        while (val != 0) {
            res.append(val & 1);
            val >>= 1;
        }
        return res.reverse().toString();
    }
}
```

```C# [sol3-C#]
public class Solution {
    public string BaseNeg2(int n) {
        int val = 0x55555555 ^ (0x55555555 - n);
        if (val == 0) {
            return "0";
        }
        StringBuilder sb = new StringBuilder();
        while (val != 0) {
            sb.Append(val & 1);
            val >>= 1;
        }
        StringBuilder res = new StringBuilder();
        for (int i = sb.Length - 1; i >= 0; i--) {
            res.Append(sb[i]);
        }
        return res.ToString();
    }
}
```

```C [sol3-C]
char * baseNeg2(int n) {
    int val = 0x55555555 ^ (0x55555555 - n);
    if (val == 0) {
        return "0";
    }
    char *res = (char *)calloc(sizeof(char), 32);
    int pos = 0;
    while (val) {
        res[pos++] = '0' + (val & 1);
        val >>= 1;
    }
    for (int l = 0, r = pos - 1; l < r; l++, r--) {
        char c = res[l];
        res[l] = res[r];
        res[r] = c;
    }
    return res;
}
```

```Python [sol3-Python3]
class Solution:
    def baseNeg2(self, n: int) -> str:
        val = 0x55555555 ^ (0x55555555 - n)
        if val == 0:
            return "0"
        res = []
        while val:
            res.append(str(val & 1))
            val >>= 1
        return ''.join(res[::-1])
```

```JavaScript [sol3-JavaScript]
var baseNeg2 = function(n) {
    let val = 0x55555555 ^ (0x55555555 - n);
    if (val === 0) {
        return "0";
    }
    let res = "";
    while (val !== 0) {
        res += val & 1;
        val >>= 1;
    }
    return res.split('').reverse().join('');
};
```

```go [sol3-Golang]
func baseNeg2(n int) string {
    val := 0x55555555 ^ (0x55555555 - n)
    if val == 0 {
        return "0"
    }
    res := []byte{}
    for val > 0 {
        res = append(res, '0'+byte(val&1))
        val >>= 1
    }
    for i, n := 0, len(res); i < n/2; i++ {
        res[i], res[n-1-i] = res[n-1-i], res[i]
    }
    return string(res)
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$，其中 $n$ 是给定的整数。整数 $n$ 对应的「负二进制」表示的长度是 $\log n$，需要生成「负二进制」表示的每一位。

- 空间复杂度：$O(1)$。除返回值外，不需要额外的空间。
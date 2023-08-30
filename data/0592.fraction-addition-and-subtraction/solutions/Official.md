#### 方法一：模拟

对于两个分数 $\dfrac{x_1}{y_1} 和 \dfrac{x_2}{y_2}$，它们相加的结果为：

$$\dfrac{x_1 \times y_2 + x_2 \times y_1}{y_1 \times y_2}$$

初始分数的分子为 $\textit{x} = 0$，分母为 $\textit{y} = 1$。我们不断从字符串中获取下一个分数，它的分子为 $\textit{x}_1$，分母为 $\textit{y}_1$，将它加到初始分数上，有：

$$
\begin{cases}
\textit{x} = \textit{x} \times \textit{y}_1 + \textit{x}_1 \times \textit{y} \\
\textit{y} = \textit{y} \times \textit{y}_1
\end{cases}
$$

最后如果 $\textit{x} = 0$，说明结果为零，直接返回 $\text{"0/1"}$；否则计算分子分母的最大公约数，返回约简后分数的字符串表示。

```Python [sol1-Python3]
class Solution:
    def fractionAddition(self, expression: str) -> str:
        x, y = 0, 1  # 分子，分母
        i, n = 0, len(expression)
        while i < n:
            # 读取分子
            x1, sign = 0, 1
            if expression[i] == '-' or expression[i] == '+':
                if expression[i] == '-':
                    sign = -1
                i += 1
            while i < n and expression[i].isdigit():
                x1 = x1 * 10 + int(expression[i])
                i += 1
            x1 = sign * x1
            i += 1

            # 读取分母
            y1 = 0
            while i < n and expression[i].isdigit():
                y1 = y1 * 10 + int(expression[i])
                i += 1

            x = x * y1 + x1 * y
            y *= y1
        if x == 0:
            return "0/1"
        g = gcd(abs(x), y)
        return f"{x // g}/{y // g}"
```

```C++ [sol1-C++]
class Solution {
public:
    string fractionAddition(string expression) {
        long long x = 0, y = 1; // 分子，分母
        int index = 0, n = expression.size();
        while (index < n) {
            // 读取分子
            long long x1 = 0, sign = 1;
            if (expression[index] == '-' || expression[index] == '+') {
                sign = expression[index] == '-' ? -1 : 1;
                index++;
            }
            while (index < n && isdigit(expression[index])) {
                x1 = x1 * 10 + expression[index] - '0';
                index++;
            }
            x1 = sign * x1;
            index++;

            // 读取分母
            long long y1 = 0;
            while (index < n && isdigit(expression[index])) {
                y1 = y1 * 10 + expression[index] - '0';
                index++;
            }

            x = x * y1 + x1 * y;
            y *= y1;
        }
        if (x == 0) {
            return "0/1";
        }
        long long g = gcd(abs(x), y); // 获取最大公约数
        return to_string(x / g) + "/" + to_string(y / g);
    }
};
```

```Java [sol1-Java]
class Solution {
    public String fractionAddition(String expression) {
        long x = 0, y = 1; // 分子，分母
        int index = 0, n = expression.length();
        while (index < n) {
            // 读取分子
            long x1 = 0, sign = 1;
            if (expression.charAt(index) == '-' || expression.charAt(index) == '+') {
                sign = expression.charAt(index) == '-' ? -1 : 1;
                index++;
            }
            while (index < n && Character.isDigit(expression.charAt(index))) {
                x1 = x1 * 10 + expression.charAt(index) - '0';
                index++;
            }
            x1 = sign * x1;
            index++;

            // 读取分母
            long y1 = 0;
            while (index < n && Character.isDigit(expression.charAt(index))) {
                y1 = y1 * 10 + expression.charAt(index) - '0';
                index++;
            }

            x = x * y1 + x1 * y;
            y *= y1;
        }
        if (x == 0) {
            return "0/1";
        }
        long g = gcd(Math.abs(x), y); // 获取最大公约数
        return Long.toString(x / g) + "/" + Long.toString(y / g);
    }

    public long gcd(long a, long b) {
        long remainder = a % b;
        while (remainder != 0) {
            a = b;
            b = remainder;
            remainder = a % b;
        }
        return b;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string FractionAddition(string expression) {
        long x = 0, y = 1; // 分子，分母
        int index = 0, n = expression.Length;
        while (index < n) {
            // 读取分子
            long x1 = 0, sign = 1;
            if (expression[index] == '-' || expression[index] == '+') {
                sign = expression[index] == '-' ? -1 : 1;
                index++;
            }
            while (index < n && char.IsDigit(expression[index])) {
                x1 = x1 * 10 + expression[index] - '0';
                index++;
            }
            x1 = sign * x1;
            index++;

            // 读取分母
            long y1 = 0;
            while (index < n && char.IsDigit(expression[index])) {
                y1 = y1 * 10 + expression[index] - '0';
                index++;
            }

            x = x * y1 + x1 * y;
            y *= y1;
        }
        if (x == 0) {
            return "0/1";
        }
        long g = GCD(Math.Abs(x), y); // 获取最大公约数
        return (x / g).ToString() + "/" + (y / g).ToString();
    }

    public long GCD(long a, long b) {
        long remainder = a % b;
        while (remainder != 0) {
            a = b;
            b = remainder;
            remainder = a % b;
        }
        return b;
    }
}
```

```C [sol1-C]
#define MAX_STR_LEN 80

long long gcd(long long a, long long b) {
    long remainder = a % b;
    while (remainder != 0) {
        a = b;
        b = remainder;
        remainder = a % b;
    }
    return b;
}

char * fractionAddition(char * expression) {
    long long x = 0, y = 1; // 分子，分母
    int index = 0, n = strlen(expression);
    while (index < n) {
        // 读取分子
        long long x1 = 0, sign = 1;
        if (expression[index] == '-' || expression[index] == '+') {
            sign = expression[index] == '-' ? -1 : 1;
            index++;
        }
        while (index < n && isdigit(expression[index])) {
            x1 = x1 * 10 + expression[index] - '0';
            index++;
        }
        x1 = sign * x1;
        index++;

        // 读取分母
        long long y1 = 0;
        while (index < n && isdigit(expression[index])) {
            y1 = y1 * 10 + expression[index] - '0';
            index++;
        }

        x = x * y1 + x1 * y;
        y *= y1;
    }
    if (x == 0) {
        return "0/1";
    }
    long long g = gcd(abs(x), y); // 获取最大公约数
    char *ans = (char *)malloc(sizeof(char) * MAX_STR_LEN);
    sprintf(ans, "%d/%d", x / g, y / g);
    return ans;
}
```

```go [sol1-Golang]
func fractionAddition(expression string) string {
    x, y := 0, 1 // 分子，分母
    for i, n := 0, len(expression); i < n; {
        // 读取分子
        x1, sign := 0, 1
        if expression[i] == '-' || expression[i] == '+' {
            if expression[i] == '-' {
                sign = -1
            }
            i++
        }
        for i < n && unicode.IsDigit(rune(expression[i])) {
            x1 = x1*10 + int(expression[i]-'0')
            i++
        }
        x1 = sign * x1
        i++

        // 读取分母
        y1 := 0
        for i < n && unicode.IsDigit(rune(expression[i])) {
            y1 = y1*10 + int(expression[i]-'0')
            i++
        }

        x = x*y1 + x1*y
        y *= y1
    }
    if x == 0 {
        return "0/1"
    }
    g := gcd(abs(x), y)
    return fmt.Sprintf("%d/%d", x/g, y/g)
}

func gcd(a, b int) int {
    for a != 0 {
        a, b = b%a, a
    }
    return b
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

```JavaScript [sol1-JavaScript]
var fractionAddition = function(expression) {
    let x = 0, y = 1; // 分子，分母
    let index = 0, n = expression.length;
    while (index < n) {
        // 读取分子
        let x1 = 0, sign = 1;
        if (expression[index] === '-' || expression[index] === '+') {
            sign = expression[index] === '-' ? -1 : 1;
            index++;
        }
        while (index < n && isDigit(expression[index])) {
            x1 = x1 * 10 + expression[index].charCodeAt() - '0'.charCodeAt();
            index++;
        }
        x1 = sign * x1;
        index++;

        // 读取分母
        let y1 = 0;
        while (index < n && isDigit(expression[index])) {
            y1 = y1 * 10 + expression[index].charCodeAt() - '0'.charCodeAt();
            index++;
        }

        x = x * y1 + x1 * y;
        y *= y1;
    }
    if (x === 0) {
        return "0/1";
    }
    const g = gcd(Math.abs(x), y); // 获取最大公约数
    return Math.floor(x / g) + "/" + Math.floor(y / g);
}

const gcd = (a, b) => {
    let remainder = a % b;
    while (remainder !== 0) {
        a = b;
        b = remainder;
        remainder = a % b;
    }
    return b;
};

const isDigit = (ch) => {
    return parseFloat(ch).toString() === "NaN" ? false : true;
}
```

**复杂度分析**

+ 时间复杂度：$O(n + \log C)$，其中 $n$ 是字符串 $\textit{expression}$ 的长度，$C$ 为化简前结果分子分母的最大值。求最大公约数需要 $O(\log C)$。

+ 空间复杂度：$O(1)$。
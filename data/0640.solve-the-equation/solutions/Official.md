## [640.求解方程 中文官方题解](https://leetcode.cn/problems/solve-the-equation/solutions/100000/qiu-jie-fang-cheng-by-leetcode-solution-knct)

#### 方法一：解析

我们将等式右边的项都移到等式左边，那么等式右边的项的默认系数为 $-1$。我们依次解析方程的项，并将同类项进行合并，使用 $\textit{factor}$ 表示变量的系数，$\textit{val}$ 表示常量值。

初始时默认系数 $\textit{sign}_1 = 1$，当我们解析到等号时，说明解析到等式右边的项，令 $\textit{sign}_1 = -1$。使用变量 $\textit{sign}_2$ 表示项的符号，初始时 $\textit{sign}_2 = \textit{sign}_1$，如果我们解析到 $\text{`+'}$ 或 $\text{`-'}$，那么相应的更改 $\textit{sign}_2$。使用 $\textit{number}$ 记录数字，$\textit{valid}$ 表示 $\textit{number}$ 是否有效（变量 $x$ 前面可能没有数字），如果我们解析到的项是变量项，那么相应的更改 $\textit{factor}$；如果我们解析到的项是常量项，那么相应的更改 $\textit{val}$。

如果 $\textit{factor} = 0$ 成立，说明变量 $x$ 对方程无影响，然后判断 $\textit{val} = 0$ 是否成立，成立则说明方程有无数解，返回 $\text{``Infinite solutions"}$，否则返回 $\text{``No solution"}$。其他情况直接返回对应的整数解 $x = \dfrac{-\textit{val}}{\textit{factor}}$。

```Python [sol1-Python3]
class Solution:
    def solveEquation(self, equation: str) -> str:
        factor = val = 0
        i, n, sign = 0, len(equation), 1  # 等式左边默认系数为正
        while i < n:
            if equation[i] == '=':
                sign = -1
                i += 1
                continue

            s = sign
            if equation[i] == '+':  # 去掉前面的符号
                i += 1
            elif equation[i] == '-':
                s = -s
                i += 1

            num, valid = 0, False
            while i < n and equation[i].isdigit():
                valid = True
                num = num * 10 + int(equation[i])
                i += 1

            if i < n and equation[i] == 'x':  # 变量
                factor += s * num if valid else s
                i += 1
            else:  # 数值
                val += s * num

        if factor == 0:
            return "No solution" if val else "Infinite solutions"
        return f"x={-val // factor}"
```

```C++ [sol1-C++]
class Solution {
public:
    string solveEquation(string equation) {
        int factor = 0, val = 0;
        int index = 0, n = equation.size(), sign1 = 1; // 等式左边默认系数为正
        while (index < n) {
            if (equation[index] == '=') {
                sign1 = -1; // 等式右边默认系数为负
                index++;
                continue;
            }

            int sign2 = sign1, number = 0;
            bool valid = false; // 记录 number 是否有效
            if (equation[index] == '-' || equation[index] == '+') { // 去掉前面的符号
                sign2 = (equation[index] == '-') ? -sign1 : sign1;
                index++;
            }
            while (index < n && isdigit(equation[index])) {
                number = number * 10 + (equation[index] - '0');
                index++;
                valid = true;
            }

            if (index < n && equation[index] == 'x') { // 变量
                factor += valid ? sign2 * number : sign2;
                index++;
            } else { // 数值
                val += sign2 * number;
            }
        }

        if (factor == 0) {
            return val == 0 ? "Infinite solutions" : "No solution";
        }
        return string("x=") + to_string(-val / factor);
    }
};
```

```Java [sol1-Java]
class Solution {
    public String solveEquation(String equation) {
        int factor = 0, val = 0;
        int index = 0, n = equation.length(), sign1 = 1; // 等式左边默认系数为正
        while (index < n) {
            if (equation.charAt(index) == '=') {
                sign1 = -1; // 等式右边默认系数为负
                index++;
                continue;
            }

            int sign2 = sign1, number = 0;
            boolean valid = false; // 记录 number 是否有效
            if (equation.charAt(index) == '-' || equation.charAt(index) == '+') { // 去掉前面的符号
                sign2 = (equation.charAt(index) == '-') ? -sign1 : sign1;
                index++;
            }
            while (index < n && Character.isDigit(equation.charAt(index))) {
                number = number * 10 + (equation.charAt(index) - '0');
                index++;
                valid = true;
            }

            if (index < n && equation.charAt(index) == 'x') { // 变量
                factor += valid ? sign2 * number : sign2;
                index++;
            } else { // 数值
                val += sign2 * number;
            }
        }

        if (factor == 0) {
            return val == 0 ? "Infinite solutions" : "No solution";
        }
        return "x=" + (-val / factor);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string SolveEquation(string equation) {
        int factor = 0, val = 0;
        int index = 0, n = equation.Length, sign1 = 1; // 等式左边默认系数为正
        while (index < n) {
            if (equation[index] == '=') {
                sign1 = -1; // 等式右边默认系数为负
                index++;
                continue;
            }

            int sign2 = sign1, number = 0;
            bool valid = false; // 记录 number 是否有效
            if (equation[index] == '-' || equation[index] == '+') { // 去掉前面的符号
                sign2 = (equation[index] == '-') ? -sign1 : sign1;
                index++;
            }
            while (index < n && char.IsDigit(equation[index])) {
                number = number * 10 + (equation[index] - '0');
                index++;
                valid = true;
            }

            if (index < n && equation[index] == 'x') { // 变量
                factor += valid ? sign2 * number : sign2;
                index++;
            } else { // 数值
                val += sign2 * number;
            }
        }

        if (factor == 0) {
            return val == 0 ? "Infinite solutions" : "No solution";
        }
        return "x=" + (-val / factor);
    }
}
```

```C [sol1-C]
#define MAX_EXPRESSION_LEN 32

char * solveEquation(char * equation) {
    int factor = 0, val = 0;
    int index = 0, n = strlen(equation), sign1 = 1; // 等式左边默认系数为正
    while (index < n) {
        if (equation[index] == '=') {
            sign1 = -1; // 等式右边默认系数为负
            index++;
            continue;
        }

        int sign2 = sign1, number = 0;
        bool valid = false; // 记录 number 是否有效
        if (equation[index] == '-' || equation[index] == '+') { // 去掉前面的符号
            sign2 = (equation[index] == '-') ? -sign1 : sign1;
            index++;
        }
        while (index < n && isdigit(equation[index])) {
            number = number * 10 + (equation[index] - '0');
            index++;
            valid = true;
        }

        if (index < n && equation[index] == 'x') { // 变量
            factor += valid ? sign2 * number : sign2;
            index++;
        } else { // 数值
            val += sign2 * number;
        }
    }

    if (factor == 0) {
        return val == 0 ? "Infinite solutions" : "No solution";
    }
    char *ans = (char *)malloc(sizeof(char) * MAX_EXPRESSION_LEN);
    sprintf(ans, "x=%d", -val / factor);
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var solveEquation = function(equation) {
    let factor = 0, val = 0;
    let index = 0, n = equation.length, sign1 = 1; // 等式左边默认系数为正
    while (index < n) {
        if (equation[index] === '=') {
            sign1 = -1; // 等式右边默认系数为负
            index++;
            continue;
        }

        let sign2 = sign1, number = 0;
        let valid = false; // 记录 number 是否有效
        if (equation[index] === '-' || equation[index] === '+') { // 去掉前面的符号
            sign2 = (equation[index] === '-') ? -sign1 : sign1;
            index++;
        }
        while (index < n && isDigit(equation[index])) {
            number = number * 10 + (equation[index].charCodeAt() - '0'.charCodeAt());
            index++;
            valid = true;
        }

        if (index < n && equation[index] === 'x') { // 变量
            factor += valid ? sign2 * number : sign2;
            index++;
        } else { // 数值
            val += sign2 * number;
        }
    }

    if (factor === 0) {
        return val === 0 ? "Infinite solutions" : "No solution";
    }
    return "x=" + (-val / factor);
};

const isDigit = (ch) => {
    return parseFloat(ch).toString() === "NaN" ? false : true;
}
```

```go [sol1-Golang]
func solveEquation(equation string) string {
    factor, val := 0, 0
    i, n, sign := 0, len(equation), 1 // 等式左边默认系数为正
    for i < n {
        if equation[i] == '=' {
            sign = -1 // 等式右边默认系数为负
            i++
            continue
        }

        s := sign
        if equation[i] == '+' { // 去掉前面的符号
            i++
        } else if equation[i] == '-' {
            s = -s
            i++
        }

        num, valid := 0, false
        for i < n && unicode.IsDigit(rune(equation[i])) {
            valid = true
            num = num*10 + int(equation[i]-'0')
            i++
        }

        if i < n && equation[i] == 'x' { // 变量
            if valid {
                s *= num
            }
            factor += s
            i++
        } else { // 数值
            val += s * num
        }
    }

    if factor == 0 {
        if val == 0 {
            return "Infinite solutions"
        }
        return "No solution"
    }
    return "x=" + strconv.Itoa(-val/factor)
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{equation}$ 的长度。

+ 空间复杂度：$O(1)$。
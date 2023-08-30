#### 方法一：递归

由于非负整数 $\textit{num}$ 的最大值为 $2^{31}-1$，因此最多有 $10$ 位数。将整数转换成英文表示中，将数字按照 $3$ 位一组划分，将每一组的英文表示拼接之后即可得到整数 $\textit{num}$ 的英文表示。

每一组最多有 $3$ 位数，可以使用递归的方式得到每一组的英文表示。根据数字所在的范围，具体做法如下：

- 小于 $20$ 的数可以直接得到其英文表示；

- 大于等于 $20$ 且小于 $100$ 的数首先将十位转换成英文表示，然后对个位递归地转换成英文表示；

- 大于等于 $100$ 的数首先将百位转换成英文表示，然后对其余部分（十位和个位）递归地转换成英文表示。

从高到低的每一组的单位依次是 $10^9$、$10^6$、$10^3$、$1$，除了最低组以外，每一组都有对应的表示单位的词，分别是 $\text{``Billion"}$、$\text{``Million"}$、$\text{``Thousand"}$。

得到每一组的英文表示后，需要对每一组加上对应的表示单位的词，然后拼接得到整数 $\textit{num}$ 的英文表示。

具体实现中需要注意以下两点：

- 只有非零的组的英文表示才会拼接到整数 $\textit{num}$ 的英文表示中；

- 如果 $\textit{num} = 0$，则不适用上述做法，而是直接返回 $\text{``Zero"}$。

```Java [sol1-Java]
class Solution {
    String[] singles = {"", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"};
    String[] teens = {"Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"};
    String[] tens = {"", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"};
    String[] thousands = {"", "Thousand", "Million", "Billion"};

    public String numberToWords(int num) {
        if (num == 0) {
            return "Zero";
        }
        StringBuffer sb = new StringBuffer();
        for (int i = 3, unit = 1000000000; i >= 0; i--, unit /= 1000) {
            int curNum = num / unit;
            if (curNum != 0) {
                num -= curNum * unit;
                StringBuffer curr = new StringBuffer();
                recursion(curr, curNum);
                curr.append(thousands[i]).append(" ");
                sb.append(curr);
            }
        }
        return sb.toString().trim();
    }

    public void recursion(StringBuffer curr, int num) {
        if (num == 0) {
            return;
        } else if (num < 10) {
            curr.append(singles[num]).append(" ");
        } else if (num < 20) {
            curr.append(teens[num - 10]).append(" ");
        } else if (num < 100) {
            curr.append(tens[num / 10]).append(" ");
            recursion(curr, num % 10);
        } else {
            curr.append(singles[num / 100]).append(" Hundred ");
            recursion(curr, num % 100);
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    string[] singles = {"", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"};
    string[] teens = {"Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"};
    string[] tens = {"", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"};
    string[] thousands = {"", "Thousand", "Million", "Billion"};

    public string NumberToWords(int num) {
        if (num == 0) {
            return "Zero";
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 3, unit = 1000000000; i >= 0; i--, unit /= 1000) {
            int curNum = num / unit;
            if (curNum != 0) {
                num -= curNum * unit;
                StringBuilder curr = new StringBuilder();
                Recursion(curr, curNum);
                curr.Append(thousands[i]).Append(" ");
                sb.Append(curr);
            }
        }
        return sb.ToString().Trim();
    }

    public void Recursion(StringBuilder curr, int num) {
        if (num == 0) {
            return;
        } else if (num < 10) {
            curr.Append(singles[num]).Append(" ");
        } else if (num < 20) {
            curr.Append(teens[num - 10]).Append(" ");
        } else if (num < 100) {
            curr.Append(tens[num / 10]).Append(" ");
            Recursion(curr, num % 10);
        } else {
            curr.Append(singles[num / 100]).Append(" Hundred ");
            Recursion(curr, num % 100);
        }
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<string> singles = {"", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"};
    vector<string> teens = {"Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"};
    vector<string> tens = {"", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"};
    vector<string> thousands = {"", "Thousand", "Million", "Billion"};

    string numberToWords(int num) {
        if (num == 0) {
            return "Zero";
        }
        string sb;
        for (int i = 3, unit = 1000000000; i >= 0; i--, unit /= 1000) {
            int curNum = num / unit;
            if (curNum != 0) {
                num -= curNum * unit;
                string curr;
                recursion(curr, curNum);
                curr = curr + thousands[i] + " ";
                sb = sb + curr;
            }
        }
        while (sb.back() == ' ') {
            sb.pop_back();
        }
        return sb;
    }

    void recursion(string & curr, int num) {
        if (num == 0) {
            return;
        } else if (num < 10) {
            curr = curr + singles[num] + " ";
        } else if (num < 20) {
            curr = curr + teens[num - 10] + " ";
        } else if (num < 100) {
            curr = curr + tens[num / 10] + " ";
            recursion(curr, num % 10);
        } else {
            curr = curr + singles[num / 100] + " Hundred ";
            recursion(curr, num % 100);
        }
    }
};
```

```JavaScript [sol1-JavaScript]
var numberToWords = function(num) {
    const singles = ["", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"];
    const teens = ["Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"];
    const tens = ["", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"];
    const thousands = ["", "Thousand", "Million", "Billion"];

    const recursion = (curr, num) => {
        if (num === 0) {
            return;
        } else if (num < 10) {
            curr.push(singles[num] + " ");
        } else if (num < 20) {
            curr.push(teens[num - 10] + " ");
        } else if (num < 100) {
            curr.push(tens[Math.floor(num / 10)] + " ");
            recursion(curr, num % 10);
        } else {
            curr.push(singles[Math.floor(num / 100)] + " Hundred ");
            recursion(curr, num % 100);
        }
    }
    
    if (num === 0) {
        return "Zero";
    }
    const sb = [];
    for (let i = 3, unit = 1000000000; i >= 0; i--, unit = Math.floor(unit / 1000)) {
        const curNum = Math.floor(num / unit);
        if (curNum !== 0) {
            num -= curNum * unit;
            const curr = [];
            recursion(curr, curNum);
            curr.push(thousands[i] + " ");
            sb.push(curr.join(''));
        }
    }
    return sb.join('').trim();
}
```

```go [sol1-Golang]
var (
    singles   = []string{"", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"}
    teens     = []string{"Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"}
    tens      = []string{"", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"}
    thousands = []string{"", "Thousand", "Million", "Billion"}
)

func numberToWords(num int) string {
    if num == 0 {
        return "Zero"
    }
    sb := &strings.Builder{}
    var recursion func(int)
    recursion = func(num int) {
        switch {
        case num == 0:
        case num < 10:
            sb.WriteString(singles[num])
            sb.WriteByte(' ')
        case num < 20:
            sb.WriteString(teens[num-10])
            sb.WriteByte(' ')
        case num < 100:
            sb.WriteString(tens[num/10])
            sb.WriteByte(' ')
            recursion(num % 10)
        default:
            sb.WriteString(singles[num/100])
            sb.WriteString(" Hundred ")
            recursion(num % 100)
        }
    }
    for i, unit := 3, int(1e9); i >= 0; i-- {
        if curNum := num / unit; curNum > 0 {
            num -= curNum * unit
            recursion(curNum)
            sb.WriteString(thousands[i])
            sb.WriteByte(' ')
        }
        unit /= 1000
    }
    return strings.TrimSpace(sb.String())
}
```

```Python [sol1-Python3]
singles = ["", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"]
teens = ["Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"]
tens = ["", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"]
thousands = ["", "Thousand", "Million", "Billion"]

class Solution:
    def numberToWords(self, num: int) -> str:
        if num == 0:
            return "Zero"

        def recursion(num: int) -> str:
            s = ""
            if num == 0:
                return s
            elif num < 10:
                s += singles[num] + " "
            elif num < 20:
                s += teens[num - 10] + " "
            elif num < 100:
                s += tens[num // 10] + " " + recursion(num % 10)
            else:
                s += singles[num // 100] + " Hundred " + recursion(num % 100)
            return s

        s = ""
        unit = int(1e9)
        for i in range(3, -1, -1):
            curNum = num // unit
            if curNum:
                num -= curNum * unit
                s += recursion(curNum) + thousands[i] + " "
            unit //= 1000
        return s.strip()
```

**复杂度分析**

- 时间复杂度：$O(1)$。非负整数 $\textit{nums}$ 按照 $3$ 位一组划分最多有 $4$ 组，分别得到每一组的英文表示，然后拼接得到整数 $\textit{num}$ 的英文表示，时间复杂度是常数。

- 空间复杂度：$O(1)$。空间复杂度主要取决于存储英文表示的字符串和递归调用栈，英文表示的长度可以看成常数，递归调用栈不会超过 $3$ 层。

#### 方法二：迭代

也可以使用迭代的方式得到每一组的英文表示。由于每一组最多有 $3$ 位数，因此依次得到百位、十位、个位上的数字，生成该组的英文表示，注意只有非零位才会被添加到英文表示中。

```Java [sol2-Java]
class Solution {
    String[] singles = {"", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"};
    String[] teens = {"Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"};
    String[] tens = {"", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"};
    String[] thousands = {"", "Thousand", "Million", "Billion"};

    public String numberToWords(int num) {
        if (num == 0) {
            return "Zero";
        }
        StringBuffer sb = new StringBuffer();
        for (int i = 3, unit = 1000000000; i >= 0; i--, unit /= 1000) {
            int curNum = num / unit;
            if (curNum != 0) {
                num -= curNum * unit;
                sb.append(toEnglish(curNum)).append(thousands[i]).append(" ");
            }
        }
        return sb.toString().trim();
    }

    public String toEnglish(int num) {
        StringBuffer curr = new StringBuffer();
        int hundred = num / 100;
        num %= 100;
        if (hundred != 0) {
            curr.append(singles[hundred]).append(" Hundred ");
        }
        int ten = num / 10;
        if (ten >= 2) {
            curr.append(tens[ten]).append(" ");
            num %= 10;
        }
        if (num > 0 && num < 10) {
            curr.append(singles[num]).append(" ");
        } else if (num >= 10) {
            curr.append(teens[num - 10]).append(" ");
        }
        return curr.toString();
    }
}
```

```C# [sol2-C#]
public class Solution {
    string[] singles = {"", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"};
    string[] teens = {"Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"};
    string[] tens = {"", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"};
    string[] thousands = {"", "Thousand", "Million", "Billion"};

    public string NumberToWords(int num) {
        if (num == 0) {
            return "Zero";
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 3, unit = 1000000000; i >= 0; i--, unit /= 1000) {
            int curNum = num / unit;
            if (curNum != 0) {
                num -= curNum * unit;
                sb.Append(toEnglish(curNum)).Append(thousands[i]).Append(" ");
            }
        }
        return sb.ToString().Trim();
    }

    public string toEnglish(int num) {
        StringBuilder curr = new StringBuilder();
        int hundred = num / 100;
        num %= 100;
        if (hundred != 0) {
            curr.Append(singles[hundred]).Append(" Hundred ");
        }
        int ten = num / 10;
        if (ten >= 2) {
            curr.Append(tens[ten]).Append(" ");
            num %= 10;
        }
        if (num > 0 && num < 10) {
            curr.Append(singles[num]).Append(" ");
        } else if (num >= 10) {
            curr.Append(teens[num - 10]).Append(" ");
        }
        return curr.ToString();
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    vector<string> singles = {"", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"};
    vector<string> teens = {"Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"};
    vector<string> tens = {"", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"};
    vector<string> thousands = {"", "Thousand", "Million", "Billion"};
    
    string numberToWords(int num) {
        if (num == 0) {
            return "Zero";
        }
        string sb;
        for (int i = 3, unit = 1000000000; i >= 0; i--, unit /= 1000) {
            int curNum = num / unit;
            if (curNum != 0) {
                num -= curNum * unit;
                sb = sb + toEnglish(curNum) + thousands[i] + " ";
            }
        }
        while (sb.back() == ' ') {
            sb.pop_back();
        }
        return sb;
    }

    string toEnglish(int num) {
        string curr;
        int hundred = num / 100;
        num %= 100;
        if (hundred != 0) {
            curr = curr + singles[hundred] + " Hundred ";
        }
        int ten = num / 10;
        if (ten >= 2) {
            curr = curr + tens[ten] + " ";
            num %= 10;
        }
        if (num > 0 && num < 10) {
            curr = curr + singles[num] + " ";
        } else if (num >= 10) {
            curr = curr + teens[num - 10] + " ";
        }
        return curr;
    }
};
```

```JavaScript [sol2-JavaScript]
var numberToWords = function(num) {
    const singles = ["", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"];
    const teens = ["Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"];
    const tens = ["", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"];
    const thousands = ["", "Thousand", "Million", "Billion"];

    const toEnglish = (num) => {
        const curr = [];
        const hundred = Math.floor(num / 100);
        num %= 100;
        if (hundred !== 0) {
            curr.push(singles[hundred] + " Hundred ");
        }
        const ten = Math.floor(num / 10);
        if (ten >= 2) {
            curr.push(tens[ten] + " ");
            num %= 10;
        }
        if (num > 0 && num < 10) {
            curr.push(singles[num] + " ");
        } else if (num >= 10) {
            curr.push(teens[num - 10] + " ");
        }
        return curr.join('');
    }

    if (num === 0) {
        return "Zero";
    }
    const sb = [];
    for (let i = 3, unit = 1000000000; i >= 0; i--, unit = Math.floor(unit / 1000)) {
        const curNum = Math.floor(num / unit);
        if (curNum !== 0) {
            num -= curNum * unit;
            sb.push(toEnglish(curNum) + thousands[i] + " ");
        }
    }
    return sb.join('').trim();
}
```

```go [sol2-Golang]
var (
    singles   = []string{"", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"}
    teens     = []string{"Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"}
    tens      = []string{"", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"}
    thousands = []string{"", "Thousand", "Million", "Billion"}
)

func numberToWords(num int) string {
    if num == 0 {
        return "Zero"
    }
    sb := &strings.Builder{}
    toEnglish := func(num int) {
        if num >= 100 {
            sb.WriteString(singles[num/100])
            sb.WriteString(" Hundred ")
            num %= 100
        }
        if num >= 20 {
            sb.WriteString(tens[num/10])
            sb.WriteByte(' ')
            num %= 10
        }
        if 0 < num && num < 10 {
            sb.WriteString(singles[num])
            sb.WriteByte(' ')
        } else if num >= 10 {
            sb.WriteString(teens[num-10])
            sb.WriteByte(' ')
        }
    }
    for i, unit := 3, int(1e9); i >= 0; i-- {
        if curNum := num / unit; curNum > 0 {
            num -= curNum * unit
            toEnglish(curNum)
            sb.WriteString(thousands[i])
            sb.WriteByte(' ')
        }
        unit /= 1000
    }
    return strings.TrimSpace(sb.String())
}
```

```Python [sol2-Python3]
singles = ["", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"]
teens = ["Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"]
tens = ["", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"]
thousands = ["", "Thousand", "Million", "Billion"]

class Solution:
    def numberToWords(self, num: int) -> str:
        if num == 0:
            return "Zero"

        def toEnglish(num: int) -> str:
            s = ""
            if num >= 100:
                s += singles[num // 100] + " Hundred "
                num %= 100
            if num >= 20:
                s += tens[num // 10] + " "
                num %= 10
            if 0 < num < 10:
                s += singles[num] + " "
            elif num >= 10:
                s += teens[num - 10] + " "
            return s

        s = ""
        unit = int(1e9)
        for i in range(3, -1, -1):
            curNum = num // unit
            if curNum:
                num -= curNum * unit
                s += toEnglish(curNum) + thousands[i] + " "
            unit //= 1000
        return s.strip()
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。
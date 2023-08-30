#### 方法一：穷举累加序列第一个数字和第二个数字的所有可能性

**思路及解法**

一个累加序列，当它的第一个数字和第二个数字以及总长度确定后，这整个累加序列也就确定了。根据这个性质，我们可以穷举累加序列的第一个数字和第二个数字的所有可能性，对每个可能性，进行一次合法性的判断。当出现一次合法的累加序列后，即可返回 $\texttt{true}$。当所有可能性都遍历完仍无法找到一个合法的累加序列时，返回 $\texttt{false}$。

记字符串 $\textit{num}$ 的长度为 $n$，序列最新确定的两个数中，位于前面的数字为 $\textit{first}$，$\textit{first}$ 的最高位在 $\textit{num}$ 中的下标为 $\textit{firstStart}$，$\textit{first}$ 的最低位在 $\textit{num}$ 中的下标为 $\textit{firstEnd}$。记序列最新确定的两个数中，位于后面的数字为 $\textit{second}$，$\textit{second}$ 的最高位在 $\textit{num}$ 中的下标为 $\textit{secondStart}$，$\textit{second}$ 的最低位在 $\textit{num}$ 中的下标为 $\textit{secondEnd}$。在穷举第一个数字和第二个数字的过程中，容易得到以下两个结论：$\textit{firstStart} = 0$，$\textit{firstEnd} + 1 = \textit{secondStart}$。因此，我们只需要用两个循环来遍历 $\textit{secondStart}$ 和 $\textit{secondEnd}$ 所有可能性的组合即可。

在判断累加序列的合法性时，用字符串的加法来算出 $\textit{first}$ 与 $\textit{second}$ 之和 $\textit{third}$。将 $\textit{third}$ 与 $\textit{num}$ 接下来紧邻的相同长度的字符串进行比较。当 $\textit{third}$ 过长或者与接下来的字符串不相同时，则说明这不是一个合法的累加序列。当相同时，则我们为这个序列新确定了一个数字。如果 $\textit{third}$ 刚好抵达 $\textit{num}$ 的末尾时，则说明这是一个合法的序列。当 $\textit{num}$ 还有多余的字符时，则需要更新 $\textit{firstStart}$，$\textit{firstEnd}$，$\textit{secondStart}$，$\textit{secondEnd}$， 继续进行合法性的判断。

当输入规模较小时，这题可以直接使用整形或者长整型的数字的相加。而我们这里使用了字符串的加法，因此也能处理溢出的过大的整数输入。

仍需要注意的是，当某个数字长度大于等于 $2$ 时，这个数字不能以 $0$ 开头，这部分的判断可以在两层循环体的开头完成。

**代码**

```Python [sol1-Python3]
class Solution:
    def isAdditiveNumber(self, num: str) -> bool:
        n = len(num)
        for secondStart in range(1, n-1):
            if num[0] == '0' and secondStart != 1:
                break
            for secondEnd in range(secondStart, n-1):
                if num[secondStart] == '0' and secondStart != secondEnd:
                    break
                if self.valid(secondStart, secondEnd, num):
                    return True
        return False
    
    def valid(self, secondStart: int, secondEnd: int, num: str) -> bool:
        n = len(num)
        firstStart, firstEnd = 0, secondStart - 1
        while secondEnd <= n - 1:
            third = self.stringAdd(num, firstStart, firstEnd, secondStart, secondEnd)
            thirdStart = secondEnd + 1
            thirdEnd = secondEnd + len(third)
            if thirdEnd >= n or num[thirdStart:thirdEnd+1] != third:
                break
            if thirdEnd == n-1:
                return True
            firstStart, firstEnd = secondStart, secondEnd
            secondStart, secondEnd = thirdStart, thirdEnd
        return False
    
    def stringAdd(self, s: str, firstStart: int, firstEnd: int, secondStart: int, secondEnd: int) -> str:
        third = []
        carry, cur = 0, 0
        while firstEnd >= firstStart or secondEnd >= secondStart or carry != 0:
            cur = carry
            if firstEnd >= firstStart:
                cur += ord(s[firstEnd]) - ord('0')
                firstEnd -= 1
            if secondEnd >= secondStart:
                cur += ord(s[secondEnd]) - ord('0')
                secondEnd -= 1
            carry = cur // 10
            cur %= 10
            third.append(chr(cur + ord('0')))
        return ''.join(third[::-1])
```

```Java [sol1-Java]
class Solution {
    public boolean isAdditiveNumber(String num) {
        int n = num.length();
        for (int secondStart = 1; secondStart < n - 1; ++secondStart) {
            if (num.charAt(0) == '0' && secondStart != 1) {
                break;
            }
            for (int secondEnd = secondStart; secondEnd < n - 1; ++secondEnd) {
                if (num.charAt(secondStart) == '0' && secondStart != secondEnd) {
                    break;
                }
                if (valid(secondStart, secondEnd, num)) {
                    return true;
                }
            }
        }
        return false;
    }

    public boolean valid(int secondStart, int secondEnd, String num) {
        int n = num.length();
        int firstStart = 0, firstEnd = secondStart - 1;
        while (secondEnd <= n - 1) {
            String third = stringAdd(num, firstStart, firstEnd, secondStart, secondEnd);
            int thirdStart = secondEnd + 1;
            int thirdEnd = secondEnd + third.length();
            if (thirdEnd >= n || !num.substring(thirdStart, thirdEnd + 1).equals(third)) {
                break;
            }
            if (thirdEnd == n - 1) {
                return true;
            }
            firstStart = secondStart;
            firstEnd = secondEnd;
            secondStart = thirdStart;
            secondEnd = thirdEnd;
        }
        return false;
    }

    public String stringAdd(String s, int firstStart, int firstEnd, int secondStart, int secondEnd) {
        StringBuffer third = new StringBuffer();
        int carry = 0, cur = 0;
        while (firstEnd >= firstStart || secondEnd >= secondStart || carry != 0) {
            cur = carry;
            if (firstEnd >= firstStart) {
                cur += s.charAt(firstEnd) - '0';
                --firstEnd;
            }
            if (secondEnd >= secondStart) {
                cur += s.charAt(secondEnd) - '0';
                --secondEnd;
            }
            carry = cur / 10;
            cur %= 10;
            third.append((char) (cur + '0'));
        }
        third.reverse();
        return third.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool IsAdditiveNumber(string num) {
        int n = num.Length;
        for (int secondStart = 1; secondStart < n - 1; ++secondStart) {
            if (num[0] == '0' && secondStart != 1) {
                break;
            }
            for (int secondEnd = secondStart; secondEnd < n - 1; ++secondEnd) {
                if (num[secondStart] == '0' && secondStart != secondEnd) {
                    break;
                }
                if (Valid(secondStart, secondEnd, num)) {
                    return true;
                }
            }
        }
        return false;
    }

    public bool Valid(int secondStart, int secondEnd, string num) {
        int n = num.Length;
        int firstStart = 0, firstEnd = secondStart - 1;
        while (secondEnd <= n - 1) {
            string third = StringAdd(num, firstStart, firstEnd, secondStart, secondEnd);
            int thirdStart = secondEnd + 1;
            int thirdEnd = secondEnd + third.Length;
            if (thirdEnd >= n || !num.Substring(thirdStart, thirdEnd - thirdStart + 1).Equals(third)) {
                break;
            }
            if (thirdEnd == n - 1) {
                return true;
            }
            firstStart = secondStart;
            firstEnd = secondEnd;
            secondStart = thirdStart;
            secondEnd = thirdEnd;
        }
        return false;
    }

    public string StringAdd(string s, int firstStart, int firstEnd, int secondStart, int secondEnd) {
        StringBuilder third = new StringBuilder();
        int carry = 0, cur = 0;
        while (firstEnd >= firstStart || secondEnd >= secondStart || carry != 0) {
            cur = carry;
            if (firstEnd >= firstStart) {
                cur += s[firstEnd] - '0';
                --firstEnd;
            }
            if (secondEnd >= secondStart) {
                cur += s[secondEnd] - '0';
                --secondEnd;
            }
            carry = cur / 10;
            cur %= 10;
            third.Append((char) (cur + '0'));
        }
        char[] arr = third.ToString().ToCharArray();
        Array.Reverse(arr);
        third.Length = 0;
        foreach (char c in arr) {
            third.Append(c);
        }
        return third.ToString();
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool isAdditiveNumber(string num) {
        int n = num.size();
        for (int secondStart = 1; secondStart < n - 1; ++secondStart) {
            if (num[0] == '0' && secondStart != 1) {
                break;
            }
            for (int secondEnd = secondStart; secondEnd < n - 1; ++secondEnd) {
                if (num[secondStart] == '0' && secondStart != secondEnd) {
                    break;
                }
                if (valid(secondStart, secondEnd, num)) {
                    return true;
                }
            }
        }
        return false;
    }

    bool valid(int secondStart, int secondEnd, string num) {
        int n = num.size();
        int firstStart = 0, firstEnd = secondStart - 1;
        while (secondEnd <= n - 1) {
            string third = stringAdd(num, firstStart, firstEnd, secondStart, secondEnd);
            int thirdStart = secondEnd + 1;
            int thirdEnd = secondEnd + third.size();
            if (thirdEnd >= n || !(num.substr(thirdStart, thirdEnd - thirdStart + 1) == third)) {
                break;
            }
            if (thirdEnd == n - 1) {
                return true;
            }
            firstStart = secondStart;
            firstEnd = secondEnd;
            secondStart = thirdStart;
            secondEnd = thirdEnd;
        }
        return false;
    }

    string stringAdd(string s, int firstStart, int firstEnd, int secondStart, int secondEnd) {
        string third;
        int carry = 0, cur = 0;
        while (firstEnd >= firstStart || secondEnd >= secondStart || carry != 0) {
            cur = carry;
            if (firstEnd >= firstStart) {
                cur += s[firstEnd] - '0';
                --firstEnd;
            }
            if (secondEnd >= secondStart) {
                cur += s[secondEnd] - '0';
                --secondEnd;
            }
            carry = cur / 10;
            cur %= 10;
            third.push_back(cur + '0');
        }
        reverse(third.begin(), third.end());
        return third;
    }
};
```

```C [sol1-C]
char * stringAdd(const char * s, int firstStart, int firstEnd, int secondStart, int secondEnd) {
    char * third = (char *)malloc(sizeof(char) * (strlen(s) + 1));
    int thirdSize = 0;
    int carry = 0, cur = 0;
    
    while (firstEnd >= firstStart || secondEnd >= secondStart || carry != 0) {
        cur = carry;
        if (firstEnd >= firstStart) {
            cur += s[firstEnd] - '0';
            --firstEnd;
        }
        if (secondEnd >= secondStart) {
            cur += s[secondEnd] - '0';
            --secondEnd;
        }
        carry = cur / 10;
        cur %= 10;
        third[thirdSize] = cur + '0';
        thirdSize++;
    }

    int left = 0;
    int right = thirdSize - 1;
    while (left < right) {
        char c = third[left];
        third[left] = third[right];
        third[right] = c;
        ++left;
        --right;
    }
    third[thirdSize] = '\0';
    return third;
}

bool valid(int secondStart, int secondEnd, const char * num) {
    int n = strlen(num);
    int firstStart = 0, firstEnd = secondStart - 1;
    while (secondEnd <= n - 1) {
        char * third = stringAdd(num, firstStart, firstEnd, secondStart, secondEnd);
        int thirdStart = secondEnd + 1;
        int thirdEnd = secondEnd + strlen(third);
        if (thirdEnd >= n || strncmp(num + thirdStart, third, thirdEnd - thirdStart + 1)) {
            free(third);
            break;
        }
        free(third);
        if (thirdEnd == n - 1) {
            return true;
        }
        firstStart = secondStart;
        firstEnd = secondEnd;
        secondStart = thirdStart;
        secondEnd = thirdEnd;
    }
    return false;
}


bool isAdditiveNumber(char * num){
    int n = strlen(num);
    for (int secondStart = 1; secondStart < n - 1; ++secondStart) {
        if (num[0] == '0' && secondStart != 1) {
            break;
        }
        for (int secondEnd = secondStart; secondEnd < n - 1; ++secondEnd) {
            if (num[secondStart] == '0' && secondStart != secondEnd) {
                break;
            }
            if (valid(secondStart, secondEnd, num)) {
                return true;
            }
        }
    }
    return false;
}
```

```JavaScript [sol1-JavaScript]
var isAdditiveNumber = function(num) {
    const n = num.length;
    for (let secondStart = 1; secondStart < n - 1; ++secondStart) {
        if (num[0] === '0' && secondStart !== 1) {
            break;
        }
        for (let secondEnd = secondStart; secondEnd < n - 1; ++secondEnd) {
            if (num[secondStart] === '0' && secondStart !== secondEnd) {
                break;
            }
            if (valid(secondStart, secondEnd, num)) {
                return true;
            }
        }
    }
    return false;
};

const valid = (secondStart, secondEnd, num) => {
    const n = num.length;
    let firstStart = 0, firstEnd = secondStart - 1;
    while (secondEnd <= n - 1) {
        const third = stringAdd(num, firstStart, firstEnd, secondStart, secondEnd);
        const thirdStart = secondEnd + 1;
        const thirdEnd = secondEnd + third.length;
        if (thirdEnd >= n || num.slice(thirdStart, thirdEnd + 1) !== third) {
            break;
        }
        if (thirdEnd === n - 1) {
            return true;
        }
        firstStart = secondStart;
        firstEnd = secondEnd;
        secondStart = thirdStart;
        secondEnd = thirdEnd;
    }
    return false;
}

const stringAdd = (s, firstStart, firstEnd, secondStart, secondEnd) => {
    const third = [];
    let carry = 0, cur = 0;
    while (firstEnd >= firstStart || secondEnd >= secondStart || carry !== 0) {
        cur = carry;
        if (firstEnd >= firstStart) {
            cur += s[firstEnd].charCodeAt() - '0'.charCodeAt();
            --firstEnd;
        }
        if (secondEnd >= secondStart) {
            cur += s[secondEnd].charCodeAt() - '0'.charCodeAt();
            --secondEnd;
        }
        carry = Math.floor(cur / 10);
        cur %= 10;
        third.push(String.fromCharCode(cur + '0'.charCodeAt()));
    }
    third.reverse();
    return third.join('');
}
```

```go [sol1-Golang]
func stringAdd(x, y string) string {
    res := []byte{}
    carry, cur := 0, 0
    for x != "" || y != "" || carry != 0 {
        cur = carry
        if x != "" {
            cur += int(x[len(x)-1] - '0')
            x = x[:len(x)-1]
        }
        if y != "" {
            cur += int(y[len(y)-1] - '0')
            y = y[:len(y)-1]
        }
        carry = cur / 10
        cur %= 10
        res = append(res, byte(cur)+'0')
    }
    for i, n := 0, len(res); i < n/2; i++ {
        res[i], res[n-1-i] = res[n-1-i], res[i]
    }
    return string(res)
}

func valid(num string, secondStart, secondEnd int) bool {
    n := len(num)
    firstStart, firstEnd := 0, secondStart-1
    for secondEnd <= n-1 {
        third := stringAdd(num[firstStart:firstEnd+1], num[secondStart:secondEnd+1])
        thirdStart := secondEnd + 1
        thirdEnd := secondEnd + len(third)
        if thirdEnd >= n || num[thirdStart:thirdEnd+1] != third {
            break
        }
        if thirdEnd == n-1 {
            return true
        }
        firstStart, firstEnd = secondStart, secondEnd
        secondStart, secondEnd = thirdStart, thirdEnd
    }
    return false
}

func isAdditiveNumber(num string) bool {
    n := len(num)
    for secondStart := 1; secondStart < n-1; secondStart++ {
        if num[0] == '0' && secondStart != 1 {
            break
        }
        for secondEnd := secondStart; secondEnd < n-1; secondEnd++ {
            if num[secondStart] == '0' && secondStart != secondEnd {
                break
            }
            if valid(num, secondStart, secondEnd) {
                return true
            }
        }
    }
    return false
}
```

**复杂度分析**

- 时间复杂度：$O(n^3)$，其中 $n$ 为字符串 $\textit{num}$ 的长度。需要两层循环来遍历第二个数字的起始位置和结束位置，每个这样的组合又需要 $O(n)$ 来验证合法性。

- 空间复杂度：$O(n)$，其中 $n$ 为字符串 $\textit{num}$ 的长度。在做字符串加法的时候需要 $O(n)$ 的空间来保存结果。
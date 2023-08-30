#### 方法一：找出所有的数字并分块

**思路与算法**

我们首先对给定的字符串 $\textit{number}$ 进行一次遍历，找出所有的数字，并记录在字符串 $\textit{digits}$ 中。如果使用的语言不支持可修改的字符串，也可以记录在数组中。

随后我们对 $\textit{digits}$ 进行一次遍历。在遍历的过程中，我们可以存储剩余的数字数量 $n$ 以及当前遍历到的字符位置 $\textit{pt}$：

- 当 $n>4$ 时，我们取出三个连续的字符，作为一个块；

- 当 $n \leq 4$ 时，我们根据题目的要求，将剩余的 $n$ 个字符进行分块，并结束遍历。

我们还需要在块之间添加破折号。根据使用的语言不同，可以考虑在遍历的过程中添加破折号，并在遍历完成后直接返回答案；或者在遍历结束后再添加破折号，并在遍历完成后使用 $\texttt{join()}$ API 得到答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string reformatNumber(string number) {
        string digits;
        for (char ch: number) {
            if (isdigit(ch)) {
                digits.push_back(ch);
            }
        }

        int n = digits.size();
        int pt = 0;
        string ans;
        while (n) {
            if (n > 4) {
                ans += digits.substr(pt, 3) + "-";
                pt += 3;
                n -= 3;
            }
            else {
                if (n == 4) {
                    ans += digits.substr(pt, 2) + "-" + digits.substr(pt + 2, 2);
                }
                else {
                    ans += digits.substr(pt, n);
                }
                break;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String reformatNumber(String number) {
        StringBuilder digits = new StringBuilder();
        for (int i = 0; i < number.length(); ++i) {
            char ch = number.charAt(i);
            if (Character.isDigit(ch)) {
                digits.append(ch);
            }
        }

        int n = digits.length();
        int pt = 0;
        StringBuilder ans = new StringBuilder();
        while (n > 0) {
            if (n > 4) {
                ans.append(digits.substring(pt, pt + 3) + "-");
                pt += 3;
                n -= 3;
            } else {
                if (n == 4) {
                    ans.append(digits.substring(pt, pt + 2) + "-" + digits.substring(pt + 2, pt + 4));
                } else {
                    ans.append(digits.substring(pt, pt + n));
                }
                break;
            }
        }
        return ans.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string ReformatNumber(string number) {
        StringBuilder sb = new StringBuilder();
        foreach (char ch in number) {
            if (char.IsDigit(ch)) {
                sb.Append(ch);
            }
        }

        string digits = sb.ToString();
        int n = digits.Length;
        int pt = 0;
        StringBuilder ans = new StringBuilder();
        while (n > 0) {
            if (n > 4) {
                ans.Append(digits.Substring(pt, 3) + "-");
                pt += 3;
                n -= 3;
            } else {
                if (n == 4) {
                    ans.Append(digits.Substring(pt, 2) + "-" + digits.Substring(pt + 2, 2));
                } else {
                    ans.Append(digits.Substring(pt, n));
                }
                break;
            }
        }
        return ans.ToString();
    }
}
```

```Python [sol1-Python3]
class Solution:
    def reformatNumber(self, number: str) -> str:
        digits = list()
        for ch in number:
            if ch.isdigit():
                digits.append(ch)
        
        n, pt = len(digits), 0
        ans = list()

        while n > 0:
            if n > 4:
                ans.append("".join(digits[pt:pt+3]))
                pt += 3
                n -= 3
            else:
                if n == 4:
                    ans.append("".join(digits[pt:pt+2]))
                    ans.append("".join(digits[pt+2:pt+4]))
                else:
                    ans.append("".join(digits[pt:pt+n]))
                break
        
        return "-".join(ans)
```

```C [sol1-C]
char * reformatNumber(char * number) {
    int len = strlen(number);
    char digits[len + 1];
    int pos = 0;
    for (int i = 0; i < len; i++) {
        char ch = number[i];
        if (isdigit(ch)) {
            digits[pos++] = ch;
        }
    }

    int n = pos;
    int pt = 0;
    char *ans =  (char *)malloc(sizeof(char) * n * 2);
    pos = 0;
    while (n) {
        if (n > 4) {
            strncpy(ans + pos, digits + pt, 3);
            pos += 3;
            ans[pos++] = '-';
            pt += 3;
            n -= 3;
        } else {
            if (n == 4) {
                strncpy(ans + pos, digits + pt, 2);
                pos += 2;
                ans[pos++] = '-';
                strncpy(ans + pos, digits + pt + 2, 2);
                pos += 2;
            } else {
                strncpy(ans + pos, digits + pt, n);
                pos += n;
            }
            break;
        }
    }
    ans[pos] = '\0';
    return ans;
}
```

```go [sol1-Golang]
func reformatNumber(number string) string {
    s := strings.ReplaceAll(number, " ", "")
    s = strings.ReplaceAll(s, "-", "")
    ans := []string{}
    i := 0
    for ; i+4 < len(s); i += 3 {
        ans = append(ans, s[i:i+3])
    }
    s = s[i:]
    if len(s) < 4 {
        ans = append(ans, s)
    } else {
        ans = append(ans, s[:2], s[2:])
    }
    return strings.Join(ans, "-")
}
```

```JavaScript [sol1-JavaScript]
var reformatNumber = function(number) {
    let digits = '';
    for (let i = 0; i < number.length; ++i) {
        const ch = number[i];
        if (isDigit(ch)) {
            digits += ch;
        }
    }

    let n = digits.length;
    let pt = 0;
    let ans = '';
    while (n > 0) {
        if (n > 4) {
            ans += digits.slice(pt, pt + 3) + "-";
            pt += 3;
            n -= 3;
        } else {
            if (n == 4) {
                ans += digits.slice(pt, pt + 2) + "-" + digits.slice(pt + 2, pt + 4);
            } else {
                ans += digits.slice(pt, pt + n);
            }
            break;
        }
    }
    return ans;
};

const isDigit = (ch) => {
    return parseFloat(ch).toString() === "NaN" ? false : true;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{number}$ 的长度。

- 空间复杂度：$O(n)$，即为字符串 $\textit{digits}$ 以及其它临时字符串需要使用的空间。
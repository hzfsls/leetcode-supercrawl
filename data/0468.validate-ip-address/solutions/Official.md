## [468.验证IP地址 中文官方题解](https://leetcode.cn/problems/validate-ip-address/solutions/100000/yan-zheng-ipdi-zhi-by-leetcode-solution-kge5)

#### 方法一：依次判断

**思路与算法**

我们首先查找给定的字符串 $\textit{queryIP}$ 中是否包含符号 $\text{`.'}$。如果包含，那么我们需要判断其是否为 IPv4 地址；如果不包含，我们则判断其是否为 IPv6 地址。

对于 IPv4 地址而言，它包含 $4$ 个部分，用 $\text{`.'}$ 隔开。因此我们可以存储相邻两个 $\text{`.'}$ 出现的位置 $\textit{last}$ 和 $\textit{cur}$（当考虑首个部分时，$\textit{last}=-1$；当考虑最后一个部分时，$\textit{cur}=n$，其中 $n$ 是字符串的长度），那么子串 $\textit{queryIP}[\textit{last}+1..\textit{cur}-1]$ 就对应着一个部分。我们需要判断：

- 它的长度是否在 $[1, 3]$ 之间（虽然这一步没有显式要求，但提前判断可以防止后续计算值时 $32$ 位整数无法表示的情况）；

- 它是否只包含数字；

- 它的值是否在 $[0, 255]$ 之间；

- 它是否不包含前导零。具体地，如果它的值为 $0$，那么该部分只能包含一个 $0$，即 $(\textit{cur}-1) - (\textit{last}+1) + 1 = 1$；如果它的值不为 $0$，那么该部分的第一个数字不能为 $0$，即 $\textit{queryIP}[\textit{last}+1]$ 不为 $0$。

对于 IPv6 地址而言，它包含 $8$ 个部分，用 $\text{`:'}$ 隔开。同样地，我们可以存储相邻两个 $\text{`:'}$ 出现的位置 $\textit{last}$ 和 $\textit{cur}$，那么子串 $\textit{queryIP}[\textit{last}+1..\textit{cur}-1]$ 就对应着一个部分。我们需要判断：

- 它的长度是否在 $[1, 4]$ 之间；

- 它是否只包含数字，或者 $\text{a-f}$，或者 $\text{A-F}$；

除了上述情况以外，如果我们无法找到对应数量的部分，那么给定的字符串也不是一个有效的 IP 地址。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string validIPAddress(string queryIP) {
        if (queryIP.find('.') != string::npos) {
            // IPv4
            int last = -1;
            for (int i = 0; i < 4; ++i) {
                int cur = (i == 3 ? queryIP.size() : queryIP.find('.', last + 1));
                if (cur == string::npos) {
                    return "Neither";
                }
                if (cur - last - 1 < 1 || cur - last - 1 > 3) {
                    return "Neither";
                }
                int addr = 0;
                for (int j = last + 1; j < cur; ++j) {
                    if (!isdigit(queryIP[j])) {
                        return "Neither";
                    }
                    addr = addr * 10 + (queryIP[j] - '0');
                }
                if (addr > 255) {
                    return "Neither";
                }
                if (addr > 0 && queryIP[last + 1] == '0') {
                    return "Neither";
                }
                if (addr == 0 && cur - last - 1 > 1) {
                    return "Neither";
                }
                last = cur;
            }
            return "IPv4";
        }
        else {
            // IPv6
            int last = -1;
            for (int i = 0; i < 8; ++i) {
                int cur = (i == 7 ? queryIP.size() : queryIP.find(':', last + 1));
                if (cur == string::npos) {
                    return "Neither";
                }
                if (cur - last - 1 < 1 || cur - last - 1 > 4) {
                    return "Neither";
                }
                for (int j = last + 1; j < cur; ++j) {
                    if (!isdigit(queryIP[j]) && !('a' <= tolower(queryIP[j]) && tolower(queryIP[j]) <= 'f')) {
                        return "Neither";
                    }
                }
                last = cur;
            }
            return "IPv6";
        }
    }
};
```

```Java [sol1-Java]
class Solution {
    public String validIPAddress(String queryIP) {
        if (queryIP.indexOf('.') >= 0) {
            // IPv4
            int last = -1;
            for (int i = 0; i < 4; ++i) {
                int cur = (i == 3 ? queryIP.length() : queryIP.indexOf('.', last + 1));
                if (cur < 0) {
                    return "Neither";
                }
                if (cur - last - 1 < 1 || cur - last - 1 > 3) {
                    return "Neither";
                }
                int addr = 0;
                for (int j = last + 1; j < cur; ++j) {
                    if (!Character.isDigit(queryIP.charAt(j))) {
                        return "Neither";
                    }
                    addr = addr * 10 + (queryIP.charAt(j) - '0');
                }
                if (addr > 255) {
                    return "Neither";
                }
                if (addr > 0 && queryIP.charAt(last + 1) == '0') {
                    return "Neither";
                }
                if (addr == 0 && cur - last - 1 > 1) {
                    return "Neither";
                }
                last = cur;
            }
            return "IPv4";
        } else {
            // IPv6
            int last = -1;
            for (int i = 0; i < 8; ++i) {
                int cur = (i == 7 ? queryIP.length() : queryIP.indexOf(':', last + 1));
                if (cur < 0) {
                    return "Neither";
                }
                if (cur - last - 1 < 1 || cur - last - 1 > 4) {
                    return "Neither";
                }
                for (int j = last + 1; j < cur; ++j) {
                    if (!Character.isDigit(queryIP.charAt(j)) && !('a' <= Character.toLowerCase(queryIP.charAt(j)) && Character.toLowerCase(queryIP.charAt(j)) <= 'f')) {
                        return "Neither";
                    }
                }
                last = cur;
            }
            return "IPv6";
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string ValidIPAddress(string queryIP) {
        if (queryIP.IndexOf('.') >= 0) {
            // IPv4
            int last = -1;
            for (int i = 0; i < 4; ++i) {
                int cur = (i == 3 ? queryIP.Length : queryIP.IndexOf('.', last + 1));
                if (cur < 0) {
                    return "Neither";
                }
                if (cur - last - 1 < 1 || cur - last - 1 > 3) {
                    return "Neither";
                }
                int addr = 0;
                for (int j = last + 1; j < cur; ++j) {
                    if (!char.IsDigit(queryIP[j])) {
                        return "Neither";
                    }
                    addr = addr * 10 + (queryIP[j] - '0');
                }
                if (addr > 255) {
                    return "Neither";
                }
                if (addr > 0 && queryIP[last + 1] == '0') {
                    return "Neither";
                }
                if (addr == 0 && cur - last - 1 > 1) {
                    return "Neither";
                }
                last = cur;
            }
            return "IPv4";
        } else {
            // IPv6
            int last = -1;
            for (int i = 0; i < 8; ++i) {
                int cur = (i == 7 ? queryIP.Length : queryIP.IndexOf(':', last + 1));
                if (cur < 0) {
                    return "Neither";
                }
                if (cur - last - 1 < 1 || cur - last - 1 > 4) {
                    return "Neither";
                }
                for (int j = last + 1; j < cur; ++j) {
                    if (!char.IsDigit(queryIP[j]) && !('a' <= char.ToLower(queryIP[j]) && char.ToLower(queryIP[j]) <= 'f')) {
                        return "Neither";
                    }
                }
                last = cur;
            }
            return "IPv6";
        }
    }
}
```

```Python [sol1-Python3]
class Solution:
    def validIPAddress(self, queryIP: str) -> str:
        if queryIP.find(".") != -1:
            # IPv4
            last = -1
            for i in range(4):
                cur = (len(queryIP) if i == 3 else queryIP.find(".", last + 1))
                if cur == -1:
                    return "Neither"
                if not 1 <= cur - last - 1 <= 3:
                    return "Neither"
                
                addr = 0
                for j in range(last + 1, cur):
                    if not queryIP[j].isdigit():
                        return "Neither"
                    addr = addr * 10 + int(queryIP[j])
                
                if addr > 255:
                    return "Neither"
                if addr > 0 and queryIP[last + 1] == "0":
                    return "Neither"
                if addr == 0 and cur - last - 1 > 1:
                    return "Neither"
                
                last = cur
            
            return "IPv4"
        else:
            # IPv6
            last = -1
            for i in range(8):
                cur = (len(queryIP) if i == 7 else queryIP.find(":", last + 1))
                if cur == -1:
                    return "Neither"
                if not 1 <= cur - last - 1 <= 4:
                    return "Neither"

                for j in range(last + 1, cur):
                    if not queryIP[j].isdigit() and not("a" <= queryIP[j].lower() <= "f"):
                        return "Neither"
                
                last = cur
            
            return "IPv6"
```

```C [sol1-C]
char * validIPAddress(char * queryIP) {
    int len = strlen(queryIP);
    if (strchr(queryIP, '.')) {
        // IPv4
        int last = -1;
        for (int i = 0; i < 4; ++i) {
            int cur = -1;
            if (i == 3) {
                cur = len;
            } else {
                char * p = strchr(queryIP + last + 1, '.');
                if (p) {
                    cur = p - queryIP;
                }
            }
            if (cur < 0) {
                return "Neither";
            }
            if (cur - last - 1 < 1 || cur - last - 1 > 3) {
                return "Neither";
            }
            int addr = 0;
            for (int j = last + 1; j < cur; ++j) {
                if (!isdigit(queryIP[j])) {
                    return "Neither";
                }
                addr = addr * 10 + (queryIP[j] - '0');
            }
            if (addr > 255) {
                return "Neither";
            }
            if (addr > 0 && queryIP[last + 1] == '0') {
                return "Neither";
            }
            if (addr == 0 && cur - last - 1 > 1) {
                return "Neither";
            }
            last = cur;
        }
        return "IPv4";
    }
    else {
        // IPv6
        int last = -1;
        for (int i = 0; i < 8; ++i) {
            int cur = -1;
            if (i == 7) {
                cur = len;
            } else {
                char * p = strchr(queryIP + last + 1, ':');
                if (p) {
                    cur = p - queryIP;
                }
            }
            if (cur < 0) {
                return "Neither";
            }
            if (cur - last - 1 < 1 || cur - last - 1 > 4) {
                return "Neither";
            }
            for (int j = last + 1; j < cur; ++j) {
                if (!isdigit(queryIP[j]) && !('a' <= tolower(queryIP[j]) && tolower(queryIP[j]) <= 'f')) {
                    return "Neither";
                }
            }
            last = cur;
        }
        return "IPv6";
    }
}
```

```JavaScript [sol1-JavaScript]
var validIPAddress = function(queryIP) {
    if (queryIP.indexOf('.') >= 0) {
        // IPv4
        let last = -1;
        for (let i = 0; i < 4; ++i) {
            const cur = (i === 3 ? queryIP.length : queryIP.indexOf('.', last + 1));
            if (cur < 0) {
                return "Neither";
            }
            if (cur - last - 1 < 1 || cur - last - 1 > 3) {
                return "Neither";
            }
            let addr = 0;
            for (let j = last + 1; j < cur; ++j) {
                if (!isDigit(queryIP[j])) {
                    return "Neither";
                }
                addr = addr * 10 + (queryIP[j].charCodeAt() - '0'.charCodeAt());
            }
            if (addr > 255) {
                return "Neither";
            }
            if (addr > 0 && queryIP[last + 1].charCodeAt() === '0'.charCodeAt()) {
                return "Neither";
            }
            if (addr === 0 && cur - last - 1 > 1) {
                return "Neither";
            }
            last = cur;
        }
        return "IPv4";
    } else {
        // IPv6
        let last = -1;
        for (let i = 0; i < 8; ++i) {
            const cur = (i === 7 ? queryIP.length : queryIP.indexOf(':', last + 1));
            if (cur < 0) {
                return "Neither";
            }
            if (cur - last - 1 < 1 || cur - last - 1 > 4) {
                return "Neither";
            }
            for (let j = last + 1; j < cur; ++j) {
                if (!isDigit(queryIP[j]) && !('a' <= queryIP[j].toLowerCase() && queryIP[j].toLowerCase() <= 'f')) {
                    return "Neither";
                }
            }
            last = cur;
        }
        return "IPv6";
    }
};

const isDigit = (ch) => {
    return parseFloat(ch).toString() === "NaN" ? false : true;
}
```

```go [sol1-Golang]
func validIPAddress(queryIP string) string {
    if sp := strings.Split(queryIP, "."); len(sp) == 4 {
        for _, s := range sp {
            if len(s) > 1 && s[0] == '0' {
                return "Neither"
            }
            if v, err := strconv.Atoi(s); err != nil || v > 255 {
                return "Neither"
            }
        }
        return "IPv4"
    }
    if sp := strings.Split(queryIP, ":"); len(sp) == 8 {
        for _, s := range sp {
            if len(s) > 4 {
                return "Neither"
            }
            if _, err := strconv.ParseUint(s, 16, 64); err != nil {
                return "Neither"
            }
        }
        return "IPv6"
    }
    return "Neither"
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{queryIP}$ 的长度。我们只需要遍历字符串常数次。

- 空间复杂度：$O(1)$。
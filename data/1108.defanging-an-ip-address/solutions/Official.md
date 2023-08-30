#### 方法一：直接遍历

**思路与算法**

按照题目要求，依次将字符串 $\textit{address}$ 中 $\texttt{`.'}$ 替换为 $\texttt{"[.]"}$ 即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def defangIPaddr(self, address: str) -> str:
        return address.replace('.', '[.]')
```

```Java [sol1-Java]
class Solution {
    public String defangIPaddr(String address) {
        return address.replace(".", "[.]");
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    string defangIPaddr(string address) {
        string ans;
        for (auto & c : address) {
            if (c == '.') {
                ans.append("[.]");
            } else {
                ans.push_back(c);
            }
        }
        return ans;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public string DefangIPaddr(string address) {
        return address.Replace(".", "[.]");
    }
}
```

```C [sol1-C]
char * defangIPaddr(char * address) {
    int len = strlen(address);
    int pos = 0;
    char * res = (char *)malloc(sizeof(char) * (len + 7));
    for (int i = 0; i < len; i++) {
        if (address[i] == '.') {
            pos += sprintf(res + pos, "%s", "[.]");
        } else {
            res[pos++] = address[i];
        }
    }
    res[pos] = '\0';
    return res;
}
```

```JavaScript [sol1-JavaScript]
var defangIPaddr = function(address) {
    return address.replaceAll('\.', '[.]');
};
```

```go [sol1-Golang]
func defangIPaddr(address string) string {
    return strings.ReplaceAll(address, ".", "[.]")
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 为字符串 $s$ 的长度。需要遍历一遍字符串即可。

+ 空间复杂度：$O(1)$。除返回值外，不需要额外的存储空间。
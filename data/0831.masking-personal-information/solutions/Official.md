## [831.隐藏个人信息 中文官方题解](https://leetcode.cn/problems/masking-personal-information/solutions/100000/yin-cang-ge-ren-xin-xi-by-leetcode-solut-2enf)
#### 方法一：模拟

我们首先判断 $s$ 是邮箱还是电话号码。显然，如果 $s$ 中有字符 $\text{`@'}$，那么它是邮箱，否则它是电话号码。

如果 $s$ 是邮箱，我们将 $s$ 的 $\text{`@'}$ 之前的部分保留第一个和最后一个字符，中间用 $\text{``*****"}$ 代替，并将整个字符串转换为小写。

如果 $s$ 是电话号码，我们只保留 $s$ 中的所有数字。使用首先将最后 $10$ 位本地号码变成 $\text{``***-***-XXXX"}$ 的形式，再判断 $s$ 中是否有额外的国际号码。如果有，则将国际号码之前添加 $\text{`+'}$ 号并加到本地号码的最前端。

- 如果有 $10$ 位数字，则加上前缀位空字符串。
- 如果有 $11$ 位数字，则加上前缀 $\text{``+*-"}$。
- 如果有 $12$ 位数字，则不加上前缀 $\text{``+**-"}$。
- 如果有 $13$ 位数字，则不加上前缀 $\text{``+**"}$。

```C++ [sol1-C++]
class Solution {
public:
    vector<string> country = {"", "+*-", "+**-", "+***-"};

    string maskPII(string s) {
        string res;
        int at = s.find("@");
        if (at != string::npos) {
            transform(s.begin(), s.end(), s.begin(), ::tolower);
            return s.substr(0, 1) + "*****" + s.substr(at - 1);
        }
        s = regex_replace(s, regex("[^0-9]"), "");
        return country[s.size() - 10] + "***-***-" + s.substr(s.size() - 4);
    }
};
```

```Java [sol1-Java]
class Solution {
    String[] country = {"", "+*-", "+**-", "+***-"};

    public String maskPII(String s) {
        int at = s.indexOf("@");
        if (at > 0) {
            s = s.toLowerCase();
            return (s.charAt(0) + "*****" + s.substring(at - 1)).toLowerCase();
        }
        s = s.replaceAll("[^0-9]", "");
        return country[s.length() - 10] + "***-***-" + s.substring(s.length() - 4);
    }
}
```

```C# [sol1-C#]
public class Solution {
    string[] country = {"", "+*-", "+**-", "+***-"};

    public string MaskPII(string s) {
        int at = s.IndexOf("@");
        if (at > 0) {
            s = s.ToLower();
            return (s[0] + "*****" + s.Substring(at - 1)).ToLower();
        }
        StringBuilder sb = new StringBuilder();
        foreach (char c in s) {
            if (char.IsDigit(c)) {
                sb.Append(c);
            }
        }
        s = sb.ToString();
        return country[s.Length - 10] + "***-***-" + s.Substring(s.Length - 4);
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maskPII(self, s: str) -> str:
        at = s.find('@')
        if at >= 0:
            return (s[0] + "*" * 5 + s[at - 1:]).lower()
        s = "".join(i for i in s if i.isdigit())
        return ["", "+*-", "+**-", "+***-"][len(s) - 10] + "***-***-" + s[-4:]
```

```Go [sol1-Go]
func maskPII(s string) string {
    at := strings.Index(s, "@")
    if at > 0 {
        s = strings.ToLower(s)
        return strings.ToLower(string(s[0])) + "*****" + s[at-1:]
    }
    var sb strings.Builder
    for i := 0; i < len(s); i++ {
        c := s[i]
        if unicode.IsDigit(rune(c)) {
            sb.WriteByte(c)
        }
    }
    s = sb.String()
    country := []string{"", "+*-", "+**-", "+***-"}
    return country[len(s)-10] + "***-***-" + s[len(s)-4:]
}
```

```JavaScript [sol1-JavaScript]
const country = ["", "+*-", "+**-", "+***-"];

var maskPII = function(s) {
    const at = s.indexOf("@");
        if (at > 0) {
            s = s.toLowerCase();
            return (s[0] + "*****" + s.substring(at - 1)).toLowerCase();
        }
        let sb = "";
        for (let i = 0; i < s.length; i++) {
            const c = s.charAt(i);
            if ('0' <= c && c <= '9') {
                sb += c;
            }
        }
        s = sb.toString();
        return country[s.length - 10] + "***-***-" + s.substring(s.length - 4);
};
```
```C [sol1-C]
#define MAX_STR_SIZE 16

const char* country[] = {"", "+*-", "+**-", "+***-"};

char * maskPII(char * s){
    char *at = strchr(s, '@');
    if (at != NULL) {
        for (int i = 0; s[i] != '\0'; i++) {
            s[i] = tolower(s[i]);
        }
        char *res = (char *)calloc(strlen(s) + 8, sizeof(char));
        sprintf(res, "%c%s%s",s[0], "*****", at - 1);
        return res;
    }
    char tmp[MAX_STR_SIZE];
    int pos = 0;
    for (int i = 0; s[i] != '\0'; i++) {
        if (isdigit(s[i])) {
            tmp[pos++] = s[i];
        }
    }
    tmp[pos] = '\0';
    char *res = (char *)calloc(20, sizeof(char));
    sprintf(res, "%s%s%s", country[pos - 10], "***-***-", tmp + pos - 4);
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串的长度。
- 空间复杂度：$O(n)$，其中 $n$ 是字符串的长度。
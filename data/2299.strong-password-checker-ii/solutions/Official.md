## [2299.强密码检验器 II 中文官方题解](https://leetcode.cn/problems/strong-password-checker-ii/solutions/100000/qiang-mi-ma-jian-yan-qi-ii-by-leetcode-s-p7ru)
#### 方法一：模拟

**思路与算法**

我们按照题目的要求模拟即可。

对于「它有至少 $8$ 个字符」的要求，我们可以判断给定的字符串 $\textit{password}$ 的长度是否至少为 $8$。

对于「至少包含一个小写英文字母、一个大写英文字母、一个数字、一个特殊字符」的要求，我们各自使用一个布尔变量 $\textit{hasLower}, \textit{hasUpper}, \textit{hasDigit}, \textit{hasSpecial}$ 来进行记录。我们可以对字符串 $\textit{password}$ 进行一次遍历，如果遇到某一类型的字符，就将对应的布尔变量置为 $\text{True}$。

对于英文字母和数字，我们可以使用语言自带的 API 进行判断，也可以根据它们的 ASCII 码范围进行判断；对于特殊字符，我们可以提前将所有的特殊字符放入一个哈希表中，并判断遍历到的字符是否在哈希表中即可。

对于「不包含 $2$ 个连续相同的字符」的要求，当我们遍历到字符串 $\textit{password}$ 的第 $i$ 个字符时，如果它和第 $i+1$ 个字符相同，那么我们直接返回 $\text{False}$。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool strongPasswordCheckerII(string password) {
        if (password.size() < 8) {
            return false;
        }

        unordered_set<char> specials = {'!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '+'};
        int n = password.size();
        bool hasLower = false, hasUpper = false, hasDigit = false, hasSpecial = false;
        for (int i = 0; i < n; ++i) {
            if (i != n - 1 && password[i] == password[i + 1]) {
                return false;
            }

            char ch = password[i];
            if (islower(ch)) {
                hasLower = true;
            }
            else if (isupper(ch)) {
                hasUpper = true;
            }
            else if (isdigit(ch)) {
                hasDigit = true;
            }
            else if (specials.count(ch)) {
                hasSpecial = true;
            }
        }

        return hasLower && hasUpper && hasDigit && hasSpecial;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean strongPasswordCheckerII(String password) {
        if (password.length() < 8) {
            return false;
        }

        Set<Character> specials = new HashSet<Character>() {{
            add('!');
            add('@');
            add('#');
            add('$');
            add('%');
            add('^');
            add('&');
            add('*');
            add('(');
            add(')');
            add('-');
            add('+');
        }};
        int n = password.length();
        boolean hasLower = false, hasUpper = false, hasDigit = false, hasSpecial = false;
        for (int i = 0; i < n; ++i) {
            if (i != n - 1 && password.charAt(i) == password.charAt(i + 1)) {
                return false;
            }

            char ch = password.charAt(i);
            if (Character.isLowerCase(ch)) {
                hasLower = true;
            } else if (Character.isUpperCase(ch)) {
                hasUpper = true;
            } else if (Character.isDigit(ch)) {
                hasDigit = true;
            } else if (specials.contains(ch)) {
                hasSpecial = true;
            }
        }

        return hasLower && hasUpper && hasDigit && hasSpecial;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool StrongPasswordCheckerII(string password) {
        if (password.Length < 8) {
            return false;
        }

        ISet<char> specials = new HashSet<char>() {'!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '+'};
        int n = password.Length;
        bool hasLower = false, hasUpper = false, hasDigit = false, hasSpecial = false;
        for (int i = 0; i < n; ++i) {
            if (i != n - 1 && password[i] == password[i + 1]) {
                return false;
            }

            char ch = password[i];
            if (char.IsLower(ch)) {
                hasLower = true;
            } else if (char.IsUpper(ch)) {
                hasUpper = true;
            } else if (char.IsDigit(ch)) {
                hasDigit = true;
            } else if (specials.Contains(ch)) {
                hasSpecial = true;
            }
        }

        return hasLower && hasUpper && hasDigit && hasSpecial;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def strongPasswordCheckerII(self, password: str) -> bool:
        if len(password) < 8:
            return False
        
        specials = set("!@#$%^&*()-+")
        hasLower = hasUpper = hasDigit = hasSpecial = False

        for i, ch in enumerate(password):
            if i != len(password) - 1 and password[i] == password[i + 1]:
                return False

            if ch.islower():
                hasLower = True
            elif ch.isupper():
                hasUpper = True
            elif ch.isdigit():
                hasDigit = True
            elif ch in specials:
                hasSpecial = True

        return hasLower and hasUpper and hasDigit and hasSpecial
```

```C [sol1-C]
bool strongPasswordCheckerII(char * password) {
    int n = strlen(password);
    if (n < 8) {
        return false;
    }
    char *specialChars = "!@#$%^&*()-+";
    bool specials[128];
    memset(specials, 0, sizeof(specials));
    for (int i = 0; i < specialChars[i] != '\0'; i++) {
        specials[specialChars[i]] = true;
    }
    bool hasLower = false, hasUpper = false, hasDigit = false, hasSpecial = false;
    for (int i = 0; i < n; ++i) {
        if (i != n - 1 && password[i] == password[i + 1]) {
            return false;
        }

        char ch = password[i];
        if (islower(ch)) {
            hasLower = true;
        }
        else if (isupper(ch)) {
            hasUpper = true;
        }
        else if (isdigit(ch)) {
            hasDigit = true;
        }
        else if (specials[ch]) {
            hasSpecial = true;
        }
    }
    return hasLower && hasUpper && hasDigit && hasSpecial;
}
```

```JavaScript [sol1-JavaScript]
var strongPasswordCheckerII = function(password) {
    if (password.length < 8) {
        return false;
    }

    const specials = new Set();
    specials.add('!');
    specials.add('@');
    specials.add('#');
    specials.add('$');
    specials.add('%');
    specials.add('^');
    specials.add('&');
    specials.add('*');
    specials.add('(');
    specials.add(')');
    specials.add('-');
    specials.add('+');
    const n = password.length;
    let hasLower = false, hasUpper = false, hasDigit = false, hasSpecial = false;
    for (let i = 0; i < n; ++i) {
        if (i !== n - 1 && password[i] === password[i + 1]) {
            return false;
        }

        const ch = password[i];
        if (isLowerCase(ch)) {
            hasLower = true;
        } else if (isUpperCase(ch)) {
            hasUpper = true;
        } else if (isDigit(ch)) {
            hasDigit = true;
        } else if (specials.has(ch)) {
            hasSpecial = true;
        }
    }
    return hasLower && hasUpper && hasDigit && hasSpecial;
};

const isDigit = (ch) => {
    return parseFloat(ch).toString() === "NaN" ? false : true;
}

const isLowerCase = str => 'a' <= str && str <= 'z';

const isUpperCase = str => 'A' <= str && str <= 'Z';
```

```go [sol1-Golang]
func strongPasswordCheckerII(password string) bool {
    n := len(password)
    if n < 8 {
        return false
    }

    var hasLower, hasUpper, hasDigit, hasSpecial bool
    for i, ch := range password {
        if i != n-1 && password[i] == password[i+1] {
            return false
        }
        if unicode.IsLower(ch) {
            hasLower = true
        } else if unicode.IsUpper(ch) {
            hasUpper = true
        } else if unicode.IsDigit(ch) {
            hasDigit = true
        } else if strings.ContainsRune("!@#$%^&*()-+", ch) {
            hasSpecial = true
        }
    }

    return hasLower && hasUpper && hasDigit && hasSpecial
}
```

**复杂度分析**

- 时间复杂度：$O(n + |\Sigma|)$，其中 $n$ 是字符串 $\textit{password}$ 的长度，$\Sigma$ 是特殊字符的集合。

- 空间复杂度：$O(|\Sigma|)$，即为哈希表需要使用的空间。
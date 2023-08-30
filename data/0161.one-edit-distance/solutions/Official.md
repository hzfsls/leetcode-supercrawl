#### 方法一：分情况讨论

假设字符串 $s$ 和 $t$ 的长度分别是 $m$ 和 $n$。

如果 $s$ 和 $t$ 的编辑距离为 $1$，则可能有三种情况：

- 往 $s$ 中插入一个字符得到 $t$，此时 $n - m = 1$，$t$ 比 $s$ 多一个字符，其余字符都相同；

- 从 $s$ 中删除一个字符得到 $t$，此时 $m - n = 1$，$s$ 比 $t$ 多一个字符，其余字符都相同；

- 将 $s$ 中的一个字符替换成不同的字符得到 $t$，此时 $m = n$，$s$ 和 $t$ 恰好有一个字符不同。

根据上述分析，当 $s$ 和 $t$ 的编辑距离为 $1$ 时，$s$ 和 $t$ 的长度关系可能有三种情况，分别是 $n - m = 1$、$m - n = 1$ 和 $m = n$。首先计算 $s$ 和 $t$ 的长度关系，在可能的三种情况中找到对应的一种情况，然后遍历字符串判断编辑距离是否为 $1$。

如果长度关系不符合上述三种情况，即 $|m - n| > 1$，则编辑距离不为 $1$。

具体实现方法如下。

当 $n - m = 1$ 或 $m - n = 1$ 时，由于两种情况具有对称性，因此可以定义一个函数统一计算这两种情况。用 $\textit{longer}$ 表示较长的字符串，$\textit{shorter}$ 表示较短的字符串，同时遍历两个字符串，比较对应下标处的字符是否相同，如果字符相同则将两个字符串的下标同时加 $1$，如果字符不同则只将 $\textit{longer}$ 的下标加 $1$。遍历过程中如果出现两个字符串的下标之差大于 $1$ 则不符合一次编辑，遍历结束时如果两个字符串的下标之差不大于 $1$ 则符合一次编辑。

当 $m = n$ 时，同时遍历 $s$ 和 $t$，比较相同下标处的字符是否相同。如果字符不同的下标个数等于 $1$，则编辑距离为 $1$。

```Python [sol1-Python3]
class Solution:
    def isOneEditDistance(self, s: str, t: str) -> bool:
        m, n = len(s), len(t)
        if m < n:
            return self.isOneEditDistance(t, s)
        if m - n > 1:
            return False
        foundDifference = False
        for i, (x, y) in enumerate(zip(s, t)):
            if x != y:
                foundDifference = True
                return s[i + 1:] == t[i + 1:] if m == n else s[i + 1:] == t[i:]  # 注：改用下标枚举可达到 O(1) 空间复杂度
        return foundDifference or m - n == 1
```

```Java [sol1-Java]
class Solution {
    public boolean isOneEditDistance(String s, String t) {
        int m = s.length(), n = t.length();
        if (n - m == 1) {
            return isOneInsert(s, t);
        } else if (m - n == 1) {
            return isOneInsert(t, s);
        } else if (m == n) {
            boolean foundDifference = false;
            for (int i = 0; i < m; i++) {
                if (s.charAt(i) != t.charAt(i)) {
                    if (!foundDifference) {
                        foundDifference = true;
                    } else {
                        return false;
                    }
                }
            }
            return foundDifference;
        } else {
            return false;
        }
    }

    public boolean isOneInsert(String shorter, String longer) {
        int length1 = shorter.length(), length2 = longer.length();
        int index1 = 0, index2 = 0;
        while (index1 < length1 && index2 < length2) {
            if (shorter.charAt(index1) == longer.charAt(index2)) {
                index1++;
            }
            index2++;
            if (index2 - index1 > 1) {
                return false;
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool IsOneEditDistance(string s, string t) {
        int m = s.Length, n = t.Length;
        if (n - m == 1) {
            return IsOneInsert(s, t);
        } else if (m - n == 1) {
            return IsOneInsert(t, s);
        } else if (m == n) {
            bool foundDifference = false;
            for (int i = 0; i < m; i++) {
                if (s[i] != t[i]) {
                    if (!foundDifference) {
                        foundDifference = true;
                    } else {
                        return false;
                    }
                }
            }
            return foundDifference;
        } else {
            return false;
        }
    }

    public bool IsOneInsert(string shorter, string longer) {
        int length1 = shorter.Length, length2 = longer.Length;
        int index1 = 0, index2 = 0;
        while (index1 < length1 && index2 < length2) {
            if (shorter[index1] == longer[index2]) {
                index1++;
            }
            index2++;
            if (index2 - index1 > 1) {
                return false;
            }
        }
        return true;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool isOneEditDistance(string s, string t) {
        int m = s.size(), n = t.size();
        if (n - m == 1) {
            return isOneInsert(s, t);
        } else if (m - n == 1) {
            return isOneInsert(t, s);
        } else if (m == n) {
            bool foundDifference = false;
            for (int i = 0; i < m; i++) {
                if (s[i] != t[i]) {
                    if (!foundDifference) {
                        foundDifference = true;
                    } else {
                        return false;
                    }
                }
            }
            return foundDifference;
        } else {
            return false;
        }
    }

    bool isOneInsert(string shorter, string longer) {
        int length1 = shorter.size(), length2 = longer.size();
        int index1 = 0, index2 = 0;
        while (index1 < length1 && index2 < length2) {
            if (shorter[index1] == longer[index2]) {
                index1++;
            }
            index2++;
            if (index2 - index1 > 1) {
                return false;
            }
        }
        return true;
    }
};
```

```C [sol1-C]
bool isOneInsert(const char * shorter, const char * longer) {
    int length1 = strlen(shorter), length2 = strlen(longer);
    int index1 = 0, index2 = 0;
    while (index1 < length1 && index2 < length2) {
        if (shorter[index1] == longer[index2]) {
            index1++;
        }
        index2++;
        if (index2 - index1 > 1) {
            return false;
        }
    }
    return true;
}

bool isOneEditDistance(char* s, char* t) {
    int m = strlen(s), n = strlen(t);
    if (n - m == 1) {
        return isOneInsert(s, t);
    } else if (m - n == 1) {
        return isOneInsert(t, s);
    } else if (m == n) {
        bool foundDifference = false;
        for (int i = 0; i < m; i++) {
            if (s[i] != t[i]) {
                if (!foundDifference) {
                    foundDifference = true;
                } else {
                    return false;
                }
            }
        }
        return foundDifference;
    } else {
        return false;
    }
}
```

```go [sol1-Golang]
func isOneEditDistance(s, t string) bool {
    m, n := len(s), len(t)
    if m < n {
        return isOneEditDistance(t, s)
    }
    if m-n > 1 {
        return false
    }
    foundDifference := false
    for i, ch := range t {
        if s[i] != byte(ch) {
            foundDifference = true
            if m == n {
                return s[i+1:] == t[i+1:]
            }
            return s[i+1:] == t[i:]
        }
    }
    return foundDifference || m-n == 1
}
```

```JavaScript [sol1-JavaScript]
var isOneEditDistance = function(s, t) {
    const m = s.length, n = t.length;
    if (n - m === 1) {
        return isOneInsert(s, t);
    } else if (m - n === 1) {
        return isOneInsert(t, s);
    } else if (m === n) {
        let foundDifference = false;
        for (let i = 0; i < m; i++) {
            if (s[i] != t[i]) {
                if (!foundDifference) {
                    foundDifference = true;
                } else {
                    return false;
                }
            }
        }
        return foundDifference;
    } else {
        return false;
    }
}

const isOneInsert = (shorter, longer) => {
    const length1 = shorter.length, length2 = longer.length;
    let index1 = 0, index2 = 0;
    while (index1 < length1 && index2 < length2) {
        if (shorter[index1] == longer[index2]) {
            index1++;
        }
        index2++;
        if (index2 - index1 > 1) {
            return false;
        }
    }
    return true;
};
```

**复杂度分析**

- 时间复杂度：$O(m + n)$，其中 $m$ 和 $n$ 分别是字符串 $s$ 和 $t$ 的长度。当 $|m - n| \le 1$ 时，需要遍历两个字符串各一次。

- 空间复杂度：$O(1)$。
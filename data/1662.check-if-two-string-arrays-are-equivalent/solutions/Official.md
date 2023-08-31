## [1662.检查两个字符串数组是否相等 中文官方题解](https://leetcode.cn/problems/check-if-two-string-arrays-are-equivalent/solutions/100000/jian-cha-liang-ge-zi-fu-chuan-shu-zu-shi-9iuo)

#### 方法一：拼接字符串进行对比

**思路与算法**

将 $\textit{word1}$ 和 $\textit{word2}$ 按顺序拼接成两个字符串，进行比较即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def arrayStringsAreEqual(self, word1: List[str], word2: List[str]) -> bool:
        return ''.join(word1) == ''.join(word2)
```

```C++ [sol1-C++]
class Solution {
public:
    string join(vector<string>& words) {
        string ret = "";
        for (auto &s : words) {
            ret += s;
        }
        return ret;
    }

    bool arrayStringsAreEqual(vector<string>& word1, vector<string>& word2) {
        return join(word1) == join(word2);
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean arrayStringsAreEqual(String[] word1, String[] word2) {
        return join(word1).equals(join(word2));
    }

    public String join(String[] words) {
        StringBuilder ret = new StringBuilder();
        for (String s : words) {
            ret.append(s);
        }
        return ret.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool ArrayStringsAreEqual(string[] word1, string[] word2) {
        return Join(word1).Equals(Join(word2));
    }

    public string Join(string[] words) {
        StringBuilder ret = new StringBuilder();
        foreach (string s in words) {
            ret.Append(s);
        }
        return ret.ToString();
    }
}
```

```go [sol1-Golang]
func arrayStringsAreEqual(word1, word2 []string) bool {
    return strings.Join(word1, "") == strings.Join(word2, "")
}
```

```JavaScript [sol1-JavaScript]
var arrayStringsAreEqual = function(word1, word2) {
    return join(word1) === join(word2);
}

const join = (words) => {
    let ret = '';
    for (const s of words) {
        ret += s;
    }
    return ret;
};
```

```C [sol1-C]
#define MAX_STR_LEN 1000

char * join(char ** word, int wordSize) {
    char *str = (char *)malloc(sizeof(char) * wordSize * MAX_STR_LEN + 1);
    int pos = 0;
    for (int i = 0; i < wordSize; i++) {
        pos += sprintf(str + pos, "%s", word[i]);
    }
    return str;
}

bool arrayStringsAreEqual(char ** word1, int word1Size, char ** word2, int word2Size) {
    char *str1 = join(word1, word1Size);
    char *str2 = join(word2, word2Size);
    bool ret = strcmp(str1, str2) == 0;
    free(str1);
    free(str2);
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n + m)$，其中 $n$ 和 $m$ 分别是 $\sum \textit{word1}[i].\textit{length}$ 和 $\sum {word2}[i].\textit{length}$。

- 空间复杂度：$O(n + m)$，其中 $n$ 和 $m$ 分别是 $\sum \textit{word1}[i].\textit{length}$ 和 $\sum {word2}[i].\textit{length}$。

#### 方法二：遍历

**思路与算法**

更进一步的想法，我们可以直接在 $\textit{word1}$ 和 $\textit{word2}$ 上进行对比，避免额外创建字符串。

设置两个指针 $\textit{p1}$ 和 $\textit{p2}$ 分别表示遍历到了 $\textit{word1}[\textit{p1}]$ 和 $\textit{word2}[\textit{p2}]$，另外还需设置两个指针 $i$ 和 $j$，表示正在对比 $\textit{word1}[\textit{p1}][i]$ 和 $\textit{word2}[\textit{p2}][j]$。

如果 $\textit{word1}[\textit{p1}][i] \neq \textit{word2}[\textit{p2}][j]$，则直接返回 $\textit{false}$。否则 $i + 1$，当 $i = \textit{word1}[\textit{p1}].length$ 时，表示对比到当前字符串末尾，需要将 $\textit{p1} + 1$，$i$ 赋值为 $0$。$j$ 和 $\textit{p2}$ 同理。

当 $\textit{p1} \lt \textit{word1}.length$ 或者 $\textit{p2} \lt \textit{word2}.length$ 不满足时，算法结束。最终两个数组相等条件即为 $\textit{p1} = \textit{word1}.length$ 并且 $\textit{p2} = \textit{word2}.length$。

**代码**

```Python [sol2-Python3]
class Solution:
    def arrayStringsAreEqual(self, word1: List[str], word2: List[str]) -> bool:
        p1 = p2 = i = j = 0
        while p1 < len(word1) and p2 < len(word2):
            if word1[p1][i] != word2[p2][j]:
                return False
            i += 1
            if i == len(word1[p1]):
                p1 += 1
                i = 0
            j += 1
            if j == len(word2[p2]):
                p2 += 1
                j = 0
        return p1 == len(word1) and p2 == len(word2)
```

```C++ [sol2-C++]
class Solution {
public:
    bool arrayStringsAreEqual(vector<string>& word1, vector<string>& word2) {
        int p1 = 0, p2 = 0, i = 0, j = 0;
        while (p1 < word1.size() && p2 < word2.size()) {
            if (word1[p1][i] != word2[p2][j]) {
                return false;
            }
            i++;
            if (i == word1[p1].size()) {
                p1++;
                i = 0;
            }
            j++;
            if (j == word2[p2].size()) {
                p2++;
                j = 0;
            }
        }
        return p1 == word1.size() && p2 == word2.size();
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean arrayStringsAreEqual(String[] word1, String[] word2) {
        int p1 = 0, p2 = 0, i = 0, j = 0;
        while (p1 < word1.length && p2 < word2.length) {
            if (word1[p1].charAt(i) != word2[p2].charAt(j)) {
                return false;
            }
            i++;
            if (i == word1[p1].length()) {
                p1++;
                i = 0;
            }
            j++;
            if (j == word2[p2].length()) {
                p2++;
                j = 0;
            }
        }
        return p1 == word1.length && p2 == word2.length;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool ArrayStringsAreEqual(string[] word1, string[] word2) {
        int p1 = 0, p2 = 0, i = 0, j = 0;
        while (p1 < word1.Length && p2 < word2.Length) {
            if (word1[p1][i] != word2[p2][j]) {
                return false;
            }
            i++;
            if (i == word1[p1].Length) {
                p1++;
                i = 0;
            }
            j++;
            if (j == word2[p2].Length) {
                p2++;
                j = 0;
            }
        }
        return p1 == word1.Length && p2 == word2.Length;
    }
}
```

```go [sol2-Golang]
func arrayStringsAreEqual(word1, word2 []string) bool {
    var p1, p2, i, j int
    for p1 < len(word1) && p2 < len(word2) {
        if word1[p1][i] != word2[p2][j] {
            return false
        }
        i++
        if i == len(word1[p1]) {
            p1++
            i = 0
        }

        j++
        if j == len(word2[p2]) {
            p2++
            j = 0
        }
    }
    return p1 == len(word1) && p2 == len(word2)
}
```

```JavaScript [sol2-JavaScript]
var arrayStringsAreEqual = function(word1, word2) {
    let p1 = 0, p2 = 0, i = 0, j = 0;
    while (p1 < word1.length && p2 < word2.length) {
        if (word1[p1][i] !== word2[p2][j]) {
            return false;
        }
        i++;
        if (i === word1[p1].length) {
            p1++;
            i = 0;
        }
        j++;
        if (j === word2[p2].length) {
            p2++;
            j = 0;
        }
    }
    return p1 == word1.length && p2 == word2.length;
};
```

```C [sol2-C]
bool arrayStringsAreEqual(char ** word1, int word1Size, char ** word2, int word2Size) {
    int p1 = 0, p2 = 0, i = 0, j = 0;
    while (p1 < word1Size && p2 < word2Size) {
        if (word1[p1][i] != word2[p2][j]) {
            return false;
        }
        i++;
        if (word1[p1][i] == '\0') {
            p1++;
            i = 0;
        }
        j++;
        if (word2[p2][j] == '\0') {
            p2++;
            j = 0;
        }
    }
    return p1 == word1Size && p2 == word2Size;
}
```

**复杂度分析**

- 时间复杂度：$O(n + m)$，其中 $n$ 和 $m$ 分别是 $\sum \textit{word1}[i].\textit{length}$ 和 $\sum {word2}[i].\textit{length}$。

- 空间复杂度：$O(1)$。算法只使用了常数个变量来表示指针。
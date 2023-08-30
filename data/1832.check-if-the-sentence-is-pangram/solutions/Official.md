#### 方法一：数组

**思路与算法**

因为 $\textit{sentence}$ 仅由小写英文字母组成，所以我们用一个长度为 $26$ 的数组 $\textit{exist}$ 来记录每种字符是否出现即可。

具体的，我们遍历 $\textit{sentence}$ 中的每个字符 $c$，如果 $c$ 是字母表中的第 $i~(0 \le i \lt 26)$ 个字母，就将 $\textit{exist}[i]$ 置为 $\textit{true}$。最后检查 $\textit{exist}$ 中是否存在 $\textit{false}$，如果存在返回 $\textit{false}$，否则返回 $\textit{true}$。

**代码**

```Python [sol1-Python3]
class Solution:
    def checkIfPangram(self, sentence: str) -> bool:
        exist = [False] * 26
        for c in sentence:
            exist[ord(c) - ord('a')] = True
        return all(exist)
```

```C++ [sol1-C++]
class Solution {
public:
    bool checkIfPangram(string sentence) {
        vector<int> exist(26);
        for (auto c : sentence) {
            exist[c - 'a'] = true;
        }
        for (auto x : exist) {
            if (x == 0) {
                return false;
            }
        }
        return true;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean checkIfPangram(String sentence) {
        boolean[] exist = new boolean[26];
        for (int i = 0; i < sentence.length(); i++) {
            char c = sentence.charAt(i);
            exist[c - 'a'] = true;
        }
        for (boolean x : exist) {
            if (!x) {
                return false;
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool CheckIfPangram(string sentence) {
        bool[] exist = new bool[26];
        foreach (char c in sentence) {
            exist[c - 'a'] = true;
        }
        foreach (bool x in exist) {
            if (!x) {
                return false;
            }
        }
        return true;
    }
}
```

```go [sol1-Golang]
func checkIfPangram(sentence string) bool {
    exist := [26]bool{}
    for _, c := range sentence {
        exist[c-'a'] = true
    }
    for _, b := range exist {
        if !b {
            return false
        }
    }
    return true
}
```

```JavaScript [sol1-JavaScript]
var checkIfPangram = function(sentence) {
    const exist = new Array(26).fill(0);
    for (let i = 0; i < sentence.length; i++) {
        const c = sentence[i];
        exist[c.charCodeAt() - 'a'.charCodeAt()] = true;
    }
    for (const x of exist) {
        if (!x) {
            return false;
        }
    }
    return true;
};
```

```C [sol1-C]
bool checkIfPangram(char * sentence) {
    int exist[26];
    memset(exist, 0, sizeof(exist));
    for (int i = 0; sentence[i] != '\0'; i++) {
        exist[sentence[i] - 'a'] = 1;
    }
    for (int i = 0; i < 26; i++) {
        if (exist[i] == 0) {
            return false;
        }
    }
    return true;
}
```

**复杂度分析**

- 时间复杂度：$O(n + C)$，其中 $n$ 是 $\textit{sentence}$ 的长度，$C$ 是字符集的大小（即小写字母的个数）。整个过程只需要遍历一次 $\textit{sentence}$ 和 $\textit{exist}$。

- 空间复杂度：$O(C)$，其中 $C$ 为字符集大小。

#### 方法二：二进制表示集合

**思路与算法**

使用数组记录每种字符是否出现仍然需要 $O(C)$ 的空间复杂度。由于字符集仅有 $26$ 个，我们可以使用一个长度为 $26$ 的二进制数字来表示字符集合，这个二进制数字使用 $32$ 位带符号整型变量即可。

二进制数字的第 $i$ 位对应字符集中的第 $i$ 个字符，例如 $0$ 对应 $a$，$1$ 对应 $b$，$23$ 对应 $x$ 等。

初始化整型变量 $\textit{exist}$ 为 $0$，遍历 $\textit{sentence}$ 中的每个字符 $c$，如果 $c$ 是字母表中的第 $i~(0 \le i \lt 26)$ 个字母，就将 $\textit{exist}$ 的二进制表示中第 $i$ 位赋值为 $1$。在实现过程中，将 $exist$ 与 $2^i$ 做或运算，$2^i$ 可以用左移运算实现。

最后，我们需要判断 $\textit{exist}$ 是否等于 $2^{26} - 1$，这个数字的第 $0 \sim 25$ 位都为 $1$，其余位为 $0$。如果等于，返回 $\textit{true}$，否则返回 $\textit{false}$。

**代码**

```Python [sol2-Python3]
class Solution:
    def checkIfPangram(self, sentence: str) -> bool:
        state = 0
        for c in sentence:
            state |= 1 << (ord(c) - ord('a'))
        return state == (1 << 26) - 1
```

```C++ [sol2-C++]
class Solution {
public:
    bool checkIfPangram(string sentence) {
        int state = 0;
        for (auto c : sentence) {
            state |= 1 << (c - 'a');
        }
        return state == (1 << 26) - 1;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean checkIfPangram(String sentence) {
        int state = 0;
        for (int i = 0; i < sentence.length(); i++) {
            char c = sentence.charAt(i);
            state |= 1 << (c - 'a');
        }
        return state == (1 << 26) - 1;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool CheckIfPangram(string sentence) {
        int state = 0;
        foreach (char c in sentence) {
            state |= 1 << (c - 'a');
        }
        return state == (1 << 26) - 1;
    }
}
```

```go [sol2-Golang]
func checkIfPangram(sentence string) bool {
    state := 0
    for _, c := range sentence {
        state |= 1 << (c - 'a')
    }
    return state == 1<<26-1
}
```

```JavaScript [sol2-JavaScript]
var checkIfPangram = function(sentence) {
    let state = 0;
    for (let i = 0; i < sentence.length; i++) {
        const c = sentence[i];
        state |= 1 << (c.charCodeAt() - 'a'.charCodeAt());
    }
    return state == (1 << 26) - 1;
};
```

```C [sol2-C]
bool checkIfPangram(char * sentence) {
    int state = 0;
    for (int i = 0; sentence[i] != '\0'; i++) {
        state |= 1 << (sentence[i] - 'a');
    }
    return state == (1 << 26) - 1;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{sentence}$ 的长度。整个过程只需要遍历一次 $\textit{sentence}$。

- 空间复杂度：$O(1)$。只使用到常数个变量。
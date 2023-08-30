#### 方法一：哈希表

**思路与算法**

我们可以使用一个哈希表记录每个字母是否出现过。

具体地，我们对字符串 $s$ 进行一次遍历。当遍历到字母 $c$ 时，如果哈希表中包含 $c$，我们返回 $c$ 作为答案即可；否则，我们将 $c$ 加入哈希表。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    char repeatedCharacter(string s) {
        unordered_set<char> seen;
        for (char ch: s) {
            if (seen.count(ch)) {
                return ch;
            }
            seen.insert(ch);
        }
        // impossible
        return ' ';
    }
};
```

```Java [sol1-Java]
class Solution {
    public char repeatedCharacter(String s) {
        Set<Character> seen = new HashSet<Character>();
        for (int i = 0; i < s.length(); i++) {
            char ch = s.charAt(i);
            if (!seen.add(ch)) {
                return ch;
            }
        }
        // impossible
        return ' ';
    }
}
```

```C# [sol1-C#]
public class Solution {
    public char RepeatedCharacter(string s) {
        ISet<char> seen = new HashSet<char>();
        foreach (char ch in s) {
            if (!seen.Add(ch)) {
                return ch;
            }
        }
        // impossible
        return ' ';
    }
}
```

```Python [sol1-Python3]
class Solution:
    def repeatedCharacter(self, s: str) -> str:
        seen = set()
        for ch in s:
            if ch in seen:
                return ch
            seen.add(ch)
```

```C [sol1-C]
char repeatedCharacter(char * s) {
    int seen[26];
    memset(seen, 0, sizeof(seen));
    for (int i = 0; s[i] != '\0'; i++) {
        if (seen[s[i] - 'a'] > 0) {
            return s[i];
        }
        seen[s[i] - 'a'] = 1;
    }
    return ' ';
}
```

```JavaScript [sol1-JavaScript]
var repeatedCharacter = function(s) {
    const seen = new Set();
    for (let i = 0; i < s.length; i++) {
        const ch = s[i];
        if (seen.has(ch)) {
            return ch;
        }
        seen.add(ch);
    }
    // impossible
    return ' ';
};
```

```go [sol1-Golang]
func repeatedCharacter(s string) byte {
	seen := map[rune]bool{}
	for _, c := range s {
		if seen[c] {
			return byte(c)
		}
		seen[c] = true
	}
	return 0 // impossible
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。

- 空间复杂度：$O(|\Sigma|)$，其中 $\Sigma$ 是字符集，在本题中字符串只包含小写字母，因此 $|\Sigma|=26$。即为哈希表需要使用的空间。

#### 方法二：状态压缩

**思路与算法**

注意到字符集的大小为 $26$，因此我们可以使用一个 $32$ 位的二进制数 $\textit{seen}$ 完美地存储哈希表。如果 $\textit{seen}$ 的第 $i~(0 \leq i < 26)$ 位是 $1$，说明第 $i$ 个小写字母已经出现过。

具体地，我们对字符串 $s$ 进行一次遍历。当遍历到字母 $c$ 时，记它是第 $i$ 个字母，$\textit{seen}$ 的第 $i~(0 \leq i < 26)$ 位是 $1$，我们返回 $c$ 作为答案即可；否则，我们将 $\textit{seen}$ 的第 $i$ 位置为 $1$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    char repeatedCharacter(string s) {
        int seen = 0;
        for (char ch: s) {
            int x = ch - 'a';
            if (seen & (1 << x)) {
                return ch;
            }
            seen |= (1 << x);
        }
        // impossible
        return ' ';
    }
};
```

```Java [sol2-Java]
class Solution {
    public char repeatedCharacter(String s) {
        int seen = 0;
        for (int i = 0; i < s.length(); i++) {
            char ch = s.charAt(i);
            int x = ch - 'a';
            if ((seen & (1 << x)) != 0) {
                return ch;
            }
            seen |= (1 << x);
        }
        // impossible
        return ' ';
    }
}
```

```C# [sol2-C#]
public class Solution {
    public char RepeatedCharacter(string s) {
        int seen = 0;
        foreach (char ch in s) {
            int x = ch - 'a';
            if ((seen & (1 << x)) != 0) {
                return ch;
            }
            seen |= (1 << x);
        }
        // impossible
        return ' ';
    }
}
```

```Python [sol2-Python3]
class Solution:
    def repeatedCharacter(self, s: str) -> str:
        seen = 0
        for ch in s:
            x = ord(ch) - ord("a")
            if seen & (1 << x):
                return ch
            seen |= (1 << x)
```

```C [sol2-C]
char repeatedCharacter(char * s) {
    int seen = 0;
    for (int i = 0; s[i] != '\0'; i++) {
        int x = s[i] - 'a';
        if (seen & (1 << x)) {
            return s[i];
        }
        seen |= (1 << x);
    }
    // impossible
    return ' ';
}
```

```JavaScript [sol2-JavaScript]
var repeatedCharacter = function(s) {
    let seen = 0;
    for (let i = 0; i < s.length; i++) {
        const ch = s[i];
        const x = ch.charCodeAt() - 'a'.charCodeAt();
        if ((seen & (1 << x)) !== 0) {
            return ch;
        }
        seen |= (1 << x);
    }
    // impossible
    return ' ';
};
```

```go [sol2-Golang]
func repeatedCharacter(s string) byte {
	seen := 0
	for _, c := range s {
		if seen>>(c-'a')&1 > 0 {
			return byte(c)
		}
		seen |= 1 << (c - 'a')
	}
	return 0 // impossible
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。

- 空间复杂度：$O(1)$。
## [2325.解密消息 中文官方题解](https://leetcode.cn/problems/decode-the-message/solutions/100000/jie-mi-xiao-xi-by-leetcode-solution-wckx)

#### 方法一：模拟

**思路与算法**

我们根据题目的要求进行模拟即可。

具体地，我们使用一个哈希表存储替换表，随后对字符串 $\textit{key}$ 进行遍历。当我们遍历到一个不为空格且未在哈希表中出现的字母时，就将当前字母和 $\textit{cur}$ 作为键值对加入哈希表中。这里的 $\textit{cur}$ 即为替换之后的字母，它的初始值为字母 $\text{`a'}$，当哈希表中每添加一个键值对后，$\textit{cur}$ 就会变为下一个字母。

在这之后，我们再对字符串 $\textit{message}$ 进行遍历，就可以得到答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string decodeMessage(string key, string message) {
        char cur = 'a';
        unordered_map<char, char> rules;

        for (char c: key) {
            if (c != ' ' && !rules.count(c)) {
                rules[c] = cur;
                ++cur;
            }
        }

        for (char& c: message) {
            if (c != ' ') {
                c = rules[c];
            }
        }

        return message;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String decodeMessage(String key, String message) {
        char cur = 'a';
        Map<Character, Character> rules = new HashMap<Character, Character>();

        for (int i = 0; i < key.length(); ++i) {
            char c = key.charAt(i);
            if (c != ' ' && !rules.containsKey(c)) {
                rules.put(c, cur);
                ++cur;
            }
        }

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < message.length(); ++i) {
            char c = message.charAt(i);
            if (c != ' ') {
                c = rules.get(c);
            }
            sb.append(c);
        }

        return sb.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string DecodeMessage(string key, string message) {
        char cur = 'a';
        IDictionary<char, char> rules = new Dictionary<char, char>();

        foreach (char c in key) {
            if (c != ' ' && !rules.ContainsKey(c)) {
                rules.Add(c, cur);
                ++cur;
            }
        }

        StringBuilder sb = new StringBuilder();
        foreach (char c in message) {
            if (c != ' ') {
                sb.Append(rules[c]);
            } else {
                sb.Append(c);
            }
        }

        return sb.ToString();
    }
}
```

```Python [sol1-Python3]
class Solution:
    def decodeMessage(self, key: str, message: str) -> str:
        cur = "a"
        rules = dict()

        for c in key:
            if c != " " and c not in rules:
                rules[c] = cur
                cur = chr(ord(cur) + 1)

        ans = "".join(rules.get(c, " ") for c in message)
        return ans
```

```C [sol1-C]
char * decodeMessage(char * key, char * message){
    char cur = 'a';
    char rules[26];
    memset(rules, 0, sizeof(rules));

    for (int i = 0; key[i] != '\0'; i++) {
        char c = key[i];
        if (c != ' ' && !rules[c - 'a']) {
            rules[c - 'a'] = cur;
            ++cur;
        }
    }

    for (int i = 0; message[i] != '\0'; i++) {
        char c = message[i];
        if (c != ' ') {
            message[i] = rules[c - 'a'];
        }
    }

    return message;
}
```

```go [sol1-Golang]
func decodeMessage(key string, message string) string {
    cur := byte('a')
    rules := map[rune]byte{}

    for _, c := range key {
        if c != ' ' && rules[c] == 0 {
            rules[c] = cur
            cur++
        }
    }

    m := []byte(message)
    for i, c := range message {
        if c != ' ' {
            m[i] = rules[c]
        }
    }

    return string(m)
}
```

```JavaScript [sol1-JavaScript]
var decodeMessage = function(key, message) {
    let cur = 'a';
    const rules = new Map();

    for (let i = 0; i < key.length; ++i) {
        const c = key[i];
        if (c !== ' ' && !rules.has(c)) {
            rules.set(c, cur);
            cur = String.fromCharCode(cur.charCodeAt() + 1);
        }
    }

    let ret = '';
    for (let i = 0; i < message.length; ++i) {
        let c = message[i];
        if (c !== ' ') {
            c = rules.get(c);
        }
        ret += c;
    }

    return ret;
};
```

**复杂度分析**

- 时间复杂度：$O(m+n)$，其中 $m$ 和 $n$ 分别是字符串 $\textit{key}$ 和 $\textit{message}$ 的长度。

- 空间复杂度：$O(|\Sigma|)$ 或者 $O(n + |\Sigma|)$，其中 $\Sigma$ 是字符集，在本题中 $|\Sigma|=26$。哈希表需要使用 $O(|\Sigma|)$ 的空间。此外，如果我们使用的语言不能对字符串进行修改，就需要额外 $O(n)$ 的空间存储答案的临时表示；否则可以在给定的字符串 $\textit{message}$ 上进行修改。
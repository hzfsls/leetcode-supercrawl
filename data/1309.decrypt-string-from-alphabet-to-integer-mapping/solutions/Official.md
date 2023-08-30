#### 方法一：遍历

我们对字符串 `s` 进行顺序遍历。

当遍历到位置 `i` 时，我们首先向后看两个字符（即 `s[i + 2]`），如果 `s[i + 2]` 存在且为 `'#'`，那么位置 `i`，`i + 1` 和 `i + 2` 表示一个 `'j'` 到 `'z'` 之间的字符，否则位置 `i` 表示一个 `'a'` 到 `'i'` 的字符。

根据对 `s[i + 2]` 的判断，我们可以使用字符串转整数的方法得到对应的字符的 ASCII 码，从而得到字符本身。在这之后，我们将位置 `i` 后移，继续进行遍历直到结束。

```C++ [sol1-C++]
class Solution {
public:
    string freqAlphabets(string s) {
        string ans;
        for (int i = 0; i < s.size(); ++i) {
            if (i + 2 < s.size() && s[i + 2] == '#') {
                ans += char((s[i] - '0') * 10 + (s[i + 1] - '1') + 'a');
                i += 2;
            }
            else {
                ans += char(s[i] - '1' + 'a');
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def freqAlphabets(self, s: str) -> str:
        def get(st):
            return chr(int(st) + 96)

        i, ans = 0, ""
        while i < len(s):
            if i + 2 < len(s) and s[i + 2] == '#':
                ans += get(s[i : i + 2])
                i += 2
            else:
                ans += get(s[i])
            i += 1
        return ans
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是字符串 `s` 的长度。

- 空间复杂度：$O(1)$。
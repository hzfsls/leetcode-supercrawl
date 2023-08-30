**方法一：模拟**

我们首先将输入的字符串 `num` 从十进制转换为十六进制，随后我们遍历该十六进制数的每一位，如果它不在 `"01ABCDEF"` 中，则返回 `"ERROR"`，否则根据题目要求，将 `"0"` 变为 `"O"`，`"1"` 变为 `"I"`，其余字母不变。

注意到常用的语言提供的十进制转十六进制的 API，大多会将十进制数转换为包含小写字母的十六进制字符串，因此我们需要将其中的小写字母替换成大写字母。

```C++ [sol1]
class Solution {
public:
    string toHexspeak(string num) {
        stringstream ss;
        ss << hex << stol(num);
        string num_hex = ss.str();
        unordered_map<char, char> transform = {
            {'0', 'O'},
            {'1', 'I'},
            {'a', 'A'},
            {'b', 'B'},
            {'c', 'C'},
            {'d', 'D'},
            {'e', 'E'},
            {'f', 'F'},
        };

        string ans;
        for (char ch: num_hex) {
            if (!transform.count(ch)) {
                return "ERROR";
            }
            ans += transform[ch];
        }
        return ans;
    }
};
```

```Python [sol1]
class Solution:
    def toHexspeak(self, num: str) -> str:
        num_hex = hex(int(num))[2:]
        transform = {
            "0": "O",
            "1": "I",
            "a": "A",
            "b": "B",
            "c": "C",
            "d": "D",
            "e": "E",
            "f": "F",
        }
        
        ans = ""
        for ch in num_hex:
            if ch not in transform:
                return "ERROR"
            ans += transform[ch]
        return ans
```

**复杂度分析**

- 时间复杂度：$O(|N|)$，其中 $|N|$ 是 $N$ 的数位个数。

- 空间复杂度：$O(1)$，需要替换的的数组或字母为 `"01ABCDEF"`，因此代码中需要存储 `8` 个映射，可以将空间复杂度视为 $O(1)$。
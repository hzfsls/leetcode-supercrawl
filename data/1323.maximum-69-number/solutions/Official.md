#### 方法一：模拟

现在把 `9` 翻转成 `6` 是不合理的，因为它会使得数字变小。因此我们应当找到 `num` 中最高位的 `6`，将其翻转成 `9`。

```C++ [sol1-C++]
class Solution {
public:
    int maximum69Number(int num) {
        string s = to_string(num);
        for (char& ch: s) {
            if (ch == '6') {
                ch = '9';
                break;
            }
        }
        return stoi(s);
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maximum69Number(self, num: int) -> int:
        return int(str(num).replace("6", "9", 1))
```

**复杂度分析**

- 时间复杂度：$O(\log \textit{num})$，表示 $\textit{num}$ 的位数。

- 空间复杂度：$O(\log \textit{num})$。为了代码编写方便，我们使用额外的字符串来存储 $\textit{num}$，使得可以直接修改特定位置的数字。
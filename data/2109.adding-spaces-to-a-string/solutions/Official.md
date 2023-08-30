#### 方法一：双指针

**思路与算法**

我们可以使用两个指针分别遍历字符串 $s$ 和数组 $\textit{spaces}$。记前者的指针为 $i$，后者的指针为 $\textit{ptr}$：当 $\textit{spaces}[\textit{ptr}]$ 恰好与 $i$ 相等时，我们在答案字符串的末尾放入一个空格，并将 $\textit{ptr}$ 向右移动一个位置。

此外，我们还需要在答案字符串的末尾放入 $s[i]$，并将 $i$ 向右移动一个位置。在两个指针全部遍历完成后，我们就得到了修改后的字符串。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string addSpaces(string s, vector<int>& spaces) {
        int n = s.size();
        string ans;
        ans.reserve(n + spaces.size());
        
        int ptr = 0;
        for (int i = 0; i < n; ++i) {
            if (ptr < spaces.size() && spaces[ptr] == i) {
                ans.push_back(' ');
                ++ptr;
            }
            ans.push_back(s[i]);
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def addSpaces(self, s: str, spaces: List[int]) -> str:
        ans = list()

        ptr = 0
        for i, ch in enumerate(s):
            if ptr < len(spaces) and spaces[ptr] == i:
                ans.append(" ")
                ptr += 1
            ans.append(ch)
        
        return "".join(ans)
```

**复杂度分析**

- 时间复杂度：$O(n + m)$，其中 $n$ 是字符串 $s$ 的长度，$m$ 是数组 $\textit{spaces}$ 的长度。

- 空间复杂度：$O(1)$ 或 $O(n + m)$，取决于使用的语言中字符串是否可以修改。
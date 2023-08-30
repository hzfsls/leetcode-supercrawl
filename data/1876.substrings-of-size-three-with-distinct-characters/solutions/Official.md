#### 方法一：遍历起始下标

**思路与算法**

我们遍历子字符串的起始下标 $i$，并检验 $i$ 开头的长度为 $3$ 的子串是否为好字符串，即是否不含有重复字符。与此同时，我们维护长度为 $3$ 好子串的个数。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countGoodSubstrings(string s) {
        int res = 0;
        int n = s.size();
        for (int i = 0; i < n - 2; ++i){
            if (s[i] != s[i+1] && s[i] != s[i+2] && s[i+1] != s[i+2]){
                ++res;
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def countGoodSubstrings(self, s: str) -> int:
        res = 0
        n = len(s)
        for i in range(n - 2):
            if s[i] != s[i+1] and s[i] != s[i+2] and s[i+1] != s[i+2]:
                res += 1
        return res
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $s$ 的长度。我们遍历了一遍字符串，对于每个下标为 $i$ 且长度为 $3$ 的子字符串，判断其是不是好子字符串的时间复杂度为 $O(1)$。

- 空间复杂度：$O(1)$。
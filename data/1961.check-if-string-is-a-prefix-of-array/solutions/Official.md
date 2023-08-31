## [1961.检查字符串是否为数组前缀 中文官方题解](https://leetcode.cn/problems/check-if-string-is-a-prefix-of-array/solutions/100000/jian-cha-zi-fu-chuan-shi-fou-wei-shu-zu-xxpvl)
#### 方法一：逐字符比较

**思路与算法**

我们可以按顺序遍历 $\textit{words}$ 中的字符串，并与 $s$ 逐字符比较。如果遇到不同的字符，则返回 $\texttt{false}$。

同时，根据题意，当且仅当 $s$ 与 $\textit{words}$ 中任一字符串同时遍历结束时，$s$ 才为 $\textit{words}$ 的前缀字符串。因此，如果遇到以下两种情况时，也应返回 $\texttt{false}$：

- 在未遍历完成 $\textit{words}$ 的某个字符串时，$s$ 提前遍历完成；

- 在遍历完成 $\textit{words}$ 的所有字符串后，$s$ 仍未遍历完成。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool isPrefixString(string s, vector<string>& words) {
        int i = 0;
        int n = s.size();
        for (const string& word : words){
            for (char ch : word){
                if (i < n && ch == s[i]){
                    ++i;
                }
                else{
                    // s 提前遍历完成或当前字符不匹配
                    return false;
                }
            }
            if (i == n){
                // 此时满足前缀定义
                return true;
            }
        }
        // 遍历完成 words 时 s 仍未遍历完成
        return false;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def isPrefixString(self, s: str, words: List[str]) -> bool:
        i = 0
        n = len(s)
        for word in words:
            for ch in word:
                if i < n and ch == s[i]:
                    i += 1
                else:
                    # s 提前遍历完成或当前字符不匹配
                    return False
            if i == n:
                # 此时满足前缀定义
                return True
        # 遍历完成 words 时 s 仍未遍历完成
        return False
```


**复杂度分析**

- 时间复杂度：$O(\min(n, m))$，其中 $n$ 为 $s$ 的长度，$m$ 为 $\textit{words}$ 中所有字符串的长度总和。即为逐字符比较的时间复杂度。

- 空间复杂度：$O(1)$。
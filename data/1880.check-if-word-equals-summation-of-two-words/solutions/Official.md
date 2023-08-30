#### 方法一：按要求处理

**思路与算法**

我们用函数 $\textit{decode}(s)$ 将单词转化为对应的整数。我们将 $\textit{res}$ 的初始值设为 $0$，在从前至后处理每个字符 $s[i]$ 时，我们需要将 $\textit{res}$ 乘 $10$ 并加上 $s[i]$ 对应的数值。最终，我们返回 $\textit{res}$ 作为转化后的整数。

最终，我们比较 $\textit{decode}(\textit{firstWord})$ 与 $\textit{decode}(\textit{secondWord})$ 的和是否等于 $\textit{decode}(\textit{targetWord})$ 即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool isSumEqual(string firstWord, string secondWord, string targetWord) {
        auto decode = [](const string& s) -> int {
            int res = 0;
            for (char ch: s){
                res *= 10;
                res += ch - 'a';
            }
            return res;
        };
        
        return decode(firstWord) + decode(secondWord) == decode(targetWord);
    }
};
```


```Python [sol1-Python3]
class Solution:
    def isSumEqual(self, firstWord: str, secondWord: str, targetWord: str) -> bool:
        def decode(word: str) -> int:
            res = 0
            for ch in word:
                res *= 10
                res += ord(ch) - ord('a')
            return res
        
        return decode(firstWord) + decode(secondWord) == decode(targetWord)
```

**复杂度分析**

- 时间复杂度：$O(n_1+n_2+n_3)$，其中 $n_1, n_2, n_3$ 分别为三个字符串的长度。我们需要分别遍历三个字符串并转为对应的整数。

- 空间复杂度：$O(1)$。
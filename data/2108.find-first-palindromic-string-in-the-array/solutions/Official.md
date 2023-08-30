#### 方法一：逐个判断

**思路与算法**

为了寻找字符串数组 $\textit{words}$ 中第一个回文字符串，我们按顺序遍历数组，并依次判断每个字符串是否回文。如果当前字符串回文，则该字符串即为第一个回文字符串，我们返回该字符串作为答案；如果遍历完成仍未找到回文字符串，则返回空字符串作为答案。

一种判断字符串回文的方法是逐字符与反转后的对应字符比较是否相等。这里我们用函数 $\textit{isPalindrome}(\textit{word})$ 来判断字符串 $\textit{word}$ 是否为回文字符串。具体地，假设 $\textit{word}$ 的长度为 $n$，我们用 $l, r$ 两个下标遍历反转前后的对应下标，其中 $l$ 的初值为 $0$ 代表字符串的起始字符，$r$ 的初值为 $n - 1$ 代表字符串的末尾字符。当 $l < r$ 时，我们循环判断字符 $\textit{word}[l]$ 与 $\textit{word}[r]$ 是否相等：如果不相等，则说明 $\textit{word}$ 不为回文字符串，此时直接返回 $\texttt{false}$；如果相等，则我们将 $l$ 加上 $1$ 并将 $r$ 减去 $1$ 继续判断。如果循环结束时所有遍历的字符对均相等，此时无论 $l = r$ 还是 $l > r$ 都可以保证每个字符均与反转后对应位置的字符相等，因此 $\textit{word}$ 为回文字符串，此时应返回 $\texttt{true}$。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    string firstPalindrome(vector<string>& words) {
        // 判断字符串是否回文
        auto isPalindrome = [](const string& word) -> bool {
            int n = word.size();
            int l = 0, r = n - 1;
            while (l < r) {
                if (word[l] != word[r]) {
                    return false;
                }
                ++l;
                --r;
            }
            return true;
        };
        
        // 顺序遍历字符串数组，如果遇到回文字符串则返回，未遇到则返回空字符串
        for (const string& word: words) {
            if (isPalindrome(word)) {
                return word;
            }
        }
        return "";
    }
};
```


```Python [sol1-Python3]
class Solution:
    def firstPalindrome(self, words: List[str]) -> str:
        # 判断字符串是否回文
        def isPalindrome(word: str) -> bool:
            n = len(word)
            l, r = 0, n - 1
            while l < r:
                if word[l] != word[r]:
                    return False
                l += 1
                r -= 1
            return True
        
        # 顺序遍历字符串数组，如果遇到回文字符串则返回，未遇到则返回空字符串
        for word in words:
            if isPalindrome(word):
                return word
        return ""
```


**复杂度分析**

- 时间复杂度：$O(\sum_i n_i)$，其中 $n_i$ 为 $\textit{words}$ 数组中第 $i$ 个字符串的长度。即为遍历寻找第一个回文字符串的时间复杂度。

- 空间复杂度：$O(1)$。
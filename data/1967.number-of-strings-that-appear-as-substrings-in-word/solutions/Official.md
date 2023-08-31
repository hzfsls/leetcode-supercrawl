## [1967.作为子字符串出现在单词中的字符串数目 中文官方题解](https://leetcode.cn/problems/number-of-strings-that-appear-as-substrings-in-word/solutions/100000/zuo-wei-zi-zi-fu-chuan-chu-xian-zai-dan-wmsp4)

#### 方法一：暴力匹配

**思路与算法**

我们可以让字符串数组 $\textit{patterns}$ 中的每个字符串 $\textit{pattern}$ 都与 $\textit{word}$ 匹配一次，同时统计其中为 $\textit{word}$ 子串的字符串数目。

我们用函数 $\textit{check}(\textit{pattern}, \textit{word})$ 来判断字符串 $\textit{pattern}$ 是否是 $\textit{word}$ 的子串。我们假设 $\textit{pattern}$ 的长度为 $m$。在该函数中，我们让 $\textit{pattern}$ 与 $\textit{word}$ 的每个长度为 $m$ 的子串均匹配一次。

为了减少不必要的匹配，我们每次匹配失败即立刻停止当前子串的匹配，对下一个子串继续匹配。如果当前子串匹配成功，我们返回 $\texttt{true}$；如果所有子串都匹配失败，则返回 $\texttt{false}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int numOfStrings(vector<string>& patterns, string word) {
        auto check = [](const string& pattern, const string& word) -> bool{
            int m = pattern.size();
            int n = word.size();
            for (int i = 0; i + m <= n; ++i){
                bool flag = true;
                for (int j = 0; j < m; ++j){
                    if (word[i + j] != pattern[j]){
                        flag = false;
                        break;
                    }
                }
                if (flag){
                    return true;
                }
            }
            return false;
        };

        int res = 0;
        for (const string& pattern : patterns){
            res += check(pattern, word);
        }
        return res;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def numOfStrings(self, patterns: List[str], word: str) -> int:
        def check(pattern: str, word: str) -> bool:
            m = len(pattern)
            n = len(word)
            for i in range(n - m + 1):
                flag = True
                for j in range(m):
                    if word[i + j] != pattern[j]:
                        flag = False
                        break
                if flag:
                    return True
            return False
        
        res = 0
        for pattern in patterns:
            res += check(pattern, word)
        return res
```

**复杂度分析**

- 时间复杂度：$O(n \times \sum_i m_i)$，其中 $n$ 为字符串 $\textit{word}$ 的长度，$m_i$ 为字符串 $\textit{patterns}[i]$ 的长度。
  
  对于 $\textit{patterns}$ 中的每个字符串 $\textit{patterns}[i]$，暴力匹配判断是否为 $\textit{word}$ 子串的时间复杂度为 $O(n \times m_i)$。

- 空间复杂度：$O(1)$。


#### 方法二：$\text{KMP}$ 算法

**思路与算法**

在方法一中，每一次调用函数 $\textit{check}(\textit{pattern}, \textit{word})$ 进行判断都需要暴力比较 $\textit{pattern}$ 与 $\textit{word}$ 中所有长度为 $m$ 的子串，假设 $\textit{word}$ 的长度为 $n$，则匹配的时间复杂度为 $O(nm)$。

我们可以对函数 $\textit{check}(\textit{pattern}, \textit{word})$ 中暴力比较的过程进行优化。在这里，我们使用 $\text{KMP}$ 算法对匹配过程进行优化。如果读者不熟悉 $\text{KMP}$ 算法，可以阅读[「28. 实现 strStr() 的官方题解」](https://leetcode-cn.com/problems/implement-strstr/solution/shi-xian-strstr-by-leetcode-solution-ds6y/) 中的方法二。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int numOfStrings(vector<string>& patterns, string word) {
        auto check = [](const string& pattern, const string& word) -> bool{
            int m = pattern.size();
            int n = word.size();
            // 生成 pattern 的前缀数组
            vector<int> pi(m);
            for (int i = 1, j = 0; i < m; i++){
                while (j > 0 && pattern[i] != pattern[j]){
                    j = pi[j - 1];
                }
                if (pattern[i] == pattern[j]){
                    ++j;
                }
                pi[i] = j;
            }
            // 利用前缀数组进行匹配
            for (int i = 0, j = 0; i < n; i++){
                while (j > 0 && word[i] != pattern[j]){
                    j = pi[j - 1];
                }
                if (word[i] == pattern[j]){
                    ++j;
                }
                if (j == m){
                    return true;
                }
            }
            return false;
        };

        int res = 0;
        for (const string& pattern : patterns){
            res += check(pattern, word);
        }
        return res;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def numOfStrings(self, patterns: List[str], word: str) -> int:
        def check(pattern: str, word: str) -> bool:
            m = len(pattern)
            n = len(word)
            # 生成 pattern 的前缀数组
            pi = [0] * m
            j = 0
            for i in range(1, m):
                while j and pattern[i] != pattern[j]:
                    j = pi[j - 1]
                if pattern[i] == pattern[j]:
                    j += 1
                pi[i] = j
            # 利用前缀数组进行匹配 
            j = 0
            for i in range(n):
                while j and word[i] != pattern[j]:
                    j = pi[j - 1]
                if word[i] == pattern[j]:
                    j += 1
                if j == m:
                    return True
            return False
        
        res = 0
        for pattern in patterns:
            res += check(pattern, word)
        return res
```

**复杂度分析**

- 时间复杂度：$O(nk + \sum_i m_i)$，其中 $n$ 为字符串 $\textit{word}$ 的长度，$k$ 为数组 $\textit{patterns}$ 中的元素数目，$m_i$ 为字符串 $\textit{patterns}[i]$ 的长度。
  
  对于 $\textit{patterns}$ 中的每个字符串 $\textit{patterns}[i]$，利用 $\text{KMP}$ 算法判断是否为 $\textit{word}$ 子串的时间复杂度为 $O(n + m_i)$。

- 空间复杂度：$O(\max_i(m_i))$，其中 $m_i$ 为字符串 $\textit{patterns}[i]$ 的长度。即为所有 $\textit{patterns}[i]$ 的前缀数组的空间开销。
#### 方法一：比较下标

**思路与算法**

我们可以考虑题目中命题的等价命题。

在字符串中**含有** $\texttt{`a'}$ 和 $\texttt{`b'}$ 的情况下「字符串中每个 $\texttt{`a'}$ 都在 $\texttt{`b'}$ 之前」等价于「字符串中 $\texttt{`a'}$ **最后一次**出现的下标在 $\texttt{`b'}$ **第一次**出现的下标之前」。那么对于这种情况，我们可以顺序遍历字符串 $s$，找到 $\texttt{`a'}$ **最后一次**出现的下标 $\textit{last}_a$ 与 $\texttt{`b'}$ **第一次**出现的下标 $\textit{first}_b$，并比较这两个下标。如果 $\textit{last}_a < \textit{first}_b$，则说明字符串中每个 $\texttt{`a'}$ 都在 $\texttt{`b'}$ 之前，此时我们返回 $\texttt{true}$ 作为答案；反之则不是，我们返回 $\texttt{false}$。

除此之外，字符串 $s$ 还有可能出现不存在 $\texttt{`a'}$ 或 $\texttt{`b'}$ 的情况。假设 $s$ 的长度为 $n$，此时我们只需要将 $\textit{last}_a$ 的初值设置为**小于**所有合法下标的 $-1$，并将 $\textit{first}_b$ 的初始下标设置为**大于**所有合法下标的 $n$，即可保证这两种情况均被视为满足条件，且返回 $\texttt{true}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool checkString(string s) {
        int n = s.size();
        int lasta = -1;   // 'a' 最后一次出现的下标
        int firstb = n;   // 'b' 第一次出现的下标
        for (int i = 0; i < n; ++i) {
            if (s[i] == 'a') {
                lasta = max(lasta, i);
            }
            else {
                firstb = min(firstb, i);
            }
        }
        return lasta < firstb;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def checkString(self, s: str) -> bool:
        n = len(s)
        lasta = -1   # 'a' 最后一次出现的下标
        firstb = n   # 'b' 第一次出现的下标
        for i in range(n):
            if s[i] == 'a':
                lasta = max(lasta, i)
            else:
                firstb = min(firstb, i)
        return lasta < firstb
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $s$ 的长度。即为遍历维护下标的时间复杂度。

- 空间复杂度：$O(1)$。


#### 方法二：寻找子串

**思路与算法**

我们也可以考虑题目中条件的**否命题**，即「字符串中存在 $\texttt{`b'}$ 在 $\texttt{`a'}$ 之前」。由于字符串仅由 $\texttt{`a'}$ 和 $\texttt{`b'}$ 构成，因此这**等价于**「字符串中存在子字符串 $\texttt{"ba"}$」。

那么我们只需要判断字符串 $s$ 中是否存在子串 $\texttt{"ba"}$，如果存在，则说明并不是每个 $\texttt{`a'}$ 都在 $\texttt{`b'}$ 之前，我们返回 $\texttt{false}$ 作为答案；反之则返回 $\texttt{true}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool checkString(string s) {
        return s.find("ba") == string::npos;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def checkString(self, s: str) -> bool:
        return s.find("ba") == -1
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $s$ 的长度。即为遍历寻找长度为 $2$ 子串的时间复杂度。

- 空间复杂度：$O(1)$。
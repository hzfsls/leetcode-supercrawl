#### 方法一：遍历字符串

**思路与算法**

我们可以遍历字符串并维护连续的 $\texttt{`0'}$ 与 $\texttt{`1'}$ 子串的最长长度 $\textit{mx}_0$ 与 $\textit{mx}_1$。

在遍历字符串的时候，我们维护上一个字符 $\textit{prev}$ 与当前连续子串的最长长度 $\textit{cnt}$。

对于每一个字符 $\textit{ch}$，我们判断它与 $\textit{prev}$ 是否相等：

- 如果相等，则将 $\textit{cnt}$ 增加 $1$；

- 如果不相等，则根据 $\textit{prev}$ 的内容更新对应的 $\textit{mx}_0$ 与 $\textit{mx}_1$。

除此以外，在遍历结束后，我们还需要根据字符串结尾的连续子串形式维护对应的 $\textit{mx}_0$ 与 $\textit{mx}_1$。

最终，我们比较 $\textit{mx}_0$ 与 $\textit{mx}_1$ 的大小并返回答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool checkZeroOnes(string s) {
        int mx0 = 0;
        int mx1 = 0;
        char prev = '#';   // 上个字符
        int cnt = 0;
        for (char ch: s){
            // 当前字符与上个字符相等
            if (ch == prev){
                ++cnt;
            }
            // 当前字符与上个字符不相等
            else{
                if (prev == '0'){
                    mx0 = max(mx0, cnt);
                }
                else if (prev == '1'){
                    mx1 = max(mx1, cnt);
                }
                cnt = 1;
            }
            prev = ch;
        }
        // 字符串结尾的连续子串
        if (prev == '0'){
            mx0 = max(mx0, cnt);
        }
        else if (prev == '1'){
            mx1 = max(mx1, cnt);
        }
        return mx1 > mx0;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def checkZeroOnes(self, s: str) -> bool:
        mx0, mx1 = 0, 0
        cnt = 0
        prev = '#'   # 上个字符
        for ch in s:
            # 当前字符与上个字符相等
            if prev == ch:
                cnt += 1
            # 当前字符与上个字符不相等
            else:
                if prev == '0':
                    mx0 = max(mx0, cnt)
                elif prev == '1':
                    mx1 = max(mx1, cnt)
                cnt = 1
            prev = ch
        # 字符串结尾的连续子串
        if prev == '0':
            mx0 = max(mx0, cnt)
        elif prev == '1':
            mx1 = max(mx1, cnt)
        return mx1 > mx0
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串的长度，即为遍历一遍字符串的时间复杂度。

- 空间复杂度：$O(1)$，我们只使用了常数个变量。
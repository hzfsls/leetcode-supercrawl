## [2182.构造限制重复的字符串 中文官方题解](https://leetcode.cn/problems/construct-string-with-repeat-limit/solutions/100000/gou-zao-xian-zhi-zhong-fu-de-zi-fu-chuan-v02s)
#### 方法一：贪心 + 双指针

**提示 $1$**

我们可以按照如下的方式构造字符串，这样构造出的字符串对应的字典序一定是最大的：

> 每次选择当前剩余的字典序最大的字符加入字符串末尾；如果字符串末尾的字符已经连续出现了 $\textit{repeatLimit}$ 次，则将字典序次大的字符加入字符串末尾，随后重复选择当前剩余的字典序最大的字符加入字符串末尾，直至用完字符或没有新的字符可以合法加入为止。

**提示 $1$ 解释**

根据反证法，我们只需要证明任意比上述方法构造出的字符串 $\textit{res}$ 的字典序更大的字符串都是不合法的即可。

根据字典序的定义，上述证明可以分为两部分：

1. 从高位至低位逐位尝试使用字典序更大的字符替代，并逐个判断；

2. 尝试在 $\textit{res}$ 后添加新的字符，并逐个判断。

对于第一部分，任何使用更大的字符替代后的字符串要么使用了 $s$ 中不存在的字符，要么某一字符连续出现的次数大于 $\textit{repeatLimit}$ 次，而这两种都是不合法的；对于第二部分，任何尝试添加新字符的字符串也一定是第一部分的两种情况之一，因而也是不合法的。

综上所述，按照上文方法构造的字符串的字典序一定是最大的。

**思路与算法**

我们可以尝试按照 **提示 $1$** 的方式构造字典序最大的合法字符串 $\textit{res}$。具体方法如下：

首先，我们遍历 $s$，并用一个长度为 $26$ 的数组 $\textit{cnt}$ 统计 $s$ 中各个字符的出现次数，其中 $\textit{cnt}[k]$ 代表字母表第 $k$ 个字符的出现次数。与此同时，我们用下标 $r$ 来表示当前未使用的**字典序最大的字符**（如果该下标不合法则代表不存在，即未使用的的字符为空），即字母表中第 $r$ 个字符。

除此以外，我们还需要用下标 $l$ 来表示当前未使用的**字典序次大的字符**（满足 $cnt[l] > 0$ 以及 $l < r$，如果该下标不合法则代表不存在）。

接下来，我们模拟循环构造字符串的过程。在每一步中，我们首先计算当前字典序最大的字符能够重复的次数 $\textit{rep}$，它是该字符剩余的个数 $\textit{cnt}[r]$ 和 $\textit{repeatLimit}$ 的较小值，随后我们将对应数量（$\textit{rep}$）的字符添加进 $\textit{res}$ 末尾，并将 $\textit{cnt}[r]$ 减去 $\textit{rep}$。此时根据 $\textit{cnt}[r]$ 的剩余数量有两种情况：

1. $\textit{cnt}[r] > 0$，即字典序最大的字符还有剩余：此时如果 $l$ 合法（即 $l \ge 0$，下同），即存在次大的字符，则我们将一个次大的字符加入 $\textit{res}$ 末尾，并将 $cnt[l]$ 减去 $1$，如果 $cnt[l]$ 为零我们还需要尝试向下寻找新的次大字符 $l$；如果 $l < 0$，即不存在次大的字符，此时我们结束循环。

2. $\textit{cnt}[r] = 0$，即字典序最大的字符已经用完：此时我们需要令 $r = l$，即字典序次大的字符变成最大，并尝试向下寻找新的次大字符并更新 $l$。

循环结束后，$\textit{res}$ 即为符合要求的字典序最大的字符串，我们返回该字符串作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string repeatLimitedString(string s, int repeatLimit) {
        vector<int> cnt(26, 0);   // 各个字符出现次数
        string res;   // 字典序最大的字符串
        int r = 0;
        for (char ch: s) {
            ++cnt[ch-'a'];
            r = max(r, ch - 'a');   // 字典序最大的字符对应下标
        }
        int l = r - 1;   // 字典序次大的字符对应下标
        while (r >= 0) {
            // 尝试更新 l
            while (l >= 0 && cnt[l] == 0) {
                --l;
            }
            // 尽可能多地添加字典序最大的字符
            int rep = min(cnt[r], repeatLimit);
            for (int i = 0; i < rep; ++i) {
                res.push_back('a' + r);
            }
            cnt[r] -= rep;
            if (cnt[r] == 0) {
                // 字典序最大的字符已用完，次大的变为最大的
                r = l;
                l = r - 1;
            } else if (l < 0) {
                // 此时无法添加新的字符
                break;
            } else {
                // 添加一个字典序次大的字符，随后继续尝试添加字典序最大的字符
                res.push_back('a' + l);
                --cnt[l];
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def repeatLimitedString(self, s: str, repeatLimit: int) -> str:
        cnt = [0] * 26   # 各个字符出现次数
        res = []   # 字典序最大的字符串
        r = 0   # 字典序最大的字符对应下标
        for ch in s:
            cnt[ord(ch)-ord('a')] += 1
            r = max(r, ord(ch)-ord('a'))
        l = r - 1   # 字典序次大的字符对应下标
        while r >= 0:
            # 尝试更新 l
            while l >= 0 and cnt[l] == 0:
                l -= 1
            # 尽可能多地添加字典序最大的字符
            rep = min(cnt[r], repeatLimit)
            for _ in range(rep):
                res.append(chr(ord('a')+r))
            cnt[r] -= rep
            if cnt[r] == 0:
                # 字典序最大的字符已用完，次大的变为最大的
                r = l 
                l = r - 1
            elif l < 0:
                # 此时无法添加新的字符
                break
            else:
                # 添加一个字典序次大的字符，随后继续尝试添加字典序最大的字符
                res.append(chr(ord('a')+l))
                cnt[l] -= 1
        return "".join(res)
```


**复杂度分析**

- 时间复杂度：$O(n + |\Sigma|)$，其中 $n$ 为 $s$ 的长度，$|\Sigma|$ 为字符集的大小。即为预处理字符出现次数和双指针生成字符串的时间复杂度。

- 空间复杂度：由于不同语言对应字符串的方法有所差异，因此时间复杂度也有所差异。
  - 对于 $\texttt{C++}$，空间复杂度为 $O(|\Sigma|)$，即为 $s$ 中字符出现次数数组的开销；
  - 对于 $\texttt{Python}$，空间复杂度为 $O(n + |\Sigma|)$，即为 $s$ 中字符出现次数数组以及辅助数组的开销。
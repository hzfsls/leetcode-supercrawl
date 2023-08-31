## [1839.所有元音按顺序排布的最长子字符串 中文官方题解](https://leetcode.cn/problems/longest-substring-of-all-vowels-in-order/solutions/100000/suo-you-yuan-yin-an-shun-xu-pai-bu-de-zu-9wqg)

#### 方法一：状态机

**提示 $1$**

我们可以将 $\texttt{a,e,i,o,u}$ 看成 $5$ 个状态。
当我们在遍历字符串的每个字符时，都会处于其中的一个状态。如果当前在 $\texttt{u}$ 状态，那么就可以对答案进行更新。

**提示 $2$**

你会如何设计状态之间的转移呢？

**思路与算法**

下面给出了状态转移图，其中蓝色的 $\texttt{a,e,i,o}$ 表示正常状态，绿色的 $\texttt{u}$ 表示目标状态，红色的 $\texttt{x}$ 表示非法状态。

![fig1](https://assets.leetcode-cn.com/solution-static/5740/1.png){:style="width:300px"}

图中也标注了两个状态之间的转移方式，对于没有标注的转移，一律转移到 $\texttt{x}$ 非法状态。

这样一来，我们只需要从 $\texttt{x}$ 状态开始，在对字符串进行一次遍历的同时，在状态机上进行转移即可。在转移的同时，我们需要记录到目前为止成功转移的次数 $\textit{cnt}$，当到达 $\texttt{u}$ 状态时，我们就可以用 $\textit{cnt}$ 来更新答案。

转移次数 $\textit{cnt}$ 的计算规则如下：

- 当我们转移到 $\texttt{x}$ 状态时，会将 $\textit{cnt}$ 清零；
- 当我们转移到 $\texttt{a}$ 状态时，如果上一个状态不为 $\texttt{a}$，那么会将 $\textit{cnt}$ 置为 $1$；
- 对于其余的情况，将 $\textit{cnt}$ 增加 $1$ 即可。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static unordered_set<string> transit;

public:
    int longestBeautifulSubstring(string word) {
        int cur = 0, ans = 0;
        char status = 'x';
        
        for (char ch: word) {
            if (transit.count(string(1, status) + ch)) {
                if (status != 'a' && ch == 'a') {
                    cur = 1;
                }
                else {
                    ++cur;
                }
                status = ch;
            }
            else {
                cur = 0;
                status = 'x';
            }
            if (status == 'u') {
                ans = max(ans, cur);
            }
        }
        
        return ans;
    }
};

unordered_set<string> Solution::transit = {
    "ae", "ei", "io", "ou",
    "aa", "ee", "ii", "oo", "uu",
    "xa", "ea", "ia", "oa", "ua"
};
```

```Python [sol1-Python3]
class Solution:

    TRANSIT = {
        ("a", "e"), ("e", "i"), ("i", "o"), ("o", "u"),
        ("a", "a"), ("e", "e"), ("i", "i"), ("o", "o"), ("u", "u"),
        ("x", "a"), ("e", "a"), ("i", "a"), ("o", "a"), ("u", "a"),
    }
    
    def longestBeautifulSubstring(self, word: str) -> int:
        cur, ans = 0, 0
        status = "x"
        
        for ch in word:
            if (status, ch) in Solution.TRANSIT:
                if status != "a" and ch == "a":
                    cur = 1
                else:
                    cur = cur + 1
                status = ch
            else:
                cur = 0
                status = "x"
            if status == "u":
                ans = max(ans, cur)

        return ans
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{word}$ 的长度。

- 空间复杂度：$O(|\Sigma|)$，其中 $\Sigma$ 是字符集，本体中给定的字符串仅包含元音字母，$|\Sigma|=5$。状态机中的转移分为三种：

    - 一个状态转移到本身，这种转移的数量为 $O(|\Sigma|)$；
    - 一个状态转移到相邻的下一个状态，例如 $\texttt{a}$ 转移到 $\texttt{e}$，$\texttt{e}$ 转移到 $\texttt{i}$，这种转移的数量为 $O(|\Sigma|)$；
    - 一个非 $\texttt{a}$ 的状态转移到 $\texttt{a}$，这种转移的数量为 $O(|\Sigma|)$。

    因此转移的数量为 $O(|\Sigma|)$，即为我们需要的空间。
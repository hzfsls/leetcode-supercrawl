## [1400.构造 K 个回文字符串 中文官方题解](https://leetcode.cn/problems/construct-k-palindrome-strings/solutions/100000/gou-zao-k-ge-hui-wen-zi-fu-chuan-by-leetcode-solut)
#### 方法一：找出可行的回文串个数

由于我们需要根据给定的字符串 $s$ 构造出 $k$ 个非空的回文串，那么一种容易想到的步骤是：

1. 求出字符串 $s$ 最少可以构造的回文串个数 $\textit{left}$；

2. 求出字符串 $s$ 最多可以构造的回文串个数 $\textit{right}$；

3. 找出在 $[\textit{left}, \textit{right}]$ 范围内满足要求的那些值，并判断 $k$ 是否在其中。

对于步骤 2 来说，它的答案很简单。我们设字符串 $s$ 的长度为 $|s|$，那么显然 $s$ 最多可以构造的回文串个数就是 $|s|$，即 $s$ 中的每一个字符都单独构成一个回文串。

那么我们如何分析步骤 1 呢？我们需要考虑回文串的性质：回文串分为两类，第一类是长度为奇数，回文中心为一个字符，例如 $\texttt{abcba}$，$\texttt{abacaba}$ 等；第二类是长度为偶数，回文中心为两个相同的字符，例如 $\texttt{abccba}$，$\texttt{abaccaba}$ 等。我们可以发现，对于第一类回文串，只有一种字符出现了奇数次，其余所有字符都出现了偶数次；而对于第二类回文串，所有字符都出现了偶数次。

因此，如果 $s$ 中有 $p$ 个字符出现了奇数次，$q$ 个字符出现了偶数次，那么 $s$ 最少可以构造的回文串个数就为 $p$，这是因为每一种出现了奇数次的字符都必须放在不同的回文串中。特别地，如果 $p=0$，那么最少构造的回文串个数为 $1$。

通过简单的分析，我们得到了 $\textit{left}$ 的值为 $\max(p, 1)$，$\textit{right}$ 的值为 $|s|$。那么最后还剩下步骤 1 了，对于 $[\textit{left}, \textit{right}]$ 范围内的值，哪些是满足要求的呢？我们当然希望所有的值都是满足要求的，但这可以实现吗？

我们随意地给出一个回文串 $\texttt{ahykhbhkyha}$，可以发现，如果将回文中心 $\texttt{b}$ 取出，这样我们就可以得到两个回文串 $\texttt{ahykhhkyha}$ 和 $\texttt{b}$。接下来，我们将回文中心 $\texttt{hh}$ 中取出一个 $\texttt{h}$，这样就得到了三个回文串 $\texttt{ahykhkyha}$，$\texttt{h}$ 和 $\texttt{b}$。以此类推，最终我们可以得到 $11$ 个回文串（即为初始回文串的长度），每一个回文串的长度均为 $1$。

因此我们就可以断定：对于 $[\textit{left}, \textit{right}]$ 范围内的值，它们都是满足要求的：

- 我们知道 $\textit{left}$ 是满足要求的；

- 如果 $x$ 是满足要求的，并且 $x \neq \textit{right}$，那么我们一定可以找到一个回文串的长度大于 $1$。我们取出该回文串的回文中心（如果是第一类回文串）或者回文中心其中的一个字符（如果是第二类回文串），单独作为一个长度为 $1$ 的回文串。这样我们就得到了 $x + 1$ 个回文串，那么 $x + 1$ 也是满足要求的。

通过归纳法，我们证明了上述的结论，因此只要 $k$ 在 $[\textit{left}, \textit{right}]$ 中，我们就返回 $\texttt{True}$，否则返回 $\texttt{False}$。

```C++ [sol1-C++]
class Solution {
public:
    bool canConstruct(string s, int k) {
        // 右边界为字符串的长度
        int right = s.size();
        // 统计每个字符出现的次数
        int occ[26] = {0};
        for (char ch: s) {
            ++occ[ch - 'a'];
        }
        // 左边界为出现奇数次字符的个数
        int left = 0;
        for (int i = 0; i < 26; ++i) {
            if (occ[i] % 2 == 1) {
                ++left;
            }
        }
        // 注意没有出现奇数次的字符的特殊情况
        left = max(left, 1);
        return left <= k && k <= right;
    }
};
```

```C++ [sol1-C++17]
class Solution {
public:
    bool canConstruct(string s, int k) {
        // 右边界为字符串的长度
        int right = s.size();
        // 统计每个字符出现的次数
        unordered_map<char, int> occ;
        for (char ch: s) {
            ++occ[ch];
        }
        // 左边界为出现奇数次字符的个数
        int left = 0;
        for (auto& [_, v]: occ) {
            if (v % 2 == 1) {
                ++left;
            }
        }
        // 注意没有出现奇数次的字符的特殊情况
        left = max(left, 1);
        return left <= k && k <= right;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean canConstruct(String s, int k) {
        // 右边界为字符串的长度
        int right = s.length();
        // 统计每个字符出现的次数
        int[] occ = new int[26];
        for (int i = 0; i < right; ++i) {
            ++occ[s.charAt(i) - 'a'];
        }
        // 左边界为出现奇数次字符的个数
        int left = 0;
        for (int i = 0; i < 26; ++i) {
            if (occ[i] % 2 == 1) {
                ++left;
            }
        }
        // 注意没有出现奇数次的字符的特殊情况
        left = Math.max(left, 1);
        return left <= k && k <= right;
    }
}
```

```Python [sol1-Python]
class Solution:
    def canConstruct(self, s: str, k: int) -> bool:
        # 右边界为字符串的长度
        right = len(s)
        # 统计每个字符出现的次数
        occ = collections.Counter(s)
        # 左边界为出现奇数次字符的个数
        left = sum(1 for _, v in occ.items() if v % 2 == 1)
        # 注意没有出现奇数次的字符的特殊情况
        left = max(left, 1)
        return left <= k <= right
```

**复杂度分析**

- 时间复杂度：$O(N + |\Sigma|)$，其中 $N$ 是字符串 $s$ 的长度，$\Sigma$ 是字符集（即字符串中可能出现的字符种类数），在本题中字符串只会包含小写字母，因此 $|\Sigma| = 26$。我们需要对字符串 $s$ 进行一次遍历，得到每个字符出现的次数，时间复杂度为 $O(N)$。在这之后，我们需要遍历每一种字符，统计出现奇数次的字符数量，时间复杂度为 $O(|\Sigma|)$。

- 空间复杂度：$O(|\Sigma|)$。我们需要使用数组或哈希表存储每个字符出现的次数。
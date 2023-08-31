## [2156.查找给定哈希值的子串 中文官方题解](https://leetcode.cn/problems/find-substring-with-given-hash-value/solutions/100000/cha-zhao-gei-ding-ha-xi-zhi-de-zi-chuan-fi8jd)

#### 方法一：数学

**思路与算法**

对于 $s$ 中任意长度为 $k$ 的子串，计算该字串哈希值的时间复杂度为 $O(k)$。如果我们直接计算所有长度为 $k$ 子串的哈希值，并逐个比较，则时间复杂度为 $O(nk)$，不符合数据范围的要求。因此我们需要优化计算不同子串哈希值的时间。

我们可以考虑两个相邻的子串 $s[i..i+k-1]$ 与 $s[i+1..i+k]$，为了方便表示，我们用函数 $h(i, p, m)$ 来表示 $s[i..i+k-1]$ 的哈希值，即

$$
\begin{aligned}
h(i, p, m) &= \textit{hash}(s[i..i+k-1], p, m)\\
&= (\textit{val}(s[i]) \times p^0 + \textit{val}(s[i+1]) \times p^1 + \dots + \textit{val}(s[i+k-1]) \times p^{k-1}) \bmod m.
\end{aligned}
$$

同理，我们有：

$$
h(i + 1, p, m) = (\textit{val}(s[i+1]) \times p^0 + \textit{val}(s[i+2]) \times p^1 + \dots + \textit{val}(s[i+k]) \times p^{k-1}) \bmod m.
$$

比较上述两式，容易发现：

$$
h(i, p, m) = (\textit{val}(s[i]) \times p^0 + p \times h(i + 1, p, m) - \textit{val}(s[i+k]) \times p^{k}) \bmod m.
$$

那么，如果我们预处理 $p^{k} \bmod m$ 的值（这需要至多 $O(k)$ 的时间复杂度），并计算出了 $h(i + 1, p, m)$ 的取值，那么我们就可以在 $O(1)$ 的时间内得出 $h(i, p, m)$ 的取值。

具体而言，我们假设 $s$ 的长度为 $n$，那么我们首先用 $O(k)$ 的时间预处理 $s$ 中**最后一个长度为 $k$ 子串**的哈希值 $h(n - k, p, m)$ 与 $p^{k} \bmod m$，就可以用 $O(n - k)$ 的时间依次计算出其余每个长度为 $k$ 子串的哈希值。我们用 $\textit{pos}$ 来维护第一个哈希值为 $\textit{hashValue}$ 的长度为 $k$ 子串的起始下标，每当向前遍历到符合要求的子串，我们就将 $\textit{pos}$ 更新为对应的起始下标。最终，我们返回该下标起始的长度为 $k$ 的子串作为答案。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    string subStrHash(string s, int power, int modulo, int k, int hashValue) {
        int mult = 1;   // power^k mod modulo
        int n = s.size();
        int pos = -1;   // 第一个符合要求子串的起始下标
        int h = 0;   // 子串哈希值
        // 预处理计算最后一个子串的哈希值和 power^k mod modulo
        for (int i = n - 1; i >= n - k; --i) {
            h = ((long long)h * power + (s[i] - 'a' + 1)) % modulo;
            if (i != n - k) {
                mult = (long long)mult * power % modulo;
            }
        }
        if (h == hashValue) {
            pos = n - k;
        }
        // 向前计算哈希值并尝试更新下标
        for (int i = n - k - 1; i >= 0; --i) {
            h = ((h - (long long)(s[i+k] - 'a' + 1) * mult % modulo + modulo) * power + (s[i] - 'a' + 1)) % modulo;
            if (h == hashValue) {
                pos = i;
            }
        }
        return s.substr(pos, k);
    }
};
```


```Python [sol1-Python3]
class Solution:
    def subStrHash(self, s: str, power: int, modulo: int, k: int, hashValue: int) -> str:
        mult = 1   # power^k mod modulo
        n = len(s)
        pos = -1   # 第一个符合要求子串的起始下标
        h = 0   # 子串哈希值
        # 预处理计算最后一个子串的哈希值和 power^k mod modulo
        for i in range(n - 1, n - k - 1, -1):
            h = (h * power + (ord(s[i]) - ord('a') + 1)) % modulo
            if i != n - k:
                mult = mult * power % modulo
        if h == hashValue:
            pos = n - k
        # 向前计算哈希值并尝试更新下标
        for i in range(n - k - 1, -1, -1):
            h = ((h - (ord(s[i+k]) - ord('a') + 1) * mult % modulo + modulo) * power + (ord(s[i]) - ord('a') + 1)) % modulo
            if h == hashValue:
                pos = i
        return s[pos:pos+k]
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $s$ 的长度。即为预处理与遍历计算长度为 $k$ 的子串的哈希值，并更新符合条件字串起始下标的时间复杂度。

- 空间复杂度：$O(1)$。
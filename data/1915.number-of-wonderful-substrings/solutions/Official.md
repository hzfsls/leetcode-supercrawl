#### 方法一：状态压缩

**提示 $1$**

如果字符串 $\textit{word}$ 的某个子串 $\textit{word}[i..j]$ 是最美字符串，那么其中最多只有一个字符出现奇数次，这说明：

> 对于任意一次字符 $c$ 而言，$\textit{word}$ 的 $i-1$ 前缀 $\textit{word}[0..i-1]$ 与 $j$ 前缀 $\textit{word}[0..j]$ 中字符 $c$ 的出现次数必须**同奇偶**。同时，我们**最多**允许有一个字符 $c$，它在两个前缀中出现次数的奇偶性不同。

**提示 $2$**

由于题目保证了 $\textit{word}$ 中只会包含前 $10$ 个小写字母，因此我们可以用一个长度为 $10$ 的二进制数 $\textit{mask}$ 表示 $\textit{word}$ 的前缀中 $[\text{a}, \text{j}]$ 出现次数的奇偶性，其中 $\textit{mask}$ 的第 $i$ 位为 $1$ 表示第 $i$ 个字母出现了奇数次，$0$ 表示第 $i$ 个字母出现了偶数次。

记 $\textit{word}$ 的 $k$ 前缀 $\textit{word}[0..k]$ 对应的二进制数为 $\textit{mask}_k$。根据提示 $1$，$\textit{word}[i..j]$ 是最美字符串，当且仅当 $\textit{mask}_{i-1}$ 和 $\textit{mask}_j$ 的二进制表示**最多**只有一位不同。

特别地，如果 $i=0$，那么 $\textit{mask}_{-1} = 0$，即所有字母均未出现过。

**思路与算法**

我们对字符串 $\textit{word}$ 进行一次遍历。

当我们遍历到 $\textit{word}[i]$ 时，我们首先计算出 $\textit{mask}_i$，再遍历 $\textit{mask}_i$ 的 $10$ 个二进制位，将其翻转（从 $0$ 变为 $1$ 或者从 $1$ 变为 $0$）得到 $\textit{mask}'_i$。此时 $\textit{mask}_i$ 和 $\textit{mask}'_i$ 的二进制表示恰好有一位不同。

为了快速计算答案，我们需要使用一个哈希映射 $\textit{freq}$ 存储每一个 $\textit{mask}$ 出现的次数。这样一来，我们直接将答案增加 $\textit{freq}[\textit{mask}'_i]$ 即可。此外，我们还需要将答案增加 $\textit{freq}[\textit{mask}_i]$，即两个前缀出现字母的奇偶性完全相同。

**细节**

在开始遍历前，我们需要将 $\textit{mask}_{-1}$ 放入哈希映射中。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    long long wonderfulSubstrings(string word) {
        unordered_map<int, int> freq = {{0, 1}};
        int mask = 0;
        long long ans = 0;
        for (char ch: word) {
            int idx = ch - 'a';
            mask ^= (1 << idx);
            if (freq.count(mask)) {
                ans += freq[mask];
            }
            for (int i = 0; i < 10; ++i) {
                if (int mask_pre = mask ^ (1 << i); freq.count(mask_pre)) {
                    ans += freq[mask_pre];
                }
            }
            ++freq[mask];
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def wonderfulSubstrings(self, word: str) -> int:
        freq = Counter([0])
        mask, ans = 0, 0
        
        for ch in word:
            idx = ord(ch) - ord("a")
            mask ^= (1 << idx)
            if mask in freq:
                ans += freq[mask]
            for i in range(10):
                mask_pre = mask ^ (1 << i)
                if (mask_pre := mask ^ (1 << i)) in freq:
                    ans += freq[mask_pre]
            freq[mask] += 1
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n|\Sigma|)$，其中 $n$ 是字符串 $\textit{word}$ 的长度，$\Sigma$ 是字符集，在本题中 $|\Sigma|=10$。

- 空间复杂度：$O(\min(n, 2^{|\Sigma|}))$。哈希映射中存储的键值对个数由字符串 $\textit{word}$ 的长度 $n$ 以及 $|\Sigma|$ 位二进制数的总数 $2^{|\Sigma|}$ 共同限制，因此空间复杂度为 $O(\min(n, 2^{|\Sigma|}))$。
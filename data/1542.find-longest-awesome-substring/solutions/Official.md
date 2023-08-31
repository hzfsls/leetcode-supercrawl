## [1542.找出最长的超赞子字符串 中文官方题解](https://leetcode.cn/problems/find-longest-awesome-substring/solutions/100000/zhao-chu-zui-chang-de-chao-zan-zi-zi-fu-chuan-by-l)
#### 方法一：状态压缩 + 哈希表

**思路与算法**

我们首先分析一下「超赞子字符串」的性质：

对于字符串 $s$ 中的一个子串 $s'$，如果其中的字符能以某种顺序组成一个回文串，那么该串就是一个「超赞子字符串」。

这就表明，**$s'$ 中最多只有一个字符出现了奇数次，其余的所有字符都出现了偶数次**。这是因为对于任意一个回文串，如果它的回文中心是单个字符（例如 $\text{abcba}$），回文中心的字符出现了奇数次，其余的所有字符根据对称性出现了偶数次；如果它的回文中心是两个相同的字符（例如 $\text{abccba}$），那么所有字符根据对称性都出现了偶数次。

因此，对于任意一个子串 $s'$ 而言，我们只需要关系它的每一个字符出现了奇数次还是偶数次。由于字符串 $s$ 中仅包含字符 $0$ 到 $9$，因此我们可以用**一个长度为 $10$ 的 $0-1$ 序列来表示任意一个子串 $s'$**。该 $0-1$ 序列从低到高的第 $i$ 位对应着 $s'$ 中出现字符 $i$ 的奇偶性：具体地，$0$ 对应着出现了偶数次，$1$ 对应着出现了奇数次。

> 举个例子，对于子串 $s'= \text{0366613544}$，其中 $0, 1, 3, 4, 5, 6$ 分别出现了 $1, 1, 2, 2, 1, 3$ 次，那么对应的 $0-1$ 序列即为 $\text{0001100011}$。注意序列的最高位对应字符 $9$，最低位对应字符 $0$。

经过上面的分析，我们就可以对「超赞子字符串」进行枚举，这里我们用 $s[i:j]$ 表示字符串 $s$ 中从位置 $i$ 到位置 $j$ 组成的子串，$t[i:j]$ 表示 $s[i:j]$ 对应的 $0-1$ 序列。

我们可以从小到大依次枚举「超赞子字符串」的右端点 $j$。如果存在某个满足 $i < j$ 的位置 $i$，并且 $s[i:j]$ 是「超赞子字符串」，那么必然满足下面的条件：

- $t[0:i-1]$ 与 $t[0:j]$ 最多只有一位不同。特别地，如果 $i=0$，那么 $s[0:i-1]$ 是一个空子串，$t[0:i-1]$ 为全 $0$ 序列。

这是为什么呢？其实和「前缀和」的思想很类似。$s[i:j]$ 中某个字符的出现次数，就等于它在 $s[0:j]$ 中的出现次数减去它在$s[0:i-1]$ 中的出现次数。如果我们只考虑出现次数的奇偶性，那么 **$s[i:j]$ 中某个字符出现的次数为偶数，当且仅当它在 $s[0:j]$ 和 $s[0:i-1]$ 中出现的次数均为奇数或者均为偶数**，也就是 $t[0:j]$ 和 $t[0:i-1]$ 对应的位置相同。因此，如果 $s[i:j]$ 是一个「超赞子字符串」，那么 $t[0:j]$ 和 $t[0:i-1]$ 最多只有一位不同。

这样一来，我们可以在遍历枚举 $j$ 的同时维护 $t[0:j]$，并用哈希映射存储所有之前出现过的 $t[0:i]$，便于后续的查找。对于哈希映射中的每个键值对，键为 $t[0:i]$，值为 $i$。在枚举 $j$ 时，我们在哈希映射中查询 $t[0:j]$ 本身以及将 $t[0:j]$ 的某一位翻转后得到的 $0-1$ 序列，查询到的的每一个值 $i-1$，都对应着一个「超赞子字符串」$s[i:j]$。

> 将某一位翻转的意思是：将某一位的 $0$ 变为 $1$，或将 $1$ 变为 $0$。

在这之后，我们将 $(t[0:j], j)$ 这一键值对放入哈希映射。注意：如果 $t[0:j]$ 已经是哈希映射中的一个键，我们需要忽略这一步操作，这是因为我们要求的是**最长的**「超赞子字符串」，所以当两个前缀的 $0-1$ 序列相同时，我们应当保留较短的前缀，而忽略较长的前缀。

**细节**

我们可以用一个 $[0, 1024)$ 之间的整数来维护 $0-1$ 序列，这实际上就是 $0-1$ 序列对应的二进制表示。对于一次翻转操作，如果我们要将 $t[0:j]$ 的第 $k$ 位进行翻转，只要使用

$$
t[0:j] \oplus (2^k)
$$

即可。其中 $\oplus$ 表示按位异或运算，$2^k$ 可以使用左移运算 `1 << k` 快速得到。

此外，空前缀（即 $i = 0$）也对应着哈希映射中的一个键值对 $(0, -1)$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int longestAwesome(string s) {
        int n = s.size();
        unordered_map<int, int> prefix = {{0, -1}};
        int ans = 0;
        int sequence = 0;
        for (int j = 0; j < n; ++j) {
            int digit = s[j] - '0';
            sequence ^= (1 << digit);
            if (prefix.count(sequence)) {
                ans = max(ans, j - prefix[sequence]);
            } else {
                prefix[sequence] = j;
            }
            for (int k = 0; k < 10; ++k) {
                if (prefix.count(sequence ^ (1 << k))) {
                    ans = max(ans, j - prefix[sequence ^ (1 << k)]);
                }
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int longestAwesome(String s) {
        int n = s.length();
        Map<Integer, Integer> prefix = new HashMap<Integer, Integer>();
        prefix.put(0, -1);
        int ans = 0;
        int sequence = 0;
        for (int j = 0; j < n; ++j) {
            int digit = s.charAt(j) - '0';
            sequence ^= (1 << digit);
            if (prefix.containsKey(sequence)) {
                ans = Math.max(ans, j - prefix.get(sequence));
            } else {
                prefix.put(sequence, j);
            }
            for (int k = 0; k < 10; ++k) {
                if (prefix.containsKey(sequence ^ (1 << k))) {
                    ans = Math.max(ans, j - prefix.get(sequence ^ (1 << k)));
                }
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def longestAwesome(self, s: str) -> int:
        n = len(s)
        prefix = {0: -1}
        ans, sequence = 0, 0

        for j in range(n):
            digit = ord(s[j]) - ord("0")
            sequence ^= (1 << digit)
            if sequence in prefix:
                ans = max(ans, j - prefix[sequence])
            else:
                prefix[sequence] = j
            for k in range(10):
                if sequence ^ (1 << k) in prefix:
                    ans = max(ans, j - prefix[sequence ^ (1 << k)])
        
        return ans
```

```C [sol1-C]
int longestAwesome(char* s) {
    int n = strlen(s);
    int prefix[200001];
    for (int i = 0; i <= 200000; i++) prefix[i] = -2;
    prefix[100000] = -1;
    int ans = 0;
    int sequence = 0;
    for (int j = 0; j < n; ++j) {
        int digit = s[j] - '0';
        sequence ^= (1 << digit);
        if (prefix[sequence + 100000] != -2) {
            ans = fmax(ans, j - prefix[sequence + 100000]);
        } else {
            prefix[sequence + 100000] = j;
        }
        for (int k = 0; k < 10; ++k) {
            if (prefix[(sequence ^ (1 << k)) + 100000] != -2) {
                ans = fmax(ans, j - prefix[(sequence ^ (1 << k)) + 100000]);
            }
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n |\Sigma|)$，其中 $n$ 是字符串 $s$ 的长度，$\Sigma$ 表示字符集，在本题中字符串只包含 $10$ 个数字字符，$|\Sigma| = 10$。

- 空间复杂度：$O(\min\{n, 2^{|\Sigma|}\})$，即为哈希映射使用的空间。哈希映射中的每个键值对使用的空间为 $O(1)$，而键值对的总数目由字符串 $s$ 的前缀串个数 $n+1$ 以及 $0-1$ 序列的总数目 $2^{|\Sigma|}$ 共同决定。
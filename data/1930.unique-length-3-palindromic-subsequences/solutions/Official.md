#### 方法一：枚举两侧的字符

**思路与算法**

我们可以枚举回文序列两侧的字符**种类**。对于每种字符，如果它在字符串 $s$ 中出现，我们记录它**第一次**出现的下标 $l$ 与**最后一次**出现的下标 $r$。那么，以该字符为两侧的回文子序列，它中间的字符只可能在 $s[l+1..r-1]$ 中选取；且以该字符为两侧的回文子序列的种数即为 $s[l+1..r-1]$ 中的字符种数。

我们遍历 $s[l+1..r-1]$ 子串计算该子串中的字符种数。在遍历时，我们可以使用哈希集合来维护该子串中的字符种类；当遍历完成后，哈希集合内元素的数目即为该子串中的字符总数。

在枚举两侧字符种类时，我们维护这些回文子序列种数之和，并最终作为答案返回。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countPalindromicSubsequence(string s) {
        int n = s.size();
        int res = 0;
        // 枚举两侧字符
        for (char ch = 'a'; ch <= 'z'; ++ch){
            int l = 0, r = n - 1;
            // 寻找该字符第一次出现的下标
            while (l < n && s[l] != ch){
                ++l;
            }
            // 寻找该字符最后一次出现的下标
            while (r >= 0 && s[r] != ch){
                --r;
            }
            if (r - l < 2){
                // 该字符未出现，或两下标中间的子串不存在
                continue;
            }
            // 利用哈希集合统计 s[l+1..r-1] 子串的字符总数，并更新答案
            unordered_set<char> charset;
            for (int k = l + 1; k < r; ++k){
                charset.insert(s[k]);
            }
            res += charset.size();
        }
        return res;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def countPalindromicSubsequence(self, s: str) -> int:
        n = len(s)
        res = 0
        # 枚举两侧字符
        for i in range(26):
            l, r = 0, n - 1
            # 寻找该字符第一次出现的下标
            while l < n and ord(s[l]) - ord('a') != i:
                l += 1
            # 寻找该字符最后一次出现的下标
            while r >= 0 and ord(s[r]) - ord('a') != i:
                r -= 1
            if r - l < 2:
                # 该字符未出现，或两下标中间的子串不存在
                continue
            # 利用哈希集合统计 s[l+1..r-1] 子串的字符总数，并更新答案
            charset = set()
            for k in range(l + 1, r):
                charset.add(s[k])
            res += len(charset)
        return res
```

**复杂度分析**

- 时间复杂度：$O(n|\Sigma| + |\Sigma|^2)$，其中 $n$ 为 $s$ 的长度，$|\Sigma|$ 为字符集的大小。我们总共需要枚举 $|\Sigma|$ 种字符，每次枚举至多需要遍历一次字符串 $s$ 与哈希集合，时间复杂度分别为 $O(n)$ 与 $O(|\Sigma|)$。

- 空间复杂度：$O(|\Sigma|)$，即为哈希集合的空间开销。

#### 方法二：枚举中间的字符

**思路与算法**

我们也可以遍历字符串 $s$ 枚举回文子序列中间的字符。假设 $s$ 的长度为 $n$，当我们遍历到 $s[i]$ 时，以 $s[i]$ 为中间字符的回文子序列种数即为前缀 $s[0..i-1]$ 与后缀 $s[i+1..n-1]$ 的公共字符种数。

对于一个任意的子串，由于其仅由小写英文字母组成，我们可以用一个 $32$ 位整数来表示该子串含有哪些字符。如果该整数从低到高第 $i$ 个二进制位为 $1$，那么代表该子串含有字典序为 $i$ 的小写英文字母。在遍历该子串时，我们需要用**按位或**来维护该整数。

为了简化计算，我们可以参照前文所述的对应关系，用两个 $32$ 位整数的数组 $\textit{pre}, \textit{suf}$ 分别维护 $s$ 中前缀与后缀包含的字符。其中，$\textit{pre}[i]$ 代表前缀 $s[0..i-1]$ 包含的字符种类，$\textit{suf}[i]$ 代表后缀 $s[i+1..n-1]$ 包含的字符种类。那么，以 $s[i]$ 为中间字符的回文子序列中，两侧字符的种类对应的状态即为 $\textit{pre}[i] \& \textit{suf}[i]$，其中 $\&$ 为**按位与**运算符。

为了避免重复计算，我们需要在遍历的同时使用**按位或**来维护**每种**字符为中间字符的回文子序列种数。最终，我们将不同种类字符对应的回文子序列总数求和作为答案返回。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countPalindromicSubsequence(string s) {
        int n = s.size();
        int res = 0;
        // 前缀/后缀字符状态数组
        vector<int> pre(n), suf(n);
        for (int i = 0; i < n; ++i) {
            // 前缀 s[0..i-1] 包含的字符种类
            pre[i] = (i ? pre[i-1] : 0) | (1 << (s[i] - 'a'));
        }
        for (int i = n - 1; i >= 0; --i) {
            // 后缀 s[i+1..n-1] 包含的字符种类
            suf[i] = (i != n - 1 ? suf[i+1] : 0) | (1 << (s[i] - 'a'));
        }
        // 每种中间字符的回文子序列状态数组
        vector<int> ans(26);
        for (int i = 1; i < n - 1; ++i) {
            ans[s[i]-'a'] |= (pre[i-1] & suf[i+1]);
        }
        // 更新答案
        for (int i = 0; i < 26; ++i) {
            res += __builtin_popcount(ans[i]);
        }
        return res;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def countPalindromicSubsequence(self, s: str) -> int:
        n = len(s)
        res = 0
        # 前缀/后缀字符状态数组
        pre = [0] * n
        suf = [0] * n
        for i in range(n):
            # 前缀 s[0..i-1] 包含的字符种类
            pre[i] = (pre[i-1] if i else 0) | (1 << (ord(s[i]) - ord('a')))
        for i in range(n - 1, -1, -1):
            # 后缀 s[i+1..n-1] 包含的字符种类
            suf[i] = (suf[i+1] if i != n - 1 else 0) | (1 << (ord(s[i]) - ord('a')))
        # 每种中间字符的回文子序列状态数组
        ans = [0] * 26
        for i in range(1, n - 1):
            ans[ord(s[i])-ord('a')] |= pre[i-1] & suf[i+1]
        # 更新答案
        for i in range(26):
            res += bin(ans[i]).count("1")
        return res
```

**复杂度分析**

- 时间复杂度：$O(n + |\Sigma|)$，其中 $n$ 为 $s$ 的长度，$|\Sigma|$ 为字符集的大小。预处理前后缀状态数组与遍历 $s$ 更新每种字符状态数组的时间复杂度均为 $O(n)$，初始化每种字符状态数组与更新答案的时间复杂度均为 $O(|\Sigma|)$。

- 空间复杂度：$O(|\Sigma|)$，即为每种字符状态数组的空间开销。
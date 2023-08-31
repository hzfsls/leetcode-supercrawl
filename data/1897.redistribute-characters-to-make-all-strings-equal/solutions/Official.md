## [1897.重新分配字符使所有字符串都相等 中文官方题解](https://leetcode.cn/problems/redistribute-characters-to-make-all-strings-equal/solutions/100000/zhong-xin-fen-pei-zi-fu-shi-suo-you-zi-f-r29g)
#### 方法一：统计每种字符的频数

**思路与算法**

我们可以**任意**进行移动字符的操作。因此，假设 $\textit{words}$ 的长度为 $n$，我们只需要使得每种字符的总出现次数能够被 $n$ 整除，即可以存在一种操作，使得操作后所有字符串均相等。

我们用 $\textit{cnt}$ 数组维护每种字符的频数。由于每个字符串 $\textit{words}[i]$ 仅由小写英文字母组成，因此我们将 $\textit{cnt}$ 的长度设为对应字符集的大小 $|\Sigma| = 26$。同时，$\textit{cnt}[k]$ 对应字典序第 $k$ 个字符的频数。

为了判断是否可行，我们遍历 $\textit{words}$ 中的每个字符串统计每种字符的频数，并最终判断它们是否均可以被 $n$ 整除。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool makeEqual(vector<string>& words) {
        vector<int> cnt(26, 0);   // 每种字符的频数
        int n = words.size();
        for (const string& wd: words){
            for (char ch: wd){
                ++cnt[ch-'a'];
            }
        }
        return all_of(cnt.begin(), cnt.end(), [n](int x){ return x % n == 0; });
    }
};
```

```Python [sol1-Python3]
class Solution:
    def makeEqual(self, words: List[str]) -> bool:
        cnt = [0] * 26   # 每种字符的频数
        n = len(words)
        for wd in words:
            for ch in wd:
                cnt[ord(ch)-ord('a')] += 1
        return all(k % n == 0 for k in cnt)
```

**复杂度分析**

- 时间复杂度：$O(m + |\Sigma|)$，其中 $m$ 为 $\textit{words}$ 中所有字符串的**长度总和**，$|\Sigma|$ 为字符集的大小，本题中即为所有小写英文字符的数量。初始化 $\textit{cnt}$ 数组的时间复杂度为 $O(|\Sigma|)$，遍历统计每个字符数量的时间复杂度为 $O(m)$，判断整除的时间复杂度为 $O(|\Sigma|)$。

- 空间复杂度：$O(|\Sigma|)$，即为 $\textit{cnt}$ 数组的大小。
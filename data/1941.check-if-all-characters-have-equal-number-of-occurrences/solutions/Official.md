#### 方法一：统计每个字符的频数

**思路与算法**

首先，我们遍历字符串 $s$，并用哈希表 $\textit{freq}$ 统计每个字符的频数。随后，我们需要检查哈希表 $\textit{freq}$ 中每个字符的频数是否相等。

我们可以计算出满足要求时每个字符的理论频数 $\textit{occ} = \textit{s.size}() / \textit{freq.size}()$，并比较 $\textit{freq}$ 中每个字符的频数是否与 $\textit{occ}$ 相等。如果全部相等，那么说明符合要求，此时应返回 $\texttt{true}$ 作为答案，反之亦然。

为了避免无法整除产生浮点数与整数的比较，我们可以在计算 $\textit{occ}$ 时用整除来代替除法，此时该判断方法依旧有效。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool areOccurrencesEqual(string s) {
        unordered_map<char, int> freq;   // 每个字符的实际频数
        for (const char ch : s){
            if (!freq.count(ch)){
                freq[ch] = 0;
            }
            ++freq[ch];
        }
        int occ = s.size() / freq.size();   // 每个字符的理论频数
        for (auto&& [_, v] : freq){
            if (v != occ){
                return false;
            }
        }
        return true;
    }
};
```

```Python [sol1-Python3]
from collections import Counter

class Solution:
    def areOccurrencesEqual(self, s: str) -> bool:
        freq = Counter(s)   # 每个字符的实际频数
        occ = len(s) // len(freq)    # 每个字符的理论频数
        return all(v == occ for v in freq.values())
```

**复杂度分析**

- 时间复杂度：$O(n + |\Sigma|)$，其中 $n$ 为 $s$ 的长度，$|\Sigma|$ 为字符集的大小。遍历 $s$ 生成字符频数哈希表的时间复杂度为 $O(n)$，遍历所有频数判断是否相等的时间复杂度为 $O(|\Sigma|)$。

- 空间复杂度：$O(|\Sigma|)$，即为字符频数哈希表和频数哈希集合的空间复杂度。
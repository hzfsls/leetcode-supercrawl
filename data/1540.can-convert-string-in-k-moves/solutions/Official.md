## [1540.K 次操作转变字符串 中文官方题解](https://leetcode.cn/problems/can-convert-string-in-k-moves/solutions/100000/k-ci-cao-zuo-zhuan-bian-zi-fu-chuan-by-leetcode-so)

#### 方法一：统计操作次数

由于每次操作只是切换字符串中的字符，不会改变字符串的长度，因此只有当字符串 $s$ 和 $t$ 的长度相等时，才可能将 $s$ 转变成 $t$。如果 $s$ 和 $t$ 的长度不相等，直接返回 $\text{false}$ 即可。

对于每个下标，如果 $s$ 和 $t$ 在该下标位置的字符不相同，则需要进行切换，所需**最小切换次数**最多为 $25$。因此，遍历 $s$ 和 $t$，计算每个下标的最小切换次数（如果不需要切换，则最小切换次数为 $0$），并统计每个最小切换次数的出现次数。

由于每次操作只能对一个未选过的下标位置的字符进行切换，因此如果有两个下标的最小切换次数相同，则如果其中的一个下标在第 $i$ 次操作时进行了切换，另一个下标必须等到第 $i+26$ 次操作时才能进行切换。如果有多个下标的最小切换次数相同，则每个下标都必须在前一个下标进行切换操作之后的第 $26$ 次操作才能进行切换。

如果有 $j$ 个下标的最小切换次数都是 $i$，其中 $1 \le i \le 25$，则需要 $i+26 \times (j-1)$ 次操作才能将 $j$ 个下标的字符都切换。如果 $i+26 \times (j-1)>k$，则无法在 $k$ 次操作以内完成全部的切换操作，因此返回 $\text{false}$。

如果对于所有的最小切换次数，所有的下标都可以在 $k$ 次操作以内进行切换，则返回 $\text{true}$。

```Java [sol1-Java]
class Solution {
    public boolean canConvertString(String s, String t, int k) {
        if (s.length() != t.length()) {
            return false;
        }
        int[] counts = new int[26];
        int length = s.length();
        for (int i = 0; i < length; i++) {
            int difference = t.charAt(i) - s.charAt(i);
            if (difference < 0) {
                difference += 26;
            }
            counts[difference]++;
        }
        for (int i = 1; i < 26; i++) {
            int maxConvert = i + 26 * (counts[i] - 1);
            if (maxConvert > k) {
                return false;
            }
        }
        return true;
    }
}
```

```cpp [sol1-C++]
class Solution {
public:
    bool canConvertString(string s, string t, int k) {
        if (s.size() != t.size()) {
            return false;
        }
        auto counts = vector<int>(26);
        int length = s.size();
        for (int i = 0; i < length; i++) {
            int difference = t.at(i) - s.at(i);
            if (difference < 0) {
                difference += 26;
            }
            counts[difference]++;
        }
        for (int i = 1; i < 26; i++) {
            int maxConvert = i + 26 * (counts[i] - 1);
            if (maxConvert > k) {
                return false;
            }
        }
        return true;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def canConvertString(self, s: str, t: str, k: int) -> bool:
        if len(s) != len(t):
            return False
        
        counts = [0] * 26
        for si, ti in zip(s, t):
            difference = ord(ti) - ord(si)
            if difference < 0:
                difference += 26
            counts[difference] += 1
        
        for i, count in enumerate(counts[1:], 1):
            maxConvert = i + 26 * (counts[i] - 1)
            if maxConvert > k:
                return False
        
        return True
```

**复杂度分析**

- 时间复杂度：$O(n+|\Sigma|)$，其中 $n$ 是字符串 $s$ 和 $t$ 的长度，$\Sigma$ 是字符集（即字符串中可能出现的字符种类数），在本题中字符串只包含小写字母，因此 $|\Sigma| = 26$。只有当字符串 $s$ 和 $t$ 的长度相等时才需要进行进一步判断，对两个字符串各遍历一次，时间复杂度是 $O(n)$，然后统计每个最小切换次数对应的下标出现次数并计算所需操作次数，对于字符集 $\Sigma$，最小切换次数最多为 $|\Sigma|-1$，计算所需操作次数可以在 $O(|\Sigma|)$ 时间内完成，因此总时间复杂度是 $O(n+|\Sigma|)$。

- 空间复杂度：$O(|\Sigma|)$，其中 $\Sigma$ 是字符集，在本题中字符串只包含小写字母，因此 $|\Sigma| = 26$。需要使用数组存储每个最小切换次数的出现次数，对于字符集 $\Sigma$，最小切换次数最多为 $|\Sigma|-1$。
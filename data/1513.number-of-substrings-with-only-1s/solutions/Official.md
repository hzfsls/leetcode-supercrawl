## [1513.仅含 1 的子串数 中文官方题解](https://leetcode.cn/problems/number-of-substrings-with-only-1s/solutions/100000/jin-han-1-de-zi-chuan-shu-by-leetcode-solution)

#### 方法一：遍历字符串寻找最长子串

如果一个所有字符都为 `1` 的字符串的长度为 `k`，则该字符串包含的所有字符都为 `1` 的子字符串（包括该字符串本身）的数量是 `k * (k + 1) / 2`。

首先寻找到所有的只包含字符 `1` 的最长子字符串。这里的「只包含字符 `1` 的最长子字符串」的意思是，假设该子字符串的下标范围是 `[i, j]`（包含下标 `i` 和下标 `j`），其中 `i <= j`，该子字符串中的所有字符都是 `1`，且下标 `i` 满足 `i` 位于字符串 `s` 的最左侧或者下标 `i - 1` 位置的字符是 `0`，以及下标 `j` 满足 `j` 位于字符串 `s` 的最右侧或者下标 `j + 1` 位置的字符是 `0`。

寻找到所有的只包含字符 `1` 的最长子字符串之后，就可以计算所有字符都为 `1` 的子字符串的数量。

具体做法是，从左到右遍历字符串，如果遇到字符 `1` 则计算连续字符 `1` 的数量，如果遇到字符 `0` 则说明上一个只包含字符 `1` 的最长子字符串遍历结束，根据最长子字符串的长度计算子字符串的数量，然后将连续字符 `1` 的数量清零。遍历结束后，如果连续字符 `1` 的数量大于零，则还有最后一个只包含字符 `1` 的最长子字符串，因此还需要计算其对应的子字符串的数量。

```Java [sol1-Java]
class Solution {
    public int numSub(String s) {
        final int MODULO = 1000000007;
        long total = 0;
        int length = s.length();
        long consecutive = 0;
        for (int i = 0; i < length; i++) {
            char c = s.charAt(i);
            if (c == '0') {
                total += consecutive * (consecutive + 1) / 2;
                total %= MODULO;
                consecutive = 0;
            } else {
                consecutive++;
            }
        }
        total += consecutive * (consecutive + 1) / 2;
        total %= MODULO;
        return (int) total;
    }
}
```

```cpp [sol1-C++]
class Solution {
public:
    static constexpr int P = int(1E9) + 7;
    
    int numSub(string s) {
        int p = 0;
        long long ans = 0;
        while (p < s.size()) {
            if (s[p] == '0') {
                ++p;
                continue;
            }
            int cnt = 0;
            while (p < s.size() && s[p] == '1') {
                ++cnt;
                ++p;
            }
            ans = ans + (1LL + (long long)cnt) * cnt / 2;
            ans = ans % P;
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def numSub(self, s: str) -> int:
        total, consecutive = 0, 0
        length = len(s)
        for i in range(length):
            if s[i] == '0':
                total += consecutive * (consecutive + 1) // 2
                consecutive = 0
            else:
                consecutive += 1
        
        total += consecutive * (consecutive + 1) // 2
        total %= (10**9 + 7)
        return total
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串的长度。需要遍历字符串一次。

- 空间复杂度：$O(1)$。只需要维护有限的变量，空间复杂度是常数。
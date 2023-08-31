## [409.最长回文串 中文官方题解](https://leetcode.cn/problems/longest-palindrome/solutions/100000/zui-chang-hui-wen-chuan-by-leetcode-solution)
### 📺 视频题解  
![409. 最长回文串.mp4](f015cd5b-ceb9-47b3-a20d-27f5e6cdee0d)

### 📖 文字题解

#### 方法一：贪心

**思路**

回文串是一个正着读和反着读都一样的字符串。以回文中心为分界线，对于回文串中左侧的字符 `ch`，在右侧对称的位置也会出现同样的字符。例如在字符串 `"abba"` 中，回文中心是 `"ab|ba"` 中竖线的位置，而在字符串 `"abcba"` 中，回文中心是 `"ab(c)ba"` 中的字符 `"c"` 本身。我们可以发现，在一个回文串中，只有最多一个字符出现了奇数次，其余的字符都出现偶数次。

那么我们如何通过给定的字符构造一个回文串呢？我们可以将每个字符使用偶数次，使得它们根据回文中心对称。在这之后，如果有剩余的字符，我们可以再取出一个，作为回文中心。

**算法**

对于每个字符 `ch`，假设它出现了 `v` 次，我们可以使用该字符 `v / 2 * 2` 次，在回文串的左侧和右侧分别放置 `v / 2` 个字符 `ch`，其中 `/` 为整数除法。例如若 `"a"` 出现了 `5` 次，那么我们可以使用 `"a"` 的次数为 `4`，回文串的左右两侧分别放置 `2` 个 `"a"`。

如果有任何一个字符 `ch` 的出现次数 `v` 为奇数（即 `v % 2 == 1`），那么可以将这个字符作为回文中心，注意只能最多有一个字符作为回文中心。在代码中，我们用 `ans` 存储回文串的长度，由于在遍历字符时，`ans` 每次会增加 `v / 2 * 2`，因此 `ans` 一直为偶数。但在发现了第一个出现次数为奇数的字符后，我们将 `ans` 增加 `1`，这样 `ans` 变为奇数，在后面发现其它出现奇数次的字符时，我们就不改变 `ans` 的值了。

```Java [sol1-Java]
class Solution {
    public int longestPalindrome(String s) {
        int[] count = new int[128];
        int length = s.length();
        for (int i = 0; i < length; ++i) {
            char c = s.charAt(i);
            count[c]++;
        }

        int ans = 0;
        for (int v: count) {
            ans += v / 2 * 2;
            if (v % 2 == 1 && ans % 2 == 0) {
                ans++;
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def longestPalindrome(self, s: str) -> int:
        ans = 0
        count = collections.Counter(s)
        for v in count.values():
            ans += v // 2 * 2
            if ans % 2 == 0 and v % 2 == 1:
                ans += 1
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int longestPalindrome(string s) {
        unordered_map<char, int> count;
        int ans = 0;
        for (char c : s)
            ++count[c];
        for (auto p : count) {
            int v = p.second;
            ans += v / 2 * 2;
            if (v % 2 == 1 and ans % 2 == 0)
                ++ans;
        }
        return ans;
    }
};
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 为字符串 `s` 的长度。我们需要遍历每个字符一次。

- 空间复杂度：$O(S)$，其中 $S$ 为字符集大小。在 Java 代码中，我们使用了一个长度为 `128` 的数组，存储每个字符出现的次数，这是因为字符的 ASCII 值的范围为 `[0, 128)`。而由于题目中保证了给定的字符串 `s` 只包含大小写字母，因此我们也可以使用哈希映射（HashMap）来存储每个字符出现的次数，例如 Python 和 C++ 的代码。如果使用哈希映射，最多只会存储 `52` 个（即小写字母与大写字母的数量之和）键值对。
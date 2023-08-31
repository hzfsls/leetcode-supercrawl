## [1573.分割字符串的方案数 中文官方题解](https://leetcode.cn/problems/number-of-ways-to-split-a-string/solutions/100000/fen-ge-zi-fu-chuan-de-fang-an-shu-by-leetcode-solu)

#### 方法一：模拟

要将字符串 $s$ 分割成 $3$ 个非空子字符串，且每个子字符串中的字符 $1$ 的数目相同，显然字符串 $s$ 中的字符 $1$ 的数目必须是 $3$ 的倍数，否则不可能满足 $3$ 个子字符串中的字符 $1$ 的数目相同。当字符串 $s$ 中的字符 $1$ 的数目确定时，每个子字符串中的字符 $1$ 的数目也是确定的。

假设字符串 $s$ 的长度为 $n$，字符串 $s$ 中的字符 $1$ 的数目为 $m$。遍历字符串 $s$，记录每个字符 $1$ 的下标位置，并计算 $m$ 的值。

如果 $m$ 不是 $3$ 的倍数，则不存在符合题目要求的分割 $s$ 的方案，因此返回 $0$。

如果 $m$ 是 $3$ 的倍数，则分别考虑 $m=0$ 和 $m>0$ 的情况：

- 如果 $m=0$，则字符串 $s$ 中的所有字符都为 $0$，因此可以在 $s$ 的内部的任何位置进行分割。由于 $s$ 的长度为 $n$，因此有 $n-1$ 个分割位置，选择 $2$ 个不同的分割位置即可将 $s$ 分成 $3$ 个非空子字符串，因此分割 $s$ 的方案数为 $\binom{n-1}{2}=\frac{(n-1)(n-2)}{2}$。

- 如果 $m>0$，则每个子字符串都包含 $m/3$ 个字符 $1$。假设 $3$ 个子字符串从左到右依次为 $s_1$、$s_2$、$s_3$，其中 $s_1$ 的最后一个字符 $1$ 和 $s_2$ 的第一个字符 $1$ 之间的距离为 $\textit{count}_1$，$s_2$ 的最后一个字符 $1$ 和 $s_3$ 的第一个字符 $1$ 之间的距离为 $\textit{count}_2$，则对应的两个字符 $1$ 之间的字符 $0$ 的个数分别为 $\textit{count}_1-1$ 和 $\textit{count}_2-1$，分别有 $\textit{count}_1$ 和 $\textit{count}_2$ 个分割位置，因此分割 $s$ 的方案数为 $\textit{count}_1 \times \textit{count}_2$。

```Java [sol1-Java]
class Solution {
    public int numWays(String s) {
        final int MODULO = 1000000007;
        List<Integer> ones = new ArrayList<Integer>();
        int n = s.length();
        for (int i = 0; i < n; i++) {
            if (s.charAt(i) == '1') {
                ones.add(i);
            }
        }
        int m = ones.size();
        if (m % 3 != 0)
            return 0;
        if (m == 0) {
            long ways = (long) (n - 1) * (n - 2) / 2;
            return (int) (ways % MODULO);
        } else {
            int index1 = m / 3, index2 = m / 3 * 2;
            int count1 = ones.get(index1) - ones.get(index1 - 1);
            int count2 = ones.get(index2) - ones.get(index2 - 1);
            long ways = (long) count1 * count2;
            return (int) (ways % MODULO);
        }
    }
}
```

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int MODULO = 1000000007;

public:
    int numWays(string s) {
        vector<int> ones;
        int n = s.size();
        for (int i = 0; i < n; ++i) {
            if (s[i] == '1') {
                ones.push_back(i);
            }
        }
        
        int m = ones.size();
        if (m % 3 != 0) {
            return 0;
        }
        if (m == 0) {
            long long ways = (long long)(n - 1) * (n - 2) / 2;
            return ways % MODULO;
        }
        else {
            int index1 = m / 3, index2 = m / 3 * 2;
            int count1 = ones[index1] - ones[index1 - 1];
            int count2 = ones[index2] - ones[index2 - 1];
            long long ways = (long long)count1 * count2;
            return ways % MODULO;
        }
    }
};
```

```Python [sol1-Python3]
class Solution:
    def numWays(self, s: str) -> int:
        MODULO = 1000000007

        ones = list()
        n = len(s)
        for i, digit in enumerate(s):
            if digit == "1":
                ones.append(i)
        
        m = len(ones)
        if m % 3 != 0:
            return 0
        
        if m == 0:
            ways = (n - 1) * (n - 2) // 2
            return ways % MODULO
        else:
            index1, index2 = m // 3, m // 3 * 2;
            count1 = ones[index1] - ones[index1 - 1]
            count2 = ones[index2] - ones[index2 - 1]
            ways = count1 * count2
            return ways % MODULO
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。遍历字符串一次，得到所有字符 $1$ 的下标位置，然后计算分割字符串的方案数，上述操作的时间复杂度都是 $O(1)$。

- 空间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。需要记录每个字符 $1$ 的下标位置，字符 $1$ 的个数不会超过字符串的长度。
#### 方法一：动态规划

**思路及算法**

要使得左右两部分不同字符的数量相同，首先要统计一侧的不同字符数量。

注意到当我们已经统计出字符串的前 $i-1$ 个字符中的不同字符数量时，我们可以利用该信息算出字符串前 $i$ 个字符的不同字符数量。记字符串的前 $i$ 个字符（为了方便处理边界情况，下标从 $1$ 开始编号）中的不同字符数量为 $f[i]$，当第 $i$ 个字符在字符串前 $i-1$ 个字符中出现过时，$f[i]=f[i-1]$，否则 $f[i]=f[i-1]+1$。

$$
f[i]=
\begin{cases}
f[i-1], & \text{第 $i$ 个字符在字符串前 $i-1$ 个字符中出现过} \\
f[i-1]+1, & \text{第 $i$ 个字符在字符串前 $i-1$ 个字符中没有出现过}
\end{cases}
$$

特别地，$f[0]=0$。

为了判断第 $i$ 个字符是否在字符串前 $i-1$ 个字符中出现过，我们可以用一个布尔类型的数组 $\text{rec}$ 进行标记，令 $\text{rec}[i]$ 表示字符 $i$ 是否出现过。这样我们只需要在统计的同时，不断更新这个 $\text{rec}$ 数组，即可实现每次 $O(1)$ 地查询字符串中第 $i$ 个字符是否出现过。

实现了统计一侧的不同字符数量的功能，我们可以如法炮制，只需要将动态规划的计算顺序进行反向，就能统计出另一侧的不同字符数量。

最后我们枚举每一个位置，判断其两侧的字符数量是否相同，即可知道这个位置的分割是不是一个「好分割」。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int numSplits(string s) {
        int n = s.length();
        vector<int> left(n + 2), right(n + 2);
        bitset<26> rec_left, rec_right;
        for (int i = 1; i <= n; i++) {
            int c = s[i - 1] - 'a';
            if (rec_left.test(c)) {
                left[i] = left[i - 1];
            } else {
                rec_left.set(c);
                left[i] = left[i - 1] + 1;
            }
        }
        for (int i = n; i > 0; i--) {
            int c = s[i - 1] - 'a';
            if (rec_right.test(c)) {
                right[i] = right[i + 1];
            } else {
                rec_right.set(c);
                right[i] = right[i + 1] + 1;
            }
        }
        int ret = 0;
        for (int i = 1; i < n; i++) {
            if (left[i] == right[i + 1]) {
                ret++;
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numSplits(String s) {
        int n = s.length();
        int[] left = new int[n + 2];
        int[] right = new int[n + 2];
        boolean[] recLeft = new boolean[26];
        boolean[] recRight = new boolean[26];
        for (int i = 1; i <= n; i++) {
            int c = s.charAt(i - 1) - 'a';
            if (recLeft[c]) {
                left[i] = left[i - 1];
            } else {
                recLeft[c] = true;;
                left[i] = left[i - 1] + 1;
            }
        }
        for (int i = n; i > 0; i--) {
            int c = s.charAt(i - 1) - 'a';
            if (recRight[c]) {
                right[i] = right[i + 1];
            } else {
                recRight[c] = true;
                right[i] = right[i + 1] + 1;
            }
        }
        int ret = 0;
        for (int i = 1; i < n; i++) {
            if (left[i] == right[i + 1]) {
                ret++;
            }
        }
        return ret;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def numSplits(self, s: str) -> int:
        n = len(s)
        left, right = [0] * (n + 2), [0] * (n + 2)

        rec_left = [False] * 26
        rec_right = [False] * 26
        for i in range(1, n + 1):
            c = ord(s[i - 1]) - ord("a")
            if rec_left[c]:
                left[i] = left[i - 1]
            else:
                rec_left[c] = True
                left[i] = left[i - 1] + 1
        
        for i in range(n, 0, -1):
            c = ord(s[i - 1]) - ord("a")
            if (rec_right[c]):
                right[i] = right[i + 1]
            else:
                rec_right[c] = True
                right[i] = right[i + 1] + 1
        
        ret = sum(1 for i in range(1, n) if left[i] == right[i + 1])
        return ret
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为给定字符串的长度。

- 空间复杂度：$O(n+|\Sigma|)$，其中 $n$ 为给定字符串的长度，$\Sigma$ 为字符集，在本题中字符串只包含小写字母，$|\Sigma| = 26$。
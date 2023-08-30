#### 方法一：动态规划

由于 $s$ 是周期字符串，对于在 $s$ 中的子串，只要知道子串的第一个字符（或最后一个字符）和子串长度，就能确定这个子串。例如子串以 $\text{`d'}$ 结尾，长度为 $3$，那么该子串为 $\text{``bcd''}$。

题目要求不同的子串个数，那么对于两个以同一个字符结尾的子串，长的那个子串必然包含短的那个。例如 $\text{``abcd''}$ 和 $\text{``bcd''}$ 均以 $\text{`d'}$ 结尾，$\text{``bcd''}$ 是 $\text{``abcd''}$ 的子串。

据此，我们可以定义 $\textit{dp}[\alpha]$ 表示 $p$ 中以字符 $\alpha$ 结尾且在 $s$ 中的子串的最长长度，知道了最长长度，也就知道了不同的子串的个数。

如何计算 $\textit{dp}[\alpha]$ 呢？我们可以在遍历 $p$ 时，维护连续递增的子串长度 $k$。具体来说，遍历到 $p[i]$ 时，如果 $p[i]$ 是 $p[i-1]$ 在字母表中的下一个字母，则将 $k$ 加一，否则将 $k$ 置为 $1$，表示重新开始计算连续递增的子串长度。然后，用 $k$ 更新 $\textit{dp}[p[i]]$ 的最大值。

遍历结束后，$p$ 中以字符 $c$ 结尾且在 $s$ 中的子串有 $\textit{dp}[c]$ 个。例如 $\textit{dp}[\text{`d'}]=3$ 表示子串 $\text{``bcd''}$、$\text{``cd''}$ 和 $\text{``d''}$。

最后答案为 

$$
\sum_{\alpha=\text{`a'}}^{\text{`z'}}\textit{dp}[\alpha]
$$

```Python [sol1-Python3]
class Solution:
    def findSubstringInWraproundString(self, p: str) -> int:
        dp = defaultdict(int)
        k = 0
        for i, ch in enumerate(p):
            if i > 0 and (ord(ch) - ord(p[i - 1])) % 26 == 1:  # 字符之差为 1 或 -25
                k += 1
            else:
                k = 1
            dp[ch] = max(dp[ch], k)
        return sum(dp.values())
```

```C++ [sol1-C++]
class Solution {
public:
    int findSubstringInWraproundString(string p) {
        vector<int> dp(26);
        int k = 0;
        for (int i = 0; i < p.length(); ++i) {
            if (i && (p[i] - p[i - 1] + 26) % 26 == 1) { // 字符之差为 1 或 -25
                ++k;
            } else {
                k = 1;
            }
            dp[p[i] - 'a'] = max(dp[p[i] - 'a'], k);
        }
        return accumulate(dp.begin(), dp.end(), 0);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int findSubstringInWraproundString(String p) {
        int[] dp = new int[26];
        int k = 0;
        for (int i = 0; i < p.length(); ++i) {
            if (i > 0 && (p.charAt(i) - p.charAt(i - 1) + 26) % 26 == 1) { // 字符之差为 1 或 -25
                ++k;
            } else {
                k = 1;
            }
            dp[p.charAt(i) - 'a'] = Math.max(dp[p.charAt(i) - 'a'], k);
        }
        return Arrays.stream(dp).sum();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindSubstringInWraproundString(string p) {
        int[] dp = new int[26];
        int k = 0;
        for (int i = 0; i < p.Length; ++i) {
            if (i > 0 && (p[i] - p[i - 1] + 26) % 26 == 1) { // 字符之差为 1 或 -25
                ++k;
            } else {
                k = 1;
            }
            dp[p[i] - 'a'] = Math.Max(dp[p[i] - 'a'], k);
        }
        return dp.Sum();
    }
}
```

```go [sol1-Golang]
func findSubstringInWraproundString(p string) (ans int) {
    dp := [26]int{}
    k := 0
    for i, ch := range p {
        if i > 0 && (byte(ch)-p[i-1]+26)%26 == 1 { // 字符之差为 1 或 -25
            k++
        } else {
            k = 1
        }
        dp[ch-'a'] = max(dp[ch-'a'], k)
    }
    for _, v := range dp {
        ans += v
    }
    return
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int findSubstringInWraproundString(char * p) {
    int dp[26];
    int len = strlen(p);
    memset(dp, 0, sizeof(dp));
    int k = 0;
    for (int i = 0; i < len; ++i) {
        if (i && (p[i] - p[i - 1] + 26) % 26 == 1) { // 字符之差为 1 或 -25
            ++k;
        } else {
            k = 1;
        }
        dp[p[i] - 'a'] = MAX(dp[p[i] - 'a'], k);
    }
    int res = 0;
    for (int i = 0; i < 26; i++) {
        res += dp[i];
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var findSubstringInWraproundString = function(p) {
    const dp = new Array(26).fill(0);
    let k = 0;
    for (let i = 0; i < p.length; ++i) {
        if (i > 0 && (p[i].charCodeAt() - p[i - 1].charCodeAt() + 26) % 26 === 1) { // 字符之差为 1 或 -25
            ++k;
        } else {
            k = 1;
        }
        dp[p[i].charCodeAt() - 'a'.charCodeAt()] = Math.max(dp[p[i].charCodeAt() - 'a'.charCodeAt()], k);
    }
    return _.sum(dp);
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $p$ 的长度。

- 空间复杂度：$O(|\Sigma|)$，其中 $|\Sigma|$ 为字符集合的大小，本题中字符均为小写字母，故 $|\Sigma|=26$。
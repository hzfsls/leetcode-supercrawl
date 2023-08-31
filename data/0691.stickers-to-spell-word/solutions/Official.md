## [691.贴纸拼词 中文官方题解](https://leetcode.cn/problems/stickers-to-spell-word/solutions/100000/tie-zhi-pin-ci-by-leetcode-solution-9g3z)
#### 方法一：记忆化搜索 + 状态压缩

**思路**

记 $\textit{target}$ 的长度为 $m$，它一共有 $2^m$ 个子序列（包括空子序列和 $\textit{target}$ 本身，字符相同但组成的下标不同的子序列视为不同的子序列）。根据动态规划的思路，拼出某个子序列 $\textit{mask}$ 所需要的最小贴纸数又可以由 $\textit{mask}$ 的子序列来计算，下一段介绍动态规划的思路。

在本题中，定义函数 $\textit{dp}(\textit{mask})$ 来求解不同状态的最小贴纸数，输入是某个子序列 $\textit{mask}$，输出是拼出该子序列的最小贴纸数。计算拼出 $\textit{mask}$ 所需的最小贴纸数时，需要选取最优的 $\textit{sticker}$ 让其贡献部分字符，未被 $\textit{sticker}$ 覆盖的其他字符 $\textit{left}$ 需要用动态规划继续计算。在选取最优的 $\textit{sticker}$ 时，需要遍历所有 $\textit{sticker}$。遍历到某个 $\textit{sticker}$ 时，计算 $\textit{mask}$ 和 $\textit{sticker}$ 字符的最大交集（非空），$\textit{mask}$ 中这部分交集由 $\textit{sticker}$ 贡献，剩余部分的最小贴纸数由动态规划继续计算，而 $\textit{sticker}$ 中不属于最大交集的剩下部分会被舍弃，不会产生任何贡献。遍历完所有 $\textit{sticker}$ 后，选取出所有贴纸数的最小值作为本次规划的结果，这一遍历 $\textit{stickers}$ 并根据剩余部分的最小贴纸数来计算当前 $\textit{mask}$ 的最小贴纸数的步骤完成了状态转移。边界情况是，如果 $\textit{mask}$ 为空集，则贴纸数为 $0$。

在动态规划时，子序列可以用一个二进制数来表示。从低位到高位，某位为 $0$ 则表示在 $\textit{target}$ 中这一位不选取，为 $1$ 则表示选取这一位，从而完成状态压缩的过程。代码实现上，本题解选择了记忆化搜索的方式。

**代码**

```Python [sol1-Python3]
class Solution:
    def minStickers(self, stickers: List[str], target: str) -> int:
        m = len(target)
        @cache
        def dp(mask: int) -> int:
            if mask == 0:
                return 0
            res = m + 1
            for sticker in stickers:
                left = mask
                cnt = Counter(sticker)
                for i, c in enumerate(target):
                    if mask >> i & 1 and cnt[c]:
                        cnt[c] -= 1
                        left ^= 1 << i
                if left < mask:
                    res = min(res, dp(left) + 1)
            return res
        res = dp((1 << m) - 1)
        return res if res <= m else -1
```

```C++ [sol1-C++]
class Solution {
public:
    int minStickers(vector<string>& stickers, string target) {
        int m = target.size();
        vector<int> dp(1 << m, -1);
        dp[0] = 0;
        function<int(int)> helper = [&](int mask) {
            if (dp[mask] != -1) {
                return dp[mask];
            }
            dp[mask] = m + 1;
            for (auto & sticker : stickers) {
                int left = mask;
                vector<int> cnt(26);
                for (char & c : sticker) {
                    cnt[c - 'a']++;
                }
                for (int i = 0; i < m; i++) {
                    if ((mask >> i & 1) && cnt[target[i] - 'a'] > 0) {
                        cnt[target[i] - 'a']--;
                        left ^= 1 << i;
                    }
                }
                if (left < mask) {
                    dp[mask] = min(dp[mask], helper(left) + 1);
                }
            }
            return dp[mask];
        };
        int res = helper((1 << m) - 1);
        return res > m ? -1 : res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minStickers(String[] stickers, String target) {
        int m = target.length();
        int[] memo = new int[1 << m];
        Arrays.fill(memo, -1);
        memo[0] = 0;
        int res = dp(stickers, target, memo, (1 << m) - 1);
        return res <= m ? res : -1;
    }

    public int dp(String[] stickers, String target, int[] memo, int mask) {
        int m = target.length();
        if (memo[mask] < 0) {
            int res = m + 1;
            for (String sticker : stickers) {
                int left = mask;
                int[] cnt = new int[26];
                for (int i = 0; i < sticker.length(); i++) {
                    cnt[sticker.charAt(i) - 'a']++;
                }
                for (int i = 0; i < target.length(); i++) {
                    char c = target.charAt(i);
                    if (((mask >> i) & 1) == 1 && cnt[c - 'a'] > 0) {
                        cnt[c - 'a']--;
                        left ^= 1 << i;
                    }
                }
                if (left < mask) {
                    res = Math.min(res, dp(stickers, target, memo, left) + 1);
                }
            }
            memo[mask] = res;
        }
        return memo[mask];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinStickers(string[] stickers, string target) {
        int m = target.Length;
        int[] memo = new int[1 << m];
        Array.Fill(memo, -1);
        memo[0] = 0;
        int res = DP(stickers, target, memo, (1 << m) - 1);
        return res <= m ? res : -1;
    }

    public int DP(string[] stickers, string target, int[] memo, int mask) {
        int m = target.Length;
        if (memo[mask] < 0) {
            int res = m + 1;
            foreach (string sticker in stickers) {
                int left = mask;
                int[] cnt = new int[26];
                for (int i = 0; i < sticker.Length; i++) {
                    cnt[sticker[i] - 'a']++;
                }
                for (int i = 0; i < target.Length; i++) {
                    char c = target[i];
                    if (((mask >> i) & 1) == 1 && cnt[c - 'a'] > 0) {
                        cnt[c - 'a']--;
                        left ^= 1 << i;
                    }
                }
                if (left < mask) {
                    res = Math.Min(res, DP(stickers, target, memo, left) + 1);
                }
            }
            memo[mask] = res;
        }
        return memo[mask];
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

static int helper(int mask, int * dp, char ** stickers, int stickersSize, char * target) {
    int m = strlen(target);
    if (dp[mask] != -1) {
        return dp[mask];
    }
    dp[mask] = m + 1;
    for (int j = 0; j < stickersSize; j++) {
        int left = mask;
        int cnt[26];
        int len = strlen(stickers[j]);
        memset(cnt, 0, sizeof(cnt));
        for (int i = 0; i < len; i++) {
            cnt[stickers[j][i] - 'a']++;
        }
        for (int i = 0; i < m; i++) {
            if ((mask >> i & 1) && cnt[target[i] - 'a'] > 0) {
                cnt[target[i] - 'a']--;
                left ^= 1 << i;
            }
        }
        if (left < mask) {
            dp[mask] = MIN(dp[mask], helper(left, dp, stickers, stickersSize, target) + 1);
        }
    }
    return dp[mask];
};

int minStickers(char ** stickers, int stickersSize, char * target) {
    int m = strlen(target);
    int * dp = (int *)malloc(sizeof(int) * (1 << m));
    memset(dp, -1, sizeof(int) * (1 << m));
    dp[0] = 0;
    int res = helper((1 << m) - 1, dp, stickers, stickersSize, target);
    free(dp);
    return res > m ? -1 : res;
}
```

```go [sol1-Golang]
func minStickers(stickers []string, target string) int {
    m := len(target)
    f := make([]int, 1<<m)
    for i := range f {
        f[i] = -1
    }
    f[0] = 0
    var dp func(int) int
    dp = func(mask int) int {
        if f[mask] != -1 {
            return f[mask]
        }
        f[mask] = m + 1
        for _, sticker := range stickers {
            left := mask
            cnt := [26]int{}
            for _, c := range sticker {
                cnt[c-'a']++
            }
            for i, c := range target {
                if mask>>i&1 == 1 && cnt[c-'a'] > 0 {
                    cnt[c-'a']--
                    left ^= 1 << i
                }
            }
            if left < mask {
                f[mask] = min(f[mask], dp(left)+1)
            }
        }
        return f[mask]
    }
    ans := dp(1<<m - 1)
    if ans <= m {
        return ans
    }
    return -1
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var minStickers = function(stickers, target) {
    const m = target.length;
    const memo = new Array(1 << m).fill(-1);
    memo[0] = 0;
    const res = dp(stickers, target, memo, (1 << m) - 1);
    return res <= m ? res : -1;
};

const dp = (stickers, target, memo, mask) => {
    const m = target.length;
    if (memo[mask] < 0) {
        let res = m + 1;
        for (const sticker of stickers) {
            let left = mask;
            const cnt = new Array(26).fill(0);
            for (let i = 0; i < sticker.length; i++) {
                cnt[sticker[i].charCodeAt() - 'a'.charCodeAt()]++;
            }
            for (let i = 0; i < target.length; i++) {
                const c = target[i];
                if (((mask >> i) & 1) === 1 && cnt[c.charCodeAt() - 'a'.charCodeAt()] > 0) {
                    cnt[c.charCodeAt() - 'a'.charCodeAt()]--;
                    left ^= 1 << i;
                }
            }
            if (left < mask) {
                res = Math.min(res, dp(stickers, target, memo, left) + 1);
            }
        }
        memo[mask] = res;
    }
    return memo[mask];
}
```

**复杂度分析**

- 时间复杂度：$O(2 ^ m \times n \times (c + m))$，其中 $m$ 为 $\textit{target}$ 的长度，$c$ 为每个 $\textit{sticker}$ 的平均字符数。一共有 $O(2 ^ m)$ 个状态。计算每个状态时，需要遍历 $n$ 个 $\textit{sticker}$。遍历每个 $\textit{sticker}$ 时，需要遍历它所有字符和 $\textit{target}$ 所有字符。

- 空间复杂度：$O(2 ^ m)$，记忆化时需要保存每个状态的贴纸数量。
## [940.不同的子序列 II 中文官方题解](https://leetcode.cn/problems/distinct-subsequences-ii/solutions/100000/bu-tong-de-zi-xu-lie-ii-by-leetcode-solu-k2h5)
#### 方法一：动态规划

**思路与算法**

我们用 $f[i]$ 表示以 $s[i]$ 为最后一个字符的子序列的数目。

- 如果子序列中只有 $s[i]$ 这一个字符，那么有一种方案；

- 如果子序列中至少有两个字符，那么我们可以枚举倒数第二个字符来进行状态转移。容易想到的是：倒数第二个字符可以选择 $s[0], s[1], \cdots, s[i-1]$ 中的某一个，这样就可以得到如下的状态转移方程：

    $$
    f[i] = f[0] + f[1] + \cdots f[i-1]
    $$

    然而这样做会产生重复计数。如果 $s[j_0]$ 和 $s[j_1]$ 这两个字符不相同，那么 $f[j_0]$ 和 $f[j_1]$ 对应的子序列是两个不相交的集合；但如果 $s[j_0]$ 和 $s[j_1]$ 这两个字符相同，那么 $f[j_0]$ 和 $f[j_1]$ 对应的子序列会包含重复的项。最简单的一个重复项就是只含有一个字符的子序列 $s[j_0]$ 或者 $s[j_1]$ 本身。

    那么我们该如何防止重复计数呢？可以发现，如果 $j_0<j_1$，那么 $f[j_0]$ 一定是 $f[j_1]$ 的一个真子集。这是因为：

    > 每一个以 $s[j_0]$ 为最后一个字符的子序列，都可以把这个字符改成完全相同的 $s[j_1]$，计入到 $f[j_1]$ 中。

    因此，对于每一种字符，我们只需要找到其最后一次出现的位置（并且在位置 $i$ 之前），并将对应的 $f$ 值累加进 $f[i]$ 即可。由于本题中字符串只包含小写字母，我们可以用 $\textit{last}[k]$ 记录第 $k~(0 \leq k < 26)$ 个小写字母最后一次出现的位置。如果它还没有出现过，那么 $\textit{last}[k] = -1$。这样我们就可以写出正确的状态转移方程：

    $$
    f[i] = \sum_{0\leq k<26,~ \textit{last}[k] \neq -1} f[\textit{last}[k]]
    $$

将这两种情况合并在一起，最终的状态转移方程即为：

$$
f[i] = 1 + \sum_{0\leq k<26,~ \textit{last}[k] \neq -1} f[\textit{last}[k]]
$$

在计算完 $f[i]$ 后，我们需要记得更新对应的 $\textit{last}$ 项。最终的答案即为：

$$
\sum_{0\leq k<26,~ \textit{last}[k] \neq -1} f[\textit{last}[k]]
$$

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int distinctSubseqII(string s) {
        vector<int> last(26, -1);
        
        int n = s.size();
        vector<int> f(n, 1);
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < 26; ++j) {
                if (last[j] != -1) {
                    f[i] = (f[i] + f[last[j]]) % mod;
                }
            }
            last[s[i] - 'a'] = i;
        }
        
        int ans = 0;
        for (int i = 0; i < 26; ++i) {
            if (last[i] != -1) {
                ans = (ans + f[last[i]]) % mod;
            }
        }
        return ans;
    }

private:
    static constexpr int mod = 1000000007;
};
```

```Java [sol1-Java]
class Solution {
    public int distinctSubseqII(String s) {
        final int MOD = 1000000007;
        int[] last = new int[26];
        Arrays.fill(last, -1);

        int n = s.length();
        int[] f = new int[n];
        Arrays.fill(f, 1);
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < 26; ++j) {
                if (last[j] != -1) {
                    f[i] = (f[i] + f[last[j]]) % MOD;
                }
            }
            last[s.charAt(i) - 'a'] = i;
        }

        int ans = 0;
        for (int i = 0; i < 26; ++i) {
            if (last[i] != -1) {
                ans = (ans + f[last[i]]) % MOD;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int DistinctSubseqII(string s) {
        const int MOD = 1000000007;
        int[] last = new int[26];
        Array.Fill(last, -1);

        int n = s.Length;
        int[] f = new int[n];
        Array.Fill(f, 1);
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < 26; ++j) {
                if (last[j] != -1) {
                    f[i] = (f[i] + f[last[j]]) % MOD;
                }
            }
            last[s[i] - 'a'] = i;
        }

        int ans = 0;
        for (int i = 0; i < 26; ++i) {
            if (last[i] != -1) {
                ans = (ans + f[last[i]]) % MOD;
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def distinctSubseqII(self, s: str) -> int:
        mod = 10**9 + 7
        last = [-1] * 26

        n = len(s)
        f = [1] * n
        for i, ch in enumerate(s):
            for j in range(26):
                if last[j] != -1:
                    f[i] = (f[i] + f[last[j]]) % mod
            last[ord(s[i]) - ord("a")] = i
        
        ans = 0
        for i in range(26):
            if last[i] != -1:
                ans = (ans + f[last[i]]) % mod
        return ans
```

```C [sol1-C]
const int mod = 1e9 + 7;

int distinctSubseqII(char * s) {
    int n = strlen(s);
    int last[26], f[n];
    for (int i = 0; i < 26; i++) {
        last[i] = -1;
    }
    for (int i = 0; i < n; i++) {
        f[i] = 1;
    }
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < 26; ++j) {
            if (last[j] != -1) {
                f[i] = (f[i] + f[last[j]]) % mod;
            }
        }
        last[s[i] - 'a'] = i;
    }
    int ans = 0;
    for (int i = 0; i < 26; ++i) {
        if (last[i] != -1) {
            ans = (ans + f[last[i]]) % mod;
        }
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var distinctSubseqII = function(s) {
    const MOD = 1000000007;
    const last = new Array(26).fill(-1);

    const n = s.length;
    const f = new Array(n).fill(1);
    for (let i = 0; i < n; ++i) {
        for (let j = 0; j < 26; ++j) {
            if (last[j] !== -1) {
                f[i] = (f[i] + f[last[j]]) % MOD;
            }
        }
        last[s[i].charCodeAt() - 'a'.charCodeAt()] = i;
    }

    let ans = 0;
    for (let i = 0; i < 26; ++i) {
        if (last[i] !== -1) {
            ans = (ans + f[last[i]]) % MOD;
        }
    }
    return ans;
};
```

```go [sol1-Golang]
func distinctSubseqII(s string) (ans int) {
    const mod int = 1e9 + 7
    last := make([]int, 26)
    for i := range last {
        last[i] = -1
    }
    n := len(s)
    f := make([]int, n)
    for i := range f {
        f[i] = 1
    }
    for i, c := range s {
        for _, j := range last {
            if j != -1 {
                f[i] = (f[i] + f[j]) % mod
            }
        }
        last[c-'a'] = i
    }
    for _, i := range last {
        if i != -1 {
            ans = (ans + f[i]) % mod
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n|\Sigma|)$，其中 $n$ 是字符串 $s$ 的长度，$\Sigma$ 是字符集，在本题中 $|\Sigma|=26$。即为动态规划需要的时间。

- 空间复杂度：$O(n + |\Sigma|)$。即为数组 $f$ 和 $\textit{last}$ 需要的空间。

#### 方法二：优化的动态规划

**思路与算法**

观察方法一中的状态转移方程：

$$
f[i] = 1 + \sum_{0\leq k<26,~ \textit{last}[k] \neq -1} f[\textit{last}[k]]
$$

我们可以考虑使用一个长度为 $|\Sigma|=26$ 的数组 $g$ 来进行动态规划，其中 $g[k]$ 就表示上述状态转移方程中的 $f[\textit{last}[k]]$。记 $o_i$ 表示 $s[i]$ 是第 $o_i$ 个字母，我们可以在遍历到 $s[i]$ 时，更新 $g[o_i]$ 的值为：

$$
g[o_i] = 1 + \sum_{0 \leq k < 26} g[k]
$$

即可。当 $\textit{last}[k] = -1$ 时我们无需进行转移，那么只要将数组 $g$ 的初始值设为 $0$，在累加时就可以达到相同的效果。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int distinctSubseqII(string s) {
        vector<int> g(26, 0);
        int n = s.size();
        for (int i = 0; i < n; ++i) {
            int total = 1;
            for (int j = 0; j < 26; ++j) {
                total = (total + g[j]) % mod;
            }
            g[s[i] - 'a'] = total;
        }
        
        int ans = 0;
        for (int i = 0; i < 26; ++i) {
            ans = (ans + g[i]) % mod;
        }
        return ans;
    }

private:
    static constexpr int mod = 1000000007;
};
```

```Java [sol2-Java]
class Solution {
    public int distinctSubseqII(String s) {
        final int MOD = 1000000007;
        int[] g = new int[26];
        int n = s.length();
        for (int i = 0; i < n; ++i) {
            int total = 1;
            for (int j = 0; j < 26; ++j) {
                total = (total + g[j]) % MOD;
            }
            g[s.charAt(i) - 'a'] = total;
        }

        int ans = 0;
        for (int i = 0; i < 26; ++i) {
            ans = (ans + g[i]) % MOD;
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int DistinctSubseqII(string s) {
        const int MOD = 1000000007;
        int[] g = new int[26];
        int n = s.Length;
        for (int i = 0; i < n; ++i) {
            int total = 1;
            for (int j = 0; j < 26; ++j) {
                total = (total + g[j]) % MOD;
            }
            g[s[i] - 'a'] = total;
        }

        int ans = 0;
        for (int i = 0; i < 26; ++i) {
            ans = (ans + g[i]) % MOD;
        }
        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def distinctSubseqII(self, s: str) -> int:
        mod = 10**9 + 7

        g = [0] * 26
        for i, ch in enumerate(s):
            total = (1 + sum(g)) % mod
            g[ord(s[i]) - ord("a")] = total
        
        return sum(g) % mod
```

```C [sol2-C]
const int mod = 1e9 + 7;

int distinctSubseqII(char * s) {
    int n = strlen(s);
    int g[26];
    memset(g, 0, sizeof(g));
    for (int i = 0; i < n; ++i) {
        int total = 1;
        for (int j = 0; j < 26; ++j) {
            total = (total + g[j]) % mod;
        }
        g[s[i] - 'a'] = total;
    }
    
    int ans = 0;
    for (int i = 0; i < 26; ++i) {
        ans = (ans + g[i]) % mod;
    }
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var distinctSubseqII = function(s) {
    const MOD = 1000000007;
    const g = new Array(26).fill(0);
    const n = s.length;
    for (let i = 0; i < n; ++i) {
        let total = 1;
        for (let j = 0; j < 26; ++j) {
            total = (total + g[j]) % MOD;
        }
        g[s[i].charCodeAt() - 'a'.charCodeAt()] = total;
    }

    let ans = 0;
    for (let i = 0; i < 26; ++i) {
        ans = (ans + g[i]) % MOD;
    }
    return ans;
};
```

```go [sol2-Golang]
func distinctSubseqII(s string) (ans int) {
    const mod int = 1e9 + 7
    g := make([]int, 26)
    for _, c := range s {
        total := 1
        for _, v := range g {
            total = (total + v) % mod
        }
        g[c-'a'] = total
    }
    for _, v := range g {
        ans = (ans + v) % mod
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n|\Sigma|)$，其中 $n$ 是字符串 $s$ 的长度，$\Sigma$ 是字符集，在本题中 $|\Sigma|=26$。即为动态规划需要的时间。

- 空间复杂度：$O(|\Sigma|)$。即为数组 $g$ 和 $\textit{last}$ 需要的空间。

#### 方法三：继续优化的动态规划

**思路与算法**

观察方法二中的状态转移方程：

$$
g[o_i] = 1 + \sum_{0 \leq k < 26} g[k]
$$

由于我们的答案是数组 $g$ 的和，而遍历 $s[i]$ 后只有 $g[o_i]$ 的值发生了变化。因此我们可以使用一个变量 $\textit{total}$ 直接维护数组 $g$ 的和，每次将 $g[o_i]$ 的值更新为 $1 + \textit{total}$，再将 $\textit{total}$ 的值增加 $g[o_i]$ 的变化量即可。

**代码**

```C++ [sol3-C++]
class Solution {
public:
    int distinctSubseqII(string s) {
        vector<int> g(26, 0);
        int n = s.size(), total = 0;
        for (int i = 0; i < n; ++i) {
            int oi = s[i] - 'a';
            int prev = g[oi];
            g[oi] = (total + 1) % mod;
            total = ((total + g[oi] - prev) % mod + mod) % mod;
        }
        return total;
    }

private:
    static constexpr int mod = 1000000007;
};
```

```Java [sol3-Java]
class Solution {
    public int distinctSubseqII(String s) {
        final int MOD = 1000000007;
        int[] g = new int[26];
        int n = s.length(), total = 0;
        for (int i = 0; i < n; ++i) {
            int oi = s.charAt(i) - 'a';
            int prev = g[oi];
            g[oi] = (total + 1) % MOD;
            total = ((total + g[oi] - prev) % MOD + MOD) % MOD;
        }
        return total;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int DistinctSubseqII(string s) {
        const int MOD = 1000000007;
        int[] g = new int[26];
        int n = s.Length, total = 0;
        for (int i = 0; i < n; ++i) {
            int oi = s[i] - 'a';
            int prev = g[oi];
            g[oi] = (total + 1) % MOD;
            total = ((total + g[oi] - prev) % MOD + MOD) % MOD;
        }
        return total;
    }
}
```

```Python [sol3-Python3]
class Solution:
    def distinctSubseqII(self, s: str) -> int:
        mod = 10**9 + 7

        g = [0] * 26
        total = 0
        for i, ch in enumerate(s):
            oi = ord(s[i]) - ord("a")
            g[oi], total = (total + 1) % mod, (total * 2 + 1 - g[oi]) % mod
        
        return total
```

```C [sol3-C]
const int mod = 1e9 + 7;

int distinctSubseqII(char * s) {
    int g[26];
    memset(g, 0, sizeof(g));
    int n = strlen(s), total = 0;
    for (int i = 0; i < n; ++i) {
        int oi = s[i] - 'a';
        int prev = g[oi];
        g[oi] = (total + 1) % mod;
        total = ((total + g[oi] - prev) % mod + mod) % mod;
    }
    return total;
}
```

```JavaScript [sol3-JavaScript]
var distinctSubseqII = function(s) {
    const MOD = 1000000007;
    const g = new Array(26).fill(0);
    let n = s.length, total = 0;
    for (let i = 0; i < n; ++i) {
        let oi = s[i].charCodeAt() - 'a'.charCodeAt();
        let prev = g[oi];
        g[oi] = (total + 1) % MOD;
        total = ((total + g[oi] - prev) % MOD + MOD) % MOD;
    }
    return total;
};
```

```go [sol3-Golang]
func distinctSubseqII(s string) (total int) {
    const mod int = 1e9 + 7
    g := make([]int, 26)
    for _, c := range s {
        oi := c - 'a'
        prev := g[oi]
        g[oi] = (total + 1) % mod
        total = ((total+g[oi]-prev)%mod + mod) % mod
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n + |\Sigma|)$。其中 $n$ 是字符串 $s$ 的长度，$\Sigma$ 是字符集，在本题中 $|\Sigma|=26$。初始化需要的时间为 $O(|\Sigma|)$，动态规划需要的时间的为 $O(n)$。

- 空间复杂度：$O(|\Sigma|)$。即为数组 $g$ 需要的空间。
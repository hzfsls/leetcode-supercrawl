## [1416.恢复数组 中文官方题解](https://leetcode.cn/problems/restore-the-array/solutions/100000/hui-fu-shu-zu-by-leetcode-solution)
#### 方法一：递推

对于「求出方案数」的题目，我们一般可以想到的做法就是递推。

我们用 $f[i]$ 表示前 $i$ 个数字进行恢复的方案数，那么可以很容易地写出递推式：

$$
f[i] = \sum_{j=0}^{i-1} f[j]
$$

其中字符串 $s$ 的第 $j+1$ 个到第 $i$ 个数字组成的数不包含前导 $0$ 并且小于等于 $k$。

对于每一个固定的 $i$，我们可以倒序（从大到小）枚举 $j$，并且由于 $k \leq 10^9$，我们最多只要倒序枚举 $9+1=10$ 个数字就行了，因为包含超过 $10$ 个数字的数要么大于 $k$，要么有前导 $0$。

下面的代码中给出了详细的注释。

```C++ [sol1-C++]
using LL = long long;

class Solution {
private:
    static constexpr int mod = 1000000007;

public:
    int numberOfArrays(string s, int k) {
        int n = s.size();
        // 为了便于代码编写，我们使用 64 位整数类型
        LL kll = k;
        vector<int> f(n + 1, 0);
        // 递推的边界条件
        f[0] = 1;
        for (int i = 1; i <= n; ++i) {
            LL num = 0, base = 1;
            // 倒序枚举 j，最多只需要枚举 10 个
            for (int j = i - 1; j >= 0 && i - j <= 10; --j) {
                // 在高位添加当前的数字，得到第 j+1 到 i 个数字组成的数
                // 注意 s 的下标是从 0 开始的
                num += (s[j] - '0') * base;
                if (num > kll) {
                    break;
                }
                // 判断是否有前导 0
                if (s[j] != '0') {
                    f[i] += f[j];
                    f[i] %= mod;
                }
                base *= 10;
            }
        }
        return f[n];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numberOfArrays(String s, int k) {
        final int MOD = 1000000007;
        int n = s.length();
        // 为了便于代码编写，我们使用 64 位整数类型
        long kLong = k;
        int[] f = new int[n + 1];
        // 递推的边界条件
        f[0] = 1;
        for (int i = 1; i <= n; ++i) {
            long num = 0, base = 1;
            // 倒序枚举 j，最多只需要枚举 10 个
            for (int j = i - 1; j >= 0 && i - j <= 10; --j) {
                // 在高位添加当前的数字，得到第 j+1 到 i 个数字组成的数
                // 注意 s 的下标是从 0 开始的
                num += (s.charAt(j) - '0') * base;
                if (num > kLong) {
                    break;
                }
                // 判断是否有前导 0
                if (s.charAt(j) != '0') {
                    f[i] += f[j];
                    f[i] %= MOD;
                }
                base *= 10;
            }
        }
        return f[n];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def numberOfArrays(self, s: str, k: int) -> int:
        mod = 10**9 + 7
        n = len(s)
        # 递推的边界条件，f[0] = 1
        f = [1] + [0] * n
        for i in range(1, n + 1):
            num, base = 0, 1
            j = i - 1
            # 倒序枚举 j，最多只需要枚举 10 个
            while j >= 0 and i - j <= 10:
                # 在高位添加当前的数字，得到第 j+1 到 i 个数字组成的数
                # 注意 s 的下标是从 0 开始的
                num += (ord(s[j]) - 48) * base
                if num > k:
                    break
                # 判断是否有前导 0
                if s[j] != "0":
                    f[i] += f[j]
                base *= 10
                j -= 1
            f[i] %= mod
        return f[n]
```

**复杂度分析**

- 时间复杂度：$O(N \log K)$，其中 $N$ 是字符串 $s$ 的长度。对于每一个 $f[i]$，我们需要倒序枚举 $10$ 个数字，这其实就是 $\log_{10} K_{\max} + 1$，我们可以用 $O(\log K)$ 来表示。

- 空间复杂度：$O(N)$，即为递推需要的空间。
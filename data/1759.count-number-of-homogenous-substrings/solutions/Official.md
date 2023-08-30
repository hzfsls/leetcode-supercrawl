#### 方法一：数学

**思路与算法**

题目给出一个长度为 $n$ 的字符串 $s$，并给出「同构字符串」的定义为：如果一个字符串中的所有字符都相同，那么该字符串就是同构字符串。现在我们需要求 $s$ 中「同构子字符串」的数目。
因为「同构子字符串」为一个连续的字符序列且需要序列中的字符都相同，那么我们首先按照连续相同的字符来对字符串 $s$ 进行分组，比如对于字符串 $\text{``abbcccaa"}$ 我们的分组结果为 $\text{[``a",``bb",``ccc",``aa"]$。因为对于一个组中字符串的任意子字符串都为「同构子字符串」，而一个长度为 $m$ 的字符串的子字符串的数目为 $\dfrac{m \times (m + 1)}{2}$。那么我们对于每一个组来统计其贡献的「同构子字符串」数目并求和即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def countHomogenous(self, s: str) -> int:
        res = 0
        for k, g in groupby(s):
            n = len(list(g))
            res += (n + 1) * n // 2
        return res % (10 ** 9 + 7)
```

```Java [sol1-Java]
class Solution {
    public int countHomogenous(String s) {
        final int MOD = 1000000007;
        long res = 0;
        char prev = s.charAt(0);
        int cnt = 0;
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == prev) {
                cnt++;
            } else {
                res += (long) (cnt + 1) * cnt / 2;
                cnt = 1;
                prev = c;
            }
        }
        res += (long) (cnt + 1) * cnt / 2;
        return (int) (res % MOD);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountHomogenous(string s) {
        const int MOD = 1000000007;
        long res = 0;
        char prev = s[0];
        int cnt = 0;
        foreach (char c in s) {
            if (c == prev) {
                cnt++;
            } else {
                res += (long) (cnt + 1) * cnt / 2;
                cnt = 1;
                prev = c;
            }
        }
        res += (long) (cnt + 1) * cnt / 2;
        return (int) (res % MOD);
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int countHomogenous(string s) {
        long long res = 0;
        long long mod = 1e9 + 7;
        int prev = s[0];
        int cnt = 0;
        for (auto c : s) {
            if (c == prev) {
                cnt++;
            } else {
                res += (long long)(cnt + 1) * cnt / 2;
                cnt = 1;
                prev = c;
            }
        }
        res += (long long)(cnt + 1) * cnt / 2;
        return res % mod;
    }
};
```

```C [sol1-C]
int countHomogenous(char * s) {
    long long res = 0;
    long long mod = 1e9 + 7;
    int prev = s[0];
    int cnt = 0;
    for (int i = 0; s[i] != '\0'; i++) {
        if (s[i] == prev) {
            cnt++;
        } else {
            res += (long long)(cnt + 1) * cnt / 2;
            cnt = 1;
            prev = s[i];
        }
    }
    res += (long long)(cnt + 1) * cnt / 2;
    return res % mod;
}
```

```JavaScript [sol1-JavaScript]
var countHomogenous = function(s) {
    const MOD = 1000000007;
    let res = 0;
    let prev = s[0];
    let cnt = 0;
    for (let i = 0; i < s.length; i++) {
        const c = s[i];
        if (c === prev) {
            cnt++;
        } else {
            res += (cnt + 1) * cnt / 2;
            cnt = 1;
            prev = c;
        }
    }
    res += (cnt + 1) * cnt / 2;
    return res % MOD;
};
```

```go [sol1-Golang]
func countHomogenous(s string) (res int) {
	const mod int = 1e9 + 7
	prev := rune(s[0])
	cnt := 0
	for _, c := range s {
		if c == prev {
			cnt++
		} else {
			res += (cnt + 1) * cnt / 2
			cnt = 1
			prev = c
		}
	}
	res += (cnt + 1) * cnt / 2
	return res % mod
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 字符串 $s$ 的长度。
- 空间复杂度：$O(1)$。仅使用常量空间。
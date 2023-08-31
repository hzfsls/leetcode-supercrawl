## [1641.统计字典序元音字符串的数目 中文官方题解](https://leetcode.cn/problems/count-sorted-vowel-strings/solutions/100000/tong-ji-zi-dian-xu-yuan-yin-zi-fu-chuan-sk7y1)
#### 方法一：动态规划

分别使用数字 $0$，$1$，$2$，$3$，$4$ 代表元音字符 $\text{`a'}$，$\text{`e'}$，$\text{`i'}$，$\text{`o'}$，$\text{`u'}$。记 $\textit{dp}[i][j]$ 表示长度为 $i+1$，以 $j$ 结尾的按字典序排列的字符串数量，那么状态转移方程如下：

$$
dp[i][j] =
\begin{cases}
1 &\qquad i = 0 \\
\sum^j_{k=0}{dp[i - 1][k]} & \qquad i \gt 0\\
\end{cases}
$$

因此长度为 $n$ 的按字典序排列的字符串数量为 $\sum_{k=0}^{4}{\textit{dp}[n-1][j]}$。因为 $\textit{dp}[i]$ 的计算只涉及 $\textit{dp}[i-1]$ 部分的数据，同时 $\textit{dp}[i]$ 等价于 $\textit{dp}[i-1]$ 的前缀和，我们可以只使用一维数组进行存储，同时在一维数组进行原地修改。

> 读者可以思考一下矩阵快速幂的做法。

```Python [sol1-Python3]
class Solution:
    def countVowelStrings(self, n: int) -> int:
        dp = [1] * 5
        for _ in range(n - 1):
            for j in range(1, 5):
                dp[j] += dp[j - 1]
        return sum(dp)
```

```C++ [sol1-C++]
class Solution {
public:
    int countVowelStrings(int n) {
        vector<int> dp(5, 1);
        for (int i = 1; i < n; i++) {
            for (int j = 1; j < 5; j++) {
                dp[j] += dp[j - 1];
            }
        }
        return accumulate(dp.begin(), dp.end(), 0);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int countVowelStrings(int n) {
        int[] dp = new int[5];
        Arrays.fill(dp, 1);
        for (int i = 1; i < n; i++) {
            for (int j = 1; j < 5; j++) {
                dp[j] += dp[j - 1];
            }
        }
        return Arrays.stream(dp).sum();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountVowelStrings(int n) {
        int[] dp = new int[5];
        Array.Fill(dp, 1);
        for (int i = 1; i < n; i++) {
            for (int j = 1; j < 5; j++) {
                dp[j] += dp[j - 1];
            }
        }
        return dp.Sum();
    }
}
```

```C [sol1-C]
int countVowelStrings(int n) {
    int dp[5];
    for (int i = 0; i < 5; i++) {
        dp[i] = 1;
    }
    for (int i = 1; i < n; i++) {
        for (int j = 1; j < 5; j++) {
            dp[j] += dp[j - 1];
        }
    }
    int ret = 0;
    for (int i = 0; i < 5; i++) {
        ret += dp[i];
    }
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var countVowelStrings = function(n) {
    const dp = new Array(5).fill(1);
    for (let i = 1; i < n; i++) {
        for (let j = 1; j < 5; j++) {
            dp[j] += dp[j - 1];
        }
    }
    return _.sum(dp);
};
```

```go [sol1-Golang]
func countVowelStrings(n int) int {
    dp := [5]int{}
    for i := 0; i < 5; i++ {
        dp[i] = 1
    }
    for i := 1; i < n; i++ {
        for j := 1; j < 5; j++ {
            dp[j] += dp[j-1]
        }
    }
    ret := 0
    for i := 0; i < 5; i++ {
        ret += dp[i]
    }
    return ret
}
```

**复杂度分析**

+ 时间复杂度：$O(n \times \Sigma)$，其中 $n$ 是字符串的长度，$\Sigma = 5$ 表示元音字符集大小。

+ 空间复杂度：$O(\Sigma)$。

#### 方法二：组合数学

对于一个按字典序排列的元音字符串，假设 $\text{`a'}$，$\text{`e'}$，$\text{`i'}$，$\text{`o'}$，$\text{`u'}$ 的起始下标分别为 $i_a$，$i_e$，$i_i$，$i_o$，$i_u$，显然 $i_a=0$ 且 $0 \le i_e \le i_i \le i_o \le i_u \le n$。因此字典序元音字符串的数目等于满足 $0 \le i_e \le i_i \le i_o \le i_u \le n$ 的 $(i_e, i_i, i_o,i_u)$ 的取值数目。想要直接求得 $(i_e, i_i, i_o,i_u)$ 的取值数目是十分困难的，我们可以作以下转换：

$$
\begin{aligned}
i_e'&=i_e \\
i_i'&=i_i+1 \\
i_o'&=i_o+2 \\
i_u'&=i_u+3 \\
\end{aligned}
$$

由 $0 \le i_e \le i_i \le i_o \le i_u \le n$ 可知 $0 \le i_e' \lt i_i' \lt i_o' \lt i_u' \le n + 3$。每一个 $(i_e, i_i, i_o,i_u)$ 都唯一地对应一个 $(i_e', i_i', i_o',i_u')$，因此 $(i_e, i_i, i_o,i_u)$ 的取值数目等于 $(i_e', i_i', i_o',i_u')$ 的取值数目。$(i_e', i_i', i_o',i_u')$ 等价于从 $n+4$ 个数中选取互不相等的 $4$ 个数，因此$(i_e', i_i', i_o',i_u')$ 的取值数目等于组合数 $C^{4}_{n+4}$。

```Python [sol2-Python3]
class Solution:
    def countVowelStrings(self, n: int) -> int:
        return comb(n + 4, 4)
```

```C++ [sol2-C++]
class Solution {
public:
    int countVowelStrings(int n) {
        return (n + 1) * (n + 2) * (n + 3) * (n + 4) / 24;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int countVowelStrings(int n) {
        return (n + 1) * (n + 2) * (n + 3) * (n + 4) / 24;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int CountVowelStrings(int n) {
        return (n + 1) * (n + 2) * (n + 3) * (n + 4) / 24;
    }
}
```

```C [sol2-C]
int countVowelStrings(int n) {
    return (n + 1) * (n + 2) * (n + 3) * (n + 4) / 24;
}
```

```JavaScript [sol2-JavaScript]
var countVowelStrings = function(n) {
    return (n + 1) * (n + 2) * (n + 3) * (n + 4) / 24;
};
```

```go [sol2-Golang]
func countVowelStrings(n int) int {
    return (n + 1) * (n + 2) * (n + 3) * (n + 4) / 24
}
```

**复杂度分析**

+ 时间复杂度：$O(\Sigma)$，其中 $\Sigma = 5$ 表示元音字符集大小。

+ 空间复杂度：$O(1)$。
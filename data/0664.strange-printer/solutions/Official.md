## [664.奇怪的打印机 中文官方题解](https://leetcode.cn/problems/strange-printer/solutions/100000/qi-guai-de-da-yin-ji-by-leetcode-solutio-ogbu)
#### 方法一：动态规划

**思路及算法**

我们可以使用动态规划解决本题，令 $f[i][j]$ 表示打印完成区间 $[i,j]$ 的最少操作数。

当我们尝试计算出 $f[i][j]$ 时，需要考虑两种情况：

1. $s[i]=s[j]$，即区间两端的字符相同，那么当我们打印左侧字符 $s[i]$ 时，可以顺便打印右侧字符 $s[j]$，这样我们即可忽略右侧字符对该区间的影响，只需要考虑如何尽快打印完区间 $[i,j-1]$ 即可，即此时有 $f[i][j]=f[i][j-1]$。
   - 我们无需关心区间 $[i,j-1]$ 的具体打印方案，因为我们总可以第一步完成 $s[i]$ 的打印，此时可以顺便完成 $s[j]$ 的打印，不会影响打印完成区间 $[i,j-1]$ 的最少操作数。
2. $s[i] \neq s[j]$，即区间两端的字符不同，那么我们需要分别完成该区间的左右两部分的打印。我们记两部分分别为区间 $[i,k]$ 和区间 $[k+1,j]$（其中 $i \leq k < j$），此时 $f[i][j]=\min_{k=i}^{j-1}{f[i][k]+f[k+1][j]}$。

总结状态转移方程为：

$$
f[i][j] =
\begin{cases}
f[i][j-1],& s[i]=s[j] \\
\min_{k=i}^{j-1}{f[i][k]+f[k+1][j]},& s[i]\neq s[j]
\end{cases}
$$

边界条件为 $f[i][i]=1$，对于长度为 $1$ 的区间，需要打印 $1$ 次。最后的答案为 $f[0][n-1]$。

注意到 $f[i][j]$ 的计算需要用到 $f[i][k]$ 和 $f[k+1][j]$（其中 $i\leq k< j$）。为了保证动态规划的计算过程满足无后效性，在实际代码中，我们需要改变动态规划的计算顺序，从大到小地枚举 $i$，并从小到大地枚举 $j$，这样可以保证当计算 $f[i][j]$ 时，$f[i][k]$ 和 $f[k+1][j]$ 都已经被计算过。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int strangePrinter(string s) {
        int n = s.length();
        vector<vector<int>> f(n, vector<int>(n));
        for (int i = n - 1; i >= 0; i--) {
            f[i][i] = 1;
            for (int j = i + 1; j < n; j++) {
                if (s[i] == s[j]) {
                    f[i][j] = f[i][j - 1];
                } else {
                    int minn = INT_MAX;
                    for (int k = i; k < j; k++) {
                        minn = min(minn, f[i][k] + f[k + 1][j]);
                    }
                    f[i][j] = minn;
                }
            }
        }
        return f[0][n - 1];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int strangePrinter(String s) {
        int n = s.length();
        int[][] f = new int[n][n];
        for (int i = n - 1; i >= 0; i--) {
            f[i][i] = 1;
            for (int j = i + 1; j < n; j++) {
                if (s.charAt(i) == s.charAt(j)) {
                    f[i][j] = f[i][j - 1];
                } else {
                    int minn = Integer.MAX_VALUE;
                    for (int k = i; k < j; k++) {
                        minn = Math.min(minn, f[i][k] + f[k + 1][j]);
                    }
                    f[i][j] = minn;
                }
            }
        }
        return f[0][n - 1];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int StrangePrinter(string s) {
        int n = s.Length;
        int[,] f = new int[n, n];
        for (int i = n - 1; i >= 0; i--) {
            f[i, i] = 1;
            for (int j = i + 1; j < n; j++) {
                if (s[i] == s[j]) {
                    f[i, j] = f[i, j - 1];
                } else {
                    int minn = int.MaxValue;
                    for (int k = i; k < j; k++) {
                        minn = Math.Min(minn, f[i, k] + f[k + 1, j]);
                    }
                    f[i, j] = minn;
                }
            }
        }
        return f[0, n - 1];
    }
}
```

```JavaScript [sol1-JavaScript]
var strangePrinter = function(s) {
    const n = s.length;
    const f = new Array(n).fill(0).map(() => new Array(n).fill(0));
    for (let i = n - 1; i >= 0; i--) {
        f[i][i] = 1;
        for (let j = i + 1; j < n; j++) {
            if (s[i] == s[j]) {
                f[i][j] = f[i][j - 1];
            } else {
                let minn = Number.MAX_SAFE_INTEGER;
                for (let k = i; k < j; k++) {
                    minn = Math.min(minn, f[i][k] + f[k + 1][j]);
                }
                f[i][j] = minn;
            }
        }
    }
    return f[0][n - 1];
};
```

```go [sol1-Golang]
func strangePrinter(s string) int {
    n := len(s)
    f := make([][]int, n)
    for i := range f {
        f[i] = make([]int, n)
    }
    for i := n - 1; i >= 0; i-- {
        f[i][i] = 1
        for j := i + 1; j < n; j++ {
            if s[i] == s[j] {
                f[i][j] = f[i][j-1]
            } else {
                f[i][j] = math.MaxInt64
                for k := i; k < j; k++ {
                    f[i][j] = min(f[i][j], f[i][k]+f[k+1][j])
                }
            }
        }
    }
    return f[0][n-1]
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```C [sol1-C]
int strangePrinter(char* s) {
    int n = strlen(s);
    int f[n][n];
    for (int i = n - 1; i >= 0; i--) {
        f[i][i] = 1;
        for (int j = i + 1; j < n; j++) {
            if (s[i] == s[j]) {
                f[i][j] = f[i][j - 1];
            } else {
                int minn = INT_MAX;
                for (int k = i; k < j; k++) {
                    minn = fmin(minn, f[i][k] + f[k + 1][j]);
                }
                f[i][j] = minn;
            }
        }
    }
    return f[0][n - 1];
```

**复杂度分析**

- 时间复杂度：$O(n^3)$，其中 $n$ 是字符串的长度。

- 空间复杂度：$O(n^2)$，其中 $n$ 是字符串的长度。我们需要保存所有 $n^2$ 个状态。
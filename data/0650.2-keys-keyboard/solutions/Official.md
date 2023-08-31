## [650.只有两个键的键盘 中文官方题解](https://leetcode.cn/problems/2-keys-keyboard/solutions/100000/zhi-you-liang-ge-jian-de-jian-pan-by-lee-ussa)

#### 方法一：动态规划

**思路与算法**

我们可以使用动态规划的思路解决本题。

设 $f[i]$ 表示打印出 $i$ 个 $\text{A}$ 的最少操作次数。由于我们只能使用「复制全部」和「粘贴」两种操作，那么要想得到 $i$ 个 $\text{A}$，我们必须首先拥有 $j$ 个 $\text{A}$，使用一次「复制全部」操作，再使用若干次「粘贴」操作得到 $i$ 个 $\text{A}$。

因此，这里的 $j$ 必须是 $i$ 的因数，「粘贴」操作的使用次数即为 $\dfrac{i}{j} - 1$。我们可以枚举 $j$ 进行状态转移，这样就可以得到状态转移方程：

$$
f[i] = \min_{j \mid i} \big\{ f[j] + \frac{i}{j} \big\}
$$

其中 $j \mid i$ 表示 $j$ 可以整除 $i$，即 $j$ 是 $i$ 的因数。

动态规划的边界条件为 $f[1] = 0$，最终的答案即为 $f[n]$。

**细节**

在枚举 $i$ 的因数 $j$ 时，我们可以直接在 $O(i)$ 的时间内依次枚举 $[1, i)$。

由于 $i$ 肯定同时拥有因数 $j$ 和 $\dfrac{i}{j}$，二者必有一个小于等于 $\sqrt{i}$。因此，一种时间复杂度更低的方法是，我们只在 $[1, \sqrt{i}]$ 的范围内枚举 $j$，并用 $j$ 和 $\dfrac{i}{j}$ 分别作为因数进行状态转移，时间复杂度为 $O(\sqrt{i})$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minSteps(int n) {
        vector<int> f(n + 1);
        for (int i = 2; i <= n; ++i) {
            f[i] = INT_MAX;
            for (int j = 1; j * j <= i; ++j) {
                if (i % j == 0) {
                    f[i] = min(f[i], f[j] + i / j);
                    f[i] = min(f[i], f[i / j] + j);
                }
            }
        }
        return f[n];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minSteps(int n) {
        int[] f = new int[n + 1];
        for (int i = 2; i <= n; ++i) {
            f[i] = Integer.MAX_VALUE;
            for (int j = 1; j * j <= i; ++j) {
                if (i % j == 0) {
                    f[i] = Math.min(f[i], f[j] + i / j);
                    f[i] = Math.min(f[i], f[i / j] + j);
                }
            }
        }
        return f[n];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinSteps(int n) {
        int[] f = new int[n + 1];
        for (int i = 2; i <= n; ++i) {
            f[i] = int.MaxValue;
            for (int j = 1; j * j <= i; ++j) {
                if (i % j == 0) {
                    f[i] = Math.Min(f[i], f[j] + i / j);
                    f[i] = Math.Min(f[i], f[i / j] + j);
                }
            }
        }
        return f[n];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minSteps(self, n: int) -> int:
        f = [0] * (n + 1)
        for i in range(2, n + 1):
            f[i] = float("inf")
            j = 1
            while j * j <= i:
                if i % j == 0:
                    f[i] = min(f[i], f[j] + i // j)
                    f[i] = min(f[i], f[i // j] + j)
                j += 1
        
        return f[n]
```

```go [sol1-Golang]
func minSteps(n int) int {
    f := make([]int, n+1)
    for i := 2; i <= n; i++ {
        f[i] = math.MaxInt32
        for j := 1; j*j <= i; j++ {
            if i%j == 0 {
                f[i] = min(f[i], f[j]+i/j)
                f[i] = min(f[i], f[i/j]+j)
            }
        }
    }
    return f[n]
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var minSteps = function(n) {
    const f = new Array(n + 1).fill(0);
    for (let i = 2; i <= n; ++i) {
        f[i] = Number.MAX_SAFE_INTEGER;
        for (let j = 1; j * j <= i; ++j) {
            if (i % j === 0) {
                f[i] = Math.min(f[i], Math.floor(f[j] + i / j));
                f[i] = Math.min(f[i], Math.floor(f[i / j] + j));
            }
        }
    }
    return f[n];
};
```

**复杂度分析**

- 时间复杂度：$O(n \sqrt{n})$。

- 空间复杂度：$O(n)$，即为存储所有状态需要的空间。

#### 方法二：分解质因数

**思路与算法**

观察方法一中的状态转移方程：

$$
f[i] = \min_{j \mid i} \big\{ f[j] + \frac{i}{j} \big\}
$$

我们可以转写成等价的形式：

$$
f[i] = \min_{j \mid i} \big\{ f[\frac{i}{j}] + j \big\}
$$

此时状态转移方程就有了直观上的表述，即 $f[n]$ 表示：

> 给定初始值 $n$，我们希望通过若干次操作将其变为 $1$。每次操作我们可以选择 $n$ 的一个大于 $1$ 的因数 $j$，耗费 $j$ 的代价并且将 $n$ 减少为 $\dfrac{n}{j}$。在所有可行的操作序列中，总代价的**最小值**即为 $f[n]$。

我们选择的所有因数的乘积必然为 $n$。因此，我们将 $n$ 拆分成若干个大于 $1$ 的整数的乘积：

$$
n = \alpha_1 \times \alpha_2 \times \cdots \times \alpha_k
$$

那么总代价即为：

$$
\sum_{i=1}^k \alpha_i
$$

对于任意的 $\alpha_i$，如果其为素数，那么无法继续进行拆分；如果其为合数，那么对于任意一种拆分成两个大于 $1$ 的整数的方式：

$$
\alpha_i = \beta_0 \times \beta_1
$$

拆分前的代价为 $\beta_0 \times \beta_1$，而拆分后的代价为 $\beta_0 + \beta_1$。由于它们均大于 $1$，因此：

$$
\beta_0 + \beta_1 \leq \beta_0 \times \beta_1
$$

恒成立。也就是说，在达到**最小的总代价**时，我们将 $n$ 拆分成了若干个素数的乘积。因此我们只需要对 $n$ 进行质因数分解，统计所有质因数的和，即为最终的答案。

**证明**

当 $\beta_0, \beta_1 > 1$ 时：

$$
\beta_0 \times \beta_1 - (\beta_0 + \beta_1) = (\beta_0 - 1)(\beta_1 - 1) - 1 \geq 0
$$

得证。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int minSteps(int n) {
        int ans = 0;
        for (int i = 2; i * i <= n; ++i) {
            while (n % i == 0) {
                n /= i;
                ans += i;
            }
        }
        if (n > 1) {
            ans += n;
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int minSteps(int n) {
        int ans = 0;
        for (int i = 2; i * i <= n; ++i) {
            while (n % i == 0) {
                n /= i;
                ans += i;
            }
        }
        if (n > 1) {
            ans += n;
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MinSteps(int n) {
        int ans = 0;
        for (int i = 2; i * i <= n; ++i) {
            while (n % i == 0) {
                n /= i;
                ans += i;
            }
        }
        if (n > 1) {
            ans += n;
        }
        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def minSteps(self, n: int) -> int:
        ans = 0
        i = 2
        while i * i <= n:
            while n % i == 0:
                n //= i
                ans += i
            i += 1
        
        if n > 1:
            ans += n
        
        return ans
```

```go [sol2-Golang]
func minSteps(n int) (ans int) {
    for i := 2; i*i <= n; i++ {
        for n%i == 0 {
            n /= i
            ans += i
        }
    }
    if n > 1 {
        ans += n
    }
    return
}
```

```JavaScript [sol2-JavaScript]
var minSteps = function(n) {
    let ans = 0;
    for (let i = 2; i * i <= n; ++i) {
        while (n % i === 0) {
            n = Math.floor(n / i);
            ans += i;
        }
    }
    if (n > 1) {
        ans += n;
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(\sqrt{n})$，即为质因数分解的时间复杂度。

- 空间复杂度：$O(1)$。
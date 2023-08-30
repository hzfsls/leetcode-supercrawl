#### 方法一：数学

$n!$ 尾零的数量即为 $n!$ 中因子 $10$ 的个数，而 $10=2\times 5$，因此转换成求 $n!$ 中质因子 $2$ 的个数和质因子 $5$ 的个数的较小值。

由于质因子 $5$ 的个数不会大于质因子 $2$ 的个数（具体证明见方法二），我们可以仅考虑质因子 $5$ 的个数。

而 $n!$ 中质因子 $5$ 的个数等于 $[1,n]$ 的每个数的质因子 $5$ 的个数之和，我们可以通过遍历 $[1,n]$ 的所有 $5$ 的倍数求出。 

```Python [sol1-Python3]
class Solution:
    def trailingZeroes(self, n: int) -> int:
        ans = 0
        for i in range(5, n + 1, 5):
            while i % 5 == 0:
                i //= 5
                ans += 1
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int trailingZeroes(int n) {
        int ans = 0;
        for (int i = 5; i <= n; i += 5) {
            for (int x = i; x % 5 == 0; x /= 5) {
                ++ans;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int trailingZeroes(int n) {
        int ans = 0;
        for (int i = 5; i <= n; i += 5) {
            for (int x = i; x % 5 == 0; x /= 5) {
                ++ans;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int TrailingZeroes(int n) {
        int ans = 0;
        for (int i = 5; i <= n; i += 5) {
            for (int x = i; x % 5 == 0; x /= 5) {
                ++ans;
            }
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func trailingZeroes(n int) (ans int) {
    for i := 5; i <= n; i += 5 {
        for x := i; x%5 == 0; x /= 5 {
            ans++
        }
    }
    return
}
```

```C [sol1-C]
int trailingZeroes(int n){
    int ans = 0;
    for (int i = 5; i <= n; i += 5) {
        for (int x = i; x % 5 == 0; x /= 5) {
            ++ans;
        }
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var trailingZeroes = function(n) {
    let ans = 0;
    for (let i = 5; i <= n; i += 5) {
        for (let x = i; x % 5 == 0; x /= 5) {
            ++ans;
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$。$n!$ 中因子 $5$ 的个数为 $O(n)$，具体证明见方法二。

- 空间复杂度：$O(1)$。

#### 方法二：优化计算

换一个角度考虑 $[1,n]$ 中质因子 $p$ 的个数。
 
$[1,n]$ 中 $p$ 的倍数有 $n_1=\Big\lfloor\dfrac{n}{p}\Big\rfloor$ 个，这些数至少贡献出了 $n_1$ 个质因子 $p$。$p^2$ 的倍数有 $n_2=\Big\lfloor\dfrac{n}{p^2}\Big\rfloor$ 个，由于这些数已经是 $p$ 的倍数了，为了不重复统计 $p$ 的个数，我们仅考虑额外贡献的质因子个数，即这些数额外贡献了至少 $n_2$ 个质因子 $p$。

依此类推，$[1,n]$ 中质因子 $p$ 的个数为

$$
\sum_{k=1}^{\infty} \Big\lfloor\dfrac{n}{p^k}\Big\rfloor
$$

上式表明：

1. $n$ 不变，$p$ 越大，质因子个数越少，因此 $[1,n]$ 中质因子 $5$ 的个数不会大于质因子 $2$ 的个数；
2. $[1,n]$ 中质因子 $5$ 的个数为

   $$
   \sum_{k=1}^{\infty} \Big\lfloor\dfrac{n}{5^k}\Big\rfloor < \sum_{k=1}^{\infty} \dfrac{n}{5^k} = \dfrac{n}{4} = O(n)
   $$

代码实现时，由于

$$
\Big\lfloor\dfrac{n}{5^k}\Big\rfloor = \Bigg\lfloor\dfrac{\Big\lfloor\dfrac{n}{5^{k-1}}\Big\rfloor}{5}\Bigg\rfloor
$$

因此我们可以通过不断将 $n$ 除以 $5$，并累加每次除后的 $n$，来得到答案。 

```Python [sol2-Python3]
class Solution:
    def trailingZeroes(self, n: int) -> int:
        ans = 0
        while n:
            n //= 5
            ans += n
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    int trailingZeroes(int n) {
        int ans = 0;
        while (n) {
            n /= 5;
            ans += n;
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int trailingZeroes(int n) {
        int ans = 0;
        while (n != 0) {
            n /= 5;
            ans += n;
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int TrailingZeroes(int n) {
        int ans = 0;
        while (n != 0) {
            n /= 5;
            ans += n;
        }
        return ans;
    }
}
```

```go [sol2-Golang]
func trailingZeroes(n int) (ans int) {
    for n > 0 {
        n /= 5
        ans += n
    }
    return
}
```

```C [sol2-C]
int trailingZeroes(int n) {
    int ans = 0;
    while (n) {
        n /= 5;
        ans += n;
    }
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var trailingZeroes = function(n) {
    let ans = 0;
    while (n !== 0) {
        n = Math.floor(n / 5);
        ans += n;
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。

- 空间复杂度：$O(1)$。
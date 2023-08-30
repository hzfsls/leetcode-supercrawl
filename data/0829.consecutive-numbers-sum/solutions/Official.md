#### 方法一：数学

如果正整数 $n$ 可以表示成 $k$ 个连续正整数之和，则由于 $k$ 个连续正整数之和的最小值是 $\sum_{i = 1}^k i = \dfrac{k(k + 1)}{2}$，因此有 $n \ge \dfrac{k(k + 1)}{2}$，即 $k(k + 1) \le 2n$。枚举每个符合 $k(k + 1) \le 2n$ 的正整数 $k$，判断正整数 $n$ 是否可以表示成 $k$ 个连续正整数之和。

如果正整数 $n$ 可以表示成 $k$ 个连续正整数之和，假设这 $k$ 个连续正整数中的最小正整数是 $x$，最大正整数是 $y$，则有 $y = x + k - 1$，根据等差数列求和公式有 $n = \dfrac{k(x + y)}{2} = \dfrac{k(2x + k - 1)}{2}$，$x = \dfrac{n}{k} - \dfrac{k - 1}{2}$，根据 $k(k + 1) \le 2n$ 可知 $x > 0$。分别考虑 $k$ 是奇数和偶数的情况。

- 当 $k$ 是奇数时，$k - 1$ 是偶数，因此 $2x + k - 1$ 是正偶数。令 $q = \dfrac{2x + k - 1}{2}$，则 $q$ 是正整数，$n = kq$，$q = \dfrac{n}{k}$。由于 $q$ 是正整数，因此 $n$ 可以被 $k$ 整除。
  当 $n$ 可以被 $k$ 整除时，由于 $\dfrac{n}{k}$ 和 $\dfrac{k - 1}{2}$ 都是整数，因此 $x = \dfrac{n}{k} - \dfrac{k - 1}{2}$ 是整数。又由于 $x > 0$，因此 $x$ 是正整数。因此 $n$ 可以表示成 $k$ 个连续正整数之和。
  综上所述，当 $k$ 是奇数时，「正整数 $n$ 可以表示成 $k$ 个连续正整数之和」等价于「正整数 $n$ 可以被 $k$ 整除」。

- 当 $k$ 是偶数时，$2x + k - 1$ 是奇数。将 $n = \dfrac{k(2x + k - 1)}{2}$ 写成 $\dfrac{2x + k - 1}{2} = \dfrac{n}{k}$，由于 $2x + k - 1$ 是奇数，因此 $\dfrac{2x + k - 1}{2}$ 不是整数，$n$ 不可以被 $k$ 整除，又由于 $2x + k - 1 = \dfrac{2n}{k}$ 是整数，因此 $2n$ 可以被 $k$ 整除。
  当 $n$ 不可以被 $k$ 整除且 $2n$ 可以被 $k$ 整除时，$\dfrac{2n}{k}$ 一定是奇数（否则 $\dfrac{n}{k}$ 是整数，和 $n$ 不可以被 $k$ 整除矛盾），令 $\dfrac{2n}{k} = 2t + 1$，其中 $t$ 是整数，则 $\dfrac{n}{k} = t + \dfrac{1}{2}$。此时 $x = \dfrac{n}{k} - \dfrac{k - 1}{2} = t + \dfrac{1}{2} - \dfrac{k}{2} + \dfrac{1}{2} = t - \dfrac{k}{2} + 1$，由于 $\dfrac{k}{2}$ 是整数，因此 $x$ 是整数。又由于 $x > 0$，因此 $x$ 是正整数。因此 $n$ 可以表示成 $k$ 个连续正整数之和。
  综上所述，当 $k$ 是偶数时，「正整数 $n$ 可以表示成 $k$ 个连续正整数之和」等价于「正整数 $n$ 不可以被 $k$ 整除且正整数 $2n$ 可以被 $k$ 整除」。

根据上述分析，可以得到判断正整数 $n$ 是否可以表示成 $k$ 个连续正整数之和的方法：

- 如果 $k$ 是奇数，则当 $n$ 可以被 $k$ 整除时，正整数 $n$ 可以表示成 $k$ 个连续正整数之和；

- 如果 $k$ 是偶数，则当 $n$ 不可以被 $k$ 整除且 $2n$ 可以被 $k$ 整除时，正整数 $n$ 可以表示成 $k$ 个连续正整数之和。

```Python [sol1-Python3]
class Solution:
    def consecutiveNumbersSum(self, n: int) -> int:
        def isKConsecutive(n: int, k: int) -> bool:
            if k % 2:
                return n % k == 0
            return n % k and 2 * n % k == 0

        ans = 0
        k = 1
        while k * (k + 1) <= n * 2:
            if isKConsecutive(n, k):
                ans += 1
            k += 1
        return ans
```

```Java [sol1-Java]
class Solution {
    public int consecutiveNumbersSum(int n) {
        int ans = 0;
        int bound = 2 * n;
        for (int k = 1; k * (k + 1) <= bound; k++) {
            if (isKConsecutive(n, k)) {
                ans++;
            }
        }
        return ans;
    }

    public boolean isKConsecutive(int n, int k) {
        if (k % 2 == 1) {
            return n % k == 0;
        } else {
            return n % k != 0 && 2 * n % k == 0;
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int ConsecutiveNumbersSum(int n) {
        int ans = 0;
        int bound = 2 * n;
        for (int k = 1; k * (k + 1) <= bound; k++) {
            if (IsKConsecutive(n, k)) {
                ans++;
            }
        }
        return ans;
    }

    public bool IsKConsecutive(int n, int k) {
        if (k % 2 == 1) {
            return n % k == 0;
        } else {
            return n % k != 0 && 2 * n % k == 0;
        }
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int consecutiveNumbersSum(int n) {
        int ans = 0;
        int bound = 2 * n;
        for (int k = 1; k * (k + 1) <= bound; k++) {
            if (isKConsecutive(n, k)) {
                ans++;
            }
        }
        return ans;
    }
  
    bool isKConsecutive(int n, int k) {
        if (k % 2 == 1) {
            return n % k == 0;
        } else {
            return n % k != 0 && 2 * n % k == 0;
        }
    }
};
```

```C [sol1-C]
bool isKConsecutive(int n, int k) {
    if (k % 2 == 1) {
        return n % k == 0;
    } else {
        return n % k != 0 && 2 * n % k == 0;
    }
}

int consecutiveNumbersSum(int n){
    int ans = 0;
    int bound = 2 * n;
    for (int k = 1; k * (k + 1) <= bound; k++) {
        if (isKConsecutive(n, k)) {
            ans++;
        }
    }
    return ans;
}
```

```go [sol1-Golang]
func isKConsecutive(n, k int) bool {
    if k%2 == 1 {
        return n%k == 0
    }
    return n%k != 0 && 2*n%k == 0
}

func consecutiveNumbersSum(n int) (ans int) {
    for k := 1; k*(k+1) <= n*2; k++ {
        if isKConsecutive(n, k) {
            ans++
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var consecutiveNumbersSum = function(n) {
    let ans = 0;
    const bound = 2 * n;
    for (let k = 1; k * (k + 1) <= bound; k++) {
        if (isKConsecutive(n, k)) {
            ans++;
        }
    }
    return ans;
}

const isKConsecutive = (n, k) => {
    if (k % 2 === 1) {
        return n % k === 0;
    } else {
        return n % k !== 0 && 2 * n % k === 0;
    }
};
```

**复杂度分析**

- 时间复杂度：$O(\sqrt{n})$，其中 $n$ 是给定的正整数。当 $n$ 可以表示成 $k$ 个连续正整数之和时，$k$ 不会超过 $\sqrt{2n}$，因此需要枚举的 $k$ 的个数是 $O(\sqrt{n})$，对于每个枚举的 $k$ 判断 $n$ 是否可以表示成 $k$ 个连续正整数之和的时间是 $O(1)$。

- 空间复杂度：$O(1)$。
## [1175.质数排列 中文官方题解](https://leetcode.cn/problems/prime-arrangements/solutions/100000/zhi-shu-pai-lie-by-leetcode-solution-i6g1)
#### 方法一：质数判断 + 组合数学

**思路**

求符合条件的方案数，使得所有质数都放在质数索引上，所有合数放在合数索引上，质数放置和合数放置是相互独立的，总的方案数即为「所有质数都放在质数索引上的方案数」$\times$「所有合数都放在合数索引上的方案数」。求「所有质数都放在质数索引上的方案数」，即求质数个数 $\textit{numPrimes}$ 的阶乘。「所有合数都放在合数索引上的方案数」同理。求质数个数时，可以使用试除法。「[204.计数质数的官方题解](https://leetcode.cn/problems/count-primes/solution/ji-shu-zhi-shu-by-leetcode-solution/)」列举了更多的求质数个数方法，读者可以根据兴趣阅读。最后注意计算过程中需要对 $10^9+7$ 取模。

**代码**

```Python [sol1-Python3]
class Solution:
    def numPrimeArrangements(self, n: int) -> int:
        numPrimes = sum(self.isPrime(i) for i in range(1, n + 1))
        return self.factorial(numPrimes) * self.factorial(n - numPrimes) % (10 ** 9 + 7)

    def isPrime(self, n: int) -> int:
        if n == 1:
            return 0
        for i in range(2, int(sqrt(n)) + 1):
            if n % i == 0:
                return 0
        return 1

    def factorial(self, n: int) -> int:
        res = 1
        for i in range(1, n + 1):
            res *= i
            res %= (10 ** 9 + 7)
        return res
```

```Java [sol1-Java]
class Solution {
    static final int MOD = 1000000007;

    public int numPrimeArrangements(int n) {
        int numPrimes = 0;
        for (int i = 1; i <= n; i++) {
            if (isPrime(i)) {
                numPrimes++;
            }
        }
        return (int) (factorial(numPrimes) * factorial(n - numPrimes) % MOD);
    }

    public boolean isPrime(int n) {
        if (n == 1) {
            return false;
        }
        for (int i = 2; i * i <= n; i++) {
            if (n % i == 0) {
                return false;
            }
        }
        return true;
    }

    public long factorial(int n) {
        long res = 1;
        for (int i = 1; i <= n; i++) {
            res *= i;
            res %= MOD;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    const int MOD = 1000000007;

    public int NumPrimeArrangements(int n) {
        int numPrimes = 0;
        for (int i = 1; i <= n; i++) {
            if (IsPrime(i)) {
                numPrimes++;
            }
        }
        return (int) (Factorial(numPrimes) * Factorial(n - numPrimes) % MOD);
    }

    public bool IsPrime(int n) {
        if (n == 1) {
            return false;
        }
        for (int i = 2; i * i <= n; i++) {
            if (n % i == 0) {
                return false;
            }
        }
        return true;
    }

    public long Factorial(int n) {
        long res = 1;
        for (int i = 1; i <= n; i++) {
            res *= i;
            res %= MOD;
        }
        return res;
    }
}
```

```C++ [sol1-C++]
const int MOD = 1e9 + 7;

class Solution {
public:
    int numPrimeArrangements(int n) {
        int numPrimes = 0;
        for (int i = 1; i <= n; i++) {
            if (isPrime(i)) {
                numPrimes++;
            }
        }
        return (int) (factorial(numPrimes) * factorial(n - numPrimes) % MOD);
    }

    bool isPrime(int n) {
        if (n == 1) {
            return false;
        }
        for (int i = 2; i * i <= n; i++) {
            if (n % i == 0) {
                return false;
            }
        }
        return true;
    }

    long factorial(int n) {
        long res = 1;
        for (int i = 1; i <= n; i++) {
            res *= i;
            res %= MOD;
        }
        return res;
    }
};
```

```C [sol1-C]
#define MOD 1000000007

bool isPrime(int n) {
    if (n == 1) {
        return false;
    }
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) {
            return false;
        }
    }
    return true;
}

long factorial(int n) {
    long res = 1;
    for (int i = 1; i <= n; i++) {
        res *= i;
        res %= MOD;
    }
    return res;
}

int numPrimeArrangements(int n){
    int numPrimes = 0;
    for (int i = 1; i <= n; i++) {
        if (isPrime(i)) {
            numPrimes++;
        }
    }
    return (int) (factorial(numPrimes) * factorial(n - numPrimes) % MOD);
}
```

```go [sol1-Golang]
const mod int = 1e9 + 7

func numPrimeArrangements(n int) int {
    numPrimes := 0
    for i := 2; i <= n; i++ {
        if isPrime(i) {
            numPrimes++
        }
    }
    return factorial(numPrimes) * factorial(n-numPrimes) % mod
}

func isPrime(n int) bool {
    for i := 2; i*i <= n; i++ {
        if n%i == 0 {
            return false
        }
    }
    return true
}

func factorial(n int) int {
    f := 1
    for i := 1; i <= n; i++ {
        f = f * i % mod
    }
    return f
}
```

```JavaScript [sol1-JavaScript]
const MOD = 1000000007;
var numPrimeArrangements = function(n) {
    let numPrimes = 0;
    for (let i = 2 ; i <= n ; i++) {
        if (isPrime(i)) {
            numPrimes++;
        }
    }
    let res = 1;
    let m = n - numPrimes;
    while (numPrimes > 0) {
        res = res % MOD;
        res *= numPrimes;
        numPrimes--;
    }
    while (m > 0) {
        res = res % MOD;
        res *= m;
        m--;
    }
    return res;
};

const isPrime = (n) => {
    if (n === 1) {
        return false;
    }
    for (let i = 2; i * i <= n; i++) {
        if (n % i === 0) {
            return false;
        }
    }
    return true;
}
```

**复杂度分析**

- 时间复杂度：$O(n^{3/2})$。求 $n$ 个数中质数个数的时间复杂度为 $O(n^{3/2})$，阶乘的时间复杂度为 $O(n)$，总的时间复杂度为 $O(n^{3/2})$。

- 空间复杂度：$O(1)$，只使用了常数空间。
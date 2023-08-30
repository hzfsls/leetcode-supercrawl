#### 方法一：数学

根据丑数的定义，$0$ 和负整数一定不是丑数。

当 $n>0$ 时，若 $n$ 是丑数，则 $n$ 可以写成 $n = 2^a \times 3^b \times 5^c$ 的形式，其中 $a,b,c$ 都是非负整数。特别地，当 $a,b,c$ 都是 $0$ 时，$n=1$。

为判断 $n$ 是否满足上述形式，可以对 $n$ 反复除以 $2,3,5$，直到 $n$ 不再包含质因数 $2,3,5$。若剩下的数等于 $1$，则说明 $n$ 不包含其他质因数，是丑数；否则，说明 $n$ 包含其他质因数，不是丑数。

```Java [sol1-Java]
class Solution {
    public boolean isUgly(int n) {
        if (n <= 0) {
            return false;
        }
        int[] factors = {2, 3, 5};
        for (int factor : factors) {
            while (n % factor == 0) {
                n /= factor;
            }
        }
        return n == 1;
    }
}
```

```JavaScript [sol1-JavaScript]
var isUgly = function(n) {
    if (n <= 0) {
        return false;
    }
    const factors = [2, 3, 5];
    for (const factor of factors) {
        while (n % factor === 0) {
            n /= factor;
        }
    }
    return n == 1;
};
```

```go [sol1-Golang]
var factors = []int{2, 3, 5}

func isUgly(n int) bool {
    if n <= 0 {
        return false
    }
    for _, f := range factors {
        for n%f == 0 {
            n /= f
        }
    }
    return n == 1
}
```

```Python [sol1-Python3]
class Solution:
    def isUgly(self, n: int) -> bool:
        if n <= 0:
            return False

        factors = [2, 3, 5]
        for factor in factors:
            while n % factor == 0:
                n //= factor
        
        return n == 1
```

```C++ [sol1-C++]
class Solution {
public:
    bool isUgly(int n) {
        if (n <= 0) {
            return false;
        }
        vector<int> factors = {2, 3, 5};
        for (int factor : factors) {
            while (n % factor == 0) {
                n /= factor;
            }
        }
        return n == 1;
    }
};
```

```C [sol1-C]
bool isUgly(int n) {
    if (n <= 0) {
        return false;
    }
    int factors[] = {2, 3, 5};
    for (int i = 0; i < 3; i++) {
        while (n % factors[i] == 0) {
            n /= factors[i];
        }
    }
    return n == 1;
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。时间复杂度取决于对 $n$ 除以 $2,3,5$ 的次数，由于每次至少将 $n$ 除以 $2$，因此除法运算的次数不会超过 $O(\log n)$。

- 空间复杂度：$O(1)$。
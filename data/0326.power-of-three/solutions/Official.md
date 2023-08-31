## [326.3 的幂 中文官方题解](https://leetcode.cn/problems/power-of-three/solutions/100000/3de-mi-by-leetcode-solution-hnap)
#### 方法一：试除法

**思路与算法**

我们不断地将 $n$ 除以 $3$，直到 $n=1$。如果此过程中 $n$ 无法被 $3$ 整除，就说明 $n$ 不是 $3$ 的幂。

本题中的 $n$ 可以为负数或 $0$，可以直接提前判断该情况并返回 $\text{False}$，也可以进行试除，因为负数或 $0$ 也无法通过多次除以 $3$ 得到 $1$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool isPowerOfThree(int n) {
        while (n && n % 3 == 0) {
            n /= 3;
        }
        return n == 1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean isPowerOfThree(int n) {
        while (n != 0 && n % 3 == 0) {
            n /= 3;
        }
        return n == 1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool IsPowerOfThree(int n) {
        while (n != 0 && n % 3 == 0) {
            n /= 3;
        }
        return n == 1;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def isPowerOfThree(self, n: int) -> bool:
        while n and n % 3 == 0:
            n //= 3
        return n == 1
```

```JavaScript [sol1-JavaScript]
var isPowerOfThree = function(n) {
    while (n !== 0 && n % 3 === 0) {
        n = Math.floor(n / 3);
    }
    return n === 1;
};
```

```go [sol1-Golang]
func isPowerOfThree(n int) bool {
    for n > 0 && n%3 == 0 {
        n /= 3
    }
    return n == 1
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。当 $n$ 是 $3$ 的幂时，需要除以 $3$ 的次数为 $\log_3 n = O(\log n)$；当 $n$ 不是 $3$ 的幂时，需要除以 $3$ 的次数小于该值。

- 空间复杂度：$O(1)$。

#### 方法二：判断是否为最大 $3$ 的幂的约数

**思路与算法**

我们还可以使用一种较为取巧的做法。

在题目给定的 $32$ 位有符号整数的范围内，最大的 $3$ 的幂为 $3^{19} = 1162261467$。我们只需要判断 $n$ 是否是 $3^{19}$ 的约数即可。

与方法一不同的是，这里需要特殊判断 $n$ 是负数或 $0$ 的情况。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    bool isPowerOfThree(int n) {
        return n > 0 && 1162261467 % n == 0;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean isPowerOfThree(int n) {
        return n > 0 && 1162261467 % n == 0;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool IsPowerOfThree(int n) {
        return n > 0 && 1162261467 % n == 0;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def isPowerOfThree(self, n: int) -> bool:
        return n > 0 and 1162261467 % n == 0
```

```JavaScript [sol2-JavaScript]
var isPowerOfThree = function(n) {
    return n > 0 && 1162261467 % n === 0;
};
```

```go [sol2-Golang]
func isPowerOfThree(n int) bool {
    return n > 0 && 1162261467%n == 0
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。
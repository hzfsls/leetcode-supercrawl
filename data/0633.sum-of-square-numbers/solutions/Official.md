## [633.平方数之和 中文官方题解](https://leetcode.cn/problems/sum-of-square-numbers/solutions/100000/ping-fang-shu-zhi-he-by-leetcode-solutio-8ydl)

#### 前言

对于给定的非负整数 $c$，需要判断是否存在整数 $a$ 和 $b$，使得 $a^2 + b^2 = c$。可以枚举 $a$ 和 $b$ 所有可能的情况，时间复杂度为 $O(c^2)$。但是暴力枚举有一些情况是没有必要的。例如：当 $c = 20$ 时，当 $a = 1$ 的时候，枚举 $b$ 的时候，只需要枚举到 $b = 5$ 就可以结束了，这是因为 $1^2 + 5^2 = 25 > 20$。当 $b > 5$ 时，一定有 $1^2 + b^2 > 20$。

注意到这一点，可以使用  $\texttt{sqrt}$ 函数或者双指针降低时间复杂度。

#### 方法一：使用 $\texttt{sqrt}$ 函数

在枚举 $a$ 的同时，使用 $\texttt{sqrt}$ 函数找出 $b$。注意：本题 $c$ 的取值范围在 $[0,2^{31} - 1]$，因此在计算的过程中可能会发生 $\texttt{int}$ 型溢出的情况，需要使用 $\texttt{long}$ 型避免溢出。

```Java [sol1-Java]
class Solution {
    public boolean judgeSquareSum(int c) {
        for (long a = 0; a * a <= c; a++) {
            double b = Math.sqrt(c - a * a);
            if (b == (int) b) {
                return true;
            }
        }
        return false;
    }
}
```

```JavaScript [sol1-JavaScript]
var judgeSquareSum = function(c) {
    for (let a = 0; a * a <= c; a++) {
        const b = Math.sqrt(c - a * a);
        if (b === parseInt(b)) {
            return true;
        }
    }
    return false;
};
```

```go [sol1-Golang]
func judgeSquareSum(c int) bool {
    for a := 0; a*a <= c; a++ {
        rt := math.Sqrt(float64(c - a*a))
        if rt == math.Floor(rt) {
            return true
        }
    }
    return false
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool judgeSquareSum(int c) {
        for (long a = 0; a * a <= c; a++) {
            double b = sqrt(c - a * a);
            if (b == (int)b) {
                return true;
            }
        }
        return false;
    }
};
```

```C [sol1-C]
bool judgeSquareSum(int c) {
    for (long a = 0; a * a <= c; a++) {
        double b = sqrt(c - a * a);
        if (b == (int)b) {
            return true;
        }
    }
    return false;
}
```

**复杂度分析**

- 时间复杂度：$O(\sqrt{c})$。枚举 $a$ 的时间复杂度为 $O(\sqrt{c})$，对于每个 $a$ 的值，可在 $O(1)$ 的时间内寻找 $b$。

- 空间复杂度：$O(1)$。

#### 方法二：双指针

不失一般性，可以假设 $a \le b$。初始时 $a = 0$，$b = \sqrt{c}$，进行如下操作：

- 如果 $a^2 + b^2 = c$，我们找到了题目要求的一个解，返回 $\text{true}$；
- 如果 $a^2 + b^2 < c$，此时需要将 $a$ 的值加 $1$，继续查找；
- 如果 $a^2 + b^2 > c$，此时需要将 $b$ 的值减 $1$，继续查找。

当 $a = b$ 时，结束查找，此时如果仍然没有找到整数 $a$ 和 $b$ 满足 $a^2 + b^2 = c$，则说明不存在题目要求的解，返回 $\text{false}$。

```Java [sol2-Java]
class Solution {
    public boolean judgeSquareSum(int c) {
        long left = 0;
        long right = (long) Math.sqrt(c);
        while (left <= right) {
            long sum = left * left + right * right;
            if (sum == c) {
                return true;
            } else if (sum > c) {
                right--;
            } else {
                left++;
            }
        }
        return false;
    }
}
```

```JavaScript [sol2-JavaScript]
var judgeSquareSum = function(c) {
    let left = 0;
    let right = Math.floor(Math.sqrt(c));
    while (left <= right) {
        const sum = left * left + right * right;
        if (sum === c) {
            return true;
        } else if (sum > c) {
            right--;
        } else {
            left++;
        }
    }
    return false;
};
```

```go [sol2-Golang]
func judgeSquareSum(c int) bool {
    left, right := 0, int(math.Sqrt(float64(c)))
    for left <= right {
        sum := left*left + right*right
        if sum == c {
            return true
        } else if sum > c {
            right--
        } else {
            left++
        }
    }
    return false
}
```

```C++ [sol2-C++]
class Solution {
public:
    bool judgeSquareSum(int c) {
        long left = 0;
        long right = (int)sqrt(c);
        while (left <= right) {
            long sum = left * left + right * right;
            if (sum == c) {
                return true;
            } else if (sum > c) {
                right--;
            } else {
                left++;
            }
        }
        return false;
    }
};
```

```C [sol2-C]
bool judgeSquareSum(int c) {
    long left = 0;
    long right = (int)sqrt(c);
    while (left <= right) {
        long sum = left * left + right * right;
        if (sum == c) {
            return true;
        } else if (sum > c) {
            right--;
        } else {
            left++;
        }
    }
    return false;
}
```

**复杂度分析**

- 时间复杂度：$O(\sqrt{c})$。最坏情况下 $a$ 和 $b$ 一共枚举了 $0$ 到 $\sqrt{c}$ 里的所有整数。

- 空间复杂度：$O(1)$。

#### 方法三：数学

费马平方和定理告诉我们：

> 一个非负整数 $c$ 如果能够表示为两个整数的平方和，当且仅当 $c$ 的所有形如 $4k + 3$ 的**质因子**的幂均为偶数。

证明请见 [这里](http://wstein.org/edu/124/lectures/lecture21/lecture21/node2.html)。

因此我们需要对 $c$ 进行**质因数分解**，再判断**所有**形如 $4k + 3$ 的质因子的幂是否均为偶数即可。

```Java [sol3-Java]
class Solution {
    public boolean judgeSquareSum(int c) {
        for (int base = 2; base * base <= c; base++) {
            // 如果不是因子，枚举下一个
            if (c % base != 0) {
                continue;
            }

            // 计算 base 的幂
            int exp = 0;
            while (c % base == 0) {
                c /= base;
                exp++;
            }

            // 根据 Sum of two squares theorem 验证
            if (base % 4 == 3 && exp % 2 != 0) {
                return false;
            }
        }

      	// 例如 11 这样的用例，由于上面的 for 循环里 base * base <= c ，base == 11 的时候不会进入循环体
      	// 因此在退出循环以后需要再做一次判断
        return c % 4 != 3;
    }
}
```

```JavaScript [sol3-JavaScript]
var judgeSquareSum = function(c) {
    for (let base = 2; base * base <= c; base++) {
        // 如果不是因子，枚举下一个
        if (c % base !== 0) {
            continue;
        }

        // 计算 base 的幂
        let exp = 0;
        while (c % base == 0) {
            c /= base;
            exp++;
        }

        // 根据 Sum of two squares theorem 验证
        if (base % 4 === 3 && exp % 2 !== 0) {
            return false;
        }
    }

    // 例如 11 这样的用例，由于上面的 for 循环里 base * base <= c ，base == 11 的时候不会进入循环体
    // 因此在退出循环以后需要再做一次判断
    return c % 4 !== 3;
};
```

```go [sol3-Golang]
func judgeSquareSum(c int) bool {
    for base := 2; base*base <= c; base++ {
        // 如果不是因子，枚举下一个
        if c%base > 0 {
            continue
        }

        // 计算 base 的幂
        exp := 0
        for ; c%base == 0; c /= base {
            exp++
        }

        // 根据 Sum of two squares theorem 验证
        if base%4 == 3 && exp%2 != 0 {
            return false
        }
    }

    // 例如 11 这样的用例，由于上面的 for 循环里 base * base <= c ，base == 11 的时候不会进入循环体
    // 因此在退出循环以后需要再做一次判断
    return c%4 != 3
}
```

```C++ [sol3-C++]
class Solution {
public:
    bool judgeSquareSum(int c) {
        for (int base = 2; base * base <= c; base++) {
            // 如果不是因子，枚举下一个
            if (c % base != 0) {
                continue;
            }

            // 计算 base 的幂
            int exp = 0;
            while (c % base == 0) {
                c /= base;
                exp++;
            }

            // 根据 Sum of two squares theorem 验证
            if (base % 4 == 3 && exp % 2 != 0) {
                return false;
            }
        }

        // 例如 11 这样的用例，由于上面的 for 循环里 base * base <= c ，base == 11 的时候不会进入循环体
        // 因此在退出循环以后需要再做一次判断
        return c % 4 != 3;
    }
};
```

```C [sol3-C]
bool judgeSquareSum(int c) {
    for (int base = 2; base * base <= c; base++) {
        // 如果不是因子，枚举下一个
        if (c % base != 0) {
            continue;
        }

        // 计算 base 的幂
        int exp = 0;
        while (c % base == 0) {
            c /= base;
            exp++;
        }

        // 根据 Sum of two squares theorem 验证
        if (base % 4 == 3 && exp % 2 != 0) {
            return false;
        }
    }

    // 例如 11 这样的用例，由于上面的 for 循环里 base * base <= c ，base == 11 的时候不会进入循环体
    // 因此在退出循环以后需要再做一次判断
    return c % 4 != 3;
}
```

**复杂度分析**

* 时间复杂度：$O(\sqrt{c})$。

* 空间复杂度：$O(1)$。

---
# [📚 好读书？读好书！让时间更有价值| 世界读书日](https://leetcode-cn.com/circle/discuss/12QtuI/)
4 月 22 日至 4 月 28 日，进入「[学习](https://leetcode-cn.com/leetbook/)」，完成页面右上角的「让时间更有价值」限时阅读任务，可获得「2021 读书日纪念勋章」。更多活动详情戳上方标题了解更多👆
#### 今日学习任务：
- 了解构造函数引用
[完成阅读 1.3 构造函数引用与讨论](https://leetcode-cn.com/leetbook/read/modern-java-recipes/9i21ds/)
- 了解并行流
[完成阅读 9.1 ~ 9.2（含讨论）](https://leetcode-cn.com/leetbook/read/modern-java-recipes/9zjzzh/)
#### 方法一：枚举

我们可以枚举 $\textit{num}$ 的所有真因子，累加所有真因子之和，记作 $\textit{sum}$。若 $\textit{sum}=\textit{num}$ 则返回 $\texttt{true}$，否则返回 $\texttt{false}$。

在枚举时，我们只需要枚举不超过 $\sqrt\textit{num}$ 的数。这是因为如果 $\textit{num}$ 有一个大于 $\sqrt\textit{num}$ 的因数 $d$，那么它一定有一个小于 $\sqrt\textit{num}$ 的因数 $\dfrac{\textit{num}}{d}$。

在枚举时，若找到了一个因数 $d$，那么就找到了因数 $\dfrac{\textit{num}}{d}$。注意当 $d\cdot d=\textit{num}$ 时这两个因数相同，此时不能重复计算。

```Python [sol1-Python3]
class Solution:
    def checkPerfectNumber(self, num: int) -> bool:
        if num == 1:
            return False

        sum = 1
        d = 2
        while d * d <= num:
            if num % d == 0:
                sum += d
                if d * d < num:
                    sum += num / d
            d += 1
        return sum == num
```

```C++ [sol1-C++]
class Solution {
public:
    bool checkPerfectNumber(int num) {
        if (num == 1) {
            return false;
        }

        int sum = 1;
        for (int d = 2; d * d <= num; ++d) {
            if (num % d == 0) {
                sum += d;
                if (d * d < num) {
                    sum += num / d;
                }
            }
        }
        return sum == num;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean checkPerfectNumber(int num) {
        if (num == 1) {
            return false;
        }

        int sum = 1;
        for (int d = 2; d * d <= num; ++d) {
            if (num % d == 0) {
                sum += d;
                if (d * d < num) {
                    sum += num / d;
                }
            }
        }
        return sum == num;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool CheckPerfectNumber(int num) {
        if (num == 1) {
            return false;
        }

        int sum = 1;
        for (int d = 2; d * d <= num; ++d) {
            if (num % d == 0) {
                sum += d;
                if (d * d < num) {
                    sum += num / d;
                }
            }
        }
        return sum == num;
    }
}
```

```go [sol1-Golang]
func checkPerfectNumber(num int) bool {
    if num == 1 {
        return false
    }

    sum := 1
    for d := 2; d*d <= num; d++ {
        if num%d == 0 {
            sum += d
            if d*d < num {
                sum += num / d
            }
        }
    }
    return sum == num
}
```

```C [sol1-C]
bool checkPerfectNumber(int num){
    if (num == 1) {
        return false;
    }

    int sum = 1;
    for (int d = 2; d * d <= num; ++d) {
        if (num % d == 0) {
            sum += d;
            if (d * d < num) {
                sum += num / d;
            }
        }
    }
    return sum == num;
}
```

```JavaScript [sol1-JavaScript]
var checkPerfectNumber = function(num) {
    if (num === 1) {
        return false;
    }

    let sum = 1;
    for (let d = 2; d * d <= num; ++d) {
        if (num % d === 0) {
            sum += d;
            if (d * d < num) {
                sum += Math.floor(num / d);
            }
        }
    }
    return sum === num;
};
```

**复杂度分析**

- 时间复杂度：$O(\sqrt\textit{num})$。
- 空间复杂度：$O(1)$。

#### 方法二：数学

根据欧几里得-欧拉定理，每个偶完全数都可以写成

$$
2^{p-1}(2^p-1)
$$

的形式，其中 $p$ 为素数且 $2^p-1$ 为素数。

由于目前奇完全数还未被发现，因此题目范围 $[1,10^8]$ 内的完全数都可以写成上述形式。

这一共有如下 $5$ 个：

$$
6, 28, 496, 8128, 33550336
$$

```Python [sol2-Python3]
class Solution:
    def checkPerfectNumber(self, num: int) -> bool:
        return num == 6 or num == 28 or num == 496 or num == 8128 or num == 33550336
```

```C++ [sol2-C++]
class Solution {
public:
    bool checkPerfectNumber(int num) {
        return num == 6 || num == 28 || num == 496 || num == 8128 || num == 33550336;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean checkPerfectNumber(int num) {
        return num == 6 || num == 28 || num == 496 || num == 8128 || num == 33550336;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool CheckPerfectNumber(int num) {
        return num == 6 || num == 28 || num == 496 || num == 8128 || num == 33550336;
    }
}
```

```go [sol2-Golang]
func checkPerfectNumber(num int) bool {
    return num == 6 || num == 28 || num == 496 || num == 8128 || num == 33550336
}
```

```C [sol2-C]
bool checkPerfectNumber(int num){
    return num == 6 || num == 28 || num == 496 || num == 8128 || num == 33550336;
}
```

```JavaScript [sol2-JavaScript]
var checkPerfectNumber = function(num) {
    return num === 6 || num === 28 || num === 496 || num === 8128 || num === 33550336;
};
```

**复杂度分析**

- 时间复杂度：$O(1)$。
- 空间复杂度：$O(1)$。
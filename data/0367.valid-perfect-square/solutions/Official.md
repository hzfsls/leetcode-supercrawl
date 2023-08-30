#### 前言

在方法一中，我们使用内置的库函数来解决问题。

在方法二、方法三和方法四中，我们不使用库函数来解决进阶问题。注意，因为不能使用任何内置的库函数，所以也不能使用类似 $\sqrt{x} = x^{\frac{1}{2}} = (e^{\ln x})^{\frac{1}{2}} = e^{\frac{1}{2} \ln x}$ 的公式来通过其他库函数计算平方根。

#### 方法一：使用内置的库函数

**思路和算法**

根据完全平方数的性质，我们只需要直接判断 $\textit{num}$ 的平方根 $x$ 是否为整数即可。对于不能判断浮点数的值是否等于整数的语言，则可以通过以下规则判断：

- 若 $\sqrt{\textit{num}}$ 为正整数，则有 $\lfloor x_i \rfloor^2 = (\sqrt{\textit{num}})^2 = \textit{num}$，其中符号 $\lfloor x \rfloor$ 表示 $x$ 的向下取整。

**代码**

```Python [sol1-Python3]
class Solution:
    def isPerfectSquare(self, num: int) -> bool:
        return float.is_integer(pow(num, 0.5))
```

```Java [sol1-Java]
class Solution {
    public boolean isPerfectSquare(int num) {
        int x = (int) Math.sqrt(num);
        return x * x == num;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool IsPerfectSquare(int num) {
        int x = (int) Math.Sqrt(num);
        return x * x == num;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool isPerfectSquare(int num) {
        int x = (int) sqrt(num);
        return x * x == num;
    }
};
```

```go [sol1-Golang]
func isPerfectSquare(num int) bool {
    x := int(math.Sqrt(float64(num)))
    return x*x == num
}
```

```JavaScript [sol1-JavaScript]
var isPerfectSquare = function(num) {
    const x = Math.floor(Math.sqrt(num));
    return x * x === num;
};
```

**复杂度分析**

代码中使用的 $\texttt{pow}$ 函数的时空复杂度与 CPU 支持的指令集相关，这里不深入分析。

#### 方法二：暴力

**思路和算法**

如果 $\textit{num}$ 为完全平方数，那么一定存在正整数 $x$ 满足 $x \times x = \textit{num}$。于是我们可以从 $1$ 开始，从小到大遍历所有正整数，寻找是否存在满足 $x \times x = \textit{num}$ 的正整数 $x$。在遍历中，如果出现正整数 $x$ 使 $x \times x > \textit{num}$，那么更大的正整数也不可能满足 $x \times x = \textit{num}$，不需要继续遍历了。

**代码**

```Python [sol2-Python3]
class Solution:
    def isPerfectSquare(self, num: int) -> bool:
        x = 1
        square = 1
        while square <= num:
            if square == num:
                return True
            x += 1
            square = x * x
        return False
```

```Java [sol2-Java]
class Solution {
    public boolean isPerfectSquare(int num) {
        long x = 1, square = 1;
        while (square <= num) {
            if (square == num) {
                return true;
            }
            ++x;
            square = x * x;
        }
        return false;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool IsPerfectSquare(int num) {
        long x = 1, square = 1;
        while (square <= num) {
            if (square == num) {
                return true;
            }
            ++x;
            square = x * x;
        }
        return false;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    bool isPerfectSquare(int num) {
        long x = 1, square = 1;
        while (square <= num) {
            if (square == num) {
                return true;
            }
            ++x;
            square = x * x;
        }
        return false;
    }
};
```

```go [sol2-Golang]
func isPerfectSquare(num int) bool {
    for x := 1; x*x <= num; x++ {
        if x*x == num {
            return true
        }
    }
    return false
}
```

```JavaScript [sol2-JavaScript]
var isPerfectSquare = function(num) {
    let x = 1, square = 1;
    while (square <= num) {
        if (square === num) {
            return true;
        }
        ++x;
        square = x * x;
    }
    return false;
};
```

**复杂度分析**

- 时间复杂度：$O(\sqrt{n})$，其中 $n$ 为正整数 $\textit{num}$ 的最大值。我们最多需要遍历 $\sqrt{n} + 1$ 个正整数。

- 空间复杂度：$O(1)$。

#### 方法三：二分查找

**思路和算法**

考虑使用二分查找来优化方法二中的搜索过程。因为 $\textit{num}$ 是正整数，所以若正整数 $x$ 满足 $x \times x = \textit{num}$，则 $x$ 一定满足 $1 \le x \le \textit{num}$。于是我们可以将 $1$ 和 $\textit{num}$ 作为二分查找搜索区间的初始边界。

**细节**

因为我们在移动左侧边界 $\textit{left}$ 和右侧边界 $\textit{right}$ 时，新的搜索区间都不会包含被检查的下标 $\textit{mid}$，所以搜索区间的边界始终是我们没有检查过的。因此，当$\textit{left} = \textit{right}$ 时，我们仍需要检查 $\textit{mid} = (\textit{left}+\textit{right}) / 2$。

**代码**

```Python [sol3-Python3]
class Solution:
    def isPerfectSquare(self, num: int) -> bool:
        left, right = 0, num
        while left <= right:
            mid = (left + right) // 2
            square = mid * mid
            if square < num:
                left = mid + 1
            elif square > num:
                right = mid - 1
            else:
                return True
        return False
```

```Java [sol3-Java]
class Solution {
    public boolean isPerfectSquare(int num) {
        int left = 0, right = num;
        while (left <= right) {
            int mid = (right - left) / 2 + left;
            long square = (long) mid * mid;
            if (square < num) {
                left = mid + 1;
            } else if (square > num) {
                right = mid - 1;
            } else {
                return true;
            }
        }
        return false;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public bool IsPerfectSquare(int num) {
        int left = 0, right = num;
        while (left <= right) {
            int mid = (right - left) / 2 + left;
            long square = (long) mid * mid;
            if (square < num) {
                left = mid + 1;
            } else if (square > num) {
                right = mid - 1;
            } else {
                return true;
            }
        }
        return false;
    }
}
```

```C++ [sol3-C++]
class Solution {
public:
    bool isPerfectSquare(int num) {
        int left = 0, right = num;
        while (left <= right) {
            int mid = (right - left) / 2 + left;
            long square = (long) mid * mid;
            if (square < num) {
                left = mid + 1;
            } else if (square > num) {
                right = mid - 1;
            } else {
                return true;
            }
        }
        return false;
    }
};
```

```go [sol3-Golang]
func isPerfectSquare(num int) bool {
    left, right := 0, num
    for left <= right {
        mid := (left + right) / 2
        square := mid * mid
        if square < num {
            left = mid + 1
        } else if square > num {
            right = mid - 1
        } else {
            return true
        }
    }
    return false
}
```

```JavaScript [sol3-JavaScript]
var isPerfectSquare = function(num) {
    let left = 0, right = num;
    while (left <= right) {
        const mid = Math.floor((right - left) / 2) + left;
        const square = mid * mid;
        if (square < num) {
            left = mid + 1;
        } else if (square > num) {
            right = mid - 1;
        } else {
            return true;
        }
    }
    return false;
};
```

**复杂度分析**

- 时间复杂度：$O(\log n)$，其中 $n$ 为正整数 $\textit{num}$ 的最大值。

- 空间复杂度：$O(1)$。

#### 方法四：牛顿迭代法

**前置知识**

牛顿迭代法。牛顿迭代法是一种近似求解方程（近似求解函数零点）的方法。其本质是借助泰勒级数，从初始值开始快速向函数零点逼近。

![1](https://assets.leetcode-cn.com/solution-static/367/1.png)

对于函数 $f(x)$，我们任取 $x_0$ 作为初始值。在每一次迭代中，我们根据当前值 $x_i$ 找到函数图像上的点 $(x_i,f(x_i))$，过该点做一条斜率为该点导数 $f'(x_0)$ 的直线，该直线与横轴（$X$ 轴）的交点记作 $(x_{i+1},0)$。$x_{i+1}$ 相较于 $x_i$ 而言，距离函数零点更近。在经过多次迭代后，我们就可以得到距离函数零点非常近的交点。

**思路**

如果 $\textit{num}$ 为完全平方数，那么一定存在正整数 $x$ 满足 $x \times x = \textit{num}$。于是我们写出如下方程：

$$
y = f(x) = x^2 - \textit{num}
$$

如果方程能够取得整数解，则说明存在满足 $x \times x = \textit{num}$ 的正整数 $x$。这个方程可以通过牛顿迭代法求解。

**算法**

在算法实现中，我们需要解决以下四个问题：

* 如何选取初始值？

因为 $\textit{num}$ 是正整数，所以 $y = x^2 - \textit{num}$ 有两个零点 $- \sqrt{\textit{num}}$ 和 $\sqrt{\textit{num}}$，其中 $1 \le \sqrt{\textit{num}} \le \textit{num}$。我们只需要判断 $\sqrt{\textit{num}}$ 是否为正整数即可。又因为 $y = x^2 - \textit{num}$ 是凸函数，所以只要我们选取的初始值大于等于 $\sqrt{\textit{num}}$，那么每次迭代得到的结果也都会大于等于 $\sqrt{\textit{num}}$。

因此，我们可以选择 $\textit{num}$ 作为初始值。

* 如何进行迭代？

对 $f(x)$ 求导，得到
$$
f'(x) = 2 x
$$

假设当前值为 $x_i$，将 $x_i$ 代入 $f(x)$ 得到函数图像上的点 $(x_i,x_i^2 - \textit{num})$，过该点做一条斜率为 $f'(x_i) = 2 x_i$ 的直线，则直线的方程为

$$
y - (x_i^2 - \textit{num}) = 2 x_i (x - x_i)
$$

直线与横轴（$X$ 轴）交点的横坐标为上式中的 $y = 0$ 时 $x$ 的解。于是令上式中 $y=0$，得到

$$
2 x_i x - x_i^2 - \textit{num} = 0
$$

整理上式即可得到下一次迭代的值：

$$
x_{i+1} = \frac{x_i^2 + \textit{num}}{2 x_i} = \frac{1}{2} \big( x_i + \frac{\textit{num}}{x_i} \big) \tag{1}
$$

* 如何判断迭代是否可以结束？

每一次迭代后，我们都会距离零点更近一步，所以当相邻两次迭代的结果非常接近时，我们就可以断定，此时的结果已经足够我们得到答案了。一般来说，可以判断相邻两次迭代的结果的差值是否小于一个极小的非负数 $\epsilon$，其中 $\epsilon$ 一般可以取 $10^{-6}$ 或 $10^{-7}$。

* 如何通过迭代得到的近似零点得到最终的答案？

因为初始值的选择以及 $y = x^2 - \textit{num}$ 凸函数的性质，我们通过迭代得到的 $x_i$ 一定是 $\sqrt{\textit{num}}$ 的近似零点，且满足 $x_i \ge \sqrt{\textit{num}}$。

当 $\textit{num}$ 是完全平方数时，$\sqrt{\textit{num}}$ 为正整数，则有 $\lfloor x_i \rfloor^2 = (\sqrt{\textit{num}})^2 = \textit{num}$，其中符号 $\lfloor x \rfloor$ 表示 $x$ 的向下取整。

**代码**

```Python [sol4-Python3]
class Solution:
    def isPerfectSquare(self, num: int) -> bool:
        x0 = num
        while True:
            x1 = (x0 + num / x0) / 2
            if x0 - x1 < 1e-6:
                break
            x0 = x1
        x0 = int(x0)
        return x0 * x0 == num
```

```Java [sol4-Java]
class Solution {
    public boolean isPerfectSquare(int num) {
        double x0 = num;
        while (true) {
            double x1 = (x0 + num / x0) / 2;
            if (x0 - x1 < 1e-6) {
                break;
            }
            x0 = x1;
        }
        int x = (int) x0;
        return x * x == num;
    }
}
```

```C# [sol4-C#]
public class Solution {
    public bool IsPerfectSquare(int num) {
        double x0 = num;
        while (true) {
            double x1 = (x0 + num / x0) / 2;
            if (x0 - x1 < 1e-6) {
                break;
            }
            x0 = x1;
        }
        int x = (int) x0;
        return x * x == num;
    }
}
```

```C++ [sol4-C++]
class Solution {
public:
    bool isPerfectSquare(int num) {
        double x0 = num;
        while (true) {
            double x1 = (x0 + num / x0) / 2;
            if (x0 - x1 < 1e-6) {
                break;
            }
            x0 = x1;
        }
        int x = (int) x0;
        return x * x == num;
    }
};
```

```go [sol4-Golang]
func isPerfectSquare(num int) bool {
    x0 := float64(num)
    for {
        x1 := (x0 + float64(num)/x0) / 2
        if x0-x1 < 1e-6 {
            x := int(x0)
            return x*x == num
        }
        x0 = x1
    }
}
```

```JavaScript [sol4-JavaScript]
var isPerfectSquare = function(num) {
    let x0 = num;
    while (true) {
        const x1 = Math.floor((x0 + num / x0) / 2);
        if (x0 - x1 < 1e-6) {
            break;
        }
        x0 = x1;
    }
    x = x0;
    return x * x === num;
};
```

**复杂度分析**

- 时间复杂度：$O(\log n)$，其中 $n$ 为正整数 $\textit{num}$ 的最大值。具体计算如下：

  不妨设当前值为 $x_i$，误差为 $\epsilon_i = x_i^2 - \textit{num}$；根据式 $(1)$ 解得下一次迭代的值为 $x_{i+1}$，误差为

  $$
  \begin{aligned}
  \epsilon_{i+1}
  & = x_{i+1}^2 - \textit{num} \\
  & = \Big( \frac{x_i^2 + \textit{num}}{2 x_i} \Big)^2 - \textit{num} \\
  & = \frac{(x_i^2 - \textit{num})^2}{4 x_i^2} \\
  & = \frac{\epsilon_i^2}{4x_i^2}
  \end{aligned}
  $$

  因为 $\textit{num}$ 是正整数，所以有

  $$
  \frac{\epsilon_{i+1}}{\epsilon_i} = \frac{\epsilon_i}{4 x_i^2} = \frac{x_i^2 - \textit{num}}{4 x_i^2} < \frac{1}{4}
  $$

  因为每一次迭代都可以将误差缩小到原来的 $\frac{1}{4}$ 以下，所以只需要最多 $\log_4 m$ 次迭代即可将误差缩小到阈值范围内，其中 $m$ 为初始值的误差与阈值的比。根据大 $O$ 符号表示法，其量级可以表示为 $O(\log n)$。

- 空间复杂度：$O(1)$。
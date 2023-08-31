## [1227.飞机座位分配概率 中文官方题解](https://leetcode.cn/problems/airplane-seat-assignment-probability/solutions/100000/fei-ji-zuo-wei-fen-pei-gai-lu-by-leetcod-gyw4)

#### 方法一：数学

用 $f(n)$ 表示当有 $n$ 位乘客登机时，第 $n$ 位乘客坐在自己的座位上的概率。从最简单的情况开始考虑：

- 当 $n=1$ 时，只有 $1$ 位乘客和 $1$ 个座位，因此第 $1$ 位乘客只能坐在第 $1$ 个座位上，$f(1)=1$；

- 当 $n=2$ 时，有 $2$ 个座位，每个座位有 $0.5$ 的概率被第 $1$ 位乘客选中，当第 $1$ 位乘客选中座位之后，第 $2$ 位乘客只能选择剩下的座位，因此第 $2$ 位乘客有 $0.5$ 的概率坐在自己的座位上，$f(2)=0.5$。

当 $n>2$ 时，如何计算 $f(n)$ 的值？考虑第 $1$ 位乘客选择的座位，有以下三种情况。

- 第 $1$ 位乘客有 $\frac{1}{n}$ 的概率选择第 $1$ 个座位，则所有乘客都可以坐在自己的座位上，此时第 $n$ 位乘客坐在自己的座位上的概率是 $1.0$。

- 第 $1$ 位乘客有 $\frac{1}{n}$ 的概率选择第 $n$ 个座位，则第 $2$ 位乘客到第 $n-1$ 位乘客都可以坐在自己的座位上，第 $n$ 位乘客只能坐在第 $1$ 个座位上，此时第 $n$ 位乘客坐在自己的座位上的概率是 $0.0$。

- 第 $1$ 位乘客有 $\frac{n-2}{n}$ 的概率选择其余的座位，每个座位被选中的概率是 $\frac{1}{n}$。
  假设第 $1$ 位乘客选择第 $i$ 个座位，其中 $2 \le i \le n-1$，则第 $2$ 位乘客到第 $i-1$ 位乘客都可以坐在自己的座位上，第 $i$ 位乘客到第 $n$ 位乘客的座位不确定，第 $i$ 位乘客会在剩下的 $n-(i-1)=n-i+1$ 个座位中随机选择（包括第 $1$ 个座位和第 $i+1$ 个座位到第 $n$ 个座位）。由于此时剩下的乘客数和座位数都是 $n-i+1$，有 $1$ 位乘客会随机选择座位，因此问题规模从 $n$ 减小至 $n-i+1$。

结合上述三种情况，可以得到 $f(n)$ 的递推式：

$$
\begin{aligned}
f(n) &= \frac{1}{n} \times 1.0 + \frac{1}{n} \times 0.0 + \frac{1}{n} \times \sum_{i=2}^{n-1} f(n-i+1) \\
&= \frac{1}{n}(1.0+\sum_{i=2}^{n-1} f(n-i+1))
\end{aligned}
$$

上述递推式中，$i$ 的取值个数有 $n-2$ 个，由于 $i$ 的取值个数必须是非负整数，因此只有当 $n-2 \ge 0$ 即 $n \ge 2$ 时，上述递推式才成立。

如果直接利用上述递推式计算 $f(n)$ 的值，则时间复杂度为 $O(n^2)$，无法通过全部测试用例，因此需要优化。

将上述递推式中的 $n$ 换成 $n-1$，可以得到递推式：

$$
f(n-1) = \frac{1}{n-1}(1.0+\sum_{i=2}^{n-2} f(n-i))
$$

上述递推式中，$i$ 的取值个数有 $n-3$ 个，只有当 $n-3 \ge 0$ 即 $n \ge 3$ 时，上述递推式才成立。

当 $n \ge 3$ 时，上述两个递推式可以写成如下形式：

$$
\begin{aligned}
n \times f(n) &= 1.0+\sum_{i=2}^{n-1} f(n-i+1) \\
(n-1) \times f(n-1) &= 1.0+\sum_{i=2}^{n-2} f(n-i)
\end{aligned}
$$

将上述两式相减：

$$
\begin{aligned}
&~~~~~ n \times f(n) - (n-1) \times f(n-1) \\
&= (1.0+\sum_{i=2}^{n-1} f(n-i+1)) - (1.0+\sum_{i=2}^{n-2} f(n-i)) \\
&= f(n-1)
\end{aligned}
$$

整理后得到简化的递推式：

$$
\begin{aligned}
n \times f(n) &= n \times f(n-1) \\
f(n) &= f(n-1)
\end{aligned}
$$

由于已知 $f(1)=1$ 和 $f(2)=0.5$，因此当 $n \ge 3$ 时，根据 $f(n) = f(n-1)$ 可知，对任意正整数 $n$ 都有 $f(n)=0.5$。又由于 $f(2)=0.5$，因此当 $n \ge 2$ 时，对任意正整数 $n$ 都有 $f(n)=0.5$。

由此可以得到 $f(n)$ 的结果：

$$
f(n) = \begin{cases}
1.0, & n = 1 \\
0.5, & n \ge 2
\end{cases}
$$

```Java [sol1-Java]
class Solution {
    public double nthPersonGetsNthSeat(int n) {
        return n == 1 ? 1.0 : 0.5;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    double nthPersonGetsNthSeat(int n) {
        return n == 1 ? 1.0 : 0.5;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def nthPersonGetsNthSeat(self, n: int) -> float:
        return 1.0 if n == 1 else 0.5
```

```JavaScript [sol1-JavaScript]
var nthPersonGetsNthSeat = function(n) {
    return n == 1 ? 1.0 : 0.5;
};
```

```Go [sol1-Golang]
func nthPersonGetsNthSeat(n int) float64 {
    if n == 1 {
        return 1.0
    }
    return 0.5
}
```

```C [sol1-C]
double nthPersonGetsNthSeat(int n){
    return n == 1 ? 1.0 : 0.5;
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。

#### 思考题

这道题也可以使用动态规划方法求解，但是使用动态规划方法求解时必须仔细考虑状态定义和状态转移方程。有些动态规划的做法虽然能得到正确的答案，但是动态规划的做法本身可能是错误的。

下面提供一种错误的动态规划方法，请读者阅读之后思考错误之处。

用 $f(n)$ 表示当有 $n$ 位乘客登机时，第 $n$ 位乘客坐在自己的座位上的概率。

当 $n=1$ 时，$f(n)=1$。

当 $n=2$ 时，$f(n)=0.5$。

当 $n>2$ 时，第 $1$ 位乘客有 $\frac{1}{n}$ 的概率选择第 $1$ 个座位，有 $\frac{1}{n}$ 的概率选择第 $n$ 个座位，有 $\frac{n-2}{n}$ 的概率选择其他座位。

- 当第 $1$ 位乘客选择第 $1$ 个座位时，第 $n$ 位乘客坐在自己的座位上的概率是 $1.0$。

- 当第 $1$ 位乘客选择第 $n$ 个座位时，第 $n$ 位乘客坐在自己的座位上的概率是 $0.0$。

- 当第 $1$ 位乘客选择其他座位时，其余 $n-1$ 位乘客中有一位乘客的座位被占用，需要随机选择其他座位，因此问题规模从 $n$ 减小至 $n-1$。

由此得到如下状态转移方程：

$$
\begin{aligned}
f(n) &= \frac{1}{n} \times 1.0 + \frac{1}{n} \times 0.0 + \frac{n-2}{n} \times f(n-1) \\
&= \frac{1}{n}(1.0+(n-2) \times f(n-1))
\end{aligned}
$$

状态转移方程成立的条件是 $n>2$。

由此可以得到如下实现。

```Java [sol2-Java]
class Solution {
    public double nthPersonGetsNthSeat(int n) {
        if (n <= 2) {
            return 1.0 / n;
        }
        double prob = 0.5;
        for (int i = 3; i <= n; i++) {
            prob = (1.0 + (i - 2) * prob) / i;
        }
        return prob;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    double nthPersonGetsNthSeat(int n) {
        if (n <= 2) {
            return 1.0 / n;
        }
        double prob = 0.5;
        for (int i = 3; i <= n; i++) {
            prob = (1.0 + (i - 2) * prob) / i;
        }
        return prob;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def nthPersonGetsNthSeat(self, n: int) -> float:
        if n <= 2:
            return 1 / n
        prob = 0.5
        for i in range(3, n + 1):
            prob = (1 + (i - 2) * prob) / i
        return prob
```

```JavaScript [sol2-JavaScript]
var nthPersonGetsNthSeat = function(n) {
    if (n <= 2) {
        return 1.0 / n;
    }
    let prob = 0.5;
    for (let i = 3; i <= n; i++) {
        prob = (1.0 + (i - 2) * prob) / i;
    }
    return prob;
};
```

```Go [sol2-Golang]
func nthPersonGetsNthSeat(n int) float64 {
    if n <= 2 {
        return 1 / float64(n)
    }
    prob := 0.5
    for i := 3; i <= n; i++ {
        prob = (1 + float64(i-2)*prob) / float64(i)
    }
    return prob
}
```

```C [sol2-C]
double nthPersonGetsNthSeat(int n){
    if (n <= 2) {
        return 1.0 / n;
    }
    double prob = 0.5;
    for (int i = 3; i <= n; i++) {
        prob = (1.0 + (i - 2) * prob) / i;
    }
    return prob;
}
```

虽然上述动态规划的做法可以得到正确的结果，但是**上述动态规划的做法是错误的**。

在此提出两道思考题，请读者思考。

- 为什么上述动态规划的做法是错误的，错误在哪里？

- 为什么使用上述动态规划的做法仍然可以得到正确的结果？
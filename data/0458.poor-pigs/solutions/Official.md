## [458.可怜的小猪 中文官方题解](https://leetcode.cn/problems/poor-pigs/solutions/100000/ke-lian-de-xiao-zhu-by-leetcode-solution-z0h7)
#### 方法一：动态规划

根据 $\textit{minutesToDie}$ 和 $\textit{minutesToTest}$，可以计算得到最大测试轮数 $\textit{iterations} = \Big\lfloor \dfrac{\textit{minutesToTest}}{\textit{minutesToDie}} \Big\rfloor$。

问题的等价描述是：在 $\textit{buckets}$ 桶液体中恰好有一桶有毒，至少需要多少只小猪才能在 $\textit{iterations}$ 轮测试中确定有毒的是哪一桶。

这个问题很难直接计算，可以从另一个角度考虑：用 $f(i, j)$ 表示 $i$ 只小猪测试 $j$ 轮最多可以在多少桶液体中确定有毒的是哪一桶。在确定最大测试轮数为 $\textit{iterations}$ 的情况下，需要计算使得 $f(i, \textit{iterations}) \ge \textit{buckets}$ 成立的最小的 $i$。

如果测试轮数是 $0$ 或者小猪数量是 $0$，则不能进行测试，如果有超过 $1$ 桶液体则无法确定有毒的是哪一桶，此时最多只能在 $1$ 桶液体中确定有毒的是这唯一的一桶。因此对任意 $i$ 都有 $f(i, 0) = 1$，对任意 $j$ 都有 $f(0, j) = 1$。

当 $i$ 和 $j$ 都大于 $0$ 时，可以通过递推的方法计算 $f(i, j)$ 的值。

当剩下 $i$ 只小猪和 $j$ 轮测试时，如果在一轮测试之后有 $k$ 只小猪存活，则剩下 $k$ 只小猪和 $j - 1$ 轮测试。由于 $k$ 只小猪和 $j - 1$ 轮测试可以判断的最大桶数是 $f(k, j - 1)$，$i$ 只小猪中有 $k$ 只小猪存活的组合数是 $C(i, k)$，因此剩下 $k$ 只小猪和 $j - 1$ 轮测试时，可以判断的最大桶数是 $f(k, j - 1) \times C(i, k)$。由于 $0 \le k \le i$，因此 $f(i, j)$ 的计算如下：

$$
f(i, j) = \sum\limits_{k = 0}^i f(k, j - 1) \times C(i, k)
$$

其中 $C(i, k)$ 表示从 $i$ 个不同元素中取出 $k$ 个元素的组合，$i$ 和 $k$ 满足 $0 \le k \le i$。特别地，$C(0, 0) = 1$。

当 $i \ge 1$ 时，组合数的计算如下：

- $C(i, 0) = C(i, i) = 1$；

- 当 $0 < j < i$ 时，$C(i, j) = C(i - 1, j - 1) + C(i - 1, j)$。

当小猪数量等于 $\textit{buckets} - 1$ 时，可以将 $\textit{buckets} - 1$ 桶液体分别给每只小猪喝一桶，剩下一桶液体没有小猪喝，如果有一只小猪死了则这只小猪喝的一桶液体有毒，如果小猪都存活则剩下一桶没有小猪喝的液体有毒，此时可以在一轮内确定有毒的是哪一桶。因此最多需要的小猪数量是 $\textit{buckets} - 1$，$i$ 的取值范围是 $0 \le i < \textit{buckets}$。

由于最大测试轮数 $\textit{iterations}$ 可以根据 $\textit{minutesToDie}$ 和 $\textit{minutesToTest}$ 计算得到，因此最大测试轮数可以看成已知，任何情况下的测试轮数都不能超过最大测试轮数，$j$ 的取值范围是 $0 \le j \le \textit{iterations}$。

为了计算 $f$ 的值，一种做法是预先计算组合数，然后计算 $f$ 的值，但是题目的数据规模是 $\textit{buckets} \le 1000$，如果预先计算所有 $0 \le j \le i \le \textit{buckets}$ 的组合数则可能导致结果溢出。为了避免溢出，可以在计算 $f$ 的同时计算组合数。

具体做法是，对于 $1 \le i < \textit{buckets}$ 的每个 $i$，首先计算满足 $0 \le j \le i$ 的所有组合数 $C(i, j)$，然后计算所有满足 $1 \le j \le \textit{iterations}$ 的 $f(i, j)$。计算过程中，找到使得 $f(i, \textit{iterations}) \ge \textit{buckets}$ 成立的最小的 $i$ 并返回，该返回值即为至少需要的小猪数量。

特别地，当 $\textit{buckets} = 1$ 时，不需要进行测试即可知道这唯一的一桶液体一定有毒，此时不需要任何小猪，返回 $0$。

下面用一个例子说明 $f$ 的计算。假设有 $3$ 只小猪和 $4$ 轮测试，$f(3, 4) = 125$，即最多可以在 $125$ 桶液体中确定有毒的是哪一桶。

将 $125$ 桶液体排成 $5 \times 5 \times 5$ 的正方体，每桶液体都可以用唯一的坐标 $(x, y, z)$ 表示，其中 $x$、$y$、$z$ 都是整数且取值范围都是 $[0, 4]$。

> 排成棱长为 $5$ 的正方体是因为 $4$ 轮测试对应 $5$ 种状态，前 $4$ 种状态分别是在 $4$ 轮当中的某一轮喝，最后一种状态是不喝。

在第 $i$ 轮测试中，第 $0$ 只小猪喝 $x = i$ 平面内的全部液体，第 $1$ 只小猪喝 $y = i$ 平面内的全部液体，第 $2$ 只小猪喝 $z = i$ 平面内的全部液体，其中 $0 \le i < 4$。

考虑第 $0$ 轮之后存活的小猪数量。

- 第 $0$ 轮之后没有小猪存活。有毒的液体位于 $(0, 0, 0)$，有毒的液体的可能位置有 $f(0, 3) \times C(3, 0) = 1$ 个。

- 第 $0$ 轮之后有 $1$ 只小猪存活。假设存活的是第 $0$ 只小猪，则有毒的液体的坐标 $(x, y, z)$ 满足 $x \ne 0$、$y = 0$ 且 $z = 0$，此时 $x$ 有 $4$ 种取值，因此有毒的液体的可能位置有 $f(1, 3) = 4$ 个。

   - 由于有 $1$ 只小猪存活的组合数是 $C(3, 1) = 3$，因此有毒的液体的所有可能位置有 $f(1, 3) \times C(3, 1) = 12$ 个。

- 第 $0$ 轮之后有 $2$ 只小猪存活。假设存活的是第 $0$ 只小猪和第 $1$ 只小猪，则有毒的液体的坐标 $(x, y, z)$ 满足 $x \ne 0$、$y \ne 0$ 且 $z = 0$，此时 $x$ 和 $y$ 各有 $4$ 种取值，因此有毒的液体的可能位置有 $f(2, 3) = 16$ 个。

   - 由于有 $2$ 只小猪存活的组合数是 $C(3, 2) = 3$，因此有毒的液体的所有可能位置有 $f(2, 3) \times C(3, 2) = 48$ 个。

- 第 $0$ 轮之后有 $3$ 只小猪存活。有毒的液体的坐标 $(x, y, z)$ 满足 $x \ne 0$、$y \ne 0$ 且 $z \ne 0$，此时 $x$、$y$ 和 $z$ 各有 $4$ 种取值，因此有毒的液体的可能位置有 $f(3, 3) \times C(3, 3) = 64$。

因此 $f(3, 4) = 1 + 12 + 48 + 64 = 125$。

```Java [sol1-Java]
class Solution {
    public int poorPigs(int buckets, int minutesToDie, int minutesToTest) {
        if (buckets == 1) {
            return 0;
        }
        int[][] combinations = new int[buckets + 1][buckets + 1];
        combinations[0][0] = 1;
        int iterations = minutesToTest / minutesToDie;
        int[][] f = new int[buckets][iterations + 1];
        for (int i = 0; i < buckets; i++) {
            f[i][0] = 1;
        }
        for (int j = 0; j <= iterations; j++) {
            f[0][j] = 1;
        }
        for (int i = 1; i < buckets; i++) {
            combinations[i][0] = 1;
            combinations[i][i] = 1;
            for (int j = 1; j < i; j++) {
                combinations[i][j] = combinations[i - 1][j - 1] + combinations[i - 1][j];
            }
            for (int j = 1; j <= iterations; j++) {
                for (int k = 0; k <= i; k++) {
                    f[i][j] += f[k][j - 1] * combinations[i][i - k];
                }
            }
            if (f[i][iterations] >= buckets) {
                return i;
            }
        }
        return 0;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int PoorPigs(int buckets, int minutesToDie, int minutesToTest) {
        if (buckets == 1) {
            return 0;
        }
        int[,] combinations = new int[buckets + 1, buckets + 1];
        combinations[0, 0] = 1;
        int iterations = minutesToTest / minutesToDie;
        int[,] f = new int[buckets, iterations + 1];
        for (int i = 0; i < buckets; i++) {
            f[i, 0] = 1;
        }
        for (int j = 0; j <= iterations; j++) {
            f[0, j] = 1;
        }
        for (int i = 1; i < buckets; i++) {
            combinations[i, 0] = 1;
            combinations[i, i] = 1;
            for (int j = 1; j < i; j++) {
                combinations[i, j] = combinations[i - 1, j - 1] + combinations[i - 1, j];
            }
            for (int j = 1; j <= iterations; j++) {
                for (int k = 0; k <= i; k++) {
                    f[i, j] += f[k, j - 1] * combinations[i, i - k];
                }
            }
            if (f[i, iterations] >= buckets) {
                return i;
            }
        }
        return 0;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int poorPigs(int buckets, int minutesToDie, int minutesToTest) {
        if (buckets == 1) {
            return 0;
        }
        vector<vector<int>> combinations(buckets + 1,vector<int>(buckets + 1));
        combinations[0][0] = 1;
        int iterations = minutesToTest / minutesToDie;
        vector<vector<int>> f(buckets,vector<int>(iterations + 1));
        for (int i = 0; i < buckets; i++) {
            f[i][0] = 1;
        }
        for (int j = 0; j <= iterations; j++) {
            f[0][j] = 1;
        }
        for (int i = 1; i < buckets; i++) {
            combinations[i][0] = 1;
            combinations[i][i] = 1;
            for (int j = 1; j < i; j++) {
                combinations[i][j] = combinations[i - 1][j - 1] + combinations[i - 1][j];
            }
            for (int j = 1; j <= iterations; j++) {
                for (int k = 0; k <= i; k++) {
                    f[i][j] += f[k][j - 1] * combinations[i][i - k];
                }
            }
            if (f[i][iterations] >= buckets) {
                return i;
            }
        }
        return 0;
    }
};
```

```go [sol1-Golang]
func poorPigs(buckets, minutesToDie, minutesToTest int) int {
    if buckets == 1 {
        return 0
    }

    combinations := make([][]int, buckets+1)
    for i := range combinations {
        combinations[i] = make([]int, buckets+1)
    }
    combinations[0][0] = 1

    iterations := minutesToTest / minutesToDie
    f := make([][]int, buckets)
    for i := range f {
        f[i] = make([]int, iterations+1)
    }
    for i := 0; i < buckets; i++ {
        f[i][0] = 1
    }
    for j := 0; j <= iterations; j++ {
        f[0][j] = 1
    }

    for i := 1; i < buckets; i++ {
        combinations[i][0] = 1
        for j := 1; j < i; j++ {
            combinations[i][j] = combinations[i-1][j-1] + combinations[i-1][j]
        }
        combinations[i][i] = 1
        for j := 1; j <= iterations; j++ {
            for k := 0; k <= i; k++ {
                f[i][j] += f[k][j-1] * combinations[i][i-k]
            }
        }
        if f[i][iterations] >= buckets {
            return i
        }
    }
    return 0
}
```

```Python [sol1-Python3]
class Solution:
    def poorPigs(self, buckets: int, minutesToDie: int, minutesToTest: int) -> int:
        if buckets == 1:
            return 0
        combinations = [[0] * (buckets + 1) for _ in range(buckets + 1)]
        combinations[0][0] = 1
        iterations = minutesToTest // minutesToDie
        f = [[1] * (iterations + 1)] + [[1] + [0] * iterations for _ in range(buckets - 1)]
        for i in range(1, buckets):
            combinations[i][0] = 1
            for j in range(1, i):
                combinations[i][j] = combinations[i - 1][j - 1] + combinations[i - 1][j]
            combinations[i][i] = 1
            for j in range(1, iterations + 1):
                for k in range(i + 1):
                    f[i][j] += f[k][j - 1] * combinations[i][i - k]
            if f[i][iterations] >= buckets:
                return i
        return 0
```

```JavaScript [sol1-JavaScript]
var poorPigs = function(buckets, minutesToDie, minutesToTest) {
    if (buckets === 1) {
        return 0;
    }
    const combinations = new Array(buckets + 1).fill(0).map(() => new Array(buckets + 1).fill(0));
    combinations[0][0] = 1;
    const iterations = Math.floor(minutesToTest / minutesToDie);
    const f = new Array(buckets).fill(0).map(() => new Array(iterations + 1).fill(0));
    for (let i = 0; i < buckets; i++) {
        f[i][0] = 1;
    }
    for (let j = 0; j <= iterations; j++) {
        f[0][j] = 1;
    }
    for (let i = 1; i < buckets; i++) {
        combinations[i][0] = 1;
        combinations[i][i] = 1;
        for (let j = 1; j < i; j++) {
            combinations[i][j] = combinations[i - 1][j - 1] + combinations[i - 1][j];
        }
        for (let j = 1; j <= iterations; j++) {
            for (let k = 0; k <= i; k++) {
                f[i][j] += f[k][j - 1] * combinations[i][i - k];
            }
        }
        if (f[i][iterations] >= buckets) {
            return i;
        }
    }
    return 0;
};
```

**复杂度分析**

- 时间复杂度：$O(\textit{buckets} \times (\textit{buckets} + \textit{iterations}\times\textit{buckets}))$，其中 $\textit{iterations} = \Big\lfloor \dfrac{\textit{minutesToTest}}{\textit{minutesToDie}} \Big\rfloor$ 为最大测试轮数。最多需要循环 $O(\textit{buckets})$ 轮，对于每一轮循环，需要 $O(\textit{buckets})$ 的时间计算组合数，以及需要 $O(\textit{iterations}\times\textit{buckets})$ 的时间计算 $f$ 的状态值。

- 空间复杂度：$O(\textit{buckets}^2 + \textit{buckets} \times \textit{iterations})$，其中 $\textit{iterations} = \Big\lfloor \dfrac{\textit{minutesToTest}}{\textit{minutesToDie}} \Big\rfloor$ 为最大测试轮数。需要创建二维数组 $\textit{combinations}$ 和 $f$。

#### 方法二：数学

方法一的动态规划需要计算 $f$ 的每个状态，也可以直接推导 $f$ 的每个元素的表达式。

当最大测试轮数是 $1$ 时，$i$ 只小猪可以判断的最大桶数是 $f(i, 1)$。根据递推关系，有

$$
\begin{aligned}
f(i, 1) &= \sum\limits_{k = 0}^i f(k, 0) \times C(i, k) \\
&= \sum\limits_{k = 0}^i C(i, k) \\
&= 2^i
\end{aligned}
$$

当最大测试轮数是 $2$ 时，$i$ 只小猪可以判断的最大桶数是 $f(i, 2)$。根据递推关系，有

$$
\begin{aligned}
f(i, 2) &= \sum\limits_{k = 0}^i f(k, 1) \times C(i, k) \\
&= \sum\limits_{k = 0}^i 2^k \times C(i, k) \\
&= 3^i
\end{aligned}
$$

推广到一般情况，当最大测试轮数是 $j$ 时，$i$ 只小猪可以判断的最大桶数是 $f(i, j)$。根据递推关系，有

$$
\begin{aligned}
f(i, j) &= \sum\limits_{k = 0}^i f(k, j - 1) \times C(i, k) \\
&= \sum\limits_{k = 0}^i j^k \times C(i, k) \\
&= (j + 1)^i
\end{aligned}
$$

上述结论可以通过二项式定理证明。

当最大测试轮数为 $\textit{iterations}$ 时，需要找到使得 $(\textit{iterations} + 1)^i \ge \textit{buckets}$ 成立的最小的 $i$，即为至少需要的小猪数量。令 $\textit{states} = \textit{iterations} + 1$，则至少需要的小猪数量是 $\lceil \log_{\textit{states}} \textit{buckets} \rceil$。

实现方面需要注意浮点数的精度问题。

```Java [sol2-Java]
class Solution {
    public int poorPigs(int buckets, int minutesToDie, int minutesToTest) {
        int states = minutesToTest / minutesToDie + 1;
        int pigs = (int) Math.ceil(Math.log(buckets) / Math.log(states) - 1e-5);
        return pigs;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int PoorPigs(int buckets, int minutesToDie, int minutesToTest) {
        int states = minutesToTest / minutesToDie + 1;
        int pigs = (int) Math.Ceiling(Math.Log(buckets) / Math.Log(states) - 1e-5);
        return pigs;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int poorPigs(int buckets, int minutesToDie, int minutesToTest) {
        int states = minutesToTest / minutesToDie + 1;
        int pigs = ceil(log(buckets) / log(states) - 1e-5);
        return pigs;
    }
};
```

```go [sol2-Golang]
func poorPigs(buckets, minutesToDie, minutesToTest int) int {
    states := minutesToTest/minutesToDie + 1
    return int(math.Ceil(math.Log(float64(buckets)) / math.Log(float64(states)) - 1e-5))
}
```

```Python [sol2-Python3]
class Solution:
    def poorPigs(self, buckets: int, minutesToDie: int, minutesToTest: int) -> int:
        states = minutesToTest // minutesToDie + 1
        return ceil(log(buckets) / log(states) - 1e-5)
```

```JavaScript [sol2-JavaScript]
var poorPigs = function(buckets, minutesToDie, minutesToTest) {
    const states = Math.floor(minutesToTest / minutesToDie) + 1;
    const pigs = Math.ceil(Math.log(buckets) / Math.log(states) - 1e-5);
    return pigs;
};
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。
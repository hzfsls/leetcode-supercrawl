## [1137.第 N 个泰波那契数 中文官方题解](https://leetcode.cn/problems/n-th-tribonacci-number/solutions/100000/di-n-ge-tai-bo-na-qi-shu-by-leetcode-sol-kn16)

#### 方法一：动态规划

泰波那契数的边界条件是 $T(0)=0, T(1)=1, T(2)=1$。当 $n>2$ 时，每一项的和都等于前三项的和，因此有如下递推关系：

$$
T(n)=T(n-1)+T(n-2)+T(n-3)
$$

由于泰波那契数存在递推关系，因此可以使用动态规划求解。动态规划的状态转移方程即为上述递推关系，边界条件为 $T(0)$、$T(1)$ 和 $T(2)$。

根据状态转移方程和边界条件，可以得到时间复杂度和空间复杂度都是 $O(n)$ 的实现。由于 $T(n)$ 只和前三项有关，因此可以使用「滚动数组思想」将空间复杂度优化成 $O(1)$。**如下的代码中给出的就是这种实现。**

![fig1](https://assets.leetcode-cn.com/solution-static/1137/1137.gif)

```Java [sol1-Java]
class Solution {
    public int tribonacci(int n) {
        if (n == 0) {
            return 0;
        }
        if (n <= 2) {
            return 1;
        }
        int p = 0, q = 0, r = 1, s = 1;
        for (int i = 3; i <= n; ++i) {
            p = q;
            q = r;
            r = s;
            s = p + q + r;
        }
        return s;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int Tribonacci(int n) {
        if (n == 0) {
            return 0;
        }
        if (n <= 2) {
            return 1;
        }
        int p = 0, q = 0, r = 1, s = 1;
        for (int i = 3; i <= n; ++i) {
            p = q;
            q = r;
            r = s;
            s = p + q + r;
        }
        return s;
    }
}
```

```JavaScript [sol1-JavaScript]
var tribonacci = function(n) {
    if (n === 0) {
        return 0;
    }
    if (n <= 2) {
        return 1;
    }
    let p = 0, q = 0, r = 1, s = 1;
    for (let i = 3; i <= n; ++i) {
        p = q;
        q = r;
        r = s;
        s = p + q + r;
    }
    return s;
};
```

```Python [sol1-Python3]
class Solution:
    def tribonacci(self, n: int) -> int:
        if n == 0:
            return 0
        if n <= 2:
            return 1
        
        p = 0
        q = r = 1
        for i in range(3, n + 1):
            s = p + q + r
            p, q, r = q, r, s
        return s
```

```go [sol1-Golang]
func tribonacci(n int) int {
    if n == 0 {
        return 0
    }
    if n <= 2 {
        return 1
    }
    p, q, r, s := 0, 0, 1, 1
    for i := 3; i <= n; i++ {
        p = q
        q = r
        r = s
        s = p + q + r
    }
    return s
}
```

```C++ [sol1-C++]
class Solution {
public:
    int tribonacci(int n) {
        if (n == 0) {
            return 0;
        }
        if (n <= 2) {
            return 1;
        }
        int p = 0, q = 0, r = 1, s = 1;
        for (int i = 3; i <= n; ++i) {
            p = q;
            q = r;
            r = s;
            s = p + q + r;
        }
        return s;
    }
};
```

```C [sol1-C]
int tribonacci(int n) {
    if (n == 0) {
        return 0;
    }
    if (n <= 2) {
        return 1;
    }
    int p = 0, q = 0, r = 1, s = 1;
    for (int i = 3; i <= n; ++i) {
        p = q;
        q = r;
        r = s;
        s = p + q + r;
    }
    return s;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：$O(1)$。

#### 方法二：矩阵快速幂

方法一的时间复杂度是 $O(n)$。使用矩阵快速幂的方法可以降低时间复杂度。

首先我们可以构建这样一个递推关系：

$$
\left[
\begin{matrix}
    1 & 1 & 1 \\
    1 & 0 & 0 \\
    0 & 1 & 0
\end{matrix}
\right]
\left[
\begin{matrix}
    T(n) \\
    T(n - 1) \\
    T(n - 2)
\end{matrix}
\right] = 
\left[
\begin{matrix}
    T(n) + T(n - 1) + T(n - 2) \\
    T(n) \\
    T(n - 1)
\end{matrix}
\right] = 
\left[
\begin{matrix}
    T(n + 1) \\
    T(n) \\
    T(n - 1)
\end{matrix}
\right]
$$

因此：

$$
\left[
\begin{matrix}
    T(n + 2) \\
    T(n + 1) \\
    T(n)
\end{matrix}
\right] = 
\left[
\begin{matrix}
    1 & 1 & 1 \\
    1 & 0 & 0 \\
    0 & 1 & 0
\end{matrix}
\right]^n
\left[
\begin{matrix}
    T(2) \\
    T(1) \\
    T(0)
\end{matrix}
\right]
$$

令：

$$
M = \left[
\begin{matrix}
    1 & 1 & 1 \\
    1 & 0 & 0 \\
    0 & 1 & 0
\end{matrix}
\right]
$$

因此只要我们能快速计算矩阵 $M$ 的 $n$ 次幂，就可以得到 $T(n)$ 的值。如果直接求取 $M^n$，时间复杂度是 $O(n)$，可以定义矩阵乘法，然后用快速幂算法来加速这里 $M^n$ 的求取。

```Java [sol2-Java]
class Solution {
    public int tribonacci(int n) {
        if (n == 0) {
            return 0;
        }
        if (n <= 2) {
            return 1;
        }
        int[][] q = {{1, 1, 1}, {1, 0, 0}, {0, 1, 0}};
        int[][] res = pow(q, n);
        return res[0][2];
    }

    public int[][] pow(int[][] a, int n) {
        int[][] ret = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}};
        while (n > 0) {
            if ((n & 1) == 1) {
                ret = multiply(ret, a);
            }
            n >>= 1;
            a = multiply(a, a);
        }
        return ret;
    }

    public int[][] multiply(int[][] a, int[][] b) {
        int[][] c = new int[3][3];
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                c[i][j] = a[i][0] * b[0][j] + a[i][1] * b[1][j] + a[i][2] * b[2][j];
            }
        }
        return c;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int Tribonacci(int n) {
        if (n == 0) {
            return 0;
        }
        if (n <= 2) {
            return 1;
        }
        int[,] q = {{1, 1, 1}, {1, 0, 0}, {0, 1, 0}};
        int[,] res = Pow(q, n);
        return res[0, 2];
    }

    public int[,] Pow(int[,] a, int n) {
        int[,] ret = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}};
        while (n > 0) {
            if ((n & 1) == 1) {
                ret = Multiply(ret, a);
            }
            n >>= 1;
            a = Multiply(a, a);
        }
        return ret;
    }

    public int[,] Multiply(int[,] a, int[,] b) {
        int[,] c = new int[3, 3];
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                c[i, j] = a[i, 0] * b[0, j] + a[i, 1] * b[1, j] + a[i, 2] * b[2, j];
            }
        }
        return c;
    }
}
```

```JavaScript [sol2-JavaScript]
var tribonacci = function(n) {
    if (n === 0) {
        return 0;
    }
    if (n <= 2) {
        return 1;
    }
    const q = [[1, 1, 1], [1, 0, 0], [0, 1, 0]];
    const res = pow(q, n);
    return res[0][2];
};

const pow = (a, n) => {
    let ret = [[1, 0, 0], [0, 1, 0], [0, 0, 1]];
    while (n > 0) {
        if ((n & 1) === 1) {
            ret = multiply(ret, a);
        }
        n >>= 1;
        a = multiply(a, a);
    }
    return ret;
}

const multiply = (a, b) => {
    const c = new Array(3).fill(0).map(() => new Array(3).fill(0));
    for (let i = 0; i < 3; i++) {
        for (let j = 0; j < 3; j++) {
            c[i][j] = a[i][0] * b[0][j] + a[i][1] * b[1][j] + a[i][2] * b[2][j];
        }
    }
    return c;
}
```

```Python [sol2-Python3]
class Solution:
    def tribonacci(self, n: int) -> int:
        if n == 0:
            return 0
        if n <= 2:
            return 1
        
        def multiply(a: List[List[int]], b: List[List[int]]) -> List[List[int]]:
            c = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
            for i in range(3):
                for j in range(3):
                    c[i][j] = a[i][0] * b[0][j] + a[i][1] * b[1][j] + a[i][2] * b[2][j]
            return c

        def matrix_pow(a: List[List[int]], n: int) -> List[List[int]]:
            ret = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
            while n > 0:
                if n & 1:
                    ret = multiply(ret, a)
                n >>= 1
                a = multiply(a, a)
            return ret
        
        q = [[1, 1, 1], [1, 0, 0], [0, 1, 0]]
        res = matrix_pow(q, n)
        return res[0][2]
```

```go [sol2-Golang]
type matrix [3][3]int

func (a matrix) mul(b matrix) matrix {
    c := matrix{}
    for i, row := range a {
        for j := range b[0] {
            for k, v := range row {
                c[i][j] += v * b[k][j]
            }
        }
    }
    return c
}

func (a matrix) pow(n int) matrix {
    res := matrix{}
    for i := range res {
        res[i][i] = 1
    }
    for ; n > 0; n >>= 1 {
        if n&1 > 0 {
            res = res.mul(a)
        }
        a = a.mul(a)
    }
    return res
}

func tribonacci(n int) int {
    if n == 0 {
        return 0
    }
    if n <= 2 {
        return 1
    }
    m := matrix{
        {1, 1, 1},
        {1, 0, 0},
        {0, 1, 0},
    }
    res := m.pow(n)
    return res[0][2]
}
```

```C++ [sol2-C++]
class Solution {
public:
    int tribonacci(int n) {
        if (n == 0) {
            return 0;
        }
        if (n <= 2) {
            return 1;
        }
        vector<vector<long>> q = {{1, 1, 1}, {1, 0, 0}, {0, 1, 0}};
        vector<vector<long>> res = pow(q, n);
        return res[0][2];
    }

    vector<vector<long>> pow(vector<vector<long>>& a, long n) {
        vector<vector<long>> ret = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}};
        while (n > 0) {
            if ((n & 1) == 1) {
                ret = multiply(ret, a);
            }
            n >>= 1;
            a = multiply(a, a);
        }
        return ret;
    }

    vector<vector<long>> multiply(vector<vector<long>>& a, vector<vector<long>>& b) {
        vector<vector<long>> c(3, vector<long>(3));
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                c[i][j] = a[i][0] * b[0][j] + a[i][1] * b[1][j] + a[i][2] * b[2][j];
            }
        }
        return c;
    }
};
```

```C [sol2-C]
struct Matrix {
    long mat[3][3];
};

struct Matrix multiply(struct Matrix* a, struct Matrix* b) {
    struct Matrix c;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            c.mat[i][j] = a->mat[i][0] * b->mat[0][j] + a->mat[i][1] * b->mat[1][j] + a->mat[i][2] * b->mat[2][j];
        }
    }
    return c;
};

struct Matrix qpow(struct Matrix* a, long n) {
    struct Matrix ret = {{{1, 0, 0}, {0, 1, 0}, {0, 0, 1}}};
    while (n > 0) {
        if ((n & 1) == 1) {
            ret = multiply(&ret, a);
        }
        n >>= 1;
        *a = multiply(a, a);
    }
    return ret;
}

int tribonacci(int n) {
    if (n == 0) {
        return 0;
    }
    if (n <= 2) {
        return 1;
    }
    struct Matrix q = {{{1, 1, 1}, {1, 0, 0}, {0, 1, 0}}};
    struct Matrix res = qpow(&q, n);
    return res.mat[0][2];
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。

- 空间复杂度：$O(1)$。
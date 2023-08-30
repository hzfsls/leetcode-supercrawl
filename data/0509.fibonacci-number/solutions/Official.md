#### 方法一：动态规划

斐波那契数的边界条件是 $F(0)=0$ 和 $F(1)=1$。当 $n>1$ 时，每一项的和都等于前两项的和，因此有如下递推关系：

$$F(n)=F(n-1)+F(n-2)$$

由于斐波那契数存在递推关系，因此可以使用动态规划求解。动态规划的状态转移方程即为上述递推关系，边界条件为 $F(0)$ 和 $F(1)$。

根据状态转移方程和边界条件，可以得到时间复杂度和空间复杂度都是 $O(n)$ 的实现。由于 $F(n)$ 只和 $F(n-1)$ 与 $F(n-2)$ 有关，因此可以使用「滚动数组思想」把空间复杂度优化成 $O(1)$。**如下的代码中给出的就是这种实现。**

![fig1](https://assets.leetcode-cn.com/solution-static/509/509_fig1.gif)

```Java [sol1-Java]
class Solution {
    public int fib(int n) {
        if (n < 2) {
            return n;
        }
        int p = 0, q = 0, r = 1;
        for (int i = 2; i <= n; ++i) {
            p = q; 
            q = r; 
            r = p + q;
        }
        return r;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int fib(int n) {
        if (n < 2) {
            return n;
        }
        int p = 0, q = 0, r = 1;
        for (int i = 2; i <= n; ++i) {
            p = q; 
            q = r; 
            r = p + q;
        }
        return r;
    }
};
```

```JavaScript [sol1-JavaScript]
var fib = function(n) {
    if (n < 2) {
        return n;
    }
    let p = 0, q = 0, r = 1;
    for (let i = 2; i <= n; i++) {
        p = q;
        q = r;
        r = p + q;
    }
    return r;
};
```

```go [sol1-Golang]
func fib(n int) int {
    if n < 2 {
        return n
    }
    p, q, r := 0, 0, 1
    for i := 2; i <= n; i++ {
        p = q
        q = r
        r = p + q
    }
    return r
}
```

```C [sol1-C]
int fib(int n) {
    if (n < 2) {
        return n;
    }
    int p = 0, q = 0, r = 1;
    for (int i = 2; i <= n; ++i) {
        p = q;
        q = r;
        r = p + q;
    }
    return r;
}
```

```Python [sol1-Python3]
class Solution:
    def fib(self, n: int) -> int:
        if n < 2:
            return n
        
        p, q, r = 0, 0, 1
        for i in range(2, n + 1):
            p, q = q, r
            r = p + q
        
        return r
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
    1 & 1 \\
    1 & 0
\end{matrix}
\right]
\left[
\begin{matrix}
    F(n)\\
    F(n - 1)
\end{matrix}
\right] = 
\left[
\begin{matrix}
    F(n) + F(n - 1)\\
    F(n)
\end{matrix}
\right] = 
\left[
\begin{matrix}
    F(n + 1)\\
    F(n)
\end{matrix}
\right]
$$

因此：

$$
\left[
\begin{matrix}
    F(n + 1)\\
    F(n)
\end{matrix}
\right] = 
\left[
\begin{matrix}
    1 & 1 \\
    1 & 0
\end{matrix}
\right] ^n
\left[
\begin{matrix}
    F(1)\\
    F(0)
\end{matrix}
\right]
$$
令：
$$
M = \left[
\begin{matrix}
    1 & 1 \\
    1 & 0
\end{matrix}
\right]
$$

因此只要我们能快速计算矩阵 $M$ 的 $n$ 次幂，就可以得到 $F(n)$ 的值。如果直接求取 $M^n$，时间复杂度是 $O(n)$，可以定义矩阵乘法，然后用快速幂算法来加速这里 $M^n$ 的求取。

```Java [sol2-Java]
class Solution {
    public int fib(int n) {
        if (n < 2) {
            return n;
        }
        int[][] q = {{1, 1}, {1, 0}};
        int[][] res = pow(q, n - 1);
        return res[0][0];
    }

    public int[][] pow(int[][] a, int n) {
        int[][] ret = {{1, 0}, {0, 1}};
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
        int[][] c = new int[2][2];
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
                c[i][j] = a[i][0] * b[0][j] + a[i][1] * b[1][j];
            }
        }
        return c;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int fib(int n) {
        if (n < 2) {
            return n;
        }
        vector<vector<int>> q{{1, 1}, {1, 0}};
        vector<vector<int>> res = matrix_pow(q, n - 1);
        return res[0][0];
    }

    vector<vector<int>> matrix_pow(vector<vector<int>>& a, int n) {
        vector<vector<int>> ret{{1, 0}, {0, 1}};
        while (n > 0) {
            if (n & 1) {
                ret = matrix_multiply(ret, a);
            }
            n >>= 1;
            a = matrix_multiply(a, a);
        }
        return ret;
    }

    vector<vector<int>> matrix_multiply(vector<vector<int>>& a, vector<vector<int>>& b) {
        vector<vector<int>> c{{0, 0}, {0, 0}};
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
                c[i][j] = a[i][0] * b[0][j] + a[i][1] * b[1][j];
            }
        }
        return c;
    }
};
```

```JavaScript [sol2-JavaScript]
var fib = function(n) {
    if (n < 2) {
        return n;
    }
    const q = [[1, 1], [1, 0]];
    const res = pow(q, n - 1);
    return res[0][0];
};

const pow = (a, n) => {
    let ret = [[1, 0], [0, 1]];
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
    const c = new Array(2).fill(0).map(() => new Array(2).fill(0));
    for (let i = 0; i < 2; i++) {
        for (let j = 0; j < 2; j++) {
            c[i][j] = a[i][0] * b[0][j] + a[i][1] * b[1][j];
        }
    }
    return c;
}
```

```go [sol2-Golang]
type matrix [2][2]int

func multiply(a, b matrix) (c matrix) {
    for i := 0; i < 2; i++ {
        for j := 0; j < 2; j++ {
            c[i][j] = a[i][0]*b[0][j] + a[i][1]*b[1][j]
        }
    }
    return
}

func pow(a matrix, n int) matrix {
    ret := matrix{{1, 0}, {0, 1}}
    for ; n > 0; n >>= 1 {
        if n&1 == 1 {
            ret = multiply(ret, a)
        }
        a = multiply(a, a)
    }
    return ret
}

func fib(n int) int {
    if n < 2 {
        return n
    }
    res := pow(matrix{{1, 1}, {1, 0}}, n-1)
    return res[0][0]
}
```

```C [sol2-C]
struct Matrix {
    int mat[2][2];
};

struct Matrix matrixMultiply(struct Matrix* a, struct Matrix* b) {
    struct Matrix c;
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            c.mat[i][j] = (*a).mat[i][0] * (*b).mat[0][j] + (*a).mat[i][1] * (*b).mat[1][j];
        }
    }
    return c;
}

struct Matrix matrixPow(struct Matrix a, int n) {
    struct Matrix ret;
    ret.mat[0][0] = ret.mat[1][1] = 1;
    ret.mat[0][1] = ret.mat[1][0] = 0;
    while (n > 0) {
        if (n & 1) {
            ret = matrixMultiply(&ret, &a);
        }
        n >>= 1;
        a = matrixMultiply(&a, &a);
    }
    return ret;
}

int fib(int n) {
    if (n < 2) {
        return n;
    }
    struct Matrix q;
    q.mat[0][0] = q.mat[0][1] = q.mat[1][0] = 1;
    q.mat[1][1] = 0;
    struct Matrix res = matrixPow(q, n - 1);
    return res.mat[0][0];
}
```

```Python [sol2-Python3]
class Solution:
    def fib(self, n: int) -> int:
        if n < 2:
            return n
        
        q = [[1, 1], [1, 0]]
        res = self.matrix_pow(q, n - 1)
        return res[0][0]
    
    def matrix_pow(self, a: List[List[int]], n: int) -> List[List[int]]:
        ret = [[1, 0], [0, 1]]
        while n > 0:
            if n & 1:
                ret = self.matrix_multiply(ret, a)
            n >>= 1
            a = self.matrix_multiply(a, a)
        return ret

    def matrix_multiply(self, a: List[List[int]], b: List[List[int]]) -> List[List[int]]:
        c = [[0, 0], [0, 0]]
        for i in range(2):
            for j in range(2):
                c[i][j] = a[i][0] * b[0][j] + a[i][1] * b[1][j]
        return c
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。

- 空间复杂度：$O(1)$。

#### 方法三：通项公式

斐波那契数 $F(n)$ 是齐次线性递推，根据递推方程 $F(n)=F(n-1)+F(n-2)$，可以写出这样的特征方程：

$$x^2=x+1$$

求得 $x_1 = \frac{1+\sqrt{5}}{2}$，$x_2 = \frac{1-\sqrt{5}}{2}$。设通解为 $F(n)=c_1x_1^n+c_2x_2^n$，代入初始条件 $F(0)=0$，$F(1)=1$，得 $c_1=\frac{1}{\sqrt{5}}$，$c_2=-\frac{1}{\sqrt{5}}$。因此斐波那契数的通项公式如下：

$$F(n)=\frac{1}{\sqrt{5}}\left[ \left(\frac{1+\sqrt{5}}{2}\right)^{n} - \left(\frac{1-\sqrt{5}}{2}\right)^{n} \right]$$

得到通项公式之后，就可以通过公式直接求解第 $n$ 项。

```Java [sol3-Java]
class Solution {
    public int fib(int n) {
        double sqrt5 = Math.sqrt(5);
        double fibN = Math.pow((1 + sqrt5) / 2, n) - Math.pow((1 - sqrt5) / 2, n);
        return (int) Math.round(fibN / sqrt5);
    }
}
```

```C++ [sol3-C++]
class Solution {
public:
    int fib(int n) {
        double sqrt5 = sqrt(5);
        double fibN = pow((1 + sqrt5) / 2, n) - pow((1 - sqrt5) / 2, n);
        return round(fibN / sqrt5);
    }
};
```

```JavaScript [sol3-JavaScript]
var fib = function(n) {
    const sqrt5 = Math.sqrt(5);
    const fibN = Math.pow((1 + sqrt5) / 2, n) - Math.pow((1 - sqrt5) / 2, n);
    return Math.round(fibN / sqrt5);
};
```

```go [sol3-Golang]
func fib(n int) int {
    sqrt5 := math.Sqrt(5)
    p1 := math.Pow((1+sqrt5)/2, float64(n))
    p2 := math.Pow((1-sqrt5)/2, float64(n))
    return int(math.Round((p1 - p2) / sqrt5))
}
```

```C [sol3-C]
int fib(int n) {
    double sqrt5 = sqrt(5);
    double fibN = pow((1 + sqrt5) / 2, n) - pow((1 - sqrt5) / 2, n);
    return round(fibN / sqrt5);
}
```

```Python [sol3-Python3]
class Solution:
    def fib(self, n: int) -> int:
        sqrt5 = 5**0.5
        fibN = ((1 + sqrt5) / 2) ** n - ((1 - sqrt5) / 2) ** n
        return round(fibN / sqrt5)
```

**复杂度分析**

代码中使用的 $\texttt{pow}$ 函数的时空复杂度与 CPU 支持的指令集相关，这里不深入分析。
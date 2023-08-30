#### 方法一：动态规划

**思路及算法**

我们可以依据题目的要求写出状态表达式：$f[i]$ 表示最少需要多少个数的平方来表示整数 $i$。

这些数必然落在区间 $[1,\sqrt{n}]$。我们可以枚举这些数，假设当前枚举到 $j$，那么我们还需要取若干数的平方，构成 $i-j^2$。此时我们发现该子问题和原问题类似，只是规模变小了。这符合了动态规划的要求，于是我们可以写出状态转移方程。

$$
f[i]=1+\min_{j=1}^{\lfloor\sqrt{i}\rfloor}{f[i-j^2]}
$$

其中 $f[0]=0$ 为边界条件，实际上我们无法表示数字 $0$，只是为了保证状态转移过程中遇到 $j$ 恰为 $\sqrt{i}$ 的情况合法。

同时因为计算 $f[i]$ 时所需要用到的状态仅有 $f[i-j^2]$，必然小于 $i$，因此我们只需要从小到大地枚举 $i$ 来计算 $f[i]$ 即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int numSquares(int n) {
        vector<int> f(n + 1);
        for (int i = 1; i <= n; i++) {
            int minn = INT_MAX;
            for (int j = 1; j * j <= i; j++) {
                minn = min(minn, f[i - j * j]);
            }
            f[i] = minn + 1;
        }
        return f[n];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numSquares(int n) {
        int[] f = new int[n + 1];
        for (int i = 1; i <= n; i++) {
            int minn = Integer.MAX_VALUE;
            for (int j = 1; j * j <= i; j++) {
                minn = Math.min(minn, f[i - j * j]);
            }
            f[i] = minn + 1;
        }
        return f[n];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumSquares(int n) {
        int[] f = new int[n + 1];
        for (int i = 1; i <= n; i++) {
            int minn = int.MaxValue;
            for (int j = 1; j * j <= i; j++) {
                minn = Math.Min(minn, f[i - j * j]);
            }
            f[i] = minn + 1;
        }
        return f[n];
    }
}
```

```go [sol1-Golang]
func numSquares(n int) int {
    f := make([]int, n+1)
    for i := 1; i <= n; i++ {
        minn := math.MaxInt32
        for j := 1; j*j <= i; j++ {
            minn = min(minn, f[i-j*j])
        }
        f[i] = minn + 1
    }
    return f[n]
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var numSquares = function(n) {
    const f = new Array(n + 1).fill(0);
    for (let i = 1; i <= n; i++) {
        let minn = Number.MAX_VALUE;
        for (let j = 1; j * j <= i; j++) {
            minn = Math.min(minn, f[i - j * j]);
        }
        f[i] = minn + 1;
    }
    return f[n];
};
```

```C [sol1-C]
int numSquares(int n) {
    int f[n + 1];
    f[0] = 0;
    for (int i = 1; i <= n; i++) {
        int minn = INT_MAX;
        for (int j = 1; j * j <= i; j++) {
            minn = fmin(minn, f[i - j * j]);
        }
        f[i] = minn + 1;
    }
    return f[n];
}
```

**复杂度分析**

- 时间复杂度：$O(n\sqrt{n})$，其中 $n$ 为给定的正整数。状态转移方程的时间复杂度为 $O(\sqrt{n})$，共需要计算 $n$ 个状态，因此总时间复杂度为 $O(n \sqrt{n})$。

- 空间复杂度：$O(n)$。我们需要 $O(n)$ 的空间保存状态。

#### 方法二：数学

**思路及算法**

一个数学定理可以帮助解决本题：「[四平方和定理](https://baike.baidu.com/item/%E5%9B%9B%E5%B9%B3%E6%96%B9%E5%92%8C%E5%AE%9A%E7%90%86)」。

四平方和定理证明了任意一个正整数都可以被表示为至多四个正整数的平方和。这给出了本题的答案的上界。

同时四平方和定理包含了一个更强的结论：当且仅当 $n \neq 4^k \times (8m+7)$ 时，$n$ 可以被表示为至多三个正整数的平方和。因此，当 $n = 4^k \times (8m+7)$ 时，$n$ 只能被表示为四个正整数的平方和。此时我们可以直接返回 $4$。

当 $n \neq 4^k \times (8m+7)$ 时，我们需要判断到底多少个完全平方数能够表示 $n$，我们知道答案只会是 $1,2,3$ 中的一个：

- 答案为 $1$ 时，则必有 $n$ 为完全平方数，这很好判断；

- 答案为 $2$ 时，则有 $n=a^2+b^2$，我们只需要枚举所有的 $a(1 \leq a \leq \sqrt{n})$，判断 $n-a^2$ 是否为完全平方数即可；

- 答案为 $3$ 时，我们很难在一个优秀的时间复杂度内解决它，但我们只需要检查答案为 $1$ 或 $2$ 的两种情况，即可利用排除法确定答案。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    // 判断是否为完全平方数
    bool isPerfectSquare(int x) {
        int y = sqrt(x);
        return y * y == x;
    }

    // 判断是否能表示为 4^k*(8m+7)
    bool checkAnswer4(int x) {
        while (x % 4 == 0) {
            x /= 4;
        }
        return x % 8 == 7;
    }

    int numSquares(int n) {
        if (isPerfectSquare(n)) {
            return 1;
        }
        if (checkAnswer4(n)) {
            return 4;
        }
        for (int i = 1; i * i <= n; i++) {
            int j = n - i * i;
            if (isPerfectSquare(j)) {
                return 2;
            }
        }
        return 3;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int numSquares(int n) {
        if (isPerfectSquare(n)) {
            return 1;
        }
        if (checkAnswer4(n)) {
            return 4;
        }
        for (int i = 1; i * i <= n; i++) {
            int j = n - i * i;
            if (isPerfectSquare(j)) {
                return 2;
            }
        }
        return 3;
    }

    // 判断是否为完全平方数
    public boolean isPerfectSquare(int x) {
        int y = (int) Math.sqrt(x);
        return y * y == x;
    }

    // 判断是否能表示为 4^k*(8m+7)
    public boolean checkAnswer4(int x) {
        while (x % 4 == 0) {
            x /= 4;
        }
        return x % 8 == 7;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int NumSquares(int n) {
        if (IsPerfectSquare(n)) {
            return 1;
        }
        if (CheckAnswer4(n)) {
            return 4;
        }
        for (int i = 1; i * i <= n; i++) {
            int j = n - i * i;
            if (IsPerfectSquare(j)) {
                return 2;
            }
        }
        return 3;
    }

    // 判断是否为完全平方数
    public bool IsPerfectSquare(int x) {
        int y = (int) Math.Sqrt(x);
        return y * y == x;
    }

    // 判断是否能表示为 4^k*(8m+7)
    public bool CheckAnswer4(int x) {
        while (x % 4 == 0) {
            x /= 4;
        }
        return x % 8 == 7;
    }
}
```

```go [sol2-Golang]
// 判断是否为完全平方数
func isPerfectSquare(x int) bool {
    y := int(math.Sqrt(float64(x)))
    return y*y == x
}

// 判断是否能表示为 4^k*(8m+7)
func checkAnswer4(x int) bool {
    for x%4 == 0 {
        x /= 4
    }
    return x%8 == 7
}

func numSquares(n int) int {
    if isPerfectSquare(n) {
        return 1
    }
    if checkAnswer4(n) {
        return 4
    }
    for i := 1; i*i <= n; i++ {
        j := n - i*i
        if isPerfectSquare(j) {
            return 2
        }
    }
    return 3
}
```

```JavaScript [sol2-JavaScript]
var numSquares = function(n) {
    if (isPerfectSquare(n)) {
        return 1;
    }
    if (checkAnswer4(n)) {
        return 4;
    }
    for (let i = 1; i * i <= n; i++) {
        let j = n - i * i;
        if (isPerfectSquare(j)) {
            return 2;
        }
    }
    return 3;
}

// 判断是否为完全平方数
const isPerfectSquare = (x) => {
    const y = Math.floor(Math.sqrt(x));
    return y * y == x;
}

// 判断是否能表示为 4^k*(8m+7)
const checkAnswer4 = (x) => {
    while (x % 4 == 0) {
        x /= 4;
    }
    return x % 8 == 7;
}
```

```C [sol2-C]
// 判断是否为完全平方数
bool isPerfectSquare(int x) {
    int y = sqrt(x);
    return y * y == x;
}

// 判断是否能表示为 4^k*(8m+7)
bool checkAnswer4(int x) {
    while (x % 4 == 0) {
        x /= 4;
    }
    return x % 8 == 7;
}

int numSquares(int n) {
    if (isPerfectSquare(n)) {
        return 1;
    }
    if (checkAnswer4(n)) {
        return 4;
    }
    for (int i = 1; i * i <= n; i++) {
        int j = n - i * i;
        if (isPerfectSquare(j)) {
            return 2;
        }
    }
    return 3;
}
```

**复杂度分析**

- 时间复杂度：$O(\sqrt{n})$，其中 $n$ 为给定的正整数。最坏情况下答案为 $3$，我们需要运行所有的判断，而判断答案是否为 $1$ 的时间复杂度为 $O(1)$，判断答案是否为 $4$ 的时间复杂度为 $O(\log n)$，剩余判断为 $O(\sqrt n)$，因此总时间复杂度为 $O(\log n + \sqrt n) = O(\sqrt n)$。

- 空间复杂度：$O(1)$。我们只需要常数的空间保存若干变量。
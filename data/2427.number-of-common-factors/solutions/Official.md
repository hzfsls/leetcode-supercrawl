#### 方法一：枚举到较小值

**思路与算法**

由于 $a$ 和 $b$ 的公因子一定不会超过 $a$ 和 $b$，因此我们只需要在 $[1, \min(a, b)]$ 中枚举 $x$，并判断 $x$ 是否为公因子即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int commonFactors(int a, int b) {
        int ans = 0;
        for (int x = 1; x <= min(a, b); ++x) {
            if (a % x == 0 && b % x == 0) {
                ++ans;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int commonFactors(int a, int b) {
        int ans = 0;
        for (int x = 1; x <= Math.min(a, b); ++x) {
            if (a % x == 0 && b % x == 0) {
                ++ans;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CommonFactors(int a, int b) {
        int ans = 0;
        for (int x = 1; x <= Math.Min(a, b); ++x) {
            if (a % x == 0 && b % x == 0) {
                ++ans;
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def commonFactors(self, a: int, b: int) -> int:
        ans = 0
        for x in range(1, min(a, b) + 1):
            if a % x == 0 and b % x == 0:
                ans += 1
        return ans
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int commonFactors(int a, int b) {
    int ans = 0;
    int c = MIN(a, b);
    for (int x = 1; x <= c; ++x) {
        if (a % x == 0 && b % x == 0) {
            ++ans;
        }
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var commonFactors = function(a, b) {
    let ans = 0;
    for (let x = 1; x <= Math.min(a, b); ++x) {
        if (a % x === 0 && b % x === 0) {
            ++ans;
        }
    }
    return ans;
};
```

```go [sol1-Golang]
func commonFactors(a int, b int) int {
    m := min(a, b)
    ans := 0
    for i := 1; i <= m; i++ {
        if a%i == 0 && b%i == 0 {
            ans++
        }
    }
    return ans
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是给定输入 $a$ 和 $b$ 的范围。

- 空间复杂度：$O(1)$。

#### 方法二：枚举到最大公约数

**思路与算法**

$x$ 是 $a$ 和 $b$ 的公因子，当且仅当 $x$ 是 $a$ 和 $b$ 的**最大公约数**的因子。因此，我们可以首先求出 $a$ 和 $b$ 的最大公约数 $c = \gcd(a, b)$，再枚举 $c$ 的因子个数。

我们可以使用类似方法一种的遍历，对于 $[1, c]$ 中的整数依次进行枚举，时间复杂度为 $O(c)$。我们也可以进行一些优化，因子一定是成对出现的：如果 $x$ 是 $c$ 的因子，那么 $\dfrac{c}{x}$ 一定也是 $c$ 的因子。因此，我们可以仅对 $[1, \lfloor \sqrt{c} \rfloor]$ 中的整数依此进行枚举，如果枚举到 $x$ 是 $c$ 的因子，并且 $x \neq \dfrac{c}{x}$（即 $x^2 \neq c$），那么答案额外增加 $1$。这样一来，时间复杂度可以降低至 $O(\sqrt{c})$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int commonFactors(int a, int b) {
        int c = gcd(a, b), ans = 0;
        for (int x = 1; x * x <= c; ++x) {
            if (c % x == 0) {
                ++ans;
                if (x * x != c) {
                    ++ans;
                }
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int commonFactors(int a, int b) {
        int c = gcd(a, b), ans = 0;
        for (int x = 1; x * x <= c; ++x) {
            if (c % x == 0) {
                ++ans;
                if (x * x != c) {
                    ++ans;
                }
            }
        }
        return ans;
    }

    public int gcd(int a, int b) {
        while (b != 0) {
            a %= b;
            a ^= b;
            b ^= a;
            a ^= b;
        }
        return a;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int CommonFactors(int a, int b) {
        int c = GCD(a, b), ans = 0;
        for (int x = 1; x * x <= c; ++x) {
            if (c % x == 0) {
                ++ans;
                if (x * x != c) {
                    ++ans;
                }
            }
        }
        return ans;
    }

    public int GCD(int a, int b) {
        while (b != 0) {
            a %= b;
            a ^= b;
            b ^= a;
            a ^= b;
        }
        return a;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def commonFactors(self, a: int, b: int) -> int:
        c, ans = gcd(a, b), 0
        x = 1
        while x * x <= c:
            if c % x == 0:
                ans += 1
                if x * x != c:
                    ans += 1
            x += 1
        return ans
```

```C [sol2-C]
int gcd(int a, int b) {
    while (b != 0) {
        a %= b;
        a ^= b;
        b ^= a;
        a ^= b;
    }
    return a;
}

int commonFactors(int a, int b) {
    int c = gcd(a, b), ans = 0;
    for (int x = 1; x * x <= c; ++x) {
        if (c % x == 0) {
            ++ans;
            if (x * x != c) {
                ++ans;
            }
        }
    }
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var commonFactors = function(a, b) {
    let c = gcd(a, b), ans = 0;
    for (let x = 1; x * x <= c; ++x) {
        if (c % x === 0) {
            ++ans;
            if (x * x !== c) {
                ++ans;
            }
        }
    }
    return ans;
}

const gcd = (a, b) => {
    while (b !== 0) {
        a %= b;
        a ^= b;
        b ^= a;
        a ^= b;
    }
    return a;
};
```

```go [sol2-Golang]
func commonFactors(a int, b int) int {
	g := gcd(a, b)
	ans := 0
	for i := 1; i*i <= g; i++ {
		if g%i == 0 {
			ans++
			if i*i < g {
				ans++
			}
		}
	}
	return ans
}

func gcd(a, b int) int {
	for a != 0 {
		a, b = b%a, a
	}
	return b
}
```

**复杂度分析**

- 时间复杂度：$O(\sqrt{n})$，其中 $n$ 是给定输入 $a$ 和 $b$ 的范围。需要注意的是，求解 $a$ 和 $b$ 最大公约数需要 $O(\log n)$ 的时间，但其渐进意义下小于 $O(\sqrt{n})$，因此可以省略。

- 空间复杂度：$O(1)$。
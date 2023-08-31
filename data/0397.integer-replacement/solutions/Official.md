## [397.整数替换 中文官方题解](https://leetcode.cn/problems/integer-replacement/solutions/100000/zheng-shu-ti-huan-by-leetcode-solution-swef)
#### 方法一：枚举所有的情况

**思路与算法**

我们可以使用递归的方法枚举所有将 $n$ 变为 $1$ 的替换序列：

- 当 $n$ 为偶数时，我们只有唯一的方法将 $n$ 替换为 $\dfrac{n}{2}$。

- 当 $n$ 为奇数时，我们可以选择将 $n$ 增加 $1$ 或减少 $1$。由于这两种方法都会将 $n$ 变为偶数，那么下一步一定是除以 $2$，因此这里我们可以看成使用两次操作，将 $n$ 变为 $\dfrac{n+1}{2}$ 或 $\dfrac{n-1}{2}$。

**细节**

当 $n = 2^{31}-1$ 时，计算 $n+1$ 会导致溢出，因此我们可以使用整数除法 $\lfloor \dfrac{n}{2} \rfloor + 1$ 和 $\lfloor \dfrac{n}{2} \rfloor$ 分别计算 $\dfrac{n+1}{2}$ 或 $\dfrac{n-1}{2}$，其中 $\lfloor \cdot \rfloor$ 表示向下取整。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int integerReplacement(int n) {
        if (n == 1) {
            return 0;
        }
        if (n % 2 == 0) {
            return 1 + integerReplacement(n / 2);
        }
        return 2 + min(integerReplacement(n / 2), integerReplacement(n / 2 + 1));
    }
};
```

```Java [sol1-Java]
class Solution {
    public int integerReplacement(int n) {
        if (n == 1) {
            return 0;
        }
        if (n % 2 == 0) {
            return 1 + integerReplacement(n / 2);
        }
        return 2 + Math.min(integerReplacement(n / 2), integerReplacement(n / 2 + 1));
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int IntegerReplacement(int n) {
        if (n == 1) {
            return 0;
        }
        if (n % 2 == 0) {
            return 1 + IntegerReplacement(n / 2);
        }
        return 2 + Math.Min(IntegerReplacement(n / 2), IntegerReplacement(n / 2 + 1));
    }
}
```

```Python [sol1-Python3]
class Solution:
    def integerReplacement(self, n: int) -> int:
        if n == 1:
            return 0
        if n % 2 == 0:
            return 1 + self.integerReplacement(n // 2)
        return 2 + min(self.integerReplacement(n // 2), self.integerReplacement(n // 2 + 1))
```

```go [sol1-Golang]
func integerReplacement(n int) int {
    if n == 1 {
        return 0
    }
    if n%2 == 0 {
        return 1 + integerReplacement(n/2)
    }
    return 2 + min(integerReplacement(n/2), integerReplacement(n/2+1))
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var integerReplacement = function(n) {
    if (n === 1) {
        return 0;
    }
    if (n % 2 === 0) {
        return 1 + integerReplacement(Math.floor(n / 2));
    }
    return 2 + Math.min(integerReplacement(Math.floor(n / 2)), integerReplacement(Math.floor(n / 2) + 1));
};
```

**复杂度分析**

- 时间复杂度：$O(\phi ^{\log n})$，其中 $\phi = \dfrac{1+\sqrt{5}}{2} \approx 1.618$ 表示黄金分割比。

    时间复杂度的准确证明较为复杂，这里给出一种直观上的叙述，感兴趣的读者可以自行展开思考：

    - 在递归的过程中，递归树的同一层上最小的 $n$ 值和最大的 $n$ 值相差不会超过 $1$，这里可以使用数学归纳法证明。

    - 如果递归树的上一层出现的值为 $x$ 和 $x+1$，它们分别被递归调用了 $p$ 和 $q$ 次，而当前层出现的值为 $y$ 和 $y+1$，那么它们分别会被递归调用：

        - 要么 $p$ 和 $p+q$ 次；

        - 要么 $p+q$ 和 $q$ 次。
    
        这类似于斐波那契数列的递推式。
    
    因此 $l = O(\log n)$ 层的递归树中所有 $n$ 值被调用的次数之和为 $O(\text{fib}(l)) = O(\text{fib}(\log n))$，其中 $\text{fib}(\cdot)$ 表示斐波那契数列的对应项。由于 $\text{fib}(l) = O(\phi^l)$，因此算法的时间复杂度为 $O(\phi ^{\log n})$。

- 空间复杂度：$O(\log n)$。每一次递归都会将 $n$ 减小一半，因此需要 $O(\log n)$ 的栈空间。

#### 方法二：记忆化搜索

**思路与算法**

我们给方法一的递归加上记忆化，这样递归树的每一层最多只会计算两个 $n$ 值，时间复杂度降低为 $O(\log n)$。

**代码**

```C++ [sol2-C++]
class Solution {
private:
    unordered_map<int, int> memo;

public:
    int integerReplacement(int n) {
        if (n == 1) {
            return 0;
        }
        if (memo.count(n)) {
            return memo[n];
        }
        if (n % 2 == 0) {
            return memo[n] = 1 + integerReplacement(n / 2);
        }
        return memo[n] = 2 + min(integerReplacement(n / 2), integerReplacement(n / 2 + 1));
    }
};
```

```Java [sol2-Java]
class Solution {
    Map<Integer, Integer> memo = new HashMap<Integer, Integer>();

    public int integerReplacement(int n) {
        if (n == 1) {
            return 0;
        }
        if (!memo.containsKey(n)) {
            if (n % 2 == 0) {
                memo.put(n, 1 + integerReplacement(n / 2));
            } else {
                memo.put(n, 2 + Math.min(integerReplacement(n / 2), integerReplacement(n / 2 + 1)));
            }
        }
        return memo.get(n);
    }
}
```

```C# [sol2-C#]
public class Solution {
    Dictionary<int, int> memo = new Dictionary<int, int>();

    public int IntegerReplacement(int n) {
        if (n == 1) {
            return 0;
        }
        if (!memo.ContainsKey(n)) {
            if (n % 2 == 0) {
                memo.Add(n, 1 + IntegerReplacement(n / 2));
            } else {
                memo.Add(n, 2 + Math.Min(IntegerReplacement(n / 2), IntegerReplacement(n / 2 + 1)));
            }
        }
        return memo[n];
    }
}
```

```Python [sol2-Python3]
class Solution:
    @cache
    def integerReplacement(self, n: int) -> int:
        if n == 1:
            return 0
        if n % 2 == 0:
            return 1 + self.integerReplacement(n // 2)
        return 2 + min(self.integerReplacement(n // 2), self.integerReplacement(n // 2 + 1))
```

```go [sol2-Golang]
var memo map[int]int

func _integerReplacement(n int) (res int) {
    if n == 1 {
        return 0
    }
    if res, ok := memo[n]; ok {
        return res
    }
    defer func() { memo[n] = res }()
    if n%2 == 0 {
        return 1 + _integerReplacement(n/2)
    }
    return 2 + min(_integerReplacement(n/2), _integerReplacement(n/2+1))
}

func integerReplacement(n int) (res int) {
    memo = map[int]int{}
    return _integerReplacement(n)
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```JavaScript [sol2-JavaScript]
const memo = new Map();
var integerReplacement = function(n) {
    if (n === 1) {
        return 0;
    }
    if (!memo.has(n)) {
        if (n % 2 === 0) {
            memo.set(n, 1 + integerReplacement(Math.floor(n / 2)));
        } else {
            memo.set(n, 2 + Math.min(integerReplacement(Math.floor(n / 2)), integerReplacement(Math.floor(n / 2) + 1)));
        }
    }
    return memo.get(n);
};
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。

- 空间复杂度：$O(\log n)$，记忆化搜索需要的空间与栈空间相同，同样为 $O(\log n)$。

#### 方法三：贪心

**思路与算法**

实际上，方法一和方法二中的递归枚举中的「最优解」是固定的：

- 当 $n$ 为偶数时，我们只有唯一的方法将 $n$ 替换为 $\dfrac{n}{2}$；

- 当 $n$ 为奇数时，$n$ 除以 $4$ 的余数要么为 $1$，要么为 $3$。

    - 如果为 $1$，我们可以断定，应该将 $n$ 变成 $\dfrac{n-1}{2}$。如果我们必须将 $n$ 变成 $\dfrac{n+1}{2}$ 才能得到最优解，而 $\dfrac{n+1}{2}$ 是奇数，那么：

        - 如果下一步进行 $-1$ 再除以 $2$，得到 $\dfrac{n-1}{4}$，那么从 $\dfrac{n-1}{2}$ 可以除以 $2$ 得到同样的结果；

        - 如果下一步进行 $+1$ 再除以 $2$，得到 $\dfrac{n+3}{4}$，那么从 $\dfrac{n-1}{2}$ 可以除以 $2$ 再 $+1$ 得到同样的结果。
    
        因此将 $n$ 变成 $\dfrac{n-1}{2}$ 总是不会劣于 $\dfrac{n+1}{2}$。
    
    - 如果为 $3$，我们可以断定，应该将 $n$ 变成 $\dfrac{n+1}{2}$。如果我们必须将 $n$ 变成 $\dfrac{n-1}{2}$ 才能得到最优解，而 $\dfrac{n-1}{2}$ 是奇数，那么：

        - 如果下一步进行 $-1$ 再除以 $2$，得到 $\dfrac{n-3}{4}$，那么从 $\dfrac{n+1}{2}$ 可以除以 $2$ 再 $-1$ 得到同样的结果。

        - 如果下一步进行 $+1$ 再除以 $2$，得到 $\dfrac{n+1}{4}$，那么从 $\dfrac{n+1}{2}$ 可以除以 $2$ 得到同样的结果。
    
        因此将 $n$ 变成 $\dfrac{n+1}{2}$ 总是不会劣于 $\dfrac{n-1}{2}$。但这里还需要考虑一种例外的情况，如果 $\dfrac{n-1}{2}$ 已经为 $1$，即 $n=3$ 时，后续就无需再进行任何操作，此时将 $n$ 变成 $\dfrac{n-1}{2}$ 才是最优的。

因此，我们只需要根据上面的分类讨论，求出将 $n$ 变为 $1$ 的操作次数即可。

**代码**

```C++ [sol3-C++]
class Solution {
public:
    int integerReplacement(int n) {
        int ans = 0;
        while (n != 1) {
            if (n % 2 == 0) {
                ++ans;
                n /= 2;
            }
            else if (n % 4 == 1) {
                ans += 2;
                n /= 2;
            }
            else {
                if (n == 3) {
                    ans += 2;
                    n = 1;
                }
                else {
                    ans += 2;
                    n = n / 2 + 1;
                }
            }
        }
        return ans;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int integerReplacement(int n) {
        int ans = 0;
        while (n != 1) {
            if (n % 2 == 0) {
                ++ans;
                n /= 2;
            } else if (n % 4 == 1) {
                ans += 2;
                n /= 2;
            } else {
                if (n == 3) {
                    ans += 2;
                    n = 1;
                } else {
                    ans += 2;
                    n = n / 2 + 1;
                }
            }
        }
        return ans;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int IntegerReplacement(int n) {
        int ans = 0;
        while (n != 1) {
            if (n % 2 == 0) {
                ++ans;
                n /= 2;
            } else if (n % 4 == 1) {
                ans += 2;
                n /= 2;
            } else {
                if (n == 3) {
                    ans += 2;
                    n = 1;
                } else {
                    ans += 2;
                    n = n / 2 + 1;
                }
            }
        }
        return ans;
    }
}
```

```Python [sol3-Python3]
class Solution:
    def integerReplacement(self, n: int) -> int:
        ans = 0
        while n != 1:
            if n % 2 == 0:
                ans += 1
                n //= 2
            elif n % 4 == 1:
                ans += 2
                n //= 2
            else:
                if n == 3:
                    ans += 2
                    n = 1
                else:
                    ans += 2
                    n = n // 2 + 1
        return ans
```

```go [sol3-Golang]
func integerReplacement(n int) (ans int) {
    for n != 1 {
        switch {
        case n%2 == 0:
            ans++
            n /= 2
        case n%4 == 1:
            ans += 2
            n /= 2
        case n == 3:
            ans += 2
            n = 1
        default:
            ans += 2
            n = n/2 + 1
        }
    }
    return
}
```

```JavaScript [sol3-JavaScript]
var integerReplacement = function(n) {
    let ans = 0;
    while (n !== 1) {
        if (n % 2 === 0) {
            ++ans;
            n = Math.floor(n / 2);
        } else if (n % 4 === 1) {
            ans += 2;
            n = Math.floor(n / 2);
        } else {
            if (n === 3) {
                ans += 2;
                n = 1;
            } else {
                ans += 2;
                n = Math.floor(n / 2) + 1;
            }
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。

- 空间复杂度：$O(1)$。
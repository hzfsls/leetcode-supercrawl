## [1025.除数博弈 中文官方题解](https://leetcode.cn/problems/divisor-game/solutions/100000/chu-shu-bo-yi-by-leetcode-solution)

#### 方法一：数学

**思路与算法**

博弈类的问题常常让我们摸不着头脑。当我们没有解题思路的时候，不妨试着写几项试试：

+ $n = 1$ 的时候，区间 $(0, 1)$ 中没有整数是 $n$ 的因数，所以此时 $\text{Alice}$ 败。
+ $n = 2$ 的时候，$\text{Alice}$ 只能拿 $1$，$n$ 变成 $1$，$\text{Bob}$ 无法继续操作，故 $\text{Alice}$ 胜。
+ $n = 3$ 的时候，$\text{Alice}$ 只能拿 $1$，$n$ 变成 $2$，根据 $n = 2$ 的结论，我们知道此时 $\text{Bob}$ 会获胜，$\text{Alice}$ 败。
+ $n = 4$ 的时候，$\text{Alice}$ 能拿 $1$ 或 $2$，如果 $\text{Alice}$ 拿 $1$，根据 $n = 3$ 的结论，$\text{Bob}$ 会失败，$\text{Alice}$ 会获胜。
+ $n = 5$ 的时候，$\text{Alice}$ 只能拿 $1$，根据 $n = 4$ 的结论，$\text{Alice}$ 会失败。
+ ......

写到这里，也许你有了一些猜想。没关系，请大胆地猜想，在这种情况下大胆地猜想是 AC 的第一步。也许你会发现这样一个现象：**$n$ 为奇数的时候 $\text{Alice}$（先手）必败，$n$ 为偶数的时候 $\text{Alice}$ 必胜。** 这个猜想是否正确呢？下面我们来想办法证明它。

**证明**

1. $n = 1$ 和 $n = 2$ 时结论成立。

2. $n > 2$ 时，假设 $n \leq k$ 时该结论成立，则 $n = k + 1$ 时：

	+ 如果 $k$ 为偶数，则 $k + 1$ 为奇数，$x$ 是 $k + 1$ 的因数，只可能是奇数，而奇数减去奇数等于偶数，且 $k + 1 - x \leq k$，故轮到 $\text{Bob}$ 的时候都是偶数。而根据我们的猜想假设 $n\le k$ 的时候偶数的时候先手必胜，故此时无论 $\text{Alice}$ 拿走什么，$\text{Bob}$ 都会处于必胜态，所以 $\text{Alice}$ 处于必败态。
	+ 如果 $k$ 为奇数，则 $k + 1$ 为偶数，$x$ 可以是奇数也可以是偶数，若 $\text{Alice}$ 减去一个奇数，那么 $k + 1 - x$ 是一个小于等于 $k$ 的奇数，此时 $\text{Bob}$ 占有它，处于必败态，则 $\text{Alice}$ 处于必胜态。

综上所述，这个猜想是正确的。

下面是代码实现。

**代码**

```cpp [sol1-C++]
class Solution {
public:
    bool divisorGame(int n) {
        return n % 2 == 0;
    }
};
```
```Java [sol1-Java]
class Solution {
    public boolean divisorGame(int n) {
        return n % 2 == 0;
    }
}
```

```golang [sol1-Golang]
func divisorGame(n int) bool {
    return n % 2 == 0
}
```

```C [sol1-C]
bool divisorGame(int n) {
    return n % 2 == 0;
}
```

**复杂度分析**

+ 时间复杂度：$O(1)$。
+ 空间复杂度：$O(1)$。

#### 方法二：动态规划

**思路与算法**

在「方法一」中，我们写出了前面几项的答案，在这个过程中我们发现，$\text{Alice}$ 处在 $n = k$ 的状态时，他（她）做一步操作，必然使得 $\text{Bob}$ 处于 $n = m (m < k)$ 的状态。因此我们只要看是否存在一个 $m$ 是必败的状态，那么 $\text{Alice}$ 直接执行对应的操作让当前的数字变成 $m$，$\text{Alice}$ 就必胜了，如果没有任何一个是必败的状态的话，说明 $\text{Alice}$ 无论怎么进行操作，最后都会让 $\text{Bob}$ 处于必胜的状态，此时 $\text{Alice}$ 是必败的。

结合以上我们定义 $f[i]$ 表示当前数字 $i$ 的时候先手是处于必胜态还是必败态，$\texttt{true}$ 表示先手必胜，$\texttt{false}$ 表示先手必败，从前往后递推，根据我们上文的分析，枚举 $i$ 在 $(0, i)$ 中 $i$ 的因数 $j$，看是否存在 $f[i-j]$ 为必败态即可。

代码如下。

**代码**

```cpp [sol2-C++]
class Solution {
public:
    bool divisorGame(int n) {
        vector<int> f(n + 5, false);

        f[1] = false;
        f[2] = true;
        for (int i = 3; i <= n; ++i) {
            for (int j = 1; j < i; ++j) {
                if (i % j == 0 && !f[i - j]) {
                    f[i] = true;
                    break;
                }
            }
        }

        return f[n];
    }
};
```
```Java [sol2-Java]
class Solution {
    public boolean divisorGame(int n) {
        boolean[] f = new boolean[n + 5];

        f[1] = false;
        f[2] = true;
        for (int i = 3; i <= n; ++i) {
            for (int j = 1; j < i; ++j) {
                if ((i % j) == 0 && !f[i - j]) {
                    f[i] = true;
                    break;
                }
            }
        }

        return f[n];
    }
}
```

```golang [sol2-Golang]
func divisorGame(n int) bool {
    f := make([]bool, n + 5)
    f[1], f[2] = false, true
    for i := 3; i <= n; i++ {
        for j := 1; j < i; j++ {
            if i % j == 0 && !f[i - j] {
                f[i] = true
                break
            }
        }
    }
    return f[n]
}
```

```C [sol2-C]
bool divisorGame(int n) {
    int f[n + 5];
    memset(f, 0, sizeof(f));

    f[1] = false;
    f[2] = true;
    for (int i = 3; i <= n; ++i) {
        for (int j = 1; j < i; ++j) {
            if (i % j == 0 && !f[i - j]) {
                f[i] = true;
                break;
            }
        }
    }

    return f[n];
}
```

**复杂度分析**

+ 时间复杂度：$O(n^2)$。递推的时候一共有 $n$ 个状态要计算，每个状态需要 $O(n)$ 的时间枚举因数，因此总时间复杂度为 $O(n^2)$。
+ 空间复杂度：$O(n)$。我们需要 $O(n)$ 的空间存储递推数组 $f$ 的值。
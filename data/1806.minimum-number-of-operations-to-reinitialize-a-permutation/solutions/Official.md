## [1806.还原排列的最少操作步数 中文官方题解](https://leetcode.cn/problems/minimum-number-of-operations-to-reinitialize-a-permutation/solutions/100000/huan-yuan-pai-lie-de-zui-shao-cao-zuo-bu-d9cn)
#### 方法一：直接模拟

**思路与算法**

题目要求，一步操作中，对于每个索引 $i$，变换规则如下：
+ 如果 $i$ 为偶数，那么 $\textit{arr}[i] = \textit{perm}[\dfrac{i}{2}]$；
+ 如果 $i$ 为奇数，那么 $\textit{arr}[i] = \textit{perm}[\dfrac{n}{2} + \dfrac{i-1}{2}]$；

然后将 $\textit{arr}$ 赋值给 $\textit{perm}$。 

我们假设初始序列 $\textit{perm} = [0,1,2,\cdots,n-1]$，按照题目上述要求的变换规则进行模拟，直到 $\textit{perm}$ 重新变回为序列 $[0,1,2,\cdots,n-1]$ 为止。每次将 $\textit{perm}$ 按照上述规则变化产生数组 $\textit{arr}$，并将 $\textit{arr}$ 赋给 $\textit{perm}$，然后我们检测 $\textit{perm}$ 是否回到原始状态并计数，如果回到原始状态则中止变换，否则继续变换。

**代码**

```Python [sol1-Python3]
class Solution:
    def reinitializePermutation(self, n: int) -> int:
        perm = list(range(n))
        target = perm.copy()
        step = 0
        while True:
            step += 1
            perm = [perm[n // 2 + (i - 1) // 2] if i % 2 else perm[i // 2] for i in range(n)]
            if perm == target:
                return step
```

```C++ [sol1-C++]
class Solution {
public:
    int reinitializePermutation(int n) {
        vector<int> perm(n), target(n);
        iota(perm.begin(), perm.end(), 0);
        iota(target.begin(), target.end(), 0);
        int step = 0;
        while (true) {
            vector<int> arr(n);
            for (int i = 0; i < n; i++) {
                if (i & 1) {
                    arr[i] = perm[n / 2 + (i - 1) / 2];
                } else {
                    arr[i] = perm[i / 2];
                }
            }
            perm = move(arr);
            step++;
            if (perm == target) {
                break;
            }
        }
        return step;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int reinitializePermutation(int n) {
        int[] perm = new int[n];
        int[] target = new int[n];
        for (int i = 0; i < n; i++) {
            perm[i] = i;
            target[i] = i;
        }
        int step = 0;
        while (true) {
            int[] arr = new int[n];
            for (int i = 0; i < n; i++) {
                if ((i & 1) != 0) {
                    arr[i] = perm[n / 2 + (i - 1) / 2];
                } else {
                    arr[i] = perm[i / 2];
                }
            }
            perm = arr;
            step++;
            if (Arrays.equals(perm, target)) {
                break;
            }
        }
        return step;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int ReinitializePermutation(int n) {
        int[] perm = new int[n];
        int[] target = new int[n];
        for (int i = 0; i < n; i++) {
            perm[i] = i;
            target[i] = i;
        }
        int step = 0;
        while (true) {
            int[] arr = new int[n];
            for (int i = 0; i < n; i++) {
                if ((i & 1) != 0) {
                    arr[i] = perm[n / 2 + (i - 1) / 2];
                } else {
                    arr[i] = perm[i / 2];
                }
            }
            perm = arr;
            step++;
            if (Enumerable.SequenceEqual(perm, target)) {
                break;
            }
        }
        return step;
    }
}
```

```C [sol1-C]
int reinitializePermutation(int n) {
    int perm[n], arr[n], target[n];
    for (int i = 0; i < n; i++) {
        perm[i] = i;
        target[i] = i;
    }
    int step = 0;
    int *pArr = arr, *pPerm = perm;
    while (true) {
        for (int i = 0; i < n; i++) {
            if (i & 1) {
                pArr[i] = pPerm[n / 2 + (i - 1) / 2];
            } else {
                pArr[i] = pPerm[i / 2];
            }
        }
        int *tmp = pArr;
        pArr = pPerm;
        pPerm = tmp;
        step++;
        if (memcmp(pPerm, target, sizeof(int) * n) == 0) {
            break;
        }
    }
    return step;
}
```

```JavaScript [sol1-JavaScript]
var reinitializePermutation = function(n) {
    let perm = new Array(n).fill(0).map((_, i) => i);
    const target = new Array(n).fill(0).map((_, i) => i);
    let step = 0;
    while (true) {
        const arr = new Array(n).fill(0);
        for (let i = 0; i < n; i++) {
            if ((i & 1) !== 0) {
                arr[i] = perm[Math.floor(n / 2) + Math.floor((i - 1) / 2)];
            } else {
                arr[i] = perm[Math.floor(i / 2)];
            }
        }
        perm = arr;
        step++;
        if (perm.toString() === target.toString()) {
            break;
        }
    }
    return step;
};
```

```go [sol1-Golang]
func reinitializePermutation(n int) (step int) {
    target := make([]int, n)
    for i := range target {
        target[i] = i
    }
    perm := append([]int(nil), target...)
    for {
        step++
        arr := make([]int, n)
        for i := range arr {
            if i%2 == 0 {
                arr[i] = perm[i/2]
            } else {
                arr[i] = perm[n/2+i/2]
            }
        }
        perm = arr
        if equal(perm, target) {
            return
        }
    }
}

func equal(a, b []int) bool {
    for i, x := range a {
        if x != b[i] {
            return false
        }
    }
    return true
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 表示给定的元素。根据方法二的推论可以知道最多需要经过 $n$ 次变换即可回到初始状态，每次变换需要的时间复杂度为 $O(n)$，因此总的时间复杂度为 $O(n^2)$。

- 空间复杂度：$O(n)$，其中 $n$ 表示给定的元素。我们需要存储每次变换中的过程变量，需要的空间为 $O(n)$。

#### 方法二：数学

**思路与算法**

我们需要观察一下原排列中对应的索引变换关系。对于原排列中第 $i$ 个元素，设 $g(i)$ 为进行一次操作后，该元素的新的下标，题目转化规则如下:
+ 如果 $g(i)$ 为偶数，那么 $\textit{arr}[g(i)] = \textit{perm}[\dfrac{g(i)}{2}]$，令 $x = \dfrac{g(i)}{2}$，则该等式转换为 $\textit{arr}[2x] = \textit{perm}[x]$，此时 $x\in[0,\dfrac{n-1}{2}]$；
+ 如果 $g(i)$ 为奇数，那么 $\textit{arr}[g(i)] = \textit{perm}[\dfrac{n}{2} + \dfrac{g(i)-1}{2}]$，令 $x = \dfrac{n}{2} + \dfrac{g(i)-1}{2}$，则该等式转换为 $\textit{arr}[2x-n-1] = \textit{perm}[x]$，此时 $x \in[\dfrac{n+1}{2},\dfrac{n}{2}]$；

因此根据题目的转换规则可以得到以下对应关系:
+ 当 $0\le i < \dfrac{n}{2}$ 时，此时 $g(i) = 2i$；
+ 当 $\dfrac{n}{2} \le i < n$ 时，此时 $g(i) = 2i-(n-1)$；

其中原排列中的第 $0$ 和 $n-1$ 个元素的下标不会变换，我们无需进行考虑。 对于其余元素 $i \in [1, n-1)$，上述两个等式可以转换为对 $n-1$ 取模，等式可以转换为 $g(i) \equiv 2i \pmod {(n-1)}$。

记 $g^k(i)$ 表示原排列 $\textit{perm}$ 中第 $i$ 个元素经过 $k$ 次变换后的下标，即 $g^2(i) = g(g(i)), g^3(i) = g(g(g(i)))$ 等等，那么我们可以推出:
$$g^k(i) \equiv 2^ki \pmod {(n-1)}$$

为了让排列还原到初始值，原数组中索引为 $i$ 的元素经过多次变换后索引变回 $i$，此时必须有：$g^k(i) \equiv 2^ki \equiv i \pmod {(n-1)}$。我们只需要找到最小的 $k$，使得上述等式对于 $i\in[1,n-1)$ 均成立，此时的 $k$ 即为所求的最小变换次数。

当 $i=1$ 时，我们有 
$$g^k(1) \equiv 2^k \equiv 1 \pmod {(n-1)}$$

如果存在 $k$ 满足上式，那么将上式两侧同乘 $i$，得到 $g^k(i) \equiv 2^ki \equiv i \pmod {(n-1)}$ 即对于 $i \in [1, n-1)$ 恒成立。因此原题等价于寻找最小的 $k$，使得 $2^k \equiv 1 \pmod {(n-1)}$。

由于 $n$ 为偶数，则 $n-1$ 是奇数，$2$ 和 $n-1$ 互质，那么根据「[欧拉定理](https://oi-wiki.org/math/number-theory/fermat/)」：
$$
2^{\varphi(n-1)} \equiv 1 \pmod {(n-1)}
$$
即 $k=\varphi(n-1)$ 一定是一个解，其中 $\varphi$ 为「[欧拉函数](https://oi-wiki.org/math/number-theory/euler/)」。因此，最小的 $k$ 一定小于等于 $\varphi(n-1)$，而欧拉函数 $\varphi(n-1) \le n -1$，因此可以知道 $k \le n - 1$ 的，因此总的时间复杂度不超过 $O(n)$。

根据上述推论，我们直接模拟即找到最小的 $k$ 使得满足 $2^k \equiv 1 \pmod {(n-1)}$ 即可。

**代码**

```Python [sol2-Python3]
class Solution:
    def reinitializePermutation(self, n: int) -> int:
        if n == 2:
            return 1
        step, pow2 = 1, 2
        while pow2 != 1:
            step += 1
            pow2 = pow2 * 2 % (n - 1)
        return step
```

```C++ [sol2-C++]
class Solution {
public:
    int reinitializePermutation(int n) {
        if (n == 2) {
            return 1;
        }
        int step = 1, pow2 = 2;
        while (pow2 != 1) {
            step++;
            pow2 = pow2 * 2 % (n - 1);
        }
        return step;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int reinitializePermutation(int n) {
        if (n == 2) {
            return 1;
        }
        int step = 1, pow2 = 2;
        while (pow2 != 1) {
            step++;
            pow2 = pow2 * 2 % (n - 1);
        }
        return step;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int ReinitializePermutation(int n) {
        if (n == 2) {
            return 1;
        }
        int step = 1, pow2 = 2;
        while (pow2 != 1) {
            step++;
            pow2 = pow2 * 2 % (n - 1);
        }
        return step;
    }
}
```

```C [sol2-C]
int reinitializePermutation(int n) {
    if (n == 2) {
        return 1;
    }
    int step = 1, pow2 = 2;
    while (pow2 != 1) {
        step++;
        pow2 = pow2 * 2 % (n - 1);
    }
    return step;
}
```

```JavaScript [sol2-JavaScript]
var reinitializePermutation = function(n) {
    if (n === 2) {
        return 1;
    }
    let step = 1, pow2 = 2;
    while (pow2 !== 1) {
        step++;
        pow2 = pow2 * 2 % (n - 1);
    }
    return step;
};
```

```go [sol2-Golang]
func reinitializePermutation(n int) int {
    if n == 2 {
        return 1
    }
    step := 1
    pow2 := 2
    for pow2 != 1 {
        step++
        pow2 = pow2 * 2 % (n - 1)
    }
    return step
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 表示给定的元素。根据推论可以知道最多需要进行计算的次数不超过 $n$，因此时间复杂度为 $O(n)$。

- 空间复杂度：$O(1)$。
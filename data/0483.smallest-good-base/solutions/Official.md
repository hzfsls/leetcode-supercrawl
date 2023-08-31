## [483.最小好进制 中文官方题解](https://leetcode.cn/problems/smallest-good-base/solutions/100000/zui-xiao-hao-jin-zhi-by-leetcode-solutio-csqn)
#### 方法一：数学

**思路及解法**

假设正整数 $n$ 在 $k~(k \geq 2)$ 进制下的所有数位都为 $1$，且位数为 $m + 1$，那么有：

$$
n = k^0 + k^1 + k^2 + \dots + k^m\tag{1}
$$

我们首先讨论两种特殊情况：

- $m=0$，此时 $n=1$，而题目保证 $n \geq 3$，所以本题中 $m>0$。
- $m=1$，此时 $n=(11)_k$，即 $k=n-1\geq 2$，这保证了本题有解。

然后我们分别证明一般情况下的两个结论，以帮助解决本题。

**结论一：$m < \log_k n$** 

注意到 $(1)$ 式右侧是一个首项为 $1$、公比为 $k$ 的等比数列，利用等比数列求和公式，我们可以得到：

$$
n = \frac{1 - k^{m+1}}{1 - k}
$$
 
对公式进行变换可得：

$$
k^{m+1} = kn - n + 1 < kn
$$

移项并化简可得：

$$
m < \log_k n
$$

这个结论帮助我们限制了 $m$ 的范围，本题中 $3 \leq n \leq 10^{18}$ 且 $k \geq 2$，所以 $m < \log_2 10^{18} < 60$。

**结论二：$k = \lfloor \sqrt[m]{n} \rfloor$** 

依据 $(1)$ 式，可知：

$$
n = k^0 + k^1 + k^2 + \dots + k^m > k^m \tag{2}
$$

依据二项式定理可知：

$$
(k+1)^m = \binom{m}{0}k^0 + \binom{m}{1}k^1 + \binom{m}{2}k^2 + \dots + \binom{m}{m}k^m
$$

因为当 $m>1$ 时，$\forall i \in [1,m-1], \dbinom{m}{i} > 1$，所以有：

$$
\begin{aligned}
(k+1)^m &= \binom{m}{0}k^0 + \binom{m}{1}k^1 + \binom{m}{2}k^2 + \dots + \binom{m}{m}k^m \\
&> k^0 + k^1 + k^2 + \dots + k^m = n \tag{3}
\end{aligned}
$$

结合 $(2)(3)$ 两式可知，当 $m>1$ 时，有 $k^m < n < (k+1)^m$。两边同时开方得：

$$
k < \sqrt[m]{n} < k+1
$$

依据这个公式我们知道，$\sqrt[m]{n}$ 必然为一个小数，且 $k$ 为 $\sqrt[m]{n}$ 的整数部分，即 $k = \lfloor \sqrt[m]{n} \rfloor$。

这个结论帮助我们在 $n$ 和 $m$ 已知的情况下快速确定 $k$ 的值。

综合上述两个结论，依据结论一，我们知道 $m$ 的取值范围为 $[1,\log_k n)$，且 $m = 1$ 时必然有解。因为随着 $m$ 的增大，$k$ 不断减小，所以我们只需要从大到小检查每一个 $m$ 可能的取值，利用结论二快速算出对应的 $k$ 值，然后校验计算出的 $k$ 值是否有效即可。如果 $k$ 值有效，我们即可返回结果。

在实际代码中，我们首先算出 $m$ 取值的上界 $\textit{mMax}$，然后从上界开始向下枚举 $m$ 值，如果当前 $m$ 值对应的 $k$ 合法，那么我们即可返回当前的 $k$ 值。如果我们一直检查到 $m=2$ 都没能找到答案，那么此时即可直接返回 $m=1$ 对应的 $k$ 值：$n-1$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string smallestGoodBase(string n) {
        long nVal = stol(n);
        int mMax = floor(log(nVal) / log(2));
        for (int m = mMax; m > 1; m--) {
            int k = pow(nVal, 1.0 / m);
            long mul = 1, sum = 1;
            for (int i = 0; i < m; i++) {
                mul *= k;
                sum += mul;
            }
            if (sum == nVal) {
                return to_string(k);
            }
        }
        return to_string(nVal - 1);
    }
};
```

```Java [sol1-Java]
class Solution {
    public String smallestGoodBase(String n) {
        long nVal = Long.parseLong(n);
        int mMax = (int) Math.floor(Math.log(nVal) / Math.log(2));
        for (int m = mMax; m > 1; m--) {
            int k = (int) Math.pow(nVal, 1.0 / m);
            long mul = 1, sum = 1;
            for (int i = 0; i < m; i++) {
                mul *= k;
                sum += mul;
            }
            if (sum == nVal) {
                return Integer.toString(k);
            }
        }
        return Long.toString(nVal - 1);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string SmallestGoodBase(string n) {
        long nVal = long.Parse(n);
        int mMax = (int) Math.Floor(Math.Log(nVal) / Math.Log(2));
        for (int m = mMax; m > 1; m--) {
            int k = (int) Math.Pow(nVal, 1.0 / m);
            long mul = 1, sum = 1;
            for (int i = 0; i < m; i++) {
                mul *= k;
                sum += mul;
            }
            if (sum == nVal) {
                return k.ToString();
            }
        }
        return (nVal - 1).ToString();
    }
}
```

```JavaScript [sol1-JavaScript]
var smallestGoodBase = function(n) {
    const nVal = parseInt(n);
    const mMax = Math.floor(Math.log(nVal) / Math.log(2));
    for (let m = mMax; m > 1; m--) {
        const k = BigInt(Math.floor(Math.pow(nVal, 1.0 / m)));
        if (k > 1) {
            let mul = BigInt(1), sum = BigInt(1);
            for (let i = 1; i <= m; i++) {
                mul *= k;
                sum += mul;
            }
            if (sum === BigInt(n)) {
                return k + '';
            }
        }
    }
    return (BigInt(n) - BigInt(1)) + '';
};
```

```go [sol1-Golang]
func smallestGoodBase(n string) string {
    nVal, _ := strconv.Atoi(n)
    mMax := bits.Len(uint(nVal)) - 1
    for m := mMax; m > 1; m-- {
        k := int(math.Pow(float64(nVal), 1/float64(m)))
        mul, sum := 1, 1
        for i := 0; i < m; i++ {
            mul *= k
            sum += mul
        }
        if sum == nVal {
            return strconv.Itoa(k)
        }
    }
    return strconv.Itoa(nVal - 1)
}
```

```C [sol1-C]
char* smallestGoodBase(char* n) {
    long nVal = atol(n);
    int mMax = floor(log(nVal) / log(2));
    char* ret = malloc(sizeof(char) * (mMax + 1));
    for (int m = mMax; m > 1; m--) {
        int k = pow(nVal, 1.0 / m);
        long mul = 1, sum = 1;
        for (int i = 0; i < m; i++) {
            mul *= k;
            sum += mul;
        }
        if (sum == nVal) {
            sprintf(ret, "%lld", k);
            return ret;
        }
    }
    sprintf(ret, "%lld", nVal - 1);
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(\log^2 n)$。至多需要进行 $O(\log n)$ 次检查，每次检查的时间复杂度为 $O(\log n)$。

- 空间复杂度：$O(1)$。只需要常数的空间保存若干变量。
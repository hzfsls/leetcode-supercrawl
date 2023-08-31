## [1830.使字符串有序的最少操作次数 中文官方题解](https://leetcode.cn/problems/minimum-number-of-operations-to-make-string-sorted/solutions/100000/shi-zi-fu-chuan-you-xu-de-zui-shao-cao-z-qgra)

#### 前言

读者需要掌握如下进阶知识点才能解决本题：

- 排列数计算。假设有 $a_0$ 个物品 $0$，$a_1$ 个物品 $1$，...，$a_{n-1}$ 个物品 $n-1$，我们需要将它们排成一排，那么方案数为

    $$
    \frac{(a_0 + a_1 + \cdots + a_{n-1})!}{a_0! \cdot a_1! \cdot \cdots \cdot a_{n-1}!}
    $$

- 乘法逆元。如果需要计算 $\dfrac{b}{a}$ 对 $m$ 取模的值，$b$ 和 $a$ 均为表达式（例如上面排列数的分子与分母）并且它们实际的值非常大，无法直接进行计算，那么我们可以求出 $a$ 在模 $m$ 意义下的乘法逆元 $a^{-1}$，此时有

    $$
    \frac{b}{a} \equiv b \cdot a^{-1} \quad (\bmod ~m)
    $$

    这样将除法运算转化为乘法运算，就可以在计算的过程中进行取模了。
    乘法逆元的具体计算方法可以参考题解的最后一节「进阶知识点：乘法逆元」。

#### 方法一：组合数学

**提示 $1$**

观察给定的示例 $1$，我们可以发现，每一轮操作会将字符串 $s$ 变为新的字符串 $s'$，满足 $s$ 和 $s'$ 包含的字符（种类以及数量）完全相同，并且根据字典序，$s'$ 是 $s$ 的前一个字符串。

**提示 $1$ 证明**

设字符串 $s$ 的字符依次为 $s[0], s[1], \cdots, s[n-1]$。

在第一步操作中，我们会找出最大的 $i$，满足 $s[i-1] > s[i]$。这也说明了

$$
s[i] \leq s[i+1] \leq \cdots \leq s[n-1]
$$

即字符串 $s$ **从 $i$ 开始的后缀已经是字典序最小的了**。要想得到 $s'$，我们必须考虑将 $s[i-1]$ 替换为一个更小的字符，可选字符的范围即为 $s[i]$ 到 $s[n-1]$。

在第二步操作中，我们会找出最大的 $j$，满足

$$
s[i] \leq s[i+1] \leq \cdots s[j] < s[i-1] \leq s[j+1] \leq \cdots \leq s[n-1]
$$

也就是说，我们会将 $s[i-1]$ 替换成更小的 $s[j]$，此外不存在比 $s[i-1]$ 小且比 $s[j]$ 大的字符。

在第三步操作中，我们交换 $s[i-1]$ 与 $s[j]$，此时 $s[i]$ 到 $s[n-1]$ 仍然是有序的。但此时并没有得到 $s'$，还需要进行第四步操作，翻转 $s[i]$ 到 $s[n-1]$。这样一来，$s[i]$ 到 $s[n-1]$ 反向有序，这就得到了 $s$ 的前一个字符串 $s'$。

如果我们将上述证明过程中的不等号全部反向，就可以得到 $s$ 的后一个字符串，这也是求数组或字符串元素的下一个排列的常用方法，读者可以尝试使用该方法解决「[31. 下一个排列](https://leetcode-cn.com/problems/next-permutation/)」。

**提示 $2$**

根据提示 $1$，我们需要求出的答案 $\it ans$，等价于 $s$ 是从小到大的第 $\it ans$ 个排列。

因此，我们可以考虑求出比 $s$ 小的排列的个数，即可得到最终的答案。

**思路与算法**

我们可以使用迭代的方法求出比 $s$ 小的排列的个数。

我们从 $s[0]$ 开始考虑，如果某一个排列 $t$ 的首个字符 $t[0] < s[0]$，那么 $t$ 一定比 $s$ 小。

如何求出满足 $t[0] < s[0]$ 的排列个数呢？在 $s$ 的全部 $n$ 个字符中，如果有 $\textit{rank}(s[0])$ 个比 $s[0]$ 小的字符，那么 $t$ 个首个字符在可以在这些字符中任意选择，方案数为 $\textit{rank}(s[0])$；剩余的 $t[1]$ 到 $t[n-1]$ 可以任意排列，方案数为 $(n-1)!$，因此满足 $t[0] < s[0]$ 的排列个数为：

$$
\textit{rank}(s[0]) \times (n-1)!
$$

这样的计算方法并没有考虑到重复字符的情况。因此我们需要统计 $s[0]$ 到 $s[n-1]$ 中每一种字符出现的次数，设字符 $c$ 出现的次数为 $\textit{freq}[c]$，那么无重复计数的排列个数应当为：

$$
\frac{\textit{rank}(s[0]) \times (n-1)!}{\prod_c \textit{freq}[c]!}
$$

这样我们就求出了所有满足 $t[0] < s[0]$ 的排列个数。

除此之外，如果 $t$ 要比 $s$ 小，那么需要满足 $t[0] = s[0]$ 并且 $t[1]$ 到 $t[n-1]$ 对应的排列需要比 $s[1]$ 到 $s[n-1]$ 对应的排列小。这就变成了一个完全相同，但规模减少了 $1$ 的问题，我们就可以迭代地计算下去，将计算出的「无重复计数的排列个数」进行累加，直到字符串的末尾。

**例子**

我们以字符串 $s = \texttt{leetcode}$ 为例，模拟以下迭代计算的过程。

- 考虑 $s[0]$ 时，字符数量为 $\{ \texttt{c}: 1, \texttt{d}: 1, \texttt{e}: 3, \texttt{l}: 1, \texttt{o}: 1, \texttt{t}: 1 \}$。比 $s[0]=\texttt{l}$ 小的字符有 $1+1+3=5$ 个，那么排列个数为：

    $$
    \frac{5 \times 7!}{1! \times 1! \times 3! \times 1! \times 1! \times 1!} = 4200
    $$

- 考虑 $s[1]$ 时，字符数量为 $\{ \texttt{c}: 1, \texttt{d}: 1, \texttt{e}: 3, \texttt{o}: 1, \texttt{t}: 1 \}$。比 $s[1]=\texttt{e}$ 小的字符有 $1+1=2$ 个，那么排列个数为：

    $$
    \frac{2 \times 6!}{1! \times 1! \times 3! \times 1! \times 1!} = 240
    $$

- 考虑 $s[2]$ 时，字符数量为 $\{ \texttt{c}: 1, \texttt{d}: 1, \texttt{e}: 2, \texttt{o}: 1, \texttt{t}: 1 \}$。比 $s[2]=\texttt{e}$ 小的字符有 $1+1=2$ 个，那么排列个数为：

    $$
    \frac{2 \times 5!}{1! \times 1! \times 2! \times 1! \times 1!} = 120
    $$

- 考虑 $s[3]$ 时，字符数量为 $\{ \texttt{c}: 1, \texttt{d}: 1, \texttt{e}: 1, \texttt{o}: 1, \texttt{t}: 1 \}$。比 $s[3]=\texttt{t}$ 小的字符有 $1+1+1+1+1=4$ 个，那么排列个数为：

    $$
    \frac{4 \times 4!}{1! \times 1! \times 1! \times 1! \times 1!} = 96
    $$

- 考虑 $s[4]$ 时，字符数量为 $\{ \texttt{c}: 1, \texttt{d}: 1, \texttt{e}: 1, \texttt{o}: 1 \}$。没有比 $s[4]=\texttt{c}$ 小的字符，排列个数为 $0$；

- 考虑 $s[5]$ 时，字符数量为 $\{ \texttt{d}: 1, \texttt{e}: 1, \texttt{o}: 1 \}$。比 $s[5]=\texttt{o}$ 小的字符有 $1+1=2$ 个，那么排列个数为：

    $$
    \frac{2 \times 2!}{1! \times 1! \times 1!} = 4
    $$

- 考虑 $s[6]$ 时，字符数量为 $\{ \texttt{d}: 1, \texttt{e}: 1 \}$。没有比 $s[6]=\texttt{o}$ 小的字符，排列个数为 $0$；

- $s[7]$ 已经到达字符串 $s$ 的末尾，一定没有比它小的字符，无需考虑。

因此，$s = \texttt{leetcode}$ 是第

$$
4200+240+120+96+4=4660
$$

个排列。

**细节**

由于我们需要用到大量的阶乘，因此我们可以预处理出所有 $n$ 以内的阶乘对 $m$ 取模的值。同时，由于阶乘会出现在分母的位置，我们还需要预处理出所有 $n$ 以内的阶乘在模 $m$ 意义下的乘法逆元。

更多的细节可以参考代码中的注释。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int mod = 1000000007;
    using LL = long long;
    
public:
    // 快速幂，用来计算 x^y mod m
    int quickmul(int x, int y) {
        int ret = 1, mul = x;
        while (y) {
            if (y & 1) {
                ret = (LL)ret * mul % mod;
            }
            mul = (LL)mul * mul % mod;
            y >>= 1;
        }
        return ret;
    }
    
    int makeStringSorted(string s) {
        int n = s.size();
        
        // fac[i] 表示 i! mod m
        // facinv[i] 表示 i! 在 mod m 意义下的乘法逆元
        vector<int> fac(n + 1), facinv(n + 1);
        fac[0] = facinv[0] = 1;
        for (int i = 1; i < n; ++i) {
            fac[i] = (LL)fac[i - 1] * i % mod;
            // 使用费马小定理 + 快速幂计算乘法逆元
            facinv[i] = quickmul(fac[i], mod - 2);
        }
        
        // freq 存储每个字符出现的次数
        vector<int> freq(26);
        for (char ch: s) {
            ++freq[ch - 'a'];
        }
        
        int ans = 0;
        for (int i = 0; i < n - 1; ++i) {
            // rank 求出比 s[i] 小的字符数量
            int rank = 0;
            for (int j = 0; j < s[i] - 'a'; ++j) {
                rank += freq[j];
            }
            // 排列个数的分子
            int cur = (LL)rank * fac[n - i - 1] % mod;
            // 依次乘分母每一项阶乘的乘法逆元
            for (int j = 0; j < 26; ++j) {
                cur = (LL)cur * facinv[freq[j]] % mod;
            }
            ans = (ans + cur) % mod;
            --freq[s[i] - 'a'];
        }
        
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def makeStringSorted(self, s: str) -> int:
        mod = 10**9 + 7
        
        # 快速幂，用来计算 x^y mod m
        def quickmul(x: int, y: int) -> int:
            # Python 有方便的内置函数
            return pow(x, y, mod)
    
        n = len(s)
        
        # fac[i] 表示 i! mod m
        # facinv[i] 表示 i! 在 mod m 意义下的乘法逆元
        fac, facinv = [0] * (n + 1), [0] * (n + 1)
        fac[0] = facinv[0] = 1
        for i in range(1, n):
            fac[i] = fac[i - 1] * i % mod
            # 使用费马小定理 + 快速幂计算乘法逆元
            facinv[i] = quickmul(fac[i], mod - 2)
        
        # freq 存储每个字符出现的次数
        freq = collections.Counter(s)
        
        ans = 0
        for i in range(n - 1):
            # rank 求出比 s[i] 小的字符数量
            rank = sum(occ for ch, occ in freq.items() if ch < s[i])
            # 排列个数的分子
            cur = rank * fac[n - i - 1] % mod
            # 依次乘分母每一项阶乘的乘法逆元
            for ch, occ in freq.items():
                cur = cur * facinv[occ] % mod
            
            ans += cur
            freq[s[i]] -= 1
            if freq[s[i]] == 0:
                freq.pop(s[i])
        
        return ans % mod
```

**复杂度分析**

- 时间复杂度：$O(n \log \textit{mod} + n|\Sigma|)$，其中 $n$ 是字符串的长度，$\textit{mod}=10^9+7$ 为取模数，$\Sigma$ 是字符集，本题中字符串只包含小写字母，因此 $|\Sigma|=26$。时间复杂度包含如下部分：

    - 预处理阶乘的时间复杂度为 $O(n)$；
    - 预处理阶乘的乘法逆元的时间复杂度为 $O(n \log \textit{mod})$，这一步也可以根据一些性质优化至 $O(n)$，感兴趣的读者可以尝试搜索「线性逆元」进行解决；
    - 迭代计算的时间复杂度为 $O(n|\Sigma|)$。

- 空间复杂度：$O(n + |\Sigma|)$。我们需要 $O(n)$ 的空间存储预处理的阶乘以及阶乘的乘法逆元，$O(|\Sigma|)$ 的空间存储每种字符的出现次数。

#### 进阶知识点：乘法逆元

设模数为 $m$（在本题中 $m=10^9+7$），对于一个整数 $a$，如果存在另一个整数 $a^{-1}~(0 < a^{-1} < m)$，满足

$$
a a^{-1} \equiv 1 ~ (\bmod ~ m)
$$

那么我们称 $a^{-1}$ 是 $a$ 的「乘法逆元」。

当 $a$ 是 $m$ 的倍数时，显然 $a^{-1}$ 不存在。而当 $a$ 不是 $m$ 的倍数时，根据上式可得

$$
aa^{-1} = km + 1, \quad k \in \mathbb{N}
$$

整理得

$$
a^{-1} \cdot a - k \cdot m = 1
$$

**若 $m$ 为质数**，根据「裴蜀定理」，$\text{gcd}(a, m) = 1$，因此必存在整数 $a^{-1}$ 和 $k$ 使得上式成立。

如果 $(a^{-1}_0, k_0)$ 是一组解，那么

$$
(a^{-1}_0 + cm, k_0 + ca), \quad c \in \mathbb{Z}
$$

都是上式的解。因此必然存在一组解中的 $a_0^{-1}$ 满足 $0 < a_0^{-1} < m$，即为我们所求的 $a^{-1}$。

那么如何求出 $a^{-1}$ 呢？**当 $m$ 为质数时**，一种简单的方法是使用「费马小定理」，即

$$
a^{m-1} \equiv 1 ~ (\bmod ~ m)
$$

那么有

$$
\left.
\begin{aligned}
& a^{m-1} a^{-1} \equiv a^{-1} \\
\Leftrightarrow ~ & a^{m-2} a a^{-1} \equiv a^{-1} \\
\Leftrightarrow ~ & a^{m-2} \equiv a^{-1}
\end{aligned}
\right. \quad (\bmod ~ m)
$$

因此，$a^{-1}$ 就等于 $a^{m-2}$ 对 $m$ 取模的结果。而计算 $a^{m-2}$ 的方法相对简单，我们可以使用「快速幂」，时间复杂度为 $O(\log m)$，具体可以参考「[50. Pow(x, n) 的官方题解](https://leetcode-cn.com/problems/powx-n/solution/powx-n-by-leetcode-solution/)」。

**当 $m$ 不为质数时**，我们可以使用「[扩展欧几里得算法](https://baike.baidu.com/item/%E6%89%A9%E5%B1%95%E6%AC%A7%E5%87%A0%E9%87%8C%E5%BE%97%E7%AE%97%E6%B3%95)」求出乘法逆元，但该知识点与本题无关，这里不再赘述。

乘法逆元可以使得我们在取模的意义下，化除法为乘法。例如当我们需要求出 $\dfrac{b}{a}$ 对 $m$ 取模的结果，那么可以使用乘法逆元

$$
\frac{b}{a} \equiv b \cdot a^{-1} ~ (\bmod ~ m)
$$

帮助我们进行求解。由于**乘法在取模的意义下满足分配律**，即

$$
(a \times b) \bmod m = \big((a \bmod m) \times (b \bmod m)\big) \bmod m
$$

而除法在取模的意义下并不满足分配律。因此当 $a$ 和 $b$ 的求解过程中本身就包含取模运算时，我们仍然可以得到正确的 $\dfrac{b}{a}$ 对 $m$ 取模的结果。
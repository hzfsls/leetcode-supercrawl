## [1922.统计好数字的数目 中文官方题解](https://leetcode.cn/problems/count-good-numbers/solutions/100000/tong-ji-hao-shu-zi-de-shu-mu-by-leetcode-53jj)
#### 方法一：快速幂

**思路与算法**

对于偶数下标处的数字，它可以为 $0, 2, 4, 6, 8$ 共计 $5$ 种，而长度为 $n$ 的数字字符串有 $\lfloor \dfrac{n+1}{2} \rfloor$ 个偶数下标，其中 $\lfloor x \rfloor$ 表示对 $x$ 向下取整。

对于奇数下标处的数字，它可以为 $2, 3, 5, 7$ 共计 $4$ 种，而长度为 $n$ 的数字字符串有 $\lfloor \dfrac{n}{2} \rfloor$ 个奇数下标。

因此长度为 $n$ 的数字字符串中，好数字的总数即为：

$$
5^{\lfloor \frac{n+1}{2} \rfloor} \cdot 4^{\lfloor \frac{n}{2} \rfloor}
$$

在本题中，由于 $n$ 的取值最大可以到 $10^{15}$，如果通过普通的乘法运算直接求出上式中的幂，会超出时间限制，因此我们需要使用快速幂算法对幂的求值进行优化。

快速幂算法可以参考[「50. Pow(x, n)」的官方题解](https://leetcode-cn.com/problems/powx-n/solution/powx-n-by-leetcode-solution/)。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int mod = 1000000007;
    
public:
    int countGoodNumbers(long long n) {
        // 快速幂求出 x^y % mod
        auto quickmul = [](int x, long long y) -> int {
            int ret = 1, mul = x;
            while (y > 0) {
                if (y % 2 == 1) {
                    ret = (long long)ret * mul % mod;
                }
                mul = (long long)mul * mul % mod;
                y /= 2;
            }
            return ret;
        };
        
        return (long long)quickmul(5, (n + 1) / 2) * quickmul(4, n / 2) % mod;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def countGoodNumbers(self, n: int) -> int:
        mod = 10**9 + 7
        
        # 快速幂求出 x^y % mod
        def quickmul(x: int, y: int) -> int:
            ret, mul = 1, x
            while y > 0:
                if y % 2 == 1:
                    ret = ret * mul % mod
                mul = mul * mul % mod
                y //= 2
            return ret
            
        return quickmul(5, (n + 1) // 2) * quickmul(4, n // 2) % mod
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。

- 空间复杂度：$O(1)$。
## [1952.三除数 中文官方题解](https://leetcode.cn/problems/three-divisors/solutions/100000/san-chu-shu-by-leetcode-solution-z1b4)

#### 方法一：枚举正除数

**思路与算法**

为了计算整数 $n$ 的正除数数目，一种常见的思路是遍历 $[1, n]$ 闭区间内的所有正整数。但对于任意一个大于等于 $\left\lfloor \sqrt{n} \right\rfloor$ （其中 $\left\lfloor \dots \right\rfloor$ 为向下取整）的正除数 $x$，$n / x$ 也是 $n$ 的正除数，且一定小于等于 $\left\lfloor \sqrt{n} \right\rfloor$。

因此，我们只需遍历 $[1, \left\lfloor \sqrt{n} \right\rfloor]$ 闭区间内的所有正整数，便可以统计出整数 $n$ 的正除数数目。如果整数 $x$ 被 $n$ 整除，那么 $x$ 与 $n / x$ 都是 $n$ 的正除数。此时我们需要根据 $x$ 与 $n / x$ 是否相等来确定新增的正除数数目：

- $x = n / x$，此时新增的正除数数目为 $1$；

- $x \not = n / x$，此时新增的正除数数目为 $2$。

最终，我们判断正除数总数是否等于 $3$ 并返回答案。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool isThree(int n) {
        int cnt = 0;
        for (int i = 1; i * i <= n; ++i){
            if (n % i == 0){
                if (i != n / i){
                    // 此时 i 与 n / i 为不同整数
                    cnt += 2;
                }
                else{
                    // 此时 i 与 n / i 相等
                    cnt += 1;
                }
            }
        }
        return cnt == 3;
    }
};
```

```Python [sol1-Python3]
from math import sqrt

class Solution:
    def isThree(self, n: int) -> bool:
        cnt = 0
        i = 1
        while i * i <= n:
            if n % i == 0:
                if i != n // i:
                    # 此时 i 与 n / i 为不同整数
                    cnt += 2
                else:
                    /# 此时 i 与 n / i 相等
                    cnt += 1
            i += 1
        return cnt == 3
```

**复杂度分析**

- 时间复杂度：$O(\sqrt{n})$，其中 $n$ 为整数的大小。即为遍历 $[1, \left\lfloor \sqrt{n} \right\rfloor]$ 内整数并统计正除数数量的时间复杂度。

- 空间复杂度：$O(1)$。
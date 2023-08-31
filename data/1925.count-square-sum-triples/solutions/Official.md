## [1925.统计平方和三元组的数目 中文官方题解](https://leetcode.cn/problems/count-square-sum-triples/solutions/100000/tong-ji-ping-fang-he-san-yuan-zu-de-shu-dfenx)

#### 方法一：枚举

**思路与算法**

我们可以枚举整数三元组 $(a, b, c)$ 中的 $a$ 和 $b$，并判断 $a^2 + b^2$ 是否为完全平方数，且 $\sqrt{a^2 + b^2}$ 是否为不大于 $n$ 的整数。

我们可以对 $a^2 + b^2$ 开平方，计算 $\left\lfloor \sqrt{a^2 + b^2} \right\rfloor^2$ 是否等于 $a^2 + b^2$ 以判断 $a^2 + b^2$ 是为完全平方数。同时，我们还需要判断 $\left\lfloor \sqrt{a^2 + b^2} \right\rfloor$ 是否不大于 $n$。

在遍历枚举的同时，我们维护平方和三元组的数目，如果符合要求，我们将计数加 $1$。最终，我们返回该数目作为答案。

**细节**

在计算 $\left\lfloor \sqrt{a^2 + b^2} \right\rfloor$ 时，为了防止浮点数造成的潜在误差，同时考虑到完全平方正数之间的距离一定大于 $1$，的我们可以用 $\sqrt{a^2 + b^2 + 1}$ 来替代 $\sqrt{a^2 + b^2}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countTriples(int n) {
        int res = 0;
        // 枚举 a 与 b
        for (int a = 1; a <= n; ++a){
            for (int b = 1; b <= n; ++b){
                // 判断是否符合要求
                int c = int(sqrt(a * a + b * b + 1.0));
                if (c <= n && c * c == a * a + b * b){
                    ++res;
                }
            }
        }
        return res;
    }
};
```

```Python [sol1-Python3]
from math import sqrt

class Solution:
    def countTriples(self, n: int) -> int:
        res = 0
        # 枚举 a 与 b
        for a in range(1, n + 1):
            for b in range(1, n + 1):
                # 判断是否符合要求
                c = int(sqrt(a ** 2 + b ** 2 + 1))
                if c <= n and c ** 2 == a ** 2 + b ** 2:
                    res += 1
        return res
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 为三元组元素的上界。即为遍历 $a$ 与 $b$ 的时间复杂度。

- 空间复杂度：$O(1)$。
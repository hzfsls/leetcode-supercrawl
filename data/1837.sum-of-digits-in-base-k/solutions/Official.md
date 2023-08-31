## [1837.K 进制表示下的各位数字总和 中文官方题解](https://leetcode.cn/problems/sum-of-digits-in-base-k/solutions/100000/k-jin-zhi-biao-shi-xia-de-ge-wei-shu-zi-4ltwc)

#### 方法一：模拟

**提示 $1$**

模拟进制转换的过程。

**提示 $2$**

事实上，我们并不需要显式求出进制转换后的结果。

**思路与算法**

在将 $10$ 进制的数转换为 $k$ 进制的过程中，我们只需要用 $\textit{res}$ 维护各位数字之和即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int sumBase(int n, int k) {
        int res = 0;
        while (n){
            res += n % k;
            n /= k;
        }
        return res;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def sumBase(self, n: int, k: int) -> int:
        res = 0
        while n:
            res += n % k
            n //= k
        return res
```

**复杂度分析**

- 时间复杂度：$O(\log n)$，循环的次数与 $n$ 在 $k$ 进制下的位数相同。

- 空间复杂度：$O(1)$。
## [2310.个位数字为 K 的整数之和 中文官方题解](https://leetcode.cn/problems/sum-of-numbers-with-units-digit-k/solutions/100000/ge-wei-shu-zi-wei-k-de-zheng-shu-zhi-he-c8nlx)

#### 方法一：枚举集合的大小

**思路与算法**

当 $\textit{num} = 0$ 时，唯一的方法是选择一个空集合，答案为 $0$。

当 $\textit{num} > 0$ 时，我们可以发现最多不会选择超过 $10$ 个数。这是因为如果这些数的个位数字为 $k$，并且我们选择了至少 $11$ 个数，由于 $11k$ 的个位数字也为 $k$，那么我们可以把任意的 $11$ 个数合并成一个，使得选择的数仍然满足要求，并且集合更小。

因此，我们可以枚举选择的数的个数 $i$。由于每个数最小为 $k$，那么这 $i$ 个数的和至少为 $i \cdot k$。如果 $i \cdot k > \textit{num}$，那么无法满足要求，否则这 $i$ 个数的和的个位数字已经确定，即为 $i \cdot k \bmod 10$。我们需要保证其与 $\textit{num}$ 的个位数字相同，这样 $\textit{num} - i \cdot k$ 就是 $10$ 的倍数，我们把多出的部分加在任意一个数字上，都不会改变它的个位数字。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minimumNumbers(int num, int k) {
        if (num == 0) {
            return 0;
        }
        for (int i = 1; i <= 10; ++i) {
            if (k * i <= num && (num - k * i) % 10 == 0) {
                return i;
            }
        }
        return -1;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minimumNumbers(self, num: int, k: int) -> int:
        if num == 0:
            return 0
        
        for i in range(1, 11):
            if k * i <= num and (num - k * i) % 10 == 0:
                return i
        
        return -1
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。
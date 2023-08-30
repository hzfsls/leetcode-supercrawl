#### 方法一：数学

**思路与算法**

一个数 $\textit{num}$ 能表示成三个连续整数的和，当且仅当 $\textit{num}$ 是 $3$ 的倍数，此时三个整数分别为：

$$
\frac{\textit{nums}}{3} - 1, \frac{\textit{nums}}{3}, \frac{\textit{nums}}{3} + 1
$$

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<long long> sumOfThree(long long num) {
        if (num % 3 == 0) {
            return {num / 3 - 1, num / 3, num / 3 + 1};
        }
        return {};
    }
};
```

```Python [sol1-Python3]
class Solution:
    def sumOfThree(self, num: int) -> List[int]:
        if num % 3 == 0:
            return [num // 3 - 1, num // 3, num // 3 + 1]
        return []
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。
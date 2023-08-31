## [2220.转换数字的最少位翻转次数 中文官方题解](https://leetcode.cn/problems/minimum-bit-flips-to-convert-number/solutions/100000/zhuan-huan-shu-zi-de-zui-shao-wei-fan-zh-awf2)

#### 方法一：位运算

**思路与算法**

为了使得位翻转操作的次数最少，我们应当只对 $\textit{start}$ 与 $\textit{goal}$ 数值不同的二进制位执行翻转操作，而对应的最少次数即为这两个数字不同的二进制位数量。

为了求出 $\textit{start}$ 与 $\textit{goal}$ 不同的二进制位数量，我们可以计算两个数**按位异或**后的数值 $\textit{tmp} = \textit{start} \oplus \textit{goal}$。根据异或运算的定义，$\textit{tmp}$ 某一二进制位为 $1$ **当且仅当** $\textit{start}$ 与 $\textit{goal}$ 在该位数值不同。因此，$\textit{tmp}$ 的二进制表示中 $1$ 的数量即为 $\textit{start}$ 与 $\textit{goal}$ 不同的二进制位数量。我们计算并返回该值即可。

关于如何计算一个整数二进制表示中 $1$ 的数量，读者可以参考[「191. 位1的个数」的题解](https://leetcode-cn.com/problems/number-of-1-bits/solution/wei-1de-ge-shu-by-leetcode-solution-jnwf/)，本文中我们将使用循环检查二进制位的方法计算。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minBitFlips(int start, int goal) {
        int res = 0;
        int tmp = start ^ goal;
        while (tmp) {
            res += tmp & 1;
            tmp >>= 1;
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def minBitFlips(self, start: int, goal: int) -> int:
        res = 0
        tmp = start ^ goal
        while tmp:
            res += tmp & 1
            tmp >>= 1
        return res
```


**复杂度分析**

- 时间复杂度：$O(\log M)$，其中 $M = \max(\textit{start}, \textit{goal})$ 为两数的较大值，即为计算异或数值中 $1$ 的位数的时间复杂度。

- 空间复杂度：$O(1)$。
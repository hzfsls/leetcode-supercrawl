## [2231.按奇偶性交换后的最大数字 中文官方题解](https://leetcode.cn/problems/largest-number-after-digit-swaps-by-parity/solutions/100000/an-qi-ou-xing-jiao-huan-hou-de-zui-da-sh-29oa)

#### 方法一：排序

**思路与算法**

根据题意，为了使得交换后的数字最大，我们需要让 $\textit{num}$ 所有数值为奇数和偶数的十进制位对应的数值都**各自按照数值大小降序排序**。

为了实现这一操作，我们首先需要将 $\textit{num}$ 转化为字符串或者每十进制位数值组成的数组，随后再在生成的字符串或数组上进行排序操作。

对于具体的排序操作，考虑到实现的难度，我们可以使用**较为简单的原地排序**算法，例如冒泡排序或选择排序。需要注意，只有当两个下标对应的数值的**奇偶性相同**时，才进行大小比较与可能的交换操作。

最终，我们将排序后的数组转化为整数并返回。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int largestInteger(int num) {
        string s = to_string(num);   // 转化为字符串
        int n = s.size();
        // 进行选择排序
        for (int i = 0; i < n - 1; ++i) {
            for (int j = i + 1; j < n; ++j) {
                // 只有下标数值奇偶相同才进行判断
                if ((s[i] - s[j]) % 2 == 0 && s[i] < s[j]) {
                    swap(s[i], s[j]);
                }
            }
        }
        // 转化为最终的整数
        return stoi(s);
    }
};
```


```Python [sol1-Python3]
class Solution:
    def largestInteger(self, num: int) -> int:
        l = [int(d) for d in list(str(num))]   # 转化为各位数值的数组
        n = len(l)
        # 进行选择排序
        for i in range(n - 1):
            for j in range(i + 1, n):
                # 只有下标数值奇偶相同才进行判断
                if (l[i] - l[j]) % 2 == 0 and l[i] < l[j]:
                    l[i], l[j] = l[j], l[i]
        # 转化为最终的整数
        return int("".join(str(d) for d in l))
```
 

**复杂度分析**

- 时间复杂度：$O(k^2)$，其中 $k$ 为 $\textit{num}$ 的位数。即为对奇偶数值的位分别进行排序的时间复杂度。

- 空间复杂度：$O(k)$，即为辅助数组或字符串的空间开销。
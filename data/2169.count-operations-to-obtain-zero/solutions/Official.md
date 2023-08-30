#### 方法一：辗转相除

**思路与算法**

我们可以按要求模拟两数比较后相减的操作，但在两数差距十分悬殊时，会有大量连续且相同的相减操作，因此我们可以对模拟的过程进行优化。

不妨假设 $\textit{num}_1 \ge \textit{num}_2$，则我们需要用 $\textit{num}_1$ 减 $\textit{num}_2$，直到 $\textit{num}_1 < \textit{num}_2$ 为止。当上述一系列操作结束之后，$\textit{num}_1$ 的新数值即为 $\textit{num}_1 \bmod \textit{num}_2$，在这期间进行了 $\lfloor \textit{num}_1 / \textit{num}_2 \rfloor$ 次相减操作，其中 $\lfloor\dots\rfloor$ 代表向下取整。

容易发现，题目中的过程即为求两个数最大公约数的「辗转相减」方法，而我们需要将它优化为时间复杂度更低的「辗转相除」法，同时利用前文的方法统计对应相减操作的次数。

具体而言，在模拟的过程中，我们用 $\textit{res}$ 来统计相减操作的次数。在每一步模拟开始前，我们需要保证 $\textit{num}_1 \ge \textit{num}_2$；在每一步中，两个数 $(\textit{num}_1, \textit{num}_2)$ 变为 $(\textit{num}_1 \bmod \textit{num}_2, \textit{num}_2)$，同时我们将 $\textit{res}$ 加上该步中相减操作的次数 $\lfloor \textit{num}_1 / \textit{num}_2 \rfloor$；最后，我们还需要交换 $\textit{num}_1$ 与 $\textit{num}_2$ 的数值，以保证下一步模拟的初始条件。当 $\textit{num}_1$ 或 $\textit{num}_2$ 中至少有一个数字为零时，循环结束，我们返回 $\textit{res}$ 作为答案。

**细节**

在第一步模拟（进入循环）之前，我们事实上不需要保证 $\textit{num}_1 \ge \textit{num}_2$，因为我们可以通过额外的一步模拟将 $(\textit{num}_1, \textit{num}_2)$ 变为 $(\textit{num}_2, \textit{num}_1)$，而这一步贡献的相减次数为 $0$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countOperations(int num1, int num2) {
        int res = 0;   // 相减操作的总次数
        while (num1 && num2) {
            // 每一步辗转相除操作
            res += num1 / num2;
            num1 %= num2;
            swap(num1, num2);
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def countOperations(self, num1: int, num2: int) -> int:
        res = 0   # 相减操作的总次数
        while num1 and num2:
            # 每一步辗转相除操作
            res += num1 // num2
            num1 %= num2
            num1, num2 = num2, num1
        return res
```


**复杂度分析**

- 时间复杂度：$O(\log \max(\textit{num}_1, \textit{num}_2))$。即为模拟辗转相除并统计操作次数的时间复杂度。

- 空间复杂度：$O(1)$。
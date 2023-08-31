## [2162.设置时间的最少代价 中文官方题解](https://leetcode.cn/problems/minimum-cost-to-set-cooking-time/solutions/100000/she-zhi-shi-jian-de-zui-shao-dai-jie-by-1ma95)

#### 方法一：模拟

**提示 $1$**

对于某一个目标秒数，**至多只有两种**按键方案有可能是最优的。

**提示 $1$ 解释**

首先，对于某一种带有前导零的（四位数字）输入，不输入前导零显然是更优的。

我们用 $m, s$ 来表示四位输入的前两位和后两位。根据题意，我们有 $0 \le m, s \le 99$。如果**确定了 $m, s$**，那么对应的最优操作方式也可以确定，即**移动次数最少**的方式（此时按键次数已确定）。

同时，我们用 $\textit{mm}, \textit{ss} (0 \le \textit{ss} \le 59)$ 来**唯一表示**目标时间对应的分和秒数。那么，我们有：

$$
\textit{targetSeconds} = 60 \times m + s = 60 \times \textit{mm} + \textit{ss}.
$$

进一步，考虑到各个变量的取值范围，我们可以得到两组变量**所有可能的对应关系**：

- $m = \textit{mm}, s = \textit{ss}$；

- $m = \textit{mm} - 1, s = \textit{ss} + 60$。

其中「可能」指的是如果上述关系可以使得每个变量均满足取值范围要求，则该对应关系成立。

那么，最优的方案只能是上述两种（如果存在）中花费较小的方案。

**思路与算法**

根据 **提示 $1$**，我们只需要计算上述两种方案对应的最小花费即可。

我们用函数 $\textit{cost}(m, s)$ 模拟对应的方案，并计算 $m, s$ 确定的输入的最小花费。

首先我们用数组 $\textit{digits}$ 按顺序表示四位输入的每一位。在模拟之前，我们需要找到 $\textit{digits}$ 中第一个非零位 $\textit{start}$，并以该位作为起始点。

我们用 $\textit{res}$ 来表示总花费，并用 $\textit{prev}$ 来表示当前手指的位置，$\textit{prev}$ 的初值即为 $\textit{startAt}$。在顺序遍历 $\textit{digits}$ 中 $\textit{start}$ 以后的整数位 $d$ 时，我们首先判断当前位与手指位置是否相等：如果相等，则不需要移动；如果不相等，则需要令 $\textit{prev} = d$，同时将 $\textit{res}$ 加上单次移动的花费 $\textit{moveCost}$。随后，我们还需要将 $\textit{res}$ 加上单次按键的花费 $\textit{pushCost}$。

当遍历完成后，$\textit{res}$ 即为对应的最小花费，我们返回该值作为答案。

对于两种方案，我们首先判断取值范围，如果合法，则计算对应的最小花费。最终，我们返回所有可行的花费中较小的作为答案。

**细节**

为了方便判断 $m, s$ 的合法性，我们可以在函数 $\textit{cost}(m, s)$ 中对于不合法的 $m, s$ 返回一个极大的数即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minCostSetTime(int startAt, int moveCost, int pushCost, int targetSeconds) {
        // 给定输入的最小花费
        auto cost = [&](int m, int s) -> int {
            if (m < 0 || m > 99 || s < 0 || s > 99) {
                // 输入不合法
                return INT_MAX;
            }
            vector<int> digits = {m / 10, m % 10, s / 10, s % 10};
            // 寻找起始位
            int start = 0;
            while (start < 4 && digits[start] == 0) {
                ++start;
            }
            
            int res = 0;   // 最小花费
            int prev = startAt;
            for (int i = start; i < 4; ++i) {
                int d = digits[i];
                if (d != prev) {
                    // 此时需要先移动再输入
                    prev = d;
                    res += moveCost;
                }
                res += pushCost;
            }
            return res;
        };
        
        int mm = targetSeconds / 60, ss = targetSeconds % 60;
        return min(cost(mm, ss), cost(mm - 1, ss + 60));   // 两种可能方案的较小值
    }
};
```


```Python [sol1-Python3]
class Solution:
    def minCostSetTime(self, startAt: int, moveCost: int, pushCost: int, targetSeconds: int) -> int:
        # 给定输入的最小花费
        def cost(m: int, s: int) -> int:
            if not (0 <= m <= 99 and 0 <= s <= 99):
                # 输入不合法
                return float("INF")
            digits = [m // 10, m % 10, s // 10, s % 10]
            # 寻找起始位
            start = 0
            while start < 4 and digits[start] == 0:
                start += 1
            
            res = 0   # 最小花费
            prev = startAt
            for d in digits[start:]:
                if d != prev:
                    # 此时需要先移动再输入
                    prev = d
                    res += moveCost
                res += pushCost
            return res
        
        mm, ss = targetSeconds // 60, targetSeconds % 60
        return min(cost(mm, ss), cost(mm - 1, ss + 60))   # 两种可能方案的较小值
```


**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。
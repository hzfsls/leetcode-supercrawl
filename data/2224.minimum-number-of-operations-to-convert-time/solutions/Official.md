#### 方法一：贪心

**思路与算法**

为了方便计算，我们用整数 $\textit{time}_1$ 与 $\textit{time}_2$ 分别表示 $\textit{current}$ 和 $\textit{correct}$ 距离 $00:00$ 过去的分钟数，并用 $\textit{diff} = \textit{time}_2 - \textit{time}_1$ 表示我们需要增加的分钟数。

由于我们希望增加操作的次数最少，同时对于 $[1, 5, 15, 60]$ 这四个增加的数量，每一个数都**可以整除它前面（如有）的所有元素**，因此**尽可能使用右边的操作**替代对应次数左边的操作一定会使得操作次数更少。

我们用 $\textit{res}$ 来维护按照上述方案所需的操作数。同时，我们**从大到小**遍历单次操作可以增加的时间 $t$，则该操作可以进行的次数即为 $\lfloor \textit{diff} / t \rfloor$（其中 $\lfloor \dots \rfloor$ 代表向下取整），我们将 $\textit{res}$ 加上该数值，并修改操作结束后剩余的时间差，即 $\textit{diff} = \textit{diff} \bmod t$。最终，$\textit{res}$ 即为最少操作次数，我们返回该数值作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int convertTime(string current, string correct) {
        int time1 = stoi(current.substr(0, 2)) * 60 + stoi(current.substr(3, 2));
        int time2 = stoi(correct.substr(0, 2)) * 60 + stoi(correct.substr(3, 2));
        int diff = time2 - time1;   // 需要增加的分钟数
        int res = 0;
        // 尽可能优先使用增加数值更大的操作
        vector<int> ops = {60, 15, 5, 1};
        for (int t: ops) {
            res += diff / t;
            diff %= t;
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def convertTime(self, current: str, correct: str) -> int:
        time1 = int(current[:2]) * 60 + int(current[3:])
        time2 = int(correct[:2]) * 60 + int(correct[3:])
        diff = time2 - time1   # 需要增加的分钟数
        res = 0
        # 尽可能优先使用增加数值更大的操作
        for t in [60, 15, 5, 1]:
            res += diff // t
            diff %= t
        return res
```


**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。
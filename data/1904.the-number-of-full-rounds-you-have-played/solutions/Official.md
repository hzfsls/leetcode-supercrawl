#### 方法一：转化为分钟

**思路与算法**

为了方便计算，我们设**第一天**的 $00:00$ 为时间零点，同时将 $\textit{startTime}$ 和 $\textit{finishTime}$ 转化为距离时间零点的分钟数 $t_0$ 和 $t_1$。

此处要注意，如果转换后的 $t_1 < t_0$，这说明 $\textit{finishTime}$ 在**第二天**，此时我们需要将 $t_1$ 加上一天对应的分钟数，即 $1440$。

在转化为分钟后，我们需要计算 $[t_0, t_1]$ 闭区间内完整对局的个数。我们可以将 $t_1$ 转化为 $t_1$ 或之前时刻**最后一场**完整对局的**结束时间** $t_1'$，**或**将 $t_0$ 转化为 $t_0$ 或之后时刻**第一场**完整对局的**开始时间** $t_0'$ 即可。转化后闭区间内完整对局的个数不变。在本文中，我们仅将 $t_1$ 转化为 $t_1'$。

进行转化后，此时由于 $t_1'$ 对应一场完整对局的结束时间，因此$[t_0, t_1']$ 闭区间的长度（由于 $t_1' \le t_1$，可能存在 $t_0 > t_1'$ 的情况，此时区间长度视为 $0$）除以一场完整对局长度 $15$ 的商数即为区间 $[t_0, t_1]$ 内完整对局的个数。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int numberOfRounds(string startTime, string finishTime) {
        // 转化为分钟
        int t0 = 60 * stoi(startTime.substr(0, 2)) + stoi(startTime.substr(3, 5));
        int t1 = 60 * stoi(finishTime.substr(0, 2)) + stoi(finishTime.substr(3, 5));
        if (t1 < t0){
            // 此时 finishTime 为第二天
            t1 += 1440;
        }
        // 第一个小于等于 finishTime 的完整对局的结束时间
        t1 = t1 / 15 * 15;
        return max(0, (t1 - t0)) / 15;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def numberOfRounds(self, startTime: str, finishTime: str) -> int:
        # 转化为分钟
        t0 = 60 * int(startTime[:2]) + int(startTime[3:])
        t1 = 60 * int(finishTime[:2]) + int(finishTime[3:])
        if t1 < t0:
            # 此时 finishTime 为第二天
            t1 += 1440
        # 第一个小于等于 finishTime 的完整对局的结束时间
        t1 = t1 // 15 * 15
        return max(0, (t1 - t0)) // 15
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。
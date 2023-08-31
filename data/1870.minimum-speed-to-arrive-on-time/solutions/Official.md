## [1870.准时到达的列车最小时速 中文官方题解](https://leetcode.cn/problems/minimum-speed-to-arrive-on-time/solutions/100000/zhun-shi-dao-da-de-lie-che-zui-xiao-shi-tl9df)

#### 方法一：二分查找

**提示 $1$**

随着火车时速增加，到达终点的时间会减小。

**思路与算法**

根据 **提示 $1$**，我们可以用二分的方法寻找到能够按时到达的**最小**时速。

由于时速必须为正整数，因此二分的下界为 $1$；对于二分的上界，我们考虑 $\textit{hours}$ 为两位小数，因此对于最后一段路程，最小的时限为 $0.01$，那么最高的时速要求即为 $\textit{dist}[i]/0.01 \le 10^7$，同时为二分时速的上界。

在二分过程中，假设当前时速为 $\textit{mid}$，我们计算对应时速下到达终点的时间 $t$，并与 $\textit{hour}$ 比较以判断能否按时到达。

假设 $\textit{dist}$ 的长度为 $n$，我们考虑第 $i$ 段花费的时间。对于前 $n - 1$ 段，我们需要加上等待通向下一个地点的火车的时间，因此花费的时间为 $\lceil \textit{dist}[i] / \textit{mid} \rceil$。而对于最后一段，花费的时间为 $\textit{dist}[n-1] / \textit{mid}$。

显然，前 $n - 1$ 段至少需要 $n - 1$ 时间完成，同时最后一段的花费时间必定为正数。因此如果时限 $\textit{hour} \le n - 1$，那么显然无法完成，此时应返回 $-1$。而只要 $\textit{hour} > n - 1$，那么一定存在符合要求的时速。

**细节**

在代码实现中，为了避免浮点数造成的潜在误差，我们需要转化为**整数**之间的比较。

假设当前时速为 $\textit{mid}$，前 $n - 1$ 段花费的时间为 $t$，那么如果能够准时到达终点，必定有：

$$
t + \frac{\textit{dist}[n-1]}{\textit{mid}} \le \textit{hour}.
$$

首先，考虑不等式左边，$t$ 为整数，但 $\textit{dist}[n-1]/\textit{mid}$ 为分数，因此我们需要在不等式两边同时乘 $\textit{mid}$，即可将不等式左边转化为整数：

$$
\textit{mid}\cdot t + \textit{dist}[n-1] \le \textit{mid}\cdot\textit{hour}.
$$

其次，考虑不等式右边，由于时限 $\textit{hour}$ 为两位小数，因此我们引入 $\textit{hr} = 100 \textit{hour}$ 以将其转为整数，并在不等式两边同时乘 $100$：

$$
100(\textit{mid}\cdot t + \textit{dist}[n-1]) \le \textit{mid}\cdot\textit{hr}.
$$

此时，不等式两边均为整数。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minSpeedOnTime(vector<int>& dist, double hour) {
        int n = dist.size();
        // 将 hour 乘 100 以转为整数
        long long hr = llround(hour * 100);
        // 时间必须要大于路程段数减 1
        if (hr <= (n - 1) * 100){
            return -1;
        }
        // 二分
        int l = 1;
        int r = 1e7;
        while (l < r){
            int mid = l + (r - l) / 2;
            // 判断当前时速是否满足时限
            long long t = 0;
            // 前 n-1 段中第 i 段贡献的时间： floor(dist[i] / mid)
            for (int i = 0; i < n - 1; ++i){
                t += (dist[i] - 1) / mid + 1;
            }
            // 最后一段贡献的时间： dist[n-1] / mid
            t *= mid;
            t += dist[n-1];
            if (t * 100 <= hr * mid){   // 通分以转化为整数比较
                r = mid;
            }
            else{
                l = mid + 1;
            }
        }
        return l;   // 满足条件的最小时速
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minSpeedOnTime(self, dist: List[int], hour: float) -> int:
        n = len(dist)
        hr = round(hour * 100)
        # 时间必须要大于路程段数减 1
        if hr <= 100 * (n - 1):
            return -1
        # 判断当前时速是否满足时限
        def check(speed: int) -> bool:
            t = 0
            # 前 n-1 段中第 i 段贡献的时间： floor(dist[i] / mid)
            for i in range(n - 1):
                t += (dist[i] - 1) // speed + 1
            # 最后一段贡献的时间： dist[n-1] / mid
            t *= speed
            t += dist[-1]
            return t * 100 <= hr * speed   # 通分以转化为整数比较
        
        # 二分
        l, r = 1, 10 ** 7
        while l < r:
            mid = l + (r - l) // 2
            if check(mid):
                r = mid
            else:
                l = mid + 1
        return l   # 满足条件的最小时速
```

**复杂度分析**

- 时间复杂度：$O(n\log(C))$，其中 $n$ 为 $\textit{dist}$ 的长度，$C$ 为二分的上下界之差。每一次二分都需要 $O(n)$ 的时间计算花费的总时间。

- 空间复杂度：$O(1)$，我们只使用了常数个变量。
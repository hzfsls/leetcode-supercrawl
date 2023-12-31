## [2188.完成比赛的最少时间 中文官方题解](https://leetcode.cn/problems/minimum-time-to-finish-the-race/solutions/100000/wan-cheng-bi-sai-de-zui-shao-shi-jian-by-durw)

#### 方法一：统计每个字母出现的次数

**思路与算法**

我们用 $f[i]$ 表示完成 $i$ 圈最少需要的时间。在进行状态转移时，我们可以枚举 $j~(j < i)$，这里 $j$ 表示在第 $j$ 圈后我们更换了轮胎，即第 $j+1, j+2, \cdots, i$ 圈使用的是同一个轮胎，这样我们就可以得到状态转移方程：

$$
f[i] = \min_{j < i} \big\{ f[j] + \min_k \{ \textit{cost}(k, i-j) \} \big\} + \textit{changeTime}
$$

这里 $\textit{cost}(k, l)$ 表示一个第 $k$ 种轮胎使用 $l$ 圈需要的总时间，这里在第 $j$ 圈之后还有 $i-j$ 圈，因此我们需要在所有的 $\textit{cost}(k, i-j)$ 中找出一个最小值，加上完成前 $j$ 圈最少需要的时间 $f[j]$ 以及更换轮胎需要的时间 $\textit{changeTime}$，以此对 $f[i]$ 进行状态转移。

上述状态转移方程需要的时间至少为 $O(\textit{numLaps}^2 \times n)$，其中 $n$ 是数组 $\textit{tires}$ 的长度，会超出时间限制，因此我们需要进行优化。

**优化**

注意到：

$$
\min_k \{ \textit{cost}(k, i-j) \}
$$

本身的取值实际上与 $i$ 和 $j$ 本身没有任何关系，至于 $i-j$ 的差值有关系，而 $i-j \in [1, \textit{numsLaps}]$，因此我们实际上可以把一个轮胎使用 $1, 2, \cdots, \textit{numsLaps}$ 圈需要的时间「预处理」出来，这样就可以直接将动态规划部分的时间复杂度优化至 $O(\textit{numLaps}^2)$。

预处理的方法很简单，记 $\textit{best}[l]$ 表示一个轮胎使用 $l$ 圈需要的最少时间。我们只需要枚举每一个轮胎即可：当我们枚举到第 $k$ 个轮胎时，它的参数为 $\textit{tire}[k] = (f_k, r_k)$，那么我们可以依次计算出它使用 $1, 2, 3, \cdots$ 圈需要的时间，并更新对应的 $\textit{best}[l]$。这样一来，在枚举完所有的轮胎之后，我们就可以用 $\textit{best}[l]$ 代替状态转移方程中的 $\min_k \{ \textit{cost}(k, l) \}$ 项，使转移的时间复杂度降低至 $O(1)$，动态规划的总时间复杂度降低至 $O(\textit{numLaps}^2)$。

然而这样引入了一个新的问题：预处理部分需要的时间为 $O(n \cdot \textit{numLaps})$，虽然动态规划需要的时间是合适的，但预处理部分会直接超出时间限制。然而我们可以直观感受到，同一个轮胎不可能连续使用很多圈，这是因为即使最优质的轮胎 $(f, r) = (1, 2)$，在第 $19$ 圈时也需要 $1 \times 2^{19-1} = 262144$ 秒，比最差的轮胎 $(f, r) = (10^5, 10^5)$ 加上转换需要的时间 $\textit{changeTime} \leq 10^5$ 得到的总时间 $2 \cdot 10^5$ 秒要多。因此我们可以得到一个重要的结论：

> 任意一个轮胎不可能连续使用超过 $19$ 圈。

虽然这个上界已经足够我们通过题目，但我们还可以继续优化这个上界，即拿同一个轮胎进行比较。在第 $x$ 圈时，某个轮胎需要的时间为 $f \times r^{x-1}$，而替换同一个新的轮胎需要的时间为 $\textit{changeTime} + f$，根据：

$$
f \times r^{x-1} < \textit{changeTime} + f
$$

可以得到：

$$
x < \log_r \left( 1 + \frac{\textit{changeTime}}{f} \right) + 1
$$

在最坏情况下 $\textit{changeTime} = 10^5$，$f = 1$，$r = 2$，可以得到 $x < 17.609655$，也就是说：

> 任意一个轮胎不可能连续使用超过 $17$ 圈。

因此在进行预处理时，如果当前圈需要的时间已经大于等于 $\textit{changeTime} + f_k$，那么就可以不用考虑第 $k$ 个轮胎再继续使用的情况了。在动态规划时，我们也只需要考虑 $i - j \leq 17$ 的情况，这样无论是预处理部分还是动态规划部分，需要的时间都大大降低。

动态规划的边界条件为 $f[0] = 0$，最终答案为 $f[\textit{numLaps}] - \textit{changeTime}$，因为可以选择任意一种轮胎开始比赛。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minimumFinishTime(vector<vector<int>>& tires, int changeTime, int numLaps) {
        vector<int> best(18, INT_MAX);
        // 记录真正的最大连续使用的圈数，17 只是我们估计出的上界
        int maxdiff = 0;
        for (const auto& tire: tires) {
            long long lap = tire[0], cur = tire[0];
            for (int i = 1; lap < changeTime + tire[0]; ++i) {
                best[i] = min(best[i], static_cast<int>(cur));
                lap *= tire[1];
                cur += lap;
                maxdiff = max(maxdiff, i);
            }
        }
        
        vector<int> f(numLaps + 1, INT_MAX);
        f[0] = 0;
        for (int i = 1; i <= numLaps; ++i) {
            for (int j = i - 1; j >= 0 && i - j <= maxdiff; --j) {
                f[i] = min(f[i], f[j] + best[i - j] + changeTime);
            }
        }
        return f[numLaps] - changeTime;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minimumFinishTime(self, tires: List[List[int]], changeTime: int, numLaps: int) -> int:
        best = [float("inf")] * 18
        # 记录真正的最大连续使用的圈数，17 只是我们估计出的上界
        maxdiff = 0
        for (f, r) in tires:
            lap = cur = f
            i = 1
            while lap < changeTime + f:
                best[i] = min(best[i], cur)
                lap *= r
                cur += lap
                maxdiff = max(maxdiff, i)
                i += 1
        
        f = [0] + [float("inf")] * numLaps
        f[0] = 0
        for i in range(1, numLaps + 1):
            j = i - 1
            while j >= 0 and i - j <= maxdiff:
                f[i] = min(f[i], f[j] + best[i - j] + changeTime)
                j -= 1
        
        return f[numLaps] - changeTime
```

**复杂度分析**

- 时间复杂度：$O((n + \textit{numLaps}) \log T_{\max})$，其中 $n$ 是数组 $\textit{tires}$ 的长度，$T_{\max}$ 是题目中 $f_i, r_i, \textit{changeTime}$ 的范围，本题中 $\log T_{\max} \approx 17$。

- 空间复杂度：$O(n + \log T_{\max})$，即为预处理和动态规划需要使用的空间。
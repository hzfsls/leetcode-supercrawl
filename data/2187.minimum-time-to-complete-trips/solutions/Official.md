## [2187.完成旅途的最少时间 中文官方题解](https://leetcode.cn/problems/minimum-time-to-complete-trips/solutions/100000/wan-cheng-lu-tu-de-zui-shao-shi-jian-by-uxyrp)
#### 方法一：二分查找转化为判定问题

**提示 $1$**

当时间增加时，所有公交车完成旅途的总数一定不会减少。

**思路与算法**

根据 **提示 $1$**，「花费 $t$ 时间能否完成 $\textit{totalTrips}$ 趟旅途」这个**判定问题**如果对于某个 $t$ 成立，那么它对于 $[t, \infty)$ 区间内的所有整数均成立。这也就说明这个判定问题对于花费时间 $t$ 具有**二值性**。因此我们可以通过二分查找确定使得该判定问题成立的**最小**的 $t$。

由于我们至少需要 $1$ 时间来至少完成一趟旅途，因此二分查找的**下界**为 $1$。而对于二分查找的**上界**，出于方便计算的考虑，我们可以将「花费时间最长的公交车完成 $\textit{totalTrips}$ 趟旅途的时间」作为二分查找的上界。

对于花费 $t$ 时间对应的判定问题，我们引入辅助函数 $\textit{check}(t)$ 来判断。

在辅助函数 $\textit{check}(t)$ 中，我们用 $\textit{cnt}$ 统计所有公交车完成旅途数量的总和。随后，我们遍历 $\textit{time}$ 数组的所有元素，对于其中花费为 $\textit{period}$ 的公交车，它在 $t$ 时间内完成旅途的数目即为 $\lfloor t / \textit{period} \rfloor$，其中 $\lfloor x \rfloor$ 表示对 $x$ 向下取整。最终，我们判断 $\textit{cnt}$ 是否大于等于 $\textit{totalTrips}$，并将该答案作为辅助函数的返回值。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    long long minimumTime(vector<int>& time, int totalTrips) {
        // 判断 t 时间内是否可以完成 totalTrips 趟旅途
        auto check = [&](long long t) -> bool {
            long long cnt = 0;
            for (int period: time) {
                cnt += t / period;
            }
            return cnt >= totalTrips;
        };
        
        // 二分查找下界与上界
        long long l = 1;
        long long r = (long long) totalTrips * *max_element(time.begin(), time.end());
        // 二分查找寻找满足要求的最小的 t
        while (l < r) {
            long long mid = l + (r - l) / 2;
            if (check(mid)) {
                r = mid;
            } else {
              l = mid + 1;
            }
        }
        return l;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def minimumTime(self, time: List[int], totalTrips: int) -> int:
        # 判断 t 时间内是否可以完成 totalTrips 趟旅途
        def check(t: int) -> bool:
            cnt = 0
            for period in time:
                cnt += t // period
            return cnt >= totalTrips
        
        # 二分查找下界与上界
        l = 1
        r = totalTrips * max(time)
        # 二分查找寻找满足要求的最小的 t
        while l < r:
            mid = l + (r - l) // 2
            if check(mid):
                r = mid
            else:
                l = mid + 1
        return l
```


**复杂度分析**

- 时间复杂度：$O(n \log(mk))$，其中 $n$ 为 $\textit{time}$ 数组的长度，$m = \textit{totalTrips}$，$k$ 为 $\textit{time}$ 中元素的最大值。我们总共需要进行 $O(\log(mk))$ 次二分查找，每次判断完成旅途数目是否达到要求的时间复杂度均为 $O(n)$。

- 空间复杂度：$O(1)$。
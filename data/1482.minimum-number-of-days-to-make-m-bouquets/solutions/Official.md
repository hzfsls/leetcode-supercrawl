## [1482.制作 m 束花所需的最少天数 中文官方题解](https://leetcode.cn/problems/minimum-number-of-days-to-make-m-bouquets/solutions/100000/zhi-zuo-m-shu-hua-suo-xu-de-zui-shao-tia-mxci)

#### 方法一：二分查找

每束花需要 $k$ 朵花，需要制作 $m$ 束花，因此一共需要 $k \times m$ 朵花。如果花园中的花朵数量少于 $k \times m$，即数组 $\textit{bloomDay}$ 的长度小于 $k \times m$，则无法制作出指定数量的花束，返回 $-1$。如果数组 $\textit{bloomDay}$ 的长度大于或等于 $k \times m$，则一定可以制作出指定数量的花束。

为了计算制作出指定数量的花束的最少天数，首先需要实现一个辅助函数用于判断在给定的天数内能否制作出指定数量的花束，辅助函数的参数除了 $\textit{bloomDay}$、$m$ 和 $k$ 之外，还有一个参数 $\textit{days}$ 表示指定天数。例如，当 $\textit{bloomDay}=[1,10,3,10,2]$、$m=3$、$k=1$ 时，如果 $\textit{days}=3$ 则辅助函数返回 $\text{true}$，如果 $\textit{days}=2$ 则辅助函数返回 $\text{false}$。

对于辅助函数的实现，可以遍历数组 $\textit{bloomDay}$，计算其中的长度为 $k$ 且最大元素不超过 $\textit{days}$ 的不重合的连续子数组的数量，如果符合要求的不重合的连续子数组的数量大于或等于 $m$ 则返回 $\text{true}$，否则返回 $\text{false}$。

当 $\textit{days}$ 很小的时候，辅助函数总是返回 $\text{false}$，因为天数太少不能收齐 $m$ 个花束；当 $\textit{days}$ 很大的时候，辅助函数总是返回 $\text{true}$，如果给定序列可以制作出 $m$ 个花束。在 $\textit{days}$ 慢慢变大的过程中，辅助函数的返回值会从 $\text{false}$ 变成 $\text{true}$，所以我们可以认为这个辅助函数是关于 $\textit{days}$ 递增的，于是可以通过二分查找得到最少天数。在确保可以制作出指定数量的花束的情况下，所需的最少天数一定不会小于数组 $\textit{bloomDay}$ 中的最小值，一定不会大于数组 $\textit{bloomDay}$ 中的最大值，因此二分查找的初始值是 $\textit{low}$ 等于数组 $\textit{bloomDay}$ 中的最小值，$\textit{high}$ 等于数组 $\textit{bloomDay}$ 中的最大值。

当 $\textit{low}$ 和 $\textit{high}$ 的值相等时，二分查找结束，此时 $\textit{low}$ 的值即为最少天数。

```Java [sol1-Java]
class Solution {
    public int minDays(int[] bloomDay, int m, int k) {
        if (m > bloomDay.length / k) {
            return -1;
        }
        int low = Integer.MAX_VALUE, high = 0;
        int length = bloomDay.length;
        for (int i = 0; i < length; i++) {
            low = Math.min(low, bloomDay[i]);
            high = Math.max(high, bloomDay[i]);
        }
        while (low < high) {
            int days = (high - low) / 2 + low;
            if (canMake(bloomDay, days, m, k)) {
                high = days;
            } else {
                low = days + 1;
            }
        }
        return low;
    }

    public boolean canMake(int[] bloomDay, int days, int m, int k) {
        int bouquets = 0;
        int flowers = 0;
        int length = bloomDay.length;
        for (int i = 0; i < length && bouquets < m; i++) {
            if (bloomDay[i] <= days) {
                flowers++;
                if (flowers == k) {
                    bouquets++;
                    flowers = 0;
                }
            } else {
                flowers = 0;
            }
        }
        return bouquets >= m;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minDays(vector<int>& bloomDay, int m, int k) {
        if (m > bloomDay.size() / k) {
            return -1;
        }
        int low = INT_MAX, high = 0;
        int length = bloomDay.size();
        for (int i = 0; i < length; i++) {
            low = min(low, bloomDay[i]);
            high = max(high, bloomDay[i]);
        }
        while (low < high) {
            int days = (high - low) / 2 + low;
            if (canMake(bloomDay, days, m, k)) {
                high = days;
            } else {
                low = days + 1;
            }
        }
        return low;
    }

    bool canMake(vector<int>& bloomDay, int days, int m, int k) {
        int bouquets = 0;
        int flowers = 0;
        int length = bloomDay.size();
        for (int i = 0; i < length && bouquets < m; i++) {
            if (bloomDay[i] <= days) {
                flowers++;
                if (flowers == k) {
                    bouquets++;
                    flowers = 0;
                }
            } else {
                flowers = 0;
            }
        }
        return bouquets >= m;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public int MinDays(int[] bloomDay, int m, int k) {
        if (m > bloomDay.Length / k) {
            return -1;
        }
        int low = int.MaxValue, high = 0;
        int length = bloomDay.Length;
        for (int i = 0; i < length; i++) {
            low = Math.Min(low, bloomDay[i]);
            high = Math.Max(high, bloomDay[i]);
        }
        while (low < high) {
            int days = (high - low) / 2 + low;
            if (CanMake(bloomDay, days, m, k)) {
                high = days;
            } else {
                low = days + 1;
            }
        }
        return low;
    }

    public bool CanMake(int[] bloomDay, int days, int m, int k) {
        int bouquets = 0;
        int flowers = 0;
        int length = bloomDay.Length;
        for (int i = 0; i < length && bouquets < m; i++) {
            if (bloomDay[i] <= days) {
                flowers++;
                if (flowers == k) {
                    bouquets++;
                    flowers = 0;
                }
            } else {
                flowers = 0;
            }
        }
        return bouquets >= m;
    }
}
```

```JavaScript [sol1-JavaScript]
var minDays = function(bloomDay, m, k) {
    if (m > bloomDay.length / k) {
        return -1;
    }
    let low = Math.min.apply(null, bloomDay), high = Math.max.apply(null, bloomDay);
    while (low < high) {
        const days = Math.floor((high - low) / 2) + low;
        if (canMake(bloomDay, days, m, k)) {
            high = days;
        } else {
            low = days + 1;
        }
    }
    return low;
};

const canMake = (bloomDay, days, m, k) => {
    let bouquets = 0;
    let flowers = 0;
    const length = bloomDay.length;
    for (let i = 0; i < length && bouquets < m; i++) {
        if (bloomDay[i] <= days) {
            flowers++;
            if (flowers == k) {
                bouquets++;
                flowers = 0;
            }
        } else {
            flowers = 0;
        }
    }
    return bouquets >= m;
}
```

```go [sol1-Golang]
func minDays(bloomDay []int, m, k int) int {
    if m > len(bloomDay)/k {
        return -1
    }
    minDay, maxDay := math.MaxInt32, 0
    for _, day := range bloomDay {
        if day < minDay {
            minDay = day
        }
        if day > maxDay {
            maxDay = day
        }
    }
    return minDay + sort.Search(maxDay-minDay, func(days int) bool {
        days += minDay
        flowers, bouquets := 0, 0
        for _, d := range bloomDay {
            if d > days {
                flowers = 0
            } else {
                flowers++
                if flowers == k {
                    bouquets++
                    flowers = 0
                }
            }
        }
        return bouquets >= m
    })
}
```

```Python [sol1-Python3]
class Solution:
    def minDays(self, bloomDay: List[int], m: int, k: int) -> int:
        if m > len(bloomDay) / k:
            return -1
        
        def canMake(days: int) -> bool:
            bouquets = flowers = 0
            for bloom in bloomDay:
                if bloom <= days:
                    flowers += 1
                    if flowers == k:
                        bouquets += 1
                        if bouquets == m:
                            break
                        flowers = 0
                else:
                    flowers = 0
            return bouquets == m
        
        low, high = min(bloomDay), max(bloomDay)
        while low < high:
            days = (low + high) // 2
            if canMake(days):
                high = days
            else:
                low = days + 1
        return low
```

```C [sol1-C]
bool canMake(int* bloomDay, int bloomDaySize, int days, int m, int k) {
    int bouquets = 0;
    int flowers = 0;
    int length = bloomDaySize;
    for (int i = 0; i < length && bouquets < m; i++) {
        if (bloomDay[i] <= days) {
            flowers++;
            if (flowers == k) {
                bouquets++;
                flowers = 0;
            }
        } else {
            flowers = 0;
        }
    }
    return bouquets >= m;
}

int minDays(int* bloomDay, int bloomDaySize, int m, int k) {
    if (m > bloomDaySize / k) {
        return -1;
    }
    int low = INT_MAX, high = 0;
    for (int i = 0; i < bloomDaySize; i++) {
        low = fmin(low, bloomDay[i]);
        high = fmax(high, bloomDay[i]);
    }
    while (low < high) {
        int days = (high - low) / 2 + low;
        if (canMake(bloomDay, bloomDaySize, days, m, k)) {
            high = days;
        } else {
            low = days + 1;
        }
    }
    return low;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log (\textit{high} - \textit{low}))$，其中 $n$ 是数组 $\textit{bloomDay}$ 的长度，$\textit{high}$ 和 $\textit{low}$ 分别是数组 $\textit{bloomDay}$ 中的最大值和最小值。
  需要遍历数组 $\textit{bloomDay}$ 得到其中的最大值 $\textit{high}$ 和最小值 $\textit{low}$，遍历的时间复杂度是 $O(n)$。
  得到最大值 $\textit{high}$ 和最小值 $\textit{low}$ 之后，二分查找的迭代次数是 $O(\log (\textit{high} - \textit{low}))$，每次判断是否能制作规定数量的花束的时间复杂度是 $O(n)$，因此二分查找的总时间复杂度是 $O(n \log (\textit{high} - \textit{low}))$。
  整个算法的时间复杂度是 $O(n)+O(n \log (\textit{high} - \textit{low}))=O(n \log (\textit{high} - \textit{low}))$。

- 空间复杂度：$O(1)$。
## [1011.在 D 天内送达包裹的能力 中文官方题解](https://leetcode.cn/problems/capacity-to-ship-packages-within-d-days/solutions/100000/zai-d-tian-nei-song-da-bao-guo-de-neng-l-ntml)
#### 方法一：二分查找转化为判定问题

**思路与算法**

假设当船的运载能力为 $x$ 时，我们可以在 $\textit{days}$ 天内运送完所有包裹，那么只要运载能力大于 $x$，我们同样可以在 $\textit{days}$ 天内运送完所有包裹：我们只需要使用运载能力为 $x$ 时的运送方法即可。

这样一来，我们就得到了一个非常重要的结论：

> 存在一个运载能力的「下限」$x_\textit{ans}$，使得当 $x \geq x_\textit{ans}$ 时，我们可以在 $\textit{days}$ 天内运送完所有包裹；当 $x < x_\textit{ans}$ 时，我们无法在 $\textit{days}$ 天内运送完所有包裹。

同时，$x_\textit{ans}$ 即为我们需要求出的答案。因此，我们就可以使用二分查找的方法找出 $x_\textit{ans}$ 的值。

在二分查找的每一步中，我们实际上需要解决一个**判定问题**：给定船的运载能力 $x$，我们是否可以在 $\textit{days}$ 天内运送完所有包裹呢？这个判定问题可以通过贪心的方法来解决：

> 由于我们必须按照数组 $\textit{weights}$ 中包裹的顺序进行运送，因此我们从数组 $\textit{weights}$ 的首元素开始遍历，将连续的包裹都安排在同一天进行运送。当这批包裹的重量大于运载能力 $x$ 时，我们就需要将最后一个包裹拿出来，安排在新的一天，并继续往下遍历。当我们遍历完整个数组后，就得到了最少需要运送的天数。

我们将「最少需要运送的天数」与 $\textit{days}$ 进行比较，就可以解决这个判定问题。当其小于等于 $\textit{days}$ 时，我们就忽略二分的右半部分区间；当其大于 $\textit{days}$ 时，我们就忽略二分的左半部分区间。

**细节**

二分查找的初始左右边界应当如何计算呢？

对于左边界而言，由于我们不能「拆分」一个包裹，因此船的运载能力不能小于所有包裹中最重的那个的重量，即左边界为数组 $\textit{weights}$ 中元素的最大值。

对于右边界而言，船的运载能力也不会大于所有包裹的重量之和，即右边界为数组 $\textit{weights}$ 中元素的和。

我们从上述左右边界开始进行二分查找，就可以保证找到最终的答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int shipWithinDays(vector<int>& weights, int days) {
        // 确定二分查找左右边界
        int left = *max_element(weights.begin(), weights.end()), right = accumulate(weights.begin(), weights.end(), 0);
        while (left < right) {
            int mid = (left + right) / 2;
            // need 为需要运送的天数
            // cur 为当前这一天已经运送的包裹重量之和
            int need = 1, cur = 0;
            for (int weight: weights) {
                if (cur + weight > mid) {
                    ++need;
                    cur = 0;
                }
                cur += weight;
            }
            if (need <= days) {
                right = mid;
            }
            else {
                left = mid + 1;
            }
        }
        return left;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int shipWithinDays(int[] weights, int days) {
        // 确定二分查找左右边界
        int left = Arrays.stream(weights).max().getAsInt(), right = Arrays.stream(weights).sum();
        while (left < right) {
            int mid = (left + right) / 2;
            // need 为需要运送的天数
            // cur 为当前这一天已经运送的包裹重量之和
            int need = 1, cur = 0;
            for (int weight : weights) {
                if (cur + weight > mid) {
                    ++need;
                    cur = 0;
                }
                cur += weight;
            }
            if (need <= days) {
                right = mid;
            } else {
                left = mid + 1;
            }
        }
        return left;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def shipWithinDays(self, weights: List[int], days: int) -> int:
        # 确定二分查找左右边界
        left, right = max(weights), sum(weights)
        while left < right:
            mid = (left + right) // 2
            # need 为需要运送的天数
            # cur 为当前这一天已经运送的包裹重量之和
            need, cur = 1, 0
            for weight in weights:
                if cur + weight > mid:
                    need += 1
                    cur = 0
                cur += weight
            
            if need <= days:
                right = mid
            else:
                left = mid + 1
        
        return left
```

```JavaScript [sol1-JavaScript]
var shipWithinDays = function(weights, days) {
    // 确定二分查找左右边界
    let left = Math.max(...weights), right = weights.reduce((a, b) => a + b);
    while (left < right) {
        const mid = Math.floor((left + right) / 2);
        //  need 为需要运送的天数
        // cur 为当前这一天已经运送的包裹重量之和
        let need = 1, cur = 0;
        for (const weight of weights) {
            if (cur + weight > mid) {
                need++;
                cur = 0;
            } 
            cur += weight;
        }

        if (need <= days) {
            right = mid;
        } else {
            left = mid + 1;
        }
    }
    return left;
};
```

```go [sol1-Golang]
func shipWithinDays(weights []int, days int) int {
    // 确定二分查找左右边界
    left, right := 0, 0
    for _, w := range weights {
        if w > left {
            left = w
        }
        right += w
    }
    return left + sort.Search(right-left, func(x int) bool {
        x += left
        day := 1 // 需要运送的天数
        sum := 0 // 当前这一天已经运送的包裹重量之和
        for _, w := range weights {
            if sum+w > x {
                day++
                sum = 0
            }
            sum += w
        }
        return day <= days
    })
}
```

```C [sol1-C]
int shipWithinDays(int* weights, int weightsSize, int days) {
    // 确定二分查找左右边界
    int left = 0, right = 0;
    for (int i = 0; i < weightsSize; i++) {
        left = fmax(left, weights[i]);
        right += weights[i];
    }
    while (left < right) {
        int mid = (left + right) / 2;
        // need 为需要运送的天数
        // cur 为当前这一天已经运送的包裹重量之和
        int need = 1, cur = 0;
        for (int i = 0; i < weightsSize; i++) {
            if (cur + weights[i] > mid) {
                ++need;
                cur = 0;
            }
            cur += weights[i];
        }
        if (need <= days) {
            right = mid;
        } else {
            left = mid + 1;
        }
    }
    return left;
}
```

**复杂度分析**

- 时间复杂度：$O\big(n\log(\Sigma w)\big)$，其中 $n$ 是数组 $\textit{weights}$ 的长度，$\Sigma w$ 是数组 $\textit{weights}$ 中元素的和。二分查找需要执行的次数为 $O(\log(\Sigma w))$，每一步中需要对数组 $\textit{weights}$ 进行依次遍历，时间为 $O(n)$，相乘即可得到总时间复杂度。

- 空间复杂度：$O(1)$。
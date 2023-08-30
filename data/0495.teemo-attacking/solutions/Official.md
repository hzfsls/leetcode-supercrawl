#### 方法一：单次扫描

我们只需要对数组进行一次扫描就可以计算出总的中毒持续时间。我们记录艾希恢复为未中毒的起始时间 $\textit{expired}$，设艾希遭遇第 $i$ 次的攻击的时间为 $\textit{timeSeries}[i]$。当艾希遭遇第 $i$ 攻击时：
+ 如果当前他正处于未中毒状态，则此时他的中毒持续时间应增加 $\textit{duration}$​，同时更新本次中毒结束时间 $\textit{expired}$​ 等于 $\textit{timeSeries}[i] + \textit{duration}$​；
+ 如果当前他正处于中毒状态，由于中毒状态不可叠加，我们知道上次中毒后结束时间为 $\textit{expired}$​​，本次中毒后结束时间为 $\textit{timeSeries}[i] + \textit{duration}$​​，因此本次中毒增加的持续中毒时间为 $\textit{timeSeries}[i] + \textit{duration} -\textit{expired}$​​；
+ 我们将每次中毒后增加的持续中毒时间相加即为总的持续中毒时间。

```Java [sol1-Java]
class Solution {
    public int findPoisonedDuration(int[] timeSeries, int duration) {
        int ans = 0;
        int expired = 0;
        for (int i = 0; i < timeSeries.length; ++i) {
            if (timeSeries[i] >= expired) {
                ans += duration;
            } else {
                ans += timeSeries[i] + duration - expired;
            }
            expired = timeSeries[i] + duration;
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int findPoisonedDuration(vector<int>& timeSeries, int duration) {
        int ans = 0;
        int expired = 0;
        for (int i = 0; i < timeSeries.size(); ++i) {
            if (timeSeries[i] >= expired) {
                ans += duration;
            } else {
                ans += timeSeries[i] + duration - expired;
            }
            expired = timeSeries[i] + duration;
        }
        return ans;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public int FindPoisonedDuration(int[] timeSeries, int duration) {
        int ans = 0;
        int expired = 0;
        for (int i = 0; i < timeSeries.Length; ++i) {
            if (timeSeries[i] >= expired) {
                ans += duration;
            } else {
                ans += timeSeries[i] + duration - expired;
            }
            expired = timeSeries[i] + duration;
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def findPoisonedDuration(self, timeSeries: List[int], duration: int) -> int:
        ans, expired = 0, 0
        for i in range(len(timeSeries)):
            if timeSeries[i] >= expired:
                ans += duration
            else:
                ans += timeSeries[i] + duration - expired
            expired = timeSeries[i] + duration
        return ans
```

```go [sol1-Golang]
func findPoisonedDuration(timeSeries []int, duration int) (ans int) {
    expired := 0
    for _, t := range timeSeries {
        if t >= expired {
            ans += duration
        } else {
            ans += t + duration - expired
        }
        expired = t + duration
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var findPoisonedDuration = function(timeSeries, duration) {
    let ans = 0;
    let expired = 0;
    for (let i = 0; i < timeSeries.length; ++i) {
        if (timeSeries[i] >= expired) {
            ans += duration;
        } else {
            ans += timeSeries[i] + duration - expired;
        }
        expired = timeSeries[i] + duration;
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{timeSeries}$ 的长度。我们只需要遍历一遍数组即可，因此总时间复杂度为 $O(n)$。

- 空间复杂度：$O(1)$。只需要记录未中毒的起始时间即可，因此时间复杂度为 $O(1)$。
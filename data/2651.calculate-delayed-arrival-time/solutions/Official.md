## [2651.计算列车到站时间 中文官方题解](https://leetcode.cn/problems/calculate-delayed-arrival-time/solutions/100000/ji-suan-lie-che-dao-zhan-shi-jian-by-lee-14h7)
#### 方法一：数学

实际到站时间 $\textit{realTime}$ 的计算公式为：

$$
\textit{realTime} = \textit{arrivalTime} + \textit{delayedTime}
$$

因为时间采用 $24$ 小时制，所以需要对 $24$ 取余，即：

$$
\textit{realTime} = (\textit{arrivalTime} + \textit{delayedTime}) \bmod 24
$$

```C [sol1-C]
int findDelayedArrivalTime(int arrivalTime, int delayedTime){
    return (arrivalTime + delayedTime) % 24;
}
```

```C++ [sol1-C++]
class Solution {
public:
    int findDelayedArrivalTime(int arrivalTime, int delayedTime) {
        return (arrivalTime + delayedTime) % 24;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int findDelayedArrivalTime(int arrivalTime, int delayedTime) {
        return (arrivalTime + delayedTime) % 24;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindDelayedArrivalTime(int arrivalTime, int delayedTime) {
        return (arrivalTime + delayedTime) % 24;
    }
}
```

```Python [sol1-Python]
class Solution:
    def findDelayedArrivalTime(self, arrivalTime: int, delayedTime: int) -> int:
        return (arrivalTime + delayedTime) % 24
```

```Go [sol1-Go]
func findDelayedArrivalTime(arrivalTime int, delayedTime int) int {
    return (arrivalTime + delayedTime) % 24
}
```

```JavaScript [sol1-JavaScript]
var findDelayedArrivalTime = function(arrivalTime, delayedTime) {
    return (arrivalTime + delayedTime) % 24;
};
```

**复杂度分析**

+ 时间复杂度：$O(1)$。

+ 空间复杂度：$O(1)$。
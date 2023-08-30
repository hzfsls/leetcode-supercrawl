#### 方法一：一次遍历

记数组 $\textit{distance}$ 的长度为 $n$。假设 $\textit{start} \le \textit{destination}$，那么我们可以：

- 从 $\textit{start}$ 到 $\textit{destination}$，距离为 $\sum\limits_{i=\textit{start}}^{\textit{destination}-1}\textit{distance}[i]$；
- 从 $\textit{start}$ 到 $0$，再从 $0$ 到 $\textit{destination}$，距离为 $\sum\limits_{i=0}^{\textit{start}-1}\textit{distance}[i]+\sum\limits_{i=\textit{destination}}^{n-1}\textit{distance}[i]$。

答案为这两个距离的最小值。

```Python [sol1-Python3]
class Solution:
    def distanceBetweenBusStops(self, distance: List[int], start: int, destination: int) -> int:
        if start > destination:
            start, destination = destination, start
        return min(sum(distance[start:destination]), sum(distance[:start]) + sum(distance[destination:]))
```

```C++ [sol1-C++]
class Solution {
public:
    int distanceBetweenBusStops(vector<int>& distance, int start, int destination) {
        if (start > destination) {
            swap(start, destination);
        }
        return min(accumulate(distance.begin() + start, distance.begin() + destination, 0),
                   accumulate(distance.begin(), distance.begin() + start, 0) +
                   accumulate(distance.begin() + destination, distance.end(), 0));
    }
};
```

```Java [sol1-Java]
class Solution {
    public int distanceBetweenBusStops(int[] distance, int start, int destination) {
        if (start > destination) {
            int temp = start;
            start = destination;
            destination = temp;
        }
        int sum1 = 0, sum2 = 0;
        for (int i = 0; i < distance.length; i++) {
            if (i >= start && i < destination) {
                sum1 += distance[i];
            } else {
                sum2 += distance[i];
            }
        }
        return Math.min(sum1, sum2);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int DistanceBetweenBusStops(int[] distance, int start, int destination) {
        if (start > destination) {
            int temp = start;
            start = destination;
            destination = temp;
        }
        int sum1 = 0, sum2 = 0;
        for (int i = 0; i < distance.Length; i++) {
            if (i >= start && i < destination) {
                sum1 += distance[i];
            } else {
                sum2 += distance[i];
            }
        }
        return Math.Min(sum1, sum2);
    }
}
```

```go [sol1-Golang]
func distanceBetweenBusStops(distance []int, start, destination int) int {
    if start > destination {
        start, destination = destination, start
    }
    sum1, sum2 := 0, 0
    for i, d := range distance {
        if start <= i && i < destination {
            sum1 += d
        } else {
            sum2 += d
        }
    }
    return min(sum1, sum2)
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int distanceBetweenBusStops(int* distance, int distanceSize, int start, int destination){
    if (start > destination) {
        int temp = start;
        start = destination;
        destination = temp;
    }
    int sum1 = 0, sum2 = 0;
    for (int i = 0; i < distanceSize; i++) {
        if (i >= start && i < destination) {
            sum1 += distance[i];
        } else {
            sum2 += distance[i];
        }
    }
    return MIN(sum1, sum2);
}
```

```JavaScript [sol1-JavaScript]
var distanceBetweenBusStops = function(distance, start, destination) {
    if (start > destination) {
        const temp = start;
        start = destination;
        destination = temp;
    }
    let sum1 = 0, sum2 = 0;
    for (let i = 0; i < distance.length; i++) {
        if (i >= start && i < destination) {
            sum1 += distance[i];
        } else {
            sum2 += distance[i];
        }
    }
    return Math.min(sum1, sum2);
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{distance}$ 的长度。

- 空间复杂度：$O(1)$，只需要额外的常数级别的空间。
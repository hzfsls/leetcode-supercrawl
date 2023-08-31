## [875.爱吃香蕉的珂珂 中文官方题解](https://leetcode.cn/problems/koko-eating-bananas/solutions/100000/ai-chi-xiang-jiao-de-ke-ke-by-leetcode-s-z4rt)
#### 方法一：二分查找

如果珂珂在 $h$ 小时内吃掉所有香蕉的最小速度是每小时 $k$ 个香蕉，则当吃香蕉的速度大于每小时 $k$ 个香蕉时一定可以在 $h$ 小时内吃掉所有香蕉，当吃香蕉的速度小于每小时 $k$ 个香蕉时一定不能在 $h$ 小时内吃掉所有香蕉。

由于吃香蕉的速度和是否可以在规定时间内吃掉所有香蕉之间存在单调性，因此可以使用二分查找的方法得到最小速度 $k$。

由于每小时都要吃香蕉，即每小时至少吃 $1$ 个香蕉，因此二分查找的下界是 $1$；由于每小时最多吃一堆香蕉，即每小时吃的香蕉数目不会超过最多的一堆中的香蕉数目，因此二分查找的上界是最多的一堆中的香蕉数目。

假设吃香蕉的速度是 $\textit{speed}$，则当一堆香蕉的个数是 $\textit{pile}$ 时，吃掉这堆香蕉需要 $\Big\lceil \dfrac{\textit{pile}}{\textit{speed}} \Big\rceil$ 小时，由此可以计算出吃掉所有香蕉需要的时间。如果在速度 $\textit{speed}$ 下可以在 $h$ 小时内吃掉所有香蕉，则最小速度一定小于或等于 $\textit{speed}$，因此将上界调整为 $\textit{speed}$；否则，最小速度一定大于 $\textit{speed}$，因此将下界调整为 $\textit{speed} + 1$。

二分查找结束之后，即可得到在 $h$ 小时内吃掉所有香蕉的最小速度 $k$。

实现方面，在计算吃掉每一堆香蕉的时间时，由于 $\textit{pile}$ 和 $\textit{speed}$ 都大于 $0$，因此 $\Big\lceil \dfrac{\textit{pile}}{\textit{speed}} \Big\rceil$ 等价于 $\Big\lfloor \dfrac{\textit{pile} + \textit{speed} - 1}{\textit{speed}} \Big\rfloor$。

```Python [sol1-Python3]
class Solution:
    def minEatingSpeed(self, piles: List[int], h: int) -> int:
        return bisect_left(range(max(piles)), -h, 1, key=lambda k: -sum((pile + k - 1) // k for pile in piles))
```

```Java [sol1-Java]
class Solution {
    public int minEatingSpeed(int[] piles, int h) {
        int low = 1;
        int high = 0;
        for (int pile : piles) {
            high = Math.max(high, pile);
        }
        int k = high;
        while (low < high) {
            int speed = (high - low) / 2 + low;
            long time = getTime(piles, speed);
            if (time <= h) {
                k = speed;
                high = speed;
            } else {
                low = speed + 1;
            }
        }
        return k;
    }

    public long getTime(int[] piles, int speed) {
        long time = 0;
        for (int pile : piles) {
            int curTime = (pile + speed - 1) / speed;
            time += curTime;
        }
        return time;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinEatingSpeed(int[] piles, int h) {
        int low = 1;
        int high = 0;
        foreach (int pile in piles) {
            high = Math.Max(high, pile);
        }
        int k = high;
        while (low < high) {
            int speed = (high - low) / 2 + low;
            long time = GetTime(piles, speed);
            if (time <= h) {
                k = speed;
                high = speed;
            } else {
                low = speed + 1;
            }
        }
        return k;
    }

    public long GetTime(int[] piles, int speed) {
        long time = 0;
        foreach (int pile in piles) {
            int curTime = (pile + speed - 1) / speed;
            time += curTime;
        }
        return time;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minEatingSpeed(vector<int>& piles, int h) {
        int low = 1;
        int high = 0;
        for (int pile : piles) {
            high = max(high, pile);
        }
        int k = high;
        while (low < high) {
            int speed = (high - low) / 2 + low;
            long time = getTime(piles, speed);
            if (time <= h) {
                k = speed;
                high = speed;
            } else {
                low = speed + 1;
            }
        }
        return k;
    }

    long getTime(const vector<int>& piles, int speed) {
        long time = 0;
        for (int pile : piles) {
            int curTime = (pile + speed - 1) / speed;
            time += curTime;
        }
        return time;
    }
};
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

long getTime(const int* piles, int pilesSize, int speed) {
    long time = 0;
    for (int i = 0; i < pilesSize; i++) {
        int curTime = (piles[i] + speed - 1) / speed;
        time += curTime;
    }
    return time;
}
    
int minEatingSpeed(int* piles, int pilesSize, int h) {
    int low = 1;
    int high = 0;
    for (int i = 0; i < pilesSize; i++) {
        high = MAX(high, piles[i]);
    }
    int k = high;
    while (low < high) {
        int speed = (high - low) / 2 + low;
        long time = getTime(piles, pilesSize, speed);
        if (time <= h) {
            k = speed;
            high = speed;
        } else {
            low = speed + 1;
        }
    }
    return k;
}
```

```go [sol1-Golang]
func minEatingSpeed(piles []int, h int) int {
    max := 0
    for _, pile := range piles {
        if pile > max {
            max = pile
        }
    }
    return 1 + sort.Search(max-1, func(speed int) bool {
        speed++
        time := 0
        for _, pile := range piles {
            time += (pile + speed - 1) / speed
        }
        return time <= h
    })
}
```

```JavaScript [sol1-JavaScript]
var minEatingSpeed = function(piles, h) {
    let low = 1;
    let high = 0;
    for (const pile of piles) {
        high = Math.max(high, pile);
    }
    let k = high;
    while (low < high) {
        const speed = Math.floor((high - low) / 2) + low;
        const time = getTime(piles, speed);
        if (time <= h) {
            k = speed;
            high = speed;
        } else {
            low = speed + 1;
        }
    }
    return k;
}

const getTime = (piles, speed) => {
    let time = 0;
    for (const pile of piles) {
        const curTime = Math.floor((pile + speed - 1) / speed);
        time += curTime;
    }
    return time;
};
```

**复杂度分析**

- 时间复杂度：$O(n \log m)$，其中 $n$ 是数组 $\textit{piles}$ 的长度，$m$ 是数组 $\textit{piles}$ 中的最大值。需要 $O(n)$ 的时间遍历数组找到最大值 $m$，二分查找需要执行 $O(\log m)$ 轮，每一轮二分查找需要 $O(n)$ 的时间，因此总时间复杂度是 $O(n \log m)$。

- 空间复杂度：$O(1)$。
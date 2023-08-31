## [1921.消灭怪物的最大数量 中文官方题解](https://leetcode.cn/problems/eliminate-maximum-number-of-monsters/solutions/100000/xiao-mie-guai-wu-de-zui-da-shu-liang-by-0ou2p)

#### 方法一：贪心 + 排序

**思路**

为了消灭尽可能多的怪物，我方需要坚持尽可能长的时间，因为我方每分钟都能消灭一个怪物。为了坚持更久，我方需要先消灭先来的怪物。因此，贪心的思路是将怪物的到达时间排序，先消灭到达时间早的怪物。我方的攻击时间序列是 $[1,2,3,\dots]$，将我方的攻击时间序列和排序后的怪物到达时间依次进行比较，当第一次出现到达时间小于等于攻击时间，即表示怪物到达城市，我方会输掉游戏。在比较时，因为我方的攻击时间为整数，因此可以将怪物到达时间向上取整，可以达到避免浮点数误差的效果。如果遍历完序列都没有出现这种情况，则表示我方可以消灭全部怪物。

**代码**

```Python [sol1-Python3]
class Solution:
    def eliminateMaximum(self, dist: List[int], speed: List[int]) -> int:
        arrivalTimes = sorted([(monsterDist - 1) // monsterSpeed + 1 for monsterDist, monsterSpeed in zip(dist, speed)])
        for attackTime, arrivalTime in enumerate(arrivalTimes):
            if arrivalTime <= attackTime:
                return attackTime
        return len(arrivalTimes)
```

```Java [sol1-Java]
class Solution {
    public int eliminateMaximum(int[] dist, int[] speed) {
        int n = dist.length;
        int[] arrivalTimes = new int[n];
        for (int i = 0; i < n; i++) {
            arrivalTimes[i] = (dist[i] - 1) / speed[i] + 1;
        }
        Arrays.sort(arrivalTimes);
        for (int i = 0; i < n; i++) {
            if (arrivalTimes[i] <= i) {
                return i;
            }
        }
        return n;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int EliminateMaximum(int[] dist, int[] speed) {
        int n = dist.Length;
        int[] arrivalTimes = new int[n];
        for (int i = 0; i < n; i++) {
            arrivalTimes[i] = (dist[i] - 1) / speed[i] + 1;
        }
        Array.Sort(arrivalTimes);
        for (int i = 0; i < n; i++) {
            if (arrivalTimes[i] <= i) {
                return i;
            }
        }
        return n;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int eliminateMaximum(vector<int>& dist, vector<int>& speed) {
        int n = dist.size();
        vector<int> arrivalTimes(n);
        for (int i = 0; i < n; i++) {
            arrivalTimes[i] = (dist[i] - 1) / speed[i] + 1;
        }
        sort(arrivalTimes.begin(), arrivalTimes.end());
        for (int i = 0; i < n; i++) {
            if (arrivalTimes[i] <= i) {
                return i;
            }
        }
        return n;
    }
};
```

```C [sol1-C]
static int cmp(const void *a, const void *b) {
    return *(int *)a - *(int *)b;
}

int eliminateMaximum(int* dist, int distSize, int* speed, int speedSize) {
    int n = distSize;
    int arrivalTimes[n];
    for (int i = 0; i < n; i++) {
        arrivalTimes[i] = (dist[i] - 1) / speed[i] + 1;
    }
    qsort(arrivalTimes, n, sizeof(int), cmp);
    for (int i = 0; i < n; i++) {
        if (arrivalTimes[i] <= i) {
            return i;
        }
    }
    return n;
}
```

```Go [sol1-Go]
func eliminateMaximum(dist []int, speed []int) int {
    n := len(dist);
    arrivalTimes := make([]int, n)
    for i := 0; i < n; i++ {
        arrivalTimes[i] = (dist[i] - 1) / speed[i] + 1
    }
    sort.Ints(arrivalTimes)
    for i := 0; i < n; i++ {
        if arrivalTimes[i] <= i {
            return i
        }
    }
    return n
}
```

```JavaScript [sol1-JavaScript]
var eliminateMaximum = function(dist, speed) {
    const n = dist.length;
    const arrivalTimes = new Array(n).fill(0);
    for (let i = 0; i < n; i++) {
        arrivalTimes[i] = Math.ceil(dist[i] / speed[i]);
    }
    arrivalTimes.sort((a, b) => a - b);
    for (let i = 0; i < n; i++) {
        if (arrivalTimes[i] <= i) {
            return i;
        }
    }
    return n;
};
```

**复杂度分析**

- 时间复杂度：$O(n \times \log n)$，其中 $n$ 是数组 $\textit{dist}$ 和 $\textit{speed}$ 的长度。为排序的时间复杂度。

- 空间复杂度：$O(n)$。需要一个数组保存怪物的到达时间。
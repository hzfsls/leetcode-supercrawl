## [871.最低加油次数 中文官方题解](https://leetcode.cn/problems/minimum-number-of-refueling-stops/solutions/100000/zui-di-jia-you-ci-shu-by-leetcode-soluti-nmga)
#### 方法一：动态规划

由于数组 $\textit{stations}$ 按照加油站的位置非递减排序，因此从左到右遍历数组 $\textit{stations}$ 的过程中，当遍历到一个加油站时，位置小于该加油站的所有加油站都已经被遍历过。

用 $n$ 表示数组 $\textit{stations}$ 的长度，即加油站的个数。最多可以加油 $n$ 次，为了得到可以到达目的地的最少加油次数，需要计算每个加油次数对应的最大行驶英里数，然后得到最大行驶英里数大于等于 $\textit{target}$ 的最少加油次数。

用 $\textit{dp}[i]$ 表示加油 $i$ 次的最大行驶英里数。由于初始时汽油量是 $\textit{startFuel}$ 升，可以行驶 $\textit{startFuel}$ 英里，因此 $\textit{dp}[0] = \textit{startFuel}$。

当遍历到加油站 $\textit{stations}[i]$ 时，假设在到达该加油站之前已经加油 $j$ 次，其中 $0 \le j \le i$，则只有当 $\textit{dp}[j] \ge \textit{stations}[i][0]$ 时才能在加油 $j$ 次的情况下到达加油站 $\textit{stations}[i]$ 的位置，在加油站 $\textit{stations}[i]$ 加油之后，共加油 $j + 1$ 次，可以行驶的英里数是 $\textit{dp}[j] + \textit{stations}[i][1]$。遍历满足 $0 \le j \le i$ 且 $\textit{dp}[j] \ge \textit{stations}[i][0]$ 的每个下标 $j$，计算 $\textit{dp}[j + 1]$ 的最大值。

当遍历到加油站 $\textit{stations}[i]$ 时，对于每个符合要求的下标 $j$，计算 $\textit{dp}[j + 1]$ 时都是将加油站 $\textit{stations}[i]$ 作为最后一次加油的加油站。为了确保每个 $\textit{dp}[j + 1]$ 的计算中，加油站 $\textit{stations}[i]$ 只会被计算一次，应该按照从大到小的顺序遍历下标 $j$。

以示例 3 为例。对于加油站 $\textit{stations}[2]$ 计算之后，$\textit{dp}[2] = 100$。对于加油站 $\textit{stations}[3]$ 计算的过程中会将 $\textit{dp}[2]$ 的值更新为 $110$，如果在计算 $\textit{dp}[3]$ 之前计算 $\textit{dp}[2]$，则 $\textit{dp}[3]$ 的值将被错误地计算为 $\textit{dp}[2] + \textit{stations}[3][1] = 150$。只有当从大到小遍历下标 $j$ 时，才能得到 $\textit{dp}[3] = 140$ 的正确结果。

当所有的加油站遍历结束之后，遍历 $\textit{dp}$，寻找使得 $\textit{dp}[i] \ge \textit{target}$ 的最小下标 $i$ 并返回。如果不存在这样的下标，则无法到达目的地，返回 $-1$。

```Python [sol1-Python3]
class Solution:
    def minRefuelStops(self, target: int, startFuel: int, stations: List[List[int]]) -> int:
        dp = [startFuel] + [0] * len(stations)
        for i, (pos, fuel) in enumerate(stations):
            for j in range(i, -1, -1):
                if dp[j] >= pos:
                    dp[j + 1] = max(dp[j + 1], dp[j] + fuel)
        return next((i for i, v in enumerate(dp) if v >= target), -1)
```

```Java [sol1-Java]
class Solution {
    public int minRefuelStops(int target, int startFuel, int[][] stations) {
        int n = stations.length;
        long[] dp = new long[n + 1];
        dp[0] = startFuel;
        for (int i = 0; i < n; i++) {
            for (int j = i; j >= 0; j--) {
                if (dp[j] >= stations[i][0]) {
                    dp[j + 1] = Math.max(dp[j + 1], dp[j] + stations[i][1]);
                }
            }
        }
        for (int i = 0; i <= n; i++) {
            if (dp[i] >= target) {
                return i;
            }
        }
        return -1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinRefuelStops(int target, int startFuel, int[][] stations) {
        int n = stations.Length;
        long[] dp = new long[n + 1];
        dp[0] = startFuel;
        for (int i = 0; i < n; i++) {
            for (int j = i; j >= 0; j--) {
                if (dp[j] >= stations[i][0]) {
                    dp[j + 1] = Math.Max(dp[j + 1], dp[j] + stations[i][1]);
                }
            }
        }
        for (int i = 0; i <= n; i++) {
            if (dp[i] >= target) {
                return i;
            }
        }
        return -1;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minRefuelStops(int target, int startFuel, vector<vector<int>>& stations) {
        int n = stations.size();
        vector<long> dp(n + 1);
        dp[0] = startFuel;
        for (int i = 0; i < n; i++) {
            for (int j = i; j >= 0; j--) {
                if (dp[j] >= stations[i][0]) {
                    dp[j + 1] = max(dp[j + 1], dp[j] + stations[i][1]);
                }
            }
        }
        for (int i = 0; i <= n; i++) {
            if (dp[i] >= target) {
                return i;
            }
        }
        return -1;
    }
};
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int minRefuelStops(int target, int startFuel, int** stations, int stationsSize, int* stationsColSize){
    long *dp = (long *)malloc(sizeof(long) * (stationsSize + 1));
    memset(dp, 0, sizeof(long) * (stationsSize + 1));
    dp[0] = startFuel;
    for (int i = 0; i < stationsSize; i++) {
        for (int j = i; j >= 0; j--) {
            if (dp[j] >= stations[i][0]) {
                dp[j + 1] = MAX(dp[j + 1], dp[j] + stations[i][1]);
            }
        }
    }
    for (int i = 0; i <= stationsSize; i++) {
        if (dp[i] >= target) {
            free(dp);
            return i;
        }
    }
    free(dp);
    return -1;
}
```

```go [sol1-Golang]
func minRefuelStops(target, startFuel int, stations [][]int) int {
    n := len(stations)
    dp := make([]int, n+1)
    dp[0] = startFuel
    for i, s := range stations {
        for j := i; j >= 0; j-- {
            if dp[j] >= s[0] {
                dp[j+1] = max(dp[j+1], dp[j]+s[1])
            }
        }
    }
    for i, v := range dp {
        if v >= target {
            return i
        }
    }
    return -1
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var minRefuelStops = function(target, startFuel, stations) {
    const n = stations.length;
    const dp = new Array(n + 1).fill(0);
    dp[0] = startFuel;
    for (let i = 0; i < n; i++) {
        for (let j = i; j >= 0; j--) {
            if (dp[j] >= stations[i][0]) {
                dp[j + 1] = Math.max(dp[j + 1], dp[j] + stations[i][1]);
            }
        }
    }
    for (let i = 0; i <= n; i++) {
        if (dp[i] >= target) {
            return i;
        }
    }
    return -1;
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是数组 $\textit{stations}$ 的长度。动态规划的状态数是 $O(n)$，每个状态需要 $O(n)$ 的时间计算，因此时间复杂度是 $O(n^2)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{stations}$ 的长度。需要创建长度为 $n + 1$ 的数组 $\textit{dp}$。

#### 方法二：贪心

用 $n$ 表示数组 $\textit{stations}$ 的长度，即加油站的个数。行驶的过程中依次到达 $n + 1$ 个位置，分别是 $n$ 个加油站和目的地。为了得到最少加油次数，应该在确保每个位置都能到达的前提下，选择最大加油量的加油站加油。

为了得到已经到达过的加油站中的最大加油量，需要使用优先队列记录所有已经到达过的加油站的加油量，优先队列中的最大元素位于队首，即每次从优先队列中取出的元素都是优先队列中的最大元素。

从左到右遍历数组 $\textit{stations}$，对于每个加油站，首先判断该位置是否可以达到，然后将当前加油站的加油量添加到优先队列中。对于目的地，则只需要判断是否可以达到。

具体做法如下。

1. 计算当前位置（加油站或目的地）与上一个位置的距离之差，根据该距离之差得到从上一个位置行驶到当前位置需要使用的汽油量，将使用的汽油量从剩余的汽油量中减去。

2. 如果剩余的汽油量小于 $0$，则表示在不加油的情况下无法从上一个位置行驶到当前位置，需要加油。取出优先队列中的最大元素加到剩余的汽油量，并将加油次数加 $1$，重复该操作直到剩余的汽油量大于等于 $0$ 或优先队列变为空。

3. 如果优先队列变为空时，剩余的汽油量仍小于 $0$，则表示在所有经过的加油站加油之后仍然无法到达当前位置，返回 $-1$。

4. 如果当前位置是加油站，则将当前加油站的加油量添加到优先队列中，并使用当前位置更新上一个位置。

如果无法到达目的地，则在遍历过程中返回 $-1$。如果遍历结束仍未返回 $-1$，则可以到达目的地，返回加油次数。

```Python [sol2-Python3]
class Solution:
    def minRefuelStops(self, target: int, startFuel: int, stations: List[List[int]]) -> int:
        n = len(stations)
        ans, fuel, prev, h = 0, startFuel, 0, []
        for i in range(n + 1):
            curr = stations[i][0] if i < n else target
            fuel -= curr - prev
            while fuel < 0 and h:
                fuel -= heappop(h)
                ans += 1
            if fuel < 0:
                return -1
            if i < n:
                heappush(h, -stations[i][1])
                prev = curr
        return ans
```

```Java [sol2-Java]
class Solution {
    public int minRefuelStops(int target, int startFuel, int[][] stations) {
        PriorityQueue<Integer> pq = new PriorityQueue<Integer>((a, b) -> b - a);
        int ans = 0, prev = 0, fuel = startFuel;
        int n = stations.length;
        for (int i = 0; i <= n; i++) {
            int curr = i < n ? stations[i][0] : target;
            fuel -= curr - prev;
            while (fuel < 0 && !pq.isEmpty()) {
                fuel += pq.poll();
                ans++;
            }
            if (fuel < 0) {
                return -1;
            }
            if (i < n) {
                pq.offer(stations[i][1]);
                prev = curr;
            }
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MinRefuelStops(int target, int startFuel, int[][] stations) {
        PriorityQueue<int, int> pq = new PriorityQueue<int, int>();
        int ans = 0, prev = 0, fuel = startFuel;
        int n = stations.Length;
        for (int i = 0; i <= n; i++) {
            int curr = i < n ? stations[i][0] : target;
            fuel -= curr - prev;
            while (fuel < 0 && pq.Count > 0) {
                fuel += pq.Dequeue();
                ans++;
            }
            if (fuel < 0) {
                return -1;
            }
            if (i < n) {
                pq.Enqueue(stations[i][1], -stations[i][1]);
                prev = curr;
            }
        }
        return ans;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int minRefuelStops(int target, int startFuel, vector<vector<int>>& stations) {
        priority_queue<int> pq;
        int ans = 0, prev = 0, fuel = startFuel;
        int n = stations.size();
        for (int i = 0; i <= n; i++) {
            int curr = i < n ? stations[i][0] : target;
            fuel -= curr - prev;
            while (fuel < 0 && !pq.empty()) {
                fuel += pq.top();
                pq.pop();
                ans++;
            }
            if (fuel < 0) {
                return -1;
            }
            if (i < n) {
                pq.emplace(stations[i][1]);
                prev = curr;
            }
        }
        return ans;
    }
};
```

```go [sol2-Golang]
func minRefuelStops(target, startFuel int, stations [][]int) (ans int) {
    fuel, prev, h := startFuel, 0, hp{}
    for i, n := 0, len(stations); i <= n; i++ {
        curr := target
        if i < n {
            curr = stations[i][0]
        }
        fuel -= curr - prev
        for fuel < 0 && h.Len() > 0 {
            fuel += heap.Pop(&h).(int)
            ans++
        }
        if fuel < 0 {
            return -1
        }
        if i < n {
            heap.Push(&h, stations[i][1])
            prev = curr
        }
    }
    return
}

type hp struct{ sort.IntSlice }
func (h hp) Less(i, j int) bool  { return h.IntSlice[i] > h.IntSlice[j] }
func (h *hp) Push(v interface{}) { h.IntSlice = append(h.IntSlice, v.(int)) }
func (h *hp) Pop() interface{}   { a := h.IntSlice; v := a[len(a)-1]; h.IntSlice = a[:len(a)-1]; return v }
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{stations}$ 的长度。需要遍历数组 $\textit{stations}$ 一次，每个加油站的汽油量最多添加到优先队列和从优先队列中移除各一次，每次优先队列的操作需要 $O(\log n)$ 的时间，因此时间复杂度是 $O(n \log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{stations}$ 的长度。优先队列需要 $O(n)$ 的空间。
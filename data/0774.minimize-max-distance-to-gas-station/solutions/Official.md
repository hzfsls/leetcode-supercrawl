[TOC]

---
#### 方法 1：动态规划 [超出内存限制]
 **思路**
  `dp[n][k]` 是在前 `n` 个加油站区间增加 `k` 个加油站的答案。我们可以将 `dp[n][k]` 的表达形式设定为较小 `(x, y)` 的 `dp[x][y]` 的表达。
 **算法**
 假设第 `i` 个区间为 `deltas[i] = stations[i+1] - stations[i]`。我们希望找到 `dp[n+1][k]` 的递归式。我们可以在第 `n+1` 个区间中增加 `x` 个加油站以得到最好的距离 `deltas[n+1] / (x+1)`，然后剩下的区间可以通过 `dp[n][k-x]` 的答案来解答。答案是所有 `x` 中的最小值。
 通过此递归式，我们可以选择使用动态规划。
**代码实现**
```Java [slu1]
class Solution {
    public double minmaxGasDist(int[] stations, int K) {
        int N = stations.length;
        double[] deltas = new double[N-1];
        for (int i = 0; i < N-1; ++i)
            deltas[i] = stations[i+1] - stations[i];

        double[][] dp = new double[N-1][K+1];
        // dp [i][j] = deltas[:i+1] 的答案，当加入 j 个加油站时
        for (int i = 0; i <= K; ++i)
            dp[0][i] = deltas[0] / (i+1);

        for (int p = 1; p < N-1; ++p)
            for (int k = 0; k <= K; ++k) {
                double bns = 999999999;
                for (int x = 0; x <= k; ++x)
                    bns = Math.min(bns, Math.max(deltas[p] / (x+1), dp[p-1][k-x]));
                dp[p][k] = bns;
            }

        return dp[N-2][K];
    }
}
```
```Python [slu1]
class Solution(object):
    def minmaxGasDist(self, stations, K):
        N = len(stations)
        deltas = [stations[i+1] - stations[i] for i in xrange(N-1)]
        dp = [[0.0] * (K+1) for _ in xrange(N-1)]
        # dp [i][j] = deltas[:i+1] 的答案，当加入 j 个加油站时
        for i in xrange(K+1):
            dp[0][i] = deltas[0] / float(i + 1)

        for p in xrange(1, N-1):
            for k in xrange(K+1):
                dp[p][k] = min(max(deltas[p] / float(x+1), dp[p-1][k-x])
                               for x in xrange(k+1))

        return dp[-1][K]
```

 **复杂度分析**
 - 时间复杂度：$O(N K^2)$，其中 $N$ 是 `stations` 的长度。
 - 空间复杂度：$O(N K)$，即 `dp` 的大小。

---
#### 方法 2：暴力破解 [超出时间限制]
 **思路**
 如同方法 1，在添加 `K` 个加油站总数时，我们应恰当地将一个加油站增加到当前最长的区间。显然这个贪心算法是正确的，没有其他方法能达到比这个方法更小的最大间距。
 **算法**
 为了找到当前最长的区间，我们要了解第 `i` 个（初始）区间变成了多少个 `count[i]` 部分。（例如：如果我们总共在这个区间增加了2个加油站，则有3个部分）这段路的新最长的区间会是 `deltas[i] / count[i]`。
**代码实现**

```Java [slu1]
class Solution {
    public double minmaxGasDist(int[] stations, int K) {
        int N = stations.length;
        double[] deltas = new double[N-1];
        for (int i = 0; i < N-1; ++i)
            deltas[i] = stations[i+1] - stations[i];

        int[] count = new int[N-1];
        Arrays.fill(count, 1);

        for (int k = 0; k < K; ++k) {
            // 求最大部分的区间
            int best = 0;
            for (int i = 0; i < N-1; ++i)
                if (deltas[i] / count[i] > deltas[best] / count[best])
                    best = i;

            // 在最佳间隔处添加
            count[best]++;
        }

        double ans = 0;
        for (int i = 0; i < N-1; ++i)
            ans = Math.max(ans, deltas[i] / count[i]);

        return ans;
    }
}
```
```Python [slu1]
class Solution(object):
    def minmaxGasDist(self, stations, K):
        N = len(stations)
        deltas = [float(stations[i+1] - stations[i]) for i in xrange(N-1)]
        count = [1] * (N - 1)

        for _ in xrange(K):
            # 求最大部分的区间
            best = 0
            for i, x in enumerate(deltas):
                if x / count[i] > deltas[best] / count[best]:
                    best = i

            # 在最佳间隔处添加
            count[best] += 1

        return max(x / count[i] for i, x in enumerate(deltas))
```
**复杂度分析**
 - 时间复杂度：$O(N K)$，其中 $N$ 是 `stations` 的长度。
 - 空间复杂度：$O(N)$，即 `deltas` 和 `count` 的大小。

---
#### 方法 3：堆 [超出时间限制]
 **思路**
 根据方法 2，如果我们要重复求次大值，我们可以用堆数据结构，使用单调最大堆以更高效地求次大值。
 **算法**
 如方法 2，让我们在要插入的中间连续的 `K` 次之后连续 增加一个加油站。我们使用堆以找出最长的区间。在 Python 中，我们使用负优先级的方式来用最小堆模拟最大堆。
 **代码实现**
```Java [slu1]
class Solution {
    public double minmaxGasDist(int[] stations, int K) {
        int N = stations.length;
        PriorityQueue<int[]> pq = new PriorityQueue<int[]>((a, b) ->
            (double)b[0]/b[1] < (double)a[0]/a[1] ? -1 : 1);
        for (int i = 0; i < N-1; ++i)
            pq.add(new int[]{stations[i+1] - stations[i], 1});

        for (int k = 0; k < K; ++k) {
            int[] node = pq.poll();
            node[1]++;
            pq.add(node);
        }

        int[] node = pq.poll();
        return (double)node[0] / node[1];
    }
}
```
```Python [slu1]
class Solution(object):
    def minmaxGasDist(self, stations, K):
        pq = [] #(-part_length, original_length, num_parts)
        for i in xrange(len(stations) - 1):
            x, y = stations[i], stations[i+1]
            pq.append((x-y, y-x, 1))
        heapq.heapify(pq)

        for _ in xrange(K):
            negnext, orig, parts = heapq.heappop(pq)
            parts += 1
            heapq.heappush(pq, (-(orig / float(parts)), orig, parts))

        return -pq[0][0]
```
**复杂度分析**
 若 $N$ 是 stations 的长度, $K$ 是要增加的加油站的数量。
 - 时间复杂度：$O(N + K \log N)$
  - 首先, 我们遍历 stations 以得到每对相邻加油站之间的区间列表。
  - 然后我们用其他 $O(N)$ 来从区间列表建立堆。
  - 最后, 我们重复并弹出元素并嵌入堆，各需要 $O(\log N)$. 总的来说, 我们重复这一步骤以增加 $K$ 次加油站。
  - 总结, 这个算法的总时间复杂度是 $O(N) + O(N) + O(K \cdot \log N) = O(N + K\cdot \log N)$.

 - 空间复杂度：$O(N)$，即 `deltas` 和 `count` 的大小。

---
#### 方法 4：二分查找
 **思路**
 我们问 `possible(D)`: 用 `K`（或更少）个加油站，我们能使所有加油站之间的距离最多为 `D` 吗？ 这个函数是单调的，所以我们可以应用二分查找来找出 $D^{\text{*}}$。
 **算法**
 更明确地说，存在一些 `D*`（答案）如果 `d < D*` 则 `possible(d) = False` 而如果 `d > D*` 则 `possible(d) = True`。二分查找单调函数是典型的方法 ，所以让我们集中注意力在 `possible(D)` 函数上。
 当我们有一些区间 `X = stations[i+1] - stations[i]`，我们需要用 $\lfloor \frac{X}{D} \rfloor$ 个加油站以确保每个子区间的大小小于 `D`。这和其他区间是独立的，所以总的来说我们需要用 $\sum_i \lfloor \frac{X_i}{D} \rfloor$ 个加油站。如果这个数字最多是 `K`，那么我们便可以使得所有加油站间的 距离最大为 `D`.
 **代码实现**
```Java [slu1]
class Solution {
    public double minmaxGasDist(int[] stations, int K) {
        double lo = 0, hi = 1e8;
        while (hi - lo > 1e-6) {
            double mi = (lo + hi) / 2.0;
            if (possible(mi, stations, K))
                hi = mi;
            else
                lo = mi;
        }
        return lo;
    }

    public boolean possible(double D, int[] stations, int K) {
        int used = 0;
        for (int i = 0; i < stations.length - 1; ++i)
            used += (int) ((stations[i+1] - stations[i]) / D);
        return used <= K;
    }
}
```
```Python [slu1]
class Solution(object):
    def minmaxGasDist(self, stations, K):
        def possible(D):
            return sum(int((stations[i+1] - stations[i]) / D)
                       for i in xrange(len(stations) - 1)) <= K

        lo, hi = 0, 10**8
        while hi - lo > 1e-6:
            mi = (lo + hi) / 2.0
            if possible(mi):
                hi = mi
            else:
                lo = mi
        return lo
```
**复杂度分析**
 - 时间复杂度：$O(N \log W)$，其中 $N$ 是 `stations` 的长度，而 $W = 10^{14}$ 是可能答案的范围 ($10^8$) 除以可接受的精度水平 ($10^{-6}$)。
 - 空间复杂度： $O(1)$，不需要额外的空间复杂度。
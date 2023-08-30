#### 方法一：贪心 + 前缀和

**思路**

设数组 $\textit{nums}$ 的长度为 $n$，其中共有 $m$ 个 $1$，它们在数组 $\textit{nums}$ 中的下标分别为 $p_0, p_1, \dots, p_{m-1}$。假设经过若干次交换后，数组 $\textit{nums}$ 中形成的 $k$ 个连续的 $1$ 的下标为 $q, q+1, \dots, q+k-1$。根据贪心的思想，要想交换次数最少，必须满足以下两个条件：
- 这 $k$ 个连续的 $1$ 的起始下标在 $p$ 数组中是连续的，即下标为 $p_i, p_{i+1}, \dots, p_{i+k-1}$。
- $k$ 个 $1$ 的起始下标和结尾下标是按顺序对应的，即下标为 $p_i$ 的 $1$ 交换到 $q$，下标为 $p_{i+k-1}$ 的 $1$ 交换到 $q+k-1$，中间的元素也需要按照顺序。

根据这两个条件，我们可以得到交换次数的公式为 $\sum\limits_{j=i}^{k+i-1}|p_j-(q+j-i)|=\sum\limits_{j=i}^{k+i-1}|(p_j-j)-(q-i)|$。设 $p_j-j = g_j$, $q-i = r$。原式化为 $\sum\limits_{j=i}^{k+i-1}|g_j-r|$。因为 $p_j$ 是严格单调递增的，因此可以保证 $g_j$ 单调非减。为了使该式取得最小值，$r$ 需取数列 $g_i, g_{i+1}, \dots, g_{i+k-1}$ 的中位数，即 $r = g_{i+k/2} = g_{\textit{mid}}$，这里的除法为整数除法。原公式化为$\sum\limits_{j=i}^{\textit{mid}-1}r-g_j + \sum\limits_{j=\textit{mid}+1}^{k+i-1}g_j-r = r\times(1-(k\mod2))+\sum\limits_{j=\textit{mid}+1}^{k+i-1}g_j - \sum\limits_{j=i}^{\textit{mid}-1}g_j$。通过遍历所有的 $i$，计算出交换次数的最小值。计算时，后两项可以通过前缀和得到。

**代码**

```Python [sol1-Python3]
class Solution:
    def minMoves(self, nums: List[int], k: int) -> int:
        g, preSum = [], [0]
        for i, num in enumerate(nums):
            if num == 1:
                g.append(i - len(g))
                preSum.append(preSum[-1] + g[-1])
        m, res = len(g), inf
        for i in range(m - k + 1):
            mid = i + k // 2
            r = g[mid]
            res = min(res, (1 - k % 2) * r + (preSum[i + k] - preSum[mid + 1]) - (preSum[mid] - preSum[i]))
        return res
```

```Java [sol1-Java]
class Solution {
    public int minMoves(int[] nums, int k) {
        List<Integer> g = new ArrayList<Integer>();
        List<Integer> preSum = new ArrayList<Integer>();
        preSum.add(0);
        for (int i = 0; i < nums.length; i++) {
            if (nums[i] == 1) {
                g.add(i - g.size());
                preSum.add(preSum.get(preSum.size() - 1) + g.get(g.size() - 1));
            }
        }
        int m = g.size(), res = Integer.MAX_VALUE;
        for (int i = 0; i <= m - k; i++) {
            int mid = i + k / 2;
            int r = g.get(mid);
            res = Math.min(res, (1 - k % 2) * r + (preSum.get(i + k) - preSum.get(mid + 1)) - (preSum.get(mid) - preSum.get(i)));
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinMoves(int[] nums, int k) {
        IList<int> g = new List<int>();
        IList<int> preSum = new List<int>();
        preSum.Add(0);
        for (int i = 0; i < nums.Length; i++) {
            if (nums[i] == 1) {
                g.Add(i - g.Count);
                preSum.Add(preSum[preSum.Count - 1] + g[g.Count - 1]);
            }
        }
        int m = g.Count, res = int.MaxValue;
        for (int i = 0; i <= m - k; i++) {
            int mid = i + k / 2;
            int r = g[mid];
            res = Math.Min(res, (1 - k % 2) * r + (preSum[i + k] - preSum[mid + 1]) - (preSum[mid] - preSum[i]));
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minMoves(vector<int>& nums, int k) {
        vector<int> g;
        vector<int> preSum(1, 0);
        for (int i = 0; i < nums.size(); i++) {
            if (nums[i] == 1) {
                g.emplace_back(i - g.size());
                preSum.emplace_back(preSum.back() + g.back());
            }
        }
        int m = g.size(), res = INT_MAX;
        for (int i = 0; i <= m - k; i++) {
            int mid = i + k / 2;
            res = min(res, (1 - k % 2) * g[mid] +  \
                           (preSum[i + k] - preSum[mid + 1]) - \
                           (preSum[mid] - preSum[i]));
        }
        return res;
    }
};
```

```C [sol1-C]
static inline int min(int a, int b) {
    return a < b ? a : b;
}

int minMoves(int* nums, int numsSize, int k) {
    int g[numsSize], preSum[numsSize + 1];
    int gSize = 0, preSumSize = 0;
    preSum[preSumSize++] = 0;
    for (int i = 0; i < numsSize; i++) {
        if (nums[i] == 1) {
            g[gSize++] = i - gSize;
            preSum[preSumSize++] = preSum[preSumSize - 1] + g[gSize - 1];
        }
    }
    int m = gSize, res = INT_MAX;
    for (int i = 0; i <= m - k; i++) {
        int mid = i + k / 2;
        res = min(res, (1 - k % 2) * g[mid] +  \
                        (preSum[i + k] - preSum[mid + 1]) - \
                        (preSum[mid] - preSum[i]));
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var minMoves = function(nums, k) {
    const g = [];
    const preSum = [];
    preSum.push(0);
    for (let i = 0; i < nums.length; i++) {
        if (nums[i] === 1) {
            g.push(i - g.length);
            preSum.push(preSum[preSum.length - 1] + g[g.length - 1]);
        }
    }
    let m = g.length, res = Number.MAX_VALUE;
    for (let i = 0; i <= m - k; i++) {
        let mid = i + Math.floor(k / 2);
        let r = g[mid];
        res = Math.min(res, (1 - k % 2) * r + (preSum[i + k] - preSum[mid + 1]) - (preSum[mid] - preSum[i]));
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(n)$。
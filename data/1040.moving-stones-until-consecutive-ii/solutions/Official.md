#### 方法一：双指针

**思路与算法**

现在题目给出一个长度无限的数轴一个长度为 $n$ 数组 $\textit{stones}$，表示 $n$ 颗石子在数轴上的不同位置，其中第 $i$，$0 \le i < n$ 颗石子的位置在 $\textit{stones}[i]$ 上，其中若一颗石子的位置最小/最大，则该石子被称为端点石子。现在我们每次需要将一颗端点石子移动到一个未占用的位置上，使得其不再是一颗端点石子，若无法进行操作则停止。我们需要返回从初始状况开始可以进行操作的最少操作次数和最大操作次数。

我们记这些石子的长度为两端点石子之间的距离差，则通过题意可以得到每次移动石子的长度严格递减，并由于石子的总个数不变，所以石子间的空位越来越少。通过移动最终让所有石子连续，实质上就是让石子间的空位为 $0$。现在我们开始考虑如何求解最大操作数和最小操作数，为了方便描述，我们不妨对数组 $\textit{stones}$ 中的石子按照位置大小升序排序，即满足

$$\textit{stones}[0] < \textit{stones}[1] < \dots <\textit{stones}[n-1]$$

首先若初始时全部石子已经连续，即空位数 $\textit{stones}[n-1] - \textit{stones}[0] + 1 - n$ 为 $0$，则此时不能进行操作，最大操作数和最小操作数都为 $0$，否则：

- 最大操作数：第一次我们只能选择 $\textit{stones}[0]$ 或者 $\textit{stones}[n-1]$ 进行移动。因为移动后不能继续成为端点石子，所以若移动 $\textit{stones}[0]$，则 $\textit{stones}[1]$ 到 $\textit{stones}[0]$ 之间的空位将会被丢弃，若移动 $\textit{stones}[n-1]$，则 $\textit{stones}[n-1]$ 到 $\textit{stones}[n-2]$ 之间的空位将会被丢弃，如果我们每次移动都将端点石子移到其最近的空位，则第一次移动后，若移动 $\textit{stones}[0]$，则此时最左端的两个石子一定保证相邻，此时我们在之后的操作中都将最左端的石子移动到与之最近的空位中，直至不能进行操作，这样剩下的空位都不会被丢弃。若移动 $\textit{stones}[n-1]$，同理此时最右端的两个石子一定保证相邻，此时我们在之后的操作中都将最右端的石子移动到与之最近的空位中，直至不能进行操作，这样剩下的空位同样都不会被丢弃。由于每次操作必定会少一个空位，所以在第一次移动后，上述的两者操作都是最优操作，又因为最初的总空位是固定的，所以若我们第一次选择移动 $\textit{stones}[0]$，则可以操作的总次数为

  $$\textit{stones}[n-1] - \textit{stones}[1] + 1 - (n - 1) \tag{1}$$

  若我们第一次选择移动 $\textit{stones}[n-1]$，则可以操作的总次数为

  $$\textit{stones}[n-2] - \textit{stones}[0] + 1 - (n - 1) \tag{2}$$

  那么两者中的较大值即为最大的操作数。

- 最小操作数：最终全部石子连续等价于全部的石子最终都移动到了一个长度为 $n$ 的窗口中。
  1. 若窗口中有连续的 $n - 1$ 个石子，若剩下一个石子与窗口中与之最近的石子之间的空位数为 $1$，则只需要一次操作即可使 $n$ 个石子连续，否则我们需要进行两步操作。比如有石子位置序列 $1,2,3,4,6$，则此时 $1,2,3,4$ 连续，$6$ 与其最近的 $4$ 中间空位数为 $1$，我们只需要将位置为 $1$ 的石子移动到位置为 $5$ 的位置即可。否则若石子位置序列为 $1,2,3,4,x$，其中 $x > 6$，则我们可以可以将位置为 $1$ 的石子移动到位置为 $6$ 的位置，然后将位置 $x$ 的石子移动到 $5$ 即可。其中剩下的一个石子在连续序列的左边时同理可以分析得到相同结论。
  2. 否则我们选择包含石子最多的窗口即可，不妨设有 $k$ 个石子，则此时需要 $n - k$ 次操作将窗口中的空位填满。证明如下。
  我们不妨设此时窗口的左端点已有石子（若没有，则可以将窗口不断右移直至窗口左端点存在石子，因为右移的过程中窗口中的石子个数只增不少，不会改变窗口石子最多的性质），若此时窗口右端点有石子，则剩下的 $n - k$ 个石子可以依次移动到窗口中的空位中，否则此时窗口中石子个数少于 $n - 1$，因为若石子个数等于 $n - 1$ 且窗口右端点无石子，此时为情况 $1$。那么外面至少有两个石子，若窗口右边存在两个及以上石子则一定可以将最右端的石子移动到窗口右端，否则若窗口右边存在一个石子，此时窗口左边必定至少有一个石子，可以将最做左边的石子移动到窗口右端，此时对于剩下的 $n - k - 1$ 个石子可以依次移动到窗口中剩下的空位中。此时总的移动数仍为 $n - k$。若窗口右边没有石子，则我们将窗口不断左移使得窗口右端存在石子，此时同上述的分析过程可以得到需要的总移动次数为 $n - k$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> numMovesStonesII(vector<int>& stones) {
        int n = stones.size();
        sort(stones.begin(), stones.end());
        if (stones.back() - stones[0] + 1 == n) {
            return {0, 0};
        }
        int ma = max(stones[n - 2] - stones[0] + 1, stones[n - 1] - stones[1] + 1) - (n - 1);
        int mi = n;
        for (int i = 0, j = 0; i < n && j + 1 < n; ++i) {
            while (j + 1 < n && stones[j + 1] - stones[i] + 1 <= n) {
                ++j;
            }
            if (j - i + 1 == n - 1 && stones[j] - stones[i] + 1 == n - 1) {
                mi = min(mi, 2);
            } else {
                mi = min(mi, n - (j - i + 1));
            }
        }
        return {mi, ma};
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] numMovesStonesII(int[] stones) {
        int n = stones.length;
        Arrays.sort(stones);
        if (stones[n - 1] - stones[0] + 1 == n) {
            return new int[]{0, 0};
        }
        int ma = Math.max(stones[n - 2] - stones[0] + 1, stones[n - 1] - stones[1] + 1) - (n - 1);
        int mi = n;
        for (int i = 0, j = 0; i < n && j + 1 < n; ++i) {
            while (j + 1 < n && stones[j + 1] - stones[i] + 1 <= n) {
                ++j;
            }
            if (j - i + 1 == n - 1 && stones[j] - stones[i] + 1 == n - 1) {
                mi = Math.min(mi, 2);
            } else {
                mi = Math.min(mi, n - (j - i + 1));
            }
        }
        return new int[]{mi, ma};
    }
}
```

```Python [sol1-Python3]
class Solution:
    def numMovesStonesII(self, stones: List[int]) -> List[int]:
        n = len(stones)
        stones.sort()
        if stones[-1] - stones[0] + 1 == n:
            return [0, 0]
        ma = max(stones[-2] - stones[0] + 1, stones[-1] - stones[1] + 1) - (n - 1)
        mi = n
        j = 0
        for i in range(n):
            while j + 1 < n and stones[j + 1] - stones[i] + 1 <= n:
                j += 1
            if j - i + 1 == n - 1 and stones[j] - stones[i] + 1 == n - 1:
                mi = min(mi, 2)
            else:
                mi = min(mi, n - (j - i + 1))
        return [mi, ma]
```

```Go [sol1-Go]
func numMovesStonesII(stones []int) []int {
    n := len(stones)
    sort.Ints(stones)
    if stones[n - 1] - stones[0] + 1 == n {
        return []int{0, 0}
    }
    ma := max(stones[n - 2] - stones[0] + 1, stones[n - 1] - stones[1] + 1) - (n - 1)
    mi := n
    j := 0
    for i := 0; i < n; i++ {
        for j + 1 < n && stones[j + 1] - stones[i] + 1 <= n {
            j++
        }
        if j - i + 1 == n - 1 && stones[j] - stones[i] + 1 == n - 1 {
            mi = min(mi, 2)
        } else {
            mi = min(mi, n - (j - i + 1))
        }
    }
    return []int{mi, ma}
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var numMovesStonesII = function(stones) {
    let n = stones.length;
    stones.sort((a, b) => a - b);
    if (stones[n - 1] - stones[0] + 1 == n) {
        return [0, 0];
    }
    let ma = Math.max(stones[n - 2] - stones[0] + 1, stones[n-1] - stones[1] + 1) - (n - 1);
    let mi = n;
    let j = 0;
    for (let i = 0; i < n; i++) {
        while (j + 1 < n && stones[j + 1] - stones[i] + 1 <= n) {
            j++;
        }
        if (j - i + 1 == n - 1 && stones[j] - stones[i] + 1 == n - 1) {
            mi = Math.min(mi, 2);
        } else {
            mi = Math.min(mi, n - (j - i + 1));
        }
    }
    return [mi, ma];
};
```

```C# [sol1-C#]
public class Solution {
    public int[] NumMovesStonesII(int[] stones) {
        int n = stones.Length;
        Array.Sort(stones);
        if (stones[n - 1] - stones[0] + 1 == n) {
            return new int[]{0, 0};
        }
        int ma = Math.Max(stones[n - 2] - stones[0] + 1, stones[n - 1] - stones[1] + 1) - (n - 1);
        int mi = n;
        for (int i = 0, j = 0; i < n && j + 1 < n; ++i) {
            while (j + 1 < n && stones[j + 1] - stones[i] + 1 <= n) {
                ++j;
            }
            if (j - i + 1 == n - 1 && stones[j] - stones[i] + 1 == n - 1) {
                mi = Math.Min(mi, 2);
            } else {
                mi = Math.Min(mi, n - (j - i + 1));
            }
        }
        return new int[]{mi, ma};
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

static int cmp(const void *a, const void *b) {
    return *(int *)a - *(int *)b;
}

int* numMovesStonesII(int* stones, int stonesSize, int* returnSize) {
    qsort(stones, stonesSize, sizeof(int), cmp);
    int *ret = (int *)calloc(sizeof(int), 2);
    *returnSize = 2;
    if (stones[stonesSize - 1] - stones[0] + 1 == stonesSize) {
        return ret;
    }
    int ma = MAX(stones[stonesSize - 2] - stones[0] + 1, stones[stonesSize - 1] - stones[1] + 1) - (stonesSize - 1);
    int mi = stonesSize;
    for (int i = 0, j = 0; i < stonesSize && j + 1 < stonesSize; ++i) {
        while (j + 1 < stonesSize && stones[j + 1] - stones[i] + 1 <= stonesSize) {
            ++ j;
        }
        if (j - i + 1 == stonesSize - 1 && stones[j] - stones[i] + 1 == stonesSize - 1) {
            mi = MIN(mi, 2);
        } else {
            mi = MIN(mi, stonesSize - (j - i + 1));
        }
    }
    ret[0] = mi;
    ret[1] = ma;
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 为数组 $\textit{stones}$ 的长度。主要为排序的时间复杂度。
- 空间复杂度：$O(\log n)$，其中 $n$ 为数组 $\textit{stones}$ 的长度。主要为排序的空间开销。
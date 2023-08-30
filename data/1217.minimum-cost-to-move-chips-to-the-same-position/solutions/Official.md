#### 方法一：贪心

**思路与算法**

首先很容易得出：

1. 从某一个偶（奇）数位置 $p_i$ 改变到另一个偶（奇）数位置 $p_j$，不妨设 $p_i < p_j$，那么一定 $\exists k \in \mathbb{N}^*$ 使得 $p_i + 2k = p_j$ 成立，即此时的最小开销为 $0$。
2. 从某一个偶（奇）数位置 $p_i$ 改变到另一个奇（偶）数位置 $p_j$，不妨设 $p_i < p_j$，那么一定 $\exists k \in \mathbb{N}$ 使得 $p_i + 2k + 1 = p_j$ 成立，即此时的最小开销为 $1$。

那么我们可以把初始每一个偶数位置的「筹码」看作一个整体，每一个奇数位置的「筹码」看作一个整体。因为我们的目标是最后将全部的「筹码」移动到同一个位置，那么最后的位置只有两种情况：

1. 移动到某一个偶数位置，此时的开销最小值就是初始奇数位置「筹码」的数量。
2. 移动到某一个奇数位置，此时的开销最小值就是初始偶数位置「筹码」的数量。

那么这两种情况中的最小值就是最后将所有筹码移动到同一位置上所需要的最小代价。

**代码**

```Python [sol1-Python3]
class Solution:
    def minCostToMoveChips(self, position: List[int]) -> int:
        cnt = Counter(p % 2 for p in position)  # 根据模 2 后的余数来统计奇偶个数
        return min(cnt[0], cnt[1])
```

```C++ [sol1-C++]
class Solution {
public:
    int minCostToMoveChips(vector<int>& position) {
        int even = 0, odd = 0;
        for (int pos : position) {
            if (pos % 2) {
                odd++;
            } else {
                even++;
            }
        }
        return min(odd, even);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minCostToMoveChips(int[] position) {
        int even = 0, odd = 0;
        for (int pos : position) {
            if ((pos & 1) != 0) {
                odd++;
            } else {
                even++;
            }
        }
        return Math.min(odd, even);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinCostToMoveChips(int[] position) {
        int even = 0, odd = 0;
        foreach (int pos in position) {
            if ((pos & 1) != 0) {
                odd++;
            } else {
                even++;
            }
        }
        return Math.Min(odd, even);
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int minCostToMoveChips(int* position, int positionSize){
    int even = 0, odd = 0;
    for (int i = 0; i < positionSize; i++) {
        if (position[i] & 1) {
            odd++;
        } else {
            even++;
        }
    }
    return MIN(odd, even);
}
```

```JavaScript [sol1-JavaScript]
var minCostToMoveChips = function(position) {
    let even = 0, odd = 0;
    for (const pos of position) {
        if ((pos & 1) !== 0) {
            odd++;
        } else {
            even++;
        }
    }
    return Math.min(odd, even);
};
```

```go [sol1-Golang]
func minCostToMoveChips(position []int) int {
    cnt := [2]int{}
    for _, p := range position {
        cnt[p%2]++
    }
    return min(cnt[0], cnt[1])
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{position}$ 的长度，只对数组进行了一次遍历。

- 空间复杂度：$O(1)$，仅使用常数变量。
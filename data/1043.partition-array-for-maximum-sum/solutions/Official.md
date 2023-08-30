#### 方法一：动态规划

**思路与算法**

我们需要将 $\textit{arr}$ 分割成若干个子数组，每个子数组的长度都不超过 $k$。分割后每个元素都将变成其所属子数组中的最大值。现考虑如何使数组和最大。

我们很难同时分割所有元素，如果能一次只考虑分割一组，然后利用之前分割得到的信息，任务就会变得简单。试想当前枚举到了 $i$，我们把 $i$ 当做这一组的末尾，然后在 $[i - k, i - 1]$ 的范围内枚举 $j$，$[j + 1, i]$ 这一段可以当做新的一组。这时我们需要利用以 $j$ 为结尾分割的最大和，可以发现如果将这个问题的答案提前计算并存储下来，以 $i$ 为结尾的问题就可以迎刃而解。

具体地，我们设 $d[i]$ 为以 $i$ 结尾分割的最大和，求解时倒序枚举 $j ~(j \in [i - k, i - 1])$，那么转移方程有：

$$d[i] = \max\{d[j] + \textit{maxValue} \times (i - j)\}$$

其中 $\textit{maxValue} = \max\{arr[j+1], \cdots, arr[i]\}$。

答案为 $d[n]$，$n$是 $\textit{arr}$ 的长度。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    using ll = long long;
    int maxSumAfterPartitioning(vector<int>& arr, int k) {
        int n = arr.size();
        vector<int> d(n + 1);
        for (int i = 1; i <= n; i++) {
            int maxValue = arr[i - 1];
            for (int j = i - 1; j >= 0 && j >= i - k; j--) {
                d[i] = max(d[i], d[j] + maxValue * (i - j));
                if (j > 0) {
                    maxValue = max(maxValue, arr[j - 1]);
                }
            }
        }
        return d[n];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxSumAfterPartitioning(int[] arr, int k) {
        int n = arr.length;
        int[] d = new int[n + 1];
        for (int i = 1; i <= n; i++) {
            int maxValue = arr[i - 1];
            for (int j = i - 1; j >= 0 && j >= i - k; j--) {
                d[i] = Math.max(d[i], d[j] + maxValue * (i - j));
                if (j > 0) {
                    maxValue = Math.max(maxValue, arr[j - 1]);
                }
            }
        }
        return d[n];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maxSumAfterPartitioning(self, arr: List[int], k: int) -> int:
        n = len(arr)
        d = [0] * (n + 1)
        for i in range(1, n + 1):
            maxValue = arr[i - 1]
            for j in range(i - 1, max(-1, i - k - 1), -1):
                d[i] = max(d[i], d[j] + maxValue * (i - j))
                if j > 0:
                    maxValue = max(maxValue, arr[j - 1])
        return d[n]
```

```Go [sol1-Golang]
func maxSumAfterPartitioning(arr []int, k int) int {
    n := len(arr)
    d := make([]int, n+1)
    for i := 1; i <= n; i++ {
        maxValue := arr[i-1]
        for j := i - 1; j >= max(0, i - k); j-- {
            d[i] = max(d[i], d[j] + maxValue * (i - j))
            if j > 0 && arr[j - 1] > maxValue {
                maxValue = arr[j - 1]
            }
        }
    }
    return d[n]
}

func max(x, y int) int {
    if x > y {
        return x
    }
    return y
}
```

```JavaScript [sol1-JavaScript]
var maxSumAfterPartitioning = function(arr, k) {
    const n = arr.length;
    const d = new Array(n + 1).fill(0);
    for (let i = 1; i <= n; i++) {
        let maxValue = arr[i - 1];
        for (let j = i - 1; j >= Math.max(0, i - k); j--) {
            d[i] = Math.max(d[i], d[j] + maxValue * (i - j));
            if (j > 0) {
                maxValue = Math.max(maxValue, arr[j - 1]);
            }
        }
    }
    return d[n];

};
```

```C# [sol1-C#]
public class Solution {
    public int MaxSumAfterPartitioning(int[] arr, int k) {
        int n = arr.Length;
        int[] d = new int[n + 1];
        for (int i = 1; i <= n; i++) {
            int maxValue = arr[i - 1];
            for (int j = i - 1; j >= 0 && j >= i - k; j--) {
                d[i] = Math.Max(d[i], d[j] + maxValue * (i - j));
                if (j > 0) {
                    maxValue = Math.Max(maxValue, arr[j - 1]);
                }
            }
        }
        return d[n];
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int maxSumAfterPartitioning(int* arr, int arrSize, int k) {
    int d[arrSize + 1];
    memset(d, 0, sizeof(d));
    for (int i = 1; i <= arrSize; i++) {
        int maxValue = arr[i - 1];
        for (int j = i - 1; j >= 0 && j >= i - k; j--) {
            d[i] = MAX(d[i], d[j] + maxValue * (i - j));
            if (j > 0) {
                maxValue = MAX(maxValue, arr[j - 1]);
            }
        }
    }
    return d[arrSize];
}
```

**复杂度分析**

- 时间复杂度：$O(nk)$，其中 $n$ 是 $\textit{arr}$ 的长度。倒序遍历 $j$ 的过程中可以顺便维护区间最大值，这样 $d[i]$ 的转移可以在 $O(k)$ 的时间内完成。

- 空间复杂度：$O(n)$，其中 $n$ 是 $\textit{arr}$ 的长度。
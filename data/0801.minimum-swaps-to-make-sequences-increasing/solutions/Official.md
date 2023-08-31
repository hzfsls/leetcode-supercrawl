## [801.使序列递增的最小交换次数 中文官方题解](https://leetcode.cn/problems/minimum-swaps-to-make-sequences-increasing/solutions/100000/shi-xu-lie-di-zeng-de-zui-xiao-jiao-huan-ux2y)

#### 方法一：动态规划

**思路与算法**

题目给定两个长度都为 $n$ 的整型数组 $\textit{nums}_1$，$\textit{nums}_2$，每次操作我们可以交换 $\textit{nums}_1$ 和 $\textit{nums}_2$ 中相同位置上的数字。我们需要求使 $\textit{nums}_1$ 和 $\textit{nums}_2$ 严格递增的最小操作次数，题目保证题目用例可以实现操作。因为每次只能交换相同位置的两个数，所以位置 $i$ 一定至少满足以下两种情况中的一种：

1. $\textit{nums}_1[i] > \textit{nums}_1[i - 1]$ 且 $\textit{nums}_2[i] > \textit{nums}_2[i - 1]$
2. $\textit{nums}_1[i] > \textit{nums}_2[i - 1]$ 且 $\textit{nums}_2[i] > \textit{nums}_1[i - 1]$

否则无论是否交换 $\textit{nums}_1[i]$ 和 $\textit{nums}_2[i]$ 都不可能使数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 最终严格递增。因为对于某一个位置来说只有交换和不交换两种情况，所以我们可以设 $\textit{dp}[i][0]$ 表示到位置 $i$ 为止使数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 满足严格递增并且位置 $i$ 不进行交换操作的最小操作数，设 $\textit{dp}[i][1]$ 表示到位置 $i$ 为止使数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 满足严格递增并且位置 $i$ 进行交换操作的最小操作数。我们思考如何求解各个状态：

1. 当只满足上述的情况 $1$ 而不满足情况 $2$ 时，位置 $i$ 的交换情况需要和位置 $i - 1$ 的情况保持一致：
$$
\begin{cases}
\textit{dp}[i][0] = \textit{dp}[i - 1][0] \\
\textit{dp}[i][1] = \textit{dp}[i - 1][1] + 1 \\
\end{cases}
$$
2. 当只满足上述的情况 $2$ 而不满足情况 $1$ 时，位置 $i$ 的交换情况需要和位置 $i - 1$ 的情况相反：
$$
\begin{cases}
\textit{dp}[i][0] = \textit{dp}[i - 1][1] \\
\textit{dp}[i][1] = \textit{dp}[i - 1][0] + 1 \\
\end{cases}
$$
3. 当同时满足上述的情况 $1$ 和情况 $2$ 时，$\textit{dp}[i][0]$，$\textit{dp}[i][1]$ 取两种情况中的较小值即可：
$$
\begin{cases}
\textit{dp}[i][0] = \min\{\textit{dp}[i - 1][0], \textit{dp}[i - 1][1]\}\\
\textit{dp}[i][1] = \min\{\textit{dp}[i - 1][1], \textit{dp}[i - 1][0]\} + 1\\
\end{cases}
$$

上述的讨论是建立在 $i > 0$ 的基础上的，而当 $i = 0$ 时，无论是否交换都为合法状态，即可以初始化 $\textit{dp}[0][0] = 0$，$\textit{dp}[0][1] = 1$。又因为求解每一个状态都只与前一个状态有关，所以我们可以用「滚动数组」的方法来进行空间优化。

**代码**

```Python [sol1-Python3]
class Solution:
    def minSwap(self, nums1: List[int], nums2: List[int]) -> int:
        n = len(nums1)
        a, b = 0, 1
        for i in range(1, n):
            at, bt = a, b
            a = b = n
            if nums1[i] > nums1[i - 1] and nums2[i] > nums2[i - 1]:
                a = min(a, at)
                b = min(b, bt + 1)
            if nums1[i] > nums2[i - 1] and nums2[i] > nums1[i - 1]:
                a = min(a, bt)
                b = min(b, at + 1)
        return min(a, b)
```

```C++ [sol1-C++]
class Solution {
public:
    int minSwap(vector<int>& nums1, vector<int>& nums2) {
        int n = nums1.size();
        int a = 0, b = 1;
        for (int i = 1; i < n; i++) {
            int at = a, bt = b;
            a = b = n;
            if (nums1[i] > nums1[i - 1] && nums2[i] > nums2[i - 1])  {
                a = min(a, at);
                b = min(b, bt + 1);
            }
            if (nums1[i] > nums2[i - 1] && nums2[i] > nums1[i - 1]) {
                a = min(a, bt);
                b = min(b, at + 1);
            }
        }
        return min(a, b);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minSwap(int[] nums1, int[] nums2) {
        int n = nums1.length;
        int a = 0, b = 1;
        for (int i = 1; i < n; i++) {
            int at = a, bt = b;
            a = b = n;
            if (nums1[i] > nums1[i - 1] && nums2[i] > nums2[i - 1])  {
                a = Math.min(a, at);
                b = Math.min(b, bt + 1);
            }
            if (nums1[i] > nums2[i - 1] && nums2[i] > nums1[i - 1]) {
                a = Math.min(a, bt);
                b = Math.min(b, at + 1);
            }
        }
        return Math.min(a, b);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinSwap(int[] nums1, int[] nums2) {
        int n = nums1.Length;
        int a = 0, b = 1;
        for (int i = 1; i < n; i++) {
            int at = a, bt = b;
            a = b = n;
            if (nums1[i] > nums1[i - 1] && nums2[i] > nums2[i - 1])  {
                a = Math.Min(a, at);
                b = Math.Min(b, bt + 1);
            }
            if (nums1[i] > nums2[i - 1] && nums2[i] > nums1[i - 1]) {
                a = Math.Min(a, bt);
                b = Math.Min(b, at + 1);
            }
        }
        return Math.Min(a, b);
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int minSwap(int* nums1, int nums1Size, int* nums2, int nums2Size){
    int n = nums1Size;
    int a = 0, b = 1;
    for (int i = 1; i < n; i++) {
        int at = a, bt = b;
        a = n, b = n;
        if (nums1[i] > nums1[i - 1] && nums2[i] > nums2[i - 1])  {
            a = MIN(a, at);
            b = MIN(b, bt + 1);
        }
        if (nums1[i] > nums2[i - 1] && nums2[i] > nums1[i - 1]) {
            a = MIN(a, bt);
            b = MIN(b, at + 1);
        }
    }
    return MIN(a, b);
}
```

```JavaScript [sol1-JavaScript]
var minSwap = function(nums1, nums2) {
    const n = nums1.length;
    let a = 0, b = 1;
    for (let i = 1; i < n; i++) {
        let at = a, bt = b;
        a = b = n;
        if (nums1[i] > nums1[i - 1] && nums2[i] > nums2[i - 1])  {
            a = Math.min(a, at);
            b = Math.min(b, bt + 1);
        }
        if (nums1[i] > nums2[i - 1] && nums2[i] > nums1[i - 1]) {
            a = Math.min(a, bt);
            b = Math.min(b, at + 1);
        }
    }
    return Math.min(a, b);
};
```

```go [sol1-Golang]
func minSwap(nums1, nums2 []int) int {
    n := len(nums1)
    a, b := 0, 1
    for i := 1; i < n; i++ {
        at, bt := a, b
        a, b = n, n
        if nums1[i] > nums1[i-1] && nums2[i] > nums2[i-1] {
            a = min(a, at)
            b = min(b, bt+1)
        }
        if nums1[i] > nums2[i-1] && nums2[i] > nums1[i-1] {
            a = min(a, bt)
            b = min(b, at+1)
        }
    }
    return min(a, b)
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 的长度。需要遍历两个数组一次，每个状态的计算时间是 $O(1)$。
- 空间复杂度：$O(1)$。使用「滚动数组」后，仅使用常量空间。
## [275.H 指数 II 中文官方题解](https://leetcode.cn/problems/h-index-ii/solutions/100000/h-zhi-shu-ii-by-leetcode-solution-si7h)
#### 前言

这道题是「[274. H 指数](https://leetcode-cn.com/problems/h-index)」的延伸，和第 274 题相比，这道题中的输入数组 $\textit{citations}$ 已经按照升序排序。

除了使用第 274 题的方法以外（见「[274. H 指数的官方题解](https://leetcode-cn.com/problems/h-index/solution/h-zhi-shu-by-leetcode-solution-fnhl)」），这道题可以利用数组 $\textit{citations}$ 有序的特点，使用二分查找的方法求解，时间复杂度为 $O(\log n)$，其中 $n$ 为数组 $\textit{citations}$ 的长度。

#### 方法一：二分查找

由于数组 $\textit{citations}$ 已经按照升序排序，因此可以使用二分查找。

设查找范围的初始左边界 $\textit{left}$ 为 $0$, 初始右边界 $\textit{right}$ 为 $n-1$，其中 $n$ 为数组 $\textit{citations}$ 的长度。每次在查找范围内取中点 $\textit{mid}$，则有 $n-\textit{mid}$ 篇论文被引用了至少 $\textit{citations}[\textit{mid}]$ 次。如果在查找过程中满足 $\textit{citations}[\textit{mid}] \ge n - \textit{mid}$，则移动右边界 $\textit{right}$，否则移动左边界 $\textit{left}$。

```Java [sol1-Java]
class Solution {
    public int hIndex(int[] citations) {
        int n = citations.length;
        int left = 0, right = n - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (citations[mid] >= n - mid) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return n - left;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int HIndex(int[] citations) {
        int n = citations.Length;
        int left = 0, right = n - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (citations[mid] >= n - mid) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return n - left;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def hIndex(self, citations: List[int]) -> int:
        n = len(citations)
        left = 0; right = n - 1
        while left <= right:
            mid = left + (right - left) // 2
            if citations[mid] >= n - mid:
                right = mid - 1
            else:
                left = mid + 1
        return n - left
```

```JavaScript [sol1-JavaScript]
var hIndex = function(citations) {
    let n = citations.length;
    let left = 0, right = n - 1;
    while (left <= right) {
        const mid = left + Math.floor((right - left) / 2);
        if (citations[mid] >= n - mid) {
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return n - left;
};
```

```C++ [sol1-C++]
class Solution {
public:
    int hIndex(vector<int>& citations) {
        int n = citations.size();
        int left = 0, right = n - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (citations[mid] >= n - mid) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return n - left;
    }
};
```

```C [sol1-C]
int hIndex(int* citations, int citationsSize) {
    int left = 0, right = citationsSize - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (citations[mid] >= citationsSize - mid) {
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return citationsSize - left;
}
```

```go [sol1-Golang]
func hIndex(citations []int) int {
    n := len(citations)
    return n - sort.Search(n, func(x int) bool { return citations[x] >= n-x })
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$，其中 $n$ 为数组 $\textit{citations}$ 的长度。二分查找的时间复杂度为 $O(\log n)$。

- 空间复杂度：$O(1)$。
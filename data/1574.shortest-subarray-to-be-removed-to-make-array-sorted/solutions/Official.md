## [1574.删除最短的子数组使剩余数组有序 中文官方题解](https://leetcode.cn/problems/shortest-subarray-to-be-removed-to-make-array-sorted/solutions/100000/shan-chu-zui-duan-de-zi-shu-zu-shi-sheng-do2f)
#### 方法一：双指针

**思路与算法**

题目给定一个整数数组 $\textit{arr}$，要求删除一段连续的子数组，使得剩余元素是非递减的。你需要求出满足这样条件的最短的子数组长度。

最基本的方案是删除数组的头部元素，使得尾部剩余元素单调递增。这样做的话，我们需要一个初始指向尾部的指针，将其不断地往前移动，直到指向的元素小于前一个元素为止，此时我们需要删除的就是该指针前面的所有元素。与这种情况类似，我们也可以删除数组的尾部元素。

但我们不会满足于此，最佳的答案可能是删除中间的一段。例如数组 $[1, 3, 5, 4, 6, 8]$，最佳答案是删除中间的 $5$ 或者 $4$，而不是删除头部的 $1,3,5$ 或者尾部的 $4,6,8$。

假设删除的是 $\textit{arr}[i + 1] \sim \textit{arr}[j - 1]$ 之间的元素，我们需要保证：

1. $\textit{arr}[0] \sim \textit{arr}[i]$ 非递减。
2. $\textit{arr}[j]\sim \textit{arr}[n-1]$ 非递减。
3. $\textit{arr}[i] \le \textit{arr}[j]$。

如果我们枚举 $i$ 和 $j$，然后再用 $O(n)$ 的时间判断是否满足上述条件，那么总复杂度是 $O(n^3)$。但如果我们在从小到大枚举 $i$ 的过程中也从大到小枚举 $j$，那么我们可以将条件 $1$ 和条件 $2$ 的判定结合到枚举过程中（每移动 $i$ 或者 $j$ 一次，就判断条件 $1$ 和条件 $2$ 是否仍然满足），总复杂度将会降低至 $O(n^2)$。

更进一步思考，假设对于当前的 $i$ 来说，$j_1$ 是最优的，那么这意味着这个 $j_1$ 是最小的满足条件 $2$ 和条件 $3$ 的下标。最小是因为我们要使得被删除数组 $\textit{arr}[i+1] \sim \textit{arr}[j - 1]$ 最短。此时我们将 $i$ 加 $1$，如果满足条件 $1$，即 $\textit{arr}[i + 1] \ge \textit{arr}[i]$，那么 $i + 1$ 所匹配的 $j_2$ 满足 $j_2 \ge j_1$。

因此，我们需要两个指针来维护这样的 $i$ 和 $j$。起初 $j$ 指向数组尾部，然后不断往前移动，直到前面的元素小于当前所指元素。然后初始化答案为 $j$ 前面的元素个数。

然后我们让 $i$ 从 $0$ 开始，直到 $n - 1$。对于每个 $i$，我们让 $j$ 不断地向后移动，直到 $\textit{arr}[j] \ge \textit{arr}[i]$ 或者 $j = n$，此时 $j - i - 1$ 就是我们要删除的元素个数，用它来更新答案。然后令 $i$ 等于 $i + 1$，并保证 $\textit{arr}[i + 1] \ge \textit{arr}[i]$，如果不满足则直接跳出循环，如果满足则继续下一轮枚举。

**代码**

```Python [sol1-Python3]
class Solution:
    def findLengthOfShortestSubarray(self, arr: List[int]) -> int:
        n = len(arr)
        j = n - 1
        while j > 0 and arr[j - 1] <= arr[j]:
            j -= 1
        if j == 0:
            return 0
        res = j
        for i in range(n):
            while j < n and arr[j] < arr[i]:
                j += 1
            res = min(res, j - i - 1)
            if i + 1 < n and arr[i] > arr[i + 1]:
                break
        return res
```

```C++ [sol1-C++]
class Solution {
public:
    int findLengthOfShortestSubarray(vector<int>& arr) {
        int n = arr.size(), j = n - 1;
        while (j > 0 && arr[j - 1] <= arr[j]) {
            j--;
        }
        if (j == 0) {
            return 0;
        }
        int res = j;
        for (int i = 0; i < n; i++) {
            while (j < n && arr[j] < arr[i]) {
                j++;
            }
            res = min(res, j - i - 1);
            if (i + 1 < n && arr[i] > arr[i + 1]) {
                break;
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int findLengthOfShortestSubarray(int[] arr) {
        int n = arr.length, j = n - 1;
        while (j > 0 && arr[j - 1] <= arr[j]) {
            j--;
        }
        if (j == 0) {
            return 0;
        }
        int res = j;
        for (int i = 0; i < n; i++) {
            while (j < n && arr[j] < arr[i]) {
                j++;
            }
            res = Math.min(res, j - i - 1);
            if (i + 1 < n && arr[i] > arr[i + 1]) {
                break;
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindLengthOfShortestSubarray(int[] arr) {
        int n = arr.Length, j = n - 1;
        while (j > 0 && arr[j - 1] <= arr[j]) {
            j--;
        }
        if (j == 0) {
            return 0;
        }
        int res = j;
        for (int i = 0; i < n; i++) {
            while (j < n && arr[j] < arr[i]) {
                j++;
            }
            res = Math.Min(res, j - i - 1);
            if (i + 1 < n && arr[i] > arr[i + 1]) {
                break;
            }
        }
        return res;
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int findLengthOfShortestSubarray(int* arr, int arrSize) {
    int n = arrSize, j = n - 1;
    while (j > 0 && arr[j - 1] <= arr[j]) {
        j--;
    }
    if (j == 0) {
        return 0;
    }
    int res = j;
    for (int i = 0; i < n; i++) {
        while (j < n && arr[j] < arr[i]) {
            j++;
        }
        res = MIN(res, j - i - 1);
        if (i + 1 < n && arr[i] > arr[i + 1]) {
            break;
        }
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var findLengthOfShortestSubarray = function(arr) {
    let n = arr.length, j = n - 1;
    while (j > 0 && arr[j - 1] <= arr[j]) {
        j--;
    }
    if (j === 0) {
        return 0;
    }
    let res = j;
    for (let i = 0; i < n; i++) {
        while (j < n && arr[j] < arr[i]) {
            j++;
        }
        res = Math.min(res, j - i - 1);
        if (i + 1 < n && arr[i] > arr[i + 1]) {
            break;
        }
    }
    return res;
};
```

```go [sol1-Golang]
func findLengthOfShortestSubarray(arr []int) int {
    n := len(arr)
    j := n - 1
    for j > 0 && arr[j-1] <= arr[j] {
        j--
    }
    if j == 0 {
        return 0
    }
    res := j
    for i := 0; i < n; i++ {
        for j < n && arr[j] < arr[i] {
            j++
        }
        res = min(res, j-i-1)
        if i+1 < n && arr[i] > arr[i+1] {
            break
        }
    }
    return res
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{arr}$ 的长度。双指针 $i$ 和 $j$ 移动过程中，每个元素最多只会被遍历两次，所以复杂度为 $O(n)$。

- 空间复杂度：$O(1)$。
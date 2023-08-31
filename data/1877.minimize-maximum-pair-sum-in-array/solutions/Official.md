## [1877.数组中最大数对和的最小值 中文官方题解](https://leetcode.cn/problems/minimize-maximum-pair-sum-in-array/solutions/100000/shu-zu-zhong-zui-da-shu-dui-he-de-zui-xi-cvll)

#### 方法一：排序 + 贪心

**提示 $1$**

数组内只有两个数的情况是平凡的。我们可以考虑数组中只有**四个数** $x_1 \le x_2 \le x_3 \le x_4$ 的情况。此时 $(x_1, x_4), (x_2, x_3)$ 的拆分方法对应的最大数对和一定是最小的。

**提示 $1$ 解释**

我们可以枚举所有的拆分方法。除了上文的拆分方法外还有两种拆分方法：

- $(x_1, x_3), (x_2, x_4)$ 

    此时 $x_2 + x_4 \ge x_1 + x_4$ 且 $x_2 + x_4 \ge x_2 + x_3$。
    
    那么 $\max(x_1+x_3,x_2+x_4) \ge x_2 + x_4 \ge \max(x_1+x_4,x_2+x_3)$。

- $(x_1, x_2), (x_3, x_4)$ 

    同样地，$\max(x_1+x_2,x_3+x_4) \ge x_3 + x_4 \ge \max(x_1+x_4,x_2+x_3)$。


**提示 $2$**

对于 $n$ 个数（$n$ 为偶数）的情况，上述的条件对应的拆分方法，即第 $k$ 大与第 $k$ 小组成的 $n / 2$ 个数对，同样可以使得最大数对和最小。

**提示 $2$ 解释**

我们可以类似 **提示 $1$** 对所有数建立**全序关系**，即 $x_1 \le \cdots \le x_n$。我们需要证明，**任意**的拆分方法得到的最大数对和一定大于等于给定的拆分方法得到的最大数对和。

我们可以考虑上述命题的**充分条件**：假设给定拆分方法中的数对和 $x_k + x_{n+1-k}$ 在 $k = k'$ 时最大，那么对于任意的拆分方法，都存在一组 $u, v$ 使得 $x_u + x_v \ge x_{k'} + x_{n+1-k'}$。

我们可以用反证法证明。

同样，我们假设 $u < v$，那么使得 $x_v \ge x_{n+1-k'}$ 的 $v$ 的取值一共有 $k'$ 种。即闭区间 $[n+1-k',n]$ 中的所有整数。对于这些 $v$ 组成的数对，如果想使得 $x_u + x_v < x_{k'} + x_{n+1-k'}$ 恒成立，必须要 $x_u < x_{k'}$。此时需要有 $k'$ 个不同的 $u$ 的取值，但只有闭区间 $[1,k'-1]$ 中的 $k'-1$ 个整数满足 $x_u < x_{k'}$ 的条件，这就产生了矛盾。

因此，一定存在一组 $u, v$ 使得 $x_u + x_v \ge x_{k'} + x_{n+1-k'}$。

**思路与算法**

根据 **提示 $2$**，我们需要将 $\textit{nums}$ 排序。排序后，我们遍历每一个第 $k$ 大与第 $k$ 小组成的数对，计算它们的和，并维护这些和的最大值。同样根据 **提示 $2$**，遍历完成后求得的最大数对和就是满足要求的最小值。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minPairSum(vector<int>& nums) {
        int n = nums.size();
        int res = 0;
        sort(nums.begin(), nums.end());
        for (int i = 0; i < n / 2; ++i) {
            res = max(res, nums[i] + nums[n - 1 - i]);
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minPairSum(int[] nums) {
        int n = nums.length;
        int res = 0;
        Arrays.sort(nums);
        for (int i = 0; i < n / 2; ++i) {
            res = Math.max(res, nums[i] + nums[n - 1 - i]);
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinPairSum(int[] nums) {
        int n = nums.Length;
        int res = 0;
        Array.Sort(nums);
        for (int i = 0; i < n / 2; ++i) {
            res = Math.Max(res, nums[i] + nums[n - 1 - i]);
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minPairSum(self, nums: List[int]) -> int:
        n = len(nums)
        res = 0
        nums.sort()
        for i in range(n // 2):
            res = max(res, nums[i] + nums[n-1-i])
        return res
```

```JavaScript [sol1-JavaScript]
var minPairSum = function(nums) {
    const n = nums.length;
    let res = 0;
    nums.sort((a, b) => a - b);
    for (let i = 0; i < Math.floor(n / 2); i++) {
        res = Math.max(res, nums[i] + nums[n - 1 - i]);
    }
    return res;
};
```

```go [sol1-Golang]
func minPairSum(nums []int) (ans int) {
    sort.Ints(nums)
    n := len(nums)
    for i, val := range nums[:n/2] {
        ans = max(ans, val+nums[n-1-i])
    }
    return
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol1-C]
int cmp(int *a, int *b) {
    return *a - *b;
}

int minPairSum(int *nums, int numsSize) {
    int res = 0;
    qsort(nums, numsSize, sizeof(int), cmp);
    for (int i = 0; i < numsSize / 2; ++i) {
        res = fmax(res, nums[i] + nums[numsSize - 1 - i]);
    }
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。排序 $\textit{nums}$ 的时间复杂度为 $O(n\log n)$，遍历维护最大数对和的时间复杂度为 $O(n)$。

- 空间复杂度：$O(\log n)$，即为排序的栈空间开销。
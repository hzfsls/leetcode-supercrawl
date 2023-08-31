## [1608.特殊数组的特征值 中文官方题解](https://leetcode.cn/problems/special-array-with-x-elements-greater-than-or-equal-x/solutions/100000/te-shu-shu-zu-de-te-zheng-zhi-by-leetcod-9wfo)

#### 方法一：降序排序 + 一次遍历

**思路与算法**

我们可以首先将数组进行降序排序，这样一来，我们就可以通过遍历的方式得到数组的特征值了。

根据特征值 $x$ 的定义，$x$ 一定是在 $[1, n]$ 范围内的一个整数，其中 $n$ 是数组 $\textit{nums}$ 的长度。因此，我们可以遍历 $[1, n]$ 并判断某个整数 $i$ 是否为特征值。

若 $i$ 为特征值，那么 $\textit{nums}$ 中恰好有 $i$ 个元素大于等于 $i$。由于数组已经降序排序，说明 $\textit{nums}[i-1]$ 必须大于等于 $i$，并且 $\textit{nums}[i]$（如果存在）必须小于 $i$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int specialArray(vector<int>& nums) {
        sort(nums.begin(), nums.end(), greater<int>());
        int n = nums.size();
        for (int i = 1; i <= n; ++i) {
            if (nums[i - 1] >= i && (i == n || nums[i] < i)) {
                return i;
            }
        }
        return -1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int specialArray(int[] nums) {
        Arrays.sort(nums);
        int n = nums.length;
        for (int i = 0, j = n - 1; i < j; i++, j--) {
            int temp = nums[i];
            nums[i] = nums[j];
            nums[j] = temp;
        }
        for (int i = 1; i <= n; ++i) {
            if (nums[i - 1] >= i && (i == n || nums[i] < i)) {
                return i;
            }
        }
        return -1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int SpecialArray(int[] nums) {
        Array.Sort(nums);
        int n = nums.Length;
        for (int i = 0, j = n - 1; i < j; i++, j--) {
            int temp = nums[i];
            nums[i] = nums[j];
            nums[j] = temp;
        }
        for (int i = 1; i <= n; ++i) {
            if (nums[i - 1] >= i && (i == n || nums[i] < i)) {
                return i;
            }
        }
        return -1;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def specialArray(self, nums: List[int]) -> int:
        nums.sort(reverse=True)
        n = len(nums)
        for i in range(1, n + 1):
            if nums[i - 1] >= i and (i == n or nums[i] < i):
                return i
        return -1
```

```C [sol1-C]
static inline int cmp(const void *pa, const void *pb) {
    return *(int *)pb - *(int *)pa;
}

int specialArray(int* nums, int numsSize) {
    qsort(nums, numsSize, sizeof(int), cmp);
    for (int i = 1; i <= numsSize; ++i) {
        if (nums[i - 1] >= i && (i == numsSize || nums[i] < i)) {
            return i;
        }
    }
    return -1;
}
```

```go [sol1-Golang]
func specialArray(nums []int) int {
    sort.Sort(sort.Reverse(sort.IntSlice(nums)))
    for i, n := 1, len(nums); i <= n; i++ {
        if nums[i-1] >= i && (i == n || nums[i] < i) {
            return i
        }
    }
    return -1
}
```

```JavaScript [sol1-JavaScript]
var specialArray = function(nums) {
    nums.sort((a, b) => a - b);
    const n = nums.length;
    for (let i = 0, j = n - 1; i < j; i++, j--) {
        const temp = nums[i];
        nums[i] = nums[j];
        nums[j] = temp;
    }
    for (let i = 1; i <= n; ++i) {
        if (nums[i - 1] >= i && (i === n || nums[i] < i)) {
            return i;
        }
    }
    return -1;
};
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(\log n)$，即为排序需要的栈空间。
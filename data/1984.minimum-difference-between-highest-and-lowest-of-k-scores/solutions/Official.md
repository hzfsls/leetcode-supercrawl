#### 方法一：排序

**思路与算法**

要想**最小化**选择的 $k$ 名学生中最高分和最低分的差值，我们一定是在排好序后的数组中**连续**地进行选择。这是因为在选择时，如果跳过了某个下标 $i$，那么在选择完毕后，将其中的最高分替换成 $\textit{nums}[i]$，最高分一定不会变大，与最低分的差值同样也不会变大。因此，一定存在有一种最优的选择方案，是连续选择了有序数组中的 $k$ 个连续的元素。

这样一来，我们首先对数组 $\textit{nums}$ 进行升序排序，随后使用一个大小固定为 $k$ 的滑动窗口在 $\textit{nums}$ 上进行遍历。记滑动窗口的左边界为 $i$，那么右边界即为 $i+k-1$，窗口中的 $k$ 名学生最高分和最低分的差值即为 $\textit{nums}[i+k-1] - \textit{nums}[i]$。

最终的答案即为所有 $\textit{nums}[i+k-1] - \textit{nums}[i]$ 中的最小值。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minimumDifference(vector<int>& nums, int k) {
        int n = nums.size();
        sort(nums.begin(), nums.end());
        int ans = INT_MAX;
        for (int i = 0; i + k - 1 < n; ++i) {
            ans = min(ans, nums[i + k - 1] - nums[i]);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minimumDifference(int[] nums, int k) {
        int n = nums.length;
        Arrays.sort(nums);
        int ans = Integer.MAX_VALUE;
        for (int i = 0; i + k - 1 < n; ++i) {
            ans = Math.min(ans, nums[i + k - 1] - nums[i]);
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinimumDifference(int[] nums, int k) {
        int n = nums.Length;
        Array.Sort(nums);
        int ans = int.MaxValue;
        for (int i = 0; i + k - 1 < n; ++i) {
            ans = Math.Min(ans, nums[i + k - 1] - nums[i]);
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minimumDifference(self, nums: List[int], k: int) -> int:
        nums.sort()
        return min(nums[i + k - 1] - nums[i] for i in range(len(nums) - k + 1))
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int cmp(const void * pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int minimumDifference(int* nums, int numsSize, int k){
    qsort(nums, numsSize, sizeof(int), cmp);
    int ans = INT_MAX;
    for (int i = 0; i + k - 1 < numsSize; ++i) {
        ans = MIN(ans, nums[i + k - 1] - nums[i]);
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var minimumDifference = function(nums, k) {
    const n = nums.length;
    nums.sort((a, b) => a - b);
    let ans = Number.MAX_SAFE_INTEGER;
    for (let i = 0; i < n - k + 1; i++) {
        ans = Math.min(ans, nums[i + k - 1] - nums[i]);
    }
    return ans;
};
```

```go [sol1-Golang]
func minimumDifference(nums []int, k int) int {
    sort.Ints(nums)
    ans := math.MaxInt32
    for i, num := range nums[:len(nums)-k+1] {
        ans = min(ans, nums[i+k-1]-num)
    }
    return ans
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。排序需要的时间为 $O(n \log n)$，后续遍历需要的时间为 $O(n)$。

- 空间复杂度：$O(\log n)$，即为排序需要使用的栈空间。
## [674.最长连续递增序列 中文官方题解](https://leetcode.cn/problems/longest-continuous-increasing-subsequence/solutions/100000/zui-chang-lian-xu-di-zeng-xu-lie-by-leet-dmb8)
#### 方法一：贪心

对于下标范围 $[l,r]$ 的连续子序列，如果对任意 $l \le i<r$ 都满足 $\textit{nums}[i]<\textit{nums}[i+1]$，则该连续子序列是递增序列。

假设数组 $\textit{nums}$ 的长度是 $n$，对于 $0<l \le r<n-1$，如果下标范围 $[l,r]$ 的连续子序列是递增序列，则考虑 $\textit{nums}[l-1]$ 和 $\textit{nums}[r+1]$。

- 如果 $\textit{nums}[l-1]<\textit{nums}[l]$，则将 $\textit{nums}[l-1]$ 加到 $\textit{nums}[l]$ 的前面，可以得到更长的连续递增序列.

- 如果 $\textit{nums}[r+1]>\textit{nums}[r]$，则将 $\textit{nums}[r+1]$ 加到 $\textit{nums}[r]$ 的后面，可以得到更长的连续递增序列。

基于上述分析可知，为了得到最长连续递增序列，可以使用贪心的策略得到尽可能长的连续递增序列。做法是使用记录当前连续递增序列的开始下标和结束下标，遍历数组的过程中每次比较相邻元素，根据相邻元素的大小关系决定是否需要更新连续递增序列的开始下标。

具体而言，令 $\textit{start}$ 表示连续递增序列的开始下标，初始时 $\textit{start}=0$，然后遍历数组 $\textit{nums}$，进行如下操作。

- 如果下标 $i>0$ 且 $\textit{nums}[i] \le \textit{nums}[i-1]$，则说明当前元素小于或等于上一个元素，因此 $\textit{nums}[i-1]$ 和 $\textit{nums}[i]$ 不可能属于同一个连续递增序列，必须从下标 $i$ 处开始一个新的连续递增序列，因此令 $\textit{start}=i$。如果下标 $i=0$ 或 $\textit{nums}[i]>\textit{nums}[i-1]$，则不更新 $\textit{start}$ 的值。

- 此时下标范围 $[\textit{start},i]$ 的连续子序列是递增序列，其长度为 $i-\textit{start}+1$，使用当前连续递增序列的长度更新最长连续递增序列的长度。

遍历结束之后，即可得到整个数组的最长连续递增序列的长度。

```Java [sol1-Java]
class Solution {
    public int findLengthOfLCIS(int[] nums) {
        int ans = 0;
        int n = nums.length;
        int start = 0;
        for (int i = 0; i < n; i++) {
            if (i > 0 && nums[i] <= nums[i - 1]) {
                start = i;
            }
            ans = Math.max(ans, i - start + 1);
        }
        return ans;
    }
}
```

```JavaScript [sol1-JavaScript]
var findLengthOfLCIS = function(nums) {
    let ans = 0;
    const n = nums.length;
    let start = 0;
    for (let i = 0; i < n; i++) {
        if (i > 0 && nums[i] <= nums[i - 1]) {
            start = i;
        }
        ans = Math.max(ans, i - start + 1);
    }
    return ans;
};
```

```go [sol1-Golang]
func findLengthOfLCIS(nums []int) (ans int) {
    start := 0
    for i, v := range nums {
        if i > 0 && v <= nums[i-1] {
            start = i
        }
        ans = max(ans, i-start+1)
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

```C++ [sol1-C++]
class Solution {
public:
    int findLengthOfLCIS(vector<int>& nums) {
        int ans = 0;
        int n = nums.size();
        int start = 0;
        for (int i = 0; i < n; i++) {
            if (i > 0 && nums[i] <= nums[i - 1]) {
                start = i;
            }
            ans = max(ans, i - start + 1);
        }
        return ans;
    }
};
```

```C [sol1-C]
int findLengthOfLCIS(int* nums, int numsSize) {
    int ans = 0;
    int start = 0;
    for (int i = 0; i < numsSize; i++) {
        if (i > 0 && nums[i] <= nums[i - 1]) {
            start = i;
        }
        ans = fmax(ans, i - start + 1);
    }
    return ans;
}
```

```Python [sol1-Python3]
class Solution:
    def findLengthOfLCIS(self, nums: List[int]) -> int:
        ans = 0
        n = len(nums)
        start = 0

        for i in range(n):
            if i > 0 and nums[i] <= nums[i - 1]:
                start = i
            ans = max(ans, i - start + 1)
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要遍历数组一次。

- 空间复杂度：$O(1)$。额外使用的空间为常数。
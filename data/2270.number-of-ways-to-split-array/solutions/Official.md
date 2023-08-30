#### 方法一：枚举 + 前缀和

**思路与算法**

我们只需要枚举所有的分割位置，并找出其中的合法分割即可。

具体地，我们用 $\textit{left}$ 和 $\textit{right}$ 分别表示分割左侧和右侧的所有元素之和。初始时，$\textit{left} = 0$，$\textit{right}$ 的值为给定数组 $\textit{nums}$ 的所有元素之和。我们从小到大依次枚举每一个分割位置，当枚举到位置 $i$ 时，我们将 $\textit{left}$ 加上 $\textit{nums}[i]$，并将 $\textit{right}$ 减去 $\textit{nums}[i]$，这样就可以实时正确地维护分割左侧和右侧的元素之和。如果 $\textit{left} \geq \textit{right}$，那么就找出了一个合法分割。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int waysToSplitArray(vector<int>& nums) {
        int n = nums.size();
        long long left = 0, right = accumulate(nums.begin(), nums.end(), 0LL);
        int ans = 0;
        for (int i = 0; i < n - 1; ++i) {
            left += nums[i];
            right -= nums[i];
            if (left >= right) {
                ++ans;
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def waysToSplitArray(self, nums: List[int]) -> int:
        n, left, right = len(nums), 0, sum(nums)
        ans = 0
        for i in range(n - 1):
            left += nums[i]
            right -= nums[i]
            if left >= right:
                ans += 1
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：$O(1)$。
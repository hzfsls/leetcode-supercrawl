## [2176.统计数组中相等且可以被整除的数对 中文官方题解](https://leetcode.cn/problems/count-equal-and-divisible-pairs-in-an-array/solutions/100000/tong-ji-shu-zu-zhong-xiang-deng-qie-ke-y-tc4p)

#### 方法一：遍历数对

**思路与算法**

我们用 $n$ 表示数组 $\textit{nums}$ 的长度。为了统计符合要求数对数量，我们可以使用两层循环遍历所有满足 $0 \le i < j < n$ 的数对 $(i, j)$，并逐个检查 $i \times j \bmod k$ 是否等于 $0$，且 $\textit{nums}[i]$ 是否等于 $\textit{nums}[j]$。

与此同时，我们用 $\textit{res}$ 统计符合要求的数对数量，如果某个数对 $(i, j)$ 符合要求，则我们将 $\textit{res}$ 加上 $1$。最终，我们返回 $\textit{res}$ 作为符合要求的数对个数。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countPairs(vector<int>& nums, int k) {
        int n = nums.size();
        int res = 0;   // 符合要求数对个数
        for (int i = 0; i < n - 1; ++i) {
            for (int j = i + 1; j < n; ++j) {
                if ((i * j) % k == 0 && nums[i] == nums[j]) {
                    ++res;
                }
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def countPairs(self, nums: List[int], k: int) -> int:
        n = len(nums)
        res = 0   # 符合要求数对个数
        for i in range(n - 1):
            for j in range(i + 1, n):
                if (i * j) % k == 0 and nums[i] == nums[j]:
                    res += 1
        return res
```


**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 为 $\textit{nums}$ 数组的长度。即为遍历数对并统计符合要求个数的时间复杂度。

- 空间复杂度：$O(1)$。
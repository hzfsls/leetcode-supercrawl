## [2195.向数组中追加 K 个整数 中文官方题解](https://leetcode.cn/problems/append-k-integers-with-minimal-sum/solutions/100000/xiang-shu-zu-zhong-zhui-jia-k-ge-zheng-s-9vdv)

#### 方法一：排序

**思路与算法**

首先可以明确的是：最优的方法一定是从 $1$ 开始，依次往数组 $\textit{nums}$ 中添加未出现过的正整数，直到添加了 $k$ 个正整数为止。

因此，我们首先对数组 $\textit{nums}$ 进行升序排序，随后在数组的最前面添加元素 $0$，最后面添加元素 $\infty$。这样一来，我们从 $\textit{nums}$ 的第一个元素（首元素为第 $0$ 个元素）开始遍历。当遍历到 $\textit{nums}[i]$ 时，如果 $\textit{nums}[i-1] + 1 < \textit{nums}[i]$，那么我们就可以在 $[\textit{nums}[i-1] + 1, \textit{nums}[i] - 1]$ 的范围内添加正整数，总计 $\textit{nums}[i] - \textit{nums}[i-1] - 1$ 个。如果这个值小于 $k$，那么我们需要添加该范围内的全部正整数，并将 $k$ 减去这个值；否则我们只需要添加从 $\textit{nums}[i] + 1$ 开始的最小 $k$ 个正整数即可。此时，添加到数组中的所有正整数之和，即为 $1 + 2 + \cdots + (\textit{nums}[i-1] + k)$ 减去所有已完成遍历的元素之和。

**细节**

本题中有两个细节需要注意：

- 由于数组 $\textit{nums}$ 中的元素和 $k$ 均不超过 $10^9$，因此添加的正整数一定不会超过 $2 \times 10^9$，即我们可以用 $2 \times 10^9 + 1$ 代替 $\infty$。

- 由于数组 $\textit{nums}$ 中会出现重复的元素，因此在维护「所有已完成遍历的元素之和」时，不能计入重复的元素。即当 $\textit{nums}[i-1] = \textit{nums}[i]$ 时不能计入 $\textit{nums}[i]$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    long long minimalKSum(vector<int>& nums, int k) {
        nums.push_back(0);
        nums.push_back(int(2e9) + 1);
        sort(nums.begin(), nums.end());

        long long presum = 0, ans = 0;
        for (int i = 1; i < nums.size(); ++i) {
            int offer = nums[i] - nums[i - 1] - 1;
            if (offer > 0) {
                if (offer < k) {
                    k -= offer;
                }
                else {
                    ans = static_cast<long long>(nums[i - 1] + k + 1) * (nums[i - 1] + k) / 2 - presum;
                    break;
                }
            }
            if (nums[i] != nums[i - 1]) {
                presum += nums[i];
            }
        }

        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minimalKSum(self, nums: List[int], k: int) -> int:
        nums.extend([0, int(2e9) + 1])
        nums.sort()

        presum = 0
        ans = 0
        for i in range(1, len(nums)):
            offer = nums[i] - nums[i - 1] - 1
            if offer > 0:
                if offer < k:
                    k -= offer
                else:
                    ans = (nums[i - 1] + k + 1) * (nums[i - 1] + k) // 2 - presum
                    break
            if nums[i] != nums[i - 1]:
                presum += nums[i]
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度，即为排序需要的时间。

- 空间复杂度：$O(\log n)$，即为排序需要使用的栈空间。
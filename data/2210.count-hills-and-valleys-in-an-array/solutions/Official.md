## [2210.统计数组中峰和谷的数量 中文官方题解](https://leetcode.cn/problems/count-hills-and-valleys-in-an-array/solutions/100000/tong-ji-shu-zu-zhong-feng-he-gu-de-shu-l-ca7e)

#### 方法一：逐个判断

**思路与算法**

我们可以遍历数组 $\textit{nums}$ 判断并统计峰和谷的数量。具体地，我们判断除了数组首尾元素（首尾元素一定不可能是峰或谷）以外的每个下标 $i$ 是否为峰与谷的一部分。我们用 $\textit{res}$ 来维护这一数量。为了防止重复遍历，我们只判断每个可能的峰或谷的**第一个下标**，即当 $\textit{nums}[i] = \textit{nums}[i-1]$ 时，我们跳过该下标。

对于每个需要判断的下标 $i$，我们用整数 $\textit{left}$ 与 $\textit{right}$ 来表示它左右是否存在不相等邻居以及最近的不相等邻居与该元素的大小关系：其中 $1$ 代表邻居大于该元素，$-1$ 代表邻居小于该元素，$0$ 代表未找到或不存在该方向的不相等邻居。$\textit{left}$ 与 $\textit{right}$ 的初值均为 $0$。为了计算 $\textit{left}$ 的状态值，我们从下标 $i - 1$ 开始向左遍历，直至找到第一个不等于 $$\textit{nums}[i]$ 的元素（此时还需要按要求更新状态值）或到达数组开头。类似地，我们从下标 $i + 1$ 开始向右遍历计算 $\textit{right}$ 的值。

最终，下标 $i$ 为峰或谷的一部分**当且仅当** $\textit{left} = \textit{right}$ 且 $\textit{left} \not= 0$。如果满足这两个条件，则我们将 $\textit{res}$ 加上 $1$。当遍历完成数组后，$\textit{res}$ 即为数组峰与谷的数量，我们返回它作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countHillValley(vector<int>& nums) {
        int res = 0;   // 峰与谷的数量
        int n = nums.size();
        for (int i = 1; i < n - 1; ++i) {
            if (nums[i] == nums[i-1]) {
                // 去重
                continue;
            }
            int left = 0;   // 左边可能的不相等邻居对应状态
            for (int j = i - 1; j >= 0; --j) {
                if (nums[j] > nums[i]) {
                    left = 1;
                    break;
                } else if (nums[j] < nums[i]) {
                    left = -1;
                    break;
                }
            }
            int right = 0;   // 右边可能的不相等邻居对应状态
            for (int j = i + 1; j < n; ++j) {
                if (nums[j] > nums[i]) {
                    right = 1;
                    break;
                } else if (nums[j] < nums[i]) {
                    right = -1;
                    break;
                }
            }
            if (left == right && left != 0) {
                // 此时下标 i 为峰或谷的一部分
                ++res;
            }
        }
        return res;   
    }
};
```


```Python [sol1-Python3]
class Solution:
    def countHillValley(self, nums: List[int]) -> int:
        res = 0   # 峰与谷的数量
        n = len(nums)
        for i in range(1, n - 1):
            if nums[i] == nums[i-1]:
                # 去重
                continue
            left = 0   # 左边可能的不相等邻居对应状态
            for j in range(i - 1, -1, -1):
                if nums[j] > nums[i]:
                    left = 1
                    break
                elif nums[j] < nums[i]:
                    left = -1
                    break
            right = 0   # 右边可能的不相等邻居对应状态
            for j in range(i + 1, n):
                if nums[j] > nums[i]:
                    right = 1
                    break
                elif nums[j] < nums[i]:
                    right = -1
                    break
            if left == right and left != 0:
                # 此时下标 i 为峰或谷的一部分
                res += 1
        return res
```


**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 为 $\textit{nums}$ 的长度。对于每个元素，判断是否为峰或者谷的时间复杂度为 $O(n)$。

- 空间复杂度：$O(1)$。
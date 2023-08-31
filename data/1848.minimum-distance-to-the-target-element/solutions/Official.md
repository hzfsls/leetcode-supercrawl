## [1848.到目标元素的最小距离 中文官方题解](https://leetcode.cn/problems/minimum-distance-to-the-target-element/solutions/100000/dao-mu-biao-yuan-su-de-zui-xiao-ju-chi-b-v4ce)
#### 方法一：模拟

**思路与算法**

我们对 $\textit{nums}$ 进行遍历，并在遍历的过程中用 $\textit{res}$ 来维护满足要求的 $|i - \textit{start}|$ 的最小值。

注意 $\textit{res}$ 的初始值需要大于等于 $|i - \textit{start}|$ 的最大可能值，即 $\textit{nums.length} - 1$。在下面的代码中，我们选择值 $\textit{nums.length}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int getMinDistance(vector<int>& nums, int target, int start) {
        int res = nums.size();
        for (int i = 0; i < nums.size(); ++i){
            if (nums[i] == target){
                res = min(res, abs(i - start));
            }
        }
        return res;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def getMinDistance(self, nums: List[int], target: int, start: int) -> int:
        res = len(nums)
        for i, num in enumerate(nums):
            if num == target:
                res = min(res, abs(i - start))
        return res
```

**复杂度分析**

- 时间复杂度：$O(n)$，即为遍历数组的时间复杂度。

- 空间复杂度：$O(1)$。
#### 方法一：遍历

**思路与算法**

一个数与 $0$ 的距离即为该数的绝对值，因此我们需要找出数组 $\textit{nums}$ 里面绝对值最小的元素的最大值。

我们遍历数组，并用 $\textit{res}$ 来维护已遍历元素中绝对值最小且数值最大的元素，以及 $\textit{dis}$ 来维护已遍历元素的最小绝对值。这两个变量的初值即为数组第一个元素的数值与绝对值。

当我们遍历到新的元素 $\textit{num}$ 时，我们需要比较该数绝对值 $|\textit{num}|$ 与 $\textit{dis}$ 的关系，此时会有三种情况:

- $|\textit{num}| < \textit{dis}$，此时我们需要将 $\textit{res}$ 更新为 $\textit{num}$，并将 $\textit{dis}$ 更新为 $|\textit{num}|$；

- $|\textit{num}| = \textit{dis}$，此时我们需要将 $\textit{res}$ 更新为 $\textit{res}$ 与 $\textit{num}$ 的最大值；

- $|\textit{num}| > \textit{dis}$，此时无需进行任何操作。

最终，$\textit{res}$ 即为数组 $\textit{nums}$ 里面绝对值最小的元素的最大值，我们返回该值作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int findClosestNumber(vector<int>& nums) {
        int res = nums[0];   // 已遍历元素中绝对值最小且数值最大的元素
        int dis = abs(nums[0]);   // 已遍历元素的最小绝对值
        for (int num: nums) {
            if (abs(num) < dis) {
                dis = abs(num);
                res = num;
            } else if (abs(num) == dis) {
                res = max(res, num);
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def findClosestNumber(self, nums: List[int]) -> int:
        res = nums[0]   # 已遍历元素中绝对值最小且数值最大的元素
        dis = abs(nums[0])   # 已遍历元素的最小绝对值
        for num in nums:
            if abs(num) < dis:
                dis = abs(num)
                res = num
            elif abs(num) == dis:
                res = max(res, num)
        return res
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{nums}$ 的长度。即为遍历寻找对应数字的时间复杂度。

- 空间复杂度：$O(1)$。
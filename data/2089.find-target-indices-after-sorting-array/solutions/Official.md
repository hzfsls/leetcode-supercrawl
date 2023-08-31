## [2089.找出数组排序后的目标下标 中文官方题解](https://leetcode.cn/problems/find-target-indices-after-sorting-array/solutions/100000/zhao-chu-shu-zu-pai-xu-hou-de-mu-biao-xi-2o22)
#### 方法一：排序后遍历

**思路与算法**

我们首先按要求对 $\textit{nums}$ 数组升序排序，随后从左到右遍历数组中的所有元素，并按顺序记录所有数值等于 $\textit{target}$ 的元素的下标。这样我们可以保证记录的下标数组中的下标（如果存在）必定按照递增顺序排列。

最后，如果符合要求的下标存在，我们返回记录的下标数组作为答案；如果不存在，我们返回空数组即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> targetIndices(vector<int>& nums, int target) {
        int n = nums.size();
        sort(nums.begin(), nums.end());
        vector<int> res;
        for (int i = 0; i < n; ++i){
            if (nums[i] == target){
                res.push_back(i);
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def targetIndices(self, nums: List[int], target: int) -> List[int]:
        n = len(nums)
        nums.sort()
        res = []
        for i in range(n):
            if nums[i] == target:
                res.append(i)
        return res
```


**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为 $\textit{nums}$ 的长度。排序的时间复杂度为 $O(n \log n)，遍历记录目标下标数组的时间复杂度为 $O(n)$。

- 空间复杂度：$O(\log n)$，即为排序的栈空间开销。


#### 方法二：直接统计数量

**思路与算法**

我们也可以不对数组排序来构造目标下标。

在排序后数组中，这些数值等于 $\textit{target}$ 的元素的下标（如果存在）一定是**连续**的。因此，我们可以通过寻找目标下标的**左边界**（即最小值，如果存在，下同）和目标下标的**数量**来构造目标下标数组。

由于数组是升序排序的，数值等于 $\textit{target}$ 的元素一定在数值小于 $\textit{target}$ 的元素的右侧，因此目标下标的左边界即为数组中数值**小于** $\textit{target}$ 的元素数量。而目标下标的数量即为数组中数值**等于** $\textit{target}$ 的元素数量。

我们遍历未排序的数组，计算数值小于 $\textit{target}$ 的元素数量 $\textit{cnt}_1$ 与数值等于 $\textit{target}$ 的元素数量 $\textit{cnt}_2$，则此时目标下标即为 $[\textit{cnt}_1, \textit{cnt}_1 + \textit{cnt}_2)$ 左闭右开区间内的所有整数。我们按照递增的顺序构造对应的下标数组（可能为空）并返回即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> targetIndices(vector<int>& nums, int target) {
        int cnt1 = 0;   // 小于 target 的元素数量
        int cnt2 = 0;   // 等于 target 的元素数量
        for (const int num: nums){
            if (num < target){
                ++cnt1;
            }
            else if (num == target){
                ++cnt2;
            }
        }
        vector<int> res;   // 下标数组
        for (int i = cnt1; i < cnt1 + cnt2; ++i){
            res.push_back(i);
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def targetIndices(self, nums: List[int], target: int) -> List[int]:
        cnt1 = 0   # 小于 target 的元素数量
        cnt2 = 0   # 等于 target 的元素数量
        for num in nums:
            if num < target:
                cnt1 += 1
            elif num == target:
                cnt2 += 1
        res = list(range(cnt1, cnt1 + cnt2))   # 下标数组
        return res
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{nums}$ 的长度。遍历统计元素数量和构造数组时间复杂度为 $O(n)$。

- 空间复杂度：$O(1)$，输出数组不计入空间复杂度。
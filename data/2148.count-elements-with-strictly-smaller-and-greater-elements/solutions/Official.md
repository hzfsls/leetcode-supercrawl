## [2148.元素计数 中文官方题解](https://leetcode.cn/problems/count-elements-with-strictly-smaller-and-greater-elements/solutions/100000/yuan-su-ji-shu-by-leetcode-solution-uk3a)
#### 方法一：按要求判断

**思路与算法**

对于数组中的一个元素，它「同时具有一个严格较小元素和一个严格较大元素」等价于它「既不等于数组中的最大值，也不等于数组中元素的最小值」。

因此我们可以首先遍历数组 $\textit{nums}$，求出数组元素的最大值 $\textit{largest}$ 与最小值 $\textit{smallest}$。随后，我们遍历数组中的元素 $\textit{num}$，统计满足 $\textit{smallest} < \textit{num} < \textit{largest}$ 的元素数目。最终，该数目即为数组中「同时具有一个严格较小元素和一个严格较大元素」的元素数量，我们返回该数目作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countElements(vector<int>& nums) {
        int smallest = *min_element(nums.begin(), nums.end());
        int largest = *max_element(nums.begin(), nums.end());
        int res = 0;
        for (int num: nums) {
            if (smallest < num && num < largest) {
                ++res;
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def countElements(self, nums: List[int]) -> int:
        smallest = min(nums)
        largest = max(nums)
        res = 0
        for num in nums:
            if smallest < num < largest:
                res += 1
        return res
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{nums}$ 的长度。其中求出数组最大值与最小值的时间复杂度为 $O(n)$，计算符合要求元素数目的时间复杂度也为 $O(n)$。

- 空间复杂度：$O(1)$。
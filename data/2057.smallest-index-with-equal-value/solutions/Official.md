## [2057.值相等的最小索引 中文官方题解](https://leetcode.cn/problems/smallest-index-with-equal-value/solutions/100000/zhi-xiang-deng-de-zui-xiao-suo-yin-by-le-0bbn)

#### 方法一：顺序遍历数组

**思路与算法**

我们可以**顺序遍历**数组 $\textit{nums}$ 的下标 $i$，检查 $i \bmod 10 = \textit{nums}[i]$ 是否成立。

如果成立，则该下标即为值相等的最小索引，我们返回该下标作为答案。若遍历完整个数组均未找到符合要求的下标，则返回 $-1$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int smallestEqual(vector<int>& nums) {
        int n = nums.size();
        for (int i = 0; i < n; ++i){
            if (i % 10 == nums[i]){
                return i;
            }
        }
        return -1;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def smallestEqual(self, nums: List[int]) -> int:
        n = len(nums)
        for i in range(n):
            if i % 10 == nums[i]:
                return i
        return -1
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{nums}$ 的长度。即为遍历数组寻找符合要求的最小索引的时间复杂度。

- 空间复杂度：$O(1)$。
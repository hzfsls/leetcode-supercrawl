## [2164.对奇偶下标分别排序 中文官方题解](https://leetcode.cn/problems/sort-even-and-odd-indices-independently/solutions/100000/dui-qi-ou-xia-biao-fen-bie-pai-xu-by-lee-31wr)
#### 方法一：按要求操作

**思路与算法**

我们可以用 $\textit{even}$ 和 $\textit{odd}$ 两个辅助数组分别存储数组 $\textit{nums}$ 的奇偶下标元素，随后对两个数组按要求排序：$\textit{even}$ 升序排序，$\textit{odd}$ 降序排序。最终，我们将排序后的 $\textit{even}$ 和 $\textit{odd}$ 数组的元素交替放回 $\textit{nums}$ 中，具体地：

- $\textit{nums}[2i] = \textit{even}[i]$，

- $\textit{nums}[2i+1] = \textit{odd}[i]$

最终，我们返回更新后的 $\textit{nums}$ 数组作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> sortEvenOdd(vector<int>& nums) {
        vector<int> even, odd;
        for (int i = 0; i < nums.size(); ++i) {
            if (i % 2 == 0) {
                even.push_back(nums[i]);
            }
            else {
                odd.push_back(nums[i]);
            }
        }
        sort(even.begin(), even.end());
        sort(odd.begin(), odd.end(), greater<int>());
        for (int i = 0; i < even.size(); ++i) {
            nums[2*i] = even[i];
        }
        for (int i = 0; i < odd.size(); ++i) {
            nums[2*i+1] = odd[i];
        }
        return nums;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def sortEvenOdd(self, nums: List[int]) -> List[int]:
        even = sorted(nums[::2])
        odd = sorted(nums[1::2])[::-1]
        nums[::2] = even
        nums[1::2] = odd
        return nums
```


**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为 $\textit{nums}$ 的长度。即为对数组奇偶下标分别排序的时间复杂度。

- 空间复杂度：$O(n)$，即为辅助数组的空间开销。
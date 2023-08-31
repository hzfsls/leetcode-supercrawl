## [2161.根据给定数字划分数组 中文官方题解](https://leetcode.cn/problems/partition-array-according-to-given-pivot/solutions/100000/gen-ju-gei-ding-shu-zi-hua-fen-shu-zu-by-372i)

#### 方法一：双指针

**思路与算法**

我们可以对数组 $\textit{nums}$ 进行一次遍历，并使用两个指针 $\textit{left}$ 和 $\textit{right}$ 来更新答案数组。答案数组长度与 $\textit{nums}$ 的长度相同，初始时，$\textit{left}$ 和 $\textit{right}$ 分别指向答案数组的最左端和最右端。

在对 $\textit{nums}$ 进行遍历时，记当前遍历到的数为 $x$。如果 $x < \textit{pivot}$，我们就将 $x$ 放入左指针的位置，并将左指针向右移动一个位置；如果 $x > \textit{pivot}$，我们就将 $x$ 放入右指针的位置，并将右指针向左移动一个位置。

在遍历结束之后，我们需要注意两点：

- 对于所有与 $\textit{pivot}$ 相等的元素，我们并没有进行处理。我们可以在初始化答案数组时，直接将所有元素赋值为 $\textit{pivot}$ 来避免额外的处理；

- 对于严格大于 $\textit{pivot}$ 的元素，题目中要求它们的「相对顺序」不能发生改变，因此需要将这些元素在答案数组中对应的段进行反转。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> pivotArray(vector<int>& nums, int pivot) {
        int n = nums.size();
        vector<int> ans(n, pivot);
        int left = 0, right = n - 1;
        for (int i = 0; i < n; ++i) {
            if (nums[i] < pivot) {
                ans[left] = nums[i];
                ++left;
            }
            else if (nums[i] > pivot) {
                ans[right] = nums[i];
                --right;
            }
        }
        reverse(ans.begin() + right + 1, ans.end());
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def pivotArray(self, nums: List[int], pivot: int) -> List[int]:
        n = len(nums)
        ans = [pivot] * n
        left, right = 0, n - 1

        for i in range(n):
            if nums[i] < pivot:
                ans[left] = nums[i]
                left += 1
            elif nums[i] > pivot:
                ans[right] = nums[i]
                right -= 1
        
        x, y = right + 1, n - 1
        while x < y:
            ans[x], ans[y] = ans[y], ans[x]
            x += 1
            y -= 1
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$。这里不考虑答案数组需要使用的空间。
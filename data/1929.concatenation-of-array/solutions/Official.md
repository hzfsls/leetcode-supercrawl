#### 方法一：按要求串联

**思路与算法**

我们顺序遍历**修改前** $\textit{nums}$ 数组的元素，并按顺序添加至 $\textit{nums}$ 数组的尾部。最终，**修改后**的 $\textit{nums}$ 数组即为串联形成的数组，我们返回该数组作为答案。

对于 $\texttt{Python}$ 语言，我们可以直接使用 $\texttt{list}$ 的 $\textit{extend}()$ 方法实现串联操作。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> getConcatenation(vector<int>& nums) {
        int n = nums.size();
        for (int i = 0; i < n; ++i){
            nums.push_back(nums[i]);
        }
        return nums;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def getConcatenation(self, nums: List[int]) -> List[int]:
        nums.extend(nums)
        return nums
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{nums}$ 的长度。即为遍历与串联的时间复杂度。

- 空间复杂度：$O(1)$，输出数组不计入空间复杂度。
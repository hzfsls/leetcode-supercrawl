## [1437.是否所有 1 都至少相隔 k 个元素 中文官方题解](https://leetcode.cn/problems/check-if-all-1s-are-at-least-length-k-places-away/solutions/100000/shi-fou-suo-you-1-du-zhi-shao-xiang-ge-k-bxwl)

#### 方法一：遍历

「所有 $1$ 都至少相隔 $k$ 个元素」等价于「任意两个相邻的 $1$ 都至少相隔 $k$ 个元素」，因此我们只需要从左到右遍历数组，并记录上一个 $1$ 出现的位置。

在遍历的过程中，如果我们找到了一个新的 $1$，就需要判断其与上一个 $1$ 之间是否至少相隔 $k$ 个元素。如果不满足要求，那么直接返回 `False` 作为答案，否则继续进行遍历。

在遍历完成之后即可返回 `True` 作为答案。

```C++ [sol1-C++]
class Solution {
public:
    bool kLengthApart(vector<int>& nums, int k) {
        int n = nums.size();
        int prev = -1;
        for (int i = 0; i < n; ++i) {
            if (nums[i] == 1) {
                if (prev != -1 && i - prev - 1 < k) {
                    return false;
                }
                prev = i;
            }
        }
        return true;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def kLengthApart(self, nums: List[int], k: int) -> bool:
        n = len(nums)
        prev = -1
        for i in range(n):
            if nums[i] == 1:
                if prev != -1 and i - prev - 1 < k:
                    return False
                prev = i
        return True
```

```Java [sol1-Java]
class Solution {
    public boolean kLengthApart(int[] nums, int k) {
        int n = nums.length;
        int prev = -1;
        for (int i = 0; i < n; ++i) {
            if (nums[i] == 1) {
                if (prev != -1 && i - prev - 1 < k) {
                    return false;
                }
                prev = i;
            }
        }
        return true;
    }
}
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$。
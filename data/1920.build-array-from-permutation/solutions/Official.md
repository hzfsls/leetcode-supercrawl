## [1920.基于排列构建数组 中文官方题解](https://leetcode.cn/problems/build-array-from-permutation/solutions/100000/ji-yu-pai-lie-gou-jian-shu-zu-by-leetcod-gjcn)
#### 方法一：按要求构建

**思路与算法**

我们可以构建一个与原数组 $\textit{nums}$ 等长的新数组，同时令新数组中下标为 $i$ 的元素等于 $\textit{nums}[\textit{nums}[i]]$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> buildArray(vector<int>& nums) {
        int n = nums.size();
        vector<int> ans;
        for (int i = 0; i < n; ++i){
            ans.push_back(nums[nums[i]]);
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def buildArray(self, nums: List[int]) -> List[int]:
        n = len(nums)
        return [nums[nums[_]] for _ in range(n)]
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{nums}$ 的长度。即为构建新数组的时间复杂度。

- 空间复杂度：$O(1)$，输出数组不计入空间复杂度。


#### 方法二：原地构建

**思路与算法**

我们也可以直接对原数组 $\textit{nums}$ 进行修改。

为了使得构建过程可以完整进行，我们需要让 $\textit{nums}$ 中的每个元素 $\textit{nums}[i]$ 能够同时存储「当前值」（即 $\textit{nums}[i]$）和「最终值」（即 $\textit{nums}[\textit{nums}[i]]$）。

我们注意到 $\textit{nums}$ 中元素的取值范围为 $[0, 999]$ 闭区间，这意味着 $\textit{nums}$ 中的每个元素的「当前值」和「最终值」都在 $[0, 999]$ 闭区间内。

因此，我们可以使用类似「$1000$ 进制」的思路来表示每个元素的「当前值」和「最终值」。对于每个元素，我们用它除以 $1000$ 的商数表示它的「最终值」，而用余数表示它的「当前值」。

那么，我们首先遍历 $\textit{nums}$，计算每个元素的「最终值」，并乘以 $1000$ 加在该元素上。随后，我们再次遍历数组，并将每个元素的值除以 $1000$ 保留其商数。此时 $\textit{nums}$ 即为构建完成的数组，我们返回该数组作为答案。

**细节**

在计算 $\textit{nums}[i]$ 的「最终值」并修改该元素时，我们需要计算**修改前** $\textit{nums}[\textit{nums}[i]]$ 的值，而 $\textit{nums}$ 中下标为 $\textit{nums}[i]$ 的元素可能已被修改，因此我们需要将取下标得到的值对 $1000$ 取模得到「最终值」。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> buildArray(vector<int>& nums) {
        int n = nums.size();
        // 第一次遍历编码最终值
        for (int i = 0; i < n; ++i){
            nums[i] += 1000 * (nums[nums[i]] % 1000);
        }
        // 第二次遍历修改为最终值
        for (int i = 0; i < n; ++i){
            nums[i] /= 1000;
        }
        return nums;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def buildArray(self, nums: List[int]) -> List[int]:
        n = len(nums)
        # 第一次遍历编码最终值
        for i in range(n):
            nums[i] += 1000 * (nums[nums[i]] % 1000) 
        # 第二次遍历修改为最终值
        for i in range(n):
            nums[i] //= 1000
        return nums
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{nums}$ 的长度。我们遍历了两次 $\textit{nums}$ 数组并进行修改，每次遍历并修改的时间复杂度均为 $O(n)$。

- 空间复杂度：$O(1)$。
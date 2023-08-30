#### 方法一：双指针

**思路与算法**

我们可以使用两个指针对数组 $\textit{left}$ 进行遍历，其中指针 $\textit{pos}$ 负责遍历所有的正数，指针 $\textit{neg}$ 负责遍历所有的负数。

记数组 $\textit{nums}$ 的长度为 $n$，那么其中分别包含 $n/2$ 个正数和负数。因此我们只需要重复如下操作 $n/2$ 次：

- 指针 $\textit{pos}$ 不断向后移动，直到遇到一个正数为止，并将该正数放入答案数组；

- 指针 $\textit{neg}$ 不断向后移动，直到遇到一个负数为止，并将该负数放入答案数组。

$\textit{pos}$ 和 $\textit{neg}$ 初识时均指向 $\textit{nums}$ 的首个元素。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> rearrangeArray(vector<int>& nums) {
        int n = nums.size();
        int pos = 0, neg = 0;
        vector<int> ans;
        for (int i = 0; i + i < n; ++i) {
            while (nums[pos] < 0) {
                ++pos;
            }
            ans.push_back(nums[pos]);
            ++pos;
            while (nums[neg] > 0) {
                ++neg;
            }
            ans.push_back(nums[neg]);
            ++neg;
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def rearrangeArray(self, nums: List[int]) -> List[int]:
        n = len(nums)
        pos = neg = 0
        ans = list()

        for i in range(n // 2):
            while nums[pos] < 0:
                pos += 1
            ans.append(nums[pos])
            pos += 1
            while nums[neg] > 0:
                neg += 1
            ans.append(nums[neg])
            neg += 1
        
        return ans
```

```Golang [sol1-Golang]
func rearrangeArray(nums []int) []int {
	n := len(nums)
	pos, neg, ans := 0, 0, []int{}

	for i := 0; i+i < n; i++ {
		for ; nums[pos] < 0; pos++ {
		}
		ans = append(ans, nums[pos])
		pos++
		for ; nums[neg] > 0; neg++ {
		}
		ans = append(ans, nums[neg])
		neg++
	}

	return ans
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$。这里不计入返回值需要使用的空间。
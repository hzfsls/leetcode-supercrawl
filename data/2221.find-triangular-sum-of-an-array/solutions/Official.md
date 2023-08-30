#### 方法一：模拟

**思路与算法**

我们只需要按照题目中的操作进行模拟即可。

记数组 $\textit{nums}$ 的长度为 $n$。我们进行 $n-1$ 次循环，第 $i~(0 \leq i < n)$ 次循环得到 $(\textit{nums}[i] + \textit{nums}[i+1]) \bmod 10$ 的值，并将其放去一个新的数组 $\textit{new\_nums}$ 中。当循环结束后，我们再用 $\textit{new\_nums}$ 覆盖 $\textit{nums}$。

当 $n=1$ 时，操作结束，我们返回 $\textit{nums}[0]$ 即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int triangularSum(vector<int>& nums) {
        while (nums.size() > 1) {
            vector<int> new_nums;
            for (int i = 0; i < nums.size() - 1; ++i) {
                new_nums.push_back((nums[i] + nums[i + 1]) % 10);
            }
            nums = move(new_nums);
        }
        return nums[0];
    }
};
```

```Python [sol1-Python3]
class Solution:
    def triangularSum(self, nums: List[int]) -> int:
        while len(nums) > 1:
            new_nums = list()
            for i in range(len(nums) - 1):
                new_nums.append((nums[i] + nums[i + 1]) % 10)
            nums = new_nums
        return nums[0]
```

**复杂度分析**

- 时间复杂度：$O(n^2)$。

- 空间复杂度：$O(n)$，即数组 $\textit{new\_nums}$ 需要使用的空间。
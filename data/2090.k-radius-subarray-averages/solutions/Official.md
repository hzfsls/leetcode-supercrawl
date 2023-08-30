#### 方法一：一次遍历

**思路与算法**

根据题目描述，只有当中心位置 $i \in [k, n-k-1]$ 时，整个长度为 $2k+1$ 的子区间才会完整地落在数组 $\textit{nums}$ 内部。当 $i < k$ 或者 $i \geq n-k$ 时，对应的平均值为 $-1$。

因此如果 $k \geq n-k-1$ 即 $2k+1 \geq n$，答案数组中所有的元素均为 $-1$。否则，我们首先计算出数组 $\textit{nums}$ 的前 $2k+1$ 个元素的和，放在答案数组的 $\textit{ans}[k]$ 中。由于：

$$
\left\{
\begin{aligned}
& \textit{ans}[i - 1] && = \textit{nums}[i - k - 1] + \textit{nums}[i - k] + \cdots + \textit{nums}[i + k - 1] \\
& \textit{ans}[i] && = \textit{nums}[i - k] + \cdots + \textit{nums}[i + k - 1] + \textit{nums}[i + k]
\end{aligned}
\right.
$$

因此随后只需要通过递推式：

$$
\textit{ans}[i] = \textit{ans}[i - 1] + \textit{nums}[i + k] - \textit{nums}[i - k - 1]
$$

即可得到所有中心位置 $i \in [k, n-k-1]$ 且长度为 $2k+1$ 的子数组的和。最后将每一个和除以 $2k+1$ 即可得到平均数。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> getAverages(vector<int>& nums, int k) {
        int n = nums.size();
        vector<int> ans(n, -1);
        if (k * 2 + 1 <= n) {
            long long sum = accumulate(nums.begin(), nums.begin() + k * 2 + 1, 0LL);
            for (int i = k; i + k < n; ++i) {
                if (i != k) {
                    sum += nums[i + k] - nums[i - k - 1];
                }
                ans[i] = sum / (k * 2 + 1);
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def getAverages(self, nums: List[int], k: int) -> List[int]:
        n = len(nums)
        ans = [-1] * n
        if k * 2 + 1 <= n:
            total = sum(nums[:k * 2 + 1])
            for i in range(k, n - k):
                if i != k:
                    total += nums[i + k] - nums[i - k - 1]
                ans[i] = total // (k * 2 + 1)
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：$O(1)$，这里不计算返回值数组 $\textit{ans}$ 需要的空间。
#### 方法一：逆向思维

**提示 $1$**

一种常规的思路是枚举数组 $\textit{nums}$ 中的两个元素 $x$ 和 $y$，计算 $\lfloor \dfrac{x}{y} \rfloor$ 并求和。但这样做的时间复杂度为 $O(n^2)$，会超出时间限制。

与其枚举 $x$ 和 $y$，我们不妨枚举 $y$ 和 $\lfloor \dfrac{x}{y} \rfloor$。

**提示 $2$**

令 $d = \lfloor \dfrac{x}{y} \rfloor$。如果我们枚举 $y$ 和 $d$，那么满足要求的 $x$ 应当在：

$$
d \cdot y \leq x < (d+1) \cdot y
$$

的范围内。

如果我们能统计出该范围内 $x$ 的个数，那么将其乘以 $d$ 再乘以 $y$ 出现的次数，将它们进行求和即可得到最终的答案。

**思路与算法**

我们首先用 $\textit{cnt}[x]$ 统计元素 $x$ 在 $\textit{nums}$ 中出现的次数。记 $\textit{upper}$ 为数组 $\textit{nums}$ 中元素的最大值。

随后我们使用两重循环分别枚举 $y$ 和 $d$。其中枚举 $y$ 的循环的范围为 $[1, \textit{upper}]$，枚举 $d$ 的循环的范围为 $[1, \lfloor \dfrac{\textit{upper}}{y} \rfloor]$。根据提示 $2$，满足要求的 $x$ 的数量为：

$$
\sum_{x=d \cdot y}^{\min \{ (d+1) \cdot y-1, \textit{upper} \}} \textit{cnt}[x]
$$

虽然 $x$ 的上界是 $(d+1)\cdot y - 1$，但是它显然也不能超过 $\textit{upper}$。由于这一段求和的下标范围 $x$ 是连续的，因此我们可以预处理出数组 $\textit{cnt}$ 的前缀和，记：

$$
\textit{pre}[i] = \sum_{x=1}^i \textit{cnt}[i]
$$

那么上式可以变为：

$$
\textit{pre}\big[\min \{ (d+1) \cdot y-1, \textit{upper} \}\big] - \textit{pre}[d \cdot y - 1]
$$

就可以在 $O(1)$ 的时间求出上式的值。

这样一来，将上式乘以 $\textit{cnt}[y] \cdot d$，再随着两重循环进行求和即可得到最终的答案。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int mod = 1000000007;
    
    using LL = long long;

public:
    int sumOfFlooredPairs(vector<int>& nums) {
        // 元素最大值
        int upper = *max_element(nums.begin(), nums.end());
        vector<int> cnt(upper + 1);
        for (int num: nums) {
            ++cnt[num];
        }
        // 预处理前缀和
        vector<int> pre(upper + 1);
        for (int i = 1; i <= upper; ++i) {
            pre[i] = pre[i - 1] + cnt[i];
        }
        
        LL ans = 0;
        for (int y = 1; y <= upper; ++y) {
            // 一个小优化，如果数组中没有 y 可以跳过
            if (cnt[y]) {
                for (int d = 1; d * y <= upper; ++d) {
                    ans += (LL)cnt[y] * d * (pre[min((d + 1) * y - 1, upper)] - pre[d * y - 1]);
                }
            }
        }
        return ans % mod;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def sumOfFlooredPairs(self, nums: List[int]) -> int:
        mod = 10**9 + 7
        
        # 元素最大值
        upper = max(nums)
        cnt = [0] * (upper + 1)
        for num in nums:
            cnt[num] += 1
        # 预处理前缀和
        pre = [0] * (upper + 1)
        for i in range(1, upper + 1):
            pre[i] = pre[i - 1] + cnt[i]
        
        ans = 0
        for y in range(1, upper + 1):
            # 一个小优化，如果数组中没有 y 可以跳过
            if cnt[y]:
                d = 1
                while d * y <= upper:
                    ans += cnt[y] * d * (pre[min((d + 1) * y - 1, upper)] - pre[d * y - 1])
                    d += 1
        return ans % mod
```

**复杂度分析**

- 时间复杂度：$O(n + C\log C)$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$C$ 是数组 $\textit{nums}$ 中的元素最大值，在本题中 $C \leq 2\cdot 10^5$。

    - 计算数组 $\textit{cnt}$ 以及预处理前缀和数组 $\textit{pre}$ 需要的时间为 $O(n + C)$；

    - 在使用两重循环枚举 $y$ 和 $d$ 时，循环执行的次数为：

        $$
        \sum_{y=1}^\textit{C} \sum_{d=1}^{\lfloor C/y \rfloor} 1 = O\left(\sum_{y=1}^\textit{C} \frac{C}{y} \right)
        $$

        为调和级数，其趋近于 $O(C \log C)$。
    
    因此总时间复杂度为 $O(n + C\log C)$。

- 空间复杂度：$O(C)$，即为数组 $\textit{cnt}$ 和 $\textit{pre}$ 需要使用的空间。
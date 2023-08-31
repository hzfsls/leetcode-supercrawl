## [1493.删掉一个元素以后全为 1 的最长子数组 中文官方题解](https://leetcode.cn/problems/longest-subarray-of-1s-after-deleting-one-element/solutions/100000/shan-diao-yi-ge-yuan-su-yi-hou-quan-wei-1-de-zui-c)
#### 方法一：递推

**思路**

在删掉元素的结果数组中，最长的且只包含 $1$ 的非空子数组存在两种情况：

+ 这个子数组在原数组中本身就是连续的，无论删或者不删其他的元素，它都是最长的且只包含 $1$ 的非空子数组；

+ 这个子数组原本不连续，而是两个连续的全 $1$ 子数组，中间夹着一个 $0$，把这个 $0$ 删掉以后，左右两个子数组组合成一个最长的且只包含 $1$ 的非空子数组。

我们可以枚举被删除的位置，假设下标为 $i$，我们希望知道「以第 $i - 1$ 位结尾的最长连续全 $1$ 子数组」和「以第 $i + 1$ 位开头的最长连续全 $1$ 子数组」的长度分别是多少，这两个量的和就是删除第 $i$ 位之后最长的且只包含 $1$ 的非空子数组的长度。假设我们可以得到这两个量，我们只要枚举所有的 $i$，就可以得到最终的答案。

我们可以这样维护「以第 $i - 1$ 位结尾的最长连续全 $1$ 子数组」和「以第 $i + 1$ 位开头的最长连续全 $1$ 子数组」的长度：

+ 记原数组为 $a$

+ 记 ${\rm pre}(i)$ 为「以第 $i$ 位结尾的最长连续全 $1$ 子数组」，那么

  $$ {\rm pre}(i) = \left\{ \begin{aligned}  & 0 , & a_i = 0 \\ & {\rm pre}(i - 1) + 1 , & a_i = 1  \end{aligned} \right.$$

+ 记 ${\rm suf}(i)$ 为「以第 $i$ 位开头的最长连续全 $1$ 子数组」，那么

  $$ {\rm suf}(i) = \left\{ \begin{aligned}     & 0 , & a_i = 0 \\    & {\rm suf}(i + 1) + 1 , & a_i = 1    \end{aligned} \right.$$

我们可以对原数组做一次正向遍历，预处理出 $\rm pre$，再做一次反向遍历，预处理出 $\rm suf$。最后我们枚举所有的元素作为待删除的元素，计算出删除这些元素之后最长的且只包含 $1$ 的非空子数组的长度，比较并取最大值。

代码如下。

**算法**

```C++ [sol1-C++]
class Solution {
public:
    int longestSubarray(vector<int>& nums) {
        int n = nums.size();

        vector<int> pre(n), suf(n);

        pre[0] = nums[0];
        for (int i = 1; i < n; ++i) {
            pre[i] = nums[i] ? pre[i - 1] + 1 : 0; 
        }

        suf[n - 1] = nums[n - 1];
        for (int i = n - 2; i >= 0; --i) {
            suf[i] = nums[i] ? suf[i + 1] + 1 : 0;
        }

        int ans = 0;
        for (int i = 0; i < n; ++i) {
            int preSum = i == 0 ? 0 : pre[i - 1];
            int sufSum = i == n - 1 ? 0 : suf[i + 1];
            ans = max(ans, preSum + sufSum);
        }

        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int longestSubarray(int[] nums) {
        int n = nums.length;

        int[] pre = new int[n];
        int[] suf = new int[n];

        pre[0] = nums[0];
        for (int i = 1; i < n; ++i) {
            pre[i] = nums[i] != 0 ? pre[i - 1] + 1 : 0; 
        }

        suf[n - 1] = nums[n - 1];
        for (int i = n - 2; i >= 0; --i) {
            suf[i] = nums[i] != 0 ? suf[i + 1] + 1 : 0;
        }

        int ans = 0;
        for (int i = 0; i < n; ++i) {
            int preSum = i == 0 ? 0 : pre[i - 1];
            int sufSum = i == n - 1 ? 0 : suf[i + 1];
            ans = Math.max(ans, preSum + sufSum);
        }

        return ans;
    }
}
```

**复杂度**

假设原数组长度为 $n$。

+ 时间复杂度：$O(n)$。这里对原数组进行三次遍历，每次时间代价为 $O(n)$，故渐进时间复杂度为 $O(n)$。

+ 空间复杂度：$O(n)$。这里预处理 $\rm pre$ 和 $\rm suf$ 需要两个长度为 $n$ 的数组。

#### 方法二：递推优化

**思路**

我们也可以修改递推的方式使用一次就可以得到答案。

记 $p_0(i)$ 为「以第 $i$ 位结尾的最长连续全 $1$ 子数组」，与方法一中的 ${\rm pre}(i)$ 相同，递推式为：

$$ p_0(i) = \left\{ \begin{aligned} 
    & 0 , & a_i = 0 \\
    & p_0(i - 1) + 1 , & a_i = 1 
   \end{aligned} \right.
$$

同时，我们记 $p_1(i)$ 为「以第 $i$ 位结尾，并且可以在某个位置删除一个 $0$ 的最长连续全 $1$ 子数组」。注意这里我们规定了只删除 $0$，而不是任意一个元素，这是因为只要数组中的元素不全为 $1$，那么删除 $1$ 就没有任何意义。$p_1(i)$ 的递推式为：

$$ p_1(i) = \left\{ \begin{aligned} 
    & p_0(i - 1) , & a_i = 0 \\
    & p_1(i - 1) + 1 , & a_i = 1 
   \end{aligned} \right.
$$

当我们遇到 $1$ 时，$p_1(i)$ 的递推式与 $p_0(i)$ 相同；而当我们遇到 $0$ 时，由于 $p_1(i)$ 允许删除一个 $0$，那么我们可以把这个 $0$ 删除，将 $p_0(i-1)$ 的值赋予 $p_1(i)$。

最后的答案即为 $p_1(i)$ 中的最大值。当遇到数组中的元素全为 $1$ 的特殊情况时，我们需要将答案减去 $1$，这是因为在这种情况下，我们不得不删除一个 $1$。注意到递推式中所有的 $p_0(i), p_1(i)$ 只和 $p_0(i-1), p_1(i-1)$ 相关，因此我们可以直接使用两个变量进行递推，减少空间复杂度。

**算法**

```C++ [sol2-C++]
class Solution {
public:
    int longestSubarray(vector<int>& nums) {
        int ans = 0;
        int p0 = 0, p1 = 0;
        for (int num: nums) {
            if (num == 0) {
                p1 = p0;
                p0 = 0;
            }
            else {
                ++p0;
                ++p1;
            }
            ans = max(ans, p1);
        }
        if (ans == nums.size()) {
            --ans;
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int longestSubarray(int[] nums) {
        int ans = 0;
        int p0 = 0, p1 = 0;
        for (int num : nums) {
            if (num == 0) {
                p1 = p0;
                p0 = 0;
            } else {
                ++p0;
                ++p1;
            }
            ans = Math.max(ans, p1);
        }
        if (ans == nums.length) {
            --ans;
        }
        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def longestSubarray(self, nums: List[int]) -> int:
        ans = 0
        p0 = p1 = 0
        for num in nums:
            if num == 0:
                p1, p0 = p0, 0
            else:
                p0 += 1
                p1 += 1
            ans = max(ans, p1)
        if ans == len(nums):
            ans -= 1
        return ans
```

**复杂度**

假设原数组长度为 $n$。

+ 时间复杂度：$O(n)$。这里对原数组进行一次遍历，时间代价为 $O(n)$，故渐进时间复杂度为 $O(n)$。

+ 空间复杂度：$O(1)$。
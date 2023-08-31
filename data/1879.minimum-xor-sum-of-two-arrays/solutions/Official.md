## [1879.两个数组最小的异或值之和 中文官方题解](https://leetcode.cn/problems/minimum-xor-sum-of-two-arrays/solutions/100000/liang-ge-shu-zu-zui-xiao-de-yi-huo-zhi-z-2uye)
#### 方法一：状态压缩动态规划

**思路与算法**

设数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 的长度为 $n$，我们可以用一个长度为 $n$ 的二进制数 $\textit{mask}$ 表示数组 $\textit{nums}_2$ 中的数被选择的状态：如果 $\textit{mask}$ 从低到高的第 $i$ 位为 $1$，说明 $\textit{nums}_2[i]$ 已经被选择，否则说明其未被选择。

这样一来，我们就可以使用动态规划解决本题。记 $f[\textit{mask}]$ 表示当我们选择了数组 $\textit{nums}_2$ 中的元素的状态为 $\textit{mask}$，并且选择了数组 $\textit{nums}_1$ 的前 $\text{count}(\textit{mask})$ 个元素的情况下，可以组成的最小的异或值之和。

> 这里的 $\text{count}(\textit{mask})$ 表示 $\textit{mask}$ 的二进制表示中 $1$ 的个数。

为了叙述方便，记 $c = \text{count}(\textit{mask})$。在进行状态转移时，我们可以枚举 $\textit{nums}_1[c-1]$ 与 $\textit{nums}_2$ 中的哪一个元素进行了异或运算，假设其为 $\textit{nums}_2[i]$，那么有状态转移方程：

$$
f[\textit{mask}] = \min_{\textit{mask} ~二进制表示的第~ i ~位为~ 1} \big\{ f[\textit{mask} \backslash i] + (\textit{nums}_1[c-1] \oplus \textit{nums}_2[i]) \big\}
$$

其中 $\oplus$ 表示异或运算，$\textit{mask} \backslash i$ 表示将 $\textit{mask}$ 的第 $i$ 位从 $1$ 变为 $0$。

最终的答案即为 $f[2^n - 1]$。

**细节**

- $\textit{mask} \backslash i$ 可以使用异或运算 $\textit{mask} \oplus 2^i$ 实现；

- 判断 $\textit{mask}$ 的第 $i$ 位是否为 $1$，等价于判断按位与运算 $\textit{mask} \wedge 2^i$ 的值是否大于 $0$；

- 由于我们需要求出的是最小值，因此可以将所有的状态初始化为极大值 $\infty$，方便进行状态转移。动态规划的边界条件为 $f[0]=0$，即未选择任何数时，异或值之和为 $0$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minimumXORSum(vector<int>& nums1, vector<int>& nums2) {
        int n = nums1.size();
        vector<int> f(1 << n, INT_MAX);
        f[0] = 0;
        for (int mask = 1; mask < (1 << n); ++mask) {
            for (int i = 0; i < n; ++i) {
                if (mask & (1 << i)) {
                    f[mask] = min(f[mask], f[mask ^ (1 << i)] + (nums1[__builtin_popcount(mask) - 1] ^ nums2[i]));
                }
            }
        }
        return f[(1 << n) - 1];
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minimumXORSum(self, nums1: List[int], nums2: List[int]) -> int:
        n = len(nums1)
        f = [float("inf")] * (1 << n)
        f[0] = 0

        for mask in range(1, 1 << n):
            c = bin(mask).count("1")
            for i in range(n):
                if mask & (1 << i):
                    f[mask] = min(f[mask], f[mask ^ (1 << i)] + (nums1[c - 1] ^ nums2[i]))
        
        return f[(1 << n) - 1]
```

**复杂度分析**

- 时间复杂度：$O(2^n \cdot n)$，其中 $n$ 是数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 的长度。状态的数量为 $O(2^n)$，每个状态需要 $O(n)$ 的时间计算结果，因此总时间复杂度为 $O(2^n \cdot n)$。

- 空间复杂度：$O(2^n)$，即为状态的数量。
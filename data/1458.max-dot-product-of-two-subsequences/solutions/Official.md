## [1458.两个子序列的最大点积 中文官方题解](https://leetcode.cn/problems/max-dot-product-of-two-subsequences/solutions/100000/liang-ge-zi-xu-lie-de-zui-da-dian-ji-by-jwqux)

#### 方法一：动态规划

我们用 $f[i][j]$ 表示只考虑数组 $\textit{nums}_1$ 的前 $i$ 个元素以及数组 $\textit{nums}_2$ 的前 $j$ 个元素时，可以得到的两个长度相同的**非空**子序列的最大点积。这里元素的下标从 $0$ 开始计数，与题目描述保持一致。

那么如何进行状态转移呢？我们可以考虑每个数组中的**最后一个元素**：

- 如果我们选择了 $\textit{nums}_1[i]$ 以及 $\textit{nums}_2[j]$ 并将它们形成点积，那么这一对数字对答案的贡献为 $x_{ij} = \textit{nums}_1[i] * \textit{nums}_2[j]$。在选择了这一对数字之后，前面还有 $\textit{nums}_1$ 的前 $i-1$ 个元素以及数组 $\textit{nums}_2$ 的前 $j-1$ 个元素，我们可以在其中选择数字对，也可以不选择，因为题目描述中唯一的限制就是「选择的子序列」非空，而我们已经选择了 $x_{ij}$ 这一数字对。

    - 如果我们在前面的元素中选择数字对，那么最大点积即为 $f[i-1][j-1] + x_{ij}$；

    - 如果我们不选择其它的数字对，那么最大点积即为 $x_{ij}$。

- 如果我们没有选择 $\textit{nums}_1[i]$ 以及 $\textit{nums}_2[j]$ 形成点积，由于它们是各自数组的最后一个元素，因此其中至少有一个不会与其它的任意元素形成点积。

    > 如果 $\textit{nums}_1[i]$ 与 $\textit{nums}_2[j_0]$ 形成点积，而 $\textit{nums}_2[j]$ 与 $\textit{nums}_1[i_0]$ 形成点积，那么不失一般性，必须保证 $i < i_0$ 且 $j_0 < j$，即不改变数字间相对有序，然而 $\textit{nums}[i]$ 是数组中的最后一个元素，因此 $i_0$ 不存在，产生了矛盾。

    这样我们可以「扔掉」$\textit{nums}_1[i]$ 和 $\textit{nums}_2[j]$ 中的至少一个元素：

    - 如果扔掉 $\textit{nums}_1[i]$，那么最大点积即为 $f[i-1][j]$；

    - 如果扔掉 $\textit{nums}_2[j]$，那么最大点积即为 $f[i][j-1]$；

    - 如果同时扔掉 $\textit{nums}_1[i]$ 和 $\textit{nums}_2[j]$，那么最大点积即为 $f[i-1][j-1]$。

根据上面的分析，我们就可以写出状态转移方程；

$$
f[i][j] = \max(f[i-1][j-1] + x_{ij}, x_{ij}, f[i-1][j], f[i][j-1], f[i-1][j-1])
$$

注意到状态转移方程中有一个可以优化的地方，这是因为 $f[i-1][j]$ 以及 $f[i][j-1]$ 对应的状态转移方程中已经包含了 $f[i-1][j-1]$，因此可以从状态转移方程中移除这一项，即：

$$
f[i][j] = \max(f[i-1][j-1] + x_{ij}, x_{ij}, f[i-1][j], f[i][j-1])
$$

动态规划的边界条件也非常容易处理。在对 $f[i][j]$ 进行转移时，我们只要处理那些没有超出边界的项就行了。最后的答案即为 $f[m-1][n-1]$，其中 $m$ 和 $n$ 分别是数组 $\textit{nums}_1$ 以及数组 $\textit{nums}_2$ 的长度。

```C++ [sol1-C++]
class Solution {
public:
    int maxDotProduct(vector<int>& nums1, vector<int>& nums2) {
        int m = nums1.size();
        int n = nums2.size();
        vector<vector<int>> f(m, vector<int>(n));

        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                int xij = nums1[i] * nums2[j];
                f[i][j] = xij;
                if (i > 0) {
                    f[i][j] = max(f[i][j], f[i - 1][j]);
                }
                if (j > 0) {
                    f[i][j] = max(f[i][j], f[i][j - 1]);
                }
                if (i > 0 && j > 0) {
                    f[i][j] = max(f[i][j], f[i - 1][j - 1] + xij);
                }
            }
        }

        return f[m - 1][n - 1];
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maxDotProduct(self, nums1: List[int], nums2: List[int]) -> int:
        m, n = len(nums1), len(nums2)
        f = [[0] * n for _ in range(m)]
        
        for i in range(m):
            for j in range(n):
                xij = nums1[i] * nums2[j]
                f[i][j] = xij
                if i > 0:
                    f[i][j] = max(f[i][j], f[i - 1][j])
                if j > 0:
                    f[i][j] = max(f[i][j], f[i][j - 1])
                if i > 0 and j > 0:
                    f[i][j] = max(f[i][j], f[i - 1][j - 1] + xij)
        
        return f[m - 1][n - 1]
```

```Java [sol1-Java]
class Solution {
    public int maxDotProduct(int[] nums1, int[] nums2) {
        int m = nums1.length;
        int n = nums2.length;
        int[][] f = new int[m][n];

        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                int xij = nums1[i] * nums2[j];
                f[i][j] = xij;
                if (i > 0) {
                    f[i][j] = Math.max(f[i][j], f[i - 1][j]);
                }
                if (j > 0) {
                    f[i][j] = Math.max(f[i][j], f[i][j - 1]);
                }
                if (i > 0 && j > 0) {
                    f[i][j] = Math.max(f[i][j], f[i - 1][j - 1] + xij);
                }
            }
        }

        return f[m - 1][n - 1];
    }
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是数组 $\textit{nums}_1$ 以及数组 $\textit{nums}_2$ 的长度。

- 空间复杂度：$O(mn)$，用来存储所有的状态。注意到 $f[i][j]$ 只会从 $f[i][..]$ 以及 $f[i-1][..]$ 转移而来，因此我们可以使用两个一维数组交替地进行状态转移，时间复杂度降低为 $O(n)$。
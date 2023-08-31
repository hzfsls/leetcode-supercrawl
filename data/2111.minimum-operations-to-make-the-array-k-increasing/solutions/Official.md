## [2111.使数组 K 递增的最少操作次数 中文官方题解](https://leetcode.cn/problems/minimum-operations-to-make-the-array-k-increasing/solutions/100000/shi-shu-zu-k-di-zeng-de-zui-shao-cao-zuo-3e62)

#### 方法一：动态规划

**提示 $1$**

题目的要求本质上是对于每一个 $i~(0 \leq i < k)$，数组 $\textit{arr}$ 的子序列：

$$
\textit{arr}[i], \textit{arr}[i + k], \textit{arr}[i + 2k], \cdots
$$

是单调递增的。

**提示 $1$ 解释**

由于 $\textit{arr}[i - k] \leq \textit{arr}[i]$，它也可以写成 $\textit{arr}[i] \leq \textit{arr}[i + k]$。如果我们对于 $\textit{arr}[i + k]$ 也套用这个不等式，就可以得到 $\textit{arr}[i + k] \leq \textit{arr}[i + 2k]$。以此类推，我们就可以得到：

$$
\textit{arr}[i] \leq \textit{arr}[i + k] \leq \textit{arr}[i + 2k] \leq \cdots
$$

也就是说，我们将数组 $\textit{arr}$ 中的每个元素根据其下标对 $k$ 取模的值，分成了 $k$ 个子序列（即下标对 $k$ 取模的值分别为 $0, 1, \cdots, k-1$）。这 $k-1$ 个子序列分别都是单调递增的。

**提示 $2$**

对于给定的一个序列，如果我们希望通过修改最少的元素，使得它单调递增，那么最少需要修改的元素个数，就是「序列的长度」减去「序列的最长递增子序列」的长度。

**提示 $2$ 解释**

我们可以这样想：对于序列中那些需要被修改的元素，由于我们可以把它们修改成任意元素，因此它们修改之前的值并不重要，我们可以忽略它们。

而对于序列中那些没有被修改的元素，由于最终的序列是单调递增的，因此这些没有被修改的元素组成的子序列也一定是单调递增的。要想修改的元素越少，这个子序列就要越长。因此我们的目标就是求出序列的最长递增的子序列。

**思路与算法**

我们对于每一个满足 $0 \leq i < k$ 的 $i$，抽取出数组 $\textit{arr}$ 的子序列：

$$
\textit{arr}[i], \textit{arr}[i + k], \textit{arr}[i + 2k], \cdots
$$

设其长度为 $\textit{length}$，最长递增的子序列的长度为 $f$，那么最少需要修改的元素个数即为 $\textit{length} - f$。

最终的答案即为所有的 $\textit{length} - f$ 之和。

**细节**

求解最长递增子序列可以参考[「300. 最长递增子序列」的官方题解](https://leetcode-cn.com/problems/longest-increasing-subsequence/solution/zui-chang-shang-sheng-zi-xu-lie-by-leetcode-soluti/)的方法二，这里不再赘述。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int kIncreasing(vector<int>& arr, int k) {
        int n = arr.size();
        int ans = 0;
        for (int i = 0; i < k; ++i) {
            vector<int> f;
            int length = 0;
            for (int j = i; j < n; j += k) {
                ++length;
                auto it = upper_bound(f.begin(), f.end(), arr[j]);
                if (it == f.end()) {
                    f.push_back(arr[j]);
                }
                else {
                    *it = arr[j];
                }
            }
            ans += length - f.size();
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def kIncreasing(self, arr: List[int], k: int) -> int:
        n = len(arr)
        ans = 0
        for i in range(k):
            f = list()
            j, length = i, 0
            while j < n:
                length += 1
                it = bisect_right(f, arr[j])
                if it == len(f):
                    f.append(arr[j])
                else:
                    f[it] = arr[j]
                j += k
            ans += length - len(f)
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n \log \dfrac{n}{k})$。每个序列的长度为 $O(\dfrac{n}{k})$，寻找其最长递增子序列需要的时间为 $O(\dfrac{n}{k} \log \dfrac{n}{k})$，而一共有 $k$ 个序列，因此总时间复杂度为 $O(n \log \dfrac{n}{k})$。

- 空间复杂度：$O(\dfrac{n}{k})$，即为寻找单个序列的最长递增子序列时，数组 $f$ 需要的空间。
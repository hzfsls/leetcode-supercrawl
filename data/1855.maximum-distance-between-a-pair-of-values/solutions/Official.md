## [1855.下标对中的最大距离 中文官方题解](https://leetcode.cn/problems/maximum-distance-between-a-pair-of-values/solutions/100000/xia-biao-dui-zhong-de-zui-da-ju-chi-by-l-dsou)

#### 方法一：双指针

**提示 $1$**

考虑遍历下标对中的某一个下标，并寻找此时所有有效坐标对中距离最大的另一个下标。暴力遍历另一个下标显然不满足时间复杂度要求，此时是否存在一些可以优化寻找过程的性质？

**思路与算法**

不失一般性，我们遍历 $\textit{nums}_2$ 中的下标 $j$，同时寻找此时符合要求的 $\textit{nums}_1$ 中最小的下标 $i$。

假设下标 $j$ 对应的最小下标为 $i$，当 $j$ 变为 $j + 1$ 时，由于 $\textit{nums}_2$ 非递增，即 $\textit{nums}_2[j] \ge \textit{nums}_2[j+1]$，那么 $\textit{nums}_1$ 中可取元素的上界不会增加。同时由于 $\textit{nums}_1$ 也非递增，因此 $j + 1$ 对应的最小下标 $i'$ 一定满足 $i' \ge i$。

那么我们就可以在遍历 $j$ 的同时维护对应的 $i$，并用 $\textit{res}$ 来维护下标对 $(i, j)$ 的最大距离。我们将 $\textit{res}$ 初值置为 $0$，这样即使存在 $\textit{nums}_1[i] \le \textit{nums}_2[j]$ 但 $i > j$ 这种不符合要求的情况，由于此时距离为负因而不会对结果产生影响（不存在时也返回 $0$）。

另外，在维护最大距离的时候要注意下标 $i$ 的合法性，即 $i < n_1$，其中 $n_1$ 为 $\textit{nums}_1$ 的长度。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maxDistance(vector<int>& nums1, vector<int>& nums2) {
        int n1 = nums1.size();
        int n2 = nums2.size();
        int i = 0;
        int res = 0;
        for (int j = 0; j < n2; ++j){
            while (i < n1 && nums1[i] > nums2[j]){
                ++i;
            }
            if (i < n1){
                res = max(res, j - i);
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def maxDistance(self, nums1: List[int], nums2: List[int]) -> int:
        n1, n2 = len(nums1), len(nums2)
        i = 0
        res = 0
        for j in range(n2):
            while i < n1 and nums1[i] > nums2[j]:
                i += 1
            if i < n1:
                res = max(res, j - i)
        return res
```


**复杂度分析**

- 时间复杂度：$O(n_1 + n_2)$，其中 $n_1, n_2$ 分别为 $\textit{nums}_1$ 与 $\textit{nums}_2$ 的长度。在双指针寻找最大值的过程中，我们最多会遍历两个数组各一次。

- 空间复杂度：$O(1)$，我们使用了常数个变量进行遍历。
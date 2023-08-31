## [1906.查询差绝对值的最小值 中文官方题解](https://leetcode.cn/problems/minimum-absolute-difference-queries/solutions/100000/cha-xun-chai-jue-dui-zhi-de-zui-xiao-zhi-fjjq)

#### 方法一：前缀和

**提示 $1$**

在本题中，数组 $\textit{nums}$ 的元素范围在 $[1, 100]$ 中，这使得对于每一组询问 $\textit{queries}_i = (l_i, r_i)$，我们可以枚举 $[1, 100]$ 中的每一个整数是否出现，并以此计算「差绝对值的最小值」。

**提示 $2$**

对于任意的数组 $a$，如果 $a$ 已经有序，那么我们只需要对 $a$ 进行一次遍历，得到 $a$ 中相邻两元素的差值中的最小值（不能为 $0$），即为「差绝对值的最小值」。如果 $a$ 中所有元素均相等，那么「差绝对值的最小值」为 $-1$。

**思路与算法**

我们可以使用前缀和数组 $\textit{pre}[i][c]$ 表示数组 $\textit{nums}$ 的前缀 $a[0..i-1]$ 中包含元素 $c$ 的个数。

对于询问 $\textit{queries}_i = (l_i, r_i)$，如果$\textit{nums}[l_i .. r_i]$ 中包含元素 $c$，那么 $\textit{pre}[r_i+1][c] - \textit{pre}[l_i][c]$ 的值大于 $0$，否则其等于 $0$。

这样一来，根据提示 $1$，我们只需要从小到大在 $[1, 100]$ 中枚举元素 $c$，并通过 $\textit{pre}[r_i+1][c] - \textit{pre}[l_i][c] > 0$ 判断元素 $c$ 是否在 $\textit{nums}[l_i .. r_i]$ 中出现过。这样做就相当于我们对 $\textit{nums}[l_i .. r_i]$ 中的元素**无重复地**从小到大进行了一次遍历。根据提示 $2$，我们只需要求出相邻两个在 $\textit{nums}[l_i .. r_i]$ 中出现过的元素的差值中的最小值，即为「差绝对值的最小值」。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    // 元素 c 的最大值
    static constexpr int C = 100;

public:
    vector<int> minDifference(vector<int>& nums, vector<vector<int>>& queries) {
        int n = nums.size();
        // 前缀和
        vector<array<int, C + 1>> pre(n + 1);
        fill(pre[0].begin(), pre[0].end(), 0);
        for (int i = 0; i < nums.size(); ++i) {
            copy_n(pre[i].begin(), C + 1, pre[i + 1].begin());
            ++pre[i + 1][nums[i]];
        }

        int q = queries.size();
        vector<int> ans;
        for (int i = 0; i < q; ++i) {
            int left = queries[i][0], right = queries[i][1];
            // last 记录上一个出现的元素
            // best 记录相邻两个元素差值的最小值
            int last = 0, best = INT_MAX;
            for (int j = 1; j <= C; ++j) {
                if (pre[left][j] != pre[right + 1][j]) {
                    if (last) {
                        best = min(best, j - last);
                    }
                    last = j;
                }
            }
            if (best == INT_MAX) {
                best = -1;
            }
            ans.push_back(best);
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minDifference(self, nums: List[int], queries: List[List[int]]) -> List[int]:
        # 元素 c 的最大值
        C = 100

        n = len(nums)
        # 前缀和
        pre = [[0] * (C + 1)]
        for i, num in enumerate(nums):
            pre.append(pre[-1][:])
            pre[-1][num] += 1

        ans = list()
        for left, right in queries:
            # last 记录上一个出现的元素
            # best 记录相邻两个元素差值的最小值
            last = 0
            best = float("inf")
            for j in range(1, C + 1):
                if pre[left][j] != pre[right + 1][j]:
                    if last != 0:
                        best = min(best, j - last)
                    last = j
            
            if best == float("inf"):
                best = -1
            ans.append(best)
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O((n+q)C)$，其中 $n$ 和 $q$ 分别是数组 $\textit{nums}$ 和 $\textit{queries}$ 的长度，$C$ 是数组 $\textit{nums}$ 中元素的最大值，在本题中 $C=100$。

    - 我们需要 $O(nC)$ 的时间预处理前缀和；

    - 我们需要 $O(C)$ 的时间，遍历 $[1, C]$ 中的每一个整数来得到一个询问对应的答案。询问一共有 $q$ 个，总时间复杂度为 $O(qC)$。

- 空间复杂度：$O(nC)$，即为存储前缀和需要使用的空间。
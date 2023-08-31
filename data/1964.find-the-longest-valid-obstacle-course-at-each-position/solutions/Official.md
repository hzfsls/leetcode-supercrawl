## [1964.找出到每个位置为止最长的有效障碍赛跑路线 中文官方题解](https://leetcode.cn/problems/find-the-longest-valid-obstacle-course-at-each-position/solutions/100000/zhao-chu-dao-mei-ge-wei-zhi-wei-zhi-zui-pb8mu)

#### 方法一：动态规划 + 二分查找

**思路与算法**

本题和[「300. 最长递增子序列」](https://leetcode-cn.com/problems/longest-increasing-subsequence/)是几乎一样的题目。

可以发现，我们需要求出的是数组 $\textit{obstacles}$ 中以每一个下标为结束位置的「最长递增子序列」的长度，其中「递增」表示子序列中相邻两个元素需要满足前者小于等于后者。而 300 题需要求出的是数组中的「最长严格递增子序列」，我们只需要修改比较两个元素的大小关系的逻辑（将「小于等于」改成「小于」，反之亦然），就可以实现这两种问题之间的相互转换。

由于在求解「最长严格递增子序列」的过程中，是需要求出以每一个下标为结束位置的「最长严格递增子序列」的长度的，因此我们可以直接使用[「300. 最长递增子序列」的官方题解](https://leetcode-cn.com/problems/longest-increasing-subsequence/solution/zui-chang-shang-sheng-zi-xu-lie-by-leetcode-soluti/)中方法二的代码。如果读者对该方法不熟悉，可以阅读官方题解或者其它参考资料进行学习，本题解不再赘述。

**代码**

下面的代码直接修改自 [「300. 最长递增子序列」的官方题解](https://leetcode-cn.com/problems/longest-increasing-subsequence/solution/zui-chang-shang-sheng-zi-xu-lie-by-leetcode-soluti/)中方法二的 $\texttt{Python}$ 代码。

```C++ [sol1-C++]
class Solution {
public:
    vector<int> longestObstacleCourseAtEachPosition(vector<int>& obstacles) {
        vector<int> d, ans;
        for (int ob: obstacles) {
            // 这里需要改成 >=
            if (d.empty() || ob >= d.back()) {
                d.push_back(ob);
                ans.push_back(d.size());
            }
            else {
                // 将 300 题解中的二分查找改为 API 调用使得代码更加直观
                // 如果是最长严格递增子序列，这里是 lower_bound
                // 如果是最长递增子序列，这里是 upper_bound
                int loc = upper_bound(d.begin(), d.end(), ob) - d.begin();
                ans.push_back(loc + 1);
                d[loc] = ob;
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def longestObstacleCourseAtEachPosition(self, obstacles: List[int]) -> List[int]:
        d = list()
        ans = list()
        for ob in obstacles:
            # 这里需要改成 >=
            if not d or ob >= d[-1]:
                d.append(ob)
                ans.append(len(d))
            else:
                # 将 300 题解中的二分查找改为 API 调用使得代码更加直观
                # 如果是最长严格递增子序列，这里是 bisect_left
                # 如果是最长递增子序列，这里是 bisect_right
                loc = bisect_right(d, ob)
                ans.append(loc + 1)
                d[loc] = ob
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$。

- 空间复杂度：$O(n)$。
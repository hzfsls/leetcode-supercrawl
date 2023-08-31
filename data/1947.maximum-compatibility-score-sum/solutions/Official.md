## [1947.最大兼容性评分和 中文官方题解](https://leetcode.cn/problems/maximum-compatibility-score-sum/solutions/100000/zui-da-jian-rong-xing-ping-fen-he-by-lee-be2l)

#### 方法一：枚举排列

**思路与算法**

由于每一名学生恰好被分配一名老师，并且老师和学生的人数均为 $m$，因此我们可以枚举所有 $0, 1, \cdots, m-1$ 组成的排列。

对于当前的排列 $p_0, p_1, \cdots, p_{m-1}$，我们给第 $i$ 名学生分配第 $p_i$ 名老师，再统计兼容性评分和即可。

枚举所有排列的方法有很多种，例如可以参考[「31. 下一个排列」的官方题解](https://leetcode-cn.com/problems/next-permutation/solution/xia-yi-ge-pai-lie-by-leetcode-solution/)，从 $0, 1, \cdots, m-1$ 开始，每次生成下一个排列，直到 $m-1, \cdots, 1, 0$ 为止。

此外，在统计兼容性评分和之前，我们可以预处理出每一名学生 $i$ 与老师 $j$ 的兼容性评分，存储在 $g[i][j]$ 中。这样一来，对于当前的排列 $p_0, p_1, \cdots, p_{m-1}$，我们只需要对所有的 $g[i][p_i]$ 进行累加，就可以在 $O(m)$ 的时间内快速得到兼容性评分和。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maxCompatibilitySum(vector<vector<int>>& students, vector<vector<int>>& mentors) {
        int m = students.size();
        int n = students[0].size();
        vector<vector<int>> g(m, vector<int>(m));
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < m; ++j) {
                for (int k = 0; k < n; ++k) {
                    g[i][j] += (students[i][k] == mentors[j][k]);
                }
            }
        }

        vector<int> p(m);
        iota(p.begin(), p.end(), 0);
        int ans = 0;
        do {
            int cur = 0;
            for (int i = 0; i < m; ++i) {
                cur += g[i][p[i]];
            }
            ans = max(ans, cur);
        } while (next_permutation(p.begin(), p.end()));
        return ans;
    }
};
```

```Python [sol1-Python3]
class Helper:
    @staticmethod
    def nextPermutation(nums: List[int]) -> bool:
        i = len(nums) - 2
        while i >= 0 and nums[i] >= nums[i + 1]:
            i -= 1
        if i < 0:
            return False

        if i >= 0:
            j = len(nums) - 1
            while j >= 0 and nums[i] >= nums[j]:
                j -= 1
            nums[i], nums[j] = nums[j], nums[i]
        
        left, right = i + 1, len(nums) - 1
        while left < right:
            nums[left], nums[right] = nums[right], nums[left]
            left += 1
            right -= 1
        
        return True

class Solution:
    def maxCompatibilitySum(self, students: List[List[int]], mentors: List[List[int]]) -> int:
        m, n = len(students), len(students[0])
        g = [[0] * m for _ in range(m)]
        for i in range(m):
            for j in range(m):
                for k in range(n):
                    g[i][j] += int(students[i][k] == mentors[j][k])

        p = list(range(m))
        ans = 0

        while True:
            cur = sum(g[i][p[i]] for i in range(m))
            ans = max(ans, cur)
            if not Helper.nextPermutation(p):
                break
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(m^2n + m \cdot m!)$。

    - 我们需要 $O(m^2n)$ 的时间预处理所有的 $g[i][j]$。

    - 排列的总数为 $m!$，对于每个排列，我们需要 $O(m)$ 的时间计算兼容性评分和。

- 空间复杂度：$O(m^2)$。

    - 我们需要 $O(m^2)$ 的空间存储所有的 $g[i][j]$。

    - 我们需要 $O(m)$ 的空间存储当前的排列，其在渐近意义下小于 $O(m^2)$，可以忽略。

#### 方法二：状态压缩动态规划

**思路与算法**

我们按照编号顺序给每一名学生分配老师。

我们可以用一个长度为 $m$ 的二进制数 $\textit{mask}$ 表示每一名老师是否被分配了学生。如果 $\textit{mask}$ 的第 $i$ 位为 $1$，那么第 $i$ 位老师被分配到了学生，否则就没有被分配到学生。

这样一来，我们就可以用状态压缩动态规划解决本题了。记 $f[\textit{mask}]$ 表示当老师被分配学生的状态为 $\textit{mask}$ 时，最大的兼容性评分和。由于我们规定了按照编号顺序给每一名学生分配老师，那么 $\textit{mask}$ 中包含 $c$ 个 $1$，就说明我们分配的学生编号为 $0, 1, \cdots, c-1$。

因此，在进行状态转移时，我们可以枚举编号为 $c-1$ 的学生被分配的是哪一名老师，这样就可以得到状态转移方程：

$$
f[\textit{mask}] = \max_{\textit{mask} ~的第 ~i~ 位为 ~1~} \big\{ f[\textit{mask} \backslash i] + g[c-1][i] \big\}
$$

其中 $\textit{mask} \backslash i$ 表示将 $\textit{mask}$ 的第 $i$ 位从 $1$ 变成 $0$，$g$ 的定义与方法一中的相同。

最终的答案即为 $f[2^m-1]$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int maxCompatibilitySum(vector<vector<int>>& students, vector<vector<int>>& mentors) {
        int m = students.size();
        int n = students[0].size();
        vector<vector<int>> g(m, vector<int>(m));
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < m; ++j) {
                for (int k = 0; k < n; ++k) {
                    g[i][j] += (students[i][k] == mentors[j][k]);
                }
            }
        }

        vector<int> f(1 << m);
        for (int mask = 1; mask < (1 << m); ++mask) {
            int c = __builtin_popcount(mask);
            for (int i = 0; i < m; ++i) {
                // 判断 mask 的第 i 位是否为 1
                if (mask & (1 << i)) {
                    f[mask] = max(f[mask], f[mask ^ (1 << i)] + g[c - 1][i]);
                }
            }
        }
        return f[(1 << m) - 1];
    }
};
```

```Python [sol2-Python3]
class Solution:
    def maxCompatibilitySum(self, students: List[List[int]], mentors: List[List[int]]) -> int:
        m, n = len(students), len(students[0])
        g = [[0] * m for _ in range(m)]
        for i in range(m):
            for j in range(m):
                for k in range(n):
                    g[i][j] += int(students[i][k] == mentors[j][k])

        f = [0] * (1 << m)
        for mask in range(1, 1 << m):
            c = bin(mask).count("1")
            for i in range(m):
                # 判断 mask 的第 i 位是否为 1
                if mask & (1 << i):
                    f[mask] = max(f[mask], f[mask ^ (1 << i)] + g[c - 1][i])
        
        return f[(1 << m) - 1]
```

**复杂度分析**

- 时间复杂度：$O(m^2n + m \cdot 2^m)$。

    - 我们需要 $O(m^2n)$ 的时间预处理所有的 $g[i][j]$。

    - 状态的总数为 $2^m$，对于每个状态，我们需要 $O(m)$ 的时间进行转移。

- 空间复杂度：$O(2^m)$。

    - 我们需要 $O(m^2)$ 的空间存储所有的 $g[i][j]$，其在渐进意义下小于 $O(2^m)$，可以忽略。

    - 我们需要 $O(2^m)$ 的空间存储所有的状态。
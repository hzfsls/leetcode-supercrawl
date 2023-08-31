## [1931.用三种不同颜色为网格涂色 中文官方题解](https://leetcode.cn/problems/painting-a-grid-with-three-different-colors/solutions/100000/yong-san-chong-bu-tong-yan-se-wei-wang-g-7nb2)

#### 方法一：状态压缩动态规划

**提示 $1$**

要使得任意两个相邻的格子的颜色均不相同，我们需要保证：

- 同一行内任意两个相邻格子的颜色互不相同；

- 相邻的两行之间，同一列上的两个格子的颜色互不相同。

因此，我们可以考虑：

- 首先通过枚举的方法，找出所有对一行进行涂色的方案数；

- 然后通过动态规划的方法，计算出对整个 $m \times n$ 的方格进行涂色的方案数。

在本题中，$m$ 和 $n$ 的最大值分别是 $5$ 和 $1000$，我们需要将较小的 $m$ 看成行的长度，较大的 $n$ 看成列的长度，这样才可以对一行进行枚举。

**思路与算法**

我们首先枚举对一行进行涂色的方案数。

对于我们可以选择红绿蓝三种颜色，我们可以将它们看成 $0, 1, 2$。这样一来，一种涂色方案就对应着一个长度为 $m$ 的三进制数，其十进制的范围为 $[0, 3^m)$。

因此，我们可以枚举 $[0, 3^m)$ 范围内的所有整数，将其转换为长度为 $m$ 的三进制串，再判断其是否满足任意相邻的两个数位均不相同即可。

随后我们就可以使用动态规划来计算方案数了。我们用 $f[i][\textit{mask}]$ 表示我们已经对 $0, 1, \cdots, i$ 行进行了涂色，并且第 $i$ 行的涂色方案对应的三进制表示为 $\textit{mask}$ 的前提下的总方案数。在进行状态转移时，我们可以考虑第 $i-1$ 行的涂色方案 $\textit{mask}'$：

$$
f[i][\textit{mask}] = \sum_{\textit{mask} ~与~ \textit{mask}' 同一数位上的数字均不相同} f[i-1][\textit{mask}']
$$

只要 $\textit{mask}'$ 与 $\textit{mask}$ 同一数位上的数字均不相同，就说明这两行可以相邻，我们就可以进行状态转移。

最终的答案即为所有满足 $\textit{mask} \in [0, 3^m)$ 的 $f[n-1][\textit{mask}]$ 之和。

**细节**

上述动态规划中的边界条件在于第 $0$ 行的涂色。当 $i=0$ 时，$f[i-1][..]$ 不是合法状态，无法进行转移，我们需要对它们进行特判：即如果 $\textit{mask}$ 任意相邻的两个数位均不相同，那么 $f[0][\textit{mask}] = 1$，否则 $f[0][\textit{mask}] = 0$。

在其余情况下的状态转移时，对于给定的 $\textit{mask}$，我们总是要找出所有满足要求的 $\textit{mask}'$，因此我们不妨也把它们预处理出来，具体可以参考下方给出的代码。

最后需要注意的是，在状态转移方程中，$f[i][..]$ 只会从 $f[i-1][..]$ 转移而来，因此我们可以使用两个长度为 $3^m$ 的一维数组，交替地进行状态转移。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int mod = 1000000007;

public:
    int colorTheGrid(int m, int n) {
        // 哈希映射 valid 存储所有满足要求的对一行进行涂色的方案
        // 键表示 mask，值表示 mask 的三进制串（以列表的形式存储）
        unordered_map<int, vector<int>> valid;

        // 在 [0, 3^m) 范围内枚举满足要求的 mask
        int mask_end = pow(3, m);
        for (int mask = 0; mask < mask_end; ++mask) {
            vector<int> color;
            int mm = mask;
            for (int i = 0; i < m; ++i) {
                color.push_back(mm % 3);
                mm /= 3;
            }
            bool check = true;
            for (int i = 0; i < m - 1; ++i) {
                if (color[i] == color[i + 1]) {
                    check = false;
                    break;
                }
            }
            if (check) {
                valid[mask] = move(color);
            }
        }

        // 预处理所有的 (mask1, mask2) 二元组，满足 mask1 和 mask2 作为相邻行时，同一列上两个格子的颜色不同
        unordered_map<int, vector<int>> adjacent;
        for (const auto& [mask1, color1]: valid) {
            for (const auto& [mask2, color2]: valid) {
                bool check = true;
                for (int i = 0; i < m; ++i) {
                    if (color1[i] == color2[i]) {
                        check = false;
                        break;
                    }
                }
                if (check) {
                    adjacent[mask1].push_back(mask2);
                }
            }
        }

        vector<int> f(mask_end);
        for (const auto& [mask, _]: valid) {
            f[mask] = 1;
        }
        for (int i = 1; i < n; ++i) {
            vector<int> g(mask_end);
            for (const auto& [mask2, _]: valid) {
                for (int mask1: adjacent[mask2]) {
                    g[mask2] += f[mask1];
                    if (g[mask2] >= mod) {
                        g[mask2] -= mod;
                    }
                }
            }
            f = move(g);
        }

        int ans = 0;
        for (int num: f) {
            ans += num;
            if (ans >= mod) {
                ans -= mod;
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def colorTheGrid(self, m: int, n: int) -> int:
        mod = 10**9 + 7
        # 哈希映射 valid 存储所有满足要求的对一行进行涂色的方案
        # 键表示 mask，值表示 mask 的三进制串（以列表的形式存储）
        valid = dict()
        
        # 在 [0, 3^m) 范围内枚举满足要求的 mask
        for mask in range(3**m):
            color = list()
            mm = mask
            for i in range(m):
                color.append(mm % 3)
                mm //= 3
            if any(color[i] == color[i + 1] for i in range(m - 1)):
                continue
            valid[mask] = color
        
        # 预处理所有的 (mask1, mask2) 二元组，满足 mask1 和 mask2 作为相邻行时，同一列上两个格子的颜色不同
        adjacent = defaultdict(list)
        for mask1, color1 in valid.items():
            for mask2, color2 in valid.items():
                if not any(x == y for x, y in zip(color1, color2)):
                    adjacent[mask1].append(mask2)
        
        f = [int(mask in valid) for mask in range(3**m)]
        for i in range(1, n):
            g = [0] * (3**m)
            for mask2 in valid.keys():
                for mask1 in adjacent[mask2]:
                    g[mask2] += f[mask1]
                    if g[mask2] >= mod:
                        g[mask2] -= mod
            f = g
            
        return sum(f) % mod
```

**复杂度分析**

- 时间复杂度：$O(3^{2m} \cdot n)$。

    - 预处理 $\textit{mask}$ 的时间复杂度为 $O(m \cdot 3^m)$；

    - 预处理 $(\textit{mask}, \textit{mask}')$ 二元组的时间复杂度为 $O(3^{2m})$；

    - 动态规划的时间复杂度为 $O(3^{2m} \cdot n)$，其在渐近意义下大于前两者。

- 空间复杂度：$O(3^{2m})$。

    - 存储 $\textit{mask}$ 的哈希映射需要的空间为 $O(m \cdot 3^m)$；

    - 存储 $(\textit{mask}, \textit{mask}')$ 二元组需要的空间为 $O(3^{2m})$，在渐进意义下大于其余两者；

    - 动态规划存储状态需要的空间为 $O(3^m)$。

不过需要注意的是，在实际的情况下，当 $m=5$ 时，满足要求的 $\textit{mask}$ 仅有 $48$ 个，远小于 $3^m=243$；满足要求的 $(\textit{mask}, \textit{mask}')$ 二元组仅有 $486$ 对，远小于 $3^{2m}=59049$。因此该算法的实际运行时间会较快。
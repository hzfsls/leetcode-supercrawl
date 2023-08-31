## [1434.每个人戴不同帽子的方案数 中文官方题解](https://leetcode.cn/problems/number-of-ways-to-wear-different-hats-to-each-other/solutions/100000/mei-ge-ren-dai-bu-tong-mao-zi-de-fang-an-d4kd)

#### 方法一：状态压缩动态规划

我们用 $f[i][\textit{mask}]$ 表示我们处理了前 $i$ 顶帽子，并且已经被分配帽子的人的状态为 $\textit{mask}$ 时的方案数。

对于帽子而言，我们从 $1$ 开始编号，即 $i$ 的范围为 $[1, 40]$。具体的原因在下文的状态转移方程中会有所体现，这是为了方便存储边界条件。

对于人而言，$\textit{mask}$ 是一个长度为 $n$ 的二进制数，它的每一位对应了一个人的状态。如果 $\textit{mask}$ 的第 $k$ 位为 $0$，那么第 $k$ 个人还没有被分配帽子，如果为 $1$，那么第 $k$ 个人被分配了帽子。

- 例如当 $\textit{mask} = (10010)_2$ 时，从右向左看，第 $1$ 位和第 $4$ 位为 $1$，表示第 $1$ 和 $4$ 个人被分配了帽子，而第 $2$，$3$，$5$ 个人还没有被分配帽子。根据 $\textit{mask}$ 本身的性质，我们需要将人从 $0$ 开始编号。

在状态的设计中，我们并没有存储每个人具体选择了哪顶帽子。这是因为在统计方案数时，我们只需要知道哪些帽子已经被选择过，以及哪些人已经选择过帽子就行了。

那么如何推导出状态转移方程呢？根据 $f[i][\textit{mask}]$，我们有两种转移的方法：

- 如果第 $i$ 顶帽子没有分配给任何人，那么会从 $f[i-1][\textit{mask}]$ 转移而来，即表示前 $i-1$ 顶帽子对应的分配状态就是 $\textit{mask}$，而第 $i$ 顶帽子不会对人的状态进行任何改变；

- 如果第 $i$ 顶帽子分配给了第 $j$ 个人，那么我们首先需要确定：

    - 第 $j$ 个人是喜欢第 $i$ 顶帽子的；

    - $\textit{mask}$ 的第 $j$ 位为 $1$，因为第 $j$ 个人被分配了第 $i$ 顶帽子。

  在满足了这两点要求之后，$f[i][\textit{mask}]$ 就可以从 $f[i-1][\textit{mask}']$ 转移而来，其中 $\textit{mask}'$ 是将 $\textit{mask}$ 的第 $j$ 位变成 $0$ 得到的值。也就是说，前 $i-1$ 顶帽子对应的分配状态中，第 $j$ 个人没有被分配帽子，而其它人的分配状态不变。

因此我们就可以写出状态转移方程：

$$
f[i][\textit{mask}] = f[i - 1][\textit{mask}] + \sum_{{j \in \textit{mask} ~\wedge~ i \in \textit{hats}[j]}} f[i - 1][\textit{mask} ~\backslash~ j]
$$

等式右侧的第一项不需要解释。第二项求和部分的条件 $j \in \textit{mask}$ 表示 $\textit{mask}$ 的第 $j$ 位为 $1$，$i \in \textit{hats}[j]$ 表示第 $j$ 个人喜欢第 $i$ 顶帽子，$\textit{mask} ~\backslash~ j$ 表示将 $\textit{mask}$ 的第 $j$ 位变成 $0$。这与上文的推导过程是一致的。

动态规划的边界条件为 $f[0][0] = 1$，这也是最初始的状态。最终的答案为 $f[40][2^n-1]$，其中 $2^n-1$ 是包含 $n$ 个 $1$ 的二进制表示对应的十进制值。

**小技巧**

- 我们可以用 `mask & (1 << j)` 或 `(mask >> j) & 1` 判断 $\textit{mask}$ 的第 $j$ 位是否为 $1$；

- 我们可以用 `mask ^ (1 << j)` 或 `mask - (1 << j)` 将 $\textit{mask}$ 的第 $j$ 位从 $1$ 变为 $0$。

```C++ [sol1-C++]
using LL = long long;

class Solution {
private:
    static constexpr int mod = 1000000007;
    
public:
    int numberWays(vector<vector<int>>& hats) {
        int n = hats.size();
        // 找到帽子编号的最大值，这样我们只需要求出 $f[maxhatid][2^n - 1]$ 作为答案
        int maxHatId = 0;
        for (int i = 0; i < n; ++i) {
            for (int h: hats[i]) {
                maxHatId = max(maxHatId, h);
            }
        }
        
        // 对于每一顶帽子 h，hatToPerson[h] 中存储了喜欢这顶帽子的所有人，方便进行动态规划
        vector<vector<int>> hatToPerson(maxHatId + 1);
        for (int i = 0; i < n; ++i) {
            for (int h: hats[i]) {
                hatToPerson[h].push_back(i);
            }
        }
        
        vector<vector<int>> f(maxHatId + 1, vector<int>(1 << n));
        // 边界条件
        f[0][0] = 1;
        for (int i = 1; i <= maxHatId; ++i) {
            for (int mask = 0; mask < (1 << n); ++mask) {
                f[i][mask] = f[i - 1][mask];
                for (int j: hatToPerson[i]) {
                    if (mask & (1 << j)) {
                        f[i][mask] += f[i - 1][mask ^ (1 << j)];
                        f[i][mask] %= mod;
                    }
                }
            }
        }
        
        return f[maxHatId][(1 << n) - 1];
    }
};
```

```Python [sol1-Python3]
class Solution:
    def numberWays(self, hats: List[List[int]]) -> int:
        mod = 10**9 + 7
        n = len(hats)
        # 找到帽子编号的最大值，这样我们只需要求出 $f[maxhatid][2^n - 1]$ 作为答案
        maxHatId = max(max(ids) for ids in hats)
        
        # 对于每一顶帽子 h，hatToPerson[h] 中存储了喜欢这顶帽子的所有人，方便进行动态规划
        hatToPerson = collections.defaultdict(list)
        for i in range(n):
            for h in hats[i]:
                hatToPerson[h].append(i)
        
        f = [[0] * (1 << n) for _ in range(maxHatId + 1)]
        # 边界条件
        f[0][0] = 1
        for i in range(1, maxHatId + 1):
            for mask in range(1 << n):
                f[i][mask] = f[i - 1][mask]
                for j in hatToPerson[i]:
                    if mask & (1 << j):
                        f[i][mask] += f[i - 1][mask ^ (1 << j)]
                f[i][mask] %= mod
        
        return f[maxHatId][(1 << n) - 1]
```

```Java [sol1-Java]
class Solution {
    public int numberWays(List<List<Integer>> hats) {
        final int MOD = 1000000007;
        int n = hats.size();
        // 找到帽子编号的最大值，这样我们只需要求出 f[maxhatid][2^n - 1] 作为答案
        int maxHatId = 0;
        for (int i = 0; i < n; ++i) {
            List<Integer> list = hats.get(i);
            for (int h: list) {
                maxHatId = Math.max(maxHatId, h);
            }
        }
        
        // 对于每一顶帽子 h，hatToPerson[h] 中存储了喜欢这顶帽子的所有人，方便进行动态规划
        List<List<Integer>> hatToPerson = new ArrayList<List<Integer>>();
        for (int i = 0; i <= maxHatId; i++) {
            hatToPerson.add(new ArrayList<Integer>());
        }
        for (int i = 0; i < n; ++i) {
            List<Integer> list = hats.get(i);
            for (int h: list) {
                hatToPerson.get(h).add(i);
            }
        }
        
        int[][] f = new int[maxHatId + 1][1 << n];
        // 边界条件
        f[0][0] = 1;
        for (int i = 1; i <= maxHatId; ++i) {
            for (int mask = 0; mask < (1 << n); ++mask) {
                f[i][mask] = f[i - 1][mask];
                List<Integer> list = hatToPerson.get(i);
                for (int j: list) {
                    if ((mask & (1 << j)) != 0) {
                        f[i][mask] += f[i - 1][mask ^ (1 << j)];
                        f[i][mask] %= MOD;
                    }
                }
            }
        }
        
        return f[maxHatId][(1 << n) - 1];
    }
}
```

**复杂度分析**

- 时间复杂度：$O(2^n * h)$，其中 $h$ 表示 $\textit{hats}$ 中的元素个数。

    - 我们需要 $O(h)$ 的时间得到帽子编号的最大值；

    - 我们需要 $O(h)$ 的时间构造数组 $\textit{hatToPerson}$；

    - 在动态规划过程中，枚举 $\textit{mask}$ 对应的循环的时间复杂度为 $O(2^n)$，而枚举 $i$ 和 $j$ 对应循环的时间复杂度总计为 $O(h)$，因此动态规划的时间复杂度为 $O(2^n * h)$。

- 空间复杂度：$O(2^n * m + h)$ 或 $O(2^n + h)$，其中 $m$ 表示帽子编号的最大值。

    - 我们需要 $O(h)$ 的空间存储数组 $\textit{hatToPerson}$；

    - 我们需要 $O(2^n * m)$ 的空间存储动态规划的结果。注意到在 $f[i][\textit{mask}]$ 只会从 $f[i - 1][..]$ 转移而来，因此我们也可以使用两个 $O(2^n)$ 的一维数组，交替地进行状态转移，空间复杂度降低至 $O(2^n)$。
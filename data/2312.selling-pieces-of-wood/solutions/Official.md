## [2312.卖木头块 中文官方题解](https://leetcode.cn/problems/selling-pieces-of-wood/solutions/100000/mai-mu-tou-kuai-by-leetcode-solution-gflg)

#### 方法一：动态规划 / 记忆化搜索

**思路与算法**

我们可以使用动态规划来解决本题。

我们用 $f(x, y)$ 表示当木块的高和宽分别是 $x$ 和 $y$ 时，可以得到的最多钱数。我们需要考虑三种情况：

- 如果数组 $\textit{prices}$ 中存在 $(x, y, \textit{price})$ 这一三元组，那么我们可以将木块以 $\textit{prices}$ 的价格卖出。为了快速判断存在性，我们可以使用一个哈希映射来进行存储，即哈希映射的键为 $(h_i, w_i)$，值为 $\textit{price}_i$，这样我们就可以根据木块的高和宽，在 $O(1)$ 的时间得到对应的价格。这种情况的状态转移方程为：

$$
f(x, y) = \textit{price}
$$

- 如果 $x>1$，那么我们可以沿水平方向将木块切成两部分，它们的高分别是 $i~(1 \leq i < x)$ 和 $x-i$，宽均为 $y$。因此我们可以得到状态转移方程：

$$
f(x, y) = \max_{1 \leq i < x} \big\{ f(i, y) + f(x-i, y) \big\}
$$

- 如果 $y>1$，那么我们可以沿垂直方向将木块切成两部分，它们的宽分别是 $j~(1 \leq j < y)$ 和 $y-j$，高均为 $x$。因此我们可以得到状态转移方程：

$$
f(x, y) = \max_{1 \leq j < y} \big\{ f(x, j) + f(x, y-j) \big\}
$$

当有多种情况满足时，我们需要选择它们中的较大值。最终的答案即为 $f(m, n)$。

**细节**

本题使用记忆化搜索进行编码更加简洁方便。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    long long sellingWood(int m, int n, vector<vector<int>>& prices) {
        auto pair_hash = [fn = hash<int>()](const pair<int, int>& o) -> size_t {
            return (fn(o.first) << 16) ^ fn(o.second);
        };
        unordered_map<pair<int, int>, int, decltype(pair_hash)> value(0, pair_hash);

        vector<vector<long long>> memo(m + 1, vector<long long>(n + 1, -1));

        function<long long(int, int)> dfs = [&](int x, int y) -> long long {
            if (memo[x][y] != -1) {
                return memo[x][y];
            }

            long long ret = value.count({x, y}) ? value[{x, y}] : 0;
            if (x > 1) {
                for (int i = 1; i < x; ++i) {
                    ret = max(ret, dfs(i, y) + dfs(x - i, y));
                }
            }
            if (y > 1) {
                for (int j = 1; j < y; ++j) {
                    ret = max(ret, dfs(x, j) + dfs(x, y - j));
                }
            }
            return memo[x][y] = ret;
        };

        for (int i = 0; i < prices.size(); ++i) {
            value[{prices[i][0], prices[i][1]}] = prices[i][2];
        }
        return dfs(m, n);
    }
};
```

```Python [sol1-Python3]
class Solution:
    def sellingWood(self, m: int, n: int, prices: List[List[int]]) -> int:
        value = dict()

        @cache
        def dfs(x: int, y: int) -> int:
            ret = value.get((x, y), 0)

            if x > 1:
                for i in range(1, x):
                    ret = max(ret, dfs(i, y) + dfs(x - i, y))
            
            if y > 1:
                for j in range(1, y):
                    ret = max(ret, dfs(x, j) + dfs(x, y - j))
            
            return ret
        
        for (h, w, price) in prices:
            value[(h, w)] = price
        
        ans = dfs(m, n)
        dfs.cache_clear()
        return ans
```

**复杂度分析**

- 时间复杂度：$O(mn(m+n)+p)$，其中 $p$ 是数组 $\textit{prices}$ 的长度。

- 空间复杂度：$O(mn+p)$，即为哈希映射和动态规划的数组需要使用的空间。
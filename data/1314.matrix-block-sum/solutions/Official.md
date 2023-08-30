#### 预备知识

本题需要用到一些二维前缀和（Prefix Sum）的知识，它是一维前缀和的延伸。

具体可以参考力扣 [1292 题的官方题解](https://leetcode-cn.com/problems/maximum-side-length-of-a-square-with-sum-less-than-or-equal-to-threshold/solution/yuan-su-he-xiao-yu-deng-yu-yu-zhi-de-zheng-fang-xi/) 中的「预备知识」和「注意事项」部分。

#### 方法一：二维前缀和

我们用数组 `P` 表示数组 `mat` 的二维前缀和，`P` 的维数为 `(m + 1) * (n + 1)`，其中 `P[i][j]` 表示数组 `mat` 中以 `(0, 0)` 为左上角，`(i - 1, j - 1)` 为右下角的矩形子数组的元素之和。

题目需要对数组 `mat` 中的每个位置，计算以 `(i - K, j - K)` 为左上角，`(i + K, j + K)` 为右下角的矩形子数组的元素之和，我们可以在前缀和数组的帮助下，通过：

```
sum = P[i + K + 1][j + K + 1] - P[i - K][j + K + 1] - P[i + K + 1][j - K] + P[i - K][j - K]
```

得到元素之和。注意到 `i + K + 1`、`j + K - 1`、`i - K` 和 `j - K` 这些下标有可能不在矩阵内，因此对于所有的横坐标，我们需要将其规范在 `[0, m]` 的区间内；对于所有的纵坐标，我们需要将其规范在 `[0, n]` 的区间内。具体地：

- `i + K + 1` 和 `j + K - 1` 分别可能超过 `m` 和 `n`，因此我们需要对这两个坐标与 `m` 和 `n` 取较小值，忽略不在矩阵内的部分；

- `i - K` 和 `j - K` 可能小于 `0`，因此我们需要对这两个坐标与 `0` 取较大值，忽略不在矩阵内的部分。

更一般的做法是，我们对所有的横坐标与 `m` 取较小值，纵坐标与 `n` 取较小值，再将所有坐标与 `0` 取较大值，就可以将这些坐标规范在前缀和数组 `P` 的范围内。

```C++ [sol1-C++]
class Solution {
public:
    int get(const vector<vector<int>>& pre, int m, int n, int x, int y) {
        x = max(min(x, m), 0);
        y = max(min(y, n), 0);
        return pre[x][y];
    }
    
    vector<vector<int>> matrixBlockSum(vector<vector<int>>& mat, int K) {
        int m = mat.size(), n = mat[0].size();
        vector<vector<int>> P(m + 1, vector<int>(n + 1));
        for (int i = 1; i <= m; ++i) {
            for (int j = 1; j <= n; ++j) {
                P[i][j] = P[i - 1][j] + P[i][j - 1] - P[i - 1][j - 1] + mat[i - 1][j - 1];
            }
        }
        
        vector<vector<int>> ans(m, vector<int>(n));
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                ans[i][j] = get(P, m, n, i + K + 1, j + K + 1) - get(P, m, n, i - K, j + K + 1) - get(P, m, n, i + K + 1, j - K) + get(P, m, n, i - K, j - K);
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def matrixBlockSum(self, mat: List[List[int]], K: int) -> List[List[int]]:
        m, n = len(mat), len(mat[0])
        P = [[0] * (n + 1) for _ in range(m + 1)]
        for i in range(1, m + 1):
            for j in range(1, n + 1):
                P[i][j] = P[i - 1][j] + P[i][j - 1] - P[i - 1][j - 1] + mat[i - 1][j - 1]
        
        def get(x, y):
            x = max(min(x, m), 0)
            y = max(min(y, n), 0)
            return P[x][y]

        ans = [[0] * n for _ in range(m)]
        for i in range(m):
            for j in range(n):
                ans[i][j] = get(i + K + 1, j + K + 1) - get(i - K, j + K + 1) - get(i + K + 1, j - K) + get(i - K, j - K);
        return ans
```

**复杂度分析**

- 时间复杂度：$O(MN)$。

- 空间复杂度：$O(MN)$。
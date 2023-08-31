## [1828.统计一个圆中点的数目 中文官方题解](https://leetcode.cn/problems/queries-on-number-of-points-inside-a-circle/solutions/100000/tong-ji-yi-ge-yuan-zhong-dian-de-shu-mu-jnylm)

#### 方法一：枚举每个点是否在每个圆中

**思路与算法**

我们可以使用二重循环，对于每一个查询，枚举所有的点，依次判断它们是否在查询的圆中即可。

如果查询圆的圆心为 $(c_x, c_y)$，半径为 $c_r$，枚举的点坐标为 $(p_x, p_y)$，那么点在圆中（包括在圆上的情况）当且仅当点到圆心的距离小于等于半径。我们可以用以下方法进行判断：

$$
(c_x-p_x)^2 + (c_y-p_y)^2 \leq c_r^2
$$

注意这里两侧的距离都进行了平方操作，这样可以避免引入浮点数，产生不必要的误差。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> countPoints(vector<vector<int>>& points, vector<vector<int>>& queries) {
        int m = points.size(), n = queries.size();
        vector<int> ans(n);
        for (int i = 0; i < n; ++i) {
            int cx = queries[i][0], cy = queries[i][1], cr = queries[i][2];
            for (int j = 0; j < m; ++j) {
                int px = points[j][0], py = points[j][1];
                if ((cx - px) * (cx - px) + (cy - py) * (cy - py) <= cr * cr) {
                    ++ans[i];
                }
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] countPoints(int[][] points, int[][] queries) {
        int m = points.length, n = queries.length;
        int[] ans = new int[n];
        for (int i = 0; i < n; ++i) {
            int cx = queries[i][0], cy = queries[i][1], cr = queries[i][2];
            for (int j = 0; j < m; ++j) {
                int px = points[j][0], py = points[j][1];
                if ((cx - px) * (cx - px) + (cy - py) * (cy - py) <= cr * cr) {
                    ++ans[i];
                }
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] CountPoints(int[][] points, int[][] queries) {
        int m = points.Length, n = queries.Length;
        int[] ans = new int[n];
        for (int i = 0; i < n; ++i) {
            int cx = queries[i][0], cy = queries[i][1], cr = queries[i][2];
            for (int j = 0; j < m; ++j) {
                int px = points[j][0], py = points[j][1];
                if ((cx - px) * (cx - px) + (cy - py) * (cy - py) <= cr * cr) {
                    ++ans[i];
                }
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def countPoints(self, points: List[List[int]], queries: List[List[int]]) -> List[int]:
        ans = [0] * len(queries)

        for i, (cx, cy, cr) in enumerate(queries):
            for (px, py) in points:
                if (cx - px) ** 2 + (cy - py) ** 2 <= cr ** 2:
                    ans[i] += 1
        
        return ans
```

```C [sol1-C]
int* countPoints(int** points, int pointsSize, int* pointsColSize, int** queries, int queriesSize, int* queriesColSize, int* returnSize) {    
    int *ans = (int *)malloc(sizeof(int) * queriesSize);
    memset(ans, 0, sizeof(int) * queriesSize);
    for (int i = 0; i < queriesSize; ++i) {
        int cx = queries[i][0], cy = queries[i][1], cr = queries[i][2];
        for (int j = 0; j < pointsSize; ++j) {
            int px = points[j][0], py = points[j][1];
            if ((cx - px) * (cx - px) + (cy - py) * (cy - py) <= cr * cr) {
                ++ans[i];
            }
        }
    }
    *returnSize = queriesSize;
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var countPoints = function(points, queries) {
    const m = points.length, n = queries.length;
    const ans = new Array(n).fill(0);
    for (let i = 0; i < n; ++i) {
        let cx = queries[i][0], cy = queries[i][1], cr = queries[i][2];
        for (let j = 0; j < m; ++j) {
            let px = points[j][0], py = points[j][1];
            if ((cx - px) * (cx - px) + (cy - py) * (cy - py) <= cr * cr) {
                ++ans[i];
            }
        }
    }
    return ans;
};
```

```go [sol1-Golang]
func countPoints(points [][]int, queries [][]int) []int {
    ans := make([]int, len(queries))
    for i, q := range queries {
        x, y, r := q[0], q[1], q[2]
        for _, p := range points {
            if (p[0]-x)*(p[0]-x)+(p[1]-y)*(p[1]-y) <= r*r {
                ans[i]++
            }
        }
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是数组 $\textit{points}$ 和 $\textit{queries}$ 的长度。

- 空间复杂度：$O(1)$。
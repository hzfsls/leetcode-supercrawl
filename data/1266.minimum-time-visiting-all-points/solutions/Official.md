#### 方法一：切比雪夫距离

对于平面上的两个点 `x = (x0, x1)` 和 `y = (y0, y1)`，设它们横坐标距离之差为 `dx = |x0 - y0|`，纵坐标距离之差为 `dy = |x1 - y1|`，对于以下三种情况，我们可以分别计算出从 `x` 移动到 `y` 的最少次数：

- `dx < dy`：沿对角线移动 `dx` 次，再竖直移动 `dy - dx` 次，总计 `dx + (dy - dx) = dy` 次；

- `dx == dy`：沿对角线移动 `dx` 次；

- `dx > dy`：沿对角线移动 `dy` 次，再水平移动 `dx - dy` 次，总计 `dy + (dx - dy) = dx` 次。

可以发现，对于任意一种情况，从 `x` 移动到 `y` 的最少次数为 `dx` 和 `dy` 中的较大值 `max(dx, dy)`，这也被称作 `x` 和 `y` 之间的 [切比雪夫距离](https://baike.baidu.com/item/%E5%88%87%E6%AF%94%E9%9B%AA%E5%A4%AB%E8%B7%9D%E7%A6%BB)。

由于题目要求，需要按照数组中出现的顺序来访问这些点。因此我们遍历整个数组，对于数组中的相邻两个点，计算出它们的切比雪夫距离，所有的距离之和即为答案。

```C++ [sol1]
class Solution {
public:
    int minTimeToVisitAllPoints(vector<vector<int>>& points) {
        int x0 = points[0][0], x1 = points[0][1];
        int ans = 0;
        for (int i = 1; i < points.size(); ++i) {
            int y0 = points[i][0], y1 = points[i][1];
            ans += max(abs(x0 - y0), abs(x1 - y1));
            x0 = y0;
            x1 = y1;
        }
        return ans;
    }
};
```

```Python [sol1]
class Solution:
    def minTimeToVisitAllPoints(self, points: List[List[int]]) -> int:
        x0, x1 = points[0]
        ans = 0
        for i in range(1, len(points)):
            y0, y1 = points[i]
            ans += max(abs(x0 - y0), abs(x1 - y1))
            x0, x1 = points[i]
        return ans
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是数组的长度。

- 空间复杂度：$O(1)$。
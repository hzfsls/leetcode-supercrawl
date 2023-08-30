#### 方法一：排序

**思路**

两点之间内部不包含任何点的最宽垂直面积的宽度，即所有点投影到横轴上后，求相邻的两个点的最大距离。可以先将输入的坐标按照横坐标排序，然后依次求出所有相邻点的横坐标距离，返回最大值。

**代码**

```Python [sol1-Python3]
class Solution:
    def maxWidthOfVerticalArea(self, points: List[List[int]]) -> int:
        points.sort()
        mx = 0
        for i in range(1, len(points)):
            mx = max(points[i][0] - points[i - 1][0], mx)
        return mx
```

```Java [sol1-Java]
class Solution {
    public int maxWidthOfVerticalArea(int[][] points) {
        Arrays.sort(points, (a, b) -> a[0] - b[0]);
        int mx = 0;
        for (int i = 1; i < points.length; i++) {
            mx = Math.max(points[i][0] - points[i - 1][0], mx);
        }
        return mx;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxWidthOfVerticalArea(int[][] points) {
        Array.Sort(points, (a, b) => a[0] - b[0]);
        int mx = 0;
        for (int i = 1; i < points.Length; i++) {
            mx = Math.Max(points[i][0] - points[i - 1][0], mx);
        }
        return mx;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int maxWidthOfVerticalArea(vector<vector<int>>& points) {
        sort(points.begin(), points.end());
        int mx = 0;
        for (int i = 1; i < points.size(); i++) {
            mx = max(points[i][0] - points[i - 1][0], mx);
        }
        return mx;
    }
};
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

static int cmp(const void *pa, const void *pb) {
    return (*(int **)pa)[0] - (*(int **)pb)[0];
}

int maxWidthOfVerticalArea(int** points, int pointsSize, int* pointsColSize) {
    qsort(points, pointsSize, sizeof(int *), cmp);
    int mx = 0;
    for (int i = 1; i < pointsSize; i++) {
        mx = MAX(points[i][0] - points[i - 1][0], mx);
    }
    return mx;
}
```

```JavaScript [sol1-JavaScript]
var maxWidthOfVerticalArea = function(points) {
    points.sort((a, b) => a[0] - b[0]);
    let mx = 0;
    for (let i = 1; i < points.length; i++) {
        mx = Math.max(points[i][0] - points[i - 1][0], mx);
    }
    return mx;
};
```

```go [sol1-Golang]
func maxWidthOfVerticalArea(points [][]int) (ans int) {
    sort.Slice(points, func(i, j int) bool {
        return points[i][0] < points[j][0]
    })
    for i := 1; i < len(points); i++ {
        ans = max(ans, points[i][0]-points[i-1][0])
    }
    return
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是输入数组的长度，排序消耗 $O(n \log n)$ 时间复杂度。

- 空间复杂度：$O(\log n)$，为排序的空间复杂度。
#### 方法一：计算重叠面积

两个矩形覆盖的总面积等于两个矩形的面积之和减去两个矩形的重叠部分的面积。由于两个矩形的左下顶点和右上顶点已知，因此两个矩形的面积可以直接计算。如果两个矩形重叠，则两个矩形的重叠部分也是矩形，重叠部分的面积可以根据重叠部分的边界计算。

两个矩形的水平边投影到 $x$ 轴上的线段分别为 $[\textit{ax}_1, \textit{ax}_2]$ 和 $[\textit{bx}_1, \textit{bx}_2]$，竖直边投影到 $y$ 轴上的线段分别为 $[\textit{ay}_1, \textit{ay}_2]$ 和 $[\textit{by}_1, \textit{by}_2]$。如果两个矩形重叠，则重叠部分的水平边投影到 $x$ 轴上的线段为 $[\max(\textit{ax}_1, \textit{bx}_1), \min(\textit{ax}_2, \textit{bx}_2)]$，竖直边投影到 $y$ 轴上的线段为 $[\max(\textit{ay}_1, \textit{by}_1), \min(\textit{ay}_2, \textit{by}_2)]$，根据重叠部分的水平边投影到 $x$ 轴上的线段长度和竖直边投影到 $y$ 轴上的线段长度即可计算重叠部分的面积。只有当两条线段的长度都大于 $0$ 时，重叠部分的面积才大于 $0$，否则重叠部分的面积为 $0$。

```Java [sol1-Java]
class Solution {
    public int computeArea(int ax1, int ay1, int ax2, int ay2, int bx1, int by1, int bx2, int by2) {
        int area1 = (ax2 - ax1) * (ay2 - ay1), area2 = (bx2 - bx1) * (by2 - by1);
        int overlapWidth = Math.min(ax2, bx2) - Math.max(ax1, bx1), overlapHeight = Math.min(ay2, by2) - Math.max(ay1, by1);
        int overlapArea = Math.max(overlapWidth, 0) * Math.max(overlapHeight, 0);
        return area1 + area2 - overlapArea;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int ComputeArea(int ax1, int ay1, int ax2, int ay2, int bx1, int by1, int bx2, int by2) {
        int area1 = (ax2 - ax1) * (ay2 - ay1), area2 = (bx2 - bx1) * (by2 - by1);
        int overlapWidth = Math.Min(ax2, bx2) - Math.Max(ax1, bx1), overlapHeight = Math.Min(ay2, by2) - Math.Max(ay1, by1);
        int overlapArea = Math.Max(overlapWidth, 0) * Math.Max(overlapHeight, 0);
        return area1 + area2 - overlapArea;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int computeArea(int ax1, int ay1, int ax2, int ay2, int bx1, int by1, int bx2, int by2) {
        int area1 = (ax2 - ax1) * (ay2 - ay1), area2 = (bx2 - bx1) * (by2 - by1);
        int overlapWidth = min(ax2, bx2) - max(ax1, bx1), overlapHeight = min(ay2, by2) - max(ay1, by1);
        int overlapArea = max(overlapWidth, 0) * max(overlapHeight, 0);
        return area1 + area2 - overlapArea;
    }
};
```

```JavaScript [sol1-JavaScript]
var computeArea = function(ax1, ay1, ax2, ay2, bx1, by1, bx2, by2) {
    const area1 = (ax2 - ax1) * (ay2 - ay1), area2 = (bx2 - bx1) * (by2 - by1);
    const overlapWidth = Math.min(ax2, bx2) - Math.max(ax1, bx1), overlapHeight = Math.min(ay2, by2) - Math.max(ay1, by1);
    const overlapArea = Math.max(overlapWidth, 0) * Math.max(overlapHeight, 0);
    return area1 + area2 - overlapArea;
};
```

```C [sol1-C]
int computeArea(int ax1, int ay1, int ax2, int ay2, int bx1, int by1, int bx2, int by2) {
    int area1 = (ax2 - ax1) * (ay2 - ay1), area2 = (bx2 - bx1) * (by2 - by1);
    int overlapWidth = fmin(ax2, bx2) - fmax(ax1, bx1), overlapHeight = fmin(ay2, by2) - fmax(ay1, by1);
    int overlapArea = fmax(overlapWidth, 0) * fmax(overlapHeight, 0);
    return area1 + area2 - overlapArea;
}
```

```go [sol1-Golang]
func computeArea(ax1, ay1, ax2, ay2, bx1, by1, bx2, by2 int) int {
    area1 := (ax2 - ax1) * (ay2 - ay1)
    area2 := (bx2 - bx1) * (by2 - by1)
    overlapWidth := min(ax2, bx2) - max(ax1, bx1)
    overlapHeight := min(ay2, by2) - max(ay1, by1)
    overlapArea := max(overlapWidth, 0) * max(overlapHeight, 0)
    return area1 + area2 - overlapArea
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

```Python [sol1-Python3]
class Solution:
    def computeArea(self, ax1: int, ay1: int, ax2: int, ay2: int, bx1: int, by1: int, bx2: int, by2: int) -> int:
        area1 = (ax2 - ax1) * (ay2 - ay1)
        area2 = (bx2 - bx1) * (by2 - by1)
        overlapWidth = min(ax2, bx2) - max(ax1, bx1)
        overlapHeight = min(ay2, by2) - max(ay1, by1)
        overlapArea = max(overlapWidth, 0) * max(overlapHeight, 0)
        return area1 + area2 - overlapArea
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。
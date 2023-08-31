## [836.矩形重叠 中文官方题解](https://leetcode.cn/problems/rectangle-overlap/solutions/100000/ju-xing-zhong-die-by-leetcode-solution)
#### 方法一：检查位置

**思路**

我们尝试分析在什么情况下，矩形 `rec1` 和 `rec2` 没有重叠。

如果矩形 `rec1` 和 `rec2` 中至少有一个矩形的面积为 $0$，则一定没有重叠。

当矩形 `rec1` 和 `rec2` 的面积都大于 $0$ 时，如果我们在平面中放置一个固定的矩形 `rec2`，那么矩形 `rec1` 必须要出现在 `rec2` 的「四周」，也就是说，矩形 `rec1` 需要满足以下四种情况中的至少一种：

- 矩形 `rec1` 在矩形 `rec2` 的左侧；

- 矩形 `rec1` 在矩形 `rec2` 的右侧；

- 矩形 `rec1` 在矩形 `rec2` 的上方；

- 矩形 `rec1` 在矩形 `rec2` 的下方。

何为「左侧」？如果矩形 `rec1` 在矩形 `rec2` 的左侧，那就表示我们可以找到一条竖直的线（可以与矩形的边重合），使得矩形 `rec1` 和 `rec2` 被分在这条竖线的两侧。对于「右侧」、「上方」以及「下方」，它们的定义与「左侧」是类似的。

**算法**

首先判断矩形 `rec1` 和 `rec2` 的面积是否为 $0$。

- 对于矩形 `rec1` 而言，其面积为 $0$ 当且仅当 `rec1[0] == rec1[2]` 或 `rec1[1] == rec1[3]`；

- 对于矩形 `rec2` 而言，其面积为 $0$ 当且仅当 `rec2[0] == rec2[2]` 或 `rec2[1] == rec2[3]`。

如果至少有一个矩形的面积为 $0$，则一定没有重叠。

如果矩形 `rec1` 和 `rec2` 的面积都大于 $0$，则考虑两个矩形的位置。我们将上述四种情况翻译成代码。具体地，我们用 `(rec[0], rec[1])` 表示矩形的左下角，`(rec[2], rec[3])` 表示矩形的右上角，与题目描述一致。对于「左侧」，即矩形 `rec1` 在 `x` 轴上的最大值不能大于矩形 `rec2` 在 `x` 轴上最小值。对于「右侧」、「上方」以及「下方」同理。因此我们可以翻译成如下的代码：

- 左侧：`rec1[2] <= rec2[0]`；

- 右侧：`rec1[0] >= rec2[2]`；

- 上方：`rec1[1] >= rec2[3]`；

- 下方：`rec1[3] <= rec2[1]`。

```Java [sol1-Java]
class Solution {
    public boolean isRectangleOverlap(int[] rec1, int[] rec2) {
        if (rec1[0] == rec1[2] || rec1[1] == rec1[3] || rec2[0] == rec2[2] || rec2[1] == rec2[3]) {
            return false;
        }
        return !(rec1[2] <= rec2[0] ||   // left
                 rec1[3] <= rec2[1] ||   // bottom
                 rec1[0] >= rec2[2] ||   // right
                 rec1[1] >= rec2[3]);    // top
    }
}
```
```Python [sol1-Python3]
class Solution:
    def isRectangleOverlap(self, rec1: List[int], rec2: List[int]) -> bool:
        if rec1[0] == rec1[2] or rec1[1] == rec1[3] or rec2[0] == rec2[2] or rec2[1] == rec2[3]:
            return False
        return not (rec1[2] <= rec2[0] or  # left
                    rec1[3] <= rec2[1] or  # bottom
                    rec1[0] >= rec2[2] or  # right
                    rec1[1] >= rec2[3])    # top
```
```C++ [sol1-C++]
class Solution {
public:
    bool isRectangleOverlap(vector<int>& rec1, vector<int>& rec2) {
        if (rec1[0] == rec1[2] || rec1[1] == rec1[3] || rec2[0] == rec2[2] || rec2[1] == rec2[3]) {
            return false;
        }
        return !(rec1[2] <= rec2[0] ||   // left
                 rec1[3] <= rec2[1] ||   // bottom
                 rec1[0] >= rec2[2] ||   // right
                 rec1[1] >= rec2[3]);    // top
    }
};
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$，不需要额外的空间。

#### 方法二：检查区域

**思路**

如果两个矩形重叠，那么它们重叠的区域一定也是一个矩形，那么这代表了两个矩形与 $x$ 轴平行的边（水平边）投影到 $x$ 轴上时会有交集，与 $y$ 轴平行的边（竖直边）投影到 $y$ 轴上时也会有交集。因此，我们可以将问题看作一维线段是否有交集的问题。

**算法**

矩形 `rec1` 和 `rec2` 的水平边投影到 $x$ 轴上的线段分别为 `(rec1[0], rec1[2])` 和 `(rec2[0], rec2[2])`。根据数学知识我们可以知道，当 `min(rec1[2], rec2[2]) > max(rec1[0], rec2[0])` 时，这两条线段有交集。对于矩形 `rec1` 和 `rec2` 的竖直边投影到 $y$ 轴上的线段，同理可以得到，当 `min(rec1[3], rec2[3]) > max(rec1[1], rec2[1])` 时，这两条线段有交集。

```Java [sol2-Java]
class Solution {
    public boolean isRectangleOverlap(int[] rec1, int[] rec2) {
        return (Math.min(rec1[2], rec2[2]) > Math.max(rec1[0], rec2[0]) &&
                Math.min(rec1[3], rec2[3]) > Math.max(rec1[1], rec2[1]));
    }
}
```
```Python [sol2-Python3]
class Solution:
    def isRectangleOverlap(self, rec1: List[int], rec2: List[int]) -> bool:
        def intersect(p_left, p_right, q_left, q_right):
            return min(p_right, q_right) > max(p_left, q_left)
        return (intersect(rec1[0], rec1[2], rec2[0], rec2[2]) and
                intersect(rec1[1], rec1[3], rec2[1], rec2[3]))
```
```C++ [sol2-C++]
class Solution {
public:
    bool isRectangleOverlap(vector<int>& rec1, vector<int>& rec2) {
        return (min(rec1[2], rec2[2]) > max(rec1[0], rec2[0]) &&
                min(rec1[3], rec2[3]) > max(rec1[1], rec2[1]));
    }
};
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$，不需要额外的空间。
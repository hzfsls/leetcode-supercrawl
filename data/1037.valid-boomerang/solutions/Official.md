## [1037.有效的回旋镖 中文官方题解](https://leetcode.cn/problems/valid-boomerang/solutions/100000/you-xiao-de-hui-xuan-biao-by-leetcode-so-yqby)
#### 方法一：向量叉乘

计算从 $\textit{points}[0]$ 开始，分别指向 $\textit{points}[1]$ 和 $\textit{points}[2]$ 的向量 $\vec{v}_1$ 和 $\vec{v}_2$。「三点各不相同且不在一条直线上」等价于「这两个向量的叉乘结果不为零」：
$$\vec{v}_1 \times \vec{v}_2 \ne \vec{0}$$

```Python [sol1-Python3]
class Solution:
    def isBoomerang(self, points: List[List[int]]) -> bool:
        v1 = (points[1][0] - points[0][0], points[1][1] - points[0][1])
        v2 = (points[2][0] - points[0][0], points[2][1] - points[0][1])
        return v1[0] * v2[1] - v1[1] * v2[0] != 0
```

```C++ [sol1-C++]
class Solution {
public:
    bool isBoomerang(vector<vector<int>>& points) {
        vector<int> v1 = {points[1][0] - points[0][0], points[1][1] - points[0][1]};
        vector<int> v2 = {points[2][0] - points[0][0], points[2][1] - points[0][1]};
        return v1[0] * v2[1] - v1[1] * v2[0] != 0;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean isBoomerang(int[][] points) {
        int[] v1 = {points[1][0] - points[0][0], points[1][1] - points[0][1]};
        int[] v2 = {points[2][0] - points[0][0], points[2][1] - points[0][1]};
        return v1[0] * v2[1] - v1[1] * v2[0] != 0;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool IsBoomerang(int[][] points) {
        int[] v1 = {points[1][0] - points[0][0], points[1][1] - points[0][1]};
        int[] v2 = {points[2][0] - points[0][0], points[2][1] - points[0][1]};
        return v1[0] * v2[1] - v1[1] * v2[0] != 0;
    }
}
```

```C [sol1-C]
bool isBoomerang(int** points, int pointsSize, int* pointsColSize){
    int v1[2] = {points[1][0] - points[0][0], points[1][1] - points[0][1]};
    int v2[2] = {points[2][0] - points[0][0], points[2][1] - points[0][1]};
    return v1[0] * v2[1] - v1[1] * v2[0] != 0;
}
```

```go [sol1-Golang]
func isBoomerang(points [][]int) bool {
    v1 := [2]int{points[1][0] - points[0][0], points[1][1] - points[0][1]}
    v2 := [2]int{points[2][0] - points[0][0], points[2][1] - points[0][1]}
    return v1[0]*v2[1]-v1[1]*v2[0] != 0
}
```

```JavaScript [sol1-JavaScript]
var isBoomerang = function(points) {
    const v1 = [points[1][0] - points[0][0], points[1][1] - points[0][1]];
    const v2 = [points[2][0] - points[0][0], points[2][1] - points[0][1]];
    return v1[0] * v2[1] - v1[1] * v2[0] != 0;
};
```

**复杂度分析**

+ 时间复杂度：$O(1)$。

+ 空间复杂度：$O(1)$。
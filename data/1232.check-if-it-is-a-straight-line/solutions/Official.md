## [1232.缀点成线 中文官方题解](https://leetcode.cn/problems/check-if-it-is-a-straight-line/solutions/100000/zhui-dian-cheng-xian-by-leetcode-solutio-lpt6)

#### 方法一：数学

**思路**

记数组 $\textit{coordinates}$ 中的点为 $P_0, P_1, \dots, P_{n-1}$。为方便后续计算，将所有点向 $(-P_{0x}, -P_{0y})$ 方向平移。记平移后的点为 $P_0', P_1', \dots, P_{n-1}'$，其中 $P_i'=(P_{ix}-P_{0x}, P_{iy}-P_{0y})$，$P_0'$ 位于坐标系原点 $O$ 上。

由于经过两点的直线有且仅有一条，我们以 $P_0'$ 和 $P_1'$ 来确定这条直线。

因为 $P_0'$ 位于坐标系原点 $O$ 上，直线过原点，故设其方程为 $Ax+By=0$，将 $P_1'$ 坐标代入可得 $A=P_{1y}',B=-P_{1x}'$.

然后依次判断 $P_2', \dots, P_{n-1}'$ 是否在这条直线上，将其坐标代入直线方程即可。

**代码**

```cpp [sol1-C++]
class Solution {
public:
    bool checkStraightLine(vector<vector<int>> &coordinates) {
        int deltaX = coordinates[0][0], deltaY = coordinates[0][1];
        int n = coordinates.size();
        for (int i = 0; i < n; ++i) {
            coordinates[i][0] -= deltaX;
            coordinates[i][1] -= deltaY;
        }
        int A = coordinates[1][1], B = -coordinates[1][0];
        for (int i = 2; i < n; ++i) {
            int x = coordinates[i][0], y = coordinates[i][1];
            if (A * x + B * y != 0) {
                return false;
            }
        }
        return true;
    }
};
```

```Go [sol1-Golang]
func checkStraightLine(coordinates [][]int) bool {
    deltaX, deltaY := coordinates[0][0], coordinates[0][1]
    for _, p := range coordinates {
        p[0] -= deltaX
        p[1] -= deltaY
    }
    A, B := coordinates[1][1], -coordinates[1][0]
    for _, p := range coordinates[2:] {
        x, y := p[0], p[1]
        if A*x+B*y != 0 {
            return false
        }
    }
    return true
}
```

```Java [sol1-Java]
class Solution {
    public boolean checkStraightLine(int[][] coordinates) {
        int deltaX = coordinates[0][0], deltaY = coordinates[0][1];
        int n = coordinates.length;
        for (int i = 0; i < n; i++) {
            coordinates[i][0] -= deltaX;
            coordinates[i][1] -= deltaY;
        }
        int A = coordinates[1][1], B = -coordinates[1][0];
        for (int i = 2; i < n; i++) {
            int x = coordinates[i][0], y = coordinates[i][1];
            if (A * x + B * y != 0) {
                return false;
            }
        }
        return true;
    }
}
```

```JavaScript [sol1-JavaScript]
var checkStraightLine = function(coordinates) {
    const deltaX = coordinates[0][0], deltaY = coordinates[0][1];
    const n = coordinates.length;
    for (let i = 0; i < n; i++) {
        coordinates[i][0] -= deltaX;
        coordinates[i][1] -= deltaY;
    }
    const A = coordinates[1][1], B = -coordinates[1][0];
    for (let i = 2; i < n; i++) {
        const [x, y] = [coordinates[i][0], coordinates[i][1]];
        if (A * x + B * y !== 0) {
            return false;
        }
    }
    return true;
};
```

```C [sol1-C]
bool checkStraightLine(int** coordinates, int coordinatesSize, int* coordinatesColSize) {
    int deltaX = coordinates[0][0], deltaY = coordinates[0][1];
    for (int i = 0; i < coordinatesSize; ++i) {
        coordinates[i][0] -= deltaX;
        coordinates[i][1] -= deltaY;
    }
    int A = coordinates[1][1], B = -coordinates[1][0];
    for (int i = 2; i < coordinatesSize; ++i) {
        int x = coordinates[i][0], y = coordinates[i][1];
        if (A * x + B * y != 0) {
            return false;
        }
    }
    return true;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组中的元素数量。

- 时间复杂度：$O(1)$
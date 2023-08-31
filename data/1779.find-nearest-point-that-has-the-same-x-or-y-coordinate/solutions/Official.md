## [1779.找到最近的有相同 X 或 Y 坐标的点 中文官方题解](https://leetcode.cn/problems/find-nearest-point-that-has-the-same-x-or-y-coordinate/solutions/100000/zhao-dao-zui-jin-de-you-xiang-tong-x-huo-x900)

#### 方法一：枚举所有的点

**思路与算法**

我们可以枚举数组 $\textit{points}$ 中所有的点并计算出答案。

当我们枚举到点 $(\textit{px}, \textit{py})$，如果 $x=\textit{px}$，那么这两个点有相同的 $x$ 坐标，我们可以用距离 $|y - \textit{py}|$ 更新答案；如果 $y=\textit{py}$，那么这两个点有相同的 $y$ 坐标，我们可以用距离 $|x - \textit{px}|$ 更新答案。

题目要求返回下标**最小**的一个最近有效点，我们只需要按照数据枚举点，在距离严格变小时才选择更新答案即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int nearestValidPoint(int x, int y, vector<vector<int>>& points) {
        int n = points.size();
        int best = numeric_limits<int>::max(), bestid = -1;
        for (int i = 0; i < n; ++i) {
            int px = points[i][0], py = points[i][1];
            if (x == px) {
                if (int dist = abs(y - py); dist < best) {
                    best = dist;
                    bestid = i;
                }
            }
            else if (y == py) {
                if (int dist = abs(x - px); dist < best) {
                    best = dist;
                    bestid = i;
                }
            }
        }
        return bestid;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int nearestValidPoint(int x, int y, int[][] points) {
        int n = points.length;
        int best = Integer.MAX_VALUE, bestid = -1;
        for (int i = 0; i < n; ++i) {
            int px = points[i][0], py = points[i][1];
            if (x == px) {
                int dist = Math.abs(y - py);
                if (dist < best) {
                    best = dist;
                    bestid = i;
                }
            } else if (y == py) {
                int dist = Math.abs(x - px);
                if (dist < best) {
                    best = dist;
                    bestid = i;
                }
            }
        }
        return bestid;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NearestValidPoint(int x, int y, int[][] points) {
        int n = points.Length;
        int best = int.MaxValue, bestid = -1;
        for (int i = 0; i < n; ++i) {
            int px = points[i][0], py = points[i][1];
            if (x == px) {
                int dist = Math.Abs(y - py);
                if (dist < best) {
                    best = dist;
                    bestid = i;
                }
            } else if (y == py) {
                int dist = Math.Abs(x - px);
                if (dist < best) {
                    best = dist;
                    bestid = i;
                }
            }
        }
        return bestid;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def nearestValidPoint(self, x: int, y: int, points: List[List[int]]) -> int:
        n = len(points)
        best, bestid = float("inf"), -1
        for i, (px, py) in enumerate(points):
            if x == px:
                if (dist := abs(y - py)) < best:
                    best = dist
                    bestid = i
            elif y == py:
                if (dist := abs(x - px)) < best:
                    best = dist
                    bestid = i
        
        return bestid
```

```C [sol1-C]
int nearestValidPoint(int x, int y, int** points, int pointsSize, int* pointsColSize) {
    int best = INT_MAX, bestid = -1;
    for (int i = 0; i < pointsSize; ++i) {
        int px = points[i][0], py = points[i][1];
        if (x == px) {
            int dist = abs(y - py);
            if (dist < best) {
                best = dist;
                bestid = i;
            }
        }
        else if (y == py) {
            int dist = abs(x - px);
            if (dist < best) {
                best = dist;
                bestid = i;
            }
        }
    }
    return bestid;
}
```

```JavaScript [sol1-JavaScript]
var nearestValidPoint = function(x, y, points) {
    const n = points.length;
    let best = Number.MAX_VALUE, bestid = -1;
    for (let i = 0; i < n; ++i) {
        const px = points[i][0], py = points[i][1];
        if (x === px) {
            const dist = Math.abs(y - py);
            if (dist < best) {
                best = dist;
                bestid = i;
            }
        } else if (y === py) {
            const dist = Math.abs(x - px);
            if (dist < best) {
                best = dist;
                bestid = i;
            }
        }
    }
    return bestid;
};
```

```go [sol1-Golang]
func nearestValidPoint(x, y int, points [][]int) int {
    ans := -1
    minDist := math.MaxInt32
    for i, p := range points {
        if p[0] == x || p[1] == y {
            dist := abs(p[0]-x) + abs(p[1]-y)
            if dist < minDist {
                minDist = dist
                ans = i
            }
        }
    }
    return ans
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{points}$ 的长度。

- 空间复杂度：$O(1)$。
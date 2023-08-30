#### 方法一：枚举

首先遍历所有的信号塔，获得所有信号塔的 $x$ 坐标和 $y$ 坐标的最大值，分别记为 $\textit{xMax}$ 和 $\textit{yMax}$。

在计算结果坐标 $(c_x, c_y)$ 之前，首先考虑 $c_x$ 和 $c_y$ 的取值范围。

假设坐标 $(x_1, y_1)$ 满足 $x_1 > \textit{xMax}$ 或 $y_1 > \textit{yMax}$，考虑坐标 $(x_2, y_2)$，其中 $x_2 = \min(x_1, \textit{xMax})$，$y_2 = \min(y_1, \textit{yMax})$，则对于任意一个信号塔，该信号塔到坐标 $(x_2, y_2)$ 的距离一定小于等于到坐标 $(x_1, y_1)$ 的距离。由于一个信号塔在一个坐标的信号强度随着距离的增加而减少或不变，因此坐标 $(x_1, y_1)$ 处和坐标 $(x_2, y_2)$ 处的网络信号相比，一定是坐标 $(x_2, y_2)$ 处的网络信号更好或者两个坐标处的网络信号相同。由于题目要求返回字典序最小的网络信号最好的坐标，坐标 $(x_2, y_2)$ 的字典序一定小于坐标 $(x_1, y_1)$，因此坐标 $(x_1, y_1)$ 不可能是结果坐标。结果坐标一定满足 $c_x \le \textit{xMax}$ 且 $c_y \le \textit{yMax}$。

假设坐标 $(x_3, y_3)$ 满足 $x_3 < 0$ 或 $y_3 < 0$，考虑坐标 $(x_4, y_4)$，其中 $x_4 = \max(x_3, 0)$，$y_4 = \max(y_3, 0)$，则对于任意一个信号塔，由于信号塔的坐标非负，因此该信号塔到坐标 $(x_4, y_4)$ 的距离一定小于等于到坐标 $(x_3, y_3)$ 的距离。由于一个信号塔在一个坐标的信号强度随着距离的增加而减少或不变，因此坐标 $(x_3, y_3)$ 处和坐标 $(x_4, y_4)$ 处的网络信号相比，一定是坐标 $(x_4, y_4)$ 处的网络信号更好或者两个坐标处的网络信号相同。

根据题目要求，如果有多个网络信号最好的坐标，则返回网络信号最好的**非负**坐标，此时 $c_x \ge 0$ 且 $c_y \ge 0$。如果只有一个网络信号最好的坐标，则根据上述分析可知，同样有 $c_x \ge 0$ 且 $c_y \ge 0$。

因此结果坐标 $(c_x, c_y)$ 满足 $0 \le c_x \le \textit{xMax}$ 且 $0 \le c_y \le \textit{yMax}$，只需要在 $0 \le x \le \textit{xMax}$ 且 $0 \le y \le \textit{yMax}$ 的范围中遍历每一个坐标，计算该坐标处接收到的所有网络信号塔的信号强度之和，即该坐标的网络信号。遍历全部坐标之后，即可得到网络信号最好的坐标。

为了确保结果坐标是字典序最小的网络信号最好的坐标，遍历时应分别将 $x$ 和 $y$ 从小到大遍历，只有当一个坐标的网络信号严格大于最好信号时才更新结果坐标。

特别地，当一个网络信号塔与当前坐标的距离大于阈值 $\textit{radius}$ 时，该网络信号塔的信号不能到达当前信号，只有当距离不超过阈值 $\textit{radius}$ 时才计算信号强度。

```Python [sol1-Python3]
class Solution:
    def bestCoordinate(self, towers: List[List[int]], radius: int) -> List[int]:
        x_max = max(t[0] for t in towers)
        y_max = max(t[1] for t in towers)
        cx = cy = max_quality = 0
        for x in range(x_max + 1):
            for y in range(y_max + 1):
                quality = 0
                for tx, ty, q in towers:
                    d = (x - tx) ** 2 + (y - ty) ** 2
                    if d <= radius ** 2:
                        quality += int(q / (1 + d ** 0.5))
                if quality > max_quality:
                    cx, cy, max_quality = x, y, quality
        return [cx, cy]
```

```Java [sol1-Java]
class Solution {
    public int[] bestCoordinate(int[][] towers, int radius) {
        int xMax = Integer.MIN_VALUE, yMax = Integer.MIN_VALUE;
        for (int[] tower : towers) {
            int x = tower[0], y = tower[1];
            xMax = Math.max(xMax, x);
            yMax = Math.max(yMax, y);
        }
        int cx = 0, cy = 0;
        int maxQuality = 0;
        for (int x = 0; x <= xMax; x++) {
            for (int y = 0; y <= yMax; y++) {
                int[] coordinate = {x, y};
                int quality = 0;
                for (int[] tower : towers) {
                    int squaredDistance = getSquaredDistance(coordinate, tower);
                    if (squaredDistance <= radius * radius) {
                        double distance = Math.sqrt(squaredDistance);
                        quality += (int) Math.floor(tower[2] / (1 + distance));
                    }
                }
                if (quality > maxQuality) {
                    cx = x;
                    cy = y;
                    maxQuality = quality;
                }
            }
        }
        return new int[]{cx, cy};
    }

    public int getSquaredDistance(int[] coordinate, int[] tower) {
        return (tower[0] - coordinate[0]) * (tower[0] - coordinate[0]) + (tower[1] - coordinate[1]) * (tower[1] - coordinate[1]);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] BestCoordinate(int[][] towers, int radius) {
        int xMax = int.MinValue, yMax = int.MinValue;
        foreach (int[] tower in towers) {
            int x = tower[0], y = tower[1];
            xMax = Math.Max(xMax, x);
            yMax = Math.Max(yMax, y);
        }
        int cx = 0, cy = 0;
        int maxQuality = 0;
        for (int x = 0; x <= xMax; x++) {
            for (int y = 0; y <= yMax; y++) {
                int[] coordinate = {x, y};
                int quality = 0;
                foreach (int[] tower in towers) {
                    int squaredDistance = GetSquaredDistance(coordinate, tower);
                    if (squaredDistance <= radius * radius) {
                        double distance = Math.Sqrt(squaredDistance);
                        quality += (int) Math.Floor(tower[2] / (1 + distance));
                    }
                }
                if (quality > maxQuality) {
                    cx = x;
                    cy = y;
                    maxQuality = quality;
                }
            }
        }
        return new int[]{cx, cy};
    }

    public int GetSquaredDistance(int[] coordinate, int[] tower) {
        return (tower[0] - coordinate[0]) * (tower[0] - coordinate[0]) + (tower[1] - coordinate[1]) * (tower[1] - coordinate[1]);
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> bestCoordinate(vector<vector<int>>& towers, int radius) {
        int xMax = INT_MIN, yMax = INT_MIN;
        for (auto &&tower : towers) {
            int x = tower[0], y = tower[1];
            xMax = max(xMax, x);
            yMax = max(yMax, y);
        }
        int cx = 0, cy = 0;
        int maxQuality = 0;
        for (int x = 0; x <= xMax; x++) {
            for (int y = 0; y <= yMax; y++) {
                vector<int> coordinate = {x, y};
                int quality = 0;
                for (auto &&tower : towers) {
                    int squaredDistance = getSquaredDistance(coordinate, tower);
                    if (squaredDistance <= radius * radius) {
                        double distance = sqrt((double)squaredDistance);
                        quality += floor((double)tower[2] / (1 + distance));
                    }
                }
                if (quality > maxQuality) {
                    cx = x;
                    cy = y;
                    maxQuality = quality;
                }
            }
        }
        return {cx, cy};
    }

    int getSquaredDistance(const vector<int> &coordinate, const vector<int> &tower) {
        return (tower[0] - coordinate[0]) * (tower[0] - coordinate[0]) + (tower[1] - coordinate[1]) * (tower[1] - coordinate[1]);
    }
};
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int getSquaredDistance(const int *coordinate, const int *tower) {
    return (tower[0] - coordinate[0]) * (tower[0] - coordinate[0]) + \
           (tower[1] - coordinate[1]) * (tower[1] - coordinate[1]);
}

int* bestCoordinate(int** towers, int towersSize, int* towersColSize, int radius, int* returnSize) {
    int xMax = INT_MIN, yMax = INT_MIN;
    for (int i = 0; i < towersSize; i++) {
        int x = towers[i][0], y = towers[i][1];
        xMax = MAX(xMax, x);
        yMax = MAX(yMax, y);
    }
    int cx = 0, cy = 0;
    int maxQuality = 0;
    for (int x = 0; x <= xMax; x++) {
        for (int y = 0; y <= yMax; y++) {
            int coordinate[2] = {x, y};
            int quality = 0;
            for (int i = 0; i < towersSize; i++) {
                int squaredDistance = getSquaredDistance(coordinate, towers[i]);
                if (squaredDistance <= radius * radius) {
                    double distance = sqrt((double)squaredDistance);
                    quality += floor((double)towers[i][2] / (1 + distance));
                }
            }
            if (quality > maxQuality) {
                cx = x;
                cy = y;
                maxQuality = quality;
            }
        }
    }
    int *ans = (int *)malloc(sizeof(int) * 2);
    ans[0] = cx, ans[1] = cy;
    *returnSize = 2;
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var bestCoordinate = function(towers, radius) {
    let xMax = Number.MIN_VALUE, yMax = -Number.MAX_VALUE;
    for (const tower of towers) {
        let x = tower[0], y = tower[1];
        xMax = Math.max(xMax, x);
        yMax = Math.max(yMax, y);
    }
    let cx = 0, cy = 0;
    let maxQuality = 0;
    for (let x = 0; x <= xMax; x++) {
        for (let y = 0; y <= yMax; y++) {
            const coordinate = [x, y];
            let quality = 0;
            for (const tower of towers) {
                const squaredDistance = getSquaredDistance(coordinate, tower);
                if (squaredDistance <= radius * radius) {
                    const distance = Math.sqrt(squaredDistance);
                    quality += Math.floor(tower[2] / (1 + distance));
                }
            }
            if (quality > maxQuality) {
                cx = x;
                cy = y;
                maxQuality = quality;
            }
        }
    }
    return [cx, cy];
}

const getSquaredDistance = (coordinate, tower) => {
    return (tower[0] - coordinate[0]) * (tower[0] - coordinate[0]) + (tower[1] - coordinate[1]) * (tower[1] - coordinate[1]);
};
```

```go [sol1-Golang]
func bestCoordinate(towers [][]int, radius int) []int {
    var xMax, yMax, cx, cy, maxQuality int
    for _, t := range towers {
        xMax = max(xMax, t[0])
        yMax = max(yMax, t[1])
    }
    for x := 0; x <= xMax; x++ {
        for y := 0; y <= yMax; y++ {
            quality := 0
            for _, t := range towers {
                d := (x-t[0])*(x-t[0]) + (y-t[1])*(y-t[1])
                if d <= radius*radius {
                    quality += int(float64(t[2]) / (1 + math.Sqrt(float64(d))))
                }
            }
            if quality > maxQuality {
                cx, cy, maxQuality = x, y, quality
            }
        }
    }
    return []int{cx, cy}
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(R_x \times R_y \times n)$，其中 $R_x$ 和 $R_y$ 分别是网络信号塔的 $x$ 坐标和 $y$ 坐标的最大值，$n$ 是网络信号塔的数量。
  这道题中，每个网络信号塔的 $x$ 坐标和 $y$ 坐标的取值范围都是从 $0$ 到 $50$，因此 $R_x$ 和 $R_y$ 都不超过 $50$。
  时间复杂度主要取决于遍历范围内的所有坐标。需要遍历 $R_x \times R_y$ 个坐标，对于每个坐标，计算该坐标的网络信号需要遍历所有的网络信号塔，时间复杂度是 $O(n)$。
  因此时间复杂度是 $O(R_x \times R_y \times n)$。

- 空间复杂度：$O(1)$。只需要使用常量的额外空间。
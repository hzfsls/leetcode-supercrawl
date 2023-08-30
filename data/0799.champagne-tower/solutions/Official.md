#### 方法一：模拟

**思路**

可以模拟倒香槟过程。首先将所有的 $\textit{poured}$ 杯香槟全部倒到 $\textit{row} = 0$ 的这个杯子中。当有溢出时，再将溢出的部分平均倒到下一层的相邻的两个杯子中。而除了 $\textit{row} = 0$ 的这个杯子中的香槟是直接来自于外部，其他杯子中的香槟均来自于它的上一层的相邻的一个或两个杯子中溢出的香槟。根据这个思路，可以求出每一层的每一只杯子中的香槟体积。求出 $\textit{row} = \textit{query\_row}$ 的杯子的香槟体积后，取第 $\textit{query\_glass}$ 个杯子中的体积，并与 $1$ 求最小值返回。

**代码**

```Python [sol1-Python3]
class Solution:
    def champagneTower(self, poured: int, query_row: int, query_glass: int) -> float:
        row = [poured]
        for i in range(1, query_row + 1):
            nextRow = [0] * (i + 1)
            for j, volume in enumerate(row):
                if volume > 1:
                    nextRow[j] += (volume - 1) / 2
                    nextRow[j + 1] += (volume - 1) / 2
            row = nextRow
        return min(1, row[query_glass])
```

```Java [sol1-Java]
class Solution {
    public double champagneTower(int poured, int query_row, int query_glass) {
        double[] row = {poured};
        for (int i = 1; i <= query_row; i++) {
            double[] nextRow = new double[i + 1];
            for (int j = 0; j < i; j++) {
                double volume = row[j];
                if (volume > 1) {
                    nextRow[j] += (volume - 1) / 2;
                    nextRow[j + 1] += (volume - 1) / 2;
                }
            }
            row = nextRow;
        }
        return Math.min(1, row[query_glass]);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public double ChampagneTower(int poured, int query_row, int query_glass) {
        double[] row = {poured};
        for (int i = 1; i <= query_row; i++) {
            double[] nextRow = new double[i + 1];
            for (int j = 0; j < i; j++) {
                double volume = row[j];
                if (volume > 1) {
                    nextRow[j] += (volume - 1) / 2;
                    nextRow[j + 1] += (volume - 1) / 2;
                }
            }
            row = nextRow;
        }
        return Math.Min(1, row[query_glass]);
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    double champagneTower(int poured, int query_row, int query_glass) {
        vector<double> row = {(double)poured};
        for (int i = 1; i <= query_row; i++) {
            vector<double> nextRow(i + 1, 0.0);
            for (int j = 0; j < row.size(); j++) {
                double volume = row[j];
                if (volume > 1) {
                    nextRow[j] += (volume - 1) / 2;
                    nextRow[j + 1] += (volume - 1) / 2;
                }
            }
            row = nextRow;
        }            
        return min(1.0, row[query_glass]);
    }
};
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

double champagneTower(int poured, int query_row, int query_glass) {
    double row[query_row + 2];
    int rowSize = 1;
    row[0] = poured;
    for (int i = 1; i <= query_row; i++) {
        double nextRow[i + 1];
        for (int j = 0; j <= i; j++) {
            nextRow[j] = 0.0;
        }
        for (int j = 0; j < rowSize; j++) {
            double volume = row[j];
            if (volume > 1) {
                nextRow[j] += (volume - 1) / 2;
                nextRow[j + 1] += (volume - 1) / 2;
            }
        }
        memcpy(row, nextRow, sizeof(double) * (i + 1));
        rowSize = i + 1;
    }            
    return MIN(1.0, row[query_glass]);
}
```

```JavaScript [sol1-JavaScript]
var champagneTower = function(poured, query_row, query_glass) {
    let row = [poured];
    for (let i = 1; i <= query_row; i++) {
        const nextRow = new Array(i + 1).fill(0);
        for (let j = 0; j < i; j++) {
            const volume = row[j];
            if (volume > 1) {
                nextRow[j] += (volume - 1) / 2;
                nextRow[j + 1] += (volume - 1) / 2;
            }
        }
        row = nextRow;
    }
    return Math.min(1, row[query_glass]);
};
```

```go [sol1-Golang]
func champagneTower(poured, queryRow, queryGlass int) float64 {
    row := []float64{float64(poured)}
    for i := 1; i <= queryRow; i++ {
        nextRow := make([]float64, i+1)
        for j, volume := range row {
            if volume > 1 {
                nextRow[j] += (volume - 1) / 2
                nextRow[j+1] += (volume - 1) / 2
            }
        }
        row = nextRow
    }
    return math.Min(1, row[queryGlass])
}
```

**复杂度分析**

- 时间复杂度：$O(query\_row^2)$。使用了两层 $\texttt{for}$ 循环。

- 空间复杂度：$O(query\_row)$。使用滚动数组实现的空间复杂度是 $O(query\_row)$。